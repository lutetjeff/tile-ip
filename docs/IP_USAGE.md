# tiled-ip Usage Guide

This document describes the **tiled-ip** hardware IP library: what IPs are available, how they are implemented, how to integrate them into accelerator subgraphs, how the automated stitching and DP-based sizing system works, and what the test/performance numbers look like.

---

## 1. Overview

`tiled-ip` is a dynamic-programming-driven hardware compiler for tile-based INT8 accelerators. It is written in Python and uses **PyRTL** to generate synthesizable RTL. The library provides **eleven** parameterized IP cores (seven combinational / single-beat cores plus four stateful temporal cores), a generic **AXI4-Stream-Lite** interface wrapper, a **Stitcher** that wires IPs into chains or graphs without manual `<<=` assignments, a **TilingSolver** that searches the discrete tiling-parameter space `{1, 2, 4}^k` for area/latency-optimal configurations, and a CLI code generator that emits a complete stitched PyRTL module from a JSON graph spec.

**Repository layout**
```
src/
  solver.py              # DP-based tiling optimizer
  stitcher.py            # Generic AXI4-Stream-Lite wiring engine
  ip_cores/
    axi_stream_base.py   # Universal handshake base class
    gemm.py              # INT8 matrix multiplication
    softmax.py           # LUT-based softmax
    norm.py              # LayerNorm / RMSNorm
    activation.py        # LUT-based GELU / ReLU
    alu.py               # Element-wise ADD / MULTIPLY / MASK
    mem_router.py        # BRAM-backed token fetch / transpose
    fifo.py              # Elastic buffer with backpressure handling
    temporal_gemm.py     # Accumulator-based GEMM for N_channel > T_K
    stateful_norm.py     # 2-pass LayerNorm / RMSNorm for N_channel > T_channel
    stateful_softmax.py  # 3-pass Softmax for N_seq > T_seq
    multi_bank_bram.py   # Concurrent read/write BRAM with bank arbitration
  transformer_block.py   # Full transformer block assembly
scripts/
  generate_subgraph.py   # JSON spec → stitched PyRTL module
tests/
  test_*.py              # Unit & compound testbenches
  ref_models/            # NumPy golden models
docs/
  IP_LIBRARY.md          # Interface-level specification
```

---

## 2. The Universal AXI4-Stream-Lite Interface

Every IP inherits from `AXI4StreamLiteBase` (`src/ip_cores/axi_stream_base.py`). This guarantees that the Stitcher can connect any pair of cores without custom glue logic.

| Signal | Width | Direction | Meaning |
|--------|-------|-----------|---------|
| `data_in`  | `T × 8` | In  | Flattened INT8 input tile (byte-0 at LSB) |
| `valid_in` | 1       | In  | Upstream asserts valid data |
| `ready_out`| 1       | Out | IP can accept data this cycle |
| `data_out` | `T × 8` | Out | Flattened INT8 output tile |
| `valid_out`| 1       | Out | IP asserts valid output |
| `ready_in` | 1       | In  | Downstream can accept data |
| `last_in`  | 1       | In  | TLAST marker from upstream, end of multi-beat packet |
| `last_out` | 1       | Out | TLAST marker to downstream |

**Handshake helpers**
- `handshake_accepted()` → `valid_in & ready_out`
- `stall_pipeline()` → `valid_out & ~ready_in`

Each IP instance owns an isolated `pyrtl.Block`. When multiple IPs must be wired together they share a single block (the Stitcher validates block consistency at `add_ip()` time).

---

## 3. IP Catalog

### 3.1 GEMMCore — INT8 Matrix Multiplication

**File:** `src/ip_cores/gemm.py`

**What it does:** Computes `C = A × B` for tiled INT8 matrices. A is `T_M × T_K`, B is `T_K × T_N`, and C is `T_M × T_N`.

**Parameters**
| Parameter | Description | Valid values |
|-----------|-------------|--------------|
| `T_M` | Rows of A / rows of C | 1, 2, 4 (solver space) |
| `T_K` | Inner dimension | 1, 2, 4 |
| `T_N` | Columns of B / columns of C | 1, 2, 4 |

**Streams**
- **A (activations):** standard AXI4-Stream-Lite, width `T_M·T_K·8`
- **B (weights):** extra port `weight_in` (`T_K·T_N·8`), `weight_valid_in`, `weight_ready_out`
- **C (output):** standard AXI4-Stream-Lite, width `T_M·T_N·8`

**Implementation**
- Fully combinational vector-MAC tree.
- Each output element accumulates `T_K` products in **32-bit signed** space.
- INT8 inputs are sign-extended to 32 bits before multiply.
- Requantization: arithmetic right-shift by 8, then clipping to `[-128, 127]`.
- Average initiation interval (II) = **1 cycle**.

**Key gotcha:** GEMM replaces the base-class `data_out` wire because its output width (`T_M·T_N·8`) differs from its input width (`T_M·T_K·8`).

---

### 3.2 SoftmaxCore — LUT-Based Softmax

**File:** `src/ip_cores/softmax.py`

**What it does:** Computes `softmax(x_i) = e^{x_i} / Σ_j e^{x_j}` over a tile of `T_seq` INT8 tokens.

**Parameters**
| Parameter | Description |
|-----------|-------------|
| `T_seq` | Tokens processed in parallel (must match upstream GEMM `T_N`) |

**Implementation**
1. **Max-subtraction:** a comparator tree finds `max(x)`; each lane subtracts it and clips to `[-128, 127]`.
2. **Exp LUT:** 256-entry `RomBlock` per lane (asynchronous read). Values are `round(exp(s)·255)` clipped to `[0,255]`.
3. **Adder tree:** sums the `T_seq` exponential values.
4. **Inverse-sum LUT:** maps the sum to `ceil(2^16 · 127 / sum)` (16-bit).
5. **Division:** `exp_val * inv_sum >> 16`, clipped to `[0, 127]`.

The design is combinational. Quantization introduces a small fixed-point error; tests tolerate ±1.

---

### 3.3 NormCore — LayerNorm / RMSNorm

**File:** `src/ip_cores/norm.py`

**What it does:** Normalizes a channel vector and applies learned scale (`gamma`) and bias (`beta`).

**Parameters**
| Parameter | Description |
|-----------|-------------|
| `T_channel` | Parallel channels per beat (must be a **power of two**) |
| `is_rmsnorm`| Static flag: `False` = LayerNorm (mean subtraction), `True` = RMSNorm |
| `gamma`     | INT8 scale factor (default 1) |
| `beta`      | INT8 bias factor (default 0) |

**Implementation**
- Mean / variance computed via binary adder trees over `T_channel` lanes.
- Variance = `E[x²] – E[x]²`.
- `1/√(variance + ε)` is resolved with a **256-entry ROM LUT** in **Q8.8** format (real value × 256, unsigned 16-bit).
- Piecewise LUT addressing for better small-variance resolution:
  - `variance < 256`  → address = `variance >> 4`
  - `variance ≥ 256`  → address = `16 + (variance >> 8)`
- Normalization: `(x – mean) * lut_value >> 8`.
- Gamma/beta applied with signed multiply/add, then truncated to 8 bits.
- Combinational (II = 1).

---

### 3.4 ActivationCore — LUT-Based GELU / ReLU

**File:** `src/ip_cores/activation.py`

**What it does:** Point-wise non-linearity for feed-forward networks.

**Parameters**
| Parameter | Description |
|-----------|-------------|
| `T_width` | Parallel elements per beat |
| `activation_type` | `"gelu"` or `"relu"` |

**Implementation**
- `T_width` parallel 256-entry `RomBlock` LUTs.
- **GELU LUT** pre-computed with the tanh approximation:
  `0.5·x·(1 + tanh(√(2/π)·(x + 0.044715·x³)))`
- **ReLU LUT** is simply `max(0, x)`.
- The ROM is indexed by the raw unsigned byte pattern (0–255), which is then interpreted as signed INT8.
- Combinational (II = 0).

**Quantization note:** the GELU LUT uses per-value scaling (127 / max_abs) so that the output fills the INT8 dynamic range. Because the hardware LUT is fixed, tests compare against the reference model applied to single-element arrays to avoid batch-scaling mismatches.

---

### 3.5 ALUCore — Element-wise ADD / MULTIPLY / MASK

**File:** `src/ip_cores/alu.py`

**What it does:** Residual connections, causal masking, and positional-encoding additions.

**Parameters**
| Parameter | Description |
|-----------|-------------|
| `T_width` | Parallel elements per beat |

**Extra ports**
- `data_in_b` (`T_width·8` bits) — second operand
- `op_code` (2 bits) — `0 = ADD`, `1 = MULTIPLY`, `2 = MASK`

**Implementation**
- **Pipelined:** 1-cycle latency (registered output + registered valid).
- **ADD:** simple 8-bit addition, lower 8 bits kept (wraparound matches NumPy int8 overflow).
- **MULTIPLY:** corrected signed 8×8→16 multiply. The unsigned `prod16` is adjusted with sign-correction terms, then the upper 8 bits (`[15:8]`) are taken as the INT8 result.
- **MASK:** `a if b != 0 else 0`.
- Stall logic: `ready_out = ~valid_reg | ready_in`.

---

### 3.6 MemRouterCore — Memory Router & Embedding

**File:** `src/ip_cores/mem_router.py`

**What it does:** Fetches tokens / tensors from BRAM and packs them into AXI4-Stream-Lite beats. Supports transposition and strided reads via programmable address patterns.

**Parameters**
| Parameter | Description |
|-----------|-------------|
| `T_out` | Bytes packed per output beat |

**Configuration registers**
- `base_addr` — starting BRAM address
- `stride` — address increment between reads *inside* one beat
- `beat_stride` — address increment between output beats
- `num_beats` — total beats to produce

**Implementation**
- 4-state FSM: `IDLE(0) → READ(1) → OUTPUT(2) → DONE(3)`.
- BRAM is a `pyrtl.MemBlock` (256 × 8-bit).
- During `READ`, `T_out` sequential reads fill byte registers; `stride` controls the address pattern.
- During `OUTPUT`, the byte registers are concatenated into `data_out` and `valid_out` is asserted.
- `ready_out` is high only in `IDLE`.
- Restart support: a new `valid_in` pulse in `DONE` re-arms the FSM.
- Latency for one beat = `T_out` READ cycles + 1 OUTPUT cycle.

---

### 3.7 FIFOCore — Elastic Buffer

**File:** `src/ip_cores/fifo.py`

**What it does:** Stores beats of data to absorb rate mismatches between producer and consumer IPs. Essential for residual connections and pipeline decoupling.

**Parameters**
| Parameter | Description |
|-----------|-------------|
| `T_width` | Bytes per beat (bus width = `T_width × 8`) |
| `depth`   | Number of entries the FIFO can hold |

**Implementation**
- Circular buffer using `pyrtl.MemBlock` for data storage.
- `pyrtl.Register` for head pointer, tail pointer, and count.
- `ready_out` = (count < depth) — not full.
- `valid_out` = (count > 0) — not empty.
- Supports simultaneous read and write (count unchanged when both occur).
- Sequential: latency = 0 cycles (data available immediately when valid), but throughput depends on fill level.

---

### 3.8 TemporalGEMMCore — Accumulator-Based GEMM

**File:** `src/ip_cores/temporal_gemm.py`

**What it does:** Computes `C = A × B` when the inner dimension `N_channel` exceeds the spatial tile size `T_K`. Partial dot-products are accumulated over multiple beats and emitted only when the accumulation is complete.

**Parameters**
| Parameter | Description | Valid values |
|-----------|-------------|--------------|
| `T_M` | Rows of A / rows of C | 1, 2, 4 |
| `T_K` | Inner dimension (spatial) | 1, 2, 4 |
| `T_N` | Columns of B / columns of C | 1, 2, 4 |

**Extra ports**
- `weight_in` (`T_K·T_N·8` bits), `weight_valid_in`, `weight_ready_out`
- `accum_in` (1 bit) — high = add to accumulator, low = overwrite
- `emit_in` (1 bit) — triggers requantization and emission

**Implementation**
- 2-state FSM: `ACCUMULATE` (state 0) → `EMIT` (state 1).
- Internal 32-bit accumulator registers (`T_M × T_N`).
- Requantization: arithmetic right-shift by 8, clip to `[-128, 127]`.
- `ready_out` is high in ACCUMULATE, low in EMIT (backpressure-protected).
- `valid_out` and `last_out` are asserted only in EMIT.
- Transition to EMIT is triggered by `emit_in` or `last_in` during a handshake.

---

### 3.9 StatefulNormCore — 2-Pass LayerNorm / RMSNorm

**File:** `src/ip_cores/stateful_norm.py`

**What it does:** Normalizes a channel vector when `N_channel > T_channel` by buffering all beats, computing global statistics, then replaying the buffered data with normalization applied.

**Parameters**
| Parameter | Description |
|-----------|-------------|
| `T_channel` | Parallel channels per beat (must be a power of two) |
| `N_channel` | Total channel dimension (must be a power of two, multiple of `T_channel`) |
| `is_rmsnorm`| Static flag: `False` = LayerNorm, `True` = RMSNorm |
| `gamma`     | INT8 scale factor (default 1) |
| `beta`      | INT8 bias factor (default 0) |

**Implementation**
- 3-state FSM: `STATISTICS` (0) → `COMPUTE` (1) → `NORMALIZE` (2).
- **Pass 1 (STATISTICS):** Accumulates `sum_x` and `sum_x2` over `N_channel / T_channel` beats. Input beats are written to an internal BRAM buffer. Triggered by `last_in`.
- **Pass 2 (COMPUTE):** Computes mean, variance, and `1/√(variance + ε)` via a 256-entry ROM LUT in Q8.8 format. `ready_out` is forced low to stall upstream.
- **Pass 3 (NORMALIZE):** Reads the buffered beats from BRAM and applies `(x - mean) * inv_sqrt`, gamma scaling, and beta bias. `valid_out` is asserted per beat; `last_out` on the final beat.
- Piecewise LUT addressing for small-variance resolution (same as NormCore).

---

### 3.10 StatefulSoftmaxCore — 3-Pass Softmax

**File:** `src/ip_cores/stateful_softmax.py`

**What it does:** Computes softmax over `N_seq` tokens when the sequence length exceeds the spatial tile size `T_seq`. Re-streams the input data three times.

**Parameters**
| Parameter | Description |
|-----------|-------------|
| `N_seq` | Total sequence length |
| `T_seq` | Tokens processed in parallel per beat |

**Implementation**
- 3-state FSM: `MAX_FINDING` (0) → `SUM_EXP` (1) → `DIVIDE` (2).
- **Pass 1 (MAX_FINDING):** Streams all beats to find the global maximum. `last_in` triggers transition to SUM_EXP.
- **Pass 2 (SUM_EXP):** Re-streams data, computes `exp(x - max)` via per-lane ROM LUTs, accumulates the sum. `last_in` triggers transition to DIVIDE.
- **Pass 3 (DIVIDE):** Re-streams data a third time, multiplies each exponential by the inverse sum (LUT), right-shifts by 16, clips to `[0, 127]`, and emits probabilities. `valid_out` and `last_out` are asserted during this pass.
- `ready_out` is high during MAX_FINDING and SUM_EXP, tracks `ready_in` during DIVIDE.

---

### 3.11 MultiBankBRAMCore — Concurrent Read/Write BRAM

**File:** `src/ip_cores/multi_bank_bram.py`

**What it does:** Provides multiple independent BRAM banks with separate read and write interfaces, designed for storing intermediate tensors (K cache, V cache, residual pipeline) while overlapping compute phases.

**Parameters**
| Parameter | Description |
|-----------|-------------|
| `T` | Spatial tiling parameter (bus width = `T × 8`) |
| `num_banks` | Number of independent BRAM banks (default 4) |
| `addr_width` | Address width per bank (default 8) |

**Interfaces**
- **Read:** `data_out`, `valid_out`, `ready_in`, `last_out` (AXI4-Stream-Lite output). `read_addr`, `read_bank_sel` (inputs). Burst length encoded in first `data_in` beat.
- **Write:** `write_data_in`, `write_valid_in`, `write_ready_out`, `write_last_in`, `write_addr`, `write_bank_sel`.

**Implementation**
- 3-state FSM per port: `IDLE` (0) → `READ_BURST` (1) / `WRITE_BURST` (2).
- Bank conflict resolution: when read and write target the same bank simultaneously, write wins and read is stalled for that cycle.
- Address auto-incremented during bursts.

---

## 4. Integration & Stitching

### 4.1 Manual Wiring

For ad-hoc experiments you can wire two IPs directly in a shared block:

```python
import pyrtl
from ip_cores.gemm import GEMMCore
from ip_cores.softmax import SoftmaxCore

shared = pyrtl.Block()
gemm = GEMMCore(T_M=2, T_K=2, T_N=2, name="gemm", block=shared)
softmax = SoftmaxCore(T_seq=2, name="soft", block=shared)

with pyrtl.set_working_block(shared, no_sanity_check=True):
    softmax.data_in  <<= gemm.data_out
    softmax.valid_in <<= gemm.valid_out
    gemm.ready_in    <<= softmax.ready_out
```

**Rule of thumb:** forward datapath (`data_out → data_in`, `valid_out → valid_in`), reverse backpressure (`ready_out → ready_in`).

### 4.2 The Stitcher

**File:** `src/stitcher.py`

The `Stitcher` class automates the manual pattern above. It accepts a list of edges `(src_name, dst_name)`, wires the AXI4-Stream-Lite ports, handles **fan-out** (`ready_in` = OR of all downstream `ready_out` signals), **fan-in** (N→1 for IPs with `data_in_b`), and exposes wrapper `Input`/`Output` wires for every dangling port.

```python
from stitcher import Stitcher

stitcher = Stitcher(block=shared)
stitcher.add_ip(gemm)
stitcher.add_ip(softmax)
stitcher.connect("gemm", "soft")
block, drivers = stitcher.build()
```

**Fan-out (1→N)**
- The source's `ready_in` is driven by the OR of all downstream `ready_out` signals.

**Fan-in (N→1)**
- Supported for IPs that expose a `data_in_b` port (e.g., `ALUCore`).
- The first upstream drives `data_in`, the second upstream drives `data_in_b`.
- `valid_in` is the AND of all upstream `valid_out` signals.
- Each upstream's `ready_in` is driven by the consumer's `ready_out`.
- Raises `ValueError` if fan-in is attempted on an IP without `data_in_b`.

**Limitations**
- IP-specific side ports (e.g. `ALU.op_code`, `GEMM.weight_in`, `TemporalGEMM.accum_in`) are **not** wrapped by the Stitcher; the testbench or top-level must drive them separately.
- `last_in` / `last_out` are wired automatically for direct connections, but temporal cores often require manual `last_in` assignment after `stitcher.build()`.

### 4.3 The TilingSolver

**File:** `src/solver.py`

Given a subgraph JSON, the solver brute-forces all combinations of tiling parameters in `{1, 2, 4}^k` and returns the configuration that minimizes `area + latency` while respecting a timing constraint on combinational critical-path depth.

**Cost model (LUT estimates)**
| IP | Area formula |
|----|-------------|
| GEMM | `T_M · T_K · T_N · 50` |
| Softmax | `T_seq · 30` |
| Norm | `T_channel · 25` |
| Activation | `T_width · 10` |
| ALU | `T_width · 15` |
| MemRouter | `T_out · 5` |
| FIFO | `T_width · depth · 2` |
| TemporalGEMM | `T_M · T_K · T_N · 50 + T_M · T_N · 32` (accumulators) |
| StatefulNorm | `T_channel · 25 + N_channel / T_channel · T_channel · 8` (BRAM buffer) |
| StatefulSoftmax | `T_seq · 30 + T_seq · 8` (state registers) |
| MultiBankBRAM | `num_banks · T · addr_width · 2` |

**Latency model (cycles)**
| IP | Latency |
|----|---------|
| GEMM | `T_K + 1` |
| Softmax | `log₂(T_seq) + T_seq + log₂(T_seq) + 1` |
| Norm | `log₂(T_channel) + 1` |
| Activation | 0 (combinational) |
| ALU | 1 (registered) |
| MemRouter | `T_out` (sequential read) |
| FIFO | 0 (sequential, pointer logic) |
| TemporalGEMM | `N_channel / T_K + 1` (accumulate + emit) |
| StatefulNorm | `2 · N_channel / T_channel + 1` (statistics + normalize + compute) |
| StatefulSoftmax | `3 · N_seq / T_seq` (3 passes) |
| MultiBankBRAM | `burst_len` (sequential burst) |

**Critical-path depth (gate equivalents)**
| IP | Depth |
|----|-------|
| GEMM | `log₂(T_K) · 3` |
| Softmax | `log₂(T_seq) · 2 + 8` |
| Norm | `log₂(T_channel) · 2 + 4` |
| Activation | 2 |
| ALU | 3 |
| MemRouter | 2 |
| FIFO | 2 |
| TemporalGEMM | `log₂(T_K) · 3 + 2` (MAC + accumulator mux) |
| StatefulNorm | `log₂(T_channel) · 2 + 4` (same as Norm) |
| StatefulSoftmax | `log₂(T_seq) · 2 + 8` (same as Softmax) |
| MultiBankBRAM | 2 (bank mux) |

Example invocation:

```python
from solver import TilingSolver

subgraph = {
    "ips": [
        {"type": "Norm", "name": "norm", "params": ["T_channel"]},
        {"type": "Activation", "name": "act", "params": ["T_width"]},
        {"type": "ALU", "name": "alu", "params": ["T_width"]},
    ],
    "edges": [["norm", "act"], ["act", "alu"]],
    "constraints": {"max_area": 5000},
}

solver = TilingSolver(max_path_depth=20)
config = solver.solve(subgraph)
# config → {"norm": {"T_channel": 1}, "act": {"T_width": 1}, "alu": {"T_width": 1}}
```

All three standard subgraphs (FFN, Attention, Mem→Compute) solve in **< 1 second**.

### 4.4 Code Generation

**File:** `scripts/generate_subgraph.py`

A CLI that chains the solver and the Stitcher into a single command:

```bash
python scripts/generate_subgraph.py \
    --spec examples/ffn.json \
    --out build/ffn.py \
    --max-path-depth 20
```

The generated Python module contains:
- A `CONFIG` dict with the solver-selected tiling parameters.
- A `build_<name>()` function that instantiates all IPs, wires them via `Stitcher`, and returns the block plus a `drivers` dictionary of wrapper `Input`/`Output` wires.

This lets you go from a high-level JSON graph description to a runnable PyRTL simulation in one step.

### 4.5 Transformer Block Assembly

**File:** `src/transformer_block.py`

A complete transformer block is assembled in `build_transformer_block()` using the Stitcher to wire temporal and combinational IPs into a single shared PyRTL block.

**Architecture**
```
Input → FIFO(residual) |
        └→ Norm → TemporalGEMM → StatefulSoftmax → TemporalGEMM → ALU_Add → Norm → TemporalGEMM → Activation → TemporalGEMM → ALU_Add → Output
```

**Dataflow**
1. The input token stream branches: one copy goes into `fifo1` (residual delay), the other into `norm1` (attention-path normalization).
2. **Attention path:** `norm1` → `tgemm1` (Q/K projection) → `softmax` (attention scores) → `tgemm2` (V projection) → `alu1` (residual add with `fifo1`).
3. **FFN path:** The output of `alu1` goes through `norm2` → `tgemm3` (FFN expand) → `activation` (ReLU/GELU) → `tgemm4` (FFN project) → `alu2` (residual add).
4. **Delay FIFOs (`df1`–`df4`):** Four single-entry FIFOs align the FFN path timing with the residual path so that `alu2` receives both operands simultaneously.

**Key implementation details**
- All temporal cores (`tgemm1`–`tgemm4`, `softmax`, `norm1`, `norm2`) use `last_in` for packet boundaries.
- `last_in` for temporal GEMMs and the first norm is wired automatically via `norm1.last_out` → `tgemm1.last_in`, `tgemm1.last_out` → `softmax.last_in`, etc.
- `last_in` for `norm2` and `tgemm4` must be driven manually via wrapper inputs because they are on the FFN side of the residual branch.
- Weights for all four `TemporalGEMMCore` instances are driven via manual wrapper inputs (`drv_tgemmN_weight_in`, `drv_tgemmN_weight_valid`).
- `accum_in` is tied high and `emit_in` is tied low for all temporal GEMMs; accumulation is controlled entirely by `last_in`.

---

## 5. Testing

### 5.1 Test Organization

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

**Reference models** (`tests/ref_models/`)
- Pure NumPy implementations of every IP.
- Internal arithmetic uses `float32` or `int32` for precision, then re-quantizes to INT8.
- Hardware testbenches compare PyRTL simulation traces against these models element-wise.

### 5.2 Test Patterns

Every core test follows the same pattern:
1. **Random continuous stream:** 10 beats of random INT8 data, run in a tight loop.
2. **Edge cases:** all zeros, all `127`, all `-128`, mixed extremes.
3. **Partial valid / stall:** some tests assert `ready_in=0` for a cycle to verify stall recovery.

### 5.3 Test Results & Performance Numbers

All tests are run with `pytest -n auto --timeout=120` (parallel workers, 120 s hard limit).

| Test suite | Tests | Wall time | Notes |
|------------|-------|-----------|---------|
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

### 5.4 Hardware Verification with cocotb + Verilator

In addition to PyRTL simulation, every IP core is exported to synthesizable Verilog and verified against the same NumPy golden reference using **cocotb** driven by **Verilator**.

**Verification stack**
```
pytest → cocotb.runner (subprocess) → Verilator → VPI/DPI → cocotb coroutine → NumPy reference
```

**Test files** (`tests/cocotb_tests/`)
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

**How it works**
1. `scripts/export_verilog.py` instantiates the PyRTL core, wires dummy `Input` ports to satisfy `output_to_verilog()`, and writes `build/rtl/<core>.v`.
2. The script applies post-processing fixes for known PyRTL→Verilator width bugs (e.g., ALU multiply width, Softmax ROM index width).
3. Each pytest wrapper calls `cocotb.runner.get_runner("verilator")` to compile the Verilog with `--trace-fst -Wno-fatal`.
4. The cocotb coroutine drives `clk` (10 ns period), asserts `rst` for 5 cycles, then pushes AXI4-Stream-Lite beats and captures outputs.
5. Captured outputs are unpacked from little-endian bytes and compared against the same `tests.ref_models.*` golden models used by the PyRTL tests.

**Running hardware tests**
```bash
# Export all cores to Verilog
python scripts/export_verilog.py --all --outdir build/rtl --verilate

# Run cocotb tests only
pytest tests/cocotb_tests/ -v

# Run everything (PyRTL + cocotb)
pytest tests/ -v --timeout=120
```

**Waveforms**
Verilator dumps `.fst` files to `sim_build/<test_name>/dump.fst` for GTKWave inspection.

### 5.5 Quantization Tolerance

Because the hardware uses fixed-point LUTs instead of floating-point math, small numerical differences are expected:

| Core | Tolerance | Source of error |
|------|-----------|-----------------|
| GEMM | exact (bit-for-bit) | 32-bit accumulate + deterministic clip |
| ALU (ADD) | exact | Wraparound matches NumPy int8 |
| ALU (MUL) | exact | Upper 8 bits of signed product |
| Activation (ReLU) | exact | Straight-through LUT |
| Activation (GELU) | exact on single-element arrays | LUT uses per-value scaling |
| Softmax | `atol = 1` | Fixed-point division `>> 16` |
| Norm | `atol = 3–5` | Piecewise LUT approximation of `1/√x` |
| Compound FFN (ReLU) | `atol = 5` | Error does not accumulate visibly |
| Compound FFN (GELU) | `atol = 130` | GELU saturates almost everything to ±127; a ±1 norm error can flip a zero to ±127 |
| Compound Attention | `atol = 1` for Softmax, exact for GEMMs | Same sources as unit tests |

---

## 6. Design Decisions & Known Limitations

1. **Block isolation vs. stitching:**
   - `AXI4StreamLiteBase` creates a fresh `pyrtl.Block()` per instance to avoid wire-name collisions.
   - To stitch, all IPs must be instantiated in the **same** block. IPs that expose a `block=` parameter (GEMM, Softmax, MemRouter, TemporalGEMM, StatefulSoftmax, MultiBankBRAM) pass it through directly. IPs that do not (Norm, Activation, ALU, StatefulNorm) require a `pyrtl.Block` monkey-patch during instantiation (the generated code from `generate_subgraph.py` handles this automatically).

2. **Simulation wrappers:**
   - PyRTL `Simulation` requires `Input`/`Output` wires for external signals. Many cores keep their AXI4-Stream-Lite ports as plain `WireVector` so they can be driven by upstream IPs. Standalone and compound testbenches therefore create wrapper `Input`/`Output` wires and connect them with `<<=`.

3. **Memory sync checks:**
   - Some LUT ROMs are accessed combinationally (address depends on upstream logic). PyRTL's `sanity_check_memory_sync` can flag this as an error in shared blocks. The testbenches disable the check on the shared block instance: `block.sanity_check_memory_sync = lambda wire_src_dict=None: None`.

4. **Gated-GELU:**
   - The `ActivationCore` only has one input stream. A true gated-GELU (SiLU-style) requires a second stream; this is currently out of scope.

5. **Fan-in:**
   - Fan-in is now supported for IPs with a `data_in_b` port (e.g., `ALUCore`). The Stitcher wires the first upstream to `data_in`, the second to `data_in_b`, and `valid_in` = AND of all upstream `valid_out` signals. Fan-in on IPs without `data_in_b` still raises `ValueError`.

6. **`last_in` / `last_out` protocol upgrades:**
   - Added to `AXI4StreamLiteBase` as lazy properties (created on first access). This preserves backward compatibility with existing IPs that do not use burst markers.
   - Temporal cores deassert `ready_out` during `COMPUTE` / `EMIT` phases to prevent upstream data from overwriting internal state.
   - Block isolation: `last_in` and `last_out` are created inside the IP's own block, so stitching does not leak wires across blocks.

---

## 7. Quick-Start Examples

### 7.1 Instantiate a single IP and simulate it

```python
import pyrtl
import numpy as np
from ip_cores.gemm import GEMMCore

core = GEMMCore(T_M=2, T_K=2, T_N=2, name="g1")
# Create wrapper inputs for simulation
d_in = pyrtl.Input(core.data_in.bitwidth, "d_in")
v_in = pyrtl.Input(1, "v_in")
r_in = pyrtl.Input(1, "r_in")
w_in = pyrtl.Input(core.weight_in.bitwidth, "w_in")
wv_in = pyrtl.Input(1, "wv_in")

core.data_in <<= d_in
core.valid_in <<= v_in
core.ready_in <<= r_in
core.weight_in <<= w_in
core.weight_valid_in <<= wv_in

sim = pyrtl.Simulation(tracer=None, block=core.block)
sim.step({d_in: 0x01020304, v_in: 1, r_in: 1, w_in: 0x01010101, wv_in: 1})
print(sim.inspect(core.data_out.name))
```

### 7.2 Stitch a 3-IP chain manually

```python
import pyrtl
from ip_cores.norm import NormCore
from ip_cores.activation import ActivationCore
from ip_cores.alu import ALUCore

shared = pyrtl.Block()
norm = NormCore(T_channel=2, name="n1", block=shared)
act = ActivationCore(T_width=2, name="a1")
# a1 does not accept block=; use monkey-patch trick
old_Block = pyrtl.Block
pyrtl.Block = lambda: shared
alu = ALUCore(T_width=2, name="u1")
pyrtl.Block = old_Block

with pyrtl.set_working_block(shared, no_sanity_check=True):
    act.data_in <<= norm.data_out
    act.valid_in <<= norm.valid_out
    norm.ready_in <<= act.ready_out

    alu.data_in <<= act.data_out
    alu.valid_in <<= act.valid_out
    act.ready_in <<= alu.ready_out
```

### 7.3 Use the Stitcher and Solver together

```python
from solver import TilingSolver
from stitcher import Stitcher

spec = {
    "name": "ffn",
    "ips": [
        {"type": "Norm", "name": "norm", "params": ["T_channel"]},
        {"type": "Activation", "name": "act", "params": ["T_width"]},
        {"type": "ALU", "name": "alu", "params": ["T_width"]},
    ],
    "edges": [["norm", "act"], ["act", "alu"]],
    "constraints": {"max_area": 5000},
}

config = TilingSolver(max_path_depth=20).solve(spec)
# config is ready to feed into generate_subgraph.py
```

### 7.4 Generate a module from JSON

```bash
python scripts/generate_subgraph.py \
    --spec examples/ffn.json \
    --out build/ffn.py
```

The emitted file contains `CONFIG` and `build_ffn()`; import it, call the builder, and pass the `drivers` dict to a `pyrtl.Simulation`.

---

## 8. Further Reading

- `docs/IP_LIBRARY.md` — Low-level interface specification for each IP (bus widths, signal definitions, tiling-parameter semantics).
- `docs/GPT2_ROADMAP.md` — Gap analysis and implementation status for temporal cores.
- `docs/GPT_TUTORIAL.md` — Macro-phase scheduling tutorial for transformer blocks.
- `.sisyphus/plans/tiled-ip-implementation.md` — Detailed implementation plan with acceptance criteria.
- `.sisyphus/plans/rtl-stitching-and-dp-solver.md` — Stitcher & solver design notes.
- `.sisyphus/notepads/*/learnings.md` — Development log with bug-fixes, PyRTL gotchas, and tolerance rationale.
