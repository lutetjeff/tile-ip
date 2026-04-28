import numpy as np
import pyrtl
import pytest

from ip_cores.mem_router import MemRouterCore
from ref_models.mem_router_ref import mem_router_ref


def _create_wrapped_sim(core: MemRouterCore, reg_map=None, mem_map=None):
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

    kwargs = {"tracer": None, "block": core.block}
    if reg_map is not None:
        kwargs["register_value_map"] = reg_map
    if mem_map is not None:
        kwargs["memory_value_map"] = {core.bram: mem_map}
    sim = pyrtl.Simulation(**kwargs)
    return sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out


class TestMemRouterCore:
    def setup_method(self):
        pyrtl.reset_working_block()

    def _outputs_to_bytes(self, outputs, T_out):
        bytes_list = []
        for val in outputs:
            for i in range(T_out):
                byte = (val >> (i * 8)) & 0xFF
                bytes_list.append(np.int8(np.uint8(byte)))
        return np.array(bytes_list, dtype=np.int8)

    def _run_sim(self, core, mem_map, reg_map, ready_pattern=None, max_cycles=200):
        sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out = (
            _create_wrapped_sim(core, reg_map=reg_map, mem_map=mem_map)
        )

        outputs = []
        for cycle in range(max_cycles):
            valid_in_val = 1 if cycle == 0 else 0
            if ready_pattern is not None:
                ready_in_val = ready_pattern[cycle % len(ready_pattern)]
            else:
                ready_in_val = 1

            sim.step(
                {
                    data_in: 0,
                    valid_in: valid_in_val,
                    ready_in: ready_in_val,
                }
            )

            if sim.inspect(valid_out) == 1 and ready_in_val == 1:
                outputs.append(sim.inspect(data_out))

            if sim.inspect(core.state) == 3:
                break

        return outputs

    @pytest.mark.parametrize("T_out", [1, 2, 4])
    def test_transpose_10_beats(self, T_out):
        rows = T_out
        cols = 10
        data = np.random.randint(-128, 127, size=rows * cols, dtype=np.int8)

        core = MemRouterCore(T_out=T_out, name="mr")

        mem_map = {i: int(np.uint8(data[i])) for i in range(rows * cols)}
        reg_map = {
            core.base_addr: 0,
            core.stride: cols,
            core.beat_stride: 1,
            core.num_beats: cols,
            core.state: 0,
            core.beat_count: 0,
            core.read_idx: 0,
            core.current_addr: 0,
        }
        for i in range(T_out):
            reg_map[core.byte_regs[i]] = 0

        outputs = self._run_sim(core, mem_map, reg_map)

        ref = mem_router_ref(data, (rows, cols))
        ref_flat = ref.flatten()
        hw_bytes = self._outputs_to_bytes(outputs, T_out)

        assert len(hw_bytes) == len(ref_flat)
        assert np.array_equal(hw_bytes, ref_flat)

    @pytest.mark.parametrize("T_out", [1, 2, 4])
    def test_linear_stride(self, T_out):
        rows = 10
        cols = T_out
        data = np.random.randint(-128, 127, size=rows * cols, dtype=np.int8)

        core = MemRouterCore(T_out=T_out, name="mr_lin")

        mem_map = {i: int(np.uint8(data[i])) for i in range(rows * cols)}
        reg_map = {
            core.base_addr: 0,
            core.stride: 1,
            core.beat_stride: T_out,
            core.num_beats: rows,
            core.state: 0,
            core.beat_count: 0,
            core.read_idx: 0,
            core.current_addr: 0,
        }
        for i in range(T_out):
            reg_map[core.byte_regs[i]] = 0

        outputs = self._run_sim(core, mem_map, reg_map)

        ref = mem_router_ref(data, (rows, cols, False))
        ref_flat = ref.flatten()
        hw_bytes = self._outputs_to_bytes(outputs, T_out)

        assert len(hw_bytes) == len(ref_flat)
        assert np.array_equal(hw_bytes, ref_flat)

    def test_stall_recovery(self):
        T_out = 2
        rows = 2
        cols = 10
        data = np.random.randint(-128, 127, size=rows * cols, dtype=np.int8)

        core = MemRouterCore(T_out=T_out, name="mr_stall")

        mem_map = {i: int(np.uint8(data[i])) for i in range(rows * cols)}
        reg_map = {
            core.base_addr: 0,
            core.stride: cols,
            core.beat_stride: 1,
            core.num_beats: cols,
            core.state: 0,
            core.beat_count: 0,
            core.read_idx: 0,
            core.current_addr: 0,
        }
        for i in range(T_out):
            reg_map[core.byte_regs[i]] = 0

        ready_pattern = [1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]

        outputs = self._run_sim(core, mem_map, reg_map, ready_pattern=ready_pattern)

        ref = mem_router_ref(data, (rows, cols))
        ref_flat = ref.flatten()
        hw_bytes = self._outputs_to_bytes(outputs, T_out)

        assert len(hw_bytes) == len(ref_flat)
        assert np.array_equal(hw_bytes, ref_flat)

    def test_restart_from_done(self):
        T_out = 2
        rows = 2
        cols = 5
        data = np.random.randint(-128, 127, size=rows * cols, dtype=np.int8)

        core = MemRouterCore(T_out=T_out, name="mr_restart")

        mem_map = {i: int(np.uint8(data[i])) for i in range(rows * cols)}
        reg_map = {
            core.base_addr: 0,
            core.stride: cols,
            core.beat_stride: 1,
            core.num_beats: cols,
            core.state: 0,
            core.beat_count: 0,
            core.read_idx: 0,
            core.current_addr: 0,
        }
        for i in range(T_out):
            reg_map[core.byte_regs[i]] = 0

        sim, data_in, valid_in, ready_in, data_out, valid_out, ready_out = (
            _create_wrapped_sim(core, reg_map=reg_map, mem_map=mem_map)
        )

        outputs1 = []
        for cycle in range(100):
            valid_in_val = 1 if cycle == 0 else 0
            sim.step(
                {
                    data_in: 0,
                    valid_in: valid_in_val,
                    ready_in: 1,
                }
            )
            if sim.inspect(valid_out) == 1:
                outputs1.append(sim.inspect(data_out))
            if cycle > 0 and sim.inspect(core.state) == 3:
                break

        outputs2 = []
        for cycle in range(100):
            valid_in_val = 1 if cycle == 0 else 0
            sim.step(
                {
                    data_in: 0,
                    valid_in: valid_in_val,
                    ready_in: 1,
                }
            )
            if sim.inspect(valid_out) == 1:
                outputs2.append(sim.inspect(data_out))
            if cycle > 0 and sim.inspect(core.state) == 3:
                break

        ref = mem_router_ref(data, (rows, cols)).flatten()
        hw_bytes1 = self._outputs_to_bytes(outputs1, T_out)
        hw_bytes2 = self._outputs_to_bytes(outputs2, T_out)

        assert np.array_equal(hw_bytes1, ref)
        assert np.array_equal(hw_bytes2, ref)

    def test_zero_beats(self):
        T_out = 2
        core = MemRouterCore(T_out=T_out, name="mr_zero")

        mem_map = {0: 0, 1: 0}
        reg_map = {
            core.base_addr: 0,
            core.stride: 1,
            core.beat_stride: 1,
            core.num_beats: 0,
            core.state: 0,
            core.beat_count: 0,
            core.read_idx: 0,
            core.current_addr: 0,
        }
        for i in range(T_out):
            reg_map[core.byte_regs[i]] = 0

        outputs = self._run_sim(core, mem_map, reg_map)

        assert len(outputs) == 0
