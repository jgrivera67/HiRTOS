--
--  Copyright (c) 2022-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS_Cpu_Arch_Interface.System_Registers;
with HiRTOS_Platform_Parameters;
with Memory_Utils;
with System.Machine_Code;
with System.Storage_Elements;

package body HiRTOS_Cpu_Startup_Interface is
   use HiRTOS_Cpu_Arch_Interface.System_Registers;
   use HiRTOS_Cpu_Multi_Core_Interface;
   use System.Storage_Elements;
   use ASCII;

   ----------------
   -- Enable_FPU --
   ----------------

   procedure Enable_FPU is
      CPACR_Value : CPACR_Type;
      FPEXC_EN_Bit_Mask : constant Interfaces.Unsigned_32 := Interfaces.Shift_Left (1, 30);
   begin
      --
      --  Enable full access to FPU
      --
      CPACR_Value := Get_CPACR;
      CPACR_Value.cp10 := Advanced_SIMD_And_Floating_Point_Enabled_For_EL0_EL1;
      CPACR_Value.cp11 := Advanced_SIMD_And_Floating_Point_Enabled_For_EL0_EL1;
      Set_CPACR (CPACR_Value);

      System.Machine_Code.Asm (
         --
         --  Enable VFP instructions:
         --
         "isb" & LF &
         "vmrs r0, fpexc" & LF &
         "orr  r0, r0, %0" & LF &
         "vmsr fpexc, r0" & LF &

         --
         --  Initializes floating-point registers:
         --
         "mov  r0, #0" & LF &
         "vmov d0,  r0, r0" & LF &
         "vmov d1,  r0, r0" & LF &
         "vmov d2,  r0, r0" & LF &
         "vmov d3,  r0, r0" & LF &
         "vmov d4,  r0, r0" & LF &
         "vmov d5,  r0, r0" & LF &
         "vmov d6,  r0, r0" & LF &
         "vmov d7,  r0, r0" & LF &
         "vmov d8,  r0, r0" & LF &
         "vmov d9,  r0, r0" & LF &
         "vmov d10, r0, r0" & LF &
         "vmov d11, r0, r0" & LF &
         "vmov d12, r0, r0" & LF &
         "vmov d13, r0, r0" & LF &
         "vmov d14, r0, r0" & LF &
         "vmov d15, r0, r0" & LF &
         "vmsr fpscr, r0",
         Inputs => Interfaces.Unsigned_32'Asm_Input ("g", FPEXC_EN_Bit_Mask), --  %0
         Clobber => "r0",
         Volatile => True);
   end Enable_FPU;

   -----------------------
   -- Ada_Reset_Handler --
   -----------------------

   procedure Ada_Reset_Handler is

      procedure Gnat_Generated_Main with Import,
                                      Convention => C,
                                      External_Name => "main";

      Global_Data_Region_Size_In_Bytes : constant Integer_Address :=
         To_Integer (HiRTOS_Platform_Parameters.Global_Data_Region_End_Address) -
         To_Integer (HiRTOS_Platform_Parameters.Global_Data_Region_Start_Address);
   begin
      --??? HiRTOS_Cpu_Arch_Interface.Enable_Caches;
      Enable_FPU;

      if Get_Cpu_Id = Valid_Cpu_Core_Id_Type'First then
         --
         --  In case C code is invoked from Ada, C global variables
         --  need to be initialized in RAM:
         --
         Memory_Utils.Copy_Data_Section;
         Memory_Utils.Clear_BSS_Section;
         Memory_Utils.Clear_Privileged_BSS_Section;
         Memory_Utils.Flush_Data_Cache_Range (
            HiRTOS_Platform_Parameters.Global_Data_Region_Start_Address,
            Global_Data_Region_Size_In_Bytes);
      end if;

      --
      --  Call main() generated by gnat binder, which will do the elaboration
      --  of Ada library-level packages and then invoke the main Ada subprogram
      --
      --  NOTE: Before calling 'Gnat_Generated_Main' only
      --  "No_Elaboration_Code_All" packages can be invoked.
      --
      Gnat_Generated_Main;

      --
      --  We should not return here
      --
      loop
         HiRTOS_Cpu_Arch_Interface.Wait_For_Interrupt;
      end loop;
   end Ada_Reset_Handler;

end HiRTOS_Cpu_Startup_Interface;
