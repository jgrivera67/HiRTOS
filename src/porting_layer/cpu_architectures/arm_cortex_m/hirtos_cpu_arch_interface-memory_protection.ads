--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Memory protection services
--  for ARMv7-M MPU
--

with HiRTOS_Platform_Parameters;
with System.Storage_Elements;
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

   Min_Region_Size_In_Bytes : constant := HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment;

   type Memory_Region_Id_Type is mod HiRTOS_Platform_Parameters.Max_Num_MPU_Regions;

   --
   --  Mapping of logical memory protection regions to memory protection descriptor
   --  indices
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
      Thread_Private_Mmio_Region => 8,

      --  Valid region roles must be added before this entry:
      Invalid_Region_Role => HiRTOS_Platform_Parameters.Max_Num_MPU_Regions);

   procedure Initialize
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Enables memory protection hardware
   --
   procedure Enable_Memory_Protection (Enable_Background_Region : Boolean)
      with Pre => Cpu_In_Privileged_Mode and then
                  Enable_Background_Region;

   --
   --  Disables memory protection hardware
   --
   procedure Disable_Memory_Protection
      with Pre => Cpu_In_Privileged_Mode;

   function Is_Address_Power_Of_Two (Address : System.Address) return Boolean is
      (Is_Value_Power_Of_Two (To_Integer (Address)));

   function Is_Range_NAPOT_Aligned (Start_Address : System.Address;
                                    Size_In_Bytes : System.Storage_Elements.Integer_Address)
      return Boolean is
      (Is_Value_Power_Of_Two (Size_In_Bytes) and then
       Size_In_Bytes >= 8 and then
       To_Integer (Start_Address) mod Size_In_Bytes = 0);

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => Cpu_In_Privileged_Mode and then
                  Size_In_Bytes /= 0 and then
                  Is_Range_NAPOT_Aligned (Start_Address, Size_In_Bytes);

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => Cpu_In_Privileged_Mode and then
                  To_Integer (Start_Address) < To_Integer (End_Address);

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => Size_In_Bytes /= 0 and then
                  Size_In_Bytes mod Min_Region_Size_In_Bytes = 0 and then
                  Is_Range_NAPOT_Aligned (Start_Address, Size_In_Bytes);

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => To_Integer (Start_Address) < To_Integer (End_Address) and then
                  To_Integer (Start_Address) mod Min_Region_Size_In_Bytes = 0 and then
                  To_Integer (End_Address) mod Min_Region_Size_In_Bytes = 0;

   procedure Initialize_Memory_Region_Descriptor_Disabled (
      Region_Descriptor : out Memory_Region_Descriptor_Type);

   --
   --  Copies saved state of a memory region descriptor to the
   --  corresponding PMP entries. THe region descriptor can be either
   --  a single-entry or two-entry descriptor that was initialize by an
   --  earlier call to Initialize_Memory_Region_Descriptor, or to
   --  Save_Memory_Region_Descriptor..
   --
   procedure Restore_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : Memory_Region_Descriptor_Type)
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Saves state of a memory region descriptor from the corresponding
   --  PMP entries
   --
   procedure Save_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : out Memory_Region_Descriptor_Type)
      with Pre => Cpu_In_Privileged_Mode and then
                  Region_Id mod 2 = 0;

private
   use HiRTOS_Cpu_Arch_Interface.System_Registers;

   type Memory_Region_Descriptor_Type is limited record
      RBAR_Value : MPU_RBAR_Register_Type;
      RASR_Value : MPU_RASR_Register_Type;
   end record;

   --
   --  MPU device state
   --
   type MPU_Device_Type is record
      Initialized : Boolean := False;
      MPU_Enabled : Boolean := False;
      Num_Regions : Natural := 0;
   end record;

   MPU_Device_Var : MPU_Device_Type;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection;
