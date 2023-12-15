--
--  Copyright (c) 2016-2022, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

package body Number_Conversion_Utils is

   -----------------------------
   -- Decimal_String_To_Float --
   -----------------------------

   procedure Decimal_String_To_Float (Decimal_Str : String;
                                      Value : out Float;
                                      Conversion_Ok : out Boolean)
   is
      Integer_Part : Unsigned_32;
      Fraction_Part : Unsigned_32;
      Decimal_Point_Index : Natural := 0;
      Decimal_Divisor : Natural;
   begin
      Value := 0.0;

      for I in Decimal_Str'Range loop
         if Decimal_Str (I) = '.' then
            Decimal_Point_Index := I;
            exit;
         end if;
      end loop;

      if Decimal_Point_Index = 0 then
         Conversion_Ok := False;
         return;
      end if;

      Decimal_String_To_Unsigned (Decimal_Str (Decimal_Str'First ..
                                               Decimal_Point_Index - 1),
                                  Integer_Part,
                                  Conversion_Ok);
      if not Conversion_Ok then
         return;
      end if;

      Decimal_String_To_Unsigned (Decimal_Str (Decimal_Point_Index + 1 ..
                                               Decimal_Str'Last),
                                  Fraction_Part,
                                  Conversion_Ok);
      if not Conversion_Ok then
         return;
      end if;

      Decimal_Divisor := 1;
      for I in Decimal_Point_Index + 1 .. Decimal_Str'Last loop
         Decimal_Divisor := Decimal_Divisor * 10;
      end loop;

      if Decimal_Divisor /= 0 then
         Value := Float (Integer_Part) + (Float (Fraction_Part) /
                                          Float (Decimal_Divisor));
      else
         Value := Float (Integer_Part);
      end if;
   end Decimal_String_To_Float;

   --------------------------------
   -- Decimal_String_To_Unsigned --
   --------------------------------

   procedure Decimal_String_To_Unsigned
     (Decimal_Str : String;
      Value : out Unsigned_32;
      Conversion_Ok : out Boolean)
   is
      Prev_Value : Unsigned_32;
      Decimal_Digit : Unsigned_32;
   begin
      Value := 0;
      for C of Decimal_Str loop
         if C in '0' .. '9' then
            Decimal_Digit := Character'Pos (C) - Character'Pos ('0');
         else
            Conversion_Ok := False;
            return;
         end if;

         Prev_Value := Value;
         Value := Value * 10 + Decimal_Digit;
         if Value < Prev_Value then
            --  Number is too big
            Conversion_Ok := False;
            return;
         end if;
      end loop;

      Conversion_Ok := True;
   end Decimal_String_To_Unsigned;

   --------------------------------
   -- Decimal_String_To_Unsigned --
   --------------------------------

   procedure Decimal_String_To_Unsigned
     (Decimal_Str : String;
      Value : out Unsigned_16;
      Conversion_Ok : out Boolean)
   is
      Unsigned_32_Value : Unsigned_32;
   begin
      Value := 0;
      Decimal_String_To_Unsigned (Decimal_Str, Unsigned_32_Value,
                                  Conversion_Ok);
      if Conversion_Ok then
         if Unsigned_32_Value <= Unsigned_32 (Unsigned_16'Last) then
            Value := Unsigned_16 (Unsigned_32_Value);
         else
            Conversion_Ok := False;
         end if;
      end if;
   end Decimal_String_To_Unsigned;

   --------------------------------
   -- Decimal_String_To_Unsigned --
   --------------------------------

   procedure Decimal_String_To_Unsigned
     (Decimal_Str : String;
      Value : out Unsigned_8;
      Conversion_Ok : out Boolean)
   is
      Unsigned_32_Value : Unsigned_32;
   begin
      Value := 0;
      Decimal_String_To_Unsigned (Decimal_Str, Unsigned_32_Value,
                                  Conversion_Ok);
      if Conversion_Ok then
         if Unsigned_32_Value <= Unsigned_32 (Unsigned_8'Last) then
            Value := Unsigned_8 (Unsigned_32_Value);
         else
            Conversion_Ok := False;
         end if;
      end if;
   end Decimal_String_To_Unsigned;

   -----------------------------
   -- Float_To_Decimal_String --
   -----------------------------

   procedure Float_To_Decimal_String (Value : Float;
                                      Buffer : out String;
                                      Actual_Length : out Positive)
   is
      Buffer_Index : Positive := Buffer'First;
      Integer_Part : constant Unsigned_32 :=
         Unsigned_32 (Float'Floor (abs Value));
      Fraction_Part : constant Unsigned_32 :=
         Unsigned_32 (
            Float'Rounding (((abs Value) - Float (Integer_Part)) * 100.0));
      Integer_Part_Str_Length : Positive;
      Fraction_Part_Str_Length : Positive;
   begin
      if Value < 0.0 then
         Buffer (Buffer_Index) := '-';
         Buffer_Index := Buffer_Index + 1;
      end if;

      Unsigned_To_Decimal_String (Integer_Part,
                                  Buffer (Buffer_Index .. Buffer'Last),
                                  Integer_Part_Str_Length);
      Buffer_Index := Buffer_Index + Integer_Part_Str_Length;
      if Buffer_Index > Buffer'Last then
         Actual_Length := Integer_Part_Str_Length;
         return;
      end if;

      Buffer (Buffer_Index) := '.';
      Buffer_Index := Buffer_Index + 1;
      if Buffer_Index > Buffer'Last then
         Actual_Length := Integer_Part_Str_Length + 1;
         return;
      end if;

      Unsigned_To_Decimal_String (Fraction_Part,
                                  Buffer (Buffer_Index .. Buffer'Last),
                                  Fraction_Part_Str_Length);
      Actual_Length := Integer_Part_Str_Length + 1 + Fraction_Part_Str_Length;
   end Float_To_Decimal_String;

   ------------------------------------
   -- Hexadecimal_String_To_Unsigned --
   ------------------------------------

   procedure Hexadecimal_String_To_Unsigned
     (Hexadecimal_Str : String;
      Value : out Unsigned_32;
      Conversion_Ok : out Boolean)
   is
      Prev_Value : Unsigned_32;
      Hexadecimal_Digit : Unsigned_32;
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
         Value := Shift_Left (Value, 4) or Hexadecimal_Digit;
         if Value < Prev_Value then
            --  Number is too big
            Conversion_Ok := False;
            return;
         end if;
      end loop;

      Conversion_Ok := True;
   end Hexadecimal_String_To_Unsigned;

   ------------------------------------
   -- Hexadecimal_String_To_Unsigned --
   ------------------------------------

   procedure Hexadecimal_String_To_Unsigned
     (Hexadecimal_Str : String;
      Value : out Unsigned_16;
      Conversion_Ok : out Boolean)
   is
      Unsigned_32_Value : Unsigned_32;
   begin
      Value := 0;
      Hexadecimal_String_To_Unsigned (Hexadecimal_Str, Unsigned_32_Value,
                                      Conversion_Ok);
      if Conversion_Ok then
         if Unsigned_32_Value <= Unsigned_32 (Unsigned_16'Last) then
            Value := Unsigned_16 (Unsigned_32_Value);
         else
            Conversion_Ok := False;
         end if;
      end if;
   end Hexadecimal_String_To_Unsigned;

   ------------------------------------
   -- Hexadecimal_String_To_Unsigned --
   ------------------------------------

   procedure Hexadecimal_String_To_Unsigned
     (Hexadecimal_Str : String;
      Value : out Unsigned_8;
      Conversion_Ok : out Boolean)
   is
      Unsigned_32_Value : Unsigned_32;
   begin
      Value := 0;
      Hexadecimal_String_To_Unsigned (Hexadecimal_Str, Unsigned_32_Value,
                                      Conversion_Ok);
      if Conversion_Ok then
         if Unsigned_32_Value <= Unsigned_32 (Unsigned_8'Last) then
            Value := Unsigned_8 (Unsigned_32_Value);
         else
            Conversion_Ok := False;
         end if;
      end if;
   end Hexadecimal_String_To_Unsigned;

   -----------------------------
   -- Signed_To_Decimal_String --
   ------------------------------

   procedure Signed_To_Decimal_String (Value : Integer_32;
                                       Buffer : out String;
                                       Actual_Length : out Positive)
  is
      Tmp_Buffer : String (1 .. 10);
      Start_Index : Positive range Tmp_Buffer'Range := Tmp_Buffer'First;
      Value_Left : Unsigned_32 := Unsigned_32 (abs Value);
   begin
      for I in reverse Tmp_Buffer'Range loop
         Tmp_Buffer (I) := Character'Val ((Value_Left mod 10) +
                                          Character'Pos ('0'));
         Value_Left := Value_Left / 10;
         if Value_Left = 0 then
            Start_Index := I;
            exit;
         end if;
      end loop;

      Actual_Length := (Tmp_Buffer'Last - Start_Index) + 1;
      if Value < 0 then
         Actual_Length := Actual_Length + 1;
         if Buffer'Length >= Actual_Length then
            Buffer (Buffer'First) := '-';
            Buffer (Buffer'First + 1 .. Buffer'First + 1 + Actual_Length - 2) :=
               Tmp_Buffer (Start_Index .. Tmp_Buffer'Last);
         else
            raise Program_Error
               with "Signed_To_Decimal_String: buffer too small";
         end if;

      else
         if Buffer'Length >= Actual_Length then
            Buffer (Buffer'First .. Buffer'First + Actual_Length - 1) :=
               Tmp_Buffer (Start_Index .. Tmp_Buffer'Last);
         else
            raise Program_Error
               with "Signed_To_Decimal_String: buffer too small";
         end if;
      end if;

   end Signed_To_Decimal_String;

   --------------------------------
   -- Unsigned_To_Decimal_String --
   --------------------------------

   procedure Unsigned_To_Decimal_String (Value : Unsigned_32;
                                         Buffer : out String;
                                         Actual_Length : out Positive;
                                         Add_Leading_Zeros : Boolean := False)
  is
      Tmp_Buffer : String (1 .. 10);
      Start_Index : Positive range Tmp_Buffer'Range := Tmp_Buffer'First;
      Value_Left : Unsigned_32 := Value;
   begin
      for I in reverse Tmp_Buffer'Range loop
         Tmp_Buffer (I) := Character'Val ((Value_Left mod 10) +
                                          Character'Pos ('0'));
         Value_Left := Value_Left / 10;
         if Value_Left = 0 then
            Start_Index := I;
            exit;
         end if;
      end loop;

      Actual_Length := (Tmp_Buffer'Last - Start_Index) + 1;
      if Buffer'Length >= Actual_Length then
         if Add_Leading_Zeros then
            Buffer (Buffer'First .. Buffer'Last - Actual_Length) :=
               [others => '0'];
            Buffer (Buffer'Last - Actual_Length + 1 .. Buffer'Last) :=
               Tmp_Buffer (Start_Index .. Tmp_Buffer'Last);
            Actual_Length := Buffer'Length;
         else
            Buffer (Buffer'First .. Buffer'First + Actual_Length - 1) :=
               Tmp_Buffer (Start_Index .. Tmp_Buffer'Last);
         end if;
      else
         raise Program_Error
            with "Unsigned_To_Decimal: buffer too small";
      end if;

   end Unsigned_To_Decimal_String;

   ------------------------------------
   -- Unsigned_To_Hexadecimal_String --
   ------------------------------------

   procedure Unsigned_To_Hexadecimal_String (Value : Unsigned_32;
                                             Buffer : out String)
   is
      Hex_Digit : Unsigned_32 range 16#0# .. 16#f#;
      Value_Left : Unsigned_32 := Value;
   begin
      for I in reverse Buffer'Range loop
         Hex_Digit := Value_Left and 16#f#;
         if Hex_Digit < 16#a# then
            Buffer (I) := Character'Val (Hex_Digit + Character'Pos ('0'));
         else
            Buffer (I) := Character'Val ((Hex_Digit - 16#a#) +
                                           Character'Pos ('A'));
         end if;

         Value_Left := Shift_Right (Value_Left, 4);
      end loop;

      pragma Assert (Value_Left = 0);

   end Unsigned_To_Hexadecimal_String;

   ------------------------------------
   -- Unsigned_To_Hexadecimal_String --
   ------------------------------------

   procedure Unsigned_To_Hexadecimal_String (Value : Unsigned_16;
                                             Buffer : out String)
   is
      Hex_Digit : Unsigned_16 range 16#0# .. 16#f#;
      Value_Left : Unsigned_16 := Value;
   begin
      for I in reverse Buffer'Range loop
         Hex_Digit := Value_Left and 16#f#;
         if Hex_Digit < 16#a# then
            Buffer (I) := Character'Val (Hex_Digit + Character'Pos ('0'));
         else
            Buffer (I) := Character'Val ((Hex_Digit - 16#a#) +
                                           Character'Pos ('A'));
         end if;

         Value_Left := Shift_Right (Value_Left, 4);
      end loop;

      pragma Assert (Value_Left = 0);

   end Unsigned_To_Hexadecimal_String;

   ------------------------------------
   -- Unsigned_To_Hexadecimal_String --
   ------------------------------------

   procedure Unsigned_To_Hexadecimal_String (Value : Unsigned_8;
                                             Buffer : out String)
   is
      Hex_Digit : Unsigned_8 range 16#0# .. 16#f#;
      Value_Left : Unsigned_8 := Value;
   begin
      for I in reverse Buffer'Range loop
         Hex_Digit := Value_Left and 16#f#;
         if Hex_Digit < 16#a# then
            Buffer (I) := Character'Val (Hex_Digit + Character'Pos ('0'));
         else
            Buffer (I) := Character'Val ((Hex_Digit - 16#a#) +
                                           Character'Pos ('A'));
         end if;

         Value_Left := Shift_Right (Value_Left, 4);
      end loop;

      pragma Assert (Value_Left = 0);

   end Unsigned_To_Hexadecimal_String;

end Number_Conversion_Utils;
