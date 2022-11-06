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
--  @summary HiRTOS Memory protection services
--

with HiRTOS_Cpu_Arch_Interface.Memory_Protection;
with System.Storage_Elements;

package HiRTOS.Memory_Protection
   with SPARK_Mode => On
is
   use type System.Address;

   type Memory_Range_Type is limited private;

   type Memory_Range_Size_In_Bits_Type is new System.Storage_Elements.Integer_Address;

   procedure Begin_Data_Range_Write_Access (
      Start_Address : System.Address;
      Size_In_Bits : Memory_Range_Size_In_Bits_Type;
      Old_Data_Range : out Memory_Range_Type)
      with Pre => Start_Address /= System.Null_Address and then
                  Size_In_Bits > 0 and then
                  Size_In_Bits mod System.Storage_Unit = 0;

   procedure End_Data_Range_Access (
      Old_Data_Range : Memory_Range_Type);

private

   --
   --  Mapping of logical memory protection regions to memory protection descriptor
   --  indices
   --
   --  NOTE: Higher region index means higher region precedence in case of overlapping regions
   --
   type Memory_Region_Role_Type is
     (Global_Data_Region, Global_Interrupt_Stack_Region,
      Thread_Stack_Data_Region, Thread_Private_Data_Region,
      Thread_Private_MMIO_Region, Global_Code_Region,
      Thread_Private_Code_Region);

   for Memory_Region_Role_Type use
     (Global_Data_Region         => 0, Global_Interrupt_Stack_Region => 1,
      Thread_Stack_Data_Region   => 2, Thread_Private_Data_Region => 3,
      Thread_Private_MMIO_Region => 4, Global_Code_Region => 5,
      Thread_Private_Code_Region => 6);

   type Memory_Range_Type is limited record
      Region_Descriptor :
         HiRTOS_Cpu_Arch_Interface.Memory_Protection.Memory_Region_Descriptor_Type;
      Region_Role : Memory_Region_Role_Type;
   end record
     with Convention => C;

end HiRTOS.Memory_Protection;
