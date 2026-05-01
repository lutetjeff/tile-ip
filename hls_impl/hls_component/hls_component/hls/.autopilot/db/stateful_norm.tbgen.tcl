set moduleName stateful_norm
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
set C_modelName {stateful_norm}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ s_norm2_in int 16 regular {fifo 0 volatile }  }
	{ s_norm2_out int 16 regular {fifo 1 volatile }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "s_norm2_in", "interface" : "fifo", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "s_norm2_out", "interface" : "fifo", "bitwidth" : 16, "direction" : "WRITEONLY"} ]}
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
	{ s_norm2_in_dout sc_in sc_lv 16 signal 0 } 
	{ s_norm2_in_empty_n sc_in sc_logic 1 signal 0 } 
	{ s_norm2_in_read sc_out sc_logic 1 signal 0 } 
	{ s_norm2_in_num_data_valid sc_in sc_lv 3 signal 0 } 
	{ s_norm2_in_fifo_cap sc_in sc_lv 3 signal 0 } 
	{ s_norm2_out_din sc_out sc_lv 16 signal 1 } 
	{ s_norm2_out_full_n sc_in sc_logic 1 signal 1 } 
	{ s_norm2_out_write sc_out sc_logic 1 signal 1 } 
	{ s_norm2_out_num_data_valid sc_in sc_lv 32 signal 1 } 
	{ s_norm2_out_fifo_cap sc_in sc_lv 32 signal 1 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "s_norm2_in_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "s_norm2_in", "role": "dout" }} , 
 	{ "name": "s_norm2_in_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm2_in", "role": "empty_n" }} , 
 	{ "name": "s_norm2_in_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm2_in", "role": "read" }} , 
 	{ "name": "s_norm2_in_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "s_norm2_in", "role": "num_data_valid" }} , 
 	{ "name": "s_norm2_in_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "s_norm2_in", "role": "fifo_cap" }} , 
 	{ "name": "s_norm2_out_din", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "s_norm2_out", "role": "din" }} , 
 	{ "name": "s_norm2_out_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm2_out", "role": "full_n" }} , 
 	{ "name": "s_norm2_out_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm2_out", "role": "write" }} , 
 	{ "name": "s_norm2_out_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_norm2_out", "role": "num_data_valid" }} , 
 	{ "name": "s_norm2_out_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_norm2_out", "role": "fifo_cap" }}  ]}

set ArgLastReadFirstWriteLatency {
	stateful_norm {
		s_norm2_in {Type I LastRead 1 FirstWrite -1}
		s_norm2_out {Type O LastRead -1 FirstWrite 1}}
	stateful_norm_Pipeline_VITIS_LOOP_85_1 {
		s_norm2_in {Type I LastRead 1 FirstWrite -1}
		buf_49_out {Type O LastRead -1 FirstWrite 0}
		buf_48_out {Type O LastRead -1 FirstWrite 0}
		buf_47_out {Type O LastRead -1 FirstWrite 0}
		buf_46_out {Type O LastRead -1 FirstWrite 0}
		buf_45_out {Type O LastRead -1 FirstWrite 0}
		buf_44_out {Type O LastRead -1 FirstWrite 0}
		buf_43_out {Type O LastRead -1 FirstWrite 0}
		buf_42_out {Type O LastRead -1 FirstWrite 0}
		buf_41_out {Type O LastRead -1 FirstWrite 0}
		buf_40_out {Type O LastRead -1 FirstWrite 0}
		buf_39_out {Type O LastRead -1 FirstWrite 0}
		buf_38_out {Type O LastRead -1 FirstWrite 0}
		buf_37_out {Type O LastRead -1 FirstWrite 0}
		buf_36_out {Type O LastRead -1 FirstWrite 0}
		buf_35_out {Type O LastRead -1 FirstWrite 0}
		buf_out {Type O LastRead -1 FirstWrite 0}
		sum_x_out {Type O LastRead -1 FirstWrite 0}}
	stateful_norm_Pipeline_VITIS_LOOP_109_3 {
		buf_reload {Type I LastRead 0 FirstWrite -1}
		buf_36_reload {Type I LastRead 0 FirstWrite -1}
		buf_38_reload {Type I LastRead 0 FirstWrite -1}
		buf_40_reload {Type I LastRead 0 FirstWrite -1}
		buf_42_reload {Type I LastRead 0 FirstWrite -1}
		buf_44_reload {Type I LastRead 0 FirstWrite -1}
		buf_46_reload {Type I LastRead 0 FirstWrite -1}
		buf_48_reload {Type I LastRead 0 FirstWrite -1}
		sext_ln100 {Type I LastRead 0 FirstWrite -1}
		buf_35_reload {Type I LastRead 0 FirstWrite -1}
		buf_37_reload {Type I LastRead 0 FirstWrite -1}
		buf_39_reload {Type I LastRead 0 FirstWrite -1}
		buf_41_reload {Type I LastRead 0 FirstWrite -1}
		buf_43_reload {Type I LastRead 0 FirstWrite -1}
		buf_45_reload {Type I LastRead 0 FirstWrite -1}
		buf_47_reload {Type I LastRead 0 FirstWrite -1}
		buf_49_reload {Type I LastRead 0 FirstWrite -1}
		s_norm2_out {Type O LastRead -1 FirstWrite 1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "23", "Max" : "23"}
	, {"Name" : "Interval", "Min" : "23", "Max" : "23"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	s_norm2_in { ap_fifo {  { s_norm2_in_dout fifo_data_out 0 16 }  { s_norm2_in_empty_n fifo_status_empty 0 1 }  { s_norm2_in_read fifo_data_in 1 1 }  { s_norm2_in_num_data_valid fifo_update 0 3 }  { s_norm2_in_fifo_cap fifo_data 0 3 } } }
	s_norm2_out { ap_fifo {  { s_norm2_out_din fifo_data_out 1 16 }  { s_norm2_out_full_n fifo_status_empty 0 1 }  { s_norm2_out_write fifo_data_in 1 1 }  { s_norm2_out_num_data_valid fifo_update 0 32 }  { s_norm2_out_fifo_cap fifo_data 0 32 } } }
}
