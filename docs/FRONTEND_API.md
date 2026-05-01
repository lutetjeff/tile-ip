# Declarative Frontend API

This document describes the `TiledIPGraph` class for declaratively building IP graphs.

---

## Overview

`TiledIPGraph` provides a Networkx-style API that hides all PyRTL block management and monkey-patching complexity. It wraps the `Stitcher` class and provides a simpler interface for building IP pipelines.

**File:** `src/frontend.py`

---

## TiledIPGraph Class

### Constructor

```python
class TiledIPGraph:
    def __init__(self) -> None:
        """Creates a hidden shared pyrtl.Block and Stitcher."""
```

The constructor creates:
- An internal `pyrtl.Block()` for all IPs
- An internal `Stitcher` instance wired to that block
- An empty dictionary to track registered nodes

### Methods

#### `add_node(name: str, ip_class: type, **kwargs) -> Any`

Instantiate and register an IP node.

```python
def add_node(self, name: str, ip_class: type, **kwargs: Any) -> Any:
```

**Parameters:**
- `name`: Unique graph node name (must not already exist)
- `ip_class`: IP core class to instantiate (e.g., `GEMMCore`, `NormCore`)
- `**kwargs`: Additional constructor arguments forwarded to `ip_class`

**Returns:** The instantiated IP instance

**Example:**
```python
graph = TiledIPGraph()
gemm = graph.add_node("gemm", GEMMCore, T_M=2, T_K=2, T_N=2)
norm = graph.add_node("norm", NormCore, T_channel=4)
```

#### `add_edge(src: str, dst: str) -> None`

Add a directed connection from `src` to `dst`.

```python
def add_edge(self, src: str, dst: str) -> None:
```

**Parameters:**
- `src`: Source node name (must exist)
- `dst`: Destination node name (must exist)

**Example:**
```python
graph.add_edge("gemm", "norm")  # gemm output -> norm input
```

#### `set_input_shape(name: str, N: int, T: int) -> None`

Assign an input shape to a node for shape propagation.

```python
def set_input_shape(self, name: str, N: int, T: int) -> None:
```

**Parameters:**
- `name`: Node name (must exist)
- `N`: Total number of elements
- `T`: Elements per beat (tiling factor)

**Example:**
```python
graph.set_input_shape("gemm", N=1024, T=8)
```

This seeds shape propagation for downstream IPs that need to know their input shape.

#### `build() -> tuple[pyrtl.Block, dict[str, Any]]`

Build and return the stitched PyRTL block and drivers dictionary.

```python
def build(self) -> tuple[pyrtl.Block, dict[str, Any]]:
```

**Returns:**
- `pyrtl.Block`: The shared PyRTL block containing all wired IPs
- `dict[str, Any]`: Driver wire dictionary mapping names to `Input`/`Output` wires

The drivers dictionary contains wrapper wires for dangling ports:
- Source nodes (no upstream): `"{name}_data_in"`, `"{name}_valid_in"` as `Input`s; `"{name}_ready_out"` as `Output`
- Sink nodes (no downstream): `"{name}_data_out"`, `"{name}_valid_out"` as `Output`s; `"{name}_ready_in"` as `Input`

---

## Examples

### Building a Simple Chain

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

### Building a Multi-Path Graph

```python
from frontend import TiledIPGraph
from ip_cores.gemm import GEMMCore
from ip_cores.alu import ALUCore
from ip_cores.fifo import FIFOCore

graph = TiledIPGraph()

# Add nodes
graph.add_node("gemm", GEMMCore, T_M=1, T_K=4, T_N=4)
graph.add_node("fifo", FIFOCore, T_width=4, depth=8)
graph.add_node("alu", ALUCore, T_width=4, op_mode="add")

# Add edges (fan-out: gemm output goes to both alu and fifo)
graph.add_edge("gemm", "alu")
graph.add_edge("gemm", "fifo")

block, drivers = graph.build()
```

### Building a Transformer Block

```python
from frontend import TiledIPGraph
from ip_cores.stateful_norm import StatefulNormCore
from ip_cores.temporal_gemm import TemporalGEMMCore
from ip_cores.stateful_softmax import StatefulSoftmaxCore
from ip_cores.alu import ALUCore
from ip_cores.fifo import FIFOCore
from ip_cores.activation import ActivationCore

T = 2
seq_len = 8

graph = TiledIPGraph()

# Attention path
fifo1 = graph.add_node("fifo1", FIFOCore, T_width=T, depth=8)
norm1 = graph.add_node("norm1", StatefulNormCore, T_channel=T, N_channel=seq_len)
tgemm1 = graph.add_node("tgemm1", TemporalGEMMCore, T_M=1, T_K=T, T_N=T, M=seq_len // T, N=T)
softmax = graph.add_node("softmax", StatefulSoftmaxCore, N_seq=seq_len, T_seq=T)
tgemm2 = graph.add_node("tgemm2", TemporalGEMMCore, T_M=1, T_K=T, T_N=T, M=seq_len // T, N=T)
alu1 = graph.add_node("alu1", ALUCore, T_width=T, op_mode="add")

# FFN path
df1 = graph.add_node("df1", FIFOCore, T_width=T, depth=1)
df2 = graph.add_node("df2", FIFOCore, T_width=T, depth=1)
df3 = graph.add_node("df3", FIFOCore, T_width=T, depth=1)
df4 = graph.add_node("df4", FIFOCore, T_width=T, depth=1)
fifo2 = graph.add_node("fifo2", FIFOCore, T_width=T, depth=8)
norm2 = graph.add_node("norm2", StatefulNormCore, T_channel=T, N_channel=seq_len)
tgemm3 = graph.add_node("tgemm3", TemporalGEMMCore, T_M=1, T_K=T, T_N=T, M=seq_len // T, N=T)
activation = graph.add_node("activation", ActivationCore, T_width=T, activation_type="relu")
tgemm4 = graph.add_node("tgemm4", TemporalGEMMCore, T_M=1, T_K=T, T_N=T, M=seq_len // T, N=T)
alu2 = graph.add_node("alu2", ALUCore, T_width=T, op_mode="add")

# Connect attention path
graph.add_edge("norm1", "tgemm1")
graph.add_edge("tgemm1", "softmax")
graph.add_edge("softmax", "tgemm2")
graph.add_edge("tgemm2", "alu1")
graph.add_edge("fifo1", "alu1")

# Connect FFN path
graph.add_edge("alu1", "norm2")
graph.add_edge("alu1", "df1")
graph.add_edge("df1", "df2")
graph.add_edge("df2", "df3")
graph.add_edge("df3", "df4")
graph.add_edge("df4", "fifo2")
graph.add_edge("norm2", "tgemm3")
graph.add_edge("tgemm3", "activation")
graph.add_edge("activation", "tgemm4")
graph.add_edge("tgemm4", "alu2")
graph.add_edge("fifo2", "alu2")

# Set input shapes
graph.set_input_shape("fifo1", seq_len, T)
graph.set_input_shape("norm1", seq_len, T)
graph.set_input_shape("fifo2", seq_len, T)

block, drivers = graph.build()
```

### Example Scripts

The repository includes runnable examples built on `TiledIPGraph`:

- `examples/ffn_block.py` — minimal FFN block
- `examples/transformer_block.py` — full transformer block with attention and FFN paths

Use them as starting points for custom graph assembly and simulation scaffolding.

---

## Shape Propagation

`TiledIPGraph` uses the `Stitcher`'s shape propagation system:

1. If a node has `input_shape` set (via `set_input_shape()` or directly), its `output_shape` is inferred
2. When connecting edges, the Stitcher checks if tiling parameters match
3. If T mismatches between connected IPs, a `StreamShapeAdapter` is automatically inserted

```python
# T mismatch: norm outputs T=4, but tgemm expects T=2
graph.add_edge("norm", "tgemm")
# Stitcher automatically inserts: norm -> adapter(T_out=2) -> tgemm
```

---

## Comparison with Manual Stitcher

| Aspect | TiledIPGraph | Manual Stitcher |
|--------|--------------|-----------------|
| PyRTL Block | Automatic | Manual management |
| Block monkey-patching | Hidden | User must handle |
| add_node | One call | Separate instantiation |
| add_edge | One call | connect() call |
| Shape propagation | Automatic | Via Stitcher |
| Custom PyRTL logic | Not possible | Full access |
| Fan-in support | Via Stitcher | Via Stitcher |

---

## When to Use TiledIPGraph vs Manual Stitcher

**Use TiledIPGraph when:**
- Building standard IP pipelines (chains, trees, DAGs)
- You want simple, readable code
- You don't need custom PyRTL logic

**Use Manual Stitcher when:**
- You need to add custom PyRTL wires or logic
- You're building non-standard topologies
- You need direct access to the PyRTL block during construction
- You're debugging and need to inspect intermediate wires

---

## Implementation Details

### Internal Block Management

```python
@contextmanager
def _shared_block(block: pyrtl.Block) -> Iterator[None]:
    """Temporarily route pyrtl.Block() construction to *block*."""
    original_block = pyrtl.Block
    pyrtl.Block = lambda: block
    try:
        yield
    finally:
        pyrtl.Block = original_block
```

This context manager redirects `pyrtl.Block()` calls to the shared block while an IP is being instantiated. It restores the original after the IP is created.

### Error Handling

- `add_node()` raises `ValueError` if a node with the same name already exists
- `add_edge()` raises `ValueError` if either node name is not registered
- `set_input_shape()` raises `ValueError` if the node name is not registered
- `build()` delegates to `Stitcher.build()` which may raise `ValueError` for cycles or shape mismatches

---

## Further Reading

- [GETTING_STARTED.md](GETTING_STARTED.md) — Quick-start examples
- [STITCHING.md](STITCHING.md) — Stitcher details
- [TRANSFORMER_BLOCK.md](TRANSFORMER_BLOCK.md) — Full transformer block example
- `src/frontend.py` — Full implementation
