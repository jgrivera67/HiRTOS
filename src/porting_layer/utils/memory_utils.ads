--
--  Copyright (c) 2016, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
--
with Interfaces.C;
with System.Storage_Elements;

package Memory_Utils with
   No_Elaboration_Code_All
is
   use Interfaces;
   use System.Storage_Elements;

   type Words_Array_Type is array (Integer_Address range <>) of Unsigned_32;

   function Get_Flash_Used return Unsigned_32;

   function Get_Sram_Used return Unsigned_32;

   function How_Many (M : Unsigned_32; N : Unsigned_32) return Unsigned_32
   is (((M - 1) / N) + 1);

   function Round_Up (M : Unsigned_32; N : Unsigned_32) return Unsigned_32
   is (How_Many (M, N) * N);

   type Bytes_Array_Type is array (Positive range <>) of aliased Unsigned_8;

   function Compute_Checksum (Bytes_Array : Bytes_Array_Type)
      return Unsigned_32;
   --
   --  Computes the CRC-32 checksum for a given block of memory
   --
   --  @param start_addr: start address of the memory block
   --  @param size: size in bytes
   --
   --  @return calculated CRC value
   --

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

   procedure Clear_BSS_Section;
   --
   --  Clear BSS section in SRAM
   --  (C global and static non-initialized variables)
   --

   procedure Copy_Data_Section;
   --
   --  Copy data section from flash to SRAM
   --  (C global and static initialized variables)
   --
end Memory_Utils;
