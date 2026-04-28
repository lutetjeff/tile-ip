import os
from pathlib import Path

import pytest
from cocotb.runner import get_runner


def test_gemm_cocotb() -> None:
    runner = get_runner("verilator")
    sources = [Path("build/rtl/gemm.v")]
    build_dir = Path("sim_build") / "gemm_cocotb"

    runner.build(
        sources=sources,
        hdl_toplevel="toplevel",
        build_args=["--trace-fst", "-Wno-fatal"],
        build_dir=build_dir,
    )

    runner.test(
        hdl_toplevel="toplevel",
        test_module="tests.cocotb_tests.gemm_testbench",
        build_dir=build_dir,
    )