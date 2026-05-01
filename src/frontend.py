"""Declarative frontend for constructing tiled IP graphs.

This module provides a thin wrapper around :class:`stitcher.Stitcher` that
lets users build IP graphs without dealing with PyRTL block monkey-patching or
manual wiring details.
"""

from __future__ import annotations

from contextlib import contextmanager
from typing import Any, Iterator

import pyrtl

from ip_cores.axi_stream_base import StreamShape
from stitcher import Stitcher


@contextmanager
def _shared_block(block: pyrtl.Block) -> Iterator[None]:
    """Temporarily route ``pyrtl.Block`` construction to *block*.

    IP cores in this project create their own PyRTL blocks by calling
    ``pyrtl.Block()`` internally. The frontend hides that implementation detail
    by redirecting those calls to a single shared block while a node is being
    instantiated.
    """

    original_block = pyrtl.Block
    pyrtl.Block = lambda: block
    try:
        yield
    finally:
        pyrtl.Block = original_block


class TiledIPGraph:
    """Declarative graph builder for tiled IP cores.

    The graph owns a hidden shared :class:`pyrtl.Block` and a matching
    :class:`~stitcher.Stitcher`. Users add named IP nodes, connect them with
    directed edges, optionally set source input shapes, and then build the
    stitched block.
    """

    def __init__(self) -> None:
        self._block = pyrtl.Block()
        self._stitcher = Stitcher(block=self._block)
        self._nodes: dict[str, Any] = {}

    def add_node(self, name: str, ip_class: type, **kwargs: Any) -> Any:
        """Instantiate and register an IP node.

        Parameters
        ----------
        name:
            Unique graph node name.
        ip_class:
            IP core class to instantiate. It must accept ``name=...`` and the
            provided keyword arguments.
        **kwargs:
            Additional constructor arguments forwarded to ``ip_class``.
        """

        if name in self._nodes:
            raise ValueError(f"Node with name '{name}' already exists")

        with _shared_block(self._block):
            ip_instance = ip_class(name=name, **kwargs)

        self._stitcher.add_ip(ip_instance)
        self._nodes[name] = ip_instance
        return ip_instance

    def add_edge(self, src: str, dst: str) -> None:
        """Add a directed connection from ``src`` to ``dst``."""

        self._stitcher.connect(src, dst)

    def set_input_shape(self, name: str, N: int, T: int) -> None:
        """Assign an input shape to a node.

        This is a light-weight helper for users who want to seed shape
        propagation manually.
        """

        if name not in self._nodes:
            raise ValueError(f"Unknown node: {name}")
        self._nodes[name].input_shape = StreamShape(N, T)

    def build(self) -> tuple[pyrtl.Block, dict[str, Any]]:
        """Build and return the stitched PyRTL block.

        Returns
        -------
        tuple[pyrtl.Block, dict[str, Any]]
            The shared block and the driver wire dictionary returned by
            :meth:`stitcher.Stitcher.build`.
        """

        return self._stitcher.build()


__all__ = ["TiledIPGraph"]
