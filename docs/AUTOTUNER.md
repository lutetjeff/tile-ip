# Branch-and-Bound Autotuner

This document describes the `Autotuner` class for finding optimal tile configurations.

---

## Overview

The autotuner performs branch-and-bound search over tile-factor assignments using FPGA characterization data. It replaces/supplements the `TilingSolver` for FPGA targets with known resource constraints.

**File:** `src/autotuner.py`

---

## CharacterizationDB

**File:** `src/autotuner.py` (class `CharacterizationDB`)

Reads FPGA characterization results and provides resource/timing lookups with estimation fallback.

### Constructor

```python
CharacterizationDB(json_path: str | None = None)
```

If `json_path` is `None`, defaults to `build/characterization/characterization_results.json`.

### Methods

**`lookup(ip_type: str, params: dict[str, int]) -> dict[str, float | int]`**

Returns resource/timing dict for an IP type with given parameters.

```python
char_db = CharacterizationDB()
metrics = char_db.lookup("GEMMCore", {"T_M": 2, "T_K": 2, "T_N": 2})
# Returns: {"LUT": 1234, "FF": 567, "DSP": 8, "BRAM": 0,
#           "power_w": 0.45, "wns_ns": 2.5, "clock_period_ns": 10.0}
```

If the exact configuration was characterized, measured data is returned. Otherwise, an estimate is produced using heuristics.

### Estimation Fallbacks

| IP Type | Estimation Formula |
|---------|-------------------|
| ALUCore | LUT: `109 + (T_width-1) * 108`, FF: `9 + (T_width-1) * 8` |
| TemporalGEMMCore | LUT: `T_M*T_K*T_N * 200`, FF: `T_M*T_N * 16`, DSP: `prod // 4` |
| StatefulNormCore | LUT: `T_channel * 80 + N_channel * 2`, FF: `T_channel * 16` |
| StatefulSoftmaxCore | LUT: `T_seq * 100 + N_seq * 2`, FF: `T_seq * 20` |
| ActivationCore | LUT: `T_width * 15`, FF: `T_width * 4` |
| FIFOCore | LUT: `depth * 2 + T_width * 4`, FF: `depth * T_width * 8 + 16` |
| GEMMCore | LUT: `T_M*T_K*T_N * 50`, FF: `T_M*T_N * 8`, DSP: `prod // 8` |
| SoftmaxCore | LUT: `T_seq * 30`, FF: `T_seq * 10` |
| NormCore | LUT: `T_channel * 25`, FF: `T_channel * 8` |
| MemRouterCore | LUT: `T_out * 5`, FF: `T_out * 2` |

---

## Autotuner Class

### Constructor

```python
Autotuner(
    spec: dict[str, Any],
    char_db: CharacterizationDB | None = None,
    top_n: int = 5,
)
```

**Parameters:**
- `spec`: Graph specification (same format as `TilingSolver`)
- `char_db`: Characterization database (default: creates new instance)
- `top_n`: Number of best designs to retain (default 5)

**Spec format:**
```python
{
    "name": "ffn",
    "ips": [
        {"type": "Norm", "name": "norm", "params": ["T_channel"]},
        {"type": "Activation", "name": "act", "params": ["T_width"]},
        {"type": "ALU", "name": "alu", "params": ["T_width"]},
    ],
    "edges": [["norm", "act"], ["act", "alu"]],
    "constraints": {
        "fpga": {"LUT": 35200, "FF": 17600, "DSP": 80, "BRAM": 90}
    },
}
```

### Methods

**`run(output_dir: str | None = None) -> list[tuple[float, dict, dict]]`**

Executes the branch-and-bound search.

**Returns:** List of top-N designs sorted by latency ascending. Each element is `(latency_ns, config_dict, metrics_dict)`.

If `output_dir` is specified, Verilog is emitted for each design.

**`output_verilog(design, output_dir, rank) -> str | None`**

Emits Verilog for a design. Called automatically by `run()` when `output_dir` is specified.

---

## Latency Model

Per-element latency formula:

```
Latency(ns/element) = (1000 / min_fmax) * (max_beats * max_ii + congestion) / total_elements
```

Where:
- `min_fmax`: Minimum fmax across all IPs in the configuration (MHz)
- `max_beats`: Maximum number of beats among all IPs
- `max_ii`: Maximum initiation interval (typically 1, higher for GEMM)
- `congestion`: 0/1/2/3 based on utilization:
  - 0 if util < 50%
  - 1 if util < 75%
  - 2 if util < 87.5%
  - 3 if util >= 87.5%
- `total_elements`: Number of elements processed by the critical IP

### Computing Beats, II, and Elements

**Beats per IP:**
```python
GEMM/TemporalGEMM:  max(1, (M * N) // (T_M * T_N))
Norm/StatefulNorm:  max(1, N_channel // T_channel)
Softmax/StatefulSoftmax: max(1, N_seq // T_seq)
MemRouter: max(1, num_beats)
ALU/Activation/FIFO: max(1, N // T_width)
```

**Initiation Interval (II):**
```python
GEMM/TemporalGEMM: max(1, T_M * T_K * T_N)
Others: 1
```

**Total Elements:**
```python
GEMM/TemporalGEMM: max(1, M * N)
Norm/StatefulNorm: max(1, N_channel)
Softmax/StatefulSoftmax: max(1, N_seq)
ALU/Activation/FIFO: max(1, N)
MemRouter: max(1, num_beats * T_out)
```

---

## Pruning Rules

Configurations are pruned (discarded) if:

1. **Utilization > 100%:** Total resource usage of any type exceeds FPGA capacity
2. **Latency > 1.5× best:** Per-element latency exceeds 1.5× the current best found

### Utilization Calculation

```python
total = {"LUT": 0, "FF": 0, "DSP": 0, "BRAM": 0}
for ip in ips:
    metrics = char_db.lookup(ip.type, ip.params)
    total[k] += metrics[k] for each resource type

util = max(
    total["LUT"] / max_lut,
    total["FF"] / max_ff,
    total["DSP"] / max_dsp,
    total["BRAM"] / max_bram,
)
```

---

## Tile Factor Search Space

Tile factors are swept from `{1, 2, 4, 8, 16}` for each parameter.

The total search space for a graph with K tile parameters is `5^K`. Branch-and-bound pruning typically reduces this significantly.

---

## Example Usage

### Basic Invocation

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

# Best design
best_latency, best_config, best_metrics = results[0]
print(f"Best latency: {best_latency:.2f} ns/element")
print(f"Config: {best_config}")
print(f"Metrics: {best_metrics}")
```

### With Verilog Output

```python
autotuner = Autotuner(spec, char_db=char_db, top_n=5)
results = autotuner.run(output_dir="build/designs")

# Verilog files: build/designs/design_0.v, design_1.v, etc.
```

### Custom FPGA Constraints

```python
spec = {
    "name": "large_ffn",
    "ips": [...],
    "edges": [...],
    "constraints": {
        "fpga": {
            "LUT": 85000,   # Virtex UltraScale+
            "FF": 170000,
            "DSP": 1600,
            "BRAM": 900
        }
    },
}
```

---

## Comparison with TilingSolver

| Aspect | TilingSolver | Autotuner |
|--------|--------------|-----------|
| Search strategy | Brute-force | Branch-and-bound |
| Cost model | LUT estimates | Characterization + estimates |
| FPGA constraints | `max_area` | Full resource budget |
| Latency model | Cycle-based | Per-element ns |
| Output | Config dict | Top-N designs + Verilog |
| Speed | < 1s | Varies with pruning |

**When to use TilingSolver:**
- Quick exploration without characterization data
- Simple area + depth constraints

**When to use Autotuner:**
- Target FPGA has known resource constraints
- Characterization data is available
- Need Verilog output for top designs

---

## Further Reading

- [GETTING_STARTED.md](GETTING_STARTED.md) — Quick-start examples
- [STITCHING.md](STITCHING.md) — Stitcher and code generation
- [PARETO_VISUALIZATION.md](PARETO_VISUALIZATION.md) — Pareto frontier visualization
- `src/autotuner.py` — Full implementation
- `tests/test_autotuner.py` — Verification tests