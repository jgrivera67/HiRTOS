--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  ARM PSCI (Power State Coordination Interface) interface
--

with System.Machine_Code;
with Hirtos_Low_Level_Debug_Interface;

package body PSCI_Interface is

   function SMC_Call (Function_Id : PSCI_Function_Id_Type;
                      Arg1 : Cpu_Register_Type;
                      Arg2 : Cpu_Register_Type;
                      Arg3 : Cpu_Register_Type) return PSCI_Error_Type
   is
      use ASCII;
      Result : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
           "mov x0, %1" & LF &
           "mov x1, %2" & LF &
           "mov x2, %3" & LF &
           "mov x3, %4" & LF &
           "smc #0" & LF &
           "mov %0, x0",
           Outputs => Cpu_Register_Type'Asm_Output ("=r", Result), --  %0
           Inputs => [
                        Cpu_Register_Type'Asm_Input ("r", Function_Id'Enum_Rep), --  %1
                        Cpu_Register_Type'Asm_Input ("r", Arg1),                 --  %2
                        Cpu_Register_Type'Asm_Input ("r", Arg2),                 --  %3
                        Cpu_Register_Type'Asm_Input ("r", Arg3)                  --  %4
                     ],
           Volatile => True);

      return PSCI_Error_Type'Enum_Val (Result);
   end SMC_Call;

   procedure Cpu_On (Cpu_Id : CPU.Secondary_Cpu_Core_Id_Type;
                     Entry_Point_Address : System.Address) is
      MPIDR_Value : constant MPIDR_EL1_Type := Cpu_Id_To_MPIDR (Cpu_Id, Board.Cpu_Model);
      PSCI_Error : constant PSCI_Error_Type :=
         SMC_Call (Function_Id => PSCI_Function_Cpu_On,
                   Arg1 => Cpu_Register_Type (MPIDR_Value.Value),
                   Arg2 => Cpu_Register_Type (To_Integer (Entry_Point_Address)),
                   Arg3 => 0);
   begin
      if PSCI_Error /= PSCI_No_Error then
         Hirtos_Low_Level_Debug_Interface.Print_String ("PSCI error: ");
         Hirtos_Low_Level_Debug_Interface.Print_String (PSCI_Error'Image);
         Hirtos_Low_Level_Debug_Interface.Put_Char (ASCII.LF);
      end if;
   end Cpu_On;

end PSCI_Interface;
