#!/usr/bin/env python3
"""Visualize Pareto-optimal IP characterization points in 3D.

This script reads the characterization JSON emitted by scripts/characterize_ips.py,
computes throughput and utilization metrics, identifies non-dominated points, and
renders a 3D scatter plot.
"""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any, cast

import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D  # noqa: F401


@dataclass
class Point:
    label: str
    max_util: float
    throughput_mhz: float
    power_w: float


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Visualize Pareto frontier from characterization results")
    parser.add_argument("--input", default="build/characterization/characterization_results.json")
    parser.add_argument("--output", default="pareto_plot.png")
    parser.add_argument("--show", action="store_true")
    return parser.parse_args()


def load_payload(path: Path) -> dict[str, Any] | None:
    if not path.exists():
        print(f"Error: input file not found: {path}", file=sys.stderr)
        return None
    try:
        return json.loads(path.read_text())
    except json.JSONDecodeError as exc:
        print(f"Error: failed to parse JSON from {path}: {exc}", file=sys.stderr)
        return None


def compute_points(payload: dict[str, Any]) -> list[Point]:
    metadata = payload.get("metadata", {}) if isinstance(payload, dict) else {}
    clock_period = metadata.get("clock_period_ns")
    results = payload.get("results", []) if isinstance(payload, dict) else []
    points: list[Point] = []
    for result in results:
        if not isinstance(result, dict) or result.get("status") != "success":
            continue
        resources = result.get("resources", {})
        timing = result.get("timing", {})
        power = result.get("power", {})
        if clock_period is None or "wns_ns" not in timing:
            continue
        try:
            effective_period = float(clock_period) - float(timing["wns_ns"])
            if effective_period <= 0:
                continue
            fmax_mhz = 1000.0 / effective_period
            max_util = max(float(resources.get(k, 0)) for k in ("LUT", "FF", "DSP", "BRAM"))
            power_w = float(power.get("total_w", 0.0))
            label = str(result.get("ip", "unknown"))
            points.append(Point(label=label, max_util=max_util, throughput_mhz=fmax_mhz, power_w=power_w))
        except (TypeError, ValueError):
            continue
    return points


def dominates(a: Point, b: Point) -> bool:
    return (
        a.max_util <= b.max_util
        and a.throughput_mhz >= b.throughput_mhz
        and a.power_w <= b.power_w
        and (
            a.max_util < b.max_util
            or a.throughput_mhz > b.throughput_mhz
            or a.power_w < b.power_w
        )
    )


def pareto_frontier(points: list[Point]) -> list[Point]:
    frontier: list[Point] = []
    for point in points:
        if any(dominates(other, point) for other in points if other is not point):
            continue
        frontier.append(point)
    return frontier


def plot(points: list[Point], frontier: list[Point], output: Path, show: bool) -> None:
    fig = plt.figure(figsize=(10, 8))
    ax = fig.add_subplot(111, projection="3d")

    if points:
        ax.scatter(
            [p.max_util for p in points],
            [p.throughput_mhz for p in points],
            cast(Any, [p.power_w for p in points]),
            c="lightgray",
            alpha=0.35,
            s=30,
            label="All points",
        )
    if frontier:
        ax.scatter(
            [p.max_util for p in frontier],
            [p.throughput_mhz for p in frontier],
            cast(Any, [p.power_w for p in frontier]),
            c="red",
            s=70,
            label="Pareto-optimal",
        )

    ax.set_xlabel("Max Utilization (resources)")
    ax.set_ylabel("Throughput (MHz)")
    ax.set_zlabel("Power (W)")
    ax.set_title("Pareto Frontier: Utilization vs Throughput vs Power")
    ax.legend(loc="best")
    fig.tight_layout()
    fig.savefig(output, dpi=200)
    if show:
        plt.show()
    plt.close(fig)


def main() -> int:
    args = parse_args()
    payload = load_payload(Path(args.input))
    if payload is None:
        return 0
    points = compute_points(payload)
    if not points:
        print("No successful characterization points found to plot.", file=sys.stderr)
        return 0
    frontier = pareto_frontier(points)
    plot(points, frontier, Path(args.output), args.show)
    print(f"Saved Pareto plot to {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
