--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target platform interface - Thread CPU context declarations
--

with Interfaces;
with System.Storage_Elements;

package HiRTOS_Cpu_Arch_Interface.Thread_Context with SPARK_Mode => On is

   type Cpu_Context_Type is limited private;

   --  Initialize a thread's CPU context
   --
   procedure Initialize_Thread_Cpu_Context (Thread_Cpu_Context : out Cpu_Context_Type;
                                            Entry_Point_Address : Cpu_Register_Type;
                                            Thread_Arg : Cpu_Register_Type;
                                            Stack_End_Address : Cpu_Register_Type);

   --
   --  Perform the first thread thread context switch
   --
   procedure First_Thread_Context_Switch with No_Return;

   --
   --  Perform a synchronous thread context switch
   --
   procedure Synchronous_Thread_Context_Switch;

   --
   --  Switch to CPU privileged mode
   --
   procedure Switch_Cpu_To_Privileged_Mode with
      Pre  => not Cpu_In_Privileged_Mode,
      Post => Cpu_In_Privileged_Mode;

   --
   --  Switch back to CPU unprivileged mode
   --
   procedure Switch_Cpu_To_Unprivileged_Mode with
    Pre  => Cpu_In_Privileged_Mode and then not Cpu_Interrupting_Disabled,
    Post => not Cpu_In_Privileged_Mode;

   function  Get_Saved_PC (Cpu_Context : Cpu_Context_Type) return System.Address;

   procedure Set_Saved_PC (Cpu_Context : in out Cpu_Context_Type; PC_Value : System.Address);

   function Get_Saved_CPSR (Cpu_Context : Cpu_Context_Type) return Cpu_Register_Type;

private

   Num_Double_Precision_Floating_Point_Registers : constant := 16;

   type Double_Precision_Registers_Type is
      array (1 .. Num_Double_Precision_Floating_Point_Registers) of Interfaces.Unsigned_64
      with Convention => C;

   type Floating_Point_Registers_Type is record
      Double_Precision_Registers : Double_Precision_Registers_Type := [others => 0];
      Fpscr : Interfaces.Unsigned_32 := 0;
      Reserved : Interfaces.Unsigned_32 := 0; --  alignment hole
   end record
      with Convention => C;

   for Floating_Point_Registers_Type use record
      Double_Precision_Registers at 0 range 0 .. (128 * 8) - 1;
      Fpscr at 128 range 0 .. 31;
      Reserved at 132 range 0 .. 31;
   end record;

   pragma Compile_Time_Error (
      Interfaces.Unsigned_64'Object_Size /= Standard.Long_Float'Object_Size,
      "Unexpected double-precision floating point size");

   pragma Compile_Time_Error (
      Interfaces.Unsigned_32'Object_Size /= Float'Object_Size,
      "Unexpected single-precision floating point size");

   type Integer_Registers_Type is record
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

   for Integer_Registers_Type use record
      R0  at 16#00# range 0 .. 31;
      R1  at 16#04# range 0 .. 31;
      R2  at 16#08# range 0 .. 31;
      R3  at 16#0c# range 0 .. 31;
      R4  at 16#10# range 0 .. 31;
      R5  at 16#14# range 0 .. 31;
      R6  at 16#18# range 0 .. 31;
      R7  at 16#1c# range 0 .. 31;
      R8  at 16#20# range 0 .. 31;
      R9  at 16#24# range 0 .. 31;
      R10 at 16#28# range 0 .. 31;
      R11 at 16#2c# range 0 .. 31;
      R12 at 16#30# range 0 .. 31;
      LR  at 16#34# range 0 .. 31;
      PC  at 16#38# range 0 .. 31;
      CPSR at 16#3c# range 0 .. 31;
   end record;

   --
   --  CPU context saved on the current's stack on entry to ISRs and on synchronous
   --  task context switches. Fields are in the exact order as the will be stored on the
   --  stack.
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
      Floating_Point_Registers : Floating_Point_Registers_Type;
      Integer_Registers : Integer_Registers_Type;
   end record;

   for Cpu_Context_Type use record
      Floating_Point_Registers at 0 range 0 .. (136 * 8) - 1;
      Integer_Registers at 136 range 0 .. (64 * 8) - 1;
   end record;

   function Get_Saved_PC (Cpu_Context : Cpu_Context_Type) return System.Address is
      (System.Storage_Elements.To_Address (
         System.Storage_Elements.Integer_Address (Cpu_Context.Integer_Registers.PC)));

   function Get_Saved_CPSR (Cpu_Context : Cpu_Context_Type) return Cpu_Register_Type is
      (Cpu_Context.Integer_Registers.CPSR);

end HiRTOS_Cpu_Arch_Interface.Thread_Context;
