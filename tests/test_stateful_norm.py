"""Testbench for the Stateful Normalization IP core (multi-beat LayerNorm / RMSNorm)."""

from __future__ import annotations

import math

import numpy as np
import pyrtl
import pytest

from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ip_cores.stateful_norm import StatefulNormCore


def _pack_bytes(x: np.ndarray) -> int:
    val = 0
    for i, b in enumerate(x):
        val |= (int(b) & 0xFF) << (i * 8)
    return val


def _unpack_bytes(val: int, T: int) -> np.ndarray:
    out = []
    for i in range(T):
        b = (val >> (i * 8)) & 0xFF
        if b >= 128:
            b -= 256
        out.append(b)
    return np.array(out, dtype=np.int8)


def _build_lut() -> dict[int, int]:
    eps = 1e-5
    lut: dict[int, int] = {}
    for addr in range(256):
        if addr < 16:
            real_var = (addr << 4) + 8
        else:
            real_var = ((addr - 16) << 8) + 128
        val = 1.0 / math.sqrt(real_var + eps)
        scaled = round(val * 256)
        scaled = max(1, min(scaled, 65535))
        lut[addr] = scaled
    return lut


_LUT = _build_lut()


def _ref_stateful_norm(x: np.ndarray, is_rmsnorm: bool, gamma: int = 1, beta: int = 0) -> np.ndarray:
    x_f = x.astype(np.float32)
    mean_x = np.mean(x_f)
    mean_x2 = np.mean(x_f**2)
    variance = mean_x2 - mean_x**2

    if variance < 256:
        addr = int(variance) >> 4
    else:
        addr = 16 + (int(variance) >> 8)
        addr = min(addr, 255)

    inv_sqrt = _LUT[addr] / 256.0

    if is_rmsnorm:
        normalized = x_f * inv_sqrt
    else:
        normalized = (x_f - mean_x) * inv_sqrt

    norm_trunc = np.floor(normalized)
    scaled = norm_trunc * gamma + beta
    scaled_int32 = scaled.astype(np.int32)
    wrapped = (scaled_int32 & 0xFF).astype(np.int8)
    return wrapped


def _create_wrapped_sim(core: StatefulNormCore):
    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        data_in = pyrtl.Input(bitwidth=core.data_in.bitwidth, name="wrapper_data_in")
        valid_in = pyrtl.Input(bitwidth=1, name="wrapper_valid_in")
        ready_in = pyrtl.Input(bitwidth=1, name="wrapper_ready_in")

        core.data_in <<= data_in
        core.valid_in <<= valid_in
        core.ready_in <<= ready_in

    sim = pyrtl.Simulation(tracer=None, block=core.block)
    return sim, data_in, valid_in, ready_in


def _send_beats_handshake(sim, data_in, valid_in, ready_in, beats, ready_out_name):
    beat_idx = 0
    while beat_idx < len(beats):
        sim.step(
            {
                data_in: _pack_bytes(beats[beat_idx]),
                valid_in: 1,
                ready_in: 1,
            }
        )
        if sim.inspect(ready_out_name) == 1:
            beat_idx += 1


def _drain_output_handshake(sim, data_in, valid_in, ready_in, num_beats, valid_out_name, data_out_name, T_channel):
    hw_out = []
    cycles = 0
    max_cycles = num_beats * 10
    while len(hw_out) < num_beats and cycles < max_cycles:
        sim.step({data_in: 0, valid_in: 0, ready_in: 1})
        if sim.inspect(valid_out_name) == 1:
            hw_out.append(_unpack_bytes(sim.inspect(data_out_name), T_channel))
        cycles += 1
    return hw_out


def test_stateful_norm_interface_widths() -> None:
    for T in [1, 2, 4]:
        pyrtl.reset_working_block()
        ip = StatefulNormCore(T_channel=T, N_channel=8, name=f"sn{T}")
        assert ip.data_in.bitwidth == T * 8
        assert ip.data_out.bitwidth == T * 8
        assert ip.valid_in.bitwidth == 1
        assert ip.ready_out.bitwidth == 1


def test_stateful_norm_invalid_tiling() -> None:
    with pytest.raises(ValueError):
        StatefulNormCore(T_channel=3, N_channel=8, name="bad")
    with pytest.raises(ValueError):
        StatefulNormCore(T_channel=0, N_channel=8, name="bad")
    with pytest.raises(ValueError):
        StatefulNormCore(T_channel=2, N_channel=3, name="bad")
    with pytest.raises(ValueError):
        StatefulNormCore(T_channel=2, N_channel=6, name="bad")


@pytest.mark.parametrize("T_channel", [1, 2, 4])
def test_stateful_norm_pipeline_timing(T_channel: int) -> None:
    pyrtl.reset_working_block()
    N_channel = 8
    num_beats = N_channel // T_channel
    ip = StatefulNormCore(T_channel=T_channel, N_channel=N_channel, name="sn")
    sim, data_in, valid_in, ready_in = _create_wrapped_sim(ip)

    rng = np.random.default_rng(42)
    beats = [rng.integers(-80, 80, size=(T_channel,), dtype=np.int8) for _ in range(num_beats)]

    _send_beats_handshake(sim, data_in, valid_in, ready_in, beats, ip.ready_out.name)

    for i in range(num_beats):
        sim.step(
            {
                data_in: 0,
                valid_in: 0,
                ready_in: 1,
            }
        )
        assert sim.inspect(ip.valid_out.name) == 1, f"output beat {i}: valid_out should be 1"
        assert sim.inspect(ip.ready_out.name) == 1, f"output beat {i}: ready_out should be 1 (II=1)"

    sim.step(
        {
            data_in: 0,
            valid_in: 0,
            ready_in: 1,
        }
    )
    assert sim.inspect(ip.ready_out.name) == 1, "after packet: ready_out should be 1"
    assert sim.inspect(ip.valid_out.name) == 0, "after packet: valid_out should be 0"


@pytest.mark.parametrize("T_channel", [1, 2, 4])
def test_stateful_norm_backpressure(T_channel: int) -> None:
    pyrtl.reset_working_block()
    N_channel = 8
    num_beats = N_channel // T_channel
    ip = StatefulNormCore(T_channel=T_channel, N_channel=N_channel, name="sn")
    sim, data_in, valid_in, ready_in = _create_wrapped_sim(ip)

    beats = [
        np.full(T_channel, (i + 1) * 10, dtype=np.int8) for i in range(num_beats)
    ]

    _send_beats_handshake(sim, data_in, valid_in, ready_in, beats, ip.ready_out.name)

    sim.step({data_in: 0, valid_in: 0, ready_in: 0})
    assert sim.inspect(ip.valid_out.name) == 1
    out0 = _unpack_bytes(sim.inspect(ip.data_out.name), T_channel)

    sim.step({data_in: 0, valid_in: 0, ready_in: 0})
    assert sim.inspect(ip.valid_out.name) == 1
    out0_again = _unpack_bytes(sim.inspect(ip.data_out.name), T_channel)
    np.testing.assert_array_equal(out0, out0_again)

    sim.step({data_in: 0, valid_in: 0, ready_in: 1})
    out_before = _unpack_bytes(sim.inspect(ip.data_out.name), T_channel)
    np.testing.assert_array_equal(out0, out_before)

    if num_beats > 1:
        sim.step({data_in: 0, valid_in: 0, ready_in: 1})
        out1 = _unpack_bytes(sim.inspect(ip.data_out.name), T_channel)
        assert not np.array_equal(out0, out1)


@pytest.mark.parametrize("T_channel", [1, 2, 4])
def test_stateful_norm_ii1_back_to_back(T_channel: int) -> None:
    pyrtl.reset_working_block()
    N_channel = 8
    num_beats = N_channel // T_channel
    ip = StatefulNormCore(T_channel=T_channel, N_channel=N_channel, name="sn")
    sim, data_in, valid_in, ready_in = _create_wrapped_sim(ip)

    rng = np.random.default_rng(123)
    packet1_beats = [rng.integers(-80, 80, size=(T_channel,), dtype=np.int8) for _ in range(num_beats)]
    packet2_beats = [rng.integers(-80, 80, size=(T_channel,), dtype=np.int8) for _ in range(num_beats)]
    x1 = np.concatenate(packet1_beats).astype(np.int8)
    x2 = np.concatenate(packet2_beats).astype(np.int8)

    _send_beats_handshake(sim, data_in, valid_in, ready_in, packet1_beats, ip.ready_out.name)

    hw1 = []
    beat_idx = 0
    while beat_idx < num_beats:
        sim.step(
            {
                data_in: _pack_bytes(packet2_beats[beat_idx]),
                valid_in: 1,
                ready_in: 1,
            }
        )
        if sim.inspect(ip.valid_out.name) == 1:
            hw1.append(_unpack_bytes(sim.inspect(ip.data_out.name), T_channel))
        if sim.inspect(ip.ready_out.name) == 1:
            beat_idx += 1

    hw2 = _drain_output_handshake(sim, data_in, valid_in, ready_in, num_beats, ip.valid_out.name, ip.data_out.name, T_channel)

    sim.step({data_in: 0, valid_in: 0, ready_in: 1})
    assert sim.inspect(ip.valid_out.name) == 0

    hw1_arr = np.concatenate(hw1).astype(np.int8)
    hw2_arr = np.concatenate(hw2).astype(np.int8)
    ref1 = _ref_stateful_norm(x1, is_rmsnorm=False)
    ref2 = _ref_stateful_norm(x2, is_rmsnorm=False)

    np.testing.assert_allclose(hw1_arr, ref1, atol=1)
    np.testing.assert_allclose(hw2_arr, ref2, atol=1)


@pytest.mark.parametrize("T_channel", [1, 2, 4])
@pytest.mark.parametrize("is_rmsnorm", [False, True])
def test_stateful_norm_random_packet(T_channel: int, is_rmsnorm: bool) -> None:
    pyrtl.reset_working_block()
    N_channel = 8
    num_beats = N_channel // T_channel
    ip = StatefulNormCore(T_channel=T_channel, N_channel=N_channel, name="sn", is_rmsnorm=is_rmsnorm)
    sim, data_in, valid_in, ready_in = _create_wrapped_sim(ip)

    rng = np.random.default_rng(42)
    beats = [rng.integers(-80, 80, size=(T_channel,), dtype=np.int8) for _ in range(num_beats)]
    x = np.concatenate(beats).astype(np.int8)

    _send_beats_handshake(sim, data_in, valid_in, ready_in, beats, ip.ready_out.name)

    hw_out = _drain_output_handshake(sim, data_in, valid_in, ready_in, num_beats, ip.valid_out.name, ip.data_out.name, T_channel)

    hw = np.concatenate(hw_out).astype(np.int8)
    ref = _ref_stateful_norm(x, is_rmsnorm)

    np.testing.assert_allclose(hw, ref, atol=1)


@pytest.mark.parametrize("T_channel", [1, 2, 4])
@pytest.mark.parametrize("is_rmsnorm", [False, True])
def test_stateful_norm_two_packets(T_channel: int, is_rmsnorm: bool) -> None:
    pyrtl.reset_working_block()
    N_channel = 8
    num_beats = N_channel // T_channel
    ip = StatefulNormCore(T_channel=T_channel, N_channel=N_channel, name="sn", is_rmsnorm=is_rmsnorm)
    sim, data_in, valid_in, ready_in = _create_wrapped_sim(ip)

    rng = np.random.default_rng(123)
    packet1_beats = [rng.integers(-80, 80, size=(T_channel,), dtype=np.int8) for _ in range(num_beats)]
    packet2_beats = [rng.integers(-80, 80, size=(T_channel,), dtype=np.int8) for _ in range(num_beats)]
    x1 = np.concatenate(packet1_beats).astype(np.int8)
    x2 = np.concatenate(packet2_beats).astype(np.int8)

    _send_beats_handshake(sim, data_in, valid_in, ready_in, packet1_beats, ip.ready_out.name)

    hw1 = []
    beat_idx = 0
    while beat_idx < num_beats:
        sim.step(
            {
                data_in: _pack_bytes(packet2_beats[beat_idx]),
                valid_in: 1,
                ready_in: 1,
            }
        )
        if sim.inspect(ip.valid_out.name) == 1:
            hw1.append(_unpack_bytes(sim.inspect(ip.data_out.name), T_channel))
        if sim.inspect(ip.ready_out.name) == 1:
            beat_idx += 1

    hw2 = _drain_output_handshake(sim, data_in, valid_in, ready_in, num_beats, ip.valid_out.name, ip.data_out.name, T_channel)

    hw1_arr = np.concatenate(hw1).astype(np.int8)
    hw2_arr = np.concatenate(hw2).astype(np.int8)
    ref1 = _ref_stateful_norm(x1, is_rmsnorm)
    ref2 = _ref_stateful_norm(x2, is_rmsnorm)

    np.testing.assert_allclose(hw1_arr, ref1, atol=1)
    np.testing.assert_allclose(hw2_arr, ref2, atol=1)


@pytest.mark.parametrize("T_channel", [1, 2, 4])
def test_stateful_norm_all_zeros(T_channel: int) -> None:
    pyrtl.reset_working_block()
    N_channel = 8
    num_beats = N_channel // T_channel
    ip = StatefulNormCore(T_channel=T_channel, N_channel=N_channel, name="sn")
    sim, data_in, valid_in, ready_in = _create_wrapped_sim(ip)

    beats = [np.zeros(T_channel, dtype=np.int8) for _ in range(num_beats)]

    _send_beats_handshake(sim, data_in, valid_in, ready_in, beats, ip.ready_out.name)

    for _ in range(num_beats):
        sim.step({data_in: 0, valid_in: 0, ready_in: 1})
        out = _unpack_bytes(sim.inspect(ip.data_out.name), T_channel)
        np.testing.assert_array_equal(out, np.zeros(T_channel, dtype=np.int8))


@pytest.mark.parametrize("T_channel", [1, 2, 4])
def test_stateful_norm_all_same_layernorm(T_channel: int) -> None:
    pyrtl.reset_working_block()
    N_channel = 8
    num_beats = N_channel // T_channel
    ip = StatefulNormCore(T_channel=T_channel, N_channel=N_channel, name="sn", is_rmsnorm=False)
    sim, data_in, valid_in, ready_in = _create_wrapped_sim(ip)

    beats = [np.full(T_channel, 50, dtype=np.int8) for _ in range(num_beats)]

    _send_beats_handshake(sim, data_in, valid_in, ready_in, beats, ip.ready_out.name)

    for _ in range(num_beats):
        sim.step({data_in: 0, valid_in: 0, ready_in: 1})
        out = _unpack_bytes(sim.inspect(ip.data_out.name), T_channel)
        np.testing.assert_array_equal(out, np.zeros(T_channel, dtype=np.int8))


@pytest.mark.parametrize("T_channel", [1, 2, 4])
def test_stateful_norm_max_contrast(T_channel: int) -> None:
    pyrtl.reset_working_block()
    N_channel = 8
    num_beats = N_channel // T_channel

    raw = np.array([127, -128] * (N_channel // 2), dtype=np.int8)
    beats = [raw[i * T_channel : (i + 1) * T_channel] for i in range(num_beats)]

    for is_rmsnorm in [False, True]:
        pyrtl.reset_working_block()
        ip = StatefulNormCore(
            T_channel=T_channel, N_channel=N_channel, name="sn", is_rmsnorm=is_rmsnorm
        )
        sim, data_in, valid_in, ready_in = _create_wrapped_sim(ip)

        _send_beats_handshake(sim, data_in, valid_in, ready_in, beats, ip.ready_out.name)

        hw_out = _drain_output_handshake(sim, data_in, valid_in, ready_in, num_beats, ip.valid_out.name, ip.data_out.name, T_channel)

        hw = np.concatenate(hw_out).astype(np.int8)
        assert np.all(hw[raw < 0] < 0)
        assert np.all(hw[raw > 0] >= 0)
