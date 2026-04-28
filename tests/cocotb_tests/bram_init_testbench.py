import os
from pathlib import Path

import cocotb
import numpy as np
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge


@cocotb.test()
async def test_bram_init(dut):
    bitwidth = int(os.environ.get("COCOTB_BITWIDTH", "8"))
    addrwidth = int(os.environ.get("COCOTB_ADDRWIDTH", "4"))
    depth = 1 << addrwidth

    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    dut.addr.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    expected = {}
    for addr in range(depth):
        expected[addr] = (addr * 3 + 17) & ((1 << bitwidth) - 1)

    for addr in range(depth):
        dut.addr.value = addr
        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)
        actual = int(dut.data.value)
        assert actual == expected[addr], f"BRAM mismatch at addr {addr}: expected {expected[addr]:x}, got {actual:x}"

    print("BRAM initialization test completed successfully")
