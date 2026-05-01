# tiled-ip

[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![PyRTL](https://img.shields.io/badge/backend-PyRTL-green.svg)](https://github.com/UCSBarchlab/PyRTL)
[![pytest](https://img.shields.io/badge/testing-pytest-orange.svg)](https://docs.pytest.org/)

`tiled-ip` is a dynamic-programming-driven hardware compiler for tile-based INT8 accelerators. It provides a library of parameterized IP cores and automated tools to stitch them into complex hardware pipelines, such as full GPT-2 transformer blocks.

## Key Features

*   **Parameterized IP Library:** 11 optimized IP cores (GEMM, Softmax, Norm, Activation, ALU, MemRouter, FIFO, TemporalGEMM, StatefulNorm, StatefulSoftmax, MultiBankBRAM).
*   **Shape Propagation:** `StreamShape(N, T)` system tracks tensor dimensions through pipelines and auto-configures downstream IPs. The `Stitcher` inserts `StreamShapeAdapter` cores automatically when tiling factors differ.
*   **Automated Stitching:** A `Stitcher` engine that wires IP cores into chains or graphs using a standardized AXI4-Stream-Lite interface, with topological traversal and shape-aware connection validation.
*   **Declarative Frontend:** `TiledIPGraph` class provides a Networkx-style API that hides PyRTL block management and monkey-patching.
*   **DP-Driven Optimization:** A `TilingSolver` that brute-forces the tiling-parameter space `{1, 2, 4}^k` to find area/latency-optimal configurations.
*   **Branch-and-Bound Autotuner:** `Autotuner` class searches tile configurations using FPGA characterization data with utilization and latency pruning.
*   **Pareto Visualization:** Tools to visualize trade-offs between LUT utilization, throughput, and power.
*   **Hardware Verification:** Full verification stack using PyRTL simulation, cocotb, and Verilator.
*   **Transformer Ready:** Parameterized transformer blocks (`seq_len`, `emb_dim`, `T`) with attention and FFN paths, residual connections, and shape inference.
*   **Robust Testing:** 1200+ tests covering unit, compound, end-to-end, shape propagation, and adapter scenarios.

## IP Catalog

| Core | Function |
| :--- | :--- |
| **GEMM** | INT8 matrix multiplication |
| **Softmax** | LUT-based softmax |
| **Norm** | LayerNorm / RMSNorm |
| **Activation** | LUT-based GELU / ReLU |
| **ALU** | Element-wise ADD / MULTIPLY / MASK |
| **MemRouter** | BRAM-backed token fetch / transpose |
| **FIFO** | Elastic buffer with backpressure |
| **TemporalGEMM** | Accumulator-based GEMM |
| **StatefulNorm** | 2-pass LayerNorm / RMSNorm |
| **StatefulSoftmax** | 3-pass Softmax |
| **MultiBankBRAM** | Concurrent R/W BRAM |

## Quick Start

### Installation

```bash
# Install in editable mode
pip install -e .

# Install with development dependencies
pip install -e ".[dev]"
```

### Single IP Simulation

```python
import pyrtl
from ip_cores.gemm import GEMMCore

# Instantiate a GEMM core
core = GEMMCore(T_M=2, T_K=2, T_N=2, name="g1")

# Setup simulation inputs
d_in = pyrtl.Input(core.data_in.bitwidth, "d_in")
v_in = pyrtl.Input(1, "v_in")
# ... (setup other ports)

# Run simulation
sim = pyrtl.Simulation(tracer=None, block=core.block)
sim.step({d_in: 0x01020304, v_in: 1, ...})
print(sim.inspect(core.data_out.name))
```

### TiledIPGraph (Recommended)

```python
from frontend import TiledIPGraph
from ip_cores.norm import NormCore
from ip_cores.activation import ActivationCore

# Build IP graphs declaratively
graph = TiledIPGraph()
graph.add_node("norm", NormCore, T_channel=2)
graph.add_node("act", ActivationCore, T_width=2)
graph.add_edge("norm", "act")
block, drivers = graph.build()
```

### Autotuner

```python
from autotuner import Autotuner, CharacterizationDB

spec = {
    "ips": [{"type": "Norm", "name": "norm", "params": ["T_channel"]}, ...],
    "edges": [["norm", "act"], ...],
    "constraints": {"fpga": {"LUT": 35200, "FF": 17600, "DSP": 80, "BRAM": 90}},
}

autotuner = Autotuner(spec, top_n=3)
results = autotuner.run(output_dir="build/designs")
```

### Transformer Block

```python
from transformer_block import build_transformer_block

# Assemble full block with parameters
block, drivers, manual_inputs = build_transformer_block(
    seq_len=4,   # sequence length
    emb_dim=4,   # embedding dimension
    T=2,         # tile size
)
# Run simulation...
```

## Testing

Run the full test suite:

```bash
pytest tests/ -v --timeout=120
```

## Project Structure

```text
tiled-ip/
├── docs/               # Documentation
├── src/                # Source code
│   ├── ip_cores/       # IP library
│   ├── solver.py       # Tiling optimizer
│   ├── stitcher.py     # Wiring engine
│   ├── frontend.py     # Declarative TiledIPGraph API
│   ├── autotuner.py   # Branch-and-bound autotuner
│   └── transformer_block.py  # Full transformer block
├── scripts/            # CLI tools
│   ├── generate_subgraph.py   # JSON → PyRTL module
│   ├── visualize_pareto.py    # 3D Pareto visualization
│   └── generate_ip_pareto_plots.py  # Per-IP Pareto plots
└── tests/              # Testbenches
```

## Documentation

| Document | Description |
|----------|-------------|
| [Getting Started](docs/GETTING_STARTED.md) | Overview, repo layout, quick-start examples |
| [IP Catalog](docs/IP_CATALOG.md) | All 11 IP cores with parameters and implementation details |
| [Shape Propagation](docs/SHAPE_PROPAGATION.md) | `StreamShape(N,T)` system and automatic adapter insertion |
| [Transformer Block](docs/TRANSFORMER_BLOCK.md) | Full transformer block architecture and parameterization |
| [Stitching & Solver](docs/STITCHING.md) | Stitcher wiring engine, autotuner, and code generation |
| [Autotuner](docs/AUTOTUNER.md) | Branch-and-bound tile optimization |
| [Frontend API](docs/FRONTEND_API.md) | Declarative TiledIPGraph API |
| [Pareto Visualization](docs/PARETO_VISUALIZATION.md) | Pareto frontier visualization |
| [Testing](docs/TESTING.md) | Test framework, results, and cocotb+Verilator verification |
| [Design Decisions](docs/DESIGN_DECISIONS.md) | Architecture decisions and known limitations |
| [IP Library Specification](docs/IP_LIBRARY.md) | Low-level interface specification |
| [GPT-2 Roadmap](docs/GPT2_ROADMAP.md) | Gap analysis and implementation status |
| [Temporal Streaming Tutorial](docs/GPT_TUTORIAL.md) | Macro-phase scheduling for transformer blocks |

## License

[Placeholder for License]
