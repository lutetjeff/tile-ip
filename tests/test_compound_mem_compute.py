import numpy as np
import pyrtl
import pytest

from ip_cores.axi_stream_base import AXI4StreamLiteBase
from ip_cores.gemm import GEMMCore
from ip_cores.mem_router import MemRouterCore
from tests.ref_models.gemm_ref import gemm_ref
from tests.ref_models.mem_router_ref import mem_router_ref
from stitcher import Stitcher


def _pack_bytes(values: np.ndarray) -> int:
    result = 0
    for i, v in enumerate(values.flatten()):
        result |= (int(v) & 0xFF) << (i * 8)
    return result


def _unpack_bytes(value: int, shape: tuple) -> np.ndarray:
    total = int(np.prod(shape))
    flat = np.array(
        [(value >> (i * 8)) & 0xFF for i in range(total)], dtype=np.uint8
    ).astype(np.int8)
    return flat.reshape(shape)


class TestCompoundMemCompute:
    def setup_method(self):
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize("T_M", [1, 2, 4, 8])
    @pytest.mark.parametrize("T_K", [1, 2, 4, 8])
    @pytest.mark.parametrize("T_N", [1, 2, 4, 8])
    def test_compound_random(self, T_M: int, T_K: int, T_N: int) -> None:
        T_out = T_M * T_K

        A = np.random.randint(-50, 50, size=(T_M, T_K), dtype=np.int8)
        B = np.random.randint(-50, 50, size=(T_K, T_N), dtype=np.int8)
        A_flat = A.flatten()

        shared_block = pyrtl.Block()
        mr = MemRouterCore(T_out=T_out, name="mr", block=shared_block)
        gemm = GEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, name="gemm", block=shared_block)

        with pyrtl.set_working_block(shared_block, no_sanity_check=True):
            gemm.data_in <<= mr.data_out
            gemm.valid_in <<= mr.valid_out
            mr.ready_in <<= gemm.ready_out

            mr.data_in <<= pyrtl.Const(0, bitwidth=mr.data_in.bitwidth)

            mr_valid = pyrtl.Input(1, name="mr_valid")
            gemm_ready = pyrtl.Input(1, name="gemm_ready")
            gemm_weight = pyrtl.Input(gemm.weight_in.bitwidth, name="gemm_weight")
            gemm_weight_valid = pyrtl.Input(1, name="gemm_weight_valid")

            mr.valid_in <<= mr_valid
            gemm.ready_in <<= gemm_ready
            gemm.weight_in <<= gemm_weight
            gemm.weight_valid_in <<= gemm_weight_valid

        mem_map = {i: int(np.uint8(A_flat[i])) for i in range(len(A_flat))}
        reg_map = {
            mr.base_addr: 0,
            mr.stride: 1,
            mr.beat_stride: T_out,
            mr.num_beats: 1,
            mr.state: 0,
            mr.beat_count: 0,
            mr.read_idx: 0,
            mr.current_addr: 0,
        }
        for i in range(T_out):
            reg_map[mr.byte_regs[i]] = 0

        sim = pyrtl.Simulation(
            tracer=None,
            register_value_map=reg_map,
            memory_value_map={mr.bram: mem_map},
            block=shared_block,
        )

        gemm_outputs = []
        mr_outputs = []
        max_cycles = T_out + 10

        for cycle in range(max_cycles):
            inputs = {
                mr_valid: 1 if cycle == 0 else 0,
                gemm_ready: 1,
                gemm_weight: _pack_bytes(B),
                gemm_weight_valid: 1,
            }
            sim.step(inputs)

            if sim.inspect(gemm.valid_out) == 1:
                gemm_outputs.append(sim.inspect(gemm.data_out))
                mr_outputs.append(sim.inspect(mr.data_out))

            if sim.inspect(mr.state) == 3 and cycle > 0:
                break

        assert len(gemm_outputs) == 1
        assert len(mr_outputs) == 1

        C_hw = _unpack_bytes(gemm_outputs[0], (T_M, T_N))
        C_ref = gemm_ref(A, B)
        np.testing.assert_array_equal(C_hw, C_ref)

        streamed_bytes = _unpack_bytes(mr_outputs[0], (T_M, T_K))
        ref_streamed = mem_router_ref(A_flat, (T_M, T_K, False))
        np.testing.assert_array_equal(streamed_bytes, ref_streamed)

    @pytest.mark.parametrize("T_M", [1, 2, 4, 8])
    @pytest.mark.parametrize("T_K", [1, 2, 4, 8])
    @pytest.mark.parametrize("T_N", [1, 2, 4, 8])
    def test_compound_all_zeros(self, T_M: int, T_K: int, T_N: int) -> None:
        T_out = T_M * T_K

        A = np.zeros((T_M, T_K), dtype=np.int8)
        B = np.zeros((T_K, T_N), dtype=np.int8)
        A_flat = A.flatten()

        shared_block = pyrtl.Block()
        mr = MemRouterCore(T_out=T_out, name="mr", block=shared_block)
        gemm = GEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, name="gemm", block=shared_block)

        with pyrtl.set_working_block(shared_block, no_sanity_check=True):
            gemm.data_in <<= mr.data_out
            gemm.valid_in <<= mr.valid_out
            mr.ready_in <<= gemm.ready_out

            mr.data_in <<= pyrtl.Const(0, bitwidth=mr.data_in.bitwidth)

            mr_valid = pyrtl.Input(1, name="mr_valid")
            gemm_ready = pyrtl.Input(1, name="gemm_ready")
            gemm_weight = pyrtl.Input(gemm.weight_in.bitwidth, name="gemm_weight")
            gemm_weight_valid = pyrtl.Input(1, name="gemm_weight_valid")

            mr.valid_in <<= mr_valid
            gemm.ready_in <<= gemm_ready
            gemm.weight_in <<= gemm_weight
            gemm.weight_valid_in <<= gemm_weight_valid

        mem_map = {i: 0 for i in range(len(A_flat))}
        reg_map = {
            mr.base_addr: 0,
            mr.stride: 1,
            mr.beat_stride: T_out,
            mr.num_beats: 1,
            mr.state: 0,
            mr.beat_count: 0,
            mr.read_idx: 0,
            mr.current_addr: 0,
        }
        for i in range(T_out):
            reg_map[mr.byte_regs[i]] = 0

        sim = pyrtl.Simulation(
            tracer=None,
            register_value_map=reg_map,
            memory_value_map={mr.bram: mem_map},
            block=shared_block,
        )

        gemm_outputs = []
        for cycle in range(T_out + 10):
            inputs = {
                mr_valid: 1 if cycle == 0 else 0,
                gemm_ready: 1,
                gemm_weight: _pack_bytes(B),
                gemm_weight_valid: 1,
            }
            sim.step(inputs)

            if sim.inspect(gemm.valid_out) == 1:
                gemm_outputs.append(sim.inspect(gemm.data_out))

            if sim.inspect(mr.state) == 3 and cycle > 0:
                break

        assert len(gemm_outputs) == 1
        C_hw = _unpack_bytes(gemm_outputs[0], (T_M, T_N))
        C_ref = gemm_ref(A, B)
        np.testing.assert_array_equal(C_hw, C_ref)


class TestCompoundMemComputeStitcher:
    def setup_method(self):
        AXI4StreamLiteBase.reset()

    @pytest.mark.parametrize("T_M", [1, 2, 4, 8])
    @pytest.mark.parametrize("T_K", [1, 2, 4, 8])
    @pytest.mark.parametrize("T_N", [1, 2, 4, 8])
    def test_compound_random(self, T_M: int, T_K: int, T_N: int) -> None:
        T_out = T_M * T_K

        A = np.random.randint(-50, 50, size=(T_M, T_K), dtype=np.int8)
        B = np.random.randint(-50, 50, size=(T_K, T_N), dtype=np.int8)
        A_flat = A.flatten()

        shared_block = pyrtl.Block()
        mr = MemRouterCore(T_out=T_out, name="mr", block=shared_block)
        gemm = GEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, name="gemm", block=shared_block)

        stitcher = Stitcher(block=shared_block)
        stitcher.add_ip(mr)
        stitcher.add_ip(gemm)
        stitcher.connect("mr", "gemm")
        built_block, drivers = stitcher.build()

        with pyrtl.set_working_block(built_block, no_sanity_check=True):
            gemm_weight = pyrtl.Input(gemm.weight_in.bitwidth, name="gemm_weight")
            gemm_weight_valid = pyrtl.Input(1, name="gemm_weight_valid")
            gemm.weight_in <<= gemm_weight
            gemm.weight_valid_in <<= gemm_weight_valid

        mem_map = {i: int(np.uint8(A_flat[i])) for i in range(len(A_flat))}
        reg_map = {
            mr.base_addr: 0,
            mr.stride: 1,
            mr.beat_stride: T_out,
            mr.num_beats: 1,
            mr.state: 0,
            mr.beat_count: 0,
            mr.read_idx: 0,
            mr.current_addr: 0,
        }
        for i in range(T_out):
            reg_map[mr.byte_regs[i]] = 0

        sim = pyrtl.Simulation(
            tracer=None,
            register_value_map=reg_map,
            memory_value_map={mr.bram: mem_map},
            block=built_block,
        )

        gemm_outputs = []
        mr_outputs = []
        max_cycles = T_out + 10

        for cycle in range(max_cycles):
            inputs = {
                drivers["mr_data_in"]: 0,
                drivers["mr_valid_in"]: 1 if cycle == 0 else 0,
                drivers["gemm_ready_in"]: 1,
                gemm_weight: _pack_bytes(B),
                gemm_weight_valid: 1,
            }
            sim.step(inputs)

            if sim.inspect(gemm.valid_out) == 1:
                gemm_outputs.append(sim.inspect(gemm.data_out))
                mr_outputs.append(sim.inspect(mr.data_out))

            if sim.inspect(mr.state) == 3 and cycle > 0:
                break

        assert len(gemm_outputs) == 1
        assert len(mr_outputs) == 1

        C_hw = _unpack_bytes(gemm_outputs[0], (T_M, T_N))
        C_ref = gemm_ref(A, B)
        np.testing.assert_array_equal(C_hw, C_ref)

        streamed_bytes = _unpack_bytes(mr_outputs[0], (T_M, T_K))
        ref_streamed = mem_router_ref(A_flat, (T_M, T_K, False))
        np.testing.assert_array_equal(streamed_bytes, ref_streamed)

    @pytest.mark.parametrize("T_M", [1, 2, 4, 8])
    @pytest.mark.parametrize("T_K", [1, 2, 4, 8])
    @pytest.mark.parametrize("T_N", [1, 2, 4, 8])
    def test_compound_all_zeros(self, T_M: int, T_K: int, T_N: int) -> None:
        T_out = T_M * T_K

        A = np.zeros((T_M, T_K), dtype=np.int8)
        B = np.zeros((T_K, T_N), dtype=np.int8)
        A_flat = A.flatten()

        shared_block = pyrtl.Block()
        mr = MemRouterCore(T_out=T_out, name="mr", block=shared_block)
        gemm = GEMMCore(T_M=T_M, T_K=T_K, T_N=T_N, name="gemm", block=shared_block)

        stitcher = Stitcher(block=shared_block)
        stitcher.add_ip(mr)
        stitcher.add_ip(gemm)
        stitcher.connect("mr", "gemm")
        built_block, drivers = stitcher.build()

        with pyrtl.set_working_block(built_block, no_sanity_check=True):
            gemm_weight = pyrtl.Input(gemm.weight_in.bitwidth, name="gemm_weight")
            gemm_weight_valid = pyrtl.Input(1, name="gemm_weight_valid")
            gemm.weight_in <<= gemm_weight
            gemm.weight_valid_in <<= gemm_weight_valid

        mem_map = {i: 0 for i in range(len(A_flat))}
        reg_map = {
            mr.base_addr: 0,
            mr.stride: 1,
            mr.beat_stride: T_out,
            mr.num_beats: 1,
            mr.state: 0,
            mr.beat_count: 0,
            mr.read_idx: 0,
            mr.current_addr: 0,
        }
        for i in range(T_out):
            reg_map[mr.byte_regs[i]] = 0

        sim = pyrtl.Simulation(
            tracer=None,
            register_value_map=reg_map,
            memory_value_map={mr.bram: mem_map},
            block=built_block,
        )

        gemm_outputs = []
        for cycle in range(T_out + 10):
            inputs = {
                drivers["mr_data_in"]: 0,
                drivers["mr_valid_in"]: 1 if cycle == 0 else 0,
                drivers["gemm_ready_in"]: 1,
                gemm_weight: _pack_bytes(B),
                gemm_weight_valid: 1,
            }
            sim.step(inputs)

            if sim.inspect(gemm.valid_out) == 1:
                gemm_outputs.append(sim.inspect(gemm.data_out))

            if sim.inspect(mr.state) == 3 and cycle > 0:
                break

        assert len(gemm_outputs) == 1
        C_hw = _unpack_bytes(gemm_outputs[0], (T_M, T_N))
        C_ref = gemm_ref(A, B)
        np.testing.assert_array_equal(C_hw, C_ref)
