"""Tests for Stitcher fan-in (N->1) connections.

Verifies two MemRouterCores feeding one ALUCore ADD operation,
as used in residual connections.
"""

from __future__ import annotations

import numpy as np
import pyrtl
import pytest

from ip_cores.alu import ALUCore
from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ip_cores.mem_router import MemRouterCore
from ref_models.alu_ref import alu_ref, OP_ADD
from ref_models.mem_router_ref import mem_router_ref
from stitcher import Stitcher


def _pack_bytes(values: np.ndarray) -> int:
    val = 0
    for i, b in enumerate(values):
        val |= (int(b) & 0xFF) << (i * 8)
    return val


def _unpack_bytes(value: int, T_width: int) -> np.ndarray:
    out = []
    for i in range(T_width):
        b = (value >> (i * 8)) & 0xFF
        if b >= 128:
            b -= 256
        out.append(b)
    return np.array(out, dtype=np.int8)


def _make_shared_block() -> pyrtl.Block:
    return pyrtl.Block()


def _instantiate_ips_with_block(block: pyrtl.Block, factory):
    original = pyrtl.Block
    pyrtl.Block = lambda: block
    try:
        return factory()
    finally:
        pyrtl.Block = original


class TestStitcherFanIn:
    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize("T_width", [1, 2, 4])
    def test_two_memrouters_to_alu_add(self, T_width: int) -> None:
        block = _make_shared_block()

        def _factory():
            return (
                MemRouterCore(T_out=T_width, name="mr1", block=block),
                MemRouterCore(T_out=T_width, name="mr2", block=block),
                ALUCore(T_width=T_width, name="alu"),
            )

        mr1, mr2, alu = _instantiate_ips_with_block(block, _factory)
        stitcher = Stitcher(block=block)
        stitcher.add_ip(mr1)
        stitcher.add_ip(mr2)
        stitcher.add_ip(alu)
        stitcher.connect("mr1", "alu")
        stitcher.connect("mr2", "alu")
        built_block, drivers = stitcher.build()

        with pyrtl.set_working_block(built_block, no_sanity_check=True):
            drv_alu_op_code = pyrtl.Input(bitwidth=2, name="drv_alu_op_code")
            alu.op_code <<= drv_alu_op_code

        rows = T_width
        cols = 5
        data1 = np.random.randint(-128, 127, size=rows * cols, dtype=np.int8)
        data2 = np.random.randint(-128, 127, size=rows * cols, dtype=np.int8)

        mem_map1 = {i: int(np.uint8(data1[i])) for i in range(rows * cols)}
        mem_map2 = {i: int(np.uint8(data2[i])) for i in range(rows * cols)}

        reg_map = {
            mr1.base_addr: 0,
            mr1.stride: cols,
            mr1.beat_stride: 1,
            mr1.num_beats: cols,
            mr1.state: 0,
            mr1.beat_count: 0,
            mr1.read_idx: 0,
            mr1.current_addr: 0,
            mr2.base_addr: 0,
            mr2.stride: cols,
            mr2.beat_stride: 1,
            mr2.num_beats: cols,
            mr2.state: 0,
            mr2.beat_count: 0,
            mr2.read_idx: 0,
            mr2.current_addr: 0,
        }
        for i in range(T_width):
            reg_map[mr1.byte_regs[i]] = 0
            reg_map[mr2.byte_regs[i]] = 0

        sim = pyrtl.Simulation(
            tracer=None,
            block=built_block,
            register_value_map=reg_map,
            memory_value_map={
                mr1.bram: mem_map1,
                mr2.bram: mem_map2,
            },
        )

        outputs = []
        for cycle in range(100):
            valid_in_val = 1 if cycle == 0 else 0
            last_in_val = 1 if cycle == 0 else 0

            sim.step(
                {
                    drivers["mr1_valid_in"]: valid_in_val,
                    drivers["mr1_last_in"]: last_in_val,
                    drivers["mr1_data_in"]: 0,
                    drivers["mr2_valid_in"]: valid_in_val,
                    drivers["mr2_last_in"]: last_in_val,
                    drivers["mr2_data_in"]: 0,
                    drivers["alu_ready_in"]: 1,
                    drv_alu_op_code: OP_ADD,
                }
            )

            if sim.inspect(drivers["alu_valid_out"]) == 1:
                outputs.append(sim.inspect(drivers["alu_data_out"]))

            if (
                cycle > 0
                and sim.inspect(mr1.state) == 3
                and sim.inspect(mr2.state) == 3
                and len(outputs) >= cols
            ):
                break

        ref1 = mem_router_ref(data1, (rows, cols))
        ref2 = mem_router_ref(data2, (rows, cols))

        assert len(outputs) == cols
        for beat in range(cols):
            hw_out = _unpack_bytes(outputs[beat], T_width)
            expected = alu_ref(ref1[beat], ref2[beat], OP_ADD)
            np.testing.assert_array_equal(hw_out, expected)

    @pytest.mark.parametrize("T_width", [1, 2, 4])
    def test_two_memrouters_to_alu_add_all_zeros(self, T_width: int) -> None:
        block = _make_shared_block()

        def _factory():
            return (
                MemRouterCore(T_out=T_width, name="mr1", block=block),
                MemRouterCore(T_out=T_width, name="mr2", block=block),
                ALUCore(T_width=T_width, name="alu"),
            )

        mr1, mr2, alu = _instantiate_ips_with_block(block, _factory)
        stitcher = Stitcher(block=block)
        stitcher.add_ip(mr1)
        stitcher.add_ip(mr2)
        stitcher.add_ip(alu)
        stitcher.connect("mr1", "alu")
        stitcher.connect("mr2", "alu")
        built_block, drivers = stitcher.build()

        with pyrtl.set_working_block(built_block, no_sanity_check=True):
            drv_alu_op_code = pyrtl.Input(bitwidth=2, name="drv_alu_op_code")
            alu.op_code <<= drv_alu_op_code

        rows = T_width
        cols = 3
        data1 = np.zeros(rows * cols, dtype=np.int8)
        data2 = np.zeros(rows * cols, dtype=np.int8)

        mem_map1 = {i: int(np.uint8(data1[i])) for i in range(rows * cols)}
        mem_map2 = {i: int(np.uint8(data2[i])) for i in range(rows * cols)}

        reg_map = {
            mr1.base_addr: 0,
            mr1.stride: cols,
            mr1.beat_stride: 1,
            mr1.num_beats: cols,
            mr1.state: 0,
            mr1.beat_count: 0,
            mr1.read_idx: 0,
            mr1.current_addr: 0,
            mr2.base_addr: 0,
            mr2.stride: cols,
            mr2.beat_stride: 1,
            mr2.num_beats: cols,
            mr2.state: 0,
            mr2.beat_count: 0,
            mr2.read_idx: 0,
            mr2.current_addr: 0,
        }
        for i in range(T_width):
            reg_map[mr1.byte_regs[i]] = 0
            reg_map[mr2.byte_regs[i]] = 0

        sim = pyrtl.Simulation(
            tracer=None,
            block=built_block,
            register_value_map=reg_map,
            memory_value_map={
                mr1.bram: mem_map1,
                mr2.bram: mem_map2,
            },
        )

        outputs = []
        for cycle in range(100):
            valid_in_val = 1 if cycle == 0 else 0
            last_in_val = 1 if cycle == 0 else 0

            sim.step(
                {
                    drivers["mr1_valid_in"]: valid_in_val,
                    drivers["mr1_last_in"]: last_in_val,
                    drivers["mr1_data_in"]: 0,
                    drivers["mr2_valid_in"]: valid_in_val,
                    drivers["mr2_last_in"]: last_in_val,
                    drivers["mr2_data_in"]: 0,
                    drivers["alu_ready_in"]: 1,
                    drv_alu_op_code: OP_ADD,
                }
            )

            if sim.inspect(drivers["alu_valid_out"]) == 1:
                outputs.append(sim.inspect(drivers["alu_data_out"]))

            if (
                cycle > 0
                and sim.inspect(mr1.state) == 3
                and sim.inspect(mr2.state) == 3
                and len(outputs) >= cols
            ):
                break

        ref1 = mem_router_ref(data1, (rows, cols))
        ref2 = mem_router_ref(data2, (rows, cols))

        assert len(outputs) == cols
        for beat in range(cols):
            hw_out = _unpack_bytes(outputs[beat], T_width)
            expected = alu_ref(ref1[beat], ref2[beat], OP_ADD)
            np.testing.assert_array_equal(hw_out, expected)
