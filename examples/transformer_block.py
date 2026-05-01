#!/usr/bin/env python3
"""Example: Full transformer block using TiledIPGraph.

Demonstrates the declarative frontend API to build a complete transformer
with attention and FFN paths, residual connections, and shape propagation.

To run a functional simulation, see tests/test_transformer_block.py.
"""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent / "src"))

import pyrtl

from frontend import TiledIPGraph
from ip_cores.activation import ActivationCore
from ip_cores.alu import ALUCore
from ip_cores.fifo import FIFOCore
from ip_cores.stateful_norm import StatefulNormCore
from ip_cores.stateful_softmax import StatefulSoftmaxCore
from ip_cores.temporal_gemm import TemporalGEMMCore


def build_transformer(seq_len=4, emb_dim=4, T=2):
    """Build a transformer block using TiledIPGraph."""
    graph = TiledIPGraph()
    graph.add_node("fifo1", FIFOCore, T_width=T, depth=8)
    graph.add_node("norm1", StatefulNormCore, T_channel=T, N_channel=seq_len)
    graph.add_node("tgemm1", TemporalGEMMCore, T_M=1, T_K=T, T_N=T, M=seq_len // T, N=T)
    graph.add_node("softmax", StatefulSoftmaxCore, N_seq=seq_len, T_seq=T)
    graph.add_node("tgemm2", TemporalGEMMCore, T_M=1, T_K=T, T_N=T, M=seq_len // T, N=T)
    graph.add_node("alu1", ALUCore, T_width=T, op_mode="add")
    graph.add_node("df1", FIFOCore, T_width=T, depth=1)
    graph.add_node("df2", FIFOCore, T_width=T, depth=1)
    graph.add_node("df3", FIFOCore, T_width=T, depth=1)
    graph.add_node("df4", FIFOCore, T_width=T, depth=1)
    graph.add_node("fifo2", FIFOCore, T_width=T, depth=8)
    graph.add_node("norm2", StatefulNormCore, T_channel=T, N_channel=seq_len)
    graph.add_node("tgemm3", TemporalGEMMCore, T_M=1, T_K=T, T_N=T, M=seq_len // T, N=T)
    graph.add_node("activation", ActivationCore, T_width=T, activation_type="relu")
    graph.add_node("tgemm4", TemporalGEMMCore, T_M=1, T_K=T, T_N=T, M=seq_len // T, N=T)
    graph.add_node("alu2", ALUCore, T_width=T, op_mode="add")

    for src, dst in [
        ("norm1", "tgemm1"),
        ("tgemm1", "softmax"),
        ("softmax", "tgemm2"),
        ("tgemm2", "alu1"),
        ("fifo1", "alu1"),
        ("alu1", "norm2"),
        ("alu1", "df1"),
        ("df1", "df2"),
        ("df2", "df3"),
        ("df3", "df4"),
        ("df4", "fifo2"),
        ("norm2", "tgemm3"),
        ("tgemm3", "activation"),
        ("activation", "tgemm4"),
        ("tgemm4", "alu2"),
        ("fifo2", "alu2"),
    ]:
        graph.add_edge(src, dst)

    graph.set_input_shape("fifo1", seq_len, T)
    graph.set_input_shape("norm1", seq_len, T)
    graph.set_input_shape("fifo2", seq_len, T)

    block, drivers = graph.build()

    # Drive TemporalGEMM side ports (accum_in, emit_in, weight_in)
    # In a real design these would come from upstream logic or be configurable
    with pyrtl.set_working_block(block, no_sanity_check=True):
        for name in ["tgemm1", "tgemm2", "tgemm3", "tgemm4"]:
            tgemm = graph._stitcher._ips[name]
            tgemm.accum_in <<= pyrtl.Const(1, bitwidth=1)
            tgemm.emit_in <<= pyrtl.Const(0, bitwidth=1)
            # Weight ports would normally be driven by a weight loader
            # For this example we leave them as dangling inputs

    return block, drivers, graph


def main():
    block, drivers, graph = build_transformer(seq_len=4, emb_dim=4, T=2)
    print("Transformer block built successfully!")
    print(f"  Drivers: {list(drivers.keys())}")
    print(f"  Number of IPs: {len(graph._stitcher._ips)}")
    print(f"  Block has {len(list(block.logic))} nets")


if __name__ == "__main__":
    main()
