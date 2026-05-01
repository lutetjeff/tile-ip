"""Transformer block assembly using the tiled-ip framework.

Assembles a simplified transformer-like block with:
- Single input FIFO that fans out to residual FIFO and StatefulNorm
- Attention path: StatefulNorm -> TemporalGEMM -> StatefulSoftmax -> TemporalGEMM -> ALU_Add (residual)
- FFN path: StatefulNorm -> TemporalGEMM -> Activation -> TemporalGEMM -> ALU_Add (residual)
- Output
"""

from __future__ import annotations

import pyrtl
from pyrtl import WireVector

from ip_cores.axi_stream_base import AXI4StreamLiteBase, StreamShape
from ip_cores.stateful_norm import StatefulNormCore
from ip_cores.temporal_gemm import TemporalGEMMCore
from ip_cores.stateful_softmax import StatefulSoftmaxCore
from ip_cores.alu import ALUCore
from ip_cores.fifo import FIFOCore
from ip_cores.activation import ActivationCore
from frontend import TiledIPGraph


def _compute_fifo_depths(seq_len: int, emb_dim: int, T: int) -> tuple[int, int]:
    """Compute residual FIFO depths for the transformer block.

    Each residual FIFO must buffer enough beats to cover the latency of
    the parallel compute path. The compute path processes one full
    sequence (N/T beats) before producing output, so the FIFO must hold
    all beats that accumulate while the compute path is busy.

    Attention path (fifo1): norm1 → tgemm1 → softmax → tgemm2
    FFN path (fifo2):       norm2 → tgemm3 → activation → tgemm4

    Returns (fifo1_depth, fifo2_depth).
    """
    num_beats = seq_len // T

    # StatefulNorm: double-buffered, accepts num_beats then processes.
    # Latency = num_beats (accumulate) + num_beats (emit) = 2 * num_beats
    # But double-buffering means it can overlap: effective = num_beats
    # (it starts emitting while accepting the next sequence)
    norm_latency = num_beats

    # TemporalGEMM: accumulates num_tiles beats then emits num_tiles beats.
    # num_tiles = (M * N) / (T_M * T_N) where M=seq_len//T, N=T, T_M=1, T_N=T
    # = (seq_len//T * T) / (1 * T) = seq_len//T = num_beats
    # Latency = num_beats (accumulate) + num_beats (emit) = 2 * num_beats
    tgemm_latency = 2 * num_beats

    # StatefulSoftmax: 3-pass over num_beats each.
    # Pass 1: find max (num_beats), Pass 2: sum exp (num_beats), Pass 3: normalize (num_beats)
    # Triple-buffered (tokens_in_flight < 3), but each pass takes num_beats cycles.
    # Total latency = 3 * num_beats
    softmax_latency = 3 * num_beats

    # Activation: combinational (0 cycles)
    activation_latency = 0

    # ALU: 1-cycle registered output
    alu_latency = 1

    # Attention path: norm1 + tgemm1 + softmax + tgemm2
    attn_latency = norm_latency + tgemm_latency + softmax_latency + tgemm_latency

    # FFN path: norm2 + tgemm3 + activation + tgemm4
    ffn_latency = norm_latency + tgemm_latency + activation_latency + tgemm_latency

    # Add margin for pipeline bubbles and backpressure settling
    fifo1_depth = attn_latency + num_beats
    fifo2_depth = ffn_latency + num_beats

    return fifo1_depth, fifo2_depth


def build_transformer_block(seq_len: int = 4, emb_dim: int = 4, T: int = 2):
    """Build a transformer block with the tiled-ip framework.

    Parameters
    ----------
    seq_len : int
        Sequence length (default 4).
    emb_dim : int
        Embedding dimension (default 4).
    T : int
        Tile size used for T_width, T_seq, T_channel, T_K, T_N (default 2).

    Returns
    -------
    tuple
        (built_block, drivers, manual_inputs)
        *built_block* is the shared PyRTL block.
        *drivers* is the dict returned by ``Stitcher.build()``.
        *manual_inputs* maps descriptive names to wrapper ``Input`` wires
        for ports that were wired manually after ``stitcher.build()``.
    """
    AXI4StreamLiteBase.reset()
    graph = TiledIPGraph()
    input_fifo = graph.add_node("input_fifo", FIFOCore, T_width=T, depth=1)
    fifo1_depth, fifo2_depth = _compute_fifo_depths(seq_len, emb_dim, T)
    fifo1 = graph.add_node("fifo1", FIFOCore, T_width=T, depth=fifo1_depth)
    norm1 = graph.add_node("norm1", StatefulNormCore, T_channel=T, N_channel=seq_len)
    tgemm1 = graph.add_node(
        "tgemm1", TemporalGEMMCore, T_M=1, T_K=T, T_N=T, M=seq_len // T, N=T
    )
    softmax = graph.add_node("softmax", StatefulSoftmaxCore, N_seq=seq_len, T_seq=T)
    tgemm2 = graph.add_node(
        "tgemm2", TemporalGEMMCore, T_M=1, T_K=T, T_N=T, M=seq_len // T, N=T
    )
    alu1 = graph.add_node("alu1", ALUCore, T_width=T, op_mode="add")
    fifo2 = graph.add_node("fifo2", FIFOCore, T_width=T, depth=fifo2_depth)
    norm2 = graph.add_node("norm2", StatefulNormCore, T_channel=T, N_channel=seq_len)
    tgemm3 = graph.add_node(
        "tgemm3", TemporalGEMMCore, T_M=1, T_K=T, T_N=T, M=seq_len // T, N=T
    )
    activation = graph.add_node("activation", ActivationCore, T_width=T, activation_type="relu")
    tgemm4 = graph.add_node(
        "tgemm4", TemporalGEMMCore, T_M=1, T_K=T, T_N=T, M=seq_len // T, N=T
    )
    alu2 = graph.add_node("alu2", ALUCore, T_width=T, op_mode="add")

    graph.add_edge("input_fifo", "fifo1")
    graph.add_edge("input_fifo", "norm1")
    graph.add_edge("norm1", "tgemm1")
    graph.add_edge("tgemm1", "softmax")
    graph.add_edge("softmax", "tgemm2")
    graph.add_edge("tgemm2", "alu1")
    graph.add_edge("fifo1", "alu1")
    graph.add_edge("alu1", "fifo2")
    graph.add_edge("alu1", "norm2")
    graph.add_edge("norm2", "tgemm3")
    graph.add_edge("tgemm3", "activation")
    graph.add_edge("activation", "tgemm4")
    graph.add_edge("tgemm4", "alu2")
    graph.add_edge("fifo2", "alu2")

    graph.set_input_shape("input_fifo", seq_len, T)
    graph.set_input_shape("fifo2", seq_len, T)

    input_fifo.input_shape = StreamShape(seq_len, T)
    fifo1.input_shape = StreamShape(seq_len, T)
    norm1.input_shape = StreamShape(seq_len, T)
    fifo2.input_shape = StreamShape(seq_len, T)

    built_block, drivers = graph.build()

    with pyrtl.set_working_block(built_block, no_sanity_check=True):
        drv_tgemm1_weight_in = pyrtl.Input(
            bitwidth=tgemm1.weight_in.bitwidth, name="drv_tgemm1_weight_in"
        )
        drv_tgemm1_weight_valid = pyrtl.Input(bitwidth=1, name="drv_tgemm1_weight_valid")
        tgemm1.weight_in <<= drv_tgemm1_weight_in
        tgemm1.weight_valid_in <<= drv_tgemm1_weight_valid

        drv_tgemm2_weight_in = pyrtl.Input(
            bitwidth=tgemm2.weight_in.bitwidth, name="drv_tgemm2_weight_in"
        )
        drv_tgemm2_weight_valid = pyrtl.Input(bitwidth=1, name="drv_tgemm2_weight_valid")
        tgemm2.weight_in <<= drv_tgemm2_weight_in
        tgemm2.weight_valid_in <<= drv_tgemm2_weight_valid

        drv_tgemm3_weight_in = pyrtl.Input(
            bitwidth=tgemm3.weight_in.bitwidth, name="drv_tgemm3_weight_in"
        )
        drv_tgemm3_weight_valid = pyrtl.Input(bitwidth=1, name="drv_tgemm3_weight_valid")
        tgemm3.weight_in <<= drv_tgemm3_weight_in
        tgemm3.weight_valid_in <<= drv_tgemm3_weight_valid

        drv_tgemm4_weight_in = pyrtl.Input(
            bitwidth=tgemm4.weight_in.bitwidth, name="drv_tgemm4_weight_in"
        )
        drv_tgemm4_weight_valid = pyrtl.Input(bitwidth=1, name="drv_tgemm4_weight_valid")
        tgemm4.weight_in <<= drv_tgemm4_weight_in
        tgemm4.weight_valid_in <<= drv_tgemm4_weight_valid

        tgemm1.accum_in <<= pyrtl.Const(1, bitwidth=1)
        tgemm1.emit_in <<= pyrtl.Const(0, bitwidth=1)
        tgemm2.accum_in <<= pyrtl.Const(1, bitwidth=1)
        tgemm2.emit_in <<= pyrtl.Const(0, bitwidth=1)
        tgemm3.accum_in <<= pyrtl.Const(1, bitwidth=1)
        tgemm3.emit_in <<= pyrtl.Const(0, bitwidth=1)
        tgemm4.accum_in <<= pyrtl.Const(1, bitwidth=1)
        tgemm4.emit_in <<= pyrtl.Const(0, bitwidth=1)

    manual_inputs = {
        "tgemm1_weight_in": drv_tgemm1_weight_in,
        "tgemm1_weight_valid": drv_tgemm1_weight_valid,
        "tgemm2_weight_in": drv_tgemm2_weight_in,
        "tgemm2_weight_valid": drv_tgemm2_weight_valid,
        "tgemm3_weight_in": drv_tgemm3_weight_in,
        "tgemm3_weight_valid": drv_tgemm3_weight_valid,
        "tgemm4_weight_in": drv_tgemm4_weight_in,
        "tgemm4_weight_valid": drv_tgemm4_weight_valid,
    }

    return built_block, drivers, manual_inputs
