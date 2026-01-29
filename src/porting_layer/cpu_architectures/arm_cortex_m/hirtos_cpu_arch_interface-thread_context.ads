--
--  Copyright (c) 2024, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target platform interface - Thread CPU context declarations
--

with System.Storage_Elements;
with HiRTOS_Cpu_Arch_Interface_Private;

package HiRTOS_Cpu_Arch_Interface.Thread_Context
   with SPARK_Mode => On
is

   type Cpu_Context_Type is private;

   --
   --  Initialize a thread's CPU context
   --
   procedure Initialize_Thread_Cpu_Context (Thread_Cpu_Context : out Cpu_Context_Type;
                                            Entry_Point_Address : Cpu_Register_Type;
                                            Thread_Arg : Cpu_Register_Type;
                                            Stack_End_Address : Cpu_Register_Type);

   --
   --  Perform the first thread thread context switch
   --
   procedure First_Thread_Context_Switch
      with Pre => Cpu_In_Privileged_Mode and then
                  HiRTOS_Cpu_Arch_Interface_Private.Is_Cpu_Using_MSP_Stack_Pointer,
                  No_Return;

   --
   --  Perform a synchronous thread context switch
   --
   procedure Synchronous_Thread_Context_Switch
      with Pre => Cpu_In_Privileged_Mode and then
                  Cpu_Interrupting_Disabled,
           Post => Cpu_In_Privileged_Mode and then
                   Cpu_Interrupting_Disabled;

   --
   --  Switch to CPU privileged mode
   --
   procedure Switch_Cpu_To_Privileged_Mode with
      Pre  => not Cpu_In_Privileged_Mode,
      Post => Cpu_In_Privileged_Mode and then not Cpu_Interrupting_Disabled;

   --
   --  Switch back to CPU unprivileged mode
   --
   procedure Switch_Cpu_To_Unprivileged_Mode with
      No_Inline;
   pragma Machine_Attribute (Switch_Cpu_To_Unprivileged_Mode, "naked");

   function  Get_Saved_PC (Cpu_Context : Cpu_Context_Type) return System.Address;

   procedure Set_Saved_PC (Cpu_Context : in out Cpu_Context_Type; PC_Value : System.Address);

   function Get_Saved_CPSR (Cpu_Context : Cpu_Context_Type) return Cpu_Register_Type;

   Cpu_Context_Size_In_Bytes : constant Integer_Address;

private
   use HiRTOS_Cpu_Arch_Interface_Private;

   --
   --  CPU context saved on the current's stack on entry to ISRs and on synchronous
   --  task context switches. Fields are in the exact order as the will be stored on the
   --  stack.
   --
   type Cpu_Context_Type is record
      --
      --  Registers saved/restored by software:
      --
      SP : Cpu_Register_Type;  --  also known as register r13 (redundant copy)
      CONTROL : CONTROL_Type;
      R4 : Cpu_Register_Type;  --  also known as register v1
      R5 : Cpu_Register_Type;  --  also known as register v2
      R6 : Cpu_Register_Type;  --  also known as register v3
      R7 : Cpu_Register_Type;  --  also known as register v4 or fp
      R8 : Cpu_Register_Type;  --  also known as register v5
      R9 : Cpu_Register_Type;  --  also known as register v6
      R10 : Cpu_Register_Type; --  also known as register v7
      R11 : Cpu_Register_Type; --  also known as register v8
      --
      --  Registers saved/restored by hardware:
      --
      R0 : Cpu_Register_Type;  --  also known as register a1
      R1 : Cpu_Register_Type;  --  also known as register a2
      R2 : Cpu_Register_Type;  --  also known as register a3
      R3 : Cpu_Register_Type;  --  also known as register a4
      R12 : Cpu_Register_Type; --  also known as register ip
      LR : Cpu_Register_Type;  --  also known as register r14
      PC : Cpu_Register_Type;  --  also known as register r15
      XPSR : XPSR_Type;
   end record
      with Convention => C,
           Size => 18 * Cpu_Register_Type'Size;

   for Cpu_Context_Type use record
      SP  at 16#00# range 0 .. 31;
      CONTROL at 16#04# range 0 .. 31;
      R4  at 16#08# range 0 .. 31;
      R5  at 16#0c# range 0 .. 31;
      R6  at 16#10# range 0 .. 31;
      R7  at 16#14# range 0 .. 31;
      R8  at 16#18# range 0 .. 31;
      R9  at 16#1c# range 0 .. 31;
      R10 at 16#20# range 0 .. 31;
      R11 at 16#24# range 0 .. 31;
      R0  at 16#28# range 0 .. 31;
      R1  at 16#2c# range 0 .. 31;
      R2  at 16#30# range 0 .. 31;
      R3  at 16#34# range 0 .. 31;
      R12 at 16#38# range 0 .. 31;
      LR  at 16#3c# range 0 .. 31;
      PC  at 16#40# range 0 .. 31;
      XPSR at 16#44# range 0 .. 31;
   end record;

   Cpu_Context_Size_In_Bytes : constant Integer_Address :=
      Cpu_Context_Type'Size / System.Storage_Unit;

   pragma Compile_Time_Error (
      Cpu_Context_Size_In_Bytes mod HiRTOS_Cpu_Arch_Parameters.Stack_Pointer_Alignment /= 0,
      "Cpu_Context_Type size must be a multiple of Stack_Pointer_Alignment");

   function Get_Saved_PC (Cpu_Context : Cpu_Context_Type) return System.Address is
      (System.Storage_Elements.To_Address (
         System.Storage_Elements.Integer_Address (Cpu_Context.PC)));

   function Get_Saved_CPSR (Cpu_Context : Cpu_Context_Type) return Cpu_Register_Type is
      (Cpu_Register_Type (Cpu_Context.XPSR.Value));

end HiRTOS_Cpu_Arch_Interface.Thread_Context;
