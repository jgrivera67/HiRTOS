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

with System;
with System.Storage_Elements;
with Interfaces;
with HiRTOS_Config_Parameters;
with HiRTOS_Platform_Parameters;
private with Generic_Linked_List;

--
--  @summary HiRTOS - High-Integrity RTOS
--
package HiRTOS with SPARK_Mode => On is
   use type Interfaces.Unsigned_16;

   --
   --  Highest thread priority is 0 and lowest thread proirity is Num_Thread_Priorities - 1
   --
   type Thread_Priority_Type is mod HiRTOS_Config_Parameters.Num_Thread_Priorities
      with Size => Interfaces.Unsigned_8'Size;

   type Error_Type is new System.Address;

   type Cpu_Register_Type is new System.Storage_Elements.Integer_Address;

   --
   --  Initialize RTOS internal state variables for the calling CPU
   --
   --  NOTE: Initialize_Rtos will initialize the MPU regions but will return still in
   --  privilege mode to the reset handler. So, that we don't have to consider
   --  the reset handler as a special interrupt context case when entering/exiting
   --  privileged mode. So only threads will run in unprivileged mode.
   --
   procedure Initialize (Interrupt_Stack_Base_Addr : System.Address;
                         Interrupt_Stack_Size : System.Storage_Elements.Integer_Address)
      with Export,
         Convention => C,
         External_Name => "hirtos_initialize";

   --
   --  Start RTOS tick timer and RTOS thread scheduler for the calling CPU
   --
   procedure Start_Thread_Scheduler
      with Export,
         Convention => C,
         External_Name => "hirtos_start_thread_scheduler";

   function Thread_Scheduler_Started return Boolean;

   --
   --  Tell if current exectuion context on the current CPU core is an
   --  interrupt context (ISR)
   --
   function Current_Execution_Context_Is_Interrupt return Boolean;

   --
   --  Raises the CPU privilege level. If the old privilege level is 0
   --  (user-mode), it transitions the CPU from user-mode to sys-mode with interrupts
   --  enabled. Otherwise, it leaves the CPU in its current privileged-mode and leaves
   --  the interrupt-enable state unchanged.
   --
   procedure Enter_Cpu_Privileged_Mode;

   --
   --  Lowers the CPU privilege level. If the old privilege level is 1
   --  (>= 1 is privileged-mode), it transitions the CPU from sys-mode to
   --  user-mode with interrupts enabled. Otherwise, it leaves the CPU in
   --  privileged mode and leaves the interrupt-enable state unchanged.
   --
   procedure Exit_Cpu_Privileged_Mode;

   --
   --  Tell if we are running in CPU privileged mode
   --
   function Running_In_Privileged_Mode return Boolean;

   --
   --  Ids of CPU cores
   --
   type Cpu_Core_Id_Type is mod HiRTOS_Platform_Parameters.Num_Cpu_Cores;

   -----------------------------------------------------------------------------
   --  Mutex public declarations                                              --
   -----------------------------------------------------------------------------

   Num_Predefined_Mutexes : constant := 2;

   type Mutex_Id_Type is range 0 .. HiRTOS_Config_Parameters.Max_Num_Mutexes +
                                    Num_Predefined_Mutexes
      with Size => Interfaces.Unsigned_8'Size;

   Invalid_Mutex_Id : constant Mutex_Id_Type := Mutex_Id_Type'Last;

   --
   --  Predefined mutex that represents disabling all interrupts in the CPU
   --
   All_Interrupts_Mutex_Id : constant Mutex_Id_Type := Mutex_Id_Type'Last - 1;

   --
   --  Predefined mutex that represents disabling thread preemption (that is, disabling
   --  the RTOS thread scheduler)
   --
   All_Threads_Mutex_Id : constant Mutex_Id_Type := Mutex_Id_Type'Last - 2;

   --
   --  Condition variable public declarations
   --

   type Condvar_Id_Type is range 0 .. HiRTOS_Config_Parameters.Max_Num_Condvars
         with Size => Interfaces.Unsigned_8'Size;

   Invalid_Condvar_Id : constant Condvar_Id_Type := Condvar_Id_Type'Last;

   -----------------------------------------------------------------------------
   --  Timer public declarations                                              --
   -----------------------------------------------------------------------------

   type Time_Us_Type is new Interfaces.Unsigned_32;

   type Time_Ms_Type is new Interfaces.Unsigned_32;

   type Timer_Ticks_Count_Type is new Interfaces.Unsigned_32;

   type Timer_Id_Type is range 0 .. HiRTOS_Config_Parameters.Max_Num_Timers
      with Size => Interfaces.Unsigned_8'Size;

   Invalid_Timer_Id : constant Timer_Id_Type := Timer_Id_Type'Last;

   -----------------------------------------------------------------------------
   --  Thread public declarations                                             --
   -----------------------------------------------------------------------------

   subtype Thread_Stack_Size_Type is Interfaces.Unsigned_16 with
      Dynamic_Predicate =>
         Thread_Stack_Size_Type >= HiRTOS_Config_Parameters.Thread_Stack_Min_Size
         or else
         Thread_Stack_Size_Type = 0;

   type Thread_Id_Type is range 0 .. HiRTOS_Config_Parameters.Max_Num_Threads
      with Size => Interfaces.Unsigned_8'Size;

   Invalid_Thread_Id : constant Thread_Id_Type := Thread_Id_Type'Last;

   Max_Privilege_Nesting : constant := 64;

   type Privilege_Nesting_Counter_Type is range 0 .. Max_Privilege_Nesting;

   -----------------------------------------------------------------------------
   --  Interrupt nesting public declarations                                  --
   -----------------------------------------------------------------------------

   --
   --  NOTE: Interrupt nesting level 0 corresponds to the CPU running in
   --  a thread context (Executing a thread's code).
   --  Interrupt nesting levels greater than 0 correspond to the CPU running
   --  in an interrupt context (executing an ISR)
   --
   type Interrupt_Nesting_Counter_Type is
      range 0 .. HiRTOS_Config_Parameters.Num_Interrupt_Priorities;

   subtype Active_Interrupt_Nesting_Counter_Type is
      Interrupt_Nesting_Counter_Type range
         Interrupt_Nesting_Counter_Type'First + 1 .. Interrupt_Nesting_Counter_Type'Last;

private

   -----------------------------------------------------------------------------
   --  Mutex private declarations                                             --
   -----------------------------------------------------------------------------

   --
   --  Mutex object
   --
   --  @field Initialized flag indicating if the mutex object has been
   --  initialized.
   --  @field Id mutex Id
   --  @field Recursive_Count REcursive mutex acquires count.
   --  @field Priority Thread priority associated to the mutex
   --
   type Mutex_Type is limited record
      Initialized : Boolean := False;
      Id : Mutex_Id_Type := Invalid_Mutex_Id;
      Recursive_Count : Interfaces.Unsigned_8 := 0;
      Priority : Thread_Priority_Type;
   end record;

   type Mutex_Pointer_Type is access all Mutex_Type;

   type Mutex_Array_Type is array (Mutex_Id_Type'First .. Mutex_Id_Type'Last -
                                                          Num_Predefined_Mutexes - 1) of
      aliased Mutex_Type;

   -----------------------------------------------------------------------------
   --  Condition variable private declarations                                --
   -----------------------------------------------------------------------------

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

   type Condvar_Pointer_Type is access all Condvar_Type;

   type Condvar_Array_Type is array (Condvar_Id_Type'First .. Condvar_Id_Type'Last - 1) of
      aliased Condvar_Type;

   -----------------------------------------------------------------------------
   --  Timer private declarations                                             --
   -----------------------------------------------------------------------------

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

   type Timer_Pointer_Type is access all Timer_Type;

   package Timer_List is new
      Generic_Linked_List (List_Id_Type => Timer_Wheel_Spoke_Index_Type,
                           Node_Payload_Type => Timer_Type,
                           Node_Payload_Pointer_Type => Timer_Pointer_Type);

   type Timer_Node_Array_Type is array (Timer_Id_Type'First .. Timer_Id_Type'Last - 1) of
      aliased Timer_List.Node_Type;

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

   -----------------------------------------------------------------------------
   --  Thread private declarations                                            --
   -----------------------------------------------------------------------------

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
   --  @field Privilege_Nesting_Counter Counter of unpaired calls to
   --  `Increment_Privilege_Nesting`
   --
   type Thread_Type is limited record
      Initialized : Boolean := False;
      Id : Thread_Id_Type := Invalid_Thread_Id;
      State : Thread_State_Type := Thread_Not_Created;
      Priority : Thread_Priority_Type;
      Timer_Id : Timer_Id_Type := Invalid_Timer_Id;
      Stack_Base_Addr : System.Address := System.Null_Address;
      Stack_Size : Thread_Stack_Size_Type := 0;
      Condvar_Id : Condvar_Id_Type := Invalid_Condvar_Id;
      Saved_Stack_Pointer : Cpu_Register_Type;
      Privilege_Nesting_Counter : Privilege_Nesting_Counter_Type := 0;
   end record with Alignment =>
                     HiRTOS_Platform_Parameters.Mem_Prot_Region_Alignment;

   type Thread_Pointer_Type is access all Thread_Type;

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
                           Node_Payload_Type => Thread_Type,
                           Node_Payload_Pointer_Type => Thread_Pointer_Type);

   type Thread_Node_Array_Type is array (Thread_Id_Type'First .. Thread_Id_Type'Last - 1) of
      aliased Thread_Queue.Node_Type;

   type Runnable_Thread_Queues_Type is array (Thread_Priority_Type) of
      Thread_Queue.List_Anchor_Type;

   function Get_Thread_Pointer (Thread_Id : Thread_Id_Type) return Thread_Pointer_Type
      with Inline_Always;

   -----------------------------------------------------------------------------
   --  Interrupt nesting private declarations                                 --
   -----------------------------------------------------------------------------

   --
   --  Interrupt nesting level object
   --
   --  @field Initialized flag indicating if the interrupt nesting level object has been
   --  initialized.
   --  @field IRQ Id
   --  @Nesting_Counter Interrupt nesting counter at which the ISR is currently running
   --  @field Saved_Stack_Pointer saved stack pointer CPU register the last time this ISR
   --  was preempted.
   --
   type Interrupt_Nesting_Level_Type is limited record
      Initialized : Boolean := False;
      Interrupt_Nesting_Counter : Active_Interrupt_Nesting_Counter_Type;
      Saved_Stack_Pointer : Cpu_Register_Type;
   end record;

   type Interrupt_Nesting_Level_Array_Type is
      array (Active_Interrupt_Nesting_Counter_Type) of Interrupt_Nesting_Level_Type;

   type Interrupt_Nesting_Level_Stack_Type is limited record
      Interrupt_Nesting_Level_Array : Interrupt_Nesting_Level_Array_Type;
      Current_Interrupt_Nesting_Counter : Interrupt_Nesting_Counter_Type :=
         Interrupt_Nesting_Counter_Type'First;
   end record;

   --
   --  State variables of a HiRTOS kernel instance
   --
   --  @field Initialized flag indicating if HiRTOS has been initialized.
   --  @field Cpu_Id Id of the CPU core associated to this HiRTOS instance
   --  @field Current_Thread_Id Thread Id of the currently running thread.
   --  @field Current_Interrupt_Nesting_Counter current interrupt nesting level.
   --  @field Timer_Ticks_Since_Boot counter of timer ticks since boot.
   --  @field Mutex_array all mutex objects
   --  @field Condvar_array all condvar objects
   --  @field Timer_Node_Array all timer objects wrapped in list node objects
   --  @field Thread_Node_Array all thread objects wrapped in list node objects.
   --  @field Interrupt_Nesting_Level_Stack stack of active interrupt handler objects.
   --  The highest entry in use is indicated by `Current_Interrupt_Nesting_Level`
   --  can be created.
   --  @field Runnable_Thread_Queues array of runable thread queues, one queue per thread priority.
   --  @field Timer_Wheel_Hash_Table array of timer hash chains, one entry per
   --  timer wheel spoke.
   --
   type HiRTOS_Instance_Type is limited record
      Initialized : Boolean;
      Cpu_Id : Cpu_Core_Id_Type;
      Current_Thread_Id : Thread_Id_Type := Invalid_Thread_Id;
      Timer_Ticks_Since_Boot : Timer_Ticks_Count_Type;
      Interrupt_Stack_Base_Addr : System.Address;
      Interrupt_Stack_Size : System.Storage_Elements.Integer_Address;
      Next_Free_Mutex_Id : Mutex_Id_Type := Mutex_Id_Type'First;
      Next_Free_Condvar_Id : Condvar_Id_Type := Condvar_Id_Type'First;
      Next_Free_Timer_Id : Timer_Id_Type := Timer_Id_Type'First;
      Next_Free_Thread_Id : Thread_Id_Type := Thread_Id_Type'First;
      Mutex_Array : Mutex_Array_Type;
      Condvar_Array : Condvar_Array_Type;
      Timer_Node_Array : Timer_Node_Array_Type;
      Thread_Node_Array : Thread_Node_Array_Type;
      Interrupt_Nesting_Level_Stack : Interrupt_Nesting_Level_Stack_Type;
      Runnable_Thread_Queues : Runnable_Thread_Queues_Type;
      Timer_Wheel : Timer_Wheel_Type;
   end record with Alignment => HiRTOS_Platform_Parameters.Cache_Line_Size_Bytes;

   --
   --  One HiRTOS instance per CPU core
   --
   HiRTOS_Instances : array (Cpu_Core_Id_Type) of HiRTOS_Instance_Type;


   procedure Enter_Interrupt_Context
      with Inline_Always,
           Suppress => All_Checks;

   procedure Exit_Interrupt_Context
      with Inline_Always,
           Suppress => All_Checks;

   --
   --  Select the next thread to run and perform a synchronous
   --  context switch.
   --
   procedure Switch_Thread_Context;
end HiRTOS;
