--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS Memory protection internal support
--

package body HiRTOS.Memory_Protection_Private with SPARK_Mode => On is

   procedure Initialize is
   begin
      pragma Assert (False); -- ????
      --- REturn in unprivileged mode
   end Initialize;

   procedure Initialize_Thread_Memory_Regions (Stack_Base_Addr : System.Address;
                                               Stack_Size_In_Bytes : System.Storage_Elements.Integer_Address;
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

end HiRTOS.Memory_Protection_Private;
