# Tiled IP Verilog Generation & cocotb Verification

## 1. Goal & Context
Transition the PyRTL-based tiled IP project from pure PyRTL simulation to standard HDL verification.
We will export the PyRTL designs to Verilog, and use Verilator + cocotb to drive the testbenches. The existing pure-Python tests will remain as the golden reference. Execution of cocotb will be wrapped within the `pytest` runner using `cocotb.runner` to maintain familiar workflows.

**Current State**: Pure Python `pyrtl.Simulation()` testing against NumPy reference models.
**End State**: Generated `.v` files in `build/rtl/`, tested via `cocotb` + `Verilator` driven by `pytest`, starting with the ALU core to prove plumbing.

## 2. Constraints & Guardrails
1. **Read-Only IP**: Do NOT modify the `src/ip_cores/*.py` source logic.
2. **Golden Reference Isolation**: Do NOT delete or modify the existing PyRTL `tests/*.py`. They are the golden behavioral reference.
3. **Plumbing First**: Prove the end-to-end flow on the `ALUCore` before touching complex blocks like GEMM or MemRouter.
4. **Verilator Compatibility**: Verify PyRTL exported Verilog manually compiles (`verilator --cc`) before writing testbenches.

## 3. Architecture & Interfaces
- **AXI4-Stream-Lite**: The interface consists of `data_in`, `valid_in`, `ready_out`, `data_out`, `valid_out`, `ready_in`. We will need to map these to standard cocotb bus drivers or write custom coroutines.
- **Verification Stack**: `pytest` -> `cocotb.runner` (subprocess) -> `Verilator` -> `VPI/DPI` -> `cocotb` (test logic) -> NumPy (golden outputs).

## 4. Implementation Tasks

### Phase 1: Verilog Export & Validation
1. **Create Verilog Export Script** ✅
   - Create `scripts/export_verilog.py` that takes CLI arguments for core selection (defaulting to all).
   - Instantiate `ALUCore` (and others later), call `.block`, and use `pyrtl.OutputToVerilog()` to write to `build/rtl/alu.v`.
   - **QA Scenario:** Run script, then manually run `verilator --cc build/rtl/alu.v` to ensure Verilator can digest PyRTL's output without syntax errors or missing module definitions.

### Phase 2: Cocotb Test Infrastructure Setup
2. **Create Cocotb Test Directory** ✅
   - Create `tests/cocotb_tests/` to isolate the hardware tests from the pure PyRTL `tests/`.
   - Create an empty `__init__.py` and configure `pytest` to pick up this directory if needed, or simply run it directly.

3. **Write ALU Cocotb Testbench** ✅
   - Create `tests/cocotb_tests/test_alu_cocotb.py`.
   - Use `cocotb.runner.get_runner("verilator")` inside a standard `def test_alu_hw():` pytest wrapper.
   - Configure the runner to build `build/rtl/alu.v` and execute a cocotb test module (`alu_testbench.py`).
   - Enable waveform dumping (`--trace-fst` for Verilator) in the build arguments.

### Phase 3: Cocotb Test Logic & Execution
4. **Implement AXI-Lite Handshake & Verification** ✅
   - In `tests/cocotb_tests/alu_testbench.py`, write the `@cocotb.test()` coroutine.
   - Import `alu_ref` from `tests.ref_models.alu_ref` to use as the golden model.
   - Implement coroutines to drive `valid_in`, `data_in`, and monitor `ready_out`.
   - Capture `data_out` on `valid_out` && `ready_in`.
   - Compare captured output against `alu_ref` using `assert` statements.
   - **QA Scenario:** Intentionally feed a wrong `data_in` vector or mutate expected output, verify cocotb reports an assertion failure (proving the test actually checks data).

### Phase 4: Expansion (Ready for Parallel Agents)
5. **Prepare for Parallel Execution** ✅
   - Once ALU passes perfectly via `pytest tests/cocotb_tests/test_alu_cocotb.py`, add the remaining IP cores (`gemm`, `norm`, `softmax`, `activation`, `mem_router`) to `scripts/export_verilog.py`.
   - Update `pyproject.toml` or create documentation on how to run cocotb tests vs pyrtl tests.

## Final Verification Wave

- [x] All verification QA scenarios pass without manual intervention.
- [x] Ensure ALU exported Verilog (`build/rtl/alu.v`) exists.
- [x] Ensure `pytest tests/cocotb_tests/test_alu_cocotb.py -v` executes cleanly and reports 0 failures.
- [x] All 6 IP cores (alu, gemm, norm, softmax, activation, mem_router) export to Verilog and compile with Verilator.
- [x] Check that Verilator waveforms (`.fst` or `.vcd`) are successfully dumped. (Note: `--trace-fst` is passed; waveforms generated in `sim_build/*/dump.fst`)
