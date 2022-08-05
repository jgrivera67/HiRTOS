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

--
--  @summary RTOS to target platform interface - CPU specific declarations
--

with Interfaces;

package HiRTOS_Platform_Interface.Cpu_Specific with SPARK_Mode => On is

   type Thread_Mem_Prot_Regions_Type is limited private;

   --
   --  Initializes the thread-private memory protection region descriptors
   --
   procedure Initialize_Thread_Mem_Prot_Regions (Stack_Base_Addr : System.Address;
                                                 Stack_Szie : Interfaces.Unsigned_32;
                                                 Thread_Regions : out Thread_Mem_Prot_Regions_Type);

   --
   --  Restore thread-private memory protection regions
   --
   procedure Restore_Thread_Mem_Prot_Regions (Thread_Regions : Thread_Mem_Prot_Regions_Type);

   --
   --  Save thread-private memory protection regions
   --
   procedure Save_Thread_Mem_Prot_Regions (Thread_Regions : out Thread_Mem_Prot_Regions_Type);

   type Cpu_Context_Type is limited private;

   --
   --  Initialize a thread's CPU context
   procedure Initialize_Thread_Cpu_Context (Thread_Cpu_Context : out Cpu_Context_Type;
                                            Initial_Stack_Pointer : System.Address);

private

   --  Saved ARM Cortex-R memory protection region descriptor
   type Mem_Prot_Region_Descriptor_Type is record
      --  Region base address register
      Rbar_Value : Interfaces.Unsigned_32;
      --  Region size register
      Rsr_Value : Interfaces.Unsigned_32;
      --  Region access control register
      Racr_Value : Interfaces.Unsigned_32;
      --  Type of floating memory protection region.
      Region_Type : Interfaces.Unsigned_8;
      --  Reserved fields to make trailing hole explicit
      Reserved1 : Interfaces.Unsigned_8;
      Reserved2 : Interfaces.Unsigned_16;
   end record
     with Convention => C;

   --
   --  Thread-private memory protection regions
   --
   --  @field stack_region memory region for the thread's stack
   --  @field writable_data_region current memory region for writable global data
   --  for the thread.
   --
   type Thread_Mem_Prot_Regions_Type is limited record
      stack_region : Mem_Prot_Region_Descriptor_Type;
      data_region : Mem_Prot_Region_Descriptor_Type;
      mmio_region : Mem_Prot_Region_Descriptor_Type;
      code_region : Mem_Prot_Region_Descriptor_Type;
      data_extra_region : Mem_Prot_Region_Descriptor_Type;
      mmio_extra_region : Mem_Prot_Region_Descriptor_Type;
   end record;

   Num_Double_Precision_Floating_Point_Registers : constant := 16;

   type Double_Precision_Registers_Type is
      array (1 .. Num_Double_Precision_Floating_Point_Registers) of Interfaces.Unsigned_64
      with Convention => C;

   type Floating_Point_Registers_Type is limited record
      Double_Precision_Registers : Double_Precision_Registers_Type;
      Fpscr : Interfaces.Unsigned_32;
      Reserved : Interfaces.Unsigned_32; --  alignment hole
   end record
      with Convention => C;

   for Floating_Point_Registers_Type use record
      Double_Precision_Registers at 0 range 0 .. 1023;
      Fpscr at 128 range 0 .. 31;
      Reserved at 132 range 0 .. 31;
   end record;

   pragma Compile_Time_Error (
      Interfaces.Unsigned_64'Object_Size /= Standard.Long_Float'Object_Size,
      "Unexpected double-precision floating point size");

   pragma Compile_Time_Error (
      Interfaces.Unsigned_32'Object_Size /= Float'Object_Size,
      "Unexpected single-precision floating point size");

   type Integer_Registers_Type is limited record
      R0 : Cpu_Register_Type;  --  also known as register a1
      R1 : Cpu_Register_Type;  --  also known as register a2
      R2 : Cpu_Register_Type;  --  also known as register a3
      R3 : Cpu_Register_Type;  --  also known as register a4
      R4 : Cpu_Register_Type;  --  also known as register v1
      R5 : Cpu_Register_Type;  --  also known as register v2
      R6 : Cpu_Register_Type;  --  also known as register v3
      R7 : Cpu_Register_Type;  --  also known as register v4
      R8 : Cpu_Register_Type;  --  also known as register v5
      R9 : Cpu_Register_Type;  --  also known as register v6
      R10 : Cpu_Register_Type; --  also known as register v7
      R11 : Cpu_Register_Type; --  also known as register v8 or fp
      R12 : Cpu_Register_Type; --  also known as register ip
      LR : Cpu_Register_Type;  --  also known as register r14
      PC : Cpu_Register_Type;  --  also known as register r15
      CPSR : Cpu_Register_Type;
   end record
      with Convention => C;

   --
   --  CPU context saved on the current's stack on entry to ISRs and on synchronous
   --  task context switches. Fields are in the exact order as the will be stored on the
   --  stack.
   --
   --  @field Sp Redundant copy of sp. Although sp (r13) does not need to be saved as
   --  sp is saved in the task control block (TCB), we still save it here, to include it
   --  in the RTOS task context's saved registers checksum.
   --
   --  @field Cpu_Privileged_Nesting_Count Saved value of `g_cpu_privileged_nesting_count`.
   --  `g_cpu_privileged_nesting_count` is saved here (on the stack) because it needs to be
   --  restored on both thread context switches and wen returning from a nested ISR.
   --
   --  @field Floating_Point_Registers Saved FPU floating point registers for the thread.
   --  We save the floating point registers even if the thread doe snot have floating point code,
   --  in case the compiler since the compiler generates code using floating point registers in any
   --  non-floating-point code, as part of some optimization (e.g., saving integer
   --  registers in floating point registers, instead of spilling them on the stack).
   --
   --  @field Integer_Registers Saved CPU integer registers
   --
   type Cpu_Context_Type is limited record
      Sp : Cpu_Register_Type; --  register r13
      Cpu_Privileged_Nesting_Count : Cpu_Register_Type;
      Floating_Point_Registers : Floating_Point_Registers_Type;
      Integer_Registers : Integer_Registers_Type;
   end record
      with Convention => C;

   for Cpu_Context_Type use record
      Sp at 0 range 0 .. 31;
      Cpu_Privileged_Nesting_Count at 4 range 0 .. 31;
      Floating_Point_Registers at 8 range 0 .. 136 * 8 - 1;
      Integer_Registers at 144 range 0 .. 64 * 8 - 1;
   end record;

end HiRTOS_Platform_Interface.Cpu_Specific;