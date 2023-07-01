--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.Condvar_Private;
with HiRTOS.Mutex_Private;
with HiRTOS.RTOS_Private;
with HiRTOS.Thread_Private;
with HiRTOS.Memory_Protection;
with HiRTOS.Timer;
with HiRTOS_Cpu_Arch_Interface.Thread_Context;
with HiRTOS_Cpu_Multi_Core_Interface;
with System.Storage_Elements;

package body HiRTOS.Condvar is
   use HiRTOS.Condvar_Private;
   use HiRTOS.Mutex_Private;
   use HiRTOS.Thread_Private;
   use HiRTOS.RTOS_Private;
   use HiRTOS_Cpu_Multi_Core_Interface;
   use System.Storage_Elements;

   function Initialized (Condvar_Id : Valid_Condvar_Id_Type) return Boolean
      with Ghost;

   procedure Initialize_Condvar (Condvar_Obj : out Condvar_Type; Condvar_Id : Valid_Condvar_Id_Type);

   procedure Wait_Internal (Condvar_Id : Valid_Condvar_Id_Type; Mutex_Id : Mutex_Id_Type;
                            Timeout_Ms : Time_Ms_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled,
           Post => HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled;

   procedure Wakeup_One_Thread (Condvar_Obj : in out Condvar_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled,
           Post => HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled;

   procedure Wait_Timeout_Callback (Timer_Id : Valid_Timer_Id_Type;
                                    Callback_Arg : Integer_Address)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode,
                  Convention => C;

   -----------------------------------------------------------------------------
   --  Public Subprograms
   -----------------------------------------------------------------------------

   procedure Create_Condvar (Condvar_Id : out Valid_Condvar_Id_Type)
      with Refined_Post => Initialized (Condvar_Id)
   is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
   begin
      RTOS_Private.Allocate_Condvar_Object (Condvar_Id);
      Initialize_Condvar (RTOS_Cpu_Instance.Condvar_Instances (Condvar_Id), Condvar_Id);
   end Create_Condvar;

   procedure Wait (Condvar_Id : Valid_Condvar_Id_Type; Mutex_Id : Valid_Mutex_Id_Type;
                   Timeout_Ms : Time_Ms_Type := Time_Ms_Type'Last) is
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;

      declare
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
            HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
         Current_Thread_Id : constant Thread_Id_Type := RTOS_Cpu_Instance.Current_Thread_Id;
         Current_Thread_Obj : HiRTOS.Thread_Private.Thread_Type renames
            RTOS_Cpu_Instance.Thread_Instances (Current_Thread_Id);
         Current_Atomic_Level : constant Atomic_Level_Type := Get_Current_Atomic_Level;
      begin
         pragma Assert (not HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled and then
                        Current_Atomic_Level = Atomic_Level_None);

         Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
         Current_Thread_Obj.Atomic_Level := Current_Atomic_Level;
         Wait_Internal (Condvar_Id, Mutex_Id, Timeout_Ms);
         HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);

         pragma Assert (Get_Current_Atomic_Level = Current_Atomic_Level);
      end;

      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Wait;

   procedure Wait (Condvar_Id : Valid_Condvar_Id_Type;
                   Timeout_Ms : Time_Ms_Type := Time_Ms_Type'Last) is
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;

      declare
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
            HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
         Current_Thread_Id : constant Thread_Id_Type := RTOS_Cpu_Instance.Current_Thread_Id;
         Current_Thread_Obj : HiRTOS.Thread_Private.Thread_Type renames
            RTOS_Cpu_Instance.Thread_Instances (Current_Thread_Id);
         Current_Atomic_Level : constant Atomic_Level_Type := Get_Current_Atomic_Level;
      begin
         Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
         Current_Thread_Obj.Atomic_Level := Current_Atomic_Level;
         Wait_Internal (Condvar_Id, Invalid_Mutex_Id, Timeout_Ms);
         HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);

         pragma Assert (Get_Current_Atomic_Level = Current_Atomic_Level);
      end;

      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Wait;

   procedure Signal (Condvar_Id : Valid_Condvar_Id_Type) is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Condvar_Obj : Condvar_Type renames RTOS_Cpu_Instance.Condvar_Instances (Condvar_Id);
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
      Thread_Awaken : Boolean := False;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      if not Thread_Priority_Queue_Is_Empty (Condvar_Obj.Waiting_Threads_Queue) then
         Wakeup_One_Thread (Condvar_Obj);
         Thread_Awaken := True;
      end if;

      if not Current_Execution_Context_Is_Interrupt and then Thread_Awaken then
         --
         --  Trigger synchronous context switch to run the thread scheduler
         --
         HiRTOS_Cpu_Arch_Interface.Thread_Context.Synchronous_Thread_Context_Switch;
      end if;

      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Signal;

   procedure Broadcast (Condvar_Id : Valid_Condvar_Id_Type) is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Condvar_Obj : Condvar_Type renames RTOS_Cpu_Instance.Condvar_Instances (Condvar_Id);
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
      Thread_Awaken : Boolean := False;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      while not Thread_Priority_Queue_Is_Empty (Condvar_Obj.Waiting_Threads_Queue) loop
         Wakeup_One_Thread (Condvar_Obj);
         Thread_Awaken := True;
      end loop;

      if not Current_Execution_Context_Is_Interrupt and then Thread_Awaken then
         --
         --  Trigger synchronous context switch to run the thread scheduler
         --
         HiRTOS_Cpu_Arch_Interface.Thread_Context.Synchronous_Thread_Context_Switch;
      end if;

      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Broadcast;

   function Last_Wait_Timed_Out return Boolean
   is
      Thread_Wait_Timed_Out : Boolean := False;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;

      declare
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
            HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
         Current_Thread_Id : constant Thread_Id_Type := RTOS_Cpu_Instance.Current_Thread_Id;
         Current_Thread_Obj : HiRTOS.Thread_Private.Thread_Type renames
            RTOS_Cpu_Instance.Thread_Instances (Current_Thread_Id);
      begin
         Thread_Wait_Timed_Out := Current_Thread_Obj.Last_Condvar_Wait_Timed_Out;
      end;

      HiRTOS.Exit_Cpu_Privileged_Mode;
      return Thread_Wait_Timed_Out;
   end Last_Wait_Timed_Out;

   -----------------------------------------------------------------------------
   --  Private Subprograms
   -----------------------------------------------------------------------------

   function Initialized (Condvar_Id : Valid_Condvar_Id_Type) return Boolean is
      (HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id).Condvar_Instances (Condvar_Id).Initialized);

   procedure Initialize_Condvar (Condvar_Obj : out Condvar_Type; Condvar_Id : Valid_Condvar_Id_Type) is
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
   begin
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access (Condvar_Obj'Address, Condvar_Obj'Size,
                                                              Old_Data_Range);
      Condvar_Obj.Id := Condvar_Id;
      Initialize_Thread_Priority_Queue (Condvar_Obj.Waiting_Threads_Queue);
      Condvar_Obj.Initialized := True;
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
   end Initialize_Condvar;

   procedure Wait_Internal (Condvar_Id : Valid_Condvar_Id_Type; Mutex_Id : Mutex_Id_Type;
                            Timeout_Ms : Time_Ms_Type) is
      use type Interfaces.Unsigned_8;
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Condvar_Obj : Condvar_Type renames RTOS_Cpu_Instance.Condvar_Instances (Condvar_Id);
      Current_Thread_Id : constant Thread_Id_Type := RTOS_Cpu_Instance.Current_Thread_Id;
      Current_Thread_Obj : HiRTOS.Thread_Private.Thread_Type renames
         RTOS_Cpu_Instance.Thread_Instances (Current_Thread_Id);
   begin
      Current_Thread_Obj.Last_Condvar_Wait_Timed_Out := False;
      if Mutex_Id /= Invalid_Mutex_Id then
         declare
            Mutex_Obj : HiRTOS.Mutex_Private.Mutex_Type renames
               RTOS_Cpu_Instance.Mutex_Instances (Mutex_Id);
         begin
            pragma Assert (Mutex_Obj.Recursive_Count = 1);
            Release_Mutex_Internal (Mutex_Obj, Current_Thread_Obj);
         end;
      end if;

      Current_Thread_Obj.Waiting_On_Condvar_Id := Condvar_Id;
      Current_Thread_Obj.State := Thread_Blocked_On_Condvar;
      Thread_Priority_Queue_Add (Condvar_Obj.Waiting_Threads_Queue, Current_Thread_Id,
                                 Current_Thread_Obj.Current_Priority,
                                 First_In_Queue => False);

      if Timeout_Ms /= Time_Ms_Type'Last then
         --
         --  Start timer for the current thread:
         --
         HiRTOS.Timer.Start_Timer (Current_Thread_Obj.Builtin_Timer_Id,
                                   HiRTOS.Get_Current_Time_Us + Time_Us_Type (Timeout_Ms * 1000),
                                   Wait_Timeout_Callback'Access,
                                   Integer_Address (Current_Thread_Id));
      end if;

      HiRTOS_Cpu_Arch_Interface.Thread_Context.Synchronous_Thread_Context_Switch;

      --
      --  NOTE: Blocked thread will resume executing here
      --
      if Mutex_Id /= Invalid_Mutex_Id then
         declare
            Mutex_Obj : HiRTOS.Mutex_Private.Mutex_Type renames
               RTOS_Cpu_Instance.Mutex_Instances (Mutex_Id);
         begin
            Acquire_Mutex_Internal (Mutex_Obj, Current_Thread_Obj, Time_Ms_Type'Last);
         end;
      end if;
   end Wait_Internal;

   procedure Wait_Timeout_Callback (Timer_Id : Valid_Timer_Id_Type;
                                    Callback_Arg : Integer_Address) is
      Thread_Id : constant Valid_Thread_Id_Type := Valid_Thread_Id_Type (Callback_Arg);
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Thread_Obj : HiRTOS.Thread_Private.Thread_Type renames RTOS_Cpu_Instance.Thread_Instances (Thread_Id);
      Condvar_Obj : Condvar_Type renames RTOS_Cpu_Instance.Condvar_Instances (Thread_Obj.Waiting_On_Condvar_Id);
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      pragma Assert (Timer_Id = Thread_Obj.Builtin_Timer_Id);

      --  begin critical section
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      Thread_Obj.Last_Condvar_Wait_Timed_Out := True;

      --
      --  Remove thread from condvar wait queue and add it to the corresponding run queue:
      --
      Thread_Priority_Queue_Remove_This (Condvar_Obj.Waiting_Threads_Queue, Thread_Id);
      Schedule_Awaken_Thread (Thread_Obj);

      --  end critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
   end Wait_Timeout_Callback;

   procedure Wakeup_One_Thread (Condvar_Obj : in out Condvar_Type) is
      Thread_Id : Thread_Id_Type;
   begin
      Thread_Priority_Queue_Remove_Head (Condvar_Obj.Waiting_Threads_Queue, Thread_Id);
      declare
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
         Thread_Obj : HiRTOS.Thread_Private.Thread_Type renames
            RTOS_Cpu_Instance.Thread_Instances (Thread_Id);
      begin
         Schedule_Awaken_Thread (Thread_Obj);
      end;
   end Wakeup_One_Thread;

end HiRTOS.Condvar;
