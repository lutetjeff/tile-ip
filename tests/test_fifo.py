import numpy as np
import pyrtl
import pytest

from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ip_cores.fifo import FIFOCore
from ref_models.fifo_ref import fifo_ref


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


def _create_wrapped_sim(core: FIFOCore):
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


class TestFIFOCore:
    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize("T_width", [1, 2, 4, 8, 16])
    @pytest.mark.parametrize("depth", [2, 4])
    def test_continuous_stream(self, T_width: int, depth: int) -> None:
        core = FIFOCore(T_width=T_width, depth=depth, name="fifo")
        sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out = (
            _create_wrapped_sim(core)
        )

        inputs = [
            np.random.randint(-128, 128, size=T_width, dtype=np.int8)
            for _ in range(10)
        ]
        packed_inputs = [_pack_bytes(val) for val in inputs]
        ready_pattern = [1] * 10

        trace = []
        for val in inputs:
            sim.step(
                {
                    data_in: _pack_bytes(val),
                    valid_in: 1,
                    ready_in: 1,
                }
            )
            trace.append(
                (
                    sim.inspect(data_out.name),
                    sim.inspect(valid_out.name),
                    sim.inspect(ready_out.name),
                )
            )

        expected = fifo_ref(packed_inputs, ready_pattern, depth)

        for i in range(10):
            assert trace[i][1] == expected[i][1], f"cycle {i} valid_out mismatch"
            assert trace[i][2] == expected[i][2], f"cycle {i} ready_out mismatch"
            if expected[i][1]:
                out_bytes = _unpack_bytes(trace[i][0], T_width)
                exp_bytes = _unpack_bytes(expected[i][0], T_width)
                np.testing.assert_array_equal(out_bytes, exp_bytes)

    @pytest.mark.parametrize("T_width", [1, 2, 4, 8, 16])
    @pytest.mark.parametrize("depth", [2, 4])
    def test_backpressure(self, T_width: int, depth: int) -> None:
        core = FIFOCore(T_width=T_width, depth=depth, name="fifo")
        sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out = (
            _create_wrapped_sim(core)
        )

        inputs = [
            np.random.randint(-128, 128, size=T_width, dtype=np.int8)
            for _ in range(10)
        ]
        packed_inputs = [_pack_bytes(val) for val in inputs]
        ready_pattern = [1 if i % 2 == 0 else 0 for i in range(10)]

        trace = []
        for i, val in enumerate(inputs):
            sim.step(
                {
                    data_in: _pack_bytes(val),
                    valid_in: 1,
                    ready_in: ready_pattern[i],
                }
            )
            trace.append(
                (
                    sim.inspect(data_out.name),
                    sim.inspect(valid_out.name),
                    sim.inspect(ready_out.name),
                )
            )

        expected = fifo_ref(packed_inputs, ready_pattern, depth)

        for i in range(10):
            assert trace[i][1] == expected[i][1], f"cycle {i} valid_out mismatch"
            assert trace[i][2] == expected[i][2], f"cycle {i} ready_out mismatch"
            if expected[i][1]:
                out_bytes = _unpack_bytes(trace[i][0], T_width)
                exp_bytes = _unpack_bytes(expected[i][0], T_width)
                np.testing.assert_array_equal(out_bytes, exp_bytes)

    @pytest.mark.parametrize("T_width", [1, 2, 4, 8, 16])
    @pytest.mark.parametrize("depth", [2, 4])
    def test_empty_read(self, T_width: int, depth: int) -> None:
        core = FIFOCore(T_width=T_width, depth=depth, name="fifo")
        sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out = (
            _create_wrapped_sim(core)
        )

        sim.step(
            {
                data_in: 0,
                valid_in: 0,
                ready_in: 1,
            }
        )
        assert sim.inspect(valid_out.name) == 0
        assert sim.inspect(ready_out.name) == 1

    @pytest.mark.parametrize("T_width", [1, 2, 4, 8, 16])
    @pytest.mark.parametrize("depth", [2, 4])
    def test_full_write(self, T_width: int, depth: int) -> None:
        core = FIFOCore(T_width=T_width, depth=depth, name="fifo")
        sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out = (
            _create_wrapped_sim(core)
        )

        inputs = [
            np.random.randint(-128, 128, size=T_width, dtype=np.int8)
            for _ in range(depth + 1)
        ]

        for i, val in enumerate(inputs):
            sim.step(
                {
                    data_in: _pack_bytes(val),
                    valid_in: 1,
                    ready_in: 0,
                }
            )

        assert sim.inspect(ready_out.name) == 0

    @pytest.mark.parametrize("T_width", [1, 2, 4, 8, 16])
    @pytest.mark.parametrize("depth", [2, 4])
    def test_random_data(self, T_width: int, depth: int) -> None:
        core = FIFOCore(T_width=T_width, depth=depth, name="fifo")
        sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out = (
            _create_wrapped_sim(core)
        )

        inputs = [
            np.random.randint(-128, 128, size=T_width, dtype=np.int8)
            for _ in range(10)
        ]
        packed_inputs = [_pack_bytes(val) for val in inputs]
        ready_pattern = [1] * 10

        trace = []
        for val in inputs:
            sim.step(
                {
                    data_in: _pack_bytes(val),
                    valid_in: 1,
                    ready_in: 1,
                }
            )
            trace.append(
                (
                    sim.inspect(data_out.name),
                    sim.inspect(valid_out.name),
                    sim.inspect(ready_out.name),
                )
            )

        expected = fifo_ref(packed_inputs, ready_pattern, depth)

        for i in range(10):
            if expected[i][1]:
                out_bytes = _unpack_bytes(trace[i][0], T_width)
                exp_bytes = _unpack_bytes(expected[i][0], T_width)
                np.testing.assert_array_equal(out_bytes, exp_bytes)
