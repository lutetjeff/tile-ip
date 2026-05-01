# This script segment is generated automatically by AutoPilot

if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler transformer_top_sparsemux_17_3_9_1_1 BINDTYPE {op} TYPE {sparsemux} IMPL {compactencoding_dontcare}
}


set name transformer_top_udiv_17ns_13ns_17_21_1
if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $name BINDTYPE {op} TYPE {udiv} IMPL {auto} LATENCY 20 ALLOW_PRAGMA 1
}


# clear list
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_begin
    cg_default_interface_gen_bundle_begin
    AESL_LIB_XILADAPTER::native_axis_begin
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 434 \
    name exp_val_18 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_exp_val_18 \
    op interface \
    ports { exp_val_18 { I 9 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 435 \
    name exp_val_20 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_exp_val_20 \
    op interface \
    ports { exp_val_20 { I 9 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 436 \
    name exp_val_22 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_exp_val_22 \
    op interface \
    ports { exp_val_22 { I 9 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 437 \
    name exp_val_24 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_exp_val_24 \
    op interface \
    ports { exp_val_24 { I 9 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 438 \
    name exp_val_26 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_exp_val_26 \
    op interface \
    ports { exp_val_26 { I 9 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 439 \
    name exp_val_28 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_exp_val_28 \
    op interface \
    ports { exp_val_28 { I 9 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 440 \
    name exp_val_30 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_exp_val_30 \
    op interface \
    ports { exp_val_30 { I 9 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 441 \
    name exp_val_32 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_exp_val_32 \
    op interface \
    ports { exp_val_32 { I 9 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 442 \
    name zext_ln217 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_zext_ln217 \
    op interface \
    ports { zext_ln217 { I 12 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 443 \
    name zext_ln213_17 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_zext_ln213_17 \
    op interface \
    ports { zext_ln213_17 { I 9 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 444 \
    name exp_val_19 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_exp_val_19 \
    op interface \
    ports { exp_val_19 { I 9 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 445 \
    name exp_val_21 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_exp_val_21 \
    op interface \
    ports { exp_val_21 { I 9 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 446 \
    name exp_val_23 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_exp_val_23 \
    op interface \
    ports { exp_val_23 { I 9 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 447 \
    name exp_val_25 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_exp_val_25 \
    op interface \
    ports { exp_val_25 { I 9 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 448 \
    name exp_val_27 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_exp_val_27 \
    op interface \
    ports { exp_val_27 { I 9 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 449 \
    name exp_val_29 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_exp_val_29 \
    op interface \
    ports { exp_val_29 { I 9 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 450 \
    name exp_val_31 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_exp_val_31 \
    op interface \
    ports { exp_val_31 { I 9 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 451 \
    name exp_val_33 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_exp_val_33 \
    op interface \
    ports { exp_val_33 { I 9 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 452 \
    name s_softmax_out \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_s_softmax_out \
    op interface \
    ports { s_softmax_out_din { O 16 vector } s_softmax_out_full_n { I 1 bit } s_softmax_out_write { O 1 bit } s_softmax_out_num_data_valid { I 32 vector } s_softmax_out_fifo_cap { I 32 vector } } \
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


