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
with Bit_Sized_Integer_Types;
private with HiRTOS_Cpu_Arch_Interface_Private;

package HiRTOS_Cpu_Arch_Interface.Thread_Context with SPARK_Mode => On is

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
   procedure First_Thread_Context_Switch with No_Return;

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
   --  NOTE: we cannot check preconditions here, because we need to ensure
   --  that the RA register is not changed before it is consumed within this
   --  subprogram
   --
   procedure Switch_Cpu_To_Unprivileged_Mode with
      No_Inline;
   pragma Machine_Attribute (Switch_Cpu_To_Unprivileged_Mode, "naked");

   function  Get_Saved_PC (Cpu_Context : Cpu_Context_Type) return System.Address;

   procedure Set_Saved_PC (Cpu_Context : in out Cpu_Context_Type; PC_Value : Cpu_Register_Type);

   function Get_Saved_CPSR (Cpu_Context : Cpu_Context_Type) return Cpu_Register_Type;

   function Get_MSCRATCH return Cpu_Register_Type;

   type Thread_Pointer_Type is record
      Cpu_Running_In_Privileged_Mode : Boolean := False;
      Thread_Id : Interfaces.Unsigned_8 := 0;
      Cpu_Id : Interfaces.Unsigned_8 := 0;
   end record
     with Size => 32,
          Bit_Order => System.Low_Order_First;

   TP_Cpu_Running_In_Privileged_Mode_Bit_Offset : constant := 0;

   for Thread_Pointer_Type use record
      Cpu_Running_In_Privileged_Mode at 0 range TP_Cpu_Running_In_Privileged_Mode_Bit_Offset .. TP_Cpu_Running_In_Privileged_Mode_Bit_Offset;
      Thread_Id at 0 range 8 .. 15;
      Cpu_Id at 0 range 16 .. 23;
   end record;

   --
   --  NOTE: This bit mask must agree with the bit offset of Cpu_Running_In_Privileged_Mode
   --  in Thread_Pointer_Type
   --
   TP_Cpu_Running_In_Privileged_Mode_Bit_Mask : constant :=
      2 ** TP_Cpu_Running_In_Privileged_Mode_Bit_Offset;

   function Get_Thread_Pointer return Thread_Pointer_Type with
      Inline_Always, Suppress => All_Checks;

   procedure Set_Thread_Pointer (Thread_Pointer : Thread_Pointer_Type) with
      Inline_Always, Suppress => All_Checks;

private
   use HiRTOS_Cpu_Arch_Parameters;
   use HiRTOS_Cpu_Arch_Interface_Private;

   --
   --  CPU context saved on the current's stack on entry to ISRs and on synchronous
   --  task context switches. Fields are in the exact order as the will be stored on the
   --  stack.
   --
   --  NOTE: X0 does not need to be saved as it is always 0. SP doe snot really need
   --  to be saved on the stack, but it is just a redundant copy for a safety check.
   --
   type Cpu_Context_Type is record
      RA : Cpu_Register_Type;  --  also known as register X1
      SP : Cpu_Register_Type;  --  also known as register X2
      GP : Cpu_Register_Type;  --  also known as register X3
      TP : Thread_Pointer_Type;  --  also known as register X4
      T0 : Cpu_Register_Type;  --  also known as register X5
      T1 : Cpu_Register_Type;  --  also known as register X6
      T2 : Cpu_Register_Type;  --  also known as register X7
      FP : Cpu_Register_Type;  --  also known as register s0 or X8
      S1 : Cpu_Register_Type;  --  also known as register X9
      A0 : Cpu_Register_Type;  --  also known as register X10
      A1 : Cpu_Register_Type;  --  also known as register X11
      A2 : Cpu_Register_Type;  --  also known as register X12
      A3 : Cpu_Register_Type;  --  also known as register X13
      A4 : Cpu_Register_Type;  --  also known as register X14
      A5 : Cpu_Register_Type;  --  also known as register X15
      A6 : Cpu_Register_Type;  --  also known as register X16
      A7 : Cpu_Register_Type;  --  also known as register X17
      S2 : Cpu_Register_Type;  --  also known as register X18
      S3 : Cpu_Register_Type;  --  also known as register X19
      S4 : Cpu_Register_Type;  --  also known as register X20
      S5 : Cpu_Register_Type;  --  also known as register X21
      S6 : Cpu_Register_Type;  --  also known as register X22
      S7 : Cpu_Register_Type;  --  also known as register X23
      S8 : Cpu_Register_Type;  --  also known as register X24
      S9 : Cpu_Register_Type;  --  also known as register X25
      S10 : Cpu_Register_Type;  --  also known as register X26
      S11 : Cpu_Register_Type;  --  also known as register X27
      T3 : Cpu_Register_Type;  --  also known as register X28
      T4 : Cpu_Register_Type;  --  also known as register X29
      T5 : Cpu_Register_Type;  --  also known as register X30
      T6 : Cpu_Register_Type;  --  also known as register X31
      MEPC : Cpu_Register_Type;
      MSTATUS : MSTATUS_Type;
      MSCRATCH : Cpu_Register_Type;
   end record
      with Convention => C,
           Size => 34 * Cpu_Register_Type'Size;

   for Cpu_Context_Type use record
      RA  at 0 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      SP  at 1 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      GP  at 2 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      TP  at 3 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      T0  at 4 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      T1  at 5 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      T2  at 6 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      FP  at 7 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      S1  at 8 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      A0  at 9 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      A1  at 10 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      A2  at 11 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      A3  at 12 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      A4  at 13 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      A5  at 14 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      A6  at 15 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      A7  at 16 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      S2  at 17 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      S3  at 18 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      S4  at 19 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      S5  at 20 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      S6  at 21 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      S7  at 22 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      S8  at 23 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      S9  at 24 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      S10 at 25 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      S11 at 26 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      T3  at 27 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      T4  at 28 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      T5  at 29 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      T6  at 30 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      MEPC at 31 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      MSTATUS at 32 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
      MSCRATCH at 33 * Integer_Register_Size_In_Bytes range 0 .. Machine_Word_Width_In_Bits - 1;
   end record;

   function Get_Saved_PC (Cpu_Context : Cpu_Context_Type) return System.Address is
      (System.Storage_Elements.To_Address (
         System.Storage_Elements.Integer_Address (Cpu_Context.MEPC)));

   function Get_Saved_CPSR (Cpu_Context : Cpu_Context_Type) return Cpu_Register_Type is
      (Cpu_Register_Type (Cpu_Context.MSTATUS.Value));

end HiRTOS_Cpu_Arch_Interface.Thread_Context;
