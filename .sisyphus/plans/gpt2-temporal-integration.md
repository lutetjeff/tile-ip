# GPT-2 Temporal Integration Plan (N=4, Context=16-128)

## 1. Objective & Scope
Integrate a full GPT-2 Transformer block natively on FPGA using the `tiled-ip` framework. The architecture will transition from purely spatial combinational streaming to stateful, multi-pass temporal streaming to support context windows of $N=16$ to $128$ while maintaining a hardware tiling factor of $T=4$. 

**Key Directives:**
- Implement the Full Temporal V2 Roadmap (`TemporalGEMM`, `StatefulNorm`, `StatefulSoftmax`).
- Implement `MultiBankBRAMCore` for K/V caches and residual routing.
- Upgrade Python tooling (`stitcher.py`, `solver.py`, `export_verilog.py`) to support stateful routing, fan-in, and full-block generation.
- Deliver an end-to-end `cocotb` testbench verifying the full block via Verilator.

## 2. Architecture & Design Decisions
- **Tiling:** $T=4$ for all spatial dimensions.
- **AXI Protocol:** Add `last_in` (TLAST) to `AXI4StreamLiteBase`. Existing IPs default to ignoring it.
- **Residuals (Fan-In):** Upgrade `stitcher.py` to support N->1 fan-in specifically for `ALUCore` (ADD) operations, handling ready/valid arbitration. Use the existing `FIFOCore` to delay the residual $X$ stream.
- **Weight Loading:** Weights will be pre-loaded into BRAMs and streamed via dedicated `MemRouterCore` instances acting as ROMs.
- **Backpressure:** Stateful IPs MUST deassert `ready_out` during `COMPUTE/EMIT` phases to stall upstream memory without data loss.

---

## 3. Implementation Tasks

### Phase 1: Protocol & Tooling Upgrades
- [x] **Task 1.1: Upgrade AXI4StreamLiteBase**
  - **Action:** Add `last_in` (1-bit) signal to `src/ip_cores/axi_stream_base.py`.
  - **Acceptance:** All existing PyRTL unit tests pass (backward compatibility: `last_in` defaults to 0).
- [x] **Task 1.2: Upgrade Stitcher for Fan-In**
  - **Action:** Modify `src/stitcher.py` to allow multiple producers to connect to a single consumer (specifically `ALUCore`). Implement round-robin or synchronized ready/valid arbitration.
  - **Acceptance:** `pytest` unit test verifying two `MemRouterCores` feeding one `ALUCore` successfully completes.
- [x] **Task 1.3: Upgrade Verilog Exporter**
  - **Action:** Modify `scripts/export_verilog.py` to support exporting stitched, multi-IP graphs with BRAMs and state machines.
  - **Acceptance:** Can successfully export the updated `test_compound_attention.py` graph to Verilator without errors.

### Phase 2: Core Temporal IPs
- [x] **Task 2.1: Implement TemporalGEMMCore**
  - **Action:** Create `src/ip_cores/temporal_gemm.py`. Add 32-bit `accum_reg`, `accum_in`, `emit_in` state logic.
  - **Acceptance:** `pytest` unit test where 4 beats of $1 \times 4$ vectors are multiplied and accumulated into a single $1 \times 4$ output. Assert `ready_out` goes low during `EMIT`.
- [x] **Task 2.2: Implement StatefulNormCore**
  - **Action:** Create `src/ip_cores/stateful_norm.py`. Implement 2-pass FSM (STATISTICS -> COMPUTE -> NORMALIZE).
  - **Acceptance:** `pytest` unit test streaming an 8-beat channel twice. Verify output matches NumPy reference model with `atol=1`.
- [x] **Task 2.3: Implement StatefulSoftmaxCore**
  - **Action:** Create `src/ip_cores/stateful_softmax.py`. Implement 3-pass FSM (MAX -> SUM -> DIVIDE).
  - **Acceptance:** `pytest` unit test streaming a 16-beat row three times. Verify output matches NumPy softmax.

### Phase 3: Memory & Orchestration
- [x] **Task 3.1: Implement MultiBankBRAMCore**
  - **Action:** Create `src/ip_cores/multi_bank_bram.py`. Add write interface, bank arbitration, and concurrent read/write state machine.
  - **Acceptance:** `pytest` unit test demonstrating writing to Bank A while simultaneously reading from Bank B.
- [x] **Task 3.2: Implement BRAM Init Infrastructure for Verilator**
  - **Action:** Add support to `export_verilog.py` and test infrastructure to load `.hex` or `.dat` files into BRAMs during Verilator simulation startup.
  - **Acceptance:** A `cocotb` test successfully reads pre-initialized weights from a generated Verilog BRAM.

### Phase 4: Integration & Full Block Test
- [x] **Task 4.1: Assemble Transformer Block in PyRTL**
  - **Action:** Create `src/transformer_block.py`. Use `Stitcher` to wire: `MemRouter(X) -> FIFOCore(Residual) | -> StatefulNorm -> TemporalGEMM(QKV) -> StatefulSoftmax -> TemporalGEMM(Proj) -> ALUCore(Add) ... -> FFN -> ALUCore(Add)`.
  - **Acceptance:** PyRTL simulation of the full block runs without stalling/deadlock.
- [x] **Task 4.2: End-to-End cocotb Verification**
  - **Action:** Create `tests/cocotb_tests/test_transformer_block.py`. Export the full block to Verilog. Drive $N=16, T=4$ inputs.
  - **Acceptance:** Output matrix matches a full NumPy GPT-2 block reference model within `atol=2`. Total cycle count is logged.

## Final Verification Wave
- [x] Run `pytest tests/ -v` to ensure all original combinational IP unit tests still pass (backward compatibility).
- [x] Run `pytest tests/cocotb_tests/test_transformer_block.py` to confirm the full Temporal Transformer Block compiles in Verilator and passes the end-to-end numerical check.
- [x] Explicitly ask the user to review the waveform (`dump.fst`) for the full block to confirm backpressure (`ready_in`/`ready_out`) behaves as expected during state transitions.
