--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS Memory protection services
--

with HiRTOS.Memory_Protection_Private;

package body HiRTOS.Memory_Protection with
  SPARK_Mode => On
is

   procedure Begin_Data_Range_Write_Access (
      Start_Address : System.Address;
      Size_In_Bits : Memory_Range_Size_In_Bits_Type;
      Old_Data_Range : out Memory_Range_Type) is
   begin
      pragma Assert (False); --  ???
   end Begin_Data_Range_Write_Access;

   procedure End_Data_Range_Access (
      Old_Data_Range : Memory_Range_Type) is
   begin
      pragma Assert (False); --  ???
   end End_Data_Range_Access;

   procedure Begin_Mmio_Range_Write_Access (
      Start_Address : System.Address;
      Size_In_Bits : Memory_Range_Size_In_Bits_Type;
      Old_Mmio_Range : out Memory_Range_Type) is
   begin
      pragma Assert (False); --  ???
   end Begin_Mmio_Range_Write_Access;

   procedure End_Mmio_Range_Access (
      Old_Mmio_Range : Memory_Range_Type) is
   begin
      pragma Assert (False); --  ???
   end End_Mmio_Range_Access;

end HiRTOS.Memory_Protection;
