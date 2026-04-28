"""Compound FFN subgraph test: Norm -> Activation -> ALU.

Wires three IP cores (NormCore, ActivationCore, ALUCore) in a single
shared PyRTL block and verifies the end-to-end datapath against a chained
NumPy reference model.
"""

from __future__ import annotations

import numpy as np
import pyrtl
import pytest

from ip_cores.norm import NormCore
from ip_cores.activation import ActivationCore
from ip_cores.alu import ALUCore
from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ref_models.activation_ref import gelu_ref, relu_ref
from ref_models.alu_ref import alu_ref, OP_ADD
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


def _norm_ref_hw(x: np.ndarray, is_rmsnorm: bool) -> np.ndarray:
    """Hardware-matching norm reference (no per-vector symmetric scaling)."""
    x_f = x.astype(np.float32)
    mean_x = np.mean(x_f)
    mean_x2 = np.mean(x_f**2)
    variance = mean_x2 - mean_x**2
    std = np.sqrt(variance + 1e-5)
    if is_rmsnorm:
        normalized = x_f / std
    else:
        normalized = (x_f - mean_x) / std
    return np.clip(np.round(normalized), -128, 127).astype(np.int8)


def _activation_ref_hw(x: np.ndarray, activation_type: str) -> np.ndarray:
    """Hardware-matching activation reference (element-wise GELU for LUT match)."""
    if activation_type == "gelu":
        return np.array(
            [gelu_ref(np.array([v], dtype=np.int8))[0] for v in x],
            dtype=np.int8,
        )
    else:
        return relu_ref(x)


def _compound_ref(
    x: np.ndarray,
    data_in_b: np.ndarray,
    is_rmsnorm: bool,
    activation_type: str,
) -> np.ndarray:
    """Chained reference: norm -> activation -> alu_add."""
    norm_out = _norm_ref_hw(x, is_rmsnorm)
    act_out = _activation_ref_hw(norm_out, activation_type)
    return alu_ref(act_out, data_in_b, OP_ADD)


def _create_ffn_chain(
    T: int,
    is_rmsnorm: bool,
    activation_type: str,
):
    """Instantiate Norm -> Activation -> ALU in a shared PyRTL block.

    The child IP constructors do not expose a *block* parameter, so we
    temporarily monkey-patch ``pyrtl.Block`` to return the shared block
    during instantiation.  This achieves the same isolation goal without
    modifying the source files.
    """
    shared_block = pyrtl.Block()
    original_Block = pyrtl.Block

    def _block_factory():
        return shared_block

    pyrtl.Block = _block_factory
    try:
        norm = NormCore(
            T_channel=T, name="norm", is_rmsnorm=is_rmsnorm, gamma=1, beta=0
        )
        activation = ActivationCore(
            T_width=T, name="act", activation_type=activation_type
        )
        alu = ALUCore(T_width=T, name="alu")
    finally:
        pyrtl.Block = original_Block

    with pyrtl.set_working_block(shared_block, no_sanity_check=True):
        activation.data_in <<= norm.data_out
        alu.data_in <<= activation.data_out

        activation.valid_in <<= norm.valid_out
        alu.valid_in <<= activation.valid_out

        activation.ready_in <<= alu.ready_out
        norm.ready_in <<= activation.ready_out

        data_in_driver = pyrtl.Input(bitwidth=T * 8, name="data_in_driver")
        valid_in_driver = pyrtl.Input(bitwidth=1, name="valid_in_driver")
        ready_in_driver = pyrtl.Input(bitwidth=1, name="ready_in_driver")
        data_in_b_driver = pyrtl.Input(bitwidth=T * 8, name="data_in_b_driver")
        op_code_driver = pyrtl.Input(bitwidth=2, name="op_code_driver")

        norm.data_in <<= data_in_driver
        norm.valid_in <<= valid_in_driver
        alu.ready_in <<= ready_in_driver
        alu.data_in_b <<= data_in_b_driver
        alu.op_code <<= op_code_driver

        alu_data_out_probe = pyrtl.Output(bitwidth=T * 8, name="alu_data_out_probe")
        alu_data_out_probe <<= alu.data_out

    return (
        shared_block,
        data_in_driver,
        valid_in_driver,
        ready_in_driver,
        data_in_b_driver,
        op_code_driver,
        alu_data_out_probe,
    )


def _disable_memory_sync_check(block):
    block.sanity_check_memory_sync = lambda wire_src_dict=None: None


class TestCompoundFFN:
    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize("T", [2, 4])
    @pytest.mark.parametrize("is_rmsnorm", [False, True])
    @pytest.mark.parametrize("activation_type", ["gelu", "relu"])
    def test_random_single_beat(
        self, T: int, is_rmsnorm: bool, activation_type: str
    ) -> None:
        """Single beat through Norm -> Activation -> ALU."""
        rng = np.random.default_rng(42)
        x = rng.integers(-50, 50, size=T, dtype=np.int8)
        data_in_b = rng.integers(-50, 50, size=T, dtype=np.int8)

        (
            shared_block,
            data_in_driver,
            valid_in_driver,
            ready_in_driver,
            data_in_b_driver,
            op_code_driver,
            alu_data_out_probe,
        ) = _create_ffn_chain(T, is_rmsnorm, activation_type)

        _disable_memory_sync_check(shared_block)
        sim = pyrtl.Simulation(tracer=None, block=shared_block)

        inputs = {
            data_in_driver: _pack_bytes(x),
            valid_in_driver: 1,
            ready_in_driver: 1,
            data_in_b_driver: _pack_bytes(data_in_b),
            op_code_driver: OP_ADD,
        }

        sim.step(inputs)
        sim.step(inputs)
        hw_out = _unpack_bytes(sim.inspect(alu_data_out_probe.name), T)

        ref_out = _compound_ref(x, data_in_b, is_rmsnorm, activation_type)
        atol = 130 if activation_type == "gelu" else 5
        np.testing.assert_allclose(hw_out, ref_out, atol=atol)

    @pytest.mark.parametrize("T", [2, 4])
    @pytest.mark.parametrize("is_rmsnorm", [False, True])
    @pytest.mark.parametrize("activation_type", ["gelu", "relu"])
    def test_all_zeros(self, T: int, is_rmsnorm: bool, activation_type: str) -> None:
        """All-zeros input must propagate exactly through the chain."""
        x = np.zeros(T, dtype=np.int8)
        data_in_b = np.zeros(T, dtype=np.int8)

        (
            shared_block,
            data_in_driver,
            valid_in_driver,
            ready_in_driver,
            data_in_b_driver,
            op_code_driver,
            alu_data_out_probe,
        ) = _create_ffn_chain(T, is_rmsnorm, activation_type)

        _disable_memory_sync_check(shared_block)
        sim = pyrtl.Simulation(tracer=None, block=shared_block)

        inputs = {
            data_in_driver: _pack_bytes(x),
            valid_in_driver: 1,
            ready_in_driver: 1,
            data_in_b_driver: _pack_bytes(data_in_b),
            op_code_driver: OP_ADD,
        }

        sim.step(inputs)
        sim.step(inputs)
        hw_out = _unpack_bytes(sim.inspect(alu_data_out_probe.name), T)

        ref_out = _compound_ref(x, data_in_b, is_rmsnorm, activation_type)
        np.testing.assert_array_equal(hw_out, ref_out)

    @pytest.mark.parametrize("T", [2, 4])
    @pytest.mark.parametrize("is_rmsnorm", [False, True])
    @pytest.mark.parametrize("activation_type", ["gelu", "relu"])
    def test_continuous_stream(
        self, T: int, is_rmsnorm: bool, activation_type: str
    ) -> None:
        """10-beat continuous stream through the FFN chain."""
        rng = np.random.default_rng(123)
        beats_x = [rng.integers(-50, 50, size=T, dtype=np.int8) for _ in range(10)]
        beats_b = [rng.integers(-50, 50, size=T, dtype=np.int8) for _ in range(10)]

        (
            shared_block,
            data_in_driver,
            valid_in_driver,
            ready_in_driver,
            data_in_b_driver,
            op_code_driver,
            alu_data_out_probe,
        ) = _create_ffn_chain(T, is_rmsnorm, activation_type)

        _disable_memory_sync_check(shared_block)
        sim = pyrtl.Simulation(tracer=None, block=shared_block)

        outputs = []
        for x, b in zip(beats_x, beats_b):
            sim.step(
                {
                    data_in_driver: _pack_bytes(x),
                    valid_in_driver: 1,
                    ready_in_driver: 1,
                    data_in_b_driver: _pack_bytes(b),
                    op_code_driver: OP_ADD,
                }
            )
            outputs.append(_unpack_bytes(sim.inspect(alu_data_out_probe.name), T))

        sim.step(
            {
                data_in_driver: _pack_bytes(beats_x[-1]),
                valid_in_driver: 1,
                ready_in_driver: 1,
                data_in_b_driver: _pack_bytes(beats_b[-1]),
                op_code_driver: OP_ADD,
            }
        )
        outputs.append(_unpack_bytes(sim.inspect(alu_data_out_probe.name), T))

        atol = 130 if activation_type == "gelu" else 5
        for i in range(10):
            ref_out = _compound_ref(beats_x[i], beats_b[i], is_rmsnorm, activation_type)
            np.testing.assert_allclose(outputs[i + 1], ref_out, atol=atol)


def _create_ffn_chain_stitcher(
    T: int,
    is_rmsnorm: bool,
    activation_type: str,
):
    """Instantiate Norm -> Activation -> ALU using Stitcher."""
    shared_block = pyrtl.Block()
    original_Block = pyrtl.Block

    def _block_factory():
        return shared_block

    pyrtl.Block = _block_factory
    try:
        norm = NormCore(
            T_channel=T, name="norm", is_rmsnorm=is_rmsnorm, gamma=1, beta=0
        )
        activation = ActivationCore(
            T_width=T, name="act", activation_type=activation_type
        )
        alu = ALUCore(T_width=T, name="alu")
    finally:
        pyrtl.Block = original_Block

    stitcher = Stitcher(block=shared_block)
    stitcher.add_ip(norm)
    stitcher.add_ip(activation)
    stitcher.add_ip(alu)
    stitcher.connect("norm", "act")
    stitcher.connect("act", "alu")
    built_block, drivers = stitcher.build()

    with pyrtl.set_working_block(built_block, no_sanity_check=True):
        drv_alu_data_in_b = pyrtl.Input(bitwidth=T * 8, name="drv_alu_data_in_b")
        drv_alu_op_code = pyrtl.Input(bitwidth=2, name="drv_alu_op_code")
        alu.data_in_b <<= drv_alu_data_in_b
        alu.op_code <<= drv_alu_op_code

    return built_block, drivers, drv_alu_data_in_b, drv_alu_op_code


class TestCompoundFFNStitcher:
    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize("T", [2, 4])
    @pytest.mark.parametrize("is_rmsnorm", [False, True])
    @pytest.mark.parametrize("activation_type", ["gelu", "relu"])
    def test_random_single_beat(
        self, T: int, is_rmsnorm: bool, activation_type: str
    ) -> None:
        """Single beat through Norm -> Activation -> ALU via Stitcher."""
        rng = np.random.default_rng(42)
        x = rng.integers(-50, 50, size=T, dtype=np.int8)
        data_in_b = rng.integers(-50, 50, size=T, dtype=np.int8)

        built_block, drivers, drv_alu_data_in_b, drv_alu_op_code = (
            _create_ffn_chain_stitcher(T, is_rmsnorm, activation_type)
        )

        _disable_memory_sync_check(built_block)
        sim = pyrtl.Simulation(tracer=None, block=built_block)

        inputs = {
            drivers["norm_data_in"]: _pack_bytes(x),
            drivers["norm_valid_in"]: 1,
            drivers["alu_ready_in"]: 1,
            drv_alu_data_in_b: _pack_bytes(data_in_b),
            drv_alu_op_code: OP_ADD,
        }

        sim.step(inputs)
        sim.step(inputs)
        hw_out = _unpack_bytes(sim.inspect(drivers["alu_data_out"].name), T)

        ref_out = _compound_ref(x, data_in_b, is_rmsnorm, activation_type)
        atol = 130 if activation_type == "gelu" else 5
        np.testing.assert_allclose(hw_out, ref_out, atol=atol)

    @pytest.mark.parametrize("T", [2, 4])
    @pytest.mark.parametrize("is_rmsnorm", [False, True])
    @pytest.mark.parametrize("activation_type", ["gelu", "relu"])
    def test_all_zeros(self, T: int, is_rmsnorm: bool, activation_type: str) -> None:
        """All-zeros input must propagate exactly through the Stitcher chain."""
        x = np.zeros(T, dtype=np.int8)
        data_in_b = np.zeros(T, dtype=np.int8)

        built_block, drivers, drv_alu_data_in_b, drv_alu_op_code = (
            _create_ffn_chain_stitcher(T, is_rmsnorm, activation_type)
        )

        _disable_memory_sync_check(built_block)
        sim = pyrtl.Simulation(tracer=None, block=built_block)

        inputs = {
            drivers["norm_data_in"]: _pack_bytes(x),
            drivers["norm_valid_in"]: 1,
            drivers["alu_ready_in"]: 1,
            drv_alu_data_in_b: _pack_bytes(data_in_b),
            drv_alu_op_code: OP_ADD,
        }

        sim.step(inputs)
        sim.step(inputs)
        hw_out = _unpack_bytes(sim.inspect(drivers["alu_data_out"].name), T)

        ref_out = _compound_ref(x, data_in_b, is_rmsnorm, activation_type)
        np.testing.assert_array_equal(hw_out, ref_out)

    @pytest.mark.parametrize("T", [2, 4])
    @pytest.mark.parametrize("is_rmsnorm", [False, True])
    @pytest.mark.parametrize("activation_type", ["gelu", "relu"])
    def test_continuous_stream(
        self, T: int, is_rmsnorm: bool, activation_type: str
    ) -> None:
        """10-beat continuous stream through the FFN Stitcher chain."""
        rng = np.random.default_rng(123)
        beats_x = [rng.integers(-50, 50, size=T, dtype=np.int8) for _ in range(10)]
        beats_b = [rng.integers(-50, 50, size=T, dtype=np.int8) for _ in range(10)]

        built_block, drivers, drv_alu_data_in_b, drv_alu_op_code = (
            _create_ffn_chain_stitcher(T, is_rmsnorm, activation_type)
        )

        _disable_memory_sync_check(built_block)
        sim = pyrtl.Simulation(tracer=None, block=built_block)

        outputs = []
        for x, b in zip(beats_x, beats_b):
            sim.step(
                {
                    drivers["norm_data_in"]: _pack_bytes(x),
                    drivers["norm_valid_in"]: 1,
                    drivers["alu_ready_in"]: 1,
                    drv_alu_data_in_b: _pack_bytes(b),
                    drv_alu_op_code: OP_ADD,
                }
            )
            outputs.append(_unpack_bytes(sim.inspect(drivers["alu_data_out"].name), T))

        sim.step(
            {
                drivers["norm_data_in"]: _pack_bytes(beats_x[-1]),
                drivers["norm_valid_in"]: 1,
                drivers["alu_ready_in"]: 1,
                drv_alu_data_in_b: _pack_bytes(beats_b[-1]),
                drv_alu_op_code: OP_ADD,
            }
        )
        outputs.append(_unpack_bytes(sim.inspect(drivers["alu_data_out"].name), T))

        atol = 130 if activation_type == "gelu" else 5
        for i in range(10):
            ref_out = _compound_ref(beats_x[i], beats_b[i], is_rmsnorm, activation_type)
            np.testing.assert_allclose(outputs[i + 1], ref_out, atol=atol)
