"""Reference implementation of INT8 activation functions for verification.

This module provides a pure NumPy reference implementation of the LUT-based
Activation IP core. It supports GELU and ReLU activations operating on INT8 inputs.

GELU: Gaussian Error Linear Unit - approximations of gelu(x) = x * Phi(x)
      where Phi is the standard Gaussian CDF. Uses the approximation:
      gelu(x) ≈ 0.5 * x * (1 + tanh(sqrt(2/pi) * (x + 0.044715 * x^3)))

ReLU: Rectified Linear Unit - relu(x) = max(0, x)

Input:
    x: NumPy int8 array - input activations

Output:
    Activated output as NumPy int8 array, requantized after computation
"""

import numpy as np


def gelu_ref(x):
    """Compute GELU activation on INT8 input.

    Args:
        x (np.ndarray): Input array, dtype=int8

    Returns:
        np.ndarray: GELU-activated output, dtype=int8

    Raises:
        ValueError: If input dtype is not int8

    Note:
        Uses the approximation: 0.5 * x * (1 + tanh(sqrt(2/pi) * (x + 0.044715 * x^3)))
        This is the 'tanh' approximation commonly used in transformers.
        Computation is done in float32, then requantized to INT8.
    """
    if x.dtype != np.int8:
        raise ValueError(f"Expected int8 array, got {x.dtype}")

    # Convert to float32
    x_float = x.astype(np.float32)

    # GELU using tanh approximation
    # sqrt(2/pi) ≈ 0.7978845608
    sqrt_2_over_pi = 0.7978845608
    # 0.044715 constant for the cubic term
    c = 0.044715

    inner = sqrt_2_over_pi * (x_float + c * x_float**3)
    gelu_float = 0.5 * x_float * (1 + np.tanh(inner))

    # Requantize to INT8
    max_abs = np.max(np.abs(gelu_float))
    if max_abs > 0:
        scale_factor = 127.0 / max_abs
        gelu_scaled = np.round(gelu_float * scale_factor)
    else:
        gelu_scaled = gelu_float

    gelu_int8 = np.clip(gelu_scaled, -128, 127).astype(np.int8)

    return gelu_int8


def relu_ref(x):
    """Compute ReLU activation on INT8 input.

    Args:
        x (np.ndarray): Input array, dtype=int8

    Returns:
        np.ndarray: ReLU-activated output, dtype=int8

    Raises:
        ValueError: If input dtype is not int8

    Note:
        Simple ReLU: relu(x) = max(0, x)
        Negative values become 0, non-negative values unchanged.
    """
    if x.dtype != np.int8:
        raise ValueError(f"Expected int8 array, got {x.dtype}")

    # ReLU: clip negative values to 0
    x_clipped = np.maximum(x, 0)

    return x_clipped.astype(np.int8)
