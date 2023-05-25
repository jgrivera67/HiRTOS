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
   use ASCII;

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

   procedure Set_DCCMVAC (DCCMVAC_Value : System.Address) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c7, c10, 1" & LF &
         "isb",
         Inputs => System.Address'Asm_Input ("r", DCCMVAC_Value), --  %0
         Volatile => True);
   end Set_DCCMVAC;

   procedure Set_DCIMVAC (DCIMVAC_Value : System.Address) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c7, c6, 1" & LF &
         "isb",
         Inputs => System.Address'Asm_Input ("r", DCIMVAC_Value), --  %0
         Volatile => True);
   end Set_DCIMVAC;

   procedure Set_DCCIMVAC (DCCIMVAC_Value : System.Address) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c7, c14, 1" & LF &
         "isb",
         Inputs => System.Address'Asm_Input ("r", DCCIMVAC_Value), --  %0
         Volatile => True);
   end Set_DCCIMVAC;

   procedure Set_DCIM_ALL is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c15, c5, 0" & LF &
         "isb",
         Inputs => System.Address'Asm_Input ("r", System.Null_Address), --  %0
         Volatile => True);
   end Set_DCIM_ALL;

   procedure Set_ICIALLU is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c7, c5, 0" & LF &
         "isb",
         Inputs => System.Address'Asm_Input ("r", System.Null_Address), --  %0
         Volatile => True);
   end Set_ICIALLU;

   function Get_VBAR return System.Address is
      VBAR_Value : System.Address;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c12, c0, 0",
         Outputs => System.Address'Asm_Output ("=r", VBAR_Value), --  %0
         Volatile => True);

      return VBAR_Value;
   end Get_VBAR;

   procedure Set_VBAR (VBAR_Value : System.Address) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c12, c0, 0",
         Inputs => System.Address'Asm_Input ("r", VBAR_Value), --  %0
         Volatile => True);
   end Set_VBAR;

end HiRTOS_Cpu_Arch_Interface.System_Registers;
