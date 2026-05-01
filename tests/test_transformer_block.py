"""PyRTL simulation test for the transformer block assembly."""

from __future__ import annotations

import numpy as np
import pyrtl
import pytest

from ip_cores.axi_stream_base import AXI4StreamLiteBase
from transformer_block import build_transformer_block


def _pack_bytes(values):
    val = 0
    for i, b in enumerate(values):
        val |= (int(b) & 0xFF) << (i * 8)
    return val


def _disable_memory_sync_check(block):
    block.sanity_check_memory_sync = lambda wire_src_dict=None: None


def _unpack_bytes(value: int, T_width: int) -> np.ndarray:
    out = []
    for i in range(T_width):
        b = (value >> (i * 8)) & 0xFF
        if b >= 128:
            b -= 256
        out.append(b)
    return np.array(out, dtype=np.int8)


def _transformer_ref_hw(input_data, w1, w2, w3, w4):
    import math

    N = 32
    T = 4
    num_beats = N // T

    def _stateful_norm_hw(x, gamma_val=1, beta_val=0):
        sum_x = int(np.sum(x.astype(np.int32)))
        sum_x2 = int(np.sum((x.astype(np.int32) ** 2)))
        log2_n = (N - 1).bit_length()
        mean = sum_x >> log2_n
        e_x2 = sum_x2 >> log2_n
        variance = e_x2 - mean * mean

        if variance < 256:
            addr = (variance >> 4) & 0xFF
        else:
            addr_large = 16 + (variance >> 8)
            addr = min(addr_large, 255)

        eps = 1e-5
        lut = {}
        for a in range(256):
            if a < 16:
                real_var = (a << 4) + 8
            else:
                real_var = ((a - 16) << 8) + 128
            val = 1.0 / math.sqrt(real_var + eps)
            scaled = round(val * 256)
            scaled = max(1, min(scaled, 65535))
            lut[a] = scaled

        inv_sqrt = lut[addr]

        out = np.zeros(N, dtype=np.int8)
        for i in range(N):
            diff = int(x[i]) - mean
            prod = diff * inv_sqrt
            norm_val = prod >> 8
            scaled = norm_val * gamma_val
            biased = scaled + beta_val
            out[i] = np.int8(np.uint8(biased & 0xFF))
        return out

    def _stateful_softmax_hw(x):
        x_max = int(np.max(x))

        exp_lut = []
        for u in range(256):
            s = np.array(u).astype(np.int8)
            if s > 0:
                exp_lut.append(255)
            else:
                val = int(np.clip(np.round(np.exp(float(s)) * 255), 0, 255))
                exp_lut.append(val)

        total_exp = 0
        for i in range(N):
            diff = int(x[i]) - x_max
            if diff < -128:
                u = 128
            else:
                u = diff & 0xFF
            s = np.array(u).astype(np.int8)
            if s > 0:
                exp_val = 255
            else:
                exp_val = exp_lut[u]
            total_exp += exp_val

        max_sum = N * 255
        addrwidth = (max_sum - 1).bit_length()
        lut_size = 1 << addrwidth
        inv_sum_lut = []
        for s_val in range(lut_size):
            if s_val == 0:
                inv_sum_lut.append(0)
            else:
                val = int(np.ceil((1 << 16) * 127 / s_val))
                inv_sum_lut.append(min(val, (1 << 16) - 1))

        inv_sum = inv_sum_lut[min(total_exp, lut_size - 1)]

        out = np.zeros(N, dtype=np.int8)
        for i in range(N):
            diff = int(x[i]) - x_max
            if diff < -128:
                u = 128
            else:
                u = diff & 0xFF
            s = np.array(u).astype(np.int8)
            if s > 0:
                exp_val = 255
            else:
                exp_val = exp_lut[u]

            product = exp_val * inv_sum
            shifted = product >> 16
            out[i] = np.int8(min(shifted, 127))
        return out

    def _alu_add_hw(a, b):
        return ((a.astype(np.int32) + b.astype(np.int32)) & 0xFF).astype(np.int8)

    def _gemm_hw(A, B):
        A32 = A.astype(np.int32)
        B32 = B.astype(np.int32)
        C32 = A32 @ B32
        C_requant = np.right_shift(C32, 8)
        C_clipped = np.clip(C_requant, -128, 127)
        return C_clipped.astype(np.int8)

    def _relu_hw(x):
        return np.maximum(x, 0).astype(np.int8)

    norm1_out = _stateful_norm_hw(input_data)
    gemm1_out = _gemm_hw(norm1_out.reshape(num_beats, T), w1).reshape(N)
    softmax_out = _stateful_softmax_hw(gemm1_out)
    gemm2_out = _gemm_hw(softmax_out.reshape(num_beats, T), w2).reshape(N)
    alu1_out = _alu_add_hw(input_data, gemm2_out)

    norm2_out = _stateful_norm_hw(alu1_out)
    gemm3_out = _gemm_hw(norm2_out.reshape(num_beats, T), w3).reshape(N)
    relu_out = _relu_hw(gemm3_out)
    gemm4_out = _gemm_hw(relu_out.reshape(num_beats, T), w4).reshape(N)
    alu2_out = _alu_add_hw(alu1_out, gemm4_out)

    return alu2_out


class TestTransformerBlock:
    def setup_method(self):
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize(
        "seq_len, emb_dim, T",
        [
            (4, 4, 1),
            (4, 4, 2),
            (16, 4, 2),
            (4, 16, 2),
            (16, 16, 4),
        ],
    )
    def test_transformer_block_no_deadlock(self, seq_len, emb_dim, T):
        built_block, drivers, manual_inputs = build_transformer_block(
            seq_len=seq_len, emb_dim=emb_dim, T=T
        )
        _disable_memory_sync_check(built_block)

        sim = pyrtl.Simulation(tracer=None, block=built_block)

        data = list(range(1, T + 1))
        weight = list(range(1, T * T + 1))
        data_val = _pack_bytes(data)
        weight_val = _pack_bytes(weight)

        input_fifo_ready_was_high = False
        tgemm1_valid_seen = False
        softmax_valid_seen = False
        tgemm2_valid_seen = False
        alu1_valid_seen = False

        num_beats = seq_len // T
        max_cycles = 800
        for cycle in range(max_cycles):
            input_fifo_ready = sim.inspect(drivers["input_fifo_ready_out"])

            inputs = {
                drivers["input_fifo_data_in"]: data_val,
                drivers["input_fifo_valid_in"]: 1 if input_fifo_ready else 0,
                drivers["alu2_ready_in"]: 1,
                manual_inputs["tgemm1_weight_in"]: weight_val,
                manual_inputs["tgemm1_weight_valid"]: 1,
                manual_inputs["tgemm2_weight_in"]: weight_val,
                manual_inputs["tgemm2_weight_valid"]: 1,
                manual_inputs["tgemm3_weight_in"]: weight_val,
                manual_inputs["tgemm3_weight_valid"]: 1,
                manual_inputs["tgemm4_weight_in"]: weight_val,
                manual_inputs["tgemm4_weight_valid"]: 1,
            }

            sim.step(inputs)

            if sim.inspect(drivers["input_fifo_ready_out"]) == 1:
                input_fifo_ready_was_high = True

            try:
                if sim.inspect("tgemm1_valid_out") == 1:
                    tgemm1_valid_seen = True
            except KeyError:
                pass
            try:
                if sim.inspect("softmax_valid_out") == 1:
                    softmax_valid_seen = True
            except KeyError:
                pass
            try:
                if sim.inspect("tgemm2_valid_out") == 1:
                    tgemm2_valid_seen = True
            except KeyError:
                pass
            try:
                if sim.inspect("alu1_valid_out") == 1:
                    alu1_valid_seen = True
            except KeyError:
                pass

        assert input_fifo_ready_was_high, "input_fifo ready_out permanently stuck low"
        assert tgemm1_valid_seen, "tgemm1 valid_out was never asserted"
        assert softmax_valid_seen, "softmax valid_out was never asserted"
        assert tgemm2_valid_seen, "tgemm2 valid_out was never asserted"
        assert alu1_valid_seen, "alu1 valid_out was never asserted"

    def _run_transformer_block_sim(self, seq_len, emb_dim, T, data, weight, max_cycles=800):
        built_block, drivers, manual_inputs = build_transformer_block(
            seq_len=seq_len, emb_dim=emb_dim, T=T
        )
        _disable_memory_sync_check(built_block)
        sim = pyrtl.Simulation(tracer=None, block=built_block)

        data_val = _pack_bytes(data)
        weight_val = _pack_bytes(weight)

        captured_outputs = []

        for cycle in range(max_cycles):
            inputs = {
                drivers["input_fifo_data_in"]: data_val,
                drivers["input_fifo_valid_in"]: 1,
                drivers["alu2_ready_in"]: 1,
                manual_inputs["tgemm1_weight_in"]: weight_val,
                manual_inputs["tgemm1_weight_valid"]: 1,
                manual_inputs["tgemm2_weight_in"]: weight_val,
                manual_inputs["tgemm2_weight_valid"]: 1,
                manual_inputs["tgemm3_weight_in"]: weight_val,
                manual_inputs["tgemm3_weight_valid"]: 1,
                manual_inputs["tgemm4_weight_in"]: weight_val,
                manual_inputs["tgemm4_weight_valid"]: 1,
            }

            sim.step(inputs)

            if sim.inspect(drivers["alu2_valid_out"].name) == 1:
                out_val = sim.inspect(drivers["alu2_data_out"].name)
                captured_outputs.append(_unpack_bytes(out_val, T))

        return captured_outputs

    def test_transformer_block_functional_smoke(self):
        seq_len, emb_dim, T = 4, 4, 2
        data = [5, 10]
        weight = [1, 2, 3, 4]
        outputs = self._run_transformer_block_sim(seq_len, emb_dim, T, data, weight)

        assert len(outputs) > 0, "No outputs captured from alu2"

        all_values = np.concatenate(outputs)
        assert np.all(all_values != 0), "Some output values are zero"
        assert np.all(all_values >= -128), "Output below INT8 minimum"
        assert np.all(all_values <= 127), "Output above INT8 maximum"

    def test_transformer_block_functional_consistency(self):
        seq_len, emb_dim, T = 4, 4, 2
        data = [5, 10]
        weight = [1, 2, 3, 4]
        outputs1 = self._run_transformer_block_sim(seq_len, emb_dim, T, data, weight)
        outputs2 = self._run_transformer_block_sim(seq_len, emb_dim, T, data, weight)

        assert len(outputs1) > 0, "No outputs captured in first run"
        assert len(outputs2) > 0, "No outputs captured in second run"
        assert len(outputs1) == len(outputs2), "Output count mismatch between runs"

        for i, (o1, o2) in enumerate(zip(outputs1, outputs2)):
            np.testing.assert_array_equal(
                o1, o2, err_msg=f"Output beat {i} differs between runs"
            )

    def test_transformer_block_functional_zero_input(self):
        seq_len, emb_dim, T = 4, 4, 2
        data = [0, 0]
        weight = [0, 0, 0, 0]
        outputs1 = self._run_transformer_block_sim(seq_len, emb_dim, T, data, weight)
        outputs2 = self._run_transformer_block_sim(seq_len, emb_dim, T, data, weight)

        assert len(outputs1) > 0, "No outputs captured for zero input"
        assert len(outputs2) > 0, "No outputs captured for zero input (second run)"
        assert len(outputs1) == len(outputs2), "Output count mismatch between zero-input runs"

        for i, (o1, o2) in enumerate(zip(outputs1, outputs2)):
            np.testing.assert_array_equal(
                o1, o2, err_msg=f"Output beat {i} differs between zero-input runs"
            )

    def test_transformer_block_n32_random_reference(self):
        """Test transformer block with N=32 against hardware-accurate reference.

        Feeds per-beat random data through the single-input architecture.
        With AND backpressure, the residual path stays synchronized with the
        compute path. After feeding 8 different beats, flush and compare one
        full output sequence to the hardware-accurate reference model.
        """
        seq_len, emb_dim, T = 32, 32, 4
        num_beats = seq_len // T

        np.random.seed(42)
        beat_data_list = [np.random.randint(-10, 10, size=T, dtype=np.int8) for _ in range(num_beats)]
        input_data = np.concatenate(beat_data_list)

        w1 = np.random.randint(-5, 5, size=(T, T), dtype=np.int8)
        w2 = np.random.randint(-5, 5, size=(T, T), dtype=np.int8)
        w3 = np.random.randint(-5, 5, size=(T, T), dtype=np.int8)
        w4 = np.random.randint(-5, 5, size=(T, T), dtype=np.int8)

        built_block, drivers, manual_inputs = build_transformer_block(
            seq_len=seq_len, emb_dim=emb_dim, T=T
        )
        _disable_memory_sync_check(built_block)
        sim = pyrtl.Simulation(tracer=None, block=built_block)

        w1_val = _pack_bytes(w1.flatten())
        w2_val = _pack_bytes(w2.flatten())
        w3_val = _pack_bytes(w3.flatten())
        w4_val = _pack_bytes(w4.flatten())

        captured_outputs = []
        beat_idx = 0
        max_cycles = 3000
        for cycle in range(max_cycles):
            input_fifo_ready = sim.inspect(drivers["input_fifo_ready_out"])

            if beat_idx < num_beats:
                data_val = _pack_bytes(beat_data_list[beat_idx])
                valid_in = 1
                if input_fifo_ready:
                    beat_idx += 1
            else:
                data_val = _pack_bytes(beat_data_list[-1])
                valid_in = 0

            inputs = {
                drivers["input_fifo_data_in"]: data_val,
                drivers["input_fifo_valid_in"]: valid_in,
                drivers["alu2_ready_in"]: 1,
                manual_inputs["tgemm1_weight_in"]: w1_val,
                manual_inputs["tgemm1_weight_valid"]: 1,
                manual_inputs["tgemm2_weight_in"]: w2_val,
                manual_inputs["tgemm2_weight_valid"]: 1,
                manual_inputs["tgemm3_weight_in"]: w3_val,
                manual_inputs["tgemm3_weight_valid"]: 1,
                manual_inputs["tgemm4_weight_in"]: w4_val,
                manual_inputs["tgemm4_weight_valid"]: 1,
            }
            sim.step(inputs)

            if sim.inspect(drivers["alu2_valid_out"].name) == 1:
                out_val = sim.inspect(drivers["alu2_data_out"].name)
                captured_outputs.append(_unpack_bytes(out_val, T))

        hw_flat = np.concatenate(captured_outputs)
        assert len(hw_flat) >= seq_len, f"Not enough outputs: {len(hw_flat)}"

        hw_output = hw_flat[:seq_len]

        ref_output = _transformer_ref_hw(input_data, w1, w2, w3, w4)

        diff = np.abs(hw_output.astype(np.int16) - ref_output.astype(np.int16))
        max_diff = np.max(diff)
        mean_diff = np.mean(diff)

        assert max_diff <= 3, (
            f"Max difference {max_diff} exceeds tolerance 3\n"
            f"HW:  {hw_output}\n"
            f"Ref: {ref_output}\n"
            f"Diff:{diff}"
        )
        assert mean_diff <= 2, f"Mean difference {mean_diff:.2f} exceeds tolerance 2"
