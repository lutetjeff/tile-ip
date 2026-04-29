# RTL Stitching & DP Solver Plan

## Objective
Build automated infrastructure to stitch the 7 existing tile-based IPs into complete accelerator subgraphs (FFN, Attention, Mem→Compute) without manual wire connections. Implement a lightweight DP solver for optimal IP placement and tiling configuration selection.

## Scope
- **IN**:
  - Generic stitching infrastructure that can automatically connect AXI4-Stream-Lite interfaces between IPs
  - DP solver for selecting optimal tiling configurations (T_M, T_K, T_N, etc.) given area/timing constraints
  - RTL stitching script that emits a single PyRTL block for a target subgraph
  - Compound tests using the generic stitcher (replacing manual connections)
- **OUT**:
  - Synthesis and place-and-route
  - Floorplanning or physical design

## Technical Approach
- **Stitcher**: A `Stitcher` class in `src/stitcher.py` that takes a connectivity graph (list of `(src_ip, dst_ip)` edges) and automatically wires `data_out→data_in`, `valid_out→valid_in`, `ready_out→ready_in`
- **DP Solver**: A `TilingSolver` in `src/solver.py` that searches the tiling parameter space {1,2,4}^k to minimize a cost function (area estimate + latency estimate) subject to a timing constraint
- **RTL Script**: `scripts/generate_subgraph.py` CLI that accepts a JSON graph spec and emits a stitched PyRTL design + testbench stub

## Tasks

### Phase 1: Generic Stitching Infrastructure
- [x] Implement `Stitcher` class in `src/stitcher.py` with `connect(src, dst)` and `build()` methods
- [x] Handle ready/valid handshake chaining across N IPs
- [x] Add `tests/test_stitcher.py` with unit tests for 2-IP and 3-IP chains
- [x] Refactor existing compound tests to optionally use `Stitcher` (keep manual tests as fallback)

### Phase 2: DP Solver for Tiling Configuration
- [x] Implement `TilingSolver` in `src/solver.py` with cost model (LUT estimate per IP × tiling params)
- [x] Add timing constraint check (estimated critical path depth)
- [x] Add `tests/test_solver.py` verifying solver finds optimal config for FFN and Attention subgraphs
- [x] Document cost model assumptions in notepad

### Phase 3: RTL Stitching Script
- [x] Create `scripts/generate_subgraph.py` CLI accepting JSON graph definition
- [x] Script instantiates IPs, calls `Stitcher`, and emits a single PyRTL block
- [x] Script generates a testbench stub comparing against a golden NumPy reference
- [x] Add `tests/test_generate_subgraph.py` with end-to-end JSON → PyRTL → simulation tests for FFN and Attention

## Final Verification Wave
1. `pytest -n auto --timeout=120 tests/test_stitcher.py tests/test_solver.py tests/test_generate_subgraph.py -q` exits 0
2. `python scripts/generate_subgraph.py --spec examples/ffn.json --out build/ffn.py` produces a runnable PyRTL module
3. Refactored compound tests (`tests/test_compound_*.py`) can run in both manual and stitcher modes
4. DP solver returns a valid configuration for all 3 compound subgraphs within 1 second
