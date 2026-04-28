"""Testbench for the Temporal GEMM IP core."""

import numpy as np
import pyrtl
import pytest

from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ip_cores.temporal_gemm import TemporalGEMMCore
from ref_models.gemm_ref import gemm_ref


def _pack_bytes(values: np.ndarray) -> int:
    result = 0
    for i, v in enumerate(values.flatten()):
        result |= (int(v) & 0xFF) << (i * 8)
    return result


def _unpack_bytes(value: int, shape: tuple) -> np.ndarray:
    total = int(np.prod(shape))
    flat = np.array(
        [(value >> (i * 8)) & 0xFF for i in range(total)], dtype=np.uint8
    ).astype(np.int8)
    return flat.reshape(shape)


def _create_wrapped_sim(core: TemporalGEMMCore):
    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        data_in = pyrtl.Input(bitwidth=core.data_in.bitwidth, name="wrapper_data_in")
        valid_in = pyrtl.Input(bitwidth=1, name="wrapper_valid_in")
        last_in = pyrtl.Input(bitwidth=1, name="wrapper_last_in")
        ready_in = pyrtl.Input(bitwidth=1, name="wrapper_ready_in")
        accum_in = pyrtl.Input(bitwidth=1, name="wrapper_accum_in")
        emit_in = pyrtl.Input(bitwidth=1, name="wrapper_emit_in")
        weight_in = pyrtl.Input(
            bitwidth=core.weight_in.bitwidth, name="wrapper_weight_in"
        )
        weight_valid_in = pyrtl.Input(bitwidth=1, name="wrapper_weight_valid_in")

        data_out = pyrtl.Output(
            bitwidth=core.data_out.bitwidth, name="wrapper_data_out"
        )
        valid_out = pyrtl.Output(bitwidth=1, name="wrapper_valid_out")
        last_out = pyrtl.Output(bitwidth=1, name="wrapper_last_out")
        ready_out = pyrtl.Output(bitwidth=1, name="wrapper_ready_out")
        weight_ready_out = pyrtl.Output(bitwidth=1, name="wrapper_weight_ready_out")

        core.data_in <<= data_in
        core.valid_in <<= valid_in
        core.last_in <<= last_in
        core.ready_in <<= ready_in
        core.accum_in <<= accum_in
        core.emit_in <<= emit_in
        core.weight_in <<= weight_in
        core.weight_valid_in <<= weight_valid_in
        data_out <<= core.data_out
        valid_out <<= core.valid_out
        last_out <<= core.last_out
        ready_out <<= core.ready_out
        weight_ready_out <<= core.weight_ready_out

    sim = pyrtl.Simulation(tracer=None, block=core.block)
    return (
        sim,
        data_in,
        valid_in,
        last_in,
        ready_in,
        accum_in,
        emit_in,
        weight_in,
        weight_valid_in,
        data_out,
        valid_out,
        last_out,
        ready_out,
        weight_ready_out,
    )


def _temporal_gemm_ref(activations, weights):
    """Reference for temporal GEMM: accumulate partial sums then requantize."""
    accum = np.zeros((activations[0].shape[0], weights[0].shape[1]), dtype=np.int32)
    for A, B in zip(activations, weights):
        A_int32 = A.astype(np.int32)
        B_int32 = B.astype(np.int32)
        accum += np.matmul(A_int32, B_int32)
    requantized = np.right_shift(accum, 8)
    requantized = np.clip(requantized, -128, 127)
    return requantized.astype(np.int8)


class TestTemporalGEMMCore:
    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    def test_four_beats_accumulate_into_one_output(self) -> None:
        T_M, T_K, T_N = 1, 4, 4
        core = TemporalGEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, name="tgemm")
        (
            sim,
            data_in,
            valid_in,
            last_in,
            ready_in,
            accum_in,
            emit_in,
            weight_in,
            weight_valid_in,
            data_out,
            valid_out,
            last_out,
            ready_out,
            weight_ready_out,
        ) = _create_wrapped_sim(core)

        activations = []
        weights = []
        for _ in range(4):
            A = np.random.randint(-50, 50, size=(T_M, T_K), dtype=np.int8)
            B = np.random.randint(-50, 50, size=(T_K, T_N), dtype=np.int8)
            activations.append(A)
            weights.append(B)

        for beat, (A, B) in enumerate(zip(activations, weights)):
            is_last = 1 if beat == 3 else 0
            sim.step(
                {
                    data_in: _pack_bytes(A),
                    valid_in: 1,
                    last_in: is_last,
                    ready_in: 1,
                    accum_in: 1,
                    emit_in: 0,
                    weight_in: _pack_bytes(B),
                    weight_valid_in: 1,
                }
            )

        sim.step(
            {
                data_in: 0,
                valid_in: 0,
                last_in: 0,
                ready_in: 1,
                accum_in: 0,
                emit_in: 0,
                weight_in: 0,
                weight_valid_in: 0,
            }
        )

        assert sim.inspect(ready_out) == 0
        assert sim.inspect(valid_out) == 1
        assert sim.inspect(last_out) == 1

        C_hw = _unpack_bytes(sim.inspect(data_out), (T_M, T_N))
        C_ref = _temporal_gemm_ref(activations, weights)
        np.testing.assert_array_equal(C_hw, C_ref)

    def test_ready_out_low_during_emit(self) -> None:
        T_M, T_K, T_N = 1, 2, 2
        core = TemporalGEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, name="tgemm")
        (
            sim,
            data_in,
            valid_in,
            last_in,
            ready_in,
            accum_in,
            emit_in,
            weight_in,
            weight_valid_in,
            data_out,
            valid_out,
            last_out,
            ready_out,
            weight_ready_out,
        ) = _create_wrapped_sim(core)

        A = np.random.randint(-50, 50, size=(T_M, T_K), dtype=np.int8)
        B = np.random.randint(-50, 50, size=(T_K, T_N), dtype=np.int8)

        sim.step(
            {
                data_in: _pack_bytes(A),
                valid_in: 1,
                last_in: 1,
                ready_in: 1,
                accum_in: 1,
                emit_in: 0,
                weight_in: _pack_bytes(B),
                weight_valid_in: 1,
            }
        )

        sim.step(
            {
                data_in: 0,
                valid_in: 0,
                last_in: 0,
                ready_in: 1,
                accum_in: 0,
                emit_in: 0,
                weight_in: 0,
                weight_valid_in: 0,
            }
        )

        assert sim.inspect(ready_out) == 0
        assert sim.inspect(weight_ready_out) == 0
        assert sim.inspect(valid_out) == 1

    def test_emit_in_triggers_output(self) -> None:
        T_M, T_K, T_N = 2, 2, 2
        core = TemporalGEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, name="tgemm")
        (
            sim,
            data_in,
            valid_in,
            last_in,
            ready_in,
            accum_in,
            emit_in,
            weight_in,
            weight_valid_in,
            data_out,
            valid_out,
            last_out,
            ready_out,
            weight_ready_out,
        ) = _create_wrapped_sim(core)

        A = np.random.randint(-50, 50, size=(T_M, T_K), dtype=np.int8)
        B = np.random.randint(-50, 50, size=(T_K, T_N), dtype=np.int8)

        sim.step(
            {
                data_in: _pack_bytes(A),
                valid_in: 1,
                last_in: 0,
                ready_in: 1,
                accum_in: 1,
                emit_in: 1,
                weight_in: _pack_bytes(B),
                weight_valid_in: 1,
            }
        )

        sim.step(
            {
                data_in: 0,
                valid_in: 0,
                last_in: 0,
                ready_in: 1,
                accum_in: 0,
                emit_in: 0,
                weight_in: 0,
                weight_valid_in: 0,
            }
        )

        assert sim.inspect(valid_out) == 1
        assert sim.inspect(ready_out) == 0

        C_hw = _unpack_bytes(sim.inspect(data_out), (T_M, T_N))
        C_ref = gemm_ref(A, B)
        np.testing.assert_array_equal(C_hw, C_ref)

    def test_accum_in_low_overwrites(self) -> None:
        T_M, T_K, T_N = 1, 2, 2
        core = TemporalGEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, name="tgemm")
        (
            sim,
            data_in,
            valid_in,
            last_in,
            ready_in,
            accum_in,
            emit_in,
            weight_in,
            weight_valid_in,
            data_out,
            valid_out,
            last_out,
            ready_out,
            weight_ready_out,
        ) = _create_wrapped_sim(core)

        A0 = np.array([[1, 2]], dtype=np.int8)
        B0 = np.array([[3, 4], [5, 6]], dtype=np.int8)

        A1 = np.array([[10, 20]], dtype=np.int8)
        B1 = np.array([[30, 40], [50, 60]], dtype=np.int8)

        sim.step(
            {
                data_in: _pack_bytes(A0),
                valid_in: 1,
                last_in: 0,
                ready_in: 1,
                accum_in: 0,
                emit_in: 0,
                weight_in: _pack_bytes(B0),
                weight_valid_in: 1,
            }
        )

        sim.step(
            {
                data_in: _pack_bytes(A1),
                valid_in: 1,
                last_in: 1,
                ready_in: 1,
                accum_in: 0,
                emit_in: 0,
                weight_in: _pack_bytes(B1),
                weight_valid_in: 1,
            }
        )

        sim.step(
            {
                data_in: 0,
                valid_in: 0,
                last_in: 0,
                ready_in: 1,
                accum_in: 0,
                emit_in: 0,
                weight_in: 0,
                weight_valid_in: 0,
            }
        )

        C_hw = _unpack_bytes(sim.inspect(data_out), (T_M, T_N))
        C_ref = gemm_ref(A1, B1)
        np.testing.assert_array_equal(C_hw, C_ref)

    def test_emit_with_backpressure(self) -> None:
        T_M, T_K, T_N = 1, 2, 2
        core = TemporalGEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, name="tgemm")
        (
            sim,
            data_in,
            valid_in,
            last_in,
            ready_in,
            accum_in,
            emit_in,
            weight_in,
            weight_valid_in,
            data_out,
            valid_out,
            last_out,
            ready_out,
            weight_ready_out,
        ) = _create_wrapped_sim(core)

        A = np.random.randint(-50, 50, size=(T_M, T_K), dtype=np.int8)
        B = np.random.randint(-50, 50, size=(T_K, T_N), dtype=np.int8)

        sim.step(
            {
                data_in: _pack_bytes(A),
                valid_in: 1,
                last_in: 1,
                ready_in: 0,
                accum_in: 1,
                emit_in: 0,
                weight_in: _pack_bytes(B),
                weight_valid_in: 1,
            }
        )

        sim.step(
            {
                data_in: 0,
                valid_in: 0,
                last_in: 0,
                ready_in: 0,
                accum_in: 0,
                emit_in: 0,
                weight_in: 0,
                weight_valid_in: 0,
            }
        )

        assert sim.inspect(valid_out) == 1
        assert sim.inspect(ready_out) == 0

        sim.step(
            {
                data_in: 0,
                valid_in: 0,
                last_in: 0,
                ready_in: 1,
                accum_in: 0,
                emit_in: 0,
                weight_in: 0,
                weight_valid_in: 0,
            }
        )

        assert sim.inspect(valid_out) == 1
        assert sim.inspect(ready_out) == 0

        sim.step(
            {
                data_in: 0,
                valid_in: 0,
                last_in: 0,
                ready_in: 1,
                accum_in: 0,
                emit_in: 0,
                weight_in: 0,
                weight_valid_in: 0,
            }
        )

        assert sim.inspect(valid_out) == 0
        assert sim.inspect(ready_out) == 1

    def test_invalid_params_raises(self) -> None:
        with pytest.raises(ValueError):
            TemporalGEMMCore(T_M=0, T_K=1, T_N=1, name="bad")
        with pytest.raises(ValueError):
            TemporalGEMMCore(T_M=1, T_K=0, T_N=1, name="bad")
        with pytest.raises(ValueError):
            TemporalGEMMCore(T_M=1, T_K=1, T_N=0, name="bad")

    def test_empty_name_raises(self) -> None:
        with pytest.raises(ValueError):
            TemporalGEMMCore(T_M=1, T_K=1, T_N=1, name="")

    def test_average_ii_reported(self) -> None:
        core = TemporalGEMMCore(T_M=2, T_K=2, T_N=2, name="tgemm")
        assert core.average_ii == 1

    def test_handshake_accepted(self) -> None:
        core = TemporalGEMMCore(T_M=2, T_K=2, T_N=2, name="tgemm")
        accepted = core.handshake_accepted()
        assert accepted.bitwidth == 1

    def test_stall_pipeline(self) -> None:
        core = TemporalGEMMCore(T_M=2, T_K=2, T_N=2, name="tgemm")
        stalled = core.stall_pipeline()
        assert stalled.bitwidth == 1
