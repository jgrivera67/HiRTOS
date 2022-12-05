--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS Memory protection services
--

with HiRTOS_Cpu_Arch_Interface.Memory_Protection;
with HiRTOS_Cpu_Arch_Parameters;
private with HiRTOS.Memory_Protection_Private;
with System.Storage_Elements;

package HiRTOS.Memory_Protection
   with SPARK_Mode => On
is
   use type System.Address;

   Memory_Range_Alignment : constant := HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment;

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

   procedure Begin_Mmio_Range_Write_Access (
      Start_Address : System.Address;
      Size_In_Bits : Memory_Range_Size_In_Bits_Type;
      Old_Mmio_Range : out Memory_Range_Type)
      with Pre => Start_Address /= System.Null_Address and then
                  Size_In_Bits > 0 and then
                  Size_In_Bits mod System.Storage_Unit = 0;

   procedure End_Mmio_Range_Access (
      Old_Mmio_Range : Memory_Range_Type);

private

   type Memory_Range_Type is limited record
      Region_Descriptor :
         HiRTOS_Cpu_Arch_Interface.Memory_Protection.Memory_Region_Descriptor_Type;
      Region_Role : HiRTOS.Memory_Protection_Private.Memory_Region_Role_Type;
   end record
     with Convention => C;

end HiRTOS.Memory_Protection;
