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


@pytest.mark.parametrize("seq_len,emb_dim,T", [
    (4, 4, 2),
    (4, 4, 1),
])
def test_transformer_block_cocotb(seq_len, emb_dim, T) -> None:
    os.environ["COCOTB_SEQ_LEN"] = str(seq_len)
    os.environ["COCOTB_EMB_DIM"] = str(emb_dim)
    os.environ["COCOTB_T"] = str(T)

    outdir = Path("build/rtl")
    outdir.mkdir(parents=True, exist_ok=True)

    pyrtl.reset_working_block()
    built_block, drivers, manual_inputs = build_transformer_block(
        seq_len=seq_len, emb_dim=emb_dim, T=T
    )
    _disable_memory_sync_check(built_block)

    vfile = outdir / f"transformer_block_{seq_len}_{emb_dim}_{T}.v"
    with open(vfile, "w") as f:
        pyrtl.output_to_verilog(f, block=built_block, add_reset=True)

    runner = get_runner("verilator")
    build_dir = Path("sim_build") / f"transformer_block_cocotb_{seq_len}_{emb_dim}_{T}"
    build_dir.mkdir(parents=True, exist_ok=True)

    runner.build(
        sources=[vfile],
        hdl_toplevel="toplevel",
        build_args=["--trace-fst", "-Wno-fatal"],
        build_dir=build_dir,
    )

    runner.test(
        hdl_toplevel="toplevel",
        test_module="tests.cocotb_tests.transformer_block_testbench",
        build_dir=build_dir,
    )
