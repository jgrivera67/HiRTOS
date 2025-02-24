--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target CPU architecture interface - private declarations
--

with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface_Private is
   use ASCII;

   function Get_CurrentEL return Exception_Level_Type is
      PSTATE_Value : PSTATE_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, currentel",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", PSTATE_Value.Value),
         Volatile => True);

      return PSTATE_Value.CurrentEL;
   end Get_CurrentEL;

   function Get_DAIF return DAIF_Type is
      PSTATE_Value : PSTATE_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, daif",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", PSTATE_Value.Value),
         Volatile => True);

      return PSTATE_Value.DAIF;
   end Get_DAIF;

   function Get_PSTATE return PSTATE_Type is
      NZCV_Reg_Value : Cpu_Register_Type;
      DAIF_Reg_Value : Cpu_Register_Type;
      CurrentEL_Reg_Value : Cpu_Register_Type;
      SPSel_Reg_Value : Cpu_Register_Type;
      PAN_Reg_Value : Cpu_Register_Type;
      UAO_Reg_Value : Cpu_Register_Type;
      DIT_Reg_Value : Cpu_Register_Type;
      SSBS_Reg_Value : Cpu_Register_Type;
      TCO_Reg_Value : Cpu_Register_Type;
      PSTATE_Value : PSTATE_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, nzcv" & LF &
         "mrs %1, daif" & LF &
         "mrs %2, currentel" & LF &
         "mrs %3, spsel" & LF &
         "mrs %4, pan" & LF &
         "mrs %5, uao" & LF &
         "mrs %6, dit" & LF &
         "mrs %7, ssbs" & LF &
         "mrs %8, tco",
         Outputs => [
            Cpu_Register_Type'Asm_Output ("=r", NZCV_Reg_Value), --  %0
            Cpu_Register_Type'Asm_Output ("=r", DAIF_Reg_Value), --  %1
            Cpu_Register_Type'Asm_Output ("=r", CurrentEL_Reg_Value), --  %2
            Cpu_Register_Type'Asm_Output ("=r", SPSel_Reg_Value), --  %3
            Cpu_Register_Type'Asm_Output ("=r", PAN_Reg_Value), --  %4
            Cpu_Register_Type'Asm_Output ("=r", UAO_Reg_Value), --  %5
            Cpu_Register_Type'Asm_Output ("=r", DIT_Reg_Value), --  %6
            Cpu_Register_Type'Asm_Output ("=r", SSBS_Reg_Value), --  %7
            Cpu_Register_Type'Asm_Output ("=r", TCO_Reg_Value) --  %8
         ],
         Volatile => True);

      PSTATE_Value.Value := (NZCV_Reg_Value or DAIF_Reg_Value or CurrentEL_Reg_Value or
                             SPSel_Reg_Value or PAN_Reg_Value or UAO_Reg_Value or
                             DIT_Reg_Value or SSBS_Reg_Value or TCO_Reg_Value);
      return PSTATE_Value;
   end Get_PSTATE;

end HiRTOS_Cpu_Arch_Interface_Private;