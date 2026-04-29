# Shape Propagation System

The `tiled-ip` framework uses a **StreamShape** system to track tensor dimensions through IP pipelines and automatically resolve tiling factor mismatches.

---

## What is `StreamShape(N, T)`?

`StreamShape` is a frozen dataclass that represents the shape of a tensor flowing through an AXI4-Stream-Lite connection:

```python
@dataclass(frozen=True)
class StreamShape:
    N: int  # Total number of elements in the tensor
    T: int  # Elements per beat (spatial tiling factor)
```

**Key invariants:**
- `N` and `T` must be positive integers
- `N` must be a multiple of `T` (the tensor must evenly divide into beats)
- `num_beats = N // T` is the number of beats to transfer the full tensor

**Example:** `StreamShape(8, 2)` represents a tensor with 8 total elements, transferred as 4 beats of 2 elements each.

---

## The `AXI4StreamLiteBase` Base Class

All IP cores inherit from `AXI4StreamLiteBase` (`src/ip_cores/axi_stream_base.py`), which provides:

### Key Attributes

| Attribute | Type | Description |
|-----------|------|-------------|
| `input_shape` | `StreamShape \| None` | Shape of the incoming tensor |
| `output_shape` | `StreamShape \| None` | Shape of the outgoing tensor (computed or inferred) |
| `_tiling_param` | `int` | The IP's spatial tiling factor `T` |
| `data_in` | `WireVector` | Input bus, width `T × 8` bits |
| `data_out` | `WireVector` | Output bus, width `T × 8` bits |

### `infer_output_shape()` Method

Each IP can override `infer_output_shape()` to declare its output shape based on `input_shape` or internal parameters:

```python
def infer_output_shape(self) -> StreamShape | None:
    """Override in subclass to declare output shape."""
    return None
```

**Default behavior:** Returns `None`, meaning the output shape cannot be inferred.

### IPs That Override `infer_output_shape()`

| IP Core | Output Shape Logic |
|---------|-------------------|
| `GEMMCore` | `StreamShape(T_M * T_N, T_N)` when `input_shape` is set |
| `SoftmaxCore` | Same as `input_shape` |
| `NormCore` | Same as `input_shape` |
| `ActivationCore` | Same as `input_shape` |
| `ALUCore` | Same as `input_shape` |
| `FIFOCore` | Same as `input_shape` |
| `TemporalGEMMCore` | Based on `M`, `N` parameters and tiling factor |
| `StatefulNormCore` | Based on `N_channel` and `T_channel` |
| `StatefulSoftmaxCore` | Based on `N_seq` and `T_seq` |
| `MultiBankBRAMCore` | `StreamShape(2**addr_width * T, T)` |
| `StreamShapeAdapter` | `StreamShape(N, T_out)` |
| `MemRouterCore` | Not implemented (source IP) |

---

## How Shape Propagation Works

### Topological Propagation (Kahn's Algorithm)

When `Stitcher.build()` is called, it propagates shapes through the IP graph in topological order:

1. **Build dependency graph:** Construct upstream/downstream adjacency lists from edges
2. **Topological sort:** Use Kahn's algorithm to process IPs in dependency order
3. **Shape resolution:** For each IP, determine `output_shape` from `input_shape` or `infer_output_shape()`
4. **Validation:** Check that N is divisible by downstream tiling params

### Resolution Rules

For each edge `src → dst`:

1. **Source has no shape:** If `src.output_shape` is `None` and `src._tiling_param != dst._tiling_param`, raise `ValueError`

2. **N validation:** If `src.output_shape.N % dst._tiling_param != 0`, raise `ValueError` (cannot evenly divide)

3. **T matches:** If `src.output_shape.T == dst._tiling_param`, direct connection; set `dst.input_shape = src.output_shape`

4. **T mismatch:** If `src.output_shape.T != dst._tiling_param`, auto-insert a `StreamShapeAdapter`

---

## Auto-Insertion of `StreamShapeAdapter`

When two IPs have incompatible tiling factors (`T_in != T_out`) but compatible total sizes (`N`), the Stitcher automatically inserts a `StreamShapeAdapter` IP.

### The `StreamShapeAdapter` IP

**File:** `src/ip_cores/shape_adapter.py`

**What it does:** Reshapes AXI4-Stream-Lite data from `T_in` elements per beat to `T_out` elements per beat while preserving the total tensor size `N`.

**Parameters**
| Parameter | Description |
|-----------|-------------|
| `N` | Total number of bytes in the tensor |
| `T_in` | Number of bytes per input beat |
| `T_out` | Number of bytes per output beat |

### Three Operating Modes

**Mode 1: Upsizing (`T_in < T_out`)** — combines multiple input beats into one wider output beat
```
Input:  4 beats of 2 bytes each  (T_in=2, N=8)
Output: 2 beats of 4 bytes each (T_out=4, N=8)
```

**Mode 2: Downsizing (`T_in > T_out`)** — splits one wider input beat into multiple narrower output beats
```
Input:  2 beats of 4 bytes each  (T_in=4, N=8)
Output: 4 beats of 2 bytes each (T_out=2, N=8)
```

**Mode 3: Passthrough (`T_in == T_out`)** — no reshaping needed, data flows through unchanged

### Implementation Details

- **Upsizing:** Uses `k = T_out // T_in` slot registers to accumulate input beats, then concatenates them for output
- **Downsizing:** Uses a buffer and chunk counter to split incoming beats
- **Passthrough:** Simple pass-through with beat counters
- `last_out` is asserted when `out_beat_count == num_out_beats - 1`

---

## N Validation Between Connected IPs

The Stitcher validates that the total tensor size `N` is compatible when connecting IPs:

- Source `N` must be divisible by destination tiling param `T`
- `N % T == 0` ensures the tensor evenly divides into beats

**Example of valid connection:**
```
src: StreamShape(N=8, T=2) → dst with tiling_param=2
8 % 2 == 0 ✓
```

**Example of invalid connection:**
```
src: StreamShape(N=8, T=2) → dst with tiling_param=3
8 % 3 != 0 ✗ (raises ValueError)
```

---

## Setting `input_shape` on Source IPs

Source IPs (with no upstream connections) need their `input_shape` set explicitly. This is typically done before calling `Stitcher.build()`:

```python
from ip_cores.axi_stream_base import StreamShape
from ip_cores.fifo import FIFOCore
from ip_cores.stateful_norm import StatefulNormCore

# Set input shapes on source IPs
fifo1.input_shape = StreamShape(seq_len, T)
norm1.input_shape = StreamShape(seq_len, T)
fifo2.input_shape = StreamShape(emb_dim, T)
```

The Stitcher then propagates these shapes through the graph automatically.

---

## Example: Resolving T=2 → T=4 Mismatch

Consider connecting a source IP outputting `StreamShape(8, 2)` to a destination IP with `tiling_param=4`:

```python
# Automatic: Stitcher inserts adapter
src.output_shape = StreamShape(8, 2)  # 4 beats of 2 bytes
dst._tiling_param = 4                 # expects 2 beats of 4 bytes

# Stitcher auto-inserts:
adapter = StreamShapeAdapter(N=8, T_in=2, T_out=4, name="adapter_src_dst")
# adapter.output_shape = StreamShape(8, 4)
```

The adapter is inserted between src and dst, converting the beat structure while preserving the total tensor size.

---

## Shape Propagation in the Transformer Block

The transformer block (`src/transformer_block.py`) demonstrates shape propagation:

```python
# Source IPs get explicit input shapes
fifo1.input_shape = StreamShape(seq_len, T)
norm1.input_shape = StreamShape(seq_len, T)
fifo2.input_shape = StreamShape(emb_dim, T)

# All internal IPs get their shapes inferred by the Stitcher
built_block, drivers = stitcher.build()
```

The Stitcher:
1. Propagates shapes from `fifo1` and `norm1` through the attention path
2. Propagates shapes from `alu1` through the FFN path
3. Auto-inserts adapters if any T mismatches occur
4. Validates all N divisions

---

## Cycle Detection

If a cycle is detected in the IP graph during topological sorting, the Stitcher raises:

```
ValueError: Cycle detected in IP graph
```

---

## Further Reading

- [STITCHING.md](STITCHING.md) — Detailed Stitcher API and examples
- [TRANSFORMER_BLOCK.md](TRANSFORMER_BLOCK.md) — Full transformer block with shape flow
- `src/ip_cores/axi_stream_base.py` — `StreamShape` and `AXI4StreamLiteBase` implementation
- `src/ip_cores/shape_adapter.py` — `StreamShapeAdapter` implementation
- `src/stitcher.py` — Shape propagation algorithm
