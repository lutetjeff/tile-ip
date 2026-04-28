"""Softmax IP core with LUT-based exponentiation and division."""

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


class SoftmaxCore(AXI4StreamLiteBase):
    def __init__(self, T_seq: int, name: str, block=None) -> None:
        super().__init__(tiling_param=T_seq, name=name, block=block)

        with pyrtl.set_working_block(self.block, no_sanity_check=True):
            lanes: list[WireVector] = []
            for i in range(T_seq):
                lane = self.data_in[i * 8 : (i + 1) * 8]
                lanes.append(lane)

            max_val = self._find_max(lanes)

            exp_vals: list[WireVector] = []
            for i, lane in enumerate(lanes):
                diff = self._signed_sub_clip(lane, max_val, i)

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

            sum_val = self._adder_tree(exp_vals)

            max_sum = T_seq * 255
            inv_sum_lut_data = _compute_inv_sum_lut(max_sum)
            inv_sum_rom = pyrtl.RomBlock(
                bitwidth=16,
                addrwidth=sum_val.bitwidth,
                romdata=inv_sum_lut_data,
                name=f"{name}_inv_sum_rom",
                asynchronous=True,
            )
            inv_sum = pyrtl.WireVector(bitwidth=16, name=f"{name}_inv_sum")
            inv_sum <<= inv_sum_rom[sum_val]

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

            self.data_out <<= pyrtl.concat_list(results)
            self.valid_out <<= self.valid_in
            self.ready_out <<= self.ready_in

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
