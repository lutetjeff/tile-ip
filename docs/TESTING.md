# Testing Framework and Results

This document describes the test organization, patterns, results, and hardware verification setup.

---

## 5.1 Test Organization

| File | What it tests |
|------|---------------|
| `tests/test_axi_stream_base.py` | Base-class handshake logic and block isolation |
| `tests/test_alu.py` | ADD, MULTIPLY, MASK across `T_width ∈ {1,2,4}` |
| `tests/test_activation.py` | GELU & ReLU LUTs across `T_width ∈ {1,2,4}` |
| `tests/test_norm.py` | LayerNorm & RMSNorm across `T_channel ∈ {1,2,4}` |
| `tests/test_softmax.py` | Softmax numerical fidelity across `T_seq ∈ {1,2,4}` |
| `tests/test_gemm.py` | GEMM MAC tree across all `T_M,T_K,T_N ∈ {1,2,4}` combos |
| `tests/test_mem_router.py` | Linear, transpose, stall, and restart patterns |
| `tests/test_fifo.py` | Continuous stream, backpressure, empty read, full write |
| `tests/test_stitcher.py` | 2-IP / 3-IP chains, fan-out, wrapper I/O generation |
| `tests/test_stitcher_fanin.py` | N→1 fan-in verification (ALU with two upstreams) |
| `tests/test_solver.py` | DP solver pruning, area/timing constraints, optimal configs |
| `tests/test_compound_ffn.py` | Norm → Activation → ALU end-to-end |
| `tests/test_compound_attention.py` | GEMM → Softmax → GEMM end-to-end |
| `tests/test_compound_mem_compute.py` | MemRouter → GEMM end-to-end |
| `tests/test_generate_subgraph.py` | JSON → CLI → dynamic import → simulation for FFN & Attention |
| `tests/test_temporal_gemm.py` | Temporal GEMM accumulation and backpressure |
| `tests/test_stateful_norm.py` | 2-pass norm FSM and numerical accuracy |
| `tests/test_stateful_softmax.py` | 3-pass softmax and backpressure |
| `tests/test_multi_bank_bram.py` | Concurrent R/W and bank arbitration |
| `tests/test_transformer_block.py` | Full block deadlock-free PyRTL sim |
| `tests/test_bram_init_export.py` | BRAM init Verilog export |
| `tests/test_ref_models.py` | Sanity checks on NumPy golden models |

### Reference Models (`tests/ref_models/`)

- Pure NumPy implementations of every IP
- Internal arithmetic uses `float32` or `int32` for precision, then re-quantizes to INT8
- Hardware testbenches compare PyRTL simulation traces against these models element-wise

---

## 5.2 Test Patterns

Every core test follows the same pattern:

1. **Random continuous stream:** 10 beats of random INT8 data, run in a tight loop
2. **Edge cases:** all zeros, all `127`, all `-128`, mixed extremes
3. **Partial valid / stall:** some tests assert `ready_in=0` for a cycle to verify stall recovery

---

## 5.3 Test Results & Performance Numbers

All tests are run with `pytest -n auto --timeout=120` (parallel workers, 120 s hard limit).

| Test suite | Tests | Wall time | Notes |
|------------|-------|-----------|-------|
| `test_gemm.py` | 167 | ~0.83 s | All `T_M,T_K,T_N ∈ {1,2,4}` combos + edge cases |
| `test_alu.py` | 45 | ~0.21 s | `T_width ∈ {1,2,4}` × 3 op-codes |
| `test_activation.py` | 25 | ~0.09 s | `T_width ∈ {1,2,4}` × GELU/ReLU |
| `test_norm.py` | 33 | — | `T_channel ∈ {1,2,4}` × LayerNorm/RMSNorm |
| `test_softmax.py` | 19 | ~0.12 s | `T_seq ∈ {1,2,4}` + one-dominant & alternating extremes |
| `test_mem_router.py` | 9 | ~0.18 s | Transpose, linear, stall, restart |
| `test_fifo.py` | 30 | ~0.12 s | `T_width ∈ {1,2,4}` × `depth ∈ {2,4}` |
| `test_stitcher.py` | 26 | — | 2-IP / 3-IP chains, fan-out, wrapper I/O |
| `test_stitcher_fanin.py` | 6 | — | N→1 fan-in verification |
| `test_solver.py` | — | — | All 3 subgraphs solve in **< 1 s** |
| `test_compound_ffn.py` | 24 | ~0.30 s | `T=2,4` × LayerNorm/RMSNorm × GELU/ReLU |
| `test_compound_attention.py` | 2 | ~0.08 s | Random + all-zeros |
| `test_compound_mem_compute.py` | 16 | ~0.18 s | `T_M,T_K,T_N ∈ {1,2}` × random + zeros |
| `test_generate_subgraph.py` | — | — | FFN & Attention JSON → code → sim |
| `test_temporal_gemm.py` | 10 | — | Accumulation, backpressure, requantization |
| `test_stateful_norm.py` | 21 | — | 2-pass FSM, LayerNorm/RMSNorm accuracy |
| `test_stateful_softmax.py` | 8 | — | 3-pass FSM, numerical fidelity |
| `test_multi_bank_bram.py` | 7 | — | Concurrent R/W, bank conflict, burst |
| `test_transformer_block.py` | 1 | — | Full block deadlock-free PyRTL sim |
| `test_bram_init_export.py` | 1 | — | BRAM init Verilog export |

**Full suite:** ~535 tests pass in under **6 seconds** total (well inside the 120 s timeout).

---

## 5.4 Hardware Verification with cocotb + Verilator

In addition to PyRTL simulation, every IP core is exported to synthesizable Verilog and verified against the same NumPy golden reference using **cocotb** driven by **Verilator**.

### Verification Stack

```
pytest → cocotb.runner (subprocess) → Verilator → VPI/DPI → cocotb coroutine → NumPy reference
```

### Test Files (`tests/cocotb_tests/`)

| File | What it tests |
|------|---------------|
| `test_alu_cocotb.py` | ADD, MULTIPLY, MASK across 3 op-codes |
| `test_gemm_cocotb.py` | 2×2 INT8 matrix multiply |
| `test_norm_cocotb.py` | LayerNorm T_channel=2 |
| `test_softmax_cocotb.py` | Softmax T_seq=2 |
| `test_activation_cocotb.py` | ReLU T_width=2 |
| `test_mem_router_cocotb.py` | MemRouter FSM T_out=2 |
| `test_fifo_cocotb.py` | FIFO backpressure T_width ∈ {1,2} |
| `test_transformer_block.py` | End-to-end Verilator verification of full transformer block |

### How It Works

1. `scripts/export_verilog.py` instantiates the PyRTL core, wires dummy `Input` ports to satisfy `output_to_verilog()`, and writes `build/rtl/<core>.v`
2. The script applies post-processing fixes for known PyRTL→Verilator width bugs
3. Each pytest wrapper calls `cocotb.runner.get_runner("verilator")` to compile the Verilog with `--trace-fst -Wno-fatal`
4. The cocotb coroutine drives `clk` (10 ns period), asserts `rst` for 5 cycles, then pushes AXI4-Stream-Lite beats and captures outputs
5. Captured outputs are unpacked from little-endian bytes and compared against the same `tests.ref_models.*` golden models

### Running Hardware Tests

```bash
# Export all cores to Verilog
python scripts/export_verilog.py --all --outdir build/rtl --verilate

# Run cocotb tests only
pytest tests/cocotb_tests/ -v

# Run everything (PyRTL + cocotb)
pytest tests/ -v --timeout=120
```

### Waveforms

Verilator dumps `.fst` files to `sim_build/<test_name>/dump.fst` for GTKWave inspection.

---

## 5.5 Quantization Tolerance

Because the hardware uses fixed-point LUTs instead of floating-point math, small numerical differences are expected:

| Core | Tolerance | Source of error |
|------|-----------|-----------------|
| GEMM | exact (bit-for-bit) | 32-bit accumulate + deterministic clip |
| ALU (ADD) | exact | Wraparound matches NumPy int8 |
| ALU (MUL) | exact | Upper 8 bits of signed product |
| Activation (ReLU) | exact | Straight-through LUT |
| Activation (GELU) | `atol = 5` | Fixed-point tanh approximation |
| Softmax | `atol = 1` | Fixed-point division `>> 16` |
| Norm | `atol = 3–5` | Piecewise LUT approximation of `1/√x` |
| Compound FFN (ReLU) | `atol = 5` | Error does not accumulate visibly |
| Compound FFN (GELU) | `atol = 5` | Norm approximation + fixed-point GELU |
| Compound Attention | `atol = 1` for Softmax, exact for GEMMs | Same sources as unit tests |

---

## Further Reading

- [GETTING_STARTED.md](GETTING_STARTED.md) — Quick-start examples
- `tests/` — All test files
- `tests/ref_models/` — NumPy golden reference models
- `tests/cocotb_tests/` — Hardware verification tests
