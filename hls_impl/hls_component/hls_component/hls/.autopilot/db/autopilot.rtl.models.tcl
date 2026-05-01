set SynModuleInfo {
  {SRCNAME fan_out.8 MODELNAME fan_out_8 RTLNAME transformer_top_fan_out_8
    SUBMODULES {
      {MODELNAME transformer_top_regslice_both RTLNAME transformer_top_regslice_both BINDTYPE interface TYPE adapter IMPL reg_slice}
      {MODELNAME transformer_top_flow_control_loop_pipe RTLNAME transformer_top_flow_control_loop_pipe BINDTYPE interface TYPE internal_upc_flow_control INSTNAME transformer_top_flow_control_loop_pipe_U}
    }
  }
  {SRCNAME fifo.1 MODELNAME fifo_1 RTLNAME transformer_top_fifo_1}
  {SRCNAME stateful_norm.2_Pipeline_VITIS_LOOP_85_1 MODELNAME stateful_norm_2_Pipeline_VITIS_LOOP_85_1 RTLNAME transformer_top_stateful_norm_2_Pipeline_VITIS_LOOP_85_1
    SUBMODULES {
      {MODELNAME transformer_top_flow_control_loop_pipe_sequential_init RTLNAME transformer_top_flow_control_loop_pipe_sequential_init BINDTYPE interface TYPE internal_upc_flow_control INSTNAME transformer_top_flow_control_loop_pipe_sequential_init_U}
    }
  }
  {SRCNAME stateful_norm.2_Pipeline_VITIS_LOOP_109_3 MODELNAME stateful_norm_2_Pipeline_VITIS_LOOP_109_3 RTLNAME transformer_top_stateful_norm_2_Pipeline_VITIS_LOOP_109_3
    SUBMODULES {
      {MODELNAME transformer_top_sparsemux_17_3_8_1_1 RTLNAME transformer_top_sparsemux_17_3_8_1_1 BINDTYPE op TYPE sparsemux IMPL compactencoding_dontcare}
    }
  }
  {SRCNAME stateful_norm.2 MODELNAME stateful_norm_2 RTLNAME transformer_top_stateful_norm_2}
  {SRCNAME gemm_Pipeline_VITIS_LOOP_139_1 MODELNAME gemm_Pipeline_VITIS_LOOP_139_1 RTLNAME transformer_top_gemm_Pipeline_VITIS_LOOP_139_1}
  {SRCNAME gemm_Pipeline_VITIS_LOOP_151_3 MODELNAME gemm_Pipeline_VITIS_LOOP_151_3 RTLNAME transformer_top_gemm_Pipeline_VITIS_LOOP_151_3
    SUBMODULES {
      {MODELNAME transformer_top_mul_8s_8s_16_1_1 RTLNAME transformer_top_mul_8s_8s_16_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME transformer_top_mac_muladd_8s_8s_16s_17_4_1 RTLNAME transformer_top_mac_muladd_8s_8s_16s_17_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME transformer_top_mac_muladd_8s_8s_17s_17_4_1 RTLNAME transformer_top_mac_muladd_8s_8s_17s_17_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME transformer_top_mac_muladd_8s_8s_17s_18_4_1 RTLNAME transformer_top_mac_muladd_8s_8s_17s_18_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME transformer_top_mac_muladd_8s_8s_18s_19_4_1 RTLNAME transformer_top_mac_muladd_8s_8s_18s_19_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME transformer_top_mac_muladd_8s_8s_19s_20_4_1 RTLNAME transformer_top_mac_muladd_8s_8s_19s_20_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
    }
  }
  {SRCNAME gemm MODELNAME gemm RTLNAME transformer_top_gemm}
  {SRCNAME stateful_softmax_Pipeline_VITIS_LOOP_188_1 MODELNAME stateful_softmax_Pipeline_VITIS_LOOP_188_1 RTLNAME transformer_top_stateful_softmax_Pipeline_VITIS_LOOP_188_1}
  {SRCNAME stateful_softmax_Pipeline_VITIS_LOOP_217_4 MODELNAME stateful_softmax_Pipeline_VITIS_LOOP_217_4 RTLNAME transformer_top_stateful_softmax_Pipeline_VITIS_LOOP_217_4
    SUBMODULES {
      {MODELNAME transformer_top_sparsemux_17_3_9_1_1 RTLNAME transformer_top_sparsemux_17_3_9_1_1 BINDTYPE op TYPE sparsemux IMPL compactencoding_dontcare}
      {MODELNAME transformer_top_udiv_17ns_13ns_17_21_1 RTLNAME transformer_top_udiv_17ns_13ns_17_21_1 BINDTYPE op TYPE udiv IMPL auto LATENCY 20 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME stateful_softmax MODELNAME stateful_softmax RTLNAME transformer_top_stateful_softmax
    SUBMODULES {
      {MODELNAME transformer_top_stateful_softmax_EXP_LUT_ROM_AUTO_1R RTLNAME transformer_top_stateful_softmax_EXP_LUT_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME gemm.5_Pipeline_VITIS_LOOP_139_1 MODELNAME gemm_5_Pipeline_VITIS_LOOP_139_1 RTLNAME transformer_top_gemm_5_Pipeline_VITIS_LOOP_139_1}
  {SRCNAME gemm.5_Pipeline_VITIS_LOOP_151_3 MODELNAME gemm_5_Pipeline_VITIS_LOOP_151_3 RTLNAME transformer_top_gemm_5_Pipeline_VITIS_LOOP_151_3}
  {SRCNAME gemm.5 MODELNAME gemm_5 RTLNAME transformer_top_gemm_5}
  {SRCNAME alu_add.3 MODELNAME alu_add_3 RTLNAME transformer_top_alu_add_3}
  {SRCNAME fifo.4 MODELNAME fifo_4 RTLNAME transformer_top_fifo_4}
  {SRCNAME fan_out MODELNAME fan_out RTLNAME transformer_top_fan_out}
  {SRCNAME fifo MODELNAME fifo RTLNAME transformer_top_fifo}
  {SRCNAME stateful_norm_Pipeline_VITIS_LOOP_85_1 MODELNAME stateful_norm_Pipeline_VITIS_LOOP_85_1 RTLNAME transformer_top_stateful_norm_Pipeline_VITIS_LOOP_85_1}
  {SRCNAME stateful_norm_Pipeline_VITIS_LOOP_109_3 MODELNAME stateful_norm_Pipeline_VITIS_LOOP_109_3 RTLNAME transformer_top_stateful_norm_Pipeline_VITIS_LOOP_109_3}
  {SRCNAME stateful_norm MODELNAME stateful_norm RTLNAME transformer_top_stateful_norm}
  {SRCNAME gemm.6_Pipeline_VITIS_LOOP_139_1 MODELNAME gemm_6_Pipeline_VITIS_LOOP_139_1 RTLNAME transformer_top_gemm_6_Pipeline_VITIS_LOOP_139_1}
  {SRCNAME gemm.6_Pipeline_VITIS_LOOP_151_3 MODELNAME gemm_6_Pipeline_VITIS_LOOP_151_3 RTLNAME transformer_top_gemm_6_Pipeline_VITIS_LOOP_151_3}
  {SRCNAME gemm.6 MODELNAME gemm_6 RTLNAME transformer_top_gemm_6}
  {SRCNAME activation_relu MODELNAME activation_relu RTLNAME transformer_top_activation_relu}
  {SRCNAME gemm.7_Pipeline_VITIS_LOOP_139_1 MODELNAME gemm_7_Pipeline_VITIS_LOOP_139_1 RTLNAME transformer_top_gemm_7_Pipeline_VITIS_LOOP_139_1}
  {SRCNAME gemm.7_Pipeline_VITIS_LOOP_151_3 MODELNAME gemm_7_Pipeline_VITIS_LOOP_151_3 RTLNAME transformer_top_gemm_7_Pipeline_VITIS_LOOP_151_3}
  {SRCNAME gemm.7 MODELNAME gemm_7 RTLNAME transformer_top_gemm_7}
  {SRCNAME alu_add MODELNAME alu_add RTLNAME transformer_top_alu_add}
  {SRCNAME fifo.9 MODELNAME fifo_9 RTLNAME transformer_top_fifo_9}
  {SRCNAME transformer_top MODELNAME transformer_top RTLNAME transformer_top IS_TOP 1
    SUBMODULES {
      {MODELNAME transformer_top_fifo_w16_d80_A RTLNAME transformer_top_fifo_w16_d80_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME s_fifo1_U}
      {MODELNAME transformer_top_fifo_w16_d2_S RTLNAME transformer_top_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME s_norm1_in_U}
      {MODELNAME transformer_top_fifo_w16_d2_S RTLNAME transformer_top_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME s_fifo1_out_U}
      {MODELNAME transformer_top_fifo_w16_d2_S RTLNAME transformer_top_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME s_norm1_out_U}
      {MODELNAME transformer_top_fifo_w16_d2_S RTLNAME transformer_top_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME s_gemm1_out_U}
      {MODELNAME transformer_top_fifo_w16_d2_S RTLNAME transformer_top_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME s_softmax_out_U}
      {MODELNAME transformer_top_fifo_w16_d2_S RTLNAME transformer_top_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME s_gemm2_out_U}
      {MODELNAME transformer_top_fifo_w16_d2_S RTLNAME transformer_top_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME s_alu1_U}
      {MODELNAME transformer_top_fifo_w16_d48_S RTLNAME transformer_top_fifo_w16_d48_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME s_alu1_fifo_U}
      {MODELNAME transformer_top_fifo_w16_d48_S RTLNAME transformer_top_fifo_w16_d48_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME s_fifo2_U}
      {MODELNAME transformer_top_fifo_w16_d2_S RTLNAME transformer_top_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME s_norm2_in_U}
      {MODELNAME transformer_top_fifo_w16_d2_S RTLNAME transformer_top_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME s_fifo2_out_U}
      {MODELNAME transformer_top_fifo_w16_d2_S RTLNAME transformer_top_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME s_norm2_out_U}
      {MODELNAME transformer_top_fifo_w16_d2_S RTLNAME transformer_top_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME s_gemm3_out_U}
      {MODELNAME transformer_top_fifo_w16_d2_S RTLNAME transformer_top_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME s_relu_out_U}
      {MODELNAME transformer_top_fifo_w16_d2_S RTLNAME transformer_top_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME s_gemm4_out_U}
      {MODELNAME transformer_top_fifo_w16_d32_S RTLNAME transformer_top_fifo_w16_d32_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME s_alu2_fifo_U}
      {MODELNAME transformer_top_start_for_fifo_1_U0 RTLNAME transformer_top_start_for_fifo_1_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_fifo_1_U0_U}
      {MODELNAME transformer_top_start_for_stateful_norm_2_U0 RTLNAME transformer_top_start_for_stateful_norm_2_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_stateful_norm_2_U0_U}
      {MODELNAME transformer_top_start_for_stateful_softmax_U0 RTLNAME transformer_top_start_for_stateful_softmax_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_stateful_softmax_U0_U}
      {MODELNAME transformer_top_start_for_alu_add_3_U0 RTLNAME transformer_top_start_for_alu_add_3_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_alu_add_3_U0_U}
      {MODELNAME transformer_top_start_for_fifo_4_U0 RTLNAME transformer_top_start_for_fifo_4_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_fifo_4_U0_U}
      {MODELNAME transformer_top_start_for_fan_out_U0 RTLNAME transformer_top_start_for_fan_out_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_fan_out_U0_U}
      {MODELNAME transformer_top_start_for_fifo_U0 RTLNAME transformer_top_start_for_fifo_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_fifo_U0_U}
      {MODELNAME transformer_top_start_for_stateful_norm_U0 RTLNAME transformer_top_start_for_stateful_norm_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_stateful_norm_U0_U}
      {MODELNAME transformer_top_start_for_activation_relu_U0 RTLNAME transformer_top_start_for_activation_relu_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_activation_relu_U0_U}
      {MODELNAME transformer_top_start_for_alu_add_U0 RTLNAME transformer_top_start_for_alu_add_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_alu_add_U0_U}
      {MODELNAME transformer_top_start_for_fifo_9_U0 RTLNAME transformer_top_start_for_fifo_9_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_fifo_9_U0_U}
    }
  }
}
