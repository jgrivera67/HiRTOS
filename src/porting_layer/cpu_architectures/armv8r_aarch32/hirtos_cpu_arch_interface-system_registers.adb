--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary RTOS to target platform interface - ARMv8-R system registers
--

with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface.System_Registers with SPARK_Mode => On is

   function Get_SCTLR return SCTLR_Type is
      SCTLR_Value : SCTLR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c1, c0, 0",
         Outputs => SCTLR_Type'Asm_Output ("=r", SCTLR_Value), --  %0
         Volatile => True);

      return SCTLR_Value;
   end Get_SCTLR;

   procedure Set_SCTLR (SCTLR_Value : SCTLR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c1, c0, 0",
         Inputs => SCTLR_Type'Asm_Input ("r", SCTLR_Value), --  %0
         Volatile => True);
   end Set_SCTLR;

   function Get_CPACR return CPACR_Type is
      CPACR_Value : CPACR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c1, c0, 2",
         Outputs => CPACR_Type'Asm_Output ("=r", CPACR_Value), --  %0
         Volatile => True);

      return CPACR_Value;
   end Get_CPACR;

   procedure Set_CPACR (CPACR_Value : CPACR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c1, c0, 2",
         Inputs => CPACR_Type'Asm_Input ("r", CPACR_Value), --  %0
         Volatile => True);
   end Set_CPACR;

end HiRTOS_Cpu_Arch_Interface.System_Registers;
