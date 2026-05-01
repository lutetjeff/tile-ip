"""Tests for the branch-and-bound autotuner.

Coverage:
1. CharacterizationDB lookup (actual + estimated).
2. Autotuner finds valid configs for FFN, Attention, Mem->Compute.
3. Utilization pruning with tiny FPGA constraints.
4. Latency pruning (large tile factors on ALU trigger failed timing).
5. Top-N designs are sorted by latency ascending.
6. Transformer-block Verilog output.
"""

from __future__ import annotations

import os
import tempfile

import pytest

from autotuner import Autotuner, CharacterizationDB


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

TRANSFORMER_BLOCK_SPEC = {
    "ips": [
        {"type": "FIFO", "name": "fifo1", "params": [], "kwargs": {"T_width": 2, "depth": 8}},
        {"type": "StatefulNorm", "name": "norm1", "params": [], "kwargs": {"T_channel": 2, "N_channel": 16}},
        {"type": "TemporalGEMM", "name": "tgemm1", "params": [], "kwargs": {"T_M": 1, "T_K": 2, "T_N": 2, "M": 16, "N": 16}},
        {"type": "StatefulSoftmax", "name": "softmax", "params": [], "kwargs": {"N_seq": 16, "T_seq": 2}},
        {"type": "ALU", "name": "alu1", "params": [], "kwargs": {"T_width": 2, "op_mode": "add"}},
    ],
    "edges": [
        ("fifo1", "norm1"),
        ("norm1", "tgemm1"),
        ("tgemm1", "softmax"),
        ("softmax", "alu1"),
    ],
    "constraints": {
        "fpga": {"LUT": 35200, "FF": 17600, "DSP": 80, "BRAM": 90}
    },
}


class TestCharacterizationDB:
    def test_alu_actual_data(self) -> None:
        db = CharacterizationDB()
        r1 = db.lookup("ALU", {"T_width": 1})
        assert r1["LUT"] == 109
        assert r1["FF"] == 9
        assert r1["power_w"] == pytest.approx(0.07)
        assert r1["wns_ns"] == pytest.approx(7.827)

        r2 = db.lookup("ALU", {"T_width": 2})
        assert r2["LUT"] == 217
        assert r2["FF"] == 17
        assert r2["power_w"] == pytest.approx(0.071)
        assert r2["wns_ns"] == pytest.approx(8.136)

    def test_alu_extrapolation(self) -> None:
        db = CharacterizationDB()
        r4 = db.lookup("ALU", {"T_width": 4})
        assert r4["LUT"] == 433
        assert r4["FF"] == 33
        assert r4["wns_ns"] > r2["wns_ns"] if (r2 := db.lookup("ALU", {"T_width": 2})) else False

    def test_temporal_gemm_estimate(self) -> None:
        db = CharacterizationDB()
        r = db.lookup("TemporalGEMM", {"T_M": 2, "T_K": 2, "T_N": 2})
        assert r["LUT"] == 2 * 2 * 2 * 200
        assert r["FF"] == 2 * 2 * 16
        assert r["DSP"] == (2 * 2 * 2) // 4
        assert r["wns_ns"] == 8.0
        assert r["clock_period_ns"] == 10.0

    def test_stateful_norm_estimate(self) -> None:
        db = CharacterizationDB()
        r = db.lookup("StatefulNorm", {"T_channel": 4, "N_channel": 16})
        assert r["LUT"] == 4 * 80 + 16 * 2
        assert r["FF"] == 4 * 16
        assert r["wns_ns"] == 8.0

    def test_fifo_estimate(self) -> None:
        db = CharacterizationDB()
        r = db.lookup("FIFO", {"T_width": 2, "depth": 8})
        assert r["LUT"] == 8 * 2 + 2 * 4
        assert r["FF"] == 8 * 2 * 8 + 16
        assert r["power_w"] == pytest.approx(0.028)


class TestAutotunerBasic:
    def test_finds_valid_ffn(self) -> None:
        tuner = Autotuner(FFN_SUBGRAPH)
        designs = tuner.run()
        assert len(designs) > 0
        lat, cfg, _ = designs[0]
        assert "norm" in cfg
        assert "act" in cfg
        assert "alu" in cfg
        assert lat > 0

    def test_finds_valid_attention(self) -> None:
        tuner = Autotuner(ATTENTION_SUBGRAPH)
        designs = tuner.run()
        assert len(designs) > 0
        lat, cfg, _ = designs[0]
        assert "gemm_qk" in cfg
        assert "softmax" in cfg
        assert "gemm_sv" in cfg
        assert lat > 0

    def test_finds_valid_mem_compute(self) -> None:
        tuner = Autotuner(MEM_COMPUTE_SUBGRAPH)
        designs = tuner.run()
        assert len(designs) > 0
        lat, cfg, _ = designs[0]
        assert "mr" in cfg
        assert "gemm" in cfg
        assert lat > 0


class TestAutotunerPruning:
    def test_prunes_by_utilization(self) -> None:
        spec = {
            "ips": [{"type": "ALU", "name": "alu", "params": ["T_width"]}],
            "edges": [],
            "constraints": {"fpga": {"LUT": 200, "FF": 17600, "DSP": 80, "BRAM": 90}},
        }
        tuner = Autotuner(spec)
        designs = tuner.run()
        assert len(designs) == 1
        _, cfg, _ = designs[0]
        assert cfg["alu"]["T_width"] == 1

    def test_prunes_by_latency(self) -> None:
        spec = {
            "ips": [{"type": "ALU", "name": "alu", "params": ["T_width"]}],
            "edges": [],
            "constraints": {"fpga": {"LUT": 35200, "FF": 17600, "DSP": 80, "BRAM": 90}},
        }
        tuner = Autotuner(spec)
        designs = tuner.run()
        configs = [cfg for _, cfg, _ in designs]
        t_widths = {cfg["alu"]["T_width"] for cfg in configs}
        assert 16 not in t_widths
        assert len(designs) < 5


class TestAutotunerTopN:
    def test_top_n_sorted_by_latency(self) -> None:
        tuner = Autotuner(FFN_SUBGRAPH, top_n=3)
        designs = tuner.run()
        assert len(designs) <= 3
        for i in range(1, len(designs)):
            assert designs[i - 1][0] <= designs[i][0]

    def test_top_n_bounded(self) -> None:
        tuner = Autotuner(FFN_SUBGRAPH, top_n=2)
        designs = tuner.run()
        assert len(designs) <= 2


class TestAutotunerVerilog:
    def test_outputs_verilog_for_transformer_block(self) -> None:
        tuner = Autotuner(TRANSFORMER_BLOCK_SPEC, top_n=3)
        with tempfile.TemporaryDirectory() as tmpdir:
            designs = tuner.run(output_dir=tmpdir)
            files = [f for f in os.listdir(tmpdir) if f.endswith(".v")]
            assert len(files) > 0
            for f in files:
                path = os.path.join(tmpdir, f)
                assert os.path.getsize(path) > 0

    def test_output_verilog_single_design(self) -> None:
        spec = {"ips": [{"type": "Norm", "name": "norm", "params": ["T_channel"]}], "edges": []}
        tuner = Autotuner(spec, top_n=2)
        designs = tuner.run()
        with tempfile.TemporaryDirectory() as tmpdir:
            path = tuner.output_verilog(designs[0], tmpdir, rank=0)
            assert path is not None
            assert os.path.exists(path)
            assert os.path.getsize(path) > 0
