--
--  Copyright (c) 2022-2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target platform interface - Thread CPU context declarations
--

with Interfaces;
with System.Storage_Elements;
private with HiRTOS_Cpu_Arch_Interface_Private;

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
      Post => not Cpu_In_Privileged_Mode,
      No_Inline;
   pragma Machine_Attribute (Switch_Cpu_To_Unprivileged_Mode, "naked");

   function  Get_Saved_PC (Cpu_Context : Cpu_Context_Type) return System.Address;

   procedure Set_Saved_PC (Cpu_Context : in out Cpu_Context_Type; PC_Value : System.Address);

   function Get_Saved_CPSR (Cpu_Context : Cpu_Context_Type) return Cpu_Register_Type;

private
   use HiRTOS_Cpu_Arch_Interface_Private;

   Num_Quad_Precision_Floating_Point_Registers : constant := 32;

   type Quad_Precision_Floating_Point_Register_Type is record
      Lower_Half : Interfaces.Unsigned_64 := 0;
      Upper_Half : Interfaces.Unsigned_64 := 0;
   end record
      with Convention => C;

   type Quad_Precision_Registers_Type is
      array (1 .. Num_Quad_Precision_Floating_Point_Registers) of Quad_Precision_Floating_Point_Register_Type
      with Convention => C;

   type Floating_Point_Registers_Type is record
      Quad_Precision_Registers : Quad_Precision_Registers_Type := [others => <>];
      Fpsr : Interfaces.Unsigned_64 := 0;
      Fpcr : Interfaces.Unsigned_64 := 0;
   end record
      with Convention => C;

   for Floating_Point_Registers_Type use record
      Quad_Precision_Registers at 0 range 0 .. (32 * 16 * 8) - 1;
      Fpsr at 512 range 0 .. 63;
      Fpcr at 520 range 0 .. 63;
   end record;

   pragma Compile_Time_Error (
      Interfaces.Unsigned_64'Object_Size /= Standard.Long_Float'Object_Size,
      "Unexpected double-precision floating point size");

   pragma Compile_Time_Error (
      Interfaces.Unsigned_32'Object_Size /= Float'Object_Size,
      "Unexpected single-precision floating point size");

   type Integer_Registers_Type is record
      PC : Cpu_Register_Type;   --  ELR_ELx
      SPSR : PSTATE_Type; --  SPSR_ELx
      X0 : Cpu_Register_Type;
      X1 : Cpu_Register_Type;
      X2 : Cpu_Register_Type;
      X3 : Cpu_Register_Type;
      X4 : Cpu_Register_Type;
      X5 : Cpu_Register_Type;
      X6 : Cpu_Register_Type;
      X7 : Cpu_Register_Type;
      X8 : Cpu_Register_Type;
      X9 : Cpu_Register_Type;
      X10 : Cpu_Register_Type;
      X11 : Cpu_Register_Type;
      X12 : Cpu_Register_Type;
      X13 : Cpu_Register_Type;
      X14 : Cpu_Register_Type;
      X15 : Cpu_Register_Type;
      X16 : Cpu_Register_Type;
      X17 : Cpu_Register_Type;
      X18 : Cpu_Register_Type;
      X19 : Cpu_Register_Type;
      X20 : Cpu_Register_Type;
      X21 : Cpu_Register_Type;
      X22 : Cpu_Register_Type;
      X23 : Cpu_Register_Type;
      X24 : Cpu_Register_Type;
      X25 : Cpu_Register_Type;
      X26 : Cpu_Register_Type;
      X27 : Cpu_Register_Type;
      X28 : Cpu_Register_Type;
      X29 : Cpu_Register_Type; --  FP
      X30 : Cpu_Register_Type; --  LR
      Reserved : Cpu_Register_Type; --  Needed for 16-byte alignment
   end record
      with Convention => C;

   for Integer_Registers_Type use record
      PC  at 16#00# range 0 .. 63;
      SPSR at 16#08# range 0 .. 63;
      X0  at 16#10# range 0 .. 63;
      X1  at 16#18# range 0 .. 63;
      X2  at 16#20# range 0 .. 63;
      X3  at 16#28# range 0 .. 63;
      X4  at 16#30# range 0 .. 63;
      X5  at 16#38# range 0 .. 63;
      X6  at 16#40# range 0 .. 63;
      X7  at 16#48# range 0 .. 63;
      X8  at 16#50# range 0 .. 63;
      X9  at 16#58# range 0 .. 63;
      X10 at 16#60# range 0 .. 63;
      X11 at 16#68# range 0 .. 63;
      X12 at 16#70# range 0 .. 63;
      X13 at 16#78# range 0 .. 63;
      X14 at 16#80# range 0 .. 63;
      X15 at 16#88# range 0 .. 63;
      X16 at 16#90# range 0 .. 63;
      X17 at 16#98# range 0 .. 63;
      X18 at 16#a0# range 0 .. 63;
      X19 at 16#a8# range 0 .. 63;
      X20 at 16#b0# range 0 .. 63;
      X21 at 16#b8# range 0 .. 63;
      X22 at 16#c0# range 0 .. 63;
      X23 at 16#c8# range 0 .. 63;
      X24 at 16#d0# range 0 .. 63;
      X25 at 16#d8# range 0 .. 63;
      X26 at 16#e0# range 0 .. 63;
      X27 at 16#e8# range 0 .. 63;
      X28 at 16#f0# range 0 .. 63;
      X29 at 16#f8# range 0 .. 63;
      X30 at 16#100# range 0 .. 63;
      Reserved at 16#108# range 0 .. 63;
   end record;

   --  pragma Compile_Time_Error (
   --     (Integer_Registers_Type'Object_Size / System.Storage_Unit) mod 16 /= 0,
   --     "Size of Integer_Registers_Type must be a multiple of 16 bytes");

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
      Floating_Point_Registers at 0 range 0 .. (528 * 8) - 1;
      Integer_Registers at 528 range 0 .. (272 * 8) - 1;
   end record;

   function Get_Saved_PC (Cpu_Context : Cpu_Context_Type) return System.Address is
      (System.Storage_Elements.To_Address (
         System.Storage_Elements.Integer_Address (Cpu_Context.Integer_Registers.PC)));

   function Get_Saved_CPSR (Cpu_Context : Cpu_Context_Type) return Cpu_Register_Type is
      (Cpu_Context.Integer_Registers.SPSR.Value);

end HiRTOS_Cpu_Arch_Interface.Thread_Context;
