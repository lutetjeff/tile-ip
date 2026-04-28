"""GEMM IP core with vector-MAC tree for INT8 matrix multiplication."""

from __future__ import annotations

import pyrtl
from pyrtl import WireVector

from ip_cores.axi_stream_base import AXI4StreamLiteBase


class GEMMCore(AXI4StreamLiteBase):
    """INT8 GEMM core using a vector-MAC tree with 32-bit accumulators.

    Computes C = A × B for tiled matrices where A is T_M × T_K, B is T_K × T_N,
    and C is T_M × T_N.  Each output element is accumulated in int32,
    requantized with an arithmetic right-shift by 8, and clipped to [-128, 127].
    """

    def __init__(self, T_M: int, T_K: int, T_N: int, name: str, block=None) -> None:
        if T_M <= 0 or T_K <= 0 or T_N <= 0:
            raise ValueError("T_M, T_K, T_N must be positive integers")
        if not name:
            raise ValueError("name must be a non-empty string")

        super().__init__(tiling_param=T_M * T_K, name=name, block=block)
        self._T_M = T_M
        self._T_K = T_K
        self._T_N = T_N
        self._name = name

        with pyrtl.set_working_block(self.block, no_sanity_check=True):
            out_width = T_M * T_N * 8
            self.block.wirevector_set.remove(self.data_out)
            self.data_out = WireVector(bitwidth=out_width, name=f"{name}_data_out")

            weight_width = T_K * T_N * 8
            self.weight_in = WireVector(bitwidth=weight_width, name=f"{name}_weight_in")
            self.weight_valid_in = WireVector(
                bitwidth=1, name=f"{name}_weight_valid_in"
            )
            self.weight_ready_out = WireVector(
                bitwidth=1, name=f"{name}_weight_ready_out"
            )

            a_elements = []
            for i in range(T_M):
                for k in range(T_K):
                    idx = i * T_K + k
                    byte = self.data_in[idx * 8 : (idx + 1) * 8]
                    sign = byte[7]
                    a_elements.append(pyrtl.concat(*[sign for _ in range(24)], byte))

            b_elements = []
            for k in range(T_K):
                for j in range(T_N):
                    idx = k * T_N + j
                    byte = self.weight_in[idx * 8 : (idx + 1) * 8]
                    sign = byte[7]
                    b_elements.append(pyrtl.concat(*[sign for _ in range(24)], byte))

            c_elements = []
            for i in range(T_M):
                for j in range(T_N):
                    acc = pyrtl.Const(0, bitwidth=32)
                    for k in range(T_K):
                        acc = acc + a_elements[i * T_K + k] * b_elements[k * T_N + j]

                    sign = acc[31]
                    shifted = pyrtl.concat(
                        pyrtl.concat(*[sign for _ in range(8)]), acc[8:32]
                    )

                    overflow_pos = (~sign) & (
                        shifted[7:31] != pyrtl.Const(0, bitwidth=24)
                    )
                    overflow_neg = sign & (
                        shifted[7:31] != pyrtl.Const(0xFFFFFF, bitwidth=24)
                    )

                    clipped = pyrtl.select(
                        overflow_pos,
                        pyrtl.Const(127, bitwidth=32),
                        pyrtl.select(
                            overflow_neg,
                            pyrtl.Const(-128, bitwidth=32),
                            shifted,
                        ),
                    )

                    c_elements.append(clipped[0:8])

            self.data_out <<= pyrtl.concat_list(c_elements)

            both_valid = self.valid_in & self.weight_valid_in
            self.valid_out <<= both_valid
            self.ready_out <<= self.ready_in
            self.weight_ready_out <<= self.ready_in

    @property
    def average_ii(self) -> int:
        """Average Initiation Interval (II) for this combinational design."""
        return 1
