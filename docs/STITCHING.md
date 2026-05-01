# Stitching, Solver, and Code Generation

This document covers the integration tools: manual wiring, the Stitcher, the TilingSolver, and the code generator.

---

## 4.1 TiledIPGraph — Declarative Frontend (Recommended)

For most use cases, use the `TiledIPGraph` class from `frontend.py`:

```python
from frontend import TiledIPGraph
from ip_cores.gemm import GEMMCore
from ip_cores.softmax import SoftmaxCore

graph = TiledIPGraph()
graph.add_node("gemm", GEMMCore, T_M=2, T_K=2, T_N=2)
graph.add_node("softmax", SoftmaxCore, T_seq=2)
graph.add_edge("gemm", "softmax")
block, drivers = graph.build()
```

This hides all PyRTL block management, monkey-patching, and wiring complexity.

## 4.2 Manual Wiring (Legacy)

For ad-hoc experiments you can wire two IPs directly in a shared block:

```python
import pyrtl
from ip_cores.gemm import GEMMCore
from ip_cores.softmax import SoftmaxCore

shared = pyrtl.Block()
gemm = GEMMCore(T_M=2, T_K=2, T_N=2, name="gemm", block=shared)
softmax = SoftmaxCore(T_seq=2, name="soft", block=shared)

with pyrtl.set_working_block(shared, no_sanity_check=True):
    softmax.data_in  <<= gemm.data_out
    softmax.valid_in <<= gemm.valid_out
    gemm.ready_in    <<= softmax.ready_out
```

**Rule of thumb:** forward datapath (`data_out → data_in`, `valid_out → valid_in`), reverse backpressure (`ready_out → ready_in`).

**Note:** Some IPs (Norm, Activation, ALU) don't accept a `block=` parameter. Use the monkey-patch trick:

```python
old_Block = pyrtl.Block
pyrtl.Block = lambda: shared  # All new IPs go to shared block
norm = NormCore(T_channel=2, name="n1")
alu = ALUCore(T_width=2, name="u1")
pyrtl.Block = old_Block  # Restore
```

---

## 4.3 The Stitcher

**File:** `src/stitcher.py`

The `Stitcher` class automates the manual pattern above. It accepts a list of edges `(src_name, dst_name)`, wires the AXI4-Stream-Lite ports, handles **fan-out** (`ready_in` = OR of all downstream `ready_out` signals), **fan-in** (N→1 for IPs with `data_in_b`), and exposes wrapper `Input`/`Output` wires for every dangling port.

### Basic Usage

```python
from stitcher import Stitcher

stitcher = Stitcher(block=shared)
stitcher.add_ip(gemm)
stitcher.add_ip(softmax)
stitcher.connect("gemm", "soft")
block, drivers = stitcher.build()
```

### Fan-Out (1→N)

The source's `ready_in` is driven by the OR of all downstream `ready_out` signals.

### Fan-In (N→1)

Supported for IPs that expose a `data_in_b` port (e.g., `ALUCore`):
- The first upstream drives `data_in`, the second upstream drives `data_in_b`
- `valid_in` is the AND of all upstream `valid_out` signals
- Each upstream's `ready_in` is driven by the consumer's `ready_out`
- **Fan-in backpressure fix:** When a destination has multiple upstreams (e.g., ALU receiving from both a compute path and a residual FIFO), the Stitcher gates each upstream's `ready_in` with `dst.ready_out AND AND(other_upstreams.valid_out)`. This prevents premature draining of short-latency paths.

### Wrapper I/O

`build()` returns a `drivers` dict with wrapper wires for dangling ports:
- **Source IPs (no upstream):** `Input` wires for `data_in`, `valid_in`; `Output` wire for `ready_out`
- **Sink IPs (no downstream):** `Output` wires for `data_out`, `valid_out`; `Input` wire for `ready_in`

### Limitations

- IP-specific side ports (e.g., `GEMM.weight_in`, `TemporalGEMM.accum_in`, `TemporalGEMM.emit_in`) are **not** wrapped; the testbench or top-level must drive them separately
- Temporal cores (TemporalGEMMCore, StatefulNormCore, StatefulSoftmaxCore) use internal beat counters and do not require external `last_in` signals

---

## 4.4 The TilingSolver

**File:** `src/solver.py`

Given a subgraph JSON, the solver brute-forces all combinations of tiling parameters in `{1, 2, 4}^k` and returns the configuration that minimizes `area + latency` while respecting a timing constraint on combinational critical-path depth.

### Cost Model (LUT Estimates)

| IP | Area formula |
|----|-------------|
| GEMM | `T_M · T_K · T_N · 50` |
| Softmax | `T_seq · 30` |
| Norm | `T_channel · 25` |
| Activation | `T_width · 10` |
| ALU | `T_width · 15` |
| MemRouter | `T_out · 5` |
| FIFO | `T_width · depth · 2` |
| TemporalGEMM | `T_M · T_K · T_N · 50 + T_M · T_N · 32` (accumulators) |
| StatefulNorm | `T_channel · 25 + N_channel / T_channel · T_channel · 8` (BRAM buffer) |
| StatefulSoftmax | `T_seq · 30 + T_seq · 8` (state registers) |
| MultiBankBRAM | `num_banks · T · addr_width · 2` |

### Latency Model (cycles)

| IP | Latency |
|----|---------|
| GEMM | `T_K + 1` |
| Softmax | `log₂(T_seq) + T_seq + log₂(T_seq) + 1` |
| Norm | `log₂(T_channel) + 1` |
| Activation | 0 (combinational) |
| ALU | 1 (registered) |
| MemRouter | `T_out` (sequential read) |
| FIFO | 0 (sequential, pointer logic) |
| TemporalGEMM | `N_channel / T_K + 1` (accumulate + emit) |
| StatefulNorm | `2 · N_channel / T_channel + 1` (statistics + normalize + compute) |
| StatefulSoftmax | `3 · N_seq / T_seq` (3 passes) |
| MultiBankBRAM | `burst_len` (sequential burst) |

### Critical-Path Depth (gate equivalents)

| IP | Depth |
|----|-------|
| GEMM | `log₂(T_K) · 3` |
| Softmax | `log₂(T_seq) · 2 + 8` |
| Norm | `log₂(T_channel) · 2 + 4` |
| Activation | 2 |
| ALU | 3 |
| MemRouter | 2 |
| FIFO | 2 |
| TemporalGEMM | `log₂(T_K) · 3 + 2` (MAC + accumulator mux) |
| StatefulNorm | `log₂(T_channel) · 2 + 4` (same as Norm) |
| StatefulSoftmax | `log₂(T_seq) · 2 + 8` (same as Softmax) |
| MultiBankBRAM | 2 (bank mux) |

### Example Invocation

```python
from solver import TilingSolver

subgraph = {
    "ips": [
        {"type": "Norm", "name": "norm", "params": ["T_channel"]},
        {"type": "Activation", "name": "act", "params": ["T_width"]},
        {"type": "ALU", "name": "alu", "params": ["T_width"]},
    ],
    "edges": [["norm", "act"], ["act", "alu"]],
    "constraints": {"max_area": 5000},
}

solver = TilingSolver(max_path_depth=20)
config = solver.solve(subgraph)
# config → {"norm": {"T_channel": 1}, "act": {"T_width": 1}, "alu": {"T_width": 1}}
```

All three standard subgraphs (FFN, Attention, Mem→Compute) solve in **< 1 second**.

---

## 4.5 Code Generation

**File:** `scripts/generate_subgraph.py`

A CLI that chains the solver and the Stitcher into a single command:

```bash
python scripts/generate_subgraph.py \
    --spec examples/ffn.json \
    --out build/ffn.py \
    --max-path-depth 20
```

The generated Python module contains:
- A `CONFIG` dict with the solver-selected tiling parameters
- A `build_<name>()` function that instantiates all IPs, wires them via `Stitcher`, and returns the block plus a `drivers` dictionary of wrapper `Input`/`Output` wires

This lets you go from a high-level JSON graph description to a runnable PyRTL simulation in one step.

### JSON Graph Format

```json
{
  "name": "ffn",
  "ips": [
    {"type": "Norm", "name": "norm", "params": ["T_channel"]},
    {"type": "Activation", "name": "act", "params": ["T_width"]},
    {"type": "ALU", "name": "alu", "params": ["T_width"}
  ],
  "edges": [["norm", "act"], ["act", "alu"]],
  "constraints": {"max_area": 5000}
}
```

### Generated Output Structure

```python
# build/ffn.py
CONFIG = {"norm": {"T_channel": 2}, "act": {"T_width": 2}, "alu": {"T_width": 2}}

def build_ffn():
    shared = pyrtl.Block()
    # ... instantiate IPs ...
    # ... wire via Stitcher ...
    return block, drivers
```

---

## 4.6 The Autotuner

**File:** `src/autotuner.py`

The autotuner performs branch-and-bound search over tile-factor assignments using characterization data. It replaces/supplements the `TilingSolver` for FPGA targets with known resource constraints.

### Latency Model

Per-element latency formula:

```
Latency(ns/element) = (1000 / min_fmax) * (max_beats * max_ii + congestion) / total_elements
```

Where:
- `min_fmax` is the minimum fmax across all IPs in the configuration
- `max_beats` is the maximum number of beats among all IPs
- `max_ii` is the maximum initiation interval
- `congestion` is 0/1/2/3 based on utilization (0 for <50%, 1 for <75%, 2 for <87.5%, 3 for >=87.5%)
- `total_elements` is the number of elements processed

### Pruning Rules

Configurations are pruned if:
1. **Utilization > 100%:** Total resource usage exceeds FPGA capacity
2. **Latency > 1.5× best:** Per-element latency exceeds 1.5× the current best

### Top-N Selection

A bounded priority queue keeps the N best designs (default N=5). Results are sorted by latency ascending.

### Tile Factor Search Space

Tile factors are swept from `{1, 2, 4, 8, 16}` for each parameter.

### Example Invocation

```python
from autotuner import Autotuner, CharacterizationDB

spec = {
    "name": "ffn",
    "ips": [
        {"type": "Norm", "name": "norm", "params": ["T_channel"]},
        {"type": "Activation", "name": "act", "params": ["T_width"]},
        {"type": "ALU", "name": "alu", "params": ["T_width"]},
    ],
    "edges": [["norm", "act"], ["act", "alu"]],
    "constraints": {"fpga": {"LUT": 35200, "FF": 17600, "DSP": 80, "BRAM": 90}},
}

char_db = CharacterizationDB()
autotuner = Autotuner(spec, char_db=char_db, top_n=3)
results = autotuner.run(output_dir="build/designs")

# Best design: (latency_ns, config_dict, metrics_dict)
best_latency, best_config, best_metrics = results[0]
```

See [AUTOTUNER.md](AUTOTUNER.md) for full documentation.

---

## 4.7 TiledIPGraph Frontend API

**File:** `src/frontend.py`

`TiledIPGraph` provides a declarative Networkx-style API that hides all PyRTL block management and monkey-patching.

### Class Overview

```python
class TiledIPGraph:
    def __init__(self) -> None:
        """Creates a hidden shared pyrtl.Block and Stitcher."""

    def add_node(self, name: str, ip_class: type, **kwargs) -> Any:
        """Instantiate and register an IP node."""

    def add_edge(self, src: str, dst: str) -> None:
        """Add a directed connection from src to dst."""

    def set_input_shape(self, name: str, N: int, T: int) -> None:
        """Assign an input shape to a node for shape propagation."""

    def build(self) -> tuple[pyrtl.Block, dict[str, Any]]:
        """Build and return the stitched PyRTL block and drivers dict."""
```

### Example: Building a Simple Chain

```python
from frontend import TiledIPGraph
from ip_cores.norm import NormCore
from ip_cores.activation import ActivationCore

graph = TiledIPGraph()
graph.add_node("norm", NormCore, T_channel=2)
graph.add_node("act", ActivationCore, T_width=2)
graph.add_edge("norm", "act")
block, drivers = graph.build()
```

### Example: Building a Transformer Block

```python
from frontend import TiledIPGraph
from ip_cores.stateful_norm import StatefulNormCore
from ip_cores.temporal_gemm import TemporalGEMMCore
from ip_cores.alu import ALUCore

graph = TiledIPGraph()
norm1 = graph.add_node("norm1", StatefulNormCore, T_channel=T, N_channel=seq_len)
tgemm1 = graph.add_node("tgemm1", TemporalGEMMCore, T_M=1, T_K=T, T_N=T, M=seq_len // T, N=T)
alu1 = graph.add_node("alu1", ALUCore, T_width=T, op_mode="add")
# ... add more nodes ...
graph.add_edge("norm1", "tgemm1")
graph.add_edge("tgemm1", "alu1")
# ... add more edges ...
block, drivers = graph.build()
```

### Comparison with Manual Stitcher

| Aspect | TiledIPGraph | Manual Stitcher |
|--------|--------------|-----------------|
| PyRTL Block | Automatic | Manual monkey-patch |
| add_node | One call | Separate instantiation |
| add_edge | One call | connect() call |
| Shape propagation | Automatic | Manual or via Stitcher |
| Flexibility | Limited to graph structure | Full PyRTL access |

See [FRONTEND_API.md](FRONTEND_API.md) for full documentation.

---

## Further Reading

- [GETTING_STARTED.md](GETTING_STARTED.md) — Quick-start examples including Stitcher usage
- [SHAPE_PROPAGATION.md](SHAPE_PROPAGATION.md) — Automatic shape propagation and adapter insertion
- [TRANSFORMER_BLOCK.md](TRANSFORMER_BLOCK.md) — Full example with 16 IPs
- [AUTOTUNER.md](AUTOTUNER.md) — Branch-and-bound autotuner documentation
- [FRONTEND_API.md](FRONTEND_API.md) — Declarative TiledIPGraph API
- [IP_CATALOG.md](IP_CATALOG.md) — Individual IP documentation
- `src/stitcher.py` — Stitcher implementation
- `src/solver.py` — TilingSolver implementation
- `src/autotuner.py` — Autotuner implementation
- `src/frontend.py` — TiledIPGraph implementation
