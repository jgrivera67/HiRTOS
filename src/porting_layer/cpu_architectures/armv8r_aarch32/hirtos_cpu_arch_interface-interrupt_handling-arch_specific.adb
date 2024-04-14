--
--  Copyright (c) 2024, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target CPU architecture interface - Architecture-specific interrupt handling
--

with HiRTOS.Interrupt_Handling;
with HiRTOS_Low_Level_Debug_Interface;

package body HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Arch_Specific
   with SPARK_Mode => On
is
   procedure Handle_Undefined_Instruction_Exception is
      Faulting_PC : constant System.Storage_Elements.Integer_Address :=
         System.Storage_Elements.To_Integer (HiRTOS.Interrupt_Handling.Get_Interrupted_PC) - 4;
   begin
      HiRTOS_Low_Level_Debug_Interface.Print_String (
         "*** Undefined instruction exception (faulting PC: ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (Faulting_PC));
      HiRTOS_Low_Level_Debug_Interface.Print_String (")" & ASCII.LF);

      raise Program_Error;
   end Handle_Undefined_Instruction_Exception;
end HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Arch_Specific;
