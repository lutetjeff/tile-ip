# Tiling Shape Propagation - Learnings & Conventions

## StreamShape Dataclass
- Defined in `src/ip_cores/axi_stream_base.py`
- `StreamShape(N, T)` where N=total elements, T=elements per beat
- Validation: N>0, T>0, N%T==0
- `num_beats` property returns N//T

## AXI4StreamLiteBase
- Constructor: `__init__(tiling_param, name, block=None, input_shape=None)`
- `tiling_param` determines bus width: `tiling_param * 8` bits
- `input_shape` and `output_shape` properties with lazy inference
- `infer_output_shape()` returns None by default; subclasses override
- `output_shape` getter calls `infer_output_shape()` if `_output_shape` is None

## infer_output_shape() Patterns
- **Transformation IPs** (GEMM, Norm, TemporalGEMM, StatefulNorm, StatefulSoftmax): Return computed shape based on constructor params
- **Passthrough IPs** (FIFO, ALU, Activation): Return `input_shape` if set, else `StreamShape(T, T)` where T=tiling_param
- **Missing**: SoftmaxCore, MemRouterCore, MultiBankBRAMCore

## SoftmaxCore
- Constructor: `SoftmaxCore(T_seq, name, block=None)`
- tiling_param = T_seq
- Should return: `StreamShape(T_seq, T_seq)`

## MemRouterCore
- Constructor: `MemRouterCore(T_out, name, block=None)`
- Output shape is runtime-configurable via `num_beats` register
- Best approach: return `input_shape` if set, else None

## MultiBankBRAMCore
- Constructor: `MultiBankBRAMCore(T, num_banks=4, addr_width=8, name="mbbram", block=None)`
- Read burst length is runtime-configurable via data_in[0:8]
- Best approach: return `input_shape` if set, else None

## Stitcher Current Behavior
- `add_ip()`: Register IP instances, validate shared block
- `connect(src, dst)`: Add directed edges
- `build()`: Wire connections, handle fan-out/fan-in, create wrapper I/O wires
- No shape propagation currently
- No topological traversal

## Transformer Block
- `build_transformer_block()` has all hardcoded parameters
- Uses monkey-patched `pyrtl.Block` factory to share block
- 16 IPs: FIFOs, StatefulNorm, TemporalGEMM, StatefulSoftmax, ALU, Activation
- Manual wiring of last_in, weight_in, accum_in, emit_in, op_code after stitcher.build()

## StreamShapeAdapter Design Notes
- Needs to reshape from T_in to T_out where N is constant
- Input: N/T_in beats of T_in bytes each
- Output: N/T_out beats of T_out bytes each
- Must buffer data and repack
- Need state machine: buffer input beats, emit output beats when enough buffered
- Validation: src.output_shape.N == dst.input_shape.N (total elements must match)
