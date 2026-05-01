import os
import sys
from pathlib import Path

import pytest
import pyrtl
from cocotb.runner import get_runner

sys.path.insert(0, str(Path(__file__).parent.parent.parent / "src"))
sys.path.insert(0, str(Path(__file__).parent.parent.parent / "scripts"))
from export_verilog import _write_hex_file, _inject_readmemh


@pytest.mark.parametrize("bitwidth,addrwidth", [(8, 4)])
def test_bram_init_cocotb(bitwidth: int, addrwidth: int) -> None:
    os.environ["COCOTB_BITWIDTH"] = str(bitwidth)
    os.environ["COCOTB_ADDRWIDTH"] = str(addrwidth)

    outdir = Path("build/rtl")
    outdir.mkdir(parents=True, exist_ok=True)

    pyrtl.reset_working_block()
    addr = pyrtl.Input(addrwidth, "addr")
    data = pyrtl.Output(bitwidth, "data")
    bram = pyrtl.MemBlock(bitwidth, addrwidth, "bram")
    data <<= bram[addr]

    depth = 1 << addrwidth
    mem_map = {addr: (addr * 3 + 17) & ((1 << bitwidth) - 1) for addr in range(depth)}

    vfile = outdir / "bram_init.v"
    with open(vfile, "w") as f:
        pyrtl.output_to_verilog(f, add_reset=True)

    hex_file = _write_hex_file(bram, mem_map, outdir)
    _inject_readmemh(vfile, {bram: hex_file})

    runner = get_runner("verilator")
    sources = [vfile]
    build_dir = Path("sim_build") / f"bram_init_cocotb_b{bitwidth}_a{addrwidth}"
    build_dir.mkdir(parents=True, exist_ok=True)

    import shutil
    shutil.copy(hex_file, build_dir / hex_file.name)

    runner.build(
        sources=sources,
        hdl_toplevel="toplevel",
        build_args=["--trace-fst", "-Wno-fatal"],
        build_dir=build_dir,
    )

    runner.test(
        hdl_toplevel="toplevel",
        test_module="tests.cocotb_tests.bram_init_testbench",
        build_dir=build_dir,
    )
