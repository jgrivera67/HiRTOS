--
--  Copyright (c) 2024, German Rivera
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
with System.Storage_Elements;

package body HiRTOS_Cpu_Arch_Interface.Tick_Timer with SPARK_Mode => On is

   type Tick_Timer_Stats_Type is limited record
      Last_Period_Time_Stamp : Timer_Timestamp_Cycles_Type;
   end record;

   procedure Tick_Timer_Interrupt_Handler (Arg : System.Address)
      with Pre => Cpu_In_Privileged_Mode;

   Tick_Timer_Stats : Tick_Timer_Stats_Type;

   procedure Initialize is
   begin
      -- TODO
      null;
   end Initialize;

   function Get_Timer_Timestamp_Cycles return Timer_Timestamp_Cycles_Type is
   begin
      return  0; --TODO
   end Get_Timer_Timestamp_Cycles;

   procedure Start_Timer (Expiration_Time_Us : HiRTOS.Relative_Time_Us_Type) is
      use System.Storage_Elements;
      Timer_Interrupt_Id : constant
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Interrupt_Id_Type :=
         HiRTOS_Cpu_Arch_Interface.Interrupts.System_Timer_Interrupt_Id;
   begin
      Tick_Timer_Stats.Last_Period_Time_Stamp := Get_Timer_Timestamp_Cycles;

      --
      --  Enable tick timer interrupt in the timer peipheral:
      --

      --  Configure timer interrupt in the interrupt controller:
      Interrupt_Controller.Configure_Interrupt (
         Interrupt_Id => Timer_Interrupt_Id,
         Priority => HiRTOS_Cpu_Arch_Interface.Interrupts.Interrupt_Priorities (Timer_Interrupt_Id),
         Trigger_Mode => Interrupt_Controller.Interrupt_Level_Sensitive,
         Interrupt_Handler_Entry_Point => Tick_Timer_Interrupt_Handler'Access,
         Interrupt_Handler_Arg => System.Null_Address); --TODO

      --  Enable timer interrupt in the interrupt controller:
      Interrupt_Controller.Enable_Interrupt (Timer_Interrupt_Id);
   end Start_Timer;

   procedure Stop_Timer is
   begin
      --  Disable timer interrupt in the interrupt controller:
      Interrupt_Controller.Disable_Interrupt (
         HiRTOS_Cpu_Arch_Interface.Interrupts.System_Timer_Interrupt_Id);

      --  Disable tick timer interrupt in the timer peipheral:
   end Stop_Timer;

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

   procedure Tick_Timer_Interrupt_Handler (Arg : System.Address)
   is
   begin
      --
      --  Clear the timer interrupt at the timer peripheral
      --  Set the timer to fire for the next tick
      --

      --TODO

      HiRTOS.Interrupt_Handling.RTOS_Tick_Timer_Interrupt_Handler;
   end Tick_Timer_Interrupt_Handler;

end HiRTOS_Cpu_Arch_Interface.Tick_Timer;
