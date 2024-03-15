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

with HiRTOS_Cpu_Arch_Parameters;
with System.Storage_Elements;
with Interfaces;
with Bit_Sized_Integer_Types;

package HiRTOS_Cpu_Arch_Interface.Memory_Protection
   with SPARK_Mode => On
is
   use System.Storage_Elements;
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

   Max_Num_Memory_Regions : constant := 16;

   type Memory_Region_Id_Type is mod Max_Num_Memory_Regions;

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
      (Address /= System.Null_Address and then
       (To_Integer (Address) and (To_Integer (Address) - 1)) = 0);

   function Is_Value_Power_Of_Two (Value : Integer_Address) return Boolean is
      (Value /= 0 and then
       (Value and (Value - 1)) = 0);

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => Cpu_In_Privileged_Mode and then
                  Is_Address_Power_Of_Two (Start_Address) and then
                  To_Integer (Start_Address) >=
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment and then
                  Size_In_Bytes > 0 and then
                  Size_In_Bytes mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0,
            Post => Is_Memory_Region_Enabled (Region_Id);

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => Cpu_In_Privileged_Mode and then
                  Is_Address_Power_Of_Two (Start_Address) and then
                  To_Integer (Start_Address) >=
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment and then
                  To_Integer (End_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  To_Integer (Start_Address) < To_Integer (End_Address) and then
                  not Is_Memory_Region_Enabled (Region_Id),
           Post => Is_Memory_Region_Enabled (Region_Id);

   --
   --  Initializes state of a memory protection descriptor object in NAPOT mode
   --
   --  NOTE: For NAPOT mode, the size of the region must be a power of two,
   --  encoded as the index of the lowest bit that is 0, as follows:
   --  If the lowest bit that is 0 in the PMPADDR register is bit i,
   --  (i: 0 .. 31), the size of the region is 2**(i + 3) and the
   --  base address must be a multiple of 2**(i + 1), so that all
   --  bits lower than bit i are also 0s in the base address.
   --
   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre =>
         Is_Value_Power_Of_Two (Size_In_Bytes) and then
         Size_In_Bytes >= 8 and then
         To_Integer (Start_Address) mod (Size_In_Bytes / 4) = 0;

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => To_Integer (Start_Address) < To_Integer (End_Address);

   procedure Initialize_Memory_Region_Descriptor_Disabled (
      Region_Descriptor : out Memory_Region_Descriptor_Type);

   function Is_Memory_Region_Descriptor_Enabled (Region_Descriptor : Memory_Region_Descriptor_Type)
      return Boolean;

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

private
   use type Interfaces.Unsigned_32;

   PMPADDR_Bit_Offset : constant := 2;

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
      --  Region base address and size (NAPOT encoded)
      PMPADDR : PMPADDR_Type := 0;
      --  "PMPCFG" byte associated with the region
      PMPCFG_Entry : PMPCFG_Entry_Type;
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
      (Region_Descriptor.PMPCFG_Entry.Addr_Matching_Mode /= PMP_Region_Off);

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
