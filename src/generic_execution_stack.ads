--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
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
