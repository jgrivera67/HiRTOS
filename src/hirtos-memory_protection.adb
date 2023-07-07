--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS Memory protection services
--

--  ???with HiRTOS_Low_Level_Debug_Interface; --???

package body HiRTOS.Memory_Protection with
  SPARK_Mode => On
is
   use HiRTOS.Memory_Protection_Private;
   use System.Storage_Elements;

   procedure Begin_Data_Range_Write_Access (
      Start_Address : System.Address;
      Size_In_Bits : Memory_Range_Size_In_Bits_Type;
      Old_Data_Range : out Memory_Range_Type)
      with Refined_Post => Old_Data_Range.Range_Region_Role = Invalid_Region_Role or else
                           Old_Data_Range.Range_Region_Role = Thread_Private_Data_Region
   is
      use type HiRTOS_Config_Parameters.Global_Data_Default_Access_Type;
      Region_Size_In_Bytes : constant Integer_Address :=
         Integer_Address (Size_In_Bits / System.Storage_Unit);
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      Old_Data_Range.Range_Region_Role := Invalid_Region_Role;
      if Valid_Stack_Address (Start_Address)
         or else
         (Valid_Global_Data_Address (Start_Address)
          and then
          (HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode
           or else
           HiRTOS_Config_Parameters.Global_Data_Default_Access =
             HiRTOS_Config_Parameters.Global_Data_Privileged_Unprivileged_Access))
      then
         return;
      end if;

      pragma Assert (System.Storage_Elements.To_Integer (Start_Address) mod Memory_Range_Alignment = 0);
      pragma Assert (Region_Size_In_Bytes mod Memory_Range_Alignment = 0);

      HiRTOS.Enter_Cpu_Privileged_Mode;
      Save_Memory_Region_Descriptor (Memory_Region_Id_Type (Thread_Private_Data_Region'Enum_Rep),
                                     Old_Data_Range.Range_Region);

      Old_Data_Range.Range_Region_Role := Thread_Private_Data_Region;

      --  Begin critical section
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      Configure_Memory_Region (Memory_Region_Id_Type (Thread_Private_Data_Region'Enum_Rep),
                               Start_Address,
                               Region_Size_In_Bytes,
                               Unprivileged_Permissions => Read_Write,
                               Privileged_Permissions => Read_Write,
                               Region_Attributes => Normal_Memory_Write_Back_Cacheable);

      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Begin_Data_Range_Write_Access;

   procedure End_Data_Range_Access (Old_Data_Range : Memory_Range_Type) is
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      if Old_Data_Range.Range_Region_Role = Invalid_Region_Role then
         return;
      end if;

      pragma Assert (Old_Data_Range.Range_Region_Role = Thread_Private_Data_Region);

      --  Begin critical section
      HiRTOS.Enter_Cpu_Privileged_Mode;
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      Restore_Memory_Region_Descriptor (Memory_Region_Id_Type (Thread_Private_Data_Region'Enum_Rep),
                                        Old_Data_Range.Range_Region);

      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end End_Data_Range_Access;

   procedure Begin_Mmio_Range_Write_Access (
      Start_Address : System.Address;
      Size_In_Bits : Memory_Range_Size_In_Bits_Type;
      Old_Mmio_Range : out Memory_Range_Type)
      with Refined_Post => Old_Mmio_Range.Range_Region_Role = Invalid_Region_Role or else
                           Old_Mmio_Range.Range_Region_Role = Thread_Private_Mmio_Region
   is
      use type HiRTOS_Config_Parameters.Global_Mmio_Default_Access_Type;
      Region_Size_In_Bytes : constant Integer_Address :=
         Integer_Address (Size_In_Bits / System.Storage_Unit);
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      Old_Mmio_Range.Range_Region_Role := Invalid_Region_Role;
      if Valid_Global_Mmio_Address (Start_Address)
         and then
         (HiRTOS_Config_Parameters.Global_Mmio_Default_Access =
            HiRTOS_Config_Parameters.Global_Mmio_Privileged_Unprivileged_Access
          or else
          HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode)
      then
         return;
      end if;

      pragma Assert (System.Storage_Elements.To_Integer (Start_Address) mod Memory_Range_Alignment = 0);
      pragma Assert (Region_Size_In_Bytes mod Memory_Range_Alignment = 0);

      HiRTOS.Enter_Cpu_Privileged_Mode;
      Save_Memory_Region_Descriptor (Memory_Region_Id_Type (Thread_Private_Mmio_Region'Enum_Rep),
                                     Old_Mmio_Range.Range_Region);

      Old_Mmio_Range.Range_Region_Role := Thread_Private_Mmio_Region;

      --  Begin critical section
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      Configure_Memory_Region (Memory_Region_Id_Type (Thread_Private_Mmio_Region'Enum_Rep),
                               Start_Address,
                               Region_Size_In_Bytes,
                               Unprivileged_Permissions => Read_Write,
                               Privileged_Permissions => Read_Write,
                               Region_Attributes => Device_Memory_Mapped_Io);

      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Begin_Mmio_Range_Write_Access;

   procedure End_Mmio_Range_Access (Old_Mmio_Range : Memory_Range_Type) is
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      if Old_Mmio_Range.Range_Region_Role = Invalid_Region_Role then
         return;
      end if;

      pragma Assert (Old_Mmio_Range.Range_Region_Role = Thread_Private_Mmio_Region);

      --  Begin critical section
      HiRTOS.Enter_Cpu_Privileged_Mode;
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      Restore_Memory_Region_Descriptor (Memory_Region_Id_Type (Thread_Private_Mmio_Region'Enum_Rep),
                                        Old_Mmio_Range.Range_Region);

      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end End_Mmio_Range_Access;

end HiRTOS.Memory_Protection;
