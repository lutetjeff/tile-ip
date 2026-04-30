import os

import cocotb
import numpy as np
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge

from tests.ref_models.activation_ref import relu_ref


def _pack_bytes(values: np.ndarray) -> int:
    result = 0
    for i, v in enumerate(values):
        result |= (int(v) & 0xFF) << (i * 8)
    return result


def _unpack_bytes(value: int, T_width: int) -> np.ndarray:
    return np.array(
        [((value >> (i * 8)) & 0xFF) for i in range(T_width)],
        dtype=np.uint8,
    ).astype(np.int8)


@cocotb.test()
async def test_activation(dut):
    T_width = int(os.environ.get("COCOTB_T_WIDTH", "2"))

    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    dut.valid_in.value = 0
    dut.ready_in.value = 0
    dut.data_in.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    test_cases = [
        np.zeros(T_width, dtype=np.int8),
        np.full(T_width, 127, dtype=np.int8),
        np.full(T_width, -128, dtype=np.int8),
        np.random.randint(-128, 128, size=T_width, dtype=np.int8),
        np.random.randint(-128, 128, size=T_width, dtype=np.int8),
    ]

    inputs = []
    outputs = []

    for data in test_cases:
        inputs.append(data)

        dut.data_in.value = _pack_bytes(data)
        dut.valid_in.value = 1
        dut.ready_in.value = 1

        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)

        # Capture output when valid_out && ready_in
        assert dut.activation_valid_out.value == 1, "activation_valid_out should be high"
        assert dut.activation_ready_out.value == 1, "activation_ready_out should be high"
        outputs.append(int(dut.activation_data_out.value))

    for i in range(len(test_cases)):
        out_bytes = _unpack_bytes(outputs[i], T_width)
        expected = relu_ref(inputs[i])
        np.testing.assert_array_equal(out_bytes, expected)
