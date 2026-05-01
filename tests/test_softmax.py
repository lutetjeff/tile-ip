import numpy as np
import pyrtl
import pytest

from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ip_cores.softmax import SoftmaxCore
from tests.ref_models.softmax_ref import softmax_ref


def _pack_bytes(values: np.ndarray) -> int:
    result = 0
    for i, v in enumerate(values):
        result |= (int(v) & 0xFF) << (i * 8)
    return result


def _unpack_bytes(value: int, T_seq: int) -> np.ndarray:
    return np.array(
        [np.int8(np.uint8((value >> (i * 8)) & 0xFF)) for i in range(T_seq)],
        dtype=np.int8,
    )


def _create_wrapped_sim(core: SoftmaxCore):
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


class TestSoftmaxCore:
    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize("T_seq", [1, 2, 4, 8, 16])
    def test_random_continuous_stream(self, T_seq: int) -> None:
        core = SoftmaxCore(T_seq=T_seq, name="sm")
        sim, data_in, valid_in, ready_in, data_out, _, _ = _create_wrapped_sim(core)

        np.random.seed(42)
        inputs = [
            np.random.randint(-128, 128, size=T_seq, dtype=np.int8) for _ in range(10)
        ]

        for beat in inputs:
            packed = _pack_bytes(beat)
            sim.step({data_in: packed, valid_in: 1, ready_in: 1})
            out_val = sim.inspect(data_out.name)
            out_bytes = _unpack_bytes(out_val, T_seq)
            expected = softmax_ref(beat)
            np.testing.assert_allclose(
                out_bytes.astype(np.int16),
                expected.astype(np.int16),
                atol=1,
            )

    @pytest.mark.parametrize("T_seq", [1, 2, 4, 8, 16])
    def test_all_zeros(self, T_seq: int) -> None:
        core = SoftmaxCore(T_seq=T_seq, name="sm")
        sim, data_in, valid_in, ready_in, data_out, _, _ = _create_wrapped_sim(core)
        beat = np.zeros(T_seq, dtype=np.int8)
        packed = _pack_bytes(beat)
        sim.step({data_in: packed, valid_in: 1, ready_in: 1})
        out_bytes = _unpack_bytes(sim.inspect(data_out.name), T_seq)
        expected = softmax_ref(beat)
        np.testing.assert_allclose(
            out_bytes.astype(np.int16),
            expected.astype(np.int16),
            atol=1,
        )

    @pytest.mark.parametrize("T_seq", [1, 2, 4, 8, 16])
    def test_all_same_positive(self, T_seq: int) -> None:
        core = SoftmaxCore(T_seq=T_seq, name="sm")
        sim, data_in, valid_in, ready_in, data_out, _, _ = _create_wrapped_sim(core)
        beat = np.full(T_seq, 127, dtype=np.int8)
        packed = _pack_bytes(beat)
        sim.step({data_in: packed, valid_in: 1, ready_in: 1})
        out_bytes = _unpack_bytes(sim.inspect(data_out.name), T_seq)
        expected = softmax_ref(beat)
        np.testing.assert_allclose(
            out_bytes.astype(np.int16),
            expected.astype(np.int16),
            atol=1,
        )

    @pytest.mark.parametrize("T_seq", [1, 2, 4, 8, 16])
    def test_all_same_negative(self, T_seq: int) -> None:
        core = SoftmaxCore(T_seq=T_seq, name="sm")
        sim, data_in, valid_in, ready_in, data_out, _, _ = _create_wrapped_sim(core)
        beat = np.full(T_seq, -128, dtype=np.int8)
        packed = _pack_bytes(beat)
        sim.step({data_in: packed, valid_in: 1, ready_in: 1})
        out_bytes = _unpack_bytes(sim.inspect(data_out.name), T_seq)
        expected = softmax_ref(beat)
        np.testing.assert_allclose(
            out_bytes.astype(np.int16),
            expected.astype(np.int16),
            atol=1,
        )

    @pytest.mark.parametrize("T_seq", [1, 2, 4, 8, 16])
    def test_one_dominant(self, T_seq: int) -> None:
        core = SoftmaxCore(T_seq=T_seq, name="sm")
        sim, data_in, valid_in, ready_in, data_out, _, _ = _create_wrapped_sim(core)
        beat = np.full(T_seq, -128, dtype=np.int8)
        if T_seq > 1:
            beat[0] = 127
        packed = _pack_bytes(beat)
        sim.step({data_in: packed, valid_in: 1, ready_in: 1})
        out_bytes = _unpack_bytes(sim.inspect(data_out.name), T_seq)
        expected = softmax_ref(beat)
        np.testing.assert_allclose(
            out_bytes.astype(np.int16),
            expected.astype(np.int16),
            atol=1,
        )

    @pytest.mark.parametrize("T_seq", [1, 2, 4, 8, 16])
    def test_alternating(self, T_seq: int) -> None:
        core = SoftmaxCore(T_seq=T_seq, name="sm")
        sim, data_in, valid_in, ready_in, data_out, _, _ = _create_wrapped_sim(core)
        beat = np.array(
            [127 if i % 2 == 0 else -128 for i in range(T_seq)],
            dtype=np.int8,
        )
        packed = _pack_bytes(beat)
        sim.step({data_in: packed, valid_in: 1, ready_in: 1})
        out_bytes = _unpack_bytes(sim.inspect(data_out.name), T_seq)
        expected = softmax_ref(beat)
        np.testing.assert_allclose(
            out_bytes.astype(np.int16),
            expected.astype(np.int16),
            atol=1,
        )

    def test_invalid_tiling_param_raises(self) -> None:
        with pytest.raises(ValueError):
            SoftmaxCore(T_seq=0, name="bad")
