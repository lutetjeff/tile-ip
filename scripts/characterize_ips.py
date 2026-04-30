#!/usr/bin/env python3
from __future__ import annotations

import argparse
import itertools
import json
import os
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent / "src"))
sys.path.insert(0, str(Path(__file__).parent))

import pyrtl
from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ip_cores.gemm import GEMMCore
from ip_cores.temporal_gemm import TemporalGEMMCore

from export_verilog import (
    CORE_EXPORTERS,
    export_alu,
    export_fifo,
    export_norm,
    export_softmax,
    export_activation,
    export_mem_router,
    export_stateful_norm,
    export_stateful_softmax,
    export_multi_bank_bram,
)



def _expose_outputs(core, block: pyrtl.Block) -> None:
    with pyrtl.set_working_block(block, no_sanity_check=True):
        if core is not None:
            for attr_name in dir(core):
                if attr_name.endswith('_out') or attr_name in ['data_out', 'valid_out', 'ready_out', 'last_out']:
                    wire = getattr(core, attr_name)
                    if isinstance(wire, pyrtl.WireVector) and not isinstance(wire, pyrtl.Output):
                        old_name = wire.name
                        wire.name = f"internal_{old_name}"
                        out_wire = pyrtl.Output(bitwidth=wire.bitwidth, name=old_name)
                        out_wire <<= wire
        else:
            for wire in list(block.wirevector_set):
                if wire.name and (wire.name.endswith('_out') or wire.name in ['data_out', 'valid_out', 'ready_out', 'last_out']):
                    if isinstance(wire, pyrtl.Output):
                        continue
                    old_name = wire.name
                    wire.name = f"internal_{old_name}"
                    out_wire = pyrtl.Output(bitwidth=wire.bitwidth, name=old_name)
                    out_wire <<= wire

def _wrap_exporter(exporter):
    def wrapper(*args, **kwargs):
        original_output = pyrtl.output_to_verilog
        def patched_output(f, block=None, **kwargs2):
            _expose_outputs(None, block)
            original_output(f, block=block, **kwargs2)
        
        pyrtl.output_to_verilog = patched_output
        try:
            return exporter(*args, **kwargs)
        finally:
            pyrtl.output_to_verilog = original_output
    return wrapper

def _export_gemm_custom(outdir: Path, T_M: int, T_K: int, T_N: int) -> Path:
    AXI4StreamLiteBase.reset()
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

    _expose_outputs(core, core.block)

    outdir.mkdir(parents=True, exist_ok=True)
    vfile = outdir / "gemm.v"
    with open(vfile, "w") as f:
        pyrtl.output_to_verilog(f, block=core.block, add_reset=True)
    return vfile


def _export_temporal_gemm_custom(outdir: Path, T_M: int, T_K: int, T_N: int) -> Path:
    AXI4StreamLiteBase.reset()
    core = TemporalGEMMCore(
        T_M=T_M, T_K=T_K, T_N=T_N, M=T_M, N=T_N, name="temporal_gemm"
    )

    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        dummy_data_in = pyrtl.Input(bitwidth=core.data_in.bitwidth, name="data_in")
        dummy_valid_in = pyrtl.Input(bitwidth=1, name="valid_in")
        dummy_ready_in = pyrtl.Input(bitwidth=1, name="ready_in")
        dummy_last_in = pyrtl.Input(bitwidth=1, name="last_in")
        dummy_accum_in = pyrtl.Input(bitwidth=1, name="accum_in")
        dummy_emit_in = pyrtl.Input(bitwidth=1, name="emit_in")
        dummy_weight_in = pyrtl.Input(bitwidth=core.weight_in.bitwidth, name="weight_in")
        dummy_weight_valid_in = pyrtl.Input(bitwidth=1, name="weight_valid_in")

        core.data_in <<= dummy_data_in
        core.valid_in <<= dummy_valid_in
        core.ready_in <<= dummy_ready_in
        core.last_in <<= dummy_last_in
        core.accum_in <<= dummy_accum_in
        core.emit_in <<= dummy_emit_in
        core.weight_in <<= dummy_weight_in
        core.weight_valid_in <<= dummy_weight_valid_in

    _expose_outputs(core, core.block)

    outdir.mkdir(parents=True, exist_ok=True)
    vfile = outdir / "temporal_gemm.v"
    with open(vfile, "w") as f:
        pyrtl.output_to_verilog(f, block=core.block, add_reset=True)
    return vfile


def _sweep_configs() -> list[dict]:
    configs = []

    for t in (1, 2, 4, 8, 16):
        configs.append(
            {"ip": "ALUCore", "name": f"alu_T{t}", "params": {"T_width": t}, "exporter": _wrap_exporter(export_alu), "exporter_kwargs": {"T_width": t}}
        )

    for t, d in itertools.product((1, 2, 4, 8, 16), (4, 8, 16, 32, 64)):
        configs.append(
            {
                "ip": "FIFOCore",
                "name": f"fifo_T{t}_d{d}",
                "params": {"T_width": t, "depth": d},
                "exporter": _wrap_exporter(export_fifo),
                "exporter_kwargs": {"T_width": t, "depth": d},
            }
        )

    for tm, tk, tn in itertools.product((1, 2, 4), repeat=3):
        configs.append(
            {
                "ip": "GEMMCore",
                "name": f"gemm_T{tm}_T{tk}_T{tn}",
                "params": {"T_M": tm, "T_K": tk, "T_N": tn},
                "exporter": _export_gemm_custom,
                "exporter_kwargs": {"T_M": tm, "T_K": tk, "T_N": tn},
            }
        )

    for t in (1, 2, 4, 8, 16):
        configs.append(
            {"ip": "NormCore", "name": f"norm_T{t}", "params": {"T_channel": t}, "exporter": _wrap_exporter(export_norm), "exporter_kwargs": {"T_width": t}}
        )

    for t in (1, 2, 4, 8, 16):
        configs.append(
            {"ip": "SoftmaxCore", "name": f"softmax_T{t}", "params": {"T_seq": t}, "exporter": _wrap_exporter(export_softmax), "exporter_kwargs": {"T_width": t}}
        )

    for t in (1, 2, 4, 8, 16):
        configs.append(
            {"ip": "ActivationCore", "name": f"activation_T{t}", "params": {"T_width": t}, "exporter": _wrap_exporter(export_activation), "exporter_kwargs": {"T_width": t}}
        )

    for t in (1, 2, 4, 8, 16):
        configs.append(
            {"ip": "MemRouterCore", "name": f"mem_router_T{t}", "params": {"T_out": t}, "exporter": _wrap_exporter(export_mem_router), "exporter_kwargs": {"T_width": t}}
        )

    for tm, tk, tn in itertools.product((1, 2, 4), repeat=3):
        configs.append(
            {
                "ip": "TemporalGEMMCore",
                "name": f"temporal_gemm_T{tm}_T{tk}_T{tn}",
                "params": {"T_M": tm, "T_K": tk, "T_N": tn, "M": tm, "N": tn},
                "exporter": _export_temporal_gemm_custom,
                "exporter_kwargs": {"T_M": tm, "T_K": tk, "T_N": tn},
            }
        )

    for t in (1, 2, 4, 8, 16):
        configs.append(
            {
                "ip": "StatefulNormCore",
                "name": f"stateful_norm_T{t}_N{t}",
                "params": {"T_channel": t, "N_channel": t},
                "exporter": _wrap_exporter(export_stateful_norm),
                "exporter_kwargs": {"T_width": t},
            }
        )

    for t in (1, 2, 4, 8, 16):
        configs.append(
            {
                "ip": "StatefulSoftmaxCore",
                "name": f"stateful_softmax_T{t}_N{t}",
                "params": {"T_seq": t, "N_seq": t},
                "exporter": _wrap_exporter(export_stateful_softmax),
                "exporter_kwargs": {"T_width": t},
            }
        )

    for t in (1, 2, 4, 8, 16):
        configs.append(
            {
                "ip": "MultiBankBRAMCore",
                "name": f"multi_bank_bram_T{t}_b4_a8",
                "params": {"T": t, "num_banks": 4, "addr_width": 8},
                "exporter": _wrap_exporter(export_multi_bank_bram),
                "exporter_kwargs": {"T_width": t},
            }
        )

    return configs



def _generate_tcl(vfile: Path, part: str, period: float) -> str:
    return f"""create_project -in_memory -part {part}
read_verilog {{{vfile.resolve()}}}
synth_design -top toplevel -mode out_of_context
create_clock -period {period} -name clk [get_ports clk]
opt_design
place_design
route_design
report_utilization -file util.rpt
report_timing_summary -file timing.rpt
report_power -file power.rpt
write_checkpoint -force post_route.dcp
"""



def _parse_utilization(rpt_path: Path) -> dict[str, int]:
    if not rpt_path.exists():
        return {}
    text = rpt_path.read_text()
    metrics: dict[str, int] = {}

    # Slice LUTs (first number after the name)
    m = re.search(r"Slice LUTs\s*\|\s*(\d+)", text)
    if m:
        metrics["LUT"] = int(m.group(1))

    m = re.search(r"Slice Registers\s*\|\s*(\d+)", text)
    if m:
        metrics["FF"] = int(m.group(1))

    m = re.search(r"DSPs\s*\|\s*(\d+)", text)
    if m:
        metrics["DSP"] = int(m.group(1))

    m = re.search(r"Block RAM Tile\s*\|\s*(\d+)", text)
    if m:
        metrics["BRAM"] = int(m.group(1))

    return metrics


def _parse_timing(rpt_path: Path) -> dict[str, float]:
    if not rpt_path.exists():
        return {}
    text = rpt_path.read_text()
    metrics: dict[str, float] = {}

    # Vivado report_timing_summary uses different formats depending on version
    m = re.search(r"Worst Negative Slack \(WNS\)[\s:]+([-\d.]+)", text)
    if m:
        metrics["wns_ns"] = float(m.group(1))
    else:
        # Alternative format: "Setup : ... Worst Slack 7.827ns ..."
        m = re.search(r"Setup\s*:\s*\d+\s*Failing Endpoints,\s*Worst Slack\s+([-\d.]+)ns", text)
        if m:
            metrics["wns_ns"] = float(m.group(1))

    return metrics


def _parse_power(rpt_path: Path) -> dict[str, float]:
    if not rpt_path.exists():
        return {}
    text = rpt_path.read_text()
    metrics: dict[str, float] = {}

    m = re.search(r"Total On-Chip Power[^\n]*\|\s*([\d.]+)", text)
    if m:
        metrics["total_w"] = float(m.group(1))

    return metrics


def _run_characterization(args: argparse.Namespace) -> None:
    outdir: Path = args.outdir
    outdir.mkdir(parents=True, exist_ok=True)

    results: list[dict] = []
    json_path = outdir / "characterization_results.json"

    configs = _sweep_configs()
    total = len(configs)

    print(f"Starting characterization sweep: {total} configurations")
    print(f"  Part: {args.part}")
    print(f"  Clock period: {args.clock_period} ns")
    print(f"  Output dir: {outdir}")
    print(f"  Vivado: {args.vivado_path}")
    print()

    for idx, cfg in enumerate(configs, start=1):
        ip_name = cfg["ip"]
        run_name = cfg["name"]
        params = cfg["params"]
        workdir = outdir / run_name
        workdir.mkdir(parents=True, exist_ok=True)

        print(f"[{idx}/{total}] {ip_name} ({run_name}) ... ", end="", flush=True)

        entry: dict = {
            "ip": ip_name,
            "params": params,
            "status": "failed",
        }

        try:
            exporter = cfg["exporter"]
            exporter_kwargs = cfg["exporter_kwargs"]
            vfile = exporter(workdir, **exporter_kwargs)
            assert isinstance(vfile, Path) and vfile.exists(), "Exporter did not return a valid file"

            tcl_path = workdir / "run_ooc.tcl"
            tcl_path.write_text(_generate_tcl(vfile, args.part, args.clock_period))

            cmd = [
                str(args.vivado_path),
                "-mode", "batch",
                "-source", "run_ooc.tcl",
                "-notrace",
                "-journal", "vivado.jou",
                "-log", "vivado.log",
            ]
            result = subprocess.run(
                cmd,
                cwd=workdir,
                capture_output=True,
                text=True,
                timeout=600,
            )

            if result.returncode != 0:
                err_log = workdir / "vivado_error.log"
                err_log.write_text(result.stderr)
                print(f"FAILED (rc={result.returncode})")
                entry["error"] = f"Vivado exited with code {result.returncode}"
                results.append(entry)
                _save_json(json_path, args, results)
                continue
            util_rpt = workdir / "util.rpt"
            timing_rpt = workdir / "timing.rpt"
            power_rpt = workdir / "power.rpt"

            missing_reports = [p.name for p in (util_rpt, timing_rpt, power_rpt) if not p.exists()]
            if missing_reports:
                print(f"FAILED (missing reports: {', '.join(missing_reports)})")
                entry["error"] = f"Missing reports: {', '.join(missing_reports)}"
                results.append(entry)
                _save_json(json_path, args, results)
                continue

            resources = _parse_utilization(util_rpt)
            timing = _parse_timing(timing_rpt)
            power = _parse_power(power_rpt)

            entry["status"] = "success"
            if resources:
                entry["resources"] = resources
            if timing:
                entry["timing"] = timing
            if power:
                entry["power"] = power

            results.append(entry)
            print("OK")

        except subprocess.TimeoutExpired:
            print("FAILED (timeout)")
            entry["error"] = "Vivado timed out after 600s"
            results.append(entry)
        except Exception as exc:
            print(f"FAILED ({type(exc).__name__}: {exc})")
            entry["error"] = f"{type(exc).__name__}: {exc}"
            results.append(entry)

        _save_json(json_path, args, results)

    print(f"\nDone. {len(results)}/{total} configurations processed.")
    print(f"Results written to: {json_path}")


def _save_json(json_path: Path, args: argparse.Namespace, results: list[dict]) -> None:
    payload = {
        "metadata": {
            "part": args.part,
            "clock_period_ns": args.clock_period,
            "timestamp": datetime.now(timezone.utc).isoformat(),
        },
        "results": results,
    }
    json_path.write_text(json.dumps(payload, indent=2))


def main() -> None:
    parser = argparse.ArgumentParser(description="Characterize tiled-ip cores with Vivado OOC")
    parser.add_argument("--part", default="xc7s50csga324-2", help="Target FPGA part")
    parser.add_argument("--clock-period", type=float, default=10.0, help="Clock constraint in ns")
    parser.add_argument("--outdir", type=Path, default=Path("build/characterization"), help="Output directory")
    parser.add_argument("--vivado-path", type=Path, default=Path("/home/lutet/data3/amd_fpga_tools/2025.2/Vivado/bin/vivado"), help="Path to Vivado binary")

    args = parser.parse_args()
    _run_characterization(args)


if __name__ == "__main__":
    main()
