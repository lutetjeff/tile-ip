import cocotb
import numpy as np
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge

from tests.test_norm import _ref_unscaled


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
async def test_norm(dut):
    T_channel = 2
    T_width = T_channel

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
        np.zeros(T_channel, dtype=np.int8),
        np.random.randint(-10, 10, size=T_channel, dtype=np.int8),
        np.full(T_channel, 50, dtype=np.int8),
        np.array([127, -128], dtype=np.int8),
    ]

    inputs = []
    outputs = []

    for x in test_cases:
        inputs.append(x)

        dut.data_in.value = _pack_bytes(x)
        dut.valid_in.value = 1
        dut.ready_in.value = 1

        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)

        # Norm is combinational: valid_out = valid_in, ready_out = ready_in
        assert dut.norm_valid_out.value == 1, "norm_valid_out should be high"
        assert dut.norm_ready_out.value == 1, "norm_ready_out should be high"
        outputs.append(int(dut.norm_data_out.value))

    for i in range(len(test_cases)):
        out_bytes = _unpack_bytes(outputs[i], T_width)
        expected = _ref_unscaled(inputs[i], is_rmsnorm=False)
        np.testing.assert_allclose(out_bytes, expected, atol=3)