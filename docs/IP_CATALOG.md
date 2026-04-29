# IP Catalog

This document describes all 11 IP cores available in `tiled-ip`, their parameters, implementation details, and known gotchas.

---

## IP Core Overview

| Core | File | Type | Description |
|------|------|------|-------------|
| **GEMMCore** | `src/ip_cores/gemm.py` | Combinational | INT8 matrix multiplication |
| **SoftmaxCore** | `src/ip_cores/softmax.py` | Combinational | LUT-based softmax |
| **NormCore** | `src/ip_cores/norm.py` | Combinational | LayerNorm / RMSNorm |
| **ActivationCore** | `src/ip_cores/activation.py` | Combinational | LUT-based GELU / ReLU |
| **ALUCore** | `src/ip_cores/alu.py` | Pipelined | Element-wise ADD / MULTIPLY / MASK |
| **MemRouterCore** | `src/ip_cores/mem_router.py` | Stateful | BRAM-backed token fetch / transpose |
| **FIFOCore** | `src/ip_cores/fifo.py` | Stateful | Elastic buffer with backpressure |
| **TemporalGEMMCore** | `src/ip_cores/temporal_gemm.py` | Stateful | Accumulator-based GEMM |
| **StatefulNormCore** | `src/ip_cores/stateful_norm.py` | Stateful | 2-pass LayerNorm / RMSNorm |
| **StatefulSoftmaxCore** | `src/ip_cores/stateful_softmax.py` | Stateful | 3-pass Softmax |
| **MultiBankBRAMCore** | `src/ip_cores/multi_bank_bram.py` | Stateful | Concurrent R/W BRAM |

---

## 3.1 GEMMCore — INT8 Matrix Multiplication

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

**Shape propagation:** GEMM overrides `infer_output_shape()` to return `StreamShape(T_M * T_N, T_N)` when `input_shape` is set.

---

## 3.2 SoftmaxCore — LUT-Based Softmax

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

**Shape propagation:** Softmax overrides `infer_output_shape()` to return the same shape as `input_shape` when set.

---

## 3.3 NormCore — LayerNorm / RMSNorm

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

**Shape propagation:** Norm overrides `infer_output_shape()` to return the same shape as `input_shape` when set.

---

## 3.4 ActivationCore — LUT-Based GELU / ReLU

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

**Shape propagation:** Activation overrides `infer_output_shape()` to return the same shape as `input_shape` when set.

---

## 3.5 ALUCore — Element-wise ADD / MULTIPLY / MASK

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

**Shape propagation:** ALU overrides `infer_output_shape()` to return the same shape as `input_shape` when set. Fan-in is supported for ALU (N→1 via `data_in` and `data_in_b`).

---

## 3.6 MemRouterCore — Memory Router & Embedding

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

## 3.7 FIFOCore — Elastic Buffer

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

**Shape propagation:** FIFO overrides `infer_output_shape()` to return the same shape as `input_shape` when set.

---

## 3.8 TemporalGEMMCore — Accumulator-Based GEMM

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

**Shape propagation:** TemporalGEMM overrides `infer_output_shape()` based on `M` and `N` parameters and the tiling factor.

---

## 3.9 StatefulNormCore — 2-Pass LayerNorm / RMSNorm

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

**Shape propagation:** StatefulNorm overrides `infer_output_shape()` based on `N_channel` and `T_channel`.

---

## 3.10 StatefulSoftmaxCore — 3-Pass Softmax

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

**Shape propagation:** StatefulSoftmax overrides `infer_output_shape()` based on `N_seq` and `T_seq`.

---

## 3.11 MultiBankBRAMCore — Concurrent Read/Write BRAM

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

**Shape propagation:** MultiBankBRAM overrides `infer_output_shape()` to return `StreamShape(2**addr_width * T, T)`.

---

## Common Gotchas

1. **GEMM output width differs from input:** GEMM replaces the base-class `data_out` wire because its output width (`T_M·T_N·8`) differs from its input width (`T_M·T_K·8`).

2. **Block isolation:** Each IP creates a fresh `pyrtl.Block()` per instance. To stitch, all IPs must be in the **same** block. Use the monkey-patch trick for IPs that don't accept a `block=` parameter.

3. **Memory sync checks:** Some LUT ROMs are accessed combinationally. PyRTL's `sanity_check_memory_sync` can flag this. Testbenches disable the check on shared blocks.

4. **Gated-GELU out of scope:** `ActivationCore` only has one input stream. True gated-GELU (SiLU-style) requires a second stream.

5. **`last_in` for temporal cores:** All temporal cores (`TemporalGEMMCore`, `StatefulNormCore`, `StatefulSoftmaxCore`) use `last_in` as the packet boundary marker.

6. **StatefulNorm requires power-of-two:** `T_channel` and `N_channel` must be powers of two, and `N_channel` must be a multiple of `T_channel`.
