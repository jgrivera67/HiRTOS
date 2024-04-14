--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS separation kernel's memory protection internal support
--

with HiRTOS_Cpu_Arch_Interface;
with System.Storage_Elements;
with HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor;

private package HiRTOS.Separation_Kernel.Memory_Protection_Private
   with SPARK_Mode => On
is
   use HiRTOS_Cpu_Arch_Interface.Memory_Protection;
   use HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor;
   use System.Storage_Elements;

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

   type Memory_Protection_Context_Type is limited record
      Hypervisor_Enabled_Regions_Bit_Mask :
         HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor.Memory_Regions_Enabled_Bit_Mask_Type;
      Fault_Status_Registers : Fault_Status_Registers_Type;
      Internal_Memory_Regions : Partition_Internal_Memory_Regions_Type;
   end record;

   --
   --  Initializes a partition's memory protection region descriptors
   --
   procedure Initialize_Memory_Protection_Context (
      TCM_Base_Address : System.Address;
      TCM_Size_In_Bytes : System.Storage_Elements.Integer_Address;
      SRAM_Base_Address : System.Address;
      SRAM_Size_In_Bytes : System.Storage_Elements.Integer_Address;
      MMIO_Base_Address : System.Address;
      MMIO_Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Partition_Hypervisor_Regions_Config : Partition_Hypervisor_Regions_Config_Type;
      Memory_Protection_Context : out Memory_Protection_Context_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode;

   --
   --  Restore a partition's memory protection regions
   --
   procedure Restore_Memory_Protection_Context (
      Memory_Protection_Context : Memory_Protection_Context_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode and then
                  HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled;

   --
   --  Save a partition's memory protection regions
   --
   procedure Save_Memory_Protection_Context (
      Memory_Protection_Context : out Memory_Protection_Context_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode;

   --
   --  Re-initializes a partition's internal memory region descriptors and
   --  exception status registers
   --
   procedure Cleanup_Memory_Protection_Context (
      Memory_Protection_Context : out Memory_Protection_Context_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode;

end HiRTOS.Separation_Kernel.Memory_Protection_Private;
