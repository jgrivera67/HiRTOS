--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - ARMv8-A system registers
--

with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface.System_Registers with SPARK_Mode => Off is

   function Get_SCTLR_EL1 return SCTLR_EL1_Type is
      SCTLR_EL1_Value : SCTLR_EL1_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, sctlr_el1",
         Outputs => SCTLR_EL1_Type'Asm_Output ("=r", SCTLR_EL1_Value), --  %0
         Volatile => True);

      return SCTLR_EL1_Value;
   end Get_SCTLR_EL1;

   procedure Set_SCTLR_EL1 (SCTLR_EL1_Value : SCTLR_EL1_Type) is
   begin
      System.Machine_Code.Asm (
         "msr sctlr_el1, %0",
         Inputs => SCTLR_EL1_Type'Asm_Input ("r", SCTLR_EL1_Value), --  %0
         Volatile => True);
   end Set_SCTLR_EL1;

   function Get_CPACR_EL1 return CPACR_EL1_Type is
      CPACR_EL1_Value : CPACR_EL1_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, cpacr_el1",
         Outputs => CPACR_EL1_Type'Asm_Output ("=r", CPACR_EL1_Value), --  %0
         Volatile => True);

      return CPACR_EL1_Value;
   end Get_CPACR_EL1;

   procedure Set_CPACR_EL1 (CPACR_EL1_Value : CPACR_EL1_Type) is
   begin
      System.Machine_Code.Asm (
         "msr cpacr_el1, %0",
         Inputs => CPACR_EL1_Type'Asm_Input ("r", CPACR_EL1_Value), --  %0
         Volatile => True);
   end Set_CPACR_EL1;

   function Get_VBAR_EL1 return System.Address is
      VBAR_Value : System.Address;
   begin
      System.Machine_Code.Asm (
         "mrs %0, vbar_el1",
         Outputs => System.Address'Asm_Output ("=r", VBAR_Value), --  %0
         Volatile => True);

      return VBAR_Value;
   end Get_VBAR_EL1;

   procedure Set_VBAR_EL1 (VBAR_Value : System.Address) is
   begin
      System.Machine_Code.Asm (
         "msr vbar_el1, %0",
         Inputs => System.Address'Asm_Input ("r", VBAR_Value), --  %0
         Volatile => True);
   end Set_VBAR_EL1;

   function Get_CONTEXTIDR_EL1 return CONTEXTIDR_EL1_Type is
      CONTEXTIDR_Value : CONTEXTIDR_EL1_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, contextidr_el1",
         Outputs => CONTEXTIDR_EL1_Type'Asm_Output ("=r", CONTEXTIDR_Value), --  %0
         Volatile => True);

      return CONTEXTIDR_Value;
   end Get_CONTEXTIDR_EL1;

   procedure Set_CONTEXTIDR_EL1 (CONTEXTIDR_Value : CONTEXTIDR_EL1_Type) is
   begin
      System.Machine_Code.Asm (
         "msr contextidr_el1, %0",
         Inputs => CONTEXTIDR_EL1_Type'Asm_Input ("r", CONTEXTIDR_Value), --  %0
         Volatile => True);
   end Set_CONTEXTIDR_EL1;

   function Get_ESR_EL1 return ESR_EL1_Type is
      ESR_EL1_Value : ESR_EL1_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, esr_el1",
         Outputs => ESR_EL1_Type'Asm_Output ("=r", ESR_EL1_Value), --  %0
         Volatile => True);

      return ESR_EL1_Value;
   end Get_ESR_EL1;

   procedure Set_ESR_EL1 (ESR_EL1_Value : ESR_EL1_Type) is
   begin
      System.Machine_Code.Asm (
         "msr esr_el1, %0",
         Inputs => ESR_EL1_Type'Asm_Input ("r", ESR_EL1_Value), --  %0
         Volatile => True);
   end Set_ESR_EL1;

   function Get_FAR_EL1 return FAR_EL1_Type is
      FAR_EL1_Value : FAR_EL1_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, far_el1",
         Outputs => FAR_EL1_Type'Asm_Output ("=r", FAR_EL1_Value), --  %0
         Volatile => True);

      return FAR_EL1_Value;
   end Get_FAR_EL1;

   procedure Set_FAR_EL1 (FAR_EL1_Value : FAR_EL1_Type) is
   begin
      System.Machine_Code.Asm (
         "msr far_el1, %0",
         Inputs => FAR_EL1_Type'Asm_Input ("r", FAR_EL1_Value), --  %0
         Volatile => True);
   end Set_FAR_EL1;

end HiRTOS_Cpu_Arch_Interface.System_Registers;
