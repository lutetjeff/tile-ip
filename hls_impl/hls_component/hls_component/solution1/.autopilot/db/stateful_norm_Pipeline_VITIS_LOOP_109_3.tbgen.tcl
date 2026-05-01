set moduleName stateful_norm_Pipeline_VITIS_LOOP_109_3
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
set C_modelName {stateful_norm_Pipeline_VITIS_LOOP_109_3}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ buf_reload int 8 regular  }
	{ buf_36_reload int 8 regular  }
	{ buf_38_reload int 8 regular  }
	{ buf_40_reload int 8 regular  }
	{ buf_42_reload int 8 regular  }
	{ buf_44_reload int 8 regular  }
	{ buf_46_reload int 8 regular  }
	{ buf_48_reload int 8 regular  }
	{ sext_ln100 int 8 regular  }
	{ buf_35_reload int 8 regular  }
	{ buf_37_reload int 8 regular  }
	{ buf_39_reload int 8 regular  }
	{ buf_41_reload int 8 regular  }
	{ buf_43_reload int 8 regular  }
	{ buf_45_reload int 8 regular  }
	{ buf_47_reload int 8 regular  }
	{ buf_49_reload int 8 regular  }
	{ s_norm2_out int 16 regular {fifo 1 volatile }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "buf_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_36_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_38_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_40_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_42_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_44_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_46_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_48_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln100", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_35_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_37_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_39_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_41_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_43_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_45_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_47_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "buf_49_reload", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "s_norm2_out", "interface" : "fifo", "bitwidth" : 16, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 28
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ s_norm2_out_din sc_out sc_lv 16 signal 17 } 
	{ s_norm2_out_full_n sc_in sc_logic 1 signal 17 } 
	{ s_norm2_out_write sc_out sc_logic 1 signal 17 } 
	{ s_norm2_out_num_data_valid sc_in sc_lv 32 signal 17 } 
	{ s_norm2_out_fifo_cap sc_in sc_lv 32 signal 17 } 
	{ buf_reload sc_in sc_lv 8 signal 0 } 
	{ buf_36_reload sc_in sc_lv 8 signal 1 } 
	{ buf_38_reload sc_in sc_lv 8 signal 2 } 
	{ buf_40_reload sc_in sc_lv 8 signal 3 } 
	{ buf_42_reload sc_in sc_lv 8 signal 4 } 
	{ buf_44_reload sc_in sc_lv 8 signal 5 } 
	{ buf_46_reload sc_in sc_lv 8 signal 6 } 
	{ buf_48_reload sc_in sc_lv 8 signal 7 } 
	{ sext_ln100 sc_in sc_lv 8 signal 8 } 
	{ buf_35_reload sc_in sc_lv 8 signal 9 } 
	{ buf_37_reload sc_in sc_lv 8 signal 10 } 
	{ buf_39_reload sc_in sc_lv 8 signal 11 } 
	{ buf_41_reload sc_in sc_lv 8 signal 12 } 
	{ buf_43_reload sc_in sc_lv 8 signal 13 } 
	{ buf_45_reload sc_in sc_lv 8 signal 14 } 
	{ buf_47_reload sc_in sc_lv 8 signal 15 } 
	{ buf_49_reload sc_in sc_lv 8 signal 16 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "s_norm2_out_din", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "s_norm2_out", "role": "din" }} , 
 	{ "name": "s_norm2_out_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm2_out", "role": "full_n" }} , 
 	{ "name": "s_norm2_out_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm2_out", "role": "write" }} , 
 	{ "name": "s_norm2_out_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_norm2_out", "role": "num_data_valid" }} , 
 	{ "name": "s_norm2_out_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_norm2_out", "role": "fifo_cap" }} , 
 	{ "name": "buf_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_reload", "role": "default" }} , 
 	{ "name": "buf_36_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_36_reload", "role": "default" }} , 
 	{ "name": "buf_38_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_38_reload", "role": "default" }} , 
 	{ "name": "buf_40_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_40_reload", "role": "default" }} , 
 	{ "name": "buf_42_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_42_reload", "role": "default" }} , 
 	{ "name": "buf_44_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_44_reload", "role": "default" }} , 
 	{ "name": "buf_46_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_46_reload", "role": "default" }} , 
 	{ "name": "buf_48_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_48_reload", "role": "default" }} , 
 	{ "name": "sext_ln100", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln100", "role": "default" }} , 
 	{ "name": "buf_35_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_35_reload", "role": "default" }} , 
 	{ "name": "buf_37_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_37_reload", "role": "default" }} , 
 	{ "name": "buf_39_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_39_reload", "role": "default" }} , 
 	{ "name": "buf_41_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_41_reload", "role": "default" }} , 
 	{ "name": "buf_43_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_43_reload", "role": "default" }} , 
 	{ "name": "buf_45_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_45_reload", "role": "default" }} , 
 	{ "name": "buf_47_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_47_reload", "role": "default" }} , 
 	{ "name": "buf_49_reload", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_49_reload", "role": "default" }}  ]}

set ArgLastReadFirstWriteLatency {
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
	{"Name" : "Latency", "Min" : "10", "Max" : "10"}
	, {"Name" : "Interval", "Min" : "9", "Max" : "9"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	buf_reload { ap_none {  { buf_reload in_data 0 8 } } }
	buf_36_reload { ap_none {  { buf_36_reload in_data 0 8 } } }
	buf_38_reload { ap_none {  { buf_38_reload in_data 0 8 } } }
	buf_40_reload { ap_none {  { buf_40_reload in_data 0 8 } } }
	buf_42_reload { ap_none {  { buf_42_reload in_data 0 8 } } }
	buf_44_reload { ap_none {  { buf_44_reload in_data 0 8 } } }
	buf_46_reload { ap_none {  { buf_46_reload in_data 0 8 } } }
	buf_48_reload { ap_none {  { buf_48_reload in_data 0 8 } } }
	sext_ln100 { ap_none {  { sext_ln100 in_data 0 8 } } }
	buf_35_reload { ap_none {  { buf_35_reload in_data 0 8 } } }
	buf_37_reload { ap_none {  { buf_37_reload in_data 0 8 } } }
	buf_39_reload { ap_none {  { buf_39_reload in_data 0 8 } } }
	buf_41_reload { ap_none {  { buf_41_reload in_data 0 8 } } }
	buf_43_reload { ap_none {  { buf_43_reload in_data 0 8 } } }
	buf_45_reload { ap_none {  { buf_45_reload in_data 0 8 } } }
	buf_47_reload { ap_none {  { buf_47_reload in_data 0 8 } } }
	buf_49_reload { ap_none {  { buf_49_reload in_data 0 8 } } }
	s_norm2_out { ap_fifo {  { s_norm2_out_din fifo_data_out 1 16 }  { s_norm2_out_full_n fifo_status_empty 0 1 }  { s_norm2_out_write fifo_data_in 1 1 }  { s_norm2_out_num_data_valid fifo_update 0 32 }  { s_norm2_out_fifo_cap fifo_data 0 32 } } }
}
