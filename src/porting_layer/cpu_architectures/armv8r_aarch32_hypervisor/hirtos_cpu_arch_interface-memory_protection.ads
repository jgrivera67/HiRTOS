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

with HiRTOS_Cpu_Arch_Parameters;
with System.Storage_Elements;
with Interfaces;

package HiRTOS_Cpu_Arch_Interface.Memory_Protection
   with SPARK_Mode => On
is
   use System.Storage_Elements;
   use type System.Address;
   use type System.Storage_Elements.Integer_Address;

   type Memory_Region_Descriptor_Type is limited private;

   type Region_Permissions_Type is (None,
                                    Read_Only,
                                    Read_Write,
                                    Read_Execute);

   type Region_Attributes_Type is (
      --  MMIO space:
      Device_Memory_Mapped_Io,
      --  RAM space:
      Normal_Memory_Non_Cacheable,
      Normal_Memory_Write_Through_Cacheable,
      Normal_Memory_Write_Back_Cacheable);

   Max_Num_Memory_Regions : constant := 24;

   type Memory_Region_Id_Type is mod Max_Num_Memory_Regions;

   --
   --  Load all memory attributes supported into the MPU's MAIR0 and MAIR1 registers:
   --
   procedure Load_Memory_Attributes_Lookup_Table
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Enables memory protection hardware
   --
   procedure Enable_Memory_Protection
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Disables memory protection hardware
   --
   procedure Disable_Memory_Protection
      with Pre => Cpu_In_Privileged_Mode;

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => To_Integer (Start_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  Size_In_Bytes > 0 and then
                  Size_In_Bytes mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  not Is_Memory_Region_Enabled (Region_Id),
            Post => Is_Memory_Region_Enabled (Region_Id);

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => To_Integer (Start_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  To_Integer (End_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  To_Integer (Start_Address) < To_Integer (End_Address) and then
                  not Is_Memory_Region_Enabled (Region_Id),
           Post => Is_Memory_Region_Enabled (Region_Id);

   procedure Change_Memory_Region_Address_Range (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      End_Address : System.Address)
      with Pre => To_Integer (Start_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  To_Integer (End_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  To_Integer (Start_Address) < To_Integer (End_Address) and then
                  Is_Memory_Region_Enabled (Region_Id),
            Post => Is_Memory_Region_Enabled (Region_Id);

   procedure Clone_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Cloned_Region_Id : Memory_Region_Id_Type)
      with Pre => To_Integer (Start_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  To_Integer (End_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  To_Integer (Start_Address) < To_Integer (End_Address) and then
                  not Is_Memory_Region_Enabled (Region_Id) and then
                  Is_Memory_Region_Enabled (Cloned_Region_Id) and then
                  Region_Id /= Cloned_Region_Id,
            Post => Is_Memory_Region_Enabled (Region_Id);

   --
   --  Initializes state of a memory protection descriptor object
   --
   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => To_Integer (Start_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  Size_In_Bytes > 0 and then
                  Size_In_Bytes mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0;

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
      with Pre => To_Integer (Start_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  To_Integer (End_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  To_Integer (Start_Address) < To_Integer (End_Address);

   procedure Initialize_Memory_Region_Descriptor_Disabled (
      Region_Descriptor : out Memory_Region_Descriptor_Type);

   function Is_Memory_Region_Descriptor_Enabled (Region_Descriptor : Memory_Region_Descriptor_Type)
      return Boolean;

   function Is_Memory_Region_Enabled (Region_Id : Memory_Region_Id_Type) return Boolean
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Copies saved state of a memory protection descriptor to the
   --  corresponding memory descriptor in the MPU
   --
   procedure Restore_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : Memory_Region_Descriptor_Type);

   --
   --  Saves state of a memory protection descriptor from the MPU
   --
   procedure Save_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : out Memory_Region_Descriptor_Type);

   procedure Disable_Memory_Region (Region_Id : Memory_Region_Id_Type)
      with Post => not Is_Memory_Region_Enabled (Region_Id);

   procedure Enable_Memory_Region (Region_Id : Memory_Region_Id_Type)
      with Post => Is_Memory_Region_Enabled (Region_Id);

   procedure Handle_Prefetch_Abort_Exception
      with Pre => Cpu_In_Privileged_Mode;

   procedure Handle_Data_Abort_Exception
      with Pre => Cpu_In_Privileged_Mode;

private
   use type Interfaces.Unsigned_32;

   ----------------------------------------------------------------------------
   --  Memory protection unit (MPU) declarations
   ----------------------------------------------------------------------------

   type Not_Unified_Mpu_Type is (Unified_Memory_Map, Not_Unified_Memory_Map)
      with Size => 1;

   for Not_Unified_Mpu_Type use
     (Unified_Memory_Map => 2#0#,
      Not_Unified_Memory_Map => 2#1#);

   type Mpu_Regions_Count_Type is (Mpu_16_Regions,
                                   Mpu_20_Regions,
                                   Mpu_24_Regions)
      with Size => 8;

   for Mpu_Regions_Count_Type use
     (Mpu_16_Regions => 16,
      Mpu_20_Regions => 20,
      Mpu_24_Regions => 24);

   --
   --  MPU Information register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type MPUIR_Type is record
      nU : Not_Unified_Mpu_Type := Unified_Memory_Map;
      DREGION : Mpu_Regions_Count_Type := Mpu_Regions_Count_Type'First;
   end record
   with Size => 32,
        Bit_Order => System.Low_Order_First;

   for MPUIR_Type use record
      nU at 0 range 0 .. 0;
      DREGION at 0 range 8 .. 15;
   end record;

   type Execute_Never_Type is (Executable, Non_Executable)
      with Size => 1;

   for Execute_Never_Type use
     (Executable => 2#0#,
      Non_Executable => 2#1#);

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

   type Address_Top_26_Bits_Type is mod 2 ** 26
      with Size => 26;

   --
   --  Region base address register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type PRBAR_Type is record
      XN : Execute_Never_Type := Non_Executable;
      AP : Access_Permissions_Attribute_Type := EL1_Read_Write_EL0_No_Access;
      SH : Sharability_Attribute_Type := Non_Shareable;
      --  Base address top 26 bits
      BASE : Address_Top_26_Bits_Type := 16#0#;
   end record
   with Size => 32,
        Bit_Order => System.Low_Order_First;

   PRBAR_BASE_Start_Bit_Position : constant := 6;

   for PRBAR_Type use record
      XN at 0 range 0 .. 0;
      AP at 0 range 1 .. 2;
      SH at 0 range 3 .. 4;
      BASE at 0 range PRBAR_BASE_Start_Bit_Position .. 31;
   end record;

   type Region_Enable_Type is (Region_Disabled, Region_Enabled)
      with Size => 1;

   for Region_Enable_Type use
     (Region_Disabled => 2#0#,
      Region_Enabled => 2#1#);

   --  Attribute indices from within the associated Memory Attribute Indirection Register
   type AttrIndx_Type is mod 2 ** 3
      with Size => 3;

   --
   --  Region limit address register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type PRLAR_Type is record
      EN : Region_Enable_Type := Region_Disabled;
      --  Attribute index
      AttrIndx : AttrIndx_Type := 0;
      --  Limit address top 26 bits
      LIMIT : Address_Top_26_Bits_Type := 16#0#;
   end record
   with Size => 32,
        Bit_Order => System.Low_Order_First;

   PRLAR_LIMIT_Start_Bit_Position : constant := 6;

   for PRLAR_Type use record
      EN at 0 range 0 .. 0;
      AttrIndx at 0 range 1 .. 3;
      LIMIT at 0 range PRLAR_LIMIT_Start_Bit_Position .. 31;
   end record;

   type Region_Id_Selector_Type is mod 2 ** 5
      with Size => 5;

   --
   --  Protection region selector register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type PRSELR_Type is record
      REGION : Region_Id_Selector_Type := Region_Id_Selector_Type'First;
   end record
      with Size => 32,
           Bit_Order => System.Low_Order_First;

   for PRSELR_Type use record
      REGION at 0 range 0 .. 4;
   end record;

   function Get_HMPUIR return MPUIR_Type
      with Inline_Always;

   function Get_Selected_HPRBAR return PRBAR_Type
      with Inline_Always;

   function Get_HPRBAR (Region_Id : Memory_Region_Id_Type) return PRBAR_Type
      with Inline_Always;

   procedure Set_Selected_HPRBAR (HPRBAR_Value : PRBAR_Type)
      with Inline_Always;

   procedure Set_HPRBAR (Region_Id : Memory_Region_Id_Type; HPRBAR_Value : PRBAR_Type)
      with Inline_Always;

   function Get_Selected_HPRLAR return PRLAR_Type
      with Inline_Always;

   function Get_HPRLAR (Region_Id : Memory_Region_Id_Type) return PRLAR_Type
      with Inline_Always;

   procedure Set_HPRLAR (HPRLAR_Value : PRLAR_Type)
      with Inline_Always;

   procedure Set_HPRLAR (Region_Id : Memory_Region_Id_Type; HPRLAR_Value : PRLAR_Type)
      with Inline_Always;

   function Get_HPRSELR return PRSELR_Type
      with Inline_Always;

   procedure Set_HPRSELR (HPRSELR_Value : PRSELR_Type)
      with Inline_Always;

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
       Normal_Memory_Outer_Write_Back => 2#1100#);

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
      (Normal_Memory_Inner_Non_Cacheable,
       Normal_Memory_Inner_Write_Through,
       Normal_Memory_Inner_Write_Back)
      with Size => 4;

   for MAIR_Normal_Memory_Subkind_Type use
      (Normal_Memory_Inner_Non_Cacheable => 2#0100#,
       Normal_Memory_Inner_Write_Through => 2#1000#,
       Normal_Memory_Inner_Write_Back => 2#1100#);

   type MAIR_Attr_Type (Memory_Kind : MAIR_Memory_Kind_Type := Device_Memory) is record
      case Memory_Kind is
         when Device_Memory =>
             Device_Memory_Subkind : MAIR_Device_Memory_Subkind_Type := Device_Memory_nGnRnE;
         when others =>
             Normal_Memory_Subkind : MAIR_Normal_Memory_Subkind_Type;
      end case;
   end record
      with Size => 8,
           Bit_Order => System.Low_Order_First;

   for MAIR_Attr_Type use record
      Device_Memory_Subkind at 0 range 0 .. 3;
      Normal_Memory_Subkind at 0 range 0 .. 3;
      Memory_Kind at 0 range 4 .. 7;
   end record;

   type MAIR_Attr_Array_Type is array (0 .. 7) of MAIR_Attr_Type
      with Component_Size => 8,
           Size => 64;

   --  Memory Attribute Indirection Registers 0 and 1
   type MAIR_Pair_Type (As_Words : Boolean := True)  is record
      case As_Words is
         when True =>
            MAIR0 : Interfaces.Unsigned_32;
            MAIR1 : Interfaces.Unsigned_32;
         when False =>
            Attr_Array : MAIR_Attr_Array_Type;
      end case;
   end record
      with Unchecked_Union,
           Size => 64;

   function Get_MAIR_Pair return MAIR_Pair_Type
      with Inline_Always;

   procedure Set_MAIR_Pair (MAIR_Pair : MAIR_Pair_Type)
      with Inline_Always;

   --  Data fault address register
   type DFAR_Type is new Interfaces.Unsigned_32;

   function Get_DFAR return DFAR_Type
      with Inline_Always;

   --
   --  NOTE: A translation fault is taken for the following reasons:
   --  - If an access hits in more than one region in one of the MPUs.
   --  - If an access does not hit in any MPU region and the background region
   --    cannot be used (based on the MPU configuration and current privilege
   --    level).
   --
   type DFSR_Status_Type is (
      No_Fault,
      Translation_Fault_Level0,
      Permission_Fault_Level0,
      Synchronous_External_Abort,
      Asynchronous_External_Abort,
      Synchronous_Parity_Error_On_Memory_Access,
      Asynchronous_Parity_Error_On_Memory_Access,
      Alignment_Fault,
      Debug_Event,
      Unsupported_Exclusive_Access_Fault)
   with Size => 6;

   for DFSR_Status_Type use
     (No_Fault => 2#000000#,
      Translation_Fault_Level0 => 2#000100#,
      Permission_Fault_Level0 => 2#001100#,
      Synchronous_External_Abort => 2#010000#,
      Asynchronous_External_Abort => 2#010001#,
      Synchronous_Parity_Error_On_Memory_Access => 2#011000#,
      Asynchronous_Parity_Error_On_Memory_Access => 2#011001#,
      Alignment_Fault => 2#100001#,
      Debug_Event => 2#100010#,
      Unsupported_Exclusive_Access_Fault => 2#110101#);

   type Write_Not_Read_Bit_Type is (Abort_Caused_By_Read_Access,
                                    Abort_Caused_By_Write_Access)
      with Size => 1;

   for Write_Not_Read_Bit_Type use
     (Abort_Caused_By_Read_Access => 2#0#,
      Abort_Caused_By_Write_Access => 2#1#);

   type External_Abort_Kind_Type is (AXI_Decode_Error_External_Abort,
                                     Slave_Error_External_Abort)
      with Size => 1;

   for External_Abort_Kind_Type use
     (AXI_Decode_Error_External_Abort => 2#0#,
      Slave_Error_External_Abort => 2#1#);

   type Cache_Maintenance_Fault_Type is (Non_Cache_Maintenance_Sync_Abort,
                                         Cache_Maintenance_Sync_Abort)
      with Size => 1;

   for Cache_Maintenance_Fault_Type use
     (Non_Cache_Maintenance_Sync_Abort => 2#0#,
      Cache_Maintenance_Sync_Abort => 2#1#);

   --  Data fault status register
   type DFSR_Type is record
      Status : DFSR_Status_Type := No_Fault;
      WnR : Write_Not_Read_Bit_Type;
      ExT : External_Abort_Kind_Type;
      CM : Cache_Maintenance_Fault_Type;
   end record
   with Size => 32,
        Bit_Order => System.Low_Order_First;

   for DFSR_Type use record
      Status at 0 range 0 .. 5;
      WnR at 0 range 11 .. 11;
      ExT at 0 range 12 .. 12;
      CM at 0 range 13 .. 13;
   end record;

   function Get_DFSR return DFSR_Type
      with Inline_Always;

   --  Instruction fault address register
   type IFAR_Type is new Interfaces.Unsigned_32;

   function Get_IFAR return IFAR_Type
      with Inline_Always;

   subtype IFSR_Status_Type is DFSR_Status_Type;

   --  Instruction fault status register
   type IFSR_Type is record
      Status : IFSR_Status_Type := No_Fault;
      ExT : External_Abort_Kind_Type;
   end record
   with Size => 32,
        Bit_Order => System.Low_Order_First;

   for IFSR_Type use record
      Status at 0 range 0 .. 5;
      ExT at 0 range 12 .. 12;
   end record;

   function Get_IFSR return IFSR_Type
      with Inline_Always;

   --
   --  ARM Cortex-R memory protection region descriptor
   --
   type Memory_Region_Descriptor_Type is limited record
      --  Region base address register
      PRBAR_Value : PRBAR_Type;
      --  Region limit address register
      PRLAR_Value : PRLAR_Type;
   end record
     with Convention => C;

   function Encode_Region_Border_Address_Field (Start_Address : System.Address) return Address_Top_26_Bits_Type
   is (Address_Top_26_Bits_Type (
         Interfaces.Shift_Right (
            Interfaces.Unsigned_32 (To_Integer (Start_Address)), PRBAR_BASE_Start_Bit_Position)));

   function Decode_Region_Last_Address_Field (Base_Field : Address_Top_26_Bits_Type) return System.Address
   is (System.Storage_Elements.To_Address (System.Storage_Elements.Integer_Address (
         Interfaces.Shift_Left (Interfaces.Unsigned_32 (Base_Field), PRBAR_BASE_Start_Bit_Position)
         or
         Interfaces.Unsigned_32 (Bit_Mask (Bit_Index_Type (PRBAR_BASE_Start_Bit_Position)) - 1))));

   function Is_Memory_Region_Descriptor_Enabled (Region_Descriptor : Memory_Region_Descriptor_Type)
      return Boolean is
      (Region_Descriptor.PRLAR_Value.EN = Region_Enabled);

   function Is_Memory_Region_Enabled (Region_Id : Memory_Region_Id_Type) return Boolean is
      (Get_PRLAR (Region_Id).EN = Region_Enabled);

   Memory_Attributes_Lookup_Table : constant MAIR_Attr_Array_Type :=
      [ Device_Memory_Mapped_Io'Enum_Rep =>
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
        others => <> ];

   No_Fault_Str : aliased constant String := "None";
   Translation_Fault_Level0_Str : aliased constant String := "Translation_Fault_Level0";
   Permission_Fault_Level0_Str : aliased constant String := "Permission_Fault_Level0";
   Synchronous_External_Abort_Str : aliased constant String := "Synchronous_External_Abort";
   Asynchronous_External_Abort_Str : aliased constant String := "Asynchronous_External_Abort";
   Synchronous_Parity_Error_On_Memory_Access_Str : aliased constant String :=
      "Synchronous_Parity_Error_On_Memory_Access";
   Asynchronous_Parity_Error_On_Memory_Access_Str : aliased constant String :=
      "Asynchronous_Parity_Error_On_Memory_Access";
   Alignment_Fault_Str : aliased constant String := "Alignment_Fault";
   Debug_Event_Str : aliased constant String := "Debug_Event";
   Unsupported_Exclusive_Access_Fault_Str : aliased constant String :=
      "Unsupported_Exclusive_Access_Fault";

   Fault_Name_Pointer_Array : constant array (DFSR_Status_Type) of not null access constant String :=
      [No_Fault => No_Fault_Str'Access,
         Translation_Fault_Level0 => Translation_Fault_Level0_Str'Access,
         Permission_Fault_Level0 => Permission_Fault_Level0_Str'Access,
         Synchronous_External_Abort => Synchronous_External_Abort_Str'Access,
         Asynchronous_External_Abort => Asynchronous_External_Abort_Str'Access,
         Synchronous_Parity_Error_On_Memory_Access => Synchronous_Parity_Error_On_Memory_Access_Str'Access,
         Asynchronous_Parity_Error_On_Memory_Access => Asynchronous_Parity_Error_On_Memory_Access_Str'Access,
         Alignment_Fault => Alignment_Fault_Str'Access,
         Debug_Event => Debug_Event_Str'Access,
         Unsupported_Exclusive_Access_Fault => Unsupported_Exclusive_Access_Fault_Str'Access];

end HiRTOS_Cpu_Arch_Interface.Memory_Protection;
