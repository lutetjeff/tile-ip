# GPT-2 Tile-Based IP Roadmap & Gap Analysis

To run a GPT-2 Transformer block natively on the `tiled-ip` framework, the architecture must evolve from single-pass, combinational tile operations into **stateful, temporally accumulating engines**.

Because self-attention and channel-wise normalization possess global data dependencies ($N_{channel}$ and $N_{seq}$), these dimensions will frequently exceed the spatial hardware constraints ($T_K, T_{channel}, T_{seq}$).

This document outlines the gap between the current V1 implementation and the V2 requirements for a GPT-2 accelerator, focusing on the required control logic, multi-beat accumulation, and memory architecture.

---

## 1. The Memory Architecture Gap

### Current State
The `MemRouterCore` contains a single, read-only `pyrtl.MemBlock`. It generates complex stride patterns (e.g., matrix transposition) to pack data onto the AXI4-Stream bus, but it lacks any capability to accept writes or store intermediate tensors (like K, V caches, or residual connections).

### Proposed: `MultiBankBRAMCore`
To support the routing phases of GPT-2, we need a dedicated BRAM subsystem:

* **Multi-Bank Organization:** Separate, independently addressable banks for the K cache, V cache, and residual pipeline.
* **Concurrent Read/Write:** Separate read and write interfaces to allow overlapping phases (e.g., writing the new K cache while simultaneously computing $Q \times K^T$).
* **Write Interface:** An AXI4-Stream write port (`write_data`, `write_valid`, `write_ready`) paired with an address generator that can write transposed or strided blocks back into memory.
* **State Machine:**
  * `IDLE` → `WRITE_BURST` → `READ_BURST`
  * Handles bank selection and arbitration if the AXI interconnect attempts to read/write the same bank simultaneously.

---

## 2. The Matrix Multiplication Gap

### Current State
`GEMMCore` is a purely combinational vector-MAC tree. It takes one tile of $A$ and one tile of $B$, computes the full 32-bit dot product, requantizes to INT8, and outputs the result in a single clock cycle. It has no internal registers to hold partial sums.

### Proposed: `TemporalGEMMCore`
Because the embedding dimension $N_{channel}$ is much larger than $T_K$, dot products must be accumulated over multiple beats (temporal accumulation).

* **Registers:** An internal 2D array of 32-bit accumulators: `accum_reg[T_M][T_N]`.
* **Control Signals:**
  * `accum_in` (1-bit): If high, the MAC result is added to `accum_reg`. If low, `accum_reg` is overwritten (start of a new tile).
  * `emit_in` (1-bit): Triggers the requantization phase.
* **State Machine:**
  * `ACCUMULATE`: Accepts valid inputs, computes MACs, and updates `accum_reg`. The core does **not** assert `valid_out`.
  * `EMIT`: When `emit_in` goes high, the core right-shifts the 32-bit registers, clips to INT8, and asserts `valid_out`.
* **Backpressure:** The core must deassert `ready_out` during the `EMIT` phase if the downstream consumer is stalling, preventing new data from overwriting the accumulators before they are drained.

---

## 3. The Normalization Gap

### Current State
`NormCore` is a combinational adder-tree. It expects the entire $N_{channel}$ to fit within $T_{channel}$ in a single cycle. It cannot compute a global mean or variance if the channel is split across multiple beats.

### Proposed: `StatefulNormCore` (Two-Pass)
To handle $N_{channel} > T_{channel}$, Normalization must become a stateful, two-pass operation.

* **Registers:** Wide accumulators for `sum_x` and `sum_x2` (sum of squares), plus registers for the finalized `mean` and `inverse_sqrt_variance`.
* **Pass 1 (Statistics Phase):**
  * `ACCUMULATE`: The core accepts $N_{channel} / T_{channel}$ beats of data, updating `sum_x` and `sum_x2`. `valid_out` remains low.
  * `COMPUTE`: After the last beat, the core spends 1-2 cycles passing the variance through the $1/\sqrt{x}$ ROM LUT.
* **Pass 2 (Normalization Phase):**
  * The memory controller must re-stream the exact same $X$ tensor into the core.
  * `NORMALIZE`: For each incoming beat, the core applies `(x - mean) * inv_sqrt`, appends the learned $\gamma / \beta$, and asserts `valid_out`.
* **Backpressure:** `ready_out` must go low during the `COMPUTE` phase to pause the memory router while the LUT resolves.

---

## 4. The Softmax Gap

### Current State
`SoftmaxCore` finds the maximum, computes exponents, sums them, and divides—all combinationally within a single $T_{seq}$ tile.

### Proposed: `StatefulSoftmaxCore`
Softmax relies on the global denominator $\sum e^{x_i}$. If the context window $N_{seq}$ exceeds $T_{seq}$, it requires a state machine similar to the Norm core.

* **Registers:** `running_max` (8-bit) and `running_sum_exp` (16+ bit).
* **Pass 1 (Max Finding):** Stream all beats to find the true global maximum.
* **Pass 2 (Summation):** Re-stream the data, compute $e^{x_i - max}$, and accumulate the sum.
* **Pass 3 (Division):** Re-stream a *third* time, multiply by the inverse sum, and emit.
* **Alternative (Hardware Optimization):** If $N_{seq}$ is restricted to something very small for this proof-of-concept (e.g., a 16-token micro-GPT), we can instantiate a $T_{seq}=16$ Softmax core and keep it combinational, avoiding the heavy 3-pass streaming penalty.

---

## 5. AXI4-Stream Protocol Upgrades

To move to a temporally accumulating architecture, the `AXI4StreamLiteBase` wrapper logic will need to handle stateful backpressure:

1. **`TLAST` Integration:** We must add a `last_in` signal to the AXI protocol so the spatial engines know when an accumulation loop is complete without needing internal beat counters.
2. **Phase Isolation:** Cores will frequently assert `valid_in == 1` but `valid_out == 0` (during accumulation). The `ready_out` signal must correctly stall upstream memory if an internal state machine is busy transitioning between phases.