# RTL Stitching Learnings

## Block Management

- All IPs in a stitched graph must share the same `pyrtl.Block`. The cleanest way to achieve this is to monkey-patch `pyrtl.Block` to return a shared block before instantiating any IPs, then restore the original after.
- The `Stitcher` class validates block consistency at `add_ip()` time. If an IP uses a different block than the stitcher's shared block, it raises `ValueError` immediately.
- `pyrtl.set_working_block(block, no_sanity_check=True)` must wrap all wiring operations to ensure wires are created in the correct block context.

## Wire Name Collisions

- IP constructors (e.g., `ALUCore`) create internal wires with predictable names like `{name}_data_in_b` and `{name}_op_code`. When creating wrapper `Input` wires in tests, use a distinct prefix (e.g., `drv_{name}_data_in_b`) to avoid PyRTL's duplicate-wire-name error during `block.sanity_check()`.

## Pipeline Latency in Chains

- A single `ALUCore` has 1-cycle latency (registered output). A chain of N ALUs has N-cycle latency.
- Combinational IPs like `ActivationCore` add zero latency.
- When writing tests for multi-IP chains, flush the pipeline with N extra cycles after the last input beat, then compare outputs starting at index N.

## Backpressure and Fan-Out

- Forward datapath: `src.data_out -> dst.data_in`, `src.valid_out -> dst.valid_in`.
- Reverse backpressure: `dst.ready_out -> src.ready_in`.
- For fan-out (1→N), the source's `ready_in` must be the OR of all downstream `ready_out` signals. PyRTL allows a single wire to drive multiple destinations, so `data_out` and `valid_out` fan-out is straightforward.
- Fan-in (N→1) is not supported in Phase 1 because multiple `data_out` wires cannot drive the same `data_in` without an explicit merge IP.

## Wrapper I/O Generation

- The `Stitcher.build()` method creates `Input`/`Output` wrapper wires only for "dangling" AXI4-Stream-Lite ports (sources with no upstream, sinks with no downstream).
- IP-specific inputs (e.g., `data_in_b`, `op_code` for ALU) are NOT wrapped by the Stitcher; the test/user must create and connect them separately.

## Simulation Setup

- `pyrtl.Simulation(tracer=None, block=block)` requires a clean block. If duplicate wire names exist, `block.sanity_check()` fails during Simulation construction.
- For ALU tests, `ready_in` should be driven high (1) to prevent stalling and simplify latency calculations.

## CLI & Code Generation Gotchas (2026-04-27)

### Dynamic Module Loading
- Use `importlib.util.spec_from_file_location` + `module_from_spec` + `exec_module`
- Must add module to `sys.modules` before exec to handle relative imports in generated code
- Generated modules need `sys.path` to include `src/` for IP core imports

### Monkey-Patching in Generated Code
- IPs without `block` param (Norm, Activation, ALU) require `pyrtl.Block` monkey-patch
- IPs with `block` param (GEMM, Softmax, MemRouter) can pass it directly
- Generated code must restore `pyrtl.Block` in a `finally` block

### Config Exposure
- Generated module exposes `CONFIG` dict so tests can read actual tiling params
- Without this, tests hardcode T values that may mismatch solver's optimal choice
- Solver prefers T=1 for area minimization, causing bitwidth mismatches if tests assume T=2

### Simulation Inputs
- `_pack_bytes` must handle variable T; bitwidth of driver wires comes from actual config
- Always read `drivers["ip_data_in"].bitwidth` or use `module.CONFIG` to determine T

### CLI Patterns
- Use `subprocess.run` with `cwd=project_root` so relative paths work
- `--out` creates parent directories automatically; stdout mode useful for quick inspection
- Invalid JSON raises non-zero exit code via `json.load` exception
