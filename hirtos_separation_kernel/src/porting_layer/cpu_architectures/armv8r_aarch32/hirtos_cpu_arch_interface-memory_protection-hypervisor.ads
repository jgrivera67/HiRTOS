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
   --  Load all memory attributes supported into the El2-controlled MPU's HMAIR0/HMAIR1
   --  registers:
   --
   procedure Load_Memory_Attributes_Lookup_Table
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
