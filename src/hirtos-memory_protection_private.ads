--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
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
