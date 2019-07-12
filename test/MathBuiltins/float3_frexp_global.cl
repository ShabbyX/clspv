// RUN: clspv %s -o %t.spv
// RUN: spirv-dis -o %t2.spvasm %t.spv
// RUN: FileCheck %s < %t2.spvasm
// RUN: spirv-val --target-env vulkan1.0 %t.spv


void kernel __attribute__((reqd_work_group_size(1, 1, 1))) foo(global float3* a, global float3* b, global int3* c)
{
  *a = frexp(*b, c);
}

// CHECK: [[_1:%[0-9a-zA-Z_]+]] = OpExtInstImport "GLSL.std.450"
// CHECK-DAG: [[_float:%[0-9a-zA-Z_]+]] = OpTypeFloat 32
// CHECK-DAG: [[_v3float:%[0-9a-zA-Z_]+]] = OpTypeVector [[_float]] 3
// CHECK: [[_22:%[0-9a-zA-Z_]+]] = OpAccessChain
// CHECK: [[_23:%[0-9a-zA-Z_]+]] = OpAccessChain
// CHECK: [[_24:%[0-9a-zA-Z_]+]] = OpAccessChain
// CHECK: [[_25:%[0-9a-zA-Z_]+]] = OpLoad [[_v3float]] [[_23]]
// CHECK: [[_26:%[0-9a-zA-Z_]+]] = OpExtInst [[_v3float]] [[_1]] Frexp [[_25]] [[_24]]
// CHECK: OpStore [[_22]] [[_26]]
