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

with Interfaces;

package HiRTOS_Cpu_Arch_Interface.Memory_Protection
   with SPARK_Mode => On
is
   use type System.Address;

   type Memory_Region_Descriptor_Type is private;

   type Thread_Memory_Regions_Type is limited private;

   type Region_Size_In_Bits_Type is new Interfaces.Unsigned_32;

   type Region_Permissions_Type is (None,
                                    Read_Only,
                                    Read_Write,
                                    Read_Execute);

   -------------------------------------------------------------------
   --  Subprograms to be invoked only from HiRTOS code
   -------------------------------------------------------------------

   --
   --  Initializes memory protection hardware
   --
   procedure Initialize;

   procedure Set_Memory_Region (
      Region : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bits : Region_Size_In_Bits_Type;
      Permissions : Region_Permissions_Type)
      with Pre => Start_Address /= System.Null_Address and then
                  Size_In_Bits > 0 and then
                  Size_In_Bits mod System.Storage_Unit = 0 and then
                  Permissions /= None;

   procedure Restore_Memory_Region (
      Saved_Region : Memory_Region_Descriptor_Type);

   --
   --  Initializes the thread-private memory protection region descriptors
   --
   procedure Initialize_Thread_Memory_Regions (Stack_Base_Addr : System.Address;
                                               Stack_Size : Interfaces.Unsigned_16;
                                               Thread_Regions : out Thread_Memory_Regions_Type);

   --
   --  Restore thread-private memory protection regions
   --
   procedure Restore_Thread_Memory_Regions (Thread_Regions : Thread_Memory_Regions_Type);

   --
   --  Save thread-private memory protection regions
   --
   procedure Save_Thread_Memory_Regions (Thread_Regions : out Thread_Memory_Regions_Type);

   -------------------------------------------------------------------
   --  Subprograms to be invoked from applications
   -------------------------------------------------------------------

   --  TODO: Add them here

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

   --
   --  Thread-private memory protection regions
   --
   --  @field stack_region memory region for the thread's stack
   --  @field writable_data_region current memory region for writable global data
   --  for the thread.
   --
   type Thread_Memory_Regions_Type is limited record
      Stack_Region : Memory_Region_Descriptor_Type;
      Data_Region : Memory_Region_Descriptor_Type;
      Mmio_Region : Memory_Region_Descriptor_Type;
      Code_Region : Memory_Region_Descriptor_Type;
   end record;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection;
