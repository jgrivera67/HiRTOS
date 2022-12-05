--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS Memory protection internal support
--

with HiRTOS_Cpu_Arch_Interface;
with HiRTOS_Cpu_Arch_Interface.Memory_Protection;
private with HiRTOS_Platform_Parameters;
with System.Storage_Elements;

private package HiRTOS.Memory_Protection_Private
   with SPARK_Mode => On
is
   --
   --  Mapping of logical memory protection regions to memory protection descriptor
   --  indices
   --
   --  NOTE: Higher region index means higher region precedence in case of overlapping regions
   --
   type Memory_Region_Role_Type is
     (Global_Data_Region,
      Global_Interrupt_Stack_Region,
      Global_Mmio_Region,
      Thread_Stack_Data_Region,
      Thread_Private_Data_Region,
      Thread_Private_Mmio_Region,
      Global_Code_Region,
      Thread_Private_Code_Region,
      Global_Rodata_Region);

   for Memory_Region_Role_Type use
     (Global_Data_Region => 0,
      Global_Interrupt_Stack_Region => 1,
      Global_Mmio_Region => 2,
      Thread_Stack_Data_Region   => 3,
      Thread_Private_Data_Region => 4,
      Thread_Private_Mmio_Region => 5,
      Global_Code_Region => 6,
      Thread_Private_Code_Region => 7,
      Global_Rodata_Region => 8);

   pragma Compile_Time_Error (
      Memory_Region_Role_Type'Last'Enum_Rep >= HiRTOS_Cpu_Arch_Interface.Memory_Protection.Max_Num_Memory_Regions,
      "Maxium number of MPU regions exceeded");

   type Thread_Memory_Regions_Type is limited private;

   procedure Initialize
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode,
           Post => not HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode;

   --
   --  Initializes the thread-private memory protection region descriptors
   --
   procedure Initialize_Thread_Memory_Regions (Stack_Base_Addr : System.Address;
                                               Stack_Size_In_Bytes : System.Storage_Elements.Integer_Address;
                                               Thread_Regions : out Thread_Memory_Regions_Type);

   --
   --  Restore thread-private memory protection regions
   --
   procedure Restore_Thread_Memory_Regions (Thread_Regions : Thread_Memory_Regions_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode;

   --
   --  Save thread-private memory protection regions
   --
   procedure Save_Thread_Memory_Regions (Thread_Regions : out Thread_Memory_Regions_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode;

private
   use HiRTOS_Cpu_Arch_Interface.Memory_Protection;
   use System.Storage_Elements;

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

   Global_Text_Region_Size_In_Bytes : constant Integer_Address :=
      To_Integer (HiRTOS_Platform_Parameters.Global_Text_Region_End_Address) -
      To_Integer (HiRTOS_Platform_Parameters.Global_Text_Region_Start_Address);

   Rodata_Section_Size_In_Bytes : constant Integer_Address :=
      To_Integer (HiRTOS_Platform_Parameters.Rodata_Section_End_Address) -
      To_Integer (HiRTOS_Platform_Parameters.Rodata_Section_Start_Address);

   Global_Data_Region_Size_In_Bytes : constant Integer_Address :=
      To_Integer (HiRTOS_Platform_Parameters.Global_Data_Region_End_Address) -
      To_Integer (HiRTOS_Platform_Parameters.Global_Data_Region_Start_Address);

   Global_Mmio_Region_Size_In_Bytes : constant Integer_Address :=
      To_Integer (HiRTOS_Platform_Parameters.Global_Mmio_Range_End_Address) -
      To_Integer (HiRTOS_Platform_Parameters.Global_Mmio_Range_Start_Address);

end HiRTOS.Memory_Protection_Private;
