# AXI-Stream Handshake Fix - Learnings

## Key Patterns

1. **AXI-Stream Handshake Rule**: Producer must hold `data_in` and `valid_in` steady until `ready_out` is asserted. Only then should it advance to the next beat.
2. **Multi-beat tokens**: `last_in` should be 0 on all beats except the final beat of each token. For `T_channel=2, N_channel=4`, this means `last_in` alternates 0, 1, 0, 1...
3. **Continuous driving**: For FIFO-based pipelines, stopping input too early can cause downstream starvation because the FIFO empties before the slower path catches up.

## Issues Found

### tests/test_transformer_block.py
- Original code already had `last_in` alternating (partial fix from v2).
- Main issue: test drove inputs for only a fixed number of beats (8), then stopped. This caused `fifo1` to empty before `tgemm2` produced output, so `alu1` never saw both inputs valid simultaneously.
- Fix: Drive `fifo1` and `norm1` continuously as long as `ready_out` is high, following proper handshake.
- Also added monitoring of intermediate stages (`tgemm1`, `softmax`, `tgemm2`, `alu1`) to verify data flows through the pipeline.

### tests/test_stateful_norm.py
- Tests used simple `for` loops sending one beat per cycle, assuming `ready_out` was always 1.
- Fix: Added `_send_beats_handshake()` helper that holds `data_in`/`valid_in` steady and only advances `beat_idx` when `ready_out` is asserted.
- Added `_drain_output_handshake()` helper for collecting output using proper `ready_in` assertion.
- Updated all parametric tests to use these helpers.

### tests/test_stateful_softmax.py
- Tests already followed proper handshake patterns in most places (checking `ready_out` before advancing `beat_idx`).
- No changes needed.

## Design Issue Discovered (not fixed per constraints)

The transformer block has a throughput mismatch between the two paths to `alu2`:
- Left path (norm2 -> tgemm3 -> activation -> tgemm4): produces 1 beat every ~6 cycles
- Right path (df1-df4 -> fifo2): produces 1 beat every ~3 cycles

Additionally, `temporal_gemm.py` transitions to emit state without checking `ready_in`, which can cause data loss when the consumer isn't ready.

These are design issues in `src/` but the task constrained us to only fix tests.
