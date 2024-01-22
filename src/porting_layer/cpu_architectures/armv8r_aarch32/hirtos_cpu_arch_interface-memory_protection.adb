--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Memory protection services
--  for ARMv8-R EL1 MPU
--

with HiRTOS.Interrupt_Handling;
with HiRTOS_Cpu_Arch_Interface.Memory_Protection.EL1_MPU;
with HiRTOS_Cpu_Arch_Interface.System_Registers;
with HiRTOS_Low_Level_Debug_Interface;

package body HiRTOS_Cpu_Arch_Interface.Memory_Protection with SPARK_Mode => On is
   use HiRTOS_Cpu_Arch_Interface.Memory_Protection.EL1_MPU;
   use HiRTOS_Cpu_Arch_Interface.System_Registers;

   function Get_Num_Regions_Supported return Mpu_Regions_Count_Type is
   begin
      return Get_MPUIR.DREGION;
   end Get_Num_Regions_Supported;

   function Is_Memory_Region_Enabled (Region_Id : Memory_Region_Id_Type) return Boolean is
      (Get_PRLAR (Region_Id).EN = Region_Enabled);

   procedure Load_Memory_Attributes_Lookup_Table is
      MAIR_Pair : MAIR_Pair_Type;
   begin
      MAIR_Pair.Attr_Array := Memory_Attributes_Lookup_Table;
      Set_MAIR_Pair (MAIR_Pair);
   end Load_Memory_Attributes_Lookup_Table;

   procedure Enable_Memory_Protection (Enable_Background_Region : Boolean) is
      SCTLR_Value : SCTLR_Type;
   begin
      Memory_Barrier;
      SCTLR_Value := Get_SCTLR;
      SCTLR_Value.M := Mpu_Enabled;
      SCTLR_Value.A := Alignment_Check_Disabled; -- To allow unaligned accesses
      --  ???SCTLR_Value.C := Cacheable; --TODO
      --  ???SCTLR_Value.I := Instruction_Access_Cacheable; --TODO: This too slow in ARM FVP simulator
      if Enable_Background_Region then
         SCTLR_Value.BR := Background_Region_Enabled;
      else
         SCTLR_Value.BR := Background_Region_Disabled;
      end if;

      Set_SCTLR (SCTLR_Value);
   end Enable_Memory_Protection;

   procedure Disable_Memory_Protection is
      SCTLR_Value : SCTLR_Type;
   begin
      SCTLR_Value := Get_SCTLR;
      SCTLR_Value.M := Mpu_Disabled;
      SCTLR_Value.BR := Background_Region_Disabled;
      Set_SCTLR (SCTLR_Value);
      Memory_Barrier;
   end Disable_Memory_Protection;

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
      Region_Descriptor : Memory_Region_Descriptor_Type;
   begin
      Initialize_Memory_Region_Descriptor (Region_Descriptor,
                                           Start_Address,
                                           End_Address,
                                           Unprivileged_Permissions,
                                           Privileged_Permissions,
                                           Region_Attributes);
      Restore_Memory_Region_Descriptor (Region_Id, Region_Descriptor);
   end Configure_Memory_Region;

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
   is
      End_Address : constant System.Address := System.Storage_Elements.To_Address (
         System.Storage_Elements.To_Integer (Start_Address) + Size_In_Bytes);
   begin
      Initialize_Memory_Region_Descriptor (Region_Descriptor,
                                           Start_Address,
                                           End_Address,
                                           Unprivileged_Permissions,
                                           Privileged_Permissions,
                                           Region_Attributes);
   end Initialize_Memory_Region_Descriptor;

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
   is
      PRBAR_Value : PRBAR_Type;
      PRLAR_Value : PRLAR_Type;
   begin
      PRBAR_Value.BASE := Encode_Region_Border_Address_Field (Start_Address);

      --
      --  NOTE: The Cortex-R52 processor is not coherent and the inner shareability
      --  domain consists of an individual Cortex-R52 core. The Cortex-R52 processor
      --  does not cache data that is marked as shareable, and all cache maintenance
      --  instructions are performed locally. This means that instruction cache maintenance
      --  operations are not broadcast to any other core. The outer shareability domain
      --  is external to the Cortex-R52 processor, and is therefore system-dependent.
      --
      PRBAR_Value.SH := Non_Shareable;
      PRBAR_Value.XN := Non_Executable;
      case Privileged_Permissions is
         when Read_Write =>
            if Unprivileged_Permissions = Read_Write then
               PRBAR_Value.AP := EL1_and_EL0_Read_Write; --  same as EL2_Read_Write_EL1_EL0_No_Access
            else
               pragma Assert (Unprivileged_Permissions = None);
               PRBAR_Value.AP := EL1_Read_Write_EL0_No_Access; --  same as EL2_Read_Write_EL1_EL0_No_Access
            end if;
         when Read_Only =>
            if Unprivileged_Permissions = Read_Only then
               PRBAR_Value.AP := EL1_and_EL0_Read_Only; --  same as EL2_and_EL1_EL0_Read_Only
            else
               pragma Assert (Unprivileged_Permissions = None);
               PRBAR_Value.AP := EL1_Read_Only_EL0_No_Access; --  same as EL2_Read_Only_EL1_EL0_No_Access
            end if;
         when Read_Execute =>
            PRBAR_Value.XN := Executable;
            if Unprivileged_Permissions = Read_Execute then
               PRBAR_Value.AP := EL1_and_EL0_Read_Only; --  same as EL2_and_EL1_EL0_Read_Only
            else
               pragma Assert (Unprivileged_Permissions = None);
               PRBAR_Value.AP := EL1_Read_Only_EL0_No_Access; --  same as EL2_Read_Only_EL1_EL0_No_Access
            end if;
         when Read_Write_Execute =>
            pragma Assert (Unprivileged_Permissions = Read_Write_Execute);
            PRBAR_Value.XN := Executable;
            PRBAR_Value.AP := EL1_and_EL0_Read_Write; --  same as EL2_Read_Write_EL1_EL0_No_Access
         when others =>
            pragma Assert (False);
      end case;

      PRLAR_Value.LIMIT := Encode_Region_Border_Address_Field (System.Storage_Elements.To_Address (
         System.Storage_Elements.To_Integer (End_Address) - 1));

      PRLAR_Value.AttrIndx := AttrIndx_Type (Region_Attributes'Enum_Rep);
      PRLAR_Value.EN := Region_Enabled;

      Region_Descriptor.PRBAR_Value := PRBAR_Value;
      Region_Descriptor.PRLAR_Value := PRLAR_Value;
   end Initialize_Memory_Region_Descriptor;

   procedure Restore_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : Memory_Region_Descriptor_Type) is
      Region_Disabled_Value : constant PRLAR_Type := (EN => Region_Disabled, others => <>);
   begin
      --
      --  NOTE: Before changing the PRBAR/PRLAR pair, we need to disable the region:
      --
      Set_PRLAR (Region_Id, Region_Disabled_Value);
      Set_PRBAR (Region_Id, Region_Descriptor.PRBAR_Value);
      Set_PRLAR (Region_Id, Region_Descriptor.PRLAR_Value);

      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
   end Restore_Memory_Region_Descriptor;

   procedure Initialize_Memory_Region_Descriptor_Disabled (
      Region_Descriptor : out Memory_Region_Descriptor_Type) is
   begin
      Region_Descriptor.PRLAR_Value.EN := Region_Disabled;
   end Initialize_Memory_Region_Descriptor_Disabled;

   procedure Save_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : out Memory_Region_Descriptor_Type) is
   begin
      Region_Descriptor.PRBAR_Value := Get_PRBAR (Region_Id);
      Region_Descriptor.PRLAR_Value := Get_PRLAR (Region_Id);
   end Save_Memory_Region_Descriptor;

   procedure Disable_Memory_Region (Region_Id : Memory_Region_Id_Type)
   is
      PRLAR_Value : PRLAR_Type;
   begin
      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
      PRLAR_Value := Get_PRLAR (Region_Id);
      PRLAR_Value.EN := Region_Disabled;
      Set_PRLAR (Region_Id, PRLAR_Value);
   end Disable_Memory_Region;

   procedure Enable_Memory_Region (Region_Id : Memory_Region_Id_Type)
   is
      PRLAR_Value : PRLAR_Type;
   begin
      PRLAR_Value := Get_PRLAR (Region_Id);
      PRLAR_Value.EN := Region_Enabled;
      Set_PRLAR (Region_Id, PRLAR_Value);
      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
   end Enable_Memory_Region;

   procedure Handle_Prefetch_Abort_Exception is
      IFSR_Value : IFSR_Type;
      IFAR_Value : IFAR_Type;
   begin
      IFSR_Value := Get_IFSR;
      IFAR_Value := Get_IFAR;

      HiRTOS_Low_Level_Debug_Interface.Print_String (
         "*** EL1 Prefetch abort: " & Fault_Name_Pointer_Array (IFSR_Value.Status).all & "  (faulting PC: ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (IFAR_Value));
      HiRTOS_Low_Level_Debug_Interface.Print_String (")" & ASCII.LF);

      raise Program_Error;
   end Handle_Prefetch_Abort_Exception;

   procedure Handle_Data_Abort_Exception is
      DFSR_Value : DFSR_Type;
      DFAR_Value : DFAR_Type;
      Faulting_PC : constant Integer_Address :=
         To_Integer (HiRTOS.Interrupt_Handling.Get_Interrupted_PC) - 8;
   begin
      DFSR_Value := Get_DFSR;
      DFAR_Value := Get_DFAR;
      HiRTOS_Low_Level_Debug_Interface.Print_String (
         "*** EL1 Data abort: " & Fault_Name_Pointer_Array (DFSR_Value.Status).all & "  (faulting PC: ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (Faulting_PC));
      HiRTOS_Low_Level_Debug_Interface.Print_String (", fault data address: ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (DFAR_Value));
      HiRTOS_Low_Level_Debug_Interface.Print_String (")" & ASCII.LF);

      raise Program_Error;
   end Handle_Data_Abort_Exception;

   procedure Initialize_Fault_Status_Registers (
      Fault_Status_Registers : out Fault_Status_Registers_Type)
   is
   begin
      Fault_Status_Registers.DFSR_Value := (others => <>);
      Fault_Status_Registers.IFSR_Value := (others => <>);
   end Initialize_Fault_Status_Registers;

   procedure Save_Fault_Status_Registers (
      Fault_Status_Registers : out Fault_Status_Registers_Type) is
   begin
      Fault_Status_Registers.DFSR_Value := Get_DFSR;
      Fault_Status_Registers.IFSR_Value := Get_IFSR;
   end Save_Fault_Status_Registers;

   procedure Restore_Fault_Status_Registers (
      Fault_Status_Registers : Fault_Status_Registers_Type) is
   begin
      Set_DFSR (Fault_Status_Registers.DFSR_Value);
      Set_IFSR (Fault_Status_Registers.IFSR_Value);
   end Restore_Fault_Status_Registers;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection;
