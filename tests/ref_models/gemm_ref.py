"""Reference implementation of INT8 GEMM (Matrix Multiplication) for verification.

This module provides a pure NumPy reference implementation of the parameterized
INT8 GEMM IP core. It computes C = A × B with 32-bit accumulation and
requantization to INT8 via right-shift by 8.

Input:
    A: NumPy int8 array of shape (M, K) - activation matrix
    B: NumPy int8 array of shape (K, N) - weight matrix

Output:
    C: NumPy int8 array of shape (M, N) - result matrix after requantization

Implementation:
    - Accumulation is performed in int32 to prevent overflow
    - Requantization uses right-shift by 8 (equivalent to division by 256)
"""

import numpy as np


def gemm_ref(A, B):
    """Compute INT8 matrix multiplication with 32-bit accumulation.

    Args:
        A (np.ndarray): Input activation matrix of shape (M, K), dtype=int8
        B (np.ndarray): Input weight matrix of shape (K, N), dtype=int8

    Returns:
        np.ndarray: Output matrix of shape (M, N), dtype=int8

    Raises:
        ValueError: If matrix dimensions are incompatible or dtypes are wrong
    """
    if A.dtype != np.int8 or B.dtype != np.int8:
        raise ValueError(f"Expected int8 arrays, got A={A.dtype}, B={B.dtype}")

    if A.shape[1] != B.shape[0]:
        raise ValueError(f"Incompatible shapes: A={A.shape}, B={B.shape}")

    # Convert to int32 for accumulation
    A_int32 = A.astype(np.int32)
    B_int32 = B.astype(np.int32)

    # Matrix multiply with int32 accumulation
    C_int32 = np.matmul(A_int32, B_int32)

    # Requantization: right-shift by 8 (simulates INT8 output scaling)
    # Using numpy right shift on int32 array
    C_requantized = np.right_shift(C_int32, 8)

    # Clip to int8 range and convert
    C_requantized = np.clip(C_requantized, -128, 127)

    return C_requantized.astype(np.int8)
