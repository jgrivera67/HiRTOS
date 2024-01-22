--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Tick timer driver
--

with HiRTOS.Interrupt_Handling;
with HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
with HiRTOS_Cpu_Arch_Interface.Interrupts;
with HiRTOS_Cpu_Startup_Interface;
with System.Machine_Code;
with System.Storage_Elements;

package body HiRTOS_Cpu_Arch_Interface.Tick_Timer with SPARK_Mode => On is

   type Tick_Timer_Stats_Type is limited record
      Last_Period_Time_Stamp : Timer_Timestamp_Cycles_Type;
      Timer_Interrupt_Small_Drift_Count : Interfaces.Unsigned_32 := 0;
      Timer_Interrupt_Big_Drift_Count : Interfaces.Unsigned_32 := 0;
   end record;

   procedure Tick_Timer_Interrupt_Handler (Arg : System.Address)
      with Pre => Cpu_In_Privileged_Mode;

   Tick_Timer_Stats : Tick_Timer_Stats_Type;

   procedure Initialize is
      CNTP_CTL_Value : CNTP_CTL_Type;
      CNTFRQ_Value : CNTFRQ_Type;
   begin
      CNTFRQ_Value := Get_CNTFRQ;
      pragma Assert (CNTFRQ_Value = CNTFRQ_Type (HiRTOS_Platform_Parameters.System_Clock_Frequency_Hz));

      --
      --  Make sure that the timer is disabled:
      --
      --  NOTE: Even if the ENABLE bit is 0, CNTPCT continues to count.
      --
      if HiRTOS_Cpu_Startup_Interface.HiRTOS_Booted_As_Partition then
         CNTP_CTL_Value := Get_CNTV_CTL;
         CNTP_CTL_Value.ENABLE := Timer_Disabled;
         CNTP_CTL_Value.IMASK := Timer_Interrupt_Masked;
         Set_CNTV_CTL (CNTP_CTL_Value);
      else
         CNTP_CTL_Value := Get_CNTP_CTL;
         CNTP_CTL_Value.ENABLE := Timer_Disabled;
         CNTP_CTL_Value.IMASK := Timer_Interrupt_Masked;
         Set_CNTP_CTL (CNTP_CTL_Value);
      end if;

      --
      --  NOTE: the generic timer interrupt is enabled in the GIC and in the
      --  peripheral when Start_Timer is called and disabled when Stop_Timer
      --  is called.
      --
   end Initialize;

   function Get_Timer_Timestamp_Cycles return Timer_Timestamp_Cycles_Type is
      CNTPCT_Value : constant CNTPCT_Type :=
         (if HiRTOS_Cpu_Startup_Interface.HiRTOS_Booted_As_Partition then Get_CNTVCT
                                                                     else Get_CNTPCT);
   begin
      return  Timer_Timestamp_Cycles_Type (CNTPCT_Value.Value);
   end Get_Timer_Timestamp_Cycles;

   procedure Start_Timer (Expiration_Time_Us : HiRTOS.Relative_Time_Us_Type) is
      use System.Storage_Elements;
      CNTP_CTL_Value : CNTP_CTL_Type;
      CNTP_TVAL_Value : constant CNTP_TVAL_Type :=
         CNTP_TVAL_Type (Expiration_Time_Us * Timer_Counter_Cycles_Per_Us);
      Timer_Interrupt_Id : constant
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Interrupt_Id_Type :=
         (if HiRTOS_Cpu_Startup_Interface.HiRTOS_Booted_As_Partition then
             HiRTOS_Cpu_Arch_Interface.Interrupts.Generic_Virtual_Timer_Interrupt_Id
          else
             HiRTOS_Cpu_Arch_Interface.Interrupts.Generic_Physical_Timer_Interrupt_Id);
   begin
      pragma Assert (CNTP_TVAL_Value >= CNTP_TVAL_Type (Expiration_Time_Us));

      Tick_Timer_Stats.Last_Period_Time_Stamp := Get_Timer_Timestamp_Cycles;

      --
      --  Enable tick timer interrupt in the generic timer peripheral:
      --
      --  NOTE: Section G8.7.16 of ARMv8 Architecture Reference Manual says:
      --  "When the value of the ENABLE bit is 1, ISTATUS indicates whether
      --   the timer condition is met. ISTATUS takes no account of the value
      --   of the IMASK bit. If the value of ISTATUS is 1 and the value of
      --   IMASK is 0 then the timer interrupt is asserted.
      --   Setting the ENABLE bit to 0 disables the timer output signal,
      --   but the timer value accessible from CNTP_TVAL/CNTV_TVAL continues
      --   to count down. Disabling the output signal might be a power-saving
      --   option."
      --
      if HiRTOS_Cpu_Startup_Interface.HiRTOS_Booted_As_Partition then
         Set_CNTV_TVAL (CNTP_TVAL_Value);

         CNTP_CTL_Value := Get_CNTV_CTL;
         CNTP_CTL_Value.ENABLE := Timer_Enabled;
         CNTP_CTL_Value.IMASK := Timer_Interrupt_Not_Masked;
         Set_CNTV_CTL (CNTP_CTL_Value);
      else
         Set_CNTP_TVAL (CNTP_TVAL_Value);

         CNTP_CTL_Value := Get_CNTP_CTL;
         CNTP_CTL_Value.ENABLE := Timer_Enabled;
         CNTP_CTL_Value.IMASK := Timer_Interrupt_Not_Masked;
         Set_CNTP_CTL (CNTP_CTL_Value);
      end if;

      --  Configure generic physical timer interrupt in the GIC:
      Interrupt_Controller.Configure_Internal_Interrupt (
         Internal_Interrupt_Id => Timer_Interrupt_Id,
         Priority => HiRTOS_Cpu_Arch_Interface.Interrupts.Interrupt_Priorities (Timer_Interrupt_Id),
         Cpu_Interrupt_Line => Interrupt_Controller.Cpu_Interrupt_Irq,
         Trigger_Mode => Interrupt_Controller.Interrupt_Level_Sensitive,
         Interrupt_Handler_Entry_Point => Tick_Timer_Interrupt_Handler'Access,
         Interrupt_Handler_Arg => To_Address (Integer_Address (CNTP_TVAL_Value)));

      --  Enable generic timer interrupt in the GIC:
      Interrupt_Controller.Enable_Internal_Interrupt (Timer_Interrupt_Id);
   end Start_Timer;

   procedure Stop_Timer is
      CNTP_CTL_Value : CNTP_CTL_Type;
   begin
      if HiRTOS_Cpu_Startup_Interface.HiRTOS_Booted_As_Partition then
         --  Disable generic timer interrupt in the GIC:
         Interrupt_Controller.Disable_Internal_Interrupt (
            HiRTOS_Cpu_Arch_Interface.Interrupts.Generic_Virtual_Timer_Interrupt_Id);

         --  Disable tick timer interrupt in the generic timer peipheral:
         CNTP_CTL_Value := Get_CNTV_CTL;
         CNTP_CTL_Value.ENABLE := Timer_Disabled;
         CNTP_CTL_Value.IMASK := Timer_Interrupt_Masked;
         Set_CNTV_CTL (CNTP_CTL_Value);
      else
         --  Disable generic timer interrupt in the GIC:
         Interrupt_Controller.Disable_Internal_Interrupt (
            HiRTOS_Cpu_Arch_Interface.Interrupts.Generic_Physical_Timer_Interrupt_Id);

         --  Disable tick timer interrupt in the generic timer peipheral:
         CNTP_CTL_Value := Get_CNTP_CTL;
         CNTP_CTL_Value.ENABLE := Timer_Disabled;
         CNTP_CTL_Value.IMASK := Timer_Interrupt_Masked;
         Set_CNTP_CTL (CNTP_CTL_Value);
      end if;
   end Stop_Timer;

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

   procedure Tick_Timer_Interrupt_Handler (Arg : System.Address)
   is
      use System.Storage_Elements;
      use type Interfaces.Unsigned_32;
      Timer_Period_Cycles : constant CNTP_TVAL_Type := CNTP_TVAL_Type (To_Integer (Arg));
      Current_Time_Stamp : constant Timer_Timestamp_Cycles_Type := Get_Timer_Timestamp_Cycles;
      Expected_Period_Time_Stamp : constant Timer_Timestamp_Cycles_Type :=
         Tick_Timer_Stats.Last_Period_Time_Stamp + Timer_Timestamp_Cycles_Type (Timer_Period_Cycles);
      Time_Delta_Cycles : constant Timer_Timestamp_Cycles_Type :=
         Current_Time_Stamp - Expected_Period_Time_Stamp;
   begin
      declare
         Timer_Period_Drift_Cycles : constant CNTP_TVAL_Type :=
            (if Time_Delta_Cycles <= Timer_Timestamp_Cycles_Type (Interfaces.Unsigned_32'Last) then
               CNTP_TVAL_Type (Time_Delta_Cycles)
             else
               Timer_Period_Cycles);
      begin
         --
         --  NOTE: Setting CNTP_TVAL/CNTV_TVAL here serves two purposes:
         --  - Clear the timer interrupt at the timer peripheral
         --  - Set the timer to fire for the next tick
         --
         if Timer_Period_Drift_Cycles = 0 then
            Tick_Timer_Stats.Last_Period_Time_Stamp := Expected_Period_Time_Stamp;
            if HiRTOS_Cpu_Startup_Interface.HiRTOS_Booted_As_Partition then
               Set_CNTV_TVAL (Timer_Period_Cycles);
            else
               Set_CNTP_TVAL (Timer_Period_Cycles);
            end if;
         elsif Timer_Period_Drift_Cycles < Timer_Period_Cycles then
            Tick_Timer_Stats.Timer_Interrupt_Small_Drift_Count := @ + 1;
            Tick_Timer_Stats.Last_Period_Time_Stamp := Expected_Period_Time_Stamp;
            if HiRTOS_Cpu_Startup_Interface.HiRTOS_Booted_As_Partition then
               Set_CNTV_TVAL (Timer_Period_Cycles - Timer_Period_Drift_Cycles);
            else
               Set_CNTP_TVAL (Timer_Period_Cycles - Timer_Period_Drift_Cycles);
            end if;
         else
            Tick_Timer_Stats.Timer_Interrupt_Big_Drift_Count := @ + 1;
            Tick_Timer_Stats.Last_Period_Time_Stamp := Current_Time_Stamp;
            if HiRTOS_Cpu_Startup_Interface.HiRTOS_Booted_As_Partition then
               Set_CNTV_TVAL (Timer_Period_Cycles);
            else
               Set_CNTP_TVAL (Timer_Period_Cycles);
            end if;
         end if;
      end;

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

   function Get_CNTV_CTL return CNTV_CTL_Type is
      CNTV_CTL_Value : CNTV_CTL_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c14, c3, 1",
         Outputs => CNTV_CTL_Type'Asm_Output ("=r", CNTV_CTL_Value), --  %0
         Volatile => True);

      return CNTV_CTL_Value;
   end Get_CNTV_CTL;

   procedure Set_CNTV_CTL (CNTV_CTL_Value : CNTV_CTL_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c14, c3, 1",
         Inputs => CNTV_CTL_Type'Asm_Input ("r", CNTV_CTL_Value), --  %0
         Volatile => True);
   end Set_CNTV_CTL;

   function Get_CNTV_TVAL return CNTV_TVAL_Type is
      CNTV_TVAL_Value : CNTV_TVAL_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c14, c3, 0",
         Outputs => CNTV_TVAL_Type'Asm_Output ("=r", CNTV_TVAL_Value), --  %0
         Volatile => True);

      return CNTV_TVAL_Value;
   end Get_CNTV_TVAL;

   procedure Set_CNTV_TVAL (CNTV_TVAL_Value : CNTV_TVAL_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c14, c3, 0",
         Inputs => CNTV_TVAL_Type'Asm_Input ("r", CNTV_TVAL_Value), --  %0
         Volatile => True);
   end Set_CNTV_TVAL;

   function Get_CNTVCT return CNTVCT_Type is
      CNTVCT_Value : CNTVCT_Type;
   begin
      --  NOTE: Use "=&r" to ensure a different register is used
      System.Machine_Code.Asm (
         "mrrc p15, 1, %0, %1, c14",
         Outputs => [Interfaces.Unsigned_32'Asm_Output ("=r", CNTVCT_Value.Low_Word),    --  %0
                     Interfaces.Unsigned_32'Asm_Output ("=&r", CNTVCT_Value.High_Word)], --  %1
         Volatile => True);

      return CNTVCT_Value;
   end Get_CNTVCT;

end HiRTOS_Cpu_Arch_Interface.Tick_Timer;
