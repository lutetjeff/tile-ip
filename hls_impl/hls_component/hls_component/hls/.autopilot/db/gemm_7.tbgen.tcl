set moduleName gemm_7
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
set C_modelName {gemm.7}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
dict set ap_memory_interface_dict w4_0 { MEM_WIDTH 8 MEM_SIZE 16 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE BYTE_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict w4_1 { MEM_WIDTH 8 MEM_SIZE 16 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE BYTE_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict w4_2 { MEM_WIDTH 8 MEM_SIZE 16 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE BYTE_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict w4_3 { MEM_WIDTH 8 MEM_SIZE 16 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE BYTE_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict w4_4 { MEM_WIDTH 8 MEM_SIZE 16 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE BYTE_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict w4_5 { MEM_WIDTH 8 MEM_SIZE 16 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE BYTE_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict w4_6 { MEM_WIDTH 8 MEM_SIZE 16 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE BYTE_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict w4_7 { MEM_WIDTH 8 MEM_SIZE 16 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE BYTE_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict w4_8 { MEM_WIDTH 8 MEM_SIZE 16 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE BYTE_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict w4_9 { MEM_WIDTH 8 MEM_SIZE 16 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE BYTE_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict w4_10 { MEM_WIDTH 8 MEM_SIZE 16 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE BYTE_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict w4_11 { MEM_WIDTH 8 MEM_SIZE 16 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE BYTE_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict w4_12 { MEM_WIDTH 8 MEM_SIZE 16 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE BYTE_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict w4_13 { MEM_WIDTH 8 MEM_SIZE 16 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE BYTE_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict w4_14 { MEM_WIDTH 8 MEM_SIZE 16 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE BYTE_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict w4_15 { MEM_WIDTH 8 MEM_SIZE 16 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE BYTE_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
set C_modelArgList {
	{ s_relu_out int 16 regular {fifo 0 volatile }  }
	{ s_gemm4_out int 16 regular {fifo 1 volatile }  }
	{ w4_0 int 8 regular {bram 16 { 1 1 } 1 1 }  }
	{ w4_1 int 8 regular {bram 16 { 1 1 } 1 1 }  }
	{ w4_2 int 8 regular {bram 16 { 1 1 } 1 1 }  }
	{ w4_3 int 8 regular {bram 16 { 1 1 } 1 1 }  }
	{ w4_4 int 8 regular {bram 16 { 1 1 } 1 1 }  }
	{ w4_5 int 8 regular {bram 16 { 1 1 } 1 1 }  }
	{ w4_6 int 8 regular {bram 16 { 1 1 } 1 1 }  }
	{ w4_7 int 8 regular {bram 16 { 1 1 } 1 1 }  }
	{ w4_8 int 8 regular {bram 16 { 1 1 } 1 1 }  }
	{ w4_9 int 8 regular {bram 16 { 1 1 } 1 1 }  }
	{ w4_10 int 8 regular {bram 16 { 1 1 } 1 1 }  }
	{ w4_11 int 8 regular {bram 16 { 1 1 } 1 1 }  }
	{ w4_12 int 8 regular {bram 16 { 1 1 } 1 1 }  }
	{ w4_13 int 8 regular {bram 16 { 1 1 } 1 1 }  }
	{ w4_14 int 8 regular {bram 16 { 1 1 } 1 1 }  }
	{ w4_15 int 8 regular {bram 16 { 1 1 } 1 1 }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "s_relu_out", "interface" : "fifo", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "s_gemm4_out", "interface" : "fifo", "bitwidth" : 16, "direction" : "WRITEONLY"} , 
 	{ "Name" : "w4_0", "interface" : "bram", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_1", "interface" : "bram", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_2", "interface" : "bram", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_3", "interface" : "bram", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_4", "interface" : "bram", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_5", "interface" : "bram", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_6", "interface" : "bram", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_7", "interface" : "bram", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_8", "interface" : "bram", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_9", "interface" : "bram", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_10", "interface" : "bram", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_11", "interface" : "bram", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_12", "interface" : "bram", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_13", "interface" : "bram", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_14", "interface" : "bram", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_15", "interface" : "bram", "bitwidth" : 8, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 180
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ start_full_n sc_in sc_logic 1 signal -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ start_out sc_out sc_logic 1 signal -1 } 
	{ start_write sc_out sc_logic 1 signal -1 } 
	{ s_relu_out_dout sc_in sc_lv 16 signal 0 } 
	{ s_relu_out_empty_n sc_in sc_logic 1 signal 0 } 
	{ s_relu_out_read sc_out sc_logic 1 signal 0 } 
	{ s_relu_out_num_data_valid sc_in sc_lv 3 signal 0 } 
	{ s_relu_out_fifo_cap sc_in sc_lv 3 signal 0 } 
	{ s_gemm4_out_din sc_out sc_lv 16 signal 1 } 
	{ s_gemm4_out_full_n sc_in sc_logic 1 signal 1 } 
	{ s_gemm4_out_write sc_out sc_logic 1 signal 1 } 
	{ s_gemm4_out_num_data_valid sc_in sc_lv 32 signal 1 } 
	{ s_gemm4_out_fifo_cap sc_in sc_lv 32 signal 1 } 
	{ w4_0_Addr_A sc_out sc_lv 32 signal 2 } 
	{ w4_0_EN_A sc_out sc_logic 1 signal 2 } 
	{ w4_0_WEN_A sc_out sc_lv 1 signal 2 } 
	{ w4_0_Din_A sc_out sc_lv 8 signal 2 } 
	{ w4_0_Dout_A sc_in sc_lv 8 signal 2 } 
	{ w4_0_Addr_B sc_out sc_lv 32 signal 2 } 
	{ w4_0_EN_B sc_out sc_logic 1 signal 2 } 
	{ w4_0_WEN_B sc_out sc_lv 1 signal 2 } 
	{ w4_0_Din_B sc_out sc_lv 8 signal 2 } 
	{ w4_0_Dout_B sc_in sc_lv 8 signal 2 } 
	{ w4_1_Addr_A sc_out sc_lv 32 signal 3 } 
	{ w4_1_EN_A sc_out sc_logic 1 signal 3 } 
	{ w4_1_WEN_A sc_out sc_lv 1 signal 3 } 
	{ w4_1_Din_A sc_out sc_lv 8 signal 3 } 
	{ w4_1_Dout_A sc_in sc_lv 8 signal 3 } 
	{ w4_1_Addr_B sc_out sc_lv 32 signal 3 } 
	{ w4_1_EN_B sc_out sc_logic 1 signal 3 } 
	{ w4_1_WEN_B sc_out sc_lv 1 signal 3 } 
	{ w4_1_Din_B sc_out sc_lv 8 signal 3 } 
	{ w4_1_Dout_B sc_in sc_lv 8 signal 3 } 
	{ w4_2_Addr_A sc_out sc_lv 32 signal 4 } 
	{ w4_2_EN_A sc_out sc_logic 1 signal 4 } 
	{ w4_2_WEN_A sc_out sc_lv 1 signal 4 } 
	{ w4_2_Din_A sc_out sc_lv 8 signal 4 } 
	{ w4_2_Dout_A sc_in sc_lv 8 signal 4 } 
	{ w4_2_Addr_B sc_out sc_lv 32 signal 4 } 
	{ w4_2_EN_B sc_out sc_logic 1 signal 4 } 
	{ w4_2_WEN_B sc_out sc_lv 1 signal 4 } 
	{ w4_2_Din_B sc_out sc_lv 8 signal 4 } 
	{ w4_2_Dout_B sc_in sc_lv 8 signal 4 } 
	{ w4_3_Addr_A sc_out sc_lv 32 signal 5 } 
	{ w4_3_EN_A sc_out sc_logic 1 signal 5 } 
	{ w4_3_WEN_A sc_out sc_lv 1 signal 5 } 
	{ w4_3_Din_A sc_out sc_lv 8 signal 5 } 
	{ w4_3_Dout_A sc_in sc_lv 8 signal 5 } 
	{ w4_3_Addr_B sc_out sc_lv 32 signal 5 } 
	{ w4_3_EN_B sc_out sc_logic 1 signal 5 } 
	{ w4_3_WEN_B sc_out sc_lv 1 signal 5 } 
	{ w4_3_Din_B sc_out sc_lv 8 signal 5 } 
	{ w4_3_Dout_B sc_in sc_lv 8 signal 5 } 
	{ w4_4_Addr_A sc_out sc_lv 32 signal 6 } 
	{ w4_4_EN_A sc_out sc_logic 1 signal 6 } 
	{ w4_4_WEN_A sc_out sc_lv 1 signal 6 } 
	{ w4_4_Din_A sc_out sc_lv 8 signal 6 } 
	{ w4_4_Dout_A sc_in sc_lv 8 signal 6 } 
	{ w4_4_Addr_B sc_out sc_lv 32 signal 6 } 
	{ w4_4_EN_B sc_out sc_logic 1 signal 6 } 
	{ w4_4_WEN_B sc_out sc_lv 1 signal 6 } 
	{ w4_4_Din_B sc_out sc_lv 8 signal 6 } 
	{ w4_4_Dout_B sc_in sc_lv 8 signal 6 } 
	{ w4_5_Addr_A sc_out sc_lv 32 signal 7 } 
	{ w4_5_EN_A sc_out sc_logic 1 signal 7 } 
	{ w4_5_WEN_A sc_out sc_lv 1 signal 7 } 
	{ w4_5_Din_A sc_out sc_lv 8 signal 7 } 
	{ w4_5_Dout_A sc_in sc_lv 8 signal 7 } 
	{ w4_5_Addr_B sc_out sc_lv 32 signal 7 } 
	{ w4_5_EN_B sc_out sc_logic 1 signal 7 } 
	{ w4_5_WEN_B sc_out sc_lv 1 signal 7 } 
	{ w4_5_Din_B sc_out sc_lv 8 signal 7 } 
	{ w4_5_Dout_B sc_in sc_lv 8 signal 7 } 
	{ w4_6_Addr_A sc_out sc_lv 32 signal 8 } 
	{ w4_6_EN_A sc_out sc_logic 1 signal 8 } 
	{ w4_6_WEN_A sc_out sc_lv 1 signal 8 } 
	{ w4_6_Din_A sc_out sc_lv 8 signal 8 } 
	{ w4_6_Dout_A sc_in sc_lv 8 signal 8 } 
	{ w4_6_Addr_B sc_out sc_lv 32 signal 8 } 
	{ w4_6_EN_B sc_out sc_logic 1 signal 8 } 
	{ w4_6_WEN_B sc_out sc_lv 1 signal 8 } 
	{ w4_6_Din_B sc_out sc_lv 8 signal 8 } 
	{ w4_6_Dout_B sc_in sc_lv 8 signal 8 } 
	{ w4_7_Addr_A sc_out sc_lv 32 signal 9 } 
	{ w4_7_EN_A sc_out sc_logic 1 signal 9 } 
	{ w4_7_WEN_A sc_out sc_lv 1 signal 9 } 
	{ w4_7_Din_A sc_out sc_lv 8 signal 9 } 
	{ w4_7_Dout_A sc_in sc_lv 8 signal 9 } 
	{ w4_7_Addr_B sc_out sc_lv 32 signal 9 } 
	{ w4_7_EN_B sc_out sc_logic 1 signal 9 } 
	{ w4_7_WEN_B sc_out sc_lv 1 signal 9 } 
	{ w4_7_Din_B sc_out sc_lv 8 signal 9 } 
	{ w4_7_Dout_B sc_in sc_lv 8 signal 9 } 
	{ w4_8_Addr_A sc_out sc_lv 32 signal 10 } 
	{ w4_8_EN_A sc_out sc_logic 1 signal 10 } 
	{ w4_8_WEN_A sc_out sc_lv 1 signal 10 } 
	{ w4_8_Din_A sc_out sc_lv 8 signal 10 } 
	{ w4_8_Dout_A sc_in sc_lv 8 signal 10 } 
	{ w4_8_Addr_B sc_out sc_lv 32 signal 10 } 
	{ w4_8_EN_B sc_out sc_logic 1 signal 10 } 
	{ w4_8_WEN_B sc_out sc_lv 1 signal 10 } 
	{ w4_8_Din_B sc_out sc_lv 8 signal 10 } 
	{ w4_8_Dout_B sc_in sc_lv 8 signal 10 } 
	{ w4_9_Addr_A sc_out sc_lv 32 signal 11 } 
	{ w4_9_EN_A sc_out sc_logic 1 signal 11 } 
	{ w4_9_WEN_A sc_out sc_lv 1 signal 11 } 
	{ w4_9_Din_A sc_out sc_lv 8 signal 11 } 
	{ w4_9_Dout_A sc_in sc_lv 8 signal 11 } 
	{ w4_9_Addr_B sc_out sc_lv 32 signal 11 } 
	{ w4_9_EN_B sc_out sc_logic 1 signal 11 } 
	{ w4_9_WEN_B sc_out sc_lv 1 signal 11 } 
	{ w4_9_Din_B sc_out sc_lv 8 signal 11 } 
	{ w4_9_Dout_B sc_in sc_lv 8 signal 11 } 
	{ w4_10_Addr_A sc_out sc_lv 32 signal 12 } 
	{ w4_10_EN_A sc_out sc_logic 1 signal 12 } 
	{ w4_10_WEN_A sc_out sc_lv 1 signal 12 } 
	{ w4_10_Din_A sc_out sc_lv 8 signal 12 } 
	{ w4_10_Dout_A sc_in sc_lv 8 signal 12 } 
	{ w4_10_Addr_B sc_out sc_lv 32 signal 12 } 
	{ w4_10_EN_B sc_out sc_logic 1 signal 12 } 
	{ w4_10_WEN_B sc_out sc_lv 1 signal 12 } 
	{ w4_10_Din_B sc_out sc_lv 8 signal 12 } 
	{ w4_10_Dout_B sc_in sc_lv 8 signal 12 } 
	{ w4_11_Addr_A sc_out sc_lv 32 signal 13 } 
	{ w4_11_EN_A sc_out sc_logic 1 signal 13 } 
	{ w4_11_WEN_A sc_out sc_lv 1 signal 13 } 
	{ w4_11_Din_A sc_out sc_lv 8 signal 13 } 
	{ w4_11_Dout_A sc_in sc_lv 8 signal 13 } 
	{ w4_11_Addr_B sc_out sc_lv 32 signal 13 } 
	{ w4_11_EN_B sc_out sc_logic 1 signal 13 } 
	{ w4_11_WEN_B sc_out sc_lv 1 signal 13 } 
	{ w4_11_Din_B sc_out sc_lv 8 signal 13 } 
	{ w4_11_Dout_B sc_in sc_lv 8 signal 13 } 
	{ w4_12_Addr_A sc_out sc_lv 32 signal 14 } 
	{ w4_12_EN_A sc_out sc_logic 1 signal 14 } 
	{ w4_12_WEN_A sc_out sc_lv 1 signal 14 } 
	{ w4_12_Din_A sc_out sc_lv 8 signal 14 } 
	{ w4_12_Dout_A sc_in sc_lv 8 signal 14 } 
	{ w4_12_Addr_B sc_out sc_lv 32 signal 14 } 
	{ w4_12_EN_B sc_out sc_logic 1 signal 14 } 
	{ w4_12_WEN_B sc_out sc_lv 1 signal 14 } 
	{ w4_12_Din_B sc_out sc_lv 8 signal 14 } 
	{ w4_12_Dout_B sc_in sc_lv 8 signal 14 } 
	{ w4_13_Addr_A sc_out sc_lv 32 signal 15 } 
	{ w4_13_EN_A sc_out sc_logic 1 signal 15 } 
	{ w4_13_WEN_A sc_out sc_lv 1 signal 15 } 
	{ w4_13_Din_A sc_out sc_lv 8 signal 15 } 
	{ w4_13_Dout_A sc_in sc_lv 8 signal 15 } 
	{ w4_13_Addr_B sc_out sc_lv 32 signal 15 } 
	{ w4_13_EN_B sc_out sc_logic 1 signal 15 } 
	{ w4_13_WEN_B sc_out sc_lv 1 signal 15 } 
	{ w4_13_Din_B sc_out sc_lv 8 signal 15 } 
	{ w4_13_Dout_B sc_in sc_lv 8 signal 15 } 
	{ w4_14_Addr_A sc_out sc_lv 32 signal 16 } 
	{ w4_14_EN_A sc_out sc_logic 1 signal 16 } 
	{ w4_14_WEN_A sc_out sc_lv 1 signal 16 } 
	{ w4_14_Din_A sc_out sc_lv 8 signal 16 } 
	{ w4_14_Dout_A sc_in sc_lv 8 signal 16 } 
	{ w4_14_Addr_B sc_out sc_lv 32 signal 16 } 
	{ w4_14_EN_B sc_out sc_logic 1 signal 16 } 
	{ w4_14_WEN_B sc_out sc_lv 1 signal 16 } 
	{ w4_14_Din_B sc_out sc_lv 8 signal 16 } 
	{ w4_14_Dout_B sc_in sc_lv 8 signal 16 } 
	{ w4_15_Addr_A sc_out sc_lv 32 signal 17 } 
	{ w4_15_EN_A sc_out sc_logic 1 signal 17 } 
	{ w4_15_WEN_A sc_out sc_lv 1 signal 17 } 
	{ w4_15_Din_A sc_out sc_lv 8 signal 17 } 
	{ w4_15_Dout_A sc_in sc_lv 8 signal 17 } 
	{ w4_15_Addr_B sc_out sc_lv 32 signal 17 } 
	{ w4_15_EN_B sc_out sc_logic 1 signal 17 } 
	{ w4_15_WEN_B sc_out sc_lv 1 signal 17 } 
	{ w4_15_Din_B sc_out sc_lv 8 signal 17 } 
	{ w4_15_Dout_B sc_in sc_lv 8 signal 17 } 
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
 	{ "name": "start_out", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_out", "role": "default" }} , 
 	{ "name": "start_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_write", "role": "default" }} , 
 	{ "name": "s_relu_out_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "s_relu_out", "role": "dout" }} , 
 	{ "name": "s_relu_out_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_relu_out", "role": "empty_n" }} , 
 	{ "name": "s_relu_out_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_relu_out", "role": "read" }} , 
 	{ "name": "s_relu_out_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "s_relu_out", "role": "num_data_valid" }} , 
 	{ "name": "s_relu_out_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "s_relu_out", "role": "fifo_cap" }} , 
 	{ "name": "s_gemm4_out_din", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "s_gemm4_out", "role": "din" }} , 
 	{ "name": "s_gemm4_out_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_gemm4_out", "role": "full_n" }} , 
 	{ "name": "s_gemm4_out_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_gemm4_out", "role": "write" }} , 
 	{ "name": "s_gemm4_out_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_gemm4_out", "role": "num_data_valid" }} , 
 	{ "name": "s_gemm4_out_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_gemm4_out", "role": "fifo_cap" }} , 
 	{ "name": "w4_0_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_0", "role": "Addr_A" }} , 
 	{ "name": "w4_0_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_0", "role": "EN_A" }} , 
 	{ "name": "w4_0_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_0", "role": "WEN_A" }} , 
 	{ "name": "w4_0_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0", "role": "Din_A" }} , 
 	{ "name": "w4_0_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0", "role": "Dout_A" }} , 
 	{ "name": "w4_0_Addr_B", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_0", "role": "Addr_B" }} , 
 	{ "name": "w4_0_EN_B", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_0", "role": "EN_B" }} , 
 	{ "name": "w4_0_WEN_B", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_0", "role": "WEN_B" }} , 
 	{ "name": "w4_0_Din_B", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0", "role": "Din_B" }} , 
 	{ "name": "w4_0_Dout_B", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0", "role": "Dout_B" }} , 
 	{ "name": "w4_1_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_1", "role": "Addr_A" }} , 
 	{ "name": "w4_1_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_1", "role": "EN_A" }} , 
 	{ "name": "w4_1_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_1", "role": "WEN_A" }} , 
 	{ "name": "w4_1_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1", "role": "Din_A" }} , 
 	{ "name": "w4_1_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1", "role": "Dout_A" }} , 
 	{ "name": "w4_1_Addr_B", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_1", "role": "Addr_B" }} , 
 	{ "name": "w4_1_EN_B", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_1", "role": "EN_B" }} , 
 	{ "name": "w4_1_WEN_B", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_1", "role": "WEN_B" }} , 
 	{ "name": "w4_1_Din_B", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1", "role": "Din_B" }} , 
 	{ "name": "w4_1_Dout_B", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1", "role": "Dout_B" }} , 
 	{ "name": "w4_2_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_2", "role": "Addr_A" }} , 
 	{ "name": "w4_2_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_2", "role": "EN_A" }} , 
 	{ "name": "w4_2_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_2", "role": "WEN_A" }} , 
 	{ "name": "w4_2_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2", "role": "Din_A" }} , 
 	{ "name": "w4_2_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2", "role": "Dout_A" }} , 
 	{ "name": "w4_2_Addr_B", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_2", "role": "Addr_B" }} , 
 	{ "name": "w4_2_EN_B", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_2", "role": "EN_B" }} , 
 	{ "name": "w4_2_WEN_B", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_2", "role": "WEN_B" }} , 
 	{ "name": "w4_2_Din_B", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2", "role": "Din_B" }} , 
 	{ "name": "w4_2_Dout_B", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2", "role": "Dout_B" }} , 
 	{ "name": "w4_3_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_3", "role": "Addr_A" }} , 
 	{ "name": "w4_3_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_3", "role": "EN_A" }} , 
 	{ "name": "w4_3_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_3", "role": "WEN_A" }} , 
 	{ "name": "w4_3_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3", "role": "Din_A" }} , 
 	{ "name": "w4_3_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3", "role": "Dout_A" }} , 
 	{ "name": "w4_3_Addr_B", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_3", "role": "Addr_B" }} , 
 	{ "name": "w4_3_EN_B", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_3", "role": "EN_B" }} , 
 	{ "name": "w4_3_WEN_B", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_3", "role": "WEN_B" }} , 
 	{ "name": "w4_3_Din_B", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3", "role": "Din_B" }} , 
 	{ "name": "w4_3_Dout_B", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3", "role": "Dout_B" }} , 
 	{ "name": "w4_4_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_4", "role": "Addr_A" }} , 
 	{ "name": "w4_4_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_4", "role": "EN_A" }} , 
 	{ "name": "w4_4_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_4", "role": "WEN_A" }} , 
 	{ "name": "w4_4_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4", "role": "Din_A" }} , 
 	{ "name": "w4_4_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4", "role": "Dout_A" }} , 
 	{ "name": "w4_4_Addr_B", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_4", "role": "Addr_B" }} , 
 	{ "name": "w4_4_EN_B", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_4", "role": "EN_B" }} , 
 	{ "name": "w4_4_WEN_B", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_4", "role": "WEN_B" }} , 
 	{ "name": "w4_4_Din_B", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4", "role": "Din_B" }} , 
 	{ "name": "w4_4_Dout_B", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4", "role": "Dout_B" }} , 
 	{ "name": "w4_5_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_5", "role": "Addr_A" }} , 
 	{ "name": "w4_5_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_5", "role": "EN_A" }} , 
 	{ "name": "w4_5_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_5", "role": "WEN_A" }} , 
 	{ "name": "w4_5_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5", "role": "Din_A" }} , 
 	{ "name": "w4_5_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5", "role": "Dout_A" }} , 
 	{ "name": "w4_5_Addr_B", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_5", "role": "Addr_B" }} , 
 	{ "name": "w4_5_EN_B", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_5", "role": "EN_B" }} , 
 	{ "name": "w4_5_WEN_B", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_5", "role": "WEN_B" }} , 
 	{ "name": "w4_5_Din_B", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5", "role": "Din_B" }} , 
 	{ "name": "w4_5_Dout_B", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5", "role": "Dout_B" }} , 
 	{ "name": "w4_6_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_6", "role": "Addr_A" }} , 
 	{ "name": "w4_6_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_6", "role": "EN_A" }} , 
 	{ "name": "w4_6_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_6", "role": "WEN_A" }} , 
 	{ "name": "w4_6_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6", "role": "Din_A" }} , 
 	{ "name": "w4_6_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6", "role": "Dout_A" }} , 
 	{ "name": "w4_6_Addr_B", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_6", "role": "Addr_B" }} , 
 	{ "name": "w4_6_EN_B", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_6", "role": "EN_B" }} , 
 	{ "name": "w4_6_WEN_B", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_6", "role": "WEN_B" }} , 
 	{ "name": "w4_6_Din_B", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6", "role": "Din_B" }} , 
 	{ "name": "w4_6_Dout_B", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6", "role": "Dout_B" }} , 
 	{ "name": "w4_7_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_7", "role": "Addr_A" }} , 
 	{ "name": "w4_7_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_7", "role": "EN_A" }} , 
 	{ "name": "w4_7_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_7", "role": "WEN_A" }} , 
 	{ "name": "w4_7_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7", "role": "Din_A" }} , 
 	{ "name": "w4_7_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7", "role": "Dout_A" }} , 
 	{ "name": "w4_7_Addr_B", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_7", "role": "Addr_B" }} , 
 	{ "name": "w4_7_EN_B", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_7", "role": "EN_B" }} , 
 	{ "name": "w4_7_WEN_B", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_7", "role": "WEN_B" }} , 
 	{ "name": "w4_7_Din_B", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7", "role": "Din_B" }} , 
 	{ "name": "w4_7_Dout_B", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7", "role": "Dout_B" }} , 
 	{ "name": "w4_8_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_8", "role": "Addr_A" }} , 
 	{ "name": "w4_8_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_8", "role": "EN_A" }} , 
 	{ "name": "w4_8_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_8", "role": "WEN_A" }} , 
 	{ "name": "w4_8_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8", "role": "Din_A" }} , 
 	{ "name": "w4_8_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8", "role": "Dout_A" }} , 
 	{ "name": "w4_8_Addr_B", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_8", "role": "Addr_B" }} , 
 	{ "name": "w4_8_EN_B", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_8", "role": "EN_B" }} , 
 	{ "name": "w4_8_WEN_B", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_8", "role": "WEN_B" }} , 
 	{ "name": "w4_8_Din_B", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8", "role": "Din_B" }} , 
 	{ "name": "w4_8_Dout_B", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8", "role": "Dout_B" }} , 
 	{ "name": "w4_9_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_9", "role": "Addr_A" }} , 
 	{ "name": "w4_9_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_9", "role": "EN_A" }} , 
 	{ "name": "w4_9_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_9", "role": "WEN_A" }} , 
 	{ "name": "w4_9_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9", "role": "Din_A" }} , 
 	{ "name": "w4_9_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9", "role": "Dout_A" }} , 
 	{ "name": "w4_9_Addr_B", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_9", "role": "Addr_B" }} , 
 	{ "name": "w4_9_EN_B", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_9", "role": "EN_B" }} , 
 	{ "name": "w4_9_WEN_B", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_9", "role": "WEN_B" }} , 
 	{ "name": "w4_9_Din_B", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9", "role": "Din_B" }} , 
 	{ "name": "w4_9_Dout_B", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9", "role": "Dout_B" }} , 
 	{ "name": "w4_10_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_10", "role": "Addr_A" }} , 
 	{ "name": "w4_10_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_10", "role": "EN_A" }} , 
 	{ "name": "w4_10_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_10", "role": "WEN_A" }} , 
 	{ "name": "w4_10_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10", "role": "Din_A" }} , 
 	{ "name": "w4_10_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10", "role": "Dout_A" }} , 
 	{ "name": "w4_10_Addr_B", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_10", "role": "Addr_B" }} , 
 	{ "name": "w4_10_EN_B", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_10", "role": "EN_B" }} , 
 	{ "name": "w4_10_WEN_B", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_10", "role": "WEN_B" }} , 
 	{ "name": "w4_10_Din_B", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10", "role": "Din_B" }} , 
 	{ "name": "w4_10_Dout_B", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10", "role": "Dout_B" }} , 
 	{ "name": "w4_11_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_11", "role": "Addr_A" }} , 
 	{ "name": "w4_11_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_11", "role": "EN_A" }} , 
 	{ "name": "w4_11_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_11", "role": "WEN_A" }} , 
 	{ "name": "w4_11_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11", "role": "Din_A" }} , 
 	{ "name": "w4_11_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11", "role": "Dout_A" }} , 
 	{ "name": "w4_11_Addr_B", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_11", "role": "Addr_B" }} , 
 	{ "name": "w4_11_EN_B", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_11", "role": "EN_B" }} , 
 	{ "name": "w4_11_WEN_B", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_11", "role": "WEN_B" }} , 
 	{ "name": "w4_11_Din_B", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11", "role": "Din_B" }} , 
 	{ "name": "w4_11_Dout_B", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11", "role": "Dout_B" }} , 
 	{ "name": "w4_12_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_12", "role": "Addr_A" }} , 
 	{ "name": "w4_12_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_12", "role": "EN_A" }} , 
 	{ "name": "w4_12_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_12", "role": "WEN_A" }} , 
 	{ "name": "w4_12_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12", "role": "Din_A" }} , 
 	{ "name": "w4_12_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12", "role": "Dout_A" }} , 
 	{ "name": "w4_12_Addr_B", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_12", "role": "Addr_B" }} , 
 	{ "name": "w4_12_EN_B", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_12", "role": "EN_B" }} , 
 	{ "name": "w4_12_WEN_B", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_12", "role": "WEN_B" }} , 
 	{ "name": "w4_12_Din_B", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12", "role": "Din_B" }} , 
 	{ "name": "w4_12_Dout_B", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12", "role": "Dout_B" }} , 
 	{ "name": "w4_13_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_13", "role": "Addr_A" }} , 
 	{ "name": "w4_13_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_13", "role": "EN_A" }} , 
 	{ "name": "w4_13_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_13", "role": "WEN_A" }} , 
 	{ "name": "w4_13_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13", "role": "Din_A" }} , 
 	{ "name": "w4_13_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13", "role": "Dout_A" }} , 
 	{ "name": "w4_13_Addr_B", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_13", "role": "Addr_B" }} , 
 	{ "name": "w4_13_EN_B", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_13", "role": "EN_B" }} , 
 	{ "name": "w4_13_WEN_B", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_13", "role": "WEN_B" }} , 
 	{ "name": "w4_13_Din_B", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13", "role": "Din_B" }} , 
 	{ "name": "w4_13_Dout_B", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13", "role": "Dout_B" }} , 
 	{ "name": "w4_14_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_14", "role": "Addr_A" }} , 
 	{ "name": "w4_14_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_14", "role": "EN_A" }} , 
 	{ "name": "w4_14_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_14", "role": "WEN_A" }} , 
 	{ "name": "w4_14_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14", "role": "Din_A" }} , 
 	{ "name": "w4_14_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14", "role": "Dout_A" }} , 
 	{ "name": "w4_14_Addr_B", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_14", "role": "Addr_B" }} , 
 	{ "name": "w4_14_EN_B", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_14", "role": "EN_B" }} , 
 	{ "name": "w4_14_WEN_B", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_14", "role": "WEN_B" }} , 
 	{ "name": "w4_14_Din_B", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14", "role": "Din_B" }} , 
 	{ "name": "w4_14_Dout_B", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14", "role": "Dout_B" }} , 
 	{ "name": "w4_15_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_15", "role": "Addr_A" }} , 
 	{ "name": "w4_15_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_15", "role": "EN_A" }} , 
 	{ "name": "w4_15_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_15", "role": "WEN_A" }} , 
 	{ "name": "w4_15_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15", "role": "Din_A" }} , 
 	{ "name": "w4_15_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15", "role": "Dout_A" }} , 
 	{ "name": "w4_15_Addr_B", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "w4_15", "role": "Addr_B" }} , 
 	{ "name": "w4_15_EN_B", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_15", "role": "EN_B" }} , 
 	{ "name": "w4_15_WEN_B", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "w4_15", "role": "WEN_B" }} , 
 	{ "name": "w4_15_Din_B", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15", "role": "Din_B" }} , 
 	{ "name": "w4_15_Dout_B", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15", "role": "Dout_B" }}  ]}

set ArgLastReadFirstWriteLatency {
	gemm_7 {
		s_relu_out {Type I LastRead 1 FirstWrite -1}
		s_gemm4_out {Type O LastRead -1 FirstWrite 8}
		w4_0 {Type I LastRead 8 FirstWrite -1}
		w4_1 {Type I LastRead 8 FirstWrite -1}
		w4_2 {Type I LastRead 8 FirstWrite -1}
		w4_3 {Type I LastRead 8 FirstWrite -1}
		w4_4 {Type I LastRead 8 FirstWrite -1}
		w4_5 {Type I LastRead 8 FirstWrite -1}
		w4_6 {Type I LastRead 8 FirstWrite -1}
		w4_7 {Type I LastRead 8 FirstWrite -1}
		w4_8 {Type I LastRead 8 FirstWrite -1}
		w4_9 {Type I LastRead 8 FirstWrite -1}
		w4_10 {Type I LastRead 8 FirstWrite -1}
		w4_11 {Type I LastRead 8 FirstWrite -1}
		w4_12 {Type I LastRead 8 FirstWrite -1}
		w4_13 {Type I LastRead 8 FirstWrite -1}
		w4_14 {Type I LastRead 8 FirstWrite -1}
		w4_15 {Type I LastRead 8 FirstWrite -1}}
	gemm_7_Pipeline_VITIS_LOOP_139_1 {
		s_relu_out {Type I LastRead 1 FirstWrite -1}
		p_out {Type O LastRead -1 FirstWrite 0}
		p_out1 {Type O LastRead -1 FirstWrite 0}
		p_out2 {Type O LastRead -1 FirstWrite 0}
		p_out3 {Type O LastRead -1 FirstWrite 0}
		p_out4 {Type O LastRead -1 FirstWrite 0}
		p_out5 {Type O LastRead -1 FirstWrite 0}
		p_out6 {Type O LastRead -1 FirstWrite 0}
		p_out7 {Type O LastRead -1 FirstWrite 0}
		p_out8 {Type O LastRead -1 FirstWrite 0}
		p_out9 {Type O LastRead -1 FirstWrite 0}
		p_out10 {Type O LastRead -1 FirstWrite 0}
		p_out11 {Type O LastRead -1 FirstWrite 0}
		p_out12 {Type O LastRead -1 FirstWrite 0}
		p_out13 {Type O LastRead -1 FirstWrite 0}
		p_out14 {Type O LastRead -1 FirstWrite 0}
		p_out15 {Type O LastRead -1 FirstWrite 0}}
	gemm_7_Pipeline_VITIS_LOOP_151_3 {
		w4_0_load {Type I LastRead 0 FirstWrite -1}
		w4_2_load {Type I LastRead 0 FirstWrite -1}
		w4_4_load {Type I LastRead 0 FirstWrite -1}
		w4_6_load {Type I LastRead 0 FirstWrite -1}
		w4_8_load {Type I LastRead 0 FirstWrite -1}
		w4_10_load {Type I LastRead 0 FirstWrite -1}
		w4_12_load {Type I LastRead 0 FirstWrite -1}
		w4_14_load {Type I LastRead 0 FirstWrite -1}
		w4_0_load_1 {Type I LastRead 0 FirstWrite -1}
		w4_2_load_1 {Type I LastRead 0 FirstWrite -1}
		w4_4_load_1 {Type I LastRead 0 FirstWrite -1}
		w4_6_load_1 {Type I LastRead 0 FirstWrite -1}
		w4_8_load_1 {Type I LastRead 0 FirstWrite -1}
		w4_10_load_1 {Type I LastRead 0 FirstWrite -1}
		w4_12_load_1 {Type I LastRead 0 FirstWrite -1}
		w4_14_load_1 {Type I LastRead 0 FirstWrite -1}
		w4_0_load_2 {Type I LastRead 0 FirstWrite -1}
		w4_2_load_2 {Type I LastRead 0 FirstWrite -1}
		w4_4_load_2 {Type I LastRead 0 FirstWrite -1}
		w4_6_load_2 {Type I LastRead 0 FirstWrite -1}
		w4_8_load_2 {Type I LastRead 0 FirstWrite -1}
		w4_10_load_2 {Type I LastRead 0 FirstWrite -1}
		w4_12_load_2 {Type I LastRead 0 FirstWrite -1}
		w4_14_load_2 {Type I LastRead 0 FirstWrite -1}
		w4_0_load_3 {Type I LastRead 0 FirstWrite -1}
		w4_2_load_3 {Type I LastRead 0 FirstWrite -1}
		w4_4_load_3 {Type I LastRead 0 FirstWrite -1}
		w4_6_load_3 {Type I LastRead 0 FirstWrite -1}
		w4_8_load_3 {Type I LastRead 0 FirstWrite -1}
		w4_10_load_3 {Type I LastRead 0 FirstWrite -1}
		w4_12_load_3 {Type I LastRead 0 FirstWrite -1}
		w4_14_load_3 {Type I LastRead 0 FirstWrite -1}
		w4_0_load_4 {Type I LastRead 0 FirstWrite -1}
		w4_2_load_4 {Type I LastRead 0 FirstWrite -1}
		w4_4_load_4 {Type I LastRead 0 FirstWrite -1}
		w4_6_load_4 {Type I LastRead 0 FirstWrite -1}
		w4_8_load_4 {Type I LastRead 0 FirstWrite -1}
		w4_10_load_4 {Type I LastRead 0 FirstWrite -1}
		w4_12_load_4 {Type I LastRead 0 FirstWrite -1}
		w4_14_load_4 {Type I LastRead 0 FirstWrite -1}
		w4_0_load_5 {Type I LastRead 0 FirstWrite -1}
		w4_2_load_5 {Type I LastRead 0 FirstWrite -1}
		w4_4_load_5 {Type I LastRead 0 FirstWrite -1}
		w4_6_load_5 {Type I LastRead 0 FirstWrite -1}
		w4_8_load_5 {Type I LastRead 0 FirstWrite -1}
		w4_10_load_5 {Type I LastRead 0 FirstWrite -1}
		w4_12_load_5 {Type I LastRead 0 FirstWrite -1}
		w4_14_load_5 {Type I LastRead 0 FirstWrite -1}
		w4_0_load_6 {Type I LastRead 0 FirstWrite -1}
		w4_2_load_6 {Type I LastRead 0 FirstWrite -1}
		w4_4_load_6 {Type I LastRead 0 FirstWrite -1}
		w4_6_load_6 {Type I LastRead 0 FirstWrite -1}
		w4_8_load_6 {Type I LastRead 0 FirstWrite -1}
		w4_10_load_6 {Type I LastRead 0 FirstWrite -1}
		w4_12_load_6 {Type I LastRead 0 FirstWrite -1}
		w4_14_load_6 {Type I LastRead 0 FirstWrite -1}
		w4_0_load_7 {Type I LastRead 0 FirstWrite -1}
		w4_2_load_7 {Type I LastRead 0 FirstWrite -1}
		w4_4_load_7 {Type I LastRead 0 FirstWrite -1}
		w4_6_load_7 {Type I LastRead 0 FirstWrite -1}
		w4_8_load_7 {Type I LastRead 0 FirstWrite -1}
		w4_10_load_7 {Type I LastRead 0 FirstWrite -1}
		w4_12_load_7 {Type I LastRead 0 FirstWrite -1}
		w4_14_load_7 {Type I LastRead 0 FirstWrite -1}
		w4_0_load_8 {Type I LastRead 0 FirstWrite -1}
		w4_2_load_8 {Type I LastRead 0 FirstWrite -1}
		w4_4_load_8 {Type I LastRead 0 FirstWrite -1}
		w4_6_load_8 {Type I LastRead 0 FirstWrite -1}
		w4_8_load_8 {Type I LastRead 0 FirstWrite -1}
		w4_10_load_8 {Type I LastRead 0 FirstWrite -1}
		w4_12_load_8 {Type I LastRead 0 FirstWrite -1}
		w4_14_load_8 {Type I LastRead 0 FirstWrite -1}
		w4_0_load_9 {Type I LastRead 0 FirstWrite -1}
		w4_2_load_9 {Type I LastRead 0 FirstWrite -1}
		w4_4_load_9 {Type I LastRead 0 FirstWrite -1}
		w4_6_load_9 {Type I LastRead 0 FirstWrite -1}
		w4_8_load_9 {Type I LastRead 0 FirstWrite -1}
		w4_10_load_9 {Type I LastRead 0 FirstWrite -1}
		w4_12_load_9 {Type I LastRead 0 FirstWrite -1}
		w4_14_load_9 {Type I LastRead 0 FirstWrite -1}
		w4_0_load_10 {Type I LastRead 0 FirstWrite -1}
		w4_2_load_10 {Type I LastRead 0 FirstWrite -1}
		w4_4_load_10 {Type I LastRead 0 FirstWrite -1}
		w4_6_load_10 {Type I LastRead 0 FirstWrite -1}
		w4_8_load_10 {Type I LastRead 0 FirstWrite -1}
		w4_10_load_10 {Type I LastRead 0 FirstWrite -1}
		w4_12_load_10 {Type I LastRead 0 FirstWrite -1}
		w4_14_load_10 {Type I LastRead 0 FirstWrite -1}
		w4_0_load_11 {Type I LastRead 0 FirstWrite -1}
		w4_2_load_11 {Type I LastRead 0 FirstWrite -1}
		w4_4_load_11 {Type I LastRead 0 FirstWrite -1}
		w4_6_load_11 {Type I LastRead 0 FirstWrite -1}
		w4_8_load_11 {Type I LastRead 0 FirstWrite -1}
		w4_10_load_11 {Type I LastRead 0 FirstWrite -1}
		w4_12_load_11 {Type I LastRead 0 FirstWrite -1}
		w4_14_load_11 {Type I LastRead 0 FirstWrite -1}
		w4_0_load_12 {Type I LastRead 0 FirstWrite -1}
		w4_2_load_12 {Type I LastRead 0 FirstWrite -1}
		w4_4_load_12 {Type I LastRead 0 FirstWrite -1}
		w4_6_load_12 {Type I LastRead 0 FirstWrite -1}
		w4_8_load_12 {Type I LastRead 0 FirstWrite -1}
		w4_10_load_12 {Type I LastRead 0 FirstWrite -1}
		w4_12_load_12 {Type I LastRead 0 FirstWrite -1}
		w4_14_load_12 {Type I LastRead 0 FirstWrite -1}
		w4_0_load_13 {Type I LastRead 0 FirstWrite -1}
		w4_2_load_13 {Type I LastRead 0 FirstWrite -1}
		w4_4_load_13 {Type I LastRead 0 FirstWrite -1}
		w4_6_load_13 {Type I LastRead 0 FirstWrite -1}
		w4_8_load_13 {Type I LastRead 0 FirstWrite -1}
		w4_10_load_13 {Type I LastRead 0 FirstWrite -1}
		w4_12_load_13 {Type I LastRead 0 FirstWrite -1}
		w4_14_load_13 {Type I LastRead 0 FirstWrite -1}
		w4_0_load_14 {Type I LastRead 0 FirstWrite -1}
		w4_2_load_14 {Type I LastRead 0 FirstWrite -1}
		w4_4_load_14 {Type I LastRead 0 FirstWrite -1}
		w4_6_load_14 {Type I LastRead 0 FirstWrite -1}
		w4_8_load_14 {Type I LastRead 0 FirstWrite -1}
		w4_10_load_14 {Type I LastRead 0 FirstWrite -1}
		w4_12_load_14 {Type I LastRead 0 FirstWrite -1}
		w4_14_load_14 {Type I LastRead 0 FirstWrite -1}
		w4_0_load_15 {Type I LastRead 0 FirstWrite -1}
		w4_2_load_15 {Type I LastRead 0 FirstWrite -1}
		w4_4_load_15 {Type I LastRead 0 FirstWrite -1}
		w4_6_load_15 {Type I LastRead 0 FirstWrite -1}
		w4_8_load_15 {Type I LastRead 0 FirstWrite -1}
		w4_10_load_15 {Type I LastRead 0 FirstWrite -1}
		w4_12_load_15 {Type I LastRead 0 FirstWrite -1}
		w4_14_load_15 {Type I LastRead 0 FirstWrite -1}
		sext_ln160_15 {Type I LastRead 0 FirstWrite -1}
		sext_ln160_14 {Type I LastRead 0 FirstWrite -1}
		sext_ln160_13 {Type I LastRead 0 FirstWrite -1}
		sext_ln160_12 {Type I LastRead 0 FirstWrite -1}
		sext_ln160_11 {Type I LastRead 0 FirstWrite -1}
		sext_ln160_10 {Type I LastRead 0 FirstWrite -1}
		sext_ln160_9 {Type I LastRead 0 FirstWrite -1}
		sext_ln160_8 {Type I LastRead 0 FirstWrite -1}
		sext_ln160_7 {Type I LastRead 0 FirstWrite -1}
		sext_ln160_6 {Type I LastRead 0 FirstWrite -1}
		sext_ln160_5 {Type I LastRead 0 FirstWrite -1}
		sext_ln160_4 {Type I LastRead 0 FirstWrite -1}
		sext_ln160_3 {Type I LastRead 0 FirstWrite -1}
		sext_ln160_2 {Type I LastRead 0 FirstWrite -1}
		sext_ln160 {Type I LastRead 0 FirstWrite -1}
		sext_ln160_1 {Type I LastRead 0 FirstWrite -1}
		w4_1_load {Type I LastRead 0 FirstWrite -1}
		w4_3_load {Type I LastRead 0 FirstWrite -1}
		w4_5_load {Type I LastRead 0 FirstWrite -1}
		w4_7_load {Type I LastRead 0 FirstWrite -1}
		w4_9_load {Type I LastRead 0 FirstWrite -1}
		w4_11_load {Type I LastRead 0 FirstWrite -1}
		w4_13_load {Type I LastRead 0 FirstWrite -1}
		w4_15_load {Type I LastRead 0 FirstWrite -1}
		w4_1_load_1 {Type I LastRead 0 FirstWrite -1}
		w4_3_load_1 {Type I LastRead 0 FirstWrite -1}
		w4_5_load_1 {Type I LastRead 0 FirstWrite -1}
		w4_7_load_1 {Type I LastRead 0 FirstWrite -1}
		w4_9_load_1 {Type I LastRead 0 FirstWrite -1}
		w4_11_load_1 {Type I LastRead 0 FirstWrite -1}
		w4_13_load_1 {Type I LastRead 0 FirstWrite -1}
		w4_15_load_1 {Type I LastRead 0 FirstWrite -1}
		w4_1_load_2 {Type I LastRead 0 FirstWrite -1}
		w4_3_load_2 {Type I LastRead 0 FirstWrite -1}
		w4_5_load_2 {Type I LastRead 0 FirstWrite -1}
		w4_7_load_2 {Type I LastRead 0 FirstWrite -1}
		w4_9_load_2 {Type I LastRead 0 FirstWrite -1}
		w4_11_load_2 {Type I LastRead 0 FirstWrite -1}
		w4_13_load_2 {Type I LastRead 0 FirstWrite -1}
		w4_15_load_2 {Type I LastRead 0 FirstWrite -1}
		w4_1_load_3 {Type I LastRead 0 FirstWrite -1}
		w4_3_load_3 {Type I LastRead 0 FirstWrite -1}
		w4_5_load_3 {Type I LastRead 0 FirstWrite -1}
		w4_7_load_3 {Type I LastRead 0 FirstWrite -1}
		w4_9_load_3 {Type I LastRead 0 FirstWrite -1}
		w4_11_load_3 {Type I LastRead 0 FirstWrite -1}
		w4_13_load_3 {Type I LastRead 0 FirstWrite -1}
		w4_15_load_3 {Type I LastRead 0 FirstWrite -1}
		w4_1_load_4 {Type I LastRead 0 FirstWrite -1}
		w4_3_load_4 {Type I LastRead 0 FirstWrite -1}
		w4_5_load_4 {Type I LastRead 0 FirstWrite -1}
		w4_7_load_4 {Type I LastRead 0 FirstWrite -1}
		w4_9_load_4 {Type I LastRead 0 FirstWrite -1}
		w4_11_load_4 {Type I LastRead 0 FirstWrite -1}
		w4_13_load_4 {Type I LastRead 0 FirstWrite -1}
		w4_15_load_4 {Type I LastRead 0 FirstWrite -1}
		w4_1_load_5 {Type I LastRead 0 FirstWrite -1}
		w4_3_load_5 {Type I LastRead 0 FirstWrite -1}
		w4_5_load_5 {Type I LastRead 0 FirstWrite -1}
		w4_7_load_5 {Type I LastRead 0 FirstWrite -1}
		w4_9_load_5 {Type I LastRead 0 FirstWrite -1}
		w4_11_load_5 {Type I LastRead 0 FirstWrite -1}
		w4_13_load_5 {Type I LastRead 0 FirstWrite -1}
		w4_15_load_5 {Type I LastRead 0 FirstWrite -1}
		w4_1_load_6 {Type I LastRead 0 FirstWrite -1}
		w4_3_load_6 {Type I LastRead 0 FirstWrite -1}
		w4_5_load_6 {Type I LastRead 0 FirstWrite -1}
		w4_7_load_6 {Type I LastRead 0 FirstWrite -1}
		w4_9_load_6 {Type I LastRead 0 FirstWrite -1}
		w4_11_load_6 {Type I LastRead 0 FirstWrite -1}
		w4_13_load_6 {Type I LastRead 0 FirstWrite -1}
		w4_15_load_6 {Type I LastRead 0 FirstWrite -1}
		w4_1_load_7 {Type I LastRead 0 FirstWrite -1}
		w4_3_load_7 {Type I LastRead 0 FirstWrite -1}
		w4_5_load_7 {Type I LastRead 0 FirstWrite -1}
		w4_7_load_7 {Type I LastRead 0 FirstWrite -1}
		w4_9_load_7 {Type I LastRead 0 FirstWrite -1}
		w4_11_load_7 {Type I LastRead 0 FirstWrite -1}
		w4_13_load_7 {Type I LastRead 0 FirstWrite -1}
		w4_15_load_7 {Type I LastRead 0 FirstWrite -1}
		w4_1_load_8 {Type I LastRead 0 FirstWrite -1}
		w4_3_load_8 {Type I LastRead 0 FirstWrite -1}
		w4_5_load_8 {Type I LastRead 0 FirstWrite -1}
		w4_7_load_8 {Type I LastRead 0 FirstWrite -1}
		w4_9_load_8 {Type I LastRead 0 FirstWrite -1}
		w4_11_load_8 {Type I LastRead 0 FirstWrite -1}
		w4_13_load_8 {Type I LastRead 0 FirstWrite -1}
		w4_15_load_8 {Type I LastRead 0 FirstWrite -1}
		w4_1_load_9 {Type I LastRead 0 FirstWrite -1}
		w4_3_load_9 {Type I LastRead 0 FirstWrite -1}
		w4_5_load_9 {Type I LastRead 0 FirstWrite -1}
		w4_7_load_9 {Type I LastRead 0 FirstWrite -1}
		w4_9_load_9 {Type I LastRead 0 FirstWrite -1}
		w4_11_load_9 {Type I LastRead 0 FirstWrite -1}
		w4_13_load_9 {Type I LastRead 0 FirstWrite -1}
		w4_15_load_9 {Type I LastRead 0 FirstWrite -1}
		w4_1_load_10 {Type I LastRead 0 FirstWrite -1}
		w4_3_load_10 {Type I LastRead 0 FirstWrite -1}
		w4_5_load_10 {Type I LastRead 0 FirstWrite -1}
		w4_7_load_10 {Type I LastRead 0 FirstWrite -1}
		w4_9_load_10 {Type I LastRead 0 FirstWrite -1}
		w4_11_load_10 {Type I LastRead 0 FirstWrite -1}
		w4_13_load_10 {Type I LastRead 0 FirstWrite -1}
		w4_15_load_10 {Type I LastRead 0 FirstWrite -1}
		w4_1_load_11 {Type I LastRead 0 FirstWrite -1}
		w4_3_load_11 {Type I LastRead 0 FirstWrite -1}
		w4_5_load_11 {Type I LastRead 0 FirstWrite -1}
		w4_7_load_11 {Type I LastRead 0 FirstWrite -1}
		w4_9_load_11 {Type I LastRead 0 FirstWrite -1}
		w4_11_load_11 {Type I LastRead 0 FirstWrite -1}
		w4_13_load_11 {Type I LastRead 0 FirstWrite -1}
		w4_15_load_11 {Type I LastRead 0 FirstWrite -1}
		w4_1_load_12 {Type I LastRead 0 FirstWrite -1}
		w4_3_load_12 {Type I LastRead 0 FirstWrite -1}
		w4_5_load_12 {Type I LastRead 0 FirstWrite -1}
		w4_7_load_12 {Type I LastRead 0 FirstWrite -1}
		w4_9_load_12 {Type I LastRead 0 FirstWrite -1}
		w4_11_load_12 {Type I LastRead 0 FirstWrite -1}
		w4_13_load_12 {Type I LastRead 0 FirstWrite -1}
		w4_15_load_12 {Type I LastRead 0 FirstWrite -1}
		w4_1_load_13 {Type I LastRead 0 FirstWrite -1}
		w4_3_load_13 {Type I LastRead 0 FirstWrite -1}
		w4_5_load_13 {Type I LastRead 0 FirstWrite -1}
		w4_7_load_13 {Type I LastRead 0 FirstWrite -1}
		w4_9_load_13 {Type I LastRead 0 FirstWrite -1}
		w4_11_load_13 {Type I LastRead 0 FirstWrite -1}
		w4_13_load_13 {Type I LastRead 0 FirstWrite -1}
		w4_15_load_13 {Type I LastRead 0 FirstWrite -1}
		w4_1_load_14 {Type I LastRead 0 FirstWrite -1}
		w4_3_load_14 {Type I LastRead 0 FirstWrite -1}
		w4_5_load_14 {Type I LastRead 0 FirstWrite -1}
		w4_7_load_14 {Type I LastRead 0 FirstWrite -1}
		w4_9_load_14 {Type I LastRead 0 FirstWrite -1}
		w4_11_load_14 {Type I LastRead 0 FirstWrite -1}
		w4_13_load_14 {Type I LastRead 0 FirstWrite -1}
		w4_15_load_14 {Type I LastRead 0 FirstWrite -1}
		w4_1_load_15 {Type I LastRead 0 FirstWrite -1}
		w4_3_load_15 {Type I LastRead 0 FirstWrite -1}
		w4_5_load_15 {Type I LastRead 0 FirstWrite -1}
		w4_7_load_15 {Type I LastRead 0 FirstWrite -1}
		w4_9_load_15 {Type I LastRead 0 FirstWrite -1}
		w4_11_load_15 {Type I LastRead 0 FirstWrite -1}
		w4_13_load_15 {Type I LastRead 0 FirstWrite -1}
		w4_15_load_15 {Type I LastRead 0 FirstWrite -1}
		s_gemm4_out {Type O LastRead -1 FirstWrite 8}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "36", "Max" : "36"}
	, {"Name" : "Interval", "Min" : "36", "Max" : "36"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	s_relu_out { ap_fifo {  { s_relu_out_dout fifo_data_out 0 16 }  { s_relu_out_empty_n fifo_status_empty 0 1 }  { s_relu_out_read fifo_data_in 1 1 }  { s_relu_out_num_data_valid fifo_update 0 3 }  { s_relu_out_fifo_cap fifo_data 0 3 } } }
	s_gemm4_out { ap_fifo {  { s_gemm4_out_din fifo_data_out 1 16 }  { s_gemm4_out_full_n fifo_status_empty 0 1 }  { s_gemm4_out_write fifo_data_in 1 1 }  { s_gemm4_out_num_data_valid fifo_update 0 32 }  { s_gemm4_out_fifo_cap fifo_data 0 32 } } }
	w4_0 { bram {  { w4_0_Addr_A MemPortADDR2 1 32 }  { w4_0_EN_A MemPortCE2 1 1 }  { w4_0_WEN_A MemPortWE2 1 1 }  { w4_0_Din_A MemPortDIN2 1 8 }  { w4_0_Dout_A MemPortDOUT2 0 8 }  { w4_0_Addr_B MemPortADDR2 1 32 }  { w4_0_EN_B MemPortCE2 1 1 }  { w4_0_WEN_B MemPortWE2 1 1 }  { w4_0_Din_B MemPortDIN2 1 8 }  { w4_0_Dout_B MemPortDOUT2 0 8 } } }
	w4_1 { bram {  { w4_1_Addr_A MemPortADDR2 1 32 }  { w4_1_EN_A MemPortCE2 1 1 }  { w4_1_WEN_A MemPortWE2 1 1 }  { w4_1_Din_A MemPortDIN2 1 8 }  { w4_1_Dout_A MemPortDOUT2 0 8 }  { w4_1_Addr_B MemPortADDR2 1 32 }  { w4_1_EN_B MemPortCE2 1 1 }  { w4_1_WEN_B MemPortWE2 1 1 }  { w4_1_Din_B MemPortDIN2 1 8 }  { w4_1_Dout_B MemPortDOUT2 0 8 } } }
	w4_2 { bram {  { w4_2_Addr_A MemPortADDR2 1 32 }  { w4_2_EN_A MemPortCE2 1 1 }  { w4_2_WEN_A MemPortWE2 1 1 }  { w4_2_Din_A MemPortDIN2 1 8 }  { w4_2_Dout_A MemPortDOUT2 0 8 }  { w4_2_Addr_B MemPortADDR2 1 32 }  { w4_2_EN_B MemPortCE2 1 1 }  { w4_2_WEN_B MemPortWE2 1 1 }  { w4_2_Din_B MemPortDIN2 1 8 }  { w4_2_Dout_B MemPortDOUT2 0 8 } } }
	w4_3 { bram {  { w4_3_Addr_A MemPortADDR2 1 32 }  { w4_3_EN_A MemPortCE2 1 1 }  { w4_3_WEN_A MemPortWE2 1 1 }  { w4_3_Din_A MemPortDIN2 1 8 }  { w4_3_Dout_A MemPortDOUT2 0 8 }  { w4_3_Addr_B MemPortADDR2 1 32 }  { w4_3_EN_B MemPortCE2 1 1 }  { w4_3_WEN_B MemPortWE2 1 1 }  { w4_3_Din_B MemPortDIN2 1 8 }  { w4_3_Dout_B MemPortDOUT2 0 8 } } }
	w4_4 { bram {  { w4_4_Addr_A MemPortADDR2 1 32 }  { w4_4_EN_A MemPortCE2 1 1 }  { w4_4_WEN_A MemPortWE2 1 1 }  { w4_4_Din_A MemPortDIN2 1 8 }  { w4_4_Dout_A MemPortDOUT2 0 8 }  { w4_4_Addr_B MemPortADDR2 1 32 }  { w4_4_EN_B MemPortCE2 1 1 }  { w4_4_WEN_B MemPortWE2 1 1 }  { w4_4_Din_B MemPortDIN2 1 8 }  { w4_4_Dout_B MemPortDOUT2 0 8 } } }
	w4_5 { bram {  { w4_5_Addr_A MemPortADDR2 1 32 }  { w4_5_EN_A MemPortCE2 1 1 }  { w4_5_WEN_A MemPortWE2 1 1 }  { w4_5_Din_A MemPortDIN2 1 8 }  { w4_5_Dout_A MemPortDOUT2 0 8 }  { w4_5_Addr_B MemPortADDR2 1 32 }  { w4_5_EN_B MemPortCE2 1 1 }  { w4_5_WEN_B MemPortWE2 1 1 }  { w4_5_Din_B MemPortDIN2 1 8 }  { w4_5_Dout_B MemPortDOUT2 0 8 } } }
	w4_6 { bram {  { w4_6_Addr_A MemPortADDR2 1 32 }  { w4_6_EN_A MemPortCE2 1 1 }  { w4_6_WEN_A MemPortWE2 1 1 }  { w4_6_Din_A MemPortDIN2 1 8 }  { w4_6_Dout_A MemPortDOUT2 0 8 }  { w4_6_Addr_B MemPortADDR2 1 32 }  { w4_6_EN_B MemPortCE2 1 1 }  { w4_6_WEN_B MemPortWE2 1 1 }  { w4_6_Din_B MemPortDIN2 1 8 }  { w4_6_Dout_B MemPortDOUT2 0 8 } } }
	w4_7 { bram {  { w4_7_Addr_A MemPortADDR2 1 32 }  { w4_7_EN_A MemPortCE2 1 1 }  { w4_7_WEN_A MemPortWE2 1 1 }  { w4_7_Din_A MemPortDIN2 1 8 }  { w4_7_Dout_A MemPortDOUT2 0 8 }  { w4_7_Addr_B MemPortADDR2 1 32 }  { w4_7_EN_B MemPortCE2 1 1 }  { w4_7_WEN_B MemPortWE2 1 1 }  { w4_7_Din_B MemPortDIN2 1 8 }  { w4_7_Dout_B MemPortDOUT2 0 8 } } }
	w4_8 { bram {  { w4_8_Addr_A MemPortADDR2 1 32 }  { w4_8_EN_A MemPortCE2 1 1 }  { w4_8_WEN_A MemPortWE2 1 1 }  { w4_8_Din_A MemPortDIN2 1 8 }  { w4_8_Dout_A MemPortDOUT2 0 8 }  { w4_8_Addr_B MemPortADDR2 1 32 }  { w4_8_EN_B MemPortCE2 1 1 }  { w4_8_WEN_B MemPortWE2 1 1 }  { w4_8_Din_B MemPortDIN2 1 8 }  { w4_8_Dout_B MemPortDOUT2 0 8 } } }
	w4_9 { bram {  { w4_9_Addr_A MemPortADDR2 1 32 }  { w4_9_EN_A MemPortCE2 1 1 }  { w4_9_WEN_A MemPortWE2 1 1 }  { w4_9_Din_A MemPortDIN2 1 8 }  { w4_9_Dout_A MemPortDOUT2 0 8 }  { w4_9_Addr_B MemPortADDR2 1 32 }  { w4_9_EN_B MemPortCE2 1 1 }  { w4_9_WEN_B MemPortWE2 1 1 }  { w4_9_Din_B MemPortDIN2 1 8 }  { w4_9_Dout_B MemPortDOUT2 0 8 } } }
	w4_10 { bram {  { w4_10_Addr_A MemPortADDR2 1 32 }  { w4_10_EN_A MemPortCE2 1 1 }  { w4_10_WEN_A MemPortWE2 1 1 }  { w4_10_Din_A MemPortDIN2 1 8 }  { w4_10_Dout_A MemPortDOUT2 0 8 }  { w4_10_Addr_B MemPortADDR2 1 32 }  { w4_10_EN_B MemPortCE2 1 1 }  { w4_10_WEN_B MemPortWE2 1 1 }  { w4_10_Din_B MemPortDIN2 1 8 }  { w4_10_Dout_B MemPortDOUT2 0 8 } } }
	w4_11 { bram {  { w4_11_Addr_A MemPortADDR2 1 32 }  { w4_11_EN_A MemPortCE2 1 1 }  { w4_11_WEN_A MemPortWE2 1 1 }  { w4_11_Din_A MemPortDIN2 1 8 }  { w4_11_Dout_A MemPortDOUT2 0 8 }  { w4_11_Addr_B MemPortADDR2 1 32 }  { w4_11_EN_B MemPortCE2 1 1 }  { w4_11_WEN_B MemPortWE2 1 1 }  { w4_11_Din_B MemPortDIN2 1 8 }  { w4_11_Dout_B MemPortDOUT2 0 8 } } }
	w4_12 { bram {  { w4_12_Addr_A MemPortADDR2 1 32 }  { w4_12_EN_A MemPortCE2 1 1 }  { w4_12_WEN_A MemPortWE2 1 1 }  { w4_12_Din_A MemPortDIN2 1 8 }  { w4_12_Dout_A MemPortDOUT2 0 8 }  { w4_12_Addr_B MemPortADDR2 1 32 }  { w4_12_EN_B MemPortCE2 1 1 }  { w4_12_WEN_B MemPortWE2 1 1 }  { w4_12_Din_B MemPortDIN2 1 8 }  { w4_12_Dout_B MemPortDOUT2 0 8 } } }
	w4_13 { bram {  { w4_13_Addr_A MemPortADDR2 1 32 }  { w4_13_EN_A MemPortCE2 1 1 }  { w4_13_WEN_A MemPortWE2 1 1 }  { w4_13_Din_A MemPortDIN2 1 8 }  { w4_13_Dout_A MemPortDOUT2 0 8 }  { w4_13_Addr_B MemPortADDR2 1 32 }  { w4_13_EN_B MemPortCE2 1 1 }  { w4_13_WEN_B MemPortWE2 1 1 }  { w4_13_Din_B MemPortDIN2 1 8 }  { w4_13_Dout_B MemPortDOUT2 0 8 } } }
	w4_14 { bram {  { w4_14_Addr_A MemPortADDR2 1 32 }  { w4_14_EN_A MemPortCE2 1 1 }  { w4_14_WEN_A MemPortWE2 1 1 }  { w4_14_Din_A MemPortDIN2 1 8 }  { w4_14_Dout_A MemPortDOUT2 0 8 }  { w4_14_Addr_B MemPortADDR2 1 32 }  { w4_14_EN_B MemPortCE2 1 1 }  { w4_14_WEN_B MemPortWE2 1 1 }  { w4_14_Din_B MemPortDIN2 1 8 }  { w4_14_Dout_B MemPortDOUT2 0 8 } } }
	w4_15 { bram {  { w4_15_Addr_A MemPortADDR2 1 32 }  { w4_15_EN_A MemPortCE2 1 1 }  { w4_15_WEN_A MemPortWE2 1 1 }  { w4_15_Din_A MemPortDIN2 1 8 }  { w4_15_Dout_A MemPortDOUT2 0 8 }  { w4_15_Addr_B MemPortADDR2 1 32 }  { w4_15_EN_B MemPortCE2 1 1 }  { w4_15_WEN_B MemPortWE2 1 1 }  { w4_15_Din_B MemPortDIN2 1 8 }  { w4_15_Dout_B MemPortDOUT2 0 8 } } }
}
