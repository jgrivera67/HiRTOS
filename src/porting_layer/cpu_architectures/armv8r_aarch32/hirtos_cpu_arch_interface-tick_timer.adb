--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary RTOS to target platform interface - Tick timer driver
--

with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface.Tick_Timer with SPARK_Mode => On is

   procedure Initialize is
   begin
      pragma Assert (False); -- ????
   end Initialize;

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

   function Get_CNTFRQ return CNTFRQ_Type is
      CNTFRQ_Value : CNTFRQ_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c14, c0, 0",
         Outputs => CNTFRQ_Type'Asm_Output ("=r", CNTFRQ_Value), --  %0
         Volatile => True);

      return CNTFRQ_Value;
   end Get_CNTFRQ;

   function Get_CNTP_CTL return CNTP_CTL_Type is
      CNTP_CTL_Value : CNTP_CTL_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c14, c2, 1",
         Outputs => CNTP_CTL_Type'Asm_Output ("=r", CNTP_CTL_Value), --  %0
         Volatile => True);

      return CNTP_CTL_Value;
   end Get_CNTP_CTL;

   procedure Set_CNTP_CTL (CNTP_CTL_Value : CNTP_CTL_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c14, c2, 1",
         Inputs => CNTP_CTL_Type'Asm_Input ("r", CNTP_CTL_Value), --  %0
         Volatile => True);
   end Set_CNTP_CTL;

   function Get_CNTP_TVAL return CNTP_TVAL_Type is
      CNTP_TVAL_Value : CNTP_TVAL_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c14, c2, 0",
         Outputs => CNTP_TVAL_Type'Asm_Output ("=r", CNTP_TVAL_Value), --  %0
         Volatile => True);

      return CNTP_TVAL_Value;
   end Get_CNTP_TVAL;

   procedure Set_CNTP_TVAL (CNTP_TVAL_Value : CNTP_TVAL_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c14, c2, 0",
         Inputs => CNTP_TVAL_Type'Asm_Input ("r", CNTP_TVAL_Value), --  %0
         Volatile => True);
   end Set_CNTP_TVAL;

end HiRTOS_Cpu_Arch_Interface.Tick_Timer;
