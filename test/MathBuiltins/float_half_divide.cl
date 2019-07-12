// RUN: clspv %s -o %t.spv
// RUN: spirv-dis -o %t2.spvasm %t.spv
// RUN: FileCheck %s < %t2.spvasm
// RUN: spirv-val --target-env vulkan1.0 %t.spv

// CHECK-DAG: %[[FLOAT_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeFloat 32
// CHECK-DAG: %[[CONSTANT_FLOAT_42_ID:[a-zA-Z0-9_]*]] = OpConstant %[[FLOAT_TYPE_ID]] 42
// CHECK: %[[LOADB_ID:[a-zA-Z0-9_]*]] = OpLoad %[[FLOAT_TYPE_ID]]
// CHECK: %[[OP_ID:[a-zA-Z0-9_]*]] = OpFDiv %[[FLOAT_TYPE_ID]] %[[LOADB_ID]] %[[CONSTANT_FLOAT_42_ID]]
// CHECK: OpStore {{.*}} %[[OP_ID]]

void kernel __attribute__((reqd_work_group_size(1, 1, 1))) foo(global float* a, global float* b)
{
  *a = half_divide(*b, 42.0f);
}
