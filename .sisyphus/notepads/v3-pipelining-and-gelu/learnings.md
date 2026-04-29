
## StatefulSoftmaxCore Rewrite (Completed)
- Rewrote `src/ip_cores/stateful_softmax.py` with triple-buffered II=1 pipeline
- Removed 3-pass FSM, replaced with 3-stage ring buffer using `write_ptr`/`sum_ptr`/`div_ptr`
- `tokens_in_flight` counter (0-3), `ready_out = tokens_in_flight < 3`, `valid_out = div_active`
- Critical bug found and fixed: conditional_assignment precedence caused last-beat data to be dropped
  - Producer max: `prod_done` branch was checked before `prod_handshake`, so on last beat `prod_max` was reset to -128 BEFORE latching to `buf_max`
  - Fix: compute `next_prod_max` combinationaly, use `prod_handshake & (prod_beat_count == 0)` for reset, `prod_handshake` for update, latch `buf_max` with `next_prod_max`
  - Sum exp: same bug - `sum_done` branch reset `sum_exp_acc` to 0 before adding last beat's sum
  - Fix: compute `next_sum_exp` combinationaly, use `sum_active & (sum_beat_count == 0)` for reset, `sum_active` for accumulation, latch `buf_sum_exp` with `next_sum_exp`
- Separate exp ROMs for sum and divide stages (both can be active simultaneously)
- Tests rewritten: `test_single_token`, `test_all_zeros`, `test_ii1_back_to_back`, `test_backpressure`
- All 14 tests pass
