"""Stateful Softmax IP core with triple-buffered II=1 pipeline.

When ``N_seq > T_seq`` the full sequence must be streamed over multiple
beats.  This core uses a triple-buffered pipeline: the producer finds the
global maximum into one bank, the sum stage accumulates exponentials from
the next bank, and the divide stage emits normalised probabilities from
the third bank.

Fixed-point scheme
------------------
* All data paths are integer (no floating-point in PyRTL).
* A 256-entry ROM LUT stores ``exp(x - max)`` clipped to ``[0, 255]``.
* A second ROM stores ``1 / sum_exp`` in Q16.0 format.
* Division is ``exp_val * inv_sum >> 16``.
* Final 8-bit truncation clips to ``127``.

Interface
---------
Inherits ``AXI4-Stream-Lite`` from ``AXI4StreamLiteBase``.

Pipeline
--------
* ``tokens_in_flight`` (0-3) tracks buffered packets.
* ``ready_out = tokens_in_flight < 3`` – upstream can send when space exists.
* ``valid_out = div_active`` – downstream can read when divide stage has data.
* Producer writes into ``buf_data[write_ptr]`` and latches ``buf_max`` on ``last_in``.
* Sum stage reads from ``buf_data[sum_ptr]``, accumulates ``sum_exp``, and latches
  ``buf_sum_exp`` on the last beat.
* Divide stage reads from ``buf_data[div_ptr]``, recomputes ``exp``, multiplies by
  ``inv_sum``, and emits probabilities.
"""

from __future__ import annotations

import numpy as np
import pyrtl
from pyrtl import WireVector

from ip_cores.axi_stream_base import AXI4StreamLiteBase, StreamShape


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
    """Triple-buffered II=1 pipeline Softmax for sequences longer than one beat.

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

        self._N_seq = N_seq
        self._T_seq = T_seq

        if N_seq <= 0:
            raise ValueError("N_seq must be a positive integer")
        if T_seq <= 0:
            raise ValueError("T_seq must be a positive integer")

        num_beats = N_seq // T_seq
        if N_seq % T_seq != 0:
            num_beats = (N_seq // T_seq) + 1

        max_sum = N_seq * 255
        sum_width = (max_sum - 1).bit_length() if max_sum > 1 else 1

        with pyrtl.set_working_block(self.block, no_sanity_check=True):
            self._build_core(N_seq, T_seq, num_beats, max_sum, sum_width)

    def _build_core(
        self,
        N_seq: int,
        T_seq: int,
        num_beats: int,
        max_sum: int,
        sum_width: int,
    ) -> None:
        """Wire up the triple-buffered pipeline, accumulators, LUTs, and datapath."""
        name = self._name

        # ---- 0.  Pipeline registers ---------------------------------------
        write_ptr = pyrtl.Register(bitwidth=2, name=f"{name}_write_ptr")
        sum_ptr = pyrtl.Register(bitwidth=2, name=f"{name}_sum_ptr")
        div_ptr = pyrtl.Register(bitwidth=2, name=f"{name}_div_ptr")
        tokens_in_flight = pyrtl.Register(
            bitwidth=2, name=f"{name}_tokens_in_flight"
        )

        beat_count_w = max(1, (num_beats - 1).bit_length())
        prod_beat_count = pyrtl.Register(
            bitwidth=beat_count_w, name=f"{name}_prod_beat_count"
        )
        sum_beat_count = pyrtl.Register(
            bitwidth=beat_count_w, name=f"{name}_sum_beat_count"
        )
        div_beat_count = pyrtl.Register(
            bitwidth=beat_count_w, name=f"{name}_div_beat_count"
        )

        # ---- 1.  Running accumulators ------------------------------------
        prod_max = pyrtl.Register(bitwidth=8, name=f"{name}_prod_max")
        sum_exp_acc = pyrtl.Register(
            bitwidth=sum_width, name=f"{name}_sum_exp_acc"
        )

        # ---- 2.  Triple-buffered register banks -------------------------
        buf_data: list[list[pyrtl.Register]] = []
        for b in range(3):
            bank = []
            for i in range(num_beats):
                reg = pyrtl.Register(
                    bitwidth=T_seq * 8, name=f"{name}_buf_data_{b}_{i}"
                )
                bank.append(reg)
            buf_data.append(bank)

        buf_max = [
            pyrtl.Register(bitwidth=8, name=f"{name}_buf_max_{b}")
            for b in range(3)
        ]
        buf_sum_exp = [
            pyrtl.Register(bitwidth=sum_width, name=f"{name}_buf_sum_exp_{b}")
            for b in range(3)
        ]

        # ---- 3.  Handshake signals ----------------------------------------
        prod_handshake = self.handshake_accepted()
        prod_done = prod_handshake & self.last_in

        sum_active = sum_ptr != write_ptr
        sum_done = sum_active & (sum_beat_count == num_beats - 1)

        div_active = div_ptr != sum_ptr
        div_handshake = div_active & self.ready_in
        div_done = div_handshake & (div_beat_count == num_beats - 1)

        # ---- 4.  Producer beat counter ------------------------------------
        with pyrtl.conditional_assignment:
            with prod_done:
                prod_beat_count.next |= 0
            with prod_handshake:
                prod_beat_count.next |= prod_beat_count + 1
            with pyrtl.otherwise:
                prod_beat_count.next |= prod_beat_count

        # ---- 5.  Sum beat counter ---------------------------------------
        with pyrtl.conditional_assignment:
            with sum_done:
                sum_beat_count.next |= 0
            with sum_active:
                sum_beat_count.next |= sum_beat_count + 1
            with pyrtl.otherwise:
                sum_beat_count.next |= sum_beat_count

        # ---- 6.  Divide beat counter --------------------------------------
        with pyrtl.conditional_assignment:
            with div_done:
                div_beat_count.next |= 0
            with div_handshake:
                div_beat_count.next |= div_beat_count + 1
            with pyrtl.otherwise:
                div_beat_count.next |= div_beat_count

        # ---- 7.  Pointer updates -----------------------------------------
        with pyrtl.conditional_assignment:
            with prod_done:
                write_ptr.next |= pyrtl.select(
                    write_ptr == 2, 0, write_ptr + 1
                )
            with pyrtl.otherwise:
                write_ptr.next |= write_ptr

        with pyrtl.conditional_assignment:
            with sum_done:
                sum_ptr.next |= pyrtl.select(sum_ptr == 2, 0, sum_ptr + 1)
            with pyrtl.otherwise:
                sum_ptr.next |= sum_ptr

        with pyrtl.conditional_assignment:
            with div_done:
                div_ptr.next |= pyrtl.select(div_ptr == 2, 0, div_ptr + 1)
            with pyrtl.otherwise:
                div_ptr.next |= div_ptr

        # ---- 8.  Tokens-in-flight counter --------------------------------
        with pyrtl.conditional_assignment:
            with prod_done & div_done:
                tokens_in_flight.next |= tokens_in_flight
            with prod_done:
                tokens_in_flight.next |= tokens_in_flight + 1
            with div_done:
                tokens_in_flight.next |= tokens_in_flight - 1
            with pyrtl.otherwise:
                tokens_in_flight.next |= tokens_in_flight

        # ---- 9.  Slice input into per-beat lanes -------------------------
        lanes: list[WireVector] = []
        for i in range(T_seq):
            lane = self.data_in[i * 8 : (i + 1) * 8]
            lanes.append(lane)

        # ---- 10. Producer running max -------------------------------------
        beat_max = self._find_max(lanes)

        a_gt_b = pyrtl.signed_gt(beat_max, prod_max)
        next_prod_max = pyrtl.select(a_gt_b, beat_max, prod_max)

        with pyrtl.conditional_assignment:
            with prod_handshake & (prod_beat_count == 0):
                prod_max.next |= beat_max
            with prod_handshake:
                prod_max.next |= next_prod_max
            with pyrtl.otherwise:
                prod_max.next |= prod_max

        # ---- 11. Latch producer max into active bank on prod_done --------
        for b in range(3):
            with pyrtl.conditional_assignment:
                with prod_done & (write_ptr == b):
                    buf_max[b].next |= next_prod_max
                with pyrtl.otherwise:
                    buf_max[b].next |= buf_max[b]

        # ---- 12. Buffer write (producer stage) ----------------------------
        for b in range(3):
            for i in range(num_beats):
                with pyrtl.conditional_assignment:
                    with prod_handshake & (write_ptr == b) & (
                        prod_beat_count == i
                    ):
                        buf_data[b][i].next |= self.data_in
                    with pyrtl.otherwise:
                        buf_data[b][i].next |= buf_data[b][i]

        # ---- 13. Buffer read (sum stage) ---------------------------------
        sum_data_out = pyrtl.Const(0, bitwidth=T_seq * 8)
        for b in range(3):
            for i in range(num_beats):
                match = (sum_ptr == b) & (sum_beat_count == i)
                sum_data_out = pyrtl.select(match, buf_data[b][i], sum_data_out)

        # ---- 14. Buffer read (divide stage) ------------------------------
        div_data_out = pyrtl.Const(0, bitwidth=T_seq * 8)
        for b in range(3):
            for i in range(num_beats):
                match = (div_ptr == b) & (div_beat_count == i)
                div_data_out = pyrtl.select(match, buf_data[b][i], div_data_out)

        # ---- 15. Select active statistics ---------------------------------
        buf_max_sum = pyrtl.Const(0, bitwidth=8)
        for b in range(3):
            buf_max_sum = pyrtl.select(
                sum_ptr == b, buf_max[b], buf_max_sum
            )

        buf_max_div = pyrtl.Const(0, bitwidth=8)
        for b in range(3):
            buf_max_div = pyrtl.select(
                div_ptr == b, buf_max[b], buf_max_div
            )

        buf_sum_exp_div = pyrtl.Const(0, bitwidth=sum_width)
        for b in range(3):
            buf_sum_exp_div = pyrtl.select(
                div_ptr == b, buf_sum_exp[b], buf_sum_exp_div
            )

        # ---- 16. Sum stage: exp LUTs and accumulation ---------------------
        sum_lanes: list[WireVector] = []
        for i in range(T_seq):
            lane = sum_data_out[i * 8 : (i + 1) * 8]
            sum_lanes.append(lane)

        sum_exp_vals: list[WireVector] = []
        for i, lane in enumerate(sum_lanes):
            diff = self._signed_sub_clip(lane, buf_max_sum, i)
            exp_rom = pyrtl.RomBlock(
                bitwidth=8,
                addrwidth=8,
                romdata=_EXP_LUT,
                name=f"{name}_exp_rom_sum_{i}",
                asynchronous=True,
            )
            exp_val = pyrtl.WireVector(bitwidth=8, name=f"{name}_exp_sum_{i}")
            exp_val <<= exp_rom[diff]
            sum_exp_vals.append(exp_val)

        sum_beat_sum = self._adder_tree(sum_exp_vals)
        next_sum_exp = sum_exp_acc + sum_beat_sum

        with pyrtl.conditional_assignment:
            with sum_active & (sum_beat_count == 0):
                sum_exp_acc.next |= sum_beat_sum
            with sum_active:
                sum_exp_acc.next |= next_sum_exp
            with pyrtl.otherwise:
                sum_exp_acc.next |= sum_exp_acc

        # ---- 17. Latch sum_exp into active bank on sum_done --------------
        for b in range(3):
            with pyrtl.conditional_assignment:
                with sum_done & (sum_ptr == b):
                    buf_sum_exp[b].next |= next_sum_exp
                with pyrtl.otherwise:
                    buf_sum_exp[b].next |= buf_sum_exp[b]

        # ---- 18. Divide stage: exp LUTs and output -----------------------
        div_lanes: list[WireVector] = []
        for i in range(T_seq):
            lane = div_data_out[i * 8 : (i + 1) * 8]
            div_lanes.append(lane)

        div_exp_vals: list[WireVector] = []
        for i, lane in enumerate(div_lanes):
            diff = self._signed_sub_clip(lane, buf_max_div, i)
            exp_rom = pyrtl.RomBlock(
                bitwidth=8,
                addrwidth=8,
                romdata=_EXP_LUT,
                name=f"{name}_exp_rom_div_{i}",
                asynchronous=True,
            )
            exp_val = pyrtl.WireVector(bitwidth=8, name=f"{name}_exp_div_{i}")
            exp_val <<= exp_rom[diff]
            div_exp_vals.append(exp_val)

        inv_sum_lut_data = _compute_inv_sum_lut(max_sum)
        inv_sum_rom = pyrtl.RomBlock(
            bitwidth=16,
            addrwidth=sum_width,
            romdata=inv_sum_lut_data,
            name=f"{name}_inv_sum_rom",
            asynchronous=True,
        )
        inv_sum = pyrtl.WireVector(bitwidth=16, name=f"{name}_inv_sum")
        inv_sum <<= inv_sum_rom[buf_sum_exp_div]

        div_results: list[WireVector] = []
        for i, exp_val in enumerate(div_exp_vals):
            product = exp_val * inv_sum
            shifted = pyrtl.shift_right_logical(product, 16)

            max_out = pyrtl.Const(val=127, bitwidth=shifted.bitwidth)
            is_too_big = shifted > max_out
            clipped = pyrtl.select(
                is_too_big,
                pyrtl.Const(val=127, bitwidth=8),
                shifted[0:8],
            )
            div_results.append(clipped)

        # ---- 19. Output mux -----------------------------------------------
        self.data_out <<= pyrtl.concat_list(div_results)
        self.valid_out <<= div_active
        self.last_out <<= div_active & (div_beat_count == num_beats - 1)
        self.ready_out <<= tokens_in_flight < 3

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

    def infer_output_shape(self) -> StreamShape:
        return StreamShape(self._N_seq, self._T_seq)

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
