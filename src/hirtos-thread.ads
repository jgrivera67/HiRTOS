--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS.Memory_Protection;
with System.Storage_Elements;

package HiRTOS.Thread
   with SPARK_Mode => On
is
   use type System.Storage_Elements.Integer_Address;

   --
   --  NOTE: Lower value means higher priority
   --
   Lowest_Thread_Prioritiy :
      constant Thread_Priority_Type := Thread_Priority_Type'Last;

   Highest_Thread_Prioritiy :
      constant Thread_Priority_Type := Thread_Priority_Type'First;

   type Thread_Entry_Point_Type is access procedure (Arg : System.Address)
          with Convention => C;

   --
   --  Create new thread
   --
   procedure Create_Thread (Entry_Point : Thread_Entry_Point_Type;
                            Thread_Arg : System.Address;
                            Priority : Valid_Thread_Priority_Type;
                            Stack_Base_Address : System.Address;
                            Stack_Size_In_Bytes :  System.Storage_Elements.Integer_Address;
                            Thread_Id : out Valid_Thread_Id_Type)
      with Pre => HiRTOS.Memory_Protection.Valid_Code_Address (Entry_Point.all'Address) and then
                  HiRTOS.Memory_Protection.Valid_Stack_Address (Stack_Base_Address) and then
                  Stack_Size_In_Bytes /= 0 and then
                  Stack_Size_In_Bytes mod
                     (HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type'Size / System.Storage_Unit) = 0,
           Export,
           Convention => C,
           External_Name => "hirtos_create_thread",
           --  NOTE: gnatprove crashes when parsing Entry_Point.all'Address
           SPARK_Mode => Off;

   --
   --  Return the Id of the current thread executing on the current CPU core,
   --  if that core is running in thread context, or the Id of the last thread
   --  prempted by an interrupt handler, if running in interrupt context.
   --
   function Get_Current_Thread_Id return Thread_Id_Type
      with Export,
           Convention => C,
           External_Name => "hirtos_get_current_thread_id";

   --
   --  Return the priority of the current thread executing on the current CPU core,
   --  if that core is running in thread context, or the priority of the last thread
   --  prempted by an interrupt handler, if running in interrupt context.
   --
   function Get_Current_Thread_Priority return Thread_Priority_Type
      with Export,
           Convention => C,
           External_Name => "hirtos_get_current_thread_priority";

   --
   --  Put the calling thread to sleep until the current time matches
   --  the specified wakeup time.
   --
   function Thread_Delay_Until (Wakeup_Time_Us : Absolute_Time_Us_Type) return Absolute_Time_Us_Type
      with Pre => Wakeup_Time_Us mod HiRTOS_Config_Parameters.Tick_Timer_Period_Us = 0,
           Export,
           Convention => C,
           External_Name => "hirtos_thread_delay_until";

   --
   --  Suspend Calling Thread
   --
   procedure Suspend_Current_Thread
      with Export,
           Convention => C,
           External_Name => "hirtos_suspend_current_thread";

   --
   --  Resume a suspended Thread
   --
   procedure Resume_Thread (Suspended_Thread_Id : Valid_Thread_Id_Type)
      with Export,
           Convention => C,
           External_Name => "hirtos_resume_thread";

end HiRTOS.Thread;
