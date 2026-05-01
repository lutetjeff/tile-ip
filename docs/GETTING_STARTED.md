# Getting Started with tiled-ip

`tiled-ip` is a dynamic-programming-driven hardware compiler for tile-based INT8 accelerators. It is written in Python and uses **PyRTL** to generate synthesizable RTL.

## Repository Layout

```
src/
  solver.py              # DP-based tiling optimizer
  stitcher.py            # Generic AXI4-Stream-Lite wiring engine
  frontend.py            # Declarative TiledIPGraph API
  autotuner.py           # Branch-and-bound autotuner
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
  visualize_pareto.py    # 3D Pareto frontier visualization
  generate_ip_pareto_plots.py  # Per-IP-type Pareto plots
tests/
  test_*.py              # Unit & compound testbenches
  ref_models/            # NumPy golden models
docs/
  IP_LIBRARY.md          # Interface-level specification
  GETTING_STARTED.md     # This file
  IP_CATALOG.md          # All 11 IP cores with parameters
  SHAPE_PROPAGATION.md   # StreamShape system documentation
  TRANSFORMER_BLOCK.md   # Transformer block architecture
  STITCHING.md           # Stitcher, solver, autotuner, code generation
  TESTING.md             # Test framework and results
  DESIGN_DECISIONS.md    # Design decisions and known limitations
  AUTOTUNER.md          # Branch-and-bound autotuner documentation
  FRONTEND_API.md        # Declarative TiledIPGraph API
  PARETO_VISUALIZATION.md  # Pareto frontier visualization
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

**Note:** `last_in` and `last_out` are no longer part of the base interface. IPs that need packet boundary markers (MultiBankBRAMCore, StreamShapeAdapter) define them locally. Temporal cores (TemporalGEMMCore, StatefulNormCore, StatefulSoftmaxCore) use internal beat counters to track packet boundaries automatically.

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

### 7.2 Build an IP Chain with TiledIPGraph (Recommended)

The declarative frontend hides all PyRTL block management and monkey-patching:

```python
from frontend import TiledIPGraph
from ip_cores.norm import NormCore
from ip_cores.activation import ActivationCore
from ip_cores.alu import ALUCore

graph = TiledIPGraph()
graph.add_node("norm", NormCore, T_channel=2)
graph.add_node("act", ActivationCore, T_width=2)
graph.add_node("alu", ALUCore, T_width=2, op_mode="add")
graph.add_edge("norm", "act")
graph.add_edge("act", "alu")
block, drivers = graph.build()
```

### 7.3 Stitch a 3-IP Chain Manually (Legacy)

For advanced use cases requiring direct PyRTL access:

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

### 7.3 Use the Autotuner for Tile Optimization

The autotuner performs branch-and-bound search over tile configurations using characterization data:

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
results = autotuner.run()

# Best design: (latency_ns, config_dict, metrics_dict)
best_latency, best_config, best_metrics = results[0]
print(f"Best latency: {best_latency:.2f} ns/element")
print(f"Config: {best_config}")
```

### 7.4 Generate a Module from JSON

```bash
python scripts/generate_subgraph.py \
    --spec examples/ffn.json \
    --out build/ffn.py
```

The emitted file contains `CONFIG` and `build_ffn()`; import it, call the builder, and pass the `drivers` dict to a `pyrtl.Simulation`.

### 7.5 Visualize Pareto Frontiers

After characterization, visualize the trade-off space:

```bash
# 3D Pareto plot (LUT vs Throughput vs Power)
python scripts/visualize_pareto.py \
    --input build/characterization/characterization_results.json \
    --output build/pareto_plot.png

# Per-IP-type Pareto plots with labeled configurations
python scripts/generate_ip_pareto_plots.py
# Output: build/pareto_plots/*.png
```

### 7.6 Vivado IP Characterization

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
- [STITCHING.md](STITCHING.md) — Stitcher, autotuner, and code generation details
- [AUTOTUNER.md](AUTOTUNER.md) — Branch-and-bound autotuner documentation
- [FRONTEND_API.md](FRONTEND_API.md) — Declarative TiledIPGraph API
- [PARETO_VISUALIZATION.md](PARETO_VISUALIZATION.md) — Pareto frontier visualization
- [TESTING.md](TESTING.md) — Test framework and verification results
- [DESIGN_DECISIONS.md](DESIGN_DECISIONS.md) — Design decisions and known limitations
- [IP_LIBRARY.md](IP_LIBRARY.md) — Low-level interface specification
