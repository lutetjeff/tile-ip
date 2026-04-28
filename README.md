# tiled-ip

[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![PyRTL](https://img.shields.io/badge/backend-PyRTL-green.svg)](https://github.com/UCSBarchlab/PyRTL)
[![pytest](https://img.shields.io/badge/testing-pytest-orange.svg)](https://docs.pytest.org/)

`tiled-ip` is a dynamic-programming-driven hardware compiler for tile-based INT8 accelerators. It provides a library of parameterized IP cores and automated tools to stitch them into complex hardware pipelines, such as full GPT-2 transformer blocks.

## Key Features

*   **Parameterized IP Library:** 11 optimized IP cores (GEMM, Softmax, Norm, Activation, ALU, MemRouter, FIFO, TemporalGEMM, StatefulNorm, StatefulSoftmax, MultiBankBRAM).
*   **Automated Stitching:** A `Stitcher` engine that wires IP cores into chains or graphs using a standardized AXI4-Stream-Lite interface.
*   **DP-Driven Optimization:** A `TilingSolver` that brute-forces the tiling-parameter space `{1, 2, 4}^k` to find area/latency-optimal configurations.
*   **Hardware Verification:** Full verification stack using PyRTL simulation, cocotb, and Verilator.
*   **Transformer Ready:** Capability to assemble full GPT-2 transformer blocks.
*   **Robust Testing:** 535+ tests covering unit, compound, and end-to-end scenarios.

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

### Stitcher + Solver

```python
from solver import TilingSolver
from stitcher import Stitcher

# Define subgraph
spec = {
    "ips": [{"type": "Norm", "name": "norm", "params": ["T_channel"]}, ...],
    "edges": [["norm", "act"], ...],
}

# Solve for optimal tiling
config = TilingSolver(max_path_depth=20).solve(spec)

# Stitch IPs
stitcher = Stitcher(block=shared)
stitcher.add_ip(norm)
stitcher.connect("norm", "act")
# ...
```

### Transformer Block

```python
from transformer_block import build_transformer_block

# Assemble full block
block, drivers, manual_inputs = build_transformer_block()
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
│   └── stitcher.py     # Wiring engine
├── scripts/            # CLI tools
└── tests/              # Testbenches
```

## Documentation

- [IP Library Specification](docs/IP_LIBRARY.md)
- [Usage Guide](docs/IP_USAGE.md)
- [GPT-2 Roadmap](docs/GPT2_ROADMAP.md)
- [Temporal Streaming Tutorial](docs/GPT_TUTORIAL.md)

## License

[Placeholder for License]
