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

with System.Storage_Elements;

package HiRTOS_Cpu_Arch_Interface.Memory_Protection
   with SPARK_Mode => On
is
   use type System.Address;
   use type System.Storage_Elements.Integer_Address;

   Num_Region_Descriptors : constant := 16;

   type Memory_Region_Descriptor_Id_Type is mod Num_Region_Descriptors;

   type Memory_Region_Descriptor_Type is private;

   type Region_Permissions_Type is (None,
                                    Read_Only,
                                    Read_Write,
                                    Read_Execute);

   --
   --  Enables memory protection hardware
   --
   procedure Enable_Memory_Protection;

   --
   --  Disables memory protection hardware
   --
   procedure Disable_Memory_Protection;

   --
   --  Initializes state of a memory protection descriptor object
   --
   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Permissions : Region_Permissions_Type)
      with Pre => Start_Address /= System.Null_Address and then
                  Size_In_Bytes > 0 and then
                  Permissions /= None;

   --
   --  Copies saved state of a memory protection descriptor to the
   --  corresponding memory descriptor in the MPU
   --
   procedure Restore_Memory_Region_Descriptor (
      Region_Descriptor_Id : Memory_Region_Descriptor_Id_Type;
      Region_Descriptor : Memory_Region_Descriptor_Type);

   --
   --  Saves state of a memory protection descriptor from the MPU
   --
   procedure Save_Memory_Region_Descriptor (
      Region_Descriptor_Id : Memory_Region_Descriptor_Id_Type;
      Region_Descriptor : out Memory_Region_Descriptor_Type);

private

   --  Saved ARM Cortex-R memory protection region descriptor
   type Memory_Region_Descriptor_Type is record
      --  Region base address register
      Rbar_Value : Interfaces.Unsigned_32;
      --  Region size register
      Rsr_Value : Interfaces.Unsigned_32;
      --  Region access control register
      Racr_Value : Interfaces.Unsigned_32;
      --  Type of floating memory protection region.
      Region_Type : Interfaces.Unsigned_8;
      --  Reserved fields to make trailing hole explicit
      Reserved1 : Interfaces.Unsigned_8;
      Reserved2 : Interfaces.Unsigned_16;
   end record
     with Convention => C;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection;
