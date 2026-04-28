"""Stateful Softmax IP core with 3-pass FSM for N_seq > T_seq.

Pass 1 (MAX_FINDING): Stream all beats, find global maximum.
Pass 2 (SUM_EXP):     Re-stream data, compute exp(x - max), accumulate sum.
Pass 3 (DIVIDE):      Re-stream data again, divide by sum, emit probabilities.

Reuses the LUT-based exp and inverse-sum logic from the combinational
SoftmaxCore.
"""

from __future__ import annotations

import numpy as np
import pyrtl
from pyrtl import WireVector

from ip_cores.axi_stream_base import AXI4StreamLiteBase


def _compute_exp_lut() -> list[int]:
    lut = []
    for u in range(256):
        s = np.array(u).astype(np.int8)
        if s > 0:
            lut.append(255)
        else:
            val = int(np.clip(np.round(np.exp(float(s)) * 255), 0, 255))
            lut.append(val)
    return lut


_EXP_LUT = _compute_exp_lut()


def _compute_inv_sum_lut(max_sum: int, K: int = 16) -> list[int]:
    addrwidth = (max_sum - 1).bit_length()
    lut_size = 1 << addrwidth
    lut = []
    for s in range(lut_size):
        if s == 0:
            lut.append(0)
        else:
            val = int(np.ceil((1 << K) * 127 / s))
            lut.append(min(val, (1 << K) - 1))
    return lut


class StatefulSoftmaxCore(AXI4StreamLiteBase):
    """3-pass FSM Softmax for sequences longer than one beat.

    Parameters
    ----------
    N_seq : int
        Total sequence length (number of int8 elements).
    T_seq : int
        Number of elements packed per beat (tiling parameter).
    name : str
        Unique instance name used to prefix all internal wires.
    block : pyrtl.Block, optional
        Isolated working block.  Created automatically if ``None``.
    """

    def __init__(self, N_seq: int, T_seq: int, name: str, block=None) -> None:
        super().__init__(tiling_param=T_seq, name=name, block=block)

        if N_seq <= 0:
            raise ValueError("N_seq must be a positive integer")
        if T_seq <= 0:
            raise ValueError("T_seq must be a positive integer")

        MAX_FINDING = 0
        SUM_EXP = 1
        DIVIDE = 2

        with pyrtl.set_working_block(self.block, no_sanity_check=True):
            state = pyrtl.Register(bitwidth=2, name=f"{name}_state")
            global_max = pyrtl.Register(bitwidth=8, name=f"{name}_global_max")
            has_data = pyrtl.Register(bitwidth=1, name=f"{name}_has_data")

            max_sum = N_seq * 255
            sum_width = (max_sum - 1).bit_length() if max_sum > 1 else 1
            sum_exp = pyrtl.Register(bitwidth=sum_width, name=f"{name}_sum_exp")

            lanes: list[WireVector] = []
            for i in range(T_seq):
                lane = self.data_in[i * 8 : (i + 1) * 8]
                lanes.append(lane)

            beat_max = self._find_max(lanes)

            exp_vals: list[WireVector] = []
            for i, lane in enumerate(lanes):
                diff = self._signed_sub_clip(lane, global_max, i)

                exp_rom = pyrtl.RomBlock(
                    bitwidth=8,
                    addrwidth=8,
                    romdata=_EXP_LUT,
                    name=f"{name}_exp_rom_{i}",
                    asynchronous=True,
                )
                exp_val = pyrtl.WireVector(bitwidth=8, name=f"{name}_exp_{i}")
                exp_val <<= exp_rom[diff]
                exp_vals.append(exp_val)

            beat_sum = self._adder_tree(exp_vals)

            inv_sum_lut_data = _compute_inv_sum_lut(max_sum)
            inv_sum_rom = pyrtl.RomBlock(
                bitwidth=16,
                addrwidth=sum_exp.bitwidth,
                romdata=inv_sum_lut_data,
                name=f"{name}_inv_sum_rom",
                asynchronous=True,
            )
            inv_sum = pyrtl.WireVector(bitwidth=16, name=f"{name}_inv_sum")
            inv_sum <<= inv_sum_rom[sum_exp]

            results: list[WireVector] = []
            for i, exp_val in enumerate(exp_vals):
                product = exp_val * inv_sum
                shifted = pyrtl.shift_right_logical(product, 16)

                max_out = pyrtl.Const(val=127, bitwidth=shifted.bitwidth)
                is_too_big = shifted > max_out
                clipped = pyrtl.select(
                    is_too_big,
                    pyrtl.Const(val=127, bitwidth=8),
                    shifted[0:8],
                )
                results.append(clipped)

            handshake = self.valid_in & self.ready_out

            with pyrtl.conditional_assignment:
                with state == MAX_FINDING:
                    with handshake & self.last_in:
                        state.next |= SUM_EXP
                with state == SUM_EXP:
                    with handshake & self.last_in:
                        state.next |= DIVIDE
                with state == DIVIDE:
                    with handshake & self.last_in:
                        state.next |= MAX_FINDING

            with pyrtl.conditional_assignment:
                with state == MAX_FINDING:
                    with handshake & self.last_in:
                        has_data.next |= 0
                        with has_data == 0:
                            global_max.next |= beat_max
                        with pyrtl.otherwise:
                            a_gt_b = pyrtl.signed_gt(beat_max, global_max)
                            global_max.next |= pyrtl.select(
                                a_gt_b, beat_max, global_max
                            )
                    with handshake & (has_data == 0):
                        global_max.next |= beat_max
                        has_data.next |= 1
                    with handshake & (has_data == 1):
                        a_gt_b = pyrtl.signed_gt(beat_max, global_max)
                        global_max.next |= pyrtl.select(
                            a_gt_b, beat_max, global_max
                        )
                with state == DIVIDE:
                    with handshake & self.last_in:
                        has_data.next |= 0

            with pyrtl.conditional_assignment:
                with state == MAX_FINDING:
                    with handshake & self.last_in:
                        sum_exp.next |= 0
                with state == SUM_EXP:
                    with handshake:
                        sum_exp.next |= sum_exp + beat_sum

            self.data_out <<= pyrtl.concat_list(results)
            self.valid_out <<= (state == DIVIDE) & self.valid_in
            self.last_out <<= (state == DIVIDE) & self.last_in
            self.ready_out <<= pyrtl.select(
                state == DIVIDE, self.ready_in, pyrtl.Const(1, bitwidth=1)
            )

    def _find_max(self, lanes: list[WireVector]) -> WireVector:
        current = list(lanes)
        while len(current) > 1:
            next_level: list[WireVector] = []
            for i in range(0, len(current), 2):
                if i + 1 < len(current):
                    a_gt_b = pyrtl.signed_gt(current[i], current[i + 1])
                    max_ab = pyrtl.select(a_gt_b, current[i], current[i + 1])
                    next_level.append(max_ab)
                else:
                    next_level.append(current[i])
            current = next_level
        return current[0]

    def _signed_sub_clip(
        self,
        a: WireVector,
        b: WireVector,
        idx: int,
    ) -> WireVector:
        a_ext = a.sign_extended(10)
        b_ext = b.sign_extended(10)
        diff = pyrtl.signed_sub(a_ext, b_ext)

        neg128 = pyrtl.Const(val=-128, bitwidth=10, signed=True)
        is_clipped = pyrtl.signed_lt(diff, neg128)

        clipped = pyrtl.select(
            is_clipped,
            pyrtl.Const(val=128, bitwidth=8),
            diff[0:8],
        )
        return clipped

    def _adder_tree(self, values: list[WireVector]) -> WireVector:
        current = list(values)
        while len(current) > 1:
            next_level: list[WireVector] = []
            for i in range(0, len(current), 2):
                if i + 1 < len(current):
                    next_level.append(current[i] + current[i + 1])
                else:
                    next_level.append(current[i])
            current = next_level
        return current[0]
