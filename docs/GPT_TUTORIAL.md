To make sense of the scheduling, we have to separate the **spatial execution** (what the IPs do in a single clock cycle) from the **temporal execution** (how the `MemRouter` feeds the IPs over time). 

Because your hardware can only process a tile of size $T$ at a time, you cannot treat a Transformer block as a single, uninterrupted fluid pipeline from start to finish. Self-attention fundamentally breaks pure streaming because of data dependencies—you cannot compute the attention scores ($Q \times K^T$) until the $K$ matrix is fully generated and ready to be transposed.

Therefore, the `MemRouter` and your state machine must schedule the GPT-2 block in **Macro-Phases**, separated by BRAM buffers. 

Here is how the tiles are scheduled one after another through your AXI4-Stream IPs. Let's assume an input sequence of $N_{seq}$ tokens and an embedding dimension of $N_{channel}$, with your hardware tiled at $T_{seq}$ and $T_{channel}$.

### Phase 1: QKV Generation (The Accumulation Loop)
The first step is taking the input $X$ and projecting it into Query, Key, and Value matrices. 

Because the embedding dimension $N_{channel}$ is likely much larger than your GEMM's inner dimension capacity $T_K$, the GEMM must temporally accumulate partial sums.
1. The `MemRouter` streams a tile of $X$ ($T_M \times T_K$) and a tile of weights ($T_K \times T_N$) into the pipeline.
2. The `NormCore` normalizes the $X$ tile on the fly.
3. The `GEMMCore` multiplies them. Because this is only a partial dot-product across the channel dimension, the GEMM holds the 32-bit accumulator.
4. The `MemRouter` pumps the next tile of $X$ and weights (moving along the $K$ dimension). 
5. Once $N_{channel} / T_K$ beats have passed, the dot product is complete. The GEMM requantizes to INT8, asserts `valid_out`, and emits the finished Q, K, or V tile.
6. **The Routing:** The $Q$ tiles can stay in a pipeline buffer, but the $K$ and $V$ tiles **must be written back to BRAM**. $K$ needs to be transposed later, and $V$ needs to wait for the Softmax to finish.

### Phase 2: Attention Scores ($Q \times K^T$) & Softmax
Once $K$ is fully resident in BRAM, Phase 2 begins.
1. A `MemRouter` is configured to read $K$ from BRAM with a **transposed stride pattern**.
2. It streams $T_{seq} \times T_{channel}$ tiles of $Q$ and the transposed $K^T$ into a GEMM.
3. The GEMM computes the attention scores. Again, it takes multiple beats to accumulate across the channel dimension.
4. When a final score tile is emitted, it flows immediately into the `ALUCore` (configured for ADD) where the Causal Mask tile is streamed in parallel to mask future tokens.
5. The masked score tile flows directly into the `SoftmaxCore`. The Softmax requires the entire row to compute the denominator, so it operates on $T_{seq}$ tokens, computing the exponents and inverse sums via its LUTs.

### Phase 3: Context Projection ($Probs \times V$)
1. The probabilities from the `SoftmaxCore` flow directly into the next `GEMMCore`.
2. Simultaneously, a `MemRouter` fetches the $V$ tiles that were parked in BRAM during Phase 1 and streams them into this GEMM.
3. The output is the Context tensor.

### Phase 4: Output Projection & Residual Convergence
1. The Context tiles stream into a final `GEMMCore` to be multiplied by the output projection weights ($W_o$).
2. The output of this GEMM is the final Attention output tile.
3. **The Synchronization:** This tile streams into `ALU.data_in_a`. Meanwhile, the original, un-normalized $X$ tile (which has been sitting in the `FIFOCore` we discussed earlier) pops out and streams into `ALU.data_in_b`.
4. The `ALUCore` adds them together, completing the first residual connection. 
5. This output is immediately written to BRAM, ready to become the input for the Feed-Forward Network (FFN) Macro-Phase.

### The Scheduling Hierarchy

To visualize the software orchestrator's job, it looks like a nested loop structure generating `MemRouter` configurations:

* **Layer Loop:** Repeat for all 12 (or more) GPT-2 blocks.
    * **Macro-Phase Loop:** Switch between QKV, Attention, and FFN execution graphs.
        * **Spatial Tile Loop (m, n):** Move across the output matrix grid.
            * **Accumulation Loop (k):** Stream $K/T_K$ beats to compute one final spatial tile. 

The IPs are "dumb" spatial engines. They just wait for `valid_in`. The intelligence of the system lives entirely in the `MemRouter` strides and the Python backend that calculates exactly how many beats to pump for each Macro-Phase.
