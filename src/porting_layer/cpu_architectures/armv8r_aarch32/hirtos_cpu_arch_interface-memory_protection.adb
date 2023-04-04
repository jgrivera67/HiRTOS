--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary RTOS to target platform interface - Memory protection services
--  for ARMv8-R MPU
--

with HiRTOS.Interrupt_Handling;
with HiRTOS_Cpu_Arch_Interface.System_Registers;
with HiRTOS_Low_Level_Debug_Interface;
with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface.Memory_Protection with SPARK_Mode => On is
   use HiRTOS_Cpu_Arch_Interface.System_Registers;

   procedure Load_Memory_Attributes_Lookup_Table is
      MAIR_Pair : MAIR_Pair_Type;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;
      MAIR_Pair.Attr_Array := Memory_Attributes_Lookup_Table;
      Set_MAIR_Pair (MAIR_Pair);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Load_Memory_Attributes_Lookup_Table;

   procedure Enable_Memory_Protection is
      SCTLR_Value : SCTLR_Type;
   begin
      Memory_Barrier;
      HiRTOS.Enter_Cpu_Privileged_Mode;
      SCTLR_Value := Get_SCTLR;
      SCTLR_Value.M := EL1_Mpu_Enabled;
      SCTLR_Value.A := Alignment_Check_Disabled; -- To allow unaligned accesses
      --SCTLR_Value.C := Cacheable; --TODO
      --SCTLR_Value.I := Instruction_Access_Cacheable; --TODO: This too slow in ARM FVP simulator
      SCTLR_Value.BR := Background_Region_Enabled; -- TODO: Change this to Disabled
      Set_SCTLR (SCTLR_Value);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Enable_Memory_Protection;

   procedure Disable_Memory_Protection is
      SCTLR_Value : SCTLR_Type;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;
      SCTLR_Value := Get_SCTLR;
      SCTLR_Value.M := EL1_Mpu_Disabled;
      SCTLR_Value.BR := Background_Region_Enabled;
      Set_SCTLR (SCTLR_Value);
      HiRTOS.Exit_Cpu_Privileged_Mode;
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

   procedure Change_Memory_Region_Address_Range (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      End_Address : System.Address)
   is
      PRBAR_Value : PRBAR_Type;
      PRLAR_Value : PRLAR_Type;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;

      PRBAR_Value := Get_PRBAR (Region_Id);
      PRBAR_Value.BASE := Encode_Region_Border_Address_Field (Start_Address);
      Set_PRBAR (Region_Id, PRBAR_Value);

      PRLAR_Value := Get_PRLAR (Region_Id);
      PRLAR_Value.LIMIT := Encode_Region_Border_Address_Field (
         System.Storage_Elements.To_Address (
            System.Storage_Elements.To_Integer (End_Address - 1)));
      Set_PRLAR (Region_Id, PRLAR_Value);

      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Change_Memory_Region_Address_Range;

   procedure Clone_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Cloned_Region_Id : Memory_Region_Id_Type)
   is
      PRBAR_Value : PRBAR_Type;
      PRLAR_Value : PRLAR_Type;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;

      PRBAR_Value := Get_PRBAR (Cloned_Region_Id);
      PRBAR_Value.BASE := Encode_Region_Border_Address_Field (Start_Address);
      Set_PRBAR (Region_Id, PRBAR_Value);

      PRLAR_Value := Get_PRLAR (Cloned_Region_Id);
      PRLAR_Value.LIMIT := Encode_Region_Border_Address_Field (
         System.Storage_Elements.To_Address (
            System.Storage_Elements.To_Integer (End_Address - 1)));
      Set_PRLAR (Region_Id, PRLAR_Value);

      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Clone_Memory_Region;

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
               PRBAR_Value.AP := EL1_and_EL0_Read_Write;
            else
               pragma Assert (Unprivileged_Permissions = None);
               PRBAR_Value.AP := EL1_Read_Write_EL0_No_Access;
            end if;
         when Read_Only =>
            if Unprivileged_Permissions = Read_Only then
               PRBAR_Value.AP := EL1_and_EL0_Read_Only;
            else
               pragma Assert (Unprivileged_Permissions = None);
               PRBAR_Value.AP := EL1_Read_Only_EL0_No_Access;
            end if;
         when Read_Execute =>
            PRBAR_Value.XN := Executable;
            if Unprivileged_Permissions = Read_Execute then
               PRBAR_Value.AP := EL1_and_EL0_Read_Only;
            else
               pragma Assert (Unprivileged_Permissions = None);
               PRBAR_Value.AP := EL1_Read_Only_EL0_No_Access;
            end if;
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
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;
      Set_PRBAR (Region_Id, Region_Descriptor.PRBAR_Value);
      Set_PRLAR (Region_Id, Region_Descriptor.PRLAR_Value);
      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
      HiRTOS.Exit_Cpu_Privileged_Mode;
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
      HiRTOS.Enter_Cpu_Privileged_Mode;
      Region_Descriptor.PRBAR_Value := Get_PRBAR (Region_Id);
      Region_Descriptor.PRLAR_Value := Get_PRLAR (Region_Id);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Save_Memory_Region_Descriptor;

   procedure Disable_Memory_Region (Region_Id : Memory_Region_Id_Type)
   is
      PRLAR_Value : PRLAR_Type;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;
      PRLAR_Value := Get_PRLAR (Region_Id);
      PRLAR_Value.EN := Region_Disabled;
      Set_PRLAR (Region_Id, PRLAR_Value);
      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Disable_Memory_Region;

   procedure Enable_Memory_Region (Region_Id : Memory_Region_Id_Type)
   is
      PRLAR_Value : PRLAR_Type;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;
      PRLAR_Value := Get_PRLAR (Region_Id);
      PRLAR_Value.EN := Region_Enabled;
      Set_PRLAR (Region_Id, PRLAR_Value);
      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Enable_Memory_Region;

   procedure Handle_Prefetch_Abort_Exception is
      IFSR_Value : constant IFSR_Type := Get_IFSR;
      IFAR_Value : constant IFAR_Type := Get_IFAR;
   begin

      HiRTOS_Low_Level_Debug_Interface.Print_String (
         "*** Prefetch abort: " & Fault_Name_Pointer_Array (IFSR_Value.Status).all & "  (faulting PC: ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (IFAR_Value));
      HiRTOS_Low_Level_Debug_Interface.Print_String (")" & ASCII.LF);

      raise Program_Error;
   end Handle_Prefetch_Abort_Exception;

   procedure Handle_Data_Abort_Exception is
      DFSR_Value : constant DFSR_Type := Get_DFSR;
      DFAR_Value : constant DFAR_Type := Get_DFAR;
      Faulting_PC : constant Integer_Address :=
         To_Integer (HiRTOS.Interrupt_Handling.Get_Interrupted_PC) - 8;
   begin
      HiRTOS_Low_Level_Debug_Interface.Print_String (
         "*** Data abort: " & Fault_Name_Pointer_Array (DFSR_Value.Status).all & "  (faulting PC: ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (Faulting_PC));
      HiRTOS_Low_Level_Debug_Interface.Print_String (", fault data address: ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (DFAR_Value));
      HiRTOS_Low_Level_Debug_Interface.Print_String (")" & ASCII.LF);

      raise Program_Error;
   end Handle_Data_Abort_Exception;

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

   function Get_MPUIR return MPUIR_Type is
      MPUIR_Value : MPUIR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c0, c0, 4",
         Outputs => MPUIR_Type'Asm_Output ("=r", MPUIR_Value), --  %0
         Volatile => True);

      return MPUIR_Value;
   end Get_MPUIR;

   function Get_Selected_PRBAR return PRBAR_Type is
      PRBAR_Value : PRBAR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c6, c3, 0",
         Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value), --  %0
         Volatile => True);

      return PRBAR_Value;
   end Get_Selected_PRBAR;

   function Get_PRBAR (Region_Id : Memory_Region_Id_Type) return PRBAR_Type is
      PRBAR_Value : PRBAR_Type;
   begin
      --  To access PRBAR0 to PRBAR15:
      --  MRC p15, 0, <Rt>, c6, c8+n[3:1], 4*n[0]
      --  To access PRBAR16 to PRBAR24:
      --  MRC p15, 1, <Rt>, c6, c8+n[3:1], 4*n[0]
      case Region_Id is
         when 0 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c8, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 1 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c8, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 2 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c9, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 3 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c9, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 4 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c10, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 5 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c10, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 6 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c11, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 7 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c11, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 8 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c12, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 9 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c12, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 10 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c13, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 11 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c13, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 12 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c14, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 13 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c14, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 14 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c15, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 15 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c15, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 16 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c8, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 17 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c8, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 18 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c9, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 19 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c9, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 20 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c10, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 21 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c10, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 22 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c11, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 23 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c11, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
      end case;

      return PRBAR_Value;
   end Get_PRBAR;

   procedure Set_Selected_PRBAR (PRBAR_Value : PRBAR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c6, c3, 0",
         Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
         Volatile => True);
   end Set_Selected_PRBAR;

   procedure Set_PRBAR (Region_Id : Memory_Region_Id_Type; PRBAR_Value : PRBAR_Type) is
   begin
      --  To access PRBAR0 to PRBAR15:
      --  MCR p15, 0, <Rt>, c6, c8+n[3:1], 4*n[0]
      --  To access PRBAR16 to PRBAR24:
      --  MCR p15, 1, <Rt>, c6, c8+n[3:1], 4*n[0]
      case Region_Id is
         when 0 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c8, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 1 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c8, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 2 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c9, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 3 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c9, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 4 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c10, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 5 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c10, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 6 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c11, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 7 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c11, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 8 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c12, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 9 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c12, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 10 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c13, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 11 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c13, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 12 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c14, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 13 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c14, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 14 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c15, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 15 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c15, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 16 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c8, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 17 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c8, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 18 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c9, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 19 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c9, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 20 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c10, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 21 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c10, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 22 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c11, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 23 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c11, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
      end case;
   end Set_PRBAR;

   function Get_Selected_PRLAR return PRLAR_Type is
      PRLAR_Value : PRLAR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c6, c3, 1",
         Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value), --  %0
         Volatile => True);

      return PRLAR_Value;
   end Get_Selected_PRLAR;

   function Get_PRLAR (Region_Id : Memory_Region_Id_Type) return PRLAR_Type is
      PRLAR_Value : PRLAR_Type;
   begin
      --  To access PRLAR0 to PRLAR15:
      --  MRC p15, 0, <Rt>, c6, c8+n[3:1], 4*n[0]+1
      --  To access PRLAR16 to PRLAR24:
      --  MRC p15, 1, <Rt>, c6, c8+n[3:1], 4*n[0]+1
      case Region_Id is
         when 0 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c8, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 1 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c8, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 2 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c9, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 3 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c9, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 4 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c10, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 5 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c10, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 6 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c11, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 7 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c11, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 8 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c12, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 9 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c12, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 10 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c13, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 11 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c13, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 12 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c14, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 13 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c14, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 14 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c15, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 15 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c15, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 16 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c8, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 17 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c8, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 18 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c9, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 19 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c9, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 20 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c10, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 21 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c10, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 22 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c11, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 23 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c11, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
      end case;

      return PRLAR_Value;
   end Get_PRLAR;

   procedure Set_PRLAR (PRLAR_Value : PRLAR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c6, c3, 1",
         Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
         Volatile => True);
   end Set_PRLAR;

   procedure Set_PRLAR (Region_Id : Memory_Region_Id_Type; PRLAR_Value : PRLAR_Type) is
   begin
      --  To access PRLAR0 to PRLAR15:
      --  MCR p15, 0, <Rt>, c6, c8+n[3:1], 4*n[0]+1
      --  To access PRLAR16 to PRLAR24:
      --  MCR p15, 1, <Rt>, c6, c8+n[3:1], 4*n[0]+1
      case Region_Id is
         when 0 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c8, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 1 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c8, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 2 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c9, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 3 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c9, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 4 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c10, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 5 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c10, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 6 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c11, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 7 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c11, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 8 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c12, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 9 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c12, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 10 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c13, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 11 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c13, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 12 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c14, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 13 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c14, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 14 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c15, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 15 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c15, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 16 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c8, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 17 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c8, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 18 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c9, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 19 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c9, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 20 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c10, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 21 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c10, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 22 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c11, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 23 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c11, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
      end case;
   end Set_PRLAR;

   function Get_PRSELR return PRSELR_Type is
      PRSELR_Value : PRSELR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c6, c2, 1",
         Outputs => PRSELR_Type'Asm_Output ("=r", PRSELR_Value), --  %0
         Volatile => True);

      return PRSELR_Value;
   end Get_PRSELR;

   procedure Set_PRSELR (PRSELR_Value : PRSELR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c6, c2, 1",
         Inputs => PRSELR_Type'Asm_Input ("r", PRSELR_Value), --  %0
         Volatile => True);
   end Set_PRSELR;

   function Get_MAIR_Pair return MAIR_Pair_Type is
      MAIR_Pair : MAIR_Pair_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c10, c2, 0",
         Outputs => Interfaces.Unsigned_32'Asm_Output ("=r", MAIR_Pair.MAIR0), --  %0
         Volatile => True);

      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c10, c2, 1",
         Outputs => Interfaces.Unsigned_32'Asm_Output ("=r", MAIR_Pair.MAIR1), --  %0
         Volatile => True);

      return MAIR_Pair;
   end Get_MAIR_Pair;

   procedure Set_MAIR_Pair (MAIR_Pair : MAIR_Pair_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c10, c2, 0",
         Inputs => Interfaces.Unsigned_32'Asm_Input ("r", MAIR_Pair.MAIR0), --  %0
         Volatile => True);

      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c10, c2, 1",
         Inputs => Interfaces.Unsigned_32'Asm_Input ("r", MAIR_Pair.MAIR1), --  %0
         Volatile => True);
   end Set_MAIR_Pair;

   function Get_DFAR return DFAR_Type is
      DFAR_Value : DFAR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c6, c0, 0",
         Outputs => DFAR_Type'Asm_Output ("=r", DFAR_Value), --  %0
         Volatile => True);

      return DFAR_Value;
   end Get_DFAR;

   function Get_DFSR return DFSR_Type is
      DFSR_Value : DFSR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c5, c0, 0",
         Outputs => DFSR_Type'Asm_Output ("=r", DFSR_Value), --  %0
         Volatile => True);

      return DFSR_Value;
   end Get_DFSR;

   function Get_IFAR return IFAR_Type is
      IFAR_Value : IFAR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c6, c0, 2",
         Outputs => IFAR_Type'Asm_Output ("=r", IFAR_Value), --  %0
         Volatile => True);

      return IFAR_Value;
   end Get_IFAR;

   function Get_IFSR return IFSR_Type is
      IFSR_Value : IFSR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c5, c0, 1",
         Outputs => IFSR_Type'Asm_Output ("=r", IFSR_Value), --  %0
         Volatile => True);

      return IFSR_Value;
   end Get_IFSR;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection;