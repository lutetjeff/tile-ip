"""Stitcher for connecting AXI4-Stream-Lite IP cores in chains and graphs.

Provides a declarative API to wire multiple tile-based IPs into a single
shared PyRTL block without manual ``<<=`` assignments.
"""

from __future__ import annotations

import pyrtl
from pyrtl import WireVector

from ip_cores.axi_stream_base import AXI4StreamLiteBase


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

        Fan-in (N→1) is **not supported** in Phase 1 and raises
        ``ValueError``.

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

        # Build adjacency lists
        upstream: dict[str, list[str]] = {name: [] for name in self._ips}
        downstream: dict[str, list[str]] = {name: [] for name in self._ips}
        for src, dst in self._edges:
            downstream[src].append(dst)
            upstream[dst].append(src)

        # Fan-in guard (Phase 1)
        for name, ups in upstream.items():
            if len(ups) > 1:
                raise ValueError(
                    f"IP '{name}' has multiple upstreams ({ups}). "
                    "Fan-in is not supported in Phase 1. Use an explicit merge IP."
                )

        drivers: dict[str, WireVector] = {}

        with pyrtl.set_working_block(self._block, no_sanity_check=True):
            # ---- Forward datapath: data_out -> data_in, valid_out -> valid_in ----
            for src_name, dst_name in self._edges:
                src = self._ips[src_name]
                dst = self._ips[dst_name]
                dst.data_in <<= src.data_out
                dst.valid_in <<= src.valid_out

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
                    # Source: expose data_in, valid_in as Inputs.
                    drivers[f"{name}_data_in"] = pyrtl.Input(
                        bitwidth=ip.data_in.bitwidth,
                        name=f"{self._driver_prefix}{name}_data_in",
                    )
                    drivers[f"{name}_valid_in"] = pyrtl.Input(
                        bitwidth=1,
                        name=f"{self._driver_prefix}{name}_valid_in",
                    )
                    ip.data_in <<= drivers[f"{name}_data_in"]
                    ip.valid_in <<= drivers[f"{name}_valid_in"]

                    # Expose ready_out as Output for observation.
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
