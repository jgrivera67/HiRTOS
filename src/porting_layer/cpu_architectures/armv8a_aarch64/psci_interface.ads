--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  ARM PSCI (Power State Coordination Interface) interface
--

with HiRTOS_Cpu_Arch_Interface;
with HiRTOS_Cpu_Arch_Parameters;
with HiRTOS_Cpu_Multi_Core_Interface;
with System.Storage_Elements;

package PSCI_Interface with SPARK_MODE => On is
   use HiRTOS_Cpu_Arch_Interface;
   use HiRTOS_Cpu_Arch_Parameters;
   use HiRTOS_Cpu_Multi_Core_Interface;
   use System.Storage_Elements;

   procedure Cpu_On (Cpu_Id : Secondary_Cpu_Core_Id_Type;
                     Entry_Point_Address : System.Address)
      with Pre => Cpu_In_Privileged_Mode and then
                  Get_Cpu_Id = Valid_Cpu_Core_Id_Type'First and then
                  To_Integer (Entry_Point_Address) mod Instruction_Size_In_Bytes = 0;

private
   type PSCI_Function_Id_Type is (PSCI_Function_Cpu_On)
      with Size => 32;

   for PSCI_Function_Id_Type use (
      PSCI_Function_Cpu_On => 16#c400_0003#
   );

   type PSCI_Error_Type is (
      PSCI_Invalid_Address,
      PSCI_Disabled,
      PSCI_Not_Present,
      PSCI_Internal_Failure,
      PSCI_On_Pending,
      PSCI_Already_On,
      PSCI_Denied,
      PSCI_Invalid_Parameters,
      PSCI_Not_Supported,
      PSCI_No_Error
   ) with Size => 32;

   for PSCI_Error_Type use (
      PSCI_Invalid_Address => -9,
      PSCI_Disabled => -8,
      PSCI_Not_Present => -7,
      PSCI_Internal_Failure => -6,
      PSCI_On_Pending => -5,
      PSCI_Already_On => -4,
      PSCI_Denied => -3,
      PSCI_Invalid_Parameters => -2,
      PSCI_Not_Supported => -1,
      PSCI_No_Error => 0
   );

   function SMC_Call (Function_Id : PSCI_Function_Id_Type;
                      Arg1 : Cpu_Register_Type;
                      Arg2 : Cpu_Register_Type;
                      Arg3 : Cpu_Register_Type) return PSCI_Error_Type;
end PSCI_Interface;
