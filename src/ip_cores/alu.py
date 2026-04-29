"""Element-wise ALU IP core for INT8 tile operations."""

from __future__ import annotations

import pyrtl
from pyrtl import WireVector

from ip_cores.axi_stream_base import AXI4StreamLiteBase, StreamShape


class ALUCore(AXI4StreamLiteBase):
    """Element-wise ALU performing ADD, MULTIPLY, and MASK on INT8 tiles.

    Parameters
    ----------
    T_width : int
        Number of elements per tile.  Each operand bus is ``T_width * 8`` bits.
    name : str
        Unique instance name for wire prefixing.
    """

    def __init__(self, T_width: int, name: str) -> None:
        super().__init__(tiling_param=T_width, name=name)

        with pyrtl.set_working_block(self.block, no_sanity_check=True):
            self.data_in_b = WireVector(
                bitwidth=self._bus_width, name=f"{name}_data_in_b"
            )
            self.op_code = WireVector(bitwidth=2, name=f"{name}_op_code")

            out_reg = pyrtl.Register(bitwidth=self._bus_width, name=f"{name}_out_reg")
            valid_reg = pyrtl.Register(bitwidth=1, name=f"{name}_valid_reg")

            handshake = self.handshake_accepted()
            stall = self.stall_pipeline()

            lane_results: list[WireVector] = []
            for lane in range(T_width):
                low = lane * 8
                high = low + 8
                a_byte = self.data_in[low:high]
                b_byte = self.data_in_b[low:high]

                add_sum = a_byte + b_byte
                add_res = add_sum[:8]

                sign_a = a_byte[7]
                sign_b = b_byte[7]
                prod16 = a_byte * b_byte

                corr_a = pyrtl.select(
                    sign_a,
                    pyrtl.concat(b_byte, pyrtl.Const(0, bitwidth=8)),
                    pyrtl.Const(0, bitwidth=16),
                )
                corr_b = pyrtl.select(
                    sign_b,
                    pyrtl.concat(a_byte, pyrtl.Const(0, bitwidth=8)),
                    pyrtl.Const(0, bitwidth=16),
                )
                corr_ab = pyrtl.select(
                    sign_a & sign_b,
                    pyrtl.Const(0x10000, bitwidth=17),
                    pyrtl.Const(0, bitwidth=17),
                )

                prod17 = pyrtl.concat(pyrtl.Const(0, bitwidth=1), prod16)
                corr_a17 = pyrtl.concat(pyrtl.Const(0, bitwidth=1), corr_a)
                corr_b17 = pyrtl.concat(pyrtl.Const(0, bitwidth=1), corr_b)
                signed_prod17 = prod17 - corr_a17 - corr_b17 + corr_ab

                mul_res = signed_prod17[8:16]

                mask_res = pyrtl.select(
                    b_byte != 0,
                    a_byte,
                    pyrtl.Const(0, bitwidth=8),
                )

                elem_res = pyrtl.select(
                    self.op_code == 0,
                    add_res,
                    pyrtl.select(
                        self.op_code == 1,
                        mul_res,
                        mask_res,
                    ),
                )
                lane_results.append(elem_res)

            result_bus = pyrtl.concat_list(lane_results)

            out_reg.next <<= pyrtl.select(handshake, result_bus, out_reg)
            valid_reg.next <<= pyrtl.select(
                stall,
                valid_reg,
                pyrtl.select(
                    handshake,
                    self.valid_in,
                    pyrtl.Const(0, bitwidth=1),
                ),
            )

            self.data_out <<= out_reg
            self.valid_out <<= valid_reg
            self.ready_out <<= ~valid_reg | self.ready_in

    def infer_output_shape(self) -> StreamShape:
        if self.input_shape is not None:
            return self.input_shape
        return StreamShape(self._bus_width // 8, self._bus_width // 8)
