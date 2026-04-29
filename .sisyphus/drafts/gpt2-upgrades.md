# GPT-2 IP Core Upgrades Draft

## GEMM Enhancements
- Needs temporal accumulation (accumulation over multiple beats).
- Control signals: `accumulate` (1-bit) indicating if the current beat should be added to the accumulator, or if it's the final beat (where it should emit and reset).

## Memory Enhancements
- Currently MemRouter has an internal 256-entry ROM/RAM but only supports reads (via `data_out`) with stride patterns.
- Needs a dedicated BRAM subsystem (e.g., `BRAMBankCore`) that can accept writes (to store K, V, and intermediate residuals) and allow multi-bank reads.
- Needs a Write capability to MemRouter, or a separate `MemWriterCore`.

## Norm and Softmax Enhancements
- NormCore currently computes variance over `T_channel`. If $N_{channel} > T_{channel}$, it needs to accumulate sum and sum-of-squares over multiple beats before dividing and emitting.
- SoftmaxCore similarly computes sum of exps over `T_seq`. For larger sequences, it needs temporal accumulation of the sum.

## New IP Requirements
### 1. TemporalGEMMCore
To support $N_{channel} > T_K$, the GEMM must support partial sum accumulation over multiple clock cycles.
- Internal 32-bit registers for each element in the $T_M \times T_N$ output tile.
- An `accum_in` signal. If 1, add to existing accumulator. If 0, overwrite it.
- An `emit_in` signal (or derive from last beat). When high, requantizes the 32-bit accumulators to INT8 and outputs on `data_out` along with `valid_out`.

### 2. MultiBankBRAMCore
- Replaces the internal 256-entry ROM in MemRouter.
- Has an explicit Write interface (`write_data`, `write_addr`, `write_valid`) and Read interface.
- Supports concurrent read/write.
- Parameterized by $T_{width}$ and number of banks to match GEMM/ALU widths.

### 3. StatefulNormCore (Two-Pass)
- LayerNorm requires the global mean/variance across all $N_{channel}$ elements. If $N_{channel} > T_{channel}$, this requires 2 passes:
  - Pass 1: Stream $X$ in. Accumulate sum and sum-of-squares over $N_{channel} / T_{channel}$ beats.
  - Compute inverse sqrt.
  - Pass 2: Stream $X$ in again (from a FIFO/BRAM), multiply/add, and output.
- Alternative: Restrict $N_{channel}$ to match $T_{channel}$ (e.g. 64-dim embeddings for a micro GPT-2), allowing the current 1-pass NormCore to work.

### 4. StatefulSoftmaxCore
- Requires global sum of exponents across $N_{seq}$.
- If $N_{seq}=16$, we can just instantiate the current SoftmaxCore with $T_{seq}=16$. 16 bytes = 128 bits, which is very feasible combinationally.

