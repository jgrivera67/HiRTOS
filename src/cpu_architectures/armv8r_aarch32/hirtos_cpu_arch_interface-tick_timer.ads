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

package HiRTOS_Cpu_Arch_Interface.Tick_Timer
   with SPARK_Mode => On
is

   procedure Initialize;

private

   ----------------------------------------------------------------------------
   --  ARMv8-R Generic timer declarations
   ----------------------------------------------------------------------------

   type CNTFRQ_Type is new Interfaces.Unsigned_32;

   function Get_CNTFRQ return CNTFRQ_Type
      with Inline_Always;

   type Timer_Enable_Type is (Timer_Disabled, Timer_Enabled)
      with Size => 1;

   for Timer_Enable_Type use
      (Timer_Disabled => 2#0#,
       Timer_Enabled => 2#1#);

   type Timer_Interrupt_Mask_Type is (Timer_Interrupt_Not_Masked,
                                      Timer_Interrupt_Masked)
      with Size => 1;

   for Timer_Interrupt_Mask_Type use
      (Timer_Interrupt_Not_Masked => 2#0#,
       Timer_Interrupt_Masked => 2#1#);

   type Timer_Status_Type is (Timer_Condition_Not_Met,
                              Timer_Condition_Met)
      with Size => 1;

   for Timer_Status_Type use
      (Timer_Condition_Not_Met => 2#0#,
       Timer_Condition_Met => 2#1#);

   --
   --  Counter-timer Physical Timer Control register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type CNTP_CTL_Type is record
      ENABLE : Timer_Enable_Type := Timer_Disabled;
      IMASK : Timer_Interrupt_Mask_Type := Timer_Interrupt_Not_Masked;
      ISTATUS : Timer_Status_Type := Timer_Condition_Not_Met;
   end record
   with Size => 32,
        Bit_Order => System.Low_Order_First;

   for CNTP_CTL_Type use record
      ENABLE at 0 range 0 .. 0;
      IMASK at 0 range 1 .. 1;
      ISTATUS at 0 range 2 .. 2;
   end record;

   function Get_CNTP_CTL return CNTP_CTL_Type
      with Inline_Always;

   procedure Set_CNTP_CTL (CNTP_CTL_Value : CNTP_CTL_Type)
      with Inline_Always;

   --
   --  Counter-timer Physical Timer TimerValue register
   --
   --  From section G8.7.18 of DDI0487Fc_armv8_arm.pdf:
   --  "On a read of this register:
   --  - If CNTP_CTL.ENABLE is 0, the value returned is UNKNOWN.
   --  - If CNTP_CTL.ENABLE is 1, the value returned is (CNTP_CVAL - CNTPCT).
   --
   --  On a write of this register, CNTP_CVAL is set to (CNTPCT + TimerValue), where
   --  TimerValue is treated as a signed 32-bit integer.
   --  When CNTP_CTL.ENABLE is 1, the timer condition is met when (CNTPCT - CNTP_CVAL)
   --  is greater than or equal to zero. This means that TimerValue acts like a 32-bit
   --  downcounter timer. When the timer condition is met:
   --  - CNTP_CTL.ISTATUS is set to 1.
   --  - If CNTP_CTL.IMASK is 0, an interrupt is generated.
   --
   --  When CNTP_CTL.ENABLE is 0, the timer condition is not met, but CNTPCT continues
   --  to count, so the TimerValue view appears to continue to count down."
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type CNTP_TVAL_Type is new Interfaces.Unsigned_32;

   function Get_CNTP_TVAL return CNTP_TVAL_Type
      with Inline_Always;

   procedure Set_CNTP_TVAL (CNTP_TVAL_Value : CNTP_TVAL_Type)
      with Inline_Always;

end HiRTOS_Cpu_Arch_Interface.Tick_Timer;
