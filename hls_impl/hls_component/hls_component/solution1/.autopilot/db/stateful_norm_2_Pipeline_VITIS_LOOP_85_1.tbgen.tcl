set moduleName stateful_norm_2_Pipeline_VITIS_LOOP_85_1
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
set C_modelName {stateful_norm.2_Pipeline_VITIS_LOOP_85_1}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ s_norm1_in int 16 regular {fifo 0 volatile }  }
	{ buf_16_out int 8 regular {pointer 1}  }
	{ buf_15_out int 8 regular {pointer 1}  }
	{ buf_14_out int 8 regular {pointer 1}  }
	{ buf_13_out int 8 regular {pointer 1}  }
	{ buf_12_out int 8 regular {pointer 1}  }
	{ buf_11_out int 8 regular {pointer 1}  }
	{ buf_10_out int 8 regular {pointer 1}  }
	{ buf_9_out int 8 regular {pointer 1}  }
	{ buf_8_out int 8 regular {pointer 1}  }
	{ buf_7_out int 8 regular {pointer 1}  }
	{ buf_6_out int 8 regular {pointer 1}  }
	{ buf_5_out int 8 regular {pointer 1}  }
	{ buf_4_out int 8 regular {pointer 1}  }
	{ buf_3_out int 8 regular {pointer 1}  }
	{ buf_2_out int 8 regular {pointer 1}  }
	{ buf_out int 8 regular {pointer 1}  }
	{ sum_x_out int 12 regular {pointer 1}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "s_norm1_in", "interface" : "fifo", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "buf_16_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_15_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_14_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_13_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_12_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_11_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_10_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_9_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_8_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_7_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_6_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_5_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_4_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_3_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "buf_2_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
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
	{ s_norm1_in_dout sc_in sc_lv 16 signal 0 } 
	{ s_norm1_in_empty_n sc_in sc_logic 1 signal 0 } 
	{ s_norm1_in_read sc_out sc_logic 1 signal 0 } 
	{ s_norm1_in_num_data_valid sc_in sc_lv 3 signal 0 } 
	{ s_norm1_in_fifo_cap sc_in sc_lv 3 signal 0 } 
	{ buf_16_out sc_out sc_lv 8 signal 1 } 
	{ buf_16_out_ap_vld sc_out sc_logic 1 outvld 1 } 
	{ buf_15_out sc_out sc_lv 8 signal 2 } 
	{ buf_15_out_ap_vld sc_out sc_logic 1 outvld 2 } 
	{ buf_14_out sc_out sc_lv 8 signal 3 } 
	{ buf_14_out_ap_vld sc_out sc_logic 1 outvld 3 } 
	{ buf_13_out sc_out sc_lv 8 signal 4 } 
	{ buf_13_out_ap_vld sc_out sc_logic 1 outvld 4 } 
	{ buf_12_out sc_out sc_lv 8 signal 5 } 
	{ buf_12_out_ap_vld sc_out sc_logic 1 outvld 5 } 
	{ buf_11_out sc_out sc_lv 8 signal 6 } 
	{ buf_11_out_ap_vld sc_out sc_logic 1 outvld 6 } 
	{ buf_10_out sc_out sc_lv 8 signal 7 } 
	{ buf_10_out_ap_vld sc_out sc_logic 1 outvld 7 } 
	{ buf_9_out sc_out sc_lv 8 signal 8 } 
	{ buf_9_out_ap_vld sc_out sc_logic 1 outvld 8 } 
	{ buf_8_out sc_out sc_lv 8 signal 9 } 
	{ buf_8_out_ap_vld sc_out sc_logic 1 outvld 9 } 
	{ buf_7_out sc_out sc_lv 8 signal 10 } 
	{ buf_7_out_ap_vld sc_out sc_logic 1 outvld 10 } 
	{ buf_6_out sc_out sc_lv 8 signal 11 } 
	{ buf_6_out_ap_vld sc_out sc_logic 1 outvld 11 } 
	{ buf_5_out sc_out sc_lv 8 signal 12 } 
	{ buf_5_out_ap_vld sc_out sc_logic 1 outvld 12 } 
	{ buf_4_out sc_out sc_lv 8 signal 13 } 
	{ buf_4_out_ap_vld sc_out sc_logic 1 outvld 13 } 
	{ buf_3_out sc_out sc_lv 8 signal 14 } 
	{ buf_3_out_ap_vld sc_out sc_logic 1 outvld 14 } 
	{ buf_2_out sc_out sc_lv 8 signal 15 } 
	{ buf_2_out_ap_vld sc_out sc_logic 1 outvld 15 } 
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
 	{ "name": "s_norm1_in_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "s_norm1_in", "role": "dout" }} , 
 	{ "name": "s_norm1_in_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm1_in", "role": "empty_n" }} , 
 	{ "name": "s_norm1_in_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_norm1_in", "role": "read" }} , 
 	{ "name": "s_norm1_in_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "s_norm1_in", "role": "num_data_valid" }} , 
 	{ "name": "s_norm1_in_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "s_norm1_in", "role": "fifo_cap" }} , 
 	{ "name": "buf_16_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_16_out", "role": "default" }} , 
 	{ "name": "buf_16_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_16_out", "role": "ap_vld" }} , 
 	{ "name": "buf_15_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_15_out", "role": "default" }} , 
 	{ "name": "buf_15_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_15_out", "role": "ap_vld" }} , 
 	{ "name": "buf_14_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_14_out", "role": "default" }} , 
 	{ "name": "buf_14_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_14_out", "role": "ap_vld" }} , 
 	{ "name": "buf_13_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_13_out", "role": "default" }} , 
 	{ "name": "buf_13_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_13_out", "role": "ap_vld" }} , 
 	{ "name": "buf_12_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_12_out", "role": "default" }} , 
 	{ "name": "buf_12_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_12_out", "role": "ap_vld" }} , 
 	{ "name": "buf_11_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_11_out", "role": "default" }} , 
 	{ "name": "buf_11_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_11_out", "role": "ap_vld" }} , 
 	{ "name": "buf_10_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_10_out", "role": "default" }} , 
 	{ "name": "buf_10_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_10_out", "role": "ap_vld" }} , 
 	{ "name": "buf_9_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_9_out", "role": "default" }} , 
 	{ "name": "buf_9_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_9_out", "role": "ap_vld" }} , 
 	{ "name": "buf_8_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_8_out", "role": "default" }} , 
 	{ "name": "buf_8_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_8_out", "role": "ap_vld" }} , 
 	{ "name": "buf_7_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_7_out", "role": "default" }} , 
 	{ "name": "buf_7_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_7_out", "role": "ap_vld" }} , 
 	{ "name": "buf_6_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_6_out", "role": "default" }} , 
 	{ "name": "buf_6_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_6_out", "role": "ap_vld" }} , 
 	{ "name": "buf_5_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_5_out", "role": "default" }} , 
 	{ "name": "buf_5_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_5_out", "role": "ap_vld" }} , 
 	{ "name": "buf_4_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_4_out", "role": "default" }} , 
 	{ "name": "buf_4_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_4_out", "role": "ap_vld" }} , 
 	{ "name": "buf_3_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_3_out", "role": "default" }} , 
 	{ "name": "buf_3_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_3_out", "role": "ap_vld" }} , 
 	{ "name": "buf_2_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_2_out", "role": "default" }} , 
 	{ "name": "buf_2_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_2_out", "role": "ap_vld" }} , 
 	{ "name": "buf_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "buf_out", "role": "default" }} , 
 	{ "name": "buf_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "buf_out", "role": "ap_vld" }} , 
 	{ "name": "sum_x_out", "direction": "out", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "sum_x_out", "role": "default" }} , 
 	{ "name": "sum_x_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "sum_x_out", "role": "ap_vld" }}  ]}

set ArgLastReadFirstWriteLatency {
	stateful_norm_2_Pipeline_VITIS_LOOP_85_1 {
		s_norm1_in {Type I LastRead 1 FirstWrite -1}
		buf_16_out {Type O LastRead -1 FirstWrite 1}
		buf_15_out {Type O LastRead -1 FirstWrite 1}
		buf_14_out {Type O LastRead -1 FirstWrite 1}
		buf_13_out {Type O LastRead -1 FirstWrite 1}
		buf_12_out {Type O LastRead -1 FirstWrite 1}
		buf_11_out {Type O LastRead -1 FirstWrite 1}
		buf_10_out {Type O LastRead -1 FirstWrite 1}
		buf_9_out {Type O LastRead -1 FirstWrite 1}
		buf_8_out {Type O LastRead -1 FirstWrite 1}
		buf_7_out {Type O LastRead -1 FirstWrite 1}
		buf_6_out {Type O LastRead -1 FirstWrite 1}
		buf_5_out {Type O LastRead -1 FirstWrite 1}
		buf_4_out {Type O LastRead -1 FirstWrite 1}
		buf_3_out {Type O LastRead -1 FirstWrite 1}
		buf_2_out {Type O LastRead -1 FirstWrite 1}
		buf_out {Type O LastRead -1 FirstWrite 1}
		sum_x_out {Type O LastRead -1 FirstWrite 1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "11", "Max" : "11"}
	, {"Name" : "Interval", "Min" : "9", "Max" : "9"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	s_norm1_in { ap_fifo {  { s_norm1_in_dout fifo_data_out 0 16 }  { s_norm1_in_empty_n fifo_status_empty 0 1 }  { s_norm1_in_read fifo_data_in 1 1 }  { s_norm1_in_num_data_valid fifo_update 0 3 }  { s_norm1_in_fifo_cap fifo_data 0 3 } } }
	buf_16_out { ap_vld {  { buf_16_out out_data 1 8 }  { buf_16_out_ap_vld out_vld 1 1 } } }
	buf_15_out { ap_vld {  { buf_15_out out_data 1 8 }  { buf_15_out_ap_vld out_vld 1 1 } } }
	buf_14_out { ap_vld {  { buf_14_out out_data 1 8 }  { buf_14_out_ap_vld out_vld 1 1 } } }
	buf_13_out { ap_vld {  { buf_13_out out_data 1 8 }  { buf_13_out_ap_vld out_vld 1 1 } } }
	buf_12_out { ap_vld {  { buf_12_out out_data 1 8 }  { buf_12_out_ap_vld out_vld 1 1 } } }
	buf_11_out { ap_vld {  { buf_11_out out_data 1 8 }  { buf_11_out_ap_vld out_vld 1 1 } } }
	buf_10_out { ap_vld {  { buf_10_out out_data 1 8 }  { buf_10_out_ap_vld out_vld 1 1 } } }
	buf_9_out { ap_vld {  { buf_9_out out_data 1 8 }  { buf_9_out_ap_vld out_vld 1 1 } } }
	buf_8_out { ap_vld {  { buf_8_out out_data 1 8 }  { buf_8_out_ap_vld out_vld 1 1 } } }
	buf_7_out { ap_vld {  { buf_7_out out_data 1 8 }  { buf_7_out_ap_vld out_vld 1 1 } } }
	buf_6_out { ap_vld {  { buf_6_out out_data 1 8 }  { buf_6_out_ap_vld out_vld 1 1 } } }
	buf_5_out { ap_vld {  { buf_5_out out_data 1 8 }  { buf_5_out_ap_vld out_vld 1 1 } } }
	buf_4_out { ap_vld {  { buf_4_out out_data 1 8 }  { buf_4_out_ap_vld out_vld 1 1 } } }
	buf_3_out { ap_vld {  { buf_3_out out_data 1 8 }  { buf_3_out_ap_vld out_vld 1 1 } } }
	buf_2_out { ap_vld {  { buf_2_out out_data 1 8 }  { buf_2_out_ap_vld out_vld 1 1 } } }
	buf_out { ap_vld {  { buf_out out_data 1 8 }  { buf_out_ap_vld out_vld 1 1 } } }
	sum_x_out { ap_vld {  { sum_x_out out_data 1 12 }  { sum_x_out_ap_vld out_vld 1 1 } } }
}
