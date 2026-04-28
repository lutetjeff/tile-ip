"""Memory Router IP core with BRAM-backed token fetch and AXI4-Stream output."""

from __future__ import annotations

import pyrtl
from pyrtl import WireVector

from ip_cores.axi_stream_base import AXI4StreamLiteBase


class MemRouterCore(AXI4StreamLiteBase):
    """Memory Router that fetches tokens from BRAM and streams them via AXI4-Stream-Lite.

    The core implements a programmable state machine with configurable stride
    patterns to support operations such as matrix transposition (column-wise
    reads) or linear contiguous reads.

    Configuration registers (initialised via ``register_value_map`` in
    simulation, or driven externally in a full SoC integration):

    - ``base_addr``   : starting BRAM address for the first read.
    - ``stride``      : address increment between consecutive reads *within*
                      one output beat.
    - ``beat_stride`` : address increment applied to ``base_addr`` between
                      output beats.
    - ``num_beats``   : total number of output beats to produce.

    State encoding
    --------------
    0 = IDLE, 1 = READ, 2 = OUTPUT, 3 = DONE

    Parameters
    ----------
    T_out : int
        Number of bytes packed per output beat (tiling parameter).
    name : str
        Unique instance name used to prefix all internal wires.
    """

    def __init__(self, T_out: int, name: str, block=None) -> None:
        super().__init__(tiling_param=T_out, name=name, block=block)

        with pyrtl.set_working_block(self.block, no_sanity_check=True):
            self.bram = pyrtl.MemBlock(
                bitwidth=8,
                addrwidth=8,
                name=f"{name}_bram",
            )

            self.base_addr = pyrtl.Register(bitwidth=8, name=f"{name}_base_addr")
            self.stride = pyrtl.Register(bitwidth=8, name=f"{name}_stride")
            self.beat_stride = pyrtl.Register(bitwidth=8, name=f"{name}_beat_stride")
            self.num_beats = pyrtl.Register(bitwidth=8, name=f"{name}_num_beats")

            self.state = pyrtl.Register(bitwidth=2, name=f"{name}_state")
            self.beat_count = pyrtl.Register(bitwidth=8, name=f"{name}_beat_count")
            self.read_idx = pyrtl.Register(bitwidth=8, name=f"{name}_read_idx")
            self.current_addr = pyrtl.Register(bitwidth=8, name=f"{name}_current_addr")

            self.byte_regs = [
                pyrtl.Register(bitwidth=8, name=f"{name}_byte_{i}")
                for i in range(T_out)
            ]

            self.base_addr.next <<= self.base_addr
            self.stride.next <<= self.stride
            self.beat_stride.next <<= self.beat_stride
            self.num_beats.next <<= self.num_beats

            with pyrtl.conditional_assignment:
                with self.state == 0:
                    with self.valid_in:
                        with self.num_beats == 0:
                            self.state.next |= 3
                        with pyrtl.otherwise:
                            self.state.next |= 1
                with self.state == 1:
                    with self.read_idx == T_out - 1:
                        self.state.next |= 2
                with self.state == 2:
                    with self.ready_in:
                        with self.beat_count == self.num_beats - 1:
                            self.state.next |= 3
                        with pyrtl.otherwise:
                            self.state.next |= 1
                with self.state == 3:
                    with self.valid_in:
                        with self.num_beats == 0:
                            self.state.next |= 3
                        with pyrtl.otherwise:
                            self.state.next |= 1

            with pyrtl.conditional_assignment:
                with self.state == 0:
                    with self.valid_in:
                        self.current_addr.next |= self.base_addr
                        self.read_idx.next |= 0
                        self.beat_count.next |= 0
                with self.state == 1:
                    self.current_addr.next |= self.current_addr + self.stride
                    self.read_idx.next |= self.read_idx + 1
                with self.state == 2:
                    with self.ready_in:
                        with self.beat_count != self.num_beats - 1:
                            self.current_addr.next |= (
                                self.base_addr
                                + (self.beat_count + 1) * self.beat_stride
                            )
                            self.read_idx.next |= 0
                            self.beat_count.next |= self.beat_count + 1
                with self.state == 3:
                    with self.valid_in:
                        self.current_addr.next |= self.base_addr
                        self.read_idx.next |= 0
                        self.beat_count.next |= 0

            bram_data = self.bram[self.current_addr]
            for i in range(T_out):
                with pyrtl.conditional_assignment:
                    with self.state == 1:
                        with self.read_idx == i:
                            self.byte_regs[i].next |= bram_data

            self.data_out <<= pyrtl.concat_list(self.byte_regs)
            self.valid_out <<= self.state == 2
            self.ready_out <<= self.state == 0
