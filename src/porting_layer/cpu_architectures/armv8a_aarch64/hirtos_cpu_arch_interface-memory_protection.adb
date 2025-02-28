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

--??? with HiRTOS.Interrupt_Handling;
--??? with HiRTOS_Low_Level_Debug_Interface;

package body HiRTOS_Cpu_Arch_Interface.Memory_Protection is

   function Get_Num_Regions_Supported return Mpu_Regions_Count_Type is
   begin
      return Mpu_32_Regions; -- TODO: Change this to the right value
   end Get_Num_Regions_Supported;

   procedure Initialize is
   begin
      null; --  TODO: Implement this
   end Initialize;

   procedure Enable_Memory_Protection (Enable_Background_Region : Boolean) is
   begin
      Memory_Barrier;
      null; --  TODO: Implement this
   end Enable_Memory_Protection;

   procedure Disable_Memory_Protection is
   begin
      null; --  TODO: Implement this
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
   begin
      null; --  TODO: Implement this
   end Initialize_Memory_Region_Descriptor;

   procedure Restore_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : Memory_Region_Descriptor_Type) is
   begin
      null; --  TODO: Implement this
      Memory_Barrier;
   end Restore_Memory_Region_Descriptor;

   procedure Initialize_Memory_Region_Descriptor_Disabled (
      Region_Descriptor : out Memory_Region_Descriptor_Type) is
   begin
      null; --  TODO: Implement this
   end Initialize_Memory_Region_Descriptor_Disabled;

   procedure Save_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : out Memory_Region_Descriptor_Type) is
   begin
      null; --  TODO: Implement this
   end Save_Memory_Region_Descriptor;

   procedure Disable_Memory_Region (Region_Id : Memory_Region_Id_Type)
   is
   begin
      Memory_Barrier;
      null; --  TODO: Implement this
   end Disable_Memory_Region;

   procedure Enable_Memory_Region (Region_Id : Memory_Region_Id_Type)
   is
   begin
      null; --  TODO: Implement this
   end Enable_Memory_Region;

   function Is_Memory_Region_Enabled (Region_Id : Memory_Region_Id_Type) return Boolean is
      (True); --  TODO: Implement this

   procedure Handle_Prefetch_Abort_Exception is
   begin
      null; --  TODO: Implement this

      --  HiRTOS_Low_Level_Debug_Interface.Print_String (
      --     "*** EL1 Prefetch abort: " & Fault_Name_Pointer_Array (IFSR_Value.Status).all & "  (faulting PC: ");
      --  HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (IFAR_Value));
      --  HiRTOS_Low_Level_Debug_Interface.Print_String (")" & ASCII.LF);

      raise Program_Error;
   end Handle_Prefetch_Abort_Exception;

   procedure Handle_Data_Abort_Exception is
      --  Faulting_PC : constant Integer_Address :=
      --     To_Integer (HiRTOS.Interrupt_Handling.Get_Interrupted_PC) - 8;
   begin
      null; --  TODO: Implement this

      --  HiRTOS_Low_Level_Debug_Interface.Print_String (
      --     "*** EL1 Data abort: " & Fault_Name_Pointer_Array (DFSR_Value.Status).all & "  (faulting PC: ");
      --  HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (Faulting_PC));
      --  HiRTOS_Low_Level_Debug_Interface.Print_String (", fault data address: ");
      --  HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (DFAR_Value));
      --  HiRTOS_Low_Level_Debug_Interface.Print_String (")" & ASCII.LF);

      raise Program_Error;
   end Handle_Data_Abort_Exception;

   procedure Initialize_Fault_Status_Registers (
      Fault_Status_Registers : out Fault_Status_Registers_Type)
   is
   begin
      Fault_Status_Registers.ESR_EL1_Value := 0; --  TODO: Initialize to right default (others => <>);
      Fault_Status_Registers.FAR_EL1_Value := 0; --  TODO: Initialize to right default (others => <>);
      Fault_Status_Registers.SCTLR_EL1_Value := System_Registers.Get_SCTLR_EL1;
   end Initialize_Fault_Status_Registers;

   procedure Save_Fault_Status_Registers (
      Fault_Status_Registers : out Fault_Status_Registers_Type) is
   begin
      Fault_Status_Registers.ESR_EL1_Value := System_Registers.Get_ESR_EL1;
      Fault_Status_Registers.FAR_EL1_Value := System_Registers.Get_FAR_EL1;
      Fault_Status_Registers.SCTLR_EL1_Value := System_Registers.Get_SCTLR_EL1;
   end Save_Fault_Status_Registers;

   procedure Restore_Fault_Status_Registers (
      Fault_Status_Registers : Fault_Status_Registers_Type) is
   begin
      System_Registers.Set_ESR_EL1 (Fault_Status_Registers.ESR_EL1_Value);
      System_Registers.Set_FAR_EL1 (Fault_Status_Registers.FAR_EL1_Value);
      System_Registers.Set_SCTLR_EL1 (Fault_Status_Registers.SCTLR_EL1_Value);
      Strong_Memory_Barrier;
   end Restore_Fault_Status_Registers;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection;
