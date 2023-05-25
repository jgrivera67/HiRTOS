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

package body HiRTOS_Cpu_Arch_Interface.System_Registers.Hypervisor with SPARK_Mode => On is

   function Get_HCR return HCR_Type is
      HCR_Value : HCR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 4, %0, c1, c1, 0",
         Outputs => HCR_Type'Asm_Output ("=r", HCR_Value), --  %0
         Volatile => True);

      return HCR_Value;
   end Get_HCR;

   procedure Set_HCR (HCR_Value : HCR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 4, %0, c1, c1, 0",
         Inputs => HCR_Type'Asm_Input ("r", HCR_Value), --  %0
         Volatile => True);
   end Set_HCR;

   function Get_HSR return HSR_Type is
      HSR_Value : HSR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 4, %0, c5, c2, 0",
         Outputs => HSR_Type'Asm_Output ("=r", HSR_Value), --  %0
         Volatile => True);

      return HSR_Value;
   end Get_HSR;

   procedure Set_HSR (HSR_Value : HSR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 4, %0, c5, c2, 0",
         Inputs => HSR_Type'Asm_Input ("r", HSR_Value), --  %0
         Volatile => True);
   end Set_HSR;

   function Get_HSCTLR return HSCTLR_Type is
      HSCTLR_Value : HSCTLR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 4, %0, c1, c0, 0",
         Outputs => HSCTLR_Type'Asm_Output ("=r", HSCTLR_Value), --  %0
         Volatile => True);

      return HSCTLR_Value;
   end Get_HSCTLR;

   procedure Set_HSCTLR (HSCTLR_Value : HSCTLR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 4, %0, c1, c0, 0",
         Inputs => HSCTLR_Type'Asm_Input ("r", HSCTLR_Value), --  %0
         Volatile => True);
   end Set_HSCTLR;

   function Get_HVBAR return System.Address is
      HVBAR_Value : System.Address;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 4, %0, c12, c0, 0",
         Outputs => System.Address'Asm_Output ("=r", HVBAR_Value), --  %0
         Volatile => True);

      return HVBAR_Value;
   end Get_HVBAR;

   procedure Set_HVBAR (HVBAR_Value : System.Address) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 4, %0, c12, c0, 0",
         Inputs => System.Address'Asm_Input ("r", HVBAR_Value), --  %0
         Volatile => True);
   end Set_HVBAR;

end HiRTOS_Cpu_Arch_Interface.System_Registers.Hypervisor;
