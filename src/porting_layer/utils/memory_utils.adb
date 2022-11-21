--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

package body Memory_Utils is
   --
   --  Constants
   --

   Flash_Used_End_Marker : constant Unsigned_32;
   pragma Import (Asm, Flash_Used_End_Marker, "__rom_end");
   --  Address of the end of the used area of Flash

   Sram_Start_Marker : constant Unsigned_32;
   pragma Import (Asm, Sram_Start_Marker, "__data_start");
   --  Start address of of SRAM

   Statically_Allocated_Sram_End_Marker : constant Unsigned_32;
   pragma Import (Asm, Statically_Allocated_Sram_End_Marker, "_end");
   --  End address of the statically allocated portion of SRAM

   -----------------------
   -- Clear_BSS_Section --
   -----------------------

   procedure Clear_BSS_Section is
      --  Start address of the .bss section in SRAM
      BSS_Start : Unsigned_32;
      pragma Import (Asm, BSS_Start, "__bss_start");

      --  Size in 32-bit words of the .bss section
      BSS_Words : constant Unsigned_32;
      pragma Import (Asm, BSS_Words, "__bss_words");

      Num_BSS_Words : constant Integer_Address :=
        To_Integer (BSS_Words'Address);
      BSS_Section : Words_Array_Type (1 .. Num_BSS_Words) with
        Address => BSS_Start'Address;
   begin
      BSS_Section := [others => 0];
   end Clear_BSS_Section;

   -----------------------
   -- Copy_Data_Section --
   -----------------------

   procedure Copy_Data_Section is
      --  Start address of the .data section in SRAM
      Data_Start : Unsigned_32;
      pragma Import (Asm, Data_Start, "__data_start");

      --  Size in 32-bit words of the .data section
      Data_Words : constant Unsigned_32;
      pragma Import (Asm, Data_Words, "__data_words");

      --  Start address of the .data section in flash
      Data_Load : constant Unsigned_32;
      pragma Import (Asm, Data_Load, "__data_load");

      Num_Data_Words : constant Integer_Address :=
        To_Integer (Data_Words'Address);
      Data_Section : Words_Array_Type (1 .. Num_Data_Words) with
         Address => Data_Start'Address;
      Data_Section_Initializers : Words_Array_Type (1 .. Num_Data_Words) with
         Address => Data_Load'Address;
   begin
      Data_Section := Data_Section_Initializers;
   end Copy_Data_Section;

   --------------------
   -- Get_Flash_Used --
   --------------------

   function Get_Flash_Used return Unsigned_32 is
      (Unsigned_32 (To_Integer (Flash_Used_End_Marker'Address)));

   -------------------
   -- Get_Sram_Used --
   -------------------

   function Get_Sram_Used return Unsigned_32 is
     (Unsigned_32 (To_Integer (Statically_Allocated_Sram_End_Marker'Address) -
                   To_Integer (Sram_Start_Marker'Address)));

   ----------------------
   -- Compute_Checksum --
   ----------------------

   function Compute_Checksum (Bytes_Array : Bytes_Array_Type)
      return Unsigned_32
   is
      CRC_32_Polynomial : constant := 16#04c11db7#;
      CRC : Unsigned_32 := Unsigned_32'Last;
      Data_Byte : Unsigned_8;
   begin
      for B of Bytes_Array loop
         Data_Byte := B;
         for I in 1 .. 8 loop
            if ((Unsigned_32 (Data_Byte) xor CRC) and 1) /= 0 then
               CRC := Shift_Right (CRC, 1);
               Data_Byte := Shift_Right (Data_Byte, 1);
               CRC := CRC xor CRC_32_Polynomial;
            else
               CRC := Shift_Right (CRC, 1);
               Data_Byte := Shift_Right (Data_Byte, 1);
            end if;
         end loop;
      end loop;

      return CRC;
   end Compute_Checksum;
end Memory_Utils;
