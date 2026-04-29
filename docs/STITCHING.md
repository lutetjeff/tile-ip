# Stitching, Solver, and Code Generation

This document covers the integration tools: manual wiring, the Stitcher, the TilingSolver, and the code generator.

---

## 4.1 Manual Wiring

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

## 4.2 The Stitcher

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
- Raises `ValueError` if fan-in is attempted on an IP without `data_in_b`

### Wrapper I/O

`build()` returns a `drivers` dict with wrapper wires for dangling ports:
- **Source IPs (no upstream):** `Input` wires for `data_in`, `valid_in`, `last_in`; `Output` wire for `ready_out`
- **Sink IPs (no downstream):** `Output` wires for `data_out`, `valid_out`; `Input` wire for `ready_in`

### Limitations

- IP-specific side ports (e.g., `ALU.op_code`, `GEMM.weight_in`, `TemporalGEMM.accum_in`) are **not** wrapped; the testbench or top-level must drive them separately
- `last_in`/`last_out` are wired automatically for direct connections, but temporal cores often require manual `last_in` assignment after `stitcher.build()`

---

## 4.3 The TilingSolver

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

## 4.4 Code Generation

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
    {"type": "ALU", "name": "alu", "params": ["T_width"]}
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

## Further Reading

- [GETTING_STARTED.md](GETTING_STARTED.md) — Quick-start examples including Stitcher usage
- [SHAPE_PROPAGATION.md](SHAPE_PROPAGATION.md) — Automatic shape propagation and adapter insertion
- [TRANSFORMER_BLOCK.md](TRANSFORMER_BLOCK.md) — Full example with 16 IPs
- [IP_CATALOG.md](IP_CATALOG.md) — Individual IP documentation
- `src/stitcher.py` — Stitcher implementation
- `src/solver.py` — TilingSolver implementation
