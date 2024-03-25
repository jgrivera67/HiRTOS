--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS_Cpu_Arch_Parameters;
with HiRTOS_Cpu_Arch_Interface;
with HiRTOS_Cpu_Arch_Interface.Thread_Context;
with HiRTOS_Cpu_Arch_Interface_Private;
with HiRTOS_Platform_Parameters;
with HiRTOS_Platform_Interface;
with Bit_Sized_Integer_Types;
with Memory_Utils;
with Watchdog_Driver;
with System.Storage_Elements;
with System.Machine_Code;

package body HiRTOS_Cpu_Startup_Interface is
   use HiRTOS_Cpu_Multi_Core_Interface;
   use HiRTOS_Cpu_Arch_Interface_Private;
   use HiRTOS_Cpu_Arch_Interface.Thread_Context;
   use System.Storage_Elements;

   ----------------
   -- Enable_FPU --
   ----------------

   procedure Enable_FPU is
   begin
      null;
   end Enable_FPU;

   procedure Set_Mtvec_Register (Interrupt_Vector_Table_Address : System.Address)
      with Pre => To_Integer (Interrupt_Vector_Table_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Call_Instruction_Size_In_Bytes = 0
   is
      Mtvec_Value : constant Integer_Address :=
         To_Integer (Interrupt_Vector_Table_Address) or 2#1#; --  Vectored mode
   begin
      System.Machine_Code.Asm (
         "csrw mtvec, %0",
         Inputs => Integer_Address'Asm_Input ("r", Mtvec_Value), --  %0
         Volatile => True);
   end Set_Mtvec_Register;

   -----------------------
   -- Ada_Reset_Handler --
   -----------------------

   procedure Ada_Reset_Handler is
      use type Bit_Sized_Integer_Types.Bit_Type;

      procedure Gnat_Generated_Main with Import,
                                      Convention => C,
                                      External_Name => "main";

      Global_Data_Region_Size_In_Bytes : constant Integer_Address :=
         To_Integer (HiRTOS_Platform_Parameters.Global_Data_Region_End_Address) -
         To_Integer (HiRTOS_Platform_Parameters.Global_Data_Region_Start_Address);

      MISA_Value : constant MISA_Type := Get_MISA;
      Thread_Pointer : constant Thread_Pointer_Type :=
         (Cpu_Running_In_Privileged_Mode => True, others => <>);
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type with Unreferenced;
   begin
      Set_Thread_Pointer (Thread_Pointer);
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      Set_Mtvec_Register (Interrupt_Vector_Jump_Table'Address);

      if MISA_Value.F = 1 then
         Enable_FPU;
      end if;

      if Get_Cpu_Id = Valid_Cpu_Core_Id_Type'First then
         Watchdog_Driver.Disable_Watchdogs;

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

      HiRTOS_Platform_Interface.Initialize_Platform;

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
