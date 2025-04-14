--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS target CPU architecture parameters for ARMv8-A aarch64
--

with System;

package HiRTOS_Cpu_Arch_Parameters
   with SPARK_Mode => On, No_Elaboration_Code_All
is
   --
   --  Width in bits of CPUs integer registers
   --
   Machine_Word_Width_In_Bits : constant := 64;

   --
   --  Cache line size in bytes
   --
   Cache_Line_Size_Bytes : constant := 64;

   --
   --  Size in bytes of an MMU page
   --
   Page_Size_In_Bytes : constant := 4 * 1024;

   --
   --  Alignment in bytes for a memory protection region
   --
   Memory_Region_Alignment : constant := Page_Size_In_Bytes;

   --
   --  Required alignment in bytes for the stack pointer
   --
   Stack_Pointer_Alignment : constant := 16;

   --
   --  Width of CPU integer registers in bytes
   --
   Integer_Register_Size_In_Bytes : constant := Machine_Word_Width_In_Bits / System.Storage_Unit;

   --
   --  Size in bytes of the 'BL' machine instruction
   --
   Call_Instruction_Size_In_Bytes : constant := 4;

   --
   --  Size in bytes of the 'BRK' machine instruction
   --
   Break_Instruction_Size_In_Bytes : constant := 4;

   --
   --  Number of usable external interrupt priorities (levels) in
   --  the interrupt controller
   --
   Num_Interrupt_Priorities : constant := 31;

end HiRTOS_Cpu_Arch_Parameters;
