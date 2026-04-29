"""PyRTL simulation test for the transformer block assembly."""

from __future__ import annotations

import numpy as np
import pyrtl
import pytest

from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ref_models.alu_ref import OP_ADD
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

        fifo1_ready_was_high = False
        norm1_ready_was_high = False
        tgemm1_valid_seen = False
        softmax_valid_seen = False
        tgemm2_valid_seen = False
        alu1_valid_seen = False

        norm1_beat = 0
        fifo1_sent = 0
        num_beats = seq_len // T
        max_cycles = 800
        for cycle in range(max_cycles):
            last_in_beat = 1 if (norm1_beat + 1) % num_beats == 0 else 0

            norm1_ready = sim.inspect(drivers["norm1_ready_out"])
            fifo1_ready = sim.inspect(drivers["fifo1_ready_out"])

            if norm1_ready == 1:
                norm1_valid = 1
                norm1_last = last_in_beat
                norm1_beat += 1
            else:
                norm1_valid = 0
                norm1_last = 0

            if fifo1_ready == 1:
                fifo1_valid = 1
                fifo1_last = 1
                fifo1_sent += 1
            else:
                fifo1_valid = 0
                fifo1_last = 0

            inputs = {
                drivers["fifo1_data_in"]: data_val,
                drivers["fifo1_valid_in"]: fifo1_valid,
                drivers["fifo1_last_in"]: fifo1_last,
                drivers["norm1_data_in"]: data_val,
                drivers["norm1_valid_in"]: norm1_valid,
                drivers["norm1_last_in"]: norm1_last,
                drivers["alu2_ready_in"]: 1,
                manual_inputs["norm2_last_in"]: last_in_beat if norm1_valid else 0,
                manual_inputs["tgemm4_last_in"]: 1,
                manual_inputs["tgemm1_weight_in"]: weight_val,
                manual_inputs["tgemm1_weight_valid"]: 1,
                manual_inputs["tgemm2_weight_in"]: weight_val,
                manual_inputs["tgemm2_weight_valid"]: 1,
                manual_inputs["tgemm3_weight_in"]: weight_val,
                manual_inputs["tgemm3_weight_valid"]: 1,
                manual_inputs["tgemm4_weight_in"]: weight_val,
                manual_inputs["tgemm4_weight_valid"]: 1,
                manual_inputs["alu1_op_code"]: OP_ADD,
                manual_inputs["alu2_op_code"]: OP_ADD,
            }

            sim.step(inputs)

            if sim.inspect(drivers["fifo1_ready_out"]) == 1:
                fifo1_ready_was_high = True
            if sim.inspect(drivers["norm1_ready_out"]) == 1:
                norm1_ready_was_high = True

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

        assert fifo1_ready_was_high, "fifo1 ready_out permanently stuck low"
        assert norm1_ready_was_high, "norm1 ready_out permanently stuck low"
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

        num_beats = seq_len // T
        captured_outputs = []

        for cycle in range(max_cycles):
            beat = cycle % num_beats
            is_last = 1 if beat == num_beats - 1 else 0

            inputs = {
                drivers["fifo1_data_in"]: data_val,
                drivers["fifo1_valid_in"]: 1,
                drivers["fifo1_last_in"]: is_last,
                drivers["norm1_data_in"]: data_val,
                drivers["norm1_valid_in"]: 1,
                drivers["norm1_last_in"]: is_last,
                drivers["alu2_ready_in"]: 1,
                manual_inputs["norm2_last_in"]: is_last,
                manual_inputs["tgemm4_last_in"]: is_last,
                manual_inputs["tgemm1_weight_in"]: weight_val,
                manual_inputs["tgemm1_weight_valid"]: 1,
                manual_inputs["tgemm2_weight_in"]: weight_val,
                manual_inputs["tgemm2_weight_valid"]: 1,
                manual_inputs["tgemm3_weight_in"]: weight_val,
                manual_inputs["tgemm3_weight_valid"]: 1,
                manual_inputs["tgemm4_weight_in"]: weight_val,
                manual_inputs["tgemm4_weight_valid"]: 1,
                manual_inputs["alu1_op_code"]: OP_ADD,
                manual_inputs["alu2_op_code"]: OP_ADD,
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
