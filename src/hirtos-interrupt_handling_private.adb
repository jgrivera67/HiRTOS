--
--  Copyright (c) 2022-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

package body HiRTOS.Interrupt_Handling_Private is

   procedure Initialize_Interrupt_Nesting_Level
     (Interrupt_Nesting_Level : out Interrupt_Nesting_Level_Type);

   -----------------------------------------------------------------------------
   --  Public Subprograms
   -----------------------------------------------------------------------------

   procedure Initialize is
   begin
      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Initialize;
      HiRTOS_Cpu_Arch_Interface.Enable_Cpu_Interrupting;
   end Initialize;

   procedure Initialize_Interrupt_Nesting_Level_Stack
     (Interrupt_Nesting_Level_Stack : out Interrupt_Nesting_Level_Stack_Type)
   is
   begin
      for Nesting_Level of Interrupt_Nesting_Level_Stack
        .Interrupt_Nesting_Level_Array
      loop
         Initialize_Interrupt_Nesting_Level (Nesting_Level);
      end loop;

      Interrupt_Nesting_Level_Stack.Current_Interrupt_Nesting_Counter :=
        Interrupt_Nesting_Counter_Type'First + 1;
   end Initialize_Interrupt_Nesting_Level_Stack;

   procedure Increment_Interrupt_Nesting
     (Interrupt_Nesting_Level_Stack : in out Interrupt_Nesting_Level_Stack_Type;
      Stack_Pointer : System.Address)
   is
      Current_Interrupt_Nesting_Counter : Interrupt_Nesting_Counter_Type renames
        Interrupt_Nesting_Level_Stack.Current_Interrupt_Nesting_Counter;
   begin
      Current_Interrupt_Nesting_Counter := @ + 1;
      Interrupt_Nesting_Level_Stack.Interrupt_Nesting_Level_Array
         (Current_Interrupt_Nesting_Counter).Saved_Stack_Pointer := Stack_Pointer;
   end Increment_Interrupt_Nesting;

   procedure Decrement_Interrupt_Nesting
     (Interrupt_Nesting_Level_Stack : in out Interrupt_Nesting_Level_Stack_Type)
   is
      Current_Interrupt_Nesting_Counter :
        Interrupt_Nesting_Counter_Type renames
        Interrupt_Nesting_Level_Stack.Current_Interrupt_Nesting_Counter;
   begin
      Current_Interrupt_Nesting_Counter := @ - 1;
   end Decrement_Interrupt_Nesting;

   -----------------------------------------------------------------------------
   --  Private Subprograms
   -----------------------------------------------------------------------------

   procedure Initialize_Interrupt_Nesting_Level
     (Interrupt_Nesting_Level : out Interrupt_Nesting_Level_Type)
   is
   begin
      Interrupt_Nesting_Level.Interrupt_Id :=
        HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Invalid_Interrupt_Id;
      Interrupt_Nesting_Level.Interrupt_Nesting_Counter :=
        Active_Interrupt_Nesting_Counter_Type'First;
      Interrupt_Nesting_Level.Saved_Stack_Pointer := System.Null_Address;
      Interrupt_Nesting_Level.Atomic_Level := Atomic_Level_None;
   end Initialize_Interrupt_Nesting_Level;

end HiRTOS.Interrupt_Handling_Private;
