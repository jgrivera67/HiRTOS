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
package body HiRTOS.Thread_Private is

   -----------------------------------------------------------------------------
   --  Private Subprograms Specifications                                     --
   -----------------------------------------------------------------------------

   --
   --  If the thread has consumed its time slice, enqueue it at the end of the
   --  given run queue.
   --
   procedure Track_Thread_Time_Slice (HiRTOS_Instance : in out HiRTOS_Instance_Type;
                                      Thread_Obj : in out Thread_Type)
      with Pre => Thread_Obj.Time_Slice_Left_Us <= Thread_Time_Slice_Us
                  and then
                  HiRTOS_Platform_Interface.Cpu_Interrupting_Disabled;

   procedure Save_Thread_Extended_Context (Thread_Obj : in out Thread_Type);

   -----------------------------------------------------------------------------
   --  Public Subprograms                                                     --
   -----------------------------------------------------------------------------

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
                                        Stack_Pointer : HiRTOS_Platform_Interface.Cpu_Register_Type)
   is
   begin
      Thread_Obj.Saved_Stack_Pointer := Stack_Pointer;
   end Save_Thread_Stack_Pointer;

   procedure Run_Thread_Scheduler is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Current_Thread_Id : constant Thread_Id_Type := HiRTOS_Instance.Current_Thread_Id;
      Current_Thread_Obj : Thread_Type renames HiRTOS_Instance.Thread_Instances (Current_Thread_Id);
      Old_Cpu_Interrupt_Mask : HiRTOS_Platform_Interface.Cpu_Register_Type;
      Old_Current_Thread_Id : constant Thread_Id_Type := Current_Thread_Id;
   begin
      --  begin critical section
      Old_Cpu_Interrupt_Mask := HiRTOS_Platform_Interface.Disable_Cpu_Interrupting;
      if Current_Thread_Id /= Invalid_Thread_Id then
         Track_Thread_Time_Slice (HiRTOS_Instance, Current_Thread_Obj);

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
      HiRTOS_Platform_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupt_Mask);
   end Run_Thread_Scheduler;

   -----------------------------------------------------------------------------
   --  Private Subprograms                                                    --
   -----------------------------------------------------------------------------

   procedure Track_Thread_Time_Slice (HiRTOS_Instance : in out HiRTOS_Instance_Type;
                                      Thread_Obj : in out Thread_Type) is
      Run_Queue : Thread_Queue_Package.List_Anchor_Type renames
                     HiRTOS_Instance.Runnable_Thread_Queues (Thread_Obj.Priority);
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
      HiRTOS_Platform_Interface.Memory_Protection.Save_Thread_Mem_Prot_Regions (Thread_Obj.Thread_Mem_Prot_Regions);
   end Save_Thread_Extended_Context;

   procedure Restore_Thread_Extended_Context (Thread_Obj : in out Thread_Type) is
   begin
      HiRTOS_Platform_Interface.Memory_Protection.Restore_Thread_Mem_Prot_Regions (Thread_Obj.Thread_Mem_Prot_Regions);
   end Save_Thread_Extended_Context;

end HiRTOS.Thread_Private;