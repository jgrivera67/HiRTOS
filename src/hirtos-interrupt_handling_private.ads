--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;

private package HiRTOS.Interrupt_Handling_Private with
  SPARK_Mode => On
is
   --
   --  Interrupt nesting level object
   --
   --  @field Initialized: flag indicating if the interrupt nesting level object has been
   --         initialized.
   --  @field IRQ Id: IRQ that is being served by the ISR running at this interrupt nesting level.
   --  @field Saved_Stack_Pointer: saved stack pointer CPU register the last time the current ISR,
   --         at this interrupt nesting level, was preempted.
   --  @field Atomic_Level: Current atomic level
   --
   type Interrupt_Nesting_Level_Type is limited record
      Initialized : Boolean := False;
      Interrupt_Id : HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Interrupt_Id_Type :=
              HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Invalid_Interrupt_Id;
      Interrupt_Nesting_Counter : Active_Interrupt_Nesting_Counter_Type;
      Saved_Stack_Pointer       : System.Address := System.Null_Address;
      Atomic_Level              : Atomic_Level_Type := Atomic_Level_None;
   end record;

   type Interrupt_Nesting_Level_Array_Type is
     array
       (Active_Interrupt_Nesting_Counter_Type) of Interrupt_Nesting_Level_Type;

   type Interrupt_Nesting_Level_Stack_Type is limited record
      Interrupt_Nesting_Level_Array     : Interrupt_Nesting_Level_Array_Type;
      Current_Interrupt_Nesting_Counter : Interrupt_Nesting_Counter_Type :=
         Interrupt_Nesting_Counter_Type'First + 1;
   end record;

   procedure Initialize;

   procedure Initialize_Interrupt_Nesting_Level_Stack
     (Interrupt_Nesting_Level_Stack : out Interrupt_Nesting_Level_Stack_Type);

   procedure Increment_Interrupt_Nesting
     (Interrupt_Nesting_Level_Stack : in out Interrupt_Nesting_Level_Stack_Type;
      Stack_Pointer : System.Address) with
     Pre => HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled and then
            Get_Current_Interrupt_Nesting (Interrupt_Nesting_Level_Stack) <
               Interrupt_Nesting_Counter_Type'Last;

   procedure Decrement_Interrupt_Nesting
     (Interrupt_Nesting_Level_Stack : in out Interrupt_Nesting_Level_Stack_Type) with
     Pre => HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled and then
            Get_Current_Interrupt_Nesting (Interrupt_Nesting_Level_Stack) > 0;

   function Get_Current_Interrupt_Nesting
     (Interrupt_Nesting_Level_Stack : Interrupt_Nesting_Level_Stack_Type)
      return Interrupt_Nesting_Counter_Type is
      (Interrupt_Nesting_Level_Stack.Current_Interrupt_Nesting_Counter);

end HiRTOS.Interrupt_Handling_Private;
