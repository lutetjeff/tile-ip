"""Transformer block assembly using the tiled-ip framework.

Assembles a simplified transformer-like block with:
- Input branching to FIFO (residual) and StatefulNorm
- Attention path: StatefulNorm -> TemporalGEMM -> StatefulSoftmax -> TemporalGEMM -> ALU_Add (residual)
- FFN path: StatefulNorm -> TemporalGEMM -> Activation -> TemporalGEMM -> ALU_Add (residual)
- Output
"""

from __future__ import annotations

import pyrtl
from pyrtl import WireVector

from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ip_cores.stateful_norm import StatefulNormCore
from ip_cores.temporal_gemm import TemporalGEMMCore
from ip_cores.stateful_softmax import StatefulSoftmaxCore
from ip_cores.alu import ALUCore
from ip_cores.fifo import FIFOCore
from ip_cores.activation import ActivationCore
from stitcher import Stitcher


def build_transformer_block():
    """Build a transformer block with the tiled-ip framework.

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
    shared_block = pyrtl.Block()
    original_Block = pyrtl.Block

    def _block_factory():
        return shared_block

    pyrtl.Block = _block_factory
    try:
        fifo1 = FIFOCore(T_width=2, depth=8, name="fifo1")
        norm1 = StatefulNormCore(T_channel=2, N_channel=4, name="norm1")
        tgemm1 = TemporalGEMMCore(T_M=1, T_K=2, T_N=2, name="tgemm1")
        softmax = StatefulSoftmaxCore(N_seq=4, T_seq=2, name="softmax")
        tgemm2 = TemporalGEMMCore(T_M=1, T_K=2, T_N=2, name="tgemm2")
        alu1 = ALUCore(T_width=2, name="alu1")
        df1 = FIFOCore(T_width=2, depth=1, name="df1")
        df2 = FIFOCore(T_width=2, depth=1, name="df2")
        df3 = FIFOCore(T_width=2, depth=1, name="df3")
        df4 = FIFOCore(T_width=2, depth=1, name="df4")
        fifo2 = FIFOCore(T_width=2, depth=8, name="fifo2")
        norm2 = StatefulNormCore(T_channel=2, N_channel=4, name="norm2")
        tgemm3 = TemporalGEMMCore(T_M=1, T_K=2, T_N=2, name="tgemm3")
        activation = ActivationCore(T_width=2, name="activation", activation_type="relu")
        tgemm4 = TemporalGEMMCore(T_M=1, T_K=2, T_N=2, name="tgemm4")
        alu2 = ALUCore(T_width=2, name="alu2")
    finally:
        pyrtl.Block = original_Block

    stitcher = Stitcher(block=shared_block)
    for ip in [
        fifo1,
        norm1,
        tgemm1,
        softmax,
        tgemm2,
        alu1,
        df1,
        df2,
        df3,
        df4,
        fifo2,
        norm2,
        tgemm3,
        activation,
        tgemm4,
        alu2,
    ]:
        stitcher.add_ip(ip)

    stitcher.connect("norm1", "tgemm1")
    stitcher.connect("tgemm1", "softmax")
    stitcher.connect("softmax", "tgemm2")
    stitcher.connect("tgemm2", "alu1")
    stitcher.connect("fifo1", "alu1")
    stitcher.connect("alu1", "norm2")
    stitcher.connect("alu1", "df1")
    stitcher.connect("df1", "df2")
    stitcher.connect("df2", "df3")
    stitcher.connect("df3", "df4")
    stitcher.connect("df4", "fifo2")
    stitcher.connect("norm2", "tgemm3")
    stitcher.connect("tgemm3", "activation")
    stitcher.connect("activation", "tgemm4")
    stitcher.connect("tgemm4", "alu2")
    stitcher.connect("fifo2", "alu2")

    built_block, drivers = stitcher.build()

    with pyrtl.set_working_block(built_block, no_sanity_check=True):
        tgemm1.last_in <<= norm1.last_out
        softmax.last_in <<= tgemm1.last_out
        tgemm2.last_in <<= softmax.last_out
        tgemm3.last_in <<= norm2.last_out

        drv_norm2_last_in = pyrtl.Input(bitwidth=1, name="drv_norm2_last_in")
        drv_tgemm4_last_in = pyrtl.Input(bitwidth=1, name="drv_tgemm4_last_in")
        norm2.last_in <<= drv_norm2_last_in
        tgemm4.last_in <<= drv_tgemm4_last_in

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

        drv_alu1_op_code = pyrtl.Input(bitwidth=2, name="drv_alu1_op_code")
        drv_alu2_op_code = pyrtl.Input(bitwidth=2, name="drv_alu2_op_code")
        alu1.op_code <<= drv_alu1_op_code
        alu2.op_code <<= drv_alu2_op_code

    manual_inputs = {
        "norm2_last_in": drv_norm2_last_in,
        "tgemm4_last_in": drv_tgemm4_last_in,
        "tgemm1_weight_in": drv_tgemm1_weight_in,
        "tgemm1_weight_valid": drv_tgemm1_weight_valid,
        "tgemm2_weight_in": drv_tgemm2_weight_in,
        "tgemm2_weight_valid": drv_tgemm2_weight_valid,
        "tgemm3_weight_in": drv_tgemm3_weight_in,
        "tgemm3_weight_valid": drv_tgemm3_weight_valid,
        "tgemm4_weight_in": drv_tgemm4_weight_in,
        "tgemm4_weight_valid": drv_tgemm4_weight_valid,
        "alu1_op_code": drv_alu1_op_code,
        "alu2_op_code": drv_alu2_op_code,
    }

    return built_block, drivers, manual_inputs
