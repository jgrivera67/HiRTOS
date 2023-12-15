--
--  Copyright (c) 2022-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS Memory protection internal support
--

with HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
with HiRTOS_Cpu_Multi_Core_Interface;
with HiRTOS_Cpu_Arch_Interface.System_Registers;

package body HiRTOS.Memory_Protection_Private with SPARK_Mode => On is
   use HiRTOS_Cpu_Multi_Core_Interface;
   use HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;

   procedure Initialize is
      use type HiRTOS_Config_Parameters.Global_Data_Default_Access_Type;
      use type HiRTOS_Config_Parameters.Global_Mmio_Default_Access_Type;
      use type System.Address;
      Cpu_Id : constant Cpu_Core_Id_Type := Get_Cpu_Id;
      ISR_Stack_Info : constant ISR_Stack_Info_Type := Get_ISR_Stack_Info (Cpu_Id);
   begin
      Disable_Memory_Protection;
      Load_Memory_Attributes_Lookup_Table;

      --
      --  Disable all region descriptors:
      --
      for Region_Id in Memory_Region_Id_Type loop
         Disable_Memory_Region (Region_Id);
      end loop;

      --
      --  Configure global text region:
      --
      Configure_Memory_Region (Memory_Region_Id_Type (Global_Code_Region'Enum_Rep),
                               HiRTOS_Platform_Parameters.Global_Text_Region_Start_Address,
                               Global_Text_Region_Size_In_Bytes,
                               Unprivileged_Permissions => Read_Execute,
                               Privileged_Permissions => Read_Execute,
                               Region_Attributes =>
                                 --  Only reads need to be cached
                                 Normal_Memory_Write_Through_Cacheable);

      --
      --  Configure global rodata region:
      --
      Configure_Memory_Region (Memory_Region_Id_Type (Global_Rodata_Region'Enum_Rep),
                               HiRTOS_Platform_Parameters.Rodata_Section_Start_Address,
                               Rodata_Section_Size_In_Bytes,
                               Unprivileged_Permissions => Read_Only,
                               Privileged_Permissions => Read_Only,
                               Region_Attributes =>
                                 --  Only reads need to be cached
                                 Normal_Memory_Write_Through_Cacheable);

      --
      --  Set NULL pointer de-reference guard region:
      --
      if HiRTOS_Cpu_Arch_Interface.System_Registers.Get_VBAR /= System.Null_Address then
         Configure_Memory_Region (Memory_Region_Id_Type (Null_Pointer_Dereference_Guard'Enum_Rep),
                                 System.Null_Address,
                                 HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment,
                                 Unprivileged_Permissions => None,
                                 --  NOTE: PERM_NONE not supported for privileged mode
                                 Privileged_Permissions => Read_Only,
                                 Region_Attributes => Normal_Memory_Non_Cacheable);
      end if;

      --
      --  Configure explicit global data region, if both privileged/unprivileged
      --  default access is wanted:
      --
      --  NOTE: There is no need to have an explicit MPU region for the privileged
      --  BSS section, as it is covered by the the background region.
      --
      if HiRTOS_Config_Parameters.Global_Data_Default_Access =
           HiRTOS_Config_Parameters.Global_Data_Privileged_Unprivileged_Access
      then
         Configure_Memory_Region (Memory_Region_Id_Type (Global_Data_Region'Enum_Rep),
                               HiRTOS_Platform_Parameters.Global_Data_Region_Start_Address,
                               Global_Data_Region_Size_In_Bytes,
                               Unprivileged_Permissions => Read_Write,
                               Privileged_Permissions => Read_Write,
                               Region_Attributes => Normal_Memory_Write_Back_Cacheable);
      end if;

      --
      --  Configure explicit global MMIO region, if both privileged/unprivileged
      --  default access is wanted:
      --
      if HiRTOS_Config_Parameters.Global_Mmio_Default_Access =
            HiRTOS_Config_Parameters.Global_Mmio_Privileged_Unprivileged_Access
      then
         Configure_Memory_Region (Memory_Region_Id_Type (Global_Mmio_Region'Enum_Rep),
                                  HiRTOS_Platform_Parameters.Global_Mmio_Region_Start_Address,
                                  Global_Mmio_Region_Size_In_Bytes,
                                  Unprivileged_Permissions => Read_Write,
                                  Privileged_Permissions => Read_Write,
                                  Region_Attributes => Device_Memory_Mapped_Io);
      end if;

      --
      --  Configure ISR stack region:
      --
      Configure_Memory_Region (Memory_Region_Id_Type (Global_Interrupt_Stack_Region'Enum_Rep),
                                           ISR_Stack_Info.Base_Address,
                                           ISR_Stack_Info.Size_In_Bytes,
                                           Unprivileged_Permissions => Read_Write,
                                           Privileged_Permissions => Read_Write,
                                           Region_Attributes => Normal_Memory_Write_Back_Cacheable);

      --
      --  Set region to detect ISR stack overflows:
      --
      Configure_Memory_Region (Memory_Region_Id_Type (Global_Interrupt_Stack_Overflow_Guard'Enum_Rep),
                               To_Address (To_Integer (ISR_Stack_Info.Base_Address) -
                                           HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment),
                               HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment,
                               Unprivileged_Permissions => None,
                               --  NOTE: PERM_NONE not supported for privileged mode
                               Privileged_Permissions => Read_Only,
                               Region_Attributes => Normal_Memory_Non_Cacheable);

      if HiRTOS_Config_Parameters.Global_Data_Default_Access =
            HiRTOS_Config_Parameters.Global_Data_Privileged_Access_Unprivileged_No_Access
         or else
         HiRTOS_Config_Parameters.Global_Mmio_Default_Access =
            HiRTOS_Config_Parameters.Global_Mmio_Privileged_Access_Unprivileged_No_Access
      then
         Enable_Memory_Protection (Enable_Background_Region => True);
      else
         Enable_Memory_Protection (Enable_Background_Region => False);
      end if;
   end Initialize;

   procedure Initialize_Thread_Memory_Regions (Stack_Base_Addr : System.Address;
                                               Stack_End_Addr : System.Address;
                                               Thread_Regions : out Thread_Memory_Regions_Type)
   is
   begin
      Initialize_Memory_Region_Descriptor_Disabled (Thread_Regions.Private_Code_Region);
      Initialize_Memory_Region_Descriptor_Disabled (Thread_Regions.Private_Data_Region);
      Initialize_Memory_Region_Descriptor_Disabled (Thread_Regions.Private_Mmio_Region);
      Initialize_Memory_Region_Descriptor (Thread_Regions.Stack_Region,
                                           Stack_Base_Addr,
                                           Stack_End_Addr,
                                           Unprivileged_Permissions => Read_Write,
                                           Privileged_Permissions => Read_Write,
                                           Region_Attributes => Normal_Memory_Write_Back_Cacheable);
   end Initialize_Thread_Memory_Regions;

   procedure Restore_Thread_Memory_Regions (Thread_Regions : Thread_Memory_Regions_Type) is
   begin
      Restore_Memory_Region_Descriptor (Memory_Region_Id_Type (Thread_Private_Code_Region'Enum_Rep),
                                        Thread_Regions.Private_Code_Region);

      Restore_Memory_Region_Descriptor (Memory_Region_Id_Type (Thread_Private_Data_Region'Enum_Rep),
                                        Thread_Regions.Private_Data_Region);

      Restore_Memory_Region_Descriptor (Memory_Region_Id_Type (Thread_Private_Mmio_Region'Enum_Rep),
                                        Thread_Regions.Private_Mmio_Region);

      Restore_Memory_Region_Descriptor (Memory_Region_Id_Type (Thread_Stack_Data_Region'Enum_Rep),
                                        Thread_Regions.Stack_Region);
   end Restore_Thread_Memory_Regions;

   procedure Save_Thread_Memory_Regions (Thread_Regions : out Thread_Memory_Regions_Type) is
   begin
      Save_Memory_Region_Descriptor (Memory_Region_Id_Type (Thread_Private_Code_Region'Enum_Rep),
                                     Thread_Regions.Private_Code_Region);

      Save_Memory_Region_Descriptor (Memory_Region_Id_Type (Thread_Private_Data_Region'Enum_Rep),
                                     Thread_Regions.Private_Data_Region);

      Save_Memory_Region_Descriptor (Memory_Region_Id_Type (Thread_Private_Mmio_Region'Enum_Rep),
                                     Thread_Regions.Private_Mmio_Region);

      Save_Memory_Region_Descriptor (Memory_Region_Id_Type (Thread_Stack_Data_Region'Enum_Rep),
                                     Thread_Regions.Stack_Region);
   end Save_Thread_Memory_Regions;

end HiRTOS.Memory_Protection_Private;
