# V3 Architecture Plan: GELU Fix & Stateful Pipelining

## Goal
Fix the mathematical bug in the GELU activation core and refactor `StatefulNormCore` and `StatefulSoftmaxCore` to achieve an Initiation Interval (II) of 1 using Flip-Flops (PyRTL Registers) for internal buffering.

## Scope Boundaries
**IN SCOPE:**
- `src/ip_cores/activation.py`
- `tests/ref_models/activation_ref.py`
- `src/ip_cores/stateful_norm.py`
- `src/ip_cores/stateful_softmax.py`
- Updating tests to match the new behavior and stricter `atol` for GELU.
- Updating `docs/IP_USAGE.md` regarding GELU tolerances.

**OUT OF SCOPE:**
- Systolic GEMM (deferred to future plan).
- `TemporalGEMMCore` modifications.

## Task 1: Fix GELU Quantization Bug
**Context:** The current LUT generator and reference model apply dynamic scalar scaling (`127 / abs(gelu_float)`), turning GELU into `127 * sign(x)`. The tests mask this with `atol=130`.
**Implementation:**
- [x] Edit `src/ip_cores/activation.py`: In `_compute_gelu_lut()`, remove `max_abs` scaling. Simply compute `gelu_scaled = np.round(gelu_float)` and clip to `[-128, 127]`.
- [x] Edit `tests/ref_models/activation_ref.py`: In `gelu_ref(x)`, remove dynamic scaling. Compute `gelu_float` and round to `gelu_scaled`, clip, return as `int8`.
- [x] Edit `tests/test_activation.py`: Change `gelu_ref` calls to evaluate the entire `beat` array at once (`expected = gelu_ref(beat)`). Use `np.testing.assert_array_equal` (or `assert_allclose` with `atol=1` if noise exists).
- [x] Edit `tests/test_compound_ffn.py`: Call `gelu_ref` on the full array. Reduce the `atol` from 130 to 5.
- [x] Update `docs/IP_USAGE.md` to remove the GELU `atol=130` note.
- [x] All tests pass (73/73)

## Task 2: Pipeline StatefulNormCore for II=1 (FFs)
**Context:** Current 3-pass FSM stalls the DMA pipeline. We want II=1 using PyRTL Registers for buffering.
**Implementation:**
- [x] Rewrite `src/ip_cores/stateful_norm.py` with double-buffered pipeline (II=1).
- [x] Update `tests/test_stateful_norm.py` for pipelined behavior (remove FSM-phase tests, add II=1 back-to-back tests, backpressure tests).
- [x] All norm tests pass (32/32)
- Remove the 3-state FSM (`STATISTICS`, `COMPUTE`, `NORMALIZE`).
- Implement Double Buffering using `pyrtl.Register` arrays (size: `2 * N_channel` bytes).
- Use a `write_ptr` (0 or 1) and `read_ptr` (1 or 0) managed by a `tokens_in_flight` counter.
- **Producer Stage:**
  - On valid data, write to the FF buffer at `write_ptr`.
  - Accumulate `sum_x` and `sum_x2`.
  - On `last_in`, latch the final accumulators into `stats_sum_x[write_ptr]` and `stats_sum_x2[write_ptr]`. Toggle `write_ptr`. Increment `tokens_in_flight`.
- **Consumer Stage:**
  - Activates when `tokens_in_flight > 0`.
  - Reads from the FF buffer at `read_ptr`.
  - Uses `stats_sum_x[read_ptr]` and `stats_sum_x2[read_ptr]` to compute mean, variance, and inv_sqrt combinationally via the LUT.
  - Normalizes the read data and outputs it with `valid_out = 1`.
  - On the final beat of the token, toggle `read_ptr` and decrement `tokens_in_flight`.
- **Interface:** `ready_out` = `tokens_in_flight < 2`. `valid_out` driven by the Consumer stage.

## Task 3: Pipeline StatefulSoftmaxCore for II=1 (FFs)
**Context:** Current 3-pass FSM stalls the pipeline. We want II=1 using PyRTL Registers.
**Implementation:**
- [x] Rewrite `src/ip_cores/stateful_softmax.py` with triple-buffered pipeline (II=1).
- [x] Update `tests/test_stateful_softmax.py` for pipelined behavior.
- [x] All softmax tests pass (14/14)
- Remove the 3-state FSM (`MAX_FINDING`, `SUM_EXP`, `DIVIDE`).
- Implement Triple Buffering using `pyrtl.Register` arrays (size: `3 * N_seq` bytes).
- **Stage 1 (Max Finding):**
  - Writes incoming data to `buf[p]`.
  - Computes max. On `last_in`, latch to `global_max[p]` and increment write pointer `p`.
- **Stage 2 (Sum Exp):**
  - Reads from `buf[(p-1)%3]`.
  - Computes `exp(x - global_max[(p-1)%3])` via LUT.
  - Accumulates sum. On last beat, latches to `sum_exp[(p-1)%3]`.
- **Stage 3 (Divide & Emit):**
  - Reads from `buf[(p-2)%3]`.
  - Re-computes `exp(x - global_max[(p-2)%3])` via LUT (saves storing exps).
  - Multiplies by `inv_sum(sum_exp[(p-2)%3])` via LUT.
  - Emits data. `valid_out = 1`.
- **Coordination:** A single counter/token pipeline state manages the progress so each stage works on its respective ring buffer slot.

## Final Verification Wave
- [x] Run `pytest tests/test_activation.py` - 41 passed
- [x] Run `pytest tests/test_compound_ffn.py` - 32 passed
- [x] Run `pytest tests/test_stateful_norm.py` - 32 passed
- [x] Run `pytest tests/test_stateful_softmax.py` - 14 passed
- [x] Run `pytest tests/test_transformer_block.py` - 1 passed
- [x] Verify all tests pass with no deadlocks and accurate mathematical tolerance.
- Total: 120/120 tests pass
