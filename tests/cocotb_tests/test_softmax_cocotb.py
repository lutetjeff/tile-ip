import sys
from pathlib import Path

from cocotb.runner import get_runner

sys.path.insert(0, str(Path(__file__).parent.parent.parent / "src"))
sys.path.insert(0, str(Path(__file__).parent.parent.parent / "scripts"))
from export_verilog import export_softmax


def test_softmax_cocotb() -> None:
    outdir = Path("build/rtl")
    vfile = export_softmax(outdir, T_width=2)

    runner = get_runner("verilator")
    build_dir = Path("sim_build") / "softmax_cocotb"
    build_dir.mkdir(parents=True, exist_ok=True)

    runner.build(
        sources=[vfile],
        hdl_toplevel="toplevel",
        build_args=["--trace-fst", "-Wno-fatal"],
        build_dir=build_dir,
    )

    runner.test(
        hdl_toplevel="toplevel",
        test_module="tests.cocotb_tests.softmax_testbench",
        build_dir=build_dir,
    )
