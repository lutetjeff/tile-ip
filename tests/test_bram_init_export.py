import sys
from pathlib import Path

import pyrtl
import pytest

sys.path.insert(0, str(Path(__file__).parent.parent / "src"))
sys.path.insert(0, str(Path(__file__).parent.parent / "scripts"))
from ip_cores.fifo import FIFOCore
from ip_cores.mem_router import MemRouterCore
from export_verilog import export_stitched_graph
from stitcher import Stitcher


def test_stitched_graph_bram_init():
    """Verify stitched graph export generates $readmemh for multiple BRAMs."""
    pyrtl.reset_working_block()
    shared_block = pyrtl.Block()

    mr1 = MemRouterCore(T_out=2, name="mr1", block=shared_block)
    mr2 = MemRouterCore(T_out=2, name="mr2", block=shared_block)

    stitcher = Stitcher(block=shared_block)
    stitcher.add_ip(mr1)
    stitcher.add_ip(mr2)
    stitcher.connect("mr1", "mr2")

    mr1_mem_map = {i: (i + 1) & 0xFF for i in range(16)}
    mr2_mem_map = {i: (i * 2) & 0xFF for i in range(16)}
    memory_value_map = {mr1.bram: mr1_mem_map, mr2.bram: mr2_mem_map}

    outdir = Path("build/rtl")
    outdir.mkdir(parents=True, exist_ok=True)

    vfile = export_stitched_graph(
        stitcher,
        outdir,
        name="stitched_bram_init",
        memory_value_map=memory_value_map,
    )

    verilog = vfile.read_text()

    assert "$readmemh(\"mr1_bram.hex\", mr1_bram)" in verilog
    assert "$readmemh(\"mr2_bram.hex\", mr2_bram)" in verilog

    hex_mr1 = (outdir / "mr1_bram.hex").read_text().splitlines()
    assert hex_mr1[0] == "01"
    assert hex_mr1[15] == "10"

    hex_mr2 = (outdir / "mr2_bram.hex").read_text().splitlines()
    assert hex_mr2[0] == "00"
    assert hex_mr2[1] == "02"

    import subprocess
    cmd = ["verilator", "--cc", "-Wno-fatal", str(vfile)]
    result = subprocess.run(cmd, capture_output=True, text=True)
    assert result.returncode == 0, f"Verilator failed: {result.stderr}"
