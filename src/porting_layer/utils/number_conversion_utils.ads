--
--  Copyright (c) 2016-2022, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--
with Generic_Number_Conversion_Utils;
with Interfaces;

package Number_Conversion_Utils
is
   use Interfaces;

   procedure Decimal_String_To_Unsigned (Decimal_Str : String;
                                         Value : out Unsigned_32;
                                         Conversion_Ok : out Boolean);

   procedure Decimal_String_To_Unsigned (Decimal_Str : String;
                                         Value : out Unsigned_16;
                                         Conversion_Ok : out Boolean);

   procedure Decimal_String_To_Unsigned (Decimal_Str : String;
                                         Value : out Unsigned_8;
                                         Conversion_Ok : out Boolean);

   procedure Decimal_String_To_Float (Decimal_Str : String;
                                      Value : out Float;
                                      Conversion_Ok : out Boolean);

   procedure Float_To_Decimal_String (Value : Float;
                                      Buffer : out String;
                                      Actual_Length : out Positive);

   package Unsigned_64_Number_Conversion_Utils
     is new Generic_Number_Conversion_Utils
       (Unsigned_Type => Unsigned_64,
        Shift_Right_Func => Interfaces.Shift_Right,
        Shift_Left_Func => Interfaces.Shift_Left);

   package Unsigned_32_Number_Conversion_Utils
     is new Generic_Number_Conversion_Utils
       (Unsigned_Type => Unsigned_32,
        Shift_Right_Func => Interfaces.Shift_Right,
        Shift_Left_Func => Interfaces.Shift_Left);

   package Unsigned_16_Number_Conversion_Utils
     is new Generic_Number_Conversion_Utils
       (Unsigned_Type => Unsigned_16,
        Shift_Right_Func => Interfaces.Shift_Right,
        Shift_Left_Func => Interfaces.Shift_Left);

   package Unsigned_8_Number_Conversion_Utils
     is new Generic_Number_Conversion_Utils
       (Unsigned_Type => Unsigned_8,
        Shift_Right_Func => Interfaces.Shift_Right,
        Shift_Left_Func => Interfaces.Shift_Left);

   procedure Hexadecimal_String_To_Unsigned (Hexadecimal_Str : String;
                                             Value : out Unsigned_64;
                                             Conversion_Ok : out Boolean)
   renames Unsigned_64_Number_Conversion_Utils.Hexadecimal_String_To_Unsigned;

   procedure Hexadecimal_String_To_Unsigned (Hexadecimal_Str : String;
                                             Value : out Unsigned_32;
                                             Conversion_Ok : out Boolean)
   renames Unsigned_32_Number_Conversion_Utils.Hexadecimal_String_To_Unsigned;

   procedure Hexadecimal_String_To_Unsigned (Hexadecimal_Str : String;
                                             Value : out Unsigned_16;
                                             Conversion_Ok : out Boolean)
   renames Unsigned_16_Number_Conversion_Utils.Hexadecimal_String_To_Unsigned;

   procedure Hexadecimal_String_To_Unsigned (Hexadecimal_Str : String;
                                             Value : out Unsigned_8;
                                             Conversion_Ok : out Boolean)
   renames Unsigned_8_Number_Conversion_Utils.Hexadecimal_String_To_Unsigned;

   subtype Signed_32_Decimal_String_Type is String (1 .. 11);

   procedure Signed_To_Decimal_String (Value : Integer_32;
                                       Buffer : out String;
                                       Actual_Length : out Positive)
      with Pre => Buffer'Length >= 1,
           Post => Actual_Length in Buffer'Range;

   subtype Unsigned_32_Decimal_String_Type is String (1 .. 10);

   procedure Unsigned_To_Decimal_String (Value : Unsigned_32;
                                         Buffer : out String;
                                         Actual_Length : out Positive;
                                         Add_Leading_Zeros : Boolean := False)
     with Pre => Buffer'Length >= 1,
          Post => Actual_Length in Buffer'Range;

   subtype Unsigned_64_Hexadecimal_String_Type is String (1 .. 16);
   subtype Unsigned_32_Hexadecimal_String_Type is String (1 .. 8);
   subtype Unsigned_16_Hexadecimal_String_Type is String (1 .. 4);
   subtype Unsigned_8_Hexadecimal_String_Type is String (1 .. 2);

   procedure Unsigned_To_Hexadecimal_String (Value : Unsigned_64;
                                             Buffer : out String)
   renames Unsigned_64_Number_Conversion_Utils.Unsigned_To_Hexadecimal_String;

   procedure Unsigned_To_Hexadecimal_String (Value : Unsigned_32;
                                             Buffer : out String)
   renames Unsigned_32_Number_Conversion_Utils.Unsigned_To_Hexadecimal_String;

   procedure Unsigned_To_Hexadecimal_String (Value : Unsigned_16;
                                             Buffer : out String)
   renames Unsigned_16_Number_Conversion_Utils.Unsigned_To_Hexadecimal_String;

   procedure Unsigned_To_Hexadecimal_String (Value : Unsigned_8;
                                             Buffer : out String)
   renames Unsigned_8_Number_Conversion_Utils.Unsigned_To_Hexadecimal_String;

end Number_Conversion_Utils;
