"""Compound attention subgraph test: GEMM (Q*K^T) -> Softmax -> GEMM (Scores*V).

Wires three IP cores (two GEMMCore instances and one SoftmaxCore) in a single
shared PyRTL block and verifies the end-to-end attention datapath against a
chained NumPy reference model.
"""

from __future__ import annotations

import numpy as np
import pyrtl
import pytest

from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ip_cores.gemm import GEMMCore
from ip_cores.softmax import SoftmaxCore
from ref_models.gemm_ref import gemm_ref
from ref_models.softmax_ref import softmax_ref
from stitcher import Stitcher


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


class TestCompoundAttention:
    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize("T", [2])
    def test_attention_chain_random(self, T: int) -> None:
        shared_block = pyrtl.Block()

        gemm_qk = GEMMCore(T_M=T, T_K=T, T_N=T, name="gemm_qk", block=shared_block)
        softmax = SoftmaxCore(T_seq=T * T, name="softmax", block=shared_block)
        gemm_sv = GEMMCore(T_M=T, T_K=T, T_N=T, name="gemm_sv", block=shared_block)

        with pyrtl.set_working_block(shared_block, no_sanity_check=True):
            q_in = pyrtl.Input(bitwidth=gemm_qk.data_in.bitwidth, name="q_in")
            q_valid = pyrtl.Input(bitwidth=1, name="q_valid")
            q_ready = pyrtl.Input(bitwidth=1, name="q_ready")
            k_in = pyrtl.Input(bitwidth=gemm_qk.weight_in.bitwidth, name="k_in")
            k_valid = pyrtl.Input(bitwidth=1, name="k_valid")
            v_in = pyrtl.Input(bitwidth=gemm_sv.weight_in.bitwidth, name="v_in")
            v_valid = pyrtl.Input(bitwidth=1, name="v_valid")
            sv_ready = pyrtl.Input(bitwidth=1, name="sv_ready")

            final_data_out = pyrtl.Output(
                gemm_sv.data_out.bitwidth, name="final_data_out_probe"
            )
            final_valid_out = pyrtl.Output(1, name="final_valid_out_probe")

            gemm_qk.data_in <<= q_in
            gemm_qk.valid_in <<= q_valid
            gemm_qk.ready_in <<= q_ready
            gemm_qk.weight_in <<= k_in
            gemm_qk.weight_valid_in <<= k_valid

            softmax.data_in <<= gemm_qk.data_out
            softmax.valid_in <<= gemm_qk.valid_out
            softmax.ready_in <<= gemm_sv.ready_out

            gemm_sv.data_in <<= softmax.data_out
            gemm_sv.valid_in <<= softmax.valid_out
            gemm_sv.ready_in <<= sv_ready
            gemm_sv.weight_in <<= v_in
            gemm_sv.weight_valid_in <<= v_valid

            final_data_out <<= gemm_sv.data_out
            final_valid_out <<= gemm_sv.valid_out

        np.random.seed(42)
        Q = np.random.randint(-50, 50, size=(T, T), dtype=np.int8)
        K = np.random.randint(-50, 50, size=(T, T), dtype=np.int8)
        V = np.random.randint(-50, 50, size=(T, T), dtype=np.int8)

        scores_ref = gemm_ref(Q, K.T)
        softmax_ref_out = softmax_ref(scores_ref.flatten())
        softmax_ref_2d = softmax_ref_out.reshape(T, T)
        final_ref = gemm_ref(softmax_ref_2d, V)

        sim = pyrtl.Simulation(tracer=None, block=shared_block)

        sim.step(
            {
                q_in: _pack_bytes(Q),
                q_valid: 1,
                q_ready: 1,
                k_in: _pack_bytes(K.T),
                k_valid: 1,
                sv_ready: 1,
                v_in: _pack_bytes(V),
                v_valid: 1,
            }
        )

        qk_hw = _unpack_bytes(sim.inspect("gemm_qk_data_out"), (T, T))
        np.testing.assert_array_equal(qk_hw, scores_ref)

        sm_hw = _unpack_bytes(sim.inspect("softmax_data_out"), (T, T))
        np.testing.assert_allclose(
            sm_hw.flatten().astype(np.int16),
            softmax_ref_out.astype(np.int16),
            atol=1,
        )

        final_hw = _unpack_bytes(sim.inspect("final_data_out_probe"), (T, T))
        np.testing.assert_array_equal(final_hw, final_ref)
        assert sim.inspect("final_valid_out_probe") == 1

    @pytest.mark.parametrize("T", [2])
    def test_attention_chain_all_zeros(self, T: int) -> None:
        shared_block = pyrtl.Block()

        gemm_qk = GEMMCore(T_M=T, T_K=T, T_N=T, name="gemm_qk", block=shared_block)
        softmax = SoftmaxCore(T_seq=T * T, name="softmax", block=shared_block)
        gemm_sv = GEMMCore(T_M=T, T_K=T, T_N=T, name="gemm_sv", block=shared_block)

        with pyrtl.set_working_block(shared_block, no_sanity_check=True):
            q_in = pyrtl.Input(bitwidth=gemm_qk.data_in.bitwidth, name="q_in")
            q_valid = pyrtl.Input(bitwidth=1, name="q_valid")
            q_ready = pyrtl.Input(bitwidth=1, name="q_ready")
            k_in = pyrtl.Input(bitwidth=gemm_qk.weight_in.bitwidth, name="k_in")
            k_valid = pyrtl.Input(bitwidth=1, name="k_valid")
            v_in = pyrtl.Input(bitwidth=gemm_sv.weight_in.bitwidth, name="v_in")
            v_valid = pyrtl.Input(bitwidth=1, name="v_valid")
            sv_ready = pyrtl.Input(bitwidth=1, name="sv_ready")

            final_data_out = pyrtl.Output(
                gemm_sv.data_out.bitwidth, name="final_data_out_probe"
            )
            final_valid_out = pyrtl.Output(1, name="final_valid_out_probe")

            gemm_qk.data_in <<= q_in
            gemm_qk.valid_in <<= q_valid
            gemm_qk.ready_in <<= q_ready
            gemm_qk.weight_in <<= k_in
            gemm_qk.weight_valid_in <<= k_valid

            softmax.data_in <<= gemm_qk.data_out
            softmax.valid_in <<= gemm_qk.valid_out
            softmax.ready_in <<= gemm_sv.ready_out

            gemm_sv.data_in <<= softmax.data_out
            gemm_sv.valid_in <<= softmax.valid_out
            gemm_sv.ready_in <<= sv_ready
            gemm_sv.weight_in <<= v_in
            gemm_sv.weight_valid_in <<= v_valid

            final_data_out <<= gemm_sv.data_out
            final_valid_out <<= gemm_sv.valid_out

        Q = np.zeros((T, T), dtype=np.int8)
        K = np.zeros((T, T), dtype=np.int8)
        V = np.zeros((T, T), dtype=np.int8)

        scores_ref = gemm_ref(Q, K.T)
        softmax_ref_out = softmax_ref(scores_ref.flatten())
        softmax_ref_2d = softmax_ref_out.reshape(T, T)
        final_ref = gemm_ref(softmax_ref_2d, V)

        sim = pyrtl.Simulation(tracer=None, block=shared_block)

        sim.step(
            {
                q_in: _pack_bytes(Q),
                q_valid: 1,
                q_ready: 1,
                k_in: _pack_bytes(K.T),
                k_valid: 1,
                sv_ready: 1,
                v_in: _pack_bytes(V),
                v_valid: 1,
            }
        )

        qk_hw = _unpack_bytes(sim.inspect("gemm_qk_data_out"), (T, T))
        np.testing.assert_array_equal(qk_hw, scores_ref)

        sm_hw = _unpack_bytes(sim.inspect("softmax_data_out"), (T, T))
        np.testing.assert_allclose(
            sm_hw.flatten().astype(np.int16),
            softmax_ref_out.astype(np.int16),
            atol=1,
        )

        final_hw = _unpack_bytes(sim.inspect("final_data_out_probe"), (T, T))
        np.testing.assert_array_equal(final_hw, final_ref)
        assert sim.inspect("final_valid_out_probe") == 1


class TestCompoundAttentionStitcher:
    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize("T", [2])
    def test_attention_chain_random(self, T: int) -> None:
        shared_block = pyrtl.Block()

        gemm_qk = GEMMCore(T_M=T, T_K=T, T_N=T, name="gemm_qk", block=shared_block)
        softmax = SoftmaxCore(T_seq=T * T, name="softmax", block=shared_block)
        gemm_sv = GEMMCore(T_M=T, T_K=T, T_N=T, name="gemm_sv", block=shared_block)

        stitcher = Stitcher(block=shared_block)
        stitcher.add_ip(gemm_qk)
        stitcher.add_ip(softmax)
        stitcher.add_ip(gemm_sv)
        stitcher.connect("gemm_qk", "softmax")
        stitcher.connect("softmax", "gemm_sv")
        built_block, drivers = stitcher.build()

        with pyrtl.set_working_block(built_block, no_sanity_check=True):
            k_in = pyrtl.Input(bitwidth=gemm_qk.weight_in.bitwidth, name="k_in")
            k_valid = pyrtl.Input(bitwidth=1, name="k_valid")
            v_in = pyrtl.Input(bitwidth=gemm_sv.weight_in.bitwidth, name="v_in")
            v_valid = pyrtl.Input(bitwidth=1, name="v_valid")

            gemm_qk.weight_in <<= k_in
            gemm_qk.weight_valid_in <<= k_valid
            gemm_sv.weight_in <<= v_in
            gemm_sv.weight_valid_in <<= v_valid

        np.random.seed(42)
        Q = np.random.randint(-50, 50, size=(T, T), dtype=np.int8)
        K = np.random.randint(-50, 50, size=(T, T), dtype=np.int8)
        V = np.random.randint(-50, 50, size=(T, T), dtype=np.int8)

        scores_ref = gemm_ref(Q, K.T)
        softmax_ref_out = softmax_ref(scores_ref.flatten())
        softmax_ref_2d = softmax_ref_out.reshape(T, T)
        final_ref = gemm_ref(softmax_ref_2d, V)

        sim = pyrtl.Simulation(tracer=None, block=built_block)

        sim.step(
            {
                drivers["gemm_qk_data_in"]: _pack_bytes(Q),
                drivers["gemm_qk_valid_in"]: 1,
                drivers["gemm_sv_ready_in"]: 1,
                k_in: _pack_bytes(K.T),
                k_valid: 1,
                v_in: _pack_bytes(V),
                v_valid: 1,
            }
        )

        qk_hw = _unpack_bytes(sim.inspect("gemm_qk_data_out"), (T, T))
        np.testing.assert_array_equal(qk_hw, scores_ref)

        sm_hw = _unpack_bytes(sim.inspect("softmax_data_out"), (T, T))
        np.testing.assert_allclose(
            sm_hw.flatten().astype(np.int16),
            softmax_ref_out.astype(np.int16),
            atol=1,
        )

        final_hw = _unpack_bytes(sim.inspect(drivers["gemm_sv_data_out"].name), (T, T))
        np.testing.assert_array_equal(final_hw, final_ref)
        assert sim.inspect(drivers["gemm_sv_valid_out"].name) == 1

    @pytest.mark.parametrize("T", [2])
    def test_attention_chain_all_zeros(self, T: int) -> None:
        shared_block = pyrtl.Block()

        gemm_qk = GEMMCore(T_M=T, T_K=T, T_N=T, name="gemm_qk", block=shared_block)
        softmax = SoftmaxCore(T_seq=T * T, name="softmax", block=shared_block)
        gemm_sv = GEMMCore(T_M=T, T_K=T, T_N=T, name="gemm_sv", block=shared_block)

        stitcher = Stitcher(block=shared_block)
        stitcher.add_ip(gemm_qk)
        stitcher.add_ip(softmax)
        stitcher.add_ip(gemm_sv)
        stitcher.connect("gemm_qk", "softmax")
        stitcher.connect("softmax", "gemm_sv")
        built_block, drivers = stitcher.build()

        with pyrtl.set_working_block(built_block, no_sanity_check=True):
            k_in = pyrtl.Input(bitwidth=gemm_qk.weight_in.bitwidth, name="k_in")
            k_valid = pyrtl.Input(bitwidth=1, name="k_valid")
            v_in = pyrtl.Input(bitwidth=gemm_sv.weight_in.bitwidth, name="v_in")
            v_valid = pyrtl.Input(bitwidth=1, name="v_valid")

            gemm_qk.weight_in <<= k_in
            gemm_qk.weight_valid_in <<= k_valid
            gemm_sv.weight_in <<= v_in
            gemm_sv.weight_valid_in <<= v_valid

        Q = np.zeros((T, T), dtype=np.int8)
        K = np.zeros((T, T), dtype=np.int8)
        V = np.zeros((T, T), dtype=np.int8)

        scores_ref = gemm_ref(Q, K.T)
        softmax_ref_out = softmax_ref(scores_ref.flatten())
        softmax_ref_2d = softmax_ref_out.reshape(T, T)
        final_ref = gemm_ref(softmax_ref_2d, V)

        sim = pyrtl.Simulation(tracer=None, block=built_block)

        sim.step(
            {
                drivers["gemm_qk_data_in"]: _pack_bytes(Q),
                drivers["gemm_qk_valid_in"]: 1,
                drivers["gemm_sv_ready_in"]: 1,
                k_in: _pack_bytes(K.T),
                k_valid: 1,
                v_in: _pack_bytes(V),
                v_valid: 1,
            }
        )

        qk_hw = _unpack_bytes(sim.inspect("gemm_qk_data_out"), (T, T))
        np.testing.assert_array_equal(qk_hw, scores_ref)

        sm_hw = _unpack_bytes(sim.inspect("softmax_data_out"), (T, T))
        np.testing.assert_allclose(
            sm_hw.flatten().astype(np.int16),
            softmax_ref_out.astype(np.int16),
            atol=1,
        )

        final_hw = _unpack_bytes(sim.inspect(drivers["gemm_sv_data_out"].name), (T, T))
        np.testing.assert_array_equal(final_hw, final_ref)
        assert sim.inspect(drivers["gemm_sv_valid_out"].name) == 1
