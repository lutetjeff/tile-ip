"""Testbench for the GEMM IP core."""

import numpy as np
import pyrtl
import pytest

from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ip_cores.gemm import GEMMCore
from tests.ref_models.gemm_ref import gemm_ref


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


def _create_wrapped_sim(core: GEMMCore):
    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        data_in = pyrtl.Input(bitwidth=core.data_in.bitwidth, name="wrapper_data_in")
        valid_in = pyrtl.Input(bitwidth=1, name="wrapper_valid_in")
        ready_in = pyrtl.Input(bitwidth=1, name="wrapper_ready_in")
        weight_in = pyrtl.Input(
            bitwidth=core.weight_in.bitwidth, name="wrapper_weight_in"
        )
        weight_valid_in = pyrtl.Input(bitwidth=1, name="wrapper_weight_valid_in")

        data_out = pyrtl.Output(
            bitwidth=core.data_out.bitwidth, name="wrapper_data_out"
        )
        valid_out = pyrtl.Output(bitwidth=1, name="wrapper_valid_out")
        ready_out = pyrtl.Output(bitwidth=1, name="wrapper_ready_out")
        weight_ready_out = pyrtl.Output(bitwidth=1, name="wrapper_weight_ready_out")

        core.data_in <<= data_in
        core.valid_in <<= valid_in
        core.ready_in <<= ready_in
        core.weight_in <<= weight_in
        core.weight_valid_in <<= weight_valid_in
        data_out <<= core.data_out
        valid_out <<= core.valid_out
        ready_out <<= core.ready_out
        weight_ready_out <<= core.weight_ready_out

    sim = pyrtl.Simulation(tracer=None, block=core.block)
    return (
        sim,
        data_in,
        valid_in,
        ready_in,
        weight_in,
        weight_valid_in,
        data_out,
        valid_out,
        ready_out,
        weight_ready_out,
    )


class TestGEMMCore:
    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize("T_M", [1, 2, 4])
    @pytest.mark.parametrize("T_K", [1, 2, 4])
    @pytest.mark.parametrize("T_N", [1, 2, 4])
    def test_random_continuous_stream(self, T_M: int, T_K: int, T_N: int) -> None:
        core = GEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, name="gemm")
        (
            sim,
            data_in,
            valid_in,
            ready_in,
            weight_in,
            weight_valid_in,
            data_out,
            valid_out,
            ready_out,
            weight_ready_out,
        ) = _create_wrapped_sim(core)

        for _ in range(10):
            A = np.random.randint(-50, 50, size=(T_M, T_K), dtype=np.int8)
            B = np.random.randint(-50, 50, size=(T_K, T_N), dtype=np.int8)
            sim.step(
                {
                    data_in: _pack_bytes(A),
                    valid_in: 1,
                    ready_in: 1,
                    weight_in: _pack_bytes(B),
                    weight_valid_in: 1,
                }
            )
            C_hw = _unpack_bytes(sim.inspect(data_out), (T_M, T_N))
            C_ref = gemm_ref(A, B)
            np.testing.assert_array_equal(C_hw, C_ref)

    @pytest.mark.parametrize("T_M", [1, 2, 4])
    @pytest.mark.parametrize("T_K", [1, 2, 4])
    @pytest.mark.parametrize("T_N", [1, 2, 4])
    def test_all_zeros(self, T_M: int, T_K: int, T_N: int) -> None:
        core = GEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, name="gemm")
        (
            sim,
            data_in,
            valid_in,
            ready_in,
            weight_in,
            weight_valid_in,
            data_out,
            valid_out,
            ready_out,
            weight_ready_out,
        ) = _create_wrapped_sim(core)

        A = np.zeros((T_M, T_K), dtype=np.int8)
        B = np.zeros((T_K, T_N), dtype=np.int8)
        sim.step(
            {
                data_in: _pack_bytes(A),
                valid_in: 1,
                ready_in: 1,
                weight_in: _pack_bytes(B),
                weight_valid_in: 1,
            }
        )
        C_hw = _unpack_bytes(sim.inspect(data_out), (T_M, T_N))
        np.testing.assert_array_equal(C_hw, gemm_ref(A, B))

    @pytest.mark.parametrize("T_M", [1, 2, 4])
    @pytest.mark.parametrize("T_K", [1, 2, 4])
    @pytest.mark.parametrize("T_N", [1, 2, 4])
    def test_all_positive_max(self, T_M: int, T_K: int, T_N: int) -> None:
        core = GEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, name="gemm")
        (
            sim,
            data_in,
            valid_in,
            ready_in,
            weight_in,
            weight_valid_in,
            data_out,
            valid_out,
            ready_out,
            weight_ready_out,
        ) = _create_wrapped_sim(core)

        A = np.full((T_M, T_K), 127, dtype=np.int8)
        B = np.full((T_K, T_N), 127, dtype=np.int8)
        sim.step(
            {
                data_in: _pack_bytes(A),
                valid_in: 1,
                ready_in: 1,
                weight_in: _pack_bytes(B),
                weight_valid_in: 1,
            }
        )
        C_hw = _unpack_bytes(sim.inspect(data_out), (T_M, T_N))
        np.testing.assert_array_equal(C_hw, gemm_ref(A, B))

    @pytest.mark.parametrize("T_M", [1, 2, 4])
    @pytest.mark.parametrize("T_K", [1, 2, 4])
    @pytest.mark.parametrize("T_N", [1, 2, 4])
    def test_all_negative_max(self, T_M: int, T_K: int, T_N: int) -> None:
        core = GEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, name="gemm")
        (
            sim,
            data_in,
            valid_in,
            ready_in,
            weight_in,
            weight_valid_in,
            data_out,
            valid_out,
            ready_out,
            weight_ready_out,
        ) = _create_wrapped_sim(core)

        A = np.full((T_M, T_K), -128, dtype=np.int8)
        B = np.full((T_K, T_N), -128, dtype=np.int8)
        sim.step(
            {
                data_in: _pack_bytes(A),
                valid_in: 1,
                ready_in: 1,
                weight_in: _pack_bytes(B),
                weight_valid_in: 1,
            }
        )
        C_hw = _unpack_bytes(sim.inspect(data_out), (T_M, T_N))
        np.testing.assert_array_equal(C_hw, gemm_ref(A, B))

    @pytest.mark.parametrize("T_M", [1, 2, 4])
    @pytest.mark.parametrize("T_K", [1, 2, 4])
    @pytest.mark.parametrize("T_N", [1, 2, 4])
    def test_mixed_signs(self, T_M: int, T_K: int, T_N: int) -> None:
        core = GEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, name="gemm")
        (
            sim,
            data_in,
            valid_in,
            ready_in,
            weight_in,
            weight_valid_in,
            data_out,
            valid_out,
            ready_out,
            weight_ready_out,
        ) = _create_wrapped_sim(core)

        A = np.random.choice(
            [127, -128, 0, 1, -1], size=(T_M, T_K), replace=True
        ).astype(np.int8)
        B = np.random.choice(
            [127, -128, 0, 1, -1], size=(T_K, T_N), replace=True
        ).astype(np.int8)
        sim.step(
            {
                data_in: _pack_bytes(A),
                valid_in: 1,
                ready_in: 1,
                weight_in: _pack_bytes(B),
                weight_valid_in: 1,
            }
        )
        C_hw = _unpack_bytes(sim.inspect(data_out), (T_M, T_N))
        np.testing.assert_array_equal(C_hw, gemm_ref(A, B))

    @pytest.mark.parametrize("T_M", [1, 2, 4])
    @pytest.mark.parametrize("T_K", [1, 2, 4])
    @pytest.mark.parametrize("T_N", [1, 2, 4])
    def test_partial_valid(self, T_M: int, T_K: int, T_N: int) -> None:
        core = GEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, name="gemm")
        (
            sim,
            data_in,
            valid_in,
            ready_in,
            weight_in,
            weight_valid_in,
            data_out,
            valid_out,
            ready_out,
            weight_ready_out,
        ) = _create_wrapped_sim(core)

        A = np.random.randint(-50, 50, size=(T_M, T_K), dtype=np.int8)
        B = np.random.randint(-50, 50, size=(T_K, T_N), dtype=np.int8)

        sim.step(
            {
                data_in: _pack_bytes(A),
                valid_in: 1,
                ready_in: 1,
                weight_in: _pack_bytes(B),
                weight_valid_in: 0,
            }
        )
        assert sim.inspect(valid_out) == 0

        sim.step(
            {
                data_in: _pack_bytes(A),
                valid_in: 0,
                ready_in: 1,
                weight_in: _pack_bytes(B),
                weight_valid_in: 1,
            }
        )
        assert sim.inspect(valid_out) == 0

    def test_invalid_params_raises(self) -> None:
        with pytest.raises(ValueError):
            GEMMCore(T_M=0, T_K=1, T_N=1, name="bad")
        with pytest.raises(ValueError):
            GEMMCore(T_M=1, T_K=0, T_N=1, name="bad")
        with pytest.raises(ValueError):
            GEMMCore(T_M=1, T_K=1, T_N=0, name="bad")

    def test_empty_name_raises(self) -> None:
        with pytest.raises(ValueError):
            GEMMCore(T_M=1, T_K=1, T_N=1, name="")

    def test_average_ii_reported(self) -> None:
        core = GEMMCore(T_M=2, T_K=2, T_N=2, name="gemm")
        assert core.average_ii == 1

    def test_handshake_accepted(self) -> None:
        core = GEMMCore(T_M=2, T_K=2, T_N=2, name="gemm")
        accepted = core.handshake_accepted()
        assert accepted.bitwidth == 1

    def test_stall_pipeline(self) -> None:
        core = GEMMCore(T_M=2, T_K=2, T_N=2, name="gemm")
        stalled = core.stall_pipeline()
        assert stalled.bitwidth == 1
