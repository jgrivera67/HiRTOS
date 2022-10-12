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
   --
   --  MPU regions assignment
   --
   --  NOTE: Higher region id means higher region precedence in case of overlapping regions
   --
   type MPU_Region_Id_Type is (Global_Data_Region,
                               Global_Interrupt_Stack_Region,
                               Thread_Stack_Data_Region,
                               Thread_Private_Data_Region,
                               Thread_Private_MMIO_Region,
                               Global_Code_Region,
                               Thread_Private_Code_Region);

   for MPU_Region_Id_Type use (Global_Data_Region => 0,
                               Global_Interrupt_Stack_Region => 1,
                               Thread_Stack_Data_Region => 2,
                               Thread_Private_Data_Region => 3,
                               Thread_Private_MMIO_Region => 4,
                               Global_Code_Region => 5,
                               Thread_Private_Code_Region => 6);

   procedure Initialize is
   begin
      pragma Assert (False); -- ????
   end Initialize;

   procedure Set_Memory_Region (
      Region : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bits : Region_Size_In_Bits_Type;
      Permissions : Region_Permissions_Type) is
   begin
      pragma Assert (False); --  ???
   end Set_Memory_Region;

   procedure Restore_Memory_Region (
      Saved_Region : Memory_Region_Descriptor_Type) is
   begin
      pragma Assert (False); --  ???
   end Restore_Memory_Region;

   procedure Initialize_Thread_Memory_Regions (Stack_Base_Addr : System.Address;
                                                 Stack_Size : Interfaces.Unsigned_16;
                                                 Thread_Regions : out Thread_Memory_Regions_Type)
   is
   begin
      pragma Assert (False); -- ????
   end Initialize_Thread_Memory_Regions;

   procedure Restore_Thread_Memory_Regions (Thread_Regions : Thread_Memory_Regions_Type) is
   begin
      pragma Assert (False); -- ????
   end Restore_Thread_Memory_Regions;

   procedure Save_Thread_Memory_Regions (Thread_Regions : out Thread_Memory_Regions_Type) is
   begin
      pragma Assert (False); -- ????
   end Save_Thread_Memory_Regions;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection;
