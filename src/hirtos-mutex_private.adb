--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.RTOS_Private;
with HiRTOS.Condvar_Private;
with HiRTOS.Timer;
with HiRTOS_Cpu_Arch_Interface.Thread_Context;
with HiRTOS_Cpu_Multi_Core_Interface;
with System.Storage_Elements;

package body HiRTOS.Mutex_Private is
   use HiRTOS.RTOS_Private;
   use HiRTOS.Condvar_Private;
   use HiRTOS_Cpu_Multi_Core_Interface;
   use System.Storage_Elements;

   procedure Mutex_Acquire_Timeout_Callback (Timer_Id : Valid_Timer_Id_Type;
                                                Callback_Arg : Integer_Address)
         with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode,
                     Convention => C;

   procedure Take_Mutex_Ownership (Mutex_Obj : in out Mutex_Type;
                                   Thread_Obj : in out Thread_Type;
                                   RTOS_Cpu_Instance : in out HiRTOS_Cpu_Instance_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled and then
                  Mutex_Obj.Owner_Thread_Id = Invalid_Thread_Id and then
                  Mutex_Obj.Recursive_Count = 0 and then
                  (Thread_Obj.State = Thread_Running or else
                   Thread_Obj.State = Thread_Runnable) and then
                  Thread_Obj.Waiting_On_Mutex_Id = Invalid_Mutex_Id;

   -----------------------------------------------------------------------------
   --  Public Subprograms
   -----------------------------------------------------------------------------

   procedure Acquire_Mutex_Internal (Mutex_Obj : in out Mutex_Type;
                                     Current_Thread_Obj : in out Thread_Type;
                                     Timeout_Ms : Time_Ms_Type)
   is
      procedure Move_Runnable_Thread_To_Higher_Priority_Queue (
         RTOS_Cpu_Instance : in out HiRTOS_Cpu_Instance_Type;
         Thread_Obj : in out HiRTOS.Thread_Private.Thread_Type;
         New_Priority : Valid_Thread_Priority_Type)
         with Pre => Thread_Obj.State = Thread_Runnable
                     and then
                     New_Priority > Thread_Obj.Current_Priority
                     and then
                     HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled
                     and then
                     Thread_Obj.Waiting_On_Condvar_Id = Invalid_Condvar_Id
                     and then
                     Thread_Obj.Waiting_On_Mutex_Id = Invalid_Mutex_Id
      is
      begin
         Thread_Priority_Queue_Remove_This (RTOS_Cpu_Instance.Runnable_Threads_Queue, Thread_Obj.Id);
         Thread_Priority_Queue_Add (RTOS_Cpu_Instance.Runnable_Threads_Queue, Thread_Obj.Id,
                                    New_Priority,
                                    First_In_Queue => False);
      end Move_Runnable_Thread_To_Higher_Priority_Queue;

      procedure Move_Blocked_Thread_To_Higher_Priority_Queue (
         Thread_Obj : in out HiRTOS.Thread_Private.Thread_Type;
         New_Priority : Valid_Thread_Priority_Type)
         with Pre => Thread_Obj.State = Thread_Blocked_On_Mutex
                     and then
                     New_Priority > Thread_Obj.Current_Priority
                     and then
                     HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled
                     and then
                     ((Thread_Obj.Waiting_On_Condvar_Id /= Invalid_Condvar_Id
                       and then
                       Thread_Obj.Waiting_On_Mutex_Id = Invalid_Mutex_Id)
                      or else
                      (Thread_Obj.Waiting_On_Mutex_Id /= Invalid_Mutex_Id
                       and then
                       Thread_Obj.Waiting_On_Condvar_Id = Invalid_Condvar_Id))
      is
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      begin
         if Thread_Obj.Waiting_On_Condvar_Id /= Invalid_Condvar_Id then
            declare
               Condvar_Obj : Condvar_Type renames
                  RTOS_Cpu_Instance.Condvar_Instances (Thread_Obj.Waiting_On_Condvar_Id);
            begin
               Thread_Priority_Queue_Remove_This (Condvar_Obj.Waiting_Threads_Queue, Thread_Obj.Id);
               Thread_Priority_Queue_Add (Condvar_Obj.Waiting_Threads_Queue, Thread_Obj.Id,
                                          New_Priority,
                                          First_In_Queue => False);
            end;
         else
            declare
               Mutex_Obj : Mutex_Type renames
                  RTOS_Cpu_Instance.Mutex_Instances (Thread_Obj.Waiting_On_Mutex_Id);
            begin
               Thread_Priority_Queue_Remove_This (Mutex_Obj.Waiting_Threads_Queue, Thread_Obj.Id);
               Thread_Priority_Queue_Add (Mutex_Obj.Waiting_Threads_Queue, Thread_Obj.Id,
                                          New_Priority,
                                          First_In_Queue => False);
            end;
         end if;
      end Move_Blocked_Thread_To_Higher_Priority_Queue;

      procedure Wait_On_Unavailable_Mutex (RTOS_Cpu_Instance : in out HiRTOS_Cpu_Instance_Type;
                                           Mutex_Obj : in out HiRTOS.Mutex_Private.Mutex_Type;
                                           Current_Thread_Obj : in out HiRTOS.Thread_Private.Thread_Type;
                                           Timeout_Ms : Time_Ms_Type)
         with Pre => Current_Thread_Obj.Waiting_On_Mutex_Id = Invalid_Mutex_Id
                     and then
                     Mutex_Obj.Owner_Thread_Id /= Invalid_Thread_Id
                     and then
                     Timeout_Ms /= 0
      is
         Owner_Thread_Obj : HiRTOS.Thread_Private.Thread_Type renames
            RTOS_Cpu_Instance.Thread_Instances (Mutex_Obj.Owner_Thread_Id);
      begin
         if Mutex_Obj.Ceiling_Priority = Invalid_Thread_Priority then
            --
            --  Follow priority inheritance protocol
            --
            --  If mutex owner's priority is lower than the current thread's
            --  priority, boost the mutex owner's priority to inherit the
            --  current thread's priority. Also, requeue the mutex owner to the
            --  corresponding runnable queue, but only if it is not currently
            --  blocked:
            --
            if Owner_Thread_Obj.Current_Priority < Current_Thread_Obj.Current_Priority
            then
               Owner_Thread_Obj.Current_Priority := Current_Thread_Obj.Current_Priority;
               if Owner_Thread_Obj.State = Thread_Runnable then
                  Move_Runnable_Thread_To_Higher_Priority_Queue (RTOS_Cpu_Instance,
                                                                 Owner_Thread_Obj,
                                                                 Current_Thread_Obj.Current_Priority);
               else
                  Move_Blocked_Thread_To_Higher_Priority_Queue (Owner_Thread_Obj,
                                                                Current_Thread_Obj.Current_Priority);
               end if;
            end if;
         else
            --
            --  Follow priority ceiling protocol
            --
            pragma Assert (Owner_Thread_Obj.Current_Priority = Mutex_Obj.Ceiling_Priority);
            pragma Assert (Current_Thread_Obj.Current_Priority <= Mutex_Obj.Ceiling_Priority);
         end if;

         Current_Thread_Obj.Waiting_On_Mutex_Id := Mutex_Obj.Id;

         --
         --  Enqueue thread in mutex's waiters queue:
         --
         Thread_Priority_Queue_Add (Mutex_Obj.Waiting_Threads_Queue, Current_Thread_Obj.Id,
                                    Current_Thread_Obj.Current_Priority,
                                    First_In_Queue => False);
         Current_Thread_Obj.Waiting_On_Mutex_Id := Mutex_Obj.Id;
         Current_Thread_Obj.State := Thread_Blocked_On_Mutex;

         if Timeout_Ms /= Time_Ms_Type'Last then
            --
            --  Start timer for the current thread:
            --
            HiRTOS.Timer.Start_Timer (Current_Thread_Obj.Builtin_Timer_Id,
                                      Relative_Time_Us_Type (Timeout_Ms * 1000),
                                      Mutex_Acquire_Timeout_Callback'Access,
                                      Integer_Address (Current_Thread_Obj.Id));
         end if;

         HiRTOS_Cpu_Arch_Interface.Thread_Context.Synchronous_Thread_Context_Switch;

         --
         --  NOTE: Blocked thread will resume executing here.
         --
      end Wait_On_Unavailable_Mutex;

      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
   begin
      Current_Thread_Obj.Last_Mutex_Acquire_Timed_Out := False;
      if Mutex_Obj.Owner_Thread_Id = Invalid_Thread_Id then
         Take_Mutex_Ownership (Mutex_Obj, Current_Thread_Obj, RTOS_Cpu_Instance);
      elsif Mutex_Obj.Owner_Thread_Id = Current_Thread_Obj.Id then
         Mutex_Obj.Recursive_Count := @ + 1;
      else
         --
         --  Mutex currently owned by another thread
         --
         if Timeout_Ms = 0 then
            Current_Thread_Obj.Last_Mutex_Acquire_Timed_Out := True;
         else
            Wait_On_Unavailable_Mutex (RTOS_Cpu_Instance, Mutex_Obj, Current_Thread_Obj,
                                       Timeout_Ms);
         end if;
      end if;
   end Acquire_Mutex_Internal;

   procedure Release_Mutex_Internal (Mutex_Obj : in out Mutex_Type;
                                     Current_Thread_Obj : in out Thread_Type)
   is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Last_Mutex_Acquired_Id : Mutex_Id_Type;
   begin
      Mutex_Obj.Recursive_Count := @ - 1;
      if Mutex_Obj.Recursive_Count > 0 then
         return;
      end if;

      Mutex_List_Package.List_Remove_Head (Current_Thread_Obj.Owned_Mutexes_List,
                                           Last_Mutex_Acquired_Id,
                                           RTOS_Cpu_Instance.Mutex_Lists_Nodes);
      pragma Assert (Last_Mutex_Acquired_Id = Mutex_Obj.Id);
      Current_Thread_Obj.Current_Priority := Current_Thread_Obj.Base_Priority;

      if Thread_Priority_Queue_Is_Empty (Mutex_Obj.Waiting_Threads_Queue) then
         Mutex_Obj.Owner_Thread_Id := Invalid_Thread_Id;
      else
         Thread_Priority_Queue_Remove_Head (Mutex_Obj.Waiting_Threads_Queue,
                                            Mutex_Obj.Owner_Thread_Id);
         declare
            New_Owner_Thread_Obj : Thread_Type renames
               RTOS_Cpu_Instance.Thread_Instances (Mutex_Obj.Owner_Thread_Id);
         begin
            if Mutex_Obj.Ceiling_Priority /= Invalid_Thread_Priority then
               pragma Assert (New_Owner_Thread_Obj.Current_Priority <= Mutex_Obj.Ceiling_Priority);
               New_Owner_Thread_Obj.Current_Priority := Mutex_Obj.Ceiling_Priority;
            end if;

            Schedule_Awaken_Thread (New_Owner_Thread_Obj);

            pragma Assert (New_Owner_Thread_Obj.Waiting_On_Mutex_Id = Mutex_Obj.Id);
            New_Owner_Thread_Obj.Waiting_On_Mutex_Id := Invalid_Mutex_Id;
            Take_Mutex_Ownership (Mutex_Obj, New_Owner_Thread_Obj, RTOS_Cpu_Instance);
         end;

         --
         --  Trigger synchronous context switch to run the thread scheduler
         --
         HiRTOS_Cpu_Arch_Interface.Thread_Context.Synchronous_Thread_Context_Switch;
      end if;
   end Release_Mutex_Internal;

   -----------------------------------------------------------------------------
   --  Private Subprograms
   -----------------------------------------------------------------------------

   procedure Take_Mutex_Ownership (Mutex_Obj : in out Mutex_Type;
                                   Thread_Obj : in out Thread_Type;
                                   RTOS_Cpu_Instance : in out HiRTOS_Cpu_Instance_Type) is
   begin
      Thread_Obj.Waiting_On_Mutex_Id := Invalid_Mutex_Id;
      Mutex_Obj.Owner_Thread_Id := Thread_Obj.Id;
      Mutex_Obj.Recursive_Count := 1;
      Mutex_List_Package.List_Add_Head (Thread_Obj.Owned_Mutexes_List,
                                          Mutex_Obj.Id,
                                          RTOS_Cpu_Instance.Mutex_Lists_Nodes);

      if Mutex_Obj.Ceiling_Priority /= Invalid_Thread_Priority and then
         Thread_Obj.Current_Priority < Mutex_Obj.Ceiling_Priority
      then
         Thread_Obj.Current_Priority := Mutex_Obj.Ceiling_Priority;
      end if;
   end Take_Mutex_Ownership;

   procedure Mutex_Acquire_Timeout_Callback (Timer_Id : Valid_Timer_Id_Type;
                                             Callback_Arg : System.Storage_Elements.Integer_Address)
   is
      Thread_Id : constant Valid_Thread_Id_Type := Valid_Thread_Id_Type (Callback_Arg);
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Thread_Obj : HiRTOS.Thread_Private.Thread_Type renames RTOS_Cpu_Instance.Thread_Instances (Thread_Id);
      Mutex_Obj : Mutex_Type renames RTOS_Cpu_Instance.Mutex_Instances (Thread_Obj.Waiting_On_Mutex_Id);
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      pragma Assert (Timer_Id = Thread_Obj.Builtin_Timer_Id);

      --  begin critical section
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      Thread_Obj.Last_Mutex_Acquire_Timed_Out := True;
      Thread_Obj.Waiting_On_Mutex_Id := Invalid_Mutex_Id;

      --
      --  Remove thread from mutex wait queue and add it to the corresponding run queue:
      --
      Thread_Priority_Queue_Remove_This (Mutex_Obj.Waiting_Threads_Queue, Thread_Id);
      Schedule_Awaken_Thread (Thread_Obj);

      --  end critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
   end Mutex_Acquire_Timeout_Callback;

end HiRTOS.Mutex_Private;
