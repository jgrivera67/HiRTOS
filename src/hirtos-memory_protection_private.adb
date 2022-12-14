--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS Memory protection internal support
--

with HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
with HiRTOS_Cpu_Multi_Core_Interface;

package body HiRTOS.Memory_Protection_Private with SPARK_Mode => On is
   use HiRTOS_Cpu_Multi_Core_Interface;
   use HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;

   procedure Initialize is
      Region_Descriptor : Memory_Region_Descriptor_Type;
      Cpu_Id : constant Cpu_Core_Id_Type := Get_Cpu_Id;
      ISR_Stack_Info : constant ISR_Stack_Info_Type := Get_ISR_Stack_Info (Cpu_Id);
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
   begin
      Disable_Memory_Protection;
      Load_Memory_Attributes_Lookup_Table;

      --
      --  Disable all region descriptors:
      --
      Initialize_Memory_Region_Descriptor_Disabled (Region_Descriptor);
      for Region_Id in Memory_Region_Id_Type loop
         Restore_Memory_Region_Descriptor (Region_Id, Region_Descriptor);
      end loop;

      --
      --  Configure global text region:
      --
      Initialize_Memory_Region_Descriptor (Region_Descriptor,
                                           HiRTOS_Platform_Parameters.Global_Text_Region_Start_Address,
                                           Global_Text_Region_Size_In_Bytes,
                                           Unprivileged_Permissions => Read_Execute,
                                           Privileged_Permissions => Read_Execute,
                                           Region_Attributes =>
                                           --  Only reads need to be cached
                                           Normal_Memory_Write_Through_Cacheable);
      Restore_Memory_Region_Descriptor (Memory_Region_Id_Type (Global_Code_Region'Enum_Rep),
                                        Region_Descriptor);

      --
      --  Configure global rodata region:
      --
      Initialize_Memory_Region_Descriptor (Region_Descriptor,
                                           HiRTOS_Platform_Parameters.Rodata_Section_Start_Address,
                                           Rodata_Section_Size_In_Bytes,
                                           Unprivileged_Permissions => Read_Only,
                                           Privileged_Permissions => Read_Only,
                                           Region_Attributes =>
                                           --  Only reads need to be cached
                                           Normal_Memory_Write_Through_Cacheable);
      Restore_Memory_Region_Descriptor (Memory_Region_Id_Type (Global_Rodata_Region'Enum_Rep),
                                        Region_Descriptor);

      --
      --  Configure global data region:
      --

      case HiRTOS_Config_Parameters.Global_Data_Default_Access is
         when HiRTOS_Config_Parameters.Global_Data_Privileged_Unprivileged_Read_Only_Access =>
            Privileged_Permissions := Read_Only;
            Unprivileged_Permissions := Read_Only;
         when HiRTOS_Config_Parameters.Global_Data_Privileged_Read_Write_Unprivileged_Read_Only_Access =>
            Privileged_Permissions := Read_Write;
            Unprivileged_Permissions := Read_Only;
         when HiRTOS_Config_Parameters.Global_Data_Privileged_Unprivileged_Read_Write_Access =>
            Privileged_Permissions := Read_Write;
            Unprivileged_Permissions := Read_Write;
      end case;

      Initialize_Memory_Region_Descriptor (Region_Descriptor,
                                           HiRTOS_Platform_Parameters.Global_Data_Region_Start_Address,
                                           Global_Data_Region_Size_In_Bytes,
                                           Unprivileged_Permissions,
                                           Privileged_Permissions,
                                           Region_Attributes => Normal_Memory_Write_Back_Cacheable);
      Restore_Memory_Region_Descriptor (Memory_Region_Id_Type (Global_Data_Region'Enum_Rep),
                                        Region_Descriptor);

      --
      --  Configure global MMIO region:
      --

      case HiRTOS_Config_Parameters.Global_Mmio_Default_Access is
         when HiRTOS_Config_Parameters.Global_Mmio_Privileged_Only_Access =>
            Privileged_Permissions := Read_Write;
            Unprivileged_Permissions := None;
         when HiRTOS_Config_Parameters.Global_Mmio_Privileged_Unprivileged_Access =>
            Privileged_Permissions := Read_Write;
            Unprivileged_Permissions := Read_Write;
      end case;

      Initialize_Memory_Region_Descriptor (Region_Descriptor,
                                           HiRTOS_Platform_Parameters.Global_Mmio_Range_Start_Address,
                                           Global_Mmio_Region_Size_In_Bytes,
                                           Unprivileged_Permissions,
                                           Privileged_Permissions,
                                           Region_Attributes => Device_Memory_Mapped_Io);
      Restore_Memory_Region_Descriptor (Memory_Region_Id_Type (Global_Mmio_Region'Enum_Rep),
                                        Region_Descriptor);

      --
      --  Configure ISR stack region:
      --
      Initialize_Memory_Region_Descriptor (Region_Descriptor,
                                           ISR_Stack_Info.Base_Address,
                                           ISR_Stack_Info.Size_In_Bytes,
                                           Unprivileged_Permissions => Read_Write,
                                           Privileged_Permissions => Read_Write,
                                           Region_Attributes => Normal_Memory_Write_Back_Cacheable);
      Restore_Memory_Region_Descriptor (Memory_Region_Id_Type (Global_Interrupt_Stack_Region'Enum_Rep),
                                        Region_Descriptor);

      --Enable_Memory_Protection;
   end Initialize;

   procedure Initialize_Thread_Memory_Regions (Stack_Base_Addr : System.Address;
                                               Stack_Size_In_Bytes : System.Storage_Elements.Integer_Address;
                                               Thread_Regions : out Thread_Memory_Regions_Type)
   is
   begin
      Initialize_Memory_Region_Descriptor (Thread_Regions.Stack_Region,
                                           Stack_Base_Addr,
                                           Stack_Size_In_Bytes,
                                           Unprivileged_Permissions => Read_Write,
                                           Privileged_Permissions => Read_Write,
                                           Region_Attributes => Normal_Memory_Write_Back_Cacheable);

      Initialize_Memory_Region_Descriptor_Disabled (Thread_Regions.Code_Region);
      Initialize_Memory_Region_Descriptor_Disabled (Thread_Regions.Data_Region);
      Initialize_Memory_Region_Descriptor_Disabled (Thread_Regions.Mmio_Region);
   end Initialize_Thread_Memory_Regions;

   procedure Restore_Thread_Memory_Regions (Thread_Regions : Thread_Memory_Regions_Type) is
   begin
      Restore_Memory_Region_Descriptor (
         Memory_Region_Id_Type (Thread_Private_Code_Region'Enum_Rep),
                                Thread_Regions.Code_Region);
      Restore_Memory_Region_Descriptor (
         Memory_Region_Id_Type (Thread_Private_Data_Region'Enum_Rep),
                                Thread_Regions.Data_Region);
      Restore_Memory_Region_Descriptor (
         Memory_Region_Id_Type (Thread_Private_Mmio_Region'Enum_Rep),
                                Thread_Regions.Mmio_Region);
      Restore_Memory_Region_Descriptor (
         Memory_Region_Id_Type (Thread_Stack_Data_Region'Enum_Rep),
                                Thread_Regions.Stack_Region);
   end Restore_Thread_Memory_Regions;

   procedure Save_Thread_Memory_Regions (Thread_Regions : out Thread_Memory_Regions_Type) is
   begin
      Save_Memory_Region_Descriptor (
         Memory_Region_Id_Type (Thread_Private_Code_Region'Enum_Rep),
                                Thread_Regions.Code_Region);
      Save_Memory_Region_Descriptor (
         Memory_Region_Id_Type (Thread_Private_Data_Region'Enum_Rep),
                                Thread_Regions.Data_Region);
      Save_Memory_Region_Descriptor (
         Memory_Region_Id_Type (Thread_Private_Mmio_Region'Enum_Rep),
                                Thread_Regions.Mmio_Region);
      Save_Memory_Region_Descriptor (
         Memory_Region_Id_Type (Thread_Stack_Data_Region'Enum_Rep),
                                Thread_Regions.Stack_Region);
   end Save_Thread_Memory_Regions;

end HiRTOS.Memory_Protection_Private;
