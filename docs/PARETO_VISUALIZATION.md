# Pareto Frontier Visualization

This document describes the Pareto visualization tools for analyzing IP characterization results.

---

## Overview

The visualization tools help identify optimal IP configurations by plotting the trade-off space between resource usage, throughput, and power consumption. Points on the Pareto frontier represent configurations where no other configuration dominates in all three dimensions.

---

## Scripts

### visualize_pareto.py

**File:** `scripts/visualize_pareto.py`

Creates a 3D scatter plot showing all characterization points and highlights the Pareto-optimal frontier.

**What it does:**
- Reads `build/characterization/characterization_results.json`
- Computes `fmax`, `max_utilization`, and `power_w` for each successful characterization
- Identifies non-dominated points (Pareto frontier)
- Renders a 3D plot with:
  - X-axis: Max Utilization (normalized resource usage)
  - Y-axis: Throughput (MHz)
  - Z-axis: Power (W)
  - Gray points: All configurations
  - Red points: Pareto-optimal configurations

**Metrics computed:**
```python
fmax_mhz = 1000.0 / (clock_period_ns - wns_ns)
throughput = fmax_mhz / II  # II = initiation interval
max_util = max(LUT, FF, DSP, BRAM) normalized to FPGA capacity
```

**Usage:**

```bash
# Basic usage
python scripts/visualize_pareto.py

# Specify input and output
python scripts/visualize_pareto.py \
    --input build/characterization/characterization_results.json \
    --output build/pareto_plot.png

# Display plot interactively
python scripts/visualize_pareto.py --show
```

**Output:** `pareto_plot.png` (or specified path)

---

### generate_ip_pareto_plots.py

**File:** `scripts/generate_ip_pareto_plots.py`

Creates per-IP-type Pareto frontier plots showing LUT vs latency trade-offs.

**What it does:**
- Sweeps tile parameters over `{1, 2, 4, 8, 16}` for each IP type
- Computes latency per element using the characterization database
- Identifies Pareto-efficient configurations
- Generates labeled scatter plots per IP type

**Latency computation:**
```python
fmax = 1000 / (clock_period_ns - wns_ns)
II = compute_ii(ip_type, params)  # 1 for most IPs, >1 for GEMM
latency_ns = (1000 / fmax) * (II + congestion)
latency_per_element = latency_ns / T_factor
```

Where `T_factor` varies by IP type:
- `T_width` for ALU, Activation, FIFO
- `T_M * T_N` for GEMM, TemporalGEMM
- `T_channel` for Norm, StatefulNorm
- `T_seq` for Softmax, StatefulSoftmax

**Usage:**

```bash
# Generate all Pareto plots
python scripts/generate_ip_pareto_plots.py

# Output directory: build/pareto_plots/
# Output files: ALUCore_pareto.png, TemporalGEMMCore_pareto.png, etc.
```

**Output files:**
```
build/pareto_plots/
├── ALUCore_pareto.png
├── ActivationCore_pareto.png
├── FIFOCore_pareto.png
├── GEMMCore_pareto.png
├── MemRouterCore_pareto.png
├── NormCore_pareto.png
├── SoftmaxCore_pareto.png
├── StatefulNormCore_pareto.png
├── StatefulSoftmaxCore_pareto.png
└── TemporalGEMMCore_pareto.png
```

**Plot features:**
- Blue points: Dominated configurations
- Red points: Pareto frontier
- Red dashed line: Pareto frontier envelope
- Labels: Configuration parameters (e.g., `T=4`, `K=4,M=1,N=4`)

---

## Data Source

Both scripts read from `build/characterization/characterization_results.json`.

**Expected JSON structure:**
```json
{
  "metadata": {
    "clock_period_ns": 10.0,
    "part": "xc7s50csga324-2"
  },
  "results": [
    {
      "ip": "GEMMCore",
      "params": {"T_M": 2, "T_K": 2, "T_N": 2},
      "status": "success",
      "resources": {
        "LUT": 1234,
        "FF": 567,
        "DSP": 8,
        "BRAM": 0
      },
      "timing": {
        "wns_ns": 2.5,
        "fmax_mhz": 133.3
      },
      "power": {
        "total_w": 0.45
      }
    }
  ]
}
```

---

## Understanding Pareto Frontiers

A configuration is **Pareto-optimal** if no other configuration has:
- Lower or equal max utilization AND
- Higher or equal throughput AND
- Lower or equal power

And at least one of those metrics is strictly better.

**Dominated points** can be identified by checking if any other point meets all three criteria while being strictly better in at least one.

---

## Example Workflow

1. **Characterize IPs:**
   ```bash
   python scripts/characterize_ips_parallel.py -j 4 --outdir build/char_full
   ```

2. **Generate global Pareto plot:**
   ```bash
   python scripts/visualize_pareto.py \
       --input build/char_full/characterization_results.json \
       --output build/pareto_plot.png
   ```

3. **Generate per-IP Pareto plots:**
   ```bash
   python scripts/generate_ip_pareto_plots.py
   ```

4. **Analyze results** to identify optimal tile configurations for your target FPGA.

---

## Further Reading

- [GETTING_STARTED.md](GETTING_STARTED.md) — Quick-start examples
- [AUTOTUNER.md](AUTOTUNER.md) — Using characterization data for tile optimization
- [IP_CATALOG.md](IP_CATALOG.md) — Individual IP documentation
- `scripts/visualize_pareto.py` — 3D visualization script
- `scripts/generate_ip_pareto_plots.py` — Per-IP plotting script