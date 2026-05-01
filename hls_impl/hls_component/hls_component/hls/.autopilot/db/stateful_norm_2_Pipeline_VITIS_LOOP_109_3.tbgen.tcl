set moduleName stateful_norm_2_Pipeline_VITIS_LOOP_109_3
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
set C_modelName {stateful_norm.2_Pipeline_VITIS_LOOP_109_3}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ buf_reload int 8 regular  }
	{ buf_3_reload int 8 regular  }
	{ buf_5_reload int 8 regular  }
	{ buf_7_reload int 8 regular  }
	{ buf_9_reload int 8 regular  }
	{ buf_11_reload int 8 regular  }
	{ buf_13_reload int 8 regular  }
	{ buf_15_reload int 8 regular  }
	{ sext_ln100 int 8 regular  }
	{ buf_2_reload int 8 regular  }
	{ buf_4_reload int 8 regular  }
	{ buf_6_reload int 8 regular  }
	{ buf_8_reload int 8 regular  }
	{ buf_10_reload int 8 regular  }
	{ buf_12_reload int 8 regular  }
	{ buf_14_reload int 8 regular  }
	{ buf_16_reload int 8 regular  }
	{ s_norm1_out int 16 regular {fifo 1 volatile }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "buf_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_3_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_5_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_7_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_9_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_11_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_13_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_15_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln100", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_2_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_4_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_6_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_8_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_10_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_12_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_14_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_16_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "s_norm1_out", "interface" : "fifo", "bitwidth" : 16, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 28
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ s_norm1_out_din sc_out sc_lv 16 signal 17 } 
	{ s_norm1_out_full_n sc_in sc_logic 1 signal 17 } 
	{ s_norm1_out_write sc_out sc_logic 1 signal 17 } 
	{ s_norm1_out_num_data_valid sc_in sc_lv 32 signal 17 } 
	{ s_norm1_out_fifo_cap sc_in sc_lv 32 signal 17 } 
	{ buf_reload sc_in sc_lv 8 signal 0 } 
	{ buf_3_reload sc_in sc_lv 8 signal 1 } 
	{ buf_5_reload sc_in sc_lv 8 signal 2 } 
	{ buf_7_reload sc_in sc_lv 8 signal 3 } 
	{ buf_9_reload sc_in sc_lv 8 signal 4 } 
	{ buf_11_reload sc_in sc_lv 8 signal 5 } 
	{ buf_13_reload sc_in sc_lv 8 signal 6 } 
	{ buf_15_reload sc_in sc_lv 8 signal 7 } 
	{ sext_ln100 sc_in sc_lv 8 signal 8 } 
	{ buf_2_reload sc_in sc_lv 8 signal 9 } 
	{ buf_4_reload sc_in sc_lv 8 signal 10 } 
	{ buf_6_reload sc_in sc_lv 8 signal 11 } 
	{ buf_8_reload sc_in sc_lv 8 signal 12 } 
	{ buf_10_reload sc_in sc_lv 8 signal 13 } 
	{ buf_12_reload sc_in sc_lv 8 signal 14 } 
	{ buf_14_reload sc_in sc_lv 8 signal 15 } 
	{ buf_16_reload sc_in sc_lv 8 signal 16 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "s_norm1_out_din", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "s_norm1_out", "role": "din" }} , 
 	{ "name": "s_norm1_out_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm1_out", "role": "full_n" }} , 
 	{ "name": "s_norm1_out_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm1_out", "role": "write" }} , 
 	{ "name": "s_norm1_out_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_norm1_out", "role": "num_data_valid" }} , 
 	{ "name": "s_norm1_out_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_norm1_out", "role": "fifo_cap" }} , 
 	{ "name": "buf_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_reload", "role": "default" }} , 
 	{ "name": "buf_3_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_3_reload", "role": "default" }} , 
 	{ "name": "buf_5_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_5_reload", "role": "default" }} , 
 	{ "name": "buf_7_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_7_reload", "role": "default" }} , 
 	{ "name": "buf_9_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_9_reload", "role": "default" }} , 
 	{ "name": "buf_11_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_11_reload", "role": "default" }} , 
 	{ "name": "buf_13_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_13_reload", "role": "default" }} , 
 	{ "name": "buf_15_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_15_reload", "role": "default" }} , 
 	{ "name": "sext_ln100", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln100", "role": "default" }} , 
 	{ "name": "buf_2_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_2_reload", "role": "default" }} , 
 	{ "name": "buf_4_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_4_reload", "role": "default" }} , 
 	{ "name": "buf_6_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_6_reload", "role": "default" }} , 
 	{ "name": "buf_8_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_8_reload", "role": "default" }} , 
 	{ "name": "buf_10_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_10_reload", "role": "default" }} , 
 	{ "name": "buf_12_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_12_reload", "role": "default" }} , 
 	{ "name": "buf_14_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_14_reload", "role": "default" }} , 
 	{ "name": "buf_16_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_16_reload", "role": "default" }}  ]}

set ArgLastReadFirstWriteLatency {
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
	{"Name" : "Latency", "Min" : "10", "Max" : "10"}
	, {"Name" : "Interval", "Min" : "9", "Max" : "9"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	buf_reload { ap_none {  { buf_reload in_data 0 8 } } }
	buf_3_reload { ap_none {  { buf_3_reload in_data 0 8 } } }
	buf_5_reload { ap_none {  { buf_5_reload in_data 0 8 } } }
	buf_7_reload { ap_none {  { buf_7_reload in_data 0 8 } } }
	buf_9_reload { ap_none {  { buf_9_reload in_data 0 8 } } }
	buf_11_reload { ap_none {  { buf_11_reload in_data 0 8 } } }
	buf_13_reload { ap_none {  { buf_13_reload in_data 0 8 } } }
	buf_15_reload { ap_none {  { buf_15_reload in_data 0 8 } } }
	sext_ln100 { ap_none {  { sext_ln100 in_data 0 8 } } }
	buf_2_reload { ap_none {  { buf_2_reload in_data 0 8 } } }
	buf_4_reload { ap_none {  { buf_4_reload in_data 0 8 } } }
	buf_6_reload { ap_none {  { buf_6_reload in_data 0 8 } } }
	buf_8_reload { ap_none {  { buf_8_reload in_data 0 8 } } }
	buf_10_reload { ap_none {  { buf_10_reload in_data 0 8 } } }
	buf_12_reload { ap_none {  { buf_12_reload in_data 0 8 } } }
	buf_14_reload { ap_none {  { buf_14_reload in_data 0 8 } } }
	buf_16_reload { ap_none {  { buf_16_reload in_data 0 8 } } }
	s_norm1_out { ap_fifo {  { s_norm1_out_din fifo_data_out 1 16 }  { s_norm1_out_full_n fifo_status_empty 0 1 }  { s_norm1_out_write fifo_data_in 1 1 }  { s_norm1_out_num_data_valid fifo_update 0 32 }  { s_norm1_out_fifo_cap fifo_data 0 32 } } }
}
