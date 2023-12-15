--
--  Copyright (c) 2022-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

with System.Storage_Elements;
with Interfaces;
with HiRTOS_Cpu_Arch_Parameters;

--
--  @summary Generic execution stack
--
generic
   Stack_Size_In_Bytes : Positive;
package Generic_Execution_Stack with
  SPARK_Mode => On, No_Elaboration_Code_All
is

   type Stack_Overflow_Guard_Type is
     array
       (1 ..
            HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment) of Interfaces
       .Unsigned_8 with
     Size =>
      HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment * System.Storage_Unit,
     Alignment => HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment;

   subtype Stack_Entry_Type is System.Storage_Elements.Integer_Address;

   type Stack_Entries_Type is
     array (1 ..
            Stack_Size_In_Bytes /
            (System.Storage_Elements.Integer_Address'Size / System.Storage_Unit)) of Stack_Entry_Type with
     Convention => C,
     Alignment  =>
      Stack_Entry_Type'Size / System.Storage_Unit;

   type Execution_Stack_Type is limited record
      Stack_Overflow_Guard : Stack_Overflow_Guard_Type;
      Stack_Entries        : Stack_Entries_Type;
   end record with
     Convention => C,
     Alignment  => HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment;

end Generic_Execution_Stack;
