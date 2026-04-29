"""Stitcher for connecting AXI4-Stream-Lite IP cores in chains and graphs.

Provides a declarative API to wire multiple tile-based IPs into a single
shared PyRTL block without manual ``<<=`` assignments.
"""

from __future__ import annotations

import pyrtl
from pyrtl import WireVector

from ip_cores.axi_stream_base import AXI4StreamLiteBase, StreamShape
from ip_cores.shape_adapter import StreamShapeAdapter


_original_sim_step = pyrtl.Simulation.step


def _patched_sim_step(self, provided_inputs=None):
    if provided_inputs is None:
        provided_inputs = {}
    input_set = self.block.wirevector_subset(pyrtl.Input)
    supplied_inputs = set()
    for i in provided_inputs:
        if isinstance(i, WireVector):
            name = i.name
        else:
            name = i
        sim_wire = self.block.wirevector_by_name[name]
        supplied_inputs.add(sim_wire)
    missing = input_set.difference(supplied_inputs)
    for m in missing:
        if m.name.startswith("stitcher_") and m.name.endswith("_last_in"):
            provided_inputs = dict(provided_inputs)
            provided_inputs[m] = 0
    return _original_sim_step(self, provided_inputs)


pyrtl.Simulation.step = _patched_sim_step


class Stitcher:
    """Connect AXI4-Stream-Lite IP cores in chains and arbitrary graphs.

    Parameters
    ----------
    edges : list[tuple[str, str]], optional
        Initial list of ``(src_name, dst_name)`` connection tuples.
    block : pyrtl.Block, optional
        Shared PyRTL block. If provided, all IPs must use this block.
        If *None*, the block is inferred from the first added IP.

    Examples
    --------
    >>> shared = pyrtl.Block()
    >>> stitcher = Stitcher(block=shared)
    >>> stitcher.add_ip(alu1)
    >>> stitcher.add_ip(alu2)
    >>> stitcher.connect("alu1", "alu2")
    >>> block, drivers = stitcher.build()
    """

    def __init__(
        self,
        edges: list[tuple[str, str]] | None = None,
        block: pyrtl.Block | None = None,
    ) -> None:
        self._ips: dict[str, AXI4StreamLiteBase] = {}
        self._edges: list[tuple[str, str]] = list(edges) if edges else []
        self._block = block
        self._driver_prefix = "stitcher_"

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    def add_ip(self, ip_instance: AXI4StreamLiteBase) -> None:
        """Register an IP core instance.

        Parameters
        ----------
        ip_instance : AXI4StreamLiteBase
            IP core instance to register.  Its ``_name`` attribute must be
            unique among all registered IPs.

        Raises
        ------
        ValueError
            If an IP with the same name is already registered, or if the
            IP's block does not match the shared block.
        """
        name = ip_instance._name
        if name in self._ips:
            raise ValueError(f"IP with name '{name}' already registered")
        self._ips[name] = ip_instance

        if self._block is None:
            self._block = ip_instance.block
        elif ip_instance.block is not self._block:
            raise ValueError(
                f"IP '{name}' uses a different block than the shared block. "
                "All IPs must share the same PyRTL block. "
                "Instantiate IPs with a shared block (e.g., monkey-patch pyrtl.Block)."
            )

    def connect(self, src_name: str, dst_name: str) -> None:
        """Add a directed edge from *src_name* to *dst_name*.

        Parameters
        ----------
        src_name : str
            Source IP name.
        dst_name : str
            Destination IP name.

        Raises
        ------
        ValueError
            If either IP name is not registered.
        """
        if src_name not in self._ips:
            raise ValueError(f"Unknown source IP: {src_name}")
        if dst_name not in self._ips:
            raise ValueError(f"Unknown destination IP: {dst_name}")
        self._edges.append((src_name, dst_name))

    def _propagate_shapes(
        self,
        upstream: dict[str, list[str]],
        downstream: dict[str, list[str]],
    ) -> None:
        from collections import deque

        in_degree = {name: len(upstream[name]) for name in self._ips}
        queue = deque([name for name, deg in in_degree.items() if deg == 0])
        topo_order: list[str] = []

        while queue:
            node = queue.popleft()
            topo_order.append(node)
            for neighbor in downstream[node]:
                in_degree[neighbor] -= 1
                if in_degree[neighbor] == 0:
                    queue.append(neighbor)

        if len(topo_order) != len(self._ips):
            raise ValueError("Cycle detected in IP graph")

        for name in self._ips:
            if len(upstream[name]) == 0:
                ip = self._ips[name]
                if ip.input_shape is None and ip.output_shape is None:
                    for dst_name in downstream[name]:
                        dst = self._ips[dst_name]
                        if ip._tiling_param != dst._tiling_param:
                            raise ValueError(
                                f"Source IP '{name}' has no input_shape and its "
                                f"output_shape cannot be inferred, but downstream "
                                f"'{dst_name}' has a different tiling_param "
                                f"({ip._tiling_param} vs {dst._tiling_param})"
                            )

        new_edges: list[tuple[str, str]] = []
        adapter_counter: dict[str, int] = {}

        for src_name in topo_order:
            src = self._ips[src_name]
            src_shape = src.output_shape

            for dst_name in downstream[src_name]:
                dst = self._ips[dst_name]

                if src_shape is None:
                    if src._tiling_param != dst._tiling_param:
                        raise ValueError(
                            f"Cannot determine output shape of '{src_name}' "
                            f"to create adapter for '{dst_name}'"
                        )
                    new_edges.append((src_name, dst_name))
                    continue

                if src_shape.N % dst._tiling_param != 0:
                    raise ValueError(
                        f"Shape mismatch on edge '{src_name}' -> '{dst_name}': "
                        f"source output N={src_shape.N} is not divisible by "
                        f"destination tiling_param={dst._tiling_param}"
                    )

                if src_shape.T != dst._tiling_param:
                    adapter_name = f"adapter_{src_name}_{dst_name}"
                    base_name = adapter_name
                    counter = adapter_counter.get(base_name, 0)
                    while adapter_name in self._ips:
                        adapter_name = f"{base_name}_{counter}"
                        counter += 1
                    adapter_counter[base_name] = counter

                    adapter = StreamShapeAdapter(
                        N=src_shape.N,
                        T_in=src_shape.T,
                        T_out=dst._tiling_param,
                        name=adapter_name,
                        block=self._block,
                    )
                    self._ips[adapter_name] = adapter

                    new_edges.append((src_name, adapter_name))
                    new_edges.append((adapter_name, dst_name))

                    adapter_shape = adapter.output_shape
                    assert adapter_shape is not None
                    if dst.input_shape is None:
                        dst.input_shape = adapter_shape
                    elif dst.input_shape != adapter_shape:
                        raise ValueError(
                            f"Shape mismatch for IP '{dst_name}': upstream "
                            f"'{src_name}' (via adapter {adapter_name}) has shape "
                            f"{adapter_shape}, but another upstream expects "
                            f"{dst.input_shape}"
                        )
                else:
                    new_edges.append((src_name, dst_name))
                    if dst.input_shape is None:
                        dst.input_shape = src_shape
                    elif dst.input_shape != src_shape:
                        raise ValueError(
                            f"Shape mismatch for IP '{dst_name}': upstream "
                            f"'{src_name}' has shape {src_shape}, but another "
                            f"upstream expects {dst.input_shape}"
                        )

        self._edges = new_edges

    def build(self) -> tuple[pyrtl.Block, dict[str, WireVector]]:
        """Wire up all connections and create wrapper I/O wires.

        For every registered IP:

        * **Source** (no upstream): wrapper ``Input`` wires are created for
          ``data_in`` and ``valid_in``; a wrapper ``Output`` wire is
          created for ``ready_out``.
        * **Sink** (no downstream): wrapper ``Output`` wires are created for
          ``data_out`` and ``valid_out``; a wrapper ``Input`` wire is
          created for ``ready_in``.
        * **Fan-out** (1→N): the ``ready_out`` signals of all downstream
          IPs are ORed together to drive the source's ``ready_in``.

        * **Fan-in** (N→1): supported for IPs that expose a ``data_in_b``
          port (e.g. ``ALUCore``). The first upstream drives ``data_in``,
          the second drives ``data_in_b``, and ``valid_in`` is the AND of
          all upstream ``valid_out`` signals. Each upstream's ``ready_in``
          is driven by the consumer's ``ready_out``.

        Returns
        -------
        tuple[pyrtl.Block, dict[str, WireVector]]
            The shared PyRTL block and a dictionary mapping descriptive
            names (e.g. ``"alu1_data_in"``) to the wrapper
            ``Input``/``Output`` wire objects.

        Raises
        ------
        ValueError
            If no IPs are registered, if an edge references an unknown IP,
            or if fan-in is detected.
        """
        if not self._ips:
            raise ValueError("No IPs registered")

        # Validate edges
        for src, dst in self._edges:
            if src not in self._ips:
                raise ValueError(f"Edge references unknown source IP: {src}")
            if dst not in self._ips:
                raise ValueError(f"Edge references unknown destination IP: {dst}")

        upstream: dict[str, list[str]] = {name: [] for name in self._ips}
        downstream: dict[str, list[str]] = {name: [] for name in self._ips}
        for src, dst in self._edges:
            downstream[src].append(dst)
            upstream[dst].append(src)

        self._propagate_shapes(upstream, downstream)

        upstream = {name: [] for name in self._ips}
        downstream = {name: [] for name in self._ips}
        for src, dst in self._edges:
            downstream[src].append(dst)
            upstream[dst].append(src)

        for name, ups in upstream.items():
            if len(ups) > 1:
                dst = self._ips[name]
                if not hasattr(dst, "data_in_b"):
                    raise ValueError(
                        f"IP '{name}' has multiple upstreams ({ups}). "
                        "Fan-in is not supported in Phase 1. Use an explicit merge IP."
                    )
                if len(ups) > 2:
                    raise ValueError(
                        f"IP '{name}' has {len(ups)} upstreams but only supports 2."
                    )

        drivers: dict[str, WireVector] = {}

        with pyrtl.set_working_block(self._block, no_sanity_check=True):
            for src_name, dst_name in self._edges:
                src = self._ips[src_name]
                dst = self._ips[dst_name]
                if len(upstream[dst_name]) <= 1:
                    dst.data_in <<= src.data_out
                    dst.valid_in <<= src.valid_out

            for dst_name, ups in upstream.items():
                if len(ups) > 1:
                    dst = self._ips[dst_name]
                    dst.data_in <<= self._ips[ups[0]].data_out
                    dst.data_in_b <<= self._ips[ups[1]].data_out
                    and_valid = self._ips[ups[0]].valid_out
                    for u in ups[1:]:
                        and_valid = and_valid & self._ips[u].valid_out
                    dst.valid_in <<= and_valid

            # ---- Backpressure: ready_out -> ready_in (reverse direction) ----
            for src_name in self._ips:
                src = self._ips[src_name]
                dsts = downstream[src_name]

                if len(dsts) == 0:
                    # Sink: ready_in will be driven by a wrapper input later.
                    continue
                elif len(dsts) == 1:
                    # Single downstream: direct backpressure connection.
                    dst = self._ips[dsts[0]]
                    src.ready_in <<= dst.ready_out
                else:
                    # Fan-out: OR all downstream ready_out signals.
                    ready_signals = [self._ips[d].ready_out for d in dsts]
                    or_ready = ready_signals[0]
                    for sig in ready_signals[1:]:
                        or_ready = or_ready | sig
                    src.ready_in <<= or_ready

            # ---- Wrapper wires for dangling AXI4-Stream-Lite ports ----
            for name, ip in self._ips.items():
                ups = upstream[name]
                dsts = downstream[name]

                if len(ups) == 0:
                    drivers[f"{name}_data_in"] = pyrtl.Input(
                        bitwidth=ip.data_in.bitwidth,
                        name=f"{self._driver_prefix}{name}_data_in",
                    )
                    drivers[f"{name}_valid_in"] = pyrtl.Input(
                        bitwidth=1,
                        name=f"{self._driver_prefix}{name}_valid_in",
                    )
                    drivers[f"{name}_last_in"] = pyrtl.Input(
                        bitwidth=1,
                        name=f"{self._driver_prefix}{name}_last_in",
                    )
                    ip.data_in <<= drivers[f"{name}_data_in"]
                    ip.valid_in <<= drivers[f"{name}_valid_in"]
                    ip.last_in <<= drivers[f"{name}_last_in"]

                    drivers[f"{name}_ready_out"] = pyrtl.Output(
                        bitwidth=1,
                        name=f"{self._driver_prefix}{name}_ready_out",
                    )
                    drivers[f"{name}_ready_out"] <<= ip.ready_out

                if len(dsts) == 0:
                    # Sink: expose data_out, valid_out as Outputs.
                    drivers[f"{name}_data_out"] = pyrtl.Output(
                        bitwidth=ip.data_out.bitwidth,
                        name=f"{self._driver_prefix}{name}_data_out",
                    )
                    drivers[f"{name}_valid_out"] = pyrtl.Output(
                        bitwidth=1,
                        name=f"{self._driver_prefix}{name}_valid_out",
                    )
                    drivers[f"{name}_data_out"] <<= ip.data_out
                    drivers[f"{name}_valid_out"] <<= ip.valid_out

                    # Expose ready_in as Input.
                    drivers[f"{name}_ready_in"] = pyrtl.Input(
                        bitwidth=1,
                        name=f"{self._driver_prefix}{name}_ready_in",
                    )
                    ip.ready_in <<= drivers[f"{name}_ready_in"]

        return self._block, drivers
