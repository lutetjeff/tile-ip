set moduleName activation_relu
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set isPipelined_legacy 1
set pipeline_type loop_auto_rewind
set FunctionProtocol ap_ctrl_hs
set restart_counter_num 0
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set DLRegFirstOffset 0
set DLRegItemOffset 0
set svuvm_can_support 1
set cdfgNum 33
set C_modelName {activation_relu}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ s_gemm3_out int 16 regular {fifo 0 volatile }  }
	{ s_relu_out int 16 regular {fifo 1 volatile }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "s_gemm3_out", "interface" : "fifo", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "s_relu_out", "interface" : "fifo", "bitwidth" : 16, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 17
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ s_gemm3_out_dout sc_in sc_lv 16 signal 0 } 
	{ s_gemm3_out_empty_n sc_in sc_logic 1 signal 0 } 
	{ s_gemm3_out_read sc_out sc_logic 1 signal 0 } 
	{ s_gemm3_out_num_data_valid sc_in sc_lv 3 signal 0 } 
	{ s_gemm3_out_fifo_cap sc_in sc_lv 3 signal 0 } 
	{ s_relu_out_din sc_out sc_lv 16 signal 1 } 
	{ s_relu_out_full_n sc_in sc_logic 1 signal 1 } 
	{ s_relu_out_write sc_out sc_logic 1 signal 1 } 
	{ s_relu_out_num_data_valid sc_in sc_lv 3 signal 1 } 
	{ s_relu_out_fifo_cap sc_in sc_lv 3 signal 1 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "s_gemm3_out_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "s_gemm3_out", "role": "dout" }} , 
 	{ "name": "s_gemm3_out_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_gemm3_out", "role": "empty_n" }} , 
 	{ "name": "s_gemm3_out_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_gemm3_out", "role": "read" }} , 
 	{ "name": "s_gemm3_out_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "s_gemm3_out", "role": "num_data_valid" }} , 
 	{ "name": "s_gemm3_out_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "s_gemm3_out", "role": "fifo_cap" }} , 
 	{ "name": "s_relu_out_din", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "s_relu_out", "role": "din" }} , 
 	{ "name": "s_relu_out_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_relu_out", "role": "full_n" }} , 
 	{ "name": "s_relu_out_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_relu_out", "role": "write" }} , 
 	{ "name": "s_relu_out_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "s_relu_out", "role": "num_data_valid" }} , 
 	{ "name": "s_relu_out_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "s_relu_out", "role": "fifo_cap" }}  ]}

set ArgLastReadFirstWriteLatency {
	activation_relu {
		s_gemm3_out {Type I LastRead 0 FirstWrite -1}
		s_relu_out {Type O LastRead -1 FirstWrite 0}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "9", "Max" : "9"}
	, {"Name" : "Interval", "Min" : "8", "Max" : "8"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	s_gemm3_out { ap_fifo {  { s_gemm3_out_dout fifo_data_out 0 16 }  { s_gemm3_out_empty_n fifo_status_empty 0 1 }  { s_gemm3_out_read fifo_data_in 1 1 }  { s_gemm3_out_num_data_valid fifo_update 0 3 }  { s_gemm3_out_fifo_cap fifo_data 0 3 } } }
	s_relu_out { ap_fifo {  { s_relu_out_din fifo_data_out 1 16 }  { s_relu_out_full_n fifo_status_empty 0 1 }  { s_relu_out_write fifo_data_in 1 1 }  { s_relu_out_num_data_valid fifo_update 0 3 }  { s_relu_out_fifo_cap fifo_data 0 3 } } }
}
