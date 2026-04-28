"""FIFO IP core with AXI4-Stream-Lite interface."""

from __future__ import annotations

import pyrtl
from pyrtl import WireVector

from ip_cores.axi_stream_base import AXI4StreamLiteBase


class FIFOCore(AXI4StreamLiteBase):
    """Simple FIFO buffer with AXI4-Stream-Lite handshake.

    Parameters
    ----------
    T_width : int
        Number of bytes per beat.  The data buses are ``T_width * 8`` bits wide.
    depth : int
        FIFO depth (number of entries).
    name : str
        Unique instance name for wire prefixing.
    """

    def __init__(self, T_width: int, depth: int, name: str) -> None:
        super().__init__(tiling_param=T_width, name=name)

        with pyrtl.set_working_block(self.block, no_sanity_check=True):
            ptr_width = max(1, (depth - 1).bit_length())
            count_width = max(1, depth.bit_length())

            head = pyrtl.Register(bitwidth=ptr_width, name=f"{name}_head")
            tail = pyrtl.Register(bitwidth=ptr_width, name=f"{name}_tail")
            count = pyrtl.Register(bitwidth=count_width, name=f"{name}_count")

            mem = pyrtl.MemBlock(
                bitwidth=self._bus_width,
                addrwidth=ptr_width,
                name=f"{name}_mem",
            )

            write_en = self.valid_in & self.ready_out
            read_en = self.valid_out & self.ready_in

            self.ready_out <<= count < depth
            self.valid_out <<= count > 0
            self.data_out <<= pyrtl.select(
                count > 0,
                mem[tail],
                pyrtl.Const(0, bitwidth=self._bus_width),
            )

            head.next <<= pyrtl.select(write_en, head + 1, head)
            tail.next <<= pyrtl.select(read_en, tail + 1, tail)

            count.next <<= pyrtl.select(
                write_en & read_en,
                count,
                pyrtl.select(
                    write_en,
                    count + 1,
                    pyrtl.select(
                        read_en,
                        count - 1,
                        count,
                    ),
                ),
            )

            mem[head] <<= pyrtl.MemBlock.EnabledWrite(self.data_in, write_en)
