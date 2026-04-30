#!/usr/bin/env python3
"""Parallel Vivado IP characterization runner.

Runs N Vivado OOC synthesis/implementation jobs concurrently,
sweeping all tile dimensions for every IP in the library.

Usage:
    python scripts/characterize_ips_parallel.py -j 4
    nohup python scripts/characterize_ips_parallel.py -j 4 --outdir build/char_full > char.log 2>&1 &
"""

from __future__ import annotations

import argparse
import itertools
import json
import multiprocessing
import os
import re
import subprocess
import sys
import time
from concurrent.futures import ProcessPoolExecutor, as_completed
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
    driven = set()
    for net in block.logic:
        for dest in net.dests:
            driven.add(dest.name)

    with pyrtl.set_working_block(block, no_sanity_check=True):
        if core is not None:
            seen_wires = set()
            for attr_name in dir(core):
                if attr_name.startswith("_"):
                    continue
                if attr_name.endswith("_out") or attr_name in [
                    "data_out",
                    "valid_out",
                    "ready_out",
                    "last_out",
                ]:
                    wire = getattr(core, attr_name)
                    if isinstance(wire, pyrtl.WireVector) and not isinstance(
                        wire, pyrtl.Output
                    ):
                        if id(wire) in seen_wires:
                            continue
                        seen_wires.add(id(wire))
                        if wire.name not in driven:
                            wire <<= pyrtl.Const(0, bitwidth=wire.bitwidth)
                            continue
                        old_name = wire.name
                        wire.name = f"internal_{old_name}"
                        out_wire = pyrtl.Output(bitwidth=wire.bitwidth, name=old_name)
                        out_wire <<= wire
        else:
            for wire in list(block.wirevector_set):
                if wire.name and (
                    wire.name.endswith("_out")
                    or wire.name in ["data_out", "valid_out", "ready_out", "last_out"]
                ):
                    if isinstance(wire, pyrtl.Output):
                        continue
                    if wire.name not in driven:
                        wire <<= pyrtl.Const(0, bitwidth=wire.bitwidth)
                        continue
                    old_name = wire.name
                    wire.name = f"internal_{old_name}"
                    out_wire = pyrtl.Output(bitwidth=wire.bitwidth, name=old_name)
                    out_wire <<= wire


def _export_gemm_custom(outdir: Path, T_M: int, T_K: int, T_N: int) -> Path:
    AXI4StreamLiteBase.reset()
    core = GEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, name="gemm")

    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        dummy_data_in = pyrtl.Input(
            bitwidth=core.data_in.bitwidth, name="data_in"
        )
        dummy_weight_in = pyrtl.Input(
            bitwidth=core.weight_in.bitwidth, name="weight_in"
        )
        dummy_valid_in = pyrtl.Input(bitwidth=1, name="valid_in")
        dummy_weight_valid_in = pyrtl.Input(
            bitwidth=1, name="weight_valid_in"
        )
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


def _export_temporal_gemm_custom(
    outdir: Path, T_M: int, T_K: int, T_N: int
) -> Path:
    AXI4StreamLiteBase.reset()
    core = TemporalGEMMCore(
        T_M=T_M, T_K=T_K, T_N=T_N, M=T_M, N=T_N, name="temporal_gemm"
    )

    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        dummy_data_in = pyrtl.Input(
            bitwidth=core.data_in.bitwidth, name="data_in"
        )
        dummy_valid_in = pyrtl.Input(bitwidth=1, name="valid_in")
        dummy_ready_in = pyrtl.Input(bitwidth=1, name="ready_in")
        dummy_last_in = pyrtl.Input(bitwidth=1, name="last_in")
        dummy_accum_in = pyrtl.Input(bitwidth=1, name="accum_in")
        dummy_emit_in = pyrtl.Input(bitwidth=1, name="emit_in")
        dummy_weight_in = pyrtl.Input(
            bitwidth=core.weight_in.bitwidth, name="weight_in"
        )
        dummy_weight_valid_in = pyrtl.Input(
            bitwidth=1, name="weight_valid_in"
        )

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


class PicklableExporter:
    """Picklable wrapper that exposes outputs before Verilog generation."""

    def __init__(self, exporter_name: str):
        self.exporter_name = exporter_name

    def __call__(self, *args, **kwargs):
        from export_verilog import (
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

        dispatch = {
            "export_alu": export_alu,
            "export_fifo": export_fifo,
            "export_norm": export_norm,
            "export_softmax": export_softmax,
            "export_activation": export_activation,
            "export_mem_router": export_mem_router,
            "export_stateful_norm": export_stateful_norm,
            "export_stateful_softmax": export_stateful_softmax,
            "export_multi_bank_bram": export_multi_bank_bram,
        }
        exporter = dispatch[self.exporter_name]

        original_output = pyrtl.output_to_verilog

        def patched_output(f, block=None, **kwargs2):
            _expose_outputs(None, block)
            original_output(f, block=block, **kwargs2)

        pyrtl.output_to_verilog = patched_output
        try:
            return exporter(*args, **kwargs)
        finally:
            pyrtl.output_to_verilog = original_output


def _sweep_configs() -> list[dict]:
    configs = []

    for t in (1, 2, 4, 8, 16):
        configs.append(
            {
                "ip": "ALUCore",
                "name": f"alu_T{t}",
                "params": {"T_width": t},
                "exporter": PicklableExporter("export_alu"),
                "exporter_kwargs": {"T_width": t},
            }
        )

    for t, d in itertools.product((1, 2, 4, 8, 16), (4, 8, 16, 32, 64)):
        configs.append(
            {
                "ip": "FIFOCore",
                "name": f"fifo_T{t}_d{d}",
                "params": {"T_width": t, "depth": d},
                "exporter": PicklableExporter("export_fifo"),
                "exporter_kwargs": {"T_width": t, "depth": d},
            }
        )

    for tm, tk, tn in itertools.product((1, 2, 4, 8, 16), repeat=3):
        configs.append(
            {
                "ip": "GEMMCore",
                "name": f"gemm_T{tm}_T{tk}_T{tn}",
                "params": {"T_M": tm, "T_K": tk, "T_N": tn},
                "exporter": "_export_gemm_custom",
                "exporter_kwargs": {"T_M": tm, "T_K": tk, "T_N": tn},
            }
        )

    for t in (1, 2, 4, 8, 16):
        configs.append(
            {
                "ip": "NormCore",
                "name": f"norm_T{t}",
                "params": {"T_channel": t},
                "exporter": PicklableExporter("export_norm"),
                "exporter_kwargs": {"T_width": t},
            }
        )

    for t in (1, 2, 4, 8, 16):
        configs.append(
            {
                "ip": "SoftmaxCore",
                "name": f"softmax_T{t}",
                "params": {"T_seq": t},
                "exporter": PicklableExporter("export_softmax"),
                "exporter_kwargs": {"T_width": t},
            }
        )

    for t in (1, 2, 4, 8, 16):
        configs.append(
            {
                "ip": "ActivationCore",
                "name": f"activation_T{t}",
                "params": {"T_width": t},
                "exporter": PicklableExporter("export_activation"),
                "exporter_kwargs": {"T_width": t},
            }
        )

    for t in (1, 2, 4, 8, 16):
        configs.append(
            {
                "ip": "MemRouterCore",
                "name": f"mem_router_T{t}",
                "params": {"T_out": t},
                "exporter": PicklableExporter("export_mem_router"),
                "exporter_kwargs": {"T_width": t},
            }
        )

    for tm, tk, tn in itertools.product((1, 2, 4, 8, 16), repeat=3):
        configs.append(
            {
                "ip": "TemporalGEMMCore",
                "name": f"temporal_gemm_T{tm}_T{tk}_T{tn}",
                "params": {"T_M": tm, "T_K": tk, "T_N": tn, "M": tm, "N": tn},
                "exporter": "_export_temporal_gemm_custom",
                "exporter_kwargs": {"T_M": tm, "T_K": tk, "T_N": tn},
            }
        )

    for t in (1, 2, 4, 8, 16):
        configs.append(
            {
                "ip": "StatefulNormCore",
                "name": f"stateful_norm_T{t}_N{t}",
                "params": {"T_channel": t, "N_channel": t},
                "exporter": PicklableExporter("export_stateful_norm"),
                "exporter_kwargs": {"T_width": t},
            }
        )

    for t in (1, 2, 4, 8, 16):
        configs.append(
            {
                "ip": "StatefulSoftmaxCore",
                "name": f"stateful_softmax_T{t}_N{t}",
                "params": {"T_seq": t, "N_seq": t},
                "exporter": PicklableExporter("export_stateful_softmax"),
                "exporter_kwargs": {"T_width": t},
            }
        )

    for t in (1, 2, 4, 8, 16):
        configs.append(
            {
                "ip": "MultiBankBRAMCore",
                "name": f"multi_bank_bram_T{t}_b4_a8",
                "params": {"T": t, "num_banks": 4, "addr_width": 8},
                "exporter": PicklableExporter("export_multi_bank_bram"),
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

    m = re.search(r"Worst Negative Slack \(WNS\)[\s:]+([-\d.]+)", text)
    if m:
        metrics["wns_ns"] = float(m.group(1))
    else:
        m = re.search(
            r"Setup\s*:\s*\d+\s*Failing Endpoints,\s*Worst Slack\s+([-\d.]+)ns",
            text,
        )
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


def _run_single_config(
    cfg: dict,
    outdir: Path,
    part: str,
    clock_period: float,
    vivado_path: Path,
) -> dict:
    ip_name = cfg["ip"]
    run_name = cfg["name"]
    params = cfg["params"]
    workdir = outdir / run_name
    workdir.mkdir(parents=True, exist_ok=True)

    entry: dict = {
        "ip": ip_name,
        "params": params,
        "status": "failed",
    }

    util_rpt = workdir / "util.rpt"
    timing_rpt = workdir / "timing.rpt"
    power_rpt = workdir / "power.rpt"
    if all(p.exists() for p in (util_rpt, timing_rpt, power_rpt)):
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
        return entry

    try:
        exporter = cfg["exporter"]
        if isinstance(exporter, str):
            if exporter == "_export_gemm_custom":
                exporter = _export_gemm_custom
            elif exporter == "_export_temporal_gemm_custom":
                exporter = _export_temporal_gemm_custom
            else:
                entry["error"] = f"Unknown exporter: {exporter}"
                return entry

        exporter_kwargs = cfg["exporter_kwargs"]
        vfile = exporter(workdir, **exporter_kwargs)
        if not isinstance(vfile, Path) or not vfile.exists():
            entry["error"] = "Exporter did not return a valid file"
            return entry

        tcl_path = workdir / "run_ooc.tcl"
        tcl_path.write_text(_generate_tcl(vfile, part, clock_period))

        cmd = [
            str(vivado_path),
            "-mode",
            "batch",
            "-source",
            "run_ooc.tcl",
            "-notrace",
            "-journal",
            "vivado.jou",
            "-log",
            "vivado.log",
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
            entry["error"] = f"Vivado exited with code {result.returncode}"
            return entry

        missing_reports = [
            p.name for p in (util_rpt, timing_rpt, power_rpt) if not p.exists()
        ]
        if missing_reports:
            entry["error"] = f"Missing reports: {', '.join(missing_reports)}"
            return entry

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

    except subprocess.TimeoutExpired:
        entry["error"] = "Vivado timed out after 600s"
    except Exception as exc:
        entry["error"] = f"{type(exc).__name__}: {exc}"

    return entry


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Parallel Vivado IP characterization"
    )
    parser.add_argument(
        "--part", default="xc7s50csga324-2", help="Target FPGA part"
    )
    parser.add_argument(
        "--clock-period",
        type=float,
        default=10.0,
        help="Clock constraint in ns",
    )
    parser.add_argument(
        "--outdir",
        type=Path,
        default=Path("build/characterization"),
        help="Output directory",
    )
    parser.add_argument(
        "--vivado-path",
        type=Path,
        default=Path(
            "/home/lutet/data3/amd_fpga_tools/2025.2/Vivado/bin/vivado"
        ),
        help="Path to Vivado binary",
    )
    parser.add_argument(
        "-j",
        "--parallel",
        type=int,
        default=4,
        help="Number of concurrent Vivado jobs (default: 4)",
    )
    parser.add_argument(
        "--resume",
        action="store_true",
        help="Skip configs that already have report files",
    )

    args = parser.parse_args()

    outdir: Path = args.outdir
    outdir.mkdir(parents=True, exist_ok=True)
    json_path = outdir / "characterization_results.json"

    configs = _sweep_configs()
    total = len(configs)

    print(f"Parallel characterization sweep: {total} configurations")
    print(f"  Part: {args.part}")
    print(f"  Clock period: {args.clock_period} ns")
    print(f"  Output dir: {outdir}")
    print(f"  Vivado: {args.vivado_path}")
    print(f"  Parallel jobs: {args.parallel}")
    print(f"  Resume mode: {args.resume}")
    print()

    if args.resume:
        todo = []
        for cfg in configs:
            wd = outdir / cfg["name"]
            if not all(
                (wd / f).exists() for f in ("util.rpt", "timing.rpt", "power.rpt")
            ):
                todo.append(cfg)
        skipped = total - len(todo)
        print(f"Resuming: {skipped} already done, {len(todo)} remaining")
        configs = todo

    results: list[dict] = []
    completed = 0
    failed = 0

    def _save():
        payload = {
            "metadata": {
                "part": args.part,
                "clock_period_ns": args.clock_period,
                "timestamp": datetime.now(timezone.utc).isoformat(),
                "parallel_jobs": args.parallel,
            },
            "results": results,
        }
        json_path.write_text(json.dumps(payload, indent=2))

    start_time = time.monotonic()

    multiprocessing.set_start_method("spawn", force=True)

    with ProcessPoolExecutor(max_workers=args.parallel) as executor:
        future_to_cfg = {
            executor.submit(
                _run_single_config,
                cfg,
                outdir,
                args.part,
                args.clock_period,
                args.vivado_path,
            ): cfg
            for cfg in configs
        }

        for future in as_completed(future_to_cfg):
            cfg = future_to_cfg[future]
            try:
                entry = future.result()
                results.append(entry)
                completed += 1
                if entry["status"] != "success":
                    failed += 1
                    print(
                        f"[{completed}/{len(configs)}] {cfg['name']} FAILED: {entry.get('error', 'unknown')}"
                    )
                else:
                    print(f"[{completed}/{len(configs)}] {cfg['name']} OK")
            except Exception as exc:
                completed += 1
                failed += 1
                print(
                    f"[{completed}/{len(configs)}] {cfg['name']} EXCEPTION: {exc}"
                )
                results.append(
                    {
                        "ip": cfg["ip"],
                        "params": cfg["params"],
                        "status": "failed",
                        "error": str(exc),
                    }
                )

            if completed % 5 == 0:
                _save()
                elapsed = time.monotonic() - start_time
                rate = completed / elapsed if elapsed > 0 else 0
                eta = (len(configs) - completed) / rate if rate > 0 else 0
                print(
                    f"  -> Saved ({completed} done, {failed} failed, {rate:.2f} configs/s, ETA {eta/60:.1f}m)"
                )

    _save()
    elapsed = time.monotonic() - start_time
    print(f"\nDone. {completed}/{len(configs)} processed in {elapsed/60:.1f}m.")
    print(f"  Success: {completed - failed}, Failed: {failed}")
    print(f"  Results: {json_path}")


if __name__ == "__main__":
    main()
