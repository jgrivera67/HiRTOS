--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Memory protection services
--  for the ARMv7-M MPU
--

with Bit_Sized_Integer_Types;
with Interfaces;

package body HiRTOS_Cpu_Arch_Interface.Memory_Protection with SPARK_Mode => On is
   use Bit_Sized_Integer_Types;
   use Interfaces;

   procedure Initialize is
      MPU_TYPE_Value : MPU_TYPE_Register_Type;
      MPU_CTRL_Value : MPU_CTRL_Register_Type;
      RNR_Value : MPU_RNR_Register_Type;
      RASR_Value : MPU_RASR_Register_Type;
      MPU_Registers : HiRTOS_Cpu_Arch_Interface.System_Registers.MPU_Type renames
         HiRTOS_Cpu_Arch_Interface.System_Registers.SCS.MPU;
   begin
      --
      --  Verify that the MPU has enough regions:
      --
      MPU_TYPE_Value := MPU_Registers.MPU_TYPE;
      MPU_Device_Var.Num_Regions :=
         Natural (MPU_TYPE_Value.DREGION_Num);

      if MPU_Device_Var.Num_Regions = 0 then
         return;
      end if;

      --
      --  Disable MPU to configure it:
      --
      MPU_CTRL_Value := MPU_Registers.MPU_CTRL;
      MPU_CTRL_Value.ENABLE := 0;
      MPU_Registers.MPU_CTRL := MPU_CTRL_Value;

      --
      --  Disable the default background region:
      --
      MPU_CTRL_Value.PRIVDEFENA := 0;
      MPU_Registers.MPU_CTRL := MPU_CTRL_Value;

      --
      --  Disable access to all regions:
      --
      for I in 0 .. MPU_Device_Var.Num_Regions - 1 loop
         RNR_Value.REGION := Byte_Type (I);
         MPU_Registers.MPU_RNR := RNR_Value;
         Memory_Barrier;
         RASR_Value := (ENABLE => 0, others => <>);
         MPU_Registers.MPU_RASR := RASR_Value;
      end loop;

      MPU_Device_Var.Initialized := True;
   end Initialize;

   function Encode_Region_Size (Region_Size_Bytes : Integer_Address)
      return Encoded_Region_Size_Type
   is
   begin
      for Log_Base2_Value in reverse Encoded_Region_Size_Type'Range loop
         if (Unsigned_32 (Region_Size_Bytes) and
             Shift_Left (Unsigned_32 (1), Natural (Log_Base2_Value))) /= 0
         then
            pragma Assert ((Region_Size_Bytes and
                            ((2 ** Natural (Log_Base2_Value)) - 1)) = 0);

            return Log_Base2_Value - 1;
         end if;
      end loop;

      pragma Assert (Region_Size_Bytes = 0); --  4GiB
      return Encoded_Region_Size_Type'Last;
   end Encode_Region_Size;

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
   is
      Region_Descriptor : Memory_Region_Descriptor_Type;
   begin
         pragma Assert (Is_Range_NAPOT_Aligned (Start_Address, Size_In_Bytes));
         Initialize_Memory_Region_Descriptor (Region_Descriptor,
                                              Start_Address,
                                              Size_In_Bytes,
                                              Unprivileged_Permissions,
                                              Privileged_Permissions,
                                              Region_Attributes);
      Restore_Memory_Region_Descriptor (Region_Id, Region_Descriptor);
   end Configure_Memory_Region;

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
   is
      Size_In_Bytes : constant System.Storage_Elements.Integer_Address :=
         To_Integer (End_Address) - To_Integer (Start_Address);
   begin
      Configure_Memory_Region (Region_Id,
                               Start_Address,
                               Size_In_Bytes,
                               Unprivileged_Permissions,
                               Privileged_Permissions,
                               Region_Attributes);
   end Configure_Memory_Region;

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type with Unreferenced;
      Region_Attributes : Region_Attributes_Type with Unreferenced)
   is
      function Encode_Read_Write_Permissions (Privileged_Permissions : Region_Permissions_Type;
                                             Unprivileged_Permissions : Region_Permissions_Type)
         return Read_Write_Permissions_Type
      is
      begin
         case Privileged_Permissions is
            when Read_Write =>
               if Unprivileged_Permissions = Read_Write then
                  return Privileged_Read_Write_Unprivileged_Read_Write;
               else
                  pragma Assert (Unprivileged_Permissions = None);
                  return Privileged_Read_Write_Unprivileged_No_Access;
               end if;
            when Read_Only | Read_Execute =>
               if Unprivileged_Permissions = Read_Only or else
                  Unprivileged_Permissions = Read_Execute
               then
                  return Privileged_Read_Only_Unprivileged_Read_Only;
               else
                  pragma Assert (Unprivileged_Permissions = None);
                  return Privileged_Read_Write_Unprivileged_No_Access;
               end if;
            when Read_Write_Execute =>
               pragma Assert (Unprivileged_Permissions = Read_Write_Execute);
               return Privileged_Read_Write_Unprivileged_Read_Write;
            when others =>
               pragma Assert (False);
               return No_Access;
         end case;
      end Encode_Read_Write_Permissions;

      ADDR_Value : constant Twenty_Seven_Bits_Type :=
         Twenty_Seven_Bits_Type (Shift_Right (Unsigned_32 (To_Integer (Start_Address)), 5));
      Encoded_Region_Size : constant Encoded_Region_Size_Type :=
         Encode_Region_Size (Size_In_Bytes);
      Encoded_Read_Write_Permissions : constant Read_Write_Permissions_Type :=
         Encode_Read_Write_Permissions (Privileged_Permissions, Unprivileged_Permissions);
      Encoded_Execute_Permission : constant Bit_Type :=
         (if Privileged_Permissions in Read_Execute | Read_Write_Execute or else
             Unprivileged_Permissions in Read_Execute | Read_Write_Execute
          then 0 else 1);
   begin
      if MPU_Device_Var.Num_Regions = 0 then
         return;
      end if;

      Region_Descriptor.RBAR_Value := (ADDR => ADDR_Value, others => <>);
      Region_Descriptor.RASR_Value := (ENABLE => 1,
                                       SIZE => Encoded_Region_Size,
                                       ATTRS => (AP => Encoded_Read_Write_Permissions,
                                                 XN => Encoded_Execute_Permission,
                                                 others => <>),
                                       others => <>);
   end Initialize_Memory_Region_Descriptor;

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
   is
      Size_In_Bytes : constant System.Storage_Elements.Integer_Address :=
         To_Integer (End_Address) - To_Integer (Start_Address);
   begin
      Initialize_Memory_Region_Descriptor (Region_Descriptor,
                                           Start_Address,
                                           Size_In_Bytes,
                                           Unprivileged_Permissions,
                                           Privileged_Permissions,
                                           Region_Attributes);
   end Initialize_Memory_Region_Descriptor;

   procedure Restore_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : Memory_Region_Descriptor_Type) is
      MPU_RNR_Value : MPU_RNR_Register_Type;
      MPU_Registers : HiRTOS_Cpu_Arch_Interface.System_Registers.MPU_Type renames
         HiRTOS_Cpu_Arch_Interface.System_Registers.SCS.MPU;
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      if MPU_Device_Var.Num_Regions = 0 then
         return;
      end if;

      --  Begin critical section
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
      MPU_RNR_Value.REGION := Byte_Type (Region_Id);
      MPU_Registers.MPU_RNR := MPU_RNR_Value;
      Memory_Barrier;
      MPU_Registers.MPU_RBAR := Region_Descriptor.RBAR_Value;
      MPU_Registers.MPU_RASR := Region_Descriptor.RASR_Value;
      Memory_Barrier;

      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
   end Restore_Memory_Region_Descriptor;

   procedure Initialize_Memory_Region_Descriptor_Disabled (
      Region_Descriptor : out Memory_Region_Descriptor_Type) is
   begin
      Region_Descriptor.RASR_Value := (ENABLE => 0, others => <>);
   end Initialize_Memory_Region_Descriptor_Disabled;

   procedure Save_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : out Memory_Region_Descriptor_Type) is
      MPU_RNR_Value : MPU_RNR_Register_Type;
      MPU_Registers : HiRTOS_Cpu_Arch_Interface.System_Registers.MPU_Type renames
         HiRTOS_Cpu_Arch_Interface.System_Registers.SCS.MPU;
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      if MPU_Device_Var.Num_Regions = 0 then
         return;
      end if;

      --  Begin critical section
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      MPU_RNR_Value.REGION := Byte_Type (Region_Id);
      MPU_Registers.MPU_RNR := MPU_RNR_Value;
      Memory_Barrier;
      Region_Descriptor.RBAR_Value := MPU_Registers.MPU_RBAR;
      Region_Descriptor.RASR_Value := MPU_Registers.MPU_RASR;
      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
   end Save_Memory_Region_Descriptor;

   procedure Enable_Memory_Protection (Enable_Background_Region : Boolean with Unreferenced) is
      MPU_CTRL_Value : MPU_CTRL_Register_Type;
      MPU_Registers : HiRTOS_Cpu_Arch_Interface.System_Registers.MPU_Type renames
         HiRTOS_Cpu_Arch_Interface.System_Registers.SCS.MPU;
   begin
      if MPU_Device_Var.Num_Regions = 0 then
         return;
      end if;

      MPU_CTRL_Value := MPU_Registers.MPU_CTRL;
      --  Enable the default background region:
      MPU_CTRL_Value.PRIVDEFENA := 1;
      MPU_CTRL_Value.ENABLE := 1;
      MPU_Registers.MPU_CTRL := MPU_CTRL_Value;
   end Enable_Memory_Protection;

   procedure Disable_Memory_Protection is
      MPU_CTRL_Value : MPU_CTRL_Register_Type;
      MPU_Registers : HiRTOS_Cpu_Arch_Interface.System_Registers.MPU_Type renames
         HiRTOS_Cpu_Arch_Interface.System_Registers.SCS.MPU;
   begin
      if MPU_Device_Var.Num_Regions = 0 then
         return;
      end if;

      MPU_CTRL_Value := MPU_Registers.MPU_CTRL;
      MPU_CTRL_Value.ENABLE := 0;
      MPU_Registers.MPU_CTRL := MPU_CTRL_Value;
   end Disable_Memory_Protection;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection;
