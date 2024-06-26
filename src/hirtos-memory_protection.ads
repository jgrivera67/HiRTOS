--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS Memory protection services
--

with HiRTOS_Cpu_Arch_Interface.Memory_Protection;
with HiRTOS_Cpu_Arch_Parameters;
private with HiRTOS_Platform_Parameters;
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

   function Valid_Code_Address (Address : System.Address) return Boolean;

   function Valid_Stack_Address (Address : System.Address) return Boolean;

   function Valid_Global_Data_Address (Address : System.Address) return Boolean;

   function Valid_Global_Mmio_Address (Address : System.Address) return Boolean;

   function Address_Range_In_Global_Data_Region (Start_Address : System.Address;
                                                 Size_In_Bytes : System.Storage_Elements.Integer_Address)
      return Boolean;

   function Address_Range_In_Global_Data_Region (Start_Address : System.Address;
                                                 End_Address : System.Address)
      return Boolean;

   function Address_Range_In_Global_Mmio_Region (Start_Address : System.Address;
                                                 Size_In_Bytes : System.Storage_Elements.Integer_Address)
      return Boolean;

   function Address_Range_In_Global_Mmio_Region (Start_Address : System.Address;
                                                 End_Address : System.Address)
      return Boolean;

private
   use HiRTOS_Cpu_Arch_Interface.Memory_Protection;
   use type System.Storage_Elements.Integer_Address;

   --
   --  Memory range permissions and atributes saved on calls to Begin_Data_Range_Write_Access
   --  or Begin_Mmio_Range_Write_Access, and restored with calls to End_Data_Range_Write_Access
   --  or End_Mmio_Range_Write_Access
   --
   type Memory_Range_Type is limited record
      Range_Region_Role : HiRTOS.Memory_Protection_Private.Memory_Region_Role_Type;
      Range_Region : Memory_Region_Descriptor_Type;
   end record
     with Convention => C;

   function Valid_Code_Address (Address : System.Address) return Boolean is
      (System.Storage_Elements.To_Integer (Address) in
       System.Storage_Elements.To_Integer (HiRTOS_Platform_Parameters.Global_Text_Region_Start_Address) ..
       System.Storage_Elements.To_Integer (HiRTOS_Platform_Parameters.Global_Text_Region_End_Address));

   function Valid_Stack_Address (Address : System.Address) return Boolean is
      (System.Storage_Elements.To_Integer (Address) in
       System.Storage_Elements.To_Integer (HiRTOS_Platform_Parameters.Stacks_Section_Start_Address) ..
       System.Storage_Elements.To_Integer (HiRTOS_Platform_Parameters.Stacks_Section_End_Address));

   function Valid_Global_Data_Address (Address : System.Address) return Boolean is
      (System.Storage_Elements.To_Integer (Address) in
       System.Storage_Elements.To_Integer (HiRTOS_Platform_Parameters.Global_Data_Region_Start_Address) ..
       System.Storage_Elements.To_Integer (HiRTOS_Platform_Parameters.Global_Data_Region_End_Address));

   function Valid_Global_Mmio_Address (Address : System.Address) return Boolean is
      (System.Storage_Elements.To_Integer (Address) in
       System.Storage_Elements.To_Integer (HiRTOS_Platform_Parameters.Global_Mmio_Region_Start_Address) ..
       System.Storage_Elements.To_Integer (HiRTOS_Platform_Parameters.Global_Mmio_Region_End_Address));

   function Address_Range_In_Global_Data_Region (Start_Address : System.Address;
                                                 Size_In_Bytes : System.Storage_Elements.Integer_Address)
      return Boolean is
      (Valid_Global_Data_Address (Start_Address) and then
       Valid_Global_Data_Address (System.Storage_Elements.To_Address (
         System.Storage_Elements.To_Integer (Start_Address) + (Size_In_Bytes - 1))));

   function Address_Range_In_Global_Data_Region (Start_Address : System.Address;
                                                 End_Address : System.Address)
      return Boolean is
      (Valid_Global_Data_Address (Start_Address) and then
       Valid_Global_Data_Address (System.Storage_Elements.To_Address (
         System.Storage_Elements.To_Integer (End_Address) - 1)));

   function Address_Range_In_Global_Mmio_Region (Start_Address : System.Address;
                                                 Size_In_Bytes : System.Storage_Elements.Integer_Address)
      return Boolean is
      (Valid_Global_Mmio_Address (Start_Address) and then
       Valid_Global_Mmio_Address (System.Storage_Elements.To_Address (
         System.Storage_Elements.To_Integer (Start_Address) + (Size_In_Bytes - 1))));

   function Address_Range_In_Global_Mmio_Region (Start_Address : System.Address;
                                                 End_Address : System.Address)
      return Boolean is
      (Valid_Global_Mmio_Address (Start_Address) and then
       Valid_Global_Mmio_Address (System.Storage_Elements.To_Address (
         System.Storage_Elements.To_Integer (End_Address) - 1)));

end HiRTOS.Memory_Protection;
