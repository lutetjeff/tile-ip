# Implementation Plan: Tiling Shape Propagation

## Objective
Implement a shape propagation system (`StreamShape(N, T)`) so IP cores infer their output shapes and auto-configure downstream consumers, replacing hardcoded parameters.

## Phase 1: Shape Abstraction & Base Class
- [x] Define `StreamShape` dataclass to store `N` (tensor dimension) and `T` (tiling factor).
- [x] Add `input_shape` and `output_shape` attributes to `AXI4StreamLiteBase`.
- [x] Implement `infer_output_shape()` method in `AXI4StreamLiteBase`.
- [x] Update individual IP cores to override `infer_output_shape()` based on their specific logic.
  - [x] SoftmaxCore
  - [x] MemRouterCore
  - [x] MultiBankBRAMCore

## Phase 2: Stitcher Upgrades (Removed - merged to Phase 3)
## Phase 3: Shape Adapter IP & Stitcher Upgrades
- [x] Implement `StreamShapeAdapter` IP core to handle dynamic reshaping between streams with varying bitwidths (e.g., $T=2$ to $T=4$).
- [x] Update `src/stitcher.py` to perform topological traversal of the IP graph.
- [x] Pass `StreamShape` objects during IP constructor calls.
- [x] Automatically insert `StreamShapeAdapter` IP cores where `src.output_shape.T != dst.input_shape.T`.
- [x] Add validation logic to ensure total tensor size (`N`) matches even if tiling factors (`T`) differ.

## Phase 4: Transformer Block Refactor
- [x] Update `src/transformer_block.py` to accept top-level parameters (`seq_len`, `emb_dim`, `T`).
- [x] Remove hardcoded parameters within the block.
- [x] Ensure the block relies on the stitcher's shape propagation for internal connections.

## Phase 5: TemporalGEMM Emit Fix
- [x] Modify `TemporalGEMMCore` to correctly emit multi-beat outputs when $M \times N > T_M \times T_N$.
- [x] Ensure the core handles the tiling factor `T` correctly during the emission process.

## Verification
- [x] Create unit tests to verify `StreamShape` propagation across different IP configurations.
- [x] Add a test case for `StreamShapeAdapter`.
- [x] Verify `TemporalGEMMCore` simulation output for multi-beat scenarios.