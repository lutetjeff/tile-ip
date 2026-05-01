set moduleName stateful_norm_Pipeline_VITIS_LOOP_85_1
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
set C_modelName {stateful_norm_Pipeline_VITIS_LOOP_85_1}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ s_norm2_in int 16 regular {fifo 0 volatile }  }
	{ buf_49_out int 8 regular {pointer 1}  }
	{ buf_48_out int 8 regular {pointer 1}  }
	{ buf_47_out int 8 regular {pointer 1}  }
	{ buf_46_out int 8 regular {pointer 1}  }
	{ buf_45_out int 8 regular {pointer 1}  }
	{ buf_44_out int 8 regular {pointer 1}  }
	{ buf_43_out int 8 regular {pointer 1}  }
	{ buf_42_out int 8 regular {pointer 1}  }
	{ buf_41_out int 8 regular {pointer 1}  }
	{ buf_40_out int 8 regular {pointer 1}  }
	{ buf_39_out int 8 regular {pointer 1}  }
	{ buf_38_out int 8 regular {pointer 1}  }
	{ buf_37_out int 8 regular {pointer 1}  }
	{ buf_36_out int 8 regular {pointer 1}  }
	{ buf_35_out int 8 regular {pointer 1}  }
	{ buf_out int 8 regular {pointer 1}  }
	{ sum_x_out int 12 regular {pointer 1}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "s_norm2_in", "interface" : "fifo", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "buf_49_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_48_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_47_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_46_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_45_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_44_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_43_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_42_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_41_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_40_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_39_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_38_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_37_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_36_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_35_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "sum_x_out", "interface" : "wire", "bitwidth" : 12, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 45
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ s_norm2_in_dout sc_in sc_lv 16 signal 0 } 
	{ s_norm2_in_empty_n sc_in sc_logic 1 signal 0 } 
	{ s_norm2_in_read sc_out sc_logic 1 signal 0 } 
	{ s_norm2_in_num_data_valid sc_in sc_lv 3 signal 0 } 
	{ s_norm2_in_fifo_cap sc_in sc_lv 3 signal 0 } 
	{ buf_49_out sc_out sc_lv 8 signal 1 } 
	{ buf_49_out_ap_vld sc_out sc_logic 1 outvld 1 } 
	{ buf_48_out sc_out sc_lv 8 signal 2 } 
	{ buf_48_out_ap_vld sc_out sc_logic 1 outvld 2 } 
	{ buf_47_out sc_out sc_lv 8 signal 3 } 
	{ buf_47_out_ap_vld sc_out sc_logic 1 outvld 3 } 
	{ buf_46_out sc_out sc_lv 8 signal 4 } 
	{ buf_46_out_ap_vld sc_out sc_logic 1 outvld 4 } 
	{ buf_45_out sc_out sc_lv 8 signal 5 } 
	{ buf_45_out_ap_vld sc_out sc_logic 1 outvld 5 } 
	{ buf_44_out sc_out sc_lv 8 signal 6 } 
	{ buf_44_out_ap_vld sc_out sc_logic 1 outvld 6 } 
	{ buf_43_out sc_out sc_lv 8 signal 7 } 
	{ buf_43_out_ap_vld sc_out sc_logic 1 outvld 7 } 
	{ buf_42_out sc_out sc_lv 8 signal 8 } 
	{ buf_42_out_ap_vld sc_out sc_logic 1 outvld 8 } 
	{ buf_41_out sc_out sc_lv 8 signal 9 } 
	{ buf_41_out_ap_vld sc_out sc_logic 1 outvld 9 } 
	{ buf_40_out sc_out sc_lv 8 signal 10 } 
	{ buf_40_out_ap_vld sc_out sc_logic 1 outvld 10 } 
	{ buf_39_out sc_out sc_lv 8 signal 11 } 
	{ buf_39_out_ap_vld sc_out sc_logic 1 outvld 11 } 
	{ buf_38_out sc_out sc_lv 8 signal 12 } 
	{ buf_38_out_ap_vld sc_out sc_logic 1 outvld 12 } 
	{ buf_37_out sc_out sc_lv 8 signal 13 } 
	{ buf_37_out_ap_vld sc_out sc_logic 1 outvld 13 } 
	{ buf_36_out sc_out sc_lv 8 signal 14 } 
	{ buf_36_out_ap_vld sc_out sc_logic 1 outvld 14 } 
	{ buf_35_out sc_out sc_lv 8 signal 15 } 
	{ buf_35_out_ap_vld sc_out sc_logic 1 outvld 15 } 
	{ buf_out sc_out sc_lv 8 signal 16 } 
	{ buf_out_ap_vld sc_out sc_logic 1 outvld 16 } 
	{ sum_x_out sc_out sc_lv 12 signal 17 } 
	{ sum_x_out_ap_vld sc_out sc_logic 1 outvld 17 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "s_norm2_in_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "s_norm2_in", "role": "dout" }} , 
 	{ "name": "s_norm2_in_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm2_in", "role": "empty_n" }} , 
 	{ "name": "s_norm2_in_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm2_in", "role": "read" }} , 
 	{ "name": "s_norm2_in_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "s_norm2_in", "role": "num_data_valid" }} , 
 	{ "name": "s_norm2_in_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "s_norm2_in", "role": "fifo_cap" }} , 
 	{ "name": "buf_49_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_49_out", "role": "default" }} , 
 	{ "name": "buf_49_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_49_out", "role": "ap_vld" }} , 
 	{ "name": "buf_48_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_48_out", "role": "default" }} , 
 	{ "name": "buf_48_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_48_out", "role": "ap_vld" }} , 
 	{ "name": "buf_47_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_47_out", "role": "default" }} , 
 	{ "name": "buf_47_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_47_out", "role": "ap_vld" }} , 
 	{ "name": "buf_46_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_46_out", "role": "default" }} , 
 	{ "name": "buf_46_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_46_out", "role": "ap_vld" }} , 
 	{ "name": "buf_45_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_45_out", "role": "default" }} , 
 	{ "name": "buf_45_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_45_out", "role": "ap_vld" }} , 
 	{ "name": "buf_44_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_44_out", "role": "default" }} , 
 	{ "name": "buf_44_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_44_out", "role": "ap_vld" }} , 
 	{ "name": "buf_43_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_43_out", "role": "default" }} , 
 	{ "name": "buf_43_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_43_out", "role": "ap_vld" }} , 
 	{ "name": "buf_42_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_42_out", "role": "default" }} , 
 	{ "name": "buf_42_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_42_out", "role": "ap_vld" }} , 
 	{ "name": "buf_41_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_41_out", "role": "default" }} , 
 	{ "name": "buf_41_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_41_out", "role": "ap_vld" }} , 
 	{ "name": "buf_40_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_40_out", "role": "default" }} , 
 	{ "name": "buf_40_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_40_out", "role": "ap_vld" }} , 
 	{ "name": "buf_39_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_39_out", "role": "default" }} , 
 	{ "name": "buf_39_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_39_out", "role": "ap_vld" }} , 
 	{ "name": "buf_38_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_38_out", "role": "default" }} , 
 	{ "name": "buf_38_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_38_out", "role": "ap_vld" }} , 
 	{ "name": "buf_37_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_37_out", "role": "default" }} , 
 	{ "name": "buf_37_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_37_out", "role": "ap_vld" }} , 
 	{ "name": "buf_36_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_36_out", "role": "default" }} , 
 	{ "name": "buf_36_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_36_out", "role": "ap_vld" }} , 
 	{ "name": "buf_35_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_35_out", "role": "default" }} , 
 	{ "name": "buf_35_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_35_out", "role": "ap_vld" }} , 
 	{ "name": "buf_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_out", "role": "default" }} , 
 	{ "name": "buf_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_out", "role": "ap_vld" }} , 
 	{ "name": "sum_x_out", "direction": "out", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "sum_x_out", "role": "default" }} , 
 	{ "name": "sum_x_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "sum_x_out", "role": "ap_vld" }}  ]}

set ArgLastReadFirstWriteLatency {
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
		sum_x_out {Type O LastRead -1 FirstWrite 0}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "10", "Max" : "10"}
	, {"Name" : "Interval", "Min" : "9", "Max" : "9"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	s_norm2_in { ap_fifo {  { s_norm2_in_dout fifo_data_out 0 16 }  { s_norm2_in_empty_n fifo_status_empty 0 1 }  { s_norm2_in_read fifo_data_in 1 1 }  { s_norm2_in_num_data_valid fifo_update 0 3 }  { s_norm2_in_fifo_cap fifo_data 0 3 } } }
	buf_49_out { ap_vld {  { buf_49_out out_data 1 8 }  { buf_49_out_ap_vld out_vld 1 1 } } }
	buf_48_out { ap_vld {  { buf_48_out out_data 1 8 }  { buf_48_out_ap_vld out_vld 1 1 } } }
	buf_47_out { ap_vld {  { buf_47_out out_data 1 8 }  { buf_47_out_ap_vld out_vld 1 1 } } }
	buf_46_out { ap_vld {  { buf_46_out out_data 1 8 }  { buf_46_out_ap_vld out_vld 1 1 } } }
	buf_45_out { ap_vld {  { buf_45_out out_data 1 8 }  { buf_45_out_ap_vld out_vld 1 1 } } }
	buf_44_out { ap_vld {  { buf_44_out out_data 1 8 }  { buf_44_out_ap_vld out_vld 1 1 } } }
	buf_43_out { ap_vld {  { buf_43_out out_data 1 8 }  { buf_43_out_ap_vld out_vld 1 1 } } }
	buf_42_out { ap_vld {  { buf_42_out out_data 1 8 }  { buf_42_out_ap_vld out_vld 1 1 } } }
	buf_41_out { ap_vld {  { buf_41_out out_data 1 8 }  { buf_41_out_ap_vld out_vld 1 1 } } }
	buf_40_out { ap_vld {  { buf_40_out out_data 1 8 }  { buf_40_out_ap_vld out_vld 1 1 } } }
	buf_39_out { ap_vld {  { buf_39_out out_data 1 8 }  { buf_39_out_ap_vld out_vld 1 1 } } }
	buf_38_out { ap_vld {  { buf_38_out out_data 1 8 }  { buf_38_out_ap_vld out_vld 1 1 } } }
	buf_37_out { ap_vld {  { buf_37_out out_data 1 8 }  { buf_37_out_ap_vld out_vld 1 1 } } }
	buf_36_out { ap_vld {  { buf_36_out out_data 1 8 }  { buf_36_out_ap_vld out_vld 1 1 } } }
	buf_35_out { ap_vld {  { buf_35_out out_data 1 8 }  { buf_35_out_ap_vld out_vld 1 1 } } }
	buf_out { ap_vld {  { buf_out out_data 1 8 }  { buf_out_ap_vld out_vld 1 1 } } }
	sum_x_out { ap_vld {  { sum_x_out out_data 1 12 }  { sum_x_out_ap_vld out_vld 1 1 } } }
}
