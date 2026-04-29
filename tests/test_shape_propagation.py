"""Unit tests for StreamShape propagation through the Stitcher.

Verifies that the stitcher correctly propagates shapes, auto-inserts
StreamShapeAdapter instances when T mismatches, and raises ValueError
on N mismatches.
"""

from __future__ import annotations

import pyrtl
import pytest

from ip_cores.activation import ActivationCore
from ip_cores.alu import ALUCore
from ip_cores.axi_stream_base import AXI4StreamLiteBase, StreamShape
from ip_cores.fifo import FIFOCore
from stitcher import Stitcher


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


class TestShapePropagation:
    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    def test_simple_chain_propagation(self) -> None:
        """FIFO (T=2) → Activation (T=2) → ALU (T=2); all shapes match."""
        block = _make_shared_block()

        def _factory():
            return (
                FIFOCore(T_width=2, depth=4, name="fifo"),
                ActivationCore(T_width=2, name="act", activation_type="relu"),
                ALUCore(T_width=2, name="alu"),
            )

        fifo, act, alu = _instantiate_ips_with_block(block, _factory)
        fifo.input_shape = StreamShape(8, 2)

        stitcher = Stitcher(block=block)
        stitcher.add_ip(fifo)
        stitcher.add_ip(act)
        stitcher.add_ip(alu)
        stitcher.connect("fifo", "act")
        stitcher.connect("act", "alu")
        stitcher.build()

        assert fifo.input_shape == StreamShape(8, 2)
        assert act.input_shape == StreamShape(8, 2)
        assert alu.input_shape == StreamShape(8, 2)

        edge_names = [(src, dst) for src, dst in stitcher._edges]
        assert not any("adapter" in src or "adapter" in dst for src, dst in edge_names)

    def test_adapter_auto_inserted(self) -> None:
        """FIFO (T=2) → Activation (T=4); adapter auto-inserted."""
        block = _make_shared_block()

        def _factory():
            return (
                FIFOCore(T_width=2, depth=4, name="fifo"),
                ActivationCore(T_width=4, name="act", activation_type="relu"),
            )

        fifo, act = _instantiate_ips_with_block(block, _factory)
        fifo.input_shape = StreamShape(8, 2)

        stitcher = Stitcher(block=block)
        stitcher.add_ip(fifo)
        stitcher.add_ip(act)
        stitcher.connect("fifo", "act")
        stitcher.build()

        assert act.input_shape == StreamShape(8, 4)

        edge_names = [(src, dst) for src, dst in stitcher._edges]
        assert any("adapter_fifo_act" in src for src, _ in edge_names)
        assert any(
            src == "fifo" and "adapter_fifo_act" in dst for src, dst in edge_names
        )
        assert any(
            "adapter_fifo_act" in src and dst == "act" for src, dst in edge_names
        )

        adapter = next(
            ip
            for name, ip in stitcher._ips.items()
            if name.startswith("adapter_fifo_act")
        )
        assert adapter.input_shape == StreamShape(8, 2)
        assert adapter.output_shape == StreamShape(8, 4)

    def test_mixed_t_values_chain(self) -> None:
        """FIFO (T=2) → Activation (T=4) → ALU (T=4); adapter only on first edge."""
        block = _make_shared_block()

        def _factory():
            return (
                FIFOCore(T_width=2, depth=4, name="fifo"),
                ActivationCore(T_width=4, name="act", activation_type="relu"),
                ALUCore(T_width=4, name="alu"),
            )

        fifo, act, alu = _instantiate_ips_with_block(block, _factory)
        fifo.input_shape = StreamShape(8, 2)

        stitcher = Stitcher(block=block)
        stitcher.add_ip(fifo)
        stitcher.add_ip(act)
        stitcher.add_ip(alu)
        stitcher.connect("fifo", "act")
        stitcher.connect("act", "alu")
        stitcher.build()

        assert fifo.input_shape == StreamShape(8, 2)
        assert act.input_shape == StreamShape(8, 4)
        assert alu.input_shape == StreamShape(8, 4)

        edge_names = [(src, dst) for src, dst in stitcher._edges]
        assert any(src == "fifo" and "adapter" in dst for src, dst in edge_names)
        assert any("adapter" in src and dst == "act" for src, dst in edge_names)
        assert any(src == "act" and dst == "alu" for src, dst in edge_names)
        assert not any(
            src == "act" and "adapter" in dst for src, dst in edge_names
        )
        assert not any(
            "adapter" in src and dst == "alu" for src, dst in edge_names
        )

    def test_n_mismatch_raises(self) -> None:
        """N not divisible by downstream tiling_param raises ValueError."""
        block = _make_shared_block()

        def _factory():
            return (
                FIFOCore(T_width=2, depth=4, name="fifo"),
                ActivationCore(T_width=4, name="act", activation_type="relu"),
            )

        fifo, act = _instantiate_ips_with_block(block, _factory)
        fifo.input_shape = StreamShape(6, 2)

        stitcher = Stitcher(block=block)
        stitcher.add_ip(fifo)
        stitcher.add_ip(act)
        stitcher.connect("fifo", "act")

        with pytest.raises(ValueError, match="not divisible by"):
            stitcher.build()

    def test_source_without_input_shape(self) -> None:
        """Source IP with no input_shape and matching tiling_param works."""
        block = _make_shared_block()

        def _factory():
            return (
                ALUCore(T_width=2, name="alu1"),
                ALUCore(T_width=2, name="alu2"),
            )

        alu1, alu2 = _instantiate_ips_with_block(block, _factory)

        stitcher = Stitcher(block=block)
        stitcher.add_ip(alu1)
        stitcher.add_ip(alu2)
        stitcher.connect("alu1", "alu2")
        stitcher.build()

        assert alu1.input_shape is None
        assert alu2.input_shape == StreamShape(2, 2)

        edge_names = [(src, dst) for src, dst in stitcher._edges]
        assert not any("adapter" in src or "adapter" in dst for src, dst in edge_names)

    def test_fan_out_shape_propagation(self) -> None:
        """FIFO → ALU (T=2) and Activation (T=4); adapter only on T-mismatch branch."""
        block = _make_shared_block()

        def _factory():
            return (
                FIFOCore(T_width=2, depth=4, name="fifo"),
                ALUCore(T_width=2, name="alu"),
                ActivationCore(T_width=4, name="act", activation_type="relu"),
            )

        fifo, alu, act = _instantiate_ips_with_block(block, _factory)
        fifo.input_shape = StreamShape(8, 2)

        stitcher = Stitcher(block=block)
        stitcher.add_ip(fifo)
        stitcher.add_ip(alu)
        stitcher.add_ip(act)
        stitcher.connect("fifo", "alu")
        stitcher.connect("fifo", "act")
        stitcher.build()

        assert fifo.input_shape == StreamShape(8, 2)
        assert alu.input_shape == StreamShape(8, 2)
        assert act.input_shape == StreamShape(8, 4)

        edge_names = [(src, dst) for src, dst in stitcher._edges]
        assert any(src == "fifo" and dst == "alu" for src, dst in edge_names)
        assert any(src == "fifo" and "adapter" in dst for src, dst in edge_names)
        assert any("adapter" in src and dst == "act" for src, dst in edge_names)
        assert not any(
            src == "alu" and "adapter" in dst for src, dst in edge_names
        )
