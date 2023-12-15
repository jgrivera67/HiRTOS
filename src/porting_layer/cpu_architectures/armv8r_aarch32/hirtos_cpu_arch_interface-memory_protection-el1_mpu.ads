--
--  Copyright (c) 2022-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary ARMv8-R EL1-controlled MPU
--

private package HiRTOS_Cpu_Arch_Interface.Memory_Protection.EL1_MPU
   with SPARK_Mode => On
is
   --
   --  EL1-controlled MPU Information register
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

   function Get_MAIR_Pair return MAIR_Pair_Type
      with Inline_Always;

   procedure Set_MAIR_Pair (MAIR_Pair : MAIR_Pair_Type)
      with Inline_Always;

   function Get_DFAR return DFAR_Type
      with Inline_Always;

   function Get_DFSR return DFSR_Type
      with Inline_Always;

   function Get_IFAR return IFAR_Type
      with Inline_Always;

   function Get_IFSR return IFSR_Type
      with Inline_Always;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection.EL1_MPU;
