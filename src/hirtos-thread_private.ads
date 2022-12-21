--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.Memory_Protection_Private;

private package HiRTOS.Thread_Private with
  SPARK_Mode => On
is
   Thread_Time_Slice_Us : constant :=
     HiRTOS_Config_Parameters.Thread_Time_Slice_Ticks *
     HiRTOS_Config_Parameters.Tick_Period_Us;

   type Thread_State_Type is
     (Thread_Not_Created, Thread_Runnable, Thread_Running, Thread_Blocked);

   Max_Privilege_Nesting : constant := 64;

   --
   --  Privilege nesting counter. 0 means the CPU is in unprivileged mode
   --  and > 0 means the CPU is tunning in privileged mode. It is incremented
   --  every time that Enter_Cpu_Privileged_Mode is called and decremented
   --  every time that Exit_Cpu_Privileged_Mode is called.
   --
   type Privilege_Nesting_Counter_Type is range 0 .. Max_Privilege_Nesting;

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
   --  @field Delay_Timer_Id: Id of the delay timer associated with this thread.
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
      Delay_Timer_Id : Timer_Id_Type := Invalid_Timer_Id;
      Saved_Stack_Pointer : System.Address;
      Privilege_Nesting_Counter : Privilege_Nesting_Counter_Type := 0;
      Time_Slice_Left_Us : Time_Us_Type := Thread_Time_Slice_Us;
      Saved_Thread_Memory_Regions :
         HiRTOS.Memory_Protection_Private.Thread_Memory_Regions_Type;
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

   type Priority_Thread_Queues_Type is
     array
       (Valid_Thread_Priority_Type) of Thread_Queue_Package.List_Anchor_Type;

   procedure Initialize_Priority_Thread_Queues
     (Priority_Thread_Queues : out Priority_Thread_Queues_Type);

   procedure Increment_Privilege_Nesting (Thread_Obj : in out Thread_Type) with
     Pre =>
      Get_Privilege_Nesting (Thread_Obj) < Privilege_Nesting_Counter_Type'Last;

   procedure Decrement_Privilege_Nesting (Thread_Obj : in out Thread_Type) with
     Pre => Get_Privilege_Nesting (Thread_Obj) > 0;

   procedure Save_Thread_Stack_Pointer
     (Thread_Obj    : in out Thread_Type;
      Stack_Pointer :        System.Address);

   function Get_Thread_Stack_Pointer
     (Thread_Obj : Thread_Type)
      return System.Address with
     Inline_Always;

   function Get_Privilege_Nesting
     (Thread_Obj : Thread_Type) return Privilege_Nesting_Counter_Type is
     (Thread_Obj.Privilege_Nesting_Counter);

   function Get_Thread_Stack_Pointer
     (Thread_Obj : Thread_Type)
      return System.Address is
     (Thread_Obj.Saved_Stack_Pointer);

   procedure Run_Thread_Scheduler;

end HiRTOS.Thread_Private;
