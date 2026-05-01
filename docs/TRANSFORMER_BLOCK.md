# Transformer Block Architecture

The transformer block (`src/transformer_block.py`) implements a simplified transformer-like architecture using the `tiled-ip` framework. It demonstrates how to wire together temporal and combinational IPs into a complete accelerator pipeline.

---

## Architecture Overview

```
Input → FIFO(residual) │
        └→ Norm → TemporalGEMM → StatefulSoftmax → TemporalGEMM → ALU_Add → Norm → TemporalGEMM → Activation → TemporalGEMM → ALU_Add → Output
```

### Dataflow Paths

1. **Residual Path:** Input branches to `fifo1` for delay alignment
2. **Attention Path:** `norm1` → `tgemm1` → `softmax` → `tgemm2` → `alu1` (residual add)
3. **FFN Path:** `alu1` → `norm2` → `tgemm3` → `activation` → `tgemm4` → `alu2` (residual add)

### IP Components

| IP | Name | Function |
|----|------|----------|
| `FIFOCore` | `fifo1` | Residual delay buffer (depth=8) |
| `StatefulNormCore` | `norm1` | Attention-path normalization |
| `TemporalGEMMCore` | `tgemm1` | Q/K projection |
| `StatefulSoftmaxCore` | `softmax` | Attention scores softmax |
| `TemporalGEMMCore` | `tgemm2` | V projection |
| `ALUCore` | `alu1` | Attention residual add |
| `FIFOCore` | `df1–df4` | FFN timing alignment (depth=1 each) |
| `FIFOCore` | `fifo2` | FFN residual delay buffer (depth=8) |
| `StatefulNormCore` | `norm2` | FFN-path normalization |
| `TemporalGEMMCore` | `tgemm3` | FFN expand |
| `ActivationCore` | `activation` | ReLU non-linearity |
| `TemporalGEMMCore` | `tgemm4` | FFN project |
| `ALUCore` | `alu2` | FFN residual add |

---

## `build_transformer_block()` Function

**File:** `src/transformer_block.py`

```python
def build_transformer_block(seq_len: int = 4, emb_dim: int = 4, T: int = 2):
    """Build a transformer block with the tiled-ip framework.

    Parameters
    ----------
    seq_len : int
        Sequence length (default 4).
    emb_dim : int
        Embedding dimension (default 4).
    T : int
        Tile size used for T_width, T_seq, T_channel, T_K, T_N (default 2).

    Returns
    -------
    tuple
        (built_block, drivers, manual_inputs)
    """
```

---

## Parameter Derivation

The function derives all internal tiling parameters from three top-level parameters:

| Top-Level | Internal Usage | Derived Value |
|-----------|---------------|---------------|
| `seq_len` | `norm1.N_channel`, `fifo1.N` | `seq_len` |
| `emb_dim` | `norm2.N_channel`, `fifo2.N` | `emb_dim` |
| `T` | All `T_M`, `T_K`, `T_N`, `T_seq`, `T_channel`, `T_width` | `T` |

### TemporalGEMM Parameters

All four `TemporalGEMMCore` instances use:
- `T_M = 1` (one row per beat)
- `T_K = T` (matches tiling parameter)
- `T_N = T` (matches tiling parameter)
- `M = seq_len // T` (number of tile rows for Q/K and V projections)
- `N = T` (output dimension per beat)

| Instance | M | N | Purpose |
|----------|---|---|---------|
| `tgemm1` | `seq_len // T` | `T` | Q/K projection |
| `tgemm2` | `seq_len // T` | `T` | V projection |
| `tgemm3` | `seq_len // T` | `T` | FFN expand |
| `tgemm4` | `seq_len // T` | `T` | FFN project |

---

## Shape Flow Through the Pipeline

### Input Shapes

```python
fifo1.input_shape = StreamShape(seq_len, T)  # Residual buffer
norm1.input_shape = StreamShape(seq_len, T)  # Attention norm input
fifo2.input_shape = StreamShape(emb_dim, T)  # FFN residual buffer
```

### Attention Path

```
norm1 output → tgemm1 (Q/K) → softmax → tgemm2 (V) → alu1 (+ residual)
```

- `norm1` outputs `StreamShape(seq_len, T)`
- `tgemm1` transforms to attention score space
- `softmax` produces probabilities
- `tgemm2` projects to value space
- `alu1` adds residual from `fifo1`

### FFN Path

```
alu1 → norm2 → tgemm3 (expand) → activation → tgemm4 (project) → alu2 (+ residual)
```

- `alu1` output feeds both `norm2` and delay FIFOs
- Delay FIFOs (`df1`→`df2`→`df3`→`df4`→`fifo2`) align timing
- `norm2` normalizes
- `tgemm3` expands channel dimension
- `activation` applies ReLU
- `tgemm4` projects back
- `alu2` adds residual from `fifo2`

---

## Residual Connections

### How They Work

Residual connections use `FIFOCore` to introduce delay matching the computation latency:

1. **Input branching:** The input simultaneously feeds both the compute path and a FIFO
2. **Computation:** Data flows through normalization, GEMMs, softmax, etc.
3. **Residual add:** After computation completes, the FIFO output is added to the result via `ALUCore`

### FIFOs Used

| FIFO | Depth | Purpose |
|------|-------|---------|
| `fifo1` | 8 | Attention residual delay |
| `fifo2` | 8 | FFN residual delay |
| `df1–df4` | 1 each | FFN path timing alignment |

### Timing Alignment

The four single-depth FIFOs (`df1`–`df4`) ensure the FFN path timing matches the residual path timing so that `alu2` receives both operands simultaneously.

---

## How TiledIPGraph Builds the Transformer

The transformer block uses `TiledIPGraph` to declaratively specify the IP graph:

```python
from frontend import TiledIPGraph
from ip_cores.stateful_norm import StatefulNormCore
from ip_cores.temporal_gemm import TemporalGEMMCore
from ip_cores.stateful_softmax import StatefulSoftmaxCore
from ip_cores.alu import ALUCore
from ip_cores.fifo import FIFOCore
from ip_cores.activation import ActivationCore

graph = TiledIPGraph()
fifo1 = graph.add_node("fifo1", FIFOCore, T_width=T, depth=8)
norm1 = graph.add_node("norm1", StatefulNormCore, T_channel=T, N_channel=seq_len)
tgemm1 = graph.add_node("tgemm1", TemporalGEMMCore, T_M=1, T_K=T, T_N=T, M=seq_len // T, N=T)
softmax = graph.add_node("softmax", StatefulSoftmaxCore, N_seq=seq_len, T_seq=T)
tgemm2 = graph.add_node("tgemm2", TemporalGEMMCore, T_M=1, T_K=T, T_N=T, M=seq_len // T, N=T)
alu1 = graph.add_node("alu1", ALUCore, T_width=T, op_mode="add")
# ... remaining nodes ...

graph.add_edge("norm1", "tgemm1")
graph.add_edge("tgemm1", "softmax")
# ... remaining edges ...
```

**Key improvements over manual stitching:**
- No monkey-patching `pyrtl.Block`
- No manual `last_in` wiring (temporal cores use internal beat counters)
- No `op_code` drivers (ALU mode set via constructor `op_mode` parameter)
- Automatic shape propagation and adapter insertion

### Manual Inputs Requiring External Drivers

After `graph.build()`, only weight-related signals require external drivers:

| Signal | Purpose |
|--------|---------|
| `tgemm*_weight_in` | Weight data for all 4 GEMMs |
| `tgemm*_weight_valid` | Weight validity signals |
| `accum_in` / `emit_in` | TemporalGEMM control (typically tied to constants) |

---

## Return Values

`build_transformer_block()` returns a 3-tuple:

```python
return built_block, drivers, manual_inputs
```

| Return | Type | Description |
|--------|------|-------------|
| `built_block` | `pyrtl.Block` | The shared PyRTL block |
| `drivers` | `dict[str, WireVector]` | Wrapper Input/Output wires for dangling ports |
| `manual_inputs` | `dict[str, WireVector]` | Manual wiring inputs for external control |

---

## Usage Example

```python
from transformer_block import build_transformer_block
import pyrtl

# Build the transformer block
block, drivers, manual_inputs = build_transformer_block(seq_len=8, emb_dim=16, T=2)

# Create simulation
sim = pyrtl.Simulation(tracer=None, block=block)

# Drive inputs through the drivers dict
# Note: weight inputs (tgemm*_weight_in) and accum_in/emit_in
# must be driven externally via manual_inputs

# Run simulation
sim.step({...})
```

### Example Script

See `examples/transformer_block.py` for a runnable example that builds the block with `TiledIPGraph` and prints the resulting drivers dictionary.

Build and run it with:

```bash
python examples/transformer_block.py
```

---

## Further Reading

- [GETTING_STARTED.md](GETTING_STARTED.md) — Quick-start examples
- [FRONTEND_API.md](FRONTEND_API.md) — TiledIPGraph declarative API
- [SHAPE_PROPAGATION.md](SHAPE_PROPAGATION.md) — StreamShape system
- [STITCHING.md](STITCHING.md) — Detailed Stitcher API
- [AUTOTUNER.md](AUTOTUNER.md) — Branch-and-bound autotuner
- [IP_CATALOG.md](IP_CATALOG.md) — Individual IP documentation
- `src/transformer_block.py` — Full implementation
- `tests/test_transformer_block.py` — Verification tests
