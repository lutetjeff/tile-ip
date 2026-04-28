"""Tests for TilingSolver.

Verify brute-force search finds optimal tiling configurations for FFN,
Attention, and Mem->Compute subgraphs within timing and area constraints.
"""

from __future__ import annotations

import time

import pytest

from solver import TilingSolver


FFN_SUBGRAPH = {
    "ips": [
        {"type": "Norm", "name": "norm", "params": ["T_channel"]},
        {"type": "Activation", "name": "act", "params": ["T_width"]},
        {"type": "ALU", "name": "alu", "params": ["T_width"]},
    ],
    "edges": [("norm", "act"), ("act", "alu")],
}

ATTENTION_SUBGRAPH = {
    "ips": [
        {"type": "GEMM", "name": "gemm_qk", "params": ["T_M", "T_K", "T_N"]},
        {"type": "Softmax", "name": "softmax", "params": ["T_seq"]},
        {"type": "GEMM", "name": "gemm_sv", "params": ["T_M", "T_K", "T_N"]},
    ],
    "edges": [("gemm_qk", "softmax"), ("softmax", "gemm_sv")],
}

MEM_COMPUTE_SUBGRAPH = {
    "ips": [
        {"type": "MemRouter", "name": "mr", "params": ["T_out"]},
        {"type": "GEMM", "name": "gemm", "params": ["T_M", "T_K", "T_N"]},
    ],
    "edges": [("mr", "gemm")],
}


class TestSolverFFN:
    def test_finds_optimal_config(self) -> None:
        solver = TilingSolver(max_path_depth=20)
        result = solver.solve(FFN_SUBGRAPH)

        assert "norm" in result
        assert "act" in result
        assert "alu" in result
        assert result["norm"]["T_channel"] in {1, 2, 4}
        assert result["act"]["T_width"] in {1, 2, 4}
        assert result["alu"]["T_width"] in {1, 2, 4}

    def test_timing_constraint_prunes_large(self) -> None:
        solver = TilingSolver(max_path_depth=1)
        with pytest.raises(ValueError, match="No valid tiling configuration"):
            solver.solve(FFN_SUBGRAPH)

    def test_area_constraint_filters(self) -> None:
        solver = TilingSolver(max_path_depth=20)
        constrained = {
            **FFN_SUBGRAPH,
            "constraints": {"max_area": 1},
        }
        with pytest.raises(ValueError, match="No valid tiling configuration"):
            solver.solve(constrained)

    def test_solves_within_one_second(self) -> None:
        solver = TilingSolver(max_path_depth=20)
        start = time.time()
        result = solver.solve(FFN_SUBGRAPH)
        elapsed = time.time() - start
        assert elapsed < 1.0
        assert result is not None


class TestSolverAttention:
    def test_finds_optimal_config(self) -> None:
        solver = TilingSolver(max_path_depth=20)
        result = solver.solve(ATTENTION_SUBGRAPH)

        assert "gemm_qk" in result
        assert "softmax" in result
        assert "gemm_sv" in result
        for param in ("T_M", "T_K", "T_N"):
            assert result["gemm_qk"][param] in {1, 2, 4}
            assert result["gemm_sv"][param] in {1, 2, 4}
        assert result["softmax"]["T_seq"] in {1, 2, 4}

    def test_timing_constraint_prunes_large(self) -> None:
        solver = TilingSolver(max_path_depth=1)
        with pytest.raises(ValueError, match="No valid tiling configuration"):
            solver.solve(ATTENTION_SUBGRAPH)

    def test_solves_within_one_second(self) -> None:
        solver = TilingSolver(max_path_depth=20)
        start = time.time()
        result = solver.solve(ATTENTION_SUBGRAPH)
        elapsed = time.time() - start
        assert elapsed < 1.0
        assert result is not None


class TestSolverMemCompute:
    def test_finds_optimal_config(self) -> None:
        solver = TilingSolver(max_path_depth=20)
        result = solver.solve(MEM_COMPUTE_SUBGRAPH)

        assert "mr" in result
        assert "gemm" in result
        assert result["mr"]["T_out"] in {1, 2, 4}
        for param in ("T_M", "T_K", "T_N"):
            assert result["gemm"][param] in {1, 2, 4}

    def test_timing_constraint_prunes_large(self) -> None:
        solver = TilingSolver(max_path_depth=1)
        with pytest.raises(ValueError, match="No valid tiling configuration"):
            solver.solve(MEM_COMPUTE_SUBGRAPH)

    def test_solves_within_one_second(self) -> None:
        solver = TilingSolver(max_path_depth=20)
        start = time.time()
        result = solver.solve(MEM_COMPUTE_SUBGRAPH)
        elapsed = time.time() - start
        assert elapsed < 1.0
        assert result is not None


class TestSolverDefaultConstraints:
    def test_default_max_path_depth_allows_all(self) -> None:
        solver = TilingSolver()
        result = solver.solve(FFN_SUBGRAPH)
        assert result is not None

    def test_no_area_constraint_allows_large(self) -> None:
        solver = TilingSolver(max_path_depth=20)
        result = solver.solve(ATTENTION_SUBGRAPH)
        assert result is not None


class TestSolverPerformance:
    def test_all_three_subgraphs_under_one_second(self) -> None:
        solver = TilingSolver(max_path_depth=20)
        start = time.time()
        solver.solve(FFN_SUBGRAPH)
        solver.solve(ATTENTION_SUBGRAPH)
        solver.solve(MEM_COMPUTE_SUBGRAPH)
        elapsed = time.time() - start
        assert elapsed < 1.0
