--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.RTOS_Private;
with HiRTOS.Thread;
with HiRTOS.Thread_Private;
with HiRTOS.Timer_Private;
with HiRTOS.Memory_Protection_Private;
with HiRTOS.Interrupt_Handling_Private;
with HiRTOS.Memory_Protection;
with HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
with HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
with HiRTOS_Cpu_Arch_Interface.Thread_Context;
with HiRTOS_Cpu_Arch_Interface.Tick_Timer;
with HiRTOS_Cpu_Multi_Core_Interface;
with HiRTOS_Cpu_Startup_Interface;
with System.Storage_Elements;

--
--  @summary HiRTOS implementation
--
package body HiRTOS with
  SPARK_Mode => On
is
   use HiRTOS.RTOS_Private;
   use HiRTOS.Thread_Private;
   use HiRTOS_Cpu_Multi_Core_Interface;
   use HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
   use type System.Address;

   Idle_Thread_Stack : Small_Thread_Stack_Package.Execution_Stack_Type with
      Linker_Section => ".thread_stacks",
      Convention => C;

   Timer_Thread_Stack : Medium_Thread_Stack_Package.Execution_Stack_Type with
      Linker_Section => ".thread_stacks",
      Convention => C;

   procedure Idle_Thread_Proc (Arg : System.Address) with
     Convention => C,
     No_Return;

   procedure Initialize_HiRTOS_Lib with SPARK_Mode => Off
   is
      --  Compiler-generated Ada elaboration code:
      procedure HiRTOSinit with
         Import,
         Convention => C,
         External_Name => "HiRTOSinit";

   begin
      if Get_Cpu_Id = Valid_Cpu_Core_Id_Type'First then
         HiRTOSinit;
         HiRTOS_Cpu_Startup_Interface.HiRTOS_Global_Variables_Elaborated_Flag := True;
         HiRTOS_Cpu_Arch_Interface.Send_Multicore_Event;
      else
         while not HiRTOS_Cpu_Startup_Interface.HiRTOS_Global_Variables_Elaborated_Flag loop
            HiRTOS_Cpu_Arch_Interface.Wait_For_Multicore_Event;
         end loop;
      end if;

      Initialize_RTOS;
   end Initialize_HiRTOS_Lib;

   procedure Initialize_RTOS with
   SPARK_Mode => Off
   is
      use type System.Storage_Elements.Integer_Address;
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      ISR_Stack_Info : constant ISR_Stack_Info_Type :=
         Get_ISR_Stack_Info (Cpu_Id);
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
      HiRTOS_Obj.RTOS_Cpu_Instances (Cpu_Id);
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
   begin
      HiRTOS.Memory_Protection_Private.Initialize;
      HiRTOS.Interrupt_Handling_Private.Initialize;
      HiRTOS_Cpu_Arch_Interface.Tick_Timer.Initialize;

      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access
        (RTOS_Cpu_Instance'Address, RTOS_Cpu_Instance'Size, Old_Data_Range);
      RTOS_Cpu_Instance.Interrupt_Stack_Base_Address := ISR_Stack_Info.Base_Address;
      RTOS_Cpu_Instance.Interrupt_Stack_End_Address := System.Storage_Elements.To_Address (
         System.Storage_Elements.To_Integer (ISR_Stack_Info.Base_Address) + ISR_Stack_Info.Size_In_Bytes);
      RTOS_Cpu_Instance.Cpu_Id := Cpu_Id;

      Per_Cpu_Thread_List_Package.List_Init (RTOS_Cpu_Instance.All_Threads, Cpu_Id);
      Per_Cpu_Mutex_List_Package.List_Init (RTOS_Cpu_Instance.All_Mutexes, Cpu_Id);
      Per_Cpu_Condvar_List_Package.List_Init (RTOS_Cpu_Instance.All_Condvars, Cpu_Id);
      Per_Cpu_Timer_List_Package.List_Init (RTOS_Cpu_Instance.All_Timers, Cpu_Id);

      HiRTOS.Interrupt_Handling_Private.Initialize_Interrupt_Nesting_Level_Stack
      (RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack);
      HiRTOS.Initialize_Thread_Priority_Queue (RTOS_Cpu_Instance.Runnable_Threads_Queue);
      HiRTOS.Timer_Private.Initialize_Timer_Wheel (RTOS_Cpu_Instance.Timer_Wheel);

      HiRTOS.Thread.Create_Thread
      (Idle_Thread_Proc'Access,
         System.Null_Address,
         Lowest_Thread_Priority,
         Idle_Thread_Stack'Address,
         Idle_Thread_Stack'Size / System.Storage_Unit,
         RTOS_Cpu_Instance.Idle_Thread_Id);

      HiRTOS.Thread.Create_Thread
      (HiRTOS.Timer_Private.Timer_Thread_Proc'Access,
         System.Null_Address,
         Highest_Thread_Priority,
         Timer_Thread_Stack'Address,
         Timer_Thread_Stack'Size / System.Storage_Unit,
         RTOS_Cpu_Instance.Tick_Timer_Thread_Id);

      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
   end Initialize_RTOS;

   procedure Initialize_Thread_Priority_Queue (Thread_Priority_Queue : out Thread_Priority_Queue_Type)
   is
   begin
      for I in Thread_Priority_Queue.Thread_Queues_Array'Range loop
         Thread_Queue_Package.List_Init (Thread_Priority_Queue.Thread_Queues_Array (I), I);
      end loop;

      Thread_Priority_Queue.Non_Empty_Thread_Queues_Map := [ others => False ];
   end Initialize_Thread_Priority_Queue;

   procedure Thread_Priority_Queue_Remove_Head (Thread_Priority_Queue : in out Thread_Priority_Queue_Type;
                                                Thread_Id : out Valid_Thread_Id_Type) is
      use type HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
      Non_Empty_Thread_Queues_Map_Value : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type with
         Import, Address => Thread_Priority_Queue.Non_Empty_Thread_Queues_Map'Address;
      Leading_Zeros : constant HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type :=
         HiRTOS_Cpu_Arch_Interface.Count_Leading_Zeros (Non_Empty_Thread_Queues_Map_Value);
      Highest_Thread_Prioritiy : Valid_Thread_Priority_Type;
   begin
      pragma Assert (Non_Empty_Thread_Queues_Map_Value /= 0);
      pragma Assert (Leading_Zeros in 0 .. HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type'Size - 1);
      Highest_Thread_Prioritiy :=
         Valid_Thread_Priority_Type (HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type'Size - Leading_Zeros - 1);

      Thread_Queue_Package.List_Remove_Head (Thread_Priority_Queue.Thread_Queues_Array (Highest_Thread_Prioritiy),
                                             Thread_Id);
      if Thread_Queue_Package.List_Is_Empty (Thread_Priority_Queue.Thread_Queues_Array (Highest_Thread_Prioritiy)) then
         Thread_Priority_Queue.Non_Empty_Thread_Queues_Map (Highest_Thread_Prioritiy) := False;
      end if;
   end Thread_Priority_Queue_Remove_Head;

   procedure Thread_Priority_Queue_Remove_This (Thread_Priority_Queue : in out Thread_Priority_Queue_Type;
                                                Thread_Id : Valid_Thread_Id_Type) is
      Thread_Obj : Thread_Type renames HiRTOS_Obj.Thread_Instances (Thread_Id);
   begin
      Thread_Queue_Package.List_Remove_This (Thread_Priority_Queue.Thread_Queues_Array (Thread_Obj.Current_Priority),
                                             Thread_Id);
      if Thread_Queue_Package.List_Is_Empty (Thread_Priority_Queue.Thread_Queues_Array (Thread_Obj.Current_Priority))
      then
         Thread_Priority_Queue.Non_Empty_Thread_Queues_Map (Thread_Obj.Current_Priority) := False;
      end if;
   end Thread_Priority_Queue_Remove_This;

   procedure Thread_Priority_Queue_Add (Thread_Priority_Queue : in out Thread_Priority_Queue_Type;
                                        Thread_Id : Valid_Thread_Id_Type;
                                        Priority : Valid_Thread_Priority_Type;
                                        First_In_Queue : Boolean := False)
   is
      Per_Priority_Thread_Queue : Thread_Queue_Package.List_Anchor_Type renames
         Thread_Priority_Queue.Thread_Queues_Array (Priority);
   begin
      if First_In_Queue then
         Thread_Queue_Package.List_Add_Head (Per_Priority_Thread_Queue, Thread_Id);
      else
         Thread_Queue_Package.List_Add_Tail (Per_Priority_Thread_Queue, Thread_Id);
      end if;

      Thread_Priority_Queue.Non_Empty_Thread_Queues_Map (Priority) := True;
   end Thread_Priority_Queue_Add;

   function Thread_Priority_Queue_Is_Empty (Thread_Priority_Queue : Thread_Priority_Queue_Type)
      return Boolean
   is
      use type HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
      Non_Empty_Thread_Queues_Map_Value : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type with
         Import, Address => Thread_Priority_Queue.Non_Empty_Thread_Queues_Map'Address;
   begin
      return (Non_Empty_Thread_Queues_Map_Value = 0);
   end Thread_Priority_Queue_Is_Empty;

   procedure Start_Thread_Scheduler is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
   begin
      pragma Assert (RTOS_Cpu_Instance.Thread_Scheduler_State = Thread_Scheduler_Stopped);
      pragma Assert (RTOS_Cpu_Instance.Current_Thread_Id = Invalid_Thread_Id);
      pragma Assert (RTOS_Cpu_Instance.Current_Atomic_Level = Atomic_Level_None);
      pragma Assert (RTOS_Cpu_Instance.Current_Cpu_Execution_Mode = Cpu_Executing_Reset_Handler);

      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access
        (RTOS_Cpu_Instance'Address, RTOS_Cpu_Instance'Size, Old_Data_Range);
      RTOS_Cpu_Instance.Thread_Scheduler_State := Thread_Scheduler_Running;

      HiRTOS_Cpu_Arch_Interface.Tick_Timer.Start_Timer (HiRTOS_Config_Parameters.Tick_Timer_Period_Us);
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);

      HiRTOS_Cpu_Arch_Interface.Thread_Context.First_Thread_Context_Switch;

      --
      --  We should not come here
      --
      pragma Assert (False);

   end Start_Thread_Scheduler;

   function Thread_Scheduler_Started return Boolean is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
   begin
      return RTOS_Cpu_Instance.Current_Thread_Id /= Invalid_Thread_Id;
   end Thread_Scheduler_Started;

   function Current_Execution_Context_Is_Interrupt return Boolean is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
   begin
      return
        Interrupt_Handling_Private.Get_Current_Interrupt_Nesting_Counter
          (RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack) /= 0;
   end Current_Execution_Context_Is_Interrupt;

   procedure Enter_Cpu_Privileged_Mode is
   begin
      if not HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode then
         HiRTOS_Cpu_Arch_Interface.Switch_Cpu_To_Privileged_Mode;
      else
         if Current_Execution_Context_Is_Interrupt then
            --
            --  If we are in interrupt context, we don't need to increment the
            --  privileged nesting counter.
            --
            return;
         end if;
      end if;

      pragma Assert (HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode);

      declare
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
         Current_Thread_Id : constant Thread_Id_Type := RTOS_Cpu_Instance.Current_Thread_Id;
         Current_Thread_Obj : Thread_Type renames HiRTOS_Obj.Thread_Instances (Current_Thread_Id);
      begin
         Thread_Private.Increment_Privilege_Nesting (Current_Thread_Obj);
      end;
   end Enter_Cpu_Privileged_Mode;

   procedure Exit_Cpu_Privileged_Mode is
   begin
      --
      --  If we are in interrupt context, we don't need to do anything,
      --  as ISRs and the reset handler always run in provileged mode.
      --
      if Current_Execution_Context_Is_Interrupt then
         return;
      end if;

      declare
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
           HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
         Current_Thread_Id :
           Thread_Id_Type renames RTOS_Cpu_Instance.Current_Thread_Id;
         Current_Thread_Obj :
           Thread_Type renames HiRTOS_Obj.Thread_Instances (Current_Thread_Id);
      begin
         Thread_Private.Decrement_Privilege_Nesting (Current_Thread_Obj);
         if Thread_Private.Get_Privilege_Nesting (Current_Thread_Obj) = 0 then
            HiRTOS_Cpu_Arch_Interface.Switch_Cpu_To_Unprivileged_Mode;
            pragma Assert (not HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode);
         else
            pragma Assert (HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode);
         end if;
      end;
   end Exit_Cpu_Privileged_Mode;

   function Running_In_Privileged_Mode return Boolean renames
     HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode;

   procedure Idle_Thread_Proc (Arg : System.Address) is
   begin
      pragma Assert (Arg = System.Null_Address);
      HiRTOS.Enter_Cpu_Privileged_Mode;

      loop
         HiRTOS_Cpu_Arch_Interface.Wait_For_Interrupt;
      end loop;
   end Idle_Thread_Proc;

   function Raise_Atomic_Level (New_Atomic_Level : Atomic_Level_Type) return Atomic_Level_Type
   is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Old_Atomic_Level : constant Atomic_Level_Type :=
         RTOS_Cpu_Instance.Current_Atomic_Level;
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      if New_Atomic_Level = Old_Atomic_Level then
         return Old_Atomic_Level;
      end if;

      --  Begin critical section
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      if New_Atomic_Level = Atomic_Level_Single_Thread then
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Set_Highest_Interrupt_Priority_Disabled (
            HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Interrupt_Priority_Type'Last);
      elsif New_Atomic_Level = Atomic_Level_No_Interrupts then
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Set_Highest_Interrupt_Priority_Disabled (
            HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Interrupt_Priority_Type'First);
      else
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Set_Highest_Interrupt_Priority_Disabled (
            HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Interrupt_Priority_Type (New_Atomic_Level));
      end if;

      RTOS_Cpu_Instance.Current_Atomic_Level := New_Atomic_Level;

      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
      return Old_Atomic_Level;
   end Raise_Atomic_Level;

   procedure Restore_Atomic_Level (Old_Atomic_Level : Atomic_Level_Type) is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      if Old_Atomic_Level = Get_Current_Atomic_Level then
         return;
      end if;

      --  Begin critical section
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      RTOS_Cpu_Instance.Current_Atomic_Level := Old_Atomic_Level;
      if Old_Atomic_Level = Atomic_Level_None or else
         Old_Atomic_Level = Atomic_Level_Single_Thread
      then
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Set_Highest_Interrupt_Priority_Disabled (
            HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Interrupt_Priority_Type'Last);
      elsif Old_Atomic_Level = Atomic_Level_No_Interrupts then
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Set_Highest_Interrupt_Priority_Disabled (
            HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Interrupt_Priority_Type'First);
      else
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Set_Highest_Interrupt_Priority_Disabled (
            HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Interrupt_Priority_Type (Old_Atomic_Level));
      end if;

      if not Current_Execution_Context_Is_Interrupt and then
         Old_Atomic_Level = Atomic_Level_None
      then
         --
         --  Trigger synchronous context switch to run the thread scheduler
         --
         HiRTOS_Cpu_Arch_Interface.Thread_Context.Synchronous_Thread_Context_Switch;
      end if;

      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
   end Restore_Atomic_Level;

   function Get_Current_Atomic_Level return Atomic_Level_Type is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
   begin
      return RTOS_Cpu_Instance.Current_Atomic_Level;
   end Get_Current_Atomic_Level;

   function Get_Current_Time_Us return Time_Us_Type is
      Current_Time_Us : Time_Us_Type;
   begin
      Enter_Cpu_Privileged_Mode;
      declare
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
            HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      begin
         Current_Time_Us := Time_Us_Type (RTOS_Cpu_Instance.Timer_Ticks_Since_Boot) *
                            HiRTOS_Config_Parameters.Tick_Timer_Period_Us;
      end;

      Exit_Cpu_Privileged_Mode;
      return Current_Time_Us;

   end Get_Current_Time_Us;
end HiRTOS;
