import os
from pathlib import Path

import pytest
from cocotb.runner import get_runner


@pytest.mark.parametrize("T_out", [2])
def test_mem_router_cocotb(T_out: int) -> None:
    os.environ["COCOTB_T_OUT"] = str(T_out)

    runner = get_runner("verilator")
    sources = [Path("build/rtl/mem_router.v")]
    build_dir = Path("sim_build") / f"mem_router_cocotb_T{T_out}"

    runner.build(
        sources=sources,
        hdl_toplevel="toplevel",
        build_args=["--trace-fst", "-Wno-fatal"],
        build_dir=build_dir,
    )

    runner.test(
        hdl_toplevel="toplevel",
        test_module="tests.cocotb_tests.mem_router_testbench",
        build_dir=build_dir,
    )