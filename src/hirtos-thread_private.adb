--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
--
with HiRTOS.RTOS_Private;
with HiRTOS.Memory_Protection_Private;

package body HiRTOS.Thread_Private is
   use HiRTOS.RTOS_Private;

   -----------------------------------------------------------------------------
   --  Private Subprograms Specifications                                     --
   -----------------------------------------------------------------------------

   --
   --  If the thread has consumed its time slice, enqueue it at the end of the
   --  given run queue.
   --
   procedure Track_Thread_Time_Slice (RTOS_Cpu_Instance : in out HiRTOS_Cpu_Instance_Type;
                                      Thread_Obj : in out Thread_Type)
      with Pre => Thread_Obj.Time_Slice_Left_Us <= Thread_Time_Slice_Us
                  and then
                  HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled;

   procedure Save_Thread_Extended_Context (Thread_Obj : in out Thread_Type);

   -----------------------------------------------------------------------------
   --  Public Subprograms                                                     --
   -----------------------------------------------------------------------------

   procedure Initialize_Runnable_Thread_Queues (Runnable_Thread_Queues : out Runnable_Thread_Queues_Type)
   is
      Thread_Queue_Id : Thread_Queue_Id_Type := (Queue_Kind => Run_Queue, Thread_Priority => Invalid_Thread_Priority);
   begin
      for I in Runnable_Thread_Queues'Range loop
         Thread_Queue_Id.Thread_Priority := I;
         Thread_Queue_Package.List_Init (Runnable_Thread_Queues (I), Thread_Queue_Id);
      end loop;
   end Initialize_Runnable_Thread_Queues;

   procedure Increment_Privilege_Nesting (Thread_Obj : in out Thread_Type) is
   begin
      null; --  TODO
      pragma Assert (Thread_Obj.Privilege_Nesting_Counter < Privilege_Nesting_Counter_Type'Last);
      Thread_Obj.Privilege_Nesting_Counter := @ + 1;
   end Increment_Privilege_Nesting;

   procedure Decrement_Privilege_Nesting (Thread_Obj : in out Thread_Type) is
   begin
      pragma Assert (Thread_Obj.Privilege_Nesting_Counter >= 1);
      Thread_Obj.Privilege_Nesting_Counter := @ - 1;
   end Decrement_Privilege_Nesting;

   procedure Save_Thread_Stack_Pointer (Thread_Obj : in out Thread_Type;
                                        Stack_Pointer : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type)
   is
   begin
      Thread_Obj.Saved_Stack_Pointer := Stack_Pointer;
   end Save_Thread_Stack_Pointer;

   procedure Run_Thread_Scheduler is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (HiRTOS_Cpu_Arch_Interface.Get_Cpu_Id);
      Current_Thread_Id : constant Thread_Id_Type := RTOS_Cpu_Instance.Current_Thread_Id;
      Current_Thread_Obj : Thread_Type renames HiRTOS_Obj.Thread_Instances (Current_Thread_Id);
      Old_Cpu_Interrupt_Mask : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
      Old_Current_Thread_Id : constant Thread_Id_Type := Current_Thread_Id;
   begin
      --  begin critical section
      Old_Cpu_Interrupt_Mask := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
      if Current_Thread_Id /= Invalid_Thread_Id then
         Track_Thread_Time_Slice (RTOS_Cpu_Instance, Current_Thread_Obj);

      --  If current thread is not invalid and
      --     Increment the timeslice up count for that thread.
      --     Set Time slice used back to 0 for the current thread

      end if;

      --  Dequeue the highest priority runnable thread.
      --  If current thread /= selected thread,
      --     If current thread is not invalid
      --        save thread-specific memory protection regions in the current thread's context
      --        Enqueue current thread at the beginning of its priority queue
      --        Increment thread preempted count for current thread.
      --     end if
      --     Set the newly selected thread, as the current thread.
      --     Restore thread-specific memory protection regions from the current thread's context
      --     Increment Thread context switches count
      --  else
      --     Increment thread interrupted count for current thread
      --

      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupt_Mask);
   end Run_Thread_Scheduler;

   -----------------------------------------------------------------------------
   --  Private Subprograms                                                    --
   -----------------------------------------------------------------------------

   procedure Track_Thread_Time_Slice (RTOS_Cpu_Instance : in out HiRTOS_Cpu_Instance_Type;
                                      Thread_Obj : in out Thread_Type) is
      Run_Queue : Thread_Queue_Package.List_Anchor_Type renames
                     RTOS_Cpu_Instance.Runnable_Thread_Queues (Thread_Obj.Priority);
   begin
      if Thread_Obj.Time_Slice_Left_Us = Thread_Time_Slice_Us then
         Thread_Obj.Stats.Times_Time_Slice_Consumed := @ + 1;
         Thread_Obj.Time_Slice_Left_Us := Thread_Time_Slice_Us;
         Thread_Queue_Package.List_Add_Tail (Run_Queue, Thread_Obj.Id);
         Save_Thread_Extended_Context (Thread_Obj);
      end if;
   end Track_Thread_Time_Slice;

   procedure Save_Thread_Extended_Context (Thread_Obj : in out Thread_Type) is
   begin
      HiRTOS.Memory_Protection_Private.Save_Thread_Memory_Regions (
         Thread_Obj.Saved_Thread_Memory_Regions);
   end Save_Thread_Extended_Context;

   procedure Restore_Thread_Extended_Context (Thread_Obj : in out Thread_Type) is
   begin
      HiRTOS.Memory_Protection_Private.Restore_Thread_Memory_Regions (
         Thread_Obj.Saved_Thread_Memory_Regions);
   end Restore_Thread_Extended_Context;

end HiRTOS.Thread_Private;
