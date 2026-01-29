--
--  Copyright (c) 2024, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Tick timer driver
--

with HiRTOS_Cpu_Arch_Interface.System_Registers;
with Bit_Sized_Integer_Types;

package body HiRTOS_Cpu_Arch_Interface.Tick_Timer with SPARK_Mode => On is
   use HiRTOS_Cpu_Arch_Interface.System_Registers;
   use Bit_Sized_Integer_Types;

   type Tick_Timer_Stats_Type is limited record
      Interrupts_Count : Integer_Address := 0;
      Initialized : Boolean := False;
   end record;

   Tick_Timer_Stats : Tick_Timer_Stats_Type;

   procedure Initialize is
   begin
      pragma Assert (not Tick_Timer_Stats.Initialized);
      SCS.SysTick.LOAD := (RELOAD => Twenty_Four_Bits_Type'Last, Reserved => 0);
      SCS.SysTick.VAL := (CURRENT => 0, Reserved => 0);
      SCS.SysTick.CTLR := (ENABLE => 1, CLKSOURCE => 1, others => 0);
      Tick_Timer_Stats.Initialized := True;
   end Initialize;

   function Get_Timer_Timestamp_Cycles return Timer_Timestamp_Cycles_Type is
      Interrupts_Count : Integer_Address;
      SysTick_VAL_Value : SysTick_VAL_Type;
      SysTick_LOAD_Value : SysTick_LOAD_Type;
      Timer_Timestamp : Timer_Timestamp_Cycles_Type;
   begin
      pragma Assert (Tick_Timer_Stats.Initialized);
      SysTick_LOAD_Value := SCS.SysTick.LOAD;
      loop
         Interrupts_Count := Tick_Timer_Stats.Interrupts_Count;
         SysTick_VAL_Value := SCS.SysTick.VAL;
         Timer_Timestamp := (Timer_Timestamp_Cycles_Type (Interrupts_Count) *
                               Timer_Timestamp_Cycles_Type (SysTick_LOAD_Value.RELOAD + 1)) +
                            Timer_Timestamp_Cycles_Type (SysTick_LOAD_Value.RELOAD - SysTick_VAL_Value.CURRENT);
         exit when Interrupts_Count = Tick_Timer_Stats.Interrupts_Count;
      end loop;
      return Timer_Timestamp;
   end Get_Timer_Timestamp_Cycles;

   procedure Start_Timer (Expiration_Time_Us : HiRTOS.Relative_Time_Us_Type) is
      SysTick_CTLR_Value : SysTick_CTLR_Type;
      Old_Cpu_Interrupting_State : Cpu_Register_Type;
   begin
      pragma Assert (Tick_Timer_Stats.Initialized);

      --  Begin critical section
      Old_Cpu_Interrupting_State := Disable_Cpu_Interrupting;

      --
      --  Start generation of tick timer interrupt:
      --
      SCS.SysTick.LOAD.RELOAD :=
         Twenty_Four_Bits_Type (Expiration_Time_Us * Timer_Counter_Cycles_Per_Us - 1);
      SysTick_CTLR_Value := SCS.SysTick.CTLR;
      SysTick_CTLR_Value.TICKINT := 1;
      SCS.SysTick.CTLR := SysTick_CTLR_Value;

      --  End critical section
      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);
   end Start_Timer;

   procedure Stop_Timer is
      SysTick_CTLR_Value : SysTick_CTLR_Type;
      Old_Cpu_Interrupting_State : Cpu_Register_Type;
   begin
      --  Begin critical section
      Old_Cpu_Interrupting_State := Disable_Cpu_Interrupting;

      --
      --  Stop generation of tick timer interrupt:
      --
      SCS.SysTick.LOAD.RELOAD := Twenty_Four_Bits_Type'Last;
      SysTick_CTLR_Value := SCS.SysTick.CTLR;
      SysTick_CTLR_Value.TICKINT := 0;
      SCS.SysTick.CTLR := SysTick_CTLR_Value;

      --  End critical section
      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);
   end Stop_Timer;

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

end HiRTOS_Cpu_Arch_Interface.Tick_Timer;
