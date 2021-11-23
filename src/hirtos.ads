--
--  Copyright (c) 2021, German Rivera
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

with System;
with Interfaces;
with HiRTOS_Config_Parameters;
private with HiRTOS_Platform_Interface;
private with Generic_Object_Pool;
private with Generic_Linked_List;

--
--  @summary HiRTOS - High-Integrity RTOS
--
package HiRTOS with SPARK_Mode => On is
   use type Interfaces.Unsigned_16;

   --
   --  Number of execution priorities for ISRs and threads
   --
   Num_Execution_Priorities : constant := HiRTOS_Config_Parameters.Num_Interrupt_Priorities +
                                          HiRTOS_Config_Parameters.Num_Thread_Priorities;

   --
   --  Highest execution priority is 0 and lowest execution proirity is Num_Execution_Priorities - 1
   --
   type Execution_Priority_Type is mod Num_Execution_Priorities
      with Size => Interfaces.Unsigned_8'Size;

   type Error_Type is new System.Address;

   --
   --  Initilize RTOS internal state variables
   --
   procedure Initialize_Rtos
      with Export,
         Convention => C,
         External_Name => "hirtos_initialize_rtos";

   --
   --  Start RTOS tick timer and RTOS thread scheduler for the calling CPU
   --
   procedure Start_Thread_Scheduler
      with Export,
         Convention => C,
         External_Name => "hirtos_start_thread_scheduler";

   --
   --  Mutex package
   --
   package Mutex is
      type Mutex_Type is limited private;
      type Mutex_Pool_Type is limited private;

      type Mutex_Id_Type is range 0 .. HiRTOS_Config_Parameters.Max_Num_Mutexes
         with Size => Interfaces.Unsigned_8'Size;

      Invalid_Mutex_Id : constant Mutex_Id_Type := Mutex_Id_Type'Last;

   private
      --
      --  Mutex object
      --
      --  @field Initialized flag indicating if the mutex object has been
      --  initialized.
      --  @field Id mutex Id
      --  @field Priority Execeution priority associated to the mutex
      --
      type Mutex_Type is limited record
         Initialized : Boolean := False;
         Id : Mutex_Id_Type := Invalid_Mutex_Id;
         Priority : Execution_Priority_Type;
      end record;

      package Mutex_Pool is new
         Generic_Object_Pool (Object_Type => Mutex_Type,
                              Object_Id_Type => Mutex_Id_Type);

      type Mutex_Pool_Type is new Mutex_Pool.Object_Pool_Type;
   end Mutex;

   --
   --  Condition variable package
   --
   package Condvar is
      type Condvar_Type is limited private;
      type Condvar_Pool_Type is limited private;

      type Condvar_Id_Type is range 0 .. HiRTOS_Config_Parameters.Max_Num_Condvars
         with Size => Interfaces.Unsigned_8'Size;

      Invalid_Condvar_Id : constant Condvar_Id_Type := Condvar_Id_Type'Last;

   private
      --
      --  Condition variable object
      --
      --  @field Initialized flag indicating if the condvar object has been
      --  initialized.
      --  @field Id condvar Id
      --
      type Condvar_Type is limited record
         Initialized : Boolean := False;
         Id : Condvar_Id_Type := Invalid_Condvar_Id;
      end record;

      package Condvar_Pool is new
         Generic_Object_Pool (Object_Type => Condvar_Type,
                              Object_Id_Type => Condvar_Id_Type);

      type Condvar_Pool_Type is new Condvar_Pool.Object_Pool_Type;
   end Condvar;

   --
   --  Timer package
   --
   package Timer is
      type Timer_Type is limited private;
      type Timer_Pool_Type is limited private;

      type Time_Us_Type is new Interfaces.Unsigned_32;

      type Time_Ms_Type is new Interfaces.Unsigned_32;

      type Timer_Ticks_Count_Type is new Interfaces.Unsigned_32;

      type Timer_Id_Type is range 0 .. HiRTOS_Config_Parameters.Max_Num_Timers
         with Size => Interfaces.Unsigned_8'Size;

      Invalid_Timer_Id : constant Timer_Id_Type := Timer_Id_Type'Last;

      type Timer_Wheel_Type is limited private;

   private
      --
      --  Number of spokes of a timer wheel. It must be a power of 2.
      --
      Timer_Wheel_Num_Spokes : constant := 128;

      type Timer_Wheel_Spoke_Index_Type is mod Timer_Wheel_Num_Spokes;

      --
      --  Software timer object
      --
      --  @field Initialized flag indicating if the timer object has been
      --  initialized.
      --  @field Id timer Id
      --
      type Timer_Type is limited record
         Initialized : Boolean := False;
         Id : Timer_Id_Type := Invalid_Timer_Id;
      end record;

      package Timer_List is new
         Generic_Linked_List (List_Id_Type => Timer_Wheel_Spoke_Index_Type,
                              Node_Payload_Type => Timer_Type);

      package Timer_Pool is new
         Generic_Object_Pool (Object_Type => Timer_List.List_Node_Type,
                              Object_Id_Type => Timer_Id_Type);

      type Timer_Pool_Type is new Timer_Pool.Object_Pool_Type;

      type Timer_Wheel_Spokes_Hash_Table_Type is array (Timer_Wheel_Spoke_Index_Type) of
         Timer_List.List_Anchor_Type;

      --
      --  Timer wheel object
      --
      --  @field Wheel_Spokes_Hash_Table array of hash chains, one hash chain per wheel spoke
      --  @field Current_Wheel_Spoke_Index index of the current entry in `Wheel_Spokes_Hash_Table`
      --
      type Timer_Wheel_Type is limited record
         Wheel_Spokes_Hash_Table : Timer_Wheel_Spokes_Hash_Table_Type;
         Current_Wheel_Spoke_Index : Timer_Wheel_Spoke_Index_Type :=
            Timer_Wheel_Spoke_Index_Type'First;
      end record;
   end Timer;

   --
   --  Thread package
   --
   package Thread is
      type Thread_Type is limited private;
      type Thread_Pool_Type is limited private;

      subtype Thread_Priority_Type is Execution_Priority_Type
         range HiRTOS_Config_Parameters.Num_Interrupt_Priorities ..
               Execution_Priority_Type'Last;

      subtype Thread_Stack_Size_Type is Interfaces.Unsigned_16 with
         Dynamic_Predicate =>
            Thread_Stack_Size_Type >= HiRTOS_Config_Parameters.Thread_Stack_Min_Size
            or else
            Thread_Stack_Size_Type = 0;

      --
      --  NOTE: Lower value means higher priority
      --
      Lowest_Thread_Prioritiy :
         constant Thread_Priority_Type := Thread_Priority_Type'Last;

      Highest_Thread_Prioritiy :
         constant Thread_Priority_Type := Thread_Priority_Type'First;

      type Thread_Id_Type is range 0 .. HiRTOS_Config_Parameters.Max_Num_Threads
         with Size => Interfaces.Unsigned_8'Size;

      Invalid_Thread_Id : constant Thread_Id_Type := Thread_Id_Type'Last;

      type Runnable_Thread_Queues_Type is limited private;

      type Thread_Entry_Point_Type is access procedure (Arg : System.Address)
            with Convention => C;

      --
      --  Create new thread
      --
      procedure Create_Thread (Entry_Point : Thread_Entry_Point_Type;
                              Priority : Thread_Priority_Type;
                              Stack_Addr : System.Address;
                              Stack_Size : Interfaces.Unsigned_32;
                              Thread_Id : out Thread_Id_Type;
                              Error : out Error_Type)
      with Export,
         Convention => C,
         External_Name => "hirtos_create_thread";

   private
      type Thread_State_Type is (Thread_Not_Created,
                                 Thread_Runnable,
                                 Thread_Running,
                                 Thread_Blocked);

      --
      --  Thread control block
      --
      --  @field Initialized flag indicating if the thread object has been
      --  initialized.
      --  @field Id thread Id
      --  @field State current state of the thread
      --  @Priority Thread normal priority
      --  @field Node: this thread's node in a queue of threads, if this thread is in a queue.
      --  @field Timer_Id Id of timer used for Thread_Delay_Unitl() and
      --  Thread_Delay() calls on this thread
      --  @field Stack_Base_Addr base address of execution stack for this thread
      --  @field Stack_Size size in bytes of execution stack for this thread
      --  @field Condvar_Id Id of condition variable on which this thread can
      --  wait for other threads or interrupt handlers to wake it up.
      --  @field Saved_Stack_Pointer saved stack pointer CPU register the last time this thread was
      --  switched out
      --
      type Thread_Type is limited record
         Initialized : Boolean := False;
         Id : Thread_Id_Type := Invalid_Thread_Id;
         State : Thread_State_Type := Thread_Not_Created;
         Priority : Thread_Priority_Type;
         Timer_Id : Timer.Timer_Id_Type := Timer.Invalid_Timer_Id;
         Stack_Base_Addr : System.Address := System.Null_Address;
         Stack_Size : Thread_Stack_Size_Type := 0;
         Condvar_Id : Condvar.Condvar_Id_Type := Condvar.Invalid_Condvar_Id;
         Saved_Stack_Pointer : HiRTOS_Platform_Interface.Cpu_Register_Type;
      end record with Alignment =>
                        HiRTOS_Platform_Interface.Mem_Prot_Region_Alignment;

      --
      --  Each thread has its own condvar
      --
      pragma Compile_Time_Error (HiRTOS_Config_Parameters.Max_Num_Condvars >
                                 HiRTOS_Config_Parameters.Max_Num_Threads,
                                 "Max_Num_Condvars too small");

      --
      --  Each thread has its own timer
      --
      pragma Compile_Time_Error (HiRTOS_Config_Parameters.Max_Num_Timers >
                                 HiRTOS_Config_Parameters.Max_Num_Timers,
                                 "Max_Num_Timers too small");

      package Thread_Queue is new
         Generic_Linked_List (List_Id_Type => Thread_Priority_Type,
                              Node_Payload_Type => Thread_Type);

      package Thread_Pool is new
         Generic_Object_Pool (Object_Type => Thread_Queue.List_Node_Type,
                              Object_Id_Type => Thread_Id_Type);

      type Thread_Pool_Type is new Thread_Pool.Object_Pool_Type;

      type Runnable_Thread_Queues_Type is array (Thread_Priority_Type) of
         Thread_Queue.List_Anchor_Type;
   end Thread;

   package Interrupt_Nesting is
      type Interrupt_Nesting_Level_Stack_Type is limited private;

      subtype Interrupt_Priority_Type is Execution_Priority_Type
         range Execution_Priority_Type'First ..
               HiRTOS_Config_Parameters.Num_Interrupt_Priorities - 1;

      --
      --  NOTE: Interrupt nesting level 0 corresponds to the CPU running in
      --  a thread context (Executing a thread's code).
      --  Interrupt nesting levels greater than 0 correspond to the CPU running
      --  in an interrupt context (executing an ISR)
      --
      type Interrupt_Nesting_Level_Id_Type is
         range 0 .. HiRTOS_Config_Parameters.Num_Interrupt_Priorities;

      Interrupt_Nesting_Level_None : constant Interrupt_Nesting_Level_Id_Type :=
         Interrupt_Nesting_Level_Id_Type'First;

      subtype Active_Interrupt_Nesting_Level_Id_Type is
         Interrupt_Nesting_Level_Id_Type range
            Interrupt_Nesting_Level_None + 1 .. Interrupt_Nesting_Level_Id_Type'Last;

   private
      --
      --  Interrupt nesting level object
      --
      --  @field Initialized flag indicating if the interrupt nesting level object has been
      --  initialized.
      --  @field IRQ Id
      --  @Nesting_Level_Id Interrupt nesting level at which the ISR is currently running
      --  @Priority Interrupt normal priority
      --  @field Saved_Stack_Pointer saved stack pointer CPU register the last time this ISR
      --  was preempted.
      --
      type Interrupt_Nesting_Level_Type is limited record
         Initialized : Boolean := False;
         Interrupt_Nesting_Level_Id : Active_Interrupt_Nesting_Level_Id_Type;
         Priority : Interrupt_Priority_Type;
         Saved_Stack_Pointer : HiRTOS_Platform_Interface.Cpu_Register_Type;
      end record;

      type Interrupt_Nesting_Level_Array_Type is
         array (Active_Interrupt_Nesting_Level_Id_Type) of Interrupt_Nesting_Level_Type;

      type Interrupt_Nesting_Level_Stack_Type is limited record
         Interrupt_Nesting_Level_Array : Interrupt_Nesting_Level_Array_Type;
         Current_Interrupt_Nesting_Level_Id : Interrupt_Nesting_Level_Id_Type :=
            Interrupt_Nesting_Level_None;
      end record;
   end Interrupt_Nesting;

private
   --
   --  State variables of a HiRTOS kernel instance
   --
   --  @field Initialized flag indicating if HiRTOS has been initialized.
   --  @field Cpu_Id Id of the CPU core associated to this HiRTOS instance
   --  @field Current_Thread_Id Thread Id of the currently running thread.
   --  @field Current_Interrupt_Nesting_Level_Id current interrupt nesting level.
   --  @field Timer_Ticks_Since_Boot counter of timer ticks since boot.
   --  @field Threads_Pool all thread objects
   --  @field Mutexes_Pool all mutex objects
   --  @field Condvars_Pool all condvar objects
   --  @field Timers_Pool all timer objects
   --  @field Interrupt_Nesting_Levels_Pool array of stacked active interrupt
   --  handler objects. The highest entry in use is indicated by `Current_Interrupt_Nesting_Level`
   --  can be created.
   --  @field Runnable_Thread_Queues array of runable thread queues, one queue per thread priority.
   --  @field Timer_Wheel_Hash_Table array of timer hash chains, one entry per
   --  timer wheel spoke.
   --
   type HiRTOS_Instance_Type is limited record
      Initialized : Boolean;
      Cpu_Id : HiRTOS_Platform_Interface.Cpu_Core_Id_Type;
      Current_Thread_Id : Thread.Thread_Id_Type := Thread.Invalid_Thread_Id;
      Timer_Ticks_Since_Boot : Timer.Timer_Ticks_Count_Type;
      Thread_Pool : Thread.Thread_Pool_Type;
      Mutex_Pool : Mutex.Mutex_Pool_Type;
      Condvar_Pool : Condvar.Condvar_Pool_Type;
      Timer_Pool : Timer.Timer_Pool_Type;
      Interrupt_Nesting_Level_Stack : Interrupt_Nesting.Interrupt_Nesting_Level_Stack_Type;
      Runnable_Thread_Queues : Thread.Runnable_Thread_Queues_Type;
      Timer_Wheel : Timer.Timer_Wheel_Type;
   end record with Alignment => HiRTOS_Platform_Interface.Cache_Line_Size_Bytes;

   --
   --  One HiRTOS instance per CPU core
   --
   HiRTOS_Instances : array (HiRTOS_Platform_Interface.Cpu_Core_Id_Type) of HiRTOS_Instance_Type;

end HiRTOS;
