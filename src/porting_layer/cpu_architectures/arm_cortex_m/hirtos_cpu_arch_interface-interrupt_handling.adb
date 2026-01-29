--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target platform interface for ARM Cortex-M architecture - Interrupt handling
--

with Generic_Execution_Stack;
with HiRTOS_Platform_Parameters;

package body HiRTOS_Cpu_Arch_Interface.Interrupt_Handling is

   ISR_Stack_Size_In_Bytes : constant := 2 * 1024; -- 2KiB

   package ISR_Stacks_Package is new
      Generic_Execution_Stack (Stack_Size_In_Bytes => ISR_Stack_Size_In_Bytes);

   pragma Compile_Time_Error (
      ISR_Stacks_Package.Stack_Entries_Type'Size /= ISR_Stack_Size_In_Bytes * System.Storage_Unit,
      "Unexpected ISR stack size");

   ISR_Stacks :
      array (Valid_Cpu_Core_Id_Type) of ISR_Stacks_Package.Execution_Stack_Type
         with Linker_Section => ".isr_stack",
              Convention => C,
              Export,
              External_Name => "isr_stacks";

   pragma Compile_Time_Error (
      ISR_Stacks'Size = HiRTOS_Platform_Parameters.Num_Cpu_Cores * ISR_Stack_Size_In_Bytes * System.Storage_Unit,
      "Unexpected size of ISR_Stacks");

   ------------------------
   -- Get_ISR_Stack_Info --
   ------------------------

   function Get_ISR_Stack_Info (Cpu_Id : Cpu_Core_Id_Type)
      return ISR_Stack_Info_Type
   is
      ISR_Stack_Info : constant ISR_Stack_Info_Type :=
         (Base_Address => ISR_Stacks (Cpu_Id).Stack_Entries'Address,
          Size_In_Bytes => ISR_Stacks (Cpu_Id).Stack_Entries'Size / System.Storage_Unit);
   begin
      pragma Assert (Is_Value_Power_Of_Two (ISR_Stack_Info.Size_In_Bytes));
      return ISR_Stack_Info;
   end Get_ISR_Stack_Info;

   function Valid_ISR_Stack_Pointer (Cpu_Id : Cpu_Core_Id_Type; Stack_Pointer : System.Address)
      return Boolean is
      Min_Valid_Address : constant Integer_Address :=
         To_Integer (ISR_Stacks (Cpu_Id).Stack_Entries'Address);
      Max_Valid_Address : constant Integer_Address :=
         Min_Valid_Address + (ISR_Stacks (Cpu_Id).Stack_Entries'Size / System.Storage_Unit) - 1;
   begin
      return To_Integer (Stack_Pointer) in Min_Valid_Address .. Max_Valid_Address;
   end Valid_ISR_Stack_Pointer;

   procedure Interrupt_Handler_Prolog is
   begin
      null;
   end Interrupt_Handler_Prolog;

   procedure Interrupt_Handler_Epilog is
   begin
      loop
         Wait_For_Interrupt;
      end loop;
   end Interrupt_Handler_Epilog;

end HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
