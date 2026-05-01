#!/usr/bin/env python3
"""Visualize a TiledIPGraph using Graphviz."""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent / "src"))

import graphviz

from ip_cores.axi_stream_base import StreamShape


def _get_ip_params(ip) -> dict[str, str]:
    params: dict[str, str] = {}
    cls_name = ip.__class__.__name__

    if cls_name == "FIFOCore":
        depth = getattr(ip, "depth", getattr(ip, "_depth", None))
        if depth is not None:
            params["depth"] = str(depth)

    if cls_name == "ALUCore":
        op_mode = getattr(ip, "op_mode", getattr(ip, "_op_mode", None))
        if op_mode is not None:
            params["op_mode"] = str(op_mode)

    if cls_name == "ActivationCore":
        act_type = getattr(ip, "_activation_type", None)
        if act_type is not None:
            params["activation"] = str(act_type)

    if cls_name == "TemporalGEMMCore":
        for key in ("_T_M", "_T_K", "_T_N", "_M", "_N"):
            val = getattr(ip, key, None)
            if val is not None:
                params[key.lstrip("_")] = str(val)

    if cls_name == "StatefulNormCore":
        nch = getattr(ip, "_N_channel", None)
        if nch is not None:
            params["N_channel"] = str(nch)
        rms = getattr(ip, "_is_rmsnorm", None)
        params["type"] = "RMSNorm" if rms else "LayerNorm"

    if cls_name == "StatefulSoftmaxCore":
        for key in ("_N_seq", "_T_seq"):
            val = getattr(ip, key, None)
            if val is not None:
                params[key.lstrip("_")] = str(val)

    if cls_name == "StreamShapeAdapter":
        for key in ("_N", "_T_in", "_T_out"):
            val = getattr(ip, key, None)
            if val is not None:
                params[key.lstrip("_")] = str(val)

    return params


def _shape_str(shape: StreamShape | None) -> str:
    if shape is None:
        return "None"
    return f"StreamShape(N={shape.N}, T={shape.T})  beats={shape.num_beats}"


def _ip_label(name: str, ip) -> str:
    cls_name = ip.__class__.__name__
    params = _get_ip_params(ip)
    tiling = getattr(ip, "_tiling_param", "?")

    lines = [
        f'<B>{name}</B>',
        f'<FONT POINT-SIZE="10">{cls_name}</FONT>',
        f'<FONT POINT-SIZE="9" COLOR="#555555">T={tiling}</FONT>',
    ]

    if params:
        param_strs = [f"{k}={v}" for k, v in params.items()]
        lines.append(f'<FONT POINT-SIZE="9" COLOR="#333333">{", ".join(param_strs)}</FONT>')

    lines.append(f'<FONT POINT-SIZE="9" COLOR="#0066cc">in:  {_shape_str(ip.input_shape)}</FONT>')
    lines.append(f'<FONT POINT-SIZE="9" COLOR="#cc6600">out: {_shape_str(ip.output_shape)}</FONT>')

    return "<" + "<BR/>".join(lines) + ">"


def _ip_color(cls_name: str) -> str:
    palette = {
        "FIFOCore": "#e1f5fe",
        "StatefulNormCore": "#f3e5f5",
        "TemporalGEMMCore": "#e8f5e9",
        "StatefulSoftmaxCore": "#fff3e0",
        "ALUCore": "#ffebee",
        "ActivationCore": "#e0f2f1",
        "StreamShapeAdapter": "#fffde7",
    }
    return palette.get(cls_name, "#f5f5f5")


def visualize_graph(
    graph,
    output_path: str = "ip_graph",
    fmt: str = "svg",
    view: bool = False,
):
    if not hasattr(graph, "_stitcher"):
        raise TypeError("Expected a TiledIPGraph instance")

    stitcher = graph._stitcher

    try:
        stitcher.build()
    except Exception:
        pass

    ips = stitcher._ips
    edges = stitcher._edges

    dot = graphviz.Digraph(
        name="TiledIPGraph",
        comment="TiledIP Graph Visualization",
        format=fmt,
    )
    dot.attr(rankdir="LR", bgcolor="white")
    dot.attr("node", shape="box", style="rounded,filled", fontname="Helvetica")
    dot.attr("edge", fontname="Helvetica", fontsize="9")

    for name, ip in ips.items():
        dot.node(name, label=_ip_label(name, ip), fillcolor=_ip_color(ip.__class__.__name__))

    for src_name, dst_name in edges:
        src = ips.get(src_name)
        dst = ips.get(dst_name)
        if src is None or dst is None:
            continue

        out_shape = src.output_shape
        shape_label = f"N={out_shape.N}, T={out_shape.T}" if out_shape is not None else ""
        dot.edge(src_name, dst_name, label=shape_label, color="#555555")

    dot.render(output_path, cleanup=True, view=view)
    print(f"Rendered to {output_path}.{fmt}")
    return dot


def main():
    parser = argparse.ArgumentParser(description="Visualize a TiledIPGraph with Graphviz")
    parser.add_argument("--output", "-o", default="ip_graph", help="Output file base name")
    parser.add_argument("--format", "-f", default="svg", help="Output format")
    parser.add_argument("--view", "-v", action="store_true", help="Open in default viewer")
    parser.add_argument(
        "--example",
        "-e",
        default="transformer_block",
        choices=["transformer_block", "ffn_block"],
    )
    args = parser.parse_args()

    sys.path.insert(0, str(Path(__file__).parent.parent / "examples"))

    if args.example == "transformer_block":
        from transformer_block import build_transformer
        _, _, graph = build_transformer(seq_len=4, emb_dim=4, T=2)
    else:
        from ffn_block import build_ffn
        _, _, graph = build_ffn(seq_len=4, emb_dim=4, T=2)

    visualize_graph(graph, output_path=args.output, fmt=args.format, view=args.view)


if __name__ == "__main__":
    main()
