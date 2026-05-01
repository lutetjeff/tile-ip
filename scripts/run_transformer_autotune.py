#!/usr/bin/env python3
"""End-to-end flow: autotune transformer block (16,16) → top 3 configs → Verilog export."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent / "src"))
sys.path.insert(0, str(Path(__file__).parent.parent / "scripts"))

import pyrtl
from autotuner import Autotuner
from transformer_block import build_transformer_block

TRANSFORMER_SPEC = {
    "ips": [
        {"type": "StatefulNorm", "name": "norm", "params": ["T_channel"], "kwargs": {"N_channel": 16}},
        {"type": "TemporalGEMM", "name": "tgemm", "params": ["T_K", "T_N"], "kwargs": {"T_M": 1, "M": 8, "N": 16}},
        {"type": "StatefulSoftmax", "name": "softmax", "params": ["T_seq"], "kwargs": {"N_seq": 16}},
        {"type": "ALU", "name": "alu", "params": ["T_width"], "kwargs": {"op_mode": "add"}},
    ],
    "edges": [("norm", "tgemm"), ("tgemm", "softmax"), ("softmax", "alu")],
    "constraints": {"fpga": {"LUT": 35200, "FF": 17600, "DSP": 80, "BRAM": 90}},
}

def _pick_t_from_config(config):
    t_values = [val for params in config.values() for pname, val in params.items() if pname.startswith("T_")]
    return max(set(t_values), key=t_values.count) if t_values else 2

def main():
    print("=" * 70)
    print("Transformer Block Autotuner (seq_len=16, emb_dim=16)")
    print("=" * 70)
    
    tuner = Autotuner(TRANSFORMER_SPEC, top_n=3)
    results = tuner.run()
    
    if not results:
        print("\nNo valid configurations found!")
        return
    
    print(f"\nFound {len(results)} valid configuration(s). Exporting top 3...\n")
    
    outdir = Path("build/autotune_transformer")
    outdir.mkdir(parents=True, exist_ok=True)
    
    rows = []
    for rank, (latency, config, metrics) in enumerate(results[:3], 1):
        T = _pick_t_from_config(config)
        pyrtl.reset_working_block()
        block, drivers, manual_inputs = build_transformer_block(seq_len=16, emb_dim=16, T=T)

        for mem in block.memblock_by_name.values():
            mem.asynchronous = True

        vfile = outdir / f"transformer_design_{rank}_T{T}.v"
        with open(vfile, "w") as f:
            pyrtl.output_to_verilog(f, block=block)
        
        power_w = metrics.get("power_w", metrics["LUT"] * 0.001)
        rows.append({
            "rank": rank, "T": T, "latency_ns": latency,
            "LUT": metrics["LUT"], "FF": metrics["FF"],
            "DSP": metrics["DSP"], "BRAM": metrics["BRAM"],
            "utilization": metrics["utilization"],
            "min_fmax_mhz": metrics["min_fmax_mhz"],
            "congestion": metrics["congestion"],
            "power_w": power_w,
        })
        print(f"  Design #{rank}: T={T}, latency={latency:.2f} ns/element → {vfile.name}")
    
    print("\n" + "=" * 70)
    print("Comparison Table: Top 3 Transformer Block Configurations")
    print("=" * 70)
    
    print(f"{'Rank':>4} | {'T':>3} | {'Latency':>10} | {'LUT':>6} | {'FF':>6} | {'DSP':>4} | {'BRAM':>5} | {'Util':>7} | {'Fmax':>8} | {'Cong':>4} | {'Power':>7}")
    print("-" * 90)
    for row in rows:
        print(f"{row['rank']:>4} | {row['T']:>3} | {row['latency_ns']:>10.2f} | {row['LUT']:>6} | {row['FF']:>6} | {row['DSP']:>4} | {row['BRAM']:>5} | {row['utilization']:>7.1%} | {row['min_fmax_mhz']:>8.1f} | {row['congestion']:>4} | {row['power_w']:>7.3f}")
    
    print(f"\nAll Verilog files written to: {outdir}")
    print("=" * 70)

if __name__ == "__main__":
    main()
