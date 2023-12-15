--
--  Copyright (c) 2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS_Separation_Kernel_Config_Parameters;
private with Generic_Linked_List;

--
--  @summary Separation Kernel main module
--
package HiRTOS.Separation_Kernel with
  SPARK_Mode => On
is
   use HiRTOS_Separation_Kernel_Config_Parameters;

   --
   --  Initialize HiRTOS separation kernel library
   --
   procedure Initialize with
     Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode,
     Export,
     Convention => C,
     External_Name => "hirtos_separation_kernel_initialize";

   procedure Start_Partition_Scheduler with
     Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode;

   type Partition_Id_Type is
     range 0 .. Max_Num_Partitions;

   subtype Valid_Partition_Id_Type is
     Partition_Id_Type range Partition_Id_Type'First .. Partition_Id_Type'Last - 1;

   Invalid_Partition_Id : constant Partition_Id_Type := Partition_Id_Type'Last;

   --
   --  Partition stats
   --
   --  @field Times_Time_Slice_Consumed: Number of times the Partition has used its whole time slice
   --  @field Times_Switched_In: Number of times the Partition has been switched in.
   --  @field Last_Switched_In_Timestamp_Us: Timestamp (in microseconds) that the Partition was
   --         switched in for the last time.
   --  @field Total_Cpu_Utilization_Us: Total Cpu utilization (in microseconds) for the Partition.
   --  @field Average_Cpu_Utlization_Per_Time_Slice_Us: Average Cpu utilization (in microseconds)
   --         for the Partition, per Time slice
   --  @field Maximum_Cpu_Utlization_Per_Time_Slice_Us: Maximum Cpu utilization (in microseconds)
   --         for the Partition, per Time slice
   --
   type Partition_Stats_Type is record
      Times_Time_Slice_Consumed                : Stats_Counter_Type := 0;
      Times_Switched_In                        : Stats_Counter_Type := 0;
      Last_Switched_In_Timestamp_Us            : Absolute_Time_Us_Type := 0;
      Total_Cpu_Utilization_Us                 : Absolute_Time_Us_Type := 0;
      Average_Cpu_Utlization_Per_Time_Slice_Us : Relative_Time_Us_Type := 0;
      Maximum_Cpu_Utlization_Per_Time_Slice_Us : Relative_Time_Us_Type := 0;
   end record;

private

   --
   --  NOTE: These declarations need to be here instead of the corresponding
   --  private child packages, to avoid circular dependencies between
   --  child packages.
   --

   package Partition_Queue_Package is new Generic_Linked_List
     (List_Id_Type    => HiRTOS_Cpu_Multi_Core_Interface.Cpu_Core_Id_Type,
      Null_List_Id    => HiRTOS_Cpu_Multi_Core_Interface.Invalid_Cpu_Core_Id,
      Element_Id_Type => Partition_Id_Type,
      Null_Element_Id => Invalid_Partition_Id);

   procedure Initialize_Separation_Kernel with
     Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode;

end HiRTOS.Separation_Kernel;
