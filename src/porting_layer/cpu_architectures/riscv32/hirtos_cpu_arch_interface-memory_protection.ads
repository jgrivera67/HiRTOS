--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Memory protection services
--  for  the RISCV PMP
--

with System.Storage_Elements;
with Interfaces;
with Bit_Sized_Integer_Types;

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

   Max_Num_PMP_Entries : constant := 16;

   Min_Region_Size_In_Bytes : constant := 4;

   type Memory_Region_Id_Type is mod Max_Num_PMP_Entries;

   --
   --  Mapping of logical memory protection regions to memory protection descriptor
   --  indices
   --
   --  NOTE: We allocate 4 single-PMP-entry NAPOT regions and 6 two-PMP-entry non-NAPOT i
   --  regions to consume the 16 PMP entries
   --
   type Memory_Region_Role_Type is
     (
      Global_Code_Region,                    -- single-entry NAPOT region
      Global_Rodata_Region,                  -- single-entry NAPOT region
      Null_Pointer_Dereference_Guard,        -- single-entry NAPOT region
      Global_Interrupt_Stack_Overflow_Guard, --  single-entry NAPOT region
      Global_Interrupt_Stack_Region,         --  Two-entry non-NAPOT region
      Thread_Stack_Overflow_Guard,           --  Two-entry non-NAPOT region
      Thread_Stack_Data_Region,              --  Two-entry non-NAPOT region
      Thread_Private_Data_Region,            --  Two-entry non-NAPOT region
      Thread_Private_Data2_Region,           --  Two-entry non-NAPOT region
      Thread_Private_Mmio_Region,            --  Two-entry non-NAPOT region

      --  Valid region roles must be added before this entry:
      Invalid_Region_Role);

   for Memory_Region_Role_Type use
     (
      Global_Code_Region => 0,
      Global_Rodata_Region => 1,
      Null_Pointer_Dereference_Guard => 2,
      Global_Interrupt_Stack_Overflow_Guard => 3,
      Global_Interrupt_Stack_Region => 4,
      Thread_Stack_Overflow_Guard => 6,
      Thread_Stack_Data_Region => 8,
      Thread_Private_Data_Region => 10,
      Thread_Private_Data2_Region => 12,
      Thread_Private_Mmio_Region => 14,

      --  Valid region roles must be added before this entry:
      Invalid_Region_Role => Max_Num_PMP_Entries);

   procedure Initialize
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Enables memory protection hardware
   --
   procedure Enable_Memory_Protection (Enable_Background_Region : Boolean)
      with Pre => Cpu_In_Privileged_Mode and then
                  Enable_Background_Region;

   --
   --  Disables memory protection hardware
   --
   procedure Disable_Memory_Protection
      with Pre => Cpu_In_Privileged_Mode;

   function Is_Address_Power_Of_Two (Address : System.Address) return Boolean is
      (Is_Value_Power_Of_Two (To_Integer (Address)));

   function Is_Range_NAPOT_Aligned (Start_Address : System.Address;
                                    Size_In_Bytes : System.Storage_Elements.Integer_Address)
      return Boolean is
      (Is_Value_Power_Of_Two (Size_In_Bytes) and then
       Size_In_Bytes >= 8 and then
       To_Integer (Start_Address) mod Size_In_Bytes = 0);

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => Cpu_In_Privileged_Mode and then
                  Size_In_Bytes /= 0,
           Post => Is_Memory_Region_Enabled (Region_Id);

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => Cpu_In_Privileged_Mode and then
                  To_Integer (Start_Address) < To_Integer (End_Address) and then
                  not Is_Memory_Region_Enabled (Region_Id),
           Post => Is_Memory_Region_Enabled (Region_Id);

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type;
      Is_Single_PMP_Entry : Boolean)
      with Pre => Size_In_Bytes /= 0 and then
                  Size_In_Bytes mod Min_Region_Size_In_Bytes = 0 and then
                  To_Integer (Start_Address) mod Min_Region_Size_In_Bytes = 0 and then
                  (if Is_Single_PMP_Entry then Is_Range_NAPOT_Aligned (Start_Address, Size_In_Bytes));

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => To_Integer (Start_Address) < To_Integer (End_Address) and then
                  To_Integer (Start_Address) mod Min_Region_Size_In_Bytes = 0 and then
                  To_Integer (End_Address) mod Min_Region_Size_In_Bytes = 0;

   procedure Initialize_Memory_Region_Descriptor_Disabled (
      Region_Descriptor : out Memory_Region_Descriptor_Type);

   function Is_Memory_Region_Descriptor_Enabled (Region_Descriptor : Memory_Region_Descriptor_Type)
      return Boolean;

   function Is_Memory_Region_Enabled (Region_Id : Memory_Region_Id_Type) return Boolean
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Copies saved state of a memory region descriptor to the
   --  corresponding PMP entries. THe region descriptor can be either
   --  a single-entry or two-entry descriptor that was initialize by an
   --  earlier call to Initialize_Memory_Region_Descriptor, or to
   --  Save_Memory_Region_Descriptor..
   --
   procedure Restore_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : Memory_Region_Descriptor_Type)
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Saves state of a memory region descriptor from the corresponding
   --  PMP entries
   --
   procedure Save_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : out Memory_Region_Descriptor_Type)
      with Pre => Cpu_In_Privileged_Mode and then
                  Region_Id mod 2 = 0;

private
   use type Interfaces.Unsigned_32;

   Log_Base_2_Min_NAPOT_Aligned_Size : constant := 3;

   Min_NAPOT_Aligned_Size : constant := 2 ** Log_Base_2_Min_NAPOT_Aligned_Size;

   pragma Compile_Time_Error (
      HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment mod Min_Region_Size_In_Bytes /= 0,
      "Wrong value for Memory_Region_Alignment"
   );

   Max_Num_Single_Entry_Memory_Regions : constant := 4;

   Max_Num_Two_Entry_Memory_Regions : constant := 6;

   pragma Compile_Time_Error (
      Global_Interrupt_Stack_Overflow_Guard'Enum_Rep /= Max_Num_Single_Entry_Memory_Regions - 1,
      "Wrong value for last single-entry region Id");

   pragma Compile_Time_Error (
      Global_Interrupt_Stack_Region'Enum_Rep /= Max_Num_Single_Entry_Memory_Regions,
      "Wrong value for first two-entry region Id");

   pragma Compile_Time_Error (
      Max_Num_Single_Entry_Memory_Regions + (2 * Max_Num_Two_Entry_Memory_Regions) /=
      Max_Num_PMP_Entries, "Max_Num_PMP_Entries mismatch");

   type PMPADDR_Type is new Interfaces.Unsigned_32;

   --
   --  PMP region address-matching modes
   --
   --  For NAPOT mode, the size of the region must be a power of two,
   --  encoded as the index of the lowest bit that is 0, as follows:
   --  If the lowest bit that is 0 in the PMPADDR register is bit i,
   --  (i: 0 .. 31), the size of the region is 2**(i + 3) and the
   --  base address must be a multiple of 2**(i + 1), so that all
   --  bits lower than bit i are also 0s in the base address.
   --  Examples:
   --  - If the lowest bit that is 0 is bit 0, the size of the
   --    region is 8 bytes (= 2**(0 + 3)), and the base address is
   --    a multiple of 2 (= 2**(0 + 1)).
   --  - If the lowest bit that is 0 is bit 1, the size of the
   --    region is 16 bytes (= 2**(1 + 3)), and the base address is
   --    a multiple of 4 (= 2**(1 + 1)).
   --  - If the lowest bit that is 0 is bit 2, the size of the
   --    region is 32 bytes (= 2**(2 + 3)), and the base address is
   --    a multiple of 8 (= 2**(2 + 1)).
   --
   type PMP_Region_Address_Matching_Mode_Type is
      (PMP_Region_Off, --  Region disabled
       PMP_Region_TOR, --  Top of range
       PMP_Region_NA4, --  Naturally aligned 4-byte region
       PMP_Region_NAPOT --  Naturally aligned byte power-of-2 region
      ) with Size => 2;

   for PMP_Region_Address_Matching_Mode_Type use
      (PMP_Region_Off => 2#00#,
       PMP_Region_TOR => 2#01#,
       PMP_Region_NA4 => 2#10#,
       PMP_Region_NAPOT => 2#11#);

   --
   --  Type of 1-byte entries in PMPCFG
   ---
   type PMPCFG_Entry_Type is record
      Read_Perm : Bit_Sized_Integer_Types.Bit_Type := 0;
      Write_Perm : Bit_Sized_Integer_Types.Bit_Type := 0;
      Execute_Perm : Bit_Sized_Integer_Types.Bit_Type := 0;
      Addr_Matching_Mode : PMP_Region_Address_Matching_Mode_Type := PMP_Region_Off;
      Locked_Entry : Bit_Sized_Integer_Types.Bit_Type := 0;
   end record
   with Size => 8,
        Bit_Order => System.Low_Order_First;

   for PMPCFG_Entry_Type use record
      Read_Perm at 0 range 0 .. 0;
      Write_Perm at 0 range 1 .. 1;
      Execute_Perm at 0 range 2 .. 2;
      Addr_Matching_Mode at 0 range 3 .. 4;
      Locked_Entry at 0 range 7 .. 7;
   end record;

   Num_PMPCFG_Entries : constant := 4;

   type PMPCFG_Entry_Index_Type is mod Num_PMPCFG_Entries;

   type PMPCFG_Entry_Array_Type is
      array (PMPCFG_Entry_Index_Type) of PMPCFG_Entry_Type
      with Component_Size => 8, Size => 32;

   --
   --  PMPCFG register
   --
   --  Each PMPCFG register can be seen as an array of
   --  1-byte entries, where Entries[i] holds the permissions for
   --  region descriptor i % 4. so, pmpcfg0 holds the permissions
   --  for region descriptors 0 to 3, pmpcfg1 holds the permissions
   --  for region descriptors 4 to 7, pmpcfg2 holds the permissions
   --  for region descriptors 8 to 11 and pmpcfg3 holds the permissions for
   --  region descriptors 12 to 15.
   --
   type PMPCFG_Type (As_Word : Boolean := True)  is record
      case As_Word is
         when True =>
            Value : Interfaces.Unsigned_32;
         when False =>
            Entries : PMPCFG_Entry_Array_Type;
      end case;
   end record
      with Unchecked_Union,
           Size => 32;

   --
   --  RISCV PMP region descriptor for NAPOT mode
   --
   type Memory_Region_Descriptor_Type is limited record
      Is_Single_PMP_Entry : Boolean := False;
      First_PMPADDR : PMPADDR_Type := 0;
      Second_PMPADDR : PMPADDR_Type := 0;
      First_PMPCFG_Entry : PMPCFG_Entry_Type;
      Second_PMPCFG_Entry : PMPCFG_Entry_Type;
   end record
     with Convention => C;

   type Synchronous_Exception_Type is
      (Instruction_Address_Misaligned,
       Instruction_Access_Fault,
       Illegal_Instruction,
       Breakpoint,
       Load_Address_Misaligned,
       Load_Access_Fault,
       Store_Address_Misaligned,
       Store_Access_Fault,
       Environment_Call_From_U_Mode,
       Environment_Call_From_S_Mode,
       Environment_Call_From_M_Mode,
       Instruction_Page_Fault,
       Load_Page_Fault,
       Store_Page_Fault);

   for Synchronous_Exception_Type use
     (Instruction_Address_Misaligned => 0,
      Instruction_Access_Fault => 1,
      Illegal_Instruction => 2,
      Breakpoint => 3,
      Load_Address_Misaligned => 4,
      Load_Access_Fault => 5,
      Store_Address_Misaligned => 6,
      Store_Access_Fault => 7,
      Environment_Call_From_U_Mode => 8,
      Environment_Call_From_S_Mode => 9,
      Environment_Call_From_M_Mode => 10,
      Instruction_Page_Fault => 11,
      Load_Page_Fault => 12,
      Store_Page_Fault => 13);

   function Is_Memory_Region_Descriptor_Enabled (Region_Descriptor : Memory_Region_Descriptor_Type)
      return Boolean is
      (if Region_Descriptor.Is_Single_PMP_Entry then
          Region_Descriptor.First_PMPCFG_Entry.Addr_Matching_Mode /= PMP_Region_Off
       else
          Region_Descriptor.Second_PMPCFG_Entry.Addr_Matching_Mode /= PMP_Region_Off);

   Instruction_Address_Misaligned_Str : aliased constant String := "Instruction_Address_Misaligned";
   Instruction_Access_Fault_Str : aliased constant String := "Instruction_Access_Fault";
   Illegal_Instruction_Str : aliased constant String := "Illegal_Instruction";
   Breakpoint_Str : aliased constant String := "Breakpoint";
   Load_Address_Misaligned_Str : aliased constant String := "Load_Address_Misaligned";
   Load_Access_Fault_Str : aliased constant String := "Load_Access_Fault";
   Store_Address_Misaligned_Str : aliased constant String := "Store_Address_Misaligned";
   Store_Access_Fault_Str : aliased constant String := "Store_Access_Fault";
   Environment_Call_From_U_Mode_Str : aliased constant String := "Environment_Call_From_U_Mode";
   Environment_Call_From_S_Mode_Str : aliased constant String := "Environment_Call_From_S_Mode";
   Environment_Call_From_M_Mode_Str : aliased constant String := "Environment_Call_From_M_Mode";
   Instruction_Page_Fault_Str : aliased constant String := "Instruction_Page_Fault";
   Load_Page_Fault_Str : aliased constant String := "Load_Page_Fault";
   Store_Page_Fault_Str : aliased constant String := "Store_Page_Fault";

   Fault_Name_Pointer_Array : constant array (Synchronous_Exception_Type) of not null access constant String :=
      [Instruction_Address_Misaligned => Instruction_Address_Misaligned_Str'Access,
      Instruction_Access_Fault => Instruction_Access_Fault_Str'Access,
      Illegal_Instruction => Illegal_Instruction_Str'Access,
      Breakpoint => Breakpoint_Str'Access,
      Load_Address_Misaligned => Load_Address_Misaligned_Str'Access,
      Load_Access_Fault => Load_Access_Fault_Str'Access,
      Store_Address_Misaligned => Store_Address_Misaligned_Str'Access,
      Store_Access_Fault => Store_Access_Fault_Str'Access,
      Environment_Call_From_U_Mode => Environment_Call_From_U_Mode_Str'Access,
      Environment_Call_From_S_Mode => Environment_Call_From_S_Mode_Str'Access,
      Environment_Call_From_M_Mode => Environment_Call_From_M_Mode_Str'Access,
      Instruction_Page_Fault => Instruction_Page_Fault_Str'Access,
      Load_Page_Fault => Load_Page_Fault_Str'Access,
      Store_Page_Fault => Store_Page_Fault_Str'Access];

end HiRTOS_Cpu_Arch_Interface.Memory_Protection;
