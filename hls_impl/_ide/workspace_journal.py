# 2026-05-01T13:57:04.751926072
import vitis

client = vitis.create_client()
client.set_workspace(path="hls_impl")

comp = client.create_hls_component(name = "hls_component",cfg_file = ["hls_config.cfg"],template = "empty_hls_component")

cfg = client.get_config_file(path="/home/lutet/tiled-ip/hls_impl/hls_component/hls_config.cfg")

cfg.set_values(key="syn.file", values=["main.cpp"])

comp = client.get_component(name="hls_component")
comp.run(operation="SYNTHESIS")

cfg.set_value(section="hls", key="syn.top", value="transformer_top")

comp.run(operation="SYNTHESIS")

comp.run(operation="SYNTHESIS")

