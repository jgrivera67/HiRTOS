--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  Bit-sized unsigned integer types that don't have to byte-multiple sizes
--
package Bit_Sized_Integer_Types  with No_Elaboration_Code_All is
   type Bit_Type is mod 2 ** 1
     with Size => 1;

   type Two_Bits_Type is mod 2 ** 2
     with Size => 2;

   type Three_Bits_Type is mod 2 ** 3
     with Size => 3;

   type Four_Bits_Type is mod 2 ** 4
     with Size => 4;

   type Five_Bits_Type is mod 2 ** 5
     with Size => 5;

   type Six_Bits_Type is mod 2 ** 6
     with Size => 6;

   type Seven_Bits_Type is mod 2 ** 7
     with Size => 7;

   type Eighteen_Bits_Type is mod 2 ** 18
     with Size => 18;

   type Twenty_Seven_Bits_Type is mod 2 ** 27
     with Size => 27;

end Bit_Sized_Integer_Types;
