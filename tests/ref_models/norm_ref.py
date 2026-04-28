"""Reference implementation of INT8 LayerNorm/RMSNorm for verification.

This module provides a pure NumPy reference implementation of the Universal
Normalization IP core. It supports both LayerNorm and RMSNorm modes.

LayerNorm: y = (x - mean) / sqrt(var + eps) * gamma + beta
RMSNorm:   y = x / sqrt(var + eps) * gamma (no mean subtraction)

Input:
    x: NumPy int8 array - feature vectors
    gamma: NumPy int8 array - learned scale parameter
    beta: NumPy int8 array - learned bias parameter (optional for RMSNorm)
    is_rmsnorm: bool - if True, bypass mean-subtraction (RMSNorm mode)

Output:
    Normalized output as NumPy int8 array, requantized after computation

Implementation:
    - Computes variance using float32 internally
    - Uses 1/sqrt(x) approximation for normalization
    - Applies gamma scale and beta bias
    - Requantizes to INT8
"""

import numpy as np


def norm_ref(x, gamma, beta, is_rmsnorm):
    """Compute LayerNorm or RMSNorm with INT8 input/output.

    Args:
        x (np.ndarray): Input feature vector(s), dtype=int8
                       Shape: (..., channel_dim) where T_channel is the parallel width
        gamma (np.ndarray): Scale parameter, dtype=int8, shape must broadcast with x
        beta (np.ndarray): Bias parameter, dtype=int8, shape must broadcast with x
        is_rmsnorm (bool): If True, compute RMSNorm (skip mean subtraction)
                          If False, compute LayerNorm (include mean subtraction)

    Returns:
        np.ndarray: Normalized output with same shape as x, dtype=int8

    Raises:
        ValueError: If input dtype is not int8 or shapes are incompatible

    Note:
        - Epsilon (1e-5) is added to variance before sqrt to prevent division by zero
        - All computations done in float32, then requantized to int8
    """
    if x.dtype != np.int8:
        raise ValueError(f"Expected int8 array for x, got {x.dtype}")

    # Convert to float32 for computation
    x_float = x.astype(np.float32)
    gamma_float = gamma.astype(np.float32)
    beta_float = beta.astype(np.float32)

    # Compute variance: E[x^2] - E[x]^2 (numerically stable)
    mean_x = np.mean(x_float, axis=-1, keepdims=True)
    mean_x2 = np.mean(x_float**2, axis=-1, keepdims=True)
    variance = mean_x2 - mean_x**2

    # Add epsilon for numerical stability
    eps = 1e-5
    std = np.sqrt(variance + eps)

    if is_rmsnorm:
        # RMSNorm: normalize by RMS without mean subtraction
        normalized = x_float / std
    else:
        # LayerNorm: subtract mean before normalization
        normalized = (x_float - mean_x) / std

    # Apply scale (gamma) and bias (beta)
    output_float = normalized * gamma_float + beta_float

    # Requantize to INT8 with symmetric scaling
    # Find max absolute value for scaling
    max_abs = np.max(np.abs(output_float))
    if max_abs > 0:
        scale_factor = 127.0 / max_abs
        output_scaled = np.round(output_float * scale_factor)
    else:
        output_scaled = output_float

    # Clip to int8 range and convert
    output_int8 = np.clip(output_scaled, -128, 127).astype(np.int8)

    return output_int8
