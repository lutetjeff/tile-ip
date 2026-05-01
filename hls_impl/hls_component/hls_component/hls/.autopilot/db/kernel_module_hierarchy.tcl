set ModuleHierarchy {[{
"Name" : "transformer_top", "RefName" : "transformer_top","ID" : "0","Type" : "dataflow",
"SubInsts" : [
	{"Name" : "fan_out_8_U0", "RefName" : "fan_out_8","ID" : "1","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_53_1","RefName" : "VITIS_LOOP_53_1","ID" : "2","Type" : "pipeline"},]},
	{"Name" : "fifo_1_U0", "RefName" : "fifo_1","ID" : "3","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_66_1","RefName" : "VITIS_LOOP_66_1","ID" : "4","Type" : "pipeline"},]},
	{"Name" : "stateful_norm_2_U0", "RefName" : "stateful_norm_2","ID" : "5","Type" : "sequential",
		"SubInsts" : [
		{"Name" : "grp_stateful_norm_2_Pipeline_VITIS_LOOP_85_1_fu_96", "RefName" : "stateful_norm_2_Pipeline_VITIS_LOOP_85_1","ID" : "6","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_85_1","RefName" : "VITIS_LOOP_85_1","ID" : "7","Type" : "pipeline"},]},
		{"Name" : "grp_stateful_norm_2_Pipeline_VITIS_LOOP_109_3_fu_119", "RefName" : "stateful_norm_2_Pipeline_VITIS_LOOP_109_3","ID" : "8","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_109_3","RefName" : "VITIS_LOOP_109_3","ID" : "9","Type" : "pipeline"},]},]},
	{"Name" : "gemm_U0", "RefName" : "gemm","ID" : "10","Type" : "sequential",
		"SubInsts" : [
		{"Name" : "grp_gemm_Pipeline_VITIS_LOOP_139_1_fu_2598", "RefName" : "gemm_Pipeline_VITIS_LOOP_139_1","ID" : "11","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_139_1","RefName" : "VITIS_LOOP_139_1","ID" : "12","Type" : "pipeline"},]},
		{"Name" : "grp_gemm_Pipeline_VITIS_LOOP_151_3_fu_2620", "RefName" : "gemm_Pipeline_VITIS_LOOP_151_3","ID" : "13","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_151_3","RefName" : "VITIS_LOOP_151_3","ID" : "14","Type" : "pipeline"},]},]},
	{"Name" : "stateful_softmax_U0", "RefName" : "stateful_softmax","ID" : "15","Type" : "sequential",
		"SubInsts" : [
		{"Name" : "grp_stateful_softmax_Pipeline_VITIS_LOOP_188_1_fu_273", "RefName" : "stateful_softmax_Pipeline_VITIS_LOOP_188_1","ID" : "16","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_188_1","RefName" : "VITIS_LOOP_188_1","ID" : "17","Type" : "pipeline"},]},
		{"Name" : "grp_stateful_softmax_Pipeline_VITIS_LOOP_217_4_fu_296", "RefName" : "stateful_softmax_Pipeline_VITIS_LOOP_217_4","ID" : "18","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_217_4","RefName" : "VITIS_LOOP_217_4","ID" : "19","Type" : "pipeline"},]},]},
	{"Name" : "gemm_5_U0", "RefName" : "gemm_5","ID" : "20","Type" : "sequential",
		"SubInsts" : [
		{"Name" : "grp_gemm_5_Pipeline_VITIS_LOOP_139_1_fu_2598", "RefName" : "gemm_5_Pipeline_VITIS_LOOP_139_1","ID" : "21","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_139_1","RefName" : "VITIS_LOOP_139_1","ID" : "22","Type" : "pipeline"},]},
		{"Name" : "grp_gemm_5_Pipeline_VITIS_LOOP_151_3_fu_2620", "RefName" : "gemm_5_Pipeline_VITIS_LOOP_151_3","ID" : "23","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_151_3","RefName" : "VITIS_LOOP_151_3","ID" : "24","Type" : "pipeline"},]},]},
	{"Name" : "alu_add_3_U0", "RefName" : "alu_add_3","ID" : "25","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_256_1","RefName" : "VITIS_LOOP_256_1","ID" : "26","Type" : "pipeline"},]},
	{"Name" : "fifo_4_U0", "RefName" : "fifo_4","ID" : "27","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_66_1","RefName" : "VITIS_LOOP_66_1","ID" : "28","Type" : "pipeline"},]},
	{"Name" : "fan_out_U0", "RefName" : "fan_out","ID" : "29","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_53_1","RefName" : "VITIS_LOOP_53_1","ID" : "30","Type" : "pipeline"},]},
	{"Name" : "fifo_U0", "RefName" : "fifo","ID" : "31","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_66_1","RefName" : "VITIS_LOOP_66_1","ID" : "32","Type" : "pipeline"},]},
	{"Name" : "stateful_norm_U0", "RefName" : "stateful_norm","ID" : "33","Type" : "sequential",
		"SubInsts" : [
		{"Name" : "grp_stateful_norm_Pipeline_VITIS_LOOP_85_1_fu_96", "RefName" : "stateful_norm_Pipeline_VITIS_LOOP_85_1","ID" : "34","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_85_1","RefName" : "VITIS_LOOP_85_1","ID" : "35","Type" : "pipeline"},]},
		{"Name" : "grp_stateful_norm_Pipeline_VITIS_LOOP_109_3_fu_119", "RefName" : "stateful_norm_Pipeline_VITIS_LOOP_109_3","ID" : "36","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_109_3","RefName" : "VITIS_LOOP_109_3","ID" : "37","Type" : "pipeline"},]},]},
	{"Name" : "gemm_6_U0", "RefName" : "gemm_6","ID" : "38","Type" : "sequential",
		"SubInsts" : [
		{"Name" : "grp_gemm_6_Pipeline_VITIS_LOOP_139_1_fu_2598", "RefName" : "gemm_6_Pipeline_VITIS_LOOP_139_1","ID" : "39","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_139_1","RefName" : "VITIS_LOOP_139_1","ID" : "40","Type" : "pipeline"},]},
		{"Name" : "grp_gemm_6_Pipeline_VITIS_LOOP_151_3_fu_2620", "RefName" : "gemm_6_Pipeline_VITIS_LOOP_151_3","ID" : "41","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_151_3","RefName" : "VITIS_LOOP_151_3","ID" : "42","Type" : "pipeline"},]},]},
	{"Name" : "activation_relu_U0", "RefName" : "activation_relu","ID" : "43","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_236_1","RefName" : "VITIS_LOOP_236_1","ID" : "44","Type" : "pipeline"},]},
	{"Name" : "gemm_7_U0", "RefName" : "gemm_7","ID" : "45","Type" : "sequential",
		"SubInsts" : [
		{"Name" : "grp_gemm_7_Pipeline_VITIS_LOOP_139_1_fu_2598", "RefName" : "gemm_7_Pipeline_VITIS_LOOP_139_1","ID" : "46","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_139_1","RefName" : "VITIS_LOOP_139_1","ID" : "47","Type" : "pipeline"},]},
		{"Name" : "grp_gemm_7_Pipeline_VITIS_LOOP_151_3_fu_2620", "RefName" : "gemm_7_Pipeline_VITIS_LOOP_151_3","ID" : "48","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_151_3","RefName" : "VITIS_LOOP_151_3","ID" : "49","Type" : "pipeline"},]},]},
	{"Name" : "alu_add_U0", "RefName" : "alu_add","ID" : "50","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_256_1","RefName" : "VITIS_LOOP_256_1","ID" : "51","Type" : "pipeline"},]},
	{"Name" : "fifo_9_U0", "RefName" : "fifo_9","ID" : "52","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_66_1","RefName" : "VITIS_LOOP_66_1","ID" : "53","Type" : "pipeline"},]},]
}]}