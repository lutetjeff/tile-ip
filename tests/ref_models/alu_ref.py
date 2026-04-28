"""Reference implementation of INT8 Element-wise ALU for verification.

This module provides a pure NumPy reference implementation of the Element-wise
ALU IP core. It supports ADD, MULTIPLY, and MASK operations on INT8 tensors.

Operations:
    ADD:      C = A + B (element-wise addition)
    MULTIPLY: C = A * B (element-wise multiplication, int32 accumulation, requantize)
    MASK:     C = A if B != 0 else 0 (conditional masking)

Input:
    A: NumPy int8 array - first operand
    B: NumPy int8 array - second operand
    op_code: Integer (0=ADD, 1=MULTIPLY, 2=MASK) - operation selector

Output:
    Result array as NumPy int8
"""

import numpy as np


# Operation codes
OP_ADD = 0
OP_MULTIPLY = 1
OP_MASK = 2


def alu_ref(A, B, op_code):
    """Compute element-wise ALU operation on INT8 operands.

    Args:
        A (np.ndarray): First operand, dtype=int8
        B (np.ndarray): Second operand, dtype=int8 (must have same shape as A)
        op_code (int): Operation selector:
                       0 = ADD:  C = A + B
                       1 = MULTIPLY: C = A * B (int32 accumulation, right-shift 8)
                       2 = MASK: C = A if B != 0 else 0

    Returns:
        np.ndarray: Result array with same shape as A, dtype=int8

    Raises:
        ValueError: If A and B have different shapes or dtypes are wrong
        ValueError: If op_code is not 0, 1, or 2

    Note:
        - ADD: Direct int8 addition with clipping
        - MULTIPLY: int32 accumulation, then right-shift by 8 for requantization
        - MASK: Conditional select based on B values
    """
    if A.dtype != np.int8 or B.dtype != np.int8:
        raise ValueError(f"Expected int8 arrays, got A={A.dtype}, B={B.dtype}")

    if A.shape != B.shape:
        raise ValueError(f"Incompatible shapes: A={A.shape}, B={B.shape}")

    if op_code == OP_ADD:
        # Direct addition, clip to int8 range
        result = np.add(A, B)
        result = np.clip(result, -128, 127).astype(np.int8)

    elif op_code == OP_MULTIPLY:
        # Multiply with int32 accumulation, then requantize
        A_int32 = A.astype(np.int32)
        B_int32 = B.astype(np.int32)
        result_int32 = np.multiply(A_int32, B_int32)

        # Right-shift by 8 for requantization
        result_requantized = np.right_shift(result_int32, 8)

        # Clip to int8 range
        result = np.clip(result_requantized, -128, 127).astype(np.int8)

    elif op_code == OP_MASK:
        # Return A if B != 0, else return 0
        result = np.where(B != 0, A, np.int8(0))

    else:
        raise ValueError(
            f"Invalid op_code: {op_code}. Must be 0 (ADD), 1 (MULTIPLY), or 2 (MASK)"
        )

    return result
