--
--  Copyright (c) 2022, German Rivera
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

--
--  @summary RTOS to target platform interface - Memory protection services
--  for ARMv8-R MPU
--

package body HiRTOS_Cpu_Arch_Interface.Memory_Protection with SPARK_Mode => On is

   procedure Enable_Memory_Protection is
   begin
      pragma Assert (False); -- ????
   end Enable_Memory_Protection;

   procedure Disable_Memory_Protection is
   begin
      pragma Assert (False); -- ????
   end Disable_Memory_Protection;

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Permissions : Region_Permissions_Type) is
   begin
      pragma Assert (False); --  ???
   end Initialize_Memory_Region_Descriptor;

   procedure Restore_Memory_Region_Descriptor (
      Region_Descriptor_Id : Memory_Region_Descriptor_Id_Type;
      Region_Descriptor : Memory_Region_Descriptor_Type) is
   begin
      pragma Assert (False); --  ???
   end Restore_Memory_Region_Descriptor;

   procedure Save_Memory_Region_Descriptor (
      Region_Descriptor_Id : Memory_Region_Descriptor_Id_Type;
      Region_Descriptor : out Memory_Region_Descriptor_Type) is
   begin
      pragma Assert (False); --  ???
   end Save_Memory_Region_Descriptor;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection;
