"""Reference implementation of INT8 Softmax for verification.

This module provides a pure NumPy reference implementation of the LUT-based
Softmax IP core. It computes Softmax(x_i) = e^x_i / Σ e^x_j with max-subtraction
for numerical stability before exponentiation.

Input:
    x: NumPy int8 array (1D or 2D) representing attention scores

Output:
    Softmax output as NumPy int8 array, requantized after computation

Implementation:
    - Max-subtraction before exponentiation for numerical stability
    - Uses float32 internally for computation
    - Final result requantized to INT8
"""

import numpy as np


def softmax_ref(x):
    """Compute softmax on INT8 inputs with max-subtraction for stability.

    Args:
        x (np.ndarray): Input array of shape (..., seq_len), dtype=int8
                      Typically a 1D array of attention scores or 2D (batch, seq)

    Returns:
        np.ndarray: Softmax output with same shape as input, dtype=int8

    Raises:
        ValueError: If input dtype is not int8

    Note:
        Uses max-subtraction trick: e^(x_i-max) / Σ e^(x_j-max) to prevent
        overflow when computing e^x for large x values.
    """
    if x.dtype != np.int8:
        raise ValueError(f"Expected int8 array, got {x.dtype}")

    # Convert to float32 for computation
    x_float = x.astype(np.float32)

    # Max-subtraction for numerical stability
    x_minus_max = x_float - np.max(x_float, axis=-1, keepdims=True)

    # Exponentiation
    exp_x = np.exp(x_minus_max)

    # Sum of exponentials
    sum_exp = np.sum(exp_x, axis=-1, keepdims=True)

    # Softmax probabilities
    softmax_probs = exp_x / sum_exp

    # Requantize to INT8 (scale by 127 since softmax outputs are in [0, 1])
    # We use a simple scaling: output = round(prob * 127)
    softmax_scaled = np.round(softmax_probs * 127)

    # Clip to int8 range
    softmax_int8 = np.clip(softmax_scaled, -128, 127).astype(np.int8)

    return softmax_int8
