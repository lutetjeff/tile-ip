"""Activation IP core with LUT-based ROMs for GELU and ReLU."""

from __future__ import annotations

import numpy as np
import pyrtl
from pyrtl import WireVector

from ip_cores.axi_stream_base import AXI4StreamLiteBase


def _compute_gelu_lut() -> list[int]:
    """Pre-compute a 256-entry INT8 GELU LUT indexed by unsigned byte value."""
    sqrt_2_over_pi = 0.7978845608
    c = 0.044715
    lut = []
    for u in range(256):
        s = np.array(u).astype(np.int8).astype(np.float32)
        gelu_float = 0.5 * s * (1 + np.tanh(sqrt_2_over_pi * (s + c * s**3)))
        gelu_scaled = np.round(gelu_float)
        val = np.clip(gelu_scaled, -128, 127).astype(np.int8)
        lut.append(int(val) & 0xFF)
    return lut


def _compute_relu_lut() -> list[int]:
    """Pre-compute a 256-entry INT8 ReLU LUT indexed by unsigned byte value."""
    lut = []
    for u in range(256):
        s = np.array(u).astype(np.int8)
        val = np.maximum(s, 0).astype(np.int8)
        lut.append(int(val) & 0xFF)
    return lut


_GELU_LUT = _compute_gelu_lut()
_RELU_LUT = _compute_relu_lut()


class ActivationCore(AXI4StreamLiteBase):
    """LUT-based activation core."""

    def __init__(
        self,
        T_width: int,
        name: str,
        activation_type: str = "relu",
    ) -> None:
        if activation_type not in ("gelu", "relu"):
            raise ValueError("activation_type must be 'gelu' or 'relu'")

        super().__init__(tiling_param=T_width, name=name)
        self._activation_type = activation_type

        lut_contents = _GELU_LUT if activation_type == "gelu" else _RELU_LUT

        with pyrtl.set_working_block(self.block, no_sanity_check=True):
            rom_outputs: list[WireVector] = []

            for lane in range(T_width):
                rom = pyrtl.RomBlock(
                    bitwidth=8,
                    addrwidth=8,
                    romdata=lut_contents,
                    name=f"{name}_rom_{lane}",
                )
                low = lane * 8
                high = low + 8
                lane_in = self.data_in[low:high]
                lane_out = rom[lane_in]
                rom_outputs.append(lane_out)

            self.data_out <<= pyrtl.concat_list(rom_outputs)
            self.valid_out <<= self.valid_in
            self.ready_out <<= self.ready_in
