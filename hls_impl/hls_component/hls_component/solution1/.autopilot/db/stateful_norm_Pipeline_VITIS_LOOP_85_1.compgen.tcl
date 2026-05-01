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
    id 822 \
    name s_norm2_in \
    type fifo \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_s_norm2_in \
    op interface \
    ports { s_norm2_in_dout { I 16 vector } s_norm2_in_empty_n { I 1 bit } s_norm2_in_read { O 1 bit } s_norm2_in_num_data_valid { I 3 vector } s_norm2_in_fifo_cap { I 3 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 823 \
    name buf_49_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_49_out \
    op interface \
    ports { buf_49_out { O 8 vector } buf_49_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 824 \
    name buf_48_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_48_out \
    op interface \
    ports { buf_48_out { O 8 vector } buf_48_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 825 \
    name buf_47_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_47_out \
    op interface \
    ports { buf_47_out { O 8 vector } buf_47_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 826 \
    name buf_46_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_46_out \
    op interface \
    ports { buf_46_out { O 8 vector } buf_46_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 827 \
    name buf_45_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_45_out \
    op interface \
    ports { buf_45_out { O 8 vector } buf_45_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 828 \
    name buf_44_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_44_out \
    op interface \
    ports { buf_44_out { O 8 vector } buf_44_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 829 \
    name buf_43_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_43_out \
    op interface \
    ports { buf_43_out { O 8 vector } buf_43_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 830 \
    name buf_42_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_42_out \
    op interface \
    ports { buf_42_out { O 8 vector } buf_42_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 831 \
    name buf_41_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_41_out \
    op interface \
    ports { buf_41_out { O 8 vector } buf_41_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 832 \
    name buf_40_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_40_out \
    op interface \
    ports { buf_40_out { O 8 vector } buf_40_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 833 \
    name buf_39_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_39_out \
    op interface \
    ports { buf_39_out { O 8 vector } buf_39_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 834 \
    name buf_38_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_38_out \
    op interface \
    ports { buf_38_out { O 8 vector } buf_38_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 835 \
    name buf_37_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_37_out \
    op interface \
    ports { buf_37_out { O 8 vector } buf_37_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 836 \
    name buf_36_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_36_out \
    op interface \
    ports { buf_36_out { O 8 vector } buf_36_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 837 \
    name buf_35_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_buf_35_out \
    op interface \
    ports { buf_35_out { O 8 vector } buf_35_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 838 \
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
    id 839 \
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


