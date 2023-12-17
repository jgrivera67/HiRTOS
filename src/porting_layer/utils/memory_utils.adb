--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS_Platform_Parameters;
with HiRTOS_Cpu_Arch_Interface.System_Registers;

package body Memory_Utils is

   use type System.Storage_Elements.Integer_Address;

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
         --???Flush_Data_Cache_Range (Word_Array'Address, Word_Array'Size / System.Storage_Unit);
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
         --???Flush_Data_Cache_Range (Data_Section'Address, Data_Section'Size / System.Storage_Unit);
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

   procedure Invalidate_Data_Cache is
   begin
      HiRTOS_Cpu_Arch_Interface.Strong_Memory_Barrier;
      HiRTOS_Cpu_Arch_Interface.System_Registers.Set_DCIM_ALL;
      HiRTOS_Cpu_Arch_Interface.Strong_Memory_Barrier;
   end Invalidate_Data_Cache;

   procedure Invalidate_Data_Cache_Range (Start_Address : System.Address; Size : Integer_Address) is
      Num_Cache_Lines : constant Integer_Address := Size / HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes;
      Cache_Line_Address : System.Address := Start_Address;
   begin
      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
      for Cache_Line_Count in 1 .. Num_Cache_Lines loop
         HiRTOS_Cpu_Arch_Interface.System_Registers.Set_DCIMVAC (Cache_Line_Address);
         Cache_Line_Address := To_Address (To_Integer (@) +
                                           HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes);
      end loop;

      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
   end Invalidate_Data_Cache_Range;

   procedure Flush_Data_Cache_Range (Start_Address : System.Address; Size : Integer_Address) is
      Num_Cache_Lines : constant Integer_Address := Size / HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes;
      Cache_Line_Address : System.Address := Start_Address;
   begin
      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
      for Cache_Line_Count in 1 .. Num_Cache_Lines loop
         HiRTOS_Cpu_Arch_Interface.System_Registers.Set_DCCMVAC (Cache_Line_Address);
         Cache_Line_Address := To_Address (To_Integer (@) +
                                           HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes);
      end loop;

      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
   end Flush_Data_Cache_Range;

   procedure Flush_Invalidate_Data_Cache_Range (Start_Address : System.Address; Size : Integer_Address) is
      Num_Cache_Lines : constant Integer_Address := Size / HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes;
      Cache_Line_Address : System.Address := Start_Address;
   begin
      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
      for Cache_Line_Count in 1 .. Num_Cache_Lines loop
         HiRTOS_Cpu_Arch_Interface.System_Registers.Set_DCCIMVAC (Cache_Line_Address);
         Cache_Line_Address := To_Address (To_Integer (@) +
                                           HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes);
      end loop;

      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
   end Flush_Invalidate_Data_Cache_Range;

   procedure Invalidate_Instruction_Cache is
   begin
      HiRTOS_Cpu_Arch_Interface.Strong_Memory_Barrier;
      HiRTOS_Cpu_Arch_Interface.System_Registers.Set_ICIALLU;
      HiRTOS_Cpu_Arch_Interface.Strong_Memory_Barrier;
   end Invalidate_Instruction_Cache;
end Memory_Utils;
