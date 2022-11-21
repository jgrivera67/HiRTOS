--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary RTOS to target CPU architecture interface
--

with HiRTOS_Cpu_Arch_Parameters;
with System;

package HiRTOS_Cpu_Arch_Interface
   with SPARK_Mode => On,
        No_Elaboration_Code_All
is
   type Cpu_Register_Type is mod 2 ** HiRTOS_Cpu_Arch_Parameters.Machine_Word_Width_In_Bits
      with Size => HiRTOS_Cpu_Arch_Parameters.Machine_Word_Width_In_Bits;

   function Get_Call_Address return System.Address
      with Inline_Always,
           Suppress => All_Checks;

   function Get_Stack_Pointer return Cpu_Register_Type
      with Inline_Always,
           Suppress => All_Checks;

   procedure Set_Stack_Pointer (Stack_Pointer : Cpu_Register_Type)
      with Inline_Always,
           Suppress => All_Checks;

   function Get_Cpu_Status_Register return Cpu_Register_Type
      with Inline_Always,
           Suppress => All_Checks;

   function Cpu_Interrupting_Disabled return Boolean;

   --
   --  Disable interrupts at the CPU
   --
   --  NOTE: Only the IRQ interrupt is disabled, not the FIQ interrupt.
   --
   function Disable_Cpu_Interrupting return Cpu_Register_Type
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Restore interrupt enablement at the CPU
   --
   procedure Restore_Cpu_Interrupting (Old_Cpu_Interrupting : Cpu_Register_Type)
      with Pre => Cpu_In_Privileged_Mode and then
                  Cpu_Interrupting_Disabled;

   procedure Enable_Cpu_Interrupting
      with Pre => Cpu_In_Privileged_Mode;

   function Cpu_In_Privileged_Mode return Boolean;

   --
   --  Switch to CPU privileged mode
   --
   procedure Switch_Cpu_To_Privileged_Mode
      with Pre => not Cpu_In_Privileged_Mode and then
                  not Cpu_Interrupting_Disabled,
           Post => Cpu_In_Privileged_Mode;

   --
   --  Switch back to CPU unprivileged mode
   --
   procedure Switch_Cpu_To_Unprivileged_Mode
      with Pre => Cpu_In_Privileged_Mode and then
                  not Cpu_Interrupting_Disabled,
           Post => not Cpu_In_Privileged_Mode;

   function Ldrex_Word (Word_Address : System.Address) return Cpu_Register_Type
      with Inline_Always,
           Suppress => All_Checks;

   function Strex_Word (Word_Address : System.Address;
                        Value : Cpu_Register_Type) return Boolean
      with Inline_Always,
           Suppress => All_Checks;

   procedure Wait_For_Event
      with Inline_Always;

   procedure Send_Event
      with Inline_Always;

   procedure Memory_Barrier;

   function Atomic_Test_Set
     (Flag_Address : System.Address) return  Boolean
      with Inline_Always,
           Suppress => All_Checks;

   function Atomic_Fetch_Add
     (Counter_Address : System.Address;
      Value : Cpu_Register_Type) return Cpu_Register_Type
      with Inline_Always,
           Suppress => All_Checks;

   function Atomic_Fetch_Sub
     (Counter_Address : System.Address;
      Value : Cpu_Register_Type) return Cpu_Register_Type
      with Inline_Always,
           Suppress => All_Checks;

   function Count_Leading_Zeros (Value : Cpu_Register_Type)
      return Cpu_Register_Type
      with Import,
           Convention => C,
           External_Name => "__builtin_clz";

   function Count_Trailing_Zeros (Value : Cpu_Register_Type)
      return Cpu_Register_Type
      with Import,
           Convention => C,
           External_Name => "__builtin_ctz";

private

   --
   --  Values for CPSR mode field
   --
   CPSR_User_Mode : constant := 2#1_0000#;
   CPSR_Fast_Interrupt_Mode : constant := 2#1_0010#;
   CPSR_Supervisor_Mode : constant := 2#1_0011#;
   CPSR_Abort_Mode : constant := 2#1_0111#;
   CPSR_Undefined_Mode : constant := 2#1_1011#;
   CPSR_System_Mode : constant := 2#1_1111#;

end HiRTOS_Cpu_Arch_Interface;
