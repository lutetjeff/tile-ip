"""AXI4-Stream-Lite base class for tile-based IP cores.

Provides an isolated PyRTL working block per instance and standard
handshake ports so that multiple IPs can coexist without wire-name
collisions or global-state pollution.
"""

from __future__ import annotations

from dataclasses import dataclass

import pyrtl
from pyrtl import WireVector


@dataclass(frozen=True)
class StreamShape:
    N: int
    T: int

    def __post_init__(self):
        if self.N <= 0 or self.T <= 0:
            raise ValueError("N and T must be positive")
        if self.N % self.T != 0:
            raise ValueError(f"N ({self.N}) must be a multiple of T ({self.T})")

    @property
    def num_beats(self) -> int:
        return self.N // self.T


class AXI4StreamLiteBase:
    """Universal interface wrapper for all tile-based IPs.

    Parameters
    ----------
    tiling_param : int
        Spatial tiling parameter ``T``.  The flattened data buses are
        ``T * 8`` bits wide.
    name : str
        Unique instance name.  All internal wires are prefixed with this
        string to avoid collisions when multiple IPs are instantiated.

    Attributes
    ----------
    block : pyrtl.Block
        The isolated PyRTL working block owned by this instance.
    data_in : WireVector
        Flattened input bus (width = ``T * 8``).
    valid_in : WireVector
        1-bit control signal from upstream producer.
    ready_out : WireVector
        1-bit control signal to upstream producer.
    data_out : WireVector
        Flattened output bus (width = ``T * 8``).
    valid_out : WireVector
        1-bit control signal to downstream consumer.
    ready_in : WireVector
        1-bit control signal from downstream consumer.
    """

    def __init__(self, tiling_param: int, name: str, block: pyrtl.Block = None,
                 input_shape: StreamShape | None = None) -> None:
        if tiling_param <= 0:
            raise ValueError("tiling_param must be a positive integer")
        if not name:
            raise ValueError("name must be a non-empty string")

        self._tiling_param = tiling_param
        self._name = name
        self._bus_width = tiling_param * 8
        self._input_shape = input_shape
        self._output_shape: StreamShape | None = None

        self.block = block if block is not None else pyrtl.Block()
        with pyrtl.set_working_block(self.block, no_sanity_check=True):
            self.data_in = WireVector(bitwidth=self._bus_width, name=f"{name}_data_in")
            self.valid_in = WireVector(bitwidth=1, name=f"{name}_valid_in")
            self.ready_out = WireVector(bitwidth=1, name=f"{name}_ready_out")
            self.data_out = WireVector(
                bitwidth=self._bus_width, name=f"{name}_data_out"
            )
            self.valid_out = WireVector(bitwidth=1, name=f"{name}_valid_out")
            self.ready_in = WireVector(bitwidth=1, name=f"{name}_ready_in")

    @property
    def input_shape(self) -> StreamShape | None:
        return self._input_shape

    @input_shape.setter
    def input_shape(self, shape: StreamShape) -> None:
        self._input_shape = shape

    @property
    def output_shape(self) -> StreamShape | None:
        if self._output_shape is not None:
            return self._output_shape
        return self.infer_output_shape()

    @output_shape.setter
    def output_shape(self, shape: StreamShape) -> None:
        self._output_shape = shape

    def infer_output_shape(self) -> StreamShape | None:
        return None

    # ------------------------------------------------------------------
    # Handshake helpers
    # ------------------------------------------------------------------

    def handshake_accepted(self) -> WireVector:
        """Return a 1-bit signal high when input data is accepted.

        A transfer on the input side occurs when both ``valid_in`` and
        ``ready_out`` are asserted.
        """
        with pyrtl.set_working_block(self.block, no_sanity_check=True):
            return self.valid_in & self.ready_out

    def stall_pipeline(self) -> WireVector:
        """Return a 1-bit signal high when the output is stalled.

        The pipeline should stall when this IP has valid output data
        (``valid_out``) but the downstream consumer is not ready
        (``ready_in`` low).
        """
        with pyrtl.set_working_block(self.block, no_sanity_check=True):
            return self.valid_out & ~self.ready_in

    # ------------------------------------------------------------------
    # Block management
    # ------------------------------------------------------------------

    @classmethod
    def reset(cls) -> None:
        """Reset the global PyRTL working block.

        This is useful in test suites or between compilation passes to
        discard any wires that may have leaked into the default global
        block.
        """
        pyrtl.reset_working_block()
