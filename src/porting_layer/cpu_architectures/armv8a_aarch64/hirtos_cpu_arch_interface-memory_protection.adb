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
with HiRTOS_Low_Level_Debug_Interface;
with HiRTOS_Cpu_Arch_Interface_Private;

package body HiRTOS_Cpu_Arch_Interface.Memory_Protection is
   use HiRTOS_Cpu_Arch_Interface.Memory_Protection.EL1;
   use HiRTOS_Cpu_Arch_Interface_Private;

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

      TCR_Value : TCR_Type;
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      Translation_Table_Tree : Translation_Table_Tree_Type renames Translation_Table_Trees (Cpu_Id);
   begin
      pragma Assert (Level3_Translation_Table_Entry_Range_Size = Page_Size_In_Bytes);
      pragma Assert (
         Virtual_Address_Space_Size_In_Bytes <=
            Max_Num_Translation_Table_Entries * Level1_Translation_Table_Entry_Range_Size);
      pragma Assert (
         Virtual_Address_Space_Size_In_Bytes mod Level1_Translation_Table_Entry_Range_Size = 0);

      Initialize_Translation_Table_Tree (Translation_Table_Tree,
                                         Translation_Tables (Cpu_Id)'Access);

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
                                 IRGN0 => TT_Normal_Memory_Write_Back_Read_Allocate_Write_Allocate_Cacheable,
                                 ORGN0 => TT_Normal_Memory_Write_Back_Read_Allocate_Write_Allocate_Cacheable,
                                 SH0 => Inner_Shareable,
                                 TG0 => TTBR0_Granule,
                                 EPD1 => TTBR1_Translation_Table_Walk_Disabled,
                                 T1SZ => Virtual_Address_Space_Size_TnSZ_Value,
                                 IRGN1 => TT_Normal_Memory_Write_Back_Read_Allocate_Write_Allocate_Cacheable,
                                 ORGN1 => TT_Normal_Memory_Write_Back_Read_Allocate_Write_Allocate_Cacheable,
                                 SH1 => Inner_Shareable,
                                 TG1 => TG1_4KB,
                                 IPS => IPS_40_Bits,
                                 HA => Hardware_Access_Flag_Update_Enabled);
      Set_TCR (TCR_Value);

      --
      --  Set TTBR0 to point to the level1 translation table:
      --
      declare
         L1_Table_Id : constant Translation_Table_Id_Type :=
            Translation_Table_Tree.Level1_Translation_Table_Id;
         L1_Table : Translation_Table_Type renames
            Translation_Table_Tree.Tables_Pointer.all (L1_Table_Id);
         TTBR0_Value : TTBRn_Type;
      begin
         pragma Assert (Address_Is_Page_Aligned (L1_Table'Address));
         TTBR0_Value.Value := Interfaces.Unsigned_64 (To_Integer (L1_Table'Address));
         Set_TTBR0 (TTBR0_Value);
      end;
   end Initialize;

   procedure Initialize_Translation_Table_Tree (
      Translation_Table_Tree : out Translation_Table_Tree_Type;
      Translation_Tables_Pointer : Translation_Tables_Array_Pointer_Type) is
      L1_Table_Id : Translation_Table_Id_Type;
   begin
      Translation_Table_Tree.Tables_Pointer := Translation_Tables_Pointer;
      Translation_Table_Tree.Next_Free_Table_Index := Valid_Translation_Table_Id_Type'First;
      Allocate_Translation_Table (Translation_Table_Tree, L1_Table_Id);
      Translation_Table_Tree.Level1_Translation_Table_Id := L1_Table_Id;
   end Initialize_Translation_Table_Tree;

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
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      Size_In_Bytes : Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with SPARK_Mode => On
   is
      End_Address : constant System.Address := To_Address (
         To_Integer (Start_Address) + Size_In_Bytes);
   begin
      Configure_Memory_Region (Region_Id,
                               Start_Address,
                               End_Address,
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
      Populate_Level1_Translation_Table (Translation_Table_Tree,
                                         Start_Address,
                                         End_Address,
                                         Unprivileged_Permissions,
                                         Privileged_Permissions,
                                         Region_Attributes);
      if Region_Attributes = Normal_Memory_Write_Back_Cacheable or else
         Region_Attributes = Normal_Memory_Write_Through_Cacheable
      then
         if Caches_Are_Enabled then
            Flush_Invalidate_Data_Cache_Range (Start_Address, End_Address);
         else
            Invalidate_Data_Cache_Range (Start_Address, End_Address);
         end if;
      end if;
   end Configure_Memory_Region;

   procedure Populate_Level1_Translation_Table (
      Translation_Table_Tree : in out Translation_Table_Tree_Type;
      Start_Virtual_Address : System.Address;
      End_Virtual_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
   is
      L1_First_Index : constant Translation_Table_Entry_Index_Type :=
         Address_To_Level1_Table_Index (Start_Virtual_Address);
      Last_Virtual_Address : constant System.Address :=
         To_Address (To_Integer (End_Virtual_Address) - 1);
      L1_Last_Index : constant Translation_Table_Entry_Index_Type :=
         Address_To_Level1_Table_Index (Last_Virtual_Address);
      L1_Table_Id : constant Translation_Table_Id_Type :=
         Translation_Table_Tree.Level1_Translation_Table_Id;
      L1_Table : Translation_Table_Type renames
         Translation_Table_Tree.Tables_Pointer.all (L1_Table_Id);
   begin
      for L1_Index in L1_First_Index .. L1_Last_Index loop
         declare
            L1_Start_Virtual_Address : constant System.Address :=
               (if L1_Index > L1_First_Index then
                   Level1_Table_Index_To_Base_Virtual_Address (L1_Index)
                else
                  Start_Virtual_Address);
            L1_End_Virtual_Address : constant System.Address :=
               (if L1_Index < L1_Last_Index then
                   Level1_Table_Index_To_Base_Virtual_Address (L1_Index + 1)
                else
                   End_Virtual_Address);
         begin
            pragma Loop_Invariant (
               L1_Start_Virtual_Address < L1_End_Virtual_Address and then
               L1_Start_Virtual_Address >= Start_Virtual_Address and then
               L1_End_Virtual_Address <= End_Virtual_Address and then
               (if L1_Start_Virtual_Address > Start_Virtual_Address then
                   Address_Is_Aligned_To_Level1_Table_Entry_Range (L1_Start_Virtual_Address)) and then
               (if L1_End_Virtual_Address < End_Virtual_Address then
                   Address_Is_Aligned_To_Level1_Table_Entry_Range (L1_End_Virtual_Address)));

            Populate_Level1_Translation_Table_Entry (
               Translation_Table_Tree,
               L1_Table (L1_Index),
               L1_Start_Virtual_Address,
               L1_End_Virtual_Address,
               Unprivileged_Permissions,
               Privileged_Permissions,
               Region_Attributes);
         end;
      end loop;
   end Populate_Level1_Translation_Table;

   procedure Populate_Level1_Translation_Table_Entry (
      Translation_Table_Tree : in out Translation_Table_Tree_Type;
      L1_Translation_Table_Entry : out Translation_Table_Entry_Type;
      Start_Virtual_Address : System.Address;
      End_Virtual_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
   is
      L2_Table_Id : Translation_Table_Id_Type;
   begin
      if L1_Translation_Table_Entry.Valid_Entry = 1 then
         if L1_Translation_Table_Entry.Entry_Kind = Translation_Table_Entry_Is_Block then
            raise Program_Error with "Cannot overwrite existing entry";
         end if;

         declare
            L2_Table_Address : constant System.Address :=
               Page_Address_Prefix_To_Address (L1_Translation_Table_Entry.Page_Address_Prefix);
            L2_Table : Translation_Table_Type with Import, Address => L2_Table_Address;
         begin
            Populate_Level2_Translation_Table (
               Translation_Table_Tree,
               L2_Table,
               Start_Virtual_Address,
               End_Virtual_Address,
               Unprivileged_Permissions,
               Privileged_Permissions,
               Region_Attributes);
         end;
      else
         if Address_Is_Aligned_To_Level1_Table_Entry_Range (Start_Virtual_Address) and then
            Address_Is_Aligned_To_Level1_Table_Entry_Range (End_Virtual_Address)
         then
            --
            --  Block of memory is aligned to level 1 translation table entry size
            --  (e.g. 1GB for 4KB page granule size)
            --
            Populate_Translation_Table_Leaf_Entry (
               L1_Translation_Table_Entry,
               Start_Virtual_Address,
               Unprivileged_Permissions,
               Privileged_Permissions,
               Region_Attributes,
               TT_Level1);
         else
            Allocate_Translation_Table (Translation_Table_Tree, L2_Table_Id);
            declare
               L2_Table : Translation_Table_Type renames
                  Translation_Table_Tree.Tables_Pointer.all (L2_Table_Id);
            begin
               Populate_Level2_Translation_Table (
                  Translation_Table_Tree,
                  L2_Table,
                  Start_Virtual_Address,
                  End_Virtual_Address,
                  Unprivileged_Permissions,
                  Privileged_Permissions,
                  Region_Attributes);

               Populate_Translation_Table_Inner_Entry (
                  L1_Translation_Table_Entry,
                  L2_Table'Address);
            end;
         end if;
      end if;
   end Populate_Level1_Translation_Table_Entry;

   procedure Populate_Level2_Translation_Table (
      Translation_Table_Tree : in out Translation_Table_Tree_Type;
      L2_Translation_Table : out Translation_Table_Type;
      Start_Virtual_Address : System.Address;
      End_Virtual_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
   is
      L1_Index : constant Translation_Table_Entry_Index_Type :=
         Address_To_Level1_Table_Index (Start_Virtual_Address);
      L2_First_Index : constant Translation_Table_Entry_Index_Type :=
         Address_To_Level2_Table_Index (Start_Virtual_Address);
      Last_Virtual_Address : constant System.Address :=
         To_Address (To_Integer (End_Virtual_Address) - 1);
      L2_Last_Index : constant Translation_Table_Entry_Index_Type :=
         Address_To_Level2_Table_Index (Last_Virtual_Address);
   begin
      for L2_Index in L2_First_Index .. L2_Last_Index loop
         declare
            L2_Start_Virtual_Address : constant System.Address :=
               (if L2_Index > L2_First_Index then
                   Level2_Table_Index_To_Base_Virtual_Address (L1_Index, L2_Index)
                else
                  Start_Virtual_Address);
            L2_End_Virtual_Address : constant System.Address :=
               (if L2_Index < L2_Last_Index then
                   Level2_Table_Index_To_Base_Virtual_Address (L1_Index, L2_Index + 1)
                else
                   End_Virtual_Address);
         begin
            pragma Loop_Invariant (
               L2_Start_Virtual_Address < L2_End_Virtual_Address and then
               L2_Start_Virtual_Address >= Start_Virtual_Address and then
               L2_End_Virtual_Address <= End_Virtual_Address and then
               (if L2_Start_Virtual_Address > Start_Virtual_Address then
                   Address_Is_Aligned_To_Level2_Table_Entry_Range (L2_Start_Virtual_Address)) and then
               (if L2_End_Virtual_Address < End_Virtual_Address then
                   Address_Is_Aligned_To_Level2_Table_Entry_Range (L2_End_Virtual_Address)));

            Populate_Level2_Translation_Table_Entry (
               Translation_Table_Tree,
               L2_Translation_Table (L2_Index),
               L2_Start_Virtual_Address,
               L2_End_Virtual_Address,
               Unprivileged_Permissions,
               Privileged_Permissions,
               Region_Attributes);
         end;
      end loop;
   end Populate_Level2_Translation_Table;

   procedure Populate_Level2_Translation_Table_Entry (
      Translation_Table_Tree : in out Translation_Table_Tree_Type;
      L2_Translation_Table_Entry : out Translation_Table_Entry_Type;
      Start_Virtual_Address : System.Address;
      End_Virtual_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
   is
      L3_Table_Id : Translation_Table_Id_Type;
   begin
      if L2_Translation_Table_Entry.Valid_Entry = 1 then
         if L2_Translation_Table_Entry.Entry_Kind = Translation_Table_Entry_Is_Block then
            raise Program_Error with "Cannot overwrite existing entry";
         end if;

         declare
            L3_Table_Address : constant System.Address :=
               Page_Address_Prefix_To_Address (L2_Translation_Table_Entry.Page_Address_Prefix);
            L3_Table : Translation_Table_Type with Import, Address => L3_Table_Address;
         begin
            Populate_Level3_Translation_Table (
               L3_Table,
               Start_Virtual_Address,
               End_Virtual_Address,
               Unprivileged_Permissions,
               Privileged_Permissions,
               Region_Attributes);
         end;
      else
         if Address_Is_Aligned_To_Level2_Table_Entry_Range (Start_Virtual_Address) and then
            Address_Is_Aligned_To_Level2_Table_Entry_Range (End_Virtual_Address)
         then
            --
            --  Block of memory is aligned to level 2 translation table entry size
            --  (e.g. 2MB for 4KB page granule size)
            --
            Populate_Translation_Table_Leaf_Entry (
               L2_Translation_Table_Entry,
               Start_Virtual_Address,
               Unprivileged_Permissions,
               Privileged_Permissions,
               Region_Attributes,
               TT_Level2);
         else
            Allocate_Translation_Table (Translation_Table_Tree, L3_Table_Id);
            declare
               L3_Table : Translation_Table_Type renames
                  Translation_Table_Tree.Tables_Pointer.all (L3_Table_Id);
            begin
               Populate_Level3_Translation_Table (
                  L3_Table,
                  Start_Virtual_Address,
                  End_Virtual_Address,
                  Unprivileged_Permissions,
                  Privileged_Permissions,
                  Region_Attributes);

               Populate_Translation_Table_Inner_Entry (
                  L2_Translation_Table_Entry,
                  L3_Table'Address);
            end;
         end if;
      end if;
   end Populate_Level2_Translation_Table_Entry;

   procedure Populate_Level3_Translation_Table (
      L3_Translation_Table : out Translation_Table_Type;
      Start_Virtual_Address : System.Address;
      End_Virtual_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
   is
      L3_First_Index : constant Translation_Table_Entry_Index_Type :=
         Address_To_Level3_Table_Index (Start_Virtual_Address);
      Last_Virtual_Address : constant System.Address :=
         To_Address (To_Integer (End_Virtual_Address) - 1);
      L3_Last_Index : constant Translation_Table_Entry_Index_Type :=
         Address_To_Level3_Table_Index (Last_Virtual_Address);
      L3_Start_Virtual_Address : System.Address := Start_Virtual_Address;
   begin
      for L3_Index in L3_First_Index .. L3_Last_Index loop
         pragma Loop_Invariant (L3_Start_Virtual_Address >= Start_Virtual_Address and then
                                L3_Start_Virtual_Address < End_Virtual_Address);
         Populate_Translation_Table_Leaf_Entry (
            L3_Translation_Table (L3_Index),
            L3_Start_Virtual_Address,
            Unprivileged_Permissions,
            Privileged_Permissions,
            Region_Attributes,
            TT_Level3);

         L3_Start_Virtual_Address :=
            To_Address (To_Integer (@) + Level3_Translation_Table_Entry_Range_Size);
      end loop;
   end Populate_Level3_Translation_Table;

   procedure Populate_Translation_Table_Inner_Entry (
      Translation_Table_Entry : out Translation_Table_Entry_Type;
      Child_Translation_Table_Address : System.Address)
   is
   begin
      Translation_Table_Entry.Page_Address_Prefix :=
         Address_To_Page_Address_Prefix (Child_Translation_Table_Address);
      Translation_Table_Entry.Entry_Kind := Translation_Table_Entry_Is_Table_Or_Page;
      Translation_Table_Entry.Valid_Entry := 1;
   end Populate_Translation_Table_Inner_Entry;

   procedure Populate_Translation_Table_Leaf_Entry (
      Translation_Table_Entry : out Translation_Table_Entry_Type;
      Start_Physical_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type;
      Translation_Table_Level : Translation_Table_Level_Type)
   is
      Entry_Kind : constant Translation_Table_Entry_Kind_Type :=
         (if Translation_Table_Level = TT_Level3 then
            Translation_Table_Entry_Is_Table_Or_Page
          else
            Translation_Table_Entry_Is_Block);
   begin
      Translation_Table_Entry.SH := Inner_Shareable;
      Translation_Table_Entry.PXN := Non_Executable;
      Translation_Table_Entry.UXN := Non_Executable;
      case Privileged_Permissions is
         when Read_Write =>
            if Unprivileged_Permissions = Read_Write then
               Translation_Table_Entry.AP := EL1_and_EL0_Read_Write;
            else
               pragma Assert (Unprivileged_Permissions = None);
               Translation_Table_Entry.AP := EL1_Read_Write_EL0_No_Access;
            end if;
         when Read_Only =>
            if Unprivileged_Permissions = Read_Only then
               Translation_Table_Entry.AP := EL1_and_EL0_Read_Only;
            else
               pragma Assert (Unprivileged_Permissions = None);
               Translation_Table_Entry.AP := EL1_Read_Only_EL0_No_Access;
            end if;
         when Read_Execute =>
            Translation_Table_Entry.PXN := Executable;
            if Unprivileged_Permissions = Read_Execute then
               Translation_Table_Entry.UXN := Executable;
               Translation_Table_Entry.AP := EL1_and_EL0_Read_Only;
            else
               pragma Assert (Unprivileged_Permissions = None);
               Translation_Table_Entry.AP := EL1_Read_Only_EL0_No_Access;
            end if;
         when Read_Write_Execute =>
            pragma Assert (Unprivileged_Permissions = Read_Write_Execute);
            Translation_Table_Entry.PXN := Executable;
            Translation_Table_Entry.UXN := Executable;
            Translation_Table_Entry.AP := EL1_and_EL0_Read_Write;
         when None =>
            null;
      end case;

      Translation_Table_Entry.Page_Address_Prefix :=
         Address_To_Page_Address_Prefix (Start_Physical_Address);
      Translation_Table_Entry.Attr_Index :=
         Translation_Table_MAIR_EL1_Index_Type (Region_Attributes'Enum_Rep);
      Translation_Table_Entry.AF := 1;
      Translation_Table_Entry.nG := 0;
      Translation_Table_Entry.NS := 1;
      Translation_Table_Entry.Entry_Kind := Entry_Kind;
      Translation_Table_Entry.Valid_Entry := 1;

      if Debug_On then
         Print_Translation_Table_Leaf_Entry (Translation_Table_Entry,
                                             Start_Physical_Address,
                                             Start_Physical_Address,
                                             Unprivileged_Permissions,
                                             Privileged_Permissions,
                                             Region_Attributes,
                                             Translation_Table_Level);
      end if;
   end Populate_Translation_Table_Leaf_Entry;

   procedure Print_Translation_Table_Leaf_Entry (
      Translation_Table_Entry : Translation_Table_Entry_Type;
      Start_Virtual_Address : System.Address;
      Start_Physical_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Caching_Attributes : Region_Attributes_Type;
      Translation_Table_Level : Translation_Table_Level_Type)
   is
      procedure Print_Permissions (Permissions : Region_Permissions_Type)
      is
      begin
         case Permissions is
            when Read_Write =>
               HiRTOS_Low_Level_Debug_Interface.Print_String ("rw-");
            when Read_Only =>
               HiRTOS_Low_Level_Debug_Interface.Print_String ("r--");
            when Read_Execute =>
               HiRTOS_Low_Level_Debug_Interface.Print_String ("r-x");
            when Read_Write_Execute =>
               HiRTOS_Low_Level_Debug_Interface.Print_String ("rwx");
            when None =>
               HiRTOS_Low_Level_Debug_Interface.Print_String ("---");
         end case;
      end Print_Permissions;

      procedure Print_Caching_Attributes (Caching_Attributes : Region_Attributes_Type)
      is
      begin
         case Caching_Attributes is
            when Device_Memory_Mapped_Io =>
               HiRTOS_Low_Level_Debug_Interface.Print_String ("device-memory");
            when Normal_Memory_Non_Cacheable =>
               HiRTOS_Low_Level_Debug_Interface.Print_String ("normal-memory-non-cacheable");
            when Normal_Memory_Write_Through_Cacheable =>
               HiRTOS_Low_Level_Debug_Interface.Print_String ("normal-memory-write-through-cacheable");
            when Normal_Memory_Write_Back_Cacheable =>
               HiRTOS_Low_Level_Debug_Interface.Print_String ("normal-memory-write-back-cacheable");
         end case;
      end Print_Caching_Attributes;
   begin
      HiRTOS_Low_Level_Debug_Interface.Print_String ("Level ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (Translation_Table_Level'Enum_Rep);
      HiRTOS_Low_Level_Debug_Interface.Print_String (" translation (");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Translation_Table_Entry.Value);
      HiRTOS_Low_Level_Debug_Interface.Print_String (")");
      if Start_Virtual_Address = Start_Physical_Address then
         HiRTOS_Low_Level_Debug_Interface.Print_String (" VA=PA=");
         HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (
            Interfaces.Unsigned_64 (To_Integer (Start_Physical_Address)));
      else
         HiRTOS_Low_Level_Debug_Interface.Print_String (" VA=");
         HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (
            Interfaces.Unsigned_64 (To_Integer (Start_Virtual_Address)));
         HiRTOS_Low_Level_Debug_Interface.Print_String (" PA=");
         HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (
            Interfaces.Unsigned_64 (To_Integer (Start_Physical_Address)));
      end if;

      HiRTOS_Low_Level_Debug_Interface.Print_String (" Privileged Perms=");
      Print_Permissions (Privileged_Permissions);
      HiRTOS_Low_Level_Debug_Interface.Print_String (" Unprivileged Perms=");
      Print_Permissions (Unprivileged_Permissions);
      HiRTOS_Low_Level_Debug_Interface.Print_String (" Caching Attrs=");
      Print_Caching_Attributes (Caching_Attributes);
      HiRTOS_Low_Level_Debug_Interface.Put_Char (ASCII.LF);
   end Print_Translation_Table_Leaf_Entry;

   procedure Allocate_Translation_Table (
      Translation_Table_Tree : in out Translation_Table_Tree_Type;
      Translation_Table_Id : out Valid_Translation_Table_Id_Type) is
      Old_Cpu_Interrupting_State : constant Cpu_Register_Type :=
         HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
   begin
      if Translation_Table_Tree.Next_Free_Table_Index = Translation_Table_Id_Type'Last then
         raise Program_Error with "No more translation tables available";
      end if;

      Translation_Table_Id := Translation_Table_Tree.Next_Free_Table_Index;
      Translation_Table_Tree.Next_Free_Table_Index := @ + 1;

      Translation_Table_Tree.Tables_Pointer.all (Translation_Table_Id) := [others => <>];
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);
   end Allocate_Translation_Table;

   procedure Restore_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : Memory_Region_Descriptor_Type) is
   begin
      null; --  TODO: Implement this
      Memory_Barrier;
   end Restore_Memory_Region_Descriptor;

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
   is
      End_Address : constant System.Address := To_Address (
         To_Integer (Start_Address) + Size_In_Bytes);
   begin
      Initialize_Memory_Region_Descriptor (Region_Descriptor,
                                           Start_Address,
                                           End_Address,
                                           Unprivileged_Permissions,
                                           Privileged_Permissions,
                                           Region_Attributes);
   end Initialize_Memory_Region_Descriptor;

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type with Unreferenced;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type) is
   begin
      Configure_Memory_Region (Memory_Region_Id_Type'Last,
                               Start_Address,
                               End_Address,
                               Unprivileged_Permissions,
                               Privileged_Permissions,
                               Region_Attributes);
   end Initialize_Memory_Region_Descriptor;

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
