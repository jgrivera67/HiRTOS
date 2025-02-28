--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Memory protection services
--  for ARMv8-R Supervisor MPU
--

with HiRTOS_Cpu_Arch_Parameters;
with System.Storage_Elements;
--??? with Bit_Sized_Integer_Types;
private with HiRTOS_Cpu_Arch_Interface.System_Registers;

package HiRTOS_Cpu_Arch_Interface.Memory_Protection
   with SPARK_Mode => On
is
   use type System.Address;

   type Memory_Region_Descriptor_Type is limited private;

   type Region_Permissions_Type is (None,
                                    Read_Only,
                                    Read_Write,
                                    Read_Execute,
                                    Read_Write_Execute);

   type Region_Attributes_Type is (
      --  MMIO space:
      Device_Memory_Mapped_Io,
      --  RAM space:
      Normal_Memory_Non_Cacheable,
      Normal_Memory_Write_Through_Cacheable,
      Normal_Memory_Write_Back_Cacheable);

   Max_Num_Memory_Regions : constant := 32;

   type Memory_Region_Id_Type is mod Max_Num_Memory_Regions;

   --
   --  Mapping of logical memory protection regions to MPU region Ids
   --
   type Memory_Region_Role_Type is
     (
      Global_Code_Region,
      Global_Rodata_Region,
      Null_Pointer_Dereference_Guard,
      Global_Interrupt_Stack_Overflow_Guard,
      Global_Interrupt_Stack_Region,
      Thread_Stack_Overflow_Guard,
      Thread_Stack_Data_Region,
      Thread_Private_Data_Region,
      Thread_Private_Data2_Region,
      Thread_Private_Mmio_Region,

      --  Valid region roles must be added before this entry:
      Invalid_Region_Role);

   for Memory_Region_Role_Type use
     (
      Global_Code_Region => 0,
      Global_Rodata_Region => 1,
      Null_Pointer_Dereference_Guard => 2,
      Global_Interrupt_Stack_Overflow_Guard => 3,
      Global_Interrupt_Stack_Region => 4,
      Thread_Stack_Overflow_Guard => 5,
      Thread_Stack_Data_Region => 6,
      Thread_Private_Data_Region => 7,
      Thread_Private_Data2_Region => 8,
      Thread_Private_Mmio_Region => 9,

      --  Valid region roles must be added before this entry:
      Invalid_Region_Role => Max_Num_Memory_Regions);

   type Mpu_Regions_Count_Type is (Mpu_16_Regions,
                                   Mpu_20_Regions,
                                   Mpu_24_Regions,
                                   Mpu_32_Regions)
      with Size => 8;

   for Mpu_Regions_Count_Type use
     (Mpu_16_Regions => 16,
      Mpu_20_Regions => 20,
      Mpu_24_Regions => 24,
      Mpu_32_Regions => 32);

   function Get_Num_Regions_Supported return Mpu_Regions_Count_Type
      with Pre => Cpu_In_Privileged_Mode,
           Post => Get_Num_Regions_Supported'Result'Enum_Rep <= Max_Num_Memory_Regions;

   procedure Initialize
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Enables memory protection hardware
   --
   procedure Enable_Memory_Protection (Enable_Background_Region : Boolean)
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Disables memory protection hardware
   --
   procedure Disable_Memory_Protection
      with Pre => Cpu_In_Privileged_Mode;

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => Cpu_In_Privileged_Mode and then
                  To_Integer (Start_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  Size_In_Bytes > 0 and then
                  Size_In_Bytes mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0,
            Post => Is_Memory_Region_Enabled (Region_Id);

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => Cpu_In_Privileged_Mode and then
                  To_Integer (Start_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  To_Integer (End_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  To_Integer (Start_Address) < To_Integer (End_Address) and then
                  not Is_Memory_Region_Enabled (Region_Id),
           Post => Is_Memory_Region_Enabled (Region_Id);

   --
   --  Initializes state of a memory protection descriptor object
   --
   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment > 1 and then
                  To_Integer (Start_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  Size_In_Bytes > 0 and then
                  Size_In_Bytes mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0;

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => To_Integer (Start_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  To_Integer (End_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  To_Integer (Start_Address) < To_Integer (End_Address);

   procedure Initialize_Memory_Region_Descriptor_Disabled (
      Region_Descriptor : out Memory_Region_Descriptor_Type);

   function Is_Memory_Region_Enabled (Region_Id : Memory_Region_Id_Type) return Boolean
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Copies saved state of a memory protection descriptor to the
   --  corresponding memory descriptor in the supervisor MPU
   --
   procedure Restore_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : Memory_Region_Descriptor_Type)
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Saves state of a memory protection descriptor from the supervisor MPU
   --
   procedure Save_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : out Memory_Region_Descriptor_Type)
      with Pre => Cpu_In_Privileged_Mode;

   procedure Disable_Memory_Region (Region_Id : Memory_Region_Id_Type)
      with Pre => Cpu_In_Privileged_Mode,
           Post => not Is_Memory_Region_Enabled (Region_Id);

   procedure Enable_Memory_Region (Region_Id : Memory_Region_Id_Type)
      with Pre => Cpu_In_Privileged_Mode,
           Post => Is_Memory_Region_Enabled (Region_Id);

   procedure Handle_Prefetch_Abort_Exception
      with Pre => Cpu_In_Privileged_Mode;

   procedure Handle_Data_Abort_Exception
      with Pre => Cpu_In_Privileged_Mode;

   type Fault_Status_Registers_Type is limited private;

   procedure Initialize_Fault_Status_Registers (
      Fault_Status_Registers : out Fault_Status_Registers_Type)
      with Pre => Cpu_In_Hypervisor_Mode;

   procedure Save_Fault_Status_Registers (
      Fault_Status_Registers : out Fault_Status_Registers_Type)
      with Pre => Cpu_In_Hypervisor_Mode;

   procedure Restore_Fault_Status_Registers (
      Fault_Status_Registers : Fault_Status_Registers_Type)
      with Pre => Cpu_In_Hypervisor_Mode;

private

   type Memory_Region_Descriptor_Type is record
      Base_Address : System.Address := System.Null_Address; --  TODO: Add right fields
   end record;

   type Fault_Status_Registers_Type is limited record
      ESR_EL1_Value : System_Registers.ESR_EL1_Type;
      FAR_EL1_Value : System_Registers.FAR_EL1_Type;
      SCTLR_EL1_Value : System_Registers.SCTLR_EL1_Type;
   end record;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection;
