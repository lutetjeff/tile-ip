import os

import cocotb
import numpy as np
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge


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
async def test_fifo(dut):
    T_width = 2
    depth = 4

    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    dut.valid_in.value = 0
    dut.ready_in.value = 0
    dut.data_in.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    inputs = [
        np.random.randint(-128, 128, size=T_width, dtype=np.int8)
        for _ in range(4)
    ]

    outputs = []

    for val in inputs:
        dut.data_in.value = _pack_bytes(val)
        dut.valid_in.value = 1
        dut.ready_in.value = 0
        await RisingEdge(dut.clk)

    for _ in range(4):
        dut.valid_in.value = 0
        dut.ready_in.value = 1
        await RisingEdge(dut.clk)
        assert dut.fifo_valid_out.value == 1, "valid_out should be high when FIFO has data"
        outputs.append(int(dut.fifo_data_out.value))

    for i in range(len(inputs)):
        out_bytes = _unpack_bytes(outputs[i], T_width)
        np.testing.assert_array_equal(out_bytes, inputs[i])
