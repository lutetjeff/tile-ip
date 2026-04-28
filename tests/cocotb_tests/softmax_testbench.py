import cocotb
import numpy as np
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge

from tests.ref_models.softmax_ref import softmax_ref


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
async def test_softmax(dut):
    T_seq = 2  # Softmax processes 2 int8 values at a time

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
        np.zeros(T_seq, dtype=np.int8),
        np.full(T_seq, 127, dtype=np.int8),
        np.full(T_seq, -128, dtype=np.int8),
        np.array([127, -128], dtype=np.int8),
        np.array([50, -20], dtype=np.int8),
        np.array([-10, 100], dtype=np.int8),
    ]

    inputs = []
    outputs = []

    for x in test_cases:
        inputs.append(x)

        dut.data_in.value = _pack_bytes(x)
        dut.valid_in.value = 1
        dut.ready_in.value = 1

        await RisingEdge(dut.clk)

        assert dut.softmax_valid_out.value == 1, "softmax_valid_out should be high"
        assert dut.softmax_ready_out.value == 1, "softmax_ready_out should be high"

        outputs.append(int(dut.softmax_data_out.value))

    for i in range(len(test_cases)):
        out_bytes = _unpack_bytes(outputs[i], T_seq)
        expected = softmax_ref(inputs[i])
        np.testing.assert_allclose(out_bytes, expected, atol=1)