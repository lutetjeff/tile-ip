
## TilingSolver Cost Model (2026-04-27)

### Area Model (LUT estimates)
- GEMM: T_M * T_K * T_N * 50 LUTs (MAC tree + accumulators + requantization)
- Softmax: T_seq * 30 LUTs (exp LUTs + adder tree + divider)
- Norm: T_channel * 25 LUTs (variance tree + 1/sqrt LUT + gamma/beta)
- Activation: T_width * 10 LUTs (LUT lookup per lane)
- ALU: T_width * 15 LUTs (parallel adders/multipliers + mask logic)
- MemRouter: T_out * 5 LUTs (address generator + BRAM interface)

### Latency Model (cycles)
- GEMM: T_K + 1 (accumulation depth + requantization)
- Softmax: log2(T_seq) + T_seq + log2(T_seq) + 1 (max tree + exp LUTs + sum tree + division)
- Norm: log2(T_channel) + 1 (mean/variance tree + normalization)
- Activation: 0 (combinational LUT)
- ALU: 1 (registered output)
- MemRouter: T_out (sequential read)

### Critical Path Depth (gate equivalents)
- GEMM: log2(T_K) * 3 (multiplier + adder tree depth)
- Softmax: log2(T_seq) * 2 + 8 (max tree + exp LUT + sum tree + divider)
- Norm: log2(T_channel) * 2 + 4 (mean/variance + 1/sqrt LUT)
- Activation: 2 (LUT lookup)
- ALU: 3 (adder/multiplier)
- MemRouter: 2 (address decode)

### Search Strategy
- Brute-force over {1, 2, 4}^k where k = total number of tiling parameters
- Prune configurations violating max_path_depth (timing constraint)
- Prune configurations violating optional max_area constraint
- Select minimum (area + latency); if tie, lower latency wins implicitly
- All 3 subgraphs (FFN, Attention, Mem->Compute) solve in < 1 second
