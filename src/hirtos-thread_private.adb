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
                                        Stack_Pointer : Cpu_Register_Type)
   is
   begin
      Thread_Obj.Saved_Stack_Pointer := Stack_Pointer;
   end Save_Thread_Stack_Pointer;

   procedure Run_Thread_Scheduler is
   begin
      --  If current thread is not invalid and has consumed its time slice,
      --     Enqueue it at the end of the corresponding priorty's queue.
      --     Increment the timeslice up count for that thread.
      --     Set Time slice used back to 0 for the current thread
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
      null; --  ???
   end Run_Thread_Scheduler;

end HiRTOS.Thread_Private;
