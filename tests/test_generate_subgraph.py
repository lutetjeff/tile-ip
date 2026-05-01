"""End-to-end tests for generate_subgraph.py CLI.

Verify JSON spec -> TilingSolver -> code generation -> dynamic import ->
PyRTL simulation against NumPy reference models.
"""

from __future__ import annotations

import importlib.util
import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path

import numpy as np
import pyrtl
import pytest

from ip_cores.axi_stream_base import AXI4StreamLiteBase
from tests.ref_models.activation_ref import relu_ref
from tests.ref_models.alu_ref import alu_ref, OP_ADD
from tests.ref_models.gemm_ref import gemm_ref
from tests.ref_models.norm_ref import norm_ref
from tests.ref_models.softmax_ref import softmax_ref


FFN_SPEC = {
    "name": "ffn",
    "ips": [
        {"type": "Norm", "name": "norm", "params": ["T_channel"]},
        {"type": "Activation", "name": "act", "params": ["T_width"]},
        {"type": "ALU", "name": "alu", "params": ["T_width"]},
    ],
    "edges": [["norm", "act"], ["act", "alu"]],
    "constraints": {"max_area": 5000},
}

ATTENTION_SPEC = {
    "name": "attention",
    "ips": [
        {"type": "GEMM", "name": "gemm_qk", "params": ["T_M", "T_K", "T_N"]},
        {"type": "Softmax", "name": "softmax", "params": ["T_seq"]},
        {"type": "GEMM", "name": "gemm_sv", "params": ["T_M", "T_K", "T_N"]},
    ],
    "edges": [["gemm_qk", "softmax"], ["softmax", "gemm_sv"]],
    "constraints": {"max_area": 10000},
}


def _pack_bytes(values: np.ndarray) -> int:
    val = 0
    for i, b in enumerate(values.flatten()):
        val |= (int(b) & 0xFF) << (i * 8)
    return val


def _unpack_bytes(value: int, shape: tuple) -> np.ndarray:
    total = int(np.prod(shape))
    flat = np.array(
        [(value >> (i * 8)) & 0xFF for i in range(total)], dtype=np.uint8
    ).astype(np.int8)
    return flat.reshape(shape)


def _run_cli(
    spec_path: Path, out_path: Path | None = None
) -> subprocess.CompletedProcess:
    cmd = [sys.executable, "scripts/generate_subgraph.py", "--spec", str(spec_path)]
    if out_path:
        cmd.extend(["--out", str(out_path)])
    return subprocess.run(
        cmd, capture_output=True, text=True, cwd=Path(__file__).resolve().parent.parent
    )


def _load_generated_module(module_path: Path, module_name: str):
    spec = importlib.util.spec_from_file_location(module_name, module_path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[module_name] = module
    spec.loader.exec_module(module)
    return module


def _disable_memory_sync_check(block):
    block.sanity_check_memory_sync = lambda wire_src_dict=None: None


class TestGenerateSubgraphFFN:
    def setup_method(self):
        AXI4StreamLiteBase.reset()

    def test_ffn_json_to_simulation(self, tmp_path: Path) -> None:
        spec_file = tmp_path / "ffn.json"
        out_file = tmp_path / "ffn_generated.py"
        with spec_file.open("w") as f:
            json.dump(FFN_SPEC, f)

        result = _run_cli(spec_file, out_file)
        assert result.returncode == 0, result.stderr
        assert out_file.exists()

        module = _load_generated_module(out_file, "ffn_generated")
        block, drivers = module.build_ffn()
        cfg = module.CONFIG

        T = cfg["norm"]["T_channel"]
        rng = np.random.default_rng(42)
        x = rng.integers(-50, 50, size=T, dtype=np.int8)
        data_in_b = rng.integers(-50, 50, size=T, dtype=np.int8)

        with pyrtl.set_working_block(block, no_sanity_check=True):
            drv_alu_data_in_b = pyrtl.Input(bitwidth=T * 8, name="drv_alu_data_in_b")
            for ip in block.wirevector_set:
                if ip.name == "alu_data_in_b":
                    alu_data_in_b = ip
            alu_data_in_b <<= drv_alu_data_in_b

        _disable_memory_sync_check(block)
        sim = pyrtl.Simulation(tracer=None, block=block)

        inputs = {
            drivers["norm_data_in"]: _pack_bytes(x),
            drivers["norm_valid_in"]: 1,
            drivers["alu_ready_in"]: 1,
            drv_alu_data_in_b: _pack_bytes(data_in_b),
        }
        sim.step(inputs)
        sim.step(inputs)
        hw_out = _unpack_bytes(sim.inspect(drivers["alu_data_out"].name), (T,))

        ref_norm = norm_ref(
            x, np.ones(T, dtype=np.int8), np.zeros(T, dtype=np.int8), False
        )
        ref_act = relu_ref(ref_norm)
        ref_out = alu_ref(ref_act, data_in_b, OP_ADD)
        np.testing.assert_allclose(hw_out, ref_out, atol=5)


class TestGenerateSubgraphAttention:
    def setup_method(self):
        AXI4StreamLiteBase.reset()

    def test_attention_json_to_simulation(self, tmp_path: Path) -> None:
        spec_file = tmp_path / "attention.json"
        out_file = tmp_path / "attention_generated.py"
        with spec_file.open("w") as f:
            json.dump(ATTENTION_SPEC, f)

        result = _run_cli(spec_file, out_file)
        assert result.returncode == 0, result.stderr
        assert out_file.exists()

        module = _load_generated_module(out_file, "attention_generated")
        block, drivers = module.build_attention()
        cfg = module.CONFIG

        T = cfg["gemm_qk"]["T_M"]
        np.random.seed(42)
        Q = np.random.randint(-50, 50, size=(T, T), dtype=np.int8)
        K = np.random.randint(-50, 50, size=(T, T), dtype=np.int8)
        V = np.random.randint(-50, 50, size=(T, T), dtype=np.int8)

        with pyrtl.set_working_block(block, no_sanity_check=True):
            k_in = pyrtl.Input(bitwidth=T * T * 8, name="k_in")
            k_valid = pyrtl.Input(bitwidth=1, name="k_valid")
            v_in = pyrtl.Input(bitwidth=T * T * 8, name="v_in")
            v_valid = pyrtl.Input(bitwidth=1, name="v_valid")
            for ip in block.wirevector_set:
                if ip.name == "gemm_qk_weight_in":
                    gemm_qk_weight_in = ip
                if ip.name == "gemm_qk_weight_valid_in":
                    gemm_qk_weight_valid_in = ip
                if ip.name == "gemm_sv_weight_in":
                    gemm_sv_weight_in = ip
                if ip.name == "gemm_sv_weight_valid_in":
                    gemm_sv_weight_valid_in = ip
            gemm_qk_weight_in <<= k_in
            gemm_qk_weight_valid_in <<= k_valid
            gemm_sv_weight_in <<= v_in
            gemm_sv_weight_valid_in <<= v_valid

        sim = pyrtl.Simulation(tracer=None, block=block)

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

        scores_ref = gemm_ref(Q, K.T)
        qk_hw = _unpack_bytes(sim.inspect("gemm_qk_data_out"), (T, T))
        np.testing.assert_array_equal(qk_hw, scores_ref)

        softmax_ref_out = softmax_ref(scores_ref.flatten())
        sm_hw = _unpack_bytes(sim.inspect("softmax_data_out"), (T, T))
        np.testing.assert_allclose(
            sm_hw.flatten().astype(np.int16),
            softmax_ref_out.astype(np.int16),
            atol=1,
        )

        final_ref = gemm_ref(softmax_ref_out.reshape(T, T), V)
        final_hw = _unpack_bytes(sim.inspect(drivers["gemm_sv_data_out"].name), (T, T))
        np.testing.assert_array_equal(final_hw, final_ref)
        assert sim.inspect(drivers["gemm_sv_valid_out"].name) == 1


class TestGenerateSubgraphCLI:
    def test_stdout_mode(self, tmp_path: Path) -> None:
        spec_file = tmp_path / "ffn.json"
        with spec_file.open("w") as f:
            json.dump(FFN_SPEC, f)

        result = _run_cli(spec_file)
        assert result.returncode == 0, result.stderr
        assert "def build_ffn()" in result.stdout
        assert "import pyrtl" in result.stdout
        assert "Stitcher" in result.stdout

    def test_invalid_json(self, tmp_path: Path) -> None:
        spec_file = tmp_path / "bad.json"
        with spec_file.open("w") as f:
            f.write("{not valid json")

        result = _run_cli(spec_file)
        assert result.returncode != 0
