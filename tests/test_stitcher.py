"""Comprehensive tests for the Stitcher class.

Verifies linear chains, fan-out wiring, and error handling against
NumPy reference models.
"""

from __future__ import annotations

import numpy as np
import pyrtl
import pytest

from ip_cores.alu import ALUCore
from ip_cores.activation import ActivationCore
from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ip_cores.fifo import FIFOCore
from ref_models.alu_ref import alu_ref, OP_ADD
from ref_models.activation_ref import relu_ref
from stitcher import Stitcher


def _pack_bytes(values: np.ndarray) -> int:
    """Pack INT8 array into little-endian bus value."""
    val = 0
    for i, b in enumerate(values):
        val |= (int(b) & 0xFF) << (i * 8)
    return val


def _unpack_bytes(value: int, T_width: int) -> np.ndarray:
    """Unpack little-endian bus value into INT8 array."""
    out = []
    for i in range(T_width):
        b = (value >> (i * 8)) & 0xFF
        if b >= 128:
            b -= 256
        out.append(b)
    return np.array(out, dtype=np.int8)


def _make_shared_block() -> pyrtl.Block:
    """Return a fresh PyRTL block for monkey-patching."""
    return pyrtl.Block()


def _instantiate_ips_with_block(block: pyrtl.Block, factory):
    """Monkey-patch pyrtl.Block to *block*, call *factory*, then restore."""
    original = pyrtl.Block
    pyrtl.Block = lambda: block
    try:
        return factory()
    finally:
        pyrtl.Block = original


class TestStitcherErrors:
    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    def test_empty_stitcher_raises(self) -> None:
        stitcher = Stitcher()
        with pytest.raises(ValueError, match="No IPs registered"):
            stitcher.build()

    def test_connect_unknown_src(self) -> None:
        block = _make_shared_block()
        alu = _instantiate_ips_with_block(block, lambda: ALUCore(T_width=2, name="alu"))
        stitcher = Stitcher(block=block)
        stitcher.add_ip(alu)
        with pytest.raises(ValueError, match="Unknown destination IP"):
            stitcher.connect("alu", "missing")

    def test_connect_unknown_dst(self) -> None:
        block = _make_shared_block()
        alu = _instantiate_ips_with_block(block, lambda: ALUCore(T_width=2, name="alu"))
        stitcher = Stitcher(block=block)
        stitcher.add_ip(alu)
        with pytest.raises(ValueError, match="Unknown source IP"):
            stitcher.connect("missing", "alu")

    def test_duplicate_ip_name(self) -> None:
        block = _make_shared_block()
        alu1 = _instantiate_ips_with_block(
            block, lambda: ALUCore(T_width=2, name="alu")
        )
        alu2 = _instantiate_ips_with_block(
            block, lambda: ALUCore(T_width=2, name="alu")
        )
        stitcher = Stitcher(block=block)
        stitcher.add_ip(alu1)
        with pytest.raises(ValueError, match="already registered"):
            stitcher.add_ip(alu2)

    def test_block_mismatch(self) -> None:
        block_a = _make_shared_block()
        block_b = _make_shared_block()
        alu_a = _instantiate_ips_with_block(
            block_a, lambda: ALUCore(T_width=2, name="alu_a")
        )
        alu_b = _instantiate_ips_with_block(
            block_b, lambda: ALUCore(T_width=2, name="alu_b")
        )
        stitcher = Stitcher(block=block_a)
        stitcher.add_ip(alu_a)
        with pytest.raises(ValueError, match="different block"):
            stitcher.add_ip(alu_b)

    def test_fan_in_not_supported(self) -> None:
        block = _make_shared_block()

        def _factory():
            return (
                ALUCore(T_width=2, name="alu1"),
                ALUCore(T_width=2, name="alu2"),
                FIFOCore(T_width=2, depth=4, name="fifo3"),
            )

        alu1, alu2, fifo3 = _instantiate_ips_with_block(block, _factory)
        stitcher = Stitcher(block=block)
        stitcher.add_ip(alu1)
        stitcher.add_ip(alu2)
        stitcher.add_ip(fifo3)
        stitcher.connect("alu1", "fifo3")
        stitcher.connect("alu2", "fifo3")
        with pytest.raises(ValueError, match="Fan-in is not supported"):
            stitcher.build()

    def test_edge_unknown_ip_at_build(self) -> None:
        block = _make_shared_block()
        alu = _instantiate_ips_with_block(block, lambda: ALUCore(T_width=2, name="alu"))
        stitcher = Stitcher(edges=[("a", "b")], block=block)
        stitcher.add_ip(alu)
        with pytest.raises(ValueError, match="unknown source IP"):
            stitcher.build()


class TestStitcher2IPChain:
    """ALU → ALU linear chain."""

    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize("T_width", [1, 2, 4])
    def test_continuous_stream(self, T_width: int) -> None:
        block = _make_shared_block()

        def _factory():
            return (
                ALUCore(T_width=T_width, name="alu1", op_mode="add"),
                ALUCore(T_width=T_width, name="alu2", op_mode="add"),
            )

        alu1, alu2 = _instantiate_ips_with_block(block, _factory)
        stitcher = Stitcher(block=block)
        stitcher.add_ip(alu1)
        stitcher.add_ip(alu2)
        stitcher.connect("alu1", "alu2")
        built_block, drivers = stitcher.build()

        # Wire ALU-specific inputs (use distinct names to avoid collision with
        # wires already created inside the ALU constructor).
        with pyrtl.set_working_block(built_block, no_sanity_check=True):
            drv_alu1_data_in_b = pyrtl.Input(
                bitwidth=T_width * 8, name="drv_alu1_data_in_b"
            )
            drv_alu2_data_in_b = pyrtl.Input(
                bitwidth=T_width * 8, name="drv_alu2_data_in_b"
            )
            alu1.data_in_b <<= drv_alu1_data_in_b
            alu2.data_in_b <<= drv_alu2_data_in_b

        sim = pyrtl.Simulation(tracer=None, block=built_block)

        rng = np.random.default_rng(42)
        beats_a = [
            rng.integers(-50, 50, size=T_width, dtype=np.int8) for _ in range(10)
        ]
        b1 = rng.integers(-50, 50, size=T_width, dtype=np.int8)
        b2 = rng.integers(-50, 50, size=T_width, dtype=np.int8)

        outputs = []
        for a in beats_a:
            sim.step(
                {
                    drivers["alu1_data_in"]: _pack_bytes(a),
                    drivers["alu1_valid_in"]: 1,
                    drivers["alu2_ready_in"]: 1,
                    drv_alu1_data_in_b: _pack_bytes(b1),
                    drv_alu2_data_in_b: _pack_bytes(b2),
                }
            )
            outputs.append(
                _unpack_bytes(sim.inspect(drivers["alu2_data_out"].name), T_width)
            )

        # Flush pipeline (2-cycle latency for ALU → ALU)
        for _ in range(2):
            sim.step(
                {
                    drivers["alu1_data_in"]: _pack_bytes(beats_a[-1]),
                    drivers["alu1_valid_in"]: 1,
                    drivers["alu2_ready_in"]: 1,
                    drv_alu1_data_in_b: _pack_bytes(b1),
                    drv_alu2_data_in_b: _pack_bytes(b2),
                }
            )
            outputs.append(
                _unpack_bytes(sim.inspect(drivers["alu2_data_out"].name), T_width)
            )

        for i in range(10):
            ref = alu_ref(
                alu_ref(beats_a[i], b1, OP_ADD),
                b2,
                OP_ADD,
            )
            np.testing.assert_array_equal(outputs[i + 2], ref)

    @pytest.mark.parametrize("T_width", [1, 2, 4])
    def test_all_zeros(self, T_width: int) -> None:
        block = _make_shared_block()

        def _factory():
            return (
                ALUCore(T_width=T_width, name="alu1", op_mode="add"),
                ALUCore(T_width=T_width, name="alu2", op_mode="add"),
            )

        alu1, alu2 = _instantiate_ips_with_block(block, _factory)
        stitcher = Stitcher(block=block)
        stitcher.add_ip(alu1)
        stitcher.add_ip(alu2)
        stitcher.connect("alu1", "alu2")
        built_block, drivers = stitcher.build()

        with pyrtl.set_working_block(built_block, no_sanity_check=True):
            drv_alu1_data_in_b = pyrtl.Input(
                bitwidth=T_width * 8, name="drv_alu1_data_in_b"
            )
            drv_alu2_data_in_b = pyrtl.Input(
                bitwidth=T_width * 8, name="drv_alu2_data_in_b"
            )
            alu1.data_in_b <<= drv_alu1_data_in_b
            alu2.data_in_b <<= drv_alu2_data_in_b

        sim = pyrtl.Simulation(tracer=None, block=built_block)

        a = np.zeros(T_width, dtype=np.int8)
        b1 = np.zeros(T_width, dtype=np.int8)
        b2 = np.zeros(T_width, dtype=np.int8)

        for _ in range(3):
            sim.step(
                {
                    drivers["alu1_data_in"]: _pack_bytes(a),
                    drivers["alu1_valid_in"]: 1,
                    drivers["alu2_ready_in"]: 1,
                    drv_alu1_data_in_b: _pack_bytes(b1),
                    drv_alu2_data_in_b: _pack_bytes(b2),
                }
            )

        hw_out = _unpack_bytes(sim.inspect(drivers["alu2_data_out"].name), T_width)
        ref = alu_ref(alu_ref(a, b1, OP_ADD), b2, OP_ADD)
        np.testing.assert_array_equal(hw_out, ref)


class TestStitcher3IPChain:
    """Activation → ALU → ALU linear chain."""

    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize("T_width", [2, 4])
    def test_relu_chain(self, T_width: int) -> None:
        block = _make_shared_block()

        def _factory():
            return (
                ActivationCore(T_width=T_width, name="act", activation_type="relu"),
                ALUCore(T_width=T_width, name="alu1", op_mode="add"),
                ALUCore(T_width=T_width, name="alu2", op_mode="add"),
            )

        act, alu1, alu2 = _instantiate_ips_with_block(block, _factory)
        stitcher = Stitcher(block=block)
        stitcher.add_ip(act)
        stitcher.add_ip(alu1)
        stitcher.add_ip(alu2)
        stitcher.connect("act", "alu1")
        stitcher.connect("alu1", "alu2")
        built_block, drivers = stitcher.build()

        with pyrtl.set_working_block(built_block, no_sanity_check=True):
            drv_alu1_data_in_b = pyrtl.Input(
                bitwidth=T_width * 8, name="drv_alu1_data_in_b"
            )
            drv_alu2_data_in_b = pyrtl.Input(
                bitwidth=T_width * 8, name="drv_alu2_data_in_b"
            )
            alu1.data_in_b <<= drv_alu1_data_in_b
            alu2.data_in_b <<= drv_alu2_data_in_b

        sim = pyrtl.Simulation(tracer=None, block=built_block)

        rng = np.random.default_rng(123)
        beats_a = [
            rng.integers(-50, 50, size=T_width, dtype=np.int8) for _ in range(10)
        ]
        b1 = rng.integers(-50, 50, size=T_width, dtype=np.int8)
        b2 = rng.integers(-50, 50, size=T_width, dtype=np.int8)

        outputs = []
        for a in beats_a:
            sim.step(
                {
                    drivers["act_data_in"]: _pack_bytes(a),
                    drivers["act_valid_in"]: 1,
                    drivers["alu2_ready_in"]: 1,
                    drv_alu1_data_in_b: _pack_bytes(b1),
                    drv_alu2_data_in_b: _pack_bytes(b2),
                }
            )
            outputs.append(
                _unpack_bytes(sim.inspect(drivers["alu2_data_out"].name), T_width)
            )

        # Flush pipeline (2-cycle latency: act is combinational, each ALU is 1 cycle)
        for _ in range(2):
            sim.step(
                {
                    drivers["act_data_in"]: _pack_bytes(beats_a[-1]),
                    drivers["act_valid_in"]: 1,
                    drivers["alu2_ready_in"]: 1,
                    drv_alu1_data_in_b: _pack_bytes(b1),
                    drv_alu2_data_in_b: _pack_bytes(b2),
                }
            )
            outputs.append(
                _unpack_bytes(sim.inspect(drivers["alu2_data_out"].name), T_width)
            )

        for i in range(10):
            ref = alu_ref(
                alu_ref(relu_ref(beats_a[i]), b1, OP_ADD),
                b2,
                OP_ADD,
            )
            np.testing.assert_array_equal(outputs[i + 2], ref)


class TestStitcherFanOut:
    """1 ALU driving 2 ALUs (fan-out)."""

    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize("T_width", [2, 4])
    def test_alu_fan_out(self, T_width: int) -> None:
        block = _make_shared_block()

        def _factory():
            return (
                ALUCore(T_width=T_width, name="alu1", op_mode="add"),
                ALUCore(T_width=T_width, name="alu2", op_mode="add"),
                ALUCore(T_width=T_width, name="alu3", op_mode="add"),
            )

        alu1, alu2, alu3 = _instantiate_ips_with_block(block, _factory)
        stitcher = Stitcher(block=block)
        stitcher.add_ip(alu1)
        stitcher.add_ip(alu2)
        stitcher.add_ip(alu3)
        stitcher.connect("alu1", "alu2")
        stitcher.connect("alu1", "alu3")
        built_block, drivers = stitcher.build()

        with pyrtl.set_working_block(built_block, no_sanity_check=True):
            drv_alu1_data_in_b = pyrtl.Input(
                bitwidth=T_width * 8, name="drv_alu1_data_in_b"
            )
            drv_alu2_data_in_b = pyrtl.Input(
                bitwidth=T_width * 8, name="drv_alu2_data_in_b"
            )
            drv_alu3_data_in_b = pyrtl.Input(
                bitwidth=T_width * 8, name="drv_alu3_data_in_b"
            )
            alu1.data_in_b <<= drv_alu1_data_in_b
            alu2.data_in_b <<= drv_alu2_data_in_b
            alu3.data_in_b <<= drv_alu3_data_in_b

        sim = pyrtl.Simulation(tracer=None, block=built_block)

        rng = np.random.default_rng(77)
        beats_a = [
            rng.integers(-50, 50, size=T_width, dtype=np.int8) for _ in range(10)
        ]
        b1 = rng.integers(-50, 50, size=T_width, dtype=np.int8)
        b2 = rng.integers(-50, 50, size=T_width, dtype=np.int8)
        b3 = rng.integers(-50, 50, size=T_width, dtype=np.int8)

        outputs2 = []
        outputs3 = []
        for a in beats_a:
            sim.step(
                {
                    drivers["alu1_data_in"]: _pack_bytes(a),
                    drivers["alu1_valid_in"]: 1,
                    drivers["alu2_ready_in"]: 1,
                    drivers["alu3_ready_in"]: 1,
                    drv_alu1_data_in_b: _pack_bytes(b1),
                    drv_alu2_data_in_b: _pack_bytes(b2),
                    drv_alu3_data_in_b: _pack_bytes(b3),
                }
            )
            outputs2.append(
                _unpack_bytes(sim.inspect(drivers["alu2_data_out"].name), T_width)
            )
            outputs3.append(
                _unpack_bytes(sim.inspect(drivers["alu3_data_out"].name), T_width)
            )

        # Flush pipeline (2-cycle latency)
        for _ in range(2):
            sim.step(
                {
                    drivers["alu1_data_in"]: _pack_bytes(beats_a[-1]),
                    drivers["alu1_valid_in"]: 1,
                    drivers["alu2_ready_in"]: 1,
                    drivers["alu3_ready_in"]: 1,
                    drv_alu1_data_in_b: _pack_bytes(b1),
                    drv_alu2_data_in_b: _pack_bytes(b2),
                    drv_alu3_data_in_b: _pack_bytes(b3),
                }
            )
            outputs2.append(
                _unpack_bytes(sim.inspect(drivers["alu2_data_out"].name), T_width)
            )
            outputs3.append(
                _unpack_bytes(sim.inspect(drivers["alu3_data_out"].name), T_width)
            )

        for i in range(10):
            mid = alu_ref(beats_a[i], b1, OP_ADD)
            ref2 = alu_ref(mid, b2, OP_ADD)
            ref3 = alu_ref(mid, b3, OP_ADD)
            np.testing.assert_array_equal(outputs2[i + 2], ref2)
            np.testing.assert_array_equal(outputs3[i + 2], ref3)
