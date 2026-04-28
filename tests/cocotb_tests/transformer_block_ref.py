import numpy as np

from tests.ref_models.norm_ref import norm_ref
from tests.ref_models.gemm_ref import gemm_ref
from tests.ref_models.softmax_ref import softmax_ref
from tests.ref_models.alu_ref import alu_ref, OP_ADD
from tests.ref_models.activation_ref import relu_ref


def transformer_block_ref(input_data, weights):
    W1, W2, W3, W4 = weights

    x = input_data.astype(np.int8)
    gamma = np.array([1, 1, 1, 1], dtype=np.int8)
    beta = np.array([0, 0, 0, 0], dtype=np.int8)

    x1 = norm_ref(x, gamma, beta, is_rmsnorm=False)

    x1_beat0 = x1[0:2].reshape(1, 2)
    x1_beat1 = x1[2:4].reshape(1, 2)
    gemm1_out = gemm_ref(x1_beat0, W1) + gemm_ref(x1_beat1, W1)
    gemm1_out = np.clip(np.right_shift(gemm1_out.astype(np.int32), 8), -128, 127).astype(np.int8)

    softmax_in = gemm1_out.flatten()
    softmax_out = softmax_ref(softmax_in)

    gemm2_out = gemm_ref(softmax_out.reshape(1, 2), W2)

    residual1 = alu_ref(gemm2_out, x[0:2].reshape(1, 2), OP_ADD)

    x2 = norm_ref(residual1.flatten(), gamma[0:2], beta[0:2], is_rmsnorm=False)

    gemm3_out = gemm_ref(x2.reshape(1, 2), W3)

    act_out = relu_ref(gemm3_out.flatten())

    gemm4_out = gemm_ref(act_out.reshape(1, 2), W4)

    residual2 = alu_ref(gemm4_out, x[0:2].reshape(1, 2), OP_ADD)

    return residual2.flatten()
