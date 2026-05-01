set moduleName stateful_softmax_Pipeline_VITIS_LOOP_217_4
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
set C_modelName {stateful_softmax_Pipeline_VITIS_LOOP_217_4}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ exp_val_18 int 9 regular  }
	{ exp_val_20 int 9 regular  }
	{ exp_val_22 int 9 regular  }
	{ exp_val_24 int 9 regular  }
	{ exp_val_26 int 9 regular  }
	{ exp_val_28 int 9 regular  }
	{ exp_val_30 int 9 regular  }
	{ exp_val_32 int 9 regular  }
	{ zext_ln217 int 12 regular  }
	{ zext_ln213_17 int 9 regular  }
	{ exp_val_19 int 9 regular  }
	{ exp_val_21 int 9 regular  }
	{ exp_val_23 int 9 regular  }
	{ exp_val_25 int 9 regular  }
	{ exp_val_27 int 9 regular  }
	{ exp_val_29 int 9 regular  }
	{ exp_val_31 int 9 regular  }
	{ exp_val_33 int 9 regular  }
	{ s_softmax_out int 16 regular {fifo 1 volatile }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "exp_val_18", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "exp_val_20", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "exp_val_22", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "exp_val_24", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "exp_val_26", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "exp_val_28", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "exp_val_30", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "exp_val_32", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "zext_ln217", "interface" : "wire", "bitwidth" : 12, "direction" : "READONLY"} , 
 	{ "Name" : "zext_ln213_17", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "exp_val_19", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "exp_val_21", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "exp_val_23", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "exp_val_25", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "exp_val_27", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "exp_val_29", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "exp_val_31", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "exp_val_33", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "s_softmax_out", "interface" : "fifo", "bitwidth" : 16, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 29
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ s_softmax_out_din sc_out sc_lv 16 signal 18 } 
	{ s_softmax_out_full_n sc_in sc_logic 1 signal 18 } 
	{ s_softmax_out_write sc_out sc_logic 1 signal 18 } 
	{ s_softmax_out_num_data_valid sc_in sc_lv 32 signal 18 } 
	{ s_softmax_out_fifo_cap sc_in sc_lv 32 signal 18 } 
	{ exp_val_18 sc_in sc_lv 9 signal 0 } 
	{ exp_val_20 sc_in sc_lv 9 signal 1 } 
	{ exp_val_22 sc_in sc_lv 9 signal 2 } 
	{ exp_val_24 sc_in sc_lv 9 signal 3 } 
	{ exp_val_26 sc_in sc_lv 9 signal 4 } 
	{ exp_val_28 sc_in sc_lv 9 signal 5 } 
	{ exp_val_30 sc_in sc_lv 9 signal 6 } 
	{ exp_val_32 sc_in sc_lv 9 signal 7 } 
	{ zext_ln217 sc_in sc_lv 12 signal 8 } 
	{ zext_ln213_17 sc_in sc_lv 9 signal 9 } 
	{ exp_val_19 sc_in sc_lv 9 signal 10 } 
	{ exp_val_21 sc_in sc_lv 9 signal 11 } 
	{ exp_val_23 sc_in sc_lv 9 signal 12 } 
	{ exp_val_25 sc_in sc_lv 9 signal 13 } 
	{ exp_val_27 sc_in sc_lv 9 signal 14 } 
	{ exp_val_29 sc_in sc_lv 9 signal 15 } 
	{ exp_val_31 sc_in sc_lv 9 signal 16 } 
	{ exp_val_33 sc_in sc_lv 9 signal 17 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "s_softmax_out_din", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "s_softmax_out", "role": "din" }} , 
 	{ "name": "s_softmax_out_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_softmax_out", "role": "full_n" }} , 
 	{ "name": "s_softmax_out_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_softmax_out", "role": "write" }} , 
 	{ "name": "s_softmax_out_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_softmax_out", "role": "num_data_valid" }} , 
 	{ "name": "s_softmax_out_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_softmax_out", "role": "fifo_cap" }} , 
 	{ "name": "exp_val_18", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "exp_val_18", "role": "default" }} , 
 	{ "name": "exp_val_20", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "exp_val_20", "role": "default" }} , 
 	{ "name": "exp_val_22", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "exp_val_22", "role": "default" }} , 
 	{ "name": "exp_val_24", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "exp_val_24", "role": "default" }} , 
 	{ "name": "exp_val_26", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "exp_val_26", "role": "default" }} , 
 	{ "name": "exp_val_28", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "exp_val_28", "role": "default" }} , 
 	{ "name": "exp_val_30", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "exp_val_30", "role": "default" }} , 
 	{ "name": "exp_val_32", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "exp_val_32", "role": "default" }} , 
 	{ "name": "zext_ln217", "direction": "in", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "zext_ln217", "role": "default" }} , 
 	{ "name": "zext_ln213_17", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "zext_ln213_17", "role": "default" }} , 
 	{ "name": "exp_val_19", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "exp_val_19", "role": "default" }} , 
 	{ "name": "exp_val_21", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "exp_val_21", "role": "default" }} , 
 	{ "name": "exp_val_23", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "exp_val_23", "role": "default" }} , 
 	{ "name": "exp_val_25", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "exp_val_25", "role": "default" }} , 
 	{ "name": "exp_val_27", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "exp_val_27", "role": "default" }} , 
 	{ "name": "exp_val_29", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "exp_val_29", "role": "default" }} , 
 	{ "name": "exp_val_31", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "exp_val_31", "role": "default" }} , 
 	{ "name": "exp_val_33", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "exp_val_33", "role": "default" }}  ]}

set ArgLastReadFirstWriteLatency {
	stateful_softmax_Pipeline_VITIS_LOOP_217_4 {
		exp_val_18 {Type I LastRead 0 FirstWrite -1}
		exp_val_20 {Type I LastRead 0 FirstWrite -1}
		exp_val_22 {Type I LastRead 0 FirstWrite -1}
		exp_val_24 {Type I LastRead 0 FirstWrite -1}
		exp_val_26 {Type I LastRead 0 FirstWrite -1}
		exp_val_28 {Type I LastRead 0 FirstWrite -1}
		exp_val_30 {Type I LastRead 0 FirstWrite -1}
		exp_val_32 {Type I LastRead 0 FirstWrite -1}
		zext_ln217 {Type I LastRead 0 FirstWrite -1}
		zext_ln213_17 {Type I LastRead 0 FirstWrite -1}
		exp_val_19 {Type I LastRead 0 FirstWrite -1}
		exp_val_21 {Type I LastRead 0 FirstWrite -1}
		exp_val_23 {Type I LastRead 0 FirstWrite -1}
		exp_val_25 {Type I LastRead 0 FirstWrite -1}
		exp_val_27 {Type I LastRead 0 FirstWrite -1}
		exp_val_29 {Type I LastRead 0 FirstWrite -1}
		exp_val_31 {Type I LastRead 0 FirstWrite -1}
		exp_val_33 {Type I LastRead 0 FirstWrite -1}
		s_softmax_out {Type O LastRead -1 FirstWrite 21}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "30", "Max" : "30"}
	, {"Name" : "Interval", "Min" : "9", "Max" : "9"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	exp_val_18 { ap_none {  { exp_val_18 in_data 0 9 } } }
	exp_val_20 { ap_none {  { exp_val_20 in_data 0 9 } } }
	exp_val_22 { ap_none {  { exp_val_22 in_data 0 9 } } }
	exp_val_24 { ap_none {  { exp_val_24 in_data 0 9 } } }
	exp_val_26 { ap_none {  { exp_val_26 in_data 0 9 } } }
	exp_val_28 { ap_none {  { exp_val_28 in_data 0 9 } } }
	exp_val_30 { ap_none {  { exp_val_30 in_data 0 9 } } }
	exp_val_32 { ap_none {  { exp_val_32 in_data 0 9 } } }
	zext_ln217 { ap_none {  { zext_ln217 in_data 0 12 } } }
	zext_ln213_17 { ap_none {  { zext_ln213_17 in_data 0 9 } } }
	exp_val_19 { ap_none {  { exp_val_19 in_data 0 9 } } }
	exp_val_21 { ap_none {  { exp_val_21 in_data 0 9 } } }
	exp_val_23 { ap_none {  { exp_val_23 in_data 0 9 } } }
	exp_val_25 { ap_none {  { exp_val_25 in_data 0 9 } } }
	exp_val_27 { ap_none {  { exp_val_27 in_data 0 9 } } }
	exp_val_29 { ap_none {  { exp_val_29 in_data 0 9 } } }
	exp_val_31 { ap_none {  { exp_val_31 in_data 0 9 } } }
	exp_val_33 { ap_none {  { exp_val_33 in_data 0 9 } } }
	s_softmax_out { ap_fifo {  { s_softmax_out_din fifo_data_out 1 16 }  { s_softmax_out_full_n fifo_status_empty 0 1 }  { s_softmax_out_write fifo_data_in 1 1 }  { s_softmax_out_num_data_valid fifo_update 0 32 }  { s_softmax_out_fifo_cap fifo_data 0 32 } } }
}
