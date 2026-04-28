"""Reference implementation of Memory Router for verification.

This module provides a pure NumPy reference implementation of the Memory Router
& Embedding IP core. It simulates tensor reshaping, transposition, and token-to-vector
lookup via stride-based indexing.

Functions:
    mem_router_ref: Apply stride pattern to reshape/transpose tensor data

Input:
    mem_data: NumPy int8 array - data stored in memory (1D flattened or N-dimensional)
    stride_pattern: Tuple/List defining the memory access pattern

Output:
    Reshaped/rtransposed data as NumPy int8 array

Implementation:
    Uses stride manipulation to efficiently simulate address-stride patterns
    for transposition without actual data movement in memory.
"""

import numpy as np


def mem_router_ref(mem_data, stride_pattern):
    """Apply stride-based pattern to simulate memory routing/reshaping.

    This function simulates how the Memory Router IP generates complex address-stride
    patterns to read data in non-contiguous order (e.g., reading a matrix column-wise
    for transposition).

    Args:
        mem_data (np.ndarray): Input data, dtype=int8
                              Can be 1D (flattened tensor) or N-dimensional
        stride_pattern (tuple/list): Defines the access pattern
                                    Format depends on operation type:
                                    - For transposition: (rows, cols, transpose_flag)
                                      where transpose_flag=True does matrix transpose
                                    - For general stride: tuple of index tuples
                                      specifying output[i] = input[stride[i]]

    Returns:
        np.ndarray: Reorganized data with same dtype=int8

    Raises:
        ValueError: If stride_pattern is invalid or mem_data is not int8

    Note:
        The stride_pattern is interpreted differently based on the operation:
        - If len(stride_pattern) == 2 and both are ints: treat as (rows, cols)
          and reshape/transpose the flattened data
        - If stride_pattern is a sequence of index mappings: apply directly
    """
    if mem_data.dtype != np.int8:
        raise ValueError(f"Expected int8 array, got {mem_data.dtype}")

    data = mem_data.copy()

    # Interpret stride pattern
    if len(stride_pattern) == 2 and all(isinstance(s, int) for s in stride_pattern):
        # Simple case: (rows, cols) for matrix reshape/transpose
        rows, cols = stride_pattern
        total_elements = rows * cols

        # Flatten input if multidimensional
        if data.ndim > 1:
            data = data.flatten()
        elif data.size == 0:
            raise ValueError("Cannot reshape empty data")

        # Pad or truncate to expected size
        if data.size < total_elements:
            # Pad with zeros
            padded = np.zeros(total_elements, dtype=np.int8)
            padded[: data.size] = data.flatten()[:total_elements]
            data = padded
        else:
            data = data.flatten()[:total_elements]

        # Reshape to (rows, cols) then transpose
        # The stride pattern (rows, cols) implies we want data organized as rows×cols matrix
        # and then read in column-major order (transpose)
        matrix = data.reshape(rows, cols)
        # Transpose to simulate the K^T operation in attention
        result = matrix.T

    elif len(stride_pattern) == 3 and stride_pattern[2] == True:
        # (rows, cols, transpose_flag=True) - explicit transpose
        rows, cols, _ = stride_pattern
        total_elements = rows * cols

        if data.ndim > 1:
            data = data.flatten()
        elif data.size == 0:
            raise ValueError("Cannot reshape empty data")

        if data.size < total_elements:
            padded = np.zeros(total_elements, dtype=np.int8)
            padded[: data.size] = data.flatten()[:total_elements]
            data = padded
        else:
            data = data.flatten()[:total_elements]

        matrix = data.reshape(rows, cols)
        result = matrix.T

    elif len(stride_pattern) == 3 and stride_pattern[2] == False:
        # (rows, cols, transpose_flag=False) - no transpose
        rows, cols, _ = stride_pattern
        total_elements = rows * cols

        if data.ndim > 1:
            data = data.flatten()
        elif data.size == 0:
            raise ValueError("Cannot reshape empty data")

        if data.size < total_elements:
            padded = np.zeros(total_elements, dtype=np.int8)
            padded[: data.size] = data.flatten()[:total_elements]
            data = padded
        else:
            data = data.flatten()[:total_elements]

        result = data.reshape(rows, cols)

    else:
        # General stride pattern: list of index mappings
        # output[i] = input[stride[i]]
        output_size = (
            max(max(s) for s in stride_pattern if isinstance(s, (tuple, list))) + 1
        )

        if data.size < output_size:
            padded = np.zeros(output_size, dtype=np.int8)
            padded[: data.size] = data.flatten()[:output_size]
            data = padded
        else:
            data = data.flatten()[:output_size]

        result = np.array([data[s] for s in stride_pattern], dtype=np.int8)

    return result
