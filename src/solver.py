"""TilingSolver: DP-based search for optimal tiling configurations.

Searches the discrete tiling-parameter space {1, 2, 4}^k to minimise a
hardware cost function (area estimate + latency estimate) subject to a
user-supplied timing constraint on combinational critical-path depth.
"""

from __future__ import annotations

import itertools
import math
from typing import Any


class TilingSolver:
    """Search for optimal tiling configurations of accelerator subgraphs.

    Parameters
    ----------
    max_path_depth : int
        Maximum allowed combinational critical-path depth (in gate
        equivalents).  Configurations whose estimated critical path exceeds
        this value are pruned.
    """

    _LUT_GEMM_PER_ELEMENT = 50
    _LUT_SOFTMAX_PER_ELEMENT = 30
    _LUT_NORM_PER_ELEMENT = 25
    _LUT_ACTIVATION_PER_ELEMENT = 10
    _LUT_ALU_PER_ELEMENT = 15
    _LUT_MEMROUTER_PER_ELEMENT = 5

    def __init__(self, max_path_depth: int = 20) -> None:
        self.max_path_depth = max_path_depth

    def solve(self, subgraph: dict[str, Any]) -> dict[str, dict[str, int]]:
        """Return the optimal tiling configuration for *subgraph*.

        Parameters
        ----------
        subgraph : dict
            Must contain:

            * ``ips`` – list of IP descriptors::

                [{"type": "GEMM", "name": "gemm_qk",
                  "params": ["T_M", "T_K", "T_N"]}, ...]

            * ``edges`` – list of ``(src_name, dst_name)`` tuples defining
              the connectivity graph.

            * ``constraints`` *(optional)* – dict with keys such as
              ``max_area``.

        Returns
        -------
        dict[str, dict[str, int]]
            Mapping from IP name to parameter name to chosen value.

        Raises
        ------
        ValueError
            If no configuration satisfies the timing (and optional area)
            constraints.
        """
        ips = subgraph["ips"]
        edges = subgraph.get("edges", [])
        constraints = subgraph.get("constraints", {})
        max_area = constraints.get("max_area", None)

        param_specs: list[tuple[str, str]] = []
        for ip in ips:
            for p in ip["params"]:
                param_specs.append((ip["name"], p))

        candidate_values = [1, 2, 4]

        best_config: dict[str, dict[str, int]] | None = None
        best_cost = float("inf")

        for values in itertools.product(candidate_values, repeat=len(param_specs)):
            config: dict[str, dict[str, int]] = {}
            for (ip_name, param_name), val in zip(param_specs, values):
                config.setdefault(ip_name, {})[param_name] = val

            for ip in ips:
                config.setdefault(ip["name"], {})

            critical_path = self._critical_path_depth(ips, edges, config)
            if critical_path > self.max_path_depth:
                continue

            area = self._total_area(ips, config)
            if max_area is not None and area > max_area:
                continue

            latency = self._total_latency(ips, edges, config)
            cost = area + latency

            if cost < best_cost:
                best_cost = cost
                best_config = config

        if best_config is None:
            raise ValueError(
                f"No valid tiling configuration found within max_path_depth={self.max_path_depth}"
                + (f" and max_area={max_area}" if max_area is not None else "")
            )

        return best_config

    def _total_area(self, ips: list[dict], config: dict[str, dict[str, int]]) -> int:
        total = 0
        for ip in ips:
            name = ip["name"]
            typ = ip["type"]
            params = config.get(name, {})
            total += self._ip_area(typ, params)
        return total

    def _ip_area(self, typ: str, params: dict[str, int]) -> int:
        if typ == "GEMM":
            return (
                params.get("T_M", 1)
                * params.get("T_K", 1)
                * params.get("T_N", 1)
                * self._LUT_GEMM_PER_ELEMENT
            )
        if typ == "Softmax":
            return params.get("T_seq", 1) * self._LUT_SOFTMAX_PER_ELEMENT
        if typ == "Norm":
            return params.get("T_channel", 1) * self._LUT_NORM_PER_ELEMENT
        if typ == "Activation":
            return params.get("T_width", 1) * self._LUT_ACTIVATION_PER_ELEMENT
        if typ == "ALU":
            return params.get("T_width", 1) * self._LUT_ALU_PER_ELEMENT
        if typ == "MemRouter":
            return params.get("T_out", 1) * self._LUT_MEMROUTER_PER_ELEMENT
        return 0

    def _total_latency(
        self,
        ips: list[dict],
        edges: list[tuple[str, str]],
        config: dict[str, dict[str, int]],
    ) -> int:
        ip_names = {ip["name"] for ip in ips}
        adj: dict[str, list[str]] = {n: [] for n in ip_names}
        in_degree: dict[str, int] = {n: 0 for n in ip_names}
        for src, dst in edges:
            adj[src].append(dst)
            in_degree[dst] += 1

        latencies = {
            ip["name"]: self._ip_latency(ip["type"], config.get(ip["name"], {}))
            for ip in ips
        }

        dist = {n: latencies[n] for n in ip_names}
        queue = [n for n, d in in_degree.items() if d == 0]
        processed = 0
        while queue:
            n = queue.pop()
            processed += 1
            for nb in adj[n]:
                if dist[nb] < dist[n] + latencies[nb]:
                    dist[nb] = dist[n] + latencies[nb]
                in_degree[nb] -= 1
                if in_degree[nb] == 0:
                    queue.append(nb)

        if processed != len(ip_names):
            raise ValueError("Cycle detected in subgraph edges")

        return max(dist.values())

    def _ip_latency(self, typ: str, params: dict[str, int]) -> int:
        if typ == "GEMM":
            return params.get("T_K", 1) + 1
        if typ == "Softmax":
            t = params.get("T_seq", 1)
            return int(math.log2(t)) + t + int(math.log2(t)) + 1
        if typ == "Norm":
            return int(math.log2(params.get("T_channel", 1))) + 1
        if typ == "Activation":
            return 0
        if typ == "ALU":
            return 1
        if typ == "MemRouter":
            return params.get("T_out", 1)
        return 0

    def _critical_path_depth(
        self,
        ips: list[dict],
        edges: list[tuple[str, str]],
        config: dict[str, dict[str, int]],
    ) -> int:
        ip_names = {ip["name"] for ip in ips}
        adj: dict[str, list[str]] = {n: [] for n in ip_names}
        in_degree: dict[str, int] = {n: 0 for n in ip_names}
        for src, dst in edges:
            adj[src].append(dst)
            in_degree[dst] += 1

        depths = {
            ip["name"]: self._ip_depth(ip["type"], config.get(ip["name"], {}))
            for ip in ips
        }

        dist = {n: depths[n] for n in ip_names}
        queue = [n for n, d in in_degree.items() if d == 0]
        processed = 0
        while queue:
            n = queue.pop()
            processed += 1
            for nb in adj[n]:
                if dist[nb] < dist[n] + depths[nb]:
                    dist[nb] = dist[n] + depths[nb]
                in_degree[nb] -= 1
                if in_degree[nb] == 0:
                    queue.append(nb)

        if processed != len(ip_names):
            raise ValueError("Cycle detected in subgraph edges")

        return max(dist.values())

    def _ip_depth(self, typ: str, params: dict[str, int]) -> int:
        if typ == "GEMM":
            return int(math.log2(params.get("T_K", 1))) * 3
        if typ == "Softmax":
            t = params.get("T_seq", 1)
            return int(math.log2(t)) * 2 + 8
        if typ == "Norm":
            return int(math.log2(params.get("T_channel", 1))) * 2 + 4
        if typ == "Activation":
            return 2
        if typ == "ALU":
            return 3
        if typ == "MemRouter":
            return 2
        return 0
