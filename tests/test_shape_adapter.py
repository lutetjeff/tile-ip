"""Comprehensive tests for the StreamShapeAdapter IP core."""

from __future__ import annotations

import numpy as np
import pyrtl
import pytest

from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ip_cores.shape_adapter import StreamShapeAdapter


def _pack_bytes(values: np.ndarray) -> int:
    result = 0
    for i, v in enumerate(values):
        result |= (int(v) & 0xFF) << (i * 8)
    return result


def _unpack_bytes(value: int, T_width: int) -> np.ndarray:
    out = []
    for i in range(T_width):
        b = (value >> (i * 8)) & 0xFF
        if b >= 128:
            b -= 256
        out.append(b)
    return np.array(out, dtype=np.int8)


def _create_wrapped_sim(adapter: StreamShapeAdapter):
    with pyrtl.set_working_block(adapter.block, no_sanity_check=True):
        data_in = pyrtl.Input(
            bitwidth=adapter.data_in.bitwidth, name="wrapper_data_in"
        )
        valid_in = pyrtl.Input(bitwidth=1, name="wrapper_valid_in")
        ready_in = pyrtl.Input(bitwidth=1, name="wrapper_ready_in")

        data_out = pyrtl.Output(
            bitwidth=adapter.data_out.bitwidth, name="wrapper_data_out"
        )
        valid_out = pyrtl.Output(bitwidth=1, name="wrapper_valid_out")
        ready_out = pyrtl.Output(bitwidth=1, name="wrapper_ready_out")
        last_out = pyrtl.Output(bitwidth=1, name="wrapper_last_out")

        adapter.data_in <<= data_in
        adapter.valid_in <<= valid_in
        adapter.ready_in <<= ready_in
        data_out <<= adapter.data_out
        valid_out <<= adapter.valid_out
        ready_out <<= adapter.ready_out
        last_out <<= adapter.last_out

    sim = pyrtl.Simulation(tracer=None, block=adapter.block)
    return sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out, last_out


class TestStreamShapeAdapter:
    def setup_method(self) -> None:
        AXI4StreamLiteBase.reset()

    def test_upsizing_basic(self) -> None:
        adapter = StreamShapeAdapter(N=8, T_in=2, T_out=4, name="sa_up")
        sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out, last_out = (
            _create_wrapped_sim(adapter)
        )

        input_bytes = [
            np.array([0x01, 0x02], dtype=np.int8),
            np.array([0x03, 0x04], dtype=np.int8),
            np.array([0x05, 0x06], dtype=np.int8),
            np.array([0x07, 0x08], dtype=np.int8),
        ]
        packed = [_pack_bytes(b) for b in input_bytes]

        trace = []
        for cycle in range(6):
            d = packed[cycle] if cycle < 4 else 0
            v = 1 if cycle < 4 else 0
            sim.step({data_in: d, valid_in: v, ready_in: 1})
            trace.append(
                {
                    "data": sim.inspect(data_out.name),
                    "valid": sim.inspect(valid_out.name),
                    "ready": sim.inspect(ready_out.name),
                    "last": sim.inspect(last_out.name),
                }
            )

        assert trace[0]["valid"] == 0
        assert trace[1]["valid"] == 0

        assert trace[2]["valid"] == 1
        assert trace[2]["last"] == 0
        np.testing.assert_array_equal(
            _unpack_bytes(trace[2]["data"], 4),
            np.array([0x01, 0x02, 0x03, 0x04], dtype=np.int8),
        )

        assert trace[3]["valid"] == 0

        assert trace[4]["valid"] == 1
        assert trace[4]["last"] == 1
        np.testing.assert_array_equal(
            _unpack_bytes(trace[4]["data"], 4),
            np.array([0x05, 0x06, 0x07, 0x08], dtype=np.int8),
        )

        assert trace[5]["valid"] == 0
        assert trace[5]["ready"] == 0

    def test_upsizing_backpressure(self) -> None:
        adapter = StreamShapeAdapter(N=8, T_in=2, T_out=4, name="sa_up_bp")
        sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out, last_out = (
            _create_wrapped_sim(adapter)
        )

        input_bytes = [
            np.array([0x01, 0x02], dtype=np.int8),
            np.array([0x03, 0x04], dtype=np.int8),
            np.array([0x05, 0x06], dtype=np.int8),
            np.array([0x07, 0x08], dtype=np.int8),
        ]
        packed = [_pack_bytes(b) for b in input_bytes]

        trace = []
        in_idx = 0
        stall = {2, 3, 4}
        for cycle in range(10):
            r = 0 if cycle in stall else 1
            d = packed[in_idx] if in_idx < 4 else 0
            v = 1 if in_idx < 4 else 0
            sim.step({data_in: d, valid_in: v, ready_in: r})
            if sim.inspect(ready_out.name) and in_idx < 4:
                in_idx += 1
            trace.append(
                {
                    "data": sim.inspect(data_out.name),
                    "valid": sim.inspect(valid_out.name),
                    "ready": sim.inspect(ready_out.name),
                    "last": sim.inspect(last_out.name),
                }
            )

        assert trace[0]["valid"] == 0 and trace[0]["ready"] == 1
        assert trace[1]["valid"] == 0 and trace[1]["ready"] == 1

        assert trace[2]["valid"] == 1
        assert trace[2]["ready"] == 0
        np.testing.assert_array_equal(
            _unpack_bytes(trace[2]["data"], 4),
            np.array([0x01, 0x02, 0x03, 0x04], dtype=np.int8),
        )

        assert trace[3]["valid"] == 1 and trace[3]["ready"] == 0
        assert trace[4]["valid"] == 1 and trace[4]["ready"] == 0

        assert trace[5]["valid"] == 1 and trace[5]["ready"] == 1

        assert trace[7]["valid"] == 1
        assert trace[7]["last"] == 1
        np.testing.assert_array_equal(
            _unpack_bytes(trace[7]["data"], 4),
            np.array([0x05, 0x06, 0x07, 0x08], dtype=np.int8),
        )

    def test_downsizing_basic(self) -> None:
        adapter = StreamShapeAdapter(N=8, T_in=4, T_out=2, name="sa_down")
        sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out, last_out = (
            _create_wrapped_sim(adapter)
        )

        input_bytes = [
            np.array([0x01, 0x02, 0x03, 0x04], dtype=np.int8),
            np.array([0x05, 0x06, 0x07, 0x08], dtype=np.int8),
        ]
        packed = [_pack_bytes(b) for b in input_bytes]

        trace = []
        in_idx = 0
        for cycle in range(8):
            d = packed[in_idx] if in_idx < 2 else 0
            v = 1 if in_idx < 2 else 0
            sim.step({data_in: d, valid_in: v, ready_in: 1})
            if sim.inspect(ready_out.name) and in_idx < 2:
                in_idx += 1
            trace.append(
                {
                    "data": sim.inspect(data_out.name),
                    "valid": sim.inspect(valid_out.name),
                    "ready": sim.inspect(ready_out.name),
                    "last": sim.inspect(last_out.name),
                }
            )

        assert trace[0]["valid"] == 0
        assert trace[0]["ready"] == 1

        assert trace[1]["valid"] == 1
        assert trace[1]["last"] == 0
        np.testing.assert_array_equal(
            _unpack_bytes(trace[1]["data"], 2),
            np.array([0x01, 0x02], dtype=np.int8),
        )

        assert trace[2]["valid"] == 1
        assert trace[2]["ready"] == 1
        np.testing.assert_array_equal(
            _unpack_bytes(trace[2]["data"], 2),
            np.array([0x03, 0x04], dtype=np.int8),
        )

        assert trace[3]["valid"] == 1
        assert trace[3]["last"] == 0
        np.testing.assert_array_equal(
            _unpack_bytes(trace[3]["data"], 2),
            np.array([0x05, 0x06], dtype=np.int8),
        )

        assert trace[4]["valid"] == 1
        assert trace[4]["last"] == 1
        np.testing.assert_array_equal(
            _unpack_bytes(trace[4]["data"], 2),
            np.array([0x07, 0x08], dtype=np.int8),
        )

        assert trace[5]["valid"] == 0
        assert trace[5]["ready"] == 0

    def test_downsizing_backpressure(self) -> None:
        adapter = StreamShapeAdapter(N=8, T_in=4, T_out=2, name="sa_down_bp")
        sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out, last_out = (
            _create_wrapped_sim(adapter)
        )

        input_bytes = [
            np.array([0x01, 0x02, 0x03, 0x04], dtype=np.int8),
            np.array([0x05, 0x06, 0x07, 0x08], dtype=np.int8),
        ]
        packed = [_pack_bytes(b) for b in input_bytes]

        trace = []
        in_idx = 0
        for cycle in range(8):
            r = 0 if cycle == 2 else 1
            d = packed[in_idx] if in_idx < 2 else 0
            v = 1 if in_idx < 2 else 0
            sim.step({data_in: d, valid_in: v, ready_in: r})
            if sim.inspect(ready_out.name) and in_idx < 2:
                in_idx += 1
            trace.append(
                {
                    "data": sim.inspect(data_out.name),
                    "valid": sim.inspect(valid_out.name),
                    "ready": sim.inspect(ready_out.name),
                    "last": sim.inspect(last_out.name),
                }
            )

        assert trace[0]["valid"] == 0 and trace[0]["ready"] == 1

        assert trace[1]["valid"] == 1
        assert trace[1]["ready"] == 0
        np.testing.assert_array_equal(
            _unpack_bytes(trace[1]["data"], 2),
            np.array([0x01, 0x02], dtype=np.int8),
        )

        assert trace[2]["valid"] == 1
        assert trace[2]["ready"] == 0
        np.testing.assert_array_equal(
            _unpack_bytes(trace[2]["data"], 2),
            np.array([0x03, 0x04], dtype=np.int8),
        )

        assert trace[3]["valid"] == 1
        np.testing.assert_array_equal(
            _unpack_bytes(trace[3]["data"], 2),
            np.array([0x03, 0x04], dtype=np.int8),
        )

        assert trace[4]["valid"] == 1
        np.testing.assert_array_equal(
            _unpack_bytes(trace[4]["data"], 2),
            np.array([0x05, 0x06], dtype=np.int8),
        )

        assert trace[5]["valid"] == 1
        assert trace[5]["last"] == 1
        np.testing.assert_array_equal(
            _unpack_bytes(trace[5]["data"], 2),
            np.array([0x07, 0x08], dtype=np.int8),
        )

        assert trace[6]["valid"] == 0
        assert trace[7]["valid"] == 0

    def test_passthrough_basic(self) -> None:
        adapter = StreamShapeAdapter(N=8, T_in=2, T_out=2, name="sa_pass")
        sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out, last_out = (
            _create_wrapped_sim(adapter)
        )

        input_bytes = [
            np.array([0x01, 0x02], dtype=np.int8),
            np.array([0x03, 0x04], dtype=np.int8),
            np.array([0x05, 0x06], dtype=np.int8),
            np.array([0x07, 0x08], dtype=np.int8),
        ]
        packed = [_pack_bytes(b) for b in input_bytes]

        trace = []
        for cycle in range(6):
            d = packed[cycle] if cycle < 4 else 0
            v = 1 if cycle < 4 else 0
            sim.step({data_in: d, valid_in: v, ready_in: 1})
            trace.append(
                {
                    "data": sim.inspect(data_out.name),
                    "valid": sim.inspect(valid_out.name),
                    "ready": sim.inspect(ready_out.name),
                    "last": sim.inspect(last_out.name),
                }
            )

        for i in range(4):
            assert trace[i]["valid"] == 1
            assert trace[i]["ready"] == 1
            np.testing.assert_array_equal(
                _unpack_bytes(trace[i]["data"], 2), input_bytes[i]
            )

        assert trace[3]["last"] == 1
        for i in range(3):
            assert trace[i]["last"] == 0

        assert trace[4]["valid"] == 0 and trace[4]["ready"] == 0
        assert trace[5]["valid"] == 0 and trace[5]["ready"] == 0

    def test_passthrough_backpressure(self) -> None:
        adapter = StreamShapeAdapter(N=8, T_in=2, T_out=2, name="sa_pass_bp")
        sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out, last_out = (
            _create_wrapped_sim(adapter)
        )

        input_bytes = [
            np.array([0x01, 0x02], dtype=np.int8),
            np.array([0x03, 0x04], dtype=np.int8),
            np.array([0x05, 0x06], dtype=np.int8),
            np.array([0x07, 0x08], dtype=np.int8),
        ]
        packed = [_pack_bytes(b) for b in input_bytes]

        trace = []
        in_idx = 0
        for cycle in range(6):
            r = 1 if cycle != 1 else 0
            d = packed[in_idx] if in_idx < 4 else 0
            v = 1 if in_idx < 4 else 0
            sim.step({data_in: d, valid_in: v, ready_in: r})
            if sim.inspect(ready_out.name) and in_idx < 4:
                in_idx += 1
            trace.append(
                {
                    "data": sim.inspect(data_out.name),
                    "valid": sim.inspect(valid_out.name),
                    "ready": sim.inspect(ready_out.name),
                    "last": sim.inspect(last_out.name),
                }
            )

        assert trace[0]["valid"] == 1
        np.testing.assert_array_equal(
            _unpack_bytes(trace[0]["data"], 2), input_bytes[0]
        )

        assert trace[1]["valid"] == 1
        assert trace[1]["ready"] == 0

        assert trace[2]["valid"] == 1
        np.testing.assert_array_equal(
            _unpack_bytes(trace[2]["data"], 2), input_bytes[1]
        )

        assert trace[3]["valid"] == 1
        np.testing.assert_array_equal(
            _unpack_bytes(trace[3]["data"], 2), input_bytes[2]
        )

        assert trace[4]["valid"] == 1
        assert trace[4]["last"] == 1
        np.testing.assert_array_equal(
            _unpack_bytes(trace[4]["data"], 2), input_bytes[3]
        )

    def test_last_out_upsizing(self) -> None:
        AXI4StreamLiteBase.reset()
        adapter = StreamShapeAdapter(N=8, T_in=2, T_out=4, name="sa_last_up")
        sim, d_in, v_in, r_in, _, _, _, l_out = _create_wrapped_sim(adapter)

        last_flags = []
        for i in range(5):
            sim.step(
                {
                    d_in: _pack_bytes(
                        np.array([i * 2 + 1, i * 2 + 2], dtype=np.int8)
                    )
                    if i < 4
                    else 0,
                    v_in: 1 if i < 4 else 0,
                    r_in: 1,
                }
            )
            last_flags.append(sim.inspect(l_out.name))

        assert last_flags[0] == 0
        assert last_flags[1] == 0
        assert last_flags[2] == 0
        assert last_flags[3] == 0
        assert last_flags[4] == 1

    def test_last_out_downsizing(self) -> None:
        AXI4StreamLiteBase.reset()
        adapter = StreamShapeAdapter(N=8, T_in=4, T_out=2, name="sa_last_down")
        sim, d_in, v_in, r_in, _, _, r_out, l_out = _create_wrapped_sim(adapter)

        last_flags = []
        in_idx = 0
        packed = [
            _pack_bytes(np.array([0x01, 0x02, 0x03, 0x04], dtype=np.int8)),
            _pack_bytes(np.array([0x05, 0x06, 0x07, 0x08], dtype=np.int8)),
        ]
        for i in range(6):
            d = packed[in_idx] if in_idx < 2 else 0
            v = 1 if in_idx < 2 else 0
            sim.step({d_in: d, v_in: v, r_in: 1})
            if sim.inspect(r_out.name) and in_idx < 2:
                in_idx += 1
            last_flags.append(sim.inspect(l_out.name))

        assert last_flags[0] == 0
        assert last_flags[1] == 0
        assert last_flags[2] == 0
        assert last_flags[3] == 0
        assert last_flags[4] == 1
        assert last_flags[5] == 0

    def test_last_out_passthrough(self) -> None:
        AXI4StreamLiteBase.reset()
        adapter = StreamShapeAdapter(N=8, T_in=2, T_out=2, name="sa_last_pass")
        sim, d_in, v_in, r_in, _, _, _, l_out = _create_wrapped_sim(adapter)

        last_flags = []
        for i in range(6):
            sim.step(
                {
                    d_in: _pack_bytes(np.array([i + 1, i + 2], dtype=np.int8))
                    if i < 4
                    else 0,
                    v_in: 1 if i < 4 else 0,
                    r_in: 1,
                }
            )
            last_flags.append(sim.inspect(l_out.name))

        assert last_flags[0] == 0
        assert last_flags[1] == 0
        assert last_flags[2] == 0
        assert last_flags[3] == 1
        assert last_flags[4] == 0
        assert last_flags[5] == 0

    @pytest.mark.parametrize("T_in,T_out", [(1, 4), (2, 4), (1, 2), (4, 8)])
    def test_upsizing_random_data(self, T_in: int, T_out: int) -> None:
        N = 16
        AXI4StreamLiteBase.reset()
        adapter = StreamShapeAdapter(N=N, T_in=T_in, T_out=T_out, name="sa_rup")
        sim, d_in, v_in, r_in, d_out, v_out, r_out, l_out = _create_wrapped_sim(
            adapter
        )

        rng = np.random.default_rng(42)
        num_in = N // T_in
        num_out = N // T_out

        input_bytes = [
            rng.integers(-128, 128, size=T_in, dtype=np.int8)
            for _ in range(num_in)
        ]
        packed = [_pack_bytes(b) for b in input_bytes]

        outputs = []
        in_idx = 0
        for cycle in range(50):
            if in_idx < num_in and sim.inspect(r_out.name):
                d = packed[in_idx]
                v = 1
                in_idx += 1
            else:
                d = 0
                v = 0
            sim.step({d_in: d, v_in: v, r_in: 1})
            if sim.inspect(v_out.name):
                outputs.append(_unpack_bytes(sim.inspect(d_out.name), T_out))
            if len(outputs) == num_out:
                break

        assert len(outputs) == num_out
        assembled = []
        for ob in outputs:
            assembled.extend(ob.tolist())
        expected = []
        for ib in input_bytes:
            expected.extend(ib.tolist())
        np.testing.assert_array_equal(
            np.array(assembled, dtype=np.int8), np.array(expected, dtype=np.int8)
        )

    @pytest.mark.parametrize("T_in,T_out", [(4, 1), (4, 2), (8, 2), (8, 4)])
    def test_downsizing_random_data(self, T_in: int, T_out: int) -> None:
        N = 16
        AXI4StreamLiteBase.reset()
        adapter = StreamShapeAdapter(N=N, T_in=T_in, T_out=T_out, name="sa_rdown")
        sim, d_in, v_in, r_in, d_out, v_out, r_out, l_out = _create_wrapped_sim(
            adapter
        )

        rng = np.random.default_rng(123)
        num_in = N // T_in
        num_out = N // T_out

        input_bytes = [
            rng.integers(-128, 128, size=T_in, dtype=np.int8)
            for _ in range(num_in)
        ]
        packed = [_pack_bytes(b) for b in input_bytes]

        outputs = []
        in_idx = 0
        for cycle in range(50):
            d = packed[in_idx] if in_idx < num_in else 0
            v = 1 if in_idx < num_in else 0
            sim.step({d_in: d, v_in: v, r_in: 1})
            if sim.inspect(r_out.name) and in_idx < num_in:
                in_idx += 1
            if sim.inspect(v_out.name):
                outputs.append(_unpack_bytes(sim.inspect(d_out.name), T_out))
            if len(outputs) == num_out:
                break

        assert len(outputs) == num_out
        assembled = []
        for ob in outputs:
            assembled.extend(ob.tolist())
        expected = []
        for ib in input_bytes:
            expected.extend(ib.tolist())
        np.testing.assert_array_equal(
            np.array(assembled, dtype=np.int8), np.array(expected, dtype=np.int8)
        )

    @pytest.mark.parametrize("T", [1, 2, 4, 8])
    def test_passthrough_random_data(self, T: int) -> None:
        N = 16
        AXI4StreamLiteBase.reset()
        adapter = StreamShapeAdapter(N=N, T_in=T, T_out=T, name="sa_rpass")
        sim, d_in, v_in, r_in, d_out, v_out, r_out, l_out = _create_wrapped_sim(
            adapter
        )

        rng = np.random.default_rng(77)
        num_beats = N // T

        input_bytes = [
            rng.integers(-128, 128, size=T, dtype=np.int8) for _ in range(num_beats)
        ]
        packed = [_pack_bytes(b) for b in input_bytes]

        outputs = []
        in_idx = 0
        for cycle in range(50):
            if in_idx < num_beats and sim.inspect(r_out.name):
                d = packed[in_idx]
                v = 1
                in_idx += 1
            else:
                d = 0
                v = 0
            sim.step({d_in: d, v_in: v, r_in: 1})
            if sim.inspect(v_out.name):
                outputs.append(_unpack_bytes(sim.inspect(d_out.name), T))
            if len(outputs) == num_beats:
                break

        assert len(outputs) == num_beats
        for i in range(num_beats):
            np.testing.assert_array_equal(outputs[i], input_bytes[i])

    def test_invalid_params(self) -> None:
        with pytest.raises(ValueError, match="N must be a positive integer"):
            StreamShapeAdapter(N=0, T_in=2, T_out=4, name="bad")
        with pytest.raises(ValueError, match="T_in and T_out must be positive"):
            StreamShapeAdapter(N=8, T_in=0, T_out=4, name="bad")
        with pytest.raises(ValueError, match="must be a multiple of T_in"):
            StreamShapeAdapter(N=8, T_in=3, T_out=4, name="bad")
        with pytest.raises(ValueError, match="must be a multiple of T_out"):
            StreamShapeAdapter(N=8, T_in=2, T_out=3, name="bad")
        with pytest.raises(ValueError, match="name must be a non-empty string"):
            StreamShapeAdapter(N=8, T_in=2, T_out=4, name="")
