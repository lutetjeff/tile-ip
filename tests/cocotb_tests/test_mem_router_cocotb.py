import os
import sys
from pathlib import Path

import pytest
from cocotb.runner import get_runner

sys.path.insert(0, str(Path(__file__).parent.parent.parent / "src"))
sys.path.insert(0, str(Path(__file__).parent.parent.parent / "scripts"))
from export_verilog import export_mem_router


@pytest.mark.parametrize("T_out", [2])
def test_mem_router_cocotb(T_out: int) -> None:
    os.environ["COCOTB_T_OUT"] = str(T_out)

    outdir = Path("build/rtl")
    vfile = export_mem_router(outdir, T_width=T_out)

    runner = get_runner("verilator")
    build_dir = Path("sim_build") / f"mem_router_cocotb_T{T_out}"
    build_dir.mkdir(parents=True, exist_ok=True)

    runner.build(
        sources=[vfile],
        hdl_toplevel="toplevel",
        build_args=["--trace-fst", "-Wno-fatal"],
        build_dir=build_dir,
    )

    runner.test(
        hdl_toplevel="toplevel",
        test_module="tests.cocotb_tests.mem_router_testbench",
        build_dir=build_dir,
    )
