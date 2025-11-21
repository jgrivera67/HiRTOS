--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS multi-core CPU interface private for ARMv8-A architecture
--

with HiRTOS_Cpu_Arch_Parameters;
with Bit_Sized_Integer_Types;
with Interfaces;
with System;

package HiRTOS_Cpu_Multi_Core_Interface.Arch_Specific with
   SPARK_Mode => On
is
   use HiRTOS_Cpu_Arch_Parameters;
   use Bit_Sized_Integer_Types;

   type MPIDR_EL1_Type (As_Value : Boolean := True)  is record
      case As_Value is
         when True =>
            Value : Interfaces.Unsigned_64 := 0;
         when False =>
            Aff0 : Interfaces.Unsigned_8 := 0;  --  CPU ID if MT is 0
            Aff1 : Interfaces.Unsigned_8 := 0;  --  CPU ID if MT is 1
            Aff2 : Interfaces.Unsigned_8 := 0;  --  Affinity level 2 Cluster Id
            MT   : Bit_Type := 0;               --  0: Aff0 is CPU ID, 1: Aff1 is CPU ID
            U    : Bit_Type := 0;               --  Uniprocessor
            Res1 : Bit_Type := 1;               --  Reserved field set to 1
            Aff3 : Interfaces.Unsigned_8 := 0;  --  Affinity level 3 Cluster Id
      end case;
   end record
   with Size => 64,
        Bit_Order => System.Low_Order_First,
        Unchecked_Union;

   for MPIDR_EL1_Type use record
      Value at 0 range 0 .. 63;
      Aff0  at 0 range 0 .. 7;
      Aff1  at 0 range 8 .. 15;
      Aff2  at 0 range 16 .. 23;
      MT    at 0 range 24 .. 24;
      U     at 0 range 30 .. 30;
      Res1  at 0 range 31 .. 31;
      Aff3  at 0 range 32 .. 39;
   end record;

   function Cpu_Id_To_MPIDR (Cpu_Id : Valid_Cpu_Core_Id_Type;
                             Cpu_Model : Cpu_Model_Type)
      return MPIDR_EL1_Type is
      (case Cpu_Model is
         when Cortex_A72 =>
            (As_Value => False,
             Aff0 => Interfaces.Unsigned_8 (Cpu_Id),
             others => <>),
         when Cortex_A76 =>
            (As_Value => False,
             Aff1 => Interfaces.Unsigned_8 (Cpu_Id),
             MT => 1,
             others => <>));

end HiRTOS_Cpu_Multi_Core_Interface.Arch_Specific;