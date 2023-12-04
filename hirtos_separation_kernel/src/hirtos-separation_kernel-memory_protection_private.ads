--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS separation kernel's memory protection internal support
--

with HiRTOS_Cpu_Arch_Interface;
with System.Storage_Elements;
with HiRTOS_Cpu_Arch_Interface.Memory_Protection;

private package HiRTOS.Separation_Kernel.Memory_Protection_Private
   with SPARK_Mode => On
is
   use HiRTOS_Cpu_Arch_Interface.Memory_Protection;
   use System.Storage_Elements;

   --
   --  Mapping of logical memory protection regions to hypervisor memory protection descriptor
   --  indices
   --
   type Memory_Region_Role_Type is
     (Null_Pointer_Dereference_Guard,
      Hypervisor_Code_Region,
      Hypervisor_Rodata_Region,
      Hypervisor_Interrupt_Stack_Overflow_Guard,
      Hypervisor_Mmio_Region,

      Partition0_Sram_Region,
      Partition0_Tcm_Region,
      Partition0_Mmio_Region,
      Partition0_Reserved1_Region,

      Partition1_Sram_Region,
      Partition1_Tcm_Region,
      Partition1_Mmio_Region,
      Partition1_Reserved1_Region,

      Partition2_Sram_Region,
      Partition2_Tcm_Region,
      Partition2_Mmio_Region,
      Partition2_Reserved1_Region,

      Partition3_Sram_Region,
      Partition3_Tcm_Region,
      Partition3_Mmio_Region,
      Partition3_Reserved1_Region,

      --  Valid region roles must be added before this entry:
      Invalid_Region_Role);

   for Memory_Region_Role_Type use
     (Null_Pointer_Dereference_Guard => 0,
      Hypervisor_Code_Region => 1,
      Hypervisor_Rodata_Region => 2,
      Hypervisor_Interrupt_Stack_Overflow_Guard => 3,
      Hypervisor_Mmio_Region => 4,

      Partition0_Sram_Region => 5,
      Partition0_Tcm_Region => 6,
      Partition0_Mmio_Region => 7,
      Partition0_Reserved1_Region => 8,

      Partition1_Sram_Region => 9,
      Partition1_Tcm_Region => 10,
      Partition1_Mmio_Region => 11,
      Partition1_Reserved1_Region => 12,

      Partition2_Sram_Region => 13,
      Partition2_Tcm_Region => 14,
      Partition2_Mmio_Region => 15,
      Partition2_Reserved1_Region => 16,

      Partition3_Sram_Region => 17,
      Partition3_Tcm_Region => 18,
      Partition3_Mmio_Region => 19,
      Partition3_Reserved1_Region => 20,

      --  Valid region roles must be added before this entry:
      Invalid_Region_Role => Max_Num_Memory_Regions);

   procedure Initialize
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode,
           Post => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode;

   type Partition_Hypervisor_Regions_Config_Type is record
      Sram_Region_Id : Memory_Region_Id_Type;
      Tcm_Region_Id : Memory_Region_Id_Type;
      Mmio_Region_Id : Memory_Region_Id_Type;
      Reserved1_Region_Id : Memory_Region_Id_Type;
   end record;

   Partition_Hypervisor_Regions_Config_Array : constant
      array (Valid_Partition_Id_Type) of Partition_Hypervisor_Regions_Config_Type :=
      [0 => (Sram_Region_Id => Partition0_Sram_Region'Enum_Rep,
             Tcm_Region_Id => Partition0_Tcm_Region'Enum_Rep,
             Mmio_Region_Id => Partition0_Mmio_Region'Enum_Rep,
             Reserved1_Region_Id => Partition0_Reserved1_Region'Enum_Rep),
       1 => (Sram_Region_Id => Partition1_Sram_Region'Enum_Rep,
             Tcm_Region_Id => Partition1_Tcm_Region'Enum_Rep,
             Mmio_Region_Id => Partition1_Mmio_Region'Enum_Rep,
             Reserved1_Region_Id => Partition1_Reserved1_Region'Enum_Rep),
       2 => (Sram_Region_Id => Partition2_Sram_Region'Enum_Rep,
             Tcm_Region_Id => Partition2_Tcm_Region'Enum_Rep,
             Mmio_Region_Id => Partition2_Mmio_Region'Enum_Rep,
             Reserved1_Region_Id => Partition2_Reserved1_Region'Enum_Rep),
       3 => (Sram_Region_Id => Partition3_Sram_Region'Enum_Rep,
             Tcm_Region_Id => Partition3_Tcm_Region'Enum_Rep,
             Mmio_Region_Id => Partition3_Mmio_Region'Enum_Rep,
             Reserved1_Region_Id => Partition3_Reserved1_Region'Enum_Rep)
      ];

   --
   --  Saved MPU region descriptors of a partition's internal memory
   --  regions.
   --
   type Partition_Internal_Memory_Regions_Type is
      array (Memory_Region_Id_Type) of Memory_Region_Descriptor_Type;

   --
   --  Initializes a partition's memory protection region descriptors
   --
   procedure Initialize_Partition_Memory_Regions (
      Partition_Id : Valid_Partition_Id_Type;
      TCM_Base_Address : System.Address;
      TCM_Size_In_Bytes : System.Storage_Elements.Integer_Address;
      SRAM_Base_Address : System.Address;
      SRAM_Size_In_Bytes : System.Storage_Elements.Integer_Address;
      MMIO_Base_Address : System.Address;
      MMIO_Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Partition_Internal_Memory_Regions : out Partition_Internal_Memory_Regions_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode;

   --
   --  Restore a partition's memory protection regions
   --
   procedure Restore_Partition_Memory_Regions (
      Partition_Id : Valid_Partition_Id_Type;
      Partition_Internal_Memory_Regions : Partition_Internal_Memory_Regions_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode and then
                  HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled;

   --
   --  Save a partition's memory protection regions
   --
   procedure Save_Partition_Memory_Regions (
      Partition_Id : Valid_Partition_Id_Type;
      Partition_Internal_Memory_Regions : out Partition_Internal_Memory_Regions_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode;

end HiRTOS.Separation_Kernel.Memory_Protection_Private;
