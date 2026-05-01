# This script segment is generated automatically by AutoPilot

set name transformer_top_mul_8s_8s_16_1_1
if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $name BINDTYPE {op} TYPE {mul} IMPL {auto} LATENCY 0 ALLOW_PRAGMA 1
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler transformer_top_mac_muladd_8s_8s_16s_17_4_1 BINDTYPE {op} TYPE {all} IMPL {dsp_slice} LATENCY 3
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler transformer_top_mac_muladd_8s_8s_17s_17_4_1 BINDTYPE {op} TYPE {all} IMPL {dsp_slice} LATENCY 3
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler transformer_top_mac_muladd_8s_8s_17s_18_4_1 BINDTYPE {op} TYPE {all} IMPL {dsp_slice} LATENCY 3
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler transformer_top_mac_muladd_8s_8s_18s_19_4_1 BINDTYPE {op} TYPE {all} IMPL {dsp_slice} LATENCY 3
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler transformer_top_mac_muladd_8s_8s_19s_20_4_1 BINDTYPE {op} TYPE {all} IMPL {dsp_slice} LATENCY 3
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
    id 135 \
    name w1_0_load \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_0_load \
    op interface \
    ports { w1_0_load { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 136 \
    name w1_2_load \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_2_load \
    op interface \
    ports { w1_2_load { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 137 \
    name w1_4_load \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_4_load \
    op interface \
    ports { w1_4_load { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 138 \
    name w1_6_load \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_6_load \
    op interface \
    ports { w1_6_load { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 139 \
    name w1_8_load \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_8_load \
    op interface \
    ports { w1_8_load { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 140 \
    name w1_10_load \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_10_load \
    op interface \
    ports { w1_10_load { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 141 \
    name w1_12_load \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_12_load \
    op interface \
    ports { w1_12_load { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 142 \
    name w1_14_load \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_14_load \
    op interface \
    ports { w1_14_load { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 143 \
    name w1_0_load_1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_0_load_1 \
    op interface \
    ports { w1_0_load_1 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 144 \
    name w1_2_load_1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_2_load_1 \
    op interface \
    ports { w1_2_load_1 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 145 \
    name w1_4_load_1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_4_load_1 \
    op interface \
    ports { w1_4_load_1 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 146 \
    name w1_6_load_1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_6_load_1 \
    op interface \
    ports { w1_6_load_1 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 147 \
    name w1_8_load_1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_8_load_1 \
    op interface \
    ports { w1_8_load_1 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 148 \
    name w1_10_load_1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_10_load_1 \
    op interface \
    ports { w1_10_load_1 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 149 \
    name w1_12_load_1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_12_load_1 \
    op interface \
    ports { w1_12_load_1 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 150 \
    name w1_14_load_1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_14_load_1 \
    op interface \
    ports { w1_14_load_1 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 151 \
    name w1_0_load_2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_0_load_2 \
    op interface \
    ports { w1_0_load_2 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 152 \
    name w1_2_load_2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_2_load_2 \
    op interface \
    ports { w1_2_load_2 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 153 \
    name w1_4_load_2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_4_load_2 \
    op interface \
    ports { w1_4_load_2 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 154 \
    name w1_6_load_2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_6_load_2 \
    op interface \
    ports { w1_6_load_2 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 155 \
    name w1_8_load_2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_8_load_2 \
    op interface \
    ports { w1_8_load_2 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 156 \
    name w1_10_load_2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_10_load_2 \
    op interface \
    ports { w1_10_load_2 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 157 \
    name w1_12_load_2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_12_load_2 \
    op interface \
    ports { w1_12_load_2 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 158 \
    name w1_14_load_2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_14_load_2 \
    op interface \
    ports { w1_14_load_2 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 159 \
    name w1_0_load_3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_0_load_3 \
    op interface \
    ports { w1_0_load_3 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 160 \
    name w1_2_load_3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_2_load_3 \
    op interface \
    ports { w1_2_load_3 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 161 \
    name w1_4_load_3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_4_load_3 \
    op interface \
    ports { w1_4_load_3 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 162 \
    name w1_6_load_3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_6_load_3 \
    op interface \
    ports { w1_6_load_3 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 163 \
    name w1_8_load_3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_8_load_3 \
    op interface \
    ports { w1_8_load_3 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 164 \
    name w1_10_load_3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_10_load_3 \
    op interface \
    ports { w1_10_load_3 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 165 \
    name w1_12_load_3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_12_load_3 \
    op interface \
    ports { w1_12_load_3 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 166 \
    name w1_14_load_3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_14_load_3 \
    op interface \
    ports { w1_14_load_3 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 167 \
    name w1_0_load_4 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_0_load_4 \
    op interface \
    ports { w1_0_load_4 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 168 \
    name w1_2_load_4 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_2_load_4 \
    op interface \
    ports { w1_2_load_4 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 169 \
    name w1_4_load_4 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_4_load_4 \
    op interface \
    ports { w1_4_load_4 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 170 \
    name w1_6_load_4 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_6_load_4 \
    op interface \
    ports { w1_6_load_4 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 171 \
    name w1_8_load_4 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_8_load_4 \
    op interface \
    ports { w1_8_load_4 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 172 \
    name w1_10_load_4 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_10_load_4 \
    op interface \
    ports { w1_10_load_4 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 173 \
    name w1_12_load_4 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_12_load_4 \
    op interface \
    ports { w1_12_load_4 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 174 \
    name w1_14_load_4 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_14_load_4 \
    op interface \
    ports { w1_14_load_4 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 175 \
    name w1_0_load_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_0_load_5 \
    op interface \
    ports { w1_0_load_5 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 176 \
    name w1_2_load_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_2_load_5 \
    op interface \
    ports { w1_2_load_5 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 177 \
    name w1_4_load_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_4_load_5 \
    op interface \
    ports { w1_4_load_5 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 178 \
    name w1_6_load_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_6_load_5 \
    op interface \
    ports { w1_6_load_5 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 179 \
    name w1_8_load_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_8_load_5 \
    op interface \
    ports { w1_8_load_5 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 180 \
    name w1_10_load_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_10_load_5 \
    op interface \
    ports { w1_10_load_5 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 181 \
    name w1_12_load_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_12_load_5 \
    op interface \
    ports { w1_12_load_5 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 182 \
    name w1_14_load_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_14_load_5 \
    op interface \
    ports { w1_14_load_5 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 183 \
    name w1_0_load_6 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_0_load_6 \
    op interface \
    ports { w1_0_load_6 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 184 \
    name w1_2_load_6 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_2_load_6 \
    op interface \
    ports { w1_2_load_6 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 185 \
    name w1_4_load_6 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_4_load_6 \
    op interface \
    ports { w1_4_load_6 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 186 \
    name w1_6_load_6 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_6_load_6 \
    op interface \
    ports { w1_6_load_6 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 187 \
    name w1_8_load_6 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_8_load_6 \
    op interface \
    ports { w1_8_load_6 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 188 \
    name w1_10_load_6 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_10_load_6 \
    op interface \
    ports { w1_10_load_6 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 189 \
    name w1_12_load_6 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_12_load_6 \
    op interface \
    ports { w1_12_load_6 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 190 \
    name w1_14_load_6 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_14_load_6 \
    op interface \
    ports { w1_14_load_6 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 191 \
    name w1_0_load_7 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_0_load_7 \
    op interface \
    ports { w1_0_load_7 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 192 \
    name w1_2_load_7 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_2_load_7 \
    op interface \
    ports { w1_2_load_7 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 193 \
    name w1_4_load_7 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_4_load_7 \
    op interface \
    ports { w1_4_load_7 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 194 \
    name w1_6_load_7 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_6_load_7 \
    op interface \
    ports { w1_6_load_7 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 195 \
    name w1_8_load_7 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_8_load_7 \
    op interface \
    ports { w1_8_load_7 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 196 \
    name w1_10_load_7 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_10_load_7 \
    op interface \
    ports { w1_10_load_7 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 197 \
    name w1_12_load_7 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_12_load_7 \
    op interface \
    ports { w1_12_load_7 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 198 \
    name w1_14_load_7 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_14_load_7 \
    op interface \
    ports { w1_14_load_7 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 199 \
    name w1_0_load_8 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_0_load_8 \
    op interface \
    ports { w1_0_load_8 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 200 \
    name w1_2_load_8 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_2_load_8 \
    op interface \
    ports { w1_2_load_8 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 201 \
    name w1_4_load_8 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_4_load_8 \
    op interface \
    ports { w1_4_load_8 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 202 \
    name w1_6_load_8 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_6_load_8 \
    op interface \
    ports { w1_6_load_8 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 203 \
    name w1_8_load_8 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_8_load_8 \
    op interface \
    ports { w1_8_load_8 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 204 \
    name w1_10_load_8 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_10_load_8 \
    op interface \
    ports { w1_10_load_8 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 205 \
    name w1_12_load_8 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_12_load_8 \
    op interface \
    ports { w1_12_load_8 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 206 \
    name w1_14_load_8 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_14_load_8 \
    op interface \
    ports { w1_14_load_8 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 207 \
    name w1_0_load_9 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_0_load_9 \
    op interface \
    ports { w1_0_load_9 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 208 \
    name w1_2_load_9 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_2_load_9 \
    op interface \
    ports { w1_2_load_9 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 209 \
    name w1_4_load_9 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_4_load_9 \
    op interface \
    ports { w1_4_load_9 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 210 \
    name w1_6_load_9 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_6_load_9 \
    op interface \
    ports { w1_6_load_9 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 211 \
    name w1_8_load_9 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_8_load_9 \
    op interface \
    ports { w1_8_load_9 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 212 \
    name w1_10_load_9 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_10_load_9 \
    op interface \
    ports { w1_10_load_9 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 213 \
    name w1_12_load_9 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_12_load_9 \
    op interface \
    ports { w1_12_load_9 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 214 \
    name w1_14_load_9 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_14_load_9 \
    op interface \
    ports { w1_14_load_9 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 215 \
    name w1_0_load_10 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_0_load_10 \
    op interface \
    ports { w1_0_load_10 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 216 \
    name w1_2_load_10 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_2_load_10 \
    op interface \
    ports { w1_2_load_10 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 217 \
    name w1_4_load_10 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_4_load_10 \
    op interface \
    ports { w1_4_load_10 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 218 \
    name w1_6_load_10 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_6_load_10 \
    op interface \
    ports { w1_6_load_10 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 219 \
    name w1_8_load_10 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_8_load_10 \
    op interface \
    ports { w1_8_load_10 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 220 \
    name w1_10_load_10 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_10_load_10 \
    op interface \
    ports { w1_10_load_10 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 221 \
    name w1_12_load_10 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_12_load_10 \
    op interface \
    ports { w1_12_load_10 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 222 \
    name w1_14_load_10 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_14_load_10 \
    op interface \
    ports { w1_14_load_10 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 223 \
    name w1_0_load_11 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_0_load_11 \
    op interface \
    ports { w1_0_load_11 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 224 \
    name w1_2_load_11 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_2_load_11 \
    op interface \
    ports { w1_2_load_11 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 225 \
    name w1_4_load_11 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_4_load_11 \
    op interface \
    ports { w1_4_load_11 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 226 \
    name w1_6_load_11 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_6_load_11 \
    op interface \
    ports { w1_6_load_11 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 227 \
    name w1_8_load_11 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_8_load_11 \
    op interface \
    ports { w1_8_load_11 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 228 \
    name w1_10_load_11 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_10_load_11 \
    op interface \
    ports { w1_10_load_11 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 229 \
    name w1_12_load_11 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_12_load_11 \
    op interface \
    ports { w1_12_load_11 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 230 \
    name w1_14_load_11 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_14_load_11 \
    op interface \
    ports { w1_14_load_11 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 231 \
    name w1_0_load_12 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_0_load_12 \
    op interface \
    ports { w1_0_load_12 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 232 \
    name w1_2_load_12 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_2_load_12 \
    op interface \
    ports { w1_2_load_12 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 233 \
    name w1_4_load_12 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_4_load_12 \
    op interface \
    ports { w1_4_load_12 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 234 \
    name w1_6_load_12 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_6_load_12 \
    op interface \
    ports { w1_6_load_12 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 235 \
    name w1_8_load_12 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_8_load_12 \
    op interface \
    ports { w1_8_load_12 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 236 \
    name w1_10_load_12 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_10_load_12 \
    op interface \
    ports { w1_10_load_12 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 237 \
    name w1_12_load_12 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_12_load_12 \
    op interface \
    ports { w1_12_load_12 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 238 \
    name w1_14_load_12 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_14_load_12 \
    op interface \
    ports { w1_14_load_12 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 239 \
    name w1_0_load_13 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_0_load_13 \
    op interface \
    ports { w1_0_load_13 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 240 \
    name w1_2_load_13 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_2_load_13 \
    op interface \
    ports { w1_2_load_13 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 241 \
    name w1_4_load_13 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_4_load_13 \
    op interface \
    ports { w1_4_load_13 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 242 \
    name w1_6_load_13 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_6_load_13 \
    op interface \
    ports { w1_6_load_13 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 243 \
    name w1_8_load_13 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_8_load_13 \
    op interface \
    ports { w1_8_load_13 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 244 \
    name w1_10_load_13 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_10_load_13 \
    op interface \
    ports { w1_10_load_13 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 245 \
    name w1_12_load_13 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_12_load_13 \
    op interface \
    ports { w1_12_load_13 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 246 \
    name w1_14_load_13 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_14_load_13 \
    op interface \
    ports { w1_14_load_13 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 247 \
    name w1_0_load_14 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_0_load_14 \
    op interface \
    ports { w1_0_load_14 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 248 \
    name w1_2_load_14 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_2_load_14 \
    op interface \
    ports { w1_2_load_14 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 249 \
    name w1_4_load_14 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_4_load_14 \
    op interface \
    ports { w1_4_load_14 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 250 \
    name w1_6_load_14 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_6_load_14 \
    op interface \
    ports { w1_6_load_14 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 251 \
    name w1_8_load_14 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_8_load_14 \
    op interface \
    ports { w1_8_load_14 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 252 \
    name w1_10_load_14 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_10_load_14 \
    op interface \
    ports { w1_10_load_14 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 253 \
    name w1_12_load_14 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_12_load_14 \
    op interface \
    ports { w1_12_load_14 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 254 \
    name w1_14_load_14 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_14_load_14 \
    op interface \
    ports { w1_14_load_14 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 255 \
    name w1_0_load_15 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_0_load_15 \
    op interface \
    ports { w1_0_load_15 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 256 \
    name w1_2_load_15 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_2_load_15 \
    op interface \
    ports { w1_2_load_15 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 257 \
    name w1_4_load_15 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_4_load_15 \
    op interface \
    ports { w1_4_load_15 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 258 \
    name w1_6_load_15 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_6_load_15 \
    op interface \
    ports { w1_6_load_15 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 259 \
    name w1_8_load_15 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_8_load_15 \
    op interface \
    ports { w1_8_load_15 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 260 \
    name w1_10_load_15 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_10_load_15 \
    op interface \
    ports { w1_10_load_15 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 261 \
    name w1_12_load_15 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_12_load_15 \
    op interface \
    ports { w1_12_load_15 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 262 \
    name w1_14_load_15 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_14_load_15 \
    op interface \
    ports { w1_14_load_15 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 263 \
    name sext_ln160_270 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_sext_ln160_270 \
    op interface \
    ports { sext_ln160_270 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 264 \
    name sext_ln160_269 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_sext_ln160_269 \
    op interface \
    ports { sext_ln160_269 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 265 \
    name sext_ln160_268 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_sext_ln160_268 \
    op interface \
    ports { sext_ln160_268 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 266 \
    name sext_ln160_267 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_sext_ln160_267 \
    op interface \
    ports { sext_ln160_267 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 267 \
    name sext_ln160_266 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_sext_ln160_266 \
    op interface \
    ports { sext_ln160_266 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 268 \
    name sext_ln160_265 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_sext_ln160_265 \
    op interface \
    ports { sext_ln160_265 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 269 \
    name sext_ln160_264 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_sext_ln160_264 \
    op interface \
    ports { sext_ln160_264 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 270 \
    name sext_ln160_263 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_sext_ln160_263 \
    op interface \
    ports { sext_ln160_263 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 271 \
    name sext_ln160_262 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_sext_ln160_262 \
    op interface \
    ports { sext_ln160_262 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 272 \
    name sext_ln160_261 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_sext_ln160_261 \
    op interface \
    ports { sext_ln160_261 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 273 \
    name sext_ln160_260 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_sext_ln160_260 \
    op interface \
    ports { sext_ln160_260 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 274 \
    name sext_ln160_259 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_sext_ln160_259 \
    op interface \
    ports { sext_ln160_259 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 275 \
    name sext_ln160_258 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_sext_ln160_258 \
    op interface \
    ports { sext_ln160_258 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 276 \
    name sext_ln160_257 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_sext_ln160_257 \
    op interface \
    ports { sext_ln160_257 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 277 \
    name sext_ln160 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_sext_ln160 \
    op interface \
    ports { sext_ln160 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 278 \
    name sext_ln160_256 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_sext_ln160_256 \
    op interface \
    ports { sext_ln160_256 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 279 \
    name w1_1_load \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_1_load \
    op interface \
    ports { w1_1_load { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 280 \
    name w1_3_load \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_3_load \
    op interface \
    ports { w1_3_load { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 281 \
    name w1_5_load \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_5_load \
    op interface \
    ports { w1_5_load { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 282 \
    name w1_7_load \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_7_load \
    op interface \
    ports { w1_7_load { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 283 \
    name w1_9_load \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_9_load \
    op interface \
    ports { w1_9_load { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 284 \
    name w1_11_load \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_11_load \
    op interface \
    ports { w1_11_load { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 285 \
    name w1_13_load \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_13_load \
    op interface \
    ports { w1_13_load { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 286 \
    name w1_15_load \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_15_load \
    op interface \
    ports { w1_15_load { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 287 \
    name w1_1_load_1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_1_load_1 \
    op interface \
    ports { w1_1_load_1 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 288 \
    name w1_3_load_1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_3_load_1 \
    op interface \
    ports { w1_3_load_1 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 289 \
    name w1_5_load_1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_5_load_1 \
    op interface \
    ports { w1_5_load_1 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 290 \
    name w1_7_load_1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_7_load_1 \
    op interface \
    ports { w1_7_load_1 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 291 \
    name w1_9_load_1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_9_load_1 \
    op interface \
    ports { w1_9_load_1 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 292 \
    name w1_11_load_1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_11_load_1 \
    op interface \
    ports { w1_11_load_1 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 293 \
    name w1_13_load_1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_13_load_1 \
    op interface \
    ports { w1_13_load_1 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 294 \
    name w1_15_load_1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_15_load_1 \
    op interface \
    ports { w1_15_load_1 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 295 \
    name w1_1_load_2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_1_load_2 \
    op interface \
    ports { w1_1_load_2 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 296 \
    name w1_3_load_2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_3_load_2 \
    op interface \
    ports { w1_3_load_2 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 297 \
    name w1_5_load_2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_5_load_2 \
    op interface \
    ports { w1_5_load_2 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 298 \
    name w1_7_load_2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_7_load_2 \
    op interface \
    ports { w1_7_load_2 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 299 \
    name w1_9_load_2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_9_load_2 \
    op interface \
    ports { w1_9_load_2 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 300 \
    name w1_11_load_2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_11_load_2 \
    op interface \
    ports { w1_11_load_2 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 301 \
    name w1_13_load_2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_13_load_2 \
    op interface \
    ports { w1_13_load_2 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 302 \
    name w1_15_load_2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_15_load_2 \
    op interface \
    ports { w1_15_load_2 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 303 \
    name w1_1_load_3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_1_load_3 \
    op interface \
    ports { w1_1_load_3 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 304 \
    name w1_3_load_3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_3_load_3 \
    op interface \
    ports { w1_3_load_3 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 305 \
    name w1_5_load_3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_5_load_3 \
    op interface \
    ports { w1_5_load_3 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 306 \
    name w1_7_load_3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_7_load_3 \
    op interface \
    ports { w1_7_load_3 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 307 \
    name w1_9_load_3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_9_load_3 \
    op interface \
    ports { w1_9_load_3 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 308 \
    name w1_11_load_3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_11_load_3 \
    op interface \
    ports { w1_11_load_3 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 309 \
    name w1_13_load_3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_13_load_3 \
    op interface \
    ports { w1_13_load_3 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 310 \
    name w1_15_load_3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_15_load_3 \
    op interface \
    ports { w1_15_load_3 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 311 \
    name w1_1_load_4 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_1_load_4 \
    op interface \
    ports { w1_1_load_4 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 312 \
    name w1_3_load_4 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_3_load_4 \
    op interface \
    ports { w1_3_load_4 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 313 \
    name w1_5_load_4 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_5_load_4 \
    op interface \
    ports { w1_5_load_4 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 314 \
    name w1_7_load_4 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_7_load_4 \
    op interface \
    ports { w1_7_load_4 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 315 \
    name w1_9_load_4 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_9_load_4 \
    op interface \
    ports { w1_9_load_4 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 316 \
    name w1_11_load_4 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_11_load_4 \
    op interface \
    ports { w1_11_load_4 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 317 \
    name w1_13_load_4 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_13_load_4 \
    op interface \
    ports { w1_13_load_4 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 318 \
    name w1_15_load_4 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_15_load_4 \
    op interface \
    ports { w1_15_load_4 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 319 \
    name w1_1_load_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_1_load_5 \
    op interface \
    ports { w1_1_load_5 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 320 \
    name w1_3_load_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_3_load_5 \
    op interface \
    ports { w1_3_load_5 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 321 \
    name w1_5_load_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_5_load_5 \
    op interface \
    ports { w1_5_load_5 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 322 \
    name w1_7_load_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_7_load_5 \
    op interface \
    ports { w1_7_load_5 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 323 \
    name w1_9_load_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_9_load_5 \
    op interface \
    ports { w1_9_load_5 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 324 \
    name w1_11_load_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_11_load_5 \
    op interface \
    ports { w1_11_load_5 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 325 \
    name w1_13_load_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_13_load_5 \
    op interface \
    ports { w1_13_load_5 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 326 \
    name w1_15_load_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_15_load_5 \
    op interface \
    ports { w1_15_load_5 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 327 \
    name w1_1_load_6 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_1_load_6 \
    op interface \
    ports { w1_1_load_6 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 328 \
    name w1_3_load_6 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_3_load_6 \
    op interface \
    ports { w1_3_load_6 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 329 \
    name w1_5_load_6 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_5_load_6 \
    op interface \
    ports { w1_5_load_6 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 330 \
    name w1_7_load_6 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_7_load_6 \
    op interface \
    ports { w1_7_load_6 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 331 \
    name w1_9_load_6 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_9_load_6 \
    op interface \
    ports { w1_9_load_6 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 332 \
    name w1_11_load_6 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_11_load_6 \
    op interface \
    ports { w1_11_load_6 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 333 \
    name w1_13_load_6 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_13_load_6 \
    op interface \
    ports { w1_13_load_6 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 334 \
    name w1_15_load_6 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_15_load_6 \
    op interface \
    ports { w1_15_load_6 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 335 \
    name w1_1_load_7 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_1_load_7 \
    op interface \
    ports { w1_1_load_7 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 336 \
    name w1_3_load_7 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_3_load_7 \
    op interface \
    ports { w1_3_load_7 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 337 \
    name w1_5_load_7 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_5_load_7 \
    op interface \
    ports { w1_5_load_7 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 338 \
    name w1_7_load_7 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_7_load_7 \
    op interface \
    ports { w1_7_load_7 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 339 \
    name w1_9_load_7 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_9_load_7 \
    op interface \
    ports { w1_9_load_7 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 340 \
    name w1_11_load_7 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_11_load_7 \
    op interface \
    ports { w1_11_load_7 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 341 \
    name w1_13_load_7 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_13_load_7 \
    op interface \
    ports { w1_13_load_7 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 342 \
    name w1_15_load_7 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_15_load_7 \
    op interface \
    ports { w1_15_load_7 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 343 \
    name w1_1_load_8 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_1_load_8 \
    op interface \
    ports { w1_1_load_8 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 344 \
    name w1_3_load_8 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_3_load_8 \
    op interface \
    ports { w1_3_load_8 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 345 \
    name w1_5_load_8 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_5_load_8 \
    op interface \
    ports { w1_5_load_8 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 346 \
    name w1_7_load_8 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_7_load_8 \
    op interface \
    ports { w1_7_load_8 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 347 \
    name w1_9_load_8 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_9_load_8 \
    op interface \
    ports { w1_9_load_8 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 348 \
    name w1_11_load_8 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_11_load_8 \
    op interface \
    ports { w1_11_load_8 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 349 \
    name w1_13_load_8 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_13_load_8 \
    op interface \
    ports { w1_13_load_8 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 350 \
    name w1_15_load_8 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_15_load_8 \
    op interface \
    ports { w1_15_load_8 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 351 \
    name w1_1_load_9 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_1_load_9 \
    op interface \
    ports { w1_1_load_9 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 352 \
    name w1_3_load_9 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_3_load_9 \
    op interface \
    ports { w1_3_load_9 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 353 \
    name w1_5_load_9 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_5_load_9 \
    op interface \
    ports { w1_5_load_9 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 354 \
    name w1_7_load_9 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_7_load_9 \
    op interface \
    ports { w1_7_load_9 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 355 \
    name w1_9_load_9 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_9_load_9 \
    op interface \
    ports { w1_9_load_9 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 356 \
    name w1_11_load_9 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_11_load_9 \
    op interface \
    ports { w1_11_load_9 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 357 \
    name w1_13_load_9 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_13_load_9 \
    op interface \
    ports { w1_13_load_9 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 358 \
    name w1_15_load_9 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_15_load_9 \
    op interface \
    ports { w1_15_load_9 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 359 \
    name w1_1_load_10 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_1_load_10 \
    op interface \
    ports { w1_1_load_10 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 360 \
    name w1_3_load_10 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_3_load_10 \
    op interface \
    ports { w1_3_load_10 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 361 \
    name w1_5_load_10 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_5_load_10 \
    op interface \
    ports { w1_5_load_10 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 362 \
    name w1_7_load_10 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_7_load_10 \
    op interface \
    ports { w1_7_load_10 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 363 \
    name w1_9_load_10 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_9_load_10 \
    op interface \
    ports { w1_9_load_10 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 364 \
    name w1_11_load_10 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_11_load_10 \
    op interface \
    ports { w1_11_load_10 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 365 \
    name w1_13_load_10 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_13_load_10 \
    op interface \
    ports { w1_13_load_10 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 366 \
    name w1_15_load_10 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_15_load_10 \
    op interface \
    ports { w1_15_load_10 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 367 \
    name w1_1_load_11 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_1_load_11 \
    op interface \
    ports { w1_1_load_11 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 368 \
    name w1_3_load_11 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_3_load_11 \
    op interface \
    ports { w1_3_load_11 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 369 \
    name w1_5_load_11 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_5_load_11 \
    op interface \
    ports { w1_5_load_11 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 370 \
    name w1_7_load_11 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_7_load_11 \
    op interface \
    ports { w1_7_load_11 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 371 \
    name w1_9_load_11 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_9_load_11 \
    op interface \
    ports { w1_9_load_11 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 372 \
    name w1_11_load_11 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_11_load_11 \
    op interface \
    ports { w1_11_load_11 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 373 \
    name w1_13_load_11 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_13_load_11 \
    op interface \
    ports { w1_13_load_11 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 374 \
    name w1_15_load_11 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_15_load_11 \
    op interface \
    ports { w1_15_load_11 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 375 \
    name w1_1_load_12 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_1_load_12 \
    op interface \
    ports { w1_1_load_12 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 376 \
    name w1_3_load_12 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_3_load_12 \
    op interface \
    ports { w1_3_load_12 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 377 \
    name w1_5_load_12 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_5_load_12 \
    op interface \
    ports { w1_5_load_12 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 378 \
    name w1_7_load_12 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_7_load_12 \
    op interface \
    ports { w1_7_load_12 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 379 \
    name w1_9_load_12 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_9_load_12 \
    op interface \
    ports { w1_9_load_12 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 380 \
    name w1_11_load_12 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_11_load_12 \
    op interface \
    ports { w1_11_load_12 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 381 \
    name w1_13_load_12 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_13_load_12 \
    op interface \
    ports { w1_13_load_12 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 382 \
    name w1_15_load_12 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_15_load_12 \
    op interface \
    ports { w1_15_load_12 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 383 \
    name w1_1_load_13 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_1_load_13 \
    op interface \
    ports { w1_1_load_13 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 384 \
    name w1_3_load_13 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_3_load_13 \
    op interface \
    ports { w1_3_load_13 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 385 \
    name w1_5_load_13 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_5_load_13 \
    op interface \
    ports { w1_5_load_13 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 386 \
    name w1_7_load_13 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_7_load_13 \
    op interface \
    ports { w1_7_load_13 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 387 \
    name w1_9_load_13 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_9_load_13 \
    op interface \
    ports { w1_9_load_13 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 388 \
    name w1_11_load_13 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_11_load_13 \
    op interface \
    ports { w1_11_load_13 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 389 \
    name w1_13_load_13 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_13_load_13 \
    op interface \
    ports { w1_13_load_13 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 390 \
    name w1_15_load_13 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_15_load_13 \
    op interface \
    ports { w1_15_load_13 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 391 \
    name w1_1_load_14 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_1_load_14 \
    op interface \
    ports { w1_1_load_14 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 392 \
    name w1_3_load_14 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_3_load_14 \
    op interface \
    ports { w1_3_load_14 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 393 \
    name w1_5_load_14 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_5_load_14 \
    op interface \
    ports { w1_5_load_14 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 394 \
    name w1_7_load_14 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_7_load_14 \
    op interface \
    ports { w1_7_load_14 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 395 \
    name w1_9_load_14 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_9_load_14 \
    op interface \
    ports { w1_9_load_14 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 396 \
    name w1_11_load_14 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_11_load_14 \
    op interface \
    ports { w1_11_load_14 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 397 \
    name w1_13_load_14 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_13_load_14 \
    op interface \
    ports { w1_13_load_14 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 398 \
    name w1_15_load_14 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_15_load_14 \
    op interface \
    ports { w1_15_load_14 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 399 \
    name w1_1_load_15 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_1_load_15 \
    op interface \
    ports { w1_1_load_15 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 400 \
    name w1_3_load_15 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_3_load_15 \
    op interface \
    ports { w1_3_load_15 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 401 \
    name w1_5_load_15 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_5_load_15 \
    op interface \
    ports { w1_5_load_15 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 402 \
    name w1_7_load_15 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_7_load_15 \
    op interface \
    ports { w1_7_load_15 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 403 \
    name w1_9_load_15 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_9_load_15 \
    op interface \
    ports { w1_9_load_15 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 404 \
    name w1_11_load_15 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_11_load_15 \
    op interface \
    ports { w1_11_load_15 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 405 \
    name w1_13_load_15 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_13_load_15 \
    op interface \
    ports { w1_13_load_15 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 406 \
    name w1_15_load_15 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_w1_15_load_15 \
    op interface \
    ports { w1_15_load_15 { I 8 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 407 \
    name s_gemm1_out \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_s_gemm1_out \
    op interface \
    ports { s_gemm1_out_din { O 16 vector } s_gemm1_out_full_n { I 1 bit } s_gemm1_out_write { O 1 bit } s_gemm1_out_num_data_valid { I 32 vector } s_gemm1_out_fifo_cap { I 32 vector } } \
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


