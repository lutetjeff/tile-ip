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


@cocotb.test()
async def test_mem_router(dut):
    T_out = int(os.environ.get("COCOTB_T_OUT", "2"))

    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    dut.valid_in.value = 0
    dut.ready_in.value = 0
    dut.data_in.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    dut.ready_in.value = 1
    dut.valid_in.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    assert dut.mem_router_ready_out.value == 1
    assert dut.mem_router_valid_out.value == 0

    dut.valid_in.value = 1
    await RisingEdge(dut.clk)
    dut.valid_in.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    assert dut.mem_router_ready_out.value == 0
    assert dut.mem_router_valid_out.value == 0

    dut.rst.value = 1
    dut.valid_in.value = 0
    dut.ready_in.value = 0
    dut.data_in.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    dut.ready_in.value = 1
    dut.valid_in.value = 1
    dut.data_in.value = _pack_bytes(np.array([1, 2], dtype=np.int8))
    await RisingEdge(dut.clk)
    dut.valid_in.value = 0

    for _ in range(10):
        await RisingEdge(dut.clk)

    assert dut.mem_router_valid_out.value == 0
    assert dut.mem_router_ready_out.value == 0

    print("MemRouter test completed successfully")