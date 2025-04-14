--
--  Copyright (c) 2016-2022, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

generic
   type Unsigned_Type is mod <>;
   with function Shift_Right_Func (Value : Unsigned_Type; Shift : Natural) return Unsigned_Type;
   with function Shift_Left_Func (Value : Unsigned_Type; Shift : Natural) return Unsigned_Type;
package Generic_Number_Conversion_Utils
is
   procedure Unsigned_To_Hexadecimal_String (Value : Unsigned_Type;
                                             Buffer : out String);

   procedure Hexadecimal_String_To_Unsigned (Hexadecimal_Str : String;
                                             Value : out Unsigned_Type;
                                             Conversion_Ok : out Boolean);
end Generic_Number_Conversion_Utils;
