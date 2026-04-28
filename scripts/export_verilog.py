#!/usr/bin/env python3
"""Export PyRTL IP cores to Verilog for cocotb/Verilator verification.

Usage:
    python scripts/export_verilog.py --core alu --outdir build/rtl
    python scripts/export_verilog.py --all --outdir build/rtl
"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path

# Add src to path for imports
sys.path.insert(0, str(Path(__file__).parent.parent / "src"))

import pyrtl
from ip_cores.alu import ALUCore
from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ip_cores.fifo import FIFOCore
from ip_cores.gemm import GEMMCore
from ip_cores.norm import NormCore
from ip_cores.softmax import SoftmaxCore
from ip_cores.activation import ActivationCore
from ip_cores.mem_router import MemRouterCore
from stitcher import Stitcher


def _verilate(vfile: Path) -> tuple[bool, str]:
    """Run verilator --cc -Wno-fatal on *vfile* and return (ok, output)."""
    cmd = ["verilator", "--cc", "-Wno-fatal", str(vfile)]
    result = subprocess.run(cmd, capture_output=True, text=True)
    ok = result.returncode == 0
    output = result.stdout + result.stderr
    return ok, output


def _write_hex_file(
    memblock: pyrtl.MemBlock,
    mem_map: dict[int, int],
    outdir: Path,
) -> Path:
    hex_file = outdir / f"{memblock.name}.hex"
    depth = 1 << memblock.addrwidth
    hex_digits = (memblock.bitwidth + 3) // 4

    lines = []
    for addr in range(depth):
        val = mem_map.get(addr, 0)
        lines.append(f"{val:0{hex_digits}x}")

    hex_file.write_text("\n".join(lines) + "\n")
    return hex_file


def _inject_readmemh(
    vfile: Path,
    memblock_to_hexfile: dict[pyrtl.MemBlock, Path],
) -> None:
    if not memblock_to_hexfile:
        return

    content = vfile.read_text()

    init_blocks = ["\n    // BRAM initialization"]
    for memblock, hex_file in memblock_to_hexfile.items():
        hex_basename = hex_file.name
        init_blocks.append(f"    initial begin")
        init_blocks.append(f"        $readmemh(\"{hex_basename}\", {memblock.name});")
        init_blocks.append(f"    end")

    init_text = "\n".join(init_blocks) + "\n"
    content = content.replace("\nendmodule", init_text + "endmodule")
    vfile.write_text(content)


def _apply_memory_init(
    vfile: Path,
    outdir: Path,
    memory_value_map: dict[pyrtl.MemBlock, dict[int, int]] | None,
) -> None:
    if not memory_value_map:
        return
    hex_files = {}
    for memblock, mem_map in memory_value_map.items():
        hex_files[memblock] = _write_hex_file(memblock, mem_map, outdir)
    _inject_readmemh(vfile, hex_files)


def export_alu(
    outdir: Path,
    T_width: int = 2,
    memory_value_map: dict[pyrtl.MemBlock, dict[int, int]] | None = None,
) -> Path:
    AXI4StreamLiteBase.reset()
    core = ALUCore(T_width=T_width, name="alu")

    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        dummy_data_in = pyrtl.Input(bitwidth=core.data_in.bitwidth, name="data_in")
        dummy_data_in_b = pyrtl.Input(bitwidth=core.data_in_b.bitwidth, name="data_in_b")
        dummy_op_code = pyrtl.Input(bitwidth=2, name="op_code")
        dummy_valid_in = pyrtl.Input(bitwidth=1, name="valid_in")
        dummy_ready_in = pyrtl.Input(bitwidth=1, name="ready_in")

        core.data_in <<= dummy_data_in
        core.data_in_b <<= dummy_data_in_b
        core.op_code <<= dummy_op_code
        core.valid_in <<= dummy_valid_in
        core.ready_in <<= dummy_ready_in

    outdir.mkdir(parents=True, exist_ok=True)
    vfile = outdir / "alu.v"

    with open(vfile, "w") as f:
        pyrtl.output_to_verilog(f, block=core.block, add_reset=True)

    # Fix Verilator width expansion bug in multiply: add explicit 16-bit wires
    _fix_alu_multiply_width(vfile)
    _apply_memory_init(vfile, outdir, memory_value_map)

    print(f"Exported ALUCore (T_width={T_width}) -> {vfile}")
    return vfile


def export_fifo(
    outdir: Path,
    T_width: int = 2,
    depth: int = 4,
    memory_value_map: dict[pyrtl.MemBlock, dict[int, int]] | None = None,
) -> Path:
    AXI4StreamLiteBase.reset()
    core = FIFOCore(T_width=T_width, depth=depth, name="fifo")

    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        dummy_data_in = pyrtl.Input(bitwidth=core.data_in.bitwidth, name="data_in")
        dummy_valid_in = pyrtl.Input(bitwidth=1, name="valid_in")
        dummy_ready_in = pyrtl.Input(bitwidth=1, name="ready_in")

        core.data_in <<= dummy_data_in
        core.valid_in <<= dummy_valid_in
        core.ready_in <<= dummy_ready_in

    outdir.mkdir(parents=True, exist_ok=True)
    vfile = outdir / "fifo.v"

    with open(vfile, "w") as f:
        pyrtl.output_to_verilog(f, block=core.block, add_reset=True)

    _apply_memory_init(vfile, outdir, memory_value_map)

    print(f"Exported FIFOCore (T_width={T_width}, depth={depth}) -> {vfile}")
    return vfile


def _fix_alu_multiply_width(vfile: Path) -> None:
    content = vfile.read_text()

    # 1. Add wire[15:0] prod16_lower; after wire tmp8;
    content = content.replace(
        '    wire tmp8;\n',
        '    wire tmp8;\n    wire[15:0] prod16_lower;\n'
    )

    # 2. Add wire[15:0] prod16_upper; after wire tmp45;
    content = content.replace(
        '    wire tmp45;\n',
        '    wire tmp45;\n    wire[15:0] prod16_upper;\n'
    )

    content = content.replace(
        '    assign tmp25 = ',
        '    assign prod16_lower = (tmp3 * tmp4);\n    assign tmp25 = '
    )
    content = content.replace(
        '{1\'d0, (tmp3 * tmp4)}',
        '{1\'d0, prod16_lower}'
    )

    content = content.replace(
        '    assign tmp62 = ',
        '    assign prod16_upper = (tmp40 * tmp41);\n    assign tmp62 = '
    )
    content = content.replace(
        '{1\'d0, (tmp40 * tmp41)}',
        '{1\'d0, prod16_upper}'
    )

    vfile.write_text(content)


def _fix_softmax_rom_index(vfile: Path) -> None:
    """Fix WIDTHEXPAND: softmax_exp_0 + softmax_exp_1 is 8-bit but ROM needs 9-bit index."""
    content = vfile.read_text()
    content = content.replace(
        '    wire[7:0] softmax_exp_1;\n',
        '    wire[7:0] softmax_exp_1;\n    wire[8:0] exp_sum;\n'
    )
    content = content.replace(
        '    assign tmp72 = softmax_inv_sum_rom[(softmax_exp_0 + softmax_exp_1)];',
        '    assign exp_sum = (softmax_exp_0 + softmax_exp_1);\n    assign tmp72 = softmax_inv_sum_rom[exp_sum];'
    )
    vfile.write_text(content)


def export_gemm(
    outdir: Path,
    T_width: int = 2,
    memory_value_map: dict[pyrtl.MemBlock, dict[int, int]] | None = None,
) -> Path:
    AXI4StreamLiteBase.reset()
    T_M = T_width
    T_K = T_width
    T_N = T_width
    core = GEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, name="gemm")

    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        dummy_data_in = pyrtl.Input(bitwidth=core.data_in.bitwidth, name="data_in")
        dummy_weight_in = pyrtl.Input(bitwidth=core.weight_in.bitwidth, name="weight_in")
        dummy_valid_in = pyrtl.Input(bitwidth=1, name="valid_in")
        dummy_weight_valid_in = pyrtl.Input(bitwidth=1, name="weight_valid_in")
        dummy_ready_in = pyrtl.Input(bitwidth=1, name="ready_in")

        core.data_in <<= dummy_data_in
        core.weight_in <<= dummy_weight_in
        core.valid_in <<= dummy_valid_in
        core.weight_valid_in <<= dummy_weight_valid_in
        core.ready_in <<= dummy_ready_in

    outdir.mkdir(parents=True, exist_ok=True)
    vfile = outdir / "gemm.v"

    with open(vfile, "w") as f:
        pyrtl.output_to_verilog(f, block=core.block, add_reset=True)

    _apply_memory_init(vfile, outdir, memory_value_map)

    print(f"Exported GEMMCore (T_M={T_M}, T_K={T_K}, T_N={T_N}) -> {vfile}")
    return vfile


def export_norm(
    outdir: Path,
    T_width: int = 2,
    memory_value_map: dict[pyrtl.MemBlock, dict[int, int]] | None = None,
) -> Path:
    AXI4StreamLiteBase.reset()
    core = NormCore(T_channel=T_width, name="norm")

    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        dummy_data_in = pyrtl.Input(bitwidth=core.data_in.bitwidth, name="data_in")
        dummy_valid_in = pyrtl.Input(bitwidth=1, name="valid_in")
        dummy_ready_in = pyrtl.Input(bitwidth=1, name="ready_in")

        core.data_in <<= dummy_data_in
        core.valid_in <<= dummy_valid_in
        core.ready_in <<= dummy_ready_in

    outdir.mkdir(parents=True, exist_ok=True)
    vfile = outdir / "norm.v"

    with open(vfile, "w") as f:
        pyrtl.output_to_verilog(f, block=core.block, add_reset=True)

    _apply_memory_init(vfile, outdir, memory_value_map)

    print(f"Exported NormCore (T_channel={T_width}) -> {vfile}")
    return vfile


def export_softmax(
    outdir: Path,
    T_width: int = 2,
    memory_value_map: dict[pyrtl.MemBlock, dict[int, int]] | None = None,
) -> Path:
    AXI4StreamLiteBase.reset()
    core = SoftmaxCore(T_seq=T_width, name="softmax")

    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        dummy_data_in = pyrtl.Input(bitwidth=core.data_in.bitwidth, name="data_in")
        dummy_valid_in = pyrtl.Input(bitwidth=1, name="valid_in")
        dummy_ready_in = pyrtl.Input(bitwidth=1, name="ready_in")

        core.data_in <<= dummy_data_in
        core.valid_in <<= dummy_valid_in
        core.ready_in <<= dummy_ready_in

    outdir.mkdir(parents=True, exist_ok=True)
    vfile = outdir / "softmax.v"

    with open(vfile, "w") as f:
        pyrtl.output_to_verilog(f, block=core.block, add_reset=True)

    _fix_softmax_rom_index(vfile)
    _apply_memory_init(vfile, outdir, memory_value_map)

    print(f"Exported SoftmaxCore (T_seq={T_width}) -> {vfile}")
    return vfile


def export_activation(
    outdir: Path,
    T_width: int = 2,
    memory_value_map: dict[pyrtl.MemBlock, dict[int, int]] | None = None,
) -> Path:
    AXI4StreamLiteBase.reset()
    core = ActivationCore(T_width=T_width, name="activation", activation_type="relu")

    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        dummy_data_in = pyrtl.Input(bitwidth=core.data_in.bitwidth, name="data_in")
        dummy_valid_in = pyrtl.Input(bitwidth=1, name="valid_in")
        dummy_ready_in = pyrtl.Input(bitwidth=1, name="ready_in")

        core.data_in <<= dummy_data_in
        core.valid_in <<= dummy_valid_in
        core.ready_in <<= dummy_ready_in

    outdir.mkdir(parents=True, exist_ok=True)
    vfile = outdir / "activation.v"

    with open(vfile, "w") as f:
        pyrtl.output_to_verilog(f, block=core.block, add_reset=True)

    _apply_memory_init(vfile, outdir, memory_value_map)

    print(f"Exported ActivationCore (T_width={T_width}, type=relu) -> {vfile}")
    return vfile


def export_mem_router(
    outdir: Path,
    T_width: int = 2,
    memory_value_map: dict[pyrtl.MemBlock, dict[int, int]] | None = None,
) -> Path:
    AXI4StreamLiteBase.reset()
    core = MemRouterCore(T_out=T_width, name="mem_router")

    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        dummy_data_in = pyrtl.Input(bitwidth=core.data_in.bitwidth, name="data_in")
        dummy_valid_in = pyrtl.Input(bitwidth=1, name="valid_in")
        dummy_ready_in = pyrtl.Input(bitwidth=1, name="ready_in")

        core.data_in <<= dummy_data_in
        core.valid_in <<= dummy_valid_in
        core.ready_in <<= dummy_ready_in

    outdir.mkdir(parents=True, exist_ok=True)
    vfile = outdir / "mem_router.v"

    with open(vfile, "w") as f:
        pyrtl.output_to_verilog(f, block=core.block, add_reset=True)

    _apply_memory_init(vfile, outdir, memory_value_map)

    print(f"Exported MemRouterCore (T_out={T_width}) -> {vfile}")
    return vfile


def _find_undriven_wires(block: pyrtl.Block) -> list[pyrtl.WireVector]:
    driven_wires: set[str] = set()
    for net in block.logic:
        for arg in net.dests:
            driven_wires.add(arg.name)

    used_wires: set[str] = set()
    for net in block.logic:
        for arg in net.args:
            if arg is not None:
                used_wires.add(arg.name)

    undriven: list[pyrtl.WireVector] = []
    for w in block.wirevector_set:
        if w.name in used_wires and w.name not in driven_wires:
            if isinstance(w, (pyrtl.Const, pyrtl.Input, pyrtl.Output, pyrtl.Register)):
                continue
            undriven.append(w)
    return undriven


def export_stitched_graph(
    stitcher: Stitcher,
    outdir: Path,
    name: str = "stitched_graph",
    memory_value_map: dict[pyrtl.MemBlock, dict[int, int]] | None = None,
) -> Path:
    if not stitcher._ips:
        raise ValueError("Stitcher has no registered IPs")

    built_block, drivers = stitcher.build()

    with pyrtl.set_working_block(built_block, no_sanity_check=True):
        undriven = _find_undriven_wires(built_block)
        for wire in undriven:
            wrapper_name = f"stitcher_{wire.name}"
            wrapper_in = pyrtl.Input(bitwidth=wire.bitwidth, name=wrapper_name)
            wire <<= wrapper_in

    outdir.mkdir(parents=True, exist_ok=True)
    vfile = outdir / f"{name}.v"

    with open(vfile, "w") as f:
        pyrtl.output_to_verilog(f, block=built_block, add_reset=True)

    _apply_memory_init(vfile, outdir, memory_value_map)

    print(f"Exported stitched graph ({len(stitcher._ips)} IPs) -> {vfile}")
    return vfile


CORE_EXPORTERS = {
    "alu": export_alu,
    "fifo": export_fifo,
    "gemm": export_gemm,
    "norm": export_norm,
    "softmax": export_softmax,
    "activation": export_activation,
    "mem_router": export_mem_router,
}


def main() -> None:
    parser = argparse.ArgumentParser(description="Export PyRTL IP cores to Verilog")
    parser.add_argument(
        "--core",
        choices=list(CORE_EXPORTERS.keys()),
        help="Specific core to export",
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="Export all supported cores",
    )
    parser.add_argument(
        "--outdir",
        type=Path,
        default=Path("build/rtl"),
        help="Output directory for Verilog files (default: build/rtl)",
    )
    parser.add_argument(
        "--T-width",
        type=int,
        default=2,
        help="Tiling parameter T_width for cores (default: 2)",
    )
    parser.add_argument(
        "--verilate",
        action="store_true",
        help="Run verilator --cc -Wno-fatal on each exported file",
    )

    args = parser.parse_args()

    if not args.core and not args.all:
        parser.error("Specify --core <name> or --all")

    cores_to_export = list(CORE_EXPORTERS.keys()) if args.all else [args.core]

    verilator_results: dict[str, tuple[bool, str]] = {}

    for core_name in cores_to_export:
        exporter = CORE_EXPORTERS[core_name]
        vfile = exporter(args.outdir, T_width=args.T_width)

        if args.verilate or args.all:
            ok, output = _verilate(vfile)
            verilator_results[core_name] = (ok, output)
            status = "PASS" if ok else "FAIL"
            print(f"  Verilator {status} for {core_name}")
            if output:
                for line in output.strip().splitlines():
                    print(f"    {line}")

    if verilator_results:
        print("\n--- Verilator Summary ---")
        all_ok = True
        for core_name, (ok, output) in verilator_results.items():
            status = "PASS" if ok else "FAIL"
            print(f"  {core_name}: {status}")
            if not ok:
                all_ok = False
        if all_ok:
            print("\nAll cores passed Verilator compilation.")
        else:
            print("\nSome cores failed Verilator compilation.")
            sys.exit(1)

    print("Export complete.")


if __name__ == "__main__":
    main()
