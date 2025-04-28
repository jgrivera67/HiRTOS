--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Memory protection services
--  for ARMv8-A EL1 MPU
--

with HiRTOS_Cpu_Arch_Interface.Memory_Protection.EL1;

package body HiRTOS_Cpu_Arch_Interface.Memory_Protection is
   use HiRTOS_Cpu_Arch_Interface.Memory_Protection.EL1;

   procedure Initialize is
      procedure Load_Memory_Attributes_Lookup_Table is
         MAIR_Value : MAIR_Type;
      begin
         --
         --  Load all memory attributes supported into MAIR_EL1 register:
         --
         MAIR_Value.Attr_Array := Memory_Attributes_Lookup_Table;
         Set_MAIR (MAIR_Value);
      end Load_Memory_Attributes_Lookup_Table;

      procedure Initialize_Translation_Table_Tree (
         Translation_Table_Tree : out Translation_Table_Tree_Type) is
      begin
         for L1_Index in Level1_Translation_Table_Entry_Index_Type loop
            declare
               L1_Entry : Translation_Table_Entry_Type renames
                 Translation_Table_Tree.Level1_Translation_Table (L1_Index);
               L2_Table : Translation_Table_Type renames
                  Translation_Table_Tree.Level2_Translation_Tables (L1_Index);
            begin
               L1_Entry.Physical_Page_Address_Prefix :=
                  Address_To_Page_Address_Prefix (L2_Table'Address);
               L1_Entry.Entry_Kind := Translation_Table_Entry_Is_Table_Or_Page;
               L1_Entry.Valid_Entry := True;
               for L2_Index in Translation_Table_Entry_Index_Type loop
                  declare
                     L2_Entry : Translation_Table_Entry_Type renames
                        L2_Table (L2_Index);
                  begin
                     L2_Entry.Physical_Page_Address_Prefix :=
                        Address_To_Page_Address_Prefix (
                           Translation_Table_Tree.Level3_Translation_Tables (L1_Index, L2_Index)'Address);
                     L2_Entry.Entry_Kind := Translation_Table_Entry_Is_Table_Or_Page;
                     L2_Entry.Valid_Entry := True;
                  end;
               end loop;
            end;
         end loop;
      end Initialize_Translation_Table_Tree;

      TCR_Value : TCR_Type;
      TTBR0_Value : TTBRn_Type;
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      Translation_Table_Tree : Translation_Table_Tree_Type renames Translation_Table_Trees (Cpu_Id);
      Level1_Translation_Table_Address : constant System.Address :=
         Translation_Table_Tree.Level1_Translation_Table'Address;
   begin
      Load_Memory_Attributes_Lookup_Table;

      --
      --  Configure translation regime:
      --  - Normal memory, Inner Non-cacheable and Outer Non-cacheable for
      --    translation table memory
      --  - Non-Sharable translation table memory
      --  - 4KB granule size
      --  - Only TTBR0 will be used
      --
      TCR_Value := (@ with delta T0SZ => Virtual_Address_Space_Size_TnSZ_Value,
                                 SH0 => Non_Shareable,
                                 TG0 => TTBR0_Granule,
                                 EPD1 => TTBR1_Translation_Table_Walk_Disabled);
      Set_TCR (TCR_Value);

      Initialize_Translation_Table_Tree (Translation_Table_Tree);

      --
      --  Set TTBR0 to point to the level1 translation table:
      --
      pragma Assert (Address_Is_Page_Aligned (Level1_Translation_Table_Address));
      TTBR0_Value.Value := Interfaces.Unsigned_64 (To_Integer (Level1_Translation_Table_Address));
      Set_TTBR0 (TTBR0_Value);
   end Initialize;

   procedure Enable_Memory_Protection (Enable_Background_Region : Boolean with Unreferenced) is
      Old_Cpu_Interrupting_State : Cpu_Register_Type;
   begin
      Old_Cpu_Interrupting_State := Disable_Cpu_Interrupting;
      Enable_MMU;
      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);
   end Enable_Memory_Protection;

   procedure Disable_Memory_Protection is
      Old_Cpu_Interrupting_State : Cpu_Register_Type;
   begin
      Old_Cpu_Interrupting_State := Disable_Cpu_Interrupting;
      Disable_MMU;
      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);
   end Disable_Memory_Protection;

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type with Unreferenced;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
   is
      Translation_Table_Tree : Translation_Table_Tree_Type renames
         Translation_Table_Trees (Get_Cpu_Id);
   begin
      Populate_Page_Translation_Tables (Translation_Table_Tree,
                                        Start_Address,
                                        Size_In_Bytes,
                                        Unprivileged_Permissions,
                                        Privileged_Permissions,
                                        Region_Attributes);
   end Configure_Memory_Region;

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type with Unreferenced;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
   is
      Translation_Table_Tree : Translation_Table_Tree_Type renames
         Translation_Table_Trees (Get_Cpu_Id);
   begin
      Populate_Page_Translation_Tables (Translation_Table_Tree,
                                        Start_Address,
                                        End_Address,
                                        Unprivileged_Permissions,
                                        Privileged_Permissions,
                                        Region_Attributes);
   end Configure_Memory_Region;

   procedure Populate_Page_Translation_Tables (
      Translation_Table_Tree : in out Translation_Table_Tree_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
   is
      End_Address : constant System.Address := System.Storage_Elements.To_Address (
         System.Storage_Elements.To_Integer (Start_Address) + Size_In_Bytes);
   begin
      Populate_Page_Translation_Tables (Translation_Table_Tree,
                                        Start_Address,
                                        End_Address,
                                        Unprivileged_Permissions,
                                        Privileged_Permissions,
                                        Region_Attributes);
   end Populate_Page_Translation_Tables;

   procedure Populate_Page_Translation_Tables (
      Translation_Table_Tree : in out Translation_Table_Tree_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Page_Attributes : Region_Attributes_Type) is
      Physical_Address : System.Address := Start_Address;
      L1_Index : Translation_Table_Entry_Index_Type :=
         Translation_Table_Entry_Index_Type (To_Integer (Start_Address) /
                                             Level1_Translation_Table_Entry_Range_Size);
      L2_Index : Translation_Table_Entry_Index_Type :=
         Translation_Table_Entry_Index_Type (
            (To_Integer (Start_Address) mod Level1_Translation_Table_Entry_Range_Size) /
            Level2_Translation_Table_Entry_Range_Size);
      L3_Index : Translation_Table_Entry_Index_Type :=
         Translation_Table_Entry_Index_Type (
            (To_Integer (Start_Address) mod Level2_Translation_Table_Entry_Range_Size) /
            Level3_Translation_Table_Entry_Range_Size);
   begin
      loop
         pragma Loop_Invariant (Physical_Address >= Start_Address and then
                                Physical_Address < End_Address);
         declare
            Level3_Translation_Table : Translation_Table_Type renames
               Translation_Table_Tree.Level3_Translation_Tables (L1_Index, L2_Index);
         begin
            Populate_Level3_Translation_Table_Entry (
               Level3_Translation_Table (L3_Index),
               Physical_Address,
               Unprivileged_Permissions,
               Privileged_Permissions,
               Page_Attributes);

            Physical_Address :=
               To_Address (To_Integer (@) + Level3_Translation_Table_Entry_Range_Size);
            exit when Physical_Address = End_Address;

            L3_Index := @ + 1;
            if L3_Index = 0 then
               L2_Index := @ + 1;
               if L2_Index = 0 then
                  L1_Index := @ + 1;
               end if;
            end if;
         end;
      end loop;
   end Populate_Page_Translation_Tables;

   procedure Populate_Level3_Translation_Table_Entry (
      Translation_Table_Entry : out Translation_Table_Entry_Type;
      Start_Physical_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Page_Attributes : Region_Attributes_Type)
   is
   begin
      Translation_Table_Entry.SH := Inner_Shareable;
      Translation_Table_Entry.PXN := Non_Executable;
      Translation_Table_Entry.UXN := Non_Executable;
      case Privileged_Permissions is
         when Read_Write =>
            if Unprivileged_Permissions = Read_Write then
               Translation_Table_Entry.AP := EL1_and_EL0_Read_Write; --  same as EL2_Read_Write_EL1_EL0_No_Access
            else
               pragma Assert (Unprivileged_Permissions = None);
               Translation_Table_Entry.AP := EL1_Read_Write_EL0_No_Access; --  same as EL2_Read_Write_EL1_EL0_No_Access
            end if;
         when Read_Only =>
            if Unprivileged_Permissions = Read_Only then
               Translation_Table_Entry.AP := EL1_and_EL0_Read_Only; --  same as EL2_and_EL1_EL0_Read_Only
            else
               pragma Assert (Unprivileged_Permissions = None);
               Translation_Table_Entry.AP := EL1_Read_Only_EL0_No_Access; --  same as EL2_Read_Only_EL1_EL0_No_Access
            end if;
         when Read_Execute =>
            Translation_Table_Entry.PXN := Executable;
            if Unprivileged_Permissions = Read_Execute then
               Translation_Table_Entry.UXN := Executable;
               Translation_Table_Entry.AP := EL1_and_EL0_Read_Only; --  same as EL2_and_EL1_EL0_Read_Only
            else
               pragma Assert (Unprivileged_Permissions = None);
               Translation_Table_Entry.AP := EL1_Read_Only_EL0_No_Access; --  same as EL2_Read_Only_EL1_EL0_No_Access
            end if;
         when Read_Write_Execute =>
            pragma Assert (Unprivileged_Permissions = Read_Write_Execute);
            Translation_Table_Entry.PXN := Executable;
            Translation_Table_Entry.AP := EL1_and_EL0_Read_Write; --  same as EL2_Read_Write_EL1_EL0_No_Access
         when others =>
            pragma Assert (False);
      end case;

      pragma Assert (Address_Is_Page_Aligned (Start_Physical_Address));
      Translation_Table_Entry.Physical_Page_Address_Prefix :=
         Address_To_Page_Address_Prefix (Start_Physical_Address);
      Translation_Table_Entry.Attr_Index := Translation_Table_MAIR_EL1_Index_Type (Page_Attributes'Enum_Rep);
      Translation_Table_Entry.AF := True;
      Translation_Table_Entry.Entry_Kind := Translation_Table_Entry_Is_Block;
      Translation_Table_Entry.Valid_Entry := True;
   end Populate_Level3_Translation_Table_Entry;

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
      Fault_Status_Registers.ESR_EL1_Value := (others => <>);
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
