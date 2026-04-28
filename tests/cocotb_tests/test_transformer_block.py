import os
import sys
from pathlib import Path

import pytest
import pyrtl
from cocotb.runner import get_runner

sys.path.insert(0, str(Path(__file__).parent.parent.parent / "src"))
from transformer_block import build_transformer_block


def _disable_memory_sync_check(block):
    block.sanity_check_memory_sync = lambda wire_src_dict=None: None


def test_transformer_block_cocotb() -> None:
    outdir = Path("build/rtl")
    outdir.mkdir(parents=True, exist_ok=True)

    pyrtl.reset_working_block()
    built_block, drivers, manual_inputs = build_transformer_block()
    _disable_memory_sync_check(built_block)

    vfile = outdir / "transformer_block.v"
    with open(vfile, "w") as f:
        pyrtl.output_to_verilog(f, block=built_block, add_reset=True)

    runner = get_runner("verilator")
    sources = [vfile]
    build_dir = Path("sim_build") / "transformer_block_cocotb"
    build_dir.mkdir(parents=True, exist_ok=True)

    runner.build(
        sources=sources,
        hdl_toplevel="toplevel",
        build_args=["--trace-fst", "-Wno-fatal"],
        build_dir=build_dir,
    )

    runner.test(
        hdl_toplevel="toplevel",
        test_module="tests.cocotb_tests.transformer_block_testbench",
        build_dir=build_dir,
    )
