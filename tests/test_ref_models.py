"""Sanity tests for reference models.

Runs each reference model on small random inputs to verify they execute
without error. Does not verify numerical accuracy - that is done by testbenches.
"""

import numpy as np

from ref_models.gemm_ref import gemm_ref
from ref_models.softmax_ref import softmax_ref
from ref_models.norm_ref import norm_ref
from ref_models.activation_ref import gelu_ref, relu_ref
from ref_models.alu_ref import alu_ref, OP_ADD, OP_MULTIPLY, OP_MASK
from ref_models.mem_router_ref import mem_router_ref


def test_gemm_basic():
    A = np.random.randint(-50, 50, size=(4, 8), dtype=np.int8)
    B = np.random.randint(-50, 50, size=(8, 4), dtype=np.int8)
    C = gemm_ref(A, B)
    assert C.dtype == np.int8
    assert C.shape == (4, 4)


def test_gemm_larger():
    A = np.random.randint(-100, 100, size=(16, 32), dtype=np.int8)
    B = np.random.randint(-100, 100, size=(32, 16), dtype=np.int8)
    C = gemm_ref(A, B)
    assert C.dtype == np.int8
    assert C.shape == (16, 16)


def test_softmax_1d():
    x = np.random.randint(-128, 127, size=(16,), dtype=np.int8)
    y = softmax_ref(x)
    assert y.dtype == np.int8
    assert y.shape == x.shape


def test_softmax_2d():
    x = np.random.randint(-128, 127, size=(4, 8), dtype=np.int8)
    y = softmax_ref(x)
    assert y.dtype == np.int8
    assert y.shape == x.shape


def test_layernorm():
    x = np.random.randint(-50, 50, size=(16,), dtype=np.int8)
    gamma = np.ones(16, dtype=np.int8)
    beta = np.zeros(16, dtype=np.int8)
    y = norm_ref(x, gamma, beta, is_rmsnorm=False)
    assert y.dtype == np.int8
    assert y.shape == x.shape


def test_rmsnorm():
    x = np.random.randint(-50, 50, size=(16,), dtype=np.int8)
    gamma = np.ones(16, dtype=np.int8)
    beta = np.zeros(16, dtype=np.int8)
    y = norm_ref(x, gamma, beta, is_rmsnorm=True)
    assert y.dtype == np.int8
    assert y.shape == x.shape


def test_gelu():
    x = np.random.randint(-50, 50, size=(16,), dtype=np.int8)
    y = gelu_ref(x)
    assert y.dtype == np.int8
    assert y.shape == x.shape


def test_relu():
    x = np.random.randint(-50, 50, size=(16,), dtype=np.int8)
    y = relu_ref(x)
    assert y.dtype == np.int8
    assert y.shape == x.shape
    assert np.all(y >= 0)


def test_add():
    A = np.random.randint(-50, 50, size=(16,), dtype=np.int8)
    B = np.random.randint(-50, 50, size=(16,), dtype=np.int8)
    C = alu_ref(A, B, OP_ADD)
    assert C.dtype == np.int8
    assert C.shape == A.shape


def test_multiply():
    A = np.random.randint(-10, 10, size=(16,), dtype=np.int8)
    B = np.random.randint(-10, 10, size=(16,), dtype=np.int8)
    C = alu_ref(A, B, OP_MULTIPLY)
    assert C.dtype == np.int8
    assert C.shape == A.shape


def test_mask():
    A = np.random.randint(-50, 50, size=(16,), dtype=np.int8)
    B = np.random.randint(0, 2, size=(16,), dtype=np.int8)
    C = alu_ref(A, B, OP_MASK)
    assert C.dtype == np.int8
    assert C.shape == A.shape
    assert np.all((C == A) | (C == 0))


def test_transpose_2d():
    data = np.random.randint(-50, 50, size=(12,), dtype=np.int8)
    result = mem_router_ref(data, (3, 4))
    assert result.dtype == np.int8
    assert result.shape == (4, 3)


def test_reshape_no_transpose():
    data = np.random.randint(-50, 50, size=(12,), dtype=np.int8)
    result = mem_router_ref(data, (3, 4, False))
    assert result.dtype == np.int8
    assert result.shape == (3, 4)


def test_reshape_with_transpose():
    data = np.random.randint(-50, 50, size=(12,), dtype=np.int8)
    result = mem_router_ref(data, (3, 4, True))
    assert result.dtype == np.int8
    assert result.shape == (4, 3)


if __name__ == "__main__":
    tests = [
        test_gemm_basic,
        test_gemm_larger,
        test_softmax_1d,
        test_softmax_2d,
        test_layernorm,
        test_rmsnorm,
        test_gelu,
        test_relu,
        test_add,
        test_multiply,
        test_mask,
        test_transpose_2d,
        test_reshape_no_transpose,
        test_reshape_with_transpose,
    ]
    passed = 0
    failed = 0
    for test in tests:
        try:
            test()
            print(f"PASS: {test.__name__}")
            passed += 1
        except Exception as e:
            print(f"FAIL: {test.__name__}: {e}")
            failed += 1
    print(f"\n{passed} passed, {failed} failed")
