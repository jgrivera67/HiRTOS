--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS Memory protection internal support
--

with HiRTOS_Cpu_Arch_Interface;
with HiRTOS_Cpu_Arch_Interface.Memory_Protection;
with HiRTOS_Platform_Parameters;
with System.Storage_Elements;

private package HiRTOS.Memory_Protection_Private
   with SPARK_Mode => On
is
   use System.Storage_Elements;

   subtype Memory_Region_Role_Type is
      HiRTOS_Cpu_Arch_Interface.Memory_Protection.Memory_Region_Role_Type;

   type Thread_Memory_Regions_Type is limited private;

   procedure Initialize
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode,
           Post => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode;

   --
   --  Initializes the thread-private memory protection region descriptors
   --
   procedure Initialize_Thread_Memory_Regions (Stack_Base_Addr : System.Address;
                                               Stack_End_Addr : System.Address;
                                               Thread_Regions : out Thread_Memory_Regions_Type);

   --
   --  Restore thread-private memory protection regions
   --
   procedure Restore_Thread_Memory_Regions (Thread_Regions : Thread_Memory_Regions_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode and then
                  HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled;

   --
   --  Save thread-private memory protection regions
   --
   procedure Save_Thread_Memory_Regions (Thread_Regions : out Thread_Memory_Regions_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode;

   Global_Data_Region_Size_In_Bytes : constant Integer_Address;

private
   pragma SPARK_Mode (Off);
   use HiRTOS_Cpu_Arch_Interface.Memory_Protection;

   Global_Data_Region_Size_In_Bytes : constant Integer_Address :=
      To_Integer (HiRTOS_Platform_Parameters.Global_Data_Region_End_Address) -
      To_Integer (HiRTOS_Platform_Parameters.Global_Data_Region_Start_Address);

   --
   --  Thread-private memory protection regions
   --
   --  @field Stack_Region memory region for the thread's stack
   --  @field Private_Data_Region current memory region for the writable global data
   --  for the thread, when global data region is read-only by default. This region is
   --  also used by the thread to access hidden data.
   --  @field Mmio_Region current memory region for the accessible MMIO range
   --  for the thread, when global mmio region is no-access or read-only by default.
   --  @field Overlapped_Global_Mmio_Region saved global mmio region descriptor (in case
   --  the global mmio region is overlapped by the private mmio region).
   --  @field Code_Region memory region to access hidden code from the thread.
   --
   type Thread_Memory_Regions_Type is limited record
      Stack_Region : Memory_Region_Descriptor_Type;
      Private_Data_Region : Memory_Region_Descriptor_Type;
      Private_Mmio_Region : Memory_Region_Descriptor_Type;
   end record;

   Global_Text_Region_Size_In_Bytes : constant Integer_Address :=
      To_Integer (HiRTOS_Platform_Parameters.Global_Text_Region_End_Address) -
      To_Integer (HiRTOS_Platform_Parameters.Global_Text_Region_Start_Address);

   Rodata_Section_Size_In_Bytes : constant Integer_Address :=
      To_Integer (HiRTOS_Platform_Parameters.Rodata_Section_End_Address) -
      To_Integer (HiRTOS_Platform_Parameters.Rodata_Section_Start_Address);

   Global_Mmio_Region_Size_In_Bytes : constant Integer_Address :=
      To_Integer (HiRTOS_Platform_Parameters.Global_Mmio_Region_End_Address) -
      To_Integer (HiRTOS_Platform_Parameters.Global_Mmio_Region_Start_Address);

end HiRTOS.Memory_Protection_Private;
