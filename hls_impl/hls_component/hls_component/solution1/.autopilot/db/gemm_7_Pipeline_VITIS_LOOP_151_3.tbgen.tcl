set moduleName gemm_7_Pipeline_VITIS_LOOP_151_3
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
set C_modelName {gemm.7_Pipeline_VITIS_LOOP_151_3}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ w4_0_load int 8 regular  }
	{ w4_2_load int 8 regular  }
	{ w4_4_load int 8 regular  }
	{ w4_6_load int 8 regular  }
	{ w4_8_load int 8 regular  }
	{ w4_10_load int 8 regular  }
	{ w4_12_load int 8 regular  }
	{ w4_14_load int 8 regular  }
	{ w4_0_load_1 int 8 regular  }
	{ w4_2_load_1 int 8 regular  }
	{ w4_4_load_1 int 8 regular  }
	{ w4_6_load_1 int 8 regular  }
	{ w4_8_load_1 int 8 regular  }
	{ w4_10_load_1 int 8 regular  }
	{ w4_12_load_1 int 8 regular  }
	{ w4_14_load_1 int 8 regular  }
	{ w4_0_load_2 int 8 regular  }
	{ w4_2_load_2 int 8 regular  }
	{ w4_4_load_2 int 8 regular  }
	{ w4_6_load_2 int 8 regular  }
	{ w4_8_load_2 int 8 regular  }
	{ w4_10_load_2 int 8 regular  }
	{ w4_12_load_2 int 8 regular  }
	{ w4_14_load_2 int 8 regular  }
	{ w4_0_load_3 int 8 regular  }
	{ w4_2_load_3 int 8 regular  }
	{ w4_4_load_3 int 8 regular  }
	{ w4_6_load_3 int 8 regular  }
	{ w4_8_load_3 int 8 regular  }
	{ w4_10_load_3 int 8 regular  }
	{ w4_12_load_3 int 8 regular  }
	{ w4_14_load_3 int 8 regular  }
	{ w4_0_load_4 int 8 regular  }
	{ w4_2_load_4 int 8 regular  }
	{ w4_4_load_4 int 8 regular  }
	{ w4_6_load_4 int 8 regular  }
	{ w4_8_load_4 int 8 regular  }
	{ w4_10_load_4 int 8 regular  }
	{ w4_12_load_4 int 8 regular  }
	{ w4_14_load_4 int 8 regular  }
	{ w4_0_load_5 int 8 regular  }
	{ w4_2_load_5 int 8 regular  }
	{ w4_4_load_5 int 8 regular  }
	{ w4_6_load_5 int 8 regular  }
	{ w4_8_load_5 int 8 regular  }
	{ w4_10_load_5 int 8 regular  }
	{ w4_12_load_5 int 8 regular  }
	{ w4_14_load_5 int 8 regular  }
	{ w4_0_load_6 int 8 regular  }
	{ w4_2_load_6 int 8 regular  }
	{ w4_4_load_6 int 8 regular  }
	{ w4_6_load_6 int 8 regular  }
	{ w4_8_load_6 int 8 regular  }
	{ w4_10_load_6 int 8 regular  }
	{ w4_12_load_6 int 8 regular  }
	{ w4_14_load_6 int 8 regular  }
	{ w4_0_load_7 int 8 regular  }
	{ w4_2_load_7 int 8 regular  }
	{ w4_4_load_7 int 8 regular  }
	{ w4_6_load_7 int 8 regular  }
	{ w4_8_load_7 int 8 regular  }
	{ w4_10_load_7 int 8 regular  }
	{ w4_12_load_7 int 8 regular  }
	{ w4_14_load_7 int 8 regular  }
	{ w4_0_load_8 int 8 regular  }
	{ w4_2_load_8 int 8 regular  }
	{ w4_4_load_8 int 8 regular  }
	{ w4_6_load_8 int 8 regular  }
	{ w4_8_load_8 int 8 regular  }
	{ w4_10_load_8 int 8 regular  }
	{ w4_12_load_8 int 8 regular  }
	{ w4_14_load_8 int 8 regular  }
	{ w4_0_load_9 int 8 regular  }
	{ w4_2_load_9 int 8 regular  }
	{ w4_4_load_9 int 8 regular  }
	{ w4_6_load_9 int 8 regular  }
	{ w4_8_load_9 int 8 regular  }
	{ w4_10_load_9 int 8 regular  }
	{ w4_12_load_9 int 8 regular  }
	{ w4_14_load_9 int 8 regular  }
	{ w4_0_load_10 int 8 regular  }
	{ w4_2_load_10 int 8 regular  }
	{ w4_4_load_10 int 8 regular  }
	{ w4_6_load_10 int 8 regular  }
	{ w4_8_load_10 int 8 regular  }
	{ w4_10_load_10 int 8 regular  }
	{ w4_12_load_10 int 8 regular  }
	{ w4_14_load_10 int 8 regular  }
	{ w4_0_load_11 int 8 regular  }
	{ w4_2_load_11 int 8 regular  }
	{ w4_4_load_11 int 8 regular  }
	{ w4_6_load_11 int 8 regular  }
	{ w4_8_load_11 int 8 regular  }
	{ w4_10_load_11 int 8 regular  }
	{ w4_12_load_11 int 8 regular  }
	{ w4_14_load_11 int 8 regular  }
	{ w4_0_load_12 int 8 regular  }
	{ w4_2_load_12 int 8 regular  }
	{ w4_4_load_12 int 8 regular  }
	{ w4_6_load_12 int 8 regular  }
	{ w4_8_load_12 int 8 regular  }
	{ w4_10_load_12 int 8 regular  }
	{ w4_12_load_12 int 8 regular  }
	{ w4_14_load_12 int 8 regular  }
	{ w4_0_load_13 int 8 regular  }
	{ w4_2_load_13 int 8 regular  }
	{ w4_4_load_13 int 8 regular  }
	{ w4_6_load_13 int 8 regular  }
	{ w4_8_load_13 int 8 regular  }
	{ w4_10_load_13 int 8 regular  }
	{ w4_12_load_13 int 8 regular  }
	{ w4_14_load_13 int 8 regular  }
	{ w4_0_load_14 int 8 regular  }
	{ w4_2_load_14 int 8 regular  }
	{ w4_4_load_14 int 8 regular  }
	{ w4_6_load_14 int 8 regular  }
	{ w4_8_load_14 int 8 regular  }
	{ w4_10_load_14 int 8 regular  }
	{ w4_12_load_14 int 8 regular  }
	{ w4_14_load_14 int 8 regular  }
	{ w4_0_load_15 int 8 regular  }
	{ w4_2_load_15 int 8 regular  }
	{ w4_4_load_15 int 8 regular  }
	{ w4_6_load_15 int 8 regular  }
	{ w4_8_load_15 int 8 regular  }
	{ w4_10_load_15 int 8 regular  }
	{ w4_12_load_15 int 8 regular  }
	{ w4_14_load_15 int 8 regular  }
	{ sext_ln160_15 int 8 regular  }
	{ sext_ln160_14 int 8 regular  }
	{ sext_ln160_13 int 8 regular  }
	{ sext_ln160_12 int 8 regular  }
	{ sext_ln160_11 int 8 regular  }
	{ sext_ln160_10 int 8 regular  }
	{ sext_ln160_9 int 8 regular  }
	{ sext_ln160_8 int 8 regular  }
	{ sext_ln160_7 int 8 regular  }
	{ sext_ln160_6 int 8 regular  }
	{ sext_ln160_5 int 8 regular  }
	{ sext_ln160_4 int 8 regular  }
	{ sext_ln160_3 int 8 regular  }
	{ sext_ln160_2 int 8 regular  }
	{ sext_ln160 int 8 regular  }
	{ sext_ln160_1 int 8 regular  }
	{ w4_1_load int 8 regular  }
	{ w4_3_load int 8 regular  }
	{ w4_5_load int 8 regular  }
	{ w4_7_load int 8 regular  }
	{ w4_9_load int 8 regular  }
	{ w4_11_load int 8 regular  }
	{ w4_13_load int 8 regular  }
	{ w4_15_load int 8 regular  }
	{ w4_1_load_1 int 8 regular  }
	{ w4_3_load_1 int 8 regular  }
	{ w4_5_load_1 int 8 regular  }
	{ w4_7_load_1 int 8 regular  }
	{ w4_9_load_1 int 8 regular  }
	{ w4_11_load_1 int 8 regular  }
	{ w4_13_load_1 int 8 regular  }
	{ w4_15_load_1 int 8 regular  }
	{ w4_1_load_2 int 8 regular  }
	{ w4_3_load_2 int 8 regular  }
	{ w4_5_load_2 int 8 regular  }
	{ w4_7_load_2 int 8 regular  }
	{ w4_9_load_2 int 8 regular  }
	{ w4_11_load_2 int 8 regular  }
	{ w4_13_load_2 int 8 regular  }
	{ w4_15_load_2 int 8 regular  }
	{ w4_1_load_3 int 8 regular  }
	{ w4_3_load_3 int 8 regular  }
	{ w4_5_load_3 int 8 regular  }
	{ w4_7_load_3 int 8 regular  }
	{ w4_9_load_3 int 8 regular  }
	{ w4_11_load_3 int 8 regular  }
	{ w4_13_load_3 int 8 regular  }
	{ w4_15_load_3 int 8 regular  }
	{ w4_1_load_4 int 8 regular  }
	{ w4_3_load_4 int 8 regular  }
	{ w4_5_load_4 int 8 regular  }
	{ w4_7_load_4 int 8 regular  }
	{ w4_9_load_4 int 8 regular  }
	{ w4_11_load_4 int 8 regular  }
	{ w4_13_load_4 int 8 regular  }
	{ w4_15_load_4 int 8 regular  }
	{ w4_1_load_5 int 8 regular  }
	{ w4_3_load_5 int 8 regular  }
	{ w4_5_load_5 int 8 regular  }
	{ w4_7_load_5 int 8 regular  }
	{ w4_9_load_5 int 8 regular  }
	{ w4_11_load_5 int 8 regular  }
	{ w4_13_load_5 int 8 regular  }
	{ w4_15_load_5 int 8 regular  }
	{ w4_1_load_6 int 8 regular  }
	{ w4_3_load_6 int 8 regular  }
	{ w4_5_load_6 int 8 regular  }
	{ w4_7_load_6 int 8 regular  }
	{ w4_9_load_6 int 8 regular  }
	{ w4_11_load_6 int 8 regular  }
	{ w4_13_load_6 int 8 regular  }
	{ w4_15_load_6 int 8 regular  }
	{ w4_1_load_7 int 8 regular  }
	{ w4_3_load_7 int 8 regular  }
	{ w4_5_load_7 int 8 regular  }
	{ w4_7_load_7 int 8 regular  }
	{ w4_9_load_7 int 8 regular  }
	{ w4_11_load_7 int 8 regular  }
	{ w4_13_load_7 int 8 regular  }
	{ w4_15_load_7 int 8 regular  }
	{ w4_1_load_8 int 8 regular  }
	{ w4_3_load_8 int 8 regular  }
	{ w4_5_load_8 int 8 regular  }
	{ w4_7_load_8 int 8 regular  }
	{ w4_9_load_8 int 8 regular  }
	{ w4_11_load_8 int 8 regular  }
	{ w4_13_load_8 int 8 regular  }
	{ w4_15_load_8 int 8 regular  }
	{ w4_1_load_9 int 8 regular  }
	{ w4_3_load_9 int 8 regular  }
	{ w4_5_load_9 int 8 regular  }
	{ w4_7_load_9 int 8 regular  }
	{ w4_9_load_9 int 8 regular  }
	{ w4_11_load_9 int 8 regular  }
	{ w4_13_load_9 int 8 regular  }
	{ w4_15_load_9 int 8 regular  }
	{ w4_1_load_10 int 8 regular  }
	{ w4_3_load_10 int 8 regular  }
	{ w4_5_load_10 int 8 regular  }
	{ w4_7_load_10 int 8 regular  }
	{ w4_9_load_10 int 8 regular  }
	{ w4_11_load_10 int 8 regular  }
	{ w4_13_load_10 int 8 regular  }
	{ w4_15_load_10 int 8 regular  }
	{ w4_1_load_11 int 8 regular  }
	{ w4_3_load_11 int 8 regular  }
	{ w4_5_load_11 int 8 regular  }
	{ w4_7_load_11 int 8 regular  }
	{ w4_9_load_11 int 8 regular  }
	{ w4_11_load_11 int 8 regular  }
	{ w4_13_load_11 int 8 regular  }
	{ w4_15_load_11 int 8 regular  }
	{ w4_1_load_12 int 8 regular  }
	{ w4_3_load_12 int 8 regular  }
	{ w4_5_load_12 int 8 regular  }
	{ w4_7_load_12 int 8 regular  }
	{ w4_9_load_12 int 8 regular  }
	{ w4_11_load_12 int 8 regular  }
	{ w4_13_load_12 int 8 regular  }
	{ w4_15_load_12 int 8 regular  }
	{ w4_1_load_13 int 8 regular  }
	{ w4_3_load_13 int 8 regular  }
	{ w4_5_load_13 int 8 regular  }
	{ w4_7_load_13 int 8 regular  }
	{ w4_9_load_13 int 8 regular  }
	{ w4_11_load_13 int 8 regular  }
	{ w4_13_load_13 int 8 regular  }
	{ w4_15_load_13 int 8 regular  }
	{ w4_1_load_14 int 8 regular  }
	{ w4_3_load_14 int 8 regular  }
	{ w4_5_load_14 int 8 regular  }
	{ w4_7_load_14 int 8 regular  }
	{ w4_9_load_14 int 8 regular  }
	{ w4_11_load_14 int 8 regular  }
	{ w4_13_load_14 int 8 regular  }
	{ w4_15_load_14 int 8 regular  }
	{ w4_1_load_15 int 8 regular  }
	{ w4_3_load_15 int 8 regular  }
	{ w4_5_load_15 int 8 regular  }
	{ w4_7_load_15 int 8 regular  }
	{ w4_9_load_15 int 8 regular  }
	{ w4_11_load_15 int 8 regular  }
	{ w4_13_load_15 int 8 regular  }
	{ w4_15_load_15 int 8 regular  }
	{ s_gemm4_out int 16 regular {fifo 1 volatile }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "w4_0_load", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_2_load", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_4_load", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_6_load", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_8_load", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_10_load", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_12_load", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_14_load", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_0_load_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_2_load_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_4_load_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_6_load_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_8_load_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_10_load_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_12_load_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_14_load_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_0_load_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_2_load_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_4_load_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_6_load_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_8_load_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_10_load_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_12_load_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_14_load_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_0_load_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_2_load_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_4_load_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_6_load_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_8_load_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_10_load_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_12_load_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_14_load_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_0_load_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_2_load_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_4_load_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_6_load_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_8_load_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_10_load_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_12_load_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_14_load_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_0_load_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_2_load_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_4_load_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_6_load_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_8_load_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_10_load_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_12_load_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_14_load_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_0_load_6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_2_load_6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_4_load_6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_6_load_6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_8_load_6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_10_load_6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_12_load_6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_14_load_6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_0_load_7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_2_load_7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_4_load_7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_6_load_7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_8_load_7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_10_load_7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_12_load_7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_14_load_7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_0_load_8", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_2_load_8", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_4_load_8", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_6_load_8", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_8_load_8", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_10_load_8", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_12_load_8", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_14_load_8", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_0_load_9", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_2_load_9", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_4_load_9", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_6_load_9", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_8_load_9", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_10_load_9", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_12_load_9", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_14_load_9", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_0_load_10", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_2_load_10", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_4_load_10", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_6_load_10", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_8_load_10", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_10_load_10", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_12_load_10", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_14_load_10", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_0_load_11", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_2_load_11", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_4_load_11", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_6_load_11", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_8_load_11", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_10_load_11", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_12_load_11", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_14_load_11", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_0_load_12", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_2_load_12", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_4_load_12", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_6_load_12", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_8_load_12", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_10_load_12", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_12_load_12", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_14_load_12", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_0_load_13", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_2_load_13", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_4_load_13", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_6_load_13", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_8_load_13", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_10_load_13", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_12_load_13", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_14_load_13", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_0_load_14", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_2_load_14", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_4_load_14", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_6_load_14", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_8_load_14", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_10_load_14", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_12_load_14", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_14_load_14", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_0_load_15", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_2_load_15", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_4_load_15", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_6_load_15", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_8_load_15", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_10_load_15", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_12_load_15", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_14_load_15", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln160_15", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln160_14", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln160_13", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln160_12", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln160_11", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln160_10", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln160_9", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln160_8", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln160_7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln160_6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln160_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln160_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln160_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln160_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln160", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "sext_ln160_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_1_load", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_3_load", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_5_load", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_7_load", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_9_load", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_11_load", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_13_load", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_15_load", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_1_load_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_3_load_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_5_load_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_7_load_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_9_load_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_11_load_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_13_load_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_15_load_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_1_load_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_3_load_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_5_load_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_7_load_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_9_load_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_11_load_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_13_load_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_15_load_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_1_load_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_3_load_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_5_load_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_7_load_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_9_load_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_11_load_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_13_load_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_15_load_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_1_load_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_3_load_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_5_load_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_7_load_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_9_load_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_11_load_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_13_load_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_15_load_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_1_load_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_3_load_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_5_load_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_7_load_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_9_load_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_11_load_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_13_load_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_15_load_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_1_load_6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_3_load_6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_5_load_6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_7_load_6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_9_load_6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_11_load_6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_13_load_6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_15_load_6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_1_load_7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_3_load_7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_5_load_7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_7_load_7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_9_load_7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_11_load_7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_13_load_7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_15_load_7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_1_load_8", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_3_load_8", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_5_load_8", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_7_load_8", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_9_load_8", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_11_load_8", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_13_load_8", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_15_load_8", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_1_load_9", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_3_load_9", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_5_load_9", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_7_load_9", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_9_load_9", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_11_load_9", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_13_load_9", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_15_load_9", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_1_load_10", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_3_load_10", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_5_load_10", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_7_load_10", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_9_load_10", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_11_load_10", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_13_load_10", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_15_load_10", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_1_load_11", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_3_load_11", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_5_load_11", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_7_load_11", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_9_load_11", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_11_load_11", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_13_load_11", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_15_load_11", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_1_load_12", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_3_load_12", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_5_load_12", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_7_load_12", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_9_load_12", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_11_load_12", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_13_load_12", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_15_load_12", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_1_load_13", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_3_load_13", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_5_load_13", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_7_load_13", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_9_load_13", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_11_load_13", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_13_load_13", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_15_load_13", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_1_load_14", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_3_load_14", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_5_load_14", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_7_load_14", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_9_load_14", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_11_load_14", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_13_load_14", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_15_load_14", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_1_load_15", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_3_load_15", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_5_load_15", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_7_load_15", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_9_load_15", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_11_load_15", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_13_load_15", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "w4_15_load_15", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "s_gemm4_out", "interface" : "fifo", "bitwidth" : 16, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 283
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ s_gemm4_out_din sc_out sc_lv 16 signal 272 } 
	{ s_gemm4_out_full_n sc_in sc_logic 1 signal 272 } 
	{ s_gemm4_out_write sc_out sc_logic 1 signal 272 } 
	{ s_gemm4_out_num_data_valid sc_in sc_lv 32 signal 272 } 
	{ s_gemm4_out_fifo_cap sc_in sc_lv 32 signal 272 } 
	{ w4_0_load sc_in sc_lv 8 signal 0 } 
	{ w4_2_load sc_in sc_lv 8 signal 1 } 
	{ w4_4_load sc_in sc_lv 8 signal 2 } 
	{ w4_6_load sc_in sc_lv 8 signal 3 } 
	{ w4_8_load sc_in sc_lv 8 signal 4 } 
	{ w4_10_load sc_in sc_lv 8 signal 5 } 
	{ w4_12_load sc_in sc_lv 8 signal 6 } 
	{ w4_14_load sc_in sc_lv 8 signal 7 } 
	{ w4_0_load_1 sc_in sc_lv 8 signal 8 } 
	{ w4_2_load_1 sc_in sc_lv 8 signal 9 } 
	{ w4_4_load_1 sc_in sc_lv 8 signal 10 } 
	{ w4_6_load_1 sc_in sc_lv 8 signal 11 } 
	{ w4_8_load_1 sc_in sc_lv 8 signal 12 } 
	{ w4_10_load_1 sc_in sc_lv 8 signal 13 } 
	{ w4_12_load_1 sc_in sc_lv 8 signal 14 } 
	{ w4_14_load_1 sc_in sc_lv 8 signal 15 } 
	{ w4_0_load_2 sc_in sc_lv 8 signal 16 } 
	{ w4_2_load_2 sc_in sc_lv 8 signal 17 } 
	{ w4_4_load_2 sc_in sc_lv 8 signal 18 } 
	{ w4_6_load_2 sc_in sc_lv 8 signal 19 } 
	{ w4_8_load_2 sc_in sc_lv 8 signal 20 } 
	{ w4_10_load_2 sc_in sc_lv 8 signal 21 } 
	{ w4_12_load_2 sc_in sc_lv 8 signal 22 } 
	{ w4_14_load_2 sc_in sc_lv 8 signal 23 } 
	{ w4_0_load_3 sc_in sc_lv 8 signal 24 } 
	{ w4_2_load_3 sc_in sc_lv 8 signal 25 } 
	{ w4_4_load_3 sc_in sc_lv 8 signal 26 } 
	{ w4_6_load_3 sc_in sc_lv 8 signal 27 } 
	{ w4_8_load_3 sc_in sc_lv 8 signal 28 } 
	{ w4_10_load_3 sc_in sc_lv 8 signal 29 } 
	{ w4_12_load_3 sc_in sc_lv 8 signal 30 } 
	{ w4_14_load_3 sc_in sc_lv 8 signal 31 } 
	{ w4_0_load_4 sc_in sc_lv 8 signal 32 } 
	{ w4_2_load_4 sc_in sc_lv 8 signal 33 } 
	{ w4_4_load_4 sc_in sc_lv 8 signal 34 } 
	{ w4_6_load_4 sc_in sc_lv 8 signal 35 } 
	{ w4_8_load_4 sc_in sc_lv 8 signal 36 } 
	{ w4_10_load_4 sc_in sc_lv 8 signal 37 } 
	{ w4_12_load_4 sc_in sc_lv 8 signal 38 } 
	{ w4_14_load_4 sc_in sc_lv 8 signal 39 } 
	{ w4_0_load_5 sc_in sc_lv 8 signal 40 } 
	{ w4_2_load_5 sc_in sc_lv 8 signal 41 } 
	{ w4_4_load_5 sc_in sc_lv 8 signal 42 } 
	{ w4_6_load_5 sc_in sc_lv 8 signal 43 } 
	{ w4_8_load_5 sc_in sc_lv 8 signal 44 } 
	{ w4_10_load_5 sc_in sc_lv 8 signal 45 } 
	{ w4_12_load_5 sc_in sc_lv 8 signal 46 } 
	{ w4_14_load_5 sc_in sc_lv 8 signal 47 } 
	{ w4_0_load_6 sc_in sc_lv 8 signal 48 } 
	{ w4_2_load_6 sc_in sc_lv 8 signal 49 } 
	{ w4_4_load_6 sc_in sc_lv 8 signal 50 } 
	{ w4_6_load_6 sc_in sc_lv 8 signal 51 } 
	{ w4_8_load_6 sc_in sc_lv 8 signal 52 } 
	{ w4_10_load_6 sc_in sc_lv 8 signal 53 } 
	{ w4_12_load_6 sc_in sc_lv 8 signal 54 } 
	{ w4_14_load_6 sc_in sc_lv 8 signal 55 } 
	{ w4_0_load_7 sc_in sc_lv 8 signal 56 } 
	{ w4_2_load_7 sc_in sc_lv 8 signal 57 } 
	{ w4_4_load_7 sc_in sc_lv 8 signal 58 } 
	{ w4_6_load_7 sc_in sc_lv 8 signal 59 } 
	{ w4_8_load_7 sc_in sc_lv 8 signal 60 } 
	{ w4_10_load_7 sc_in sc_lv 8 signal 61 } 
	{ w4_12_load_7 sc_in sc_lv 8 signal 62 } 
	{ w4_14_load_7 sc_in sc_lv 8 signal 63 } 
	{ w4_0_load_8 sc_in sc_lv 8 signal 64 } 
	{ w4_2_load_8 sc_in sc_lv 8 signal 65 } 
	{ w4_4_load_8 sc_in sc_lv 8 signal 66 } 
	{ w4_6_load_8 sc_in sc_lv 8 signal 67 } 
	{ w4_8_load_8 sc_in sc_lv 8 signal 68 } 
	{ w4_10_load_8 sc_in sc_lv 8 signal 69 } 
	{ w4_12_load_8 sc_in sc_lv 8 signal 70 } 
	{ w4_14_load_8 sc_in sc_lv 8 signal 71 } 
	{ w4_0_load_9 sc_in sc_lv 8 signal 72 } 
	{ w4_2_load_9 sc_in sc_lv 8 signal 73 } 
	{ w4_4_load_9 sc_in sc_lv 8 signal 74 } 
	{ w4_6_load_9 sc_in sc_lv 8 signal 75 } 
	{ w4_8_load_9 sc_in sc_lv 8 signal 76 } 
	{ w4_10_load_9 sc_in sc_lv 8 signal 77 } 
	{ w4_12_load_9 sc_in sc_lv 8 signal 78 } 
	{ w4_14_load_9 sc_in sc_lv 8 signal 79 } 
	{ w4_0_load_10 sc_in sc_lv 8 signal 80 } 
	{ w4_2_load_10 sc_in sc_lv 8 signal 81 } 
	{ w4_4_load_10 sc_in sc_lv 8 signal 82 } 
	{ w4_6_load_10 sc_in sc_lv 8 signal 83 } 
	{ w4_8_load_10 sc_in sc_lv 8 signal 84 } 
	{ w4_10_load_10 sc_in sc_lv 8 signal 85 } 
	{ w4_12_load_10 sc_in sc_lv 8 signal 86 } 
	{ w4_14_load_10 sc_in sc_lv 8 signal 87 } 
	{ w4_0_load_11 sc_in sc_lv 8 signal 88 } 
	{ w4_2_load_11 sc_in sc_lv 8 signal 89 } 
	{ w4_4_load_11 sc_in sc_lv 8 signal 90 } 
	{ w4_6_load_11 sc_in sc_lv 8 signal 91 } 
	{ w4_8_load_11 sc_in sc_lv 8 signal 92 } 
	{ w4_10_load_11 sc_in sc_lv 8 signal 93 } 
	{ w4_12_load_11 sc_in sc_lv 8 signal 94 } 
	{ w4_14_load_11 sc_in sc_lv 8 signal 95 } 
	{ w4_0_load_12 sc_in sc_lv 8 signal 96 } 
	{ w4_2_load_12 sc_in sc_lv 8 signal 97 } 
	{ w4_4_load_12 sc_in sc_lv 8 signal 98 } 
	{ w4_6_load_12 sc_in sc_lv 8 signal 99 } 
	{ w4_8_load_12 sc_in sc_lv 8 signal 100 } 
	{ w4_10_load_12 sc_in sc_lv 8 signal 101 } 
	{ w4_12_load_12 sc_in sc_lv 8 signal 102 } 
	{ w4_14_load_12 sc_in sc_lv 8 signal 103 } 
	{ w4_0_load_13 sc_in sc_lv 8 signal 104 } 
	{ w4_2_load_13 sc_in sc_lv 8 signal 105 } 
	{ w4_4_load_13 sc_in sc_lv 8 signal 106 } 
	{ w4_6_load_13 sc_in sc_lv 8 signal 107 } 
	{ w4_8_load_13 sc_in sc_lv 8 signal 108 } 
	{ w4_10_load_13 sc_in sc_lv 8 signal 109 } 
	{ w4_12_load_13 sc_in sc_lv 8 signal 110 } 
	{ w4_14_load_13 sc_in sc_lv 8 signal 111 } 
	{ w4_0_load_14 sc_in sc_lv 8 signal 112 } 
	{ w4_2_load_14 sc_in sc_lv 8 signal 113 } 
	{ w4_4_load_14 sc_in sc_lv 8 signal 114 } 
	{ w4_6_load_14 sc_in sc_lv 8 signal 115 } 
	{ w4_8_load_14 sc_in sc_lv 8 signal 116 } 
	{ w4_10_load_14 sc_in sc_lv 8 signal 117 } 
	{ w4_12_load_14 sc_in sc_lv 8 signal 118 } 
	{ w4_14_load_14 sc_in sc_lv 8 signal 119 } 
	{ w4_0_load_15 sc_in sc_lv 8 signal 120 } 
	{ w4_2_load_15 sc_in sc_lv 8 signal 121 } 
	{ w4_4_load_15 sc_in sc_lv 8 signal 122 } 
	{ w4_6_load_15 sc_in sc_lv 8 signal 123 } 
	{ w4_8_load_15 sc_in sc_lv 8 signal 124 } 
	{ w4_10_load_15 sc_in sc_lv 8 signal 125 } 
	{ w4_12_load_15 sc_in sc_lv 8 signal 126 } 
	{ w4_14_load_15 sc_in sc_lv 8 signal 127 } 
	{ sext_ln160_15 sc_in sc_lv 8 signal 128 } 
	{ sext_ln160_14 sc_in sc_lv 8 signal 129 } 
	{ sext_ln160_13 sc_in sc_lv 8 signal 130 } 
	{ sext_ln160_12 sc_in sc_lv 8 signal 131 } 
	{ sext_ln160_11 sc_in sc_lv 8 signal 132 } 
	{ sext_ln160_10 sc_in sc_lv 8 signal 133 } 
	{ sext_ln160_9 sc_in sc_lv 8 signal 134 } 
	{ sext_ln160_8 sc_in sc_lv 8 signal 135 } 
	{ sext_ln160_7 sc_in sc_lv 8 signal 136 } 
	{ sext_ln160_6 sc_in sc_lv 8 signal 137 } 
	{ sext_ln160_5 sc_in sc_lv 8 signal 138 } 
	{ sext_ln160_4 sc_in sc_lv 8 signal 139 } 
	{ sext_ln160_3 sc_in sc_lv 8 signal 140 } 
	{ sext_ln160_2 sc_in sc_lv 8 signal 141 } 
	{ sext_ln160 sc_in sc_lv 8 signal 142 } 
	{ sext_ln160_1 sc_in sc_lv 8 signal 143 } 
	{ w4_1_load sc_in sc_lv 8 signal 144 } 
	{ w4_3_load sc_in sc_lv 8 signal 145 } 
	{ w4_5_load sc_in sc_lv 8 signal 146 } 
	{ w4_7_load sc_in sc_lv 8 signal 147 } 
	{ w4_9_load sc_in sc_lv 8 signal 148 } 
	{ w4_11_load sc_in sc_lv 8 signal 149 } 
	{ w4_13_load sc_in sc_lv 8 signal 150 } 
	{ w4_15_load sc_in sc_lv 8 signal 151 } 
	{ w4_1_load_1 sc_in sc_lv 8 signal 152 } 
	{ w4_3_load_1 sc_in sc_lv 8 signal 153 } 
	{ w4_5_load_1 sc_in sc_lv 8 signal 154 } 
	{ w4_7_load_1 sc_in sc_lv 8 signal 155 } 
	{ w4_9_load_1 sc_in sc_lv 8 signal 156 } 
	{ w4_11_load_1 sc_in sc_lv 8 signal 157 } 
	{ w4_13_load_1 sc_in sc_lv 8 signal 158 } 
	{ w4_15_load_1 sc_in sc_lv 8 signal 159 } 
	{ w4_1_load_2 sc_in sc_lv 8 signal 160 } 
	{ w4_3_load_2 sc_in sc_lv 8 signal 161 } 
	{ w4_5_load_2 sc_in sc_lv 8 signal 162 } 
	{ w4_7_load_2 sc_in sc_lv 8 signal 163 } 
	{ w4_9_load_2 sc_in sc_lv 8 signal 164 } 
	{ w4_11_load_2 sc_in sc_lv 8 signal 165 } 
	{ w4_13_load_2 sc_in sc_lv 8 signal 166 } 
	{ w4_15_load_2 sc_in sc_lv 8 signal 167 } 
	{ w4_1_load_3 sc_in sc_lv 8 signal 168 } 
	{ w4_3_load_3 sc_in sc_lv 8 signal 169 } 
	{ w4_5_load_3 sc_in sc_lv 8 signal 170 } 
	{ w4_7_load_3 sc_in sc_lv 8 signal 171 } 
	{ w4_9_load_3 sc_in sc_lv 8 signal 172 } 
	{ w4_11_load_3 sc_in sc_lv 8 signal 173 } 
	{ w4_13_load_3 sc_in sc_lv 8 signal 174 } 
	{ w4_15_load_3 sc_in sc_lv 8 signal 175 } 
	{ w4_1_load_4 sc_in sc_lv 8 signal 176 } 
	{ w4_3_load_4 sc_in sc_lv 8 signal 177 } 
	{ w4_5_load_4 sc_in sc_lv 8 signal 178 } 
	{ w4_7_load_4 sc_in sc_lv 8 signal 179 } 
	{ w4_9_load_4 sc_in sc_lv 8 signal 180 } 
	{ w4_11_load_4 sc_in sc_lv 8 signal 181 } 
	{ w4_13_load_4 sc_in sc_lv 8 signal 182 } 
	{ w4_15_load_4 sc_in sc_lv 8 signal 183 } 
	{ w4_1_load_5 sc_in sc_lv 8 signal 184 } 
	{ w4_3_load_5 sc_in sc_lv 8 signal 185 } 
	{ w4_5_load_5 sc_in sc_lv 8 signal 186 } 
	{ w4_7_load_5 sc_in sc_lv 8 signal 187 } 
	{ w4_9_load_5 sc_in sc_lv 8 signal 188 } 
	{ w4_11_load_5 sc_in sc_lv 8 signal 189 } 
	{ w4_13_load_5 sc_in sc_lv 8 signal 190 } 
	{ w4_15_load_5 sc_in sc_lv 8 signal 191 } 
	{ w4_1_load_6 sc_in sc_lv 8 signal 192 } 
	{ w4_3_load_6 sc_in sc_lv 8 signal 193 } 
	{ w4_5_load_6 sc_in sc_lv 8 signal 194 } 
	{ w4_7_load_6 sc_in sc_lv 8 signal 195 } 
	{ w4_9_load_6 sc_in sc_lv 8 signal 196 } 
	{ w4_11_load_6 sc_in sc_lv 8 signal 197 } 
	{ w4_13_load_6 sc_in sc_lv 8 signal 198 } 
	{ w4_15_load_6 sc_in sc_lv 8 signal 199 } 
	{ w4_1_load_7 sc_in sc_lv 8 signal 200 } 
	{ w4_3_load_7 sc_in sc_lv 8 signal 201 } 
	{ w4_5_load_7 sc_in sc_lv 8 signal 202 } 
	{ w4_7_load_7 sc_in sc_lv 8 signal 203 } 
	{ w4_9_load_7 sc_in sc_lv 8 signal 204 } 
	{ w4_11_load_7 sc_in sc_lv 8 signal 205 } 
	{ w4_13_load_7 sc_in sc_lv 8 signal 206 } 
	{ w4_15_load_7 sc_in sc_lv 8 signal 207 } 
	{ w4_1_load_8 sc_in sc_lv 8 signal 208 } 
	{ w4_3_load_8 sc_in sc_lv 8 signal 209 } 
	{ w4_5_load_8 sc_in sc_lv 8 signal 210 } 
	{ w4_7_load_8 sc_in sc_lv 8 signal 211 } 
	{ w4_9_load_8 sc_in sc_lv 8 signal 212 } 
	{ w4_11_load_8 sc_in sc_lv 8 signal 213 } 
	{ w4_13_load_8 sc_in sc_lv 8 signal 214 } 
	{ w4_15_load_8 sc_in sc_lv 8 signal 215 } 
	{ w4_1_load_9 sc_in sc_lv 8 signal 216 } 
	{ w4_3_load_9 sc_in sc_lv 8 signal 217 } 
	{ w4_5_load_9 sc_in sc_lv 8 signal 218 } 
	{ w4_7_load_9 sc_in sc_lv 8 signal 219 } 
	{ w4_9_load_9 sc_in sc_lv 8 signal 220 } 
	{ w4_11_load_9 sc_in sc_lv 8 signal 221 } 
	{ w4_13_load_9 sc_in sc_lv 8 signal 222 } 
	{ w4_15_load_9 sc_in sc_lv 8 signal 223 } 
	{ w4_1_load_10 sc_in sc_lv 8 signal 224 } 
	{ w4_3_load_10 sc_in sc_lv 8 signal 225 } 
	{ w4_5_load_10 sc_in sc_lv 8 signal 226 } 
	{ w4_7_load_10 sc_in sc_lv 8 signal 227 } 
	{ w4_9_load_10 sc_in sc_lv 8 signal 228 } 
	{ w4_11_load_10 sc_in sc_lv 8 signal 229 } 
	{ w4_13_load_10 sc_in sc_lv 8 signal 230 } 
	{ w4_15_load_10 sc_in sc_lv 8 signal 231 } 
	{ w4_1_load_11 sc_in sc_lv 8 signal 232 } 
	{ w4_3_load_11 sc_in sc_lv 8 signal 233 } 
	{ w4_5_load_11 sc_in sc_lv 8 signal 234 } 
	{ w4_7_load_11 sc_in sc_lv 8 signal 235 } 
	{ w4_9_load_11 sc_in sc_lv 8 signal 236 } 
	{ w4_11_load_11 sc_in sc_lv 8 signal 237 } 
	{ w4_13_load_11 sc_in sc_lv 8 signal 238 } 
	{ w4_15_load_11 sc_in sc_lv 8 signal 239 } 
	{ w4_1_load_12 sc_in sc_lv 8 signal 240 } 
	{ w4_3_load_12 sc_in sc_lv 8 signal 241 } 
	{ w4_5_load_12 sc_in sc_lv 8 signal 242 } 
	{ w4_7_load_12 sc_in sc_lv 8 signal 243 } 
	{ w4_9_load_12 sc_in sc_lv 8 signal 244 } 
	{ w4_11_load_12 sc_in sc_lv 8 signal 245 } 
	{ w4_13_load_12 sc_in sc_lv 8 signal 246 } 
	{ w4_15_load_12 sc_in sc_lv 8 signal 247 } 
	{ w4_1_load_13 sc_in sc_lv 8 signal 248 } 
	{ w4_3_load_13 sc_in sc_lv 8 signal 249 } 
	{ w4_5_load_13 sc_in sc_lv 8 signal 250 } 
	{ w4_7_load_13 sc_in sc_lv 8 signal 251 } 
	{ w4_9_load_13 sc_in sc_lv 8 signal 252 } 
	{ w4_11_load_13 sc_in sc_lv 8 signal 253 } 
	{ w4_13_load_13 sc_in sc_lv 8 signal 254 } 
	{ w4_15_load_13 sc_in sc_lv 8 signal 255 } 
	{ w4_1_load_14 sc_in sc_lv 8 signal 256 } 
	{ w4_3_load_14 sc_in sc_lv 8 signal 257 } 
	{ w4_5_load_14 sc_in sc_lv 8 signal 258 } 
	{ w4_7_load_14 sc_in sc_lv 8 signal 259 } 
	{ w4_9_load_14 sc_in sc_lv 8 signal 260 } 
	{ w4_11_load_14 sc_in sc_lv 8 signal 261 } 
	{ w4_13_load_14 sc_in sc_lv 8 signal 262 } 
	{ w4_15_load_14 sc_in sc_lv 8 signal 263 } 
	{ w4_1_load_15 sc_in sc_lv 8 signal 264 } 
	{ w4_3_load_15 sc_in sc_lv 8 signal 265 } 
	{ w4_5_load_15 sc_in sc_lv 8 signal 266 } 
	{ w4_7_load_15 sc_in sc_lv 8 signal 267 } 
	{ w4_9_load_15 sc_in sc_lv 8 signal 268 } 
	{ w4_11_load_15 sc_in sc_lv 8 signal 269 } 
	{ w4_13_load_15 sc_in sc_lv 8 signal 270 } 
	{ w4_15_load_15 sc_in sc_lv 8 signal 271 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "s_gemm4_out_din", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "s_gemm4_out", "role": "din" }} , 
 	{ "name": "s_gemm4_out_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_gemm4_out", "role": "full_n" }} , 
 	{ "name": "s_gemm4_out_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "s_gemm4_out", "role": "write" }} , 
 	{ "name": "s_gemm4_out_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_gemm4_out", "role": "num_data_valid" }} , 
 	{ "name": "s_gemm4_out_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_gemm4_out", "role": "fifo_cap" }} , 
 	{ "name": "w4_0_load", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0_load", "role": "default" }} , 
 	{ "name": "w4_2_load", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2_load", "role": "default" }} , 
 	{ "name": "w4_4_load", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4_load", "role": "default" }} , 
 	{ "name": "w4_6_load", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6_load", "role": "default" }} , 
 	{ "name": "w4_8_load", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8_load", "role": "default" }} , 
 	{ "name": "w4_10_load", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10_load", "role": "default" }} , 
 	{ "name": "w4_12_load", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12_load", "role": "default" }} , 
 	{ "name": "w4_14_load", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14_load", "role": "default" }} , 
 	{ "name": "w4_0_load_1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0_load_1", "role": "default" }} , 
 	{ "name": "w4_2_load_1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2_load_1", "role": "default" }} , 
 	{ "name": "w4_4_load_1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4_load_1", "role": "default" }} , 
 	{ "name": "w4_6_load_1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6_load_1", "role": "default" }} , 
 	{ "name": "w4_8_load_1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8_load_1", "role": "default" }} , 
 	{ "name": "w4_10_load_1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10_load_1", "role": "default" }} , 
 	{ "name": "w4_12_load_1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12_load_1", "role": "default" }} , 
 	{ "name": "w4_14_load_1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14_load_1", "role": "default" }} , 
 	{ "name": "w4_0_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0_load_2", "role": "default" }} , 
 	{ "name": "w4_2_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2_load_2", "role": "default" }} , 
 	{ "name": "w4_4_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4_load_2", "role": "default" }} , 
 	{ "name": "w4_6_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6_load_2", "role": "default" }} , 
 	{ "name": "w4_8_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8_load_2", "role": "default" }} , 
 	{ "name": "w4_10_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10_load_2", "role": "default" }} , 
 	{ "name": "w4_12_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12_load_2", "role": "default" }} , 
 	{ "name": "w4_14_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14_load_2", "role": "default" }} , 
 	{ "name": "w4_0_load_3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0_load_3", "role": "default" }} , 
 	{ "name": "w4_2_load_3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2_load_3", "role": "default" }} , 
 	{ "name": "w4_4_load_3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4_load_3", "role": "default" }} , 
 	{ "name": "w4_6_load_3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6_load_3", "role": "default" }} , 
 	{ "name": "w4_8_load_3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8_load_3", "role": "default" }} , 
 	{ "name": "w4_10_load_3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10_load_3", "role": "default" }} , 
 	{ "name": "w4_12_load_3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12_load_3", "role": "default" }} , 
 	{ "name": "w4_14_load_3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14_load_3", "role": "default" }} , 
 	{ "name": "w4_0_load_4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0_load_4", "role": "default" }} , 
 	{ "name": "w4_2_load_4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2_load_4", "role": "default" }} , 
 	{ "name": "w4_4_load_4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4_load_4", "role": "default" }} , 
 	{ "name": "w4_6_load_4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6_load_4", "role": "default" }} , 
 	{ "name": "w4_8_load_4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8_load_4", "role": "default" }} , 
 	{ "name": "w4_10_load_4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10_load_4", "role": "default" }} , 
 	{ "name": "w4_12_load_4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12_load_4", "role": "default" }} , 
 	{ "name": "w4_14_load_4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14_load_4", "role": "default" }} , 
 	{ "name": "w4_0_load_5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0_load_5", "role": "default" }} , 
 	{ "name": "w4_2_load_5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2_load_5", "role": "default" }} , 
 	{ "name": "w4_4_load_5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4_load_5", "role": "default" }} , 
 	{ "name": "w4_6_load_5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6_load_5", "role": "default" }} , 
 	{ "name": "w4_8_load_5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8_load_5", "role": "default" }} , 
 	{ "name": "w4_10_load_5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10_load_5", "role": "default" }} , 
 	{ "name": "w4_12_load_5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12_load_5", "role": "default" }} , 
 	{ "name": "w4_14_load_5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14_load_5", "role": "default" }} , 
 	{ "name": "w4_0_load_6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0_load_6", "role": "default" }} , 
 	{ "name": "w4_2_load_6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2_load_6", "role": "default" }} , 
 	{ "name": "w4_4_load_6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4_load_6", "role": "default" }} , 
 	{ "name": "w4_6_load_6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6_load_6", "role": "default" }} , 
 	{ "name": "w4_8_load_6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8_load_6", "role": "default" }} , 
 	{ "name": "w4_10_load_6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10_load_6", "role": "default" }} , 
 	{ "name": "w4_12_load_6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12_load_6", "role": "default" }} , 
 	{ "name": "w4_14_load_6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14_load_6", "role": "default" }} , 
 	{ "name": "w4_0_load_7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0_load_7", "role": "default" }} , 
 	{ "name": "w4_2_load_7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2_load_7", "role": "default" }} , 
 	{ "name": "w4_4_load_7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4_load_7", "role": "default" }} , 
 	{ "name": "w4_6_load_7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6_load_7", "role": "default" }} , 
 	{ "name": "w4_8_load_7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8_load_7", "role": "default" }} , 
 	{ "name": "w4_10_load_7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10_load_7", "role": "default" }} , 
 	{ "name": "w4_12_load_7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12_load_7", "role": "default" }} , 
 	{ "name": "w4_14_load_7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14_load_7", "role": "default" }} , 
 	{ "name": "w4_0_load_8", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0_load_8", "role": "default" }} , 
 	{ "name": "w4_2_load_8", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2_load_8", "role": "default" }} , 
 	{ "name": "w4_4_load_8", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4_load_8", "role": "default" }} , 
 	{ "name": "w4_6_load_8", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6_load_8", "role": "default" }} , 
 	{ "name": "w4_8_load_8", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8_load_8", "role": "default" }} , 
 	{ "name": "w4_10_load_8", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10_load_8", "role": "default" }} , 
 	{ "name": "w4_12_load_8", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12_load_8", "role": "default" }} , 
 	{ "name": "w4_14_load_8", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14_load_8", "role": "default" }} , 
 	{ "name": "w4_0_load_9", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0_load_9", "role": "default" }} , 
 	{ "name": "w4_2_load_9", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2_load_9", "role": "default" }} , 
 	{ "name": "w4_4_load_9", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4_load_9", "role": "default" }} , 
 	{ "name": "w4_6_load_9", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6_load_9", "role": "default" }} , 
 	{ "name": "w4_8_load_9", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8_load_9", "role": "default" }} , 
 	{ "name": "w4_10_load_9", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10_load_9", "role": "default" }} , 
 	{ "name": "w4_12_load_9", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12_load_9", "role": "default" }} , 
 	{ "name": "w4_14_load_9", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14_load_9", "role": "default" }} , 
 	{ "name": "w4_0_load_10", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0_load_10", "role": "default" }} , 
 	{ "name": "w4_2_load_10", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2_load_10", "role": "default" }} , 
 	{ "name": "w4_4_load_10", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4_load_10", "role": "default" }} , 
 	{ "name": "w4_6_load_10", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6_load_10", "role": "default" }} , 
 	{ "name": "w4_8_load_10", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8_load_10", "role": "default" }} , 
 	{ "name": "w4_10_load_10", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10_load_10", "role": "default" }} , 
 	{ "name": "w4_12_load_10", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12_load_10", "role": "default" }} , 
 	{ "name": "w4_14_load_10", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14_load_10", "role": "default" }} , 
 	{ "name": "w4_0_load_11", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0_load_11", "role": "default" }} , 
 	{ "name": "w4_2_load_11", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2_load_11", "role": "default" }} , 
 	{ "name": "w4_4_load_11", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4_load_11", "role": "default" }} , 
 	{ "name": "w4_6_load_11", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6_load_11", "role": "default" }} , 
 	{ "name": "w4_8_load_11", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8_load_11", "role": "default" }} , 
 	{ "name": "w4_10_load_11", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10_load_11", "role": "default" }} , 
 	{ "name": "w4_12_load_11", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12_load_11", "role": "default" }} , 
 	{ "name": "w4_14_load_11", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14_load_11", "role": "default" }} , 
 	{ "name": "w4_0_load_12", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0_load_12", "role": "default" }} , 
 	{ "name": "w4_2_load_12", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2_load_12", "role": "default" }} , 
 	{ "name": "w4_4_load_12", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4_load_12", "role": "default" }} , 
 	{ "name": "w4_6_load_12", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6_load_12", "role": "default" }} , 
 	{ "name": "w4_8_load_12", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8_load_12", "role": "default" }} , 
 	{ "name": "w4_10_load_12", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10_load_12", "role": "default" }} , 
 	{ "name": "w4_12_load_12", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12_load_12", "role": "default" }} , 
 	{ "name": "w4_14_load_12", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14_load_12", "role": "default" }} , 
 	{ "name": "w4_0_load_13", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0_load_13", "role": "default" }} , 
 	{ "name": "w4_2_load_13", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2_load_13", "role": "default" }} , 
 	{ "name": "w4_4_load_13", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4_load_13", "role": "default" }} , 
 	{ "name": "w4_6_load_13", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6_load_13", "role": "default" }} , 
 	{ "name": "w4_8_load_13", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8_load_13", "role": "default" }} , 
 	{ "name": "w4_10_load_13", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10_load_13", "role": "default" }} , 
 	{ "name": "w4_12_load_13", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12_load_13", "role": "default" }} , 
 	{ "name": "w4_14_load_13", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14_load_13", "role": "default" }} , 
 	{ "name": "w4_0_load_14", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0_load_14", "role": "default" }} , 
 	{ "name": "w4_2_load_14", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2_load_14", "role": "default" }} , 
 	{ "name": "w4_4_load_14", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4_load_14", "role": "default" }} , 
 	{ "name": "w4_6_load_14", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6_load_14", "role": "default" }} , 
 	{ "name": "w4_8_load_14", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8_load_14", "role": "default" }} , 
 	{ "name": "w4_10_load_14", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10_load_14", "role": "default" }} , 
 	{ "name": "w4_12_load_14", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12_load_14", "role": "default" }} , 
 	{ "name": "w4_14_load_14", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14_load_14", "role": "default" }} , 
 	{ "name": "w4_0_load_15", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_0_load_15", "role": "default" }} , 
 	{ "name": "w4_2_load_15", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_2_load_15", "role": "default" }} , 
 	{ "name": "w4_4_load_15", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_4_load_15", "role": "default" }} , 
 	{ "name": "w4_6_load_15", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_6_load_15", "role": "default" }} , 
 	{ "name": "w4_8_load_15", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_8_load_15", "role": "default" }} , 
 	{ "name": "w4_10_load_15", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_10_load_15", "role": "default" }} , 
 	{ "name": "w4_12_load_15", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_12_load_15", "role": "default" }} , 
 	{ "name": "w4_14_load_15", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_14_load_15", "role": "default" }} , 
 	{ "name": "sext_ln160_15", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln160_15", "role": "default" }} , 
 	{ "name": "sext_ln160_14", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln160_14", "role": "default" }} , 
 	{ "name": "sext_ln160_13", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln160_13", "role": "default" }} , 
 	{ "name": "sext_ln160_12", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln160_12", "role": "default" }} , 
 	{ "name": "sext_ln160_11", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln160_11", "role": "default" }} , 
 	{ "name": "sext_ln160_10", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln160_10", "role": "default" }} , 
 	{ "name": "sext_ln160_9", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln160_9", "role": "default" }} , 
 	{ "name": "sext_ln160_8", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln160_8", "role": "default" }} , 
 	{ "name": "sext_ln160_7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln160_7", "role": "default" }} , 
 	{ "name": "sext_ln160_6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln160_6", "role": "default" }} , 
 	{ "name": "sext_ln160_5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln160_5", "role": "default" }} , 
 	{ "name": "sext_ln160_4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln160_4", "role": "default" }} , 
 	{ "name": "sext_ln160_3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln160_3", "role": "default" }} , 
 	{ "name": "sext_ln160_2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln160_2", "role": "default" }} , 
 	{ "name": "sext_ln160", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln160", "role": "default" }} , 
 	{ "name": "sext_ln160_1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "sext_ln160_1", "role": "default" }} , 
 	{ "name": "w4_1_load", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1_load", "role": "default" }} , 
 	{ "name": "w4_3_load", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3_load", "role": "default" }} , 
 	{ "name": "w4_5_load", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5_load", "role": "default" }} , 
 	{ "name": "w4_7_load", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7_load", "role": "default" }} , 
 	{ "name": "w4_9_load", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9_load", "role": "default" }} , 
 	{ "name": "w4_11_load", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11_load", "role": "default" }} , 
 	{ "name": "w4_13_load", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13_load", "role": "default" }} , 
 	{ "name": "w4_15_load", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15_load", "role": "default" }} , 
 	{ "name": "w4_1_load_1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1_load_1", "role": "default" }} , 
 	{ "name": "w4_3_load_1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3_load_1", "role": "default" }} , 
 	{ "name": "w4_5_load_1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5_load_1", "role": "default" }} , 
 	{ "name": "w4_7_load_1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7_load_1", "role": "default" }} , 
 	{ "name": "w4_9_load_1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9_load_1", "role": "default" }} , 
 	{ "name": "w4_11_load_1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11_load_1", "role": "default" }} , 
 	{ "name": "w4_13_load_1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13_load_1", "role": "default" }} , 
 	{ "name": "w4_15_load_1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15_load_1", "role": "default" }} , 
 	{ "name": "w4_1_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1_load_2", "role": "default" }} , 
 	{ "name": "w4_3_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3_load_2", "role": "default" }} , 
 	{ "name": "w4_5_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5_load_2", "role": "default" }} , 
 	{ "name": "w4_7_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7_load_2", "role": "default" }} , 
 	{ "name": "w4_9_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9_load_2", "role": "default" }} , 
 	{ "name": "w4_11_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11_load_2", "role": "default" }} , 
 	{ "name": "w4_13_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13_load_2", "role": "default" }} , 
 	{ "name": "w4_15_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15_load_2", "role": "default" }} , 
 	{ "name": "w4_1_load_3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1_load_3", "role": "default" }} , 
 	{ "name": "w4_3_load_3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3_load_3", "role": "default" }} , 
 	{ "name": "w4_5_load_3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5_load_3", "role": "default" }} , 
 	{ "name": "w4_7_load_3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7_load_3", "role": "default" }} , 
 	{ "name": "w4_9_load_3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9_load_3", "role": "default" }} , 
 	{ "name": "w4_11_load_3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11_load_3", "role": "default" }} , 
 	{ "name": "w4_13_load_3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13_load_3", "role": "default" }} , 
 	{ "name": "w4_15_load_3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15_load_3", "role": "default" }} , 
 	{ "name": "w4_1_load_4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1_load_4", "role": "default" }} , 
 	{ "name": "w4_3_load_4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3_load_4", "role": "default" }} , 
 	{ "name": "w4_5_load_4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5_load_4", "role": "default" }} , 
 	{ "name": "w4_7_load_4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7_load_4", "role": "default" }} , 
 	{ "name": "w4_9_load_4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9_load_4", "role": "default" }} , 
 	{ "name": "w4_11_load_4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11_load_4", "role": "default" }} , 
 	{ "name": "w4_13_load_4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13_load_4", "role": "default" }} , 
 	{ "name": "w4_15_load_4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15_load_4", "role": "default" }} , 
 	{ "name": "w4_1_load_5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1_load_5", "role": "default" }} , 
 	{ "name": "w4_3_load_5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3_load_5", "role": "default" }} , 
 	{ "name": "w4_5_load_5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5_load_5", "role": "default" }} , 
 	{ "name": "w4_7_load_5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7_load_5", "role": "default" }} , 
 	{ "name": "w4_9_load_5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9_load_5", "role": "default" }} , 
 	{ "name": "w4_11_load_5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11_load_5", "role": "default" }} , 
 	{ "name": "w4_13_load_5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13_load_5", "role": "default" }} , 
 	{ "name": "w4_15_load_5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15_load_5", "role": "default" }} , 
 	{ "name": "w4_1_load_6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1_load_6", "role": "default" }} , 
 	{ "name": "w4_3_load_6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3_load_6", "role": "default" }} , 
 	{ "name": "w4_5_load_6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5_load_6", "role": "default" }} , 
 	{ "name": "w4_7_load_6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7_load_6", "role": "default" }} , 
 	{ "name": "w4_9_load_6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9_load_6", "role": "default" }} , 
 	{ "name": "w4_11_load_6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11_load_6", "role": "default" }} , 
 	{ "name": "w4_13_load_6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13_load_6", "role": "default" }} , 
 	{ "name": "w4_15_load_6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15_load_6", "role": "default" }} , 
 	{ "name": "w4_1_load_7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1_load_7", "role": "default" }} , 
 	{ "name": "w4_3_load_7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3_load_7", "role": "default" }} , 
 	{ "name": "w4_5_load_7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5_load_7", "role": "default" }} , 
 	{ "name": "w4_7_load_7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7_load_7", "role": "default" }} , 
 	{ "name": "w4_9_load_7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9_load_7", "role": "default" }} , 
 	{ "name": "w4_11_load_7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11_load_7", "role": "default" }} , 
 	{ "name": "w4_13_load_7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13_load_7", "role": "default" }} , 
 	{ "name": "w4_15_load_7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15_load_7", "role": "default" }} , 
 	{ "name": "w4_1_load_8", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1_load_8", "role": "default" }} , 
 	{ "name": "w4_3_load_8", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3_load_8", "role": "default" }} , 
 	{ "name": "w4_5_load_8", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5_load_8", "role": "default" }} , 
 	{ "name": "w4_7_load_8", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7_load_8", "role": "default" }} , 
 	{ "name": "w4_9_load_8", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9_load_8", "role": "default" }} , 
 	{ "name": "w4_11_load_8", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11_load_8", "role": "default" }} , 
 	{ "name": "w4_13_load_8", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13_load_8", "role": "default" }} , 
 	{ "name": "w4_15_load_8", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15_load_8", "role": "default" }} , 
 	{ "name": "w4_1_load_9", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1_load_9", "role": "default" }} , 
 	{ "name": "w4_3_load_9", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3_load_9", "role": "default" }} , 
 	{ "name": "w4_5_load_9", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5_load_9", "role": "default" }} , 
 	{ "name": "w4_7_load_9", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7_load_9", "role": "default" }} , 
 	{ "name": "w4_9_load_9", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9_load_9", "role": "default" }} , 
 	{ "name": "w4_11_load_9", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11_load_9", "role": "default" }} , 
 	{ "name": "w4_13_load_9", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13_load_9", "role": "default" }} , 
 	{ "name": "w4_15_load_9", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15_load_9", "role": "default" }} , 
 	{ "name": "w4_1_load_10", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1_load_10", "role": "default" }} , 
 	{ "name": "w4_3_load_10", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3_load_10", "role": "default" }} , 
 	{ "name": "w4_5_load_10", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5_load_10", "role": "default" }} , 
 	{ "name": "w4_7_load_10", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7_load_10", "role": "default" }} , 
 	{ "name": "w4_9_load_10", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9_load_10", "role": "default" }} , 
 	{ "name": "w4_11_load_10", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11_load_10", "role": "default" }} , 
 	{ "name": "w4_13_load_10", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13_load_10", "role": "default" }} , 
 	{ "name": "w4_15_load_10", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15_load_10", "role": "default" }} , 
 	{ "name": "w4_1_load_11", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1_load_11", "role": "default" }} , 
 	{ "name": "w4_3_load_11", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3_load_11", "role": "default" }} , 
 	{ "name": "w4_5_load_11", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5_load_11", "role": "default" }} , 
 	{ "name": "w4_7_load_11", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7_load_11", "role": "default" }} , 
 	{ "name": "w4_9_load_11", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9_load_11", "role": "default" }} , 
 	{ "name": "w4_11_load_11", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11_load_11", "role": "default" }} , 
 	{ "name": "w4_13_load_11", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13_load_11", "role": "default" }} , 
 	{ "name": "w4_15_load_11", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15_load_11", "role": "default" }} , 
 	{ "name": "w4_1_load_12", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1_load_12", "role": "default" }} , 
 	{ "name": "w4_3_load_12", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3_load_12", "role": "default" }} , 
 	{ "name": "w4_5_load_12", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5_load_12", "role": "default" }} , 
 	{ "name": "w4_7_load_12", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7_load_12", "role": "default" }} , 
 	{ "name": "w4_9_load_12", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9_load_12", "role": "default" }} , 
 	{ "name": "w4_11_load_12", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11_load_12", "role": "default" }} , 
 	{ "name": "w4_13_load_12", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13_load_12", "role": "default" }} , 
 	{ "name": "w4_15_load_12", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15_load_12", "role": "default" }} , 
 	{ "name": "w4_1_load_13", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1_load_13", "role": "default" }} , 
 	{ "name": "w4_3_load_13", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3_load_13", "role": "default" }} , 
 	{ "name": "w4_5_load_13", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5_load_13", "role": "default" }} , 
 	{ "name": "w4_7_load_13", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7_load_13", "role": "default" }} , 
 	{ "name": "w4_9_load_13", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9_load_13", "role": "default" }} , 
 	{ "name": "w4_11_load_13", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11_load_13", "role": "default" }} , 
 	{ "name": "w4_13_load_13", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13_load_13", "role": "default" }} , 
 	{ "name": "w4_15_load_13", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15_load_13", "role": "default" }} , 
 	{ "name": "w4_1_load_14", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1_load_14", "role": "default" }} , 
 	{ "name": "w4_3_load_14", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3_load_14", "role": "default" }} , 
 	{ "name": "w4_5_load_14", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5_load_14", "role": "default" }} , 
 	{ "name": "w4_7_load_14", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7_load_14", "role": "default" }} , 
 	{ "name": "w4_9_load_14", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9_load_14", "role": "default" }} , 
 	{ "name": "w4_11_load_14", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11_load_14", "role": "default" }} , 
 	{ "name": "w4_13_load_14", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13_load_14", "role": "default" }} , 
 	{ "name": "w4_15_load_14", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15_load_14", "role": "default" }} , 
 	{ "name": "w4_1_load_15", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_1_load_15", "role": "default" }} , 
 	{ "name": "w4_3_load_15", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_3_load_15", "role": "default" }} , 
 	{ "name": "w4_5_load_15", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_5_load_15", "role": "default" }} , 
 	{ "name": "w4_7_load_15", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_7_load_15", "role": "default" }} , 
 	{ "name": "w4_9_load_15", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_9_load_15", "role": "default" }} , 
 	{ "name": "w4_11_load_15", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_11_load_15", "role": "default" }} , 
 	{ "name": "w4_13_load_15", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_13_load_15", "role": "default" }} , 
 	{ "name": "w4_15_load_15", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "w4_15_load_15", "role": "default" }}  ]}

set ArgLastReadFirstWriteLatency {
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
	{"Name" : "Latency", "Min" : "17", "Max" : "17"}
	, {"Name" : "Interval", "Min" : "9", "Max" : "9"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	w4_0_load { ap_none {  { w4_0_load in_data 0 8 } } }
	w4_2_load { ap_none {  { w4_2_load in_data 0 8 } } }
	w4_4_load { ap_none {  { w4_4_load in_data 0 8 } } }
	w4_6_load { ap_none {  { w4_6_load in_data 0 8 } } }
	w4_8_load { ap_none {  { w4_8_load in_data 0 8 } } }
	w4_10_load { ap_none {  { w4_10_load in_data 0 8 } } }
	w4_12_load { ap_none {  { w4_12_load in_data 0 8 } } }
	w4_14_load { ap_none {  { w4_14_load in_data 0 8 } } }
	w4_0_load_1 { ap_none {  { w4_0_load_1 in_data 0 8 } } }
	w4_2_load_1 { ap_none {  { w4_2_load_1 in_data 0 8 } } }
	w4_4_load_1 { ap_none {  { w4_4_load_1 in_data 0 8 } } }
	w4_6_load_1 { ap_none {  { w4_6_load_1 in_data 0 8 } } }
	w4_8_load_1 { ap_none {  { w4_8_load_1 in_data 0 8 } } }
	w4_10_load_1 { ap_none {  { w4_10_load_1 in_data 0 8 } } }
	w4_12_load_1 { ap_none {  { w4_12_load_1 in_data 0 8 } } }
	w4_14_load_1 { ap_none {  { w4_14_load_1 in_data 0 8 } } }
	w4_0_load_2 { ap_none {  { w4_0_load_2 in_data 0 8 } } }
	w4_2_load_2 { ap_none {  { w4_2_load_2 in_data 0 8 } } }
	w4_4_load_2 { ap_none {  { w4_4_load_2 in_data 0 8 } } }
	w4_6_load_2 { ap_none {  { w4_6_load_2 in_data 0 8 } } }
	w4_8_load_2 { ap_none {  { w4_8_load_2 in_data 0 8 } } }
	w4_10_load_2 { ap_none {  { w4_10_load_2 in_data 0 8 } } }
	w4_12_load_2 { ap_none {  { w4_12_load_2 in_data 0 8 } } }
	w4_14_load_2 { ap_none {  { w4_14_load_2 in_data 0 8 } } }
	w4_0_load_3 { ap_none {  { w4_0_load_3 in_data 0 8 } } }
	w4_2_load_3 { ap_none {  { w4_2_load_3 in_data 0 8 } } }
	w4_4_load_3 { ap_none {  { w4_4_load_3 in_data 0 8 } } }
	w4_6_load_3 { ap_none {  { w4_6_load_3 in_data 0 8 } } }
	w4_8_load_3 { ap_none {  { w4_8_load_3 in_data 0 8 } } }
	w4_10_load_3 { ap_none {  { w4_10_load_3 in_data 0 8 } } }
	w4_12_load_3 { ap_none {  { w4_12_load_3 in_data 0 8 } } }
	w4_14_load_3 { ap_none {  { w4_14_load_3 in_data 0 8 } } }
	w4_0_load_4 { ap_none {  { w4_0_load_4 in_data 0 8 } } }
	w4_2_load_4 { ap_none {  { w4_2_load_4 in_data 0 8 } } }
	w4_4_load_4 { ap_none {  { w4_4_load_4 in_data 0 8 } } }
	w4_6_load_4 { ap_none {  { w4_6_load_4 in_data 0 8 } } }
	w4_8_load_4 { ap_none {  { w4_8_load_4 in_data 0 8 } } }
	w4_10_load_4 { ap_none {  { w4_10_load_4 in_data 0 8 } } }
	w4_12_load_4 { ap_none {  { w4_12_load_4 in_data 0 8 } } }
	w4_14_load_4 { ap_none {  { w4_14_load_4 in_data 0 8 } } }
	w4_0_load_5 { ap_none {  { w4_0_load_5 in_data 0 8 } } }
	w4_2_load_5 { ap_none {  { w4_2_load_5 in_data 0 8 } } }
	w4_4_load_5 { ap_none {  { w4_4_load_5 in_data 0 8 } } }
	w4_6_load_5 { ap_none {  { w4_6_load_5 in_data 0 8 } } }
	w4_8_load_5 { ap_none {  { w4_8_load_5 in_data 0 8 } } }
	w4_10_load_5 { ap_none {  { w4_10_load_5 in_data 0 8 } } }
	w4_12_load_5 { ap_none {  { w4_12_load_5 in_data 0 8 } } }
	w4_14_load_5 { ap_none {  { w4_14_load_5 in_data 0 8 } } }
	w4_0_load_6 { ap_none {  { w4_0_load_6 in_data 0 8 } } }
	w4_2_load_6 { ap_none {  { w4_2_load_6 in_data 0 8 } } }
	w4_4_load_6 { ap_none {  { w4_4_load_6 in_data 0 8 } } }
	w4_6_load_6 { ap_none {  { w4_6_load_6 in_data 0 8 } } }
	w4_8_load_6 { ap_none {  { w4_8_load_6 in_data 0 8 } } }
	w4_10_load_6 { ap_none {  { w4_10_load_6 in_data 0 8 } } }
	w4_12_load_6 { ap_none {  { w4_12_load_6 in_data 0 8 } } }
	w4_14_load_6 { ap_none {  { w4_14_load_6 in_data 0 8 } } }
	w4_0_load_7 { ap_none {  { w4_0_load_7 in_data 0 8 } } }
	w4_2_load_7 { ap_none {  { w4_2_load_7 in_data 0 8 } } }
	w4_4_load_7 { ap_none {  { w4_4_load_7 in_data 0 8 } } }
	w4_6_load_7 { ap_none {  { w4_6_load_7 in_data 0 8 } } }
	w4_8_load_7 { ap_none {  { w4_8_load_7 in_data 0 8 } } }
	w4_10_load_7 { ap_none {  { w4_10_load_7 in_data 0 8 } } }
	w4_12_load_7 { ap_none {  { w4_12_load_7 in_data 0 8 } } }
	w4_14_load_7 { ap_none {  { w4_14_load_7 in_data 0 8 } } }
	w4_0_load_8 { ap_none {  { w4_0_load_8 in_data 0 8 } } }
	w4_2_load_8 { ap_none {  { w4_2_load_8 in_data 0 8 } } }
	w4_4_load_8 { ap_none {  { w4_4_load_8 in_data 0 8 } } }
	w4_6_load_8 { ap_none {  { w4_6_load_8 in_data 0 8 } } }
	w4_8_load_8 { ap_none {  { w4_8_load_8 in_data 0 8 } } }
	w4_10_load_8 { ap_none {  { w4_10_load_8 in_data 0 8 } } }
	w4_12_load_8 { ap_none {  { w4_12_load_8 in_data 0 8 } } }
	w4_14_load_8 { ap_none {  { w4_14_load_8 in_data 0 8 } } }
	w4_0_load_9 { ap_none {  { w4_0_load_9 in_data 0 8 } } }
	w4_2_load_9 { ap_none {  { w4_2_load_9 in_data 0 8 } } }
	w4_4_load_9 { ap_none {  { w4_4_load_9 in_data 0 8 } } }
	w4_6_load_9 { ap_none {  { w4_6_load_9 in_data 0 8 } } }
	w4_8_load_9 { ap_none {  { w4_8_load_9 in_data 0 8 } } }
	w4_10_load_9 { ap_none {  { w4_10_load_9 in_data 0 8 } } }
	w4_12_load_9 { ap_none {  { w4_12_load_9 in_data 0 8 } } }
	w4_14_load_9 { ap_none {  { w4_14_load_9 in_data 0 8 } } }
	w4_0_load_10 { ap_none {  { w4_0_load_10 in_data 0 8 } } }
	w4_2_load_10 { ap_none {  { w4_2_load_10 in_data 0 8 } } }
	w4_4_load_10 { ap_none {  { w4_4_load_10 in_data 0 8 } } }
	w4_6_load_10 { ap_none {  { w4_6_load_10 in_data 0 8 } } }
	w4_8_load_10 { ap_none {  { w4_8_load_10 in_data 0 8 } } }
	w4_10_load_10 { ap_none {  { w4_10_load_10 in_data 0 8 } } }
	w4_12_load_10 { ap_none {  { w4_12_load_10 in_data 0 8 } } }
	w4_14_load_10 { ap_none {  { w4_14_load_10 in_data 0 8 } } }
	w4_0_load_11 { ap_none {  { w4_0_load_11 in_data 0 8 } } }
	w4_2_load_11 { ap_none {  { w4_2_load_11 in_data 0 8 } } }
	w4_4_load_11 { ap_none {  { w4_4_load_11 in_data 0 8 } } }
	w4_6_load_11 { ap_none {  { w4_6_load_11 in_data 0 8 } } }
	w4_8_load_11 { ap_none {  { w4_8_load_11 in_data 0 8 } } }
	w4_10_load_11 { ap_none {  { w4_10_load_11 in_data 0 8 } } }
	w4_12_load_11 { ap_none {  { w4_12_load_11 in_data 0 8 } } }
	w4_14_load_11 { ap_none {  { w4_14_load_11 in_data 0 8 } } }
	w4_0_load_12 { ap_none {  { w4_0_load_12 in_data 0 8 } } }
	w4_2_load_12 { ap_none {  { w4_2_load_12 in_data 0 8 } } }
	w4_4_load_12 { ap_none {  { w4_4_load_12 in_data 0 8 } } }
	w4_6_load_12 { ap_none {  { w4_6_load_12 in_data 0 8 } } }
	w4_8_load_12 { ap_none {  { w4_8_load_12 in_data 0 8 } } }
	w4_10_load_12 { ap_none {  { w4_10_load_12 in_data 0 8 } } }
	w4_12_load_12 { ap_none {  { w4_12_load_12 in_data 0 8 } } }
	w4_14_load_12 { ap_none {  { w4_14_load_12 in_data 0 8 } } }
	w4_0_load_13 { ap_none {  { w4_0_load_13 in_data 0 8 } } }
	w4_2_load_13 { ap_none {  { w4_2_load_13 in_data 0 8 } } }
	w4_4_load_13 { ap_none {  { w4_4_load_13 in_data 0 8 } } }
	w4_6_load_13 { ap_none {  { w4_6_load_13 in_data 0 8 } } }
	w4_8_load_13 { ap_none {  { w4_8_load_13 in_data 0 8 } } }
	w4_10_load_13 { ap_none {  { w4_10_load_13 in_data 0 8 } } }
	w4_12_load_13 { ap_none {  { w4_12_load_13 in_data 0 8 } } }
	w4_14_load_13 { ap_none {  { w4_14_load_13 in_data 0 8 } } }
	w4_0_load_14 { ap_none {  { w4_0_load_14 in_data 0 8 } } }
	w4_2_load_14 { ap_none {  { w4_2_load_14 in_data 0 8 } } }
	w4_4_load_14 { ap_none {  { w4_4_load_14 in_data 0 8 } } }
	w4_6_load_14 { ap_none {  { w4_6_load_14 in_data 0 8 } } }
	w4_8_load_14 { ap_none {  { w4_8_load_14 in_data 0 8 } } }
	w4_10_load_14 { ap_none {  { w4_10_load_14 in_data 0 8 } } }
	w4_12_load_14 { ap_none {  { w4_12_load_14 in_data 0 8 } } }
	w4_14_load_14 { ap_none {  { w4_14_load_14 in_data 0 8 } } }
	w4_0_load_15 { ap_none {  { w4_0_load_15 in_data 0 8 } } }
	w4_2_load_15 { ap_none {  { w4_2_load_15 in_data 0 8 } } }
	w4_4_load_15 { ap_none {  { w4_4_load_15 in_data 0 8 } } }
	w4_6_load_15 { ap_none {  { w4_6_load_15 in_data 0 8 } } }
	w4_8_load_15 { ap_none {  { w4_8_load_15 in_data 0 8 } } }
	w4_10_load_15 { ap_none {  { w4_10_load_15 in_data 0 8 } } }
	w4_12_load_15 { ap_none {  { w4_12_load_15 in_data 0 8 } } }
	w4_14_load_15 { ap_none {  { w4_14_load_15 in_data 0 8 } } }
	sext_ln160_15 { ap_none {  { sext_ln160_15 in_data 0 8 } } }
	sext_ln160_14 { ap_none {  { sext_ln160_14 in_data 0 8 } } }
	sext_ln160_13 { ap_none {  { sext_ln160_13 in_data 0 8 } } }
	sext_ln160_12 { ap_none {  { sext_ln160_12 in_data 0 8 } } }
	sext_ln160_11 { ap_none {  { sext_ln160_11 in_data 0 8 } } }
	sext_ln160_10 { ap_none {  { sext_ln160_10 in_data 0 8 } } }
	sext_ln160_9 { ap_none {  { sext_ln160_9 in_data 0 8 } } }
	sext_ln160_8 { ap_none {  { sext_ln160_8 in_data 0 8 } } }
	sext_ln160_7 { ap_none {  { sext_ln160_7 in_data 0 8 } } }
	sext_ln160_6 { ap_none {  { sext_ln160_6 in_data 0 8 } } }
	sext_ln160_5 { ap_none {  { sext_ln160_5 in_data 0 8 } } }
	sext_ln160_4 { ap_none {  { sext_ln160_4 in_data 0 8 } } }
	sext_ln160_3 { ap_none {  { sext_ln160_3 in_data 0 8 } } }
	sext_ln160_2 { ap_none {  { sext_ln160_2 in_data 0 8 } } }
	sext_ln160 { ap_none {  { sext_ln160 in_data 0 8 } } }
	sext_ln160_1 { ap_none {  { sext_ln160_1 in_data 0 8 } } }
	w4_1_load { ap_none {  { w4_1_load in_data 0 8 } } }
	w4_3_load { ap_none {  { w4_3_load in_data 0 8 } } }
	w4_5_load { ap_none {  { w4_5_load in_data 0 8 } } }
	w4_7_load { ap_none {  { w4_7_load in_data 0 8 } } }
	w4_9_load { ap_none {  { w4_9_load in_data 0 8 } } }
	w4_11_load { ap_none {  { w4_11_load in_data 0 8 } } }
	w4_13_load { ap_none {  { w4_13_load in_data 0 8 } } }
	w4_15_load { ap_none {  { w4_15_load in_data 0 8 } } }
	w4_1_load_1 { ap_none {  { w4_1_load_1 in_data 0 8 } } }
	w4_3_load_1 { ap_none {  { w4_3_load_1 in_data 0 8 } } }
	w4_5_load_1 { ap_none {  { w4_5_load_1 in_data 0 8 } } }
	w4_7_load_1 { ap_none {  { w4_7_load_1 in_data 0 8 } } }
	w4_9_load_1 { ap_none {  { w4_9_load_1 in_data 0 8 } } }
	w4_11_load_1 { ap_none {  { w4_11_load_1 in_data 0 8 } } }
	w4_13_load_1 { ap_none {  { w4_13_load_1 in_data 0 8 } } }
	w4_15_load_1 { ap_none {  { w4_15_load_1 in_data 0 8 } } }
	w4_1_load_2 { ap_none {  { w4_1_load_2 in_data 0 8 } } }
	w4_3_load_2 { ap_none {  { w4_3_load_2 in_data 0 8 } } }
	w4_5_load_2 { ap_none {  { w4_5_load_2 in_data 0 8 } } }
	w4_7_load_2 { ap_none {  { w4_7_load_2 in_data 0 8 } } }
	w4_9_load_2 { ap_none {  { w4_9_load_2 in_data 0 8 } } }
	w4_11_load_2 { ap_none {  { w4_11_load_2 in_data 0 8 } } }
	w4_13_load_2 { ap_none {  { w4_13_load_2 in_data 0 8 } } }
	w4_15_load_2 { ap_none {  { w4_15_load_2 in_data 0 8 } } }
	w4_1_load_3 { ap_none {  { w4_1_load_3 in_data 0 8 } } }
	w4_3_load_3 { ap_none {  { w4_3_load_3 in_data 0 8 } } }
	w4_5_load_3 { ap_none {  { w4_5_load_3 in_data 0 8 } } }
	w4_7_load_3 { ap_none {  { w4_7_load_3 in_data 0 8 } } }
	w4_9_load_3 { ap_none {  { w4_9_load_3 in_data 0 8 } } }
	w4_11_load_3 { ap_none {  { w4_11_load_3 in_data 0 8 } } }
	w4_13_load_3 { ap_none {  { w4_13_load_3 in_data 0 8 } } }
	w4_15_load_3 { ap_none {  { w4_15_load_3 in_data 0 8 } } }
	w4_1_load_4 { ap_none {  { w4_1_load_4 in_data 0 8 } } }
	w4_3_load_4 { ap_none {  { w4_3_load_4 in_data 0 8 } } }
	w4_5_load_4 { ap_none {  { w4_5_load_4 in_data 0 8 } } }
	w4_7_load_4 { ap_none {  { w4_7_load_4 in_data 0 8 } } }
	w4_9_load_4 { ap_none {  { w4_9_load_4 in_data 0 8 } } }
	w4_11_load_4 { ap_none {  { w4_11_load_4 in_data 0 8 } } }
	w4_13_load_4 { ap_none {  { w4_13_load_4 in_data 0 8 } } }
	w4_15_load_4 { ap_none {  { w4_15_load_4 in_data 0 8 } } }
	w4_1_load_5 { ap_none {  { w4_1_load_5 in_data 0 8 } } }
	w4_3_load_5 { ap_none {  { w4_3_load_5 in_data 0 8 } } }
	w4_5_load_5 { ap_none {  { w4_5_load_5 in_data 0 8 } } }
	w4_7_load_5 { ap_none {  { w4_7_load_5 in_data 0 8 } } }
	w4_9_load_5 { ap_none {  { w4_9_load_5 in_data 0 8 } } }
	w4_11_load_5 { ap_none {  { w4_11_load_5 in_data 0 8 } } }
	w4_13_load_5 { ap_none {  { w4_13_load_5 in_data 0 8 } } }
	w4_15_load_5 { ap_none {  { w4_15_load_5 in_data 0 8 } } }
	w4_1_load_6 { ap_none {  { w4_1_load_6 in_data 0 8 } } }
	w4_3_load_6 { ap_none {  { w4_3_load_6 in_data 0 8 } } }
	w4_5_load_6 { ap_none {  { w4_5_load_6 in_data 0 8 } } }
	w4_7_load_6 { ap_none {  { w4_7_load_6 in_data 0 8 } } }
	w4_9_load_6 { ap_none {  { w4_9_load_6 in_data 0 8 } } }
	w4_11_load_6 { ap_none {  { w4_11_load_6 in_data 0 8 } } }
	w4_13_load_6 { ap_none {  { w4_13_load_6 in_data 0 8 } } }
	w4_15_load_6 { ap_none {  { w4_15_load_6 in_data 0 8 } } }
	w4_1_load_7 { ap_none {  { w4_1_load_7 in_data 0 8 } } }
	w4_3_load_7 { ap_none {  { w4_3_load_7 in_data 0 8 } } }
	w4_5_load_7 { ap_none {  { w4_5_load_7 in_data 0 8 } } }
	w4_7_load_7 { ap_none {  { w4_7_load_7 in_data 0 8 } } }
	w4_9_load_7 { ap_none {  { w4_9_load_7 in_data 0 8 } } }
	w4_11_load_7 { ap_none {  { w4_11_load_7 in_data 0 8 } } }
	w4_13_load_7 { ap_none {  { w4_13_load_7 in_data 0 8 } } }
	w4_15_load_7 { ap_none {  { w4_15_load_7 in_data 0 8 } } }
	w4_1_load_8 { ap_none {  { w4_1_load_8 in_data 0 8 } } }
	w4_3_load_8 { ap_none {  { w4_3_load_8 in_data 0 8 } } }
	w4_5_load_8 { ap_none {  { w4_5_load_8 in_data 0 8 } } }
	w4_7_load_8 { ap_none {  { w4_7_load_8 in_data 0 8 } } }
	w4_9_load_8 { ap_none {  { w4_9_load_8 in_data 0 8 } } }
	w4_11_load_8 { ap_none {  { w4_11_load_8 in_data 0 8 } } }
	w4_13_load_8 { ap_none {  { w4_13_load_8 in_data 0 8 } } }
	w4_15_load_8 { ap_none {  { w4_15_load_8 in_data 0 8 } } }
	w4_1_load_9 { ap_none {  { w4_1_load_9 in_data 0 8 } } }
	w4_3_load_9 { ap_none {  { w4_3_load_9 in_data 0 8 } } }
	w4_5_load_9 { ap_none {  { w4_5_load_9 in_data 0 8 } } }
	w4_7_load_9 { ap_none {  { w4_7_load_9 in_data 0 8 } } }
	w4_9_load_9 { ap_none {  { w4_9_load_9 in_data 0 8 } } }
	w4_11_load_9 { ap_none {  { w4_11_load_9 in_data 0 8 } } }
	w4_13_load_9 { ap_none {  { w4_13_load_9 in_data 0 8 } } }
	w4_15_load_9 { ap_none {  { w4_15_load_9 in_data 0 8 } } }
	w4_1_load_10 { ap_none {  { w4_1_load_10 in_data 0 8 } } }
	w4_3_load_10 { ap_none {  { w4_3_load_10 in_data 0 8 } } }
	w4_5_load_10 { ap_none {  { w4_5_load_10 in_data 0 8 } } }
	w4_7_load_10 { ap_none {  { w4_7_load_10 in_data 0 8 } } }
	w4_9_load_10 { ap_none {  { w4_9_load_10 in_data 0 8 } } }
	w4_11_load_10 { ap_none {  { w4_11_load_10 in_data 0 8 } } }
	w4_13_load_10 { ap_none {  { w4_13_load_10 in_data 0 8 } } }
	w4_15_load_10 { ap_none {  { w4_15_load_10 in_data 0 8 } } }
	w4_1_load_11 { ap_none {  { w4_1_load_11 in_data 0 8 } } }
	w4_3_load_11 { ap_none {  { w4_3_load_11 in_data 0 8 } } }
	w4_5_load_11 { ap_none {  { w4_5_load_11 in_data 0 8 } } }
	w4_7_load_11 { ap_none {  { w4_7_load_11 in_data 0 8 } } }
	w4_9_load_11 { ap_none {  { w4_9_load_11 in_data 0 8 } } }
	w4_11_load_11 { ap_none {  { w4_11_load_11 in_data 0 8 } } }
	w4_13_load_11 { ap_none {  { w4_13_load_11 in_data 0 8 } } }
	w4_15_load_11 { ap_none {  { w4_15_load_11 in_data 0 8 } } }
	w4_1_load_12 { ap_none {  { w4_1_load_12 in_data 0 8 } } }
	w4_3_load_12 { ap_none {  { w4_3_load_12 in_data 0 8 } } }
	w4_5_load_12 { ap_none {  { w4_5_load_12 in_data 0 8 } } }
	w4_7_load_12 { ap_none {  { w4_7_load_12 in_data 0 8 } } }
	w4_9_load_12 { ap_none {  { w4_9_load_12 in_data 0 8 } } }
	w4_11_load_12 { ap_none {  { w4_11_load_12 in_data 0 8 } } }
	w4_13_load_12 { ap_none {  { w4_13_load_12 in_data 0 8 } } }
	w4_15_load_12 { ap_none {  { w4_15_load_12 in_data 0 8 } } }
	w4_1_load_13 { ap_none {  { w4_1_load_13 in_data 0 8 } } }
	w4_3_load_13 { ap_none {  { w4_3_load_13 in_data 0 8 } } }
	w4_5_load_13 { ap_none {  { w4_5_load_13 in_data 0 8 } } }
	w4_7_load_13 { ap_none {  { w4_7_load_13 in_data 0 8 } } }
	w4_9_load_13 { ap_none {  { w4_9_load_13 in_data 0 8 } } }
	w4_11_load_13 { ap_none {  { w4_11_load_13 in_data 0 8 } } }
	w4_13_load_13 { ap_none {  { w4_13_load_13 in_data 0 8 } } }
	w4_15_load_13 { ap_none {  { w4_15_load_13 in_data 0 8 } } }
	w4_1_load_14 { ap_none {  { w4_1_load_14 in_data 0 8 } } }
	w4_3_load_14 { ap_none {  { w4_3_load_14 in_data 0 8 } } }
	w4_5_load_14 { ap_none {  { w4_5_load_14 in_data 0 8 } } }
	w4_7_load_14 { ap_none {  { w4_7_load_14 in_data 0 8 } } }
	w4_9_load_14 { ap_none {  { w4_9_load_14 in_data 0 8 } } }
	w4_11_load_14 { ap_none {  { w4_11_load_14 in_data 0 8 } } }
	w4_13_load_14 { ap_none {  { w4_13_load_14 in_data 0 8 } } }
	w4_15_load_14 { ap_none {  { w4_15_load_14 in_data 0 8 } } }
	w4_1_load_15 { ap_none {  { w4_1_load_15 in_data 0 8 } } }
	w4_3_load_15 { ap_none {  { w4_3_load_15 in_data 0 8 } } }
	w4_5_load_15 { ap_none {  { w4_5_load_15 in_data 0 8 } } }
	w4_7_load_15 { ap_none {  { w4_7_load_15 in_data 0 8 } } }
	w4_9_load_15 { ap_none {  { w4_9_load_15 in_data 0 8 } } }
	w4_11_load_15 { ap_none {  { w4_11_load_15 in_data 0 8 } } }
	w4_13_load_15 { ap_none {  { w4_13_load_15 in_data 0 8 } } }
	w4_15_load_15 { ap_none {  { w4_15_load_15 in_data 0 8 } } }
	s_gemm4_out { ap_fifo {  { s_gemm4_out_din fifo_data_out 1 16 }  { s_gemm4_out_full_n fifo_status_empty 0 1 }  { s_gemm4_out_write fifo_data_in 1 1 }  { s_gemm4_out_num_data_valid fifo_update 0 32 }  { s_gemm4_out_fifo_cap fifo_data 0 32 } } }
}
