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

with HiRTOS.Thread_Private;
with HiRTOS.Mutex_Private;
with HiRTOS.Condvar_Private;
with HiRTOS.Timer_Private;
with HiRTOS.Interrupt_Handling_Private;
with HiRTOS_Cpu_Arch_Interface;
with System.Storage_Elements;

--
--  @summary Whole RTOS private declarations
--
private package HiRTOS.RTOS_Private with
 SPARK_Mode => On
is
  use HiRTOS.Thread_Private;
  use HiRTOS.Mutex_Private;
  use HiRTOS.Condvar_Private;
  use HiRTOS.Timer_Private;
  use HiRTOS.Interrupt_Handling_Private;

  type Thread_Scheduler_State_Type is
   (Thread_Scheduler_Stopped, Thread_Scheduler_Running);

  type Cpu_Execution_Mode_Type is
   (
  --  Upon releasing the CPU from reset,  it jumps to execute the reset
  --  exception handler
  Cpu_Executing_Reset_Handler,

    --  Asynchronous interrupt (IRQ) or synchronous exception`
    Cpu_Executing_Interrupt_Handler,

    --  Upon starting the RTOS scheduler, the CPU executes thread code
    --  as long as interrupts or exceptions don't get triggered.
    Cpu_Executing_Thread);

  package Per_Cpu_Thread_List_Package is new Generic_Linked_List
   (List_Id_Type    => HiRTOS_Cpu_Arch_Interface.Cpu_Core_Id_Type,
    Null_List_Id    => HiRTOS_Cpu_Arch_Interface.Invalid_Cpu_Core_Id,
    Element_Id_Type => Thread_Id_Type, Null_Element_Id => Invalid_Thread_Id);

  package Per_Cpu_Mutex_List_Package is new Generic_Linked_List
   (List_Id_Type    => HiRTOS_Cpu_Arch_Interface.Cpu_Core_Id_Type,
    Null_List_Id    => HiRTOS_Cpu_Arch_Interface.Invalid_Cpu_Core_Id,
    Element_Id_Type => Mutex_Id_Type, Null_Element_Id => Invalid_Mutex_Id);

  package Per_Cpu_Condvar_List_Package is new Generic_Linked_List
   (List_Id_Type    => HiRTOS_Cpu_Arch_Interface.Cpu_Core_Id_Type,
    Null_List_Id    => HiRTOS_Cpu_Arch_Interface.Invalid_Cpu_Core_Id,
    Element_Id_Type => Condvar_Id_Type, Null_Element_Id => Invalid_Condvar_Id);

  package Per_Cpu_Timer_List_Package is new Generic_Linked_List
   (List_Id_Type    => HiRTOS_Cpu_Arch_Interface.Cpu_Core_Id_Type,
    Null_List_Id    => HiRTOS_Cpu_Arch_Interface.Invalid_Cpu_Core_Id,
    Element_Id_Type => Timer_Id_Type, Null_Element_Id => Invalid_Timer_Id);

  --
  --  Per-CPU State variables of the HiRTOS kernel
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
  --  @field Interrupt_Nesting_Level_Stack: stack of active interrupt handler objects.
  --         The highest entry in use is indicated by `Current_Interrupt_Nesting_Level`
  --         can be created.
  --  @field All_Threads: List of all threads created in this CPU
  --  @field Runnable_Thread_Queues: array of runable thread queues, one queue per
  --         thread priority.
  --  @field Timer_Wheel_Hash_Table: array of timer hash chains, one entry per
  --         timer wheel spoke.
  --
  type HiRTOS_Cpu_Instance_Type is limited record
    Initialized            : Boolean                     := False;
    Cpu_Id                 : HiRTOS_Cpu_Arch_Interface.Cpu_Core_Id_Type;
    Thread_Scheduler_State : Thread_Scheduler_State_Type :=
     Thread_Scheduler_Stopped;
    Current_Atomic_Level              : Atomic_Level_Type := Atomic_Level_None;
    Current_Privilege_Nesting_Counter : Privilege_Nesting_Counter_Type :=
     Privilege_Nesting_Counter_Type'First + 1;
    Current_Cpu_Execution_Mode : Cpu_Execution_Mode_Type :=
     Cpu_Executing_Reset_Handler;
    Current_Thread_Id             : Thread_Id_Type := Invalid_Thread_Id;
    Timer_Ticks_Since_Boot        : Timer_Ticks_Count_Type := 0;
    Idle_Thread_Id                : Thread_Id_Type := Invalid_Thread_Id;
    Tick_Timer_Thread_Id          : Thread_Id_Type := Invalid_Thread_Id;
    Interrupt_Stack_Base_Addr     : System.Address;
    Interrupt_Stack_Size          : System.Storage_Elements.Integer_Address;
    Interrupt_Nesting_Level_Stack : Interrupt_Nesting_Level_Stack_Type;
    All_Threads : Per_Cpu_Thread_List_Package.List_Anchor_Type;
    All_Mutexs : Per_Cpu_Mutex_List_Package.List_Anchor_Type;
    All_Condvars : Per_Cpu_Condvar_List_Package.List_Anchor_Type;
    All_Timers : Per_Cpu_Timer_List_Package.List_Anchor_Type;
    Runnable_Thread_Queues        : Priority_Thread_Queues_Type;
    Timer_Wheel                   : Timer_Wheel_Type;
  end record with
   Alignment => HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment;

  type HiRTOS_Cpu_Instance_Array_Type is
   array
    (HiRTOS_Cpu_Arch_Interface.Cpu_Core_Id_Type) of HiRTOS_Cpu_Instance_Type;

  --
  --  State variables of the HiRTOS kernel
  --
  --  @field Next_Free_Thread_Id:Next available entry in Thread_Instances
  --  @field Next_Free_Mutex_Id:Next available entry in Mutex_Instances
  --  @field Next_Free_Condvar_Id:Next available entry in Condvar_Instances
  --  @field Next_Free_Timer_Id:Next available entry in Timer_Instances
  --  @field Thread_Instances: Array of all thread objects
  --  @field Mutex_Instances: Array of all mutex objects
  --  @field Condvar_Instances: Array of all condvar objects
  --  @field Timer_Instances: Array of all timer objects
  --
  type HiRTOS_Type is limited record
    Next_Free_Thread_Id  : Thread_Id_Type  := Thread_Id_Type'First;
    Next_Free_Mutex_Id   : Mutex_Id_Type   := Mutex_Id_Type'First;
    Next_Free_Condvar_Id : Condvar_Id_Type := Condvar_Id_Type'First;
    Next_Free_Timer_Id   : Timer_Id_Type   := Timer_Id_Type'First;
    Thread_Instances     : Thread_Array_Type;
    Mutex_Instances      : Mutex_Array_Type;
    Condvar_Instances    : Condvar_Array_Type;
    Timer_Instances      : Timer_Array_Type;
    RTOS_Cpu_Instances   : HiRTOS_Cpu_Instance_Array_Type;
  end record with
   Alignment => HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment;

  --
  --  Singleton object representing the state of the whole HiRTOS kernel
  --
  HiRTOS_Obj : HiRTOS_Type;

end HiRTOS.RTOS_Private;
