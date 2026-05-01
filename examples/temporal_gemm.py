#!/usr/bin/env python3
"""Example: Standalone TemporalGEMM core simulation.

Demonstrates how to instantiate and simulate a single TemporalGEMMCore
for accumulator-based matrix multiplication.
"""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent / "src"))

import numpy as np
import pyrtl

from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ip_cores.temporal_gemm import TemporalGEMMCore


def _pack_bytes(values):
    out = 0
    for i, value in enumerate(values):
        out |= (int(value) & 0xFF) << (8 * i)
    return out


def main():
    AXI4StreamLiteBase.reset()

    # Small TemporalGEMM: 4x4 output matrix, 2x2 tiles
    T_M, T_K, T_N = 2, 2, 2
    M, N = 4, 4
    core = TemporalGEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, M=M, N=N, name="tgemm")

    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        d_in = pyrtl.Input(core.data_in.bitwidth, "d_in")
        v_in = pyrtl.Input(1, "v_in")
        r_in = pyrtl.Input(1, "r_in")
        w_in = pyrtl.Input(core.weight_in.bitwidth, "w_in")
        wv_in = pyrtl.Input(1, "wv_in")
        accum_in = pyrtl.Input(1, "accum_in")
        emit_in = pyrtl.Input(1, "emit_in")

        core.data_in <<= d_in
        core.valid_in <<= v_in
        core.ready_in <<= r_in
        core.weight_in <<= w_in
        core.weight_valid_in <<= wv_in
        core.accum_in <<= accum_in
        core.emit_in <<= emit_in

    # Expose output for simulation
    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        data_out = pyrtl.Output(core.data_out.bitwidth, "data_out")
        valid_out = pyrtl.Output(1, "valid_out")
        ready_out = pyrtl.Output(1, "ready_out")
        data_out <<= core.data_out
        valid_out <<= core.valid_out
        ready_out <<= core.ready_out

    sim = pyrtl.Simulation(tracer=None, block=core.block)

    input_tile = _pack_bytes([1, 2, 3, 4])
    weight_tile = _pack_bytes([1, 1, 1, 1])

    # Feed 4 tiles to accumulate, then emit
    for _ in range(3):
        sim.step(
            {
                "d_in": input_tile,
                "v_in": 1,
                "r_in": 1,
                "w_in": weight_tile,
                "wv_in": 1,
                "accum_in": 1,
                "emit_in": 0,
            }
        )

    # Final tile with emit
    sim.step(
        {
            "d_in": input_tile,
            "v_in": 1,
            "r_in": 1,
            "w_in": weight_tile,
            "wv_in": 1,
            "accum_in": 1,
            "emit_in": 1,
        }
    )

    print("TemporalGEMM simulation complete.")
    print(f"  data_out={sim.inspect('data_out')}")
    print(f"  valid_out={sim.inspect('valid_out')}")
    print(f"  ready_out={sim.inspect('ready_out')}")


if __name__ == "__main__":
    main()
