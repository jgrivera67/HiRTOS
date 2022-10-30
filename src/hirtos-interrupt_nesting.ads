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

with HiRTOS_Cpu_Arch_Interface;
with HiRTOS_Platform_External_Interrupts;

private package HiRTOS.Interrupt_Nesting with
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
      Irq_Id : HiRTOS_Platform_External_Interrupts.Irq_Id_Type :=
              HiRTOS_Platform_External_Interrupts.Invalid_Irq_Id;
      Interrupt_Nesting_Counter : Active_Interrupt_Nesting_Counter_Type;
      Saved_Stack_Pointer       : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
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

   procedure Initialize_Interrupt_Nesting_Level_Stack
     (Interrupt_Nesting_Level_Stack : out Interrupt_Nesting_Level_Stack_Type);

   function Get_Current_Interrupt_Nesting
     (Interrupt_Nesting_Level_Stack : Interrupt_Nesting_Level_Stack_Type)
      return Interrupt_Nesting_Counter_Type with
     Inline_Always, Suppress => All_Checks;

   procedure Increment_Interrupt_Nesting
     (Interrupt_Nesting_Level_Stack : in out Interrupt_Nesting_Level_Stack_Type;
      Stack_Pointer :        HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type) with
     Pre =>
      Get_Current_Interrupt_Nesting (Interrupt_Nesting_Level_Stack) <
      Interrupt_Nesting_Counter_Type'Last;

   procedure Decrement_Interrupt_Nesting
     (Interrupt_Nesting_Level_Stack : in out Interrupt_Nesting_Level_Stack_Type) with
     Pre => Get_Current_Interrupt_Nesting (Interrupt_Nesting_Level_Stack) > 0;

   function Get_Current_Interrupt_Nesting
     (Interrupt_Nesting_Level_Stack : Interrupt_Nesting_Level_Stack_Type)
      return Interrupt_Nesting_Counter_Type is
     (Interrupt_Nesting_Level_Stack.Current_Interrupt_Nesting_Counter);

end HiRTOS.Interrupt_Nesting;
