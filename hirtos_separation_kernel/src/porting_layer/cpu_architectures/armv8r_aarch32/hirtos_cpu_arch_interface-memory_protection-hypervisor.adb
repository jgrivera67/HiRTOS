--
--  Copyright (c) 2022-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Memory protection services
--  for ARMv8-R EL2 MPU
--

with HiRTOS.Interrupt_Handling;
with HiRTOS_Cpu_Arch_Interface.System_Registers.Hypervisor;
with HiRTOS_Low_Level_Debug_Interface;
with HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor.EL2_MPU;

package body HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor with SPARK_Mode => On is
   use HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor.EL2_MPU;
   use HiRTOS_Cpu_Arch_Interface.System_Registers;
   use HiRTOS_Cpu_Arch_Interface.System_Registers.Hypervisor;

   function Get_Num_Regions_Supported return Mpu_Regions_Count_Type is
   begin
      return Get_HMPUIR.REGION;
   end Get_Num_Regions_Supported;

   function Is_Memory_Region_Enabled (Region_Id : Memory_Region_Id_Type) return Boolean is
      (Get_HPRLAR (Region_Id).EN = Region_Enabled);

   procedure Load_Memory_Attributes_Lookup_Table is
      MAIR_Pair : MAIR_Pair_Type;
   begin
      MAIR_Pair.Attr_Array := Memory_Attributes_Lookup_Table;
      Set_HMAIR_Pair (MAIR_Pair);
   end Load_Memory_Attributes_Lookup_Table;

   procedure Enable_Memory_Protection (Enable_Background_Region : Boolean) is
      HSCTLR_Value : HSCTLR_Type;
   begin
      Memory_Barrier;
      HSCTLR_Value := Get_HSCTLR;
      HSCTLR_Value.M := Mpu_Enabled;
      HSCTLR_Value.A := Alignment_Check_Disabled; -- To allow unaligned accesses
      --  ???SCTLR_Value.C := Cacheable; --TODO
      --  ???SCTLR_Value.I := Instruction_Access_Cacheable; --TODO: This too slow in ARM FVP simulator
      if Enable_Background_Region then
         HSCTLR_Value.BR := Background_Region_Enabled;
      else
         HSCTLR_Value.BR := Background_Region_Disabled;
      end if;

      Set_HSCTLR (HSCTLR_Value);
   end Enable_Memory_Protection;

   procedure Disable_Memory_Protection is
      HSCTLR_Value : HSCTLR_Type;
   begin
      HSCTLR_Value := Get_HSCTLR;
      HSCTLR_Value.M := Mpu_Disabled;
      HSCTLR_Value.BR := Background_Region_Disabled;
      Set_HSCTLR (HSCTLR_Value);
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

   procedure Restore_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : Memory_Region_Descriptor_Type) is
      Region_Disabled_Value : constant PRLAR_Type := (EN => Region_Disabled, others => <>);
   begin
      --
      --  NOTE: Before changing the HPRBAR/HPRLAR pair, we need to disable the region:
      --
      Set_HPRLAR (Region_Id, Region_Disabled_Value);
      Set_HPRBAR (Region_Id, Region_Descriptor.PRBAR_Value);
      Set_HPRLAR (Region_Id, Region_Descriptor.PRLAR_Value);

      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
   end Restore_Memory_Region_Descriptor;

   procedure Save_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : out Memory_Region_Descriptor_Type) is
   begin
      Region_Descriptor.PRBAR_Value := Get_HPRBAR (Region_Id);
      Region_Descriptor.PRLAR_Value := Get_HPRLAR (Region_Id);
   end Save_Memory_Region_Descriptor;

   procedure Disable_Memory_Region (Region_Id : Memory_Region_Id_Type)
   is
      PRLAR_Value : PRLAR_Type;
   begin
      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
      PRLAR_Value := Get_HPRLAR (Region_Id);
      PRLAR_Value.EN := Region_Disabled;
      Set_HPRLAR (Region_Id, PRLAR_Value);
   end Disable_Memory_Region;

   procedure Enable_Memory_Region (Region_Id : Memory_Region_Id_Type)
   is
      PRLAR_Value : PRLAR_Type;
   begin
      PRLAR_Value := Get_HPRLAR (Region_Id);
      PRLAR_Value.EN := Region_Enabled;
      Set_HPRLAR (Region_Id, PRLAR_Value);
      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
   end Enable_Memory_Region;

   procedure Enable_Memory_Regions_Bit_Mask (
      Bit_Mask : Memory_Regions_Enabled_Bit_Mask_Type) is
      HPRENR_Value : HPRENR_Type;
   begin
      HPRENR_Value := Get_HPRENR;
      HPRENR_Value.Value := @ or Bit_Mask.Value;
      Set_HPRENR (HPRENR_Value);
   end Enable_Memory_Regions_Bit_Mask;

   procedure Disable_Memory_Regions_Bit_Mask (
      Bit_Mask : Memory_Regions_Enabled_Bit_Mask_Type) is
      HPRENR_Value : HPRENR_Type;
   begin
      HPRENR_Value := Get_HPRENR;
      HPRENR_Value.Value := @ and not Bit_Mask.Value;
      Set_HPRENR (HPRENR_Value);
   end Disable_Memory_Regions_Bit_Mask;

   IFSC_Translation_Fault_Str : aliased constant String := "Translation Fault";
   IFSC_Permission_Fault_Str : aliased constant String := "Permission Fault";
   IFSC_Synchronous_External_Abort_Str : aliased constant String := "Synchronous External Abort";
   IFSC_Debug_Exception_Str : aliased constant String := "Debug Exception";

   IFSC_Str_Pointer_Array : constant array (HSR_ISS_IFSC_Type) of not null access constant String :=
      [IFSC_Translation_Fault => IFSC_Translation_Fault_Str'Access,
       IFSC_Permission_Fault => IFSC_Permission_Fault_Str'Access,
       IFSC_Synchronous_External_Abort => IFSC_Synchronous_External_Abort_Str'Access,
       IFSC_Debug_Exception => IFSC_Debug_Exception_Str'Access];

   procedure Handle_Prefetch_Abort_Exception is
      HSR_Value : HSR_Type;
      IFAR_Value : IFAR_Type;
   begin
      HSR_Value := HiRTOS_Cpu_Arch_Interface.System_Registers.Hypervisor.Get_HSR;
      IFAR_Value := Get_HIFAR;

      HiRTOS_Low_Level_Debug_Interface.Print_String (
         "*** EL2 Prefetch abort: " & IFSC_Str_Pointer_Array (HSR_Value.ISS.IFSC).all & "  (faulting PC: ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (IFAR_Value));
      HiRTOS_Low_Level_Debug_Interface.Print_String (")" & ASCII.LF);

      raise Program_Error;
   end Handle_Prefetch_Abort_Exception;

   DFSC_Translation_Fault_Str : aliased constant String := "Translation Fault";
   DFSC_Permission_Fault_Str : aliased constant String := "Permission Fault";
   DFSC_Synchronous_External_Abort_Str : aliased constant String := "Synchronous External Abort";
   DFSC_Serror_Interrupt_Str : aliased constant String := "Serror Interrupt";
   DFSC_Synchronous_Parity_Or_Ecc_Error_Str : aliased constant String := "Synchronous Parity or ECC Error";
   DFSC_Serror_Interrupt_Parity_Or_Ecc_Error_Str : aliased constant String := "Serror Interrupt Parity or ECC Error";
   DFSC_Alignment_Fault_Str : aliased constant String := "Alignment Fault";
   DFSC_Debug_Exception_Str : aliased constant String := "Debug Exception";
   DFSC_Cache_Lockdown_Fault_Str : aliased constant String := "Cache Lockdown Fault";
   DFSC_Unsupported_Exclusive_Access_Fault_Str : aliased constant String := "Unsupported Exclusive Access Fault";

   DFSC_Str_Pointer_Array : constant array (HSR_ISS_DFSC_Type) of not null access constant String :=
      [DFSC_Translation_Fault => DFSC_Translation_Fault_Str'Access,
       DFSC_Permission_Fault => DFSC_Permission_Fault_Str'Access,
       DFSC_Synchronous_External_Abort => DFSC_Synchronous_External_Abort_Str'Access,
       DFSC_Serror_Interrupt => DFSC_Serror_Interrupt_Str'Access,
       DFSC_Synchronous_Parity_Or_Ecc_Error => DFSC_Synchronous_Parity_Or_Ecc_Error_Str'Access,
       DFSC_Serror_Interrupt_Parity_Or_Ecc_Error => DFSC_Serror_Interrupt_Parity_Or_Ecc_Error_Str'Access,
       DFSC_Alignment_Fault => DFSC_Alignment_Fault_Str'Access,
       DFSC_Debug_Exception => DFSC_Debug_Exception_Str'Access,
       DFSC_Cache_Lockdown_Fault => DFSC_Cache_Lockdown_Fault_Str'Access,
       DFSC_Unsupported_Exclusive_Access_Fault => DFSC_Unsupported_Exclusive_Access_Fault_Str'Access];

   procedure Handle_Data_Abort_Exception is
      HSR_Value : HSR_Type;
      DFAR_Value : DFAR_Type;
      Faulting_PC : constant Integer_Address :=
         To_Integer (HiRTOS.Interrupt_Handling.Get_Interrupted_PC) - 8;
   begin
      HSR_Value := HiRTOS_Cpu_Arch_Interface.System_Registers.Hypervisor.Get_HSR;
      DFAR_Value := Get_HDFAR;
      HiRTOS_Low_Level_Debug_Interface.Print_String (
         "*** EL2 Data abort: " &
         (if HSR_Value.ISS.DFSC = DFSC_Permission_Fault then
            DFSC_Str_Pointer_Array (HSR_Value.ISS.DFSC).all & " - " &
            (if HSR_Value.ISS.WnR = WnR_Read_Access_Fault then
               "read"
             else
               "write") & " access"
         else
            DFSC_Str_Pointer_Array (HSR_Value.ISS.DFSC).all) & "  (faulting PC: ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (Faulting_PC));
      HiRTOS_Low_Level_Debug_Interface.Print_String (", fault data address: ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (DFAR_Value));
      HiRTOS_Low_Level_Debug_Interface.Print_String (")" & ASCII.LF);

      raise Program_Error;
   end Handle_Data_Abort_Exception;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor;
