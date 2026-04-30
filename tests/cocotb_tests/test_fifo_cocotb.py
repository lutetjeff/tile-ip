import os
import sys
from pathlib import Path

import pytest
from cocotb.runner import get_runner

sys.path.insert(0, str(Path(__file__).parent.parent.parent / "src"))
sys.path.insert(0, str(Path(__file__).parent.parent.parent / "scripts"))
from export_verilog import export_fifo


@pytest.mark.parametrize("T_width", [1, 2, 4])
def test_fifo_cocotb(T_width: int) -> None:
    os.environ["COCOTB_T_WIDTH"] = str(T_width)

    outdir = Path("build/rtl")
    vfile = export_fifo(outdir, T_width=T_width, depth=4)

    runner = get_runner("verilator")
    build_dir = Path("sim_build") / f"fifo_cocotb_t{T_width}"
    build_dir.mkdir(parents=True, exist_ok=True)

    runner.build(
        sources=[vfile],
        hdl_toplevel="toplevel",
        build_args=["--trace-fst", "-Wno-fatal"],
        build_dir=build_dir,
    )

    runner.test(
        hdl_toplevel="toplevel",
        test_module="tests.cocotb_tests.fifo_testbench",
        build_dir=build_dir,
    )
