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
--  @summary HiRTOS Memory protection internal support
--

private with HiRTOS_Cpu_Arch_Interface.Memory_Protection;
with System.Storage_Elements;

private package HiRTOS.Memory_Protection_Private
   with SPARK_Mode => On
is

   type Thread_Memory_Regions_Type is limited private;

   procedure Initialize;

   --
   --  Initializes the thread-private memory protection region descriptors
   --
   procedure Initialize_Thread_Memory_Regions (Stack_Base_Addr : System.Address;
                                               Stack_Size_In_Bytes : System.Storage_Elements.Integer_Address;
                                               Thread_Regions : out Thread_Memory_Regions_Type);

   --
   --  Restore thread-private memory protection regions
   --
   procedure Restore_Thread_Memory_Regions (Thread_Regions : Thread_Memory_Regions_Type);

   --
   --  Save thread-private memory protection regions
   --
   procedure Save_Thread_Memory_Regions (Thread_Regions : out Thread_Memory_Regions_Type);

private
   use HiRTOS_Cpu_Arch_Interface.Memory_Protection;

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

end HiRTOS.Memory_Protection_Private;
