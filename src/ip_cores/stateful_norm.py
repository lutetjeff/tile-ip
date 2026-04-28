"""Stateful Normalization IP core (LayerNorm / RMSNorm) for multi-beat channels.

When ``N_channel > T_channel`` the full channel must be streamed over multiple
beats.  This core accumulates statistics in Pass 1, computes normalization
parameters in a single compute cycle, then replays the buffered data with
normalisation applied in Pass 2.

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

FSM states
----------
0 = STATISTICS  – accept beats, accumulate ``sum_x`` / ``sum_x2``, store in BRAM.
1 = COMPUTE     – calculate mean, variance, ``1/sqrt(var)`` via LUT.
                  ``ready_out`` is forced low to stall upstream.
2 = NORMALIZE   – replay buffered beats, apply normalisation / gamma / beta.
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

from ip_cores.axi_stream_base import AXI4StreamLiteBase


class StatefulNormCore(AXI4StreamLiteBase):
    """Multi-beat LayerNorm / RMSNorm IP core with internal buffering.

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
        """Wire up the FSM, accumulators, BRAM, LUT, and normalise datapath."""
        T = self._tiling_param
        num_beats = self._num_beats
        name = self._name
        log2_t = self._log2_t
        log2_n = self._log2_n

        # ---- 0.  FSM registers -------------------------------------------
        # 0 = STATISTICS, 1 = COMPUTE, 2 = NORMALIZE
        state = pyrtl.Register(bitwidth=2, name=f"{name}_state")
        beat_count = pyrtl.Register(
            bitwidth=max(1, (num_beats - 1).bit_length()),
            name=f"{name}_beat_count",
        )

        # ---- 1.  Accumulators --------------------------------------------
        # ``sum_x`` needs ``8 + log2(N)`` bits to hold N int8 values.
        sum_x_bw = 8 + log2_n
        # ``sum_x2`` needs ``16 + log2(N)`` bits (signed_mult of int8 → 16-bit).
        sum_x2_bw = 16 + log2_n

        sum_x = pyrtl.Register(bitwidth=sum_x_bw, name=f"{name}_sum_x")
        sum_x2 = pyrtl.Register(bitwidth=sum_x2_bw, name=f"{name}_sum_x2")

        # ---- 2.  Beat-level buffer (BRAM) --------------------------------
        beat_addr_w = max(1, (num_beats - 1).bit_length())
        buf_mem = pyrtl.MemBlock(
            bitwidth=T * 8,
            addrwidth=beat_addr_w,
            name=f"{name}_buf_mem",
        )

        # ---- 3.  Handshake -----------------------------------------------
        handshake = self.handshake_accepted()

        # ---- 4.  State transitions ---------------------------------------
        with pyrtl.conditional_assignment:
            with state == 0:  # STATISTICS
                with handshake & self.last_in:
                    state.next |= 1  # → COMPUTE
            with state == 1:  # COMPUTE
                state.next |= 2  # → NORMALIZE
            with state == 2:  # NORMALIZE
                with self.ready_in & (beat_count == num_beats - 1):
                    state.next |= 0  # → STATISTICS

        # ---- 5.  Beat counter --------------------------------------------
        with pyrtl.conditional_assignment:
            with state == 0:  # STATISTICS
                with handshake:
                    beat_count.next |= beat_count + 1
            with state == 1:  # COMPUTE
                beat_count.next |= 0
            with state == 2:  # NORMALIZE
                with self.ready_in:
                    with beat_count == num_beats - 1:
                        beat_count.next |= 0
                    with pyrtl.otherwise:
                        beat_count.next |= beat_count + 1

        # ---- 6.  Slice input into per-beat channels ----------------------
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

        # ---- 7.  Beat-level sums -----------------------------------------
        beat_sum_x = self._adder_tree(signed_ch)
        x2_wires = [signed_mult(ch, ch) for ch in signed_ch]
        beat_sum_x2 = self._adder_tree(x2_wires)

        # ---- 8.  Accumulator updates -------------------------------------
        with pyrtl.conditional_assignment:
            with state == 0:  # STATISTICS
                with handshake:
                    sum_x.next |= signed_add(sum_x, beat_sum_x)[0:sum_x_bw]
                    sum_x2.next |= signed_add(sum_x2, beat_sum_x2)[0:sum_x2_bw]
            with state == 2:  # NORMALIZE -> STATISTICS transition
                with self.ready_in & (beat_count == num_beats - 1):
                    sum_x.next |= 0
                    sum_x2.next |= 0

        # ---- 9.  Buffer write (only in STATISTICS on handshake) ----------
        buf_mem[beat_count] <<= pyrtl.MemBlock.EnabledWrite(
            self.data_in, (state == 0) & handshake
        )

        # ---- 10. Buffer read (active in NORMALIZE) ----------------------
        buf_data = buf_mem[beat_count]

        # ---- 11. Compute mean / variance / LUT (combinational, stable ---
        #          during NORMALIZE because accumulators are frozen)
        mean = shift_right_arithmetic(sum_x, log2_n)
        e_x2 = shift_right_arithmetic(sum_x2, log2_n)
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

        # ---- 12. Normalise each buffered channel -------------------------
        buf_channels = []
        for i in range(T):
            ch = buf_data[i * 8 : (i + 1) * 8]
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

        # ---- 13. Apply gamma and beta ------------------------------------
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

        # ---- 14. Output mux ---------------------------------------------
        in_normalize = state == 2
        self.data_out <<= pyrtl.select(
            in_normalize,
            pyrtl.concat(*reversed(output_bytes)),
            pyrtl.Const(0, bitwidth=T * 8),
        )

        self.valid_out <<= in_normalize
        self.last_out <<= in_normalize & (beat_count == num_beats - 1)
        self.ready_out <<= state == 0

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
