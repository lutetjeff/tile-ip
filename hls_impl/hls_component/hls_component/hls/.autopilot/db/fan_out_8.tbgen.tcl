set moduleName fan_out_8
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
set C_modelName {fan_out.8}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ in_r int 16 regular {axi_s 0 volatile  { in_r Data } }  }
	{ s_fifo1 int 16 regular {fifo 1 volatile }  }
	{ s_norm1_in int 16 regular {fifo 1 volatile }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "in_r", "interface" : "axis", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "s_fifo1", "interface" : "fifo", "bitwidth" : 16, "direction" : "WRITEONLY"} , 
 	{ "Name" : "s_norm1_in", "interface" : "fifo", "bitwidth" : 16, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 23
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ start_full_n sc_in sc_logic 1 signal -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ in_r_TVALID sc_in sc_logic 1 invld 0 } 
	{ s_fifo1_din sc_out sc_lv 16 signal 1 } 
	{ s_fifo1_full_n sc_in sc_logic 1 signal 1 } 
	{ s_fifo1_write sc_out sc_logic 1 signal 1 } 
	{ s_fifo1_num_data_valid sc_in sc_lv 8 signal 1 } 
	{ s_fifo1_fifo_cap sc_in sc_lv 8 signal 1 } 
	{ s_norm1_in_din sc_out sc_lv 16 signal 2 } 
	{ s_norm1_in_full_n sc_in sc_logic 1 signal 2 } 
	{ s_norm1_in_write sc_out sc_logic 1 signal 2 } 
	{ s_norm1_in_num_data_valid sc_in sc_lv 3 signal 2 } 
	{ s_norm1_in_fifo_cap sc_in sc_lv 3 signal 2 } 
	{ start_out sc_out sc_logic 1 signal -1 } 
	{ start_write sc_out sc_logic 1 signal -1 } 
	{ in_r_TDATA sc_in sc_lv 16 signal 0 } 
	{ in_r_TREADY sc_out sc_logic 1 inacc 0 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "start_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_full_n", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "in_r_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_r", "role": "TVALID" }} , 
 	{ "name": "s_fifo1_din", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "s_fifo1", "role": "din" }} , 
 	{ "name": "s_fifo1_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_fifo1", "role": "full_n" }} , 
 	{ "name": "s_fifo1_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_fifo1", "role": "write" }} , 
 	{ "name": "s_fifo1_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "s_fifo1", "role": "num_data_valid" }} , 
 	{ "name": "s_fifo1_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "s_fifo1", "role": "fifo_cap" }} , 
 	{ "name": "s_norm1_in_din", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "s_norm1_in", "role": "din" }} , 
 	{ "name": "s_norm1_in_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm1_in", "role": "full_n" }} , 
 	{ "name": "s_norm1_in_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm1_in", "role": "write" }} , 
 	{ "name": "s_norm1_in_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "s_norm1_in", "role": "num_data_valid" }} , 
 	{ "name": "s_norm1_in_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "s_norm1_in", "role": "fifo_cap" }} , 
 	{ "name": "start_out", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_out", "role": "default" }} , 
 	{ "name": "start_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_write", "role": "default" }} , 
 	{ "name": "in_r_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "in_r", "role": "TDATA" }} , 
 	{ "name": "in_r_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_r", "role": "TREADY" }}  ]}

set ArgLastReadFirstWriteLatency {
	fan_out_8 {
		in_r {Type I LastRead 0 FirstWrite -1}
		s_fifo1 {Type O LastRead -1 FirstWrite 0}
		s_norm1_in {Type O LastRead -1 FirstWrite 0}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "9", "Max" : "9"}
	, {"Name" : "Interval", "Min" : "8", "Max" : "8"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	in_r { axis {  { in_r_TVALID in_vld 0 1 }  { in_r_TDATA in_data 0 16 }  { in_r_TREADY in_acc 1 1 } } }
	s_fifo1 { ap_fifo {  { s_fifo1_din fifo_data_out 1 16 }  { s_fifo1_full_n fifo_status_empty 0 1 }  { s_fifo1_write fifo_data_in 1 1 }  { s_fifo1_num_data_valid fifo_update 0 8 }  { s_fifo1_fifo_cap fifo_data 0 8 } } }
	s_norm1_in { ap_fifo {  { s_norm1_in_din fifo_data_out 1 16 }  { s_norm1_in_full_n fifo_status_empty 0 1 }  { s_norm1_in_write fifo_data_in 1 1 }  { s_norm1_in_num_data_valid fifo_update 0 3 }  { s_norm1_in_fifo_cap fifo_data 0 3 } } }
}
