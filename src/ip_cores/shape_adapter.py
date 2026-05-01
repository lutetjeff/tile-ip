"""Stream Shape Adapter IP core with AXI4-Stream-Lite interface.

Dynamically reshapes AXI4-Stream-Lite data between streams with different
tiling factors but the same total tensor size N.
"""

from __future__ import annotations

import pyrtl
from pyrtl import WireVector

from ip_cores.axi_stream_base import AXI4StreamLiteBase, StreamShape


class StreamShapeAdapter(AXI4StreamLiteBase):
    """Reshape AXI4-Stream-Lite data from tiling factor T_in to T_out.

    Parameters
    ----------
    N : int
        Total number of bytes in the tensor. Must be a multiple of both
        ``T_in`` and ``T_out``.
    T_in : int
        Number of bytes per input beat.
    T_out : int
        Number of bytes per output beat.
    name : str
        Unique instance name used to prefix every internal wire.
    block : pyrtl.Block, optional
        Existing PyRTL block to use. If ``None``, a new block is created.

    Examples
    --------
    Adapting from T=2 to T=4 with N=8::

        adapter = StreamShapeAdapter(N=8, T_in=2, T_out=4, name="sa")
        # Input:  4 beats of 2 bytes each
        # Output: 2 beats of 4 bytes each
    """

    def __init__(
        self,
        N: int,
        T_in: int,
        T_out: int,
        name: str,
        block=None,
    ) -> None:
        if N <= 0:
            raise ValueError("N must be a positive integer")
        if T_in <= 0 or T_out <= 0:
            raise ValueError("T_in and T_out must be positive integers")
        if N % T_in != 0:
            raise ValueError(f"N ({N}) must be a multiple of T_in ({T_in})")
        if N % T_out != 0:
            raise ValueError(f"N ({N}) must be a multiple of T_out ({T_out})")
        if not name:
            raise ValueError("name must be a non-empty string")

        self._N = N
        self._T_in = T_in
        self._T_out = T_out

        super().__init__(
            tiling_param=T_in,
            name=name,
            block=block,
            input_shape=StreamShape(N, T_in),
        )

        with pyrtl.set_working_block(self.block, no_sanity_check=True):
            out_width = T_out * 8
            self.block.wirevector_set.remove(self.data_out)
            self.data_out = WireVector(
                bitwidth=out_width, name=f"{name}_data_out"
            )

            self.last_out = WireVector(bitwidth=1, name=f"{name}_last_out")

            self._build_core()

    def _build_core(self) -> None:
        N = self._N
        T_in = self._T_in
        T_out = self._T_out
        name = self._name

        num_in_beats = N // T_in
        num_out_beats = N // T_out

        in_beat_count = pyrtl.Register(
            bitwidth=max(1, num_in_beats.bit_length()),
            name=f"{name}_in_beat_count",
        )
        out_beat_count = pyrtl.Register(
            bitwidth=max(1, num_out_beats.bit_length()),
            name=f"{name}_out_beat_count",
        )

        input_accepted = self.valid_in & self.ready_out
        output_accepted = self.valid_out & self.ready_in

        if T_in < T_out:
            k = T_out // T_in
            slot_idx = pyrtl.Register(
                bitwidth=max(1, k.bit_length()),
                name=f"{name}_slot_idx",
            )

            slots = []
            for i in range(k):
                slot = pyrtl.Register(
                    bitwidth=T_in * 8,
                    name=f"{name}_slot_{i}",
                )
                slots.append(slot)

            buffer_full = in_beat_count >= (out_beat_count + 1) * k

            self.valid_out <<= buffer_full & (out_beat_count < num_out_beats)
            self.ready_out <<= (in_beat_count < num_in_beats) & (
                ~buffer_full | output_accepted
            )

            in_beat_count.next <<= pyrtl.select(
                input_accepted, in_beat_count + 1, in_beat_count
            )
            out_beat_count.next <<= pyrtl.select(
                output_accepted, out_beat_count + 1, out_beat_count
            )
            slot_idx.next <<= pyrtl.select(
                input_accepted,
                pyrtl.select(slot_idx == k - 1, 0, slot_idx + 1),
                slot_idx,
            )

            for i in range(k):
                slots[i].next <<= pyrtl.select(
                    input_accepted & (slot_idx == i),
                    self.data_in,
                    slots[i],
                )

            # Slot 0 (first received) occupies LSB, slot k-1 (last) MSB.
            self.data_out <<= pyrtl.concat(
                *[slots[i] for i in range(k - 1, -1, -1)]
            )

        elif T_in > T_out:
            k = T_in // T_out

            buffer = pyrtl.Register(
                bitwidth=T_in * 8,
                name=f"{name}_buffer",
            )
            chunks_rem = pyrtl.Register(
                bitwidth=max(1, (k + 1).bit_length()),
                name=f"{name}_chunks_rem",
            )
            out_sub_idx = pyrtl.Register(
                bitwidth=max(1, k.bit_length()),
                name=f"{name}_out_sub_idx",
            )

            has_buffered = chunks_rem > 0

            self.valid_out <<= has_buffered & (out_beat_count < num_out_beats)
            self.ready_out <<= (in_beat_count < num_in_beats) & (
                ~has_buffered | (output_accepted & (out_sub_idx == k - 1))
            )

            in_beat_count.next <<= pyrtl.select(
                input_accepted, in_beat_count + 1, in_beat_count
            )
            out_beat_count.next <<= pyrtl.select(
                output_accepted, out_beat_count + 1, out_beat_count
            )
            buffer.next <<= pyrtl.select(
                input_accepted, self.data_in, buffer
            )
            chunks_rem.next <<= pyrtl.select(
                input_accepted,
                k,
                pyrtl.select(output_accepted, chunks_rem - 1, chunks_rem),
            )
            out_sub_idx.next <<= pyrtl.select(
                input_accepted,
                0,
                pyrtl.select(
                    output_accepted,
                    pyrtl.select(out_sub_idx == k - 1, 0, out_sub_idx + 1),
                    out_sub_idx,
                ),
            )

            data_out_wire = pyrtl.Const(0, bitwidth=T_out * 8)
            for i in range(k):
                start = i * T_out * 8
                end = (i + 1) * T_out * 8
                data_out_wire = pyrtl.select(
                    out_sub_idx == i, buffer[start:end], data_out_wire
                )
            self.data_out <<= data_out_wire

        else:
            self.valid_out <<= self.valid_in & (out_beat_count < num_out_beats)
            self.ready_out <<= self.ready_in & (in_beat_count < num_in_beats)
            self.data_out <<= self.data_in

            in_beat_count.next <<= pyrtl.select(
                input_accepted, in_beat_count + 1, in_beat_count
            )
            out_beat_count.next <<= pyrtl.select(
                output_accepted, out_beat_count + 1, out_beat_count
            )

        self.last_out <<= self.valid_out & (out_beat_count == num_out_beats - 1)

    def infer_output_shape(self) -> StreamShape:
        return StreamShape(self._N, self._T_out)
