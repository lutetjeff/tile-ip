import cocotb
import numpy as np
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge

from tests.ref_models.gemm_ref import gemm_ref


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


def _pack_matrix(mat: np.ndarray) -> int:
    if mat.shape != (2, 2):
        raise ValueError(f"Expected 2x2 matrix, got shape {mat.shape}")
    # data_in[7:0]=A[0,0], [15:8]=A[0,1], [23:16]=A[1,0], [31:24]=A[1,1]
    values = np.array([mat[0, 0], mat[0, 1], mat[1, 0], mat[1, 1]], dtype=np.int8)
    return _pack_bytes(values)


def _unpack_matrix(value: int) -> np.ndarray:
    bytes_vals = _unpack_bytes(value, 4)
    return np.array([[bytes_vals[0], bytes_vals[1]], [bytes_vals[2], bytes_vals[3]]], dtype=np.int8)


@cocotb.test()
async def test_gemm(dut):
    # GEMM parameters: T_M=T_K=T_N=2
    # data_in = 32 bits (4 int8 values for A matrix)
    # weight_in = 32 bits (4 int8 values for B matrix)

    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset for 5 cycles
    dut.rst.value = 1
    dut.valid_in.value = 0
    dut.ready_in.value = 0
    dut.weight_valid_in.value = 0
    dut.data_in.value = 0
    dut.weight_in.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    # Test cases: (A matrix, B matrix)
    test_cases = [
        (np.zeros((2, 2), dtype=np.int8), np.zeros((2, 2), dtype=np.int8)),
        (np.full((2, 2), 127, dtype=np.int8), np.full((2, 2), 127, dtype=np.int8)),
        (np.full((2, 2), -128, dtype=np.int8), np.full((2, 2), -128, dtype=np.int8)),
        (np.full((2, 2), 127, dtype=np.int8), np.full((2, 2), -128, dtype=np.int8)),
        (
            np.random.randint(-128, 128, size=(2, 2), dtype=np.int8),
            np.random.randint(-128, 128, size=(2, 2), dtype=np.int8),
        ),
        (
            np.random.randint(-128, 128, size=(2, 2), dtype=np.int8),
            np.random.randint(-128, 128, size=(2, 2), dtype=np.int8),
        ),
    ]

    inputs_a = []
    inputs_b = []
    outputs = []

    for A, B in test_cases:
        inputs_a.append(A)
        inputs_b.append(B)

        # Drive inputs
        dut.data_in.value = _pack_matrix(A)
        dut.weight_in.value = _pack_matrix(B)
        dut.valid_in.value = 1
        dut.weight_valid_in.value = 1
        dut.ready_in.value = 1

        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)

        # Capture output when valid_out is high
        assert dut.gemm_valid_out.value == 1, "gemm_valid_out should be high"
        outputs.append(int(dut.gemm_data_out.value))

    # Compare outputs against reference model
    for i in range(len(test_cases)):
        out_matrix = _unpack_matrix(outputs[i])
        expected = gemm_ref(inputs_a[i], inputs_b[i])
        np.testing.assert_array_equal(out_matrix, expected)