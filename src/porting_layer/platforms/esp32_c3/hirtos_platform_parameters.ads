--
--  Copyright (c) 2022-2024, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS target platform parameters
--

with Interfaces;
with System;

package HiRTOS_Platform_Parameters
   with SPARK_Mode => On, No_Elaboration_Code_All
is
   --
   --  Number of CPU cores
   --
   Num_Cpu_Cores : constant := 1;

   System_Clock_Frequency_Hz : constant := 100_000_000;

   GICD_Base_Address : constant System.Address :=
     System'To_Address (16#8000_0000# + 16#2F00_0000#);

   --
   --  Linker-script symbols defined in
   --  porting_layer/platforms/*/memory_layout.ld
   --

   Global_Text_Region_Start_Linker_Symbol : constant Interfaces.Unsigned_32
      with Import,
           Convention => Asm,
           External_Name => "__global_text_region_start";

   Global_Text_Region_Start_Address : constant System.Address :=
      Global_Text_Region_Start_Linker_Symbol'Address;

   Global_Text_Region_End_Linker_Symbol : constant Interfaces.Unsigned_32
      with Import,
           Convention => Asm,
           External_Name => "__global_text_region_end";

   Global_Text_Region_End_Address : constant System.Address :=
      Global_Text_Region_End_Linker_Symbol'Address;

   Rodata_Section_Start_Linker_Symbol : constant Interfaces.Unsigned_32
      with Import,
           Convention => Asm,
           External_Name => "__rodata_start";

   Rodata_Section_Start_Address : constant System.Address :=
      Rodata_Section_Start_Linker_Symbol'Address;

   Rodata_Section_End_Linker_Symbol : constant Interfaces.Unsigned_32
      with Import,
           Convention => Asm,
           External_Name => "__rodata_end";

   Rodata_Section_End_Address : constant System.Address :=
      Rodata_Section_End_Linker_Symbol'Address;

   Global_Data_Region_Start_Linker_Symbol : Interfaces.Unsigned_32
      with Import,
           Convention => Asm,
           External_Name => "__global_data_region_start";

   Global_Data_Region_Start_Address : constant System.Address :=
      Global_Data_Region_Start_Linker_Symbol'Address;

   Global_Data_Region_End_Linker_Symbol : Interfaces.Unsigned_32
      with Import,
           Convention => Asm,
           External_Name => "__global_data_region_end";

   Global_Data_Region_End_Address : constant System.Address :=
      Global_Data_Region_End_Linker_Symbol'Address;

   Data_Section_Start_Linker_Symbol : Interfaces.Unsigned_32
      with Import,
           Convention => Asm,
           External_Name => "__data_start";

   Data_Section_Start_Address : constant System.Address :=
      Data_Section_Start_Linker_Symbol'Address;

   Data_Section_End_Linker_Symbol : Interfaces.Unsigned_32
      with Import,
           Convention => Asm,
           External_Name => "__data_end";

   Data_Section_End_Address : constant System.Address :=
      Data_Section_End_Linker_Symbol'Address;

   Data_Load_Section_Start_Linker_Symbol : Interfaces.Unsigned_32
      with Import,
           Convention => Asm,
           External_Name => "__data_load";

   Data_Load_Section_Start_Address : constant System.Address :=
      Data_Load_Section_Start_Linker_Symbol'Address;

   BSS_Section_Start_Linker_Symbol : Interfaces.Unsigned_32
      with Import,
           Convention => Asm,
           External_Name => "__bss_start";

   BSS_Section_Start_Address : constant System.Address :=
      BSS_Section_Start_Linker_Symbol'Address;

   BSS_Section_End_Linker_Symbol : Interfaces.Unsigned_32
      with Import,
           Convention => Asm,
           External_Name => "__bss_end";

   BSS_Section_End_Address : constant System.Address :=
      BSS_Section_End_Linker_Symbol'Address;

   Privileged_BSS_Section_Start_Linker_Symbol : Interfaces.Unsigned_32
      with Import,
           Convention => Asm,
           External_Name => "__privileged_bss_start";

   Privileged_BSS_Section_Start_Address : constant System.Address :=
      Privileged_BSS_Section_Start_Linker_Symbol'Address;

   Privileged_BSS_Section_End_Linker_Symbol : Interfaces.Unsigned_32
      with Import,
           Convention => Asm,
           External_Name => "__privileged_bss_end";

   Privileged_BSS_Section_End_Address : constant System.Address :=
      Privileged_BSS_Section_End_Linker_Symbol'Address;

   Stacks_Section_Start_Linker_Symbol : Interfaces.Unsigned_32
      with Import,
           Convention => Asm,
           External_Name => "_stacks_start";

   Stacks_Section_Start_Address : constant System.Address :=
      Stacks_Section_Start_Linker_Symbol'Address;

   Stacks_Section_End_Linker_Symbol : Interfaces.Unsigned_32
      with Import,
           Convention => Asm,
           External_Name => "_stacks_end";

   Stacks_Section_End_Address : constant System.Address :=
      Stacks_Section_End_Linker_Symbol'Address;

   --
   --  Global MMIO range for the target platform
   --

   Global_Mmio_Region_Start_Address : constant System.Address :=
      System'To_Address (16#8000_0000# + 16#1C01_0000#);

   Global_Mmio_Region_End_Address : constant System.Address :=
      System'To_Address (16#8000_0000# + 16#3000_0000#);

end HiRTOS_Platform_Parameters;
