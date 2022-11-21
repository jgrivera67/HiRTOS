--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS to target CPU architecture interface - interrupt handling
--

with System.Storage_Elements;

package HiRTOS_Cpu_Arch_Interface.Interrupt_Handling
   with SPARK_Mode => On
is
   type ISR_Stack_Info_Type is record
      Base_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
   end record;

   function Get_ISR_Stack_Info return ISR_Stack_Info_Type;

   procedure Interrupt_Handler_Prolog
      with Inline_Always;

   procedure Interrupt_Handler_Epilog
      with Inline_Always;

private

   --
   --  Entry point of the undefined instruction exception handler
   --
   procedure Undefined_Instruction_Exception_Handler
      with Export,
           External_Name => "undefined_instruction_exception_handler";
   pragma Machine_Attribute (Undefined_Instruction_Exception_Handler, "naked");

   --
   --  Entry point of the supervisor call exception handler
   --
   procedure Supervisor_Call_Exception_Handler
      with Export,
           External_Name => "supervisor_call_exception_handler";
   pragma Machine_Attribute (Supervisor_Call_Exception_Handler, "naked");

   --
   --  Entry point of the prefetch abort exception handler
   --
   procedure Prefetch_Abort_Exception_Handler
      with Export,
           External_Name => "prefetch_abort_exception_handler";
   pragma Machine_Attribute (Prefetch_Abort_Exception_Handler, "naked");

   --
   --  Entry point of the data abort exception handler
   --
   procedure Data_Abort_Exception_Handler
      with Export,
           External_Name => "data_abort_exception_handler";
   pragma Machine_Attribute (Data_Abort_Exception_Handler, "naked");

   --
   --  Entry point of the IRQ interrupt handler
   --
   procedure Irq_Interrupt_Handler
      with Export,
           External_Name => "irq_interrupt_handler";
   pragma Machine_Attribute (Irq_Interrupt_Handler, "naked");

   --
   --  Entry point of the FIQ interrupt handler
   --
   procedure Fiq_Interrupt_Handler
      with Export,
           External_Name => "fiq_interrupt_handler";
   pragma Machine_Attribute (Fiq_Interrupt_Handler, "naked");

end HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
