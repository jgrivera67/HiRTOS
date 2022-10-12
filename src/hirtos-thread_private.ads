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

with HiRTOS_Cpu_Arch_Interface.Memory_Protection;

private package HiRTOS.Thread_Private with
  SPARK_Mode => On
is
   Thread_Time_Slice_Us : constant :=
     HiRTOS_Config_Parameters.Thread_Time_Slice_Ticks *
     HiRTOS_Config_Parameters.Tick_Period_Us;

   type Thread_State_Type is
     (Thread_Not_Created, Thread_Runnable, Thread_Running, Thread_Blocked);

   --
   --  Thread control block
   --
   --  @field Initialized: flag indicating if the thread object has been initialized.
   --  @field Id: thread Id
   --  @field State: current state of the thread
   --  @field Priority: Thread normal priority
   --  @field Atomic_Level: Current atomic level
   --  @field Timer_Id: Id of timer used for Thread_Delay_Unitl() and
   --         Thread_Delay calls on this thread
   --  @field Stack_Base_Addr: base address of execution stack for this thread
   --  @field Stack_Size: size in bytes of execution stack for this thread
   --  @field Builtin_Condvar_Id: Id of built-in condition variable on which this thread can
   --         wait for other threads or interrupt handlers to wake it up.
   --  @field Waiting_On_Condvar_Id : Id of condition variable on which this thread is
   --         currently waiting on or Invalid_Condvar_Id if none.
   --  @field Waiting_On_Mutex_Id : Id of mutex this thread is currently waiting to
   --         acquire or Invalid_Mutex_Id if none.
   --  @field Owned_Mutexes_List : List of mutexes currently owned by this thread. This
   --         list is really a stack of mutexes (LIFO list), as the last mutex acquired
   --         is the next one to be released.
   --  @field Saved_Stack_Pointer: saved stack pointer CPU register the last time this
   --         thread was switched out
   --  @field Privilege_Nesting_Counter: Counter of unpaired calls to `Enter_Privileged_Mode`
   --  @field Time_Slice_Left_Us: thread's current time slice left in microseconds.
   --  @field List_Node: this thread's node in a queue of threads, if this thread is in a queue.
   --  @field Stats: Per-thread stats
   --
   type Thread_Type is limited record
      Initialized : Boolean := False;
      Id : Thread_Id_Type := Invalid_Thread_Id;
      State : Thread_State_Type := Thread_Not_Created;
      Priority : Thread_Priority_Type;
      Atomic_Level : Atomic_Level_Type := Atomic_Level_None;
      Timer_Id : Timer_Id_Type := Invalid_Timer_Id;
      Stack_Base_Addr : System.Address := System.Null_Address;
      Stack_Size_In_Bytes : Thread_Stack_Size_In_Bytes_Type := 0;
      Builtin_Condvar_Id : Condvar_Id_Type := Invalid_Condvar_Id;
      Waiting_On_Condvar_Id : Condvar_Id_Type := Invalid_Condvar_Id;
      Waiting_On_Mutex_Id : Mutex_Id_Type := Invalid_Mutex_Id;
      Owned_Mutexes_List : Mutex_List_Package.List_Anchor_Type;
      Saved_Stack_Pointer : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
      Privilege_Nesting_Counter : Privilege_Nesting_Counter_Type := 0;
      Time_Slice_Left_Us : Time_Us_Type := Thread_Time_Slice_Us;
      Saved_Thread_Memory_Regions :
         HiRTOS_Cpu_Arch_Interface.Memory_Protection.Thread_Memory_Regions_Type;
      Stats : Thread_Stats_Type;
   end record with
     Alignment => HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment;

   --
   --  Each thread has its own condvar
   --
   pragma Compile_Time_Error
     (HiRTOS_Config_Parameters.Max_Num_Condvars >
      HiRTOS_Config_Parameters.Max_Num_Threads,
      "Max_Num_Condvars too small");

   --
   --  Each thread has its own timer
   --
   pragma Compile_Time_Error
     (HiRTOS_Config_Parameters.Max_Num_Timers >
      HiRTOS_Config_Parameters.Max_Num_Timers,
      "Max_Num_Timers too small");

   type Thread_Array_Type is array (Valid_Thread_Id_Type) of Thread_Type;

   type Runnable_Thread_Queues_Type is
     array
       (Valid_Thread_Priority_Type) of Thread_Queue_Package.List_Anchor_Type;

   procedure Initialize_Runnable_Thread_Queues
     (Runnable_Thread_Queues : out Runnable_Thread_Queues_Type);

   procedure Increment_Privilege_Nesting (Thread_Obj : in out Thread_Type) with
     Pre =>
      Get_Privilege_Nesting (Thread_Obj) < Privilege_Nesting_Counter_Type'Last;

   procedure Decrement_Privilege_Nesting (Thread_Obj : in out Thread_Type) with
     Pre => Get_Privilege_Nesting (Thread_Obj) > 0;

   procedure Save_Thread_Stack_Pointer
     (Thread_Obj    : in out Thread_Type;
      Stack_Pointer :        HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type);

   function Get_Thread_Stack_Pointer
     (Thread_Obj : Thread_Type)
      return HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type with
     Inline_Always;

   function Get_Privilege_Nesting
     (Thread_Obj : Thread_Type) return Privilege_Nesting_Counter_Type is
     (Thread_Obj.Privilege_Nesting_Counter);

   function Get_Thread_Stack_Pointer
     (Thread_Obj : Thread_Type)
      return HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type is
     (Thread_Obj.Saved_Stack_Pointer);

   procedure Run_Thread_Scheduler;

end HiRTOS.Thread_Private;
