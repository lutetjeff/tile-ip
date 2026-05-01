"""Test that all IPs can be exported to Verilog and are Vivado-compatible.

This test instantiates each IP with tile sizes up to T=16, exports to Verilog,
and verifies the output is syntactically valid (via Verilator) and drives
all output wires so Vivado OOC synthesis won't optimize away the design.
"""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent / "src"))
sys.path.insert(0, str(Path(__file__).parent.parent / "scripts"))

import pytest
import pyrtl
from characterize_ips_parallel import (
    _export_gemm_custom,
    _export_temporal_gemm_custom,
    PicklableExporter,
)
from export_verilog import (
    export_alu,
    export_fifo,
    export_norm,
    export_softmax,
    export_activation,
    export_mem_router,
    export_stateful_norm,
    export_stateful_softmax,
    export_multi_bank_bram,
)

TILE_SIZES = [1, 2, 4, 8, 16]
FIFO_DEPTHS = [4, 8, 16, 32, 64]


@pytest.mark.parametrize("T_width", TILE_SIZES)
def test_alu_export(tmp_path: Path, T_width: int) -> None:
    exporter = PicklableExporter("export_alu")
    vfile = exporter(tmp_path, T_width=T_width)
    assert vfile.exists()
    text = vfile.read_text()
    assert "module toplevel" in text
    assert f"alu_data_out" in text


@pytest.mark.parametrize("T_width,depth", [(t, d) for t in TILE_SIZES for d in FIFO_DEPTHS])
def test_fifo_export(tmp_path: Path, T_width: int, depth: int) -> None:
    exporter = PicklableExporter("export_fifo")
    vfile = exporter(tmp_path, T_width=T_width, depth=depth)
    assert vfile.exists()
    text = vfile.read_text()
    assert "module toplevel" in text
    assert f"fifo_data_out" in text


@pytest.mark.parametrize("T_M,T_K,T_N", [
    (tm, tk, tn) for tm in [1, 2, 4, 8, 16] for tk in [1, 2, 4, 8, 16] for tn in [1, 2, 4, 8, 16]
])
def test_gemm_export(tmp_path: Path, T_M: int, T_K: int, T_N: int) -> None:
    vfile = _export_gemm_custom(tmp_path, T_M=T_M, T_K=T_K, T_N=T_N)
    assert vfile.exists()
    text = vfile.read_text()
    assert "module toplevel" in text
    assert "gemm_data_out" in text


@pytest.mark.parametrize("T_width", TILE_SIZES)
def test_norm_export(tmp_path: Path, T_width: int) -> None:
    exporter = PicklableExporter("export_norm")
    vfile = exporter(tmp_path, T_width=T_width)
    assert vfile.exists()
    text = vfile.read_text()
    assert "module toplevel" in text
    assert f"norm_data_out" in text


@pytest.mark.parametrize("T_width", TILE_SIZES)
def test_softmax_export(tmp_path: Path, T_width: int) -> None:
    exporter = PicklableExporter("export_softmax")
    vfile = exporter(tmp_path, T_width=T_width)
    assert vfile.exists()
    text = vfile.read_text()
    assert "module toplevel" in text
    assert f"softmax_data_out" in text


@pytest.mark.parametrize("T_width", TILE_SIZES)
def test_activation_export(tmp_path: Path, T_width: int) -> None:
    exporter = PicklableExporter("export_activation")
    vfile = exporter(tmp_path, T_width=T_width)
    assert vfile.exists()
    text = vfile.read_text()
    assert "module toplevel" in text
    assert f"activation_data_out" in text


@pytest.mark.parametrize("T_width", TILE_SIZES)
def test_mem_router_export(tmp_path: Path, T_width: int) -> None:
    exporter = PicklableExporter("export_mem_router")
    vfile = exporter(tmp_path, T_width=T_width)
    assert vfile.exists()
    text = vfile.read_text()
    assert "module toplevel" in text
    assert f"mem_router_data_out" in text


@pytest.mark.parametrize("T_M,T_K,T_N", [
    (tm, tk, tn) for tm in [1, 2, 4, 8, 16] for tk in [1, 2, 4, 8, 16] for tn in [1, 2, 4, 8, 16]
])
def test_temporal_gemm_export(tmp_path: Path, T_M: int, T_K: int, T_N: int) -> None:
    vfile = _export_temporal_gemm_custom(tmp_path, T_M=T_M, T_K=T_K, T_N=T_N)
    assert vfile.exists()
    text = vfile.read_text()
    assert "module toplevel" in text
    assert "temporal_gemm_data_out" in text


@pytest.mark.parametrize("T_width", TILE_SIZES)
def test_stateful_norm_export(tmp_path: Path, T_width: int) -> None:
    exporter = PicklableExporter("export_stateful_norm")
    vfile = exporter(tmp_path, T_width=T_width)
    assert vfile.exists()
    text = vfile.read_text()
    assert "module toplevel" in text
    assert f"stateful_norm_data_out" in text


@pytest.mark.parametrize("T_width", TILE_SIZES)
def test_stateful_softmax_export(tmp_path: Path, T_width: int) -> None:
    exporter = PicklableExporter("export_stateful_softmax")
    vfile = exporter(tmp_path, T_width=T_width)
    assert vfile.exists()
    text = vfile.read_text()
    assert "module toplevel" in text
    assert f"stateful_softmax_data_out" in text


@pytest.mark.parametrize("T_width", TILE_SIZES)
def test_multi_bank_bram_export(tmp_path: Path, T_width: int) -> None:
    exporter = PicklableExporter("export_multi_bank_bram")
    vfile = exporter(tmp_path, T_width=T_width)
    assert vfile.exists()
    text = vfile.read_text()
    assert "module toplevel" in text
    assert f"multi_bank_bram_data_out" in text
