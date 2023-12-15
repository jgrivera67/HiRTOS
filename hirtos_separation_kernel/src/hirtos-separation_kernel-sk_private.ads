--
--  Copyright (c) 2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS.Separation_Kernel.Partition_Private;
with HiRTOS_Cpu_Arch_Interface;
with HiRTOS_Cpu_Multi_Core_Interface;

--
--  @summary Separation Kernel main module
--
private package HiRTOS.Separation_Kernel.SK_Private with
  SPARK_Mode => On
is
   use HiRTOS.Separation_Kernel.Partition_Private;
   use HiRTOS_Cpu_Arch_Interface;
   use HiRTOS_Cpu_Multi_Core_Interface;

   function Partition_Objects_Free_Count return Natural
      with Ghost;

   procedure Allocate_Partition_Object (Partition_Id : out Valid_Partition_Id_Type)
      with Pre => Partition_Objects_Free_Count /= 0;

   type Partition_Scheduler_State_Type is
     (Partition_Scheduler_Stopped, Partition_Scheduler_Running);

   --
   --  Per-CPU State variables of the HiRTOS Separation kernel
   --
   --  @field Last_Chance_Handler_Running: flag indicating if Last_Chance_Handler
   --  is currently running.
   --  @field Cpu_Id Id: of the CPU core associated to this HiRTOS instance
   --  @field Interrupt_Stack_Base_Address: base address of hypervisor-mode stack for this partition
   --  @field Interrupt_Stack_End_Address: end address of hypervisor-mode stack for this partition
   --  @field Current_Partition_Id: Partition Id of the currently running partition.
   --  @field Timer_Ticks_Since_Boot: counter of timer ticks since boot.
   --  @field Next_Free_Partition_Id:Next available entry in Partition_Instances
   --  @field Runnable_Partitions_Queue: priority queue of runnable partitions.
   --  @field Partition_Instances: Array of all partition objects
   --  @field Partition_Queues_Nodes: Array of all linked-list nodes of partition queues
   --
   type Separation_Kernel_Cpu_Instance_Type is limited record
      Last_Chance_Handler_Running : Boolean := False;
      Cpu_Id                      : Cpu_Core_Id_Type;
      Interrupt_Stack_Base_Address : System.Address := System.Null_Address;
      Interrupt_Stack_End_Address : System.Address := System.Null_Address;
      Partition_Scheduler_State   : Partition_Scheduler_State_Type :=
        Partition_Scheduler_Stopped;
      Current_Partition_Id        : Partition_Id_Type := Invalid_Partition_Id;
      Timer_Ticks_Since_Boot      : Timer_Ticks_Count_Type         := 0;
      Next_Free_Partition_Id      : Atomic_Counter_Type            :=
        Atomic_Counter_Initializer (Cpu_Register_Type (Partition_Id_Type'First));
      Runnable_Partitions_Queue   : Partition_Queue_Package.List_Anchor_Type;
      Partition_Instances         : Partition_Array_Type;
      Partition_Queue_Nodes       : Partition_Queue_Package.List_Nodes_Type;
   end record with
     Alignment => HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment;

   type Separation_Kernel_Cpu_Instance_Array_Type is
     array (Valid_Cpu_Core_Id_Type) of Separation_Kernel_Cpu_Instance_Type;

   --
   --  Separation Kernel Instances:
   --
   Separation_Kernel_Cpu_Instances : Separation_Kernel_Cpu_Instance_Array_Type;

   function Partition_Objects_Free_Count return Natural is
      (Natural (Partition_Id_Type'Last -
                Partition_Id_Type (Atomic_Load (Separation_Kernel_Cpu_Instances (Get_Cpu_Id).Next_Free_Partition_Id))));

end HiRTOS.Separation_Kernel.SK_Private;
