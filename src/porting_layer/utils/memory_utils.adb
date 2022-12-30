--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS_Platform_Parameters;

package body Memory_Utils is

   procedure Clear_Address_Range (Start_Address : System.Address; End_Address : System.Address) is
      --  Size in 32-bit words of the address range
      Num_Words : constant Integer_Address :=
         (To_Integer (End_Address) - To_Integer (Start_Address)) /
         (Unsigned_32'Size / System.Storage_Unit);

      Word_Array : Words_Array_Type (1 .. Num_Words) with
        Address => Start_Address;
   begin
      if Num_Words /= 0 then
         Word_Array := [others => 0];
      end if;
   end Clear_Address_Range;

   -----------------------
   -- Clear_BSS_Section --
   -----------------------

   procedure Clear_BSS_Section is
   begin
      Clear_Address_Range (HiRTOS_Platform_Parameters.BSS_Section_Start_Address,
                           HiRTOS_Platform_Parameters.BSS_Section_End_Address);
   end Clear_BSS_Section;

   ----------------------------------
   -- Clear_Privileged_BSS_Section --
   ----------------------------------

   procedure Clear_Privileged_BSS_Section is
   begin
      Clear_Address_Range (HiRTOS_Platform_Parameters.Privileged_BSS_Section_Start_Address,
                           HiRTOS_Platform_Parameters.Privileged_BSS_Section_End_Address);
   end Clear_Privileged_BSS_Section;

   -----------------------
   -- Copy_Data_Section --
   -----------------------

   procedure Copy_Data_Section is
      Num_Data_Words : constant Integer_Address :=
         (To_Integer (HiRTOS_Platform_Parameters.Data_Section_End_Address) -
          To_Integer (HiRTOS_Platform_Parameters.Data_Section_Start_Address)) /
         (Interfaces.Unsigned_32'Size / System.Storage_Unit);

      Data_Section : Words_Array_Type (1 .. Num_Data_Words) with
         Address => HiRTOS_Platform_Parameters.Data_Section_Start_Address;
      Data_Section_Initializers : Words_Array_Type (1 .. Num_Data_Words) with
         Address => HiRTOS_Platform_Parameters.Data_Load_Section_Start_Address;
   begin
      if Num_Data_Words /= 0 then
         Data_Section := Data_Section_Initializers;
      end if;
   end Copy_Data_Section;

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
