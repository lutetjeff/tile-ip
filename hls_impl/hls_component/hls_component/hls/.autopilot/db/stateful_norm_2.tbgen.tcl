set moduleName stateful_norm_2
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set isPipelined_legacy 0
set pipeline_type none
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
set C_modelName {stateful_norm.2}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ s_norm1_in int 16 regular {fifo 0 volatile }  }
	{ s_norm1_out int 16 regular {fifo 1 volatile }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "s_norm1_in", "interface" : "fifo", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "s_norm1_out", "interface" : "fifo", "bitwidth" : 16, "direction" : "WRITEONLY"} ]}
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
	{ s_norm1_in_dout sc_in sc_lv 16 signal 0 } 
	{ s_norm1_in_empty_n sc_in sc_logic 1 signal 0 } 
	{ s_norm1_in_read sc_out sc_logic 1 signal 0 } 
	{ s_norm1_in_num_data_valid sc_in sc_lv 3 signal 0 } 
	{ s_norm1_in_fifo_cap sc_in sc_lv 3 signal 0 } 
	{ s_norm1_out_din sc_out sc_lv 16 signal 1 } 
	{ s_norm1_out_full_n sc_in sc_logic 1 signal 1 } 
	{ s_norm1_out_write sc_out sc_logic 1 signal 1 } 
	{ s_norm1_out_num_data_valid sc_in sc_lv 32 signal 1 } 
	{ s_norm1_out_fifo_cap sc_in sc_lv 32 signal 1 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "s_norm1_in_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "s_norm1_in", "role": "dout" }} , 
 	{ "name": "s_norm1_in_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm1_in", "role": "empty_n" }} , 
 	{ "name": "s_norm1_in_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm1_in", "role": "read" }} , 
 	{ "name": "s_norm1_in_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "s_norm1_in", "role": "num_data_valid" }} , 
 	{ "name": "s_norm1_in_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "s_norm1_in", "role": "fifo_cap" }} , 
 	{ "name": "s_norm1_out_din", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "s_norm1_out", "role": "din" }} , 
 	{ "name": "s_norm1_out_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm1_out", "role": "full_n" }} , 
 	{ "name": "s_norm1_out_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm1_out", "role": "write" }} , 
 	{ "name": "s_norm1_out_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_norm1_out", "role": "num_data_valid" }} , 
 	{ "name": "s_norm1_out_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_norm1_out", "role": "fifo_cap" }}  ]}

set ArgLastReadFirstWriteLatency {
	stateful_norm_2 {
		s_norm1_in {Type I LastRead 1 FirstWrite -1}
		s_norm1_out {Type O LastRead -1 FirstWrite 1}}
	stateful_norm_2_Pipeline_VITIS_LOOP_85_1 {
		s_norm1_in {Type I LastRead 1 FirstWrite -1}
		buf_16_out {Type O LastRead -1 FirstWrite 0}
		buf_15_out {Type O LastRead -1 FirstWrite 0}
		buf_14_out {Type O LastRead -1 FirstWrite 0}
		buf_13_out {Type O LastRead -1 FirstWrite 0}
		buf_12_out {Type O LastRead -1 FirstWrite 0}
		buf_11_out {Type O LastRead -1 FirstWrite 0}
		buf_10_out {Type O LastRead -1 FirstWrite 0}
		buf_9_out {Type O LastRead -1 FirstWrite 0}
		buf_8_out {Type O LastRead -1 FirstWrite 0}
		buf_7_out {Type O LastRead -1 FirstWrite 0}
		buf_6_out {Type O LastRead -1 FirstWrite 0}
		buf_5_out {Type O LastRead -1 FirstWrite 0}
		buf_4_out {Type O LastRead -1 FirstWrite 0}
		buf_3_out {Type O LastRead -1 FirstWrite 0}
		buf_2_out {Type O LastRead -1 FirstWrite 0}
		buf_out {Type O LastRead -1 FirstWrite 0}
		sum_x_out {Type O LastRead -1 FirstWrite 0}}
	stateful_norm_2_Pipeline_VITIS_LOOP_109_3 {
		buf_reload {Type I LastRead 0 FirstWrite -1}
		buf_3_reload {Type I LastRead 0 FirstWrite -1}
		buf_5_reload {Type I LastRead 0 FirstWrite -1}
		buf_7_reload {Type I LastRead 0 FirstWrite -1}
		buf_9_reload {Type I LastRead 0 FirstWrite -1}
		buf_11_reload {Type I LastRead 0 FirstWrite -1}
		buf_13_reload {Type I LastRead 0 FirstWrite -1}
		buf_15_reload {Type I LastRead 0 FirstWrite -1}
		sext_ln100 {Type I LastRead 0 FirstWrite -1}
		buf_2_reload {Type I LastRead 0 FirstWrite -1}
		buf_4_reload {Type I LastRead 0 FirstWrite -1}
		buf_6_reload {Type I LastRead 0 FirstWrite -1}
		buf_8_reload {Type I LastRead 0 FirstWrite -1}
		buf_10_reload {Type I LastRead 0 FirstWrite -1}
		buf_12_reload {Type I LastRead 0 FirstWrite -1}
		buf_14_reload {Type I LastRead 0 FirstWrite -1}
		buf_16_reload {Type I LastRead 0 FirstWrite -1}
		s_norm1_out {Type O LastRead -1 FirstWrite 1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "23", "Max" : "23"}
	, {"Name" : "Interval", "Min" : "23", "Max" : "23"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	s_norm1_in { ap_fifo {  { s_norm1_in_dout fifo_data_out 0 16 }  { s_norm1_in_empty_n fifo_status_empty 0 1 }  { s_norm1_in_read fifo_data_in 1 1 }  { s_norm1_in_num_data_valid fifo_update 0 3 }  { s_norm1_in_fifo_cap fifo_data 0 3 } } }
	s_norm1_out { ap_fifo {  { s_norm1_out_din fifo_data_out 1 16 }  { s_norm1_out_full_n fifo_status_empty 0 1 }  { s_norm1_out_write fifo_data_in 1 1 }  { s_norm1_out_num_data_valid fifo_update 0 32 }  { s_norm1_out_fifo_cap fifo_data 0 32 } } }
}
