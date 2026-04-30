# Getting Started with tiled-ip

`tiled-ip` is a dynamic-programming-driven hardware compiler for tile-based INT8 accelerators. It is written in Python and uses **PyRTL** to generate synthesizable RTL.

## Repository Layout

```
src/
  solver.py              # DP-based tiling optimizer
  stitcher.py            # Generic AXI4-Stream-Lite wiring engine
  ip_cores/
    axi_stream_base.py   # Universal handshake base class
    gemm.py              # INT8 matrix multiplication
    softmax.py           # LUT-based softmax
    norm.py              # LayerNorm / RMSNorm
    activation.py        # LUT-based GELU / ReLU
    alu.py               # Element-wise ADD / MULTIPLY / MASK
    mem_router.py        # BRAM-backed token fetch / transpose
    fifo.py              # Elastic buffer with backpressure handling
    temporal_gemm.py     # Accumulator-based GEMM for N_channel > T_K
    stateful_norm.py     # 2-pass LayerNorm / RMSNorm for N_channel > T_channel
    stateful_softmax.py  # 3-pass Softmax for N_seq > T_seq
    multi_bank_bram.py   # Concurrent read/write BRAM with bank arbitration
    shape_adapter.py     # Auto-inserted T mismatch resolver
  transformer_block.py   # Full transformer block assembly
scripts/
  generate_subgraph.py   # JSON spec → stitched PyRTL module
tests/
  test_*.py              # Unit & compound testbenches
  ref_models/            # NumPy golden models
docs/
  IP_LIBRARY.md          # Interface-level specification
  GETTING_STARTED.md     # This file
  IP_CATALOG.md          # All 11 IP cores with parameters
  SHAPE_PROPAGATION.md   # StreamShape system documentation
  TRANSFORMER_BLOCK.md   # Transformer block architecture
  STITCHING.md           # Stitcher, solver, code generation
  TESTING.md             # Test framework and results
  DESIGN_DECISIONS.md    # Design decisions and known limitations
```

## Key Concepts

### StreamShape

All IPs use `StreamShape(N, T)` to declare their tensor shape, where:
- `N` = total number of elements in the tensor
- `T` = elements per beat (spatial tiling factor)

The Stitcher propagates shapes topologically and auto-inserts `StreamShapeAdapter` when T mismatches between connected IPs.

See [SHAPE_PROPAGATION.md](SHAPE_PROPAGATION.md) for full details.

### Universal AXI4-Stream-Lite Interface

Every IP inherits from `AXI4StreamLiteBase`. This guarantees that the Stitcher can connect any pair of cores without custom glue logic.

| Signal | Width | Direction | Meaning |
|--------|-------|-----------|---------|
| `data_in`  | `T × 8` | In  | Flattened INT8 input tile (byte-0 at LSB) |
| `valid_in` | 1       | In  | Upstream asserts valid data |
| `ready_out`| 1       | Out | IP can accept data this cycle |
| `data_out` | `T × 8` | Out | Flattened INT8 output tile |
| `valid_out`| 1       | Out | IP asserts valid output |
| `ready_in` | 1       | In  | Downstream can accept data |
| `last_in`  | 1       | In  | TLAST marker from upstream, end of multi-beat packet |
| `last_out` | 1       | Out | TLAST marker to downstream |

---

## Quick-Start Examples

### 7.1 Instantiate a Single IP and Simulate It

```python
import pyrtl
import numpy as np
from ip_cores.gemm import GEMMCore

core = GEMMCore(T_M=2, T_K=2, T_N=2, name="g1")
# Create wrapper inputs for simulation
d_in = pyrtl.Input(core.data_in.bitwidth, "d_in")
v_in = pyrtl.Input(1, "v_in")
r_in = pyrtl.Input(1, "r_in")
w_in = pyrtl.Input(core.weight_in.bitwidth, "w_in")
wv_in = pyrtl.Input(1, "wv_in")

core.data_in <<= d_in
core.valid_in <<= v_in
core.ready_in <<= r_in
core.weight_in <<= w_in
core.weight_valid_in <<= wv_in

sim = pyrtl.Simulation(tracer=None, block=core.block)
sim.step({d_in: 0x01020304, v_in: 1, r_in: 1, w_in: 0x01010101, wv_in: 1})
print(sim.inspect(core.data_out.name))
```

### 7.2 Stitch a 3-IP Chain Manually

```python
import pyrtl
from ip_cores.norm import NormCore
from ip_cores.activation import ActivationCore
from ip_cores.alu import ALUCore

shared = pyrtl.Block()
norm = NormCore(T_channel=2, name="n1", block=shared)
act = ActivationCore(T_width=2, name="a1")
# a1 does not accept block=; use monkey-patch trick
old_Block = pyrtl.Block
pyrtl.Block = lambda: shared
alu = ALUCore(T_width=2, name="u1")
pyrtl.Block = old_Block

with pyrtl.set_working_block(shared, no_sanity_check=True):
    act.data_in <<= norm.data_out
    act.valid_in <<= norm.valid_out
    norm.ready_in <<= act.ready_out

    alu.data_in <<= act.data_out
    alu.valid_in <<= act.valid_out
    act.ready_in <<= alu.ready_out
```

### 7.3 Use the Stitcher and Solver Together

```python
from solver import TilingSolver
from stitcher import Stitcher

spec = {
    "name": "ffn",
    "ips": [
        {"type": "Norm", "name": "norm", "params": ["T_channel"]},
        {"type": "Activation", "name": "act", "params": ["T_width"]},
        {"type": "ALU", "name": "alu", "params": ["T_width"]},
    ],
    "edges": [["norm", "act"], ["act", "alu"]],
    "constraints": {"max_area": 5000},
}

config = TilingSolver(max_path_depth=20).solve(spec)
# config is ready to feed into generate_subgraph.py
```

### 7.4 Generate a Module from JSON

```bash
python scripts/generate_subgraph.py \
    --spec examples/ffn.json \
    --out build/ffn.py
```

The emitted file contains `CONFIG` and `build_ffn()`; import it, call the builder, and pass the `drivers` dict to a `pyrtl.Simulation`.

### 7.5 Vivado IP Characterization

Export all IPs to Verilog and run Vivado Out-of-Context (OOC) synthesis and implementation to collect resource, timing, and power metrics:

```bash
# Single-threaded sweep
python scripts/characterize_ips.py --part xc7s50csga324-2 --clock-period 10.0

# Parallel sweep (N concurrent Vivado jobs)
python scripts/characterize_ips_parallel.py -j 4 --outdir build/char_full

# Resume an interrupted sweep
python scripts/characterize_ips_parallel.py -j 4 --outdir build/char_full --resume
```

Results are written to `build/characterization/characterization_results.json` with entries for every `(IP, tile_params)` combination.

---

## Further Reading

- [IP_CATALOG.md](IP_CATALOG.md) — All 11 IP cores with parameters, implementation details, and gotchas
- [SHAPE_PROPAGATION.md](SHAPE_PROPAGATION.md) — StreamShape system and automatic shape propagation
- [TRANSFORMER_BLOCK.md](TRANSFORMER_BLOCK.md) — Full transformer block architecture
- [STITCHING.md](STITCHING.md) — Stitcher, solver, and code generation details
- [TESTING.md](TESTING.md) — Test framework and verification results
- [DESIGN_DECISIONS.md](DESIGN_DECISIONS.md) — Design decisions and known limitations
- [IP_LIBRARY.md](IP_LIBRARY.md) — Low-level interface specification
