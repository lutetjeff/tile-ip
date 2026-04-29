# tiled-ip Usage Guide

This document is the **index** to the `tiled-ip` documentation. The content has been split into focused documents.

---

## Documentation Index

| Document | Description |
|----------|-------------|
| **[GETTING_STARTED.md](GETTING_STARTED.md)** | Overview, repo layout, 4 quick-start examples |
| **[IP_CATALOG.md](IP_CATALOG.md)** | All 11 IP cores with parameters, implementation, gotchas |
| **[SHAPE_PROPAGATION.md](SHAPE_PROPAGATION.md)** | StreamShape system and automatic shape propagation |
| **[TRANSFORMER_BLOCK.md](TRANSFORMER_BLOCK.md)** | Full transformer block architecture |
| **[STITCHING.md](STITCHING.md)** | Stitcher, solver, code generation |
| **[TESTING.md](TESTING.md)** | Test framework, results, cocotb verification |
| **[DESIGN_DECISIONS.md](DESIGN_DECISIONS.md)** | Design decisions and known limitations |
| **[IP_LIBRARY.md](IP_LIBRARY.md)** | Low-level interface specification |

---

## Quick Links

### Getting Started
- [Quick-start examples](GETTING_STARTED.md#quick-start-examples)
- [Stitcher basics](STITCHING.md#42-the-stitcher)
- [Solver usage](STITCHING.md#43-the-tilingsolver)

### IP Cores
- [All 11 cores](IP_CATALOG.md#ip-core-overview)
- [GEMM](IP_CATALOG.md#31-gemmcore--int8-matrix-multiplication)
- [TemporalGEMM](IP_CATALOG.md#38-temporalgemmcore--accumulator-based-gemm)
- [StatefulNorm](IP_CATALOG.md#39-statefulnormcore--2-pass-layernorm-rmsnorm)
- [StatefulSoftmax](IP_CATALOG.md#310-statefulsoftmaxcore--3-pass-softmax)

### Advanced Topics
- [StreamShape system](SHAPE_PROPAGATION.md)
- [Transformer block](TRANSFORMER_BLOCK.md)
- [Shape adapter (auto-inserted)](SHAPE_PROPAGATION.md#auto-insertion-of-streamshapeadapter)
- [Fan-in / fan-out](STITCHING.md)

### Testing
- [Test suite overview](TESTING.md#51-test-organization)
- [PyRTL simulation](TESTING.md)
- [cocotb + Verilator](TESTING.md#54-hardware-verification-with-cocotb--verilator)
- [Quantization tolerance](TESTING.md#55-quantization-tolerance)

---

## Additional Resources

- [GPT_TUTORIAL.md](GPT_TUTORIAL.md) — Macro-phase scheduling for transformer blocks
- `src/ip_cores/axi_stream_base.py` — `AXI4StreamLiteBase` and `StreamShape`
- `src/stitcher.py` — Stitcher implementation
- `src/solver.py` — TilingSolver implementation
- `src/transformer_block.py` — Transformer block implementation
- `tests/` — All test files
- `.sisyphus/plans/` — Implementation plans
- `.sisyphus/notepads/` — Development log
