"""Stateful Normalization IP core (LayerNorm / RMSNorm) for multi-beat channels.

When ``N_channel > T_channel`` the full channel must be streamed over multiple
beats.  This core uses a double-buffered II=1 pipeline: the producer accumulates
statistics into one bank while the consumer normalises from the other bank.

Fixed-point scheme
------------------
* All data paths are integer (no floating-point in PyRTL).
* A 256-entry ROM LUT stores ``1/sqrt(x + epsilon)`` in Q8.8 format.
* Variance is accumulated in wide bitwidth, right-shifted to obtain a LUT
  address, and clipped to ``[0, 255]``.
* Normalisation is ``(x - mean) * lut_value >> 8``.
* Gamma / beta are applied as ``norm * gamma >> 8 + beta``.
* Final 8-bit truncation uses the lower 8 bits (two's-complement wrap).

Interface
---------
Inherits ``AXI4-Stream-Lite`` from ``AXI4StreamLiteBase``.

Pipeline
--------
* ``tokens_in_flight`` (0-2) tracks buffered packets.
* ``ready_out = tokens_in_flight < 2`` – upstream can send when space exists.
* ``valid_out = tokens_in_flight > 0`` – downstream can read when data exists.
* Producer writes into ``buf_data[write_ptr]`` and latches ``sum_x`` / ``sum_x2``
  on ``last_in``.
* Consumer reads from ``buf_data[read_ptr]`` and applies normalisation.
"""

from __future__ import annotations

import math

import pyrtl
from pyrtl import WireVector, Const, RomBlock
from pyrtl.corecircuits import (
    signed_add,
    signed_mult,
    signed_sub,
    shift_right_arithmetic,
)

from ip_cores.axi_stream_base import AXI4StreamLiteBase, StreamShape


class StatefulNormCore(AXI4StreamLiteBase):
    """Multi-beat LayerNorm / RMSNorm IP core with double-buffered pipeline.

    Parameters
    ----------
    T_channel : int
        Number of parallel INT8 channels per beat.  Must be a power of two.
    N_channel : int
        Total channel dimension.  Must be a power of two and a multiple of
        ``T_channel``.
    name : str
        Unique instance name used to prefix every internal wire.
    is_rmsnorm : bool
        When ``False`` (default) the core performs LayerNorm
        (mean subtraction + variance normalisation).
        When ``True`` the core performs RMSNorm
        (variance normalisation only, mean is *not* subtracted).
    gamma : int
        INT8 scale factor applied after normalisation (default ``1``).
    beta : int
        INT8 bias factor applied after scaling (default ``0``).
    """

    def __init__(
        self,
        T_channel: int,
        N_channel: int,
        name: str,
        is_rmsnorm: bool = False,
        gamma: int = 1,
        beta: int = 0,
    ) -> None:
        if T_channel <= 0:
            raise ValueError("T_channel must be positive")
        if T_channel & (T_channel - 1):
            raise ValueError("T_channel must be a power of 2")
        if N_channel <= 0:
            raise ValueError("N_channel must be positive")
        if N_channel & (N_channel - 1):
            raise ValueError("N_channel must be a power of 2")
        if N_channel % T_channel != 0:
            raise ValueError("N_channel must be a multiple of T_channel")

        super().__init__(tiling_param=T_channel, name=name)

        self._is_rmsnorm = is_rmsnorm
        self._gamma = gamma
        self._beta = beta
        self._N_channel = N_channel
        self._num_beats = N_channel // T_channel
        self._log2_t = (T_channel - 1).bit_length()
        self._log2_n = (N_channel - 1).bit_length()

        with pyrtl.set_working_block(self.block, no_sanity_check=True):
            self._build_core()

    # ------------------------------------------------------------------
    # Internal helpers
    # ------------------------------------------------------------------

    def _build_core(self) -> None:
        """Wire up the double-buffered pipeline, accumulators, LUT, and normalise datapath."""
        T = self._tiling_param
        num_beats = self._num_beats
        name = self._name
        log2_t = self._log2_t
        log2_n = self._log2_n

        # ---- 0.  Pipeline registers ---------------------------------------
        write_ptr = pyrtl.Register(bitwidth=1, name=f"{name}_write_ptr")
        read_ptr = pyrtl.Register(bitwidth=1, name=f"{name}_read_ptr")
        tokens_in_flight = pyrtl.Register(
            bitwidth=2, name=f"{name}_tokens_in_flight"
        )

        beat_count_w = max(1, (num_beats - 1).bit_length())
        prod_beat_count = pyrtl.Register(
            bitwidth=beat_count_w, name=f"{name}_prod_beat_count"
        )
        cons_beat_count = pyrtl.Register(
            bitwidth=beat_count_w, name=f"{name}_cons_beat_count"
        )

        # ---- 1.  Accumulators --------------------------------------------
        # ``sum_x`` needs ``8 + log2(N)`` bits to hold N int8 values.
        sum_x_bw = 8 + log2_n
        # ``sum_x2`` needs ``16 + log2(N)`` bits (signed_mult of int8 → 16-bit).
        sum_x2_bw = 16 + log2_n

        sum_x = pyrtl.Register(bitwidth=sum_x_bw, name=f"{name}_sum_x")
        sum_x2 = pyrtl.Register(bitwidth=sum_x2_bw, name=f"{name}_sum_x2")

        # ---- 2.  Double-buffered register banks -------------------------
        buf_data: list[list[pyrtl.Register]] = []
        for b in range(2):
            bank = []
            for i in range(num_beats):
                reg = pyrtl.Register(
                    bitwidth=T * 8, name=f"{name}_buf_data_{b}_{i}"
                )
                bank.append(reg)
            buf_data.append(bank)

        buf_sum_x = [
            pyrtl.Register(bitwidth=sum_x_bw, name=f"{name}_buf_sum_x_{b}")
            for b in range(2)
        ]
        buf_sum_x2 = [
            pyrtl.Register(bitwidth=sum_x2_bw, name=f"{name}_buf_sum_x2_{b}")
            for b in range(2)
        ]

        # ---- 3.  Handshake -----------------------------------------------
        prod_handshake = self.handshake_accepted()
        cons_handshake = self.valid_out & self.ready_in
        prod_done = prod_handshake & self.last_in
        cons_done = cons_handshake & (cons_beat_count == num_beats - 1)

        # ---- 4.  Producer beat counter -----------------------------------
        with pyrtl.conditional_assignment:
            with prod_done:
                prod_beat_count.next |= 0
            with prod_handshake:
                prod_beat_count.next |= prod_beat_count + 1
            with pyrtl.otherwise:
                prod_beat_count.next |= prod_beat_count

        # ---- 5.  Consumer beat counter -----------------------------------
        with pyrtl.conditional_assignment:
            with cons_done:
                cons_beat_count.next |= 0
            with cons_handshake:
                cons_beat_count.next |= cons_beat_count + 1
            with pyrtl.otherwise:
                cons_beat_count.next |= cons_beat_count

        # ---- 6.  Pointer updates -----------------------------------------
        with pyrtl.conditional_assignment:
            with prod_done:
                write_ptr.next |= ~write_ptr
            with pyrtl.otherwise:
                write_ptr.next |= write_ptr

        with pyrtl.conditional_assignment:
            with cons_done:
                read_ptr.next |= ~read_ptr
            with pyrtl.otherwise:
                read_ptr.next |= read_ptr

        # ---- 7.  Tokens-in-flight counter --------------------------------
        with pyrtl.conditional_assignment:
            with prod_done & cons_done:
                tokens_in_flight.next |= tokens_in_flight
            with prod_done:
                tokens_in_flight.next |= tokens_in_flight + 1
            with cons_done:
                tokens_in_flight.next |= tokens_in_flight - 1
            with pyrtl.otherwise:
                tokens_in_flight.next |= tokens_in_flight

        # ---- 8.  Slice input into per-beat channels ----------------------
        channels = []
        for i in range(T):
            ch = self.data_in[i * 8 : (i + 1) * 8]
            channels.append(ch)

        # Sign-extend each byte for the adder tree.
        ext_bits = log2_t
        signed_ch = []
        for ch in channels:
            sign = ch[7]
            extended = pyrtl.concat_list([ch] + [sign] * ext_bits)
            signed_ch.append(extended)

        # ---- 9.  Beat-level sums -----------------------------------------
        beat_sum_x = self._adder_tree(signed_ch)
        x2_wires = [signed_mult(ch, ch) for ch in signed_ch]
        beat_sum_x2 = self._adder_tree(x2_wires)

        # ---- 10. Accumulator updates -------------------------------------
        next_sum_x = signed_add(sum_x, beat_sum_x)[0:sum_x_bw]
        next_sum_x2 = signed_add(sum_x2, beat_sum_x2)[0:sum_x2_bw]

        with pyrtl.conditional_assignment:
            with prod_done:
                sum_x.next |= 0
                sum_x2.next |= 0
            with prod_handshake:
                sum_x.next |= next_sum_x
                sum_x2.next |= next_sum_x2
            with pyrtl.otherwise:
                sum_x.next |= sum_x
                sum_x2.next |= sum_x2

        # ---- 11. Latch accumulators into active bank on prod_done --------
        for b in range(2):
            with pyrtl.conditional_assignment:
                with prod_done & (write_ptr == b):
                    buf_sum_x[b].next |= next_sum_x
                    buf_sum_x2[b].next |= next_sum_x2
                with pyrtl.otherwise:
                    buf_sum_x[b].next |= buf_sum_x[b]
                    buf_sum_x2[b].next |= buf_sum_x2[b]

        # ---- 12. Buffer write (producer stage) ---------------------------
        for b in range(2):
            for i in range(num_beats):
                with pyrtl.conditional_assignment:
                    with prod_handshake & (write_ptr == b) & (
                        prod_beat_count == i
                    ):
                        buf_data[b][i].next |= self.data_in
                    with pyrtl.otherwise:
                        buf_data[b][i].next |= buf_data[b][i]

        # ---- 13. Buffer read (consumer stage) ----------------------------
        buf_data_out = pyrtl.Const(0, bitwidth=T * 8)
        for b in range(2):
            for i in range(num_beats):
                match = (read_ptr == b) & (cons_beat_count == i)
                buf_data_out = pyrtl.select(match, buf_data[b][i], buf_data_out)

        # ---- 14. Select active statistics --------------------------------
        sum_x_active = pyrtl.select(
            read_ptr == 0, buf_sum_x[0], buf_sum_x[1]
        )
        sum_x2_active = pyrtl.select(
            read_ptr == 0, buf_sum_x2[0], buf_sum_x2[1]
        )

        # ---- 15. Compute mean / variance / LUT (combinational) -----------
        mean = shift_right_arithmetic(sum_x_active, log2_n)
        e_x2 = shift_right_arithmetic(sum_x2_active, log2_n)
        mean_sq = signed_mult(mean, mean)
        variance = signed_sub(e_x2, mean_sq)

        # Piecewise quantisation to 8-bit unsigned LUT address.
        is_small = variance < Const(256, bitwidth=variance.bitwidth)
        addr_small = shift_right_arithmetic(variance, 4)[0:8]
        addr_large_raw = Const(16, bitwidth=variance.bitwidth) + shift_right_arithmetic(
            variance, 8
        )
        addr_large = self._clip_unsigned(addr_large_raw, 8)
        var_addr = pyrtl.select(is_small, addr_small, addr_large)

        lut = self._build_inv_sqrt_lut(name)
        inv_sqrt = lut[var_addr]

        # ---- 16. Normalise each buffered channel -------------------------
        buf_channels = []
        for i in range(T):
            ch = buf_data_out[i * 8 : (i + 1) * 8]
            buf_channels.append(ch)

        buf_signed_ch = []
        for ch in buf_channels:
            sign = ch[7]
            extended = pyrtl.concat_list([ch] + [sign] * ext_bits)
            buf_signed_ch.append(extended)

        # Select (x - mean) for LayerNorm or x for RMSNorm.
        is_rms_wire = Const(1 if self._is_rmsnorm else 0, bitwidth=1)
        norm_inputs = []
        for ch in buf_signed_ch:
            diff = signed_sub(ch, mean)
            max_bw = max(ch.bitwidth, diff.bitwidth)
            ch_ext = self._sign_extend(ch, max_bw)
            diff_ext = self._sign_extend(diff, max_bw)
            sel = pyrtl.select(is_rms_wire, ch_ext, diff_ext)
            norm_inputs.append(sel)

        # ``inv_sqrt`` is in Q8.8 (real value * 256).
        normalised = []
        inv_sqrt_zext = pyrtl.concat(pyrtl.Const(0, bitwidth=1), inv_sqrt)
        for inp in norm_inputs:
            prod = signed_mult(inp, inv_sqrt_zext)
            norm_val = shift_right_arithmetic(prod, 8)
            normalised.append(norm_val)

        # ---- 17. Apply gamma and beta ------------------------------------
        gamma_const = Const(self._gamma & 0xFF, bitwidth=8)
        beta_const = Const(self._beta & 0xFF, bitwidth=8)

        norm_bw = normalised[0].bitwidth
        gamma_ext = self._sign_extend(gamma_const, norm_bw)
        beta_ext = self._sign_extend(beta_const, norm_bw)

        output_bytes = []
        for norm_val in normalised:
            scaled = signed_mult(norm_val, gamma_ext)
            biased = signed_add(scaled, beta_ext)
            output_bytes.append(biased[0:8])

        # ---- 18. Output mux ----------------------------------------------
        has_token = tokens_in_flight > 0
        self.data_out <<= pyrtl.select(
            has_token,
            pyrtl.concat(*reversed(output_bytes)),
            pyrtl.Const(0, bitwidth=T * 8),
        )

        self.valid_out <<= has_token
        self.last_out <<= has_token & (cons_beat_count == num_beats - 1)
        self.ready_out <<= tokens_in_flight < 2

    def _adder_tree(self, wires: list[WireVector]) -> WireVector:
        """Return the sum of *wires* using a binary tree of adders."""
        while len(wires) > 1:
            nxt = []
            for i in range(0, len(wires), 2):
                if i + 1 < len(wires):
                    nxt.append(signed_add(wires[i], wires[i + 1]))
                else:
                    nxt.append(wires[i])
            wires = nxt
        return wires[0]

    @staticmethod
    def _sign_extend(wire: WireVector, target_bits: int) -> WireVector:
        """Sign-extend *wire* to *target_bits* using replication of the MSB."""
        if wire.bitwidth >= target_bits:
            return wire
        extra = target_bits - wire.bitwidth
        msb = wire[wire.bitwidth - 1]
        return pyrtl.concat_list([wire] + [msb] * extra)

    @staticmethod
    def _clip_unsigned(wire: WireVector, target_bits: int) -> WireVector:
        """Clip *wire* to the unsigned range ``[0, 2**target_bits - 1]``."""
        max_val = Const((1 << target_bits) - 1, bitwidth=wire.bitwidth)
        is_overflow = wire > max_val
        clipped = pyrtl.select(is_overflow, max_val, wire)
        return clipped[0:target_bits]

    def _build_inv_sqrt_lut(self, name: str) -> RomBlock:
        """Build a 256-entry ROM with piecewise quantisation.

        Address mapping (piecewise linear):
          * addr 0-15   → variance in [0, 255]   (step 16, midpoint +8)
          * addr 16-255 → variance in [256, 65280] (step 256, midpoint +128)

        LUT value = round(1/sqrt(real_var + eps) * 256) in Q8.8 (unsigned 16-bit).
        """
        eps = 1e-5
        lut_data: dict[int, int] = {}
        for addr in range(256):
            if addr < 16:
                real_var = (addr << 4) + 8
            else:
                real_var = ((addr - 16) << 8) + 128
            val = 1.0 / math.sqrt(real_var + eps)
            scaled = round(val * 256)
            scaled = max(1, min(scaled, 65535))
            lut_data[addr] = scaled
        return RomBlock(
            bitwidth=16,
            addrwidth=8,
            romdata=lut_data,
            name=f"{name}_inv_sqrt_lut",
            asynchronous=True,
        )

    def infer_output_shape(self) -> StreamShape:
        return StreamShape(self._N_channel, self._tiling_param)
