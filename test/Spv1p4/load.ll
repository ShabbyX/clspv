; RUN: clspv-opt -SPIRVProducerPass %s -o %t.ll -producer-out-file %t.spv -spv-version=1.4
; RUN: spirv-dis %t.spv -o %t.spvasm
; RUN: FileCheck %s < %t.spvasm
; RUN: spirv-val --target-env vulkan1.1spv1.4 %t.spv

; CHECK: OpMemberDecorate [[decorated:%[a-zA-Z0-9_]+]] 1 Offset 16
; CHECK: OpDecorate [[dec_array:%[a-zA-Z0-9_]+]] ArrayStride 4
; CHECK: [[uint:%[a-zA-Z0-9_]+]] = OpTypeInt 32 0
; CHECK-DAG: [[uint_4:%[a-zA-Z0-9_]+]] = OpConstant [[uint]] 4
; CHECK-DAG: [[float:%[a-zA-Z0-9_]+]] = OpTypeFloat 32
; CHECK-DAG: [[float4:%[a-zA-Z0-9_]+]] = OpTypeVector [[float]] 4
; CHECK-DAG: [[dec_array]] = OpTypeArray [[uint]] [[uint_4]]
; CHECK-DAG: [[array:%[a-zA-Z0-9_]+]] = OpTypeArray [[uint]] [[uint_4]]
; CHECK-DAG: [[decorated]] = OpTypeStruct [[dec_array]] [[float4]]
; CHECK-DAG: [[undecorated:%[a-zA-Z0-9_]+]] = OpTypeStruct [[array]] [[float4]]
; CHECK: [[ld_dec:%[a-zA-Z0-9_]+]] = OpLoad [[decorated]]
; CHECK: OpCopyLogical [[undecorated]] [[ld_dec]]

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

%struct.S = type { [4 x i32], <4 x float> }

@__spirv_WorkgroupSize = local_unnamed_addr addrspace(8) global <3 x i32> zeroinitializer

define spir_kernel void @foo(%struct.S addrspace(1)* %in) !clspv.pod_args_impl !1 {
entry:
  %res = call { [0 x %struct.S] } addrspace(1)* @_Z14clspv.resource.0(i32 0, i32 0, i32 0, i32 0, i32 0, i32 1)
  %gep = getelementptr { [0 x %struct.S] }, { [0 x %struct.S] } addrspace(1)* %res, i32 0, i32 0, i32 0
  %ld = load %struct.S, %struct.S addrspace(1)* %gep
  ret void
}

declare { [0 x %struct.S] } addrspace(1)* @_Z14clspv.resource.0(i32, i32, i32, i32, i32, i32)

!1 = !{i32 2}

