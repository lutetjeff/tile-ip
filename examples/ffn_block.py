#!/usr/bin/env python3
"""Example: Feed-Forward Network block using TiledIPGraph.

Demonstrates the declarative frontend API to build a simple FFN pipeline:
Norm -> Activation -> ALU_Add (with second operand driven externally)
"""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent / "src"))

import pyrtl

from frontend import TiledIPGraph
from ip_cores.activation import ActivationCore
from ip_cores.alu import ALUCore
from ip_cores.stateful_norm import StatefulNormCore


def main():
    graph = TiledIPGraph()
    graph.add_node("norm", StatefulNormCore, T_channel=4, N_channel=16)
    graph.add_node("act", ActivationCore, T_width=4, activation_type="relu")
    graph.add_node("alu", ALUCore, T_width=4, op_mode="add")
    graph.add_edge("norm", "act")
    graph.add_edge("act", "alu")
    block, drivers = graph.build()

    # Drive ALU's second input (data_in_b) for residual add
    with pyrtl.set_working_block(block, no_sanity_check=True):
        alu_data_in_b = pyrtl.Input(32, "alu_data_in_b")
        alu = graph._stitcher._ips["alu"]
        alu.data_in_b <<= alu_data_in_b

    print("FFN block built successfully!")
    print(f"  Drivers: {list(drivers.keys())}")
    print(f"  Number of IPs: {len(graph._stitcher._ips)}")
    print(f"  Block has {len(list(block.logic))} nets")


if __name__ == "__main__":
    main()
