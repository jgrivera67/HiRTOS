--
--  Copyright (c) 2024, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target CPU architecture interface - private declarations
--

with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface_Private is

   function Get_MISA return MISA_Type is
      MISA_Value : MISA_Type;
   begin
      System.Machine_Code.Asm (
         "csrr  %0, misa",
         Outputs => MISA_Type'Asm_Output ("=r", MISA_Value),
         Volatile => True);

      return MISA_Value;
   end Get_MISA;

   function Get_MTVEC return MTVEC_Type is
      MTVEC_Value : MTVEC_Type;
   begin
      System.Machine_Code.Asm (
         "csrr %0, mtvec",
         Outputs => Integer_Address'Asm_Output ("=r", MTVEC_Value.Value), --  %0
         Volatile => True);

      return MTVEC_Value;
   end Get_MTVEC;

   procedure Set_MTVEC (MTVEC_Value : MTVEC_Type)
   is
   begin
      System.Machine_Code.Asm (
         "csrw mtvec, %0",
         Inputs => Integer_Address'Asm_Input ("r", MTVEC_Value.Value), --  %0
         Volatile => True);
   end Set_MTVEC;

   function Get_MSTATUS return MSTATUS_Type
   is
      MSTATUS_Value : MSTATUS_Type;
   begin
      System.Machine_Code.Asm (
         "csrr  %0, mstatus",
         Outputs => Integer_Address'Asm_Output ("=r", MSTATUS_Value.Value),
         Volatile => True);

      return MSTATUS_Value;
   end Get_MSTATUS;

   function Get_Mepc_Register return Integer_Address is
      Reg_Value : Integer_Address;
   begin
      System.Machine_Code.Asm (
         "csrr  %0, mepc",
         Outputs => Integer_Address'Asm_Output ("=r", Reg_Value),
         Volatile => True);

      return Reg_Value;
   end Get_Mepc_Register;

end HiRTOS_Cpu_Arch_Interface_Private;