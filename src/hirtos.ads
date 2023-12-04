--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with System;
with Interfaces;
with HiRTOS_Config_Parameters;
with HiRTOS_Cpu_Arch_Parameters;
with HiRTOS_Cpu_Arch_Interface;
with HiRTOS_Cpu_Multi_Core_Interface;
with Generic_Execution_Stack;
private with Generic_Linked_List;

--
--  @summary HiRTOS - High-Integrity RTOS
--
package HiRTOS with
  SPARK_Mode => On
is
   use type Interfaces.Unsigned_16;

   -----------------------------------------------------------------------------
   --  Application interface public declarations                              --
   -----------------------------------------------------------------------------

   type Error_Type is new System.Address;

   No_Error : constant Error_Type := Error_Type (System.Null_Address);

   type Stats_Counter_Type is new Interfaces.Unsigned_32;

   type Absolute_Time_Us_Type is new Interfaces.Unsigned_64;

   type Relative_Time_Us_Type is new Interfaces.Unsigned_32;

   type Time_Ms_Type is new Interfaces.Unsigned_32;

   --
   --  Tell if current exectuion context on the current CPU core is an
   --  interrupt context (ISR).
   --
   --  NOTE: This function can only be called from privileged mode as it
   --  invoked `Get_Cpu_Id()` which can only be invoked in privileged mode.
   --
   function Current_Execution_Context_Is_Interrupt return Boolean
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode;

   --
   --  Initialize HiRTOS library
   --
   procedure Initialize with
     Pre => HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled,
     Post => not HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled,
     Export, Convention => C,
     External_Name => "hirtos_initialize";

   --
   --  Start RTOS tick timer and RTOS thread scheduler for the calling CPU
   --
   procedure Start_Thread_Scheduler with
     Pre => Current_Execution_Context_Is_Interrupt,
     Export, Convention => C, External_Name => "hirtos_start_thread_scheduler",
     No_Return;

   function Thread_Scheduler_Started return Boolean;

   --
   --  Raises the CPU privilege level. If the old privilege level is 0
   --  (user-mode), it transitions the CPU from user-mode to sys-mode with interrupts
   --  enabled. Otherwise, it leaves the CPU in its current privileged-mode and leaves
   --  the interrupt-enable state unchanged.
   --
   procedure Enter_Cpu_Privileged_Mode
    with Post => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode;

   --
   --  Lowers the CPU privilege level. If the old privilege level is 1
   --  (>= 1 is privileged-mode), it transitions the CPU from sys-mode to
   --  user-mode with interrupts enabled. Otherwise, it leaves the CPU in
   --  privileged mode and leaves the interrupt-enable state unchanged.
   --
   procedure Exit_Cpu_Privileged_Mode
    with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode;

   --
   --  Tell if we are running in CPU privileged mode
   --
   function Cpu_In_Privileged_Mode return Boolean renames
     HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode;

   --
   --  Tell if we are running with CPU interrupts disabled
   --
   function Cpu_Interrupting_Disabled return Boolean renames
      HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled;

   --
   --  Get current time in microseconds since boot
   --
   function Get_Current_Time_Us return Absolute_Time_Us_Type;

   subtype Cpu_Id_Type is HiRTOS_Cpu_Multi_Core_Interface.Valid_Cpu_Core_Id_Type;

   function Get_Current_Cpu_Id return Cpu_Id_Type with
     Export, Convention => C,
     External_Name => "hirtos_get_current_cpu_id";

   -----------------------------------------------------------------------------
   --  Atomic levels public declarations                                      --
   -----------------------------------------------------------------------------

   --
   --  An atomic level object can be used to disable the thread scheduler
   --  or to disable interrupts at and below a given priority or all interrupts
   --  or for inter-processor mutual exclusion.
   --
   --  NOTE: It is assumed that interrupt priority 0 is the highest interrupt
   --  priority and interrupt priority RTOS_Cpu_Arch_Parameters.Num_Interrupt_Priorities - 1
   --  is the lowest interrupt priority.
   --
   --  Atomic levels 1 .. HiRTOS_Cpu_Arch_Parameters.Num_Interrupt_Priorities - 1
   --  mean that interrupts with priority at that atomic level and lower priorities
   --  (larger priority values) are disabled and also the thread scheduler is disabled
   --
   type Atomic_Level_Type is
     range 0 .. HiRTOS_Cpu_Arch_Parameters.Num_Interrupt_Priorities + 1;

   --
   --  Special atomic levels
   --

   --
   --  In this atomic level all interrupt are disabled and the thread scheduler
   --  is disabled. Only the first thread or ISR that calls Enter_Atomic_Level
   --  can run in a given CPU.
   --
   Atomic_Level_No_Interrupts : constant Atomic_Level_Type :=
     Atomic_Level_Type'First;

   --
   --  In this atomic level the thread scheduler is disabled, but
   --  all interrupt priorities are enabled. Only the first thread that calls
   --  Raise_Atomic_Level can run and other
   --  threads cannot run until the first thread calls Restore_Atomic_Level
   --
   Atomic_Level_Single_Thread : constant Atomic_Level_Type :=
     Atomic_Level_Type'Last - 1;

   --
   --  No atomic level is in effect. All interrupts are enabled and the thread
   --  scheduler is enabled. Preemption from other threads or ISRs can happen
   --  at any time. This is the default once RTOS multi-tasking is started.
   --
   Atomic_Level_None : constant Atomic_Level_Type := Atomic_Level_Type'Last;

   --
   --  Raises the current atomic level ofr the calling CPU to the given atomic level
   --  and returns the previous atomic level
   --
   function Raise_Atomic_Level (New_Atomic_Level : Atomic_Level_Type) return Atomic_Level_Type
     with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode and then
                 New_Atomic_Level /= Atomic_Level_None and then
                 New_Atomic_Level <= Get_Current_Atomic_Level,
          Post => Raise_Atomic_Level'Result >= New_Atomic_Level;

   --
   --  Restores the previous atomic level that was obtained by
   --  an earlier call to Raise_Atomic_Level
   --
   procedure Restore_Atomic_Level (Old_Atomic_Level : Atomic_Level_Type)
     with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode;

   function Get_Current_Atomic_Level return Atomic_Level_Type
     with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode;

   -----------------------------------------------------------------------------
   --  Mutex public declarations                                              --
   -----------------------------------------------------------------------------

   type Mutex_Id_Type is
     range 0 .. HiRTOS_Config_Parameters.Max_Num_Mutexes with
     Size => Interfaces.Unsigned_8'Size;

   subtype Valid_Mutex_Id_Type is
     Mutex_Id_Type range Mutex_Id_Type'First .. Mutex_Id_Type'Last - 1;

   Invalid_Mutex_Id : constant Mutex_Id_Type := Mutex_Id_Type'Last;

   -----------------------------------------------------------------------------
   --  Condition variable public declarations                                 --
   -----------------------------------------------------------------------------

   type Condvar_Id_Type is
     range 0 .. HiRTOS_Config_Parameters.Max_Num_Condvars with
     Size => Interfaces.Unsigned_8'Size;

   subtype Valid_Condvar_Id_Type is
     Condvar_Id_Type range Condvar_Id_Type'First .. Condvar_Id_Type'Last - 1;

   Invalid_Condvar_Id : constant Condvar_Id_Type := Condvar_Id_Type'Last;

   -----------------------------------------------------------------------------
   --  Timer public declarations                                              --
   -----------------------------------------------------------------------------

   type Timer_Ticks_Count_Type is new Interfaces.Unsigned_64;

   type Timer_Id_Type is
     range 0 .. HiRTOS_Config_Parameters.Max_Num_Timers with
     Size => Interfaces.Unsigned_8'Size;

   subtype Valid_Timer_Id_Type is
     Timer_Id_Type range Timer_Id_Type'First .. Timer_Id_Type'Last - 1;

   Invalid_Timer_Id : constant Timer_Id_Type := Timer_Id_Type'Last;

   -----------------------------------------------------------------------------
   --  Thread public declarations                                             --
   -----------------------------------------------------------------------------

   type Thread_Priority_Type is
     range 0 .. HiRTOS_Config_Parameters.Num_Thread_Priorities with
     Size => Interfaces.Unsigned_8'Size;

   --
   --  Lowest thread priority is 0 and highest thread priority is Num_Thread_Priorities - 1
   --
   subtype Valid_Thread_Priority_Type is
     Thread_Priority_Type range Thread_Priority_Type'First ..
         Thread_Priority_Type'Last - 1;

   Invalid_Thread_Priority : constant Thread_Priority_Type :=
     Thread_Priority_Type'Last;
   Lowest_Thread_Priority : constant Valid_Thread_Priority_Type :=
     Valid_Thread_Priority_Type'First;
   Highest_Thread_Priority : constant Valid_Thread_Priority_Type :=
     Valid_Thread_Priority_Type'Last;

   subtype Thread_Stack_Size_In_Bytes_Type is Interfaces.Unsigned_16 with
       Dynamic_Predicate =>
        Thread_Stack_Size_In_Bytes_Type >=
        HiRTOS_Config_Parameters.Thread_Stack_Min_Size_In_Bytes
        or else Thread_Stack_Size_In_Bytes_Type = 0;

   type Thread_Id_Type is
     range 0 .. HiRTOS_Config_Parameters.Max_Num_Threads;

   subtype Valid_Thread_Id_Type is
     Thread_Id_Type range Thread_Id_Type'First .. Thread_Id_Type'Last - 1;

   Invalid_Thread_Id : constant Thread_Id_Type := Thread_Id_Type'Last;

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
      Times_Time_Slice_Consumed                : Stats_Counter_Type := 0;
      Times_Preempted_By_Thread                : Stats_Counter_Type := 0;
      Times_Preempted_By_Isr                   : Stats_Counter_Type := 0;
      Times_Switched_In                        : Stats_Counter_Type := 0;
      Delay_Until_In_the_Past_Count            : Stats_Counter_Type := 0;
      Last_Switched_In_Timestamp_Us            : Absolute_Time_Us_Type := 0;
      Total_Cpu_Utilization_Us                 : Absolute_Time_Us_Type := 0;
      Average_Cpu_Utlization_Per_Time_Slice_Us : Relative_Time_Us_Type := 0;
      Maximum_Cpu_Utlization_Per_Time_Slice_Us : Relative_Time_Us_Type := 0;
   end record;

   package Small_Thread_Stack_Package is new Generic_Execution_Stack
     (Stack_Size_In_Bytes =>
        HiRTOS_Config_Parameters.Thread_Stack_Min_Size_In_Bytes);

   package Medium_Thread_Stack_Package is new Generic_Execution_Stack
     (Stack_Size_In_Bytes =>
        4 * HiRTOS_Config_Parameters.Thread_Stack_Min_Size_In_Bytes);

   package Large_Thread_Stack_Package is new Generic_Execution_Stack
     (Stack_Size_In_Bytes =>
        8 * HiRTOS_Config_Parameters.Thread_Stack_Min_Size_In_Bytes);

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
     range 0 .. HiRTOS_Cpu_Arch_Parameters.Num_Interrupt_Priorities;

   subtype Active_Interrupt_Nesting_Counter_Type is
     Interrupt_Nesting_Counter_Type range
       Interrupt_Nesting_Counter_Type'First + 1 ..
         Interrupt_Nesting_Counter_Type'Last;

private

   --
   --  NOTE: These declarations need to be here instead of the corresponding
   --  private child packages, to avoid circular dependencies between
   --  child packages.
   --

   package Thread_Queue_Package is new Generic_Linked_List
     (List_Id_Type    => Thread_Priority_Type,
      Null_List_Id    => Invalid_Thread_Priority,
      Element_Id_Type => Thread_Id_Type,
      Null_Element_Id => Invalid_Thread_Id);

   package Mutex_List_Package is new Generic_Linked_List
     (List_Id_Type    => Thread_Id_Type,
      Null_List_Id    => Invalid_Thread_Id,
      Element_Id_Type => Mutex_Id_Type,
      Null_Element_Id => Invalid_Mutex_Id);

   type Per_Priority_Thread_Queues_Array_Type is
     array
       (Valid_Thread_Priority_Type) of Thread_Queue_Package.List_Anchor_Type;

   type Boolean_Bit_Map_Type is array (Valid_Thread_Priority_Type) of Boolean
      with Component_Size => 1, Size => HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type'Size;

   type Thread_Priority_Queue_Type is record
      Non_Empty_Thread_Queues_Map : Boolean_Bit_Map_Type := [ others => False ];
      Thread_Queues_Array : Per_Priority_Thread_Queues_Array_Type;
   end record;

   procedure Initialize_Thread_Priority_Queue
     (Thread_Priority_Queue : out Thread_Priority_Queue_Type);

   procedure Thread_Priority_Queue_Remove_Head (Thread_Priority_Queue : in out Thread_Priority_Queue_Type;
                                                Thread_Id : out Valid_Thread_Id_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode and then
                  HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled;

   procedure Thread_Priority_Queue_Remove_This (Thread_Priority_Queue : in out Thread_Priority_Queue_Type;
                                                Thread_Id : Valid_Thread_Id_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode and then
                  HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled;

   procedure Thread_Priority_Queue_Add (Thread_Priority_Queue : in out Thread_Priority_Queue_Type;
                                        Thread_Id : Valid_Thread_Id_Type;
                                        Priority : Valid_Thread_Priority_Type;
                                        First_In_Queue : Boolean := False)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode and then
                  HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled;

   function Thread_Priority_Queue_Is_Empty (Thread_Priority_Queue : Thread_Priority_Queue_Type) return Boolean
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode and then
                  HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled;

   --
   --  Initialize RTOS internal state variables for the calling CPU
   --
   --  NOTE: Initialize_Rtos will initialize the MPU regions but will return still in
   --  privilege mode to the reset handler. So, that we don't have to consider
   --  the reset handler as a special interrupt context case when entering/exiting
   --  privileged mode. So only threads will run in unprivileged mode.
   --
   procedure Initialize_RTOS with
     Pre => Current_Execution_Context_Is_Interrupt
            and then
            HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode
            and then
            HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled,
     Post => not HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled
             and then
             HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode;

   procedure Last_Chance_Handler (Msg : System.Address; Line : Integer)
     with No_Return,
          Export,
          Convention => C,
          External_Name => "__gnat_last_chance_handler";

end HiRTOS;
