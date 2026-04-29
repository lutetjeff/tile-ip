# Tile-Based IP Implementation Plan

## Objective
Implement a PyRTL generator library for 6 tile-based IPs defined in `docs/IP_LIBRARY.md`, ensuring they adhere to a standard AXI4-Stream-Lite interface. Each IP must have comprehensive testbenches validating functionality across various tiling parameters, executing within 2 minutes per run. Create compound testbenches to verify inter-IP compatibility.

## Scope
- **IN**: 
  - Standardized interface wrapper (AXI4-Stream-Lite).
  - 6 Parameterized PyRTL IP Cores (GEMM, Softmax, Normalization, Activation, ALU, Memory Router).
  - Comprehensive unit testbenches for each IP across tiling parameters `T ∈ {1, 2, 4}` to ensure sub-2-minute execution.
  - NumPy reference models for numerical verification in tests.
  - Compound IP testbenches verifying stream compatibility (Attention, FFN, Mem->Compute).
  - Setup of parallel test execution via `pytest-xdist`.
- **OUT**:
  - The DP solver and final RTL stitching script.
  - Synthesis and place-and-route steps.
  - Generic stitching infrastructure (compound tests will use manual wire connections).

## Technical Approach
- **Language**: Python with `PyRTL` and `NumPy` (for reference models).
- **Project Structure**: 
  - `src/ip_cores/`: Contains `axi_stream_base.py` and the 6 IP generator files.
  - `tests/`: Contains test files for each IP + `test_compound.py`.
  - `tests/ref_models/`: NumPy reference implementations.
- **Interface Protocol**: Enforced via an OOP Base Class (`AXI4StreamLiteBase`) that manages the `pyrtl.working_block()` and exposes `data_in`, `valid_in`, `ready_out`, `data_out`, `valid_out`, `ready_in`.
- **Latency & Backpressure Strategy**: 
  - IPs are **non-stalling** internally where possible to maintain II=1 and simplify integration. However, if II=1 creates excessive logic delay, a larger II is acceptable.
  - GEMM will use a **systolic array** implementation (burst-style design is acceptable). The average II of the design should be reported.
  - For LUTs and intermediate results (e.g. Softmax exponentiation), values may temporarily exceed INT8 bounds, provided they align with eventual comparison against a PyTorch INT8 quantized GPT-2 reference.
- **Testing**: `pytest -n auto --timeout=120` to parameterize tiling configurations and leverage parallel workers.

## Guardrails & Edge Cases Addressed
- **Softmax Numerical Fidelity**: The INT8 $e^x$ LUT is numerically challenging. The Softmax IP will include a max-subtraction or fixed-point scaling pre-step before the LUT to prevent overflow.
- **Gated-GELU**: Since the spec only defines one input stream for Activation, Gated-GELU is considered out of scope unless a second stream is explicitly added.
- **PyRTL Memory**: Memory Router will explicitly use `PyRTL.MemBlock` as its backing store to satisfy the "BRAM" requirement.

## Tasks

### Phase 1: Infrastructure & Reference Models
- [x] Create project structure (`src/ip_cores`, `tests/ref_models`) and initialize `pyproject.toml` with `pytest`, `pytest-xdist`, `pytest-timeout`, and `numpy` dependencies.
- [x] Implement `AXI4StreamLiteBase` in `src/ip_cores/axi_stream_base.py`. Ensure it correctly encapsulates PyRTL wire instantiation (`data_in`, `data_out`, `valid_in`, etc.) and block management.
- [x] Implement NumPy reference models in `tests/ref_models/` for GEMM, Softmax (with max-subtraction/scaling), Normalization, Activation (GELU, ReLU), ALU, and Memory Routing.

### Phase 2: Core IP Implementation & Unit Tests
- [x] Implement `ALU` core and `test_alu.py`. Test OP_CODES: ADD, MULTIPLY, MASK. Verify against reference model. Parameterize `T_width ∈ {1, 2, 4}`. Include boundary data tests (zeros, max INT8).
- [x] Implement `Activation` core (LUT-based) and `test_activation.py`. Support GELU and ReLU. Initialize ROMs via Python function. Verify against reference model.
- [x] Implement `Normalization` core and `test_norm.py`. Support LayerNorm and RMSNorm (via `is_rmsnorm` flag). Handle `1/sqrt(x)` via LUT and variance via adder tree. Verify against reference model.
- [x] Implement `Softmax` core (LUT-based) and `test_softmax.py`. Intermediate results before final requantization may exceed INT8 bounds, ensuring alignment with PyTorch INT8 GPT-2 numerics. Verify against reference model.
- [x] Implement `GEMM` core and `test_gemm.py`. Use a systolic array implementation with 32-bit internal accumulators and a requantization right-shift stub (burst-style acceptable). Report the average II. Test tiling params `T_M, T_K, T_N ∈ {1, 2, 4}`. Verify against reference model.
- [x] Implement `Memory Router` core and `test_mem_router.py`. Use `PyRTL.MemBlock` as backing store. Implement programmable address stride patterns for tensor reshaping/transposition.

### Phase 3: Compound Integration Tests
- [x] Fix PyRTL Block Isolation Issue (`src/ip_cores/axi_stream_base.py`): Modify `AXI4StreamLiteBase.__init__` to accept an optional `block: pyrtl.Block = None`. If provided, use it instead of creating a new `pyrtl.Block()`. Wires from different PyRTL blocks cannot be combined, so compound tests must instantiate all IPs in the SAME block.
- [x] Implement Memory -> Compute subgraph test (`tests/test_compound_mem_compute.py`): Connect Memory Router to GEMM. Verify data fetch and MAC computation on a small tensor.
- [x] Implement FFN subgraph test (`tests/test_compound_ffn.py`): Connect Normalization -> Activation -> ALU. Verify a full feed-forward block pass.
- [x] Implement Attention subgraph test (`tests/test_compound_attention.py`): Connect GEMM (Q*K^T) -> Softmax -> GEMM (Scores*V). Verify a single attention head computation.


## Final Verification Wave (Acceptance Criteria)
1. `pytest -n auto --timeout=120 tests/ -q` must exit 0, verifying all unit and compound tests pass within the time limit.
2. `ls src/ip_cores/ | grep -E "axi_stream_base|gemm|softmax|norm|activation|alu|mem_router"` must show all 7 expected files.
3. Every test must compare PyRTL simulation output against a NumPy reference model for both a happy-path continuous stream (10 beats) and edge cases (e.g. all zeros, max positive/negative values).
4. Compound tests (`tests/test_compound_*.py`) must successfully pass a single handshake transaction end-to-end for Attention (GEMM->Softmax->GEMM), FFN (Norm->Activation->ALU), and Mem->Compute.
