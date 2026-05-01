"""Branch-and-bound autotuner for tiled IP graphs.

The autotuner searches over tile-factor assignments, computes resource/utilization
metrics using a characterization database, and tracks the top-N lowest-latency
designs.  Verilog output is produced via :class:`frontend.TiledIPGraph`.
"""

from __future__ import annotations

import copy
import heapq
import json
import os
from typing import Any

import pyrtl

from frontend import TiledIPGraph
from ip_cores.alu import ALUCore
from ip_cores.activation import ActivationCore
from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ip_cores.fifo import FIFOCore
from ip_cores.gemm import GEMMCore
from ip_cores.mem_router import MemRouterCore
from ip_cores.norm import NormCore
from ip_cores.softmax import SoftmaxCore
from ip_cores.stateful_norm import StatefulNormCore
from ip_cores.stateful_softmax import StatefulSoftmaxCore
from ip_cores.temporal_gemm import TemporalGEMMCore


class CharacterizationDB:
    """Database of FPGA characterization results with estimation fallback.

    Parameters
    ----------
    json_path : str, optional
        Path to ``characterization_results.json``.  Defaults to the file
        shipped in ``build/characterization/``.
    """

    def __init__(self, json_path: str | None = None) -> None:
        if json_path is None:
            json_path = os.path.join(
                os.path.dirname(__file__),
                "..",
                "build",
                "characterization",
                "characterization_results.json",
            )
        with open(json_path) as f:
            data = json.load(f)
        self._results: dict[tuple[str, tuple], dict] = {}
        for r in data.get("results", []):
            key = (r["ip"], tuple(sorted(r["params"].items())))
            self._results[key] = r

    def lookup(self, ip_type: str, params: dict[str, int]) -> dict[str, float | int]:
        """Return resource/timing dict for *ip_type* with *params*.

        If the exact configuration was characterized, the measured data is
        returned.  Otherwise an estimate is produced using the heuristics
        defined in the project specification.
        """
        core_name = ip_type if ip_type.endswith("Core") else ip_type + "Core"
        key = (core_name, tuple(sorted(params.items())))
        if key in self._results:
            r = self._results[key]
            if r.get("status") == "success" and "resources" in r and "timing" in r and "power" in r:
                return {
                    "LUT": r["resources"]["LUT"],
                    "FF": r["resources"]["FF"],
                    "DSP": r["resources"]["DSP"],
                    "BRAM": r["resources"]["BRAM"],
                    "power_w": r["power"]["total_w"],
                    "wns_ns": r["timing"]["wns_ns"],
                    "clock_period_ns": 10.0,
                }
        return self._estimate(core_name, params)

    def _estimate(self, core_name: str, params: dict[str, int]) -> dict[str, float | int]:
        if core_name == "ALUCore":
            return self._estimate_alu(params)
        if core_name == "TemporalGEMMCore":
            return self._estimate_temporal_gemm(params)
        if core_name == "StatefulNormCore":
            return self._estimate_stateful_norm(params)
        if core_name == "StatefulSoftmaxCore":
            return self._estimate_stateful_softmax(params)
        if core_name == "ActivationCore":
            return self._estimate_activation(params)
        if core_name == "FIFOCore":
            return self._estimate_fifo(params)
        if core_name == "GEMMCore":
            return self._estimate_gemm(params)
        if core_name == "SoftmaxCore":
            return self._estimate_softmax(params)
        if core_name == "NormCore":
            return self._estimate_norm(params)
        if core_name == "MemRouterCore":
            return self._estimate_mem_router(params)
        return {"LUT": 0, "FF": 0, "DSP": 0, "BRAM": 0, "power_w": 0.0, "wns_ns": 8.0, "clock_period_ns": 10.0}

    def _estimate_alu(self, params: dict[str, int]) -> dict[str, float | int]:
        t = params.get("T_width", 1)
        lut = int(109 + (t - 1) * 108)
        ff = int(9 + (t - 1) * 8)
        power = 0.07 + (t - 1) * 0.001
        wns = 7.827 + (t - 1) * 0.309
        return {
            "LUT": lut,
            "FF": ff,
            "DSP": 0,
            "BRAM": 0,
            "power_w": power,
            "wns_ns": wns,
            "clock_period_ns": 10.0,
        }

    def _estimate_temporal_gemm(self, params: dict[str, int]) -> dict[str, float | int]:
        t_m = params.get("T_M", 1)
        t_k = params.get("T_K", 1)
        t_n = params.get("T_N", 1)
        prod = t_m * t_k * t_n
        return {
            "LUT": prod * 200,
            "FF": t_m * t_n * 16,
            "DSP": prod // 4,
            "BRAM": 0,
            "power_w": 0.05 + 0.01 * prod,
            "wns_ns": 8.0,
            "clock_period_ns": 10.0,
        }

    def _estimate_stateful_norm(self, params: dict[str, int]) -> dict[str, float | int]:
        t_ch = params.get("T_channel", 1)
        n_ch = params.get("N_channel", 1)
        return {
            "LUT": t_ch * 80 + n_ch * 2,
            "FF": t_ch * 16,
            "DSP": 0,
            "BRAM": 0,
            "power_w": 0.06 + 0.005 * t_ch,
            "wns_ns": 8.0,
            "clock_period_ns": 10.0,
        }

    def _estimate_stateful_softmax(self, params: dict[str, int]) -> dict[str, float | int]:
        t_seq = params.get("T_seq", 1)
        n_seq = params.get("N_seq", 1)
        return {
            "LUT": t_seq * 100 + n_seq * 2,
            "FF": t_seq * 20,
            "DSP": 0,
            "BRAM": 0,
            "power_w": 0.08 + 0.008 * t_seq,
            "wns_ns": 8.0,
            "clock_period_ns": 10.0,
        }

    def _estimate_activation(self, params: dict[str, int]) -> dict[str, float | int]:
        t = params.get("T_width", 1)
        return {
            "LUT": t * 15,
            "FF": t * 4,
            "DSP": 0,
            "BRAM": 0,
            "power_w": 0.03 + 0.002 * t,
            "wns_ns": 8.0,
            "clock_period_ns": 10.0,
        }

    def _estimate_fifo(self, params: dict[str, int]) -> dict[str, float | int]:
        t = params.get("T_width", 1)
        depth = params.get("depth", 1)
        return {
            "LUT": depth * 2 + t * 4,
            "FF": depth * t * 8 + 16,
            "DSP": 0,
            "BRAM": 0,
            "power_w": 0.02 + 0.001 * depth,
            "wns_ns": 8.0,
            "clock_period_ns": 10.0,
        }

    def _estimate_gemm(self, params: dict[str, int]) -> dict[str, float | int]:
        t_m = params.get("T_M", 1)
        t_k = params.get("T_K", 1)
        t_n = params.get("T_N", 1)
        prod = t_m * t_k * t_n
        return {
            "LUT": prod * 50,
            "FF": t_m * t_n * 8,
            "DSP": prod // 8,
            "BRAM": 0,
            "power_w": 0.04 + 0.008 * prod,
            "wns_ns": 8.0,
            "clock_period_ns": 10.0,
        }

    def _estimate_softmax(self, params: dict[str, int]) -> dict[str, float | int]:
        t = params.get("T_seq", 1)
        return {
            "LUT": t * 30,
            "FF": t * 10,
            "DSP": 0,
            "BRAM": 0,
            "power_w": 0.05 + 0.003 * t,
            "wns_ns": 8.0,
            "clock_period_ns": 10.0,
        }

    def _estimate_norm(self, params: dict[str, int]) -> dict[str, float | int]:
        t = params.get("T_channel", 1)
        return {
            "LUT": t * 25,
            "FF": t * 8,
            "DSP": 0,
            "BRAM": 0,
            "power_w": 0.04 + 0.003 * t,
            "wns_ns": 8.0,
            "clock_period_ns": 10.0,
        }

    def _estimate_mem_router(self, params: dict[str, int]) -> dict[str, float | int]:
        t = params.get("T_out", 1)
        return {
            "LUT": t * 5,
            "FF": t * 2,
            "DSP": 0,
            "BRAM": 0,
            "power_w": 0.02 + 0.001 * t,
            "wns_ns": 8.0,
            "clock_period_ns": 10.0,
        }


class Autotuner:
    """Branch-and-bound autotuner for tiled IP graph specifications.

    Parameters
    ----------
    spec : dict
        Graph specification in the same format as :class:`solver.TilingSolver`.
    char_db : CharacterizationDB, optional
        Resource/timing database.  A default instance is created if omitted.
    top_n : int
        Number of best designs to retain (default 5).
    """

    _CANDIDATE_VALUES = [1, 2, 4, 8, 16]
    _DEFAULT_FPGA = {"LUT": 35200, "FF": 17600, "DSP": 80, "BRAM": 90}
    _TYPE_MAP = {
        "ALU": ALUCore,
        "Activation": ActivationCore,
        "FIFO": FIFOCore,
        "GEMM": GEMMCore,
        "MemRouter": MemRouterCore,
        "Norm": NormCore,
        "Softmax": SoftmaxCore,
        "StatefulNorm": StatefulNormCore,
        "StatefulSoftmax": StatefulSoftmaxCore,
        "TemporalGEMM": TemporalGEMMCore,
    }

    def __init__(
        self,
        spec: dict[str, Any],
        char_db: CharacterizationDB | None = None,
        top_n: int = 5,
    ) -> None:
        self.spec = spec
        self.char_db = char_db or CharacterizationDB()
        self.top_n = top_n
        self.best_latency = float("inf")
        self._heap_counter = 0
        self.top_designs: list[tuple[float, int, dict[str, dict[str, int]], dict[str, Any]]] = []

        constraints = spec.get("constraints", {})
        fpga = constraints.get("fpga", self._DEFAULT_FPGA)
        self.max_lut = fpga.get("LUT", self._DEFAULT_FPGA["LUT"])
        self.max_ff = fpga.get("FF", self._DEFAULT_FPGA["FF"])
        self.max_dsp = fpga.get("DSP", self._DEFAULT_FPGA["DSP"])
        self.max_bram = fpga.get("BRAM", self._DEFAULT_FPGA["BRAM"])

        self.ips = spec["ips"]
        self.edges = spec.get("edges", [])

        self.param_specs: list[tuple[str, str]] = []
        for ip in self.ips:
            for p in ip.get("params", []):
                self.param_specs.append((ip["name"], p))

    def run(self, output_dir: str | None = None) -> list[tuple[float, dict[str, dict[str, int]], dict[str, Any]]]:
        """Execute the branch-and-bound search and optionally emit Verilog.

        Returns
        -------
        list
            Top *N* designs sorted by latency ascending.  Each element is
            ``(latency_ns, config_dict, metrics_dict)``.
        """
        self.best_latency = float("inf")
        self._heap_counter = 0
        self.top_designs = []

        self._dfs(0, {})

        self.top_designs.sort(key=lambda x: (x[0], x[1]))
        results = [(lat, cfg, met) for lat, _, cfg, met in self.top_designs]

        if output_dir is not None:
            os.makedirs(output_dir, exist_ok=True)
            for rank, design in enumerate(results):
                self.output_verilog(design, output_dir, rank)

        return results

    def _dfs(self, idx: int, config: dict[str, dict[str, int]]) -> None:
        if idx == len(self.param_specs):
            self._evaluate_full(config)
            return

        ip_name, param_name = self.param_specs[idx]
        for val in self._CANDIDATE_VALUES:
            config.setdefault(ip_name, {})[param_name] = val
            if not self._prune_by_util(config):
                self._dfs(idx + 1, config)
            del config[ip_name][param_name]
            if not config[ip_name]:
                del config[ip_name]

    def _prune_by_util(self, config: dict[str, dict[str, int]]) -> bool:
        """Return *True* if the partial (or full) assignment exceeds 100 %% util."""
        total = {"LUT": 0, "FF": 0, "DSP": 0, "BRAM": 0}
        for ip in self.ips:
            name = ip["name"]
            params: dict[str, int] = {}
            for p in ip.get("params", []):
                params[p] = config.get(name, {}).get(p, 1)
            for k, v in ip.get("kwargs", {}).items():
                if k not in params:
                    params[k] = v
            metrics = self.char_db.lookup(ip["type"], params)
            for key in total:
                total[key] += int(metrics.get(key, 0))

        util = max(
            total["LUT"] / self.max_lut,
            total["FF"] / self.max_ff,
            total["DSP"] / self.max_dsp,
            total["BRAM"] / self.max_bram,
        )
        if util > 1.0:
            print(f"Prune: util={util:.2%} > 100%")
            return True
        return False

    def _evaluate_full(self, config: dict[str, dict[str, int]]) -> None:
        total = {"LUT": 0, "FF": 0, "DSP": 0, "BRAM": 0}
        ip_metrics: dict[str, dict[str, Any]] = {}

        for ip in self.ips:
            name = ip["name"]
            params: dict[str, int] = {}
            for p in ip.get("params", []):
                params[p] = config.get(name, {}).get(p, 1)
            for k, v in ip.get("kwargs", {}).items():
                if k not in params:
                    params[k] = v
            metrics = self.char_db.lookup(ip["type"], params)
            ip_metrics[name] = metrics
            for key in total:
                total[key] += int(metrics.get(key, 0))

        util = max(
            total["LUT"] / self.max_lut,
            total["FF"] / self.max_ff,
            total["DSP"] / self.max_dsp,
            total["BRAM"] / self.max_bram,
        )
        if util > 1.0:
            print(f"Prune: util={util:.2%} > 100%")
            return

        if util <= 0.5:
            congestion = 0
        elif util <= 0.75:
            congestion = 1
        elif util <= 0.875:
            congestion = 2
        else:
            congestion = 3

        beats_list = [self._compute_beats(ip, config) for ip in self.ips]
        ii_list = [self._compute_ii(ip, config) for ip in self.ips]
        elements_list = [self._compute_total_elements(ip, config) for ip in self.ips]

        max_beats = max(beats_list) if beats_list else 1
        max_ii = max(ii_list) if ii_list else 1
        total_elements = max(elements_list) if elements_list else 1

        fmaxes = []
        for ip in self.ips:
            name = ip["name"]
            metrics = ip_metrics[name]
            cp_ns = metrics["clock_period_ns"] - metrics["wns_ns"]
            if cp_ns <= 0:
                fmax = 1.0
            else:
                fmax = 1000.0 / cp_ns
            fmaxes.append(fmax)

        min_fmax = min(fmaxes)
        total_latency = (1000.0 / min_fmax) * (max_beats * max_ii + congestion)
        per_element_latency = total_latency / total_elements

        if per_element_latency > 1.5 * self.best_latency:
            print(f"Prune: latency={per_element_latency:.2f}ns > 1.5 * best={self.best_latency:.2f}ns")
            return

        if per_element_latency < self.best_latency:
            self.best_latency = per_element_latency

        metrics_dict = {
            "LUT": total["LUT"],
            "FF": total["FF"],
            "DSP": total["DSP"],
            "BRAM": total["BRAM"],
            "utilization": util,
            "congestion": congestion,
            "min_fmax_mhz": min_fmax,
            "max_ii": max_ii,
            "latency_ns": per_element_latency,
        }

        heapq.heappush(self.top_designs, (per_element_latency, self._heap_counter, copy.deepcopy(config), metrics_dict))
        self._heap_counter += 1
        if len(self.top_designs) > self.top_n:
            heapq.heappop(self.top_designs)

    def _compute_ii(self, ip: dict[str, Any], config: dict[str, dict[str, int]]) -> int:
        typ = ip["type"]
        if typ in {"TemporalGEMM", "GEMM"}:
            params: dict[str, int] = {}
            for p in ip.get("params", []):
                params[p] = config.get(ip["name"], {}).get(p, 1)
            for k, v in ip.get("kwargs", {}).items():
                if k not in params:
                    params[k] = v
            return max(1, params.get("T_M", 1) * params.get("T_K", 1) * params.get("T_N", 1))
        return 1

    def _compute_beats(self, ip: dict[str, Any], config: dict[str, dict[str, int]]) -> int:
        typ = ip["type"]
        params: dict[str, int] = {}
        for p in ip.get("params", []):
            params[p] = config.get(ip["name"], {}).get(p, 1)
        for k, v in ip.get("kwargs", {}).items():
            if k not in params:
                params[k] = v
        if typ in {"TemporalGEMM", "GEMM"}:
            m = params.get("M", 1)
            n = params.get("N", 1)
            t_m = params.get("T_M", 1)
            t_n = params.get("T_N", 1)
            return max(1, (m * n) // (t_m * t_n))
        if typ in {"Norm", "StatefulNorm"}:
            return max(1, params.get("N_channel", 1) // params.get("T_channel", 1))
        if typ in {"Softmax", "StatefulSoftmax"}:
            return max(1, params.get("N_seq", 1) // params.get("T_seq", 1))
        if typ == "MemRouter":
            return max(1, params.get("num_beats", 1))
        if typ in {"ALU", "Activation", "FIFO"}:
            n = params.get("N", params.get("seq_len", 1))
            return max(1, n // params.get("T_width", 1))
        return 1

    def _compute_total_elements(self, ip: dict[str, Any], config: dict[str, dict[str, int]]) -> int:
        typ = ip["type"]
        params: dict[str, int] = {}
        for p in ip.get("params", []):
            params[p] = config.get(ip["name"], {}).get(p, 1)
        for k, v in ip.get("kwargs", {}).items():
            if k not in params:
                params[k] = v
        if typ in {"TemporalGEMM", "GEMM"}:
            return max(1, params.get("M", 1) * params.get("N", 1))
        if typ in {"Norm", "StatefulNorm"}:
            return max(1, params.get("N_channel", 1))
        if typ in {"Softmax", "StatefulSoftmax"}:
            return max(1, params.get("N_seq", 1))
        if typ in {"ALU", "Activation", "FIFO"}:
            return max(1, params.get("N", params.get("seq_len", 1)))
        if typ == "MemRouter":
            return max(1, params.get("num_beats", 1) * params.get("T_out", 1))
        return 1

    def output_verilog(
        self,
        design: tuple[float, dict[str, dict[str, int]], dict[str, Any]],
        output_dir: str,
        rank: int | None = None,
    ) -> str | None:
        """Emit Verilog for *design* into *output_dir*.

        Returns the output file path, or *None* if generation fails.
        """
        latency, config, metrics = design
        if rank is None:
            rank = 0

        AXI4StreamLiteBase.reset()
        graph = TiledIPGraph()

        try:
            for ip in self.ips:
                name = ip["name"]
                typ = ip["type"]
                ip_class = self._TYPE_MAP.get(typ)
                if ip_class is None:
                    raise ValueError(f"Unknown IP type: {typ}")

                kwargs: dict[str, Any] = {}
                for p in ip.get("params", []):
                    kwargs[p] = config.get(name, {}).get(p, 1)
                for k, v in ip.get("kwargs", {}).items():
                    if k not in kwargs:
                        kwargs[k] = v

                graph.add_node(name, ip_class, **kwargs)

            for src, dst in self.edges:
                graph.add_edge(src, dst)

            block, drivers = graph.build()
        except Exception as exc:
            print(f"Warning: Failed to build design {rank}: {exc}")
            return None

        with pyrtl.set_working_block(block, no_sanity_check=True):
            driven = set()
            for net in block.logic:
                for d in net.dests:
                    driven.add(d)
            for w in list(block.wirevector_set):
                if w not in driven and not isinstance(
                    w, (pyrtl.Input, pyrtl.Const, pyrtl.Output, pyrtl.Register)
                ):
                    w <<= pyrtl.Const(0, bitwidth=w.bitwidth)

        os.makedirs(output_dir, exist_ok=True)
        out_path = os.path.join(output_dir, f"design_{rank}.v")
        with open(out_path, "w") as f:
            pyrtl.output_to_verilog(f, block=block)

        return out_path


__all__ = ["CharacterizationDB", "Autotuner"]
