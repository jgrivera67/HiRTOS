--
--  Copyright (c) 2024, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  Platform interface
--

with HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
with HiRTOS_Cpu_Arch_Interface.Tick_Timer;
with HiRTOS;

package HiRTOS_Platform_Interface
   with SPARK_Mode => On
is
   use HiRTOS_Cpu_Arch_Interface;
   use HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
   use HiRTOS_Cpu_Arch_Interface.Tick_Timer;
   use type HiRTOS.Relative_Time_Us_Type;

   procedure Initialize_Platform with
      Pre => Cpu_In_Privileged_Mode;

   procedure Initialize_Interrupt_Controller with
      Pre => Cpu_In_Privileged_Mode;

   procedure Configure_Access_Violation_Interrupts with
      Pre => Cpu_In_Privileged_Mode;

   procedure Configure_Interrupt
     (Interrupt_Id                  : Valid_Interrupt_Id_Type;
      Priority                      : Interrupt_Priority_Type;
      Trigger_Mode                  : Interrupt_Trigger_Mode_Type) with
      Pre => Cpu_In_Privileged_Mode  and then
             Cpu_Interrupting_Disabled;

   procedure Enable_Interrupt (Interrupt_Id : Valid_Interrupt_Id_Type) with
      Pre => Cpu_In_Privileged_Mode and then
             Cpu_Interrupting_Disabled;

   procedure Disable_Interrupt (Interrupt_Id : Valid_Interrupt_Id_Type) with
      Pre => Cpu_In_Privileged_Mode  and then
             Cpu_Interrupting_Disabled;

   function Begin_Interrupt_Processing (Interrupt_Id : Valid_Interrupt_Id_Type;
                                        Interrupt_Priority : Interrupt_Priority_Type)
      return Interrupt_Priority_Type with
      Pre => Cpu_In_Privileged_Mode and then
             Cpu_Interrupting_Disabled;

   procedure End_Interrupt_Processing (Interrupt_Id : Valid_Interrupt_Id_Type;
                                       Old_Highest_Interrupt_Priority_Disabled : Interrupt_Priority_Type) with
      Pre => Cpu_In_Privileged_Mode and then
             Cpu_Interrupting_Disabled;

   function Get_Highest_Interrupt_Priority_Disabled return Interrupt_Priority_Type
      with Pre => Cpu_In_Privileged_Mode;

   procedure Set_Highest_Interrupt_Priority_Disabled (Priority : Interrupt_Priority_Type)
      with Pre => Cpu_In_Privileged_Mode and then
             Cpu_Interrupting_Disabled;

   function Is_Interrupt_Pending (Interrupt_Id : Valid_Interrupt_Id_Type) return Boolean
      with Pre => Cpu_In_Privileged_Mode;

   function Get_Interrupt_Priority (Interrupt_Id : Valid_Interrupt_Id_Type)
      return Interrupt_Priority_Type
      with Pre => Cpu_In_Privileged_Mode;

   type System_Timer_Counter_Type is (System_Timer_Counter0, System_Timer_Counter1);

   procedure Initialize_System_Timer (System_Timer_Counter : System_Timer_Counter_Type) with
      Pre => Cpu_In_Privileged_Mode;

   function Get_System_Timer_Timestamp_Cycles (System_Timer_Counter : System_Timer_Counter_Type)
      return Timer_Timestamp_Cycles_Type with
      Pre => Cpu_In_Privileged_Mode;

   procedure Start_System_Timer_Single_Shot_Interrupt (System_Timer_Counter : System_Timer_Counter_Type;
                                                       Expiration_Time_Us : HiRTOS.Relative_Time_Us_Type) with
      Pre => Cpu_In_Privileged_Mode and then
             Expiration_Time_Us /= 0 and then
             Cpu_Interrupting_Disabled;

   procedure Start_System_Timer_Periodic_Interrupt (System_Timer_Counter : System_Timer_Counter_Type;
                                                    Expiration_Time_Us : HiRTOS.Relative_Time_Us_Type) with
      Pre => Cpu_In_Privileged_Mode and then
             Expiration_Time_Us /= 0 and then
             Cpu_Interrupting_Disabled;

   procedure Stop_System_Timer_Interrupt (System_Timer_Counter : System_Timer_Counter_Type) with
      Pre => Cpu_In_Privileged_Mode and then
             Cpu_Interrupting_Disabled;

   procedure Clear_System_Timer_Interrupt (System_Timer_Counter : System_Timer_Counter_Type) with
      Pre => Cpu_In_Privileged_Mode and then
             Cpu_Interrupting_Disabled;

end HiRTOS_Platform_Interface;
