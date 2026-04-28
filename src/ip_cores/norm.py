"""Normalization IP core (LayerNorm / RMSNorm) for tile-based AXI4-Stream-Lite.

The core accepts a flattened bus of ``T_channel`` INT8 values per beat,
computes mean and variance over the channel dimension, and applies
LayerNorm or RMSNorm scaling.

Fixed-point scheme
------------------
* All data paths are integer (no floating-point in PyRTL).
* A 256-entry ROM LUT stores ``1/sqrt(x + epsilon)`` in Q8.8 format
  (i.e. real value * 256, rounded to unsigned 16-bit).
* Variance is accumulated in wide bitwidth, right-shifted by 8 to obtain
  an 8-bit unsigned LUT address, and clipped to ``[0, 255]``.
* Normalisation is ``(x - mean) * lut_value >> 8``.
* Gamma / beta are applied as ``norm * gamma >> 8 + beta``.
* Final 8-bit truncation uses the lower 8 bits (two's-complement wrap).

Interface
---------
Inherits ``AXI4-Stream-Lite`` from ``AXI4StreamLiteBase``.
The core is combinational: ``valid_out = valid_in``,
``ready_out = ready_in``.
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


class NormCore(AXI4StreamLiteBase):
    """Tile-based LayerNorm / RMSNorm IP core.

    Parameters
    ----------
    T_channel : int
        Number of parallel INT8 channels per beat.  Must be a power of two.
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
        name: str,
        is_rmsnorm: bool = False,
        gamma: int = 1,
        beta: int = 0,
    ) -> None:
        if T_channel <= 0:
            raise ValueError("T_channel must be positive")
        if T_channel & (T_channel - 1):
            raise ValueError("T_channel must be a power of 2")

        super().__init__(T_channel, name)

        self._is_rmsnorm = is_rmsnorm
        self._gamma = gamma
        self._beta = beta
        self._log2_t = (T_channel - 1).bit_length()

        with pyrtl.set_working_block(self.block, no_sanity_check=True):
            self._build_core()

    # ------------------------------------------------------------------
    # Internal helpers
    # ------------------------------------------------------------------

    def _build_core(self) -> None:
        """Wire up the mean/variance/LUT/normalise/gamma/beta datapath."""
        T = self._tiling_param
        name = self._name
        log2_t = self._log2_t

        # ---- 1. Slice the flattened input bus into T_channel bytes --------
        channels = []
        for i in range(T):
            ch = self.data_in[i * 8 : (i + 1) * 8]
            channels.append(ch)

        # ---- 2. Sign-extend each byte for the adder tree -----------------
        # We need ``8 + log2(T)`` bits so that the sum of T values cannot
        # overflow.
        ext_bits = log2_t
        signed_ch = []
        for ch in channels:
            sign = ch[7]
            # concat_list places the FIRST element at the LSB.
            extended = pyrtl.concat_list([ch] + [sign] * ext_bits)
            signed_ch.append(extended)

        # ---- 3. Mean = sum(x) / T  (arithmetic right shift) ---------------
        mean_sum = self._adder_tree(signed_ch)
        mean = shift_right_arithmetic(mean_sum, log2_t)

        # ---- 4. Select (x - mean) for LayerNorm or x for RMSNorm --------
        is_rms_wire = Const(1 if self._is_rmsnorm else 0, bitwidth=1)
        norm_inputs = []
        for ch in signed_ch:
            diff = signed_sub(ch, mean)
            max_bw = max(ch.bitwidth, diff.bitwidth)
            ch_ext = self._sign_extend(ch, max_bw)
            diff_ext = self._sign_extend(diff, max_bw)
            sel = pyrtl.select(is_rms_wire, ch_ext, diff_ext)
            norm_inputs.append(sel)

        # ---- 5. Variance = E[x^2] - E[x]^2  (same for both modes) -------
        x2_wires = [signed_mult(ch, ch) for ch in signed_ch]
        x2_sum = self._adder_tree(x2_wires)
        e_x2 = shift_right_arithmetic(x2_sum, log2_t)
        mean_sq = signed_mult(mean, mean)
        variance = signed_sub(e_x2, mean_sq)

        # ---- 6. Quantise variance to an 8-bit unsigned LUT address ---------
        # Piecewise mapping for better small-variance resolution:
        #   variance < 256  → addr = variance >> 4  (0-15)
        #   variance >= 256 → addr = 16 + (variance >> 8)  (16-255)
        is_small = variance < Const(256, bitwidth=variance.bitwidth)
        addr_small = shift_right_arithmetic(variance, 4)[0:8]
        addr_large_raw = Const(16, bitwidth=variance.bitwidth) + shift_right_arithmetic(
            variance, 8
        )
        addr_large = self._clip_unsigned(addr_large_raw, 8)
        var_addr = pyrtl.select(is_small, addr_small, addr_large)

        # ---- 7. LUT lookup: 1/sqrt(variance + epsilon) -------------------
        lut = self._build_inv_sqrt_lut(name)
        inv_sqrt = lut[var_addr]

        # ---- 8. Normalise each channel ------------------------------------
        # ``inv_sqrt`` is in Q8.8 (real value * 256).
        normalised = []
        inv_sqrt_zext = pyrtl.concat(pyrtl.Const(0, bitwidth=1), inv_sqrt)
        for inp in norm_inputs:
            prod = signed_mult(inp, inv_sqrt_zext)
            norm_val = shift_right_arithmetic(prod, 8)
            normalised.append(norm_val)

        # ---- 9. Apply gamma and beta -------------------------------------
        gamma_const = Const(self._gamma & 0xFF, bitwidth=8)
        beta_const = Const(self._beta & 0xFF, bitwidth=8)

        norm_bw = normalised[0].bitwidth
        gamma_ext = self._sign_extend(gamma_const, norm_bw)
        beta_ext = self._sign_extend(beta_const, norm_bw)

        output_bytes = []
        for norm_val in normalised:
            scaled = signed_mult(norm_val, gamma_ext)
            biased = signed_add(scaled, beta_ext)
            # Truncate to 8-bit (two's-complement wrap on overflow).
            output_bytes.append(biased[0:8])

        # ---- 10. Assemble the flattened output bus ------------------------
        # ``pyrtl.concat(*reversed(...))`` places byte-0 at the LSB.
        self.data_out <<= pyrtl.concat(*reversed(output_bytes))

        # ---- 11. Combinational handshake ----------------------------------
        self.valid_out <<= self.valid_in
        self.ready_out <<= self.ready_in

    def _adder_tree(self, wires: list[WireVector]) -> WireVector:
        """Return the sum of *wires* using a binary tree of adders.

        PyRTL's ``+`` operator auto-extends the result by one bit, so the
        tree naturally grows to accommodate the full dynamic range.
        """
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
        """Clip *wire* to the unsigned range ``[0, 2**target_bits - 1]``.

        The implementation compares against the maximum value and selects
        the smaller of the two, then truncates to *target_bits*.
        """
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
