To ensure the Dynamic Programming (DP) solver and the final RTL stitching script work flawlessly, every IP must adhere to a strict, universal interface wrapper. Before defining the individual cores, we must define this standard protocol.

### The Universal AXI4-Stream-Lite Interface
Every single IP block in this library will communicate using a standardized, unidirectional handshake. This eliminates custom glue logic during the stitching phase.
* **Data Bus (`data_in` / `data_out`):** A flattened `PyRTL.WireVector` of size $W \times 8$ bits, where $W$ is the spatial tiling parameter for that specific IP.
* **Control Signals:**
    * `valid_in` (1 bit): Asserted by the upstream producer when data on the bus is good.
    * `ready_out` (1 bit): Asserted by this IP to tell the producer it can accept data.
    * `valid_out` (1 bit): Asserted by this IP when its output data is good.
    * `ready_in` (1 bit): Asserted by the downstream consumer when it can accept data.

---

### 1. The Parameterized INT8 GEMM Core
This is the workhorse of the architecture, handling QKV projections, attention matrices, and FFN layers. It maps directly to DSP48 slices.

* **Function:** Computes $C = A \times B$.
* **Tiling Parameters:**
    * $T_M$: Spatial unrolling of the Sequence dimension (rows of $A$).
    * $T_K$: Spatial unrolling of the Inner dimension (cols of $A$, rows of $B$).
    * $T_N$: Spatial unrolling of the Output Channel dimension (cols of $B$).
* **Input/Output Streams:**
    * **Stream A (Activations):** Bus width is $T_M \times T_K \times 8$ bits.
    * **Stream B (Weights):** Bus width is $T_K \times T_N \times 8$ bits. *(Note: For stationary weights, this stream is fed once from a BRAM and held).*
    * **Stream C (Output):** Bus width is $T_M \times T_N \times 8$ bits. 
* **Implementation Style:** A systolic array or vector-MAC tree. The core computes using 32-bit internal accumulators to prevent overflow. At the output boundary, include a "requantization stub" (a simple right-shift or lookup) to scale the 32-bit results back down to INT8 before pushing to Stream C.

### 2. The LUT-Based Softmax Core
Since true exponentiation is hostile to FPGAs, this core relies entirely on pre-computed BRAM mappings, converting raw INT8 attention scores to INT8 probabilities.

* **Function:** Computes $\text{Softmax}(x_i) = \frac{e^{x_i}}{\sum e^{x_j}}$.
* **Tiling Parameters:**
    * $T_{seq}$: The number of tokens processed in parallel. This *must* match the $T_N$ of the upstream GEMM that generated the attention scores.
* **Input/Output Streams:**
    * **Stream In:** Bus width is $T_{seq} \times 8$ bits.
    * **Stream Out:** Bus width is $T_{seq} \times 8$ bits.
* **Implementation Style:** The IP instantiates $T_{seq}$ parallel `PyRTL.MemBlock` instances configured as ROMs (256 depth $\times$ 8-bit width). An internal adder tree computes the sum of the exponents, and a second LUT handles the division (multiplying by the inverse sum).

### 3. The Universal Normalization Core
This handles both LayerNorm (BERT/GPT) and RMSNorm (T5) by toggling the mean-centering logic. 

* **Function:** Normalizes feature vectors and applies learned scale/bias.
* **Tiling Parameters:**
    * $T_{channel}$: The number of features processed in parallel.
* **Input/Output Streams:**
    * **Stream In:** Bus width is $T_{channel} \times 8$ bits.
    * **Stream Out:** Bus width is $T_{channel} \times 8$ bits.
    * **Config Flag (`is_rmsnorm`):** 1-bit static wire. If high, bypass the mean-subtraction stage.
* **Implementation Style:** An adder tree computes the variance. The complex $1/\sqrt{x}$ operation is handled by a single 256-entry PyRTL LUT. The normalized values are then multiplied by the learned $\gamma$ (scale) and added to $\beta$ (bias) using standard PyRTL arithmetic operators.

### 4. The LUT-Based Activation Core
A strictly point-wise non-linearity for the Feed-Forward Networks. 

* **Function:** Applies GELU, ReLU, or Gated-GELU.
* **Tiling Parameters:**
    * $T_{width}$: The number of parallel elements (matches the expanded FFN channel dimension).
* **Input/Output Streams:**
    * **Stream In:** Bus width is $T_{width} \times 8$ bits.
    * **Stream Out:** Bus width is $T_{width} \times 8$ bits.
* **Implementation Style:** Extremely lightweight. It is simply an array of $T_{width}$ parallel 256-entry LUTs. The PyRTL generator accepts a Python function (e.g., `numpy.exp` logic) at generation time to pre-populate the ROMs, making it completely agnostic to the actual math.

### 5. The Element-wise ALU
This core handles architectural routing math: residual connections, causal masking, and positional encoding additions.

* **Function:** Point-wise operations across two tensors.
* **Tiling Parameters:**
    * $T_{width}$: Parallel elements per cycle.
* **Input/Output Streams:**
    * **Stream A:** Bus width is $T_{width} \times 8$ bits.
    * **Stream B:** Bus width is $T_{width} \times 8$ bits.
    * **Config Wire (`op_code`):** 2-bit wire to select between ADD, MULTIPLY, or MASK.
    * **Stream Out:** Bus width is $T_{width} \times 8$ bits.
* **Implementation Style:** Straightforward combinational logic mapped to PyRTL `+` and `*` operators, wrapped in pipeline registers to maintain the II (Initiation Interval).

### 6. The Memory Router & Embedding Core
This IP sits at the boundaries of the compute pipeline, fetching tokens and routing tensors (like the $K^T$ transpose) from main memory or large BRAM banks into the AXI4-Streams.

* **Function:** Tensor reshaping, transposition, and token-to-vector lookup.
* **Tiling Parameters:**
    * $T_{out}$: The required width of the output stream feeding the compute IP.
* **Input/Output Streams:**
    * **Memory Interface:** Standard read/write address lines mapped to the FPGA's BRAM controller.
    * **Stream Out:** Bus width is $T_{out} \times 8$ bits.
* **Implementation Style:** A programmable state machine. Instead of moving data through logic, it generates complex address-stride patterns (e.g., skipping addresses to read a matrix column-wise for transposition) and packs the retrieved bytes into the `valid_out` stream.

### 7. The FIFO Buffer Core
A simple elastic buffer for decoupling pipeline stages and handling backpressure.

* **Function:** Stores beats of data to absorb rate mismatches between producer and consumer IPs.
* **Tiling Parameters:**
    * $T_{width}$: Number of bytes per beat (bus width = $T_{width} \times 8$ bits).
    * $depth$: Number of entries the FIFO can hold.
* **Input/Output Streams:**
    * **Stream In:** Standard AXI4-Stream-Lite, bus width $T_{width} \times 8$ bits.
    * **Stream Out:** Standard AXI4-Stream-Lite, bus width $T_{width} \times 8$ bits.
* **Implementation Style:** Circular buffer using `pyrtl.MemBlock` for data storage and `pyrtl.Register` for head/tail pointers and count. `ready_out` is asserted when the FIFO is not full; `valid_out` is asserted when the FIFO is not empty. Supports simultaneous read and write (count unchanged when both occur in the same cycle).

***
