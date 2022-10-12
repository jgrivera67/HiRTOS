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

with HiRTOS_Platform_External_Interrupts;
with System.Storage_Elements;

package body HiRTOS.Interrupt_Nesting is

   procedure Initialize_Interrupt_Nesting_Level
     (Interrupt_Nesting_Level : out Interrupt_Nesting_Level_Type);

   -----------------------------------------------------------------------------
   --  Public Subprograms
   -----------------------------------------------------------------------------

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
      Stack_Pointer :        HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type)
   is
      Current_Interrupt_Nesting_Counter :
        Interrupt_Nesting_Counter_Type renames
        Interrupt_Nesting_Level_Stack.Current_Interrupt_Nesting_Counter;
      Current_Interrupt_Nesting_Level :
        Interrupt_Nesting_Level_Type renames
        Interrupt_Nesting_Level_Stack.Interrupt_Nesting_Level_Array
          (Current_Interrupt_Nesting_Counter);
   begin
      Current_Interrupt_Nesting_Level.Saved_Stack_Pointer := Stack_Pointer;
      Current_Interrupt_Nesting_Counter                   := @ + 1;
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
      Interrupt_Nesting_Level.Irq_Id :=
        HiRTOS_Platform_External_Interrupts.Invalid_Irq_Id;
      Interrupt_Nesting_Level.Interrupt_Nesting_Counter :=
        Active_Interrupt_Nesting_Counter_Type'First;
      Interrupt_Nesting_Level.Saved_Stack_Pointer :=
        HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type
          (System.Storage_Elements.To_Integer (System.Null_Address));
      Interrupt_Nesting_Level.Atomic_Level := Atomic_Level_None;
   end Initialize_Interrupt_Nesting_Level;

end HiRTOS.Interrupt_Nesting;
