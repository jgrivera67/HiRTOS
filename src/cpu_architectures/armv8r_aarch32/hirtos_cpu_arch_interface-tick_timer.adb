--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
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
