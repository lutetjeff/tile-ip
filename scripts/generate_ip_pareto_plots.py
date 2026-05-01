#!/usr/bin/env python3
"""Generate Pareto frontier plots for each IP type.

Sweeps tile parameters over {1, 2, 4, 8, 16} and plots LUT vs latency
with the Pareto frontier highlighted in red.
"""

from __future__ import annotations

import os
import sys

# Add src to path for imports
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "src"))

import matplotlib.pyplot as plt

from autotuner import CharacterizationDB


def compute_latency(metrics: dict, ip_type: str, params: dict) -> float:
    """Compute latency per element in ns for a given IP type and parameters.

    fmax = 1000 / (clock_period_ns - wns_ns)
    latency_ns = (1000 / fmax) * (II + C) where C=0 for single IP
    II = 1 for most IPs, II = (M*N)/(T_M*T_N) for GEMM/TemporalGEMM

    Latency is divided by the tile factor T to get latency per element,
    since larger tiles process more elements in parallel per beat.
    """
    cp_ns = metrics["clock_period_ns"] - metrics["wns_ns"]
    if cp_ns <= 0:
        fmax = 1.0
    else:
        fmax = 1000.0 / cp_ns

    # Compute II
    if ip_type in ("GEMM", "TemporalGEMM"):
        t_m = params.get("T_M", 1)
        t_n = params.get("T_N", 1)
        # Default M, N based on tile params if not specified
        m = params.get("M", t_m) if t_m > 0 else 1
        n = params.get("N", t_n) if t_n > 0 else 1
        if t_m <= 0 or t_n <= 0:
            ii = 1
        else:
            ii = (m * n) // (t_m * t_n)
    else:
        ii = 1

    # C = 0 for single IP evaluation
    total_latency_ns = (1000.0 / fmax) * (ii + 0)

    # Divide by T factor to get latency per element
    if ip_type in ("ALUCore", "ActivationCore", "FIFOCore"):
        t_factor = params.get("T_width", 1)
    elif ip_type in ("TemporalGEMMCore", "GEMMCore"):
        t_factor = params.get("T_M", 1) * params.get("T_N", 1)
    elif ip_type == "StatefulNormCore":
        t_factor = params.get("T_channel", 1)
    elif ip_type == "StatefulSoftmaxCore":
        t_factor = params.get("T_seq", 1)
    elif ip_type == "SoftmaxCore":
        t_factor = params.get("T_seq", 1)
    elif ip_type == "NormCore":
        t_factor = params.get("T_channel", 1)
    elif ip_type == "MemRouterCore":
        t_factor = params.get("T_out", 1)
    else:
        t_factor = 1

    if t_factor <= 0:
        t_factor = 1

    latency_per_element_ns = total_latency_ns / t_factor
    return latency_per_element_ns


def is_pareto_efficient(costs: list[tuple[float, float]]) -> list[bool]:
    """Identify Pareto-efficient points.

    Args:
        costs: List of (lut, latency) tuples - lower is better for both.

    Returns:
        List of booleans where True indicates a Pareto-efficient point.
    """
    n = len(costs)
    is_pareto = [True] * n

    for i in range(n):
        for j in range(n):
            if i == j:
                continue
            # Check if j dominates i (j has both lower LUT and lower latency)
            if costs[j][0] <= costs[i][0] and costs[j][1] <= costs[i][1]:
                if costs[j][0] < costs[i][0] or costs[j][1] < costs[i][1]:
                    is_pareto[i] = False
                    break

    return is_pareto


def get_ip_sweep_params(ip_type: str) -> list[tuple[str, list[int]]]:
    """Return list of (param_name, values) to sweep for each IP type."""
    sweep_values = [1, 2, 4, 8, 16]

    if ip_type == "ALUCore":
        return [("T_width", sweep_values)]
    elif ip_type == "TemporalGEMMCore":
        # Vary T_K, T_N with T_M=1 fixed
        return [("T_K", sweep_values), ("T_N", sweep_values)]
    elif ip_type == "StatefulNormCore":
        # Vary T_channel with N_channel=16 fixed
        return [("T_channel", sweep_values)]
    elif ip_type == "StatefulSoftmaxCore":
        # Vary T_seq with N_seq=16 fixed
        return [("T_seq", sweep_values)]
    elif ip_type == "ActivationCore":
        return [("T_width", sweep_values)]
    elif ip_type == "FIFOCore":
        # Vary T_width and depth
        return [("T_width", sweep_values), ("depth", sweep_values)]
    elif ip_type == "GEMMCore":
        # Vary T_K, T_N with T_M=1 fixed
        return [("T_K", sweep_values), ("T_N", sweep_values)]
    elif ip_type == "SoftmaxCore":
        return [("T_seq", sweep_values)]
    elif ip_type == "NormCore":
        return [("T_channel", sweep_values)]
    elif ip_type == "MemRouterCore":
        return [("T_out", sweep_values)]
    else:
        return []


def _make_label(params: dict[str, int], ip_type: str) -> str:
    """Create a short label string from swept parameters."""
    if ip_type in ("ALUCore", "ActivationCore"):
        return f"T={params.get('T_width', '?')}"
    elif ip_type == "FIFOCore":
        return f"W={params.get('T_width', '?')},D={params.get('depth', '?')}"
    elif ip_type in ("TemporalGEMMCore", "GEMMCore"):
        return f"K={params.get('T_K', '?')},M={params.get('T_M', '?')},N={params.get('T_N', '?')}"
    elif ip_type == "StatefulNormCore":
        return f"T={params.get('T_channel', '?')}"
    elif ip_type == "StatefulSoftmaxCore":
        return f"T={params.get('T_seq', '?')}"
    elif ip_type == "SoftmaxCore":
        return f"T={params.get('T_seq', '?')}"
    elif ip_type == "NormCore":
        return f"T={params.get('T_channel', '?')}"
    elif ip_type == "MemRouterCore":
        return f"T={params.get('T_out', '?')}"
    return "?"


def sweep_ip_params(char_db: CharacterizationDB, ip_type: str) -> tuple[list[int], list[float], list[bool], list[str]]:
    """Sweep parameters for an IP type and return LUTs, latencies, Pareto flags, and labels.

    Returns:
        Tuple of (lut_list, latency_list, is_pareto_list, label_list)
    """
    sweep_specs = get_ip_sweep_params(ip_type)
    if not sweep_specs:
        return [], [], [], []

    def generate_combinations(index: int, current: dict[str, int]) -> list[dict[str, int]]:
        if index == len(sweep_specs):
            return [current.copy()]

        param_name, values = sweep_specs[index]
        results = []
        for val in values:
            current[param_name] = val
            results.extend(generate_combinations(index + 1, current))
            del current[param_name]
        return results

    all_params = generate_combinations(0, {})

    for params in all_params:
        if ip_type == "StatefulNormCore":
            params["N_channel"] = 16
        elif ip_type == "StatefulSoftmaxCore":
            params["N_seq"] = 16
        elif ip_type in ("GEMMCore", "TemporalGEMMCore"):
            params["T_M"] = 1

    luts = []
    latencies = []
    labels = []

    for params in all_params:
        metrics = char_db.lookup(ip_type, params)
        lut = metrics["LUT"]
        latency = compute_latency(metrics, ip_type, params)
        luts.append(lut)
        latencies.append(latency)
        labels.append(_make_label(params, ip_type))

    costs = list(zip(luts, latencies))
    is_pareto = is_pareto_efficient(costs)

    return luts, latencies, is_pareto, labels


def plot_pareto_frontier(
    luts: list[int],
    latencies: list[float],
    is_pareto: list[bool],
    labels: list[str],
    ip_type: str,
    output_path: str,
) -> None:
    """Generate and save a Pareto frontier plot."""
    plt.figure(figsize=(10, 6))

    pareto_luts = [luts[i] for i in range(len(luts)) if is_pareto[i]]
    pareto_lats = [latencies[i] for i in range(len(latencies)) if is_pareto[i]]
    pareto_labels = [labels[i] for i in range(len(labels)) if is_pareto[i]]
    non_pareto_luts = [luts[i] for i in range(len(luts)) if not is_pareto[i]]
    non_pareto_lats = [latencies[i] for i in range(len(latencies)) if not is_pareto[i]]
    non_pareto_labels = [labels[i] for i in range(len(labels)) if not is_pareto[i]]

    plt.scatter(
        non_pareto_luts,
        non_pareto_lats,
        c="blue",
        label="Dominated",
        alpha=0.6,
        s=50,
    )

    plt.scatter(
        pareto_luts,
        pareto_lats,
        c="red",
        label="Pareto Frontier",
        alpha=0.9,
        s=80,
        edgecolors="darkred",
        zorder=5,
    )

    for x, y, lbl in zip(non_pareto_luts, non_pareto_lats, non_pareto_labels):
        plt.annotate(
            lbl, (x, y), xytext=(5, 5), textcoords="offset points",
            fontsize=7, color="gray", alpha=0.7,
        )

    for x, y, lbl in zip(pareto_luts, pareto_lats, pareto_labels):
        plt.annotate(
            lbl, (x, y), xytext=(5, 5), textcoords="offset points",
            fontsize=8, color="darkred", fontweight="bold",
        )

    if pareto_luts:
        sorted_indices = sorted(range(len(pareto_luts)), key=lambda i: pareto_luts[i])
        pareto_luts_sorted = [pareto_luts[i] for i in sorted_indices]
        pareto_lats_sorted = [pareto_lats[i] for i in sorted_indices]
        plt.plot(pareto_luts_sorted, pareto_lats_sorted, "r--", alpha=0.7, linewidth=1.5)

    plt.xlabel("LUT (resource)", fontsize=12)
    plt.ylabel("Latency per Element (ns)", fontsize=12)
    plt.title(f"Pareto Frontier: {ip_type}", fontsize=14)
    plt.legend(loc="upper right")
    plt.grid(True, alpha=0.3)
    plt.tight_layout()
    plt.savefig(output_path, dpi=150)
    plt.close()


def main() -> None:
    """Main entry point."""
    # Create output directory
    output_dir = os.path.join(os.path.dirname(__file__), "..", "build", "pareto_plots")
    os.makedirs(output_dir, exist_ok=True)
    print(f"Output directory: {output_dir}")

    # Initialize characterization database
    char_db = CharacterizationDB()

    # List of IP types to process
    ip_types = [
        "ALUCore",
        "TemporalGEMMCore",
        "StatefulNormCore",
        "StatefulSoftmaxCore",
        "ActivationCore",
        "FIFOCore",
        "GEMMCore",
        "SoftmaxCore",
        "NormCore",
        "MemRouterCore",
    ]

    for ip_type in ip_types:
        print(f"Processing {ip_type}...")
        luts, latencies, is_pareto, labels = sweep_ip_params(char_db, ip_type)

        if not luts:
            print(f"  No data for {ip_type}, skipping.")
            continue

        n_pareto = sum(is_pareto)
        print(f"  {len(luts)} configurations, {n_pareto} on Pareto frontier")

        output_path = os.path.join(output_dir, f"{ip_type}_pareto.png")
        plot_pareto_frontier(luts, latencies, is_pareto, labels, ip_type, output_path)
        print(f"  Saved: {output_path}")

    print("\nDone! Pareto plots saved to:", output_dir)


if __name__ == "__main__":
    main()
