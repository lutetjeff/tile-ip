import numpy as np
import pyrtl
import pytest

from ip_cores.multi_bank_bram import MultiBankBRAMCore


def _create_wrapped_sim(core: MultiBankBRAMCore, reg_map=None, mem_map=None):
    with pyrtl.set_working_block(core.block, no_sanity_check=True):
        data_in = pyrtl.Input(bitwidth=core.data_in.bitwidth, name="wrapper_data_in")
        valid_in = pyrtl.Input(bitwidth=1, name="wrapper_valid_in")
        last_in = pyrtl.Input(bitwidth=1, name="wrapper_last_in")
        ready_in = pyrtl.Input(bitwidth=1, name="wrapper_ready_in")

        read_addr = pyrtl.Input(
            bitwidth=core.read_addr.bitwidth, name="wrapper_read_addr"
        )
        read_bank_sel = pyrtl.Input(
            bitwidth=core.read_bank_sel.bitwidth, name="wrapper_read_bank_sel"
        )

        write_data_in = pyrtl.Input(
            bitwidth=core.write_data_in.bitwidth, name="wrapper_write_data_in"
        )
        write_valid_in = pyrtl.Input(
            bitwidth=1, name="wrapper_write_valid_in"
        )
        write_last_in = pyrtl.Input(
            bitwidth=1, name="wrapper_write_last_in"
        )
        write_addr = pyrtl.Input(
            bitwidth=core.write_addr.bitwidth, name="wrapper_write_addr"
        )
        write_bank_sel = pyrtl.Input(
            bitwidth=core.write_bank_sel.bitwidth, name="wrapper_write_bank_sel"
        )

        data_out = pyrtl.Output(
            bitwidth=core.data_out.bitwidth, name="wrapper_data_out"
        )
        valid_out = pyrtl.Output(bitwidth=1, name="wrapper_valid_out")
        last_out = pyrtl.Output(bitwidth=1, name="wrapper_last_out")
        ready_out = pyrtl.Output(bitwidth=1, name="wrapper_ready_out")
        write_ready_out = pyrtl.Output(
            bitwidth=1, name="wrapper_write_ready_out"
        )

        core.data_in <<= data_in
        core.valid_in <<= valid_in
        core.last_in <<= last_in
        core.ready_in <<= ready_in
        core.read_addr <<= read_addr
        core.read_bank_sel <<= read_bank_sel
        core.write_data_in <<= write_data_in
        core.write_valid_in <<= write_valid_in
        core.write_last_in <<= write_last_in
        core.write_addr <<= write_addr
        core.write_bank_sel <<= write_bank_sel

        data_out <<= core.data_out
        valid_out <<= core.valid_out
        last_out <<= core.last_out
        ready_out <<= core.ready_out
        write_ready_out <<= core.write_ready_out

    kwargs = {"tracer": None, "block": core.block}
    if reg_map is not None:
        kwargs["register_value_map"] = reg_map
    if mem_map is not None:
        mem_value_map = {}
        for bank_idx, bank in enumerate(core.banks):
            bank_map = {}
            for addr, val in mem_map.get(bank_idx, {}).items():
                bank_map[addr] = val
            mem_value_map[bank] = bank_map
        kwargs["memory_value_map"] = mem_value_map

    sim = pyrtl.Simulation(**kwargs)
    return (
        sim,
        data_in,
        valid_in,
        last_in,
        ready_in,
        read_addr,
        read_bank_sel,
        write_data_in,
        write_valid_in,
        write_last_in,
        write_addr,
        write_bank_sel,
        data_out,
        valid_out,
        last_out,
        ready_out,
        write_ready_out,
    )


class TestMultiBankBRAMCore:
    def setup_method(self):
        pyrtl.reset_working_block()

    def _init_reg_map(self, core):
        return {
            core.read_state: 0,
            core.read_addr_reg: 0,
            core.read_bank_sel_reg: 0,
            core.read_burst_len: 0,
            core.read_count: 0,
            core.write_state: 0,
            core.write_addr_reg: 0,
            core.write_bank_sel_reg: 0,
        }

    def test_basic_write_then_read(self):
        T = 2
        num_banks = 4
        core = MultiBankBRAMCore(T=T, num_banks=num_banks, name="mbbram")

        reg_map = self._init_reg_map(core)
        mem_map = {
            0: {0: 0xABCD, 1: 0x1234},
            1: {0: 0x0000, 1: 0x0000},
        }

        (
            sim,
            data_in,
            valid_in,
            last_in,
            ready_in,
            read_addr,
            read_bank_sel,
            write_data_in,
            write_valid_in,
            write_last_in,
            write_addr,
            write_bank_sel,
            data_out,
            valid_out,
            last_out,
            ready_out,
            write_ready_out,
        ) = _create_wrapped_sim(core, reg_map=reg_map, mem_map=mem_map)

        outputs = []
        for cycle in range(50):
            if cycle == 0:
                sim.step(
                    {
                        data_in: 0,
                        valid_in: 0,
                        last_in: 0,
                        ready_in: 1,
                        read_addr: 0,
                        read_bank_sel: 0,
                        write_data_in: 0xDEAD,
                        write_valid_in: 1,
                        write_last_in: 1,
                        write_addr: 0,
                        write_bank_sel: 1,
                    }
                )
            elif cycle == 1:
                sim.step(
                    {
                        data_in: 0x02,
                        valid_in: 1,
                        last_in: 1,
                        ready_in: 1,
                        read_addr: 0,
                        read_bank_sel: 1,
                        write_data_in: 0,
                        write_valid_in: 0,
                        write_last_in: 0,
                        write_addr: 0,
                        write_bank_sel: 0,
                    }
                )
            else:
                sim.step(
                    {
                        data_in: 0,
                        valid_in: 0,
                        last_in: 0,
                        ready_in: 1,
                        read_addr: 0,
                        read_bank_sel: 0,
                        write_data_in: 0,
                        write_valid_in: 0,
                        write_last_in: 0,
                        write_addr: 0,
                        write_bank_sel: 0,
                    }
                )

            if sim.inspect(valid_out) == 1:
                outputs.append(sim.inspect(data_out))

            if sim.inspect(core.read_state) == 0 and cycle > 1:
                break

        assert len(outputs) == 2
        assert outputs[0] == 0xDEAD
        assert outputs[1] == 0x0000

    def test_concurrent_read_write_different_banks(self):
        T = 2
        num_banks = 4
        core = MultiBankBRAMCore(T=T, num_banks=num_banks, name="mbbram_conc")

        reg_map = self._init_reg_map(core)
        mem_map = {
            0: {0: 0x1111, 1: 0x2222},
            1: {0: 0x0000, 1: 0x0000},
        }

        (
            sim,
            data_in,
            valid_in,
            last_in,
            ready_in,
            read_addr,
            read_bank_sel,
            write_data_in,
            write_valid_in,
            write_last_in,
            write_addr,
            write_bank_sel,
            data_out,
            valid_out,
            last_out,
            ready_out,
            write_ready_out,
        ) = _create_wrapped_sim(core, reg_map=reg_map, mem_map=mem_map)

        outputs = []
        for cycle in range(50):
            if cycle == 0:
                sim.step(
                    {
                        data_in: 0x02,
                        valid_in: 1,
                        last_in: 1,
                        ready_in: 1,
                        read_addr: 0,
                        read_bank_sel: 0,
                        write_data_in: 0xBEEF,
                        write_valid_in: 1,
                        write_last_in: 1,
                        write_addr: 0,
                        write_bank_sel: 1,
                    }
                )
            elif cycle == 3:
                sim.step(
                    {
                        data_in: 0x02,
                        valid_in: 1,
                        last_in: 1,
                        ready_in: 1,
                        read_addr: 0,
                        read_bank_sel: 1,
                        write_data_in: 0,
                        write_valid_in: 0,
                        write_last_in: 0,
                        write_addr: 0,
                        write_bank_sel: 0,
                    }
                )
            else:
                sim.step(
                    {
                        data_in: 0,
                        valid_in: 0,
                        last_in: 0,
                        ready_in: 1,
                        read_addr: 0,
                        read_bank_sel: 0,
                        write_data_in: 0,
                        write_valid_in: 0,
                        write_last_in: 0,
                        write_addr: 0,
                        write_bank_sel: 0,
                    }
                )

            if sim.inspect(valid_out) == 1:
                outputs.append(sim.inspect(data_out))

            if sim.inspect(core.read_state) == 0 and cycle > 3:
                break

        assert len(outputs) == 4
        assert outputs[0] == 0x1111
        assert outputs[1] == 0x2222
        assert outputs[2] == 0xBEEF
        assert outputs[3] == 0x0000

    def test_bank_arbitration_same_bank(self):
        T = 2
        num_banks = 4
        core = MultiBankBRAMCore(T=T, num_banks=num_banks, name="mbbram_arb")

        reg_map = self._init_reg_map(core)
        mem_map = {
            0: {0: 0xAAAA, 1: 0xBBBB},
        }

        (
            sim,
            data_in,
            valid_in,
            last_in,
            ready_in,
            read_addr,
            read_bank_sel,
            write_data_in,
            write_valid_in,
            write_last_in,
            write_addr,
            write_bank_sel,
            data_out,
            valid_out,
            last_out,
            ready_out,
            write_ready_out,
        ) = _create_wrapped_sim(core, reg_map=reg_map, mem_map=mem_map)

        outputs = []
        for cycle in range(50):
            if cycle == 0:
                sim.step(
                    {
                        data_in: 0x02,
                        valid_in: 1,
                        last_in: 1,
                        ready_in: 1,
                        read_addr: 0,
                        read_bank_sel: 0,
                        write_data_in: 0x9999,
                        write_valid_in: 1,
                        write_last_in: 1,
                        write_addr: 0,
                        write_bank_sel: 0,
                    }
                )
            elif cycle == 1:
                sim.step(
                    {
                        data_in: 0,
                        valid_in: 0,
                        last_in: 0,
                        ready_in: 1,
                        read_addr: 0,
                        read_bank_sel: 0,
                        write_data_in: 0,
                        write_valid_in: 0,
                        write_last_in: 0,
                        write_addr: 0,
                        write_bank_sel: 0,
                    }
                )
            else:
                sim.step(
                    {
                        data_in: 0,
                        valid_in: 0,
                        last_in: 0,
                        ready_in: 1,
                        read_addr: 0,
                        read_bank_sel: 0,
                        write_data_in: 0,
                        write_valid_in: 0,
                        write_last_in: 0,
                        write_addr: 0,
                        write_bank_sel: 0,
                    }
                )

            if sim.inspect(valid_out) == 1:
                outputs.append(sim.inspect(data_out))

            if sim.inspect(core.read_state) == 0 and cycle > 1:
                break

        assert len(outputs) == 2
        assert outputs[0] == 0x9999
        assert outputs[1] == 0xBBBB

    def test_write_burst_with_last_in(self):
        T = 2
        num_banks = 4
        core = MultiBankBRAMCore(T=T, num_banks=num_banks, name="mbbram_burst")

        reg_map = self._init_reg_map(core)
        mem_map = {
            0: {0: 0x0000, 1: 0x0000, 2: 0x0000},
        }

        (
            sim,
            data_in,
            valid_in,
            last_in,
            ready_in,
            read_addr,
            read_bank_sel,
            write_data_in,
            write_valid_in,
            write_last_in,
            write_addr,
            write_bank_sel,
            data_out,
            valid_out,
            last_out,
            ready_out,
            write_ready_out,
        ) = _create_wrapped_sim(core, reg_map=reg_map, mem_map=mem_map)

        for cycle in range(10):
            if cycle == 0:
                sim.step(
                    {
                        data_in: 0,
                        valid_in: 0,
                        last_in: 0,
                        ready_in: 1,
                        read_addr: 0,
                        read_bank_sel: 0,
                        write_data_in: 0x1111,
                        write_valid_in: 1,
                        write_last_in: 0,
                        write_addr: 0,
                        write_bank_sel: 0,
                    }
                )
            elif cycle == 1:
                sim.step(
                    {
                        data_in: 0,
                        valid_in: 0,
                        last_in: 0,
                        ready_in: 1,
                        read_addr: 0,
                        read_bank_sel: 0,
                        write_data_in: 0x2222,
                        write_valid_in: 1,
                        write_last_in: 0,
                        write_addr: 0,
                        write_bank_sel: 0,
                    }
                )
            elif cycle == 2:
                sim.step(
                    {
                        data_in: 0,
                        valid_in: 0,
                        last_in: 0,
                        ready_in: 1,
                        read_addr: 0,
                        read_bank_sel: 0,
                        write_data_in: 0x3333,
                        write_valid_in: 1,
                        write_last_in: 1,
                        write_addr: 0,
                        write_bank_sel: 0,
                    }
                )
            else:
                sim.step(
                    {
                        data_in: 0,
                        valid_in: 0,
                        last_in: 0,
                        ready_in: 1,
                        read_addr: 0,
                        read_bank_sel: 0,
                        write_data_in: 0,
                        write_valid_in: 0,
                        write_last_in: 0,
                        write_addr: 0,
                        write_bank_sel: 0,
                    }
                )

            if cycle > 2 and sim.inspect(core.write_state) == 0:
                break

        assert sim.inspect(core.write_state) == 0

        outputs = []
        for cycle in range(10):
            if cycle == 0:
                sim.step(
                    {
                        data_in: 0x03,
                        valid_in: 1,
                        last_in: 1,
                        ready_in: 1,
                        read_addr: 0,
                        read_bank_sel: 0,
                        write_data_in: 0,
                        write_valid_in: 0,
                        write_last_in: 0,
                        write_addr: 0,
                        write_bank_sel: 0,
                    }
                )
            else:
                sim.step(
                    {
                        data_in: 0,
                        valid_in: 0,
                        last_in: 0,
                        ready_in: 1,
                        read_addr: 0,
                        read_bank_sel: 0,
                        write_data_in: 0,
                        write_valid_in: 0,
                        write_last_in: 0,
                        write_addr: 0,
                        write_bank_sel: 0,
                    }
                )

            if sim.inspect(valid_out) == 1:
                outputs.append(sim.inspect(data_out))

            if sim.inspect(core.read_state) == 0 and cycle > 0:
                break

        assert len(outputs) == 3
        assert outputs[0] == 0x1111
        assert outputs[1] == 0x2222
        assert outputs[2] == 0x3333

    def test_read_stall_recovery(self):
        T = 2
        num_banks = 4
        core = MultiBankBRAMCore(T=T, num_banks=num_banks, name="mbbram_stall")

        reg_map = self._init_reg_map(core)
        mem_map = {
            0: {0: 0xAAAA, 1: 0xBBBB},
        }

        (
            sim,
            data_in,
            valid_in,
            last_in,
            ready_in,
            read_addr,
            read_bank_sel,
            write_data_in,
            write_valid_in,
            write_last_in,
            write_addr,
            write_bank_sel,
            data_out,
            valid_out,
            last_out,
            ready_out,
            write_ready_out,
        ) = _create_wrapped_sim(core, reg_map=reg_map, mem_map=mem_map)

        outputs = []
        for cycle in range(50):
            if cycle == 0:
                sim.step(
                    {
                        data_in: 0x02,
                        valid_in: 1,
                        last_in: 1,
                        ready_in: 0,
                        read_addr: 0,
                        read_bank_sel: 0,
                        write_data_in: 0,
                        write_valid_in: 0,
                        write_last_in: 0,
                        write_addr: 0,
                        write_bank_sel: 0,
                    }
                )
            elif cycle == 1:
                sim.step(
                    {
                        data_in: 0,
                        valid_in: 0,
                        last_in: 0,
                        ready_in: 1,
                        read_addr: 0,
                        read_bank_sel: 0,
                        write_data_in: 0,
                        write_valid_in: 0,
                        write_last_in: 0,
                        write_addr: 0,
                        write_bank_sel: 0,
                    }
                )
            else:
                sim.step(
                    {
                        data_in: 0,
                        valid_in: 0,
                        last_in: 0,
                        ready_in: 1,
                        read_addr: 0,
                        read_bank_sel: 0,
                        write_data_in: 0,
                        write_valid_in: 0,
                        write_last_in: 0,
                        write_addr: 0,
                        write_bank_sel: 0,
                    }
                )

            if sim.inspect(valid_out) == 1:
                outputs.append(sim.inspect(data_out))

            if sim.inspect(core.read_state) == 0 and cycle > 1:
                break

        assert len(outputs) == 2
        assert outputs[0] == 0xAAAA
        assert outputs[1] == 0xBBBB

    def test_invalid_num_banks_raises(self):
        with pytest.raises(ValueError):
            MultiBankBRAMCore(T=2, num_banks=1, name="bad")
        with pytest.raises(ValueError):
            MultiBankBRAMCore(T=2, num_banks=0, name="bad")

    def test_invalid_addr_width_raises(self):
        with pytest.raises(ValueError):
            MultiBankBRAMCore(T=2, addr_width=0, name="bad")
        with pytest.raises(ValueError):
            MultiBankBRAMCore(T=2, addr_width=-1, name="bad")
