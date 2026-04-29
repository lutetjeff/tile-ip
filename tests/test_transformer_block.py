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


class TestTransformerBlock:
    def setup_method(self):
        AXI4StreamLiteBase.reset()

    def test_transformer_block_no_deadlock(self):
        built_block, drivers, manual_inputs = build_transformer_block()
        _disable_memory_sync_check(built_block)

        sim = pyrtl.Simulation(tracer=None, block=built_block)

        data = [1, 2]
        weight = [1, 2, 3, 4]
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
        max_cycles = 200
        for cycle in range(max_cycles):
            last_in_beat = 1 if norm1_beat % 2 == 1 else 0

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
