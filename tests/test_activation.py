"""Testbench for the LUT-based Activation core."""

import numpy as np
import pyrtl
import pytest

from ip_cores.activation import ActivationCore
from ip_cores.axi_stream_base import AXI4StreamLiteBase
from tests.ref_models.activation_ref import gelu_ref, relu_ref


def _pack_bytes(values: np.ndarray) -> int:
    result = 0
    for i, v in enumerate(values):
        result |= (int(v) & 0xFF) << (i * 8)
    return result


def _unpack_bytes(value: int, T_width: int) -> np.ndarray:
    return np.array(
        [(value >> (i * 8)) & 0xFF for i in range(T_width)],
        dtype=np.uint8,
    ).astype(np.int8)


def _create_wrapped_sim(core: ActivationCore):
    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        data_in = pyrtl.Input(bitwidth=core.data_in.bitwidth, name="wrapper_data_in")
        valid_in = pyrtl.Input(bitwidth=1, name="wrapper_valid_in")
        ready_in = pyrtl.Input(bitwidth=1, name="wrapper_ready_in")

        data_out = pyrtl.Output(
            bitwidth=core.data_out.bitwidth, name="wrapper_data_out"
        )
        valid_out = pyrtl.Output(bitwidth=1, name="wrapper_valid_out")
        ready_out = pyrtl.Output(bitwidth=1, name="wrapper_ready_out")

        core.data_in <<= data_in
        core.valid_in <<= valid_in
        core.ready_in <<= ready_in
        data_out <<= core.data_out
        valid_out <<= core.valid_out
        ready_out <<= core.ready_out

    sim = pyrtl.Simulation(tracer=None, block=core.block)
    return sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out


class TestActivationCore:
    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize("T_width", [1, 2, 4, 8, 16])
    @pytest.mark.parametrize("activation_type", ["gelu", "relu"])
    def test_random_continuous_stream(self, T_width: int, activation_type: str) -> None:
        core = ActivationCore(
            T_width=T_width, name="act", activation_type=activation_type
        )
        sim, data_in, valid_in, ready_in, data_out, _, _ = _create_wrapped_sim(core)

        inputs = [
            np.random.randint(-128, 128, size=T_width, dtype=np.int8) for _ in range(10)
        ]

        for beat in inputs:
            packed = _pack_bytes(beat)
            sim.step({data_in: packed, valid_in: 1, ready_in: 1})
            out_val = sim.inspect(data_out.name)
            out_bytes = _unpack_bytes(out_val, T_width)
            if activation_type == "gelu":
                expected = gelu_ref(beat)
                np.testing.assert_array_equal(out_bytes, expected)
            else:
                expected = relu_ref(beat)
                np.testing.assert_array_equal(out_bytes, expected)

    @pytest.mark.parametrize("T_width", [1, 2, 4, 8, 16])
    @pytest.mark.parametrize("activation_type", ["gelu", "relu"])
    def test_all_zeros(self, T_width: int, activation_type: str) -> None:
        core = ActivationCore(
            T_width=T_width, name="act", activation_type=activation_type
        )
        sim, data_in, valid_in, ready_in, data_out, _, _ = _create_wrapped_sim(core)
        beat = np.zeros(T_width, dtype=np.int8)
        packed = _pack_bytes(beat)
        sim.step({data_in: packed, valid_in: 1, ready_in: 1})
        out_bytes = _unpack_bytes(sim.inspect(data_out.name), T_width)
        if activation_type == "gelu":
            expected = gelu_ref(beat)
        else:
            expected = relu_ref(beat)
        np.testing.assert_array_equal(out_bytes, expected)

    @pytest.mark.parametrize("T_width", [1, 2, 4, 8, 16])
    @pytest.mark.parametrize("activation_type", ["gelu", "relu"])
    def test_all_positive_max(self, T_width: int, activation_type: str) -> None:
        core = ActivationCore(
            T_width=T_width, name="act", activation_type=activation_type
        )
        sim, data_in, valid_in, ready_in, data_out, _, _ = _create_wrapped_sim(core)
        beat = np.full(T_width, 127, dtype=np.int8)
        packed = _pack_bytes(beat)
        sim.step({data_in: packed, valid_in: 1, ready_in: 1})
        out_bytes = _unpack_bytes(sim.inspect(data_out.name), T_width)
        if activation_type == "gelu":
            expected = gelu_ref(beat)
        else:
            expected = relu_ref(beat)
        np.testing.assert_array_equal(out_bytes, expected)

    @pytest.mark.parametrize("T_width", [1, 2, 4, 8, 16])
    @pytest.mark.parametrize("activation_type", ["gelu", "relu"])
    def test_all_negative_max(self, T_width: int, activation_type: str) -> None:
        core = ActivationCore(
            T_width=T_width, name="act", activation_type=activation_type
        )
        sim, data_in, valid_in, ready_in, data_out, _, _ = _create_wrapped_sim(core)
        beat = np.full(T_width, -128, dtype=np.int8)
        packed = _pack_bytes(beat)
        sim.step({data_in: packed, valid_in: 1, ready_in: 1})
        out_bytes = _unpack_bytes(sim.inspect(data_out.name), T_width)
        if activation_type == "gelu":
            expected = gelu_ref(beat)
        else:
            expected = relu_ref(beat)
        np.testing.assert_array_equal(out_bytes, expected)

    def test_invalid_activation_type_raises(self) -> None:
        with pytest.raises(ValueError):
            ActivationCore(T_width=2, name="bad", activation_type="sigmoid")
