import numpy as np
import pyrtl
import pytest

from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ip_cores.stateful_softmax import StatefulSoftmaxCore
from ref_models.softmax_ref import softmax_ref


def _pack_bytes(values: np.ndarray) -> int:
    result = 0
    for i, v in enumerate(values):
        result |= (int(v) & 0xFF) << (i * 8)
    return result


def _unpack_bytes(value: int, T_seq: int) -> np.ndarray:
    return np.array(
        [np.int8((value >> (i * 8)) & 0xFF) for i in range(T_seq)],
        dtype=np.int8,
    )


def _create_wrapped_sim(core: StatefulSoftmaxCore):
    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        data_in = pyrtl.Input(bitwidth=core.data_in.bitwidth, name="wrapper_data_in")
        valid_in = pyrtl.Input(bitwidth=1, name="wrapper_valid_in")
        last_in = pyrtl.Input(bitwidth=1, name="wrapper_last_in")
        ready_in = pyrtl.Input(bitwidth=1, name="wrapper_ready_in")

        data_out = pyrtl.Output(
            bitwidth=core.data_out.bitwidth, name="wrapper_data_out"
        )
        valid_out = pyrtl.Output(bitwidth=1, name="wrapper_valid_out")
        last_out = pyrtl.Output(bitwidth=1, name="wrapper_last_out")
        ready_out = pyrtl.Output(bitwidth=1, name="wrapper_ready_out")

        core.data_in <<= data_in
        core.valid_in <<= valid_in
        core.last_in <<= last_in
        core.ready_in <<= ready_in
        data_out <<= core.data_out
        valid_out <<= core.valid_out
        last_out <<= core.last_out
        ready_out <<= core.ready_out

    sim = pyrtl.Simulation(tracer=None, block=core.block)
    return sim, data_in, valid_in, last_in, ready_in, data_out, valid_out, last_out, ready_out


class TestStatefulSoftmaxCore:
    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize("T_seq", [1, 2, 4])
    def test_16_beat_row_three_passes(self, T_seq: int) -> None:
        num_beats = 16
        N_seq = num_beats * T_seq
        core = StatefulSoftmaxCore(N_seq=N_seq, T_seq=T_seq, name="ssm")
        sim, data_in, valid_in, last_in, ready_in, data_out, valid_out, last_out, ready_out = _create_wrapped_sim(core)

        np.random.seed(42)
        beats = [
            np.random.randint(-128, 128, size=T_seq, dtype=np.int8)
            for _ in range(num_beats)
        ]
        flat = np.concatenate(beats)
        expected = softmax_ref(flat)

        outputs = []
        for pass_idx in range(3):
            for beat_idx in range(num_beats):
                is_last = 1 if beat_idx == num_beats - 1 else 0
                sim.step({
                    data_in: _pack_bytes(beats[beat_idx]),
                    valid_in: 1,
                    last_in: is_last,
                    ready_in: 1,
                })
                if sim.inspect(valid_out.name):
                    out_val = sim.inspect(data_out.name)
                    outputs.append(_unpack_bytes(out_val, T_seq))

        result = np.concatenate(outputs)
        np.testing.assert_allclose(
            result.astype(np.int16),
            expected.astype(np.int16),
            atol=1,
        )

    @pytest.mark.parametrize("T_seq", [1, 2, 4])
    def test_all_zeros(self, T_seq: int) -> None:
        num_beats = 4
        N_seq = num_beats * T_seq
        core = StatefulSoftmaxCore(N_seq=N_seq, T_seq=T_seq, name="ssm")
        sim, data_in, valid_in, last_in, ready_in, data_out, valid_out, last_out, ready_out = _create_wrapped_sim(core)

        beats = [np.zeros(T_seq, dtype=np.int8) for _ in range(num_beats)]
        flat = np.concatenate(beats)
        expected = softmax_ref(flat)

        outputs = []
        for pass_idx in range(3):
            for beat_idx in range(num_beats):
                is_last = 1 if beat_idx == num_beats - 1 else 0
                sim.step({
                    data_in: _pack_bytes(beats[beat_idx]),
                    valid_in: 1,
                    last_in: is_last,
                    ready_in: 1,
                })
                if sim.inspect(valid_out.name):
                    out_val = sim.inspect(data_out.name)
                    outputs.append(_unpack_bytes(out_val, T_seq))

        result = np.concatenate(outputs)
        np.testing.assert_allclose(
            result.astype(np.int16),
            expected.astype(np.int16),
            atol=1,
        )

    @pytest.mark.parametrize("T_seq", [1, 2, 4])
    def test_backpressure_in_divide(self, T_seq: int) -> None:
        num_beats = 4
        N_seq = num_beats * T_seq
        core = StatefulSoftmaxCore(N_seq=N_seq, T_seq=T_seq, name="ssm")
        sim, data_in, valid_in, last_in, ready_in, data_out, valid_out, last_out, ready_out = _create_wrapped_sim(core)

        np.random.seed(7)
        beats = [
            np.random.randint(-128, 128, size=T_seq, dtype=np.int8)
            for _ in range(num_beats)
        ]
        flat = np.concatenate(beats)
        expected = softmax_ref(flat)

        outputs = []
        beat_idx = 0
        pass_idx = 0
        stall_count = 0
        while pass_idx < 3:
            is_last = 1 if beat_idx == num_beats - 1 else 0
            should_stall = pass_idx == 2 and beat_idx == 1 and stall_count < 2
            ready = 0 if should_stall else 1
            sim.step({
                data_in: _pack_bytes(beats[beat_idx]),
                valid_in: 1,
                last_in: is_last,
                ready_in: ready,
            })
            if sim.inspect(valid_out.name) and sim.inspect(ready_out.name):
                out_val = sim.inspect(data_out.name)
                outputs.append(_unpack_bytes(out_val, T_seq))
            if sim.inspect(ready_out.name):
                beat_idx += 1
                stall_count = 0
                if beat_idx == num_beats:
                    beat_idx = 0
                    pass_idx += 1
            else:
                stall_count += 1

        result = np.concatenate(outputs)
        np.testing.assert_allclose(
            result.astype(np.int16),
            expected.astype(np.int16),
            atol=1,
        )

    def test_invalid_n_seq_raises(self) -> None:
        with pytest.raises(ValueError):
            StatefulSoftmaxCore(N_seq=0, T_seq=4, name="bad")

    def test_invalid_t_seq_raises(self) -> None:
        with pytest.raises(ValueError):
            StatefulSoftmaxCore(N_seq=16, T_seq=0, name="bad")
