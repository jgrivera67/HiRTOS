--
--  Copyright (c) 2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS separation kernel's memory protection internal support
--

with HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
with HiRTOS_Cpu_Arch_Interface.System_Registers.Hypervisor;
with HiRTOS_Cpu_Multi_Core_Interface;
with HiRTOS_Platform_Parameters;
with Memory_Utils;

package body HiRTOS.Separation_Kernel.Memory_Protection_Private with SPARK_Mode => On is
   use HiRTOS_Cpu_Multi_Core_Interface;
   use HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;

   procedure Initialize is
      use type System.Address;
      Cpu_Id : constant Cpu_Core_Id_Type := Get_Cpu_Id;
      ISR_Stack_Info : constant ISR_Stack_Info_Type := Get_ISR_Stack_Info (Cpu_Id);
   begin
      HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor.Initialize;

      --
      --  Set NULL pointer de-reference guard region:
      --
      if HiRTOS_Cpu_Arch_Interface.System_Registers.Hypervisor.Get_HVBAR /= System.Null_Address then
         Hypervisor.Configure_Memory_Region (
            Memory_Region_Id_Type (Hypervisor.Null_Pointer_Dereference_Guard'Enum_Rep),
            System.Null_Address,
            HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment,
            Unprivileged_Permissions => None,
            --  NOTE: PERM_NONE not supported for privileged mode
            Privileged_Permissions => Read_Only,
            Region_Attributes => Normal_Memory_Non_Cacheable);
      end if;

      --
      --  Configure hypervisor text region:
      --
      Hypervisor.Configure_Memory_Region (
         Memory_Region_Id_Type (Hypervisor_Code_Region'Enum_Rep),
         HiRTOS_Platform_Parameters.Global_Text_Region_Start_Address,
         HiRTOS_Platform_Parameters.Global_Text_Region_End_Address,
         Unprivileged_Permissions => None,
         Privileged_Permissions => Read_Execute,
         Region_Attributes =>
         --  Only reads need to be cached
         Normal_Memory_Write_Through_Cacheable);

      --
      --  Configure hypervisor rodata region:
      --
      Hypervisor.Configure_Memory_Region (
         Memory_Region_Id_Type (Hypervisor_Rodata_Region'Enum_Rep),
         HiRTOS_Platform_Parameters.Rodata_Section_Start_Address,
         HiRTOS_Platform_Parameters.Rodata_Section_End_Address,
         Unprivileged_Permissions => None,
         Privileged_Permissions => Read_Only,
         Region_Attributes =>
         --  Only reads need to be cached
         Normal_Memory_Write_Through_Cacheable);

      --
      --  Set region to detect ISR stack overflows:
      --
      Hypervisor.Configure_Memory_Region (
         Memory_Region_Id_Type (Hypervisor_Interrupt_Stack_Overflow_Guard'Enum_Rep),
         To_Address (To_Integer (ISR_Stack_Info.Base_Address) -
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment),
         HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment,
         Unprivileged_Permissions => None,
         --  NOTE: Permissions `None` not supported for privileged mode
         Privileged_Permissions => Read_Only,
         Region_Attributes => Normal_Memory_Non_Cacheable);

      --
      --  Set MMIO region to be able to access GIC registers:
      --
      Hypervisor.Configure_Memory_Region (
         Memory_Region_Id_Type (Hypervisor_Mmio_Region'Enum_Rep),
         HiRTOS_Platform_Parameters.Global_Mmio_Region_Start_Address,
         HiRTOS_Platform_Parameters.Global_Mmio_Region_End_Address,
         Unprivileged_Permissions => Read_Write,
         Privileged_Permissions => Read_Write,
         Region_Attributes => Device_Memory_Mapped_Io);

      Hypervisor.Enable_Memory_Protection (Enable_Background_Region => True);
   end Initialize;

   procedure Initialize_Memory_Protection_Context (
      TCM_Base_Address : System.Address;
      TCM_Size_In_Bytes :  System.Storage_Elements.Integer_Address;
      SRAM_Base_Address : System.Address;
      SRAM_Size_In_Bytes :  System.Storage_Elements.Integer_Address;
      MMIO_Base_Address : System.Address;
      MMIO_Size_In_Bytes :  System.Storage_Elements.Integer_Address;
      Partition_Hypervisor_Regions_Config : Partition_Hypervisor_Regions_Config_Type;
      Memory_Protection_Context : out Memory_Protection_Context_Type)
   is
      use HiRTOS_Platform_Parameters;
      TCM_Region_Id : Memory_Region_Id_Type renames
         Partition_Hypervisor_Regions_Config.Tcm_Region_Id;
      SRAM_Region_Id : Memory_Region_Id_Type renames
         Partition_Hypervisor_Regions_Config.Sram_Region_Id;
      MMIO_Region_Id : Memory_Region_Id_Type renames
         Partition_Hypervisor_Regions_Config.Mmio_Region_Id;
      Global_Mmio_Region_Size_In_Bytes : constant Integer_Address :=
         To_Integer (Global_Mmio_Region_End_Address) - To_Integer (Global_Mmio_Region_Start_Address);
   begin
      Memory_Protection_Context.Hypervisor_Enabled_Regions_Bit_Mask.Bits_Array := [others => False];
      HiRTOS_Cpu_Arch_Interface.Memory_Protection.Initialize_Fault_Status_Registers (
         Memory_Protection_Context.Fault_Status_Registers);

      --
      --  Configure Hypervisor-controlled MPU regions for the partition:
      --
      --  NOTE: We disable them, as they only need to be enabled when the corresponding
      --  partition is switched in.
      --

      if TCM_Size_In_Bytes /= 0 then
         Hypervisor.Configure_Memory_Region (TCM_Region_Id,
                                             TCM_Base_Address,
                                             TCM_Size_In_Bytes,
                                             Unprivileged_Permissions => Read_Write_Execute,
                                             Privileged_Permissions => Read_Write_Execute,
                                             Region_Attributes => Normal_Memory_Write_Back_Cacheable);
         Hypervisor.Disable_Memory_Region (TCM_Region_Id);
         Memory_Protection_Context.Hypervisor_Enabled_Regions_Bit_Mask.Bits_Array (TCM_Region_Id) := True;
      end if;

      if SRAM_Size_In_Bytes /= 0 then
         Hypervisor.Configure_Memory_Region (SRAM_Region_Id,
                                             SRAM_Base_Address,
                                             SRAM_Size_In_Bytes,
                                             Unprivileged_Permissions => Read_Write_Execute,
                                             Privileged_Permissions => Read_Write_Execute,
                                             Region_Attributes => Normal_Memory_Write_Back_Cacheable);
         Hypervisor.Disable_Memory_Region (SRAM_Region_Id);
         Memory_Protection_Context.Hypervisor_Enabled_Regions_Bit_Mask.Bits_Array (SRAM_Region_Id) := True;
      end if;

      if MMIO_Size_In_Bytes /= 0 and then
         not Memory_Utils.Address_Overlap (MMIO_Base_Address, MMIO_Size_In_Bytes,
                                           HiRTOS_Platform_Parameters.Global_Mmio_Region_Start_Address,
                                           Global_Mmio_Region_Size_In_Bytes)
      then
         Hypervisor.Configure_Memory_Region (MMIO_Region_Id,
                                             MMIO_Base_Address,
                                             MMIO_Size_In_Bytes,
                                             Unprivileged_Permissions => Read_Write,
                                             Privileged_Permissions => Read_Write,
                                             Region_Attributes => Device_Memory_Mapped_Io);
         Hypervisor.Disable_Memory_Region (MMIO_Region_Id);
         Memory_Protection_Context.Hypervisor_Enabled_Regions_Bit_Mask.Bits_Array (MMIO_Region_Id) := True;
      end if;

      for Region_Desc of Memory_Protection_Context.Internal_Memory_Regions loop
         Initialize_Memory_Region_Descriptor_Disabled (Region_Desc);
      end loop;
   end Initialize_Memory_Protection_Context;

   procedure Restore_Memory_Protection_Context (
      Memory_Protection_Context : Memory_Protection_Context_Type)
   is
   begin
      --
      --  NOTE: We don't need to physically restore the partition's hypervisor-controlled
      --  MPU regions here, we just need to enabled them.
      --
      HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor.
         Enable_Memory_Regions_Bit_Mask (Memory_Protection_Context.Hypervisor_Enabled_Regions_Bit_Mask);

      HiRTOS_Cpu_Arch_Interface.Memory_Protection.Restore_Fault_Status_Registers (
         Memory_Protection_Context.Fault_Status_Registers);

      for Region_Id in Memory_Protection_Context.Internal_Memory_Regions'Range loop
         HiRTOS_Cpu_Arch_Interface.Memory_Protection.Restore_Memory_Region_Descriptor (
            Region_Id, Memory_Protection_Context.Internal_Memory_Regions (Region_Id));
      end loop;
   end Restore_Memory_Protection_Context;

   procedure Save_Memory_Protection_Context (
      Memory_Protection_Context : out Memory_Protection_Context_Type) is
   begin
      --
      --  NOTE: We need to disable the partition's hypervisor-controlled
      --  MPU regions here, as this subprogram is invoked as part of switching out
      --  a partition.
      --
      HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor.
         Disable_Memory_Regions_Bit_Mask (Memory_Protection_Context.Hypervisor_Enabled_Regions_Bit_Mask);

      HiRTOS_Cpu_Arch_Interface.Memory_Protection.Save_Fault_Status_Registers (
         Memory_Protection_Context.Fault_Status_Registers);

      for Region_Id in Memory_Protection_Context.Internal_Memory_Regions'Range loop
         HiRTOS_Cpu_Arch_Interface.Memory_Protection.Save_Memory_Region_Descriptor (
            Region_Id, Memory_Protection_Context.Internal_Memory_Regions (Region_Id));
      end loop;
   end Save_Memory_Protection_Context;

   procedure Cleanup_Memory_Protection_Context (
      Memory_Protection_Context : out Memory_Protection_Context_Type) is
   begin
      HiRTOS_Cpu_Arch_Interface.Memory_Protection.Initialize_Fault_Status_Registers (
         Memory_Protection_Context.Fault_Status_Registers);

      for Region_Desc of Memory_Protection_Context.Internal_Memory_Regions loop
         HiRTOS_Cpu_Arch_Interface.Memory_Protection.Initialize_Memory_Region_Descriptor_Disabled (Region_Desc);
      end loop;
   end Cleanup_Memory_Protection_Context;

end HiRTOS.Separation_Kernel.Memory_Protection_Private;
