--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary ARMv8-R EL2-controlled MPU
--

private package HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor.EL2_MPU
   with SPARK_Mode => On
is
      --
   --  EL2-controlled MPU region access permissions
   --
   --  Read/write at EL2, no access at EL1/EL0
   EL2_Read_Write_EL1_EL0_No_Access :
      constant Access_Permissions_Attribute_Type := EL1_Read_Write_EL0_No_Access;
   --  Read/write at EL2 or EL1/EL0
   EL2_and_EL1_EL0_Read_Write :
      constant Access_Permissions_Attribute_Type := EL1_and_EL0_Read_Write;
   --  Read-only at EL2, no access at EL1/EL0
   EL2_Read_Only_EL1_EL0_No_Access :
      constant Access_Permissions_Attribute_Type := EL1_Read_Only_EL0_No_Access;
   --  Read-only at EL2 and E21/EL0
   EL2_and_EL1_EL0_Read_Only :
      constant Access_Permissions_Attribute_Type := EL1_and_EL0_Read_Only;

   --
   --  EL2-controlled MPU Information register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type HMPUIR_Type is record
      REGION : Mpu_Regions_Count_Type := Mpu_Regions_Count_Type'First;
   end record
   with Size => 32,
        Bit_Order => System.Low_Order_First;

   for HMPUIR_Type use record
      REGION at 0 range 0 .. 7;
   end record;

   function Get_HMPUIR return HMPUIR_Type
      with Inline_Always;

   function Get_HPRBAR return PRBAR_Type
      with Inline_Always;

   function Get_HPRBAR (Region_Id : Memory_Region_Id_Type) return PRBAR_Type
      with Inline_Always;

   procedure Set_HPRBAR (HPRBAR_Value : PRBAR_Type)
      with Inline_Always;

   procedure Set_HPRBAR (Region_Id : Memory_Region_Id_Type; HPRBAR_Value : PRBAR_Type)
      with Inline_Always;

   function Get_HPRLAR return PRLAR_Type
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

   function Get_HMAIR_Pair return MAIR_Pair_Type
      with Inline_Always;

   procedure Set_HMAIR_Pair (MAIR_Pair : MAIR_Pair_Type)
      with Inline_Always;

   --
   --  EL2-controlled MPU's enabled regions register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   subtype HPRENR_Type is Memory_Regions_Enabled_Bit_Mask_Type;

   function Get_HPRENR return HPRENR_Type
      with Inline_Always;

   procedure Set_HPRENR (HPRENR_Value : HPRENR_Type)
      with Inline_Always;

   function Get_HDFAR return DFAR_Type
      with Inline_Always;

   function Get_HIFAR return IFAR_Type
      with Inline_Always;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor.EL2_MPU;
