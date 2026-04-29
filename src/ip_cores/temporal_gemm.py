"""Temporal GEMM IP core with stateful accumulation over multiple beats."""

from __future__ import annotations

import pyrtl
from pyrtl import WireVector

from ip_cores.axi_stream_base import AXI4StreamLiteBase, StreamShape


class TemporalGEMMCore(AXI4StreamLiteBase):
    def __init__(
        self,
        T_M: int,
        T_K: int,
        T_N: int,
        name: str,
        M: int | None = None,
        N: int | None = None,
        block=None,
    ) -> None:
        if T_M <= 0 or T_K <= 0 or T_N <= 0:
            raise ValueError("T_M, T_K, T_N must be positive integers")
        if not name:
            raise ValueError("name must be a non-empty string")

        M = M if M is not None else T_M
        N = N if N is not None else T_N
        if M <= 0 or N <= 0:
            raise ValueError("M and N must be positive integers")
        if M % T_M != 0 or N % T_N != 0:
            raise ValueError("M must be a multiple of T_M and N must be a multiple of T_N")

        super().__init__(tiling_param=T_M * T_K, name=name, block=block)
        self._T_M = T_M
        self._T_K = T_K
        self._T_N = T_N
        self._M = M
        self._N = N
        self._name = name

        num_tiles = (M * N) // (T_M * T_N)
        counter_bits = (num_tiles - 1).bit_length() if num_tiles > 1 else 1

        with pyrtl.set_working_block(self.block, no_sanity_check=True):
            self.accum_in = WireVector(bitwidth=1, name=f"{name}_accum_in")
            self.emit_in = WireVector(bitwidth=1, name=f"{name}_emit_in")

            weight_width = T_K * T_N * 8
            self.weight_in = WireVector(bitwidth=weight_width, name=f"{name}_weight_in")
            self.weight_valid_in = WireVector(
                bitwidth=1, name=f"{name}_weight_valid_in"
            )
            self.weight_ready_out = WireVector(
                bitwidth=1, name=f"{name}_weight_ready_out"
            )

            out_width = T_M * T_N * 8
            self.block.wirevector_set.remove(self.data_out)
            self.data_out = WireVector(bitwidth=out_width, name=f"{name}_data_out")

            state = pyrtl.Register(bitwidth=1, name=f"{name}_state")
            tile_counter = pyrtl.Register(
                bitwidth=counter_bits, name=f"{name}_tile_counter"
            )
            emit_counter = pyrtl.Register(
                bitwidth=counter_bits, name=f"{name}_emit_counter"
            )

            accum_regs = []
            for i in range(M):
                for j in range(N):
                    reg = pyrtl.Register(bitwidth=32, name=f"{name}_accum_{i}_{j}")
                    accum_regs.append(reg)

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

            mac_results = []
            for i in range(T_M):
                for j in range(T_N):
                    acc = pyrtl.Const(0, bitwidth=32)
                    for k in range(T_K):
                        acc = acc + a_elements[i * T_K + k] * b_elements[k * T_N + j]
                    mac_results.append(acc)

            both_valid = self.valid_in & self.weight_valid_in
            handshake = both_valid & (state == 0)

            tile_matches = []
            for t in range(num_tiles):
                if num_tiles == 1:
                    tile_matches.append(pyrtl.Const(1, bitwidth=1))
                else:
                    tile_matches.append(tile_counter == t)

            for idx, reg in enumerate(accum_regs):
                tile_idx = idx // (T_M * T_N)
                local_idx = idx % (T_M * T_N)
                should_update = handshake & tile_matches[tile_idx]

                with pyrtl.conditional_assignment:
                    with should_update & self.accum_in:
                        reg.next |= reg + mac_results[local_idx]
                    with should_update:
                        reg.next |= mac_results[local_idx]
                    with pyrtl.otherwise:
                        reg.next |= reg

            with pyrtl.conditional_assignment:
                with state == 0:
                    with handshake & (self.emit_in | self.last_in):
                        state.next |= 1
                        tile_counter.next |= 0
                    with handshake:
                        state.next |= 0
                        tile_counter.next |= tile_counter + 1
                    with pyrtl.otherwise:
                        state.next |= 0
                        tile_counter.next |= tile_counter
                with state == 1:
                    with self.ready_in & (emit_counter == num_tiles - 1):
                        state.next |= 0
                        emit_counter.next |= 0
                    with self.ready_in:
                        state.next |= 1
                        emit_counter.next |= emit_counter + 1
                    with pyrtl.otherwise:
                        state.next |= 1
                        emit_counter.next |= emit_counter

            def _requantize_clip(acc32: WireVector) -> WireVector:
                sign = acc32[31]
                shifted = pyrtl.concat(
                    pyrtl.concat(*[sign for _ in range(8)]), acc32[8:32]
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
                return clipped[0:8]

            c_elements = []
            for reg in accum_regs:
                c_elements.append(_requantize_clip(reg))

            tile_outputs = []
            for t in range(num_tiles):
                start = t * T_M * T_N
                end = (t + 1) * T_M * T_N
                tile_outputs.append(pyrtl.concat_list(c_elements[start:end]))

            if num_tiles == 1:
                data_out_value = tile_outputs[0]
            else:
                data_out_value = tile_outputs[0]
                for t in range(1, num_tiles):
                    data_out_value = pyrtl.select(
                        emit_counter == t, tile_outputs[t], data_out_value
                    )

            self.data_out <<= data_out_value
            self.valid_out <<= state == 1
            self.last_out <<= (state == 1) & (emit_counter == num_tiles - 1)
            self.ready_out <<= state == 0
            self.weight_ready_out <<= state == 0

    def infer_output_shape(self) -> StreamShape:
        return StreamShape(self._M * self._N, self._T_M * self._T_N)

    @property
    def average_ii(self) -> int:
        return 1
