"""Tests for the AXI4-Stream-Lite base class."""

import pyrtl
import pytest

from ip_cores.axi_stream_base import AXI4StreamLiteBase


class TestAXI4StreamLiteBase:
    """Verify block isolation, wire naming, and handshake helpers."""

    def setup_method(self) -> None:
        """Reset global PyRTL state before every test."""
        AXI4StreamLiteBase.reset()

    def test_constructor_creates_wires(self) -> None:
        ip = AXI4StreamLiteBase(tiling_param=4, name="gemm")
        assert ip.data_in.bitwidth == 32
        assert ip.valid_in.bitwidth == 1
        assert ip.ready_out.bitwidth == 1
        assert ip.data_out.bitwidth == 32
        assert ip.valid_out.bitwidth == 1
        assert ip.ready_in.bitwidth == 1

    def test_wire_names_are_prefixed(self) -> None:
        ip = AXI4StreamLiteBase(tiling_param=2, name="softmax")
        assert ip.data_in.name == "softmax_data_in"
        assert ip.valid_in.name == "softmax_valid_in"
        assert ip.ready_out.name == "softmax_ready_out"
        assert ip.data_out.name == "softmax_data_out"
        assert ip.valid_out.name == "softmax_valid_out"
        assert ip.ready_in.name == "softmax_ready_in"

    def test_two_instances_no_collision(self) -> None:
        """Two IPs with different names must coexist without name clashes."""
        ip_a = AXI4StreamLiteBase(tiling_param=4, name="ip_a")
        ip_b = AXI4StreamLiteBase(tiling_param=4, name="ip_b")

        assert ip_a.block is not ip_b.block

        a_names = {w.name for w in ip_a.block.wirevector_set}
        b_names = {w.name for w in ip_b.block.wirevector_set}
        assert a_names.isdisjoint(b_names)

    def test_handshake_accepted(self) -> None:
        ip = AXI4StreamLiteBase(tiling_param=2, name="alu")
        accepted = ip.handshake_accepted()
        assert accepted.bitwidth == 1
        assert accepted.name.startswith("tmp")

    def test_stall_pipeline(self) -> None:
        ip = AXI4StreamLiteBase(tiling_param=2, name="alu")
        stalled = ip.stall_pipeline()
        assert stalled.bitwidth == 1
        assert stalled.name.startswith("tmp")

    def test_invalid_tiling_param_raises(self) -> None:
        with pytest.raises(ValueError):
            AXI4StreamLiteBase(tiling_param=0, name="bad")
        with pytest.raises(ValueError):
            AXI4StreamLiteBase(tiling_param=-1, name="bad")

    def test_empty_name_raises(self) -> None:
        with pytest.raises(ValueError):
            AXI4StreamLiteBase(tiling_param=4, name="")
