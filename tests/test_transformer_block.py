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

        alu2_valid_seen = False
        fifo1_ready_was_high = False
        norm1_ready_was_high = False

        for cycle in range(100):
            inputs = {
                drivers["fifo1_data_in"]: data_val,
                drivers["fifo1_valid_in"]: 1,
                drivers["fifo1_last_in"]: 1,
                drivers["norm1_data_in"]: data_val,
                drivers["norm1_valid_in"]: 1,
                drivers["norm1_last_in"]: 1,
                drivers["alu2_ready_in"]: 1,
                manual_inputs["norm2_last_in"]: 1,
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

            if sim.inspect(drivers["alu2_valid_out"]) == 1:
                alu2_valid_seen = True

            if sim.inspect(drivers["fifo1_ready_out"]) == 1:
                fifo1_ready_was_high = True
            if sim.inspect(drivers["norm1_ready_out"]) == 1:
                norm1_ready_was_high = True

        assert alu2_valid_seen, "alu2 valid_out was never asserted"
        assert fifo1_ready_was_high, "fifo1 ready_out permanently stuck low"
        assert norm1_ready_was_high, "norm1 ready_out permanently stuck low"
