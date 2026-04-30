import os

import cocotb
import numpy as np
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge

from tests.cocotb_tests.transformer_block_ref import transformer_block_ref


def _pack_bytes(values):
    result = 0
    for i, v in enumerate(values):
        result |= (int(v) & 0xFF) << (i * 8)
    return result


def _unpack_bytes(value, n):
    return np.array([((value >> (i * 8)) & 0xFF) for i in range(n)], dtype=np.uint8).astype(np.int8)


@cocotb.test()
async def test_transformer_block(dut):
    seq_len = int(os.environ.get("COCOTB_SEQ_LEN", "4"))
    emb_dim = int(os.environ.get("COCOTB_EMB_DIM", "4"))
    T = int(os.environ.get("COCOTB_T", "2"))

    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    num_beats = seq_len // T
    input_data = np.array([1, 2] * (seq_len // 2), dtype=np.int8)
    if len(input_data) < seq_len:
        input_data = np.array([1] * seq_len, dtype=np.int8)

    W1 = np.eye(T, dtype=np.int8)
    W2 = np.eye(T, dtype=np.int8)
    W3 = np.eye(T, dtype=np.int8)
    W4 = np.eye(T, dtype=np.int8)

    data_vals = [_pack_bytes(input_data[i * T:(i + 1) * T]) for i in range(num_beats)]
    w1_val = _pack_bytes(W1.flatten())
    w2_val = _pack_bytes(W2.flatten())
    w3_val = _pack_bytes(W3.flatten())
    w4_val = _pack_bytes(W4.flatten())

    dut.rst.value = 1
    dut.stitcher_fifo1_valid_in.value = 0
    dut.stitcher_norm1_valid_in.value = 0
    dut.stitcher_alu2_ready_in.value = 0
    dut.drv_tgemm1_weight_valid.value = 0
    dut.drv_tgemm2_weight_valid.value = 0
    dut.drv_tgemm3_weight_valid.value = 0
    dut.drv_tgemm4_weight_valid.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    dut.drv_tgemm1_weight_in.value = w1_val
    dut.drv_tgemm1_weight_valid.value = 1
    dut.drv_tgemm2_weight_in.value = w2_val
    dut.drv_tgemm2_weight_valid.value = 1
    dut.drv_tgemm3_weight_in.value = w3_val
    dut.drv_tgemm3_weight_valid.value = 1
    dut.drv_tgemm4_weight_in.value = w4_val
    dut.drv_tgemm4_weight_valid.value = 1
    dut.drv_alu1_op_code.value = 0
    dut.drv_alu2_op_code.value = 0
    dut.stitcher_alu2_ready_in.value = 1

    hw_output = None
    output_cycle = None
    max_cycles = 400 if T == 1 else 200

    for c in range(max_cycles):
        beat = c % num_beats
        is_last = 1 if beat == num_beats - 1 else 0
        data = data_vals[beat]

        dut.stitcher_fifo1_data_in.value = data
        dut.stitcher_fifo1_valid_in.value = 1
        dut.stitcher_fifo1_last_in.value = is_last
        dut.stitcher_norm1_data_in.value = data
        dut.stitcher_norm1_valid_in.value = 1
        dut.stitcher_norm1_last_in.value = is_last
        dut.drv_norm2_last_in.value = is_last
        dut.drv_tgemm4_last_in.value = is_last

        await RisingEdge(dut.clk)

        if int(dut.stitcher_alu2_valid_out.value) == 1 and hw_output is None:
            hw_output = _unpack_bytes(int(dut.stitcher_alu2_data_out.value), T)
            output_cycle = c
            dut._log.info(f"First output at cycle {c}: {hw_output}")

    assert hw_output is not None, f"No alu2 output captured within {max_cycles} cycles"

    if T == 2 and seq_len == 4 and emb_dim == 4:
        ref_output = transformer_block_ref(input_data, (W1, W2, W3, W4))
        dut._log.info(f"Reference output: {ref_output}")
        dut._log.info(f"HW output: {hw_output}")
        dut._log.info(f"Total cycles to first output: {output_cycle}")
        np.testing.assert_allclose(hw_output, ref_output, atol=2)
    else:
        dut._log.info(f"Smoke test passed: output={hw_output} at cycle {output_cycle}")
