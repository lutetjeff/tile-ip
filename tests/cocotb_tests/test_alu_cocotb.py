import os
from pathlib import Path

import pytest
from cocotb.runner import get_runner


@pytest.mark.parametrize("op_code", [0, 1, 2])
def test_alu_cocotb(op_code: int) -> None:
    os.environ["COCOTB_OP_CODE"] = str(op_code)

    runner = get_runner("verilator")
    sources = [Path("build/rtl/alu.v")]
    build_dir = Path("sim_build") / f"alu_cocotb_op{op_code}"

    runner.build(
        sources=sources,
        hdl_toplevel="toplevel",
        build_args=["--trace-fst", "-Wno-fatal"],
        build_dir=build_dir,
    )

    runner.test(
        hdl_toplevel="toplevel",
        test_module="tests.cocotb_tests.alu_testbench",
        build_dir=build_dir,
    )
