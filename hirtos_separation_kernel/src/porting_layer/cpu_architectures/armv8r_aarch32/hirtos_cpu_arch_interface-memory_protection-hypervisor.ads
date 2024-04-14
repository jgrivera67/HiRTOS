--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Memory protection services
--  for ARMv8-R Hypervisor MPU
--

package HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor
   with SPARK_Mode => On
is
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
      with Pre => Cpu_In_Hypervisor_Mode;

   --
   --  Enables memory protection hardware
   --
   procedure Enable_Memory_Protection (Enable_Background_Region : Boolean)
      with Pre => Cpu_In_Hypervisor_Mode;

   --
   --  Disables memory protection hardware
   --
   procedure Disable_Memory_Protection
      with Pre => Cpu_In_Hypervisor_Mode;

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => Cpu_In_Hypervisor_Mode and then
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
      with Pre => Cpu_In_Hypervisor_Mode and then
                  To_Integer (Start_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  To_Integer (End_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  To_Integer (Start_Address) < To_Integer (End_Address) and then
                  not Is_Memory_Region_Enabled (Region_Id),
           Post => Is_Memory_Region_Enabled (Region_Id);

   function Is_Memory_Region_Enabled (Region_Id : Memory_Region_Id_Type) return Boolean
      with Pre => Cpu_In_Hypervisor_Mode;

   --
   --  Copies saved state of a memory protection descriptor to the
   --  corresponding memory descriptor in the hypervisor MPU
   --
   procedure Restore_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : Memory_Region_Descriptor_Type)
      with Pre => Cpu_In_Hypervisor_Mode;

   --
   --  Saves state of a memory protection descriptor from the hypervisor MPU
   --
   procedure Save_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : out Memory_Region_Descriptor_Type)
      with Pre => Cpu_In_Hypervisor_Mode;

   procedure Disable_Memory_Region (Region_Id : Memory_Region_Id_Type)
      with Pre => Cpu_In_Hypervisor_Mode,
           Post => not Is_Memory_Region_Enabled (Region_Id);

   procedure Enable_Memory_Region (Region_Id : Memory_Region_Id_Type)
      with Pre => Cpu_In_Hypervisor_Mode,
           Post => Is_Memory_Region_Enabled (Region_Id);

   type Memory_Regions_Enabled_Bits_Array_Type is array (Memory_Region_Id_Type) of Boolean with
     Size => 32, Component_Size => 1;

   type Memory_Regions_Enabled_Bit_Mask_Type (As_Word : Boolean := True) is record
      case As_Word is
         when True =>
            Value : Interfaces.Unsigned_32 := 0;
         when False =>
            Bits_Array : Memory_Regions_Enabled_Bits_Array_Type;
      end case;
   end record with
     Size => 32, Unchecked_Union;

   procedure Enable_Memory_Regions_Bit_Mask (
      Bit_Mask : Memory_Regions_Enabled_Bit_Mask_Type)
      with Pre => Cpu_In_Hypervisor_Mode;

   procedure Disable_Memory_Regions_Bit_Mask (
      Bit_Mask : Memory_Regions_Enabled_Bit_Mask_Type)
      with Pre => Cpu_In_Hypervisor_Mode;

   procedure Handle_Prefetch_Abort_Exception
      with Pre => Cpu_In_Hypervisor_Mode;

   procedure Handle_Data_Abort_Exception
      with Pre => Cpu_In_Hypervisor_Mode;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor;
