--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HiRTOS.RTOS_Private;
with HiRTOS_Cpu_Multi_Core_Interface;
with HiRTOS_Cpu_Arch_Interface;
with HiRTOS_Low_Level_Debug_Interface; --???
with GNAT.Source_Info; --???
with HiRTOS_Cpu_Arch_Interface.Thread_Context; --???

package body HiRTOS.Thread_Private is
   use HiRTOS.RTOS_Private;
   use HiRTOS_Cpu_Multi_Core_Interface;

   -----------------------------------------------------------------------------
   --  Private Subprograms Specifications                                     --
   -----------------------------------------------------------------------------

   --
   --  If the thread has consumed its time slice, enqueue it at the end of the
   --  given run queue.
   --
   procedure Reschedule_Thread (Thread_Id : Valid_Thread_Id_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled;

   -----------------------------------------------------------------------------
   --  Public Subprograms                                                     --
   -----------------------------------------------------------------------------

   procedure Increment_Privilege_Nesting (Thread_Obj : in out Thread_Type) is
   begin
      pragma Assert (Thread_Obj.Privilege_Nesting_Counter < Privilege_Nesting_Counter_Type'Last);
      Thread_Obj.Privilege_Nesting_Counter := @ + 1;
   end Increment_Privilege_Nesting;

   procedure Decrement_Privilege_Nesting (Thread_Obj : in out Thread_Type) is
   begin
      pragma Assert (Thread_Obj.Privilege_Nesting_Counter >= 1);
      Thread_Obj.Privilege_Nesting_Counter := @ - 1;
   end Decrement_Privilege_Nesting;

   procedure Save_Thread_Stack_Pointer (Thread_Obj : in out Thread_Type;
                                        Stack_Pointer : System.Address)
   is
   begin
      Thread_Obj.Saved_Stack_Pointer := Stack_Pointer;
   end Save_Thread_Stack_Pointer;

   procedure Dequeue_Highest_Priority_Runnable_Thread (Thread_Id : out Valid_Thread_Id_Type) is
      RTOS_Cpu_Instance : HiRTOS.RTOS_Private.HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      pragma Assert (RTOS_Cpu_Instance.Current_Thread_Id = Invalid_Thread_Id);

      --  Begin critical section
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      Thread_Priority_Queue_Remove_Head (RTOS_Cpu_Instance.Runnable_Thread_Queue, Thread_Id);

      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
   end Dequeue_Highest_Priority_Runnable_Thread;

   procedure Enqueue_Runnable_Thread (Thread_Id : Valid_Thread_Id_Type; Priority : Valid_Thread_Priority_Type;
                                      First_In_Queue : Boolean := False)
   is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      --  Begin critical section
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      Thread_Priority_Queue_Add (RTOS_Cpu_Instance.Runnable_Thread_Queue, Thread_Id, Priority, First_In_Queue);

      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
   end Enqueue_Runnable_Thread;

   procedure Run_Thread_Scheduler is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Old_Thread_Id : Thread_Id_Type;
      Old_Cpu_Interrupt_Mask : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      --  begin critical section
      Old_Cpu_Interrupt_Mask := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
      Old_Thread_Id := RTOS_Cpu_Instance.Current_Thread_Id;
      if Old_Thread_Id /= Invalid_Thread_Id then
         declare
            Old_Thread_Obj : Thread_Type renames HiRTOS_Obj.Thread_Instances (Old_Thread_Id);
         begin
            --
            --  Add current thread to corresponding run queue if not blocked on a condvar or mutex:
            --
            if Old_Thread_Obj.Waiting_On_Condvar_Id = Invalid_Condvar_Id and then
               Old_Thread_Obj.Waiting_On_Mutex_Id = Invalid_Mutex_Id
            then
               Reschedule_Thread (Old_Thread_Id);
            end if;
         end;

         RTOS_Cpu_Instance.Current_Thread_Id := Invalid_Thread_Id;
      end if;

      Dequeue_Highest_Priority_Runnable_Thread (RTOS_Cpu_Instance.Current_Thread_Id);
      if RTOS_Cpu_Instance.Current_Thread_Id /= Old_Thread_Id then
         if Old_Thread_Id /= Invalid_Thread_Id then
            declare
               Old_Thread_Obj : Thread_Type renames HiRTOS_Obj.Thread_Instances (Old_Thread_Id);
            begin
               Old_Thread_Obj.Stats.Times_Preempted_By_Thread := @ + 1;
            end;
         end if;

         declare
            Current_Thread_Obj : Thread_Type renames HiRTOS_Obj.Thread_Instances (RTOS_Cpu_Instance.Current_Thread_Id);
         begin
            Current_Thread_Obj.Stats.Times_Switched_In := @ + 1;
         end;
      end if;

      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupt_Mask);
      --???
      --  declare
      --     use HiRTOS_Cpu_Arch_Interface.Thread_Context;
      --     use System.Storage_Elements;
      --     Current_Thread_Id : constant Valid_Thread_Id_Type :=
      --        RTOS_Cpu_Instance.Current_Thread_Id;
      --     Current_Thread_Obj : Thread_Type renames
      --        HiRTOS_Obj.Thread_Instances (Current_Thread_Id);
      --     Stack_Pointer : constant System.Address :=
      --        Thread_Private.Get_Thread_Stack_Pointer (Current_Thread_Obj);
      --     Thread_Cpu_Context : Cpu_Context_Type with
      --        Import, Address => Stack_Pointer;
      --  begin
      --     HiRTOS_Low_Level_Debug_Interface.Print_String ("*** JGR: " & GNAT.Source_Info.Source_Location & " SP "); --???
      --     HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (
      --        Interfaces.Unsigned_32 (To_Integer (Stack_Pointer)));
      --     HiRTOS_Low_Level_Debug_Interface.Print_String (" PC "); --???
      --     HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (
      --        Interfaces.Unsigned_32 (To_Integer (Get_Saved_PC (Thread_Cpu_Context))));
      --     HiRTOS_Low_Level_Debug_Interface.Print_String (" CPSR "); --???
      --     HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (
      --        Interfaces.Unsigned_32 (Get_Saved_CPSR (Thread_Cpu_Context)), End_Line => True);
      --  end;
      --???
   end Run_Thread_Scheduler;

   -----------------------------------------------------------------------------
   --  Private Subprograms                                                    --
   -----------------------------------------------------------------------------

   procedure Reschedule_Thread (Thread_Id : Valid_Thread_Id_Type) is
      Thread_Obj : Thread_Type renames HiRTOS_Obj.Thread_Instances (Thread_Id);
   begin
      if Thread_Obj.Time_Slice_Left_Us = 0 then
         Thread_Obj.Stats.Times_Time_Slice_Consumed := @ + 1;
         Thread_Obj.Time_Slice_Left_Us := Thread_Time_Slice_Us;
         Enqueue_Runnable_Thread (Thread_Obj.Id, Thread_Obj.Current_Priority);
      else
         pragma Assert (Thread_Obj.Time_Slice_Left_Us <= Thread_Time_Slice_Us);
         Enqueue_Runnable_Thread (Thread_Obj.Id, Thread_Obj.Current_Priority, First_In_Queue => True);
      end if;
   end Reschedule_Thread;

   procedure Save_Thread_Extended_Context (Thread_Obj : in out Thread_Type) is
   begin
      HiRTOS.Memory_Protection_Private.Save_Thread_Memory_Regions (
         Thread_Obj.Saved_Thread_Memory_Regions);
   end Save_Thread_Extended_Context;

   procedure Restore_Thread_Extended_Context (Thread_Obj : Thread_Type) is
   begin
      HiRTOS.Memory_Protection_Private.Restore_Thread_Memory_Regions (
         Thread_Obj.Saved_Thread_Memory_Regions);
   end Restore_Thread_Extended_Context;

end HiRTOS.Thread_Private;
