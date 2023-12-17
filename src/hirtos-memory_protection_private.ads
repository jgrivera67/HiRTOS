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

   --
   --  Mapping of logical memory protection regions to memory protection descriptor
   --  indices
   --
   type Memory_Region_Role_Type is
     (Global_Interrupt_Stack_Region,
      Global_Interrupt_Stack_Overflow_Guard,
      Null_Pointer_Dereference_Guard,
      Global_Code_Region,
      Global_Privileged_Code_Region,
      Global_Rodata_Region,
      Global_Data_Region,
      Global_Mmio_Region,
      Thread_Stack_Data_Region,
      Thread_Stack_Overflow_Guard,
      Thread_Private_Data_Region,
      Thread_Private_Mmio_Region,
      Thread_Private_Code_Region,

      --  Valid region roles must be added before this entry:
      Invalid_Region_Role);

   for Memory_Region_Role_Type use
     (Global_Interrupt_Stack_Region => 0,
      Global_Interrupt_Stack_Overflow_Guard => 1,
      Null_Pointer_Dereference_Guard => 2,
      Global_Code_Region => 3,
      Global_Privileged_Code_Region => 4,
      Global_Rodata_Region => 5,
      Global_Data_Region => 6,
      Global_Mmio_Region => 7,
      Thread_Stack_Data_Region => 8,
      Thread_Stack_Overflow_Guard => 9,
      Thread_Private_Data_Region => 10,
      Thread_Private_Mmio_Region => 11,
      Thread_Private_Code_Region => 12,

      --  Valid region roles must be added before this entry:
      Invalid_Region_Role => HiRTOS_Cpu_Arch_Interface.Memory_Protection.Max_Num_Memory_Regions);

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

   Global_Data_Region_Size_In_Bytes : constant Integer_Address :=
      To_Integer (HiRTOS_Platform_Parameters.Global_Data_Region_End_Address) -
      To_Integer (HiRTOS_Platform_Parameters.Global_Data_Region_Start_Address);

private
   use HiRTOS_Cpu_Arch_Interface.Memory_Protection;

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
      Private_Code_Region : Memory_Region_Descriptor_Type;
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
