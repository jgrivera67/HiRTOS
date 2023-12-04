--
--  Copyright (c) 2023, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS_Separation_Kernel_Config_Parameters;
with HiRTOS.Separation_Kernel.Partition;
with HiRTOS.Separation_Kernel.Memory_Protection_Private;
with HiRTOS_Cpu_Arch_Interface.Partition_Context;
with HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Hypervisor;
with HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor;
with HiRTOS_Cpu_Arch_Interface.Tick_Timer;

private package HiRTOS.Separation_Kernel.Partition_Private with
  SPARK_Mode => On
is
   Partition_Time_Slice_Us : constant :=
     HiRTOS_Separation_Kernel_Config_Parameters.Partition_Time_Slice_Ticks *
     HiRTOS_Separation_Kernel_Config_Parameters.Tick_Timer_Period_Us;

   type Partition_State_Type is
     (Partition_Not_Created, Partition_Runnable, Partition_Running, Partition_Suspended);

   Hypervisor_Stack_Size_In_Bytes : constant := 4 * 1024; -- 4KiB

   --
   --  Partition control block
   --
   --  @field Initialized: flag indicating if the partition object has been initialized.
   --  @field Id: partition Id
   --  @field Failover_Partition_Id: partition Id of the partition to failover to if this
   --  partition crashes.
   --  @field State: current state of the partition
   --  @field Time_Slice_Left_Us: partition's current time slice left in microseconds.
   --  @field Executed_WFI Flag indicating that the partition has executed a WFI instruction
   --  @field Hypervisor_Enabled_Regions_Bit_Mask: partition's hypervisor-controlled
   --         enabled regions.
   --  @field Cpu_Context : partition's saved CPU context.
   --  @field Extended_Cpu_Context : partition's saved extended CPU context.
   --  @field Interrupt_Handling_Context : partition's saved interrupt handling context.
   --  @field Internal_Memory_Regions : MPU region descriptors for the partition's
   --  internal memory protection regions.
   --  @field Stats: Per-partition stats
   --
   type Partition_Type is limited record
      Initialized : Boolean := False;
      Id : Partition_Id_Type := Invalid_Partition_Id;
      Failover_Partition_Id : Partition_Id_Type := Invalid_Partition_Id;
      State : Partition_State_Type := Partition_Not_Created;
      Time_Slice_Left_Us : Relative_Time_Us_Type := Partition_Time_Slice_Us;
      Executed_WFI : Boolean := False;
      Hypervisor_Enabled_Regions_Bit_Mask :
         HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor.Memory_Regions_Enabled_Bit_Mask_Type;
      Cpu_Context :
         HiRTOS_Cpu_Arch_Interface.Partition_Context.Cpu_Context_Type;
      Extended_Cpu_Context :
         HiRTOS_Cpu_Arch_Interface.Partition_Context.Extended_Cpu_Context_Type;
      Interrupt_Handling_Context :
         HiRTOS_Cpu_Arch_Interface.Partition_Context.Interrupt_Handling_Context_Type;
      Timer_Context :
         HiRTOS_Cpu_Arch_Interface.Tick_Timer.Timer_Context_Type;
      Internal_Memory_Regions :
         HiRTOS.Separation_Kernel.Memory_Protection_Private.Partition_Internal_Memory_Regions_Type;
      Stats : Partition_Stats_Type;
   end record with
     Alignment => HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment;

   type Partition_Array_Type is array (Valid_Partition_Id_Type) of Partition_Type;

   procedure Save_Partition_Extended_Context (Partition_Obj : in out Partition_Type);

   procedure Restore_Partition_Extended_Context (Partition_Obj : Partition_Type);

   procedure Dequeue_Runnable_Partition (Partition_Id : out Valid_Partition_Id_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode;

   procedure Enqueue_Runnable_Partition (Partition_Id : Valid_Partition_Id_Type;
                                         First_In_Queue : Boolean := False)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode
                  and then
                  HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled;

   procedure Run_Partition_Scheduler
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode,
           Post => HiRTOS.Separation_Kernel.Partition.Get_Current_Partition_Id /= Invalid_Partition_Id;

end HiRTOS.Separation_Kernel.Partition_Private;
