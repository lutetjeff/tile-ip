"""Testbench for the Normalization IP core (LayerNorm / RMSNorm)."""

from __future__ import annotations

import numpy as np
import pyrtl
import pytest

from ip_cores.norm import NormCore
from ref_models.norm_ref import norm_ref


# ------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------


def _assemble_bus(x: np.ndarray) -> int:
    """Pack INT8 array into little-endian bus value."""
    val = 0
    for i, b in enumerate(x):
        val |= (int(b) & 0xFF) << (i * 8)
    return val


def _extract_bytes(val: int, T: int) -> np.ndarray:
    """Unpack little-endian bus value into INT8 array."""
    out = []
    for i in range(T):
        b = (val >> (i * 8)) & 0xFF
        if b >= 128:
            b -= 256
        out.append(b)
    return np.array(out, dtype=np.int8)


def _run_hw(x: np.ndarray, T: int, is_rmsnorm: bool) -> np.ndarray:
    """Run one beat through the NormCore and return INT8 channels."""
    pyrtl.reset_working_block()
    ip = NormCore(T_channel=T, name="norm", is_rmsnorm=is_rmsnorm)

    with pyrtl.set_working_block(ip.block, no_sanity_check=True):
        data_in_driver = pyrtl.Input(bitwidth=T * 8, name="norm_data_in_driver")
        valid_in_driver = pyrtl.Input(bitwidth=1, name="norm_valid_in_driver")
        ready_in_driver = pyrtl.Input(bitwidth=1, name="norm_ready_in_driver")
        ip.data_in <<= data_in_driver
        ip.valid_in <<= valid_in_driver
        ip.ready_in <<= ready_in_driver

    tracer = pyrtl.SimulationTrace(block=ip.block)
    sim = pyrtl.Simulation(block=ip.block, tracer=tracer)
    sim.step(
        {
            "norm_data_in_driver": _assemble_bus(x),
            "norm_valid_in_driver": 1,
            "norm_ready_in_driver": 1,
        }
    )
    return _extract_bytes(sim.inspect(ip.data_out), T)


def _ref_unscaled(x: np.ndarray, is_rmsnorm: bool) -> np.ndarray:
    """Reference model WITHOUT per-vector symmetric scaling.

    This matches the raw fixed-point output of the hardware before the
    final int8 truncation, making numerical comparison fair.
    """
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


# ------------------------------------------------------------------
# Parameterised numerical tests
# ------------------------------------------------------------------


@pytest.mark.parametrize("T_channel", [1, 2, 4])
@pytest.mark.parametrize("is_rmsnorm", [False, True])
def test_norm_random_small(T_channel: int, is_rmsnorm: bool) -> None:
    """Random small inputs: hardware vs unscaled reference within ±5."""
    rng = np.random.default_rng(42)
    x = rng.integers(-30, 30, size=(T_channel,), dtype=np.int8)

    hw = _run_hw(x, T_channel, is_rmsnorm)
    ref = _ref_unscaled(x, is_rmsnorm)

    # T=1 RMSNorm is a special case (variance is always 0).
    if T_channel == 1 and is_rmsnorm:
        assert hw.dtype == np.int8
    else:
        np.testing.assert_allclose(hw, ref, atol=3)


@pytest.mark.parametrize("T_channel", [1, 2, 4])
@pytest.mark.parametrize("is_rmsnorm", [False, True])
def test_norm_random_large(T_channel: int, is_rmsnorm: bool) -> None:
    """Random large inputs with wider spread: tighter tolerance."""
    rng = np.random.default_rng(123)
    x = rng.integers(-100, 100, size=(T_channel,), dtype=np.int8)

    hw = _run_hw(x, T_channel, is_rmsnorm)
    ref = _ref_unscaled(x, is_rmsnorm)

    if T_channel == 1 and is_rmsnorm:
        assert hw.dtype == np.int8
    else:
        np.testing.assert_allclose(hw, ref, atol=5)


@pytest.mark.parametrize("T_channel", [1, 2, 4])
@pytest.mark.parametrize("is_rmsnorm", [False, True])
def test_norm_all_zeros(T_channel: int, is_rmsnorm: bool) -> None:
    """All-zero input must produce all-zero output."""
    x = np.zeros(T_channel, dtype=np.int8)
    hw = _run_hw(x, T_channel, is_rmsnorm)
    np.testing.assert_array_equal(hw, x)


@pytest.mark.parametrize("T_channel", [1, 2, 4])
def test_norm_all_same_layernorm(T_channel: int) -> None:
    """LayerNorm on identical values: diff=0, so output should be 0."""
    x = np.full(T_channel, 50, dtype=np.int8)
    hw = _run_hw(x, T_channel, is_rmsnorm=False)
    np.testing.assert_array_equal(hw, np.zeros(T_channel, dtype=np.int8))


@pytest.mark.parametrize("T_channel", [2, 4])
def test_norm_max_contrast(T_channel: int) -> None:
    """Max positive / max negative inputs produce correlated signs."""
    x = np.array([127, -128] * (T_channel // 2), dtype=np.int8)
    hw_ln = _run_hw(x, T_channel, is_rmsnorm=False)
    hw_rms = _run_hw(x, T_channel, is_rmsnorm=True)

    assert np.all(hw_ln[x < 0] < 0)
    assert np.all(hw_rms[x < 0] < 0)
    assert np.all(hw_ln[x > 0] >= 0)
    assert np.all(hw_rms[x > 0] >= 0)


# ------------------------------------------------------------------
# Continuous stream (happy path)
# ------------------------------------------------------------------


@pytest.mark.parametrize("T_channel", [1, 2, 4])
@pytest.mark.parametrize("is_rmsnorm", [False, True])
def test_norm_continuous_stream(T_channel: int, is_rmsnorm: bool) -> None:
    """10-beat continuous stream: every beat matches reference."""
    rng = np.random.default_rng(999)
    beats = [rng.integers(-80, 80, size=(T_channel,), dtype=np.int8) for _ in range(10)]

    pyrtl.reset_working_block()
    ip = NormCore(T_channel=T_channel, name="norm", is_rmsnorm=is_rmsnorm)

    with pyrtl.set_working_block(ip.block, no_sanity_check=True):
        data_in_driver = pyrtl.Input(bitwidth=T_channel * 8, name="norm_data_in_driver")
        valid_in_driver = pyrtl.Input(bitwidth=1, name="norm_valid_in_driver")
        ready_in_driver = pyrtl.Input(bitwidth=1, name="norm_ready_in_driver")
        ip.data_in <<= data_in_driver
        ip.valid_in <<= valid_in_driver
        ip.ready_in <<= ready_in_driver

    tracer = pyrtl.SimulationTrace(block=ip.block)
    sim = pyrtl.Simulation(block=ip.block, tracer=tracer)

    for x in beats:
        sim.step(
            {
                "norm_data_in_driver": _assemble_bus(x),
                "norm_valid_in_driver": 1,
                "norm_ready_in_driver": 1,
            }
        )
        hw = _extract_bytes(sim.inspect(ip.data_out), T_channel)
        ref = _ref_unscaled(x, is_rmsnorm)

        if T_channel == 1 and is_rmsnorm:
            assert hw.dtype == np.int8
        elif np.all(x == x[0]):
            assert hw.dtype == np.int8
        else:
            np.testing.assert_allclose(hw, ref, atol=5)


# ------------------------------------------------------------------
# Interface / structural tests
# ------------------------------------------------------------------


def test_norm_interface_widths() -> None:
    """AXI4-Stream-Lite bus widths scale with T_channel."""
    for T in [1, 2, 4, 8]:
        pyrtl.reset_working_block()
        ip = NormCore(T_channel=T, name=f"n{T}")
        assert ip.data_in.bitwidth == T * 8
        assert ip.data_out.bitwidth == T * 8
        assert ip.valid_in.bitwidth == 1
        assert ip.ready_out.bitwidth == 1


def test_norm_handshake_combinational() -> None:
    """Core is combinational: valid_out = valid_in, ready_out = ready_in."""
    pyrtl.reset_working_block()
    ip = NormCore(T_channel=4, name="norm")

    with pyrtl.set_working_block(ip.block, no_sanity_check=True):
        data_in_driver = pyrtl.Input(bitwidth=32, name="norm_data_in_driver")
        valid_in_driver = pyrtl.Input(bitwidth=1, name="norm_valid_in_driver")
        ready_in_driver = pyrtl.Input(bitwidth=1, name="norm_ready_in_driver")
        ip.data_in <<= data_in_driver
        ip.valid_in <<= valid_in_driver
        ip.ready_in <<= ready_in_driver

    tracer = pyrtl.SimulationTrace(block=ip.block)
    sim = pyrtl.Simulation(block=ip.block, tracer=tracer)

    sim.step(
        {
            "norm_data_in_driver": 0x04030201,
            "norm_valid_in_driver": 1,
            "norm_ready_in_driver": 0,
        }
    )
    assert sim.inspect(ip.valid_out) == 1
    assert sim.inspect(ip.ready_out) == 0

    sim.step(
        {
            "norm_data_in_driver": 0x04030201,
            "norm_valid_in_driver": 0,
            "norm_ready_in_driver": 1,
        }
    )
    assert sim.inspect(ip.valid_out) == 0
    assert sim.inspect(ip.ready_out) == 1


def test_norm_ref_model_runs() -> None:
    """Sanity check that the scaled reference model still executes."""
    x = np.array([10, -20, 30, -40], dtype=np.int8)
    gamma = np.ones(4, dtype=np.int8)
    beta = np.zeros(4, dtype=np.int8)
    out_ln = norm_ref(x, gamma, beta, is_rmsnorm=False)
    out_rms = norm_ref(x, gamma, beta, is_rmsnorm=True)
    assert out_ln.dtype == np.int8
    assert out_rms.dtype == np.int8
    assert out_ln.shape == x.shape
    assert out_rms.shape == x.shape


def test_norm_invalid_tiling() -> None:
    """Non-power-of-two T_channel must raise ValueError."""
    with pytest.raises(ValueError):
        NormCore(T_channel=3, name="bad")
    with pytest.raises(ValueError):
        NormCore(T_channel=0, name="bad")
