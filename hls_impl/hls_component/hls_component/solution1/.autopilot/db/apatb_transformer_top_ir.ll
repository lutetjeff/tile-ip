; ModuleID = '/home/lutet/tiled-ip/hls_impl/hls_component/hls_component/solution1/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"class.hls::stream<ap_int<16>>" = type { %"struct.ap_int<16>" }
%"struct.ap_int<16>" = type { %"struct.ap_int_base<16, true>" }
%"struct.ap_int_base<16, true>" = type { %"struct.ssdm_int<16, true>" }
%"struct.ssdm_int<16, true>" = type { i16 }

; Function Attrs: inaccessiblememonly nounwind willreturn
declare void @llvm.sideeffect() #0

; Function Attrs: inaccessiblemem_or_argmemonly noinline willreturn
define void @apatb_transformer_top_ir(%"class.hls::stream<ap_int<16>>"* noalias nocapture nonnull align 2 dereferenceable(2) %in, %"class.hls::stream<ap_int<16>>"* noalias nocapture nonnull align 2 dereferenceable(2) %out, [16 x i8]* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="16" %w1, [16 x i8]* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="16" %w2, [16 x i8]* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="16" %w3, [16 x i8]* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="16" %w4) local_unnamed_addr #1 {
entry:
  %in_copy = alloca i16, align 512
  call void @llvm.sideeffect() #9 [ "stream_interface"(i16* %in_copy, i32 0) ]
  %out_copy = alloca i16, align 512
  call void @llvm.sideeffect() #9 [ "stream_interface"(i16* %out_copy, i32 0) ]
  %0 = bitcast [16 x i8]* %w1 to [16 x [16 x i8]]*
  %w1_copy_0 = alloca [16 x i8], align 512
  %w1_copy_1 = alloca [16 x i8], align 512
  %w1_copy_2 = alloca [16 x i8], align 512
  %w1_copy_3 = alloca [16 x i8], align 512
  %w1_copy_4 = alloca [16 x i8], align 512
  %w1_copy_5 = alloca [16 x i8], align 512
  %w1_copy_6 = alloca [16 x i8], align 512
  %w1_copy_7 = alloca [16 x i8], align 512
  %w1_copy_8 = alloca [16 x i8], align 512
  %w1_copy_9 = alloca [16 x i8], align 512
  %w1_copy_10 = alloca [16 x i8], align 512
  %w1_copy_11 = alloca [16 x i8], align 512
  %w1_copy_12 = alloca [16 x i8], align 512
  %w1_copy_13 = alloca [16 x i8], align 512
  %w1_copy_14 = alloca [16 x i8], align 512
  %w1_copy_15 = alloca [16 x i8], align 512
  %_0 = getelementptr [16 x i8], [16 x i8]* %w1_copy_0, i64 0, i64 0
  %_1 = getelementptr [16 x i8], [16 x i8]* %w1_copy_1, i64 0, i64 0
  %_2 = getelementptr [16 x i8], [16 x i8]* %w1_copy_2, i64 0, i64 0
  %_3 = getelementptr [16 x i8], [16 x i8]* %w1_copy_3, i64 0, i64 0
  %_4 = getelementptr [16 x i8], [16 x i8]* %w1_copy_4, i64 0, i64 0
  %_5 = getelementptr [16 x i8], [16 x i8]* %w1_copy_5, i64 0, i64 0
  %_6 = getelementptr [16 x i8], [16 x i8]* %w1_copy_6, i64 0, i64 0
  %_7 = getelementptr [16 x i8], [16 x i8]* %w1_copy_7, i64 0, i64 0
  %_8 = getelementptr [16 x i8], [16 x i8]* %w1_copy_8, i64 0, i64 0
  %_9 = getelementptr [16 x i8], [16 x i8]* %w1_copy_9, i64 0, i64 0
  %_10 = getelementptr [16 x i8], [16 x i8]* %w1_copy_10, i64 0, i64 0
  %_11 = getelementptr [16 x i8], [16 x i8]* %w1_copy_11, i64 0, i64 0
  %_12 = getelementptr [16 x i8], [16 x i8]* %w1_copy_12, i64 0, i64 0
  %_13 = getelementptr [16 x i8], [16 x i8]* %w1_copy_13, i64 0, i64 0
  %_14 = getelementptr [16 x i8], [16 x i8]* %w1_copy_14, i64 0, i64 0
  %_15 = getelementptr [16 x i8], [16 x i8]* %w1_copy_15, i64 0, i64 0
  %1 = bitcast [16 x i8]* %w2 to [16 x [16 x i8]]*
  %w2_copy_0 = alloca [16 x i8], align 512
  %w2_copy_1 = alloca [16 x i8], align 512
  %w2_copy_2 = alloca [16 x i8], align 512
  %w2_copy_3 = alloca [16 x i8], align 512
  %w2_copy_4 = alloca [16 x i8], align 512
  %w2_copy_5 = alloca [16 x i8], align 512
  %w2_copy_6 = alloca [16 x i8], align 512
  %w2_copy_7 = alloca [16 x i8], align 512
  %w2_copy_8 = alloca [16 x i8], align 512
  %w2_copy_9 = alloca [16 x i8], align 512
  %w2_copy_10 = alloca [16 x i8], align 512
  %w2_copy_11 = alloca [16 x i8], align 512
  %w2_copy_12 = alloca [16 x i8], align 512
  %w2_copy_13 = alloca [16 x i8], align 512
  %w2_copy_14 = alloca [16 x i8], align 512
  %w2_copy_15 = alloca [16 x i8], align 512
  %_03 = getelementptr [16 x i8], [16 x i8]* %w2_copy_0, i64 0, i64 0
  %_16 = getelementptr [16 x i8], [16 x i8]* %w2_copy_1, i64 0, i64 0
  %_27 = getelementptr [16 x i8], [16 x i8]* %w2_copy_2, i64 0, i64 0
  %_38 = getelementptr [16 x i8], [16 x i8]* %w2_copy_3, i64 0, i64 0
  %_49 = getelementptr [16 x i8], [16 x i8]* %w2_copy_4, i64 0, i64 0
  %_510 = getelementptr [16 x i8], [16 x i8]* %w2_copy_5, i64 0, i64 0
  %_611 = getelementptr [16 x i8], [16 x i8]* %w2_copy_6, i64 0, i64 0
  %_712 = getelementptr [16 x i8], [16 x i8]* %w2_copy_7, i64 0, i64 0
  %_813 = getelementptr [16 x i8], [16 x i8]* %w2_copy_8, i64 0, i64 0
  %_914 = getelementptr [16 x i8], [16 x i8]* %w2_copy_9, i64 0, i64 0
  %_1015 = getelementptr [16 x i8], [16 x i8]* %w2_copy_10, i64 0, i64 0
  %_1116 = getelementptr [16 x i8], [16 x i8]* %w2_copy_11, i64 0, i64 0
  %_1217 = getelementptr [16 x i8], [16 x i8]* %w2_copy_12, i64 0, i64 0
  %_1318 = getelementptr [16 x i8], [16 x i8]* %w2_copy_13, i64 0, i64 0
  %_1419 = getelementptr [16 x i8], [16 x i8]* %w2_copy_14, i64 0, i64 0
  %_1520 = getelementptr [16 x i8], [16 x i8]* %w2_copy_15, i64 0, i64 0
  %2 = bitcast [16 x i8]* %w3 to [16 x [16 x i8]]*
  %w3_copy_0 = alloca [16 x i8], align 512
  %w3_copy_1 = alloca [16 x i8], align 512
  %w3_copy_2 = alloca [16 x i8], align 512
  %w3_copy_3 = alloca [16 x i8], align 512
  %w3_copy_4 = alloca [16 x i8], align 512
  %w3_copy_5 = alloca [16 x i8], align 512
  %w3_copy_6 = alloca [16 x i8], align 512
  %w3_copy_7 = alloca [16 x i8], align 512
  %w3_copy_8 = alloca [16 x i8], align 512
  %w3_copy_9 = alloca [16 x i8], align 512
  %w3_copy_10 = alloca [16 x i8], align 512
  %w3_copy_11 = alloca [16 x i8], align 512
  %w3_copy_12 = alloca [16 x i8], align 512
  %w3_copy_13 = alloca [16 x i8], align 512
  %w3_copy_14 = alloca [16 x i8], align 512
  %w3_copy_15 = alloca [16 x i8], align 512
  %_021 = getelementptr [16 x i8], [16 x i8]* %w3_copy_0, i64 0, i64 0
  %_122 = getelementptr [16 x i8], [16 x i8]* %w3_copy_1, i64 0, i64 0
  %_223 = getelementptr [16 x i8], [16 x i8]* %w3_copy_2, i64 0, i64 0
  %_324 = getelementptr [16 x i8], [16 x i8]* %w3_copy_3, i64 0, i64 0
  %_425 = getelementptr [16 x i8], [16 x i8]* %w3_copy_4, i64 0, i64 0
  %_526 = getelementptr [16 x i8], [16 x i8]* %w3_copy_5, i64 0, i64 0
  %_627 = getelementptr [16 x i8], [16 x i8]* %w3_copy_6, i64 0, i64 0
  %_728 = getelementptr [16 x i8], [16 x i8]* %w3_copy_7, i64 0, i64 0
  %_829 = getelementptr [16 x i8], [16 x i8]* %w3_copy_8, i64 0, i64 0
  %_930 = getelementptr [16 x i8], [16 x i8]* %w3_copy_9, i64 0, i64 0
  %_1031 = getelementptr [16 x i8], [16 x i8]* %w3_copy_10, i64 0, i64 0
  %_1132 = getelementptr [16 x i8], [16 x i8]* %w3_copy_11, i64 0, i64 0
  %_1233 = getelementptr [16 x i8], [16 x i8]* %w3_copy_12, i64 0, i64 0
  %_1334 = getelementptr [16 x i8], [16 x i8]* %w3_copy_13, i64 0, i64 0
  %_1435 = getelementptr [16 x i8], [16 x i8]* %w3_copy_14, i64 0, i64 0
  %_1536 = getelementptr [16 x i8], [16 x i8]* %w3_copy_15, i64 0, i64 0
  %3 = bitcast [16 x i8]* %w4 to [16 x [16 x i8]]*
  %w4_copy_0 = alloca [16 x i8], align 512
  %w4_copy_1 = alloca [16 x i8], align 512
  %w4_copy_2 = alloca [16 x i8], align 512
  %w4_copy_3 = alloca [16 x i8], align 512
  %w4_copy_4 = alloca [16 x i8], align 512
  %w4_copy_5 = alloca [16 x i8], align 512
  %w4_copy_6 = alloca [16 x i8], align 512
  %w4_copy_7 = alloca [16 x i8], align 512
  %w4_copy_8 = alloca [16 x i8], align 512
  %w4_copy_9 = alloca [16 x i8], align 512
  %w4_copy_10 = alloca [16 x i8], align 512
  %w4_copy_11 = alloca [16 x i8], align 512
  %w4_copy_12 = alloca [16 x i8], align 512
  %w4_copy_13 = alloca [16 x i8], align 512
  %w4_copy_14 = alloca [16 x i8], align 512
  %w4_copy_15 = alloca [16 x i8], align 512
  %_037 = getelementptr [16 x i8], [16 x i8]* %w4_copy_0, i64 0, i64 0
  %_138 = getelementptr [16 x i8], [16 x i8]* %w4_copy_1, i64 0, i64 0
  %_239 = getelementptr [16 x i8], [16 x i8]* %w4_copy_2, i64 0, i64 0
  %_340 = getelementptr [16 x i8], [16 x i8]* %w4_copy_3, i64 0, i64 0
  %_441 = getelementptr [16 x i8], [16 x i8]* %w4_copy_4, i64 0, i64 0
  %_542 = getelementptr [16 x i8], [16 x i8]* %w4_copy_5, i64 0, i64 0
  %_643 = getelementptr [16 x i8], [16 x i8]* %w4_copy_6, i64 0, i64 0
  %_744 = getelementptr [16 x i8], [16 x i8]* %w4_copy_7, i64 0, i64 0
  %_845 = getelementptr [16 x i8], [16 x i8]* %w4_copy_8, i64 0, i64 0
  %_946 = getelementptr [16 x i8], [16 x i8]* %w4_copy_9, i64 0, i64 0
  %_1047 = getelementptr [16 x i8], [16 x i8]* %w4_copy_10, i64 0, i64 0
  %_1148 = getelementptr [16 x i8], [16 x i8]* %w4_copy_11, i64 0, i64 0
  %_1249 = getelementptr [16 x i8], [16 x i8]* %w4_copy_12, i64 0, i64 0
  %_1350 = getelementptr [16 x i8], [16 x i8]* %w4_copy_13, i64 0, i64 0
  %_1451 = getelementptr [16 x i8], [16 x i8]* %w4_copy_14, i64 0, i64 0
  %_1552 = getelementptr [16 x i8], [16 x i8]* %w4_copy_15, i64 0, i64 0
  call void @copy_in(%"class.hls::stream<ap_int<16>>"* nonnull %in, i16* nonnull align 512 %in_copy, %"class.hls::stream<ap_int<16>>"* nonnull %out, i16* nonnull align 512 %out_copy, [16 x [16 x i8]]* nonnull %0, [16 x i8]* nonnull align 512 %w1_copy_0, [16 x i8]* nonnull align 512 %w1_copy_1, [16 x i8]* nonnull align 512 %w1_copy_2, [16 x i8]* nonnull align 512 %w1_copy_3, [16 x i8]* nonnull align 512 %w1_copy_4, [16 x i8]* nonnull align 512 %w1_copy_5, [16 x i8]* nonnull align 512 %w1_copy_6, [16 x i8]* nonnull align 512 %w1_copy_7, [16 x i8]* nonnull align 512 %w1_copy_8, [16 x i8]* nonnull align 512 %w1_copy_9, [16 x i8]* nonnull align 512 %w1_copy_10, [16 x i8]* nonnull align 512 %w1_copy_11, [16 x i8]* nonnull align 512 %w1_copy_12, [16 x i8]* nonnull align 512 %w1_copy_13, [16 x i8]* nonnull align 512 %w1_copy_14, [16 x i8]* nonnull align 512 %w1_copy_15, [16 x [16 x i8]]* nonnull %1, [16 x i8]* nonnull align 512 %w2_copy_0, [16 x i8]* nonnull align 512 %w2_copy_1, [16 x i8]* nonnull align 512 %w2_copy_2, [16 x i8]* nonnull align 512 %w2_copy_3, [16 x i8]* nonnull align 512 %w2_copy_4, [16 x i8]* nonnull align 512 %w2_copy_5, [16 x i8]* nonnull align 512 %w2_copy_6, [16 x i8]* nonnull align 512 %w2_copy_7, [16 x i8]* nonnull align 512 %w2_copy_8, [16 x i8]* nonnull align 512 %w2_copy_9, [16 x i8]* nonnull align 512 %w2_copy_10, [16 x i8]* nonnull align 512 %w2_copy_11, [16 x i8]* nonnull align 512 %w2_copy_12, [16 x i8]* nonnull align 512 %w2_copy_13, [16 x i8]* nonnull align 512 %w2_copy_14, [16 x i8]* nonnull align 512 %w2_copy_15, [16 x [16 x i8]]* nonnull %2, [16 x i8]* nonnull align 512 %w3_copy_0, [16 x i8]* nonnull align 512 %w3_copy_1, [16 x i8]* nonnull align 512 %w3_copy_2, [16 x i8]* nonnull align 512 %w3_copy_3, [16 x i8]* nonnull align 512 %w3_copy_4, [16 x i8]* nonnull align 512 %w3_copy_5, [16 x i8]* nonnull align 512 %w3_copy_6, [16 x i8]* nonnull align 512 %w3_copy_7, [16 x i8]* nonnull align 512 %w3_copy_8, [16 x i8]* nonnull align 512 %w3_copy_9, [16 x i8]* nonnull align 512 %w3_copy_10, [16 x i8]* nonnull align 512 %w3_copy_11, [16 x i8]* nonnull align 512 %w3_copy_12, [16 x i8]* nonnull align 512 %w3_copy_13, [16 x i8]* nonnull align 512 %w3_copy_14, [16 x i8]* nonnull align 512 %w3_copy_15, [16 x [16 x i8]]* nonnull %3, [16 x i8]* nonnull align 512 %w4_copy_0, [16 x i8]* nonnull align 512 %w4_copy_1, [16 x i8]* nonnull align 512 %w4_copy_2, [16 x i8]* nonnull align 512 %w4_copy_3, [16 x i8]* nonnull align 512 %w4_copy_4, [16 x i8]* nonnull align 512 %w4_copy_5, [16 x i8]* nonnull align 512 %w4_copy_6, [16 x i8]* nonnull align 512 %w4_copy_7, [16 x i8]* nonnull align 512 %w4_copy_8, [16 x i8]* nonnull align 512 %w4_copy_9, [16 x i8]* nonnull align 512 %w4_copy_10, [16 x i8]* nonnull align 512 %w4_copy_11, [16 x i8]* nonnull align 512 %w4_copy_12, [16 x i8]* nonnull align 512 %w4_copy_13, [16 x i8]* nonnull align 512 %w4_copy_14, [16 x i8]* nonnull align 512 %w4_copy_15)
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_0, i32 998, i32 1, i32 0, i1 false) ], !dbg !88
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1, i32 998, i32 1, i32 0, i1 false) ], !dbg !88
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_2, i32 998, i32 1, i32 0, i1 false) ], !dbg !88
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_3, i32 998, i32 1, i32 0, i1 false) ], !dbg !88
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_4, i32 998, i32 1, i32 0, i1 false) ], !dbg !88
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_5, i32 998, i32 1, i32 0, i1 false) ], !dbg !88
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_6, i32 998, i32 1, i32 0, i1 false) ], !dbg !88
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_7, i32 998, i32 1, i32 0, i1 false) ], !dbg !88
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_8, i32 998, i32 1, i32 0, i1 false) ], !dbg !88
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_9, i32 998, i32 1, i32 0, i1 false) ], !dbg !88
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_10, i32 998, i32 1, i32 0, i1 false) ], !dbg !88
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_11, i32 998, i32 1, i32 0, i1 false) ], !dbg !88
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_12, i32 998, i32 1, i32 0, i1 false) ], !dbg !88
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_13, i32 998, i32 1, i32 0, i1 false) ], !dbg !88
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_14, i32 998, i32 1, i32 0, i1 false) ], !dbg !88
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_15, i32 998, i32 1, i32 0, i1 false) ], !dbg !88
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_03, i32 998, i32 1, i32 0, i1 false) ], !dbg !1531
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_16, i32 998, i32 1, i32 0, i1 false) ], !dbg !1531
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_27, i32 998, i32 1, i32 0, i1 false) ], !dbg !1531
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_38, i32 998, i32 1, i32 0, i1 false) ], !dbg !1531
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_49, i32 998, i32 1, i32 0, i1 false) ], !dbg !1531
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_510, i32 998, i32 1, i32 0, i1 false) ], !dbg !1531
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_611, i32 998, i32 1, i32 0, i1 false) ], !dbg !1531
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_712, i32 998, i32 1, i32 0, i1 false) ], !dbg !1531
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_813, i32 998, i32 1, i32 0, i1 false) ], !dbg !1531
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_914, i32 998, i32 1, i32 0, i1 false) ], !dbg !1531
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1015, i32 998, i32 1, i32 0, i1 false) ], !dbg !1531
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1116, i32 998, i32 1, i32 0, i1 false) ], !dbg !1531
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1217, i32 998, i32 1, i32 0, i1 false) ], !dbg !1531
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1318, i32 998, i32 1, i32 0, i1 false) ], !dbg !1531
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1419, i32 998, i32 1, i32 0, i1 false) ], !dbg !1531
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1520, i32 998, i32 1, i32 0, i1 false) ], !dbg !1531
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_021, i32 998, i32 1, i32 0, i1 false) ], !dbg !1532
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_122, i32 998, i32 1, i32 0, i1 false) ], !dbg !1532
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_223, i32 998, i32 1, i32 0, i1 false) ], !dbg !1532
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_324, i32 998, i32 1, i32 0, i1 false) ], !dbg !1532
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_425, i32 998, i32 1, i32 0, i1 false) ], !dbg !1532
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_526, i32 998, i32 1, i32 0, i1 false) ], !dbg !1532
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_627, i32 998, i32 1, i32 0, i1 false) ], !dbg !1532
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_728, i32 998, i32 1, i32 0, i1 false) ], !dbg !1532
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_829, i32 998, i32 1, i32 0, i1 false) ], !dbg !1532
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_930, i32 998, i32 1, i32 0, i1 false) ], !dbg !1532
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1031, i32 998, i32 1, i32 0, i1 false) ], !dbg !1532
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1132, i32 998, i32 1, i32 0, i1 false) ], !dbg !1532
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1233, i32 998, i32 1, i32 0, i1 false) ], !dbg !1532
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1334, i32 998, i32 1, i32 0, i1 false) ], !dbg !1532
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1435, i32 998, i32 1, i32 0, i1 false) ], !dbg !1532
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1536, i32 998, i32 1, i32 0, i1 false) ], !dbg !1532
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_037, i32 998, i32 1, i32 0, i1 false) ], !dbg !1533
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_138, i32 998, i32 1, i32 0, i1 false) ], !dbg !1533
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_239, i32 998, i32 1, i32 0, i1 false) ], !dbg !1533
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_340, i32 998, i32 1, i32 0, i1 false) ], !dbg !1533
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_441, i32 998, i32 1, i32 0, i1 false) ], !dbg !1533
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_542, i32 998, i32 1, i32 0, i1 false) ], !dbg !1533
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_643, i32 998, i32 1, i32 0, i1 false) ], !dbg !1533
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_744, i32 998, i32 1, i32 0, i1 false) ], !dbg !1533
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_845, i32 998, i32 1, i32 0, i1 false) ], !dbg !1533
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_946, i32 998, i32 1, i32 0, i1 false) ], !dbg !1533
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1047, i32 998, i32 1, i32 0, i1 false) ], !dbg !1533
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1148, i32 998, i32 1, i32 0, i1 false) ], !dbg !1533
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1249, i32 998, i32 1, i32 0, i1 false) ], !dbg !1533
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1350, i32 998, i32 1, i32 0, i1 false) ], !dbg !1533
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1451, i32 998, i32 1, i32 0, i1 false) ], !dbg !1533
  call void @llvm.sideeffect() #10 [ "xlx_array_partition"(i8* %_1552, i32 998, i32 1, i32 0, i1 false) ], !dbg !1533
  call void @apatb_transformer_top_hw(i16* %in_copy, i16* %out_copy, [16 x i8]* %w1_copy_0, [16 x i8]* %w1_copy_1, [16 x i8]* %w1_copy_2, [16 x i8]* %w1_copy_3, [16 x i8]* %w1_copy_4, [16 x i8]* %w1_copy_5, [16 x i8]* %w1_copy_6, [16 x i8]* %w1_copy_7, [16 x i8]* %w1_copy_8, [16 x i8]* %w1_copy_9, [16 x i8]* %w1_copy_10, [16 x i8]* %w1_copy_11, [16 x i8]* %w1_copy_12, [16 x i8]* %w1_copy_13, [16 x i8]* %w1_copy_14, [16 x i8]* %w1_copy_15, [16 x i8]* %w2_copy_0, [16 x i8]* %w2_copy_1, [16 x i8]* %w2_copy_2, [16 x i8]* %w2_copy_3, [16 x i8]* %w2_copy_4, [16 x i8]* %w2_copy_5, [16 x i8]* %w2_copy_6, [16 x i8]* %w2_copy_7, [16 x i8]* %w2_copy_8, [16 x i8]* %w2_copy_9, [16 x i8]* %w2_copy_10, [16 x i8]* %w2_copy_11, [16 x i8]* %w2_copy_12, [16 x i8]* %w2_copy_13, [16 x i8]* %w2_copy_14, [16 x i8]* %w2_copy_15, [16 x i8]* %w3_copy_0, [16 x i8]* %w3_copy_1, [16 x i8]* %w3_copy_2, [16 x i8]* %w3_copy_3, [16 x i8]* %w3_copy_4, [16 x i8]* %w3_copy_5, [16 x i8]* %w3_copy_6, [16 x i8]* %w3_copy_7, [16 x i8]* %w3_copy_8, [16 x i8]* %w3_copy_9, [16 x i8]* %w3_copy_10, [16 x i8]* %w3_copy_11, [16 x i8]* %w3_copy_12, [16 x i8]* %w3_copy_13, [16 x i8]* %w3_copy_14, [16 x i8]* %w3_copy_15, [16 x i8]* %w4_copy_0, [16 x i8]* %w4_copy_1, [16 x i8]* %w4_copy_2, [16 x i8]* %w4_copy_3, [16 x i8]* %w4_copy_4, [16 x i8]* %w4_copy_5, [16 x i8]* %w4_copy_6, [16 x i8]* %w4_copy_7, [16 x i8]* %w4_copy_8, [16 x i8]* %w4_copy_9, [16 x i8]* %w4_copy_10, [16 x i8]* %w4_copy_11, [16 x i8]* %w4_copy_12, [16 x i8]* %w4_copy_13, [16 x i8]* %w4_copy_14, [16 x i8]* %w4_copy_15)
  call void @copy_back(%"class.hls::stream<ap_int<16>>"* %in, i16* %in_copy, %"class.hls::stream<ap_int<16>>"* %out, i16* %out_copy, [16 x [16 x i8]]* %0, [16 x i8]* %w1_copy_0, [16 x i8]* %w1_copy_1, [16 x i8]* %w1_copy_2, [16 x i8]* %w1_copy_3, [16 x i8]* %w1_copy_4, [16 x i8]* %w1_copy_5, [16 x i8]* %w1_copy_6, [16 x i8]* %w1_copy_7, [16 x i8]* %w1_copy_8, [16 x i8]* %w1_copy_9, [16 x i8]* %w1_copy_10, [16 x i8]* %w1_copy_11, [16 x i8]* %w1_copy_12, [16 x i8]* %w1_copy_13, [16 x i8]* %w1_copy_14, [16 x i8]* %w1_copy_15, [16 x [16 x i8]]* %1, [16 x i8]* %w2_copy_0, [16 x i8]* %w2_copy_1, [16 x i8]* %w2_copy_2, [16 x i8]* %w2_copy_3, [16 x i8]* %w2_copy_4, [16 x i8]* %w2_copy_5, [16 x i8]* %w2_copy_6, [16 x i8]* %w2_copy_7, [16 x i8]* %w2_copy_8, [16 x i8]* %w2_copy_9, [16 x i8]* %w2_copy_10, [16 x i8]* %w2_copy_11, [16 x i8]* %w2_copy_12, [16 x i8]* %w2_copy_13, [16 x i8]* %w2_copy_14, [16 x i8]* %w2_copy_15, [16 x [16 x i8]]* %2, [16 x i8]* %w3_copy_0, [16 x i8]* %w3_copy_1, [16 x i8]* %w3_copy_2, [16 x i8]* %w3_copy_3, [16 x i8]* %w3_copy_4, [16 x i8]* %w3_copy_5, [16 x i8]* %w3_copy_6, [16 x i8]* %w3_copy_7, [16 x i8]* %w3_copy_8, [16 x i8]* %w3_copy_9, [16 x i8]* %w3_copy_10, [16 x i8]* %w3_copy_11, [16 x i8]* %w3_copy_12, [16 x i8]* %w3_copy_13, [16 x i8]* %w3_copy_14, [16 x i8]* %w3_copy_15, [16 x [16 x i8]]* %3, [16 x i8]* %w4_copy_0, [16 x i8]* %w4_copy_1, [16 x i8]* %w4_copy_2, [16 x i8]* %w4_copy_3, [16 x i8]* %w4_copy_4, [16 x i8]* %w4_copy_5, [16 x i8]* %w4_copy_6, [16 x i8]* %w4_copy_7, [16 x i8]* %w4_copy_8, [16 x i8]* %w4_copy_9, [16 x i8]* %w4_copy_10, [16 x i8]* %w4_copy_11, [16 x i8]* %w4_copy_12, [16 x i8]* %w4_copy_13, [16 x i8]* %w4_copy_14, [16 x i8]* %w4_copy_15)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @arraycpy_hls.p0a16a16i8([16 x [16 x i8]]* "orig.arg.no"="0" %dst, [16 x [16 x i8]]* readonly "orig.arg.no"="1" %src, i64 "orig.arg.no"="2" %num) local_unnamed_addr #2 {
entry:
  %0 = icmp eq [16 x [16 x i8]]* %src, null
  %1 = icmp eq [16 x [16 x i8]]* %dst, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %dst.addr = getelementptr [16 x [16 x i8]], [16 x [16 x i8]]* %dst, i64 0, i64 %for.loop.idx2
  %src.addr = getelementptr [16 x [16 x i8]], [16 x [16 x i8]]* %src, i64 0, i64 %for.loop.idx2
  call void @arraycpy_hls.p0a16i8([16 x i8]* %dst.addr, [16 x i8]* %src.addr, i64 16)
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @arraycpy_hls.p0a16i8([16 x i8]* "orig.arg.no"="0" %dst, [16 x i8]* readonly "orig.arg.no"="1" %src, i64 "orig.arg.no"="2" %num) local_unnamed_addr #2 {
entry:
  %0 = icmp eq [16 x i8]* %src, null
  %1 = icmp eq [16 x i8]* %dst, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %dst.addr = getelementptr [16 x i8], [16 x i8]* %dst, i64 0, i64 %for.loop.idx2
  %src.addr = getelementptr [16 x i8], [16 x i8]* %src, i64 0, i64 %for.loop.idx2
  %3 = load i8, i8* %src.addr, align 1
  store i8 %3, i8* %dst.addr, align 1
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>>"(%"class.hls::stream<ap_int<16>>"* noalias "unpacked"="0" %dst, i16* noalias nocapture align 512 "unpacked"="1.0" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"class.hls::stream<ap_int<16>>"* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<ap_int<16>>.70"(%"class.hls::stream<ap_int<16>>"* nonnull %dst, i16* align 512 %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<ap_int<16>>.70"(%"class.hls::stream<ap_int<16>>"* noalias nocapture "unpacked"="0", i16* noalias nocapture align 512 "unpacked"="1.0") unnamed_addr #4 {
entry:
  %2 = alloca i16
  %3 = alloca %"class.hls::stream<ap_int<16>>"
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast i16* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_2(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast i16* %2 to i8*
  %7 = bitcast i16* %1 to i8*
  call void @fpga_fifo_pop_2(i8* %6, i8* %7)
  %8 = load volatile i16, i16* %2
  %.ivi = insertvalue %"class.hls::stream<ap_int<16>>" undef, i16 %8, 0, 0, 0, 0
  store %"class.hls::stream<ap_int<16>>" %.ivi, %"class.hls::stream<ap_int<16>>"* %3
  %9 = bitcast %"class.hls::stream<ap_int<16>>"* %3 to i8*
  %10 = bitcast %"class.hls::stream<ap_int<16>>"* %0 to i8*
  call void @fpga_fifo_push_2(i8* %9, i8* %10)
  br label %empty, !llvm.loop !1534

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>>.76"(i16* noalias nocapture align 512 "unpacked"="0.0" %dst, %"class.hls::stream<ap_int<16>>"* noalias "unpacked"="1" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"class.hls::stream<ap_int<16>>"* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<ap_int<16>>.79"(i16* align 512 %dst, %"class.hls::stream<ap_int<16>>"* nonnull %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<ap_int<16>>.79"(i16* noalias nocapture align 512 "unpacked"="0.0", %"class.hls::stream<ap_int<16>>"* noalias nocapture "unpacked"="1") unnamed_addr #4 {
entry:
  %2 = alloca %"class.hls::stream<ap_int<16>>"
  %3 = alloca i16
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast %"class.hls::stream<ap_int<16>>"* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_2(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast %"class.hls::stream<ap_int<16>>"* %2 to i8*
  %7 = bitcast %"class.hls::stream<ap_int<16>>"* %1 to i8*
  call void @fpga_fifo_pop_2(i8* %6, i8* %7)
  %8 = load volatile %"class.hls::stream<ap_int<16>>", %"class.hls::stream<ap_int<16>>"* %2
  %.evi = extractvalue %"class.hls::stream<ap_int<16>>" %8, 0, 0, 0, 0
  store i16 %.evi, i16* %3
  %9 = bitcast i16* %3 to i8*
  %10 = bitcast i16* %0 to i8*
  call void @fpga_fifo_push_2(i8* %9, i8* %10)
  br label %empty, !llvm.loop !1536

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @arraycpy_hls.p0a16i8.102.103(i8* "orig.arg.no"="0" "unpacked"="0.0" %dst_0, i8* "orig.arg.no"="0" "unpacked"="0.1" %dst_1, i8* "orig.arg.no"="0" "unpacked"="0.2" %dst_2, i8* "orig.arg.no"="0" "unpacked"="0.3" %dst_3, i8* "orig.arg.no"="0" "unpacked"="0.4" %dst_4, i8* "orig.arg.no"="0" "unpacked"="0.5" %dst_5, i8* "orig.arg.no"="0" "unpacked"="0.6" %dst_6, i8* "orig.arg.no"="0" "unpacked"="0.7" %dst_7, i8* "orig.arg.no"="0" "unpacked"="0.8" %dst_8, i8* "orig.arg.no"="0" "unpacked"="0.9" %dst_9, i8* "orig.arg.no"="0" "unpacked"="0.10" %dst_10, i8* "orig.arg.no"="0" "unpacked"="0.11" %dst_11, i8* "orig.arg.no"="0" "unpacked"="0.12" %dst_12, i8* "orig.arg.no"="0" "unpacked"="0.13" %dst_13, i8* "orig.arg.no"="0" "unpacked"="0.14" %dst_14, i8* "orig.arg.no"="0" "unpacked"="0.15" %dst_15, [16 x i8]* readonly "orig.arg.no"="1" %src, i64 "orig.arg.no"="2" %num) #2 {
entry:
  %0 = icmp eq [16 x i8]* %src, null
  %1 = icmp eq i8* %dst_0, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %dst.addr.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %dst.addr.exit ]
  %src.addr = getelementptr [16 x i8], [16 x i8]* %src, i64 0, i64 %for.loop.idx2
  %3 = load i8, i8* %src.addr, align 1
  switch i64 %for.loop.idx2, label %dst.addr.exit [
    i64 0, label %dst.addr.case.0
    i64 1, label %dst.addr.case.1
    i64 2, label %dst.addr.case.2
    i64 3, label %dst.addr.case.3
    i64 4, label %dst.addr.case.4
    i64 5, label %dst.addr.case.5
    i64 6, label %dst.addr.case.6
    i64 7, label %dst.addr.case.7
    i64 8, label %dst.addr.case.8
    i64 9, label %dst.addr.case.9
    i64 10, label %dst.addr.case.10
    i64 11, label %dst.addr.case.11
    i64 12, label %dst.addr.case.12
    i64 13, label %dst.addr.case.13
    i64 14, label %dst.addr.case.14
    i64 15, label %dst.addr.case.15
  ]

dst.addr.case.0:                                  ; preds = %for.loop
  store i8 %3, i8* %dst_0, align 1
  br label %dst.addr.exit

dst.addr.case.1:                                  ; preds = %for.loop
  store i8 %3, i8* %dst_1, align 1
  br label %dst.addr.exit

dst.addr.case.2:                                  ; preds = %for.loop
  store i8 %3, i8* %dst_2, align 1
  br label %dst.addr.exit

dst.addr.case.3:                                  ; preds = %for.loop
  store i8 %3, i8* %dst_3, align 1
  br label %dst.addr.exit

dst.addr.case.4:                                  ; preds = %for.loop
  store i8 %3, i8* %dst_4, align 1
  br label %dst.addr.exit

dst.addr.case.5:                                  ; preds = %for.loop
  store i8 %3, i8* %dst_5, align 1
  br label %dst.addr.exit

dst.addr.case.6:                                  ; preds = %for.loop
  store i8 %3, i8* %dst_6, align 1
  br label %dst.addr.exit

dst.addr.case.7:                                  ; preds = %for.loop
  store i8 %3, i8* %dst_7, align 1
  br label %dst.addr.exit

dst.addr.case.8:                                  ; preds = %for.loop
  store i8 %3, i8* %dst_8, align 1
  br label %dst.addr.exit

dst.addr.case.9:                                  ; preds = %for.loop
  store i8 %3, i8* %dst_9, align 1
  br label %dst.addr.exit

dst.addr.case.10:                                 ; preds = %for.loop
  store i8 %3, i8* %dst_10, align 1
  br label %dst.addr.exit

dst.addr.case.11:                                 ; preds = %for.loop
  store i8 %3, i8* %dst_11, align 1
  br label %dst.addr.exit

dst.addr.case.12:                                 ; preds = %for.loop
  store i8 %3, i8* %dst_12, align 1
  br label %dst.addr.exit

dst.addr.case.13:                                 ; preds = %for.loop
  store i8 %3, i8* %dst_13, align 1
  br label %dst.addr.exit

dst.addr.case.14:                                 ; preds = %for.loop
  store i8 %3, i8* %dst_14, align 1
  br label %dst.addr.exit

dst.addr.case.15:                                 ; preds = %for.loop
  store i8 %3, i8* %dst_15, align 1
  br label %dst.addr.exit

dst.addr.exit:                                    ; preds = %dst.addr.case.15, %dst.addr.case.14, %dst.addr.case.13, %dst.addr.case.12, %dst.addr.case.11, %dst.addr.case.10, %dst.addr.case.9, %dst.addr.case.8, %dst.addr.case.7, %dst.addr.case.6, %dst.addr.case.5, %dst.addr.case.4, %dst.addr.case.3, %dst.addr.case.2, %dst.addr.case.1, %dst.addr.case.0, %for.loop
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %dst.addr.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @arraycpy_hls.p0a16a16i8.101.104([16 x i8]* "orig.arg.no"="0" "unpacked"="0.0" %dst_0, [16 x i8]* "orig.arg.no"="0" "unpacked"="0.1" %dst_1, [16 x i8]* "orig.arg.no"="0" "unpacked"="0.2" %dst_2, [16 x i8]* "orig.arg.no"="0" "unpacked"="0.3" %dst_3, [16 x i8]* "orig.arg.no"="0" "unpacked"="0.4" %dst_4, [16 x i8]* "orig.arg.no"="0" "unpacked"="0.5" %dst_5, [16 x i8]* "orig.arg.no"="0" "unpacked"="0.6" %dst_6, [16 x i8]* "orig.arg.no"="0" "unpacked"="0.7" %dst_7, [16 x i8]* "orig.arg.no"="0" "unpacked"="0.8" %dst_8, [16 x i8]* "orig.arg.no"="0" "unpacked"="0.9" %dst_9, [16 x i8]* "orig.arg.no"="0" "unpacked"="0.10" %dst_10, [16 x i8]* "orig.arg.no"="0" "unpacked"="0.11" %dst_11, [16 x i8]* "orig.arg.no"="0" "unpacked"="0.12" %dst_12, [16 x i8]* "orig.arg.no"="0" "unpacked"="0.13" %dst_13, [16 x i8]* "orig.arg.no"="0" "unpacked"="0.14" %dst_14, [16 x i8]* "orig.arg.no"="0" "unpacked"="0.15" %dst_15, [16 x [16 x i8]]* readonly "orig.arg.no"="1" %src, i64 "orig.arg.no"="2" %num) #2 {
entry:
  %0 = icmp eq [16 x [16 x i8]]* %src, null
  %1 = icmp eq [16 x i8]* %dst_0, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %dst.addr_0 = getelementptr [16 x i8], [16 x i8]* %dst_0, i64 0, i64 %for.loop.idx2
  %dst.addr_1 = getelementptr [16 x i8], [16 x i8]* %dst_1, i64 0, i64 %for.loop.idx2
  %dst.addr_2 = getelementptr [16 x i8], [16 x i8]* %dst_2, i64 0, i64 %for.loop.idx2
  %dst.addr_3 = getelementptr [16 x i8], [16 x i8]* %dst_3, i64 0, i64 %for.loop.idx2
  %dst.addr_4 = getelementptr [16 x i8], [16 x i8]* %dst_4, i64 0, i64 %for.loop.idx2
  %dst.addr_5 = getelementptr [16 x i8], [16 x i8]* %dst_5, i64 0, i64 %for.loop.idx2
  %dst.addr_6 = getelementptr [16 x i8], [16 x i8]* %dst_6, i64 0, i64 %for.loop.idx2
  %dst.addr_7 = getelementptr [16 x i8], [16 x i8]* %dst_7, i64 0, i64 %for.loop.idx2
  %dst.addr_8 = getelementptr [16 x i8], [16 x i8]* %dst_8, i64 0, i64 %for.loop.idx2
  %dst.addr_9 = getelementptr [16 x i8], [16 x i8]* %dst_9, i64 0, i64 %for.loop.idx2
  %dst.addr_10 = getelementptr [16 x i8], [16 x i8]* %dst_10, i64 0, i64 %for.loop.idx2
  %dst.addr_11 = getelementptr [16 x i8], [16 x i8]* %dst_11, i64 0, i64 %for.loop.idx2
  %dst.addr_12 = getelementptr [16 x i8], [16 x i8]* %dst_12, i64 0, i64 %for.loop.idx2
  %dst.addr_13 = getelementptr [16 x i8], [16 x i8]* %dst_13, i64 0, i64 %for.loop.idx2
  %dst.addr_14 = getelementptr [16 x i8], [16 x i8]* %dst_14, i64 0, i64 %for.loop.idx2
  %dst.addr_15 = getelementptr [16 x i8], [16 x i8]* %dst_15, i64 0, i64 %for.loop.idx2
  %src.addr = getelementptr [16 x [16 x i8]], [16 x [16 x i8]]* %src, i64 0, i64 %for.loop.idx2
  call void @arraycpy_hls.p0a16i8.102.103(i8* %dst.addr_0, i8* %dst.addr_1, i8* %dst.addr_2, i8* %dst.addr_3, i8* %dst.addr_4, i8* %dst.addr_5, i8* %dst.addr_6, i8* %dst.addr_7, i8* %dst.addr_8, i8* %dst.addr_9, i8* %dst.addr_10, i8* %dst.addr_11, i8* %dst.addr_12, i8* %dst.addr_13, i8* %dst.addr_14, i8* %dst.addr_15, [16 x i8]* %src.addr, i64 16)
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @onebyonecpy_hls.p0a16a16i8.100.105([16 x i8]* noalias align 512 "orig.arg.no"="0" "unpacked"="0.0" %dst_0, [16 x i8]* noalias align 512 "orig.arg.no"="0" "unpacked"="0.1" %dst_1, [16 x i8]* noalias align 512 "orig.arg.no"="0" "unpacked"="0.2" %dst_2, [16 x i8]* noalias align 512 "orig.arg.no"="0" "unpacked"="0.3" %dst_3, [16 x i8]* noalias align 512 "orig.arg.no"="0" "unpacked"="0.4" %dst_4, [16 x i8]* noalias align 512 "orig.arg.no"="0" "unpacked"="0.5" %dst_5, [16 x i8]* noalias align 512 "orig.arg.no"="0" "unpacked"="0.6" %dst_6, [16 x i8]* noalias align 512 "orig.arg.no"="0" "unpacked"="0.7" %dst_7, [16 x i8]* noalias align 512 "orig.arg.no"="0" "unpacked"="0.8" %dst_8, [16 x i8]* noalias align 512 "orig.arg.no"="0" "unpacked"="0.9" %dst_9, [16 x i8]* noalias align 512 "orig.arg.no"="0" "unpacked"="0.10" %dst_10, [16 x i8]* noalias align 512 "orig.arg.no"="0" "unpacked"="0.11" %dst_11, [16 x i8]* noalias align 512 "orig.arg.no"="0" "unpacked"="0.12" %dst_12, [16 x i8]* noalias align 512 "orig.arg.no"="0" "unpacked"="0.13" %dst_13, [16 x i8]* noalias align 512 "orig.arg.no"="0" "unpacked"="0.14" %dst_14, [16 x i8]* noalias align 512 "orig.arg.no"="0" "unpacked"="0.15" %dst_15, [16 x [16 x i8]]* noalias readonly "orig.arg.no"="1" %src) #5 {
entry:
  %0 = icmp eq [16 x i8]* %dst_0, null
  %1 = icmp eq [16 x [16 x i8]]* %src, null
  %2 = or i1 %0, %1
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @arraycpy_hls.p0a16a16i8.101.104([16 x i8]* nonnull %dst_0, [16 x i8]* %dst_1, [16 x i8]* %dst_2, [16 x i8]* %dst_3, [16 x i8]* %dst_4, [16 x i8]* %dst_5, [16 x i8]* %dst_6, [16 x i8]* %dst_7, [16 x i8]* %dst_8, [16 x i8]* %dst_9, [16 x i8]* %dst_10, [16 x i8]* %dst_11, [16 x i8]* %dst_12, [16 x i8]* %dst_13, [16 x i8]* %dst_14, [16 x i8]* %dst_15, [16 x [16 x i8]]* nonnull %src, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal void @copy_in(%"class.hls::stream<ap_int<16>>"* noalias "orig.arg.no"="0" "unpacked"="0", i16* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0", %"class.hls::stream<ap_int<16>>"* noalias "orig.arg.no"="2" "unpacked"="2", i16* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0", [16 x [16 x i8]]* noalias readonly "orig.arg.no"="4" "unpacked"="4", [16 x i8]* noalias align 512 "orig.arg.no"="5" "unpacked"="5.0" %_0, [16 x i8]* noalias align 512 "orig.arg.no"="5" "unpacked"="5.1" %_1, [16 x i8]* noalias align 512 "orig.arg.no"="5" "unpacked"="5.2" %_2, [16 x i8]* noalias align 512 "orig.arg.no"="5" "unpacked"="5.3" %_3, [16 x i8]* noalias align 512 "orig.arg.no"="5" "unpacked"="5.4" %_4, [16 x i8]* noalias align 512 "orig.arg.no"="5" "unpacked"="5.5" %_5, [16 x i8]* noalias align 512 "orig.arg.no"="5" "unpacked"="5.6" %_6, [16 x i8]* noalias align 512 "orig.arg.no"="5" "unpacked"="5.7" %_7, [16 x i8]* noalias align 512 "orig.arg.no"="5" "unpacked"="5.8" %_8, [16 x i8]* noalias align 512 "orig.arg.no"="5" "unpacked"="5.9" %_9, [16 x i8]* noalias align 512 "orig.arg.no"="5" "unpacked"="5.10" %_10, [16 x i8]* noalias align 512 "orig.arg.no"="5" "unpacked"="5.11" %_11, [16 x i8]* noalias align 512 "orig.arg.no"="5" "unpacked"="5.12" %_12, [16 x i8]* noalias align 512 "orig.arg.no"="5" "unpacked"="5.13" %_13, [16 x i8]* noalias align 512 "orig.arg.no"="5" "unpacked"="5.14" %_14, [16 x i8]* noalias align 512 "orig.arg.no"="5" "unpacked"="5.15" %_15, [16 x [16 x i8]]* noalias readonly "orig.arg.no"="6" "unpacked"="6", [16 x i8]* noalias align 512 "orig.arg.no"="7" "unpacked"="7.0" %_01, [16 x i8]* noalias align 512 "orig.arg.no"="7" "unpacked"="7.1" %_16, [16 x i8]* noalias align 512 "orig.arg.no"="7" "unpacked"="7.2" %_27, [16 x i8]* noalias align 512 "orig.arg.no"="7" "unpacked"="7.3" %_38, [16 x i8]* noalias align 512 "orig.arg.no"="7" "unpacked"="7.4" %_49, [16 x i8]* noalias align 512 "orig.arg.no"="7" "unpacked"="7.5" %_510, [16 x i8]* noalias align 512 "orig.arg.no"="7" "unpacked"="7.6" %_611, [16 x i8]* noalias align 512 "orig.arg.no"="7" "unpacked"="7.7" %_712, [16 x i8]* noalias align 512 "orig.arg.no"="7" "unpacked"="7.8" %_813, [16 x i8]* noalias align 512 "orig.arg.no"="7" "unpacked"="7.9" %_914, [16 x i8]* noalias align 512 "orig.arg.no"="7" "unpacked"="7.10" %_1015, [16 x i8]* noalias align 512 "orig.arg.no"="7" "unpacked"="7.11" %_1116, [16 x i8]* noalias align 512 "orig.arg.no"="7" "unpacked"="7.12" %_1217, [16 x i8]* noalias align 512 "orig.arg.no"="7" "unpacked"="7.13" %_1318, [16 x i8]* noalias align 512 "orig.arg.no"="7" "unpacked"="7.14" %_1419, [16 x i8]* noalias align 512 "orig.arg.no"="7" "unpacked"="7.15" %_1520, [16 x [16 x i8]]* noalias readonly "orig.arg.no"="8" "unpacked"="8", [16 x i8]* noalias align 512 "orig.arg.no"="9" "unpacked"="9.0" %_021, [16 x i8]* noalias align 512 "orig.arg.no"="9" "unpacked"="9.1" %_122, [16 x i8]* noalias align 512 "orig.arg.no"="9" "unpacked"="9.2" %_223, [16 x i8]* noalias align 512 "orig.arg.no"="9" "unpacked"="9.3" %_324, [16 x i8]* noalias align 512 "orig.arg.no"="9" "unpacked"="9.4" %_425, [16 x i8]* noalias align 512 "orig.arg.no"="9" "unpacked"="9.5" %_526, [16 x i8]* noalias align 512 "orig.arg.no"="9" "unpacked"="9.6" %_627, [16 x i8]* noalias align 512 "orig.arg.no"="9" "unpacked"="9.7" %_728, [16 x i8]* noalias align 512 "orig.arg.no"="9" "unpacked"="9.8" %_829, [16 x i8]* noalias align 512 "orig.arg.no"="9" "unpacked"="9.9" %_930, [16 x i8]* noalias align 512 "orig.arg.no"="9" "unpacked"="9.10" %_1031, [16 x i8]* noalias align 512 "orig.arg.no"="9" "unpacked"="9.11" %_1132, [16 x i8]* noalias align 512 "orig.arg.no"="9" "unpacked"="9.12" %_1233, [16 x i8]* noalias align 512 "orig.arg.no"="9" "unpacked"="9.13" %_1334, [16 x i8]* noalias align 512 "orig.arg.no"="9" "unpacked"="9.14" %_1435, [16 x i8]* noalias align 512 "orig.arg.no"="9" "unpacked"="9.15" %_1536, [16 x [16 x i8]]* noalias readonly "orig.arg.no"="10" "unpacked"="10", [16 x i8]* noalias align 512 "orig.arg.no"="11" "unpacked"="11.0" %_037, [16 x i8]* noalias align 512 "orig.arg.no"="11" "unpacked"="11.1" %_138, [16 x i8]* noalias align 512 "orig.arg.no"="11" "unpacked"="11.2" %_239, [16 x i8]* noalias align 512 "orig.arg.no"="11" "unpacked"="11.3" %_340, [16 x i8]* noalias align 512 "orig.arg.no"="11" "unpacked"="11.4" %_441, [16 x i8]* noalias align 512 "orig.arg.no"="11" "unpacked"="11.5" %_542, [16 x i8]* noalias align 512 "orig.arg.no"="11" "unpacked"="11.6" %_643, [16 x i8]* noalias align 512 "orig.arg.no"="11" "unpacked"="11.7" %_744, [16 x i8]* noalias align 512 "orig.arg.no"="11" "unpacked"="11.8" %_845, [16 x i8]* noalias align 512 "orig.arg.no"="11" "unpacked"="11.9" %_946, [16 x i8]* noalias align 512 "orig.arg.no"="11" "unpacked"="11.10" %_1047, [16 x i8]* noalias align 512 "orig.arg.no"="11" "unpacked"="11.11" %_1148, [16 x i8]* noalias align 512 "orig.arg.no"="11" "unpacked"="11.12" %_1249, [16 x i8]* noalias align 512 "orig.arg.no"="11" "unpacked"="11.13" %_1350, [16 x i8]* noalias align 512 "orig.arg.no"="11" "unpacked"="11.14" %_1451, [16 x i8]* noalias align 512 "orig.arg.no"="11" "unpacked"="11.15" %_1552) #6 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>>.76"(i16* align 512 %1, %"class.hls::stream<ap_int<16>>"* %0)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>>.76"(i16* align 512 %3, %"class.hls::stream<ap_int<16>>"* %2)
  call void @onebyonecpy_hls.p0a16a16i8.100.105([16 x i8]* align 512 %_0, [16 x i8]* align 512 %_1, [16 x i8]* align 512 %_2, [16 x i8]* align 512 %_3, [16 x i8]* align 512 %_4, [16 x i8]* align 512 %_5, [16 x i8]* align 512 %_6, [16 x i8]* align 512 %_7, [16 x i8]* align 512 %_8, [16 x i8]* align 512 %_9, [16 x i8]* align 512 %_10, [16 x i8]* align 512 %_11, [16 x i8]* align 512 %_12, [16 x i8]* align 512 %_13, [16 x i8]* align 512 %_14, [16 x i8]* align 512 %_15, [16 x [16 x i8]]* %4)
  call void @onebyonecpy_hls.p0a16a16i8.100.105([16 x i8]* align 512 %_01, [16 x i8]* align 512 %_16, [16 x i8]* align 512 %_27, [16 x i8]* align 512 %_38, [16 x i8]* align 512 %_49, [16 x i8]* align 512 %_510, [16 x i8]* align 512 %_611, [16 x i8]* align 512 %_712, [16 x i8]* align 512 %_813, [16 x i8]* align 512 %_914, [16 x i8]* align 512 %_1015, [16 x i8]* align 512 %_1116, [16 x i8]* align 512 %_1217, [16 x i8]* align 512 %_1318, [16 x i8]* align 512 %_1419, [16 x i8]* align 512 %_1520, [16 x [16 x i8]]* %5)
  call void @onebyonecpy_hls.p0a16a16i8.100.105([16 x i8]* align 512 %_021, [16 x i8]* align 512 %_122, [16 x i8]* align 512 %_223, [16 x i8]* align 512 %_324, [16 x i8]* align 512 %_425, [16 x i8]* align 512 %_526, [16 x i8]* align 512 %_627, [16 x i8]* align 512 %_728, [16 x i8]* align 512 %_829, [16 x i8]* align 512 %_930, [16 x i8]* align 512 %_1031, [16 x i8]* align 512 %_1132, [16 x i8]* align 512 %_1233, [16 x i8]* align 512 %_1334, [16 x i8]* align 512 %_1435, [16 x i8]* align 512 %_1536, [16 x [16 x i8]]* %6)
  call void @onebyonecpy_hls.p0a16a16i8.100.105([16 x i8]* align 512 %_037, [16 x i8]* align 512 %_138, [16 x i8]* align 512 %_239, [16 x i8]* align 512 %_340, [16 x i8]* align 512 %_441, [16 x i8]* align 512 %_542, [16 x i8]* align 512 %_643, [16 x i8]* align 512 %_744, [16 x i8]* align 512 %_845, [16 x i8]* align 512 %_946, [16 x i8]* align 512 %_1047, [16 x i8]* align 512 %_1148, [16 x i8]* align 512 %_1249, [16 x i8]* align 512 %_1350, [16 x i8]* align 512 %_1451, [16 x i8]* align 512 %_1552, [16 x [16 x i8]]* %7)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @arraycpy_hls.p0a16i8.120.121([16 x i8]* "orig.arg.no"="0" %dst, i8* readonly "orig.arg.no"="1" "unpacked"="1.0" %src_0, i8* readonly "orig.arg.no"="1" "unpacked"="1.1" %src_1, i8* readonly "orig.arg.no"="1" "unpacked"="1.2" %src_2, i8* readonly "orig.arg.no"="1" "unpacked"="1.3" %src_3, i8* readonly "orig.arg.no"="1" "unpacked"="1.4" %src_4, i8* readonly "orig.arg.no"="1" "unpacked"="1.5" %src_5, i8* readonly "orig.arg.no"="1" "unpacked"="1.6" %src_6, i8* readonly "orig.arg.no"="1" "unpacked"="1.7" %src_7, i8* readonly "orig.arg.no"="1" "unpacked"="1.8" %src_8, i8* readonly "orig.arg.no"="1" "unpacked"="1.9" %src_9, i8* readonly "orig.arg.no"="1" "unpacked"="1.10" %src_10, i8* readonly "orig.arg.no"="1" "unpacked"="1.11" %src_11, i8* readonly "orig.arg.no"="1" "unpacked"="1.12" %src_12, i8* readonly "orig.arg.no"="1" "unpacked"="1.13" %src_13, i8* readonly "orig.arg.no"="1" "unpacked"="1.14" %src_14, i8* readonly "orig.arg.no"="1" "unpacked"="1.15" %src_15, i64 "orig.arg.no"="2" %num) #2 {
entry:
  %0 = icmp eq i8* %src_0, null
  %1 = icmp eq [16 x i8]* %dst, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %src.addr.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %src.addr.exit ]
  %dst.addr = getelementptr [16 x i8], [16 x i8]* %dst, i64 0, i64 %for.loop.idx2
  switch i64 %for.loop.idx2, label %src.addr.exit [
    i64 0, label %src.addr.case.0
    i64 1, label %src.addr.case.1
    i64 2, label %src.addr.case.2
    i64 3, label %src.addr.case.3
    i64 4, label %src.addr.case.4
    i64 5, label %src.addr.case.5
    i64 6, label %src.addr.case.6
    i64 7, label %src.addr.case.7
    i64 8, label %src.addr.case.8
    i64 9, label %src.addr.case.9
    i64 10, label %src.addr.case.10
    i64 11, label %src.addr.case.11
    i64 12, label %src.addr.case.12
    i64 13, label %src.addr.case.13
    i64 14, label %src.addr.case.14
    i64 15, label %src.addr.case.15
  ]

src.addr.case.0:                                  ; preds = %for.loop
  %_0 = load i8, i8* %src_0, align 1
  br label %src.addr.exit

src.addr.case.1:                                  ; preds = %for.loop
  %_1 = load i8, i8* %src_1, align 1
  br label %src.addr.exit

src.addr.case.2:                                  ; preds = %for.loop
  %_2 = load i8, i8* %src_2, align 1
  br label %src.addr.exit

src.addr.case.3:                                  ; preds = %for.loop
  %_3 = load i8, i8* %src_3, align 1
  br label %src.addr.exit

src.addr.case.4:                                  ; preds = %for.loop
  %_4 = load i8, i8* %src_4, align 1
  br label %src.addr.exit

src.addr.case.5:                                  ; preds = %for.loop
  %_5 = load i8, i8* %src_5, align 1
  br label %src.addr.exit

src.addr.case.6:                                  ; preds = %for.loop
  %_6 = load i8, i8* %src_6, align 1
  br label %src.addr.exit

src.addr.case.7:                                  ; preds = %for.loop
  %_7 = load i8, i8* %src_7, align 1
  br label %src.addr.exit

src.addr.case.8:                                  ; preds = %for.loop
  %_8 = load i8, i8* %src_8, align 1
  br label %src.addr.exit

src.addr.case.9:                                  ; preds = %for.loop
  %_9 = load i8, i8* %src_9, align 1
  br label %src.addr.exit

src.addr.case.10:                                 ; preds = %for.loop
  %_10 = load i8, i8* %src_10, align 1
  br label %src.addr.exit

src.addr.case.11:                                 ; preds = %for.loop
  %_11 = load i8, i8* %src_11, align 1
  br label %src.addr.exit

src.addr.case.12:                                 ; preds = %for.loop
  %_12 = load i8, i8* %src_12, align 1
  br label %src.addr.exit

src.addr.case.13:                                 ; preds = %for.loop
  %_13 = load i8, i8* %src_13, align 1
  br label %src.addr.exit

src.addr.case.14:                                 ; preds = %for.loop
  %_14 = load i8, i8* %src_14, align 1
  br label %src.addr.exit

src.addr.case.15:                                 ; preds = %for.loop
  %_15 = load i8, i8* %src_15, align 1
  br label %src.addr.exit

src.addr.exit:                                    ; preds = %src.addr.case.15, %src.addr.case.14, %src.addr.case.13, %src.addr.case.12, %src.addr.case.11, %src.addr.case.10, %src.addr.case.9, %src.addr.case.8, %src.addr.case.7, %src.addr.case.6, %src.addr.case.5, %src.addr.case.4, %src.addr.case.3, %src.addr.case.2, %src.addr.case.1, %src.addr.case.0, %for.loop
  %3 = phi i8 [ %_0, %src.addr.case.0 ], [ %_1, %src.addr.case.1 ], [ %_2, %src.addr.case.2 ], [ %_3, %src.addr.case.3 ], [ %_4, %src.addr.case.4 ], [ %_5, %src.addr.case.5 ], [ %_6, %src.addr.case.6 ], [ %_7, %src.addr.case.7 ], [ %_8, %src.addr.case.8 ], [ %_9, %src.addr.case.9 ], [ %_10, %src.addr.case.10 ], [ %_11, %src.addr.case.11 ], [ %_12, %src.addr.case.12 ], [ %_13, %src.addr.case.13 ], [ %_14, %src.addr.case.14 ], [ %_15, %src.addr.case.15 ], [ undef, %for.loop ]
  store i8 %3, i8* %dst.addr, align 1
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %src.addr.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @arraycpy_hls.p0a16a16i8.119.122([16 x [16 x i8]]* "orig.arg.no"="0" %dst, [16 x i8]* readonly "orig.arg.no"="1" "unpacked"="1.0" %src_0, [16 x i8]* readonly "orig.arg.no"="1" "unpacked"="1.1" %src_1, [16 x i8]* readonly "orig.arg.no"="1" "unpacked"="1.2" %src_2, [16 x i8]* readonly "orig.arg.no"="1" "unpacked"="1.3" %src_3, [16 x i8]* readonly "orig.arg.no"="1" "unpacked"="1.4" %src_4, [16 x i8]* readonly "orig.arg.no"="1" "unpacked"="1.5" %src_5, [16 x i8]* readonly "orig.arg.no"="1" "unpacked"="1.6" %src_6, [16 x i8]* readonly "orig.arg.no"="1" "unpacked"="1.7" %src_7, [16 x i8]* readonly "orig.arg.no"="1" "unpacked"="1.8" %src_8, [16 x i8]* readonly "orig.arg.no"="1" "unpacked"="1.9" %src_9, [16 x i8]* readonly "orig.arg.no"="1" "unpacked"="1.10" %src_10, [16 x i8]* readonly "orig.arg.no"="1" "unpacked"="1.11" %src_11, [16 x i8]* readonly "orig.arg.no"="1" "unpacked"="1.12" %src_12, [16 x i8]* readonly "orig.arg.no"="1" "unpacked"="1.13" %src_13, [16 x i8]* readonly "orig.arg.no"="1" "unpacked"="1.14" %src_14, [16 x i8]* readonly "orig.arg.no"="1" "unpacked"="1.15" %src_15, i64 "orig.arg.no"="2" %num) #2 {
entry:
  %0 = icmp eq [16 x i8]* %src_0, null
  %1 = icmp eq [16 x [16 x i8]]* %dst, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %dst.addr = getelementptr [16 x [16 x i8]], [16 x [16 x i8]]* %dst, i64 0, i64 %for.loop.idx2
  %src.addr_0 = getelementptr [16 x i8], [16 x i8]* %src_0, i64 0, i64 %for.loop.idx2
  %src.addr_1 = getelementptr [16 x i8], [16 x i8]* %src_1, i64 0, i64 %for.loop.idx2
  %src.addr_2 = getelementptr [16 x i8], [16 x i8]* %src_2, i64 0, i64 %for.loop.idx2
  %src.addr_3 = getelementptr [16 x i8], [16 x i8]* %src_3, i64 0, i64 %for.loop.idx2
  %src.addr_4 = getelementptr [16 x i8], [16 x i8]* %src_4, i64 0, i64 %for.loop.idx2
  %src.addr_5 = getelementptr [16 x i8], [16 x i8]* %src_5, i64 0, i64 %for.loop.idx2
  %src.addr_6 = getelementptr [16 x i8], [16 x i8]* %src_6, i64 0, i64 %for.loop.idx2
  %src.addr_7 = getelementptr [16 x i8], [16 x i8]* %src_7, i64 0, i64 %for.loop.idx2
  %src.addr_8 = getelementptr [16 x i8], [16 x i8]* %src_8, i64 0, i64 %for.loop.idx2
  %src.addr_9 = getelementptr [16 x i8], [16 x i8]* %src_9, i64 0, i64 %for.loop.idx2
  %src.addr_10 = getelementptr [16 x i8], [16 x i8]* %src_10, i64 0, i64 %for.loop.idx2
  %src.addr_11 = getelementptr [16 x i8], [16 x i8]* %src_11, i64 0, i64 %for.loop.idx2
  %src.addr_12 = getelementptr [16 x i8], [16 x i8]* %src_12, i64 0, i64 %for.loop.idx2
  %src.addr_13 = getelementptr [16 x i8], [16 x i8]* %src_13, i64 0, i64 %for.loop.idx2
  %src.addr_14 = getelementptr [16 x i8], [16 x i8]* %src_14, i64 0, i64 %for.loop.idx2
  %src.addr_15 = getelementptr [16 x i8], [16 x i8]* %src_15, i64 0, i64 %for.loop.idx2
  call void @arraycpy_hls.p0a16i8.120.121([16 x i8]* %dst.addr, i8* %src.addr_0, i8* %src.addr_1, i8* %src.addr_2, i8* %src.addr_3, i8* %src.addr_4, i8* %src.addr_5, i8* %src.addr_6, i8* %src.addr_7, i8* %src.addr_8, i8* %src.addr_9, i8* %src.addr_10, i8* %src.addr_11, i8* %src.addr_12, i8* %src.addr_13, i8* %src.addr_14, i8* %src.addr_15, i64 16)
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @onebyonecpy_hls.p0a16a16i8.118.123([16 x [16 x i8]]* noalias "orig.arg.no"="0" %dst, [16 x i8]* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.0" %src_0, [16 x i8]* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.1" %src_1, [16 x i8]* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.2" %src_2, [16 x i8]* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.3" %src_3, [16 x i8]* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.4" %src_4, [16 x i8]* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.5" %src_5, [16 x i8]* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.6" %src_6, [16 x i8]* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.7" %src_7, [16 x i8]* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.8" %src_8, [16 x i8]* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.9" %src_9, [16 x i8]* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.10" %src_10, [16 x i8]* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.11" %src_11, [16 x i8]* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.12" %src_12, [16 x i8]* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.13" %src_13, [16 x i8]* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.14" %src_14, [16 x i8]* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.15" %src_15) #5 {
entry:
  %0 = icmp eq [16 x [16 x i8]]* %dst, null
  %1 = icmp eq [16 x i8]* %src_0, null
  %2 = or i1 %0, %1
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @arraycpy_hls.p0a16a16i8.119.122([16 x [16 x i8]]* nonnull %dst, [16 x i8]* nonnull %src_0, [16 x i8]* %src_1, [16 x i8]* %src_2, [16 x i8]* %src_3, [16 x i8]* %src_4, [16 x i8]* %src_5, [16 x i8]* %src_6, [16 x i8]* %src_7, [16 x i8]* %src_8, [16 x i8]* %src_9, [16 x i8]* %src_10, [16 x i8]* %src_11, [16 x i8]* %src_12, [16 x i8]* %src_13, [16 x i8]* %src_14, [16 x i8]* %src_15, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal void @copy_out(%"class.hls::stream<ap_int<16>>"* noalias "orig.arg.no"="0" "unpacked"="0", i16* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0", %"class.hls::stream<ap_int<16>>"* noalias "orig.arg.no"="2" "unpacked"="2", i16* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0", [16 x [16 x i8]]* noalias "orig.arg.no"="4" "unpacked"="4", [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.0" %_0, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.1" %_1, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.2" %_2, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.3" %_3, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.4" %_4, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.5" %_5, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.6" %_6, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.7" %_7, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.8" %_8, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.9" %_9, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.10" %_10, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.11" %_11, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.12" %_12, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.13" %_13, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.14" %_14, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.15" %_15, [16 x [16 x i8]]* noalias "orig.arg.no"="6" "unpacked"="6", [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.0" %_01, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.1" %_16, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.2" %_27, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.3" %_38, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.4" %_49, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.5" %_510, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.6" %_611, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.7" %_712, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.8" %_813, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.9" %_914, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.10" %_1015, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.11" %_1116, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.12" %_1217, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.13" %_1318, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.14" %_1419, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.15" %_1520, [16 x [16 x i8]]* noalias "orig.arg.no"="8" "unpacked"="8", [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.0" %_021, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.1" %_122, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.2" %_223, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.3" %_324, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.4" %_425, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.5" %_526, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.6" %_627, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.7" %_728, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.8" %_829, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.9" %_930, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.10" %_1031, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.11" %_1132, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.12" %_1233, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.13" %_1334, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.14" %_1435, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.15" %_1536, [16 x [16 x i8]]* noalias "orig.arg.no"="10" "unpacked"="10", [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.0" %_037, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.1" %_138, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.2" %_239, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.3" %_340, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.4" %_441, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.5" %_542, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.6" %_643, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.7" %_744, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.8" %_845, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.9" %_946, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.10" %_1047, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.11" %_1148, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.12" %_1249, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.13" %_1350, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.14" %_1451, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.15" %_1552) #7 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>>"(%"class.hls::stream<ap_int<16>>"* %0, i16* align 512 %1)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>>"(%"class.hls::stream<ap_int<16>>"* %2, i16* align 512 %3)
  call void @onebyonecpy_hls.p0a16a16i8.118.123([16 x [16 x i8]]* %4, [16 x i8]* align 512 %_0, [16 x i8]* align 512 %_1, [16 x i8]* align 512 %_2, [16 x i8]* align 512 %_3, [16 x i8]* align 512 %_4, [16 x i8]* align 512 %_5, [16 x i8]* align 512 %_6, [16 x i8]* align 512 %_7, [16 x i8]* align 512 %_8, [16 x i8]* align 512 %_9, [16 x i8]* align 512 %_10, [16 x i8]* align 512 %_11, [16 x i8]* align 512 %_12, [16 x i8]* align 512 %_13, [16 x i8]* align 512 %_14, [16 x i8]* align 512 %_15)
  call void @onebyonecpy_hls.p0a16a16i8.118.123([16 x [16 x i8]]* %5, [16 x i8]* align 512 %_01, [16 x i8]* align 512 %_16, [16 x i8]* align 512 %_27, [16 x i8]* align 512 %_38, [16 x i8]* align 512 %_49, [16 x i8]* align 512 %_510, [16 x i8]* align 512 %_611, [16 x i8]* align 512 %_712, [16 x i8]* align 512 %_813, [16 x i8]* align 512 %_914, [16 x i8]* align 512 %_1015, [16 x i8]* align 512 %_1116, [16 x i8]* align 512 %_1217, [16 x i8]* align 512 %_1318, [16 x i8]* align 512 %_1419, [16 x i8]* align 512 %_1520)
  call void @onebyonecpy_hls.p0a16a16i8.118.123([16 x [16 x i8]]* %6, [16 x i8]* align 512 %_021, [16 x i8]* align 512 %_122, [16 x i8]* align 512 %_223, [16 x i8]* align 512 %_324, [16 x i8]* align 512 %_425, [16 x i8]* align 512 %_526, [16 x i8]* align 512 %_627, [16 x i8]* align 512 %_728, [16 x i8]* align 512 %_829, [16 x i8]* align 512 %_930, [16 x i8]* align 512 %_1031, [16 x i8]* align 512 %_1132, [16 x i8]* align 512 %_1233, [16 x i8]* align 512 %_1334, [16 x i8]* align 512 %_1435, [16 x i8]* align 512 %_1536)
  call void @onebyonecpy_hls.p0a16a16i8.118.123([16 x [16 x i8]]* %7, [16 x i8]* align 512 %_037, [16 x i8]* align 512 %_138, [16 x i8]* align 512 %_239, [16 x i8]* align 512 %_340, [16 x i8]* align 512 %_441, [16 x i8]* align 512 %_542, [16 x i8]* align 512 %_643, [16 x i8]* align 512 %_744, [16 x i8]* align 512 %_845, [16 x i8]* align 512 %_946, [16 x i8]* align 512 %_1047, [16 x i8]* align 512 %_1148, [16 x i8]* align 512 %_1249, [16 x i8]* align 512 %_1350, [16 x i8]* align 512 %_1451, [16 x i8]* align 512 %_1552)
  ret void
}

declare i8* @malloc(i64)

declare void @free(i8*)

declare void @apatb_transformer_top_hw(i16*, i16*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*)

; Function Attrs: argmemonly noinline willreturn
define internal void @copy_back(%"class.hls::stream<ap_int<16>>"* noalias "orig.arg.no"="0" "unpacked"="0", i16* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0", %"class.hls::stream<ap_int<16>>"* noalias "orig.arg.no"="2" "unpacked"="2", i16* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0", [16 x [16 x i8]]* noalias "orig.arg.no"="4" "unpacked"="4", [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.0" %_0, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.1" %_1, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.2" %_2, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.3" %_3, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.4" %_4, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.5" %_5, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.6" %_6, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.7" %_7, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.8" %_8, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.9" %_9, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.10" %_10, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.11" %_11, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.12" %_12, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.13" %_13, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.14" %_14, [16 x i8]* noalias readonly align 512 "orig.arg.no"="5" "unpacked"="5.15" %_15, [16 x [16 x i8]]* noalias "orig.arg.no"="6" "unpacked"="6", [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.0" %_01, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.1" %_16, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.2" %_27, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.3" %_38, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.4" %_49, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.5" %_510, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.6" %_611, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.7" %_712, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.8" %_813, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.9" %_914, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.10" %_1015, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.11" %_1116, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.12" %_1217, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.13" %_1318, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.14" %_1419, [16 x i8]* noalias readonly align 512 "orig.arg.no"="7" "unpacked"="7.15" %_1520, [16 x [16 x i8]]* noalias "orig.arg.no"="8" "unpacked"="8", [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.0" %_021, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.1" %_122, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.2" %_223, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.3" %_324, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.4" %_425, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.5" %_526, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.6" %_627, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.7" %_728, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.8" %_829, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.9" %_930, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.10" %_1031, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.11" %_1132, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.12" %_1233, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.13" %_1334, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.14" %_1435, [16 x i8]* noalias readonly align 512 "orig.arg.no"="9" "unpacked"="9.15" %_1536, [16 x [16 x i8]]* noalias "orig.arg.no"="10" "unpacked"="10", [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.0" %_037, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.1" %_138, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.2" %_239, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.3" %_340, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.4" %_441, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.5" %_542, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.6" %_643, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.7" %_744, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.8" %_845, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.9" %_946, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.10" %_1047, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.11" %_1148, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.12" %_1249, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.13" %_1350, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.14" %_1451, [16 x i8]* noalias readonly align 512 "orig.arg.no"="11" "unpacked"="11.15" %_1552) #7 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>>"(%"class.hls::stream<ap_int<16>>"* %0, i16* align 512 %1)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>>"(%"class.hls::stream<ap_int<16>>"* %2, i16* align 512 %3)
  ret void
}

declare void @transformer_top_hw_stub(%"class.hls::stream<ap_int<16>>"* noalias nocapture nonnull, %"class.hls::stream<ap_int<16>>"* noalias nocapture nonnull, [16 x i8]* noalias nocapture nonnull readonly, [16 x i8]* noalias nocapture nonnull readonly, [16 x i8]* noalias nocapture nonnull readonly, [16 x i8]* noalias nocapture nonnull readonly)

define void @transformer_top_hw_stub_wrapper(i16*, i16*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*, [16 x i8]*) #8 {
entry:
  %66 = call i8* @malloc(i64 2)
  %67 = bitcast i8* %66 to %"class.hls::stream<ap_int<16>>"*
  %68 = call i8* @malloc(i64 2)
  %69 = bitcast i8* %68 to %"class.hls::stream<ap_int<16>>"*
  %70 = call i8* @malloc(i64 256)
  %71 = bitcast i8* %70 to [16 x [16 x i8]]*
  %72 = call i8* @malloc(i64 256)
  %73 = bitcast i8* %72 to [16 x [16 x i8]]*
  %74 = call i8* @malloc(i64 256)
  %75 = bitcast i8* %74 to [16 x [16 x i8]]*
  %76 = call i8* @malloc(i64 256)
  %77 = bitcast i8* %76 to [16 x [16 x i8]]*
  call void @copy_out(%"class.hls::stream<ap_int<16>>"* %67, i16* %0, %"class.hls::stream<ap_int<16>>"* %69, i16* %1, [16 x [16 x i8]]* %71, [16 x i8]* %2, [16 x i8]* %3, [16 x i8]* %4, [16 x i8]* %5, [16 x i8]* %6, [16 x i8]* %7, [16 x i8]* %8, [16 x i8]* %9, [16 x i8]* %10, [16 x i8]* %11, [16 x i8]* %12, [16 x i8]* %13, [16 x i8]* %14, [16 x i8]* %15, [16 x i8]* %16, [16 x i8]* %17, [16 x [16 x i8]]* %73, [16 x i8]* %18, [16 x i8]* %19, [16 x i8]* %20, [16 x i8]* %21, [16 x i8]* %22, [16 x i8]* %23, [16 x i8]* %24, [16 x i8]* %25, [16 x i8]* %26, [16 x i8]* %27, [16 x i8]* %28, [16 x i8]* %29, [16 x i8]* %30, [16 x i8]* %31, [16 x i8]* %32, [16 x i8]* %33, [16 x [16 x i8]]* %75, [16 x i8]* %34, [16 x i8]* %35, [16 x i8]* %36, [16 x i8]* %37, [16 x i8]* %38, [16 x i8]* %39, [16 x i8]* %40, [16 x i8]* %41, [16 x i8]* %42, [16 x i8]* %43, [16 x i8]* %44, [16 x i8]* %45, [16 x i8]* %46, [16 x i8]* %47, [16 x i8]* %48, [16 x i8]* %49, [16 x [16 x i8]]* %77, [16 x i8]* %50, [16 x i8]* %51, [16 x i8]* %52, [16 x i8]* %53, [16 x i8]* %54, [16 x i8]* %55, [16 x i8]* %56, [16 x i8]* %57, [16 x i8]* %58, [16 x i8]* %59, [16 x i8]* %60, [16 x i8]* %61, [16 x i8]* %62, [16 x i8]* %63, [16 x i8]* %64, [16 x i8]* %65)
  %78 = bitcast [16 x [16 x i8]]* %71 to [16 x i8]*
  %79 = bitcast [16 x [16 x i8]]* %73 to [16 x i8]*
  %80 = bitcast [16 x [16 x i8]]* %75 to [16 x i8]*
  %81 = bitcast [16 x [16 x i8]]* %77 to [16 x i8]*
  call void @transformer_top_hw_stub(%"class.hls::stream<ap_int<16>>"* %67, %"class.hls::stream<ap_int<16>>"* %69, [16 x i8]* %78, [16 x i8]* %79, [16 x i8]* %80, [16 x i8]* %81)
  call void @copy_in(%"class.hls::stream<ap_int<16>>"* %67, i16* %0, %"class.hls::stream<ap_int<16>>"* %69, i16* %1, [16 x [16 x i8]]* %71, [16 x i8]* %2, [16 x i8]* %3, [16 x i8]* %4, [16 x i8]* %5, [16 x i8]* %6, [16 x i8]* %7, [16 x i8]* %8, [16 x i8]* %9, [16 x i8]* %10, [16 x i8]* %11, [16 x i8]* %12, [16 x i8]* %13, [16 x i8]* %14, [16 x i8]* %15, [16 x i8]* %16, [16 x i8]* %17, [16 x [16 x i8]]* %73, [16 x i8]* %18, [16 x i8]* %19, [16 x i8]* %20, [16 x i8]* %21, [16 x i8]* %22, [16 x i8]* %23, [16 x i8]* %24, [16 x i8]* %25, [16 x i8]* %26, [16 x i8]* %27, [16 x i8]* %28, [16 x i8]* %29, [16 x i8]* %30, [16 x i8]* %31, [16 x i8]* %32, [16 x i8]* %33, [16 x [16 x i8]]* %75, [16 x i8]* %34, [16 x i8]* %35, [16 x i8]* %36, [16 x i8]* %37, [16 x i8]* %38, [16 x i8]* %39, [16 x i8]* %40, [16 x i8]* %41, [16 x i8]* %42, [16 x i8]* %43, [16 x i8]* %44, [16 x i8]* %45, [16 x i8]* %46, [16 x i8]* %47, [16 x i8]* %48, [16 x i8]* %49, [16 x [16 x i8]]* %77, [16 x i8]* %50, [16 x i8]* %51, [16 x i8]* %52, [16 x i8]* %53, [16 x i8]* %54, [16 x i8]* %55, [16 x i8]* %56, [16 x i8]* %57, [16 x i8]* %58, [16 x i8]* %59, [16 x i8]* %60, [16 x i8]* %61, [16 x i8]* %62, [16 x i8]* %63, [16 x i8]* %64, [16 x i8]* %65)
  call void @free(i8* %66)
  call void @free(i8* %68)
  call void @free(i8* %70)
  call void @free(i8* %72)
  call void @free(i8* %74)
  call void @free(i8* %76)
  ret void
}

declare i1 @fpga_fifo_not_empty_2(i8*)

declare void @fpga_fifo_pop_2(i8*, i8*)

declare void @fpga_fifo_push_2(i8*, i8*)

attributes #0 = { inaccessiblememonly nounwind willreturn }
attributes #1 = { inaccessiblemem_or_argmemonly noinline willreturn "fpga.wrapper.func"="wrapper" }
attributes #2 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="arraycpy_hls" }
attributes #3 = { argmemonly noinline willreturn "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #4 = { argmemonly noinline willreturn "fpga.wrapper.func"="streamcpy_hls" }
attributes #5 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #6 = { argmemonly noinline willreturn "fpga.wrapper.func"="copyin" }
attributes #7 = { argmemonly noinline willreturn "fpga.wrapper.func"="copyout" }
attributes #8 = { "fpga.wrapper.func"="stub" }
attributes #9 = { inaccessiblememonly nounwind willreturn "xlx.port.bitwidth"="16" "xlx.source"="user" }
attributes #10 = { inaccessiblememonly nounwind willreturn "xlx.source"="infer-from-pragma" }

!llvm.dbg.cu = !{}
!llvm.ident = !{!0, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1}
!llvm.module.flags = !{!2, !3, !4}
!blackbox_cfg = !{!5}
!datalayout.transforms.on.top = !{!6, !28, !48, !68}

!0 = !{!"AMD/Xilinx clang version 16.0.6"}
!1 = !{!"clang version 7.0.0 "}
!2 = !{i32 2, !"Dwarf Version", i32 4}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{}
!6 = !{!7, !9, !11}
!7 = !{!8}
!8 = !{!"2", [16 x [16 x i8]]* null}
!9 = !{!10}
!10 = !{!"array_partition", !"type=Complete", !"dim=2"}
!11 = !{!12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27}
!12 = !{!"2.0", [16 x i8]* null}
!13 = !{!"2.1", [16 x i8]* null}
!14 = !{!"2.2", [16 x i8]* null}
!15 = !{!"2.3", [16 x i8]* null}
!16 = !{!"2.4", [16 x i8]* null}
!17 = !{!"2.5", [16 x i8]* null}
!18 = !{!"2.6", [16 x i8]* null}
!19 = !{!"2.7", [16 x i8]* null}
!20 = !{!"2.8", [16 x i8]* null}
!21 = !{!"2.9", [16 x i8]* null}
!22 = !{!"2.10", [16 x i8]* null}
!23 = !{!"2.11", [16 x i8]* null}
!24 = !{!"2.12", [16 x i8]* null}
!25 = !{!"2.13", [16 x i8]* null}
!26 = !{!"2.14", [16 x i8]* null}
!27 = !{!"2.15", [16 x i8]* null}
!28 = !{!29, !9, !31}
!29 = !{!30}
!30 = !{!"3", [16 x [16 x i8]]* null}
!31 = !{!32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42, !43, !44, !45, !46, !47}
!32 = !{!"3.0", [16 x i8]* null}
!33 = !{!"3.1", [16 x i8]* null}
!34 = !{!"3.2", [16 x i8]* null}
!35 = !{!"3.3", [16 x i8]* null}
!36 = !{!"3.4", [16 x i8]* null}
!37 = !{!"3.5", [16 x i8]* null}
!38 = !{!"3.6", [16 x i8]* null}
!39 = !{!"3.7", [16 x i8]* null}
!40 = !{!"3.8", [16 x i8]* null}
!41 = !{!"3.9", [16 x i8]* null}
!42 = !{!"3.10", [16 x i8]* null}
!43 = !{!"3.11", [16 x i8]* null}
!44 = !{!"3.12", [16 x i8]* null}
!45 = !{!"3.13", [16 x i8]* null}
!46 = !{!"3.14", [16 x i8]* null}
!47 = !{!"3.15", [16 x i8]* null}
!48 = !{!49, !9, !51}
!49 = !{!50}
!50 = !{!"4", [16 x [16 x i8]]* null}
!51 = !{!52, !53, !54, !55, !56, !57, !58, !59, !60, !61, !62, !63, !64, !65, !66, !67}
!52 = !{!"4.0", [16 x i8]* null}
!53 = !{!"4.1", [16 x i8]* null}
!54 = !{!"4.2", [16 x i8]* null}
!55 = !{!"4.3", [16 x i8]* null}
!56 = !{!"4.4", [16 x i8]* null}
!57 = !{!"4.5", [16 x i8]* null}
!58 = !{!"4.6", [16 x i8]* null}
!59 = !{!"4.7", [16 x i8]* null}
!60 = !{!"4.8", [16 x i8]* null}
!61 = !{!"4.9", [16 x i8]* null}
!62 = !{!"4.10", [16 x i8]* null}
!63 = !{!"4.11", [16 x i8]* null}
!64 = !{!"4.12", [16 x i8]* null}
!65 = !{!"4.13", [16 x i8]* null}
!66 = !{!"4.14", [16 x i8]* null}
!67 = !{!"4.15", [16 x i8]* null}
!68 = !{!69, !9, !71}
!69 = !{!70}
!70 = !{!"5", [16 x [16 x i8]]* null}
!71 = !{!72, !73, !74, !75, !76, !77, !78, !79, !80, !81, !82, !83, !84, !85, !86, !87}
!72 = !{!"5.0", [16 x i8]* null}
!73 = !{!"5.1", [16 x i8]* null}
!74 = !{!"5.2", [16 x i8]* null}
!75 = !{!"5.3", [16 x i8]* null}
!76 = !{!"5.4", [16 x i8]* null}
!77 = !{!"5.5", [16 x i8]* null}
!78 = !{!"5.6", [16 x i8]* null}
!79 = !{!"5.7", [16 x i8]* null}
!80 = !{!"5.8", [16 x i8]* null}
!81 = !{!"5.9", [16 x i8]* null}
!82 = !{!"5.10", [16 x i8]* null}
!83 = !{!"5.11", [16 x i8]* null}
!84 = !{!"5.12", [16 x i8]* null}
!85 = !{!"5.13", [16 x i8]* null}
!86 = !{!"5.14", [16 x i8]* null}
!87 = !{!"5.15", [16 x i8]* null}
!88 = !DILocation(line: 334, column: 5, scope: !89)
!89 = distinct !DISubprogram(name: "transformer_top", linkageName: "_Z15transformer_topRN3hls6streamI6ap_intILi16EELi0EEES4_PA16_aS6_S6_S6_", scope: !90, file: !90, line: 277, type: !91, isLocal: false, isDefinition: true, scopeLine: 279, flags: DIFlagPrototyped, isOptimized: false, unit: !178, variables: !5)
!90 = !DIFile(filename: "main.cpp", directory: "/home/lutet/tiled-ip/hls_impl/hls_component")
!91 = !DISubroutineType(types: !92)
!92 = !{null, !93, !93, !168, !168, !168, !168}
!93 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !94, size: 64)
!94 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "stream<ap_int<16>, 0>", scope: !96, file: !95, line: 53, size: 16, flags: DIFlagTypePassByReference, elements: !97, templateParams: !165, identifier: "_ZTSN3hls6streamI6ap_intILi16EELi0EEE")
!95 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/common/technology/autopilot/hls_stream_39.h", directory: "/home/lutet")
!96 = !DINamespace(name: "hls", scope: null)
!97 = !{!98, !158}
!98 = !DIDerivedType(tag: DW_TAG_member, name: "V", scope: !94, file: !95, line: 155, baseType: !99, size: 16, flags: DIFlagPublic)
!99 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int<16>", file: !100, line: 19, size: 16, flags: DIFlagTypePassByValue, elements: !101, templateParams: !157, identifier: "_ZTS6ap_intILi16EE")
!100 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/common/technology/autopilot/ap_int.h", directory: "/home/lutet")
!101 = !{!102, !137, !142, !146, !151}
!102 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !99, baseType: !103, extraData: i32 0)
!103 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int_base<16, true>", file: !104, line: 124, size: 16, flags: DIFlagTypePassByValue, elements: !105, templateParams: !135, identifier: "_ZTS11ap_int_baseILi16ELb1EE")
!104 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/common/technology/autopilot/etc/ap_int_base.h", directory: "/home/lutet")
!105 = !{!106, !124, !126, !128}
!106 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !103, baseType: !107, extraData: i32 0)
!107 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ssdm_int<16, true>", file: !108, line: 518, size: 16, flags: DIFlagTypePassByValue, elements: !109, templateParams: !119, identifier: "_ZTS8ssdm_intILi16ELb1EE")
!108 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/common/technology/autopilot/etc/ap_common.h", directory: "/home/lutet")
!109 = !{!110, !112, !116}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "V", scope: !107, file: !108, line: 520, baseType: !111, size: 16)
!111 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!112 = !DISubprogram(name: "ssdm_int", scope: !107, file: !108, line: 521, type: !113, isLocal: false, isDefinition: false, scopeLine: 521, flags: DIFlagPrototyped, isOptimized: false)
!113 = !DISubroutineType(types: !114)
!114 = !{null, !115}
!115 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !107, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!116 = !DISubprogram(name: "ssdm_int", scope: !107, file: !108, line: 522, type: !117, isLocal: false, isDefinition: false, scopeLine: 522, flags: DIFlagPrototyped, isOptimized: false)
!117 = !DISubroutineType(types: !118)
!118 = !{null, !115, !111}
!119 = !{!120, !122}
!120 = !DITemplateValueParameter(name: "_AP_N", type: !121, value: i32 16)
!121 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!122 = !DITemplateValueParameter(name: "_AP_S", type: !123, value: i1 true)
!123 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !103, file: !104, line: 148, baseType: !125, flags: DIFlagStaticMember, extraData: i32 16)
!125 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !121)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "sign_flag", scope: !103, file: !104, line: 149, baseType: !127, flags: DIFlagStaticMember, extraData: i1 true)
!127 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !123)
!128 = !DISubprogram(name: "operator=", linkageName: "_ZN11ap_int_baseILi16ELb1EEaSERKS0_", scope: !103, file: !104, line: 479, type: !129, isLocal: false, isDefinition: false, scopeLine: 479, flags: DIFlagPrototyped, isOptimized: false)
!129 = !DISubroutineType(types: !130)
!130 = !{!131, !132, !133}
!131 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !103, size: 64)
!132 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!133 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !134, size: 64)
!134 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !103)
!135 = !{!136, !122}
!136 = !DITemplateValueParameter(name: "_AP_W", type: !121, value: i32 16)
!137 = !DISubprogram(name: "ap_int", scope: !99, file: !100, line: 143, type: !138, isLocal: false, isDefinition: false, scopeLine: 143, flags: DIFlagPrototyped, isOptimized: false)
!138 = !DISubroutineType(types: !139)
!139 = !{null, !140, !141}
!140 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!141 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!142 = !DISubprogram(name: "ap_int", scope: !99, file: !100, line: 144, type: !143, isLocal: false, isDefinition: false, scopeLine: 144, flags: DIFlagPrototyped, isOptimized: false)
!143 = !DISubroutineType(types: !144)
!144 = !{null, !140, !145}
!145 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!146 = !DISubprogram(name: "ap_int", scope: !99, file: !100, line: 145, type: !147, isLocal: false, isDefinition: false, scopeLine: 145, flags: DIFlagPrototyped, isOptimized: false)
!147 = !DISubroutineType(types: !148)
!148 = !{null, !140, !149}
!149 = !DIDerivedType(tag: DW_TAG_typedef, name: "half", file: !108, line: 623, baseType: !150)
!150 = !DIBasicType(name: "__fp16", size: 16, encoding: DW_ATE_float)
!151 = !DISubprogram(name: "operator=", linkageName: "_ZN6ap_intILi16EEaSERKS0_", scope: !99, file: !100, line: 155, type: !152, isLocal: false, isDefinition: false, scopeLine: 155, flags: DIFlagPrototyped, isOptimized: false)
!152 = !DISubroutineType(types: !153)
!153 = !{!154, !140, !155}
!154 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !99, size: 64)
!155 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !156, size: 64)
!156 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !99)
!157 = !{!136}
!158 = !DISubprogram(name: "set_name", linkageName: "_ZN3hls6streamI6ap_intILi16EELi0EE8set_nameEPKc", scope: !94, file: !95, line: 152, type: !159, isLocal: false, isDefinition: false, scopeLine: 152, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!159 = !DISubroutineType(types: !160)
!160 = !{null, !161, !162}
!161 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!162 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !163, size: 64)
!163 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !164)
!164 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!165 = !{!166, !167}
!166 = !DITemplateTypeParameter(name: "__STREAM_T__", type: !99)
!167 = !DITemplateValueParameter(name: "DEPTH", type: !121, value: i32 0)
!168 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !169, size: 64)
!169 = !DICompositeType(tag: DW_TAG_array_type, baseType: !170, size: 128, elements: !176)
!170 = !DIDerivedType(tag: DW_TAG_typedef, name: "data_t", file: !90, line: 19, baseType: !171)
!171 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !172, line: 24, baseType: !173)
!172 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!173 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !174, line: 37, baseType: !175)
!174 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!175 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!176 = !{!177}
!177 = !DISubrange(count: 16)
!178 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !179, producer: "AMD/Xilinx clang version 16.0.6", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !180, globals: !269, imports: !278, splitDebugInlining: false, gnuPubnames: true)
!179 = !DIFile(filename: "/home/lutet/tiled-ip/hls_impl/hls_component/hls_component/solution1/.autopilot/db/main.pp.0.cpp", directory: "/home/lutet/tiled-ip/hls_impl/hls_component", checksumkind: CSK_MD5, checksum: "f7128d394a7f73e0badf61fdf848801d")
!180 = !{!181, !184, !170, !121, !187, !213, !221, !268, !224}
!181 = !DIDerivedType(tag: DW_TAG_typedef, name: "sum_t", file: !90, line: 21, baseType: !182)
!182 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !172, line: 26, baseType: !183)
!183 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !174, line: 41, baseType: !121)
!184 = !DIDerivedType(tag: DW_TAG_typedef, name: "acc_t", file: !90, line: 20, baseType: !185)
!185 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !172, line: 25, baseType: !186)
!186 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !174, line: 39, baseType: !111)
!187 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int_base<32, true>", file: !104, line: 124, size: 32, flags: DIFlagTypePassByValue, elements: !188, templateParams: !211, identifier: "_ZTS11ap_int_baseILi32ELb1EE")
!188 = !{!189, !202, !203, !204}
!189 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !187, baseType: !190, extraData: i32 0)
!190 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ssdm_int<32, true>", file: !108, line: 518, size: 32, flags: DIFlagTypePassByValue, elements: !191, templateParams: !200, identifier: "_ZTS8ssdm_intILi32ELb1EE")
!191 = !{!192, !193, !197}
!192 = !DIDerivedType(tag: DW_TAG_member, name: "V", scope: !190, file: !108, line: 520, baseType: !121, size: 32)
!193 = !DISubprogram(name: "ssdm_int", scope: !190, file: !108, line: 521, type: !194, isLocal: false, isDefinition: false, scopeLine: 521, flags: DIFlagPrototyped, isOptimized: false)
!194 = !DISubroutineType(types: !195)
!195 = !{null, !196}
!196 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !190, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!197 = !DISubprogram(name: "ssdm_int", scope: !190, file: !108, line: 522, type: !198, isLocal: false, isDefinition: false, scopeLine: 522, flags: DIFlagPrototyped, isOptimized: false)
!198 = !DISubroutineType(types: !199)
!199 = !{null, !196, !121}
!200 = !{!201, !122}
!201 = !DITemplateValueParameter(name: "_AP_N", type: !121, value: i32 32)
!202 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !187, file: !104, line: 148, baseType: !125, flags: DIFlagStaticMember, extraData: i32 32)
!203 = !DIDerivedType(tag: DW_TAG_member, name: "sign_flag", scope: !187, file: !104, line: 149, baseType: !127, flags: DIFlagStaticMember, extraData: i1 true)
!204 = !DISubprogram(name: "operator=", linkageName: "_ZN11ap_int_baseILi32ELb1EEaSERKS0_", scope: !187, file: !104, line: 479, type: !205, isLocal: false, isDefinition: false, scopeLine: 479, flags: DIFlagPrototyped, isOptimized: false)
!205 = !DISubroutineType(types: !206)
!206 = !{!207, !208, !209}
!207 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !187, size: 64)
!208 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !187, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!209 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !210, size: 64)
!210 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !187)
!211 = !{!212, !122}
!212 = !DITemplateValueParameter(name: "_AP_W", type: !121, value: i32 32)
!213 = !DIDerivedType(tag: DW_TAG_typedef, name: "RetType", scope: !187, file: !104, line: 146, baseType: !214)
!214 = !DIDerivedType(tag: DW_TAG_typedef, name: "Type", scope: !215, file: !104, line: 62, baseType: !218)
!215 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "retval<8, true>", file: !104, line: 61, size: 8, flags: DIFlagTypePassByValue, elements: !5, templateParams: !216, identifier: "_ZTS6retvalILi8ELb1EE")
!216 = !{!217, !122}
!217 = !DITemplateValueParameter(name: "_AP_N", type: !121, value: i32 8)
!218 = !DIDerivedType(tag: DW_TAG_typedef, name: "ap_slong", file: !219, line: 187, baseType: !220)
!219 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/common/technology/autopilot/etc/ap_decl.h", directory: "/home/lutet")
!220 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!221 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_uint<8>", file: !100, line: 184, size: 8, flags: DIFlagTypePassByValue, elements: !222, templateParams: !267, identifier: "_ZTS7ap_uintILi8EE")
!222 = !{!223, !251, !255, !258, !261}
!223 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !221, baseType: !224, extraData: i32 0)
!224 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int_base<8, false>", file: !104, line: 124, size: 8, flags: DIFlagTypePassByValue, elements: !225, templateParams: !249, identifier: "_ZTS11ap_int_baseILi8ELb0EE")
!225 = !{!226, !240, !241, !242}
!226 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !224, baseType: !227, extraData: i32 0)
!227 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ssdm_int<8, false>", file: !108, line: 526, size: 8, flags: DIFlagTypePassByValue, elements: !228, templateParams: !238, identifier: "_ZTS8ssdm_intILi8ELb0EE")
!228 = !{!229, !231, !235}
!229 = !DIDerivedType(tag: DW_TAG_member, name: "V", scope: !227, file: !108, line: 528, baseType: !230, size: 8)
!230 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!231 = !DISubprogram(name: "ssdm_int", scope: !227, file: !108, line: 529, type: !232, isLocal: false, isDefinition: false, scopeLine: 529, flags: DIFlagPrototyped, isOptimized: false)
!232 = !DISubroutineType(types: !233)
!233 = !{null, !234}
!234 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !227, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!235 = !DISubprogram(name: "ssdm_int", scope: !227, file: !108, line: 530, type: !236, isLocal: false, isDefinition: false, scopeLine: 530, flags: DIFlagPrototyped, isOptimized: false)
!236 = !DISubroutineType(types: !237)
!237 = !{null, !234, !230}
!238 = !{!217, !239}
!239 = !DITemplateValueParameter(name: "_AP_S", type: !123, value: i1 false)
!240 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !224, file: !104, line: 148, baseType: !125, flags: DIFlagStaticMember, extraData: i32 8)
!241 = !DIDerivedType(tag: DW_TAG_member, name: "sign_flag", scope: !224, file: !104, line: 149, baseType: !127, flags: DIFlagStaticMember, extraData: i1 false)
!242 = !DISubprogram(name: "operator=", linkageName: "_ZN11ap_int_baseILi8ELb0EEaSERKS0_", scope: !224, file: !104, line: 479, type: !243, isLocal: false, isDefinition: false, scopeLine: 479, flags: DIFlagPrototyped, isOptimized: false)
!243 = !DISubroutineType(types: !244)
!244 = !{!245, !246, !247}
!245 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !224, size: 64)
!246 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !224, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!247 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !248, size: 64)
!248 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !224)
!249 = !{!250, !239}
!250 = !DITemplateValueParameter(name: "_AP_W", type: !121, value: i32 8)
!251 = !DISubprogram(name: "ap_uint", scope: !221, file: !100, line: 299, type: !252, isLocal: false, isDefinition: false, scopeLine: 299, flags: DIFlagPrototyped, isOptimized: false)
!252 = !DISubroutineType(types: !253)
!253 = !{null, !254, !141}
!254 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !221, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!255 = !DISubprogram(name: "ap_uint", scope: !221, file: !100, line: 300, type: !256, isLocal: false, isDefinition: false, scopeLine: 300, flags: DIFlagPrototyped, isOptimized: false)
!256 = !DISubroutineType(types: !257)
!257 = !{null, !254, !145}
!258 = !DISubprogram(name: "ap_uint", scope: !221, file: !100, line: 301, type: !259, isLocal: false, isDefinition: false, scopeLine: 301, flags: DIFlagPrototyped, isOptimized: false)
!259 = !DISubroutineType(types: !260)
!260 = !{null, !254, !149}
!261 = !DISubprogram(name: "operator=", linkageName: "_ZN7ap_uintILi8EEaSERKS0_", scope: !221, file: !100, line: 312, type: !262, isLocal: false, isDefinition: false, scopeLine: 312, flags: DIFlagPrototyped, isOptimized: false)
!262 = !DISubroutineType(types: !263)
!263 = !{!264, !254, !265}
!264 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !221, size: 64)
!265 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !266, size: 64)
!266 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !221)
!267 = !{!250}
!268 = !DIDerivedType(tag: DW_TAG_typedef, name: "beat_t", file: !90, line: 22, baseType: !99)
!269 = !{!270}
!270 = !DIGlobalVariableExpression(var: !271, expr: !DIExpression())
!271 = distinct !DIGlobalVariable(name: "EXP_LUT", scope: !272, file: !90, line: 182, type: !275, isLocal: true, isDefinition: true)
!272 = distinct !DISubprogram(name: "stateful_softmax", linkageName: "_Z16stateful_softmaxRN3hls6streamI6ap_intILi16EELi0EEES4_", scope: !90, file: !90, line: 177, type: !273, isLocal: false, isDefinition: true, scopeLine: 177, flags: DIFlagPrototyped, isOptimized: false, unit: !178, variables: !5)
!273 = !DISubroutineType(types: !274)
!274 = !{null, !93, !93}
!275 = !DICompositeType(tag: DW_TAG_array_type, baseType: !125, size: 288, elements: !276)
!276 = !{!277}
!277 = !DISubrange(count: 9)
!278 = !{!279, !284, !290, !294, !301, !305, !313, !318, !320, !324, !328, !332, !342, !344, !348, !352, !356, !361, !365, !369, !373, !377, !385, !389, !393, !395, !399, !403, !408, !414, !418, !422, !424, !432, !436, !443, !445, !449, !453, !457, !461, !466, !470, !475, !476, !477, !478, !480, !481, !482, !483, !484, !485, !486, !589, !593, !599, !601, !603, !607, !609, !611, !613, !615, !617, !619, !621, !626, !630, !632, !634, !639, !641, !643, !645, !647, !649, !651, !654, !656, !658, !662, !666, !668, !670, !672, !674, !676, !678, !680, !682, !684, !686, !690, !694, !696, !698, !700, !702, !704, !706, !708, !710, !712, !714, !716, !718, !720, !722, !724, !728, !732, !736, !738, !740, !742, !744, !746, !748, !750, !752, !754, !758, !762, !766, !768, !770, !772, !776, !780, !784, !786, !788, !790, !792, !794, !796, !798, !800, !802, !804, !806, !808, !812, !816, !820, !822, !824, !826, !828, !832, !836, !838, !840, !842, !844, !846, !848, !852, !856, !858, !860, !862, !864, !868, !872, !876, !878, !880, !882, !884, !886, !888, !892, !896, !900, !902, !906, !910, !912, !914, !916, !918, !920, !922, !939, !942, !947, !955, !960, !964, !968, !972, !976, !978, !980, !984, !990, !994, !1000, !1006, !1008, !1012, !1016, !1020, !1024, !1032, !1034, !1038, !1042, !1046, !1048, !1052, !1056, !1060, !1062, !1064, !1068, !1076, !1080, !1084, !1088, !1090, !1096, !1098, !1104, !1108, !1112, !1116, !1120, !1124, !1128, !1130, !1132, !1136, !1140, !1144, !1146, !1150, !1154, !1156, !1158, !1162, !1166, !1170, !1174, !1175, !1176, !1177, !1178, !1179, !1180, !1181, !1182, !1183, !1184, !1186, !1187, !1188, !1191, !1194, !1196, !1198, !1200, !1204, !1207, !1210, !1213, !1216, !1218, !1222, !1226, !1229, !1232, !1234, !1236, !1238, !1240, !1243, !1246, !1249, !1252, !1255, !1257, !1261, !1265, !1270, !1274, !1276, !1278, !1280, !1282, !1284, !1286, !1288, !1290, !1292, !1294, !1296, !1298, !1300, !1302, !1304, !1308, !1314, !1319, !1323, !1325, !1327, !1329, !1331, !1338, !1342, !1346, !1350, !1354, !1358, !1363, !1367, !1369, !1373, !1379, !1383, !1388, !1390, !1392, !1396, !1400, !1402, !1404, !1406, !1408, !1412, !1414, !1416, !1420, !1424, !1428, !1432, !1436, !1440, !1442, !1446, !1450, !1454, !1458, !1460, !1462, !1466, !1470, !1471, !1472, !1473, !1474, !1475, !1481, !1484, !1485, !1487, !1489, !1491, !1493, !1497, !1499, !1501, !1503, !1505, !1507, !1509, !1511, !1513, !1517, !1521, !1523, !1527}
!279 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !280, entity: !281, file: !283, line: 58)
!280 = !DINamespace(name: "__gnu_debug", scope: null)
!281 = !DINamespace(name: "__debug", scope: !282)
!282 = !DINamespace(name: "std", scope: null)
!283 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/tps/lnx64/gcc-8.3.0/lib/gcc/x86_64-pc-linux-gnu/8.3.0/../../../../include/c++/8.3.0/debug/debug.h", directory: "/home/lutet")
!284 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !285, file: !289, line: 52)
!285 = !DISubprogram(name: "abs", scope: !286, file: !286, line: 980, type: !287, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!286 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!287 = !DISubroutineType(types: !288)
!288 = !{!121, !121}
!289 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/tps/lnx64/gcc-8.3.0/lib/gcc/x86_64-pc-linux-gnu/8.3.0/../../../../include/c++/8.3.0/bits/std_abs.h", directory: "/home/lutet")
!290 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !291, file: !293, line: 127)
!291 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !286, line: 63, baseType: !292)
!292 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !286, line: 59, size: 64, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!293 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/tps/lnx64/gcc-8.3.0/lib/gcc/x86_64-pc-linux-gnu/8.3.0/../../../../include/c++/8.3.0/cstdlib", directory: "/home/lutet")
!294 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !295, file: !293, line: 128)
!295 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !286, line: 71, baseType: !296)
!296 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !286, line: 67, size: 128, flags: DIFlagTypePassByValue, elements: !297, identifier: "_ZTS6ldiv_t")
!297 = !{!298, !300}
!298 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !296, file: !286, line: 69, baseType: !299, size: 64)
!299 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!300 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !296, file: !286, line: 70, baseType: !299, size: 64, offset: 64)
!301 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !302, file: !293, line: 130)
!302 = !DISubprogram(name: "abort", scope: !286, file: !286, line: 730, type: !303, isLocal: false, isDefinition: false, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: false)
!303 = !DISubroutineType(types: !304)
!304 = !{null}
!305 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !306, file: !293, line: 132)
!306 = !DISubprogram(name: "aligned_alloc", scope: !286, file: !286, line: 724, type: !307, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!307 = !DISubroutineType(types: !308)
!308 = !{!309, !310, !310}
!309 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!310 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !311, line: 46, baseType: !312)
!311 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/lnx64/tools/clang-16/lib/clang/16/include/stddef.h", directory: "/home/lutet")
!312 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!313 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !314, file: !293, line: 134)
!314 = !DISubprogram(name: "atexit", scope: !286, file: !286, line: 734, type: !315, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!315 = !DISubroutineType(types: !316)
!316 = !{!121, !317}
!317 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !303, size: 64)
!318 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !319, file: !293, line: 137)
!319 = !DISubprogram(name: "at_quick_exit", scope: !286, file: !286, line: 739, type: !315, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!320 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !321, file: !293, line: 140)
!321 = !DISubprogram(name: "atof", scope: !286, file: !286, line: 102, type: !322, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!322 = !DISubroutineType(types: !323)
!323 = !{!141, !162}
!324 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !325, file: !293, line: 141)
!325 = !DISubprogram(name: "atoi", scope: !286, file: !286, line: 105, type: !326, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!326 = !DISubroutineType(types: !327)
!327 = !{!121, !162}
!328 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !329, file: !293, line: 142)
!329 = !DISubprogram(name: "atol", scope: !286, file: !286, line: 108, type: !330, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!330 = !DISubroutineType(types: !331)
!331 = !{!299, !162}
!332 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !333, file: !293, line: 143)
!333 = !DISubprogram(name: "bsearch", scope: !286, file: !286, line: 960, type: !334, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!334 = !DISubroutineType(types: !335)
!335 = !{!309, !336, !336, !310, !310, !338}
!336 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !337, size: 64)
!337 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!338 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !286, line: 948, baseType: !339)
!339 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !340, size: 64)
!340 = !DISubroutineType(types: !341)
!341 = !{!121, !336, !336}
!342 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !343, file: !293, line: 144)
!343 = !DISubprogram(name: "calloc", scope: !286, file: !286, line: 675, type: !307, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!344 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !345, file: !293, line: 145)
!345 = !DISubprogram(name: "div", scope: !286, file: !286, line: 992, type: !346, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!346 = !DISubroutineType(types: !347)
!347 = !{!291, !121, !121}
!348 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !349, file: !293, line: 146)
!349 = !DISubprogram(name: "exit", scope: !286, file: !286, line: 756, type: !350, isLocal: false, isDefinition: false, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: false)
!350 = !DISubroutineType(types: !351)
!351 = !{null, !121}
!352 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !353, file: !293, line: 147)
!353 = !DISubprogram(name: "free", scope: !286, file: !286, line: 687, type: !354, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!354 = !DISubroutineType(types: !355)
!355 = !{null, !309}
!356 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !357, file: !293, line: 148)
!357 = !DISubprogram(name: "getenv", scope: !286, file: !286, line: 773, type: !358, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!358 = !DISubroutineType(types: !359)
!359 = !{!360, !162}
!360 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !164, size: 64)
!361 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !362, file: !293, line: 149)
!362 = !DISubprogram(name: "labs", scope: !286, file: !286, line: 981, type: !363, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!363 = !DISubroutineType(types: !364)
!364 = !{!299, !299}
!365 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !366, file: !293, line: 150)
!366 = !DISubprogram(name: "ldiv", scope: !286, file: !286, line: 994, type: !367, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!367 = !DISubroutineType(types: !368)
!368 = !{!295, !299, !299}
!369 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !370, file: !293, line: 151)
!370 = !DISubprogram(name: "malloc", scope: !286, file: !286, line: 672, type: !371, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!371 = !DISubroutineType(types: !372)
!372 = !{!309, !310}
!373 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !374, file: !293, line: 153)
!374 = !DISubprogram(name: "mblen", scope: !286, file: !286, line: 1062, type: !375, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!375 = !DISubroutineType(types: !376)
!376 = !{!121, !162, !310}
!377 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !378, file: !293, line: 154)
!378 = !DISubprogram(name: "mbstowcs", scope: !286, file: !286, line: 1073, type: !379, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!379 = !DISubroutineType(types: !380)
!380 = !{!310, !381, !384, !310}
!381 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !382)
!382 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !383, size: 64)
!383 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!384 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !162)
!385 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !386, file: !293, line: 155)
!386 = !DISubprogram(name: "mbtowc", scope: !286, file: !286, line: 1065, type: !387, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!387 = !DISubroutineType(types: !388)
!388 = !{!121, !381, !384, !310}
!389 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !390, file: !293, line: 157)
!390 = !DISubprogram(name: "qsort", scope: !286, file: !286, line: 970, type: !391, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!391 = !DISubroutineType(types: !392)
!392 = !{null, !309, !310, !310, !338}
!393 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !394, file: !293, line: 160)
!394 = !DISubprogram(name: "quick_exit", scope: !286, file: !286, line: 762, type: !350, isLocal: false, isDefinition: false, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: false)
!395 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !396, file: !293, line: 163)
!396 = !DISubprogram(name: "rand", scope: !286, file: !286, line: 573, type: !397, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!397 = !DISubroutineType(types: !398)
!398 = !{!121}
!399 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !400, file: !293, line: 164)
!400 = !DISubprogram(name: "realloc", scope: !286, file: !286, line: 683, type: !401, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!401 = !DISubroutineType(types: !402)
!402 = !{!309, !309, !310}
!403 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !404, file: !293, line: 165)
!404 = !DISubprogram(name: "srand", scope: !286, file: !286, line: 575, type: !405, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!405 = !DISubroutineType(types: !406)
!406 = !{null, !407}
!407 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!408 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !409, file: !293, line: 166)
!409 = !DISubprogram(name: "strtod", scope: !286, file: !286, line: 118, type: !410, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!410 = !DISubroutineType(types: !411)
!411 = !{!141, !384, !412}
!412 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !413)
!413 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !360, size: 64)
!414 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !415, file: !293, line: 167)
!415 = !DISubprogram(name: "strtol", linkageName: "__isoc23_strtol", scope: !286, file: !286, line: 215, type: !416, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!416 = !DISubroutineType(types: !417)
!417 = !{!299, !384, !412, !121}
!418 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !419, file: !293, line: 168)
!419 = !DISubprogram(name: "strtoul", linkageName: "__isoc23_strtoul", scope: !286, file: !286, line: 219, type: !420, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!420 = !DISubroutineType(types: !421)
!421 = !{!312, !384, !412, !121}
!422 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !423, file: !293, line: 169)
!423 = !DISubprogram(name: "system", scope: !286, file: !286, line: 923, type: !326, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!424 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !425, file: !293, line: 171)
!425 = !DISubprogram(name: "wcstombs", scope: !286, file: !286, line: 1077, type: !426, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!426 = !DISubroutineType(types: !427)
!427 = !{!310, !428, !429, !310}
!428 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !360)
!429 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !430)
!430 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !431, size: 64)
!431 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !383)
!432 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !433, file: !293, line: 172)
!433 = !DISubprogram(name: "wctomb", scope: !286, file: !286, line: 1069, type: !434, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!434 = !DISubroutineType(types: !435)
!435 = !{!121, !360, !383}
!436 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !438, file: !293, line: 200)
!437 = !DINamespace(name: "__gnu_cxx", scope: null)
!438 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !286, line: 81, baseType: !439)
!439 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !286, line: 77, size: 128, flags: DIFlagTypePassByValue, elements: !440, identifier: "_ZTS7lldiv_t")
!440 = !{!441, !442}
!441 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !439, file: !286, line: 79, baseType: !220, size: 64)
!442 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !439, file: !286, line: 80, baseType: !220, size: 64, offset: 64)
!443 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !444, file: !293, line: 206)
!444 = !DISubprogram(name: "_Exit", scope: !286, file: !286, line: 768, type: !350, isLocal: false, isDefinition: false, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: false)
!445 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !446, file: !293, line: 210)
!446 = !DISubprogram(name: "llabs", scope: !286, file: !286, line: 984, type: !447, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!447 = !DISubroutineType(types: !448)
!448 = !{!220, !220}
!449 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !450, file: !293, line: 216)
!450 = !DISubprogram(name: "lldiv", scope: !286, file: !286, line: 998, type: !451, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!451 = !DISubroutineType(types: !452)
!452 = !{!438, !220, !220}
!453 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !454, file: !293, line: 227)
!454 = !DISubprogram(name: "atoll", scope: !286, file: !286, line: 113, type: !455, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!455 = !DISubroutineType(types: !456)
!456 = !{!220, !162}
!457 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !458, file: !293, line: 228)
!458 = !DISubprogram(name: "strtoll", linkageName: "__isoc23_strtoll", scope: !286, file: !286, line: 238, type: !459, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!459 = !DISubroutineType(types: !460)
!460 = !{!220, !384, !412, !121}
!461 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !462, file: !293, line: 229)
!462 = !DISubprogram(name: "strtoull", linkageName: "__isoc23_strtoull", scope: !286, file: !286, line: 243, type: !463, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!463 = !DISubroutineType(types: !464)
!464 = !{!465, !384, !412, !121}
!465 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!466 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !467, file: !293, line: 231)
!467 = !DISubprogram(name: "strtof", scope: !286, file: !286, line: 124, type: !468, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!468 = !DISubroutineType(types: !469)
!469 = !{!145, !384, !412}
!470 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !471, file: !293, line: 232)
!471 = !DISubprogram(name: "strtold", scope: !286, file: !286, line: 127, type: !472, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!472 = !DISubroutineType(types: !473)
!473 = !{!474, !384, !412}
!474 = !DIBasicType(name: "long double", size: 64, encoding: DW_ATE_float)
!475 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !438, file: !293, line: 240)
!476 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !444, file: !293, line: 242)
!477 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !446, file: !293, line: 244)
!478 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !479, file: !293, line: 245)
!479 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !437, file: !293, line: 213, type: !451, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!480 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !450, file: !293, line: 246)
!481 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !454, file: !293, line: 248)
!482 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !467, file: !293, line: 249)
!483 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !458, file: !293, line: 250)
!484 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !462, file: !293, line: 251)
!485 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !471, file: !293, line: 252)
!486 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !487, file: !488, line: 57)
!487 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "exception_ptr", scope: !489, file: !488, line: 79, size: 64, flags: DIFlagTypePassByReference, elements: !490, identifier: "_ZTSNSt15__exception_ptr13exception_ptrE")
!488 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/tps/lnx64/gcc-8.3.0/lib/gcc/x86_64-pc-linux-gnu/8.3.0/../../../../include/c++/8.3.0/bits/exception_ptr.h", directory: "/home/lutet")
!489 = !DINamespace(name: "__exception_ptr", scope: !282)
!490 = !{!491, !492, !496, !499, !500, !505, !506, !510, !516, !520, !524, !527, !528, !531, !534}
!491 = !DIDerivedType(tag: DW_TAG_member, name: "_M_exception_object", scope: !487, file: !488, line: 81, baseType: !309, size: 64)
!492 = !DISubprogram(name: "exception_ptr", scope: !487, file: !488, line: 83, type: !493, isLocal: false, isDefinition: false, scopeLine: 83, flags: DIFlagExplicit | DIFlagPrototyped, isOptimized: false)
!493 = !DISubroutineType(types: !494)
!494 = !{null, !495, !309}
!495 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !487, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!496 = !DISubprogram(name: "_M_addref", linkageName: "_ZNSt15__exception_ptr13exception_ptr9_M_addrefEv", scope: !487, file: !488, line: 85, type: !497, isLocal: false, isDefinition: false, scopeLine: 85, flags: DIFlagPrototyped, isOptimized: false)
!497 = !DISubroutineType(types: !498)
!498 = !{null, !495}
!499 = !DISubprogram(name: "_M_release", linkageName: "_ZNSt15__exception_ptr13exception_ptr10_M_releaseEv", scope: !487, file: !488, line: 86, type: !497, isLocal: false, isDefinition: false, scopeLine: 86, flags: DIFlagPrototyped, isOptimized: false)
!500 = !DISubprogram(name: "_M_get", linkageName: "_ZNKSt15__exception_ptr13exception_ptr6_M_getEv", scope: !487, file: !488, line: 88, type: !501, isLocal: false, isDefinition: false, scopeLine: 88, flags: DIFlagPrototyped, isOptimized: false)
!501 = !DISubroutineType(types: !502)
!502 = !{!309, !503}
!503 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !504, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!504 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !487)
!505 = !DISubprogram(name: "exception_ptr", scope: !487, file: !488, line: 96, type: !497, isLocal: false, isDefinition: false, scopeLine: 96, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!506 = !DISubprogram(name: "exception_ptr", scope: !487, file: !488, line: 98, type: !507, isLocal: false, isDefinition: false, scopeLine: 98, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!507 = !DISubroutineType(types: !508)
!508 = !{null, !495, !509}
!509 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !504, size: 64)
!510 = !DISubprogram(name: "exception_ptr", scope: !487, file: !488, line: 101, type: !511, isLocal: false, isDefinition: false, scopeLine: 101, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!511 = !DISubroutineType(types: !512)
!512 = !{null, !495, !513}
!513 = !DIDerivedType(tag: DW_TAG_typedef, name: "nullptr_t", scope: !282, file: !514, line: 242, baseType: !515)
!514 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/tps/lnx64/gcc-8.3.0/lib/gcc/x86_64-pc-linux-gnu/8.3.0/../../../../include/c++/8.3.0/x86_64-pc-linux-gnu/bits/c++config.h", directory: "/home/lutet")
!515 = !DIBasicType(tag: DW_TAG_unspecified_type, name: "decltype(nullptr)")
!516 = !DISubprogram(name: "exception_ptr", scope: !487, file: !488, line: 105, type: !517, isLocal: false, isDefinition: false, scopeLine: 105, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!517 = !DISubroutineType(types: !518)
!518 = !{null, !495, !519}
!519 = !DIDerivedType(tag: DW_TAG_rvalue_reference_type, baseType: !487, size: 64)
!520 = !DISubprogram(name: "operator=", linkageName: "_ZNSt15__exception_ptr13exception_ptraSERKS0_", scope: !487, file: !488, line: 118, type: !521, isLocal: false, isDefinition: false, scopeLine: 118, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!521 = !DISubroutineType(types: !522)
!522 = !{!523, !495, !509}
!523 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !487, size: 64)
!524 = !DISubprogram(name: "operator=", linkageName: "_ZNSt15__exception_ptr13exception_ptraSEOS0_", scope: !487, file: !488, line: 122, type: !525, isLocal: false, isDefinition: false, scopeLine: 122, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!525 = !DISubroutineType(types: !526)
!526 = !{!523, !495, !519}
!527 = !DISubprogram(name: "~exception_ptr", scope: !487, file: !488, line: 129, type: !497, isLocal: false, isDefinition: false, scopeLine: 129, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!528 = !DISubprogram(name: "swap", linkageName: "_ZNSt15__exception_ptr13exception_ptr4swapERS0_", scope: !487, file: !488, line: 132, type: !529, isLocal: false, isDefinition: false, scopeLine: 132, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!529 = !DISubroutineType(types: !530)
!530 = !{null, !495, !523}
!531 = !DISubprogram(name: "operator bool", linkageName: "_ZNKSt15__exception_ptr13exception_ptrcvbEv", scope: !487, file: !488, line: 144, type: !532, isLocal: false, isDefinition: false, scopeLine: 144, flags: DIFlagPublic | DIFlagExplicit | DIFlagPrototyped, isOptimized: false)
!532 = !DISubroutineType(types: !533)
!533 = !{!123, !503}
!534 = !DISubprogram(name: "__cxa_exception_type", linkageName: "_ZNKSt15__exception_ptr13exception_ptr20__cxa_exception_typeEv", scope: !487, file: !488, line: 153, type: !535, isLocal: false, isDefinition: false, scopeLine: 153, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!535 = !DISubroutineType(types: !536)
!536 = !{!537, !503}
!537 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !538, size: 64)
!538 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !539)
!539 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "type_info", scope: !282, file: !540, line: 88, size: 128, flags: DIFlagTypePassByReference, elements: !541, vtableHolder: !539)
!540 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/tps/lnx64/gcc-8.3.0/lib/gcc/x86_64-pc-linux-gnu/8.3.0/../../../../include/c++/8.3.0/typeinfo", directory: "/home/lutet")
!541 = !{!542, !545, !546, !550, !554, !558, !559, !560, !564, !567, !568, !572, !579, !582, !586}
!542 = !DIDerivedType(tag: DW_TAG_member, name: "_vptr$type_info", scope: !540, file: !540, baseType: !543, size: 64, flags: DIFlagArtificial)
!543 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !544, size: 64)
!544 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "__vtbl_ptr_type", baseType: !397, size: 64)
!545 = !DIDerivedType(tag: DW_TAG_member, name: "__name", scope: !539, file: !540, line: 171, baseType: !162, size: 64, offset: 64, flags: DIFlagProtected)
!546 = !DISubprogram(name: "~type_info", scope: !539, file: !540, line: 95, type: !547, isLocal: false, isDefinition: false, scopeLine: 95, containingType: !539, virtuality: DW_VIRTUALITY_virtual, virtualIndex: 0, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!547 = !DISubroutineType(types: !548)
!548 = !{null, !549}
!549 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !539, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!550 = !DISubprogram(name: "name", linkageName: "_ZNKSt9type_info4nameEv", scope: !539, file: !540, line: 99, type: !551, isLocal: false, isDefinition: false, scopeLine: 99, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!551 = !DISubroutineType(types: !552)
!552 = !{!162, !553}
!553 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !538, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!554 = !DISubprogram(name: "before", linkageName: "_ZNKSt9type_info6beforeERKS_", scope: !539, file: !540, line: 115, type: !555, isLocal: false, isDefinition: false, scopeLine: 115, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!555 = !DISubroutineType(types: !556)
!556 = !{!123, !553, !557}
!557 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !538, size: 64)
!558 = !DISubprogram(name: "operator==", linkageName: "_ZNKSt9type_infoeqERKS_", scope: !539, file: !540, line: 120, type: !555, isLocal: false, isDefinition: false, scopeLine: 120, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!559 = !DISubprogram(name: "operator!=", linkageName: "_ZNKSt9type_infoneERKS_", scope: !539, file: !540, line: 136, type: !555, isLocal: false, isDefinition: false, scopeLine: 136, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!560 = !DISubprogram(name: "hash_code", linkageName: "_ZNKSt9type_info9hash_codeEv", scope: !539, file: !540, line: 140, type: !561, isLocal: false, isDefinition: false, scopeLine: 140, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!561 = !DISubroutineType(types: !562)
!562 = !{!563, !553}
!563 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", scope: !282, file: !514, line: 238, baseType: !312)
!564 = !DISubprogram(name: "__is_pointer_p", linkageName: "_ZNKSt9type_info14__is_pointer_pEv", scope: !539, file: !540, line: 152, type: !565, isLocal: false, isDefinition: false, scopeLine: 152, containingType: !539, virtuality: DW_VIRTUALITY_virtual, virtualIndex: 2, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!565 = !DISubroutineType(types: !566)
!566 = !{!123, !553}
!567 = !DISubprogram(name: "__is_function_p", linkageName: "_ZNKSt9type_info15__is_function_pEv", scope: !539, file: !540, line: 155, type: !565, isLocal: false, isDefinition: false, scopeLine: 155, containingType: !539, virtuality: DW_VIRTUALITY_virtual, virtualIndex: 3, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!568 = !DISubprogram(name: "__do_catch", linkageName: "_ZNKSt9type_info10__do_catchEPKS_PPvj", scope: !539, file: !540, line: 163, type: !569, isLocal: false, isDefinition: false, scopeLine: 163, containingType: !539, virtuality: DW_VIRTUALITY_virtual, virtualIndex: 4, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!569 = !DISubroutineType(types: !570)
!570 = !{!123, !553, !537, !571, !407}
!571 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !309, size: 64)
!572 = !DISubprogram(name: "__do_upcast", linkageName: "_ZNKSt9type_info11__do_upcastEPKN10__cxxabiv117__class_type_infoEPPv", scope: !539, file: !540, line: 167, type: !573, isLocal: false, isDefinition: false, scopeLine: 167, containingType: !539, virtuality: DW_VIRTUALITY_virtual, virtualIndex: 5, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: false)
!573 = !DISubroutineType(types: !574)
!574 = !{!123, !553, !575, !571}
!575 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !576, size: 64)
!576 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !577)
!577 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "__class_type_info", scope: !578, file: !540, line: 45, flags: DIFlagFwdDecl, identifier: "_ZTSN10__cxxabiv117__class_type_infoE")
!578 = !DINamespace(name: "__cxxabiv1", scope: null)
!579 = !DISubprogram(name: "type_info", scope: !539, file: !540, line: 173, type: !580, isLocal: false, isDefinition: false, scopeLine: 173, flags: DIFlagProtected | DIFlagExplicit | DIFlagPrototyped, isOptimized: false)
!580 = !DISubroutineType(types: !581)
!581 = !{null, !549, !162}
!582 = !DISubprogram(name: "operator=", linkageName: "_ZNSt9type_infoaSERKS_", scope: !539, file: !540, line: 177, type: !583, isLocal: false, isDefinition: false, scopeLine: 177, flags: DIFlagPrototyped, isOptimized: false)
!583 = !DISubroutineType(types: !584)
!584 = !{!585, !549, !557}
!585 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !539, size: 64)
!586 = !DISubprogram(name: "type_info", scope: !539, file: !540, line: 178, type: !587, isLocal: false, isDefinition: false, scopeLine: 178, flags: DIFlagPrototyped, isOptimized: false)
!587 = !DISubroutineType(types: !588)
!588 = !{null, !549, !557}
!589 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !489, entity: !590, file: !488, line: 73)
!590 = !DISubprogram(name: "rethrow_exception", linkageName: "_ZSt17rethrow_exceptionNSt15__exception_ptr13exception_ptrE", scope: !282, file: !488, line: 69, type: !591, isLocal: false, isDefinition: false, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: false)
!591 = !DISubroutineType(types: !592)
!592 = !{null, !487}
!593 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !594, file: !598, line: 83)
!594 = !DISubprogram(name: "acos", scope: !595, file: !595, line: 53, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!595 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/mathcalls.h", directory: "")
!596 = !DISubroutineType(types: !597)
!597 = !{!141, !141}
!598 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/tps/lnx64/gcc-8.3.0/lib/gcc/x86_64-pc-linux-gnu/8.3.0/../../../../include/c++/8.3.0/cmath", directory: "/home/lutet")
!599 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !600, file: !598, line: 102)
!600 = !DISubprogram(name: "asin", scope: !595, file: !595, line: 55, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!601 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !602, file: !598, line: 121)
!602 = !DISubprogram(name: "atan", scope: !595, file: !595, line: 57, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!603 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !604, file: !598, line: 140)
!604 = !DISubprogram(name: "atan2", scope: !595, file: !595, line: 59, type: !605, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!605 = !DISubroutineType(types: !606)
!606 = !{!141, !141, !141}
!607 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !608, file: !598, line: 161)
!608 = !DISubprogram(name: "ceil", scope: !595, file: !595, line: 159, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!609 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !610, file: !598, line: 180)
!610 = !DISubprogram(name: "cos", scope: !595, file: !595, line: 62, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!611 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !612, file: !598, line: 199)
!612 = !DISubprogram(name: "cosh", scope: !595, file: !595, line: 71, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!613 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !614, file: !598, line: 218)
!614 = !DISubprogram(name: "exp", scope: !595, file: !595, line: 95, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!615 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !616, file: !598, line: 237)
!616 = !DISubprogram(name: "fabs", scope: !595, file: !595, line: 162, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!617 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !618, file: !598, line: 256)
!618 = !DISubprogram(name: "floor", scope: !595, file: !595, line: 165, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!619 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !620, file: !598, line: 275)
!620 = !DISubprogram(name: "fmod", scope: !595, file: !595, line: 168, type: !605, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!621 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !622, file: !598, line: 296)
!622 = !DISubprogram(name: "frexp", scope: !595, file: !595, line: 98, type: !623, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!623 = !DISubroutineType(types: !624)
!624 = !{!141, !141, !625}
!625 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !121, size: 64)
!626 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !627, file: !598, line: 315)
!627 = !DISubprogram(name: "ldexp", scope: !595, file: !595, line: 101, type: !628, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!628 = !DISubroutineType(types: !629)
!629 = !{!141, !141, !121}
!630 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !631, file: !598, line: 334)
!631 = !DISubprogram(name: "log", scope: !595, file: !595, line: 104, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!632 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !633, file: !598, line: 353)
!633 = !DISubprogram(name: "log10", scope: !595, file: !595, line: 107, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!634 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !635, file: !598, line: 372)
!635 = !DISubprogram(name: "modf", scope: !595, file: !595, line: 110, type: !636, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!636 = !DISubroutineType(types: !637)
!637 = !{!141, !141, !638}
!638 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !141, size: 64)
!639 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !640, file: !598, line: 384)
!640 = !DISubprogram(name: "pow", scope: !595, file: !595, line: 140, type: !605, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!641 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !642, file: !598, line: 421)
!642 = !DISubprogram(name: "sin", scope: !595, file: !595, line: 64, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!643 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !644, file: !598, line: 440)
!644 = !DISubprogram(name: "sinh", scope: !595, file: !595, line: 73, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!645 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !646, file: !598, line: 459)
!646 = !DISubprogram(name: "sqrt", scope: !595, file: !595, line: 143, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!647 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !648, file: !598, line: 478)
!648 = !DISubprogram(name: "tan", scope: !595, file: !595, line: 66, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!649 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !650, file: !598, line: 497)
!650 = !DISubprogram(name: "tanh", scope: !595, file: !595, line: 75, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!651 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !652, file: !598, line: 1065)
!652 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !653, line: 164, baseType: !141)
!653 = !DIFile(filename: "/usr/include/math.h", directory: "")
!654 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !655, file: !598, line: 1066)
!655 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !653, line: 163, baseType: !145)
!656 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !657, file: !598, line: 1069)
!657 = !DISubprogram(name: "acosh", scope: !595, file: !595, line: 85, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!658 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !659, file: !598, line: 1070)
!659 = !DISubprogram(name: "acoshf", scope: !595, file: !595, line: 85, type: !660, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!660 = !DISubroutineType(types: !661)
!661 = !{!145, !145}
!662 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !663, file: !598, line: 1071)
!663 = !DISubprogram(name: "acoshl", scope: !595, file: !595, line: 85, type: !664, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!664 = !DISubroutineType(types: !665)
!665 = !{!474, !474}
!666 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !667, file: !598, line: 1073)
!667 = !DISubprogram(name: "asinh", scope: !595, file: !595, line: 87, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!668 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !669, file: !598, line: 1074)
!669 = !DISubprogram(name: "asinhf", scope: !595, file: !595, line: 87, type: !660, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!670 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !671, file: !598, line: 1075)
!671 = !DISubprogram(name: "asinhl", scope: !595, file: !595, line: 87, type: !664, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!672 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !673, file: !598, line: 1077)
!673 = !DISubprogram(name: "atanh", scope: !595, file: !595, line: 89, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!674 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !675, file: !598, line: 1078)
!675 = !DISubprogram(name: "atanhf", scope: !595, file: !595, line: 89, type: !660, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!676 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !677, file: !598, line: 1079)
!677 = !DISubprogram(name: "atanhl", scope: !595, file: !595, line: 89, type: !664, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!678 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !679, file: !598, line: 1081)
!679 = !DISubprogram(name: "cbrt", scope: !595, file: !595, line: 152, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!680 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !681, file: !598, line: 1082)
!681 = !DISubprogram(name: "cbrtf", scope: !595, file: !595, line: 152, type: !660, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!682 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !683, file: !598, line: 1083)
!683 = !DISubprogram(name: "cbrtl", scope: !595, file: !595, line: 152, type: !664, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!684 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !685, file: !598, line: 1085)
!685 = !DISubprogram(name: "copysign", scope: !595, file: !595, line: 198, type: !605, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!686 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !687, file: !598, line: 1086)
!687 = !DISubprogram(name: "copysignf", scope: !595, file: !595, line: 198, type: !688, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!688 = !DISubroutineType(types: !689)
!689 = !{!145, !145, !145}
!690 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !691, file: !598, line: 1087)
!691 = !DISubprogram(name: "copysignl", scope: !595, file: !595, line: 198, type: !692, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!692 = !DISubroutineType(types: !693)
!693 = !{!474, !474, !474}
!694 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !695, file: !598, line: 1089)
!695 = !DISubprogram(name: "erf", scope: !595, file: !595, line: 231, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!696 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !697, file: !598, line: 1090)
!697 = !DISubprogram(name: "erff", scope: !595, file: !595, line: 231, type: !660, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!698 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !699, file: !598, line: 1091)
!699 = !DISubprogram(name: "erfl", scope: !595, file: !595, line: 231, type: !664, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!700 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !701, file: !598, line: 1093)
!701 = !DISubprogram(name: "erfc", scope: !595, file: !595, line: 232, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!702 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !703, file: !598, line: 1094)
!703 = !DISubprogram(name: "erfcf", scope: !595, file: !595, line: 232, type: !660, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!704 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !705, file: !598, line: 1095)
!705 = !DISubprogram(name: "erfcl", scope: !595, file: !595, line: 232, type: !664, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!706 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !707, file: !598, line: 1097)
!707 = !DISubprogram(name: "exp2", scope: !595, file: !595, line: 130, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!708 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !709, file: !598, line: 1098)
!709 = !DISubprogram(name: "exp2f", scope: !595, file: !595, line: 130, type: !660, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!710 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !711, file: !598, line: 1099)
!711 = !DISubprogram(name: "exp2l", scope: !595, file: !595, line: 130, type: !664, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!712 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !713, file: !598, line: 1101)
!713 = !DISubprogram(name: "expm1", scope: !595, file: !595, line: 119, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!714 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !715, file: !598, line: 1102)
!715 = !DISubprogram(name: "expm1f", scope: !595, file: !595, line: 119, type: !660, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!716 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !717, file: !598, line: 1103)
!717 = !DISubprogram(name: "expm1l", scope: !595, file: !595, line: 119, type: !664, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!718 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !719, file: !598, line: 1105)
!719 = !DISubprogram(name: "fdim", scope: !595, file: !595, line: 329, type: !605, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!720 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !721, file: !598, line: 1106)
!721 = !DISubprogram(name: "fdimf", scope: !595, file: !595, line: 329, type: !688, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!722 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !723, file: !598, line: 1107)
!723 = !DISubprogram(name: "fdiml", scope: !595, file: !595, line: 329, type: !692, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!724 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !725, file: !598, line: 1109)
!725 = !DISubprogram(name: "fma", scope: !595, file: !595, line: 340, type: !726, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!726 = !DISubroutineType(types: !727)
!727 = !{!141, !141, !141, !141}
!728 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !729, file: !598, line: 1110)
!729 = !DISubprogram(name: "fmaf", scope: !595, file: !595, line: 340, type: !730, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!730 = !DISubroutineType(types: !731)
!731 = !{!145, !145, !145, !145}
!732 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !733, file: !598, line: 1111)
!733 = !DISubprogram(name: "fmal", scope: !595, file: !595, line: 340, type: !734, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!734 = !DISubroutineType(types: !735)
!735 = !{!474, !474, !474, !474}
!736 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !737, file: !598, line: 1113)
!737 = !DISubprogram(name: "fmax", scope: !595, file: !595, line: 333, type: !605, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!738 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !739, file: !598, line: 1114)
!739 = !DISubprogram(name: "fmaxf", scope: !595, file: !595, line: 333, type: !688, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!740 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !741, file: !598, line: 1115)
!741 = !DISubprogram(name: "fmaxl", scope: !595, file: !595, line: 333, type: !692, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!742 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !743, file: !598, line: 1117)
!743 = !DISubprogram(name: "fmin", scope: !595, file: !595, line: 336, type: !605, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!744 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !745, file: !598, line: 1118)
!745 = !DISubprogram(name: "fminf", scope: !595, file: !595, line: 336, type: !688, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!746 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !747, file: !598, line: 1119)
!747 = !DISubprogram(name: "fminl", scope: !595, file: !595, line: 336, type: !692, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!748 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !749, file: !598, line: 1121)
!749 = !DISubprogram(name: "hypot", scope: !595, file: !595, line: 147, type: !605, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!750 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !751, file: !598, line: 1122)
!751 = !DISubprogram(name: "hypotf", scope: !595, file: !595, line: 147, type: !688, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!752 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !753, file: !598, line: 1123)
!753 = !DISubprogram(name: "hypotl", scope: !595, file: !595, line: 147, type: !692, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!754 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !755, file: !598, line: 1125)
!755 = !DISubprogram(name: "ilogb", scope: !595, file: !595, line: 283, type: !756, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!756 = !DISubroutineType(types: !757)
!757 = !{!121, !141}
!758 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !759, file: !598, line: 1126)
!759 = !DISubprogram(name: "ilogbf", scope: !595, file: !595, line: 283, type: !760, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!760 = !DISubroutineType(types: !761)
!761 = !{!121, !145}
!762 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !763, file: !598, line: 1127)
!763 = !DISubprogram(name: "ilogbl", scope: !595, file: !595, line: 283, type: !764, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!764 = !DISubroutineType(types: !765)
!765 = !{!121, !474}
!766 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !767, file: !598, line: 1129)
!767 = !DISubprogram(name: "lgamma", scope: !595, file: !595, line: 233, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!768 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !769, file: !598, line: 1130)
!769 = !DISubprogram(name: "lgammaf", scope: !595, file: !595, line: 233, type: !660, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!770 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !771, file: !598, line: 1131)
!771 = !DISubprogram(name: "lgammal", scope: !595, file: !595, line: 233, type: !664, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!772 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !773, file: !598, line: 1134)
!773 = !DISubprogram(name: "llrint", scope: !595, file: !595, line: 319, type: !774, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!774 = !DISubroutineType(types: !775)
!775 = !{!220, !141}
!776 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !777, file: !598, line: 1135)
!777 = !DISubprogram(name: "llrintf", scope: !595, file: !595, line: 319, type: !778, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!778 = !DISubroutineType(types: !779)
!779 = !{!220, !145}
!780 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !781, file: !598, line: 1136)
!781 = !DISubprogram(name: "llrintl", scope: !595, file: !595, line: 319, type: !782, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!782 = !DISubroutineType(types: !783)
!783 = !{!220, !474}
!784 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !785, file: !598, line: 1138)
!785 = !DISubprogram(name: "llround", scope: !595, file: !595, line: 325, type: !774, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!786 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !787, file: !598, line: 1139)
!787 = !DISubprogram(name: "llroundf", scope: !595, file: !595, line: 325, type: !778, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!788 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !789, file: !598, line: 1140)
!789 = !DISubprogram(name: "llroundl", scope: !595, file: !595, line: 325, type: !782, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!790 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !791, file: !598, line: 1143)
!791 = !DISubprogram(name: "log1p", scope: !595, file: !595, line: 122, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!792 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !793, file: !598, line: 1144)
!793 = !DISubprogram(name: "log1pf", scope: !595, file: !595, line: 122, type: !660, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!794 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !795, file: !598, line: 1145)
!795 = !DISubprogram(name: "log1pl", scope: !595, file: !595, line: 122, type: !664, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!796 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !797, file: !598, line: 1147)
!797 = !DISubprogram(name: "log2", scope: !595, file: !595, line: 133, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!798 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !799, file: !598, line: 1148)
!799 = !DISubprogram(name: "log2f", scope: !595, file: !595, line: 133, type: !660, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!800 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !801, file: !598, line: 1149)
!801 = !DISubprogram(name: "log2l", scope: !595, file: !595, line: 133, type: !664, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!802 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !803, file: !598, line: 1151)
!803 = !DISubprogram(name: "logb", scope: !595, file: !595, line: 125, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!804 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !805, file: !598, line: 1152)
!805 = !DISubprogram(name: "logbf", scope: !595, file: !595, line: 125, type: !660, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!806 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !807, file: !598, line: 1153)
!807 = !DISubprogram(name: "logbl", scope: !595, file: !595, line: 125, type: !664, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!808 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !809, file: !598, line: 1155)
!809 = !DISubprogram(name: "lrint", scope: !595, file: !595, line: 317, type: !810, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!810 = !DISubroutineType(types: !811)
!811 = !{!299, !141}
!812 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !813, file: !598, line: 1156)
!813 = !DISubprogram(name: "lrintf", scope: !595, file: !595, line: 317, type: !814, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!814 = !DISubroutineType(types: !815)
!815 = !{!299, !145}
!816 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !817, file: !598, line: 1157)
!817 = !DISubprogram(name: "lrintl", scope: !595, file: !595, line: 317, type: !818, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!818 = !DISubroutineType(types: !819)
!819 = !{!299, !474}
!820 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !821, file: !598, line: 1159)
!821 = !DISubprogram(name: "lround", scope: !595, file: !595, line: 323, type: !810, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!822 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !823, file: !598, line: 1160)
!823 = !DISubprogram(name: "lroundf", scope: !595, file: !595, line: 323, type: !814, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!824 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !825, file: !598, line: 1161)
!825 = !DISubprogram(name: "lroundl", scope: !595, file: !595, line: 323, type: !818, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!826 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !827, file: !598, line: 1163)
!827 = !DISubprogram(name: "nan", scope: !595, file: !595, line: 203, type: !322, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!828 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !829, file: !598, line: 1164)
!829 = !DISubprogram(name: "nanf", scope: !595, file: !595, line: 203, type: !830, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!830 = !DISubroutineType(types: !831)
!831 = !{!145, !162}
!832 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !833, file: !598, line: 1165)
!833 = !DISubprogram(name: "nanl", scope: !595, file: !595, line: 203, type: !834, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!834 = !DISubroutineType(types: !835)
!835 = !{!474, !162}
!836 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !837, file: !598, line: 1167)
!837 = !DISubprogram(name: "nearbyint", scope: !595, file: !595, line: 297, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!838 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !839, file: !598, line: 1168)
!839 = !DISubprogram(name: "nearbyintf", scope: !595, file: !595, line: 297, type: !660, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!840 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !841, file: !598, line: 1169)
!841 = !DISubprogram(name: "nearbyintl", scope: !595, file: !595, line: 297, type: !664, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!842 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !843, file: !598, line: 1171)
!843 = !DISubprogram(name: "nextafter", scope: !595, file: !595, line: 262, type: !605, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!844 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !845, file: !598, line: 1172)
!845 = !DISubprogram(name: "nextafterf", scope: !595, file: !595, line: 262, type: !688, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!846 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !847, file: !598, line: 1173)
!847 = !DISubprogram(name: "nextafterl", scope: !595, file: !595, line: 262, type: !692, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!848 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !849, file: !598, line: 1175)
!849 = !DISubprogram(name: "nexttoward", scope: !595, file: !595, line: 264, type: !850, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!850 = !DISubroutineType(types: !851)
!851 = !{!141, !141, !474}
!852 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !853, file: !598, line: 1176)
!853 = !DISubprogram(name: "nexttowardf", scope: !595, file: !595, line: 264, type: !854, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!854 = !DISubroutineType(types: !855)
!855 = !{!145, !145, !474}
!856 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !857, file: !598, line: 1177)
!857 = !DISubprogram(name: "nexttowardl", scope: !595, file: !595, line: 264, type: !692, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!858 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !859, file: !598, line: 1179)
!859 = !DISubprogram(name: "remainder", scope: !595, file: !595, line: 275, type: !605, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!860 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !861, file: !598, line: 1180)
!861 = !DISubprogram(name: "remainderf", scope: !595, file: !595, line: 275, type: !688, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!862 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !863, file: !598, line: 1181)
!863 = !DISubprogram(name: "remainderl", scope: !595, file: !595, line: 275, type: !692, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!864 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !865, file: !598, line: 1183)
!865 = !DISubprogram(name: "remquo", scope: !595, file: !595, line: 310, type: !866, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!866 = !DISubroutineType(types: !867)
!867 = !{!141, !141, !141, !625}
!868 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !869, file: !598, line: 1184)
!869 = !DISubprogram(name: "remquof", scope: !595, file: !595, line: 310, type: !870, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!870 = !DISubroutineType(types: !871)
!871 = !{!145, !145, !145, !625}
!872 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !873, file: !598, line: 1185)
!873 = !DISubprogram(name: "remquol", scope: !595, file: !595, line: 310, type: !874, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!874 = !DISubroutineType(types: !875)
!875 = !{!474, !474, !474, !625}
!876 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !877, file: !598, line: 1187)
!877 = !DISubprogram(name: "rint", scope: !595, file: !595, line: 259, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!878 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !879, file: !598, line: 1188)
!879 = !DISubprogram(name: "rintf", scope: !595, file: !595, line: 259, type: !660, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!880 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !881, file: !598, line: 1189)
!881 = !DISubprogram(name: "rintl", scope: !595, file: !595, line: 259, type: !664, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!882 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !883, file: !598, line: 1191)
!883 = !DISubprogram(name: "round", scope: !595, file: !595, line: 301, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!884 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !885, file: !598, line: 1192)
!885 = !DISubprogram(name: "roundf", scope: !595, file: !595, line: 301, type: !660, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!886 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !887, file: !598, line: 1193)
!887 = !DISubprogram(name: "roundl", scope: !595, file: !595, line: 301, type: !664, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!888 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !889, file: !598, line: 1195)
!889 = !DISubprogram(name: "scalbln", scope: !595, file: !595, line: 293, type: !890, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!890 = !DISubroutineType(types: !891)
!891 = !{!141, !141, !299}
!892 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !893, file: !598, line: 1196)
!893 = !DISubprogram(name: "scalblnf", scope: !595, file: !595, line: 293, type: !894, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!894 = !DISubroutineType(types: !895)
!895 = !{!145, !145, !299}
!896 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !897, file: !598, line: 1197)
!897 = !DISubprogram(name: "scalblnl", scope: !595, file: !595, line: 293, type: !898, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!898 = !DISubroutineType(types: !899)
!899 = !{!474, !474, !299}
!900 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !901, file: !598, line: 1199)
!901 = !DISubprogram(name: "scalbn", scope: !595, file: !595, line: 279, type: !628, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!902 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !903, file: !598, line: 1200)
!903 = !DISubprogram(name: "scalbnf", scope: !595, file: !595, line: 279, type: !904, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!904 = !DISubroutineType(types: !905)
!905 = !{!145, !145, !121}
!906 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !907, file: !598, line: 1201)
!907 = !DISubprogram(name: "scalbnl", scope: !595, file: !595, line: 279, type: !908, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!908 = !DISubroutineType(types: !909)
!909 = !{!474, !474, !121}
!910 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !911, file: !598, line: 1203)
!911 = !DISubprogram(name: "tgamma", scope: !595, file: !595, line: 238, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!912 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !913, file: !598, line: 1204)
!913 = !DISubprogram(name: "tgammaf", scope: !595, file: !595, line: 238, type: !660, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!914 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !915, file: !598, line: 1205)
!915 = !DISubprogram(name: "tgammal", scope: !595, file: !595, line: 238, type: !664, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!916 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !917, file: !598, line: 1207)
!917 = !DISubprogram(name: "trunc", scope: !595, file: !595, line: 305, type: !596, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!918 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !919, file: !598, line: 1208)
!919 = !DISubprogram(name: "truncf", scope: !595, file: !595, line: 305, type: !660, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!920 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !921, file: !598, line: 1209)
!921 = !DISubprogram(name: "truncl", scope: !595, file: !595, line: 305, type: !664, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!922 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !923, file: !938, line: 64)
!923 = !DIDerivedType(tag: DW_TAG_typedef, name: "mbstate_t", file: !924, line: 6, baseType: !925)
!924 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/mbstate_t.h", directory: "")
!925 = !DIDerivedType(tag: DW_TAG_typedef, name: "__mbstate_t", file: !926, line: 21, baseType: !927)
!926 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/__mbstate_t.h", directory: "")
!927 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !926, line: 13, size: 64, flags: DIFlagTypePassByValue, elements: !928, identifier: "_ZTS11__mbstate_t")
!928 = !{!929, !930}
!929 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !927, file: !926, line: 15, baseType: !121, size: 32)
!930 = !DIDerivedType(tag: DW_TAG_member, name: "__value", scope: !927, file: !926, line: 20, baseType: !931, size: 32, offset: 32)
!931 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !927, file: !926, line: 16, size: 32, flags: DIFlagTypePassByValue, elements: !932, identifier: "_ZTSN11__mbstate_tUt_E")
!932 = !{!933, !934}
!933 = !DIDerivedType(tag: DW_TAG_member, name: "__wch", scope: !931, file: !926, line: 18, baseType: !407, size: 32)
!934 = !DIDerivedType(tag: DW_TAG_member, name: "__wchb", scope: !931, file: !926, line: 19, baseType: !935, size: 32)
!935 = !DICompositeType(tag: DW_TAG_array_type, baseType: !164, size: 32, elements: !936)
!936 = !{!937}
!937 = !DISubrange(count: 4)
!938 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/tps/lnx64/gcc-8.3.0/lib/gcc/x86_64-pc-linux-gnu/8.3.0/../../../../include/c++/8.3.0/cwchar", directory: "/home/lutet")
!939 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !940, file: !938, line: 139)
!940 = !DIDerivedType(tag: DW_TAG_typedef, name: "wint_t", file: !941, line: 20, baseType: !407)
!941 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/wint_t.h", directory: "")
!942 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !943, file: !938, line: 141)
!943 = !DISubprogram(name: "btowc", scope: !944, file: !944, line: 309, type: !945, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!944 = !DIFile(filename: "/usr/include/wchar.h", directory: "")
!945 = !DISubroutineType(types: !946)
!946 = !{!940, !121}
!947 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !948, file: !938, line: 142)
!948 = !DISubprogram(name: "fgetwc", scope: !944, file: !944, line: 935, type: !949, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!949 = !DISubroutineType(types: !950)
!950 = !{!940, !951}
!951 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !952, size: 64)
!952 = !DIDerivedType(tag: DW_TAG_typedef, name: "__FILE", file: !953, line: 5, baseType: !954)
!953 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/__FILE.h", directory: "")
!954 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_FILE", file: !953, line: 4, flags: DIFlagFwdDecl, identifier: "_ZTS8_IO_FILE")
!955 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !956, file: !938, line: 143)
!956 = !DISubprogram(name: "fgetws", scope: !944, file: !944, line: 964, type: !957, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!957 = !DISubroutineType(types: !958)
!958 = !{!382, !381, !121, !959}
!959 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !951)
!960 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !961, file: !938, line: 144)
!961 = !DISubprogram(name: "fputwc", scope: !944, file: !944, line: 949, type: !962, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!962 = !DISubroutineType(types: !963)
!963 = !{!940, !383, !951}
!964 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !965, file: !938, line: 145)
!965 = !DISubprogram(name: "fputws", scope: !944, file: !944, line: 971, type: !966, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!966 = !DISubroutineType(types: !967)
!967 = !{!121, !429, !959}
!968 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !969, file: !938, line: 146)
!969 = !DISubprogram(name: "fwide", scope: !944, file: !944, line: 725, type: !970, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!970 = !DISubroutineType(types: !971)
!971 = !{!121, !951, !121}
!972 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !973, file: !938, line: 147)
!973 = !DISubprogram(name: "fwprintf", scope: !944, file: !944, line: 732, type: !974, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!974 = !DISubroutineType(types: !975)
!975 = !{!121, !959, !429, null}
!976 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !977, file: !938, line: 148)
!977 = !DISubprogram(name: "fwscanf", linkageName: "__isoc23_fwscanf", scope: !944, file: !944, line: 795, type: !974, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!978 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !979, file: !938, line: 149)
!979 = !DISubprogram(name: "getwc", scope: !944, file: !944, line: 936, type: !949, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!980 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !981, file: !938, line: 150)
!981 = !DISubprogram(name: "getwchar", scope: !944, file: !944, line: 942, type: !982, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!982 = !DISubroutineType(types: !983)
!983 = !{!940}
!984 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !985, file: !938, line: 151)
!985 = !DISubprogram(name: "mbrlen", scope: !944, file: !944, line: 332, type: !986, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!986 = !DISubroutineType(types: !987)
!987 = !{!310, !384, !310, !988}
!988 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !989)
!989 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !923, size: 64)
!990 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !991, file: !938, line: 152)
!991 = !DISubprogram(name: "mbrtowc", scope: !944, file: !944, line: 321, type: !992, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!992 = !DISubroutineType(types: !993)
!993 = !{!310, !381, !384, !310, !988}
!994 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !995, file: !938, line: 153)
!995 = !DISubprogram(name: "mbsinit", scope: !944, file: !944, line: 317, type: !996, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!996 = !DISubroutineType(types: !997)
!997 = !{!121, !998}
!998 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !999, size: 64)
!999 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !923)
!1000 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1001, file: !938, line: 154)
!1001 = !DISubprogram(name: "mbsrtowcs", scope: !944, file: !944, line: 362, type: !1002, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1002 = !DISubroutineType(types: !1003)
!1003 = !{!310, !381, !1004, !310, !988}
!1004 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1005)
!1005 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !162, size: 64)
!1006 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1007, file: !938, line: 155)
!1007 = !DISubprogram(name: "putwc", scope: !944, file: !944, line: 950, type: !962, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1008 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1009, file: !938, line: 156)
!1009 = !DISubprogram(name: "putwchar", scope: !944, file: !944, line: 956, type: !1010, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1010 = !DISubroutineType(types: !1011)
!1011 = !{!940, !383}
!1012 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1013, file: !938, line: 158)
!1013 = !DISubprogram(name: "swprintf", scope: !944, file: !944, line: 742, type: !1014, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1014 = !DISubroutineType(types: !1015)
!1015 = !{!121, !381, !310, !429, null}
!1016 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1017, file: !938, line: 160)
!1017 = !DISubprogram(name: "swscanf", linkageName: "__isoc23_swscanf", scope: !944, file: !944, line: 802, type: !1018, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1018 = !DISubroutineType(types: !1019)
!1019 = !{!121, !429, !429, null}
!1020 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1021, file: !938, line: 161)
!1021 = !DISubprogram(name: "ungetwc", scope: !944, file: !944, line: 979, type: !1022, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1022 = !DISubroutineType(types: !1023)
!1023 = !{!940, !940, !951}
!1024 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1025, file: !938, line: 162)
!1025 = !DISubprogram(name: "vfwprintf", scope: !944, file: !944, line: 750, type: !1026, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1026 = !DISubroutineType(types: !1027)
!1027 = !{!121, !959, !429, !1028}
!1028 = !DIDerivedType(tag: DW_TAG_typedef, name: "__gnuc_va_list", file: !1029, line: 14, baseType: !1030)
!1029 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/lnx64/tools/clang-16/lib/clang/16/include/stdarg.h", directory: "/home/lutet")
!1030 = !DIDerivedType(tag: DW_TAG_typedef, name: "__builtin_va_list", file: !1031, baseType: !309)
!1031 = !DIFile(filename: "hls_component/solution1/.autopilot/db/main.pp.0.cpp", directory: "/home/lutet/tiled-ip/hls_impl/hls_component")
!1032 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1033, file: !938, line: 164)
!1033 = !DISubprogram(name: "vfwscanf", linkageName: "__isoc23_vfwscanf", scope: !944, file: !944, line: 875, type: !1026, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1034 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1035, file: !938, line: 167)
!1035 = !DISubprogram(name: "vswprintf", scope: !944, file: !944, line: 763, type: !1036, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1036 = !DISubroutineType(types: !1037)
!1037 = !{!121, !381, !310, !429, !1028}
!1038 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1039, file: !938, line: 170)
!1039 = !DISubprogram(name: "vswscanf", linkageName: "__isoc23_vswscanf", scope: !944, file: !944, line: 882, type: !1040, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1040 = !DISubroutineType(types: !1041)
!1041 = !{!121, !429, !429, !1028}
!1042 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1043, file: !938, line: 172)
!1043 = !DISubprogram(name: "vwprintf", scope: !944, file: !944, line: 758, type: !1044, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1044 = !DISubroutineType(types: !1045)
!1045 = !{!121, !429, !1028}
!1046 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1047, file: !938, line: 174)
!1047 = !DISubprogram(name: "vwscanf", linkageName: "__isoc23_vwscanf", scope: !944, file: !944, line: 879, type: !1044, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1048 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1049, file: !938, line: 176)
!1049 = !DISubprogram(name: "wcrtomb", scope: !944, file: !944, line: 326, type: !1050, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1050 = !DISubroutineType(types: !1051)
!1051 = !{!310, !428, !383, !988}
!1052 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1053, file: !938, line: 177)
!1053 = !DISubprogram(name: "wcscat", scope: !944, file: !944, line: 121, type: !1054, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1054 = !DISubroutineType(types: !1055)
!1055 = !{!382, !381, !429}
!1056 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1057, file: !938, line: 178)
!1057 = !DISubprogram(name: "wcscmp", scope: !944, file: !944, line: 130, type: !1058, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1058 = !DISubroutineType(types: !1059)
!1059 = !{!121, !430, !430}
!1060 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1061, file: !938, line: 179)
!1061 = !DISubprogram(name: "wcscoll", scope: !944, file: !944, line: 155, type: !1058, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1062 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1063, file: !938, line: 180)
!1063 = !DISubprogram(name: "wcscpy", scope: !944, file: !944, line: 98, type: !1054, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1064 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1065, file: !938, line: 181)
!1065 = !DISubprogram(name: "wcscspn", scope: !944, file: !944, line: 212, type: !1066, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1066 = !DISubroutineType(types: !1067)
!1067 = !{!310, !430, !430}
!1068 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1069, file: !938, line: 182)
!1069 = !DISubprogram(name: "wcsftime", scope: !944, file: !944, line: 1043, type: !1070, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1070 = !DISubroutineType(types: !1071)
!1071 = !{!310, !381, !310, !429, !1072}
!1072 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1073)
!1073 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1074, size: 64)
!1074 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1075)
!1075 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tm", file: !944, line: 94, flags: DIFlagFwdDecl, identifier: "_ZTS2tm")
!1076 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1077, file: !938, line: 183)
!1077 = !DISubprogram(name: "wcslen", scope: !944, file: !944, line: 247, type: !1078, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1078 = !DISubroutineType(types: !1079)
!1079 = !{!310, !430}
!1080 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1081, file: !938, line: 184)
!1081 = !DISubprogram(name: "wcsncat", scope: !944, file: !944, line: 125, type: !1082, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1082 = !DISubroutineType(types: !1083)
!1083 = !{!382, !381, !429, !310}
!1084 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1085, file: !938, line: 185)
!1085 = !DISubprogram(name: "wcsncmp", scope: !944, file: !944, line: 133, type: !1086, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1086 = !DISubroutineType(types: !1087)
!1087 = !{!121, !430, !430, !310}
!1088 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1089, file: !938, line: 186)
!1089 = !DISubprogram(name: "wcsncpy", scope: !944, file: !944, line: 103, type: !1082, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1090 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1091, file: !938, line: 187)
!1091 = !DISubprogram(name: "wcsrtombs", scope: !944, file: !944, line: 368, type: !1092, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1092 = !DISubroutineType(types: !1093)
!1093 = !{!310, !428, !1094, !310, !988}
!1094 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1095)
!1095 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !430, size: 64)
!1096 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1097, file: !938, line: 188)
!1097 = !DISubprogram(name: "wcsspn", scope: !944, file: !944, line: 216, type: !1066, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1098 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1099, file: !938, line: 189)
!1099 = !DISubprogram(name: "wcstod", scope: !944, file: !944, line: 402, type: !1100, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1100 = !DISubroutineType(types: !1101)
!1101 = !{!141, !429, !1102}
!1102 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1103)
!1103 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !382, size: 64)
!1104 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1105, file: !938, line: 191)
!1105 = !DISubprogram(name: "wcstof", scope: !944, file: !944, line: 407, type: !1106, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1106 = !DISubroutineType(types: !1107)
!1107 = !{!145, !429, !1102}
!1108 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1109, file: !938, line: 193)
!1109 = !DISubprogram(name: "wcstok", scope: !944, file: !944, line: 242, type: !1110, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1110 = !DISubroutineType(types: !1111)
!1111 = !{!382, !381, !429, !1102}
!1112 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1113, file: !938, line: 194)
!1113 = !DISubprogram(name: "wcstol", linkageName: "__isoc23_wcstol", scope: !944, file: !944, line: 500, type: !1114, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1114 = !DISubroutineType(types: !1115)
!1115 = !{!299, !429, !1102, !121}
!1116 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1117, file: !938, line: 195)
!1117 = !DISubprogram(name: "wcstoul", linkageName: "__isoc23_wcstoul", scope: !944, file: !944, line: 503, type: !1118, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1118 = !DISubroutineType(types: !1119)
!1119 = !{!312, !429, !1102, !121}
!1120 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1121, file: !938, line: 196)
!1121 = !DISubprogram(name: "wcsxfrm", scope: !944, file: !944, line: 159, type: !1122, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1122 = !DISubroutineType(types: !1123)
!1123 = !{!310, !381, !429, !310}
!1124 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1125, file: !938, line: 197)
!1125 = !DISubprogram(name: "wctob", scope: !944, file: !944, line: 313, type: !1126, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1126 = !DISubroutineType(types: !1127)
!1127 = !{!121, !940}
!1128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1129, file: !938, line: 198)
!1129 = !DISubprogram(name: "wmemcmp", scope: !944, file: !944, line: 283, type: !1086, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1130 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1131, file: !938, line: 199)
!1131 = !DISubprogram(name: "wmemcpy", scope: !944, file: !944, line: 287, type: !1082, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1132 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1133, file: !938, line: 200)
!1133 = !DISubprogram(name: "wmemmove", scope: !944, file: !944, line: 292, type: !1134, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1134 = !DISubroutineType(types: !1135)
!1135 = !{!382, !382, !430, !310}
!1136 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1137, file: !938, line: 201)
!1137 = !DISubprogram(name: "wmemset", scope: !944, file: !944, line: 296, type: !1138, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1138 = !DISubroutineType(types: !1139)
!1139 = !{!382, !382, !383, !310}
!1140 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1141, file: !938, line: 202)
!1141 = !DISubprogram(name: "wprintf", scope: !944, file: !944, line: 739, type: !1142, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1142 = !DISubroutineType(types: !1143)
!1143 = !{!121, !429, null}
!1144 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1145, file: !938, line: 203)
!1145 = !DISubprogram(name: "wscanf", linkageName: "__isoc23_wscanf", scope: !944, file: !944, line: 799, type: !1142, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1146 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1147, file: !938, line: 204)
!1147 = !DISubprogram(name: "wcschr", scope: !944, file: !944, line: 189, type: !1148, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1148 = !DISubroutineType(types: !1149)
!1149 = !{!382, !430, !383}
!1150 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1151, file: !938, line: 205)
!1151 = !DISubprogram(name: "wcspbrk", scope: !944, file: !944, line: 226, type: !1152, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1152 = !DISubroutineType(types: !1153)
!1153 = !{!382, !430, !430}
!1154 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1155, file: !938, line: 206)
!1155 = !DISubprogram(name: "wcsrchr", scope: !944, file: !944, line: 199, type: !1148, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1156 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1157, file: !938, line: 207)
!1157 = !DISubprogram(name: "wcsstr", scope: !944, file: !944, line: 237, type: !1152, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1159, file: !938, line: 208)
!1159 = !DISubprogram(name: "wmemchr", scope: !944, file: !944, line: 278, type: !1160, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1160 = !DISubroutineType(types: !1161)
!1161 = !{!382, !430, !383, !310}
!1162 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !1163, file: !938, line: 248)
!1163 = !DISubprogram(name: "wcstold", scope: !944, file: !944, line: 409, type: !1164, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1164 = !DISubroutineType(types: !1165)
!1165 = !{!474, !429, !1102}
!1166 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !1167, file: !938, line: 257)
!1167 = !DISubprogram(name: "wcstoll", linkageName: "__isoc23_wcstoll", scope: !944, file: !944, line: 508, type: !1168, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1168 = !DISubroutineType(types: !1169)
!1169 = !{!220, !429, !1102, !121}
!1170 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !1171, file: !938, line: 258)
!1171 = !DISubprogram(name: "wcstoull", linkageName: "__isoc23_wcstoull", scope: !944, file: !944, line: 513, type: !1172, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1172 = !DISubroutineType(types: !1173)
!1173 = !{!465, !429, !1102, !121}
!1174 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1163, file: !938, line: 264)
!1175 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1167, file: !938, line: 265)
!1176 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1171, file: !938, line: 266)
!1177 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1105, file: !938, line: 280)
!1178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1033, file: !938, line: 283)
!1179 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1039, file: !938, line: 286)
!1180 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1047, file: !938, line: 289)
!1181 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1163, file: !938, line: 293)
!1182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1167, file: !938, line: 294)
!1183 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1171, file: !938, line: 295)
!1184 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !171, file: !1185, line: 48)
!1185 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/tps/lnx64/gcc-8.3.0/lib/gcc/x86_64-pc-linux-gnu/8.3.0/../../../../include/c++/8.3.0/cstdint", directory: "/home/lutet")
!1186 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !185, file: !1185, line: 49)
!1187 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !182, file: !1185, line: 50)
!1188 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1189, file: !1185, line: 51)
!1189 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !172, line: 27, baseType: !1190)
!1190 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !174, line: 44, baseType: !299)
!1191 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1192, file: !1185, line: 53)
!1192 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !1193, line: 47, baseType: !175)
!1193 = !DIFile(filename: "/usr/include/stdint.h", directory: "")
!1194 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1195, file: !1185, line: 54)
!1195 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !1193, line: 49, baseType: !299)
!1196 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1197, file: !1185, line: 55)
!1197 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !1193, line: 50, baseType: !299)
!1198 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1199, file: !1185, line: 56)
!1199 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !1193, line: 51, baseType: !299)
!1200 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1201, file: !1185, line: 58)
!1201 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !1202, line: 25, baseType: !1203)
!1202 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-least.h", directory: "")
!1203 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int_least8_t", file: !174, line: 52, baseType: !173)
!1204 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1205, file: !1185, line: 59)
!1205 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !1202, line: 26, baseType: !1206)
!1206 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int_least16_t", file: !174, line: 54, baseType: !186)
!1207 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1208, file: !1185, line: 60)
!1208 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !1202, line: 27, baseType: !1209)
!1209 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int_least32_t", file: !174, line: 56, baseType: !183)
!1210 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1211, file: !1185, line: 61)
!1211 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !1202, line: 28, baseType: !1212)
!1212 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int_least64_t", file: !174, line: 58, baseType: !1190)
!1213 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1214, file: !1185, line: 63)
!1214 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !1193, line: 90, baseType: !1215)
!1215 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !174, line: 72, baseType: !299)
!1216 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1217, file: !1185, line: 64)
!1217 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !1193, line: 76, baseType: !299)
!1218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1219, file: !1185, line: 66)
!1219 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !1220, line: 24, baseType: !1221)
!1220 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!1221 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !174, line: 38, baseType: !230)
!1222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1223, file: !1185, line: 67)
!1223 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !1220, line: 25, baseType: !1224)
!1224 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !174, line: 40, baseType: !1225)
!1225 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!1226 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1227, file: !1185, line: 68)
!1227 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !1220, line: 26, baseType: !1228)
!1228 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !174, line: 42, baseType: !407)
!1229 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1230, file: !1185, line: 69)
!1230 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !1220, line: 27, baseType: !1231)
!1231 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !174, line: 45, baseType: !312)
!1232 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1233, file: !1185, line: 71)
!1233 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !1193, line: 60, baseType: !230)
!1234 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1235, file: !1185, line: 72)
!1235 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !1193, line: 62, baseType: !312)
!1236 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1237, file: !1185, line: 73)
!1237 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !1193, line: 63, baseType: !312)
!1238 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1239, file: !1185, line: 74)
!1239 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !1193, line: 64, baseType: !312)
!1240 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1241, file: !1185, line: 76)
!1241 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !1202, line: 31, baseType: !1242)
!1242 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint_least8_t", file: !174, line: 53, baseType: !1221)
!1243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1244, file: !1185, line: 77)
!1244 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !1202, line: 32, baseType: !1245)
!1245 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint_least16_t", file: !174, line: 55, baseType: !1224)
!1246 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1247, file: !1185, line: 78)
!1247 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !1202, line: 33, baseType: !1248)
!1248 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint_least32_t", file: !174, line: 57, baseType: !1228)
!1249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1250, file: !1185, line: 79)
!1250 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !1202, line: 34, baseType: !1251)
!1251 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint_least64_t", file: !174, line: 59, baseType: !1231)
!1252 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1253, file: !1185, line: 81)
!1253 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !1193, line: 91, baseType: !1254)
!1254 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !174, line: 73, baseType: !312)
!1255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1256, file: !1185, line: 82)
!1256 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !1193, line: 79, baseType: !312)
!1257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1258, file: !1260, line: 53)
!1258 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "lconv", file: !1259, line: 51, size: 768, flags: DIFlagFwdDecl, identifier: "_ZTS5lconv")
!1259 = !DIFile(filename: "/usr/include/locale.h", directory: "")
!1260 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/tps/lnx64/gcc-8.3.0/lib/gcc/x86_64-pc-linux-gnu/8.3.0/../../../../include/c++/8.3.0/clocale", directory: "/home/lutet")
!1261 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1262, file: !1260, line: 54)
!1262 = !DISubprogram(name: "setlocale", scope: !1259, file: !1259, line: 122, type: !1263, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1263 = !DISubroutineType(types: !1264)
!1264 = !{!360, !121, !162}
!1265 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1266, file: !1260, line: 55)
!1266 = !DISubprogram(name: "localeconv", scope: !1259, file: !1259, line: 125, type: !1267, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1267 = !DISubroutineType(types: !1268)
!1268 = !{!1269}
!1269 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1258, size: 64)
!1270 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1271, file: !1273, line: 64)
!1271 = !DISubprogram(name: "isalnum", scope: !1272, file: !1272, line: 108, type: !287, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1272 = !DIFile(filename: "/usr/include/ctype.h", directory: "")
!1273 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/tps/lnx64/gcc-8.3.0/lib/gcc/x86_64-pc-linux-gnu/8.3.0/../../../../include/c++/8.3.0/cctype", directory: "/home/lutet")
!1274 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1275, file: !1273, line: 65)
!1275 = !DISubprogram(name: "isalpha", scope: !1272, file: !1272, line: 109, type: !287, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1276 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1277, file: !1273, line: 66)
!1277 = !DISubprogram(name: "iscntrl", scope: !1272, file: !1272, line: 110, type: !287, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1278 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1279, file: !1273, line: 67)
!1279 = !DISubprogram(name: "isdigit", scope: !1272, file: !1272, line: 111, type: !287, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1280 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1281, file: !1273, line: 68)
!1281 = !DISubprogram(name: "isgraph", scope: !1272, file: !1272, line: 113, type: !287, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1282 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1283, file: !1273, line: 69)
!1283 = !DISubprogram(name: "islower", scope: !1272, file: !1272, line: 112, type: !287, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1284 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1285, file: !1273, line: 70)
!1285 = !DISubprogram(name: "isprint", scope: !1272, file: !1272, line: 114, type: !287, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1286 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1287, file: !1273, line: 71)
!1287 = !DISubprogram(name: "ispunct", scope: !1272, file: !1272, line: 115, type: !287, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1288 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1289, file: !1273, line: 72)
!1289 = !DISubprogram(name: "isspace", scope: !1272, file: !1272, line: 116, type: !287, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1290 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1291, file: !1273, line: 73)
!1291 = !DISubprogram(name: "isupper", scope: !1272, file: !1272, line: 117, type: !287, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1292 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1293, file: !1273, line: 74)
!1293 = !DISubprogram(name: "isxdigit", scope: !1272, file: !1272, line: 118, type: !287, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1294 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1295, file: !1273, line: 75)
!1295 = !DISubprogram(name: "tolower", scope: !1272, file: !1272, line: 122, type: !287, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1296 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1297, file: !1273, line: 76)
!1297 = !DISubprogram(name: "toupper", scope: !1272, file: !1272, line: 125, type: !287, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1298 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1299, file: !1273, line: 87)
!1299 = !DISubprogram(name: "isblank", scope: !1272, file: !1272, line: 130, type: !287, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1300 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !563, file: !1301, line: 44)
!1301 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/tps/lnx64/gcc-8.3.0/lib/gcc/x86_64-pc-linux-gnu/8.3.0/../../../../include/c++/8.3.0/ext/new_allocator.h", directory: "/home/lutet")
!1302 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !1303, file: !1301, line: 45)
!1303 = !DIDerivedType(tag: DW_TAG_typedef, name: "ptrdiff_t", scope: !282, file: !514, line: 239, baseType: !299)
!1304 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1305, file: !1307, line: 98)
!1305 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !1306, line: 7, baseType: !954)
!1306 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/FILE.h", directory: "")
!1307 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/tps/lnx64/gcc-8.3.0/lib/gcc/x86_64-pc-linux-gnu/8.3.0/../../../../include/c++/8.3.0/cstdio", directory: "/home/lutet")
!1308 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1309, file: !1307, line: 99)
!1309 = !DIDerivedType(tag: DW_TAG_typedef, name: "fpos_t", file: !1310, line: 85, baseType: !1311)
!1310 = !DIFile(filename: "/usr/include/stdio.h", directory: "")
!1311 = !DIDerivedType(tag: DW_TAG_typedef, name: "__fpos_t", file: !1312, line: 14, baseType: !1313)
!1312 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/__fpos_t.h", directory: "")
!1313 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_G_fpos_t", file: !1312, line: 10, size: 128, flags: DIFlagFwdDecl, identifier: "_ZTS9_G_fpos_t")
!1314 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1315, file: !1307, line: 101)
!1315 = !DISubprogram(name: "clearerr", scope: !1310, file: !1310, line: 860, type: !1316, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1316 = !DISubroutineType(types: !1317)
!1317 = !{null, !1318}
!1318 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1305, size: 64)
!1319 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1320, file: !1307, line: 102)
!1320 = !DISubprogram(name: "fclose", scope: !1310, file: !1310, line: 184, type: !1321, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1321 = !DISubroutineType(types: !1322)
!1322 = !{!121, !1318}
!1323 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1324, file: !1307, line: 103)
!1324 = !DISubprogram(name: "feof", scope: !1310, file: !1310, line: 862, type: !1321, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1325 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1326, file: !1307, line: 104)
!1326 = !DISubprogram(name: "ferror", scope: !1310, file: !1310, line: 864, type: !1321, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1327 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1328, file: !1307, line: 105)
!1328 = !DISubprogram(name: "fflush", scope: !1310, file: !1310, line: 236, type: !1321, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1329 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1330, file: !1307, line: 106)
!1330 = !DISubprogram(name: "fgetc", scope: !1310, file: !1310, line: 575, type: !1321, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1331 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1332, file: !1307, line: 107)
!1332 = !DISubprogram(name: "fgetpos", scope: !1310, file: !1310, line: 829, type: !1333, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1333 = !DISubroutineType(types: !1334)
!1334 = !{!121, !1335, !1336}
!1335 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1318)
!1336 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1337)
!1337 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1309, size: 64)
!1338 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1339, file: !1307, line: 108)
!1339 = !DISubprogram(name: "fgets", scope: !1310, file: !1310, line: 654, type: !1340, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1340 = !DISubroutineType(types: !1341)
!1341 = !{!360, !428, !121, !1335}
!1342 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1343, file: !1307, line: 109)
!1343 = !DISubprogram(name: "fopen", scope: !1310, file: !1310, line: 264, type: !1344, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1344 = !DISubroutineType(types: !1345)
!1345 = !{!1318, !384, !384}
!1346 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1347, file: !1307, line: 110)
!1347 = !DISubprogram(name: "fprintf", scope: !1310, file: !1310, line: 357, type: !1348, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1348 = !DISubroutineType(types: !1349)
!1349 = !{!121, !1335, !384, null}
!1350 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1351, file: !1307, line: 111)
!1351 = !DISubprogram(name: "fputc", scope: !1310, file: !1310, line: 611, type: !1352, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1352 = !DISubroutineType(types: !1353)
!1353 = !{!121, !121, !1318}
!1354 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1355, file: !1307, line: 112)
!1355 = !DISubprogram(name: "fputs", scope: !1310, file: !1310, line: 717, type: !1356, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1356 = !DISubroutineType(types: !1357)
!1357 = !{!121, !384, !1335}
!1358 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1359, file: !1307, line: 113)
!1359 = !DISubprogram(name: "fread", scope: !1310, file: !1310, line: 738, type: !1360, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1360 = !DISubroutineType(types: !1361)
!1361 = !{!310, !1362, !310, !310, !1335}
!1362 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !309)
!1363 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1364, file: !1307, line: 114)
!1364 = !DISubprogram(name: "freopen", scope: !1310, file: !1310, line: 271, type: !1365, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1365 = !DISubroutineType(types: !1366)
!1366 = !{!1318, !384, !384, !1335}
!1367 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1368, file: !1307, line: 115)
!1368 = !DISubprogram(name: "fscanf", linkageName: "__isoc23_fscanf", scope: !1310, file: !1310, line: 442, type: !1348, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1369 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1370, file: !1307, line: 116)
!1370 = !DISubprogram(name: "fseek", scope: !1310, file: !1310, line: 779, type: !1371, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1371 = !DISubroutineType(types: !1372)
!1372 = !{!121, !1318, !299, !121}
!1373 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1374, file: !1307, line: 117)
!1374 = !DISubprogram(name: "fsetpos", scope: !1310, file: !1310, line: 835, type: !1375, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1375 = !DISubroutineType(types: !1376)
!1376 = !{!121, !1318, !1377}
!1377 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1378, size: 64)
!1378 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1309)
!1379 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1380, file: !1307, line: 118)
!1380 = !DISubprogram(name: "ftell", scope: !1310, file: !1310, line: 785, type: !1381, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1381 = !DISubroutineType(types: !1382)
!1382 = !{!299, !1318}
!1383 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1384, file: !1307, line: 119)
!1384 = !DISubprogram(name: "fwrite", scope: !1310, file: !1310, line: 745, type: !1385, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1385 = !DISubroutineType(types: !1386)
!1386 = !{!310, !1387, !310, !310, !1335}
!1387 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !336)
!1388 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1389, file: !1307, line: 120)
!1389 = !DISubprogram(name: "getc", scope: !1310, file: !1310, line: 576, type: !1321, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1390 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1391, file: !1307, line: 121)
!1391 = !DISubprogram(name: "getchar", scope: !1310, file: !1310, line: 582, type: !397, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1392 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1393, file: !1307, line: 126)
!1393 = !DISubprogram(name: "perror", scope: !1310, file: !1310, line: 878, type: !1394, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1394 = !DISubroutineType(types: !1395)
!1395 = !{null, !162}
!1396 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1397, file: !1307, line: 127)
!1397 = !DISubprogram(name: "printf", scope: !1310, file: !1310, line: 363, type: !1398, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1398 = !DISubroutineType(types: !1399)
!1399 = !{!121, !384, null}
!1400 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1401, file: !1307, line: 128)
!1401 = !DISubprogram(name: "putc", scope: !1310, file: !1310, line: 612, type: !1352, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1402 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1403, file: !1307, line: 129)
!1403 = !DISubprogram(name: "putchar", scope: !1310, file: !1310, line: 618, type: !287, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1404 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1405, file: !1307, line: 130)
!1405 = !DISubprogram(name: "puts", scope: !1310, file: !1310, line: 724, type: !326, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1406 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1407, file: !1307, line: 131)
!1407 = !DISubprogram(name: "remove", scope: !1310, file: !1310, line: 158, type: !326, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1408 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1409, file: !1307, line: 132)
!1409 = !DISubprogram(name: "rename", scope: !1310, file: !1310, line: 160, type: !1410, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1410 = !DISubroutineType(types: !1411)
!1411 = !{!121, !162, !162}
!1412 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1413, file: !1307, line: 133)
!1413 = !DISubprogram(name: "rewind", scope: !1310, file: !1310, line: 790, type: !1316, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1414 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1415, file: !1307, line: 134)
!1415 = !DISubprogram(name: "scanf", linkageName: "__isoc23_scanf", scope: !1310, file: !1310, line: 445, type: !1398, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1416 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1417, file: !1307, line: 135)
!1417 = !DISubprogram(name: "setbuf", scope: !1310, file: !1310, line: 334, type: !1418, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1418 = !DISubroutineType(types: !1419)
!1419 = !{null, !1335, !428}
!1420 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1421, file: !1307, line: 136)
!1421 = !DISubprogram(name: "setvbuf", scope: !1310, file: !1310, line: 339, type: !1422, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1422 = !DISubroutineType(types: !1423)
!1423 = !{!121, !1335, !428, !121, !310}
!1424 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1425, file: !1307, line: 137)
!1425 = !DISubprogram(name: "sprintf", scope: !1310, file: !1310, line: 365, type: !1426, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1426 = !DISubroutineType(types: !1427)
!1427 = !{!121, !428, !384, null}
!1428 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1429, file: !1307, line: 138)
!1429 = !DISubprogram(name: "sscanf", linkageName: "__isoc23_sscanf", scope: !1310, file: !1310, line: 447, type: !1430, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1430 = !DISubroutineType(types: !1431)
!1431 = !{!121, !384, !384, null}
!1432 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1433, file: !1307, line: 139)
!1433 = !DISubprogram(name: "tmpfile", scope: !1310, file: !1310, line: 194, type: !1434, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1434 = !DISubroutineType(types: !1435)
!1435 = !{!1318}
!1436 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1437, file: !1307, line: 141)
!1437 = !DISubprogram(name: "tmpnam", scope: !1310, file: !1310, line: 211, type: !1438, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1438 = !DISubroutineType(types: !1439)
!1439 = !{!360, !360}
!1440 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1441, file: !1307, line: 143)
!1441 = !DISubprogram(name: "ungetc", scope: !1310, file: !1310, line: 731, type: !1352, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1442 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1443, file: !1307, line: 144)
!1443 = !DISubprogram(name: "vfprintf", scope: !1310, file: !1310, line: 372, type: !1444, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1444 = !DISubroutineType(types: !1445)
!1445 = !{!121, !1335, !384, !1028}
!1446 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1447, file: !1307, line: 145)
!1447 = !DISubprogram(name: "vprintf", scope: !1310, file: !1310, line: 378, type: !1448, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1448 = !DISubroutineType(types: !1449)
!1449 = !{!121, !384, !1028}
!1450 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1451, file: !1307, line: 146)
!1451 = !DISubprogram(name: "vsprintf", scope: !1310, file: !1310, line: 380, type: !1452, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1452 = !DISubroutineType(types: !1453)
!1453 = !{!121, !428, !384, !1028}
!1454 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !1455, file: !1307, line: 175)
!1455 = !DISubprogram(name: "snprintf", scope: !1310, file: !1310, line: 385, type: !1456, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1456 = !DISubroutineType(types: !1457)
!1457 = !{!121, !428, !310, !384, null}
!1458 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !1459, file: !1307, line: 176)
!1459 = !DISubprogram(name: "vfscanf", linkageName: "__isoc23_vfscanf", scope: !1310, file: !1310, line: 511, type: !1444, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1460 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !1461, file: !1307, line: 177)
!1461 = !DISubprogram(name: "vscanf", linkageName: "__isoc23_vscanf", scope: !1310, file: !1310, line: 516, type: !1448, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1462 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !1463, file: !1307, line: 178)
!1463 = !DISubprogram(name: "vsnprintf", scope: !1310, file: !1310, line: 389, type: !1464, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1464 = !DISubroutineType(types: !1465)
!1465 = !{!121, !428, !310, !384, !1028}
!1466 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !437, entity: !1467, file: !1307, line: 179)
!1467 = !DISubprogram(name: "vsscanf", linkageName: "__isoc23_vsscanf", scope: !1310, file: !1310, line: 519, type: !1468, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1468 = !DISubroutineType(types: !1469)
!1469 = !{!121, !384, !384, !1028}
!1470 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1455, file: !1307, line: 185)
!1471 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1459, file: !1307, line: 186)
!1472 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1461, file: !1307, line: 187)
!1473 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1463, file: !1307, line: 188)
!1474 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1467, file: !1307, line: 189)
!1475 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1476, file: !1480, line: 82)
!1476 = !DIDerivedType(tag: DW_TAG_typedef, name: "wctrans_t", file: !1477, line: 48, baseType: !1478)
!1477 = !DIFile(filename: "/usr/include/wctype.h", directory: "")
!1478 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1479, size: 64)
!1479 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !183)
!1480 = !DIFile(filename: "data3/amd_fpga_tools/2025.2/Vitis/tps/lnx64/gcc-8.3.0/lib/gcc/x86_64-pc-linux-gnu/8.3.0/../../../../include/c++/8.3.0/cwctype", directory: "/home/lutet")
!1481 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1482, file: !1480, line: 83)
!1482 = !DIDerivedType(tag: DW_TAG_typedef, name: "wctype_t", file: !1483, line: 38, baseType: !312)
!1483 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/wctype-wchar.h", directory: "")
!1484 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !940, file: !1480, line: 84)
!1485 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1486, file: !1480, line: 86)
!1486 = !DISubprogram(name: "iswalnum", scope: !1483, file: !1483, line: 95, type: !1126, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1487 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1488, file: !1480, line: 87)
!1488 = !DISubprogram(name: "iswalpha", scope: !1483, file: !1483, line: 101, type: !1126, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1489 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1490, file: !1480, line: 89)
!1490 = !DISubprogram(name: "iswblank", scope: !1483, file: !1483, line: 146, type: !1126, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1491 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1492, file: !1480, line: 91)
!1492 = !DISubprogram(name: "iswcntrl", scope: !1483, file: !1483, line: 104, type: !1126, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1493 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1494, file: !1480, line: 92)
!1494 = !DISubprogram(name: "iswctype", scope: !1483, file: !1483, line: 159, type: !1495, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1495 = !DISubroutineType(types: !1496)
!1496 = !{!121, !940, !1482}
!1497 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1498, file: !1480, line: 93)
!1498 = !DISubprogram(name: "iswdigit", scope: !1483, file: !1483, line: 108, type: !1126, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1499 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1500, file: !1480, line: 94)
!1500 = !DISubprogram(name: "iswgraph", scope: !1483, file: !1483, line: 112, type: !1126, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1501 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1502, file: !1480, line: 95)
!1502 = !DISubprogram(name: "iswlower", scope: !1483, file: !1483, line: 117, type: !1126, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1503 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1504, file: !1480, line: 96)
!1504 = !DISubprogram(name: "iswprint", scope: !1483, file: !1483, line: 120, type: !1126, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1505 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1506, file: !1480, line: 97)
!1506 = !DISubprogram(name: "iswpunct", scope: !1483, file: !1483, line: 125, type: !1126, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1507 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1508, file: !1480, line: 98)
!1508 = !DISubprogram(name: "iswspace", scope: !1483, file: !1483, line: 130, type: !1126, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1509 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1510, file: !1480, line: 99)
!1510 = !DISubprogram(name: "iswupper", scope: !1483, file: !1483, line: 135, type: !1126, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1511 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1512, file: !1480, line: 100)
!1512 = !DISubprogram(name: "iswxdigit", scope: !1483, file: !1483, line: 140, type: !1126, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1513 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1514, file: !1480, line: 101)
!1514 = !DISubprogram(name: "towctrans", scope: !1477, file: !1477, line: 55, type: !1515, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1515 = !DISubroutineType(types: !1516)
!1516 = !{!940, !940, !1476}
!1517 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1518, file: !1480, line: 102)
!1518 = !DISubprogram(name: "towlower", scope: !1483, file: !1483, line: 166, type: !1519, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1519 = !DISubroutineType(types: !1520)
!1520 = !{!940, !940}
!1521 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1522, file: !1480, line: 103)
!1522 = !DISubprogram(name: "towupper", scope: !1483, file: !1483, line: 169, type: !1519, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1523 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1524, file: !1480, line: 104)
!1524 = !DISubprogram(name: "wctrans", scope: !1477, file: !1477, line: 52, type: !1525, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1525 = !DISubroutineType(types: !1526)
!1526 = !{!1476, !162}
!1527 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !282, entity: !1528, file: !1480, line: 105)
!1528 = !DISubprogram(name: "wctype", scope: !1483, file: !1483, line: 155, type: !1529, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: false)
!1529 = !DISubroutineType(types: !1530)
!1530 = !{!1482, !162}
!1531 = !DILocation(line: 336, column: 5, scope: !89)
!1532 = !DILocation(line: 348, column: 5, scope: !89)
!1533 = !DILocation(line: 350, column: 5, scope: !89)
!1534 = distinct !{!1534, !1535}
!1535 = !{!"llvm.loop.rotate.disable"}
!1536 = distinct !{!1536, !1535}
