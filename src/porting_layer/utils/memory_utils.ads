--
--  Copyright (c) 2016, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Interfaces.C;
with System.Storage_Elements;

package Memory_Utils with
   No_Elaboration_Code_All
is
   use Interfaces;
   use System.Storage_Elements;

   type Words_Array_Type is array (Integer_Address range <>) of Unsigned_32;

   function How_Many (M : Unsigned_32; N : Unsigned_32) return Unsigned_32
   is (((M - 1) / N) + 1);

   function Round_Up (M : Unsigned_32; N : Unsigned_32) return Unsigned_32
   is (How_Many (M, N) * N);

   type Bytes_Array_Type is array (Positive range <>) of aliased Unsigned_8;

   --
   --  Computes the CRC-32 checksum for a given block of memory
   --
   --  @param start_addr: start address of the memory block
   --  @param size: size in bytes
   --
   --  @return calculated CRC value
   --
   function Compute_Checksum (Bytes_Array : Bytes_Array_Type)
      return Unsigned_32;

   function Address_Overlap (Block1_Start_Addr : System.Address;
                             Block1_Size : Integer_Address;
                             Block2_Start_Addr : System.Address;
                             Block2_Size : Integer_Address) return Boolean is
   --
   --  Tell if two address ranges overaap
   --
   (if To_Integer (Block1_Start_Addr) < To_Integer (Block2_Start_Addr) then
       To_Integer (Block1_Start_Addr) + Block1_Size >=
       To_Integer (Block2_Start_Addr)
    elsif To_Integer (Block1_Start_Addr) > To_Integer (Block2_Start_Addr) then
       To_Integer (Block2_Start_Addr) + Block2_Size >=
       To_Integer (Block1_Start_Addr)
    else
       True);

   function C_Memcpy (Dest_Addr, Src_Addr : System.Address;
                      Num_Bytes : Interfaces.C.size_t) return System.Address
     with Import,
          Convention => C,
          External_Name => "memcpy";

   function C_Memset (Dest_Addr : System.Address;
                      Byte_Value : Interfaces.C.int;
                      Num_Bytes : Interfaces.C.size_t) return System.Address
     with Import,
          Convention => C,
          External_Name => "memset";

   procedure Clear_Address_Range (Start_Address : System.Address; End_Address : System.Address);

   --
   --  Clear unprivileged BSS section in SRAM
   --  (C global and static non-initialized variables)
   --
   procedure Clear_BSS_Section;

   --
   --  Clear privileged BSS section in SRAM
   --  (C global and static non-initialized variables)
   --
   procedure Clear_Privileged_BSS_Section;

   procedure Copy_Data_Section;
   --
   --  Copy data section from flash to SRAM
   --  (C global and static initialized variables)
   --
end Memory_Utils;
