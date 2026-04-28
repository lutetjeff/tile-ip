import os

import cocotb
import numpy as np
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge

from tests.ref_models.alu_ref import OP_ADD, OP_MASK, OP_MULTIPLY, alu_ref


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


@cocotb.test()
async def test_alu(dut):
    T_width = 2
    op_code = int(os.environ.get("COCOTB_OP_CODE", "0"))

    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    dut.valid_in.value = 0
    dut.ready_in.value = 0
    dut.data_in.value = 0
    dut.data_in_b.value = 0
    dut.op_code.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    test_cases = [
        (np.zeros(T_width, dtype=np.int8), np.zeros(T_width, dtype=np.int8)),
        (np.full(T_width, 127, dtype=np.int8), np.full(T_width, 127, dtype=np.int8)),
        (np.full(T_width, -128, dtype=np.int8), np.full(T_width, -128, dtype=np.int8)),
        (np.full(T_width, 127, dtype=np.int8), np.full(T_width, -128, dtype=np.int8)),
        (
            np.random.randint(-128, 128, size=T_width, dtype=np.int8),
            np.random.randint(-128, 128, size=T_width, dtype=np.int8),
        ),
        (
            np.random.randint(-128, 128, size=T_width, dtype=np.int8),
            np.random.randint(-128, 128, size=T_width, dtype=np.int8),
        ),
    ]

    inputs_a = []
    inputs_b = []
    outputs = []

    for a, b in test_cases:
        inputs_a.append(a)
        inputs_b.append(b)

        dut.data_in.value = _pack_bytes(a)
        dut.data_in_b.value = _pack_bytes(b)
        dut.op_code.value = op_code
        dut.valid_in.value = 1
        dut.ready_in.value = 1

        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)

        # Capture output when valid_out && ready_in (ready_out is always 1 when ready_in=1)
        assert dut.alu_valid_out.value == 1, "valid_out should be high"
        assert dut.alu_ready_out.value == 1, "ready_out should be high"
        outputs.append(int(dut.alu_data_out.value))

    for i in range(len(test_cases)):
        out_bytes = _unpack_bytes(outputs[i], T_width)
        expected = alu_ref(inputs_a[i], inputs_b[i], op_code)
        np.testing.assert_array_equal(out_bytes, expected)
