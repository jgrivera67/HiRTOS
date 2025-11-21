--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  Board-specific interface for Raspberry PI 4
--
with HiRTOS_Cpu_Arch_Interface;
with HiRTOS_Cpu_Arch_Parameters;
with HiRTOS_Cpu_Multi_Core_Interface;
with System.Storage_Elements;

package Board is
   use HiRTOS_Cpu_Arch_Parameters;
   use HiRTOS_Cpu_Multi_Core_Interface;
   use System.Storage_Elements;

   Board_Name : constant String := "Raspberry PI 4";

   Cpu_Model : constant Cpu_Model_Type := Cortex_A72;

   Uart_Clock_Frequency_Hz : constant := 48_000_000; --  48 MHz

   procedure Start_Secondary_Cpu (Cpu_Id : Secondary_Cpu_Core_Id_Type;
                                  Entry_Point_Address : System.Address)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode and then
                  Get_Cpu_Id = Valid_Cpu_Core_Id_Type'First and then
                  To_Integer (Entry_Point_Address) mod Instruction_Size_In_Bytes = 0;

private
   -----------------------------------------------------------------------------
   --  Secondary CPU cores declarations
   -----------------------------------------------------------------------------

   Secondary_Cpu_To_Spin_Address_Map :
      constant array (Secondary_Cpu_Core_Id_Type) of System.Address :=
      [
         1 => System'To_Address (16#e0#),
         2 => System'To_Address (16#e8#),
         3 => System'To_Address (16#f0#)
      ];
end Board;
