"""Multi-Bank BRAM IP core with concurrent read/write ports and bank arbitration.

Provides multiple independent BRAM banks (e.g. K cache, V cache, residual,
scratch) with separate AXI4-Stream-Lite read and write interfaces.  When both
ports target the same bank simultaneously the write port wins and the read
port is stalled for that cycle.
"""

from __future__ import annotations

import pyrtl
from pyrtl import WireVector

from ip_cores.axi_stream_base import AXI4StreamLiteBase


class MultiBankBRAMCore(AXI4StreamLiteBase):
    """Multi-bank BRAM with concurrent read/write and bank arbitration.

    Parameters
    ----------
    T : int
        Spatial tiling parameter.  Data buses are ``T * 8`` bits wide.
    num_banks : int
        Number of independent BRAM banks (default 4).
    addr_width : int
        Address width per bank (default 8).
    name : str
        Unique instance name used to prefix all internal wires.
    block : pyrtl.Block, optional
        Existing PyRTL block to use.  A new block is created if None.

    Attributes
    ----------
    banks : list[pyrtl.MemBlock]
        The BRAM banks.
    read_addr : pyrtl.Input
        Read address (``addr_width`` bits).
    read_bank_sel : pyrtl.Input
        Read bank select (``ceil(log2(num_banks))`` bits).
    write_data_in : WireVector
        Write data bus (``T * 8`` bits).
    write_valid_in : WireVector
        1-bit write-request valid.
    write_ready_out : WireVector
        1-bit write-request ready.
    write_last_in : WireVector
        1-bit end-of-write-burst marker.
    write_addr : pyrtl.Input
        Write address (``addr_width`` bits).
    write_bank_sel : pyrtl.Input
        Write bank select (``ceil(log2(num_banks))`` bits).

    State encoding
    --------------
    0 = IDLE, 1 = READ_BURST, 2 = WRITE_BURST
    """

    def __init__(
        self,
        T: int,
        num_banks: int = 4,
        addr_width: int = 8,
        name: str = "mbbram",
        block: pyrtl.Block = None,
    ) -> None:
        if num_banks < 2:
            raise ValueError("num_banks must be at least 2")
        if addr_width <= 0:
            raise ValueError("addr_width must be positive")

        super().__init__(tiling_param=T, name=name, block=block)

        self._num_banks = num_banks
        self._addr_width = addr_width
        bank_sel_width = max(1, (num_banks - 1).bit_length())

        with pyrtl.set_working_block(self.block, no_sanity_check=True):
            self.banks = [
                pyrtl.MemBlock(
                    bitwidth=self._bus_width,
                    addrwidth=addr_width,
                    name=f"{name}_bank_{i}",
                )
                for i in range(num_banks)
            ]

            self.read_addr = WireVector(
                bitwidth=addr_width, name=f"{name}_read_addr"
            )
            self.read_bank_sel = WireVector(
                bitwidth=bank_sel_width, name=f"{name}_read_bank_sel"
            )

            self.write_data_in = WireVector(
                bitwidth=self._bus_width, name=f"{name}_write_data_in"
            )
            self.write_valid_in = WireVector(
                bitwidth=1, name=f"{name}_write_valid_in"
            )
            self.write_ready_out = WireVector(
                bitwidth=1, name=f"{name}_write_ready_out"
            )
            self.write_last_in = WireVector(
                bitwidth=1, name=f"{name}_write_last_in"
            )
            self.write_addr = WireVector(
                bitwidth=addr_width, name=f"{name}_write_addr"
            )
            self.write_bank_sel = WireVector(
                bitwidth=bank_sel_width, name=f"{name}_write_bank_sel"
            )

            self.read_state = pyrtl.Register(
                bitwidth=2, name=f"{name}_read_state"
            )
            self.read_addr_reg = pyrtl.Register(
                bitwidth=addr_width, name=f"{name}_read_addr_reg"
            )
            self.read_bank_sel_reg = pyrtl.Register(
                bitwidth=bank_sel_width, name=f"{name}_read_bank_sel_reg"
            )
            self.read_burst_len = pyrtl.Register(
                bitwidth=8, name=f"{name}_read_burst_len"
            )
            self.read_count = pyrtl.Register(
                bitwidth=8, name=f"{name}_read_count"
            )

            self.write_state = pyrtl.Register(
                bitwidth=2, name=f"{name}_write_state"
            )
            self.write_addr_reg = pyrtl.Register(
                bitwidth=addr_width, name=f"{name}_write_addr_reg"
            )
            self.write_bank_sel_reg = pyrtl.Register(
                bitwidth=bank_sel_width, name=f"{name}_write_bank_sel_reg"
            )

            bank_conflict = (
                (self.read_state == 1)
                & (self.write_state == 2)
                & (self.read_bank_sel_reg == self.write_bank_sel_reg)
            )
            read_stalled = bank_conflict

            with pyrtl.conditional_assignment:
                with self.read_state == 0:
                    with self.valid_in & self.ready_out & self.last_in:
                        self.read_state.next |= 1
                with self.read_state == 1:
                    with (~read_stalled) & self.ready_in:
                        with self.read_count == self.read_burst_len - 1:
                            self.read_state.next |= 0

            with pyrtl.conditional_assignment:
                with self.write_state == 0:
                    with self.write_valid_in & self.write_ready_out:
                        with self.write_last_in:
                            self.write_state.next |= 0
                        with pyrtl.otherwise:
                            self.write_state.next |= 2
                with self.write_state == 2:
                    with self.write_valid_in & self.write_ready_out:
                        with self.write_last_in:
                            self.write_state.next |= 0

            with pyrtl.conditional_assignment:
                with self.read_state == 0:
                    with self.valid_in & self.ready_out & self.last_in:
                        self.read_addr_reg.next |= self.read_addr
                        self.read_bank_sel_reg.next |= self.read_bank_sel
                        self.read_burst_len.next |= self.data_in[0:8]
                        self.read_count.next |= 0
                with self.read_state == 1:
                    with (~read_stalled) & self.ready_in:
                        self.read_addr_reg.next |= self.read_addr_reg + 1
                        self.read_count.next |= self.read_count + 1

            with pyrtl.conditional_assignment:
                with self.write_state == 0:
                    with self.write_valid_in & self.write_ready_out:
                        self.write_addr_reg.next |= self.write_addr + 1
                        self.write_bank_sel_reg.next |= self.write_bank_sel
                with self.write_state == 2:
                    with self.write_valid_in & self.write_ready_out:
                        self.write_addr_reg.next |= self.write_addr_reg + 1

            bank_read_data = pyrtl.mux(
                self.read_bank_sel_reg,
                *[bank[self.read_addr_reg] for bank in self.banks],
            )

            write_active = (self.write_state == 0) | (self.write_state == 2)
            write_en = write_active & self.write_valid_in & (~read_stalled)
            write_addr_active = pyrtl.select(
                self.write_state == 0,
                self.write_addr,
                self.write_addr_reg,
            )
            write_bank_active = pyrtl.select(
                self.write_state == 0,
                self.write_bank_sel,
                self.write_bank_sel_reg,
            )
            for i, bank in enumerate(self.banks):
                bank[write_addr_active] <<= pyrtl.MemBlock.EnabledWrite(
                    self.write_data_in,
                    write_en & (write_bank_active == i),
                )

            self.data_out <<= bank_read_data
            self.valid_out <<= (self.read_state == 1) & (~read_stalled)
            self.last_out <<= (
                (self.read_state == 1)
                & (~read_stalled)
                & (self.read_count == self.read_burst_len - 1)
            )
            self.ready_out <<= self.read_state == 0
            self.write_ready_out <<= (self.write_state == 0) | (self.write_state == 2)
