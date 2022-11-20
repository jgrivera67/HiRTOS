--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
--

--
--  @summary RTOS to target platform interface - Memory protection services
--  for ARMv8-R MPU
--

with System.Storage_Elements;
with Interfaces;

package HiRTOS_Cpu_Arch_Interface.Memory_Protection
   with SPARK_Mode => On
is
   use type System.Address;
   use type System.Storage_Elements.Integer_Address;

   type Memory_Region_Descriptor_Type is limited private;

   type Region_Permissions_Type is (None,
                                    Read_Only,
                                    Read_Write,
                                    Read_Execute);

   Max_Num_Memory_Regions : constant := 24;

   type Memory_Region_Id_Type is mod Max_Num_Memory_Regions;

   --
   --  Enables memory protection hardware
   --
   procedure Enable_Memory_Protection;

   --
   --  Disables memory protection hardware
   --
   procedure Disable_Memory_Protection;

   --
   --  Initializes state of a memory protection descriptor object
   --
   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Permissions : Region_Permissions_Type)
      with Pre => Start_Address /= System.Null_Address and then
                  Size_In_Bytes > 0 and then
                  Permissions /= None;

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

private

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
   type AttrIndx_Type is
      (Attr0, --  Select the Attr0 field from MAIR0.
       Attr1, --  Select the Attr1 field from MAIR0.
       Attr2, --  Select the Attr2 field from MAIR0.
       Attr3, --  Select the Attr3 field from MAIR0.
       Attr4, --  Select the Attr4 field from MAIR1.
       Attr5, --  Select the Attr5 field from MAIR1.
       Attr6, --  Select the Attr6 field from MAIR1.
       Attr7) --  Select the Attr7 field from MAIR1.
      with Size => 3;

   for AttrIndx_Type use
     (Attr0 => 2#000#,
      Attr1 => 2#001#,
      Attr2 => 2#010#,
      Attr3 => 2#011#,
      Attr4 => 2#100#,
      Attr5 => 2#101#,
      Attr6 => 2#110#,
      Attr7 => 2#111#);

   --
   --  Region limit address register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type PRLAR_Type is record
      EN : Region_Enable_Type := Region_Disabled;
      --  Attribute index
      AttrIndx : AttrIndx_Type := Attr0;
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

   function Get_MPUIR return MPUIR_Type
      with Inline_Always;

   function Get_PRBAR return PRBAR_Type
      with Inline_Always;

   function Get_PRBAR (Region_Id : Memory_Region_Id_Type) return PRBAR_Type
      with Inline_Always;

   procedure Set_PRBAR (PRBAR_Value : PRBAR_Type)
      with Inline_Always;

   procedure Set_PRBAR (Region_Id : Memory_Region_Id_Type; PRBAR_Value : PRBAR_Type)
      with Inline_Always;

   function Get_PRLAR return PRLAR_Type
      with Inline_Always;

   function Get_PRLAR (Region_Id : Memory_Region_Id_Type) return PRLAR_Type
      with Inline_Always;

   procedure Set_PRLAR (PRLAR_Value : PRLAR_Type)
      with Inline_Always;

   procedure Set_PRLAR (Region_Id : Memory_Region_Id_Type; PRLAR_Value : PRLAR_Type)
      with Inline_Always;

   function Get_PRSELR return PRSELR_Type
      with Inline_Always;

   procedure Set_PRSELR (PRSELR_Value : PRSELR_Type)
      with Inline_Always;

   --  Data fault address register
   type DFAR_Type is new Interfaces.Unsigned_32;

   function Get_DFAR return DFAR_Type
      with Inline_Always;

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

end HiRTOS_Cpu_Arch_Interface.Memory_Protection;
