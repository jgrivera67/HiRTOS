--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Memory protection services
--  for ARMv8-R Supervisor MPU
--

with HiRTOS_Cpu_Arch_Parameters;
private with HiRTOS_Cpu_Multi_Core_Interface;
private with HiRTOS_Cpu_Arch_Interface.System_Registers;

package HiRTOS_Cpu_Arch_Interface.Memory_Protection
   with SPARK_Mode => On
is
   use type System.Address;

   type Memory_Region_Descriptor_Type is limited private;

   type Region_Permissions_Type is (None,
                                    Read_Only,
                                    Read_Write,
                                    Read_Execute,
                                    Read_Write_Execute);

   type Region_Attributes_Type is (
      --  MMIO space:
      Device_Memory_Mapped_Io,
      --  RAM space:
      Normal_Memory_Non_Cacheable,
      Normal_Memory_Write_Through_Cacheable,
      Normal_Memory_Write_Back_Cacheable);

   Max_Num_Memory_Regions : constant := 32;

   type Memory_Region_Id_Type is mod Max_Num_Memory_Regions;

   --
   --  Mapping of logical memory protection regions to MPU region Ids
   --
   type Memory_Region_Role_Type is
     (
      Global_Code_Region,
      Global_Rodata_Region,
      Null_Pointer_Dereference_Guard,
      Global_Interrupt_Stack_Overflow_Guard,
      Global_Interrupt_Stack_Region,
      Thread_Stack_Overflow_Guard,
      Thread_Stack_Data_Region,
      Thread_Private_Data_Region,
      Thread_Private_Data2_Region,
      Thread_Private_Mmio_Region,

      --  Valid region roles must be added before this entry:
      Invalid_Region_Role);

   for Memory_Region_Role_Type use
     (
      Global_Code_Region => 0,
      Global_Rodata_Region => 1,
      Null_Pointer_Dereference_Guard => 2,
      Global_Interrupt_Stack_Overflow_Guard => 3,
      Global_Interrupt_Stack_Region => 4,
      Thread_Stack_Overflow_Guard => 5,
      Thread_Stack_Data_Region => 6,
      Thread_Private_Data_Region => 7,
      Thread_Private_Data2_Region => 8,
      Thread_Private_Mmio_Region => 9,

      --  Valid region roles must be added before this entry:
      Invalid_Region_Role => Max_Num_Memory_Regions);

   procedure Initialize
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Enables memory protection hardware
   --
   procedure Enable_Memory_Protection (Enable_Background_Region : Boolean)
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Disables memory protection hardware
   --
   procedure Disable_Memory_Protection
      with Pre => Cpu_In_Privileged_Mode;

   function Address_Is_Page_Aligned (Address : System.Address) return Boolean is
      (To_Integer (Address) mod HiRTOS_Cpu_Arch_Parameters.Page_Size_In_Bytes = 0);

   Virtual_Address_Space_Size_In_Bytes : constant Integer_Address;

   type Translation_Table_Tree_Type is limited private;

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      Size_In_Bytes : Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => Cpu_In_Privileged_Mode and then
                  Address_Is_Page_Aligned (Start_Address) and then
                  Size_In_Bytes > 0 and then
                  Size_In_Bytes mod HiRTOS_Cpu_Arch_Parameters.Page_Size_In_Bytes = 0;

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => Cpu_In_Privileged_Mode and then
                  Address_Is_Page_Aligned (Start_Address) and then
                  Address_Is_Page_Aligned (End_Address) and then
                  To_Integer (Start_Address) < To_Integer (End_Address);

   --
   --  Populates the page translation tables for the given physical address range
   --  using identity mapping (virtual address = physical address).
   --
   procedure Populate_Page_Translation_Tables (
      Translation_Table_Tree : in out Translation_Table_Tree_Type;
      Start_Address : System.Address;
      Size_In_Bytes : Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => Address_Is_Page_Aligned (Start_Address) and then
                  Size_In_Bytes > 0 and then
                  Size_In_Bytes mod HiRTOS_Cpu_Arch_Parameters.Page_Size_In_Bytes = 0;

   --
   --  Populates the page translation tables for the given address range
   --  using identity mapping (virtual address = physical address).
   --
   procedure Populate_Page_Translation_Tables (
      Translation_Table_Tree : in out Translation_Table_Tree_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Page_Attributes : Region_Attributes_Type)
      with Pre => Cpu_In_Privileged_Mode and then
                  Address_Is_Page_Aligned (Start_Address) and then
                  Start_Address /= System.Null_Address and then
                  Address_Is_Page_Aligned (End_Address) and then
                  To_Integer (End_Address) <= Virtual_Address_Space_Size_In_Bytes and then
                  To_Integer (Start_Address) < To_Integer (End_Address);

   procedure Initialize_Memory_Region_Descriptor_Disabled (
      Region_Descriptor : out Memory_Region_Descriptor_Type);

   function Is_Memory_Region_Enabled (Region_Id : Memory_Region_Id_Type) return Boolean
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Copies saved state of a memory protection descriptor to the
   --  corresponding memory descriptor in the supervisor MPU
   --
   procedure Restore_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : Memory_Region_Descriptor_Type)
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Saves state of a memory protection descriptor from the supervisor MPU
   --
   procedure Save_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : out Memory_Region_Descriptor_Type)
      with Pre => Cpu_In_Privileged_Mode;

   procedure Disable_Memory_Region (Region_Id : Memory_Region_Id_Type)
      with Pre => Cpu_In_Privileged_Mode,
           Post => not Is_Memory_Region_Enabled (Region_Id);

   procedure Enable_Memory_Region (Region_Id : Memory_Region_Id_Type)
      with Pre => Cpu_In_Privileged_Mode,
           Post => Is_Memory_Region_Enabled (Region_Id);

   procedure Handle_Prefetch_Abort_Exception
      with Pre => Cpu_In_Privileged_Mode;

   procedure Handle_Data_Abort_Exception
      with Pre => Cpu_In_Privileged_Mode;

   type Fault_Status_Registers_Type is limited private;

   procedure Initialize_Fault_Status_Registers (
      Fault_Status_Registers : out Fault_Status_Registers_Type)
      with Pre => Cpu_In_Hypervisor_Mode;

   procedure Save_Fault_Status_Registers (
      Fault_Status_Registers : out Fault_Status_Registers_Type)
      with Pre => Cpu_In_Hypervisor_Mode;

   procedure Restore_Fault_Status_Registers (
      Fault_Status_Registers : Fault_Status_Registers_Type)
      with Pre => Cpu_In_Hypervisor_Mode;

private

   use HiRTOS_Cpu_Multi_Core_Interface;

   type Memory_Region_Descriptor_Type is record
      Base_Address : System.Address := System.Null_Address; --  TODO: Add right fields
   end record;

   type Fault_Status_Registers_Type is limited record
      ESR_EL1_Value : HiRTOS_Cpu_Arch_Interface.System_Registers.ESR_EL1_Type;
      FAR_EL1_Value : HiRTOS_Cpu_Arch_Interface.System_Registers.FAR_EL1_Type;
      SCTLR_EL1_Value : HiRTOS_Cpu_Arch_Interface.System_Registers.SCTLR_EL1_Type;
   end record;

   type MAIR_Memory_Kind_Type is
      (Device_Memory,
       Normal_Memory_Outer_Non_Cacheable,
       Normal_Memory_Outer_Write_Through,
       Normal_Memory_Outer_Write_Back)
      with Size => 4;

   for MAIR_Memory_Kind_Type use
      (Device_Memory => 2#0000#,
       Normal_Memory_Outer_Non_Cacheable => 2#0100#,
       Normal_Memory_Outer_Write_Through => 2#1000#,
       Normal_Memory_Outer_Write_Back => 2#1111#); -- write-allocate/read-allocate

   type MAIR_Device_Memory_Subkind_Type is
      (Device_Memory_nGnRnE, --  non-gather, non-reorder, non-early-ack
       Device_Memory_nGnRE, --  non-gather, non-reorder, early-ack
       Device_Memory_nGRE, --  non-gather, reorder, early-ack
       Device_Memory_GRE --  gather, reorder, early-ack
      )
      with Size => 4;

   for MAIR_Device_Memory_Subkind_Type use
      (Device_Memory_nGnRnE => 2#0000#,
       Device_Memory_nGnRE => 2#0100#,
       Device_Memory_nGRE => 2#1000#,
       Device_Memory_GRE => 2#1100#);

   type MAIR_Normal_Memory_Subkind_Type is
      (Normal_Memory_Invalid_Subkind,
       Normal_Memory_Inner_Non_Cacheable,
       Normal_Memory_Inner_Write_Through,
       Normal_Memory_Inner_Write_Back)
      with Size => 4;

   for MAIR_Normal_Memory_Subkind_Type use
      (Normal_Memory_Invalid_Subkind => 2#0000#,
       Normal_Memory_Inner_Non_Cacheable => 2#0100#,
       Normal_Memory_Inner_Write_Through => 2#1000#,
       Normal_Memory_Inner_Write_Back => 2#1111#); -- write-allocate/read-allocate

   type MAIR_Attr_Type (Memory_Kind : MAIR_Memory_Kind_Type := Device_Memory) is record
      case Memory_Kind is
         when Device_Memory =>
             Device_Memory_Subkind : MAIR_Device_Memory_Subkind_Type := Device_Memory_nGnRnE;
         when others =>
             Normal_Memory_Subkind : MAIR_Normal_Memory_Subkind_Type := Normal_Memory_Invalid_Subkind;
      end case;
   end record
      with Size => 8,
           Bit_Order => System.Low_Order_First;

   for MAIR_Attr_Type use record
      Device_Memory_Subkind at 0 range 0 .. 3;
      Normal_Memory_Subkind at 0 range 0 .. 3;
      Memory_Kind at 0 range 4 .. 7;
   end record;

   type MAIR_Attr_Index_Type is range 0 .. 7;

   type MAIR_Attr_Array_Type is array (MAIR_Attr_Index_Type) of MAIR_Attr_Type
      with Component_Size => 8,
           Size => 64;

   --  Memory Attribute Indirection Register
   type MAIR_Type (As_Value : Boolean := True)  is record
      case As_Value is
         when True =>
            Value : Interfaces.Unsigned_64;
         when False =>
            Attr_Array : MAIR_Attr_Array_Type;
      end case;
   end record
      with Unchecked_Union,
           Size => 64;

   Memory_Attributes_Lookup_Table : constant MAIR_Attr_Array_Type :=
       [Device_Memory_Mapped_Io'Enum_Rep =>
            (Memory_Kind => Device_Memory,
             Device_Memory_Subkind => Device_Memory_nGnRnE),
        Normal_Memory_Non_Cacheable'Enum_Rep =>
            (Memory_Kind => Normal_Memory_Outer_Non_Cacheable,
             Normal_Memory_Subkind => Normal_Memory_Inner_Non_Cacheable),
        Normal_Memory_Write_Through_Cacheable'Enum_Rep =>
            (Memory_Kind => Normal_Memory_Outer_Write_Through,
             Normal_Memory_Subkind => Normal_Memory_Inner_Write_Through),
        Normal_Memory_Write_Back_Cacheable'Enum_Rep =>
            (Memory_Kind => Normal_Memory_Outer_Write_Back,
             Normal_Memory_Subkind => Normal_Memory_Inner_Write_Back),
        others => <>];

   -----------------------------------------------------------------------------
   --  Translation Table Entry Declarations
   -----------------------------------------------------------------------------

   type Execute_Never_Type is (Executable, Non_Executable)
      with Size => 1;

   for Execute_Never_Type use
     (Executable => 2#0#,
      Non_Executable => 2#1#);

   --
   --  MMU page access permissions
   --
   type Access_Permissions_Attribute_Type is
      (EL1_Read_Write_EL0_No_Access, --  Read/write at EL1, no access at EL0.
       EL1_and_EL0_Read_Write,       --  Read/write, at EL1 or EL0.
       EL1_Read_Only_EL0_No_Access,  --  Read-only at EL1, no access at EL0.
       EL1_and_EL0_Read_Only)        --  Read-only at EL1 and EL0.
      with Size => 2;

   for Access_Permissions_Attribute_Type use
     (EL1_Read_Write_EL0_No_Access => 2#00#,
      EL1_and_EL0_Read_Write => 2#01#,
      EL1_Read_Only_EL0_No_Access => 2#10#,
      EL1_and_EL0_Read_Only => 2#11#);

   --
   --  Shareability of memory in multi-processor systems:
   --  - Non-shareable: memory accessible only by a single processor or other agent,
   --    so memory accesses never need to be synchronized with other processors.
   --    This domain is not typically used in SMP systems.
   --  - Inner shareable: memory that can be shared by multiple processors,
   --    but not necessarily all of the agents in the system. A system might have multiple
   --    Inner Shareable domains. An operation that affects one Inner Shareable domain does
   --    not affect other Inner Shareable domains in the system. An example of such a domain
   --    might be a quad-core CPU cluster.
   --  - Outer shareable: memory that can be shared by multiple agents and can consist of
   --    one or more inner shareable domains. An operation that affects an outer shareable
   --    domain also implicitly affects all inner shareable domains inside it.
   --    However, it does not otherwise behave as an inner shareable operation.
   --
   type Sharability_Attribute_Type is
      (Non_Shareable,
       Outer_Shareable,
       Inner_Shareable)
      with Size => 2;

   for Sharability_Attribute_Type use
     (Non_Shareable => 2#00#,
      Outer_Shareable => 2#10#,
      Inner_Shareable => 2#11#);

   type Translation_Table_Entry_Kind_Type is
      (Translation_Table_Entry_Is_Block,
       Translation_Table_Entry_Is_Table_Or_Page)
      with Size => 1;

   for Translation_Table_Entry_Kind_Type use
       (Translation_Table_Entry_Is_Block => 2#0#,
        Translation_Table_Entry_Is_Table_Or_Page => 2#1#);

   type Translation_Table_MAIR_EL1_Index_Type is new MAIR_Attr_Index_Type
      with Size => 3;

   type Page_Address_Prefix_Type is mod 2 ** 40
      with Size => 40;

   type Translation_Table_Entry_Type (As_Value : Boolean := True)  is record
      case As_Value is
         when True =>
            Value : Interfaces.Unsigned_64 := 0;
         when False =>
            Valid_Entry : Boolean := False;
            Entry_Kind : Translation_Table_Entry_Kind_Type := Translation_Table_Entry_Is_Block;
            Attr_Index : Translation_Table_MAIR_EL1_Index_Type := 0;
            NS : Boolean := False; --  Non-Secure Access
            AP : Access_Permissions_Attribute_Type := EL1_Read_Write_EL0_No_Access;
            SH : Sharability_Attribute_Type := Non_Shareable;
            AF : Boolean := False; --  Access Flag to mark the entry as hardware-managed
            Physical_Page_Address_Prefix : Page_Address_Prefix_Type := 0;
            PXN : Execute_Never_Type := Non_Executable; --  Privileged Execute Never
            UXN : Execute_Never_Type := Non_Executable; --  Unprivileged Execute Never
      end case;
   end record
   with Size => 64,
        Bit_Order => System.Low_Order_First,
        Unchecked_Union;

   for Translation_Table_Entry_Type use record
      Value       at 0 range 0 .. 63;
      Valid_Entry at 0 range 0 .. 0;
      Entry_Kind  at 0 range 1 .. 1;
      Attr_Index  at 0 range 2 .. 4;
      NS          at 0 range 5 .. 5;
      AP          at 0 range 6 .. 7;
      SH          at 0 range 8 .. 9;
      AF          at 0 range 10 .. 10;
      Physical_Page_Address_Prefix at 0 range 12 .. 51;
      PXN         at 0 range 53 .. 53;
      UXN         at 0 range 54 .. 54;
   end record;

   function Address_To_Page_Address_Prefix (Addr : System.Address)
      return Page_Address_Prefix_Type is
      (Page_Address_Prefix_Type (
         To_Integer (Addr) / HiRTOS_Cpu_Arch_Parameters.Page_Size_In_Bytes));

   function Page_Address_Prefix_To_Address (Page_Address_Prefix : Page_Address_Prefix_Type)
      return System.Address is
      (To_Address (Integer_Address (Page_Address_Prefix) *
                   HiRTOS_Cpu_Arch_Parameters.Page_Size_In_Bytes));

   -----------------------------------------------------------------------------
   --  TCR - Translation Control Register
   -----------------------------------------------------------------------------

   --
   --  Size offset of the memory region addressed by TTBR0_ELx/TTBR1_ELx.
   --  The region size is 2 ** (64-TnSZ) bytes.
   --
   type TnSZ_Type is mod 2 ** 6
      with Size => 6;

   --
   --  Translation table walk disable for translations using TTBR1_EL1.
   --  This bit controls whether a translation table walk is performed on a TLB miss,
   --  for an address that is translated using TTBR1_EL1.
   --
   type EPD1_Type is
      (TTBR1_Translation_Table_Walk_Enabled,
       TTBR1_Translation_Table_Walk_Disabled)
      with Size => 1;

   for EPD1_Type use
      (TTBR1_Translation_Table_Walk_Enabled => 2#0#,
       TTBR1_Translation_Table_Walk_Disabled => 2#1#);

   --
   --  Granule size for the TTBR0_ELx
   --
   --  - For Granule size of 4KB, each entry of the level1 translation table
   --    covers 1GB, each entry oof the level2 translation table covers 2MB,
   --    and each entry of the level3 translation table covers 4KB.
   --  - For Granule size of 16KB, each entry of the level1 translation table
   --    covers 64GB, each entry of the level2 translation table covers 32MB,
   --    and each entry of the level3 translation table covers 16KB.
   --  - For Granule size of 64KB, each entry of the level1 translation table
   --    covers 4TB, each entry of the level2 translation table covers 512MB,
   --    and each entry of the level3 translation table covers 64KB.
   --
   type TG0_Type is
      (TG0_4KB,
       TG0_64KB,
       TG0_16KB)
      with Size => 2;

   for TG0_Type use
      (TG0_4KB => 2#00#,
       TG0_64KB => 2#01#,
       TG0_16KB => 2#10#);

   --
   --  Granule size for the TTBR1_ELx
   --
   type TG1_Type is
      (TG1_16KB,
       TG1_4KB,
       TG1_64KB)
      with Size => 2;

   for TG1_Type use
      (TG1_16KB => 2#01#,
       TG1_4KB => 2#10#,
       TG1_64KB => 2#11#);

   --
   --  Translation Control Register for ELx
   --  - T0SZ, SH0, TG0: controls the translation regime for the translation
   --    table pointed to by TTBR0_ELx. The maximum address range that can be
   --    covered by TTBR0_ELx. By convention TTBR0_ELx is used for the lower
   --    half of the 64-bit address space (typically user space):
   --    0x0000_0000_0000_0000 .. 0x000F_FFFF_FFFF_FFFF
   --  - T1SZ, EPD1, SH1, TG1: controls the translation regime for the translation
   --    table pointed to by TTBR1_ELx. By convention TTBR0_ELx is used for the lower
   --    half of the 64-bit address space (typically user space):
   --    0xFFFF_FFFF_FFFF_FFFF .. 0xFFF0_0000_0000_0000
   --
   type TCR_Type (As_Value : Boolean := True)  is record
      case As_Value is
         when True =>
            Value : Interfaces.Unsigned_64 := 0;
         when False =>
            T0SZ : TnSZ_Type := 0;
            SH0 : Sharability_Attribute_Type := Non_Shareable;
            TG0 : TG0_Type := TG0_4KB;
            T1SZ : TnSZ_Type := 0;
            EPD1 : EPD1_Type := TTBR1_Translation_Table_Walk_Enabled;
            SH1 : Sharability_Attribute_Type := Non_Shareable;
            TG1 : TG1_Type := TG1_4KB;
      end case;
   end record
   with Size => 64,
        Bit_Order => System.Low_Order_First,
        Unchecked_Union;

   for TCR_Type use record
      Value at 0 range 0 .. 63;
      T0SZ at 0 range 0 .. 5;
      SH0  at 0 range 12 .. 13;
      TG0  at 0 range 14 .. 15;
      T1SZ at 0 range 16 .. 21;
      EPD1 at 0 range 23 .. 23;
      SH1  at 0 range 28 .. 29;
      TG1  at 0 range 30 .. 31;
   end record;

   --
   --  NOTE: The size of the virtual address range is `2 ** (64 - TnSZ)`.
   --
   Virtual_Address_Space_Size_TnSZ_Value : constant TnSZ_Type := 30;

   Virtual_Address_Space_Size_In_Bytes : constant Integer_Address :=
      2 ** (64 - Natural (Virtual_Address_Space_Size_TnSZ_Value)); -- 16 GiB

   TTBR0_Granule : constant TG0_Type := TG0_4KB;

   type Translation_Table_Level_Type is (TT_Level1, TT_Level2, TT_Level3);

   TTBR0_Granule_To_Entry_Range_Size_Map :
   constant array (TG0_Type, Translation_Table_Level_Type) of Integer_Address :=
      [TG0_4KB => [TT_Level1 => 1 * 1024 * 1024 * 1024, -- 1GB
                   TT_Level2 => 2 * 1024 * 1024, -- 2MB
                   TT_Level3 => 4 * 1024], -- 4KB
       TG0_64KB => [TT_Level1 => 4 * 1024 * 1024 * 1024 * 1024, -- 4TB
                    TT_Level2 => 512 * 1024 * 1024, -- 512MB
                    TT_Level3 => 64 * 1024], -- 64KB
       TG0_16KB => [TT_Level1 => 64 * 1024 * 1024 * 1024, -- 64GB
                    TT_Level2 => 32 * 1024 * 1024, -- 32MB
                    TT_Level3 => 16 * 1024]]; -- 16KB

   TTBR1_Granule_To_Entry_Range_Size_Map :
   constant array (TG1_Type, Translation_Table_Level_Type) of Integer_Address :=
      [TG1_16KB => [TT_Level1 => 64 * 1024 * 1024 * 1024, -- 64GB
                    TT_Level2 => 32 * 1024 * 1024, -- 32MB
                    TT_Level3 => 16 * 1024],  -- 16KB
       TG1_4KB => [TT_Level1 => 1 * 1024 * 1024 * 1024, -- 1GB
                   TT_Level2 => 2 * 1024 * 1024, -- 2MB
                   TT_Level3 => 4 * 1024], -- 4KB
       TG1_64KB => [TT_Level1 => 4 * 1024 * 1024 * 1024 * 1024, -- 4TB
                    TT_Level2 => 512 * 1024 * 1024, -- 512MB
                    TT_Level3 => 64 * 1024]]; -- 64KB

   -----------------------------------------------------------------------------
   --  TTBRn - Translation Table Base Register 0/1
   -----------------------------------------------------------------------------

   type TTBRn_BADDR_Type is mod 2 ** 48
      with Size => 48,
           Dynamic_Predicate =>
              TTBRn_BADDR_Type mod HiRTOS_Cpu_Arch_Parameters.Page_Size_In_Bytes = 0;

   type TTBRn_ASID_Type is mod 2 ** 16
      with Size => 16;

   --
   --  Translation Table Base Register
   --
   type TTBRn_Type (As_Value : Boolean := True)  is record
      case As_Value is
         when True =>
            Value : Interfaces.Unsigned_64;
         when False =>
            BADDR : TTBRn_BADDR_Type := 0;
            ASID  : TTBRn_ASID_Type := 0;
      end case;
   end record
   with Size => 64,
        Bit_Order => System.Low_Order_First,
        Unchecked_Union;

   for TTBRn_Type use record
      Value at 0 range 0 .. 63;
      BADDR at 0 range 0 .. 47;
      ASID  at 0 range 48 .. 63;
   end record;

   -----------------------------------------------------------------------------
   --  Translation Table Declarations
   -----------------------------------------------------------------------------

   Max_Num_Translation_Table_Entries : constant := 512;

   Level1_Translation_Table_Entry_Range_Size : constant Integer_Address :=
      TTBR0_Granule_To_Entry_Range_Size_Map (TTBR0_Granule, TT_Level1);

   Level2_Translation_Table_Entry_Range_Size : constant Integer_Address :=
      TTBR0_Granule_To_Entry_Range_Size_Map (TTBR0_Granule, TT_Level2);

   Level3_Translation_Table_Entry_Range_Size : constant Integer_Address :=
      TTBR0_Granule_To_Entry_Range_Size_Map (TTBR0_Granule, TT_Level3);

   pragma Compile_Time_Error
      (Level3_Translation_Table_Entry_Range_Size /= HiRTOS_Cpu_Arch_Parameters.Page_Size_In_Bytes,
       "Level3 Translation Table Entry Range Size must be equal to the page size");

   --
   --  The virtual address space supported must fit in a single level1 translation table.
   --
   pragma Compile_Time_Error
     (Virtual_Address_Space_Size_In_Bytes <=
         Max_Num_Translation_Table_Entries * Level1_Translation_Table_Entry_Range_Size,
      "Virtual Address space too big");

   pragma Compile_Time_Error
     (Virtual_Address_Space_Size_In_Bytes mod Level1_Translation_Table_Entry_Range_Size /= 0,
      "Virtual Address space has an invalid size");

   type Translation_Table_Entry_Index_Type is mod Max_Num_Translation_Table_Entries;

   type Translation_Table_Type is
      array (Translation_Table_Entry_Index_Type) of Translation_Table_Entry_Type
      with Component_Size => 64,
           Size => Max_Num_Translation_Table_Entries * 64,
           Alignment => HiRTOS_Cpu_Arch_Parameters.Page_Size_In_Bytes;

   pragma Compile_Time_Error
     (Translation_Table_Type'Size / System.Storage_Unit /= HiRTOS_Cpu_Arch_Parameters.Page_Size_In_Bytes,
      "Translation_Table_Type has the wrong size");

   Num_Level1_Translation_Table_Entries_Used : constant Integer_Address :=
      Virtual_Address_Space_Size_In_Bytes / Level1_Translation_Table_Entry_Range_Size;

   subtype Level1_Translation_Table_Entry_Index_Type is
      Translation_Table_Entry_Index_Type range
         0 .. Translation_Table_Entry_Index_Type (Num_Level1_Translation_Table_Entries_Used - 1);

   type Level2_Translation_Table_Array_Type is
      array (Level1_Translation_Table_Entry_Index_Type) of Translation_Table_Type;

   type Level3_Translation_Table_Array_Type is
      array (Level1_Translation_Table_Entry_Index_Type,
             Translation_Table_Entry_Index_Type) of Translation_Table_Type;

   type Translation_Table_Tree_Type is limited record
      Level1_Translation_Table : Translation_Table_Type := [others => <>];
      Level2_Translation_Tables : Level2_Translation_Table_Array_Type := [others => [others => <>]];
      Level3_Translation_Tables : Level3_Translation_Table_Array_Type := [others => [others => <>]];
   end record;

   procedure Populate_Level3_Translation_Table_Entry (
      Translation_Table_Entry : out Translation_Table_Entry_Type;
      Start_Physical_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Page_Attributes : Region_Attributes_Type)
      with Pre => Cpu_In_Privileged_Mode and then
                  Address_Is_Page_Aligned (Start_Physical_Address) and then
                  Start_Physical_Address /= System.Null_Address and then
                  not Translation_Table_Entry.AF and then
                  not Translation_Table_Entry.Valid_Entry,
           Post => Translation_Table_Entry.Valid_Entry and then
                   Translation_Table_Entry.AF;

   --
   --  Translation table tree for each CPU core
   --
   Translation_Table_Trees :
      array (Valid_Cpu_Core_Id_Type) of Translation_Table_Tree_Type :=
         [others => <>];

end HiRTOS_Cpu_Arch_Interface.Memory_Protection;
