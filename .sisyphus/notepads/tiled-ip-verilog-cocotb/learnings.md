## Final Learnings - Tiled IP Verilog & cocotb Verification

### Completed Work
- Created `scripts/export_verilog.py` exporting all 6 IP cores (alu, gemm, norm, softmax, activation, mem_router)
- Created cocotb testbenches for all 6 cores in `tests/cocotb_tests/`
- All 8 cocotb tests pass (alu has 3 parametrized opcodes)
- All 298 existing PyRTL tests still pass (no regressions)

### Known PyRTL-to-Verilator Bugs & Fixes
1. **ALU multiply width**: PyRTL generates `(tmp3 * tmp4)` as 8-bit, Verilator truncates. Fix: insert `wire[15:0] prod16_lower/upper` with explicit assignments.
2. **Softmax ROM index width**: `(softmax_exp_0 + softmax_exp_1)` is 8-bit but 512-entry ROM needs 9-bit index. Fix: insert `wire[8:0] exp_sum`.

### Test Pattern
- pytest wrapper → `cocotb.runner.get_runner("verilator")` → builds Verilog → runs cocotb coroutine
- cocotb coroutine: Clock(10ns) → 5-cycle reset → drive inputs → wait RisingEdge → capture outputs → compare against NumPy reference
- Build caching: `runner.build()` reuses cached dirs; must `rm -rf sim_build/<test_dir>` after Verilog changes

### Signal Naming Convention
PyRTL exports top module as `toplevel`. Core signals are prefixed with core name (e.g., `alu_data_out`, `gemm_valid_out`).

### Running Tests
```bash
# Export all cores
.venv/bin/python scripts/export_verilog.py --all --outdir build/rtl --verilate

# Run cocotb tests
.venv/bin/python -m pytest tests/cocotb_tests/ -v

# Run PyRTL tests
.venv/bin/python -m pytest tests/ -v
```
