import numpy as np
import pyrtl
import pytest

from ip_cores.alu import ALUCore
from ip_cores.axi_stream_base import AXI4StreamLiteBase
from tests.ref_models.alu_ref import alu_ref, OP_ADD


def _pack_bytes(values: np.ndarray) -> int:
    result = 0
    for i, v in enumerate(values):
        result |= (int(v) & 0xFF) << (i * 8)
    return result


def _unpack_bytes(value: int, T_width: int) -> np.ndarray:
    return np.array(
        [((value >> (i * 8)) & 0xFF) for i in range(T_width)],
        dtype=np.uint8,
    ).astype(np.int8)


def _create_wrapped_sim(core: ALUCore):
    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        data_in = pyrtl.Input(bitwidth=core.data_in.bitwidth, name="wrapper_data_in")
        data_in_b = pyrtl.Input(
            bitwidth=core.data_in_b.bitwidth, name="wrapper_data_in_b"
        )
        valid_in = pyrtl.Input(bitwidth=1, name="wrapper_valid_in")
        ready_in = pyrtl.Input(bitwidth=1, name="wrapper_ready_in")

        data_out = pyrtl.Output(
            bitwidth=core.data_out.bitwidth, name="wrapper_data_out"
        )
        valid_out = pyrtl.Output(bitwidth=1, name="wrapper_valid_out")
        ready_out = pyrtl.Output(bitwidth=1, name="wrapper_ready_out")

        core.data_in <<= data_in
        core.data_in_b <<= data_in_b
        core.valid_in <<= valid_in
        core.ready_in <<= ready_in
        data_out <<= core.data_out
        valid_out <<= core.valid_out
        ready_out <<= core.ready_out

    sim = pyrtl.Simulation(tracer=None, block=core.block)
    return sim, data_in, data_in_b, valid_in, ready_in, data_out


class TestALUCore:
    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize("T_width", [1, 2, 4, 8, 16])
    def test_continuous_stream(self, T_width: int) -> None:
        core = ALUCore(T_width=T_width, name="alu")
        sim, data_in, data_in_b, valid_in, ready_in, data_out = (
            _create_wrapped_sim(core)
        )

        inputs_a = [
            np.random.randint(-128, 128, size=T_width, dtype=np.int8) for _ in range(10)
        ]
        inputs_b = [
            np.random.randint(-128, 128, size=T_width, dtype=np.int8) for _ in range(10)
        ]

        outputs = []
        for a, b in zip(inputs_a, inputs_b):
            sim.step(
                {
                    data_in: _pack_bytes(a),
                    data_in_b: _pack_bytes(b),
                    valid_in: 1,
                    ready_in: 1,
                }
            )
            outputs.append(sim.inspect(data_out.name))

        sim.step(
            {
                data_in: _pack_bytes(inputs_a[-1]),
                data_in_b: _pack_bytes(inputs_b[-1]),
                valid_in: 1,
                ready_in: 1,
            }
        )
        outputs.append(sim.inspect(data_out.name))

        for i in range(10):
            out_bytes = _unpack_bytes(outputs[i + 1], T_width)
            expected = alu_ref(inputs_a[i], inputs_b[i], OP_ADD)
            np.testing.assert_array_equal(out_bytes, expected)

    @pytest.mark.parametrize("T_width", [1, 2, 4, 8, 16])
    def test_all_zeros(self, T_width: int) -> None:
        core = ALUCore(T_width=T_width, name="alu")
        sim, data_in, data_in_b, valid_in, ready_in, data_out = (
            _create_wrapped_sim(core)
        )

        a = np.zeros(T_width, dtype=np.int8)
        b = np.zeros(T_width, dtype=np.int8)
        packed_a = _pack_bytes(a)
        packed_b = _pack_bytes(b)
        for _ in range(2):
            sim.step(
                {
                    data_in: packed_a,
                    data_in_b: packed_b,
                    valid_in: 1,
                    ready_in: 1,
                }
            )
        out_bytes = _unpack_bytes(sim.inspect(data_out.name), T_width)
        np.testing.assert_array_equal(out_bytes, alu_ref(a, b, OP_ADD))

    @pytest.mark.parametrize("T_width", [1, 2, 4, 8, 16])
    def test_all_positive_max(self, T_width: int) -> None:
        core = ALUCore(T_width=T_width, name="alu")
        sim, data_in, data_in_b, valid_in, ready_in, data_out = (
            _create_wrapped_sim(core)
        )

        a = np.full(T_width, 127, dtype=np.int8)
        b = np.full(T_width, 127, dtype=np.int8)
        packed_a = _pack_bytes(a)
        packed_b = _pack_bytes(b)
        for _ in range(2):
            sim.step(
                {
                    data_in: packed_a,
                    data_in_b: packed_b,
                    valid_in: 1,
                    ready_in: 1,
                }
            )
        out_bytes = _unpack_bytes(sim.inspect(data_out.name), T_width)
        np.testing.assert_array_equal(out_bytes, alu_ref(a, b, OP_ADD))

    @pytest.mark.parametrize("T_width", [1, 2, 4, 8, 16])
    def test_all_negative_max(self, T_width: int) -> None:
        core = ALUCore(T_width=T_width, name="alu")
        sim, data_in, data_in_b, valid_in, ready_in, data_out = (
            _create_wrapped_sim(core)
        )

        a = np.full(T_width, -128, dtype=np.int8)
        b = np.full(T_width, -128, dtype=np.int8)
        packed_a = _pack_bytes(a)
        packed_b = _pack_bytes(b)
        for _ in range(2):
            sim.step(
                {
                    data_in: packed_a,
                    data_in_b: packed_b,
                    valid_in: 1,
                    ready_in: 1,
                }
            )
        out_bytes = _unpack_bytes(sim.inspect(data_out.name), T_width)
        np.testing.assert_array_equal(out_bytes, alu_ref(a, b, OP_ADD))

    @pytest.mark.parametrize("T_width", [1, 2, 4, 8, 16])
    def test_mixed_extremes(self, T_width: int) -> None:
        core = ALUCore(T_width=T_width, name="alu")
        sim, data_in, data_in_b, valid_in, ready_in, data_out = (
            _create_wrapped_sim(core)
        )

        a = np.full(T_width, 127, dtype=np.int8)
        b = np.full(T_width, -128, dtype=np.int8)
        packed_a = _pack_bytes(a)
        packed_b = _pack_bytes(b)
        for _ in range(2):
            sim.step(
                {
                    data_in: packed_a,
                    data_in_b: packed_b,
                    valid_in: 1,
                    ready_in: 1,
                }
            )
        out_bytes = _unpack_bytes(sim.inspect(data_out.name), T_width)
        np.testing.assert_array_equal(out_bytes, alu_ref(a, b, OP_ADD))
