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
with HiRTOS_Platform_Interface;
private with Generic_Linked_List;

--
--  @summary HiRTOS - High-Integrity RTOS
--
package HiRTOS with SPARK_Mode => On is
   use type Interfaces.Unsigned_16;

   -----------------------------------------------------------------------------
   --  Application interface public declarations                              --
   -----------------------------------------------------------------------------

   type Error_Type is new System.Address;

   type Stats_Counter_Type is new Interfaces.Unsigned_32;

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

   -----------------------------------------------------------------------------
   --  Atomic levels public declarations                                      --
   -----------------------------------------------------------------------------

   --
   --  An atomic level object can be used to disable the thread scheduler
   --  or to disable interrupts at and below a given priority or all interrupts
   --  or for inter-processor mutual exclusion.
   --
   --  NOTE: It is assumed that interrupt priority 0 is the highest interrupt
   --  priority and interrupt priority RTOS_Platform_Parameters.Num_Interrupt_Priorities - 1
   --  is the lowest interrupt priority.
   --
   --  Atomic levels 1 .. HiRTOS_Platform_Parameters.Num_Interrupt_Priorities - 1
   --  mean that interrupts with priority at that atomic level and lower priorities
   --  (larger priority values) are disabled and also the thread scheduler is disabled
   --
   type Atomic_Level_Type is range
      0 .. HiRTOS_Platform_Parameters.Num_Interrupt_Priorities + 1;

   --
   --  Special atomic levels
   --

   --
   --  In this atomic level all interrupt are disabled and the thread scheduler
   --  is disabled. Only the first thread or ISR that calls Enter_Atomic_Level
   --  can run in a given CPU.
   --
   Atomic_Level_No_Interrupts : constant Atomic_Level_Type := Atomic_Level_Type'First;

   --
   --  In this atomic level the thread scheduler is disabled, but
   --  all interrupt priorities are enabled. Only the first thread that calls
   --  Enter_Atomic_Level can run and other
   --  threads cannot run until the first thread calls Exit_Atomic_Level
   --
   Atomic_Level_Single_Thread : constant Atomic_Level_Type := Atomic_Level_Type'Last - 1;

   --
   --  No atomic level is in effect. All interrupts are enabled and the thread
   --  scheduler is enabled. Preemption from other threads or ISRs can happen
   --  at any timer. This is the default once RTOS multi-tasking is started.
   --
   Atomic_Level_None : constant Atomic_Level_Type := Atomic_Level_Type'Last;

   --
   --  Enters the give atomic level and returns the previous atomic level
   --
   function Enter_Atomic_Level (New_Atomic_Level : Atomic_Level_Type) return Atomic_Level_Type;

   --
   --  Restores the previous atomic level that was obtained by
   --  an earlier call to Enter_Atomic_Level
   --
   procedure Exit_Atomic_Level (Old_Atomic_Level : Atomic_Level_Type);

   -----------------------------------------------------------------------------
   --  Mutex public declarations                                              --
   -----------------------------------------------------------------------------

   type Mutex_Id_Type is range 0 .. HiRTOS_Config_Parameters.Max_Num_Mutexes
      with Size => Interfaces.Unsigned_8'Size;

   subtype Valid_Mutex_Id_Type is Mutex_Id_Type range
      Mutex_Id_Type'First .. Mutex_Id_Type'Last - 1;

   Invalid_Mutex_Id : constant Mutex_Id_Type := Mutex_Id_Type'Last;

   -----------------------------------------------------------------------------
   --  Condition variable public declarations                                 --
   -----------------------------------------------------------------------------

   type Condvar_Id_Type is range 0 .. HiRTOS_Config_Parameters.Max_Num_Condvars
         with Size => Interfaces.Unsigned_8'Size;

   subtype Valid_Condvar_Id_Type is Condvar_Id_Type range
      Condvar_Id_Type'First .. Condvar_Id_Type'Last - 1;

   Invalid_Condvar_Id : constant Condvar_Id_Type := Condvar_Id_Type'Last;

   -----------------------------------------------------------------------------
   --  Timer public declarations                                              --
   -----------------------------------------------------------------------------

   type Time_Us_Type is new Interfaces.Unsigned_32;

   type Time_Ms_Type is new Interfaces.Unsigned_32;

   type Timer_Ticks_Count_Type is new Interfaces.Unsigned_32;

   type Timer_Id_Type is range 0 .. HiRTOS_Config_Parameters.Max_Num_Timers
      with Size => Interfaces.Unsigned_8'Size;

   subtype Valid_Timer_Id_Type is Timer_Id_Type range Timer_Id_Type'First .. Timer_Id_Type'Last - 1;

   Invalid_Timer_Id : constant Timer_Id_Type := Timer_Id_Type'Last;

   -----------------------------------------------------------------------------
   --  Thread public declarations                                             --
   -----------------------------------------------------------------------------

   type Thread_Priority_Type is range 0 ..  HiRTOS_Config_Parameters.Num_Thread_Priorities
      with Size => Interfaces.Unsigned_8'Size;

   --
   --  Highest thread priority is 0 and lowest thread proirity is Num_Thread_Priorities - 1
   --
   subtype Valid_Thread_Priority_Type is Thread_Priority_Type range
      Thread_Priority_Type'First .. Thread_Priority_Type'Last - 1;

   Invalid_Thread_Priority : constant Thread_Priority_Type := Thread_Priority_Type'Last;

   subtype Thread_Stack_Size_Type is Interfaces.Unsigned_16 with
      Dynamic_Predicate =>
         Thread_Stack_Size_Type >= HiRTOS_Config_Parameters.Thread_Stack_Min_Size
         or else
         Thread_Stack_Size_Type = 0;

   type Thread_Id_Type is range 0 .. HiRTOS_Config_Parameters.Max_Num_Threads
      with Size => Interfaces.Unsigned_8'Size;

   subtype Valid_Thread_Id_Type is Thread_Id_Type range
      Thread_Id_Type'First .. Thread_Id_Type'Last - 1;

   Invalid_Thread_Id : constant Thread_Id_Type := Thread_Id_Type'Last;

   Max_Privilege_Nesting : constant := 64;

   --
   --  Privilege nesting counter. 0 means the CPU is in unprivileged mode
   --  and > 0 means the CPU is tunning in privileged mode. It is incremented
   --  every time that Enter_Cpu_Privileged_Mode is called and decremented
   --  every time that Exit_Cpu_Privileged_Mode is called.
   --
   type Privilege_Nesting_Counter_Type is range 0 .. Max_Privilege_Nesting;

   --
   --  Thread stats
   --
   --  @field Times_Time_Slice_Consumed: Number of times the thread has used its whole time slice
   --  @field Times_Preempted_By_Thread: Number of times the thread has been preempted by
   --         a higher prioritiy thread, before consuming its whole time slice.
   --  @field Times_Preempted_By_Isr: Number of times the thread has been preemted by an ISR.
   --  @field Times_Switched_In: Number of times the thread has been switched in.
   --  @field Last_Switched_In_Timestamp_Us: Timestamp (in microseconds) that the thread was
   --         switched in for the last time.
   --  @field Total_Cpu_Utilization_Us: Total Cpu utilization (in microseconds) for the thread.
   --  @field Average_Cpu_Utlization_Per_Time_Slice_Us: Average Cpu utilization (in microseconds)
   --         for the thread, per Time slice
   --  @field Maximum_Cpu_Utlization_Per_Time_Slice_Us: Maximum Cpu utilization (in microseconds)
   --         for the thread, per Time slice
   --
   type Thread_Stats_Type is record
       Times_Time_Slice_Consumed : Stats_Counter_Type := 0;
       Times_Preempted_By_Thread : Stats_Counter_Type := 0;
       Times_Preempted_By_Isr :  Stats_Counter_Type := 0;
       Times_Switched_In : Stats_Counter_Type := 0;
       Last_Switched_In_Timestamp_Us : Time_Us_Type := 0;
       Total_Cpu_Utilization_Us : Time_Us_Type := 0;
       Average_Cpu_Utlization_Per_Time_Slice_Us : Time_Us_Type := 0;
       Maximum_Cpu_Utlization_Per_Time_Slice_Us : Time_Us_Type := 0;
   end record;

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
      range 0 .. HiRTOS_Platform_Parameters.Num_Interrupt_Priorities;

   subtype Active_Interrupt_Nesting_Counter_Type is
      Interrupt_Nesting_Counter_Type range
         Interrupt_Nesting_Counter_Type'First + 1 .. Interrupt_Nesting_Counter_Type'Last;

   -----------------------------------------------------------------------------
   --  Platform interface public declarations                                 --
   -----------------------------------------------------------------------------

   procedure Enter_Interrupt_Context
      with Inline_Always,
           Suppress => All_Checks;

   procedure Exit_Interrupt_Context
      with Inline_Always,
           Suppress => All_Checks;

private

   -----------------------------------------------------------------------------
   --  Thread private declarations                                            --
   -----------------------------------------------------------------------------

   Thread_Time_Slice_Us : constant := HiRTOS_Config_Parameters.Thread_Time_Slice_Ticks *
                                      HiRTOS_Config_Parameters.Tick_Period_Us;

   type Thread_State_Type is (Thread_Not_Created,
                              Thread_Runnable,
                              Thread_Running,
                              Thread_Blocked);

   type Thread_Queue_Kind_Type is (Run_Queue,
                                   Mutex_Waiters_Queue,
                                   Condvar_Waiters_Queue,
                                   Invalid_Queue);

   type Thread_Queue_Id_Type (Queue_Kind : Thread_Queue_Kind_Type := Invalid_Queue) is record
      case Queue_Kind is
         when Run_Queue =>
            Thread_Priority : Thread_Priority_Type := Invalid_Thread_Priority;
         when Mutex_Waiters_Queue =>
            Mutex_Id : Mutex_Id_Type := Invalid_Mutex_Id;
         when Condvar_Waiters_Queue =>
            Condvar_Id : Condvar_Id_Type := Invalid_Condvar_Id;
         when Invalid_Queue =>
            null;
      end case;
   end record;

   Invalid_Thread_Queue_Id : constant Thread_Queue_Id_Type := (Queue_Kind => Invalid_Queue);

   function Get_Next_Thread (Thread_Id : Thread_Id_Type) return Thread_Id_Type
      with Inline_Always;

   procedure Set_Next_Thread (Thread_Id : Thread_Id_Type;
                             Next_Thread_Id : Thread_Id_Type)
      with Inline_Always;

   function Get_Prev_Thread (Thread_Id : Thread_Id_Type) return Thread_Id_Type
      with Inline_Always;

   procedure Set_Prev_Thread (Thread_Id : Thread_Id_Type;
                             Prev_Thread_Id : Thread_Id_Type)
      with Inline_Always;

   function Get_Containing_Thread_Queue (Thread_Id : Thread_Id_Type) return Thread_Queue_Id_Type
      with Inline_Always;

   procedure Set_Containing_Thread_Queue (Thread_Id : Thread_Id_Type;
                                          List_Id : Thread_Queue_Id_Type)
      with Inline_Always;

   package Thread_Queue_Package is new
      Generic_Linked_List (List_Id_Type => Thread_Queue_Id_Type,
                           Null_List_Id => Invalid_Thread_Queue_Id,
                           Element_Id_Type => Thread_Id_Type,
                           Null_Element_Id => Invalid_Thread_Id,
                           Get_Next_Element => Get_Next_Thread,
                           Set_Next_Element => Set_Next_Thread,
                           Get_Prev_Element => Get_Prev_Thread,
                           Set_Prev_Element => Set_Prev_Thread,
                           Get_Containing_List => Get_Containing_Thread_Queue,
                           Set_Containing_List => Set_Containing_Thread_Queue);

   function Get_Next_Mutex (Mutex_Id : Mutex_Id_Type) return Mutex_Id_Type
      with Inline_Always;

   procedure Set_Next_Mutex (Mutex_Id : Mutex_Id_Type;
                             Next_Mutex_Id : Mutex_Id_Type)
      with Inline_Always;

   function Get_Prev_Mutex (Mutex_Id : Mutex_Id_Type) return Mutex_Id_Type
      with Inline_Always;

   procedure Set_Prev_Mutex (Mutex_Id : Mutex_Id_Type;
                             Prev_Mutex_Id : Mutex_Id_Type)
      with Inline_Always;

   function Get_Containing_Mutex_List (Mutex_Id : Mutex_Id_Type) return Thread_Id_Type
      with Inline_Always;

   procedure Set_Containing_Mutex_List (Mutex_Id : Mutex_Id_Type;
                                        List_Id : Thread_Id_Type)
      with Inline_Always;

   package Mutex_List_Package is new
      Generic_Linked_List (List_Id_Type => Thread_Id_Type,
                           Null_List_Id => Invalid_Thread_Id,
                           Element_Id_Type => Mutex_Id_Type,
                           Null_Element_Id => Invalid_Mutex_Id,
                           Get_Next_Element => Get_Next_Mutex,
                           Set_Next_Element => Set_Next_Mutex,
                           Get_Prev_Element => Get_Prev_Mutex,
                           Set_Prev_Element => Set_Prev_Mutex,
                           Get_Containing_List => Get_Containing_Mutex_List,
                           Set_Containing_List => Set_Containing_Mutex_List);

   --
   --  Thread control block
   --
   --  @field Initialized: flag indicating if the thread object has been
   --  initialized.
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
      Stack_Size : Thread_Stack_Size_Type := 0;
      Builtin_Condvar_Id : Condvar_Id_Type := Invalid_Condvar_Id;
      Waiting_On_Condvar_Id : Condvar_Id_Type := Invalid_Condvar_Id;
      Waiting_On_Mutex_Id : Mutex_Id_Type := Invalid_Mutex_Id;
      Owned_Mutexes_List : Mutex_List_Package.List_Anchor_Type;
      Saved_Stack_Pointer : HiRTOS_Platform_Interface.Cpu_Register_Type;
      Privilege_Nesting_Counter : Privilege_Nesting_Counter_Type := 0;
      Time_Slice_Left_Us : Time_Us_Type := Thread_Time_Slice_Us;
      List_Node : Thread_Queue_Package.List_Node_Type;
      Stats : Thread_Stats_Type;
   end record with Alignment =>
                     HiRTOS_Platform_Parameters.Mem_Prot_Region_Alignment;

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

   type Thread_Array_Type is array (Valid_Thread_Id_Type) of Thread_Type;

   type Runnable_Thread_Queues_Type is array (Valid_Thread_Priority_Type) of
      Thread_Queue_Package.List_Anchor_Type;

   -----------------------------------------------------------------------------
   --  Mutex private declarations                                             --
   -----------------------------------------------------------------------------

   --
   --  Mutex object
   --
   --  @field Initialized: flag indicating if the mutex object has been initialized.
   --  @field Id: mutex Id
   --  @field Owner_Thread_Id: Thread Id of the thread that currently owns the mutex
   --  @field Recursive_Count: Recursive mutex acquires count
   --  @field Priority: Thread priority associated to the mutex
   --  @field Waiters_Queue: Queue of threads waiting to acquire the mutex
   --  @field List_Node: this mutex's node in a list of mutexes, if this mutex is in a list.
   --
   type Mutex_Type is limited record
      Initialized : Boolean := False;
      Id : Mutex_Id_Type := Invalid_Mutex_Id;
      Owner_Thread_Id : Thread_Id_Type := Invalid_Thread_Id;
      Recursive_Count : Interfaces.Unsigned_8 := 0;
      Priority : Thread_Priority_Type;
      Waiters_Queue : Thread_Queue_Package.List_Anchor_Type;
      List_Node : Mutex_List_Package.List_Node_Type;
   end record;

   type Mutex_Array_Type is array (Valid_Mutex_Id_Type) of Mutex_Type;

   -----------------------------------------------------------------------------
   --  Condition variable private declarations                                --
   -----------------------------------------------------------------------------

   --
   --  Condition variable object
   --
   --  @field Initialized: Flag indicating if the condvar object has been initialized.
   --  @field Id: Condvar Id
   --  @field Wakeup_Atomic_Level: Atomic level in effect before calling Wait
   --         on the condvar and to be re-entered when wakeup up from Wait.
   --  @field Wakeup_Mutex_Id: Mutex Id of the mutex that was held before
   --         calling Wait on the condvar and to be re-acquired  when
   --         waking up from Wait. It is meaningful only if `Wake_Atomic_Level`
   --         is `Atomic_Level_None`.
   --  @field Waiters_Queue: Queue of threads waiting on the condvar.
   --
   type Condvar_Type is limited record
      Initialized : Boolean := False;
      Id : Condvar_Id_Type := Invalid_Condvar_Id;
      Wakeup_Atomic_Level : Atomic_Level_Type := Atomic_Level_None;
      Wakeup_Mutex_id : Mutex_Id_Type := Invalid_Mutex_Id;
      Waiters_Queue : Thread_Queue_Package.List_Anchor_Type;
   end record;
      --  with Type_Invariant =>
      --    (if Condvar_Type.Wakeup_Atomic_Level /= Atomic_Level_None then
      --        Condvar_Type.Wakeup_Mutex_id = Invalid_Mutex_Id);

   type Condvar_Array_Type is array (Valid_Condvar_Id_Type) of Condvar_Type;

   -----------------------------------------------------------------------------
   --  Timer private declarations                                             --
   -----------------------------------------------------------------------------

   --
   --  Number of spokes of a timer wheel. It must be a power of 2.
   --
   Timer_Wheel_Num_Spokes : constant := 128;

   type Timer_Wheel_Spoke_Index_Type is range 0 .. Timer_Wheel_Num_Spokes;

   subtype Valid_Timer_Wheel_Spoke_Index_Type is Timer_Wheel_Spoke_Index_Type range
      Timer_Wheel_Spoke_Index_Type'First .. Timer_Wheel_Spoke_Index_Type'Last - 1;

   Invalid_Timer_Wheel_Spoke_Index : constant Timer_Wheel_Spoke_Index_Type :=
      Timer_Wheel_Spoke_Index_Type'Last;

   function Get_Next_Timer (Timer_Id : Timer_Id_Type) return Timer_Id_Type
      with Inline_Always;

   procedure Set_Next_Timer (Timer_Id : Timer_Id_Type;
                             Next_Timer_Id : Timer_Id_Type)
      with Inline_Always;

   function Get_Prev_Timer (Timer_Id : Timer_Id_Type) return Timer_Id_Type
      with Inline_Always;

   procedure Set_Prev_Timer (Timer_Id : Timer_Id_Type;
                             Prev_Timer_Id : Timer_Id_Type)
      with Inline_Always;

   function Get_Containing_Timer_List (Timer_Id : Timer_Id_Type) return Timer_Wheel_Spoke_Index_Type
      with Inline_Always;

   procedure Set_Containing_Timer_List (Timer_Id : Timer_Id_Type;
                                        List_Id : Timer_Wheel_Spoke_Index_Type)
      with Inline_Always;

   package Timer_List_Package is new
      Generic_Linked_List (List_Id_Type => Timer_Wheel_Spoke_Index_Type,
                           Null_List_Id => Invalid_Timer_Wheel_Spoke_Index,
                           Element_Id_Type => Timer_Id_Type,
                           Null_Element_Id => Invalid_Timer_Id,
                           Get_Next_Element => Get_Next_Timer,
                           Set_Next_Element => Set_Next_Timer,
                           Get_Prev_Element => Get_Prev_Timer,
                           Set_Prev_Element => Set_Prev_Timer,
                           Get_Containing_List => Get_Containing_Timer_List,
                           Set_Containing_List => Set_Containing_Timer_List);

   --
   --  Software timer object
   --
   --  @field Initialized: flag indicating if the timer object has been initialized.
   --  @field Id: timer Id
   --
   type Timer_Type is limited record
      Initialized : Boolean := False;
      Id : Timer_Id_Type := Invalid_Timer_Id;
      List_Node : Timer_List_Package.List_Node_Type;
   end record;

   type Timer_Array_Type is array (Valid_Timer_Id_Type) of Timer_Type;

   type Timer_Wheel_Spokes_Hash_Table_Type is array (Valid_Timer_Wheel_Spoke_Index_Type) of
      Timer_List_Package.List_Anchor_Type;

   --
   --  Timer wheel object
   --
   --  @field Wheel_Spokes_Hash_Table: array of hash chains, one hash chain per wheel spoke
   --  @field Current_Wheel_Spoke_Index: index of the current entry in `Wheel_Spokes_Hash_Table`
   --
   type Timer_Wheel_Type is limited record
      Wheel_Spokes_Hash_Table : Timer_Wheel_Spokes_Hash_Table_Type;
      Current_Wheel_Spoke_Index : Valid_Timer_Wheel_Spoke_Index_Type :=
         Valid_Timer_Wheel_Spoke_Index_Type'First;
   end record;

   -----------------------------------------------------------------------------
   --  Interrupt nesting private declarations                                 --
   -----------------------------------------------------------------------------

   --
   --  Interrupt nesting level object
   --
   --  @field Initialized: flag indicating if the interrupt nesting level object has been
   --         initialized.
   --  @field IRQ Id: IRQ that is being served by the ISR running at this interrupt nesting level.
   --  @field Saved_Stack_Pointer: saved stack pointer CPU register the last time the current ISR,
   --         at this interrupt nesting level, was preempted.
   --  @field Atomic_Level: Current atomic level
   --
   type Interrupt_Nesting_Level_Type is limited record
      Initialized : Boolean := False;
      --  Irq_Id : HiRTOS_Platform_Interface.Irq_Id_Type :=
      --     HiRTOS_Platform_Interface.Invalid_Irq_Id;
      Interrupt_Nesting_Counter : Active_Interrupt_Nesting_Counter_Type;
      Saved_Stack_Pointer : HiRTOS_Platform_Interface.Cpu_Register_Type;
      Atomic_Level : Atomic_Level_Type := Atomic_Level_None;
   end record;

   type Interrupt_Nesting_Level_Array_Type is
      array (Active_Interrupt_Nesting_Counter_Type) of Interrupt_Nesting_Level_Type;

   type Interrupt_Nesting_Level_Stack_Type is limited record
      Interrupt_Nesting_Level_Array : Interrupt_Nesting_Level_Array_Type;
      Current_Interrupt_Nesting_Counter : Interrupt_Nesting_Counter_Type :=
         Interrupt_Nesting_Counter_Type'First + 1;
   end record;

   -----------------------------------------------------------------------------
   --  Whole RTOS private declarations                                        --
   -----------------------------------------------------------------------------

   type Thread_Scheduler_State_Type is (Thread_Scheduler_Stopped,
                                        Thread_Scheduler_Running);

   type Cpu_Execution_Mode_Type is (
            --  Upon releasing the CPU from reset,  it jumps to execute the reset
            --  exception handler
            Cpu_Executing_Reset_Handler,

            --  Asynchronous interrupt (IRQ) or synchronous exception`
            Cpu_Executing_Interrupt_Handler,

            --  Upon starting the RTOS scheduler, the CPU executes thread code
            --  as long as interrupts or exceptions don't get triggered.
            Cpu_Executing_Thread);

   --
   --  State variables of a HiRTOS kernel instance. (There is a HiRTOS instance per CPU core.)
   --
   --  @field Initialized: flag indicating if HiRTOS has been initialized.
   --  @field Cpu_Id Id: of the CPU core associated to this HiRTOS instance
   --  @field Current_Thread_Id: Thread Id of the currently running thread.
   --  @field Current_Atomic_Level: current atomic level.
   --  @field Current_Privilege_Nesting_Counter: current privilege nesting counter.
   --         Its initial value is 1, as the RTOS initialized while the CPU is running
   --         in privileged mode from the reset exception handler.
   --  @field Current_Cpu_Execution_Mode: current execution mode for the CPU.
   --  @field Timer_Ticks_Since_Boot: counter of timer ticks since boot.
   --  @field Mutex_Instances: Array of all mutex objects
   --  @field Condvar_Instances: Array of all condvar objects
   --  @field Timer_Instances: Array of all timer objects
   --  @field Thread_Instances: Array of all thread objects
   --  @field Interrupt_Nesting_Level_Stack: stack of active interrupt handler objects.
   --         The highest entry in use is indicated by `Current_Interrupt_Nesting_Level`
   --         can be created.
   --  @field Runnable_Thread_Queues: array of runable thread queues, one queue per
   --         thread priority.
   --  @field Timer_Wheel_Hash_Table: array of timer hash chains, one entry per
   --         timer wheel spoke.
   --
   type HiRTOS_Instance_Type is limited record
      Initialized : Boolean := False;
      Cpu_Id : HiRTOS_Platform_Interface.Cpu_Core_Id_Type;
      Thread_Scheduler_State : Thread_Scheduler_State_Type := Thread_Scheduler_Stopped;
      Current_Atomic_Level : Atomic_Level_Type := Atomic_Level_None;
      Current_Privilege_Nesting_Counter : Privilege_Nesting_Counter_Type :=
         Privilege_Nesting_Counter_Type'First + 1;
      Current_Cpu_Execution_Mode : Cpu_Execution_Mode_Type := Cpu_Executing_Reset_Handler;
      Current_Thread_Id : Thread_Id_Type := Invalid_Thread_Id;
      Timer_Ticks_Since_Boot : Timer_Ticks_Count_Type;
      Interrupt_Stack_Base_Addr : System.Address;
      Interrupt_Stack_Size : System.Storage_Elements.Integer_Address;
      Next_Free_Thread_Id : Thread_Id_Type := Thread_Id_Type'First;
      Next_Free_Mutex_Id : Mutex_Id_Type := Mutex_Id_Type'First;
      Next_Free_Condvar_Id : Condvar_Id_Type := Condvar_Id_Type'First;
      Next_Free_Timer_Id : Timer_Id_Type := Timer_Id_Type'First;
      Thread_Instances : Thread_Array_Type;
      Mutex_Instances : Mutex_Array_Type;
      Condvar_Instances : Condvar_Array_Type;
      Timer_Instances : Timer_Array_Type;
      Interrupt_Nesting_Level_Stack : Interrupt_Nesting_Level_Stack_Type;
      Runnable_Thread_Queues : Runnable_Thread_Queues_Type;
      Timer_Wheel : Timer_Wheel_Type;
   end record with Alignment => HiRTOS_Platform_Parameters.Cache_Line_Size_Bytes;

   --
   --  One HiRTOS instance per CPU core
   --
   HiRTOS_Instances : array (HiRTOS_Platform_Interface.Cpu_Core_Id_Type) of HiRTOS_Instance_Type;

end HiRTOS;
