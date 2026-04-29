# Learnings: StatefulNormCore Implementation

## PyRTL Accumulator Pitfall
- **Issue**: Using unsigned `+` operator (`sum_x + beat_sum_x`) for signed accumulator updates causes incorrect results when `beat_sum_x` is negative. PyRTL treats the 8-bit value as unsigned (e.g., -20 becomes 236), leading to wrong accumulation.
- **Fix**: Use `signed_add(sum_x, beat_sum_x)[0:sum_x_bw]` to properly handle signed arithmetic, then truncate to the register width.

## MemBlock Read Timing
- PyRTL `MemBlock` writes are registered (visible on next cycle), reads are combinational.
- The write-reset-read pattern works correctly: write with incrementing addr, reset addr in a no-write cycle, then read with incrementing addr.

## Registered Beat Counter Behavior
- In AXI-Stream backpressure tests, `beat_count` advances on the cycle AFTER `ready_in=1`, not on the same cycle. This is correct register behavior.
- Tests must account for this: output changes on the NEXT cycle after downstream acceptance.

## LUT Reference Model Matching
- To achieve `atol=1` tolerance, the reference model must mirror hardware's exact truncation behavior:
  - `np.floor()` for arithmetic right shift (truncation toward negative infinity)
  - `(scaled_int32 & 0xFF).astype(np.int8)` for 8-bit two's complement wrap
  - Use the exact same 256-entry LUT values as hardware

## FSM State Encoding
- 3-state FSM: 0=STATISTICS, 1=COMPUTE, 2=NORMALIZE
- `ready_out` is high only in STATISTICS (state==0)
- `valid_out` is high only in NORMALIZE (state==2)
- COMPUTE lasts exactly 1 cycle
