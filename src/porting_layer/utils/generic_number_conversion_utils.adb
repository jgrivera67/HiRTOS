--
--  Copyright (c) 2016-2022, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

package body Generic_Number_Conversion_Utils is

   procedure Unsigned_To_Hexadecimal_String (Value : Unsigned_Type;
                                             Buffer : out String)
   is
      Hex_Digit : Unsigned_Type range 16#0# .. 16#f#;
      Value_Left : Unsigned_Type := Value;
   begin
      for I in reverse Buffer'Range loop
         Hex_Digit := Value_Left and 16#f#;
         if Hex_Digit < 16#a# then
            Buffer (I) := Character'Val (Hex_Digit + Character'Pos ('0'));
         else
            Buffer (I) := Character'Val ((Hex_Digit - 16#a#) +
                                           Character'Pos ('A'));
         end if;

         Value_Left := Shift_Right_Func (Value_Left, 4);
      end loop;

      pragma Assert (Value_Left = 0);
   end Unsigned_To_Hexadecimal_String;

   procedure Hexadecimal_String_To_Unsigned (Hexadecimal_Str : String;
                                             Value : out Unsigned_Type;
                                             Conversion_Ok : out Boolean)
   is
      Prev_Value : Unsigned_Type;
      Hexadecimal_Digit : Unsigned_Type;
   begin
      Value := 0;
      for C of Hexadecimal_Str loop
         if C in '0' .. '9' then
            Hexadecimal_Digit := Character'Pos (C) - Character'Pos ('0');
         elsif C in 'A' .. 'F' then
            Hexadecimal_Digit := Character'Pos (C) - Character'Pos ('A') + 10;
         elsif C in 'a' .. 'f' then
            Hexadecimal_Digit := Character'Pos (C) - Character'Pos ('a') + 10;
         else
            Conversion_Ok := False;
            return;
         end if;

         Prev_Value := Value;
         Value := Shift_Left_Func (Value, 4) or Hexadecimal_Digit;
         if Value < Prev_Value then
            --  Number is too big
            Conversion_Ok := False;
            return;
         end if;
      end loop;

      Conversion_Ok := True;
   end Hexadecimal_String_To_Unsigned;

end Generic_Number_Conversion_Utils;
