--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  Bit-sized unsigned integer types that don't have to byte-multiple sizes
--
with Interfaces;

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

   type Nine_Bits_Type is mod 2 ** 9
     with Size => 9;

   type Twelve_Bits_Type is mod 2 ** 12
     with Size => 12;

   type Eighteen_Bits_Type is mod 2 ** 18
     with Size => 18;

   type Twenty_Four_Bits_Type is mod 2 ** 24
     with Size => 24;

   type Twenty_Seven_Bits_Type is mod 2 ** 27
     with Size => 27;

   subtype Byte_Type is Interfaces.Unsigned_8;

   subtype Half_Word_Type is Interfaces.Unsigned_16;

   subtype Word_Type is Interfaces.Unsigned_32;

   subtype Dword_Type is Interfaces.Unsigned_64;

   type Words_Array_Type is array (Positive range <>) of Word_Type;

end Bit_Sized_Integer_Types;
