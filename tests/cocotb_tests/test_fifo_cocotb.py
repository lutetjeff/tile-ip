import os
from pathlib import Path

import pytest
from cocotb.runner import get_runner


@pytest.mark.parametrize("T_width", [1, 2])
def test_fifo_cocotb(T_width: int) -> None:
    os.environ["COCOTB_T_WIDTH"] = str(T_width)

    runner = get_runner("verilator")
    sources = [Path("build/rtl/fifo.v")]
    build_dir = Path("sim_build") / f"fifo_cocotb_t{T_width}"

    runner.build(
        sources=sources,
        hdl_toplevel="toplevel",
        build_args=["--trace-fst", "-Wno-fatal"],
        build_dir=build_dir,
    )

    runner.test(
        hdl_toplevel="toplevel",
        test_module="tests.cocotb_tests.fifo_testbench",
        build_dir=build_dir,
    )
