--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS.Thread_Private;
with HiRTOS.Mutex_Private;
with HiRTOS.Condvar_Private;
with HiRTOS.Timer_Private;
with HiRTOS.Interrupt_Handling_Private;
with HiRTOS_Cpu_Arch_Interface;
with HiRTOS_Cpu_Multi_Core_Interface;

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
   use HiRTOS_Cpu_Arch_Interface;
   use HiRTOS_Cpu_Multi_Core_Interface;

   function Thread_Objects_Free_Count return Natural
      with Ghost;

   function Mutex_Objects_Free_Count return Natural
      with Ghost;

   function Condvar_Objects_Free_Count return Natural
      with Ghost;

   function Timer_Objects_Free_Count return Natural
      with Ghost;

   procedure Allocate_Thread_Object (Thread_Id : out Valid_Thread_Id_Type)
      with Pre => Thread_Objects_Free_Count /= 0;

   procedure Allocate_Mutex_Object (Mutex_Id : out Valid_Mutex_Id_Type)
      with Pre => Mutex_Objects_Free_Count /= 0;

   procedure Allocate_Condvar_Object (Condvar_Id : out Valid_Condvar_Id_Type)
      with Pre => Condvar_Objects_Free_Count /= 0;

   procedure Allocate_Timer_Object (Timer_Id : out Valid_Timer_Id_Type)
      with Pre => Timer_Objects_Free_Count /= 0;

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
        Cpu_Executing_Thread
     );

   --
   --  Per-CPU State variables of the HiRTOS kernel
   --
   --  @field Initialized: flag indicating if HiRTOS has been initialized.
   --  @field Last_Chance_Handler_Running: flag indicating if Last_Chance_Handler
   --  is currently running.
   --  @field Cpu_Id Id: of the CPU core associated to this HiRTOS instance
   --  @field Current_Thread_Id: Thread Id of the currently running thread.
   --  @field Current_Atomic_Level: current atomic level.
   --  @field Current_Cpu_Execution_Mode: current execution mode for the CPU.
   --  @field Timer_Ticks_Since_Boot: counter of timer ticks since boot.
   --  @field Next_Free_Thread_Id:Next available entry in Thread_Instances
   --  @field Next_Free_Mutex_Id:Next available entry in Mutex_Instances
   --  @field Next_Free_Condvar_Id:Next available entry in Condvar_Instances
   --  @field Next_Free_Timer_Id:Next available entry in Timer_Instances
   --  @field Interrupt_Nesting_Level_Stack: stack of active interrupt handler objects.
   --         The highest entry in use is indicated by `Current_Interrupt_Nesting_Level`
   --         can be created.
   --  @field Runnable_Threads_Queue: priority queue of runable threads.
   --  @field Timer_Wheel_Hash_Table: array of timer hash chains, one entry per
   --         timer wheel spoke.
   --  @field Thread_Instances: Array of all thread objects
   --  @field Mutex_Instances: Array of all mutex objects
   --  @field Condvar_Instances: Array of all condvar objects
   --  @field Timer_Instances: Array of all timer objects
   --  @field Thread_Queues_Nodes: Array of all linked-list nodes of thread queues
   --  @field Mutex_Lists_Nodes: Array of all linked-list nodes of Mutex lists
   --  @field Timer_Lists_Nodes: Array of all linked-list nodes of Timer lists
   --
   type HiRTOS_Cpu_Instance_Type is limited record
      Initialized            : Boolean                     := False;
      Last_Chance_Handler_Running : Boolean                := False;
      Tick_Timer_Thread_Work_Requested : Boolean           := False with Atomic;
      Cpu_Id                 : Cpu_Core_Id_Type;
      Thread_Scheduler_State : Thread_Scheduler_State_Type :=
       Thread_Scheduler_Stopped;
      Current_Atomic_Level       : Atomic_Level_Type := Atomic_Level_None;
      Current_Cpu_Execution_Mode : Cpu_Execution_Mode_Type := Cpu_Executing_Reset_Handler;
      Current_Thread_Id             : Thread_Id_Type := Invalid_Thread_Id;
      Timer_Ticks_Since_Boot        : Timer_Ticks_Count_Type := 0;
      Idle_Thread_Id                : Thread_Id_Type := Invalid_Thread_Id;
      Tick_Timer_Thread_Id          : Thread_Id_Type := Invalid_Thread_Id;
      Interrupt_Stack_Base_Address  : System.Address := System.Null_Address;
      Interrupt_Stack_End_Address   : System.Address := System.Null_Address;
      Next_Free_Thread_Id  : Atomic_Counter_Type :=
         Atomic_Counter_Initializer (Cpu_Register_Type (Thread_Id_Type'First));
      Next_Free_Mutex_Id   : Atomic_Counter_Type :=
         Atomic_Counter_Initializer (Cpu_Register_Type (Mutex_Id_Type'First));
      Next_Free_Condvar_Id : Atomic_Counter_Type :=
         Atomic_Counter_Initializer (Cpu_Register_Type (Condvar_Id_Type'First));
      Next_Free_Timer_Id   : Atomic_Counter_Type :=
         Atomic_Counter_Initializer (Cpu_Register_Type (Timer_Id_Type'First));
      Interrupt_Nesting_Level_Stack : Interrupt_Nesting_Level_Stack_Type;
      Runnable_Threads_Queue        : Thread_Priority_Queue_Type;
      Timer_Wheel                   : Timer_Wheel_Type;
      Thread_Instances     : Thread_Array_Type;
      Mutex_Instances      : Mutex_Array_Type;
      Condvar_Instances    : Condvar_Array_Type;
      Timer_Instances      : Timer_Array_Type;
      Thread_Queues_Nodes  : Thread_Queue_Package.List_Nodes_Type;
      Mutex_Lists_Nodes    : Mutex_List_Package.List_Nodes_Type;
      Timer_Lists_Nodes    : Timer_List_Package.List_Nodes_Type;
   end record with
      Alignment => HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment;

   type HiRTOS_Cpu_Instance_Array_Type is
      array (Valid_Cpu_Core_Id_Type) of HiRTOS_Cpu_Instance_Type;

   --
   --  State variables of the HiRTOS kernel
   --
   --  @field RTOS_Cpu_Instances: Per-cpu HiRTOS instances
   --
   type HiRTOS_Type is limited record
      RTOS_Cpu_Instances   : HiRTOS_Cpu_Instance_Array_Type;
   end record with
      Alignment => HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment;

   --
   --  Singleton object representing the state of the whole HiRTOS kernel
   --
   HiRTOS_Obj : HiRTOS_Type;

   function Thread_Objects_Free_Count return Natural is
      (Natural (Thread_Id_Type'Last -
                Thread_Id_Type (Atomic_Load (HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id).Next_Free_Thread_Id))));

   function Mutex_Objects_Free_Count return Natural is
      (Natural (Mutex_Id_Type'Last -
                Mutex_Id_Type (Atomic_Load (HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id).Next_Free_Mutex_Id))));

   function Condvar_Objects_Free_Count return Natural is
      (Natural (Condvar_Id_Type'Last -
                Condvar_Id_Type (Atomic_Load (HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id).Next_Free_Condvar_Id))));

   function Timer_Objects_Free_Count return Natural is
      (Natural (Timer_Id_Type'Last -
                Timer_Id_Type (Atomic_Load (HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id).Next_Free_Timer_Id))));

end HiRTOS.RTOS_Private;
