from pathlib import Path

from cocotb.runner import get_runner


def test_norm_cocotb() -> None:
    runner = get_runner("verilator")
    sources = [Path("build/rtl/norm.v")]
    build_dir = Path("sim_build") / "norm_cocotb"

    runner.build(
        sources=sources,
        hdl_toplevel="toplevel",
        build_args=["--trace-fst", "-Wno-fatal"],
        build_dir=build_dir,
    )

    runner.test(
        hdl_toplevel="toplevel",
        test_module="tests.cocotb_tests.norm_testbench",
        build_dir=build_dir,
    )