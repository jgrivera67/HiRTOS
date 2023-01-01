--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary RTOS to target platform interface - Tick timer driver
--

with HiRTOS_Platform_Parameters;
with HiRTOS.Interrupt_Handling;
with System.Machine_Code;
with System.Storage_Elements;

package body HiRTOS_Cpu_Arch_Interface.Tick_Timer with SPARK_Mode => On is

   procedure Tick_Timer_Interrupt_Handler (Arg : System.Address);

   Timer_Ticks_Per_Us : constant :=
      HiRTOS_Platform_Parameters.System_Clock_Frequency_Hz / 1_000_000;

   pragma Compile_Time_Error
     (Timer_Ticks_Per_Us = 0, "Invalid Timer_Ticks_Per_Us");

   procedure Initialize is
      CNTP_CTL_Value : CNTP_CTL_Type;
      CNTFRQ_Value : CNTFRQ_Type;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;
      CNTFRQ_Value := Get_CNTFRQ;
      pragma Assert (CNTFRQ_Value = CNTFRQ_Type (HiRTOS_Platform_Parameters.System_Clock_Frequency_Hz));

      --
      --  Make sure that the timer is disabled:
      --
      --  NOTE: Even if the ENABLE bit is 0, CNTPCT continues to count.
      --
      CNTP_CTL_Value := Get_CNTP_CTL;
      CNTP_CTL_Value.ENABLE := Timer_Disabled;
      CNTP_CTL_Value.IMASK := Timer_Interrupt_Masked;
      Set_CNTP_CTL (CNTP_CTL_Value);

      --
      --  NOTE: the generic timer interrupt is enabled in the GIC and in the
      --  peripheral when Start_Timer is called and disabled when Stop_Timer
      --  is called.
      --

      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Initialize;

   procedure Start_Timer (Expiration_Time_Us : HiRTOS.Time_Us_Type) is
      use System.Storage_Elements;
      CNTP_CTL_Value : CNTP_CTL_Type;
      CNTP_TVAL_Value : constant CNTP_TVAL_Type :=
         CNTP_TVAL_Type (Expiration_Time_Us * Timer_Ticks_Per_Us);
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;

      --
      --  Enable tick timer interrupt in the generic timer peipheral:
      --
      --  NOTE: Section G8.7.16 of ARMv8 Architecture Reference Manual says:
      --  "When the value of the ENABLE bit is 1, ISTATUS indicates whether
      --   the timer condition is met. ISTATUS takes no account of the value
      --   of the IMASK bit. If the value of ISTATUS is 1 and the value of
      --   IMASK is 0 then the timer interrupt is asserted.
      --   Setting the ENABLE bit to 0 disables the timer output signal,
      --   but the timer value accessible from CNTP_TVAL continues to
      --   count down. Disabling the output signal might be a
      --   power-saving option."
      --
      CNTP_CTL_Value := Get_CNTP_CTL;
      CNTP_CTL_Value.ENABLE := Timer_Enabled;
      CNTP_CTL_Value.IMASK := Timer_Interrupt_Not_Masked;
      Set_CNTP_CTL (CNTP_CTL_Value);

      Set_CNTP_TVAL (CNTP_TVAL_Value);

      --  Configure generic timer interrupt in the GIC:
      Interrupt_Controller.Configure_Internal_Interrupt (
         Internal_Interrupt_Id => Generic_Timer_Interrupt_Id,
         Priority => Interrupt_Controller.Highest_Interrupt_Priority,
         Cpu_Interrupt_Line => Interrupt_Controller.Cpu_Interrupt_Irq,
         Trigger_Mode => Interrupt_Controller.Interrupt_Level_Sensitive,
         Interrupt_Handler_Entry_Point => Tick_Timer_Interrupt_Handler'Access,
         Interrupt_Handler_Arg => To_Address (Integer_Address (CNTP_TVAL_Value)));

      --  Enable generic timer interrupt in the GIC:
      Interrupt_Controller.Enable_Internal_Interrupt (Generic_Timer_Interrupt_Id);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Start_Timer;

   procedure Stop_Timer is
      CNTP_CTL_Value : CNTP_CTL_Type;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;

      --  Disable generic timer interrupt in the GIC:
      Interrupt_Controller.Disable_Internal_Interrupt (Generic_Timer_Interrupt_Id);

      --  Disable tick timer interrupt in the generic timer peipheral:
      CNTP_CTL_Value := Get_CNTP_CTL;
      CNTP_CTL_Value.ENABLE := Timer_Disabled;
      CNTP_CTL_Value.IMASK := Timer_Interrupt_Masked;
      Set_CNTP_CTL (CNTP_CTL_Value);

      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Stop_Timer;

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

   procedure Tick_Timer_Interrupt_Handler (Arg : System.Address)
   is
      use System.Storage_Elements;
      CNTP_TVAL_Value : constant CNTP_TVAL_Type := CNTP_TVAL_Type (To_Integer (Arg));
   begin
      --
      --  NOTE: Setting CNTP_TVAL here serves two purposes:
      --  - Clear the timer interrupt at the timer peripheral
      --  - Set the timer to fire for the next tick
      --
      Set_CNTP_TVAL (CNTP_TVAL_Value);
      HiRTOS.Interrupt_Handling.RTOS_Tick_Timer_Interrupt_Handler;
   end Tick_Timer_Interrupt_Handler;

   function Get_CNTFRQ return CNTFRQ_Type is
      CNTFRQ_Value : CNTFRQ_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c14, c0, 0",
         Outputs => CNTFRQ_Type'Asm_Output ("=r", CNTFRQ_Value), --  %0
         Volatile => True);

      return CNTFRQ_Value;
   end Get_CNTFRQ;

   procedure Set_CNTFRQ (CNTFRQ_Value : CNTFRQ_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c14, c0, 0",
         Inputs => CNTFRQ_Type'Asm_Input ("r", CNTFRQ_Value), --  %0
         Volatile => True);
   end Set_CNTFRQ;

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

   function Get_CNTPCT return CNTPCT_Type is
      CNTPCT_Value : CNTPCT_Type;
   begin
      --  NOTE: Use "=&r" to ensure different registers is used
      System.Machine_Code.Asm (
         "mrrc p15, 0, %0, %1, c14",
         Outputs => [Interfaces.Unsigned_32'Asm_Output ("=r", CNTPCT_Value.Low_Word),    --  %0
                     Interfaces.Unsigned_32'Asm_Output ("=&r", CNTPCT_Value.High_Word)], --  %1
         Volatile => True);

      return CNTPCT_Value;
   end Get_CNTPCT;

   function Get_CNTPCTSS return CNTPCT_Type is
      CNTPCT_Value : CNTPCT_Type;
   begin
      --  NOTE: Use "=&r" to ensure different registers is used
      System.Machine_Code.Asm (
         "mrrc p15, 8, %0, %1, c14",
         Outputs => [Interfaces.Unsigned_32'Asm_Output ("=r", CNTPCT_Value.Low_Word),    --  %0
                     Interfaces.Unsigned_32'Asm_Output ("=&r", CNTPCT_Value.High_Word)], --  %1
         Volatile => True);

      return CNTPCT_Value;
   end Get_CNTPCTSS;

end HiRTOS_Cpu_Arch_Interface.Tick_Timer;
