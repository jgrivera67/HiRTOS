--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS Memory protection services
--

package body HiRTOS.Memory_Protection with
  SPARK_Mode => On
is
   use HiRTOS.Memory_Protection_Private;
   use HiRTOS_Cpu_Arch_Interface.Memory_Protection;
   use System.Storage_Elements;

   procedure Begin_Data_Range_Write_Access (
      Start_Address : System.Address;
      Size_In_Bits : Memory_Range_Size_In_Bits_Type;
      Old_Data_Range : out Memory_Range_Type)
      with Refined_Post => Old_Data_Range.Region_Role = Thread_Private_Data_Region
   is
      Region_Descriptor : Memory_Region_Descriptor_Type;
   begin
      Old_Data_Range.Region_Role := Thread_Private_Data_Region;
      Save_Memory_Region_Descriptor (
         Memory_Region_Id_Type (Thread_Private_Data_Region'Enum_Rep),
                                Old_Data_Range.Region_Descriptor);

      Initialize_Memory_Region_Descriptor (Region_Descriptor,
                                           Start_Address,
                                           Integer_Address (Size_In_Bits / System.Storage_Unit),
                                           Unprivileged_Permissions => Read_Write,
                                           Privileged_Permissions => Read_Write,
                                           Region_Attributes => Normal_Memory_Write_Back_Cacheable);

      Restore_Memory_Region_Descriptor (
         Memory_Region_Id_Type (Thread_Private_Data_Region'Enum_Rep), Region_Descriptor);
   end Begin_Data_Range_Write_Access;

   procedure End_Data_Range_Access (
      Old_Data_Range : Memory_Range_Type) is
   begin
      pragma Assert (Old_Data_Range.Region_Role = Thread_Private_Data_Region);
      Restore_Memory_Region_Descriptor (
         Memory_Region_Id_Type (Thread_Private_Data_Region'Enum_Rep),
                                Old_Data_Range.Region_Descriptor);
   end End_Data_Range_Access;

   procedure Begin_Mmio_Range_Write_Access (
      Start_Address : System.Address;
      Size_In_Bits : Memory_Range_Size_In_Bits_Type;
      Old_Mmio_Range : out Memory_Range_Type)
      with Refined_Post => Old_Mmio_Range.Region_Role = Thread_Private_Mmio_Region
   is
      Region_Descriptor : Memory_Region_Descriptor_Type;
   begin
      Old_Mmio_Range.Region_Role := Thread_Private_Mmio_Region;
      Save_Memory_Region_Descriptor (
         Memory_Region_Id_Type (Thread_Private_Mmio_Region'Enum_Rep),
                                Old_Mmio_Range.Region_Descriptor);

      Initialize_Memory_Region_Descriptor (Region_Descriptor,
                                           Start_Address,
                                           Integer_Address (Size_In_Bits / System.Storage_Unit),
                                           Unprivileged_Permissions => Read_Write,
                                           Privileged_Permissions => Read_Write,
                                           Region_Attributes => Device_Memory_Mapped_Io);

      Restore_Memory_Region_Descriptor (
         Memory_Region_Id_Type (Thread_Private_Mmio_Region'Enum_Rep), Region_Descriptor);
   end Begin_Mmio_Range_Write_Access;

   procedure End_Mmio_Range_Access (
      Old_Mmio_Range : Memory_Range_Type) is
   begin
      pragma Assert (Old_Mmio_Range.Region_Role = Thread_Private_Mmio_Region);
      Restore_Memory_Region_Descriptor (
         Memory_Region_Id_Type (Thread_Private_Mmio_Region'Enum_Rep),
                                Old_Mmio_Range.Region_Descriptor);
   end End_Mmio_Range_Access;

end HiRTOS.Memory_Protection;
