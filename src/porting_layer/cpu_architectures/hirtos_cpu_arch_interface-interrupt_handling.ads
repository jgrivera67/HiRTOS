--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target CPU architecture interface - interrupt handling
--

with HiRTOS_Cpu_Multi_Core_Interface;
with System.Storage_Elements;

package HiRTOS_Cpu_Arch_Interface.Interrupt_Handling
   with SPARK_Mode => On
is
   use HiRTOS_Cpu_Multi_Core_Interface;

   type ISR_Stack_Info_Type is record
      Base_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
   end record;

   function Get_ISR_Stack_Info (Cpu_Id : Cpu_Core_Id_Type)
      return ISR_Stack_Info_Type;

   function Valid_ISR_Stack_Pointer (Cpu_Id : Cpu_Core_Id_Type; Stack_Pointer : System.Address)
      return Boolean;

   procedure Interrupt_Handler_Epilog
      with Inline_Always, No_Return;

   procedure Handle_Undefined_Instruction_Exception
      with Pre => Cpu_In_Privileged_Mode;

end HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
