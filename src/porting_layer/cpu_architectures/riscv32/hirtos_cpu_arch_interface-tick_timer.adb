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
with HiRTOS_Platform_Interface;

package body HiRTOS_Cpu_Arch_Interface.Tick_Timer with SPARK_Mode => On is

   Tick_Timer_Counter_Id : constant HiRTOS_Platform_Interface.System_Timer_Counter_Type :=
      HiRTOS_Platform_Interface.System_Timer_Counter1;

   Tick_Timer_Interrupt_Id : constant
      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Interrupt_Id_Type :=
      (case Tick_Timer_Counter_Id is
         when HiRTOS_Platform_Interface.System_Timer_Counter0 =>
            HiRTOS_Cpu_Arch_Interface.Interrupts.System_Timer_Target0_Interrupt_Id,
         when HiRTOS_Platform_Interface.System_Timer_Counter1 =>
            HiRTOS_Cpu_Arch_Interface.Interrupts.System_Timer_Target1_Interrupt_Id);

   type Tick_Timer_Stats_Type is limited record
      Last_Period_Time_Stamp : Timer_Timestamp_Cycles_Type := 0;
      Interrupts_Count : Integer_Address := 0;
      Initialized : Boolean := False;
   end record;

   procedure Tick_Timer_Interrupt_Handler (Arg : System.Address)
      with Pre => Cpu_In_Privileged_Mode;

   Tick_Timer_Stats : Tick_Timer_Stats_Type;

   procedure Initialize is
   begin
      pragma Assert (not Tick_Timer_Stats.Initialized);
      HiRTOS_Platform_Interface.Initialize_System_Timer (Tick_Timer_Counter_Id);
      Tick_Timer_Stats.Initialized := True;
   end Initialize;

   function Get_Timer_Timestamp_Cycles return Timer_Timestamp_Cycles_Type is
   begin
      return  HiRTOS_Platform_Interface.Get_System_Timer_Timestamp_Cycles (Tick_Timer_Counter_Id);
   end Get_Timer_Timestamp_Cycles;

   procedure Start_Timer (Expiration_Time_Us : HiRTOS.Relative_Time_Us_Type) is
      Old_Cpu_Interrupting_State : Cpu_Register_Type;
   begin
      pragma Assert (Tick_Timer_Stats.Initialized);

      --  Begin critical section
      Old_Cpu_Interrupting_State := Disable_Cpu_Interrupting;

      Tick_Timer_Stats.Last_Period_Time_Stamp :=
         HiRTOS_Platform_Interface.Get_System_Timer_Timestamp_Cycles (Tick_Timer_Counter_Id);

      --  Configure timer interrupt in the interrupt controller:
      Interrupt_Controller.Configure_Interrupt (
         Interrupt_Id => Tick_Timer_Interrupt_Id,
         Priority => HiRTOS_Cpu_Arch_Interface.Interrupts.Interrupt_Priorities (Tick_Timer_Interrupt_Id),
         Trigger_Mode => Interrupt_Controller.Interrupt_Level_Sensitive,
         Interrupt_Handler_Entry_Point => Tick_Timer_Interrupt_Handler'Access,
         Interrupt_Handler_Arg => To_Address (Integer_Address (Expiration_Time_Us)));

      HiRTOS_Platform_Interface.Clear_System_Timer_Interrupt (Tick_Timer_Counter_Id);

      --
      --  Start generation of tick timer interrupt:
      --
      HiRTOS_Platform_Interface.Start_System_Timer_Periodic_Interrupt (Tick_Timer_Counter_Id, Expiration_Time_Us);

      --  Enable timer interrupt in the interrupt controller:
      Interrupt_Controller.Enable_Interrupt (Tick_Timer_Interrupt_Id);

      --  End critical section
      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);
   end Start_Timer;

   procedure Stop_Timer is
      Old_Cpu_Interrupting_State : Cpu_Register_Type;
   begin
      --  Begin critical section
      Old_Cpu_Interrupting_State := Disable_Cpu_Interrupting;

      --  Disable tick timer interrupt in the timer peipheral:
      HiRTOS_Platform_Interface.Stop_System_Timer_Interrupt (Tick_Timer_Counter_Id);

      --  Disable timer interrupt in the interrupt controller:
      Interrupt_Controller.Disable_Interrupt (Tick_Timer_Interrupt_Id);

      --  End critical section
      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);
   end Stop_Timer;

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

   procedure Tick_Timer_Interrupt_Handler (Arg : System.Address)
   is
      use type System.Address;
      Old_Cpu_Interrupting_State : Cpu_Register_Type;
      Expiration_Time_Us : constant HiRTOS.Relative_Time_Us_Type :=
         HiRTOS.Relative_Time_Us_Type (To_Integer (Arg)) with Unreferenced;
   begin
      Tick_Timer_Stats.Last_Period_Time_Stamp :=
         HiRTOS_Platform_Interface.Get_System_Timer_Timestamp_Cycles (Tick_Timer_Counter_Id);
      Tick_Timer_Stats.Interrupts_Count := @ + 1;

      --  Begin critical section
      Old_Cpu_Interrupting_State := Disable_Cpu_Interrupting;

      --
      --  Clear the timer interrupt at the timer peripheral:
      --
      HiRTOS_Platform_Interface.Clear_System_Timer_Interrupt (Tick_Timer_Counter_Id);

      --  End critical section
      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);

      HiRTOS.Interrupt_Handling.RTOS_Tick_Timer_Interrupt_Handler;
   end Tick_Timer_Interrupt_Handler;

end HiRTOS_Cpu_Arch_Interface.Tick_Timer;
