import numpy as np
import pyrtl
import pytest

from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ip_cores.stateful_softmax import StatefulSoftmaxCore
from tests.ref_models.softmax_ref import softmax_ref


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
        ready_in = pyrtl.Input(bitwidth=1, name="wrapper_ready_in")

        data_out = pyrtl.Output(
            bitwidth=core.data_out.bitwidth, name="wrapper_data_out"
        )
        valid_out = pyrtl.Output(bitwidth=1, name="wrapper_valid_out")
        ready_out = pyrtl.Output(bitwidth=1, name="wrapper_ready_out")

        core.data_in <<= data_in
        core.valid_in <<= valid_in
        core.ready_in <<= ready_in
        data_out <<= core.data_out
        valid_out <<= core.valid_out
        ready_out <<= core.ready_out

    sim = pyrtl.Simulation(tracer=None, block=core.block)
    return sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out


class TestStatefulSoftmaxCore:
    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize("T_seq", [1, 2, 4])
    def test_single_token(self, T_seq: int) -> None:
        num_beats = 4
        N_seq = num_beats * T_seq
        core = StatefulSoftmaxCore(N_seq=N_seq, T_seq=T_seq, name="ssm")
        sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out = _create_wrapped_sim(core)

        np.random.seed(42)
        beats = [
            np.random.randint(-128, 128, size=T_seq, dtype=np.int8)
            for _ in range(num_beats)
        ]
        flat = np.concatenate(beats)
        expected = softmax_ref(flat)

        outputs = []
        beat_idx = 0
        max_cycles = num_beats * 10
        for _ in range(max_cycles):
            sim.step({
                data_in: _pack_bytes(beats[beat_idx]),
                valid_in: 1,
                ready_in: 1,
            })
            if sim.inspect(valid_out.name):
                out_val = sim.inspect(data_out.name)
                outputs.append(_unpack_bytes(out_val, T_seq))
            if sim.inspect(ready_out.name):
                beat_idx += 1
                if beat_idx == num_beats:
                    break

        for _ in range(num_beats * 3):
            sim.step({
                data_in: 0,
                valid_in: 0,
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
        sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out = _create_wrapped_sim(core)

        beats = [np.zeros(T_seq, dtype=np.int8) for _ in range(num_beats)]
        flat = np.concatenate(beats)
        expected = softmax_ref(flat)

        outputs = []
        beat_idx = 0
        max_cycles = num_beats * 10
        for _ in range(max_cycles):
            sim.step({
                data_in: _pack_bytes(beats[beat_idx]),
                valid_in: 1,
                ready_in: 1,
            })
            if sim.inspect(valid_out.name):
                out_val = sim.inspect(data_out.name)
                outputs.append(_unpack_bytes(out_val, T_seq))
            if sim.inspect(ready_out.name):
                beat_idx += 1
                if beat_idx == num_beats:
                    break

        for _ in range(num_beats * 3):
            sim.step({
                data_in: 0,
                valid_in: 0,
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
    def test_ii1_back_to_back(self, T_seq: int) -> None:
        num_beats = 4
        N_seq = num_beats * T_seq
        core = StatefulSoftmaxCore(N_seq=N_seq, T_seq=T_seq, name="ssm")
        sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out = _create_wrapped_sim(core)

        np.random.seed(123)
        num_tokens = 5
        tokens = [
            [
                np.random.randint(-128, 128, size=T_seq, dtype=np.int8)
                for _ in range(num_beats)
            ]
            for _ in range(num_tokens)
        ]
        expected = [softmax_ref(np.concatenate(t)) for t in tokens]

        outputs_per_token: list[list[np.ndarray]] = [[] for _ in range(num_tokens)]
        token_beats_sent = 0
        current_token = 0
        max_cycles = num_beats * num_tokens * 4

        for cycle in range(max_cycles):
            if current_token < num_tokens and sim.inspect(ready_out.name):
                beat = tokens[current_token][token_beats_sent]
                sim.step({
                    data_in: _pack_bytes(beat),
                    valid_in: 1,
                    ready_in: 1,
                })
                if token_beats_sent == num_beats - 1:
                    current_token += 1
                    token_beats_sent = 0
                else:
                    token_beats_sent += 1
            else:
                sim.step({
                    data_in: 0,
                    valid_in: 0,
                    ready_in: 1,
                })

            if sim.inspect(valid_out.name):
                out_val = sim.inspect(data_out.name)
                total_outputs = sum(len(o) for o in outputs_per_token)
                token_idx = total_outputs // num_beats
                if token_idx < num_tokens:
                    outputs_per_token[token_idx].append(
                        _unpack_bytes(out_val, T_seq)
                    )

            total_outputs = sum(len(o) for o in outputs_per_token)
            if total_outputs >= num_tokens * num_beats:
                break

        for i in range(num_tokens):
            result = np.concatenate(outputs_per_token[i])
            np.testing.assert_allclose(
                result.astype(np.int16),
                expected[i].astype(np.int16),
                atol=1,
            )

    @pytest.mark.parametrize("T_seq", [1, 2, 4])
    def test_backpressure(self, T_seq: int) -> None:
        num_beats = 4
        N_seq = num_beats * T_seq
        core = StatefulSoftmaxCore(N_seq=N_seq, T_seq=T_seq, name="ssm")
        sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out = _create_wrapped_sim(core)

        np.random.seed(7)
        beats = [
            np.random.randint(-128, 128, size=T_seq, dtype=np.int8)
            for _ in range(num_beats)
        ]
        flat = np.concatenate(beats)
        expected = softmax_ref(flat)

        outputs = []
        beat_idx = 0
        stall_active = False
        stall_count = 0
        max_cycles = num_beats * 10

        for _ in range(max_cycles):
            if sim.inspect(valid_out.name) and not stall_active:
                if len(outputs) == 1:
                    stall_active = True
                    stall_count = 0

            if stall_active and stall_count < 2:
                ready = 0
                stall_count += 1
            else:
                stall_active = False
                ready = 1

            sim.step({
                data_in: _pack_bytes(beats[beat_idx]),
                valid_in: 1,
                ready_in: ready,
            })

            if sim.inspect(valid_out.name):
                out_val = sim.inspect(data_out.name)
                outputs.append(_unpack_bytes(out_val, T_seq))

            if sim.inspect(ready_out.name):
                beat_idx += 1
                if beat_idx == num_beats:
                    break

        for _ in range(num_beats * 3):
            sim.step({
                data_in: 0,
                valid_in: 0,
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

    def test_invalid_n_seq_raises(self) -> None:
        with pytest.raises(ValueError):
            StatefulSoftmaxCore(N_seq=0, T_seq=4, name="bad")

    def test_invalid_t_seq_raises(self) -> None:
        with pytest.raises(ValueError):
            StatefulSoftmaxCore(N_seq=16, T_seq=0, name="bad")
