# This script segment is generated automatically by AutoPilot

# clear list
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_begin
    cg_default_interface_gen_bundle_begin
    AESL_LIB_XILADAPTER::native_axis_begin
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 7 \
    name s_norm1_in \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_s_norm1_in \
    op interface \
    ports { s_norm1_in_dout { I 16 vector } s_norm1_in_empty_n { I 1 bit } s_norm1_in_read { O 1 bit } s_norm1_in_num_data_valid { I 3 vector } s_norm1_in_fifo_cap { I 3 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 8 \
    name buf_16_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_16_out \
    op interface \
    ports { buf_16_out { O 8 vector } buf_16_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 9 \
    name buf_15_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_15_out \
    op interface \
    ports { buf_15_out { O 8 vector } buf_15_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 10 \
    name buf_14_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_14_out \
    op interface \
    ports { buf_14_out { O 8 vector } buf_14_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 11 \
    name buf_13_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_13_out \
    op interface \
    ports { buf_13_out { O 8 vector } buf_13_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 12 \
    name buf_12_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_12_out \
    op interface \
    ports { buf_12_out { O 8 vector } buf_12_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 13 \
    name buf_11_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_11_out \
    op interface \
    ports { buf_11_out { O 8 vector } buf_11_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 14 \
    name buf_10_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_10_out \
    op interface \
    ports { buf_10_out { O 8 vector } buf_10_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 15 \
    name buf_9_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_9_out \
    op interface \
    ports { buf_9_out { O 8 vector } buf_9_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 16 \
    name buf_8_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_8_out \
    op interface \
    ports { buf_8_out { O 8 vector } buf_8_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 17 \
    name buf_7_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_7_out \
    op interface \
    ports { buf_7_out { O 8 vector } buf_7_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 18 \
    name buf_6_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_6_out \
    op interface \
    ports { buf_6_out { O 8 vector } buf_6_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 19 \
    name buf_5_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_5_out \
    op interface \
    ports { buf_5_out { O 8 vector } buf_5_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 20 \
    name buf_4_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_4_out \
    op interface \
    ports { buf_4_out { O 8 vector } buf_4_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 21 \
    name buf_3_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_3_out \
    op interface \
    ports { buf_3_out { O 8 vector } buf_3_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 22 \
    name buf_2_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_2_out \
    op interface \
    ports { buf_2_out { O 8 vector } buf_2_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 23 \
    name buf_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_out \
    op interface \
    ports { buf_out { O 8 vector } buf_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 24 \
    name sum_x_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_sum_x_out \
    op interface \
    ports { sum_x_out { O 12 vector } sum_x_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id -1 \
    name ap_ctrl \
    type ap_ctrl \
    reset_level 1 \
    sync_rst true \
    corename ap_ctrl \
    op interface \
    ports { ap_start { I 1 bit } ap_ready { O 1 bit } ap_done { O 1 bit } ap_idle { O 1 bit } } \
} "
}


# Adapter definition:
set PortName ap_clk
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_clock] == "cg_default_interface_gen_clock"} {
eval "cg_default_interface_gen_clock { \
    id -2 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_clk \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-113\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}


# Adapter definition:
set PortName ap_rst
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_reset] == "cg_default_interface_gen_reset"} {
eval "cg_default_interface_gen_reset { \
    id -3 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_rst \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-114\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}



# merge
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_end
    cg_default_interface_gen_bundle_end
    AESL_LIB_XILADAPTER::native_axis_end
}


# flow_control definition:
set InstName transformer_top_flow_control_loop_pipe_sequential_init_U
set CompName transformer_top_flow_control_loop_pipe_sequential_init
set name flow_control_loop_pipe_sequential_init
if {${::AESL::PGuard_autocg_gen} && ${::AESL::PGuard_autocg_ipmgen}} {
if {[info proc ::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control] == "::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control"} {
eval "::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control { \
    name ${name} \
    prefix transformer_top_ \
}"
} else {
puts "@W \[IMPL-107\] Cannot find ::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control, check your platform lib"
}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $CompName BINDTYPE interface TYPE internal_upc_flow_control INSTNAME $InstName
}


