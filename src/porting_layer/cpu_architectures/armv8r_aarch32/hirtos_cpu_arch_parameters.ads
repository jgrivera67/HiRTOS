--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS target CPU architecture parameters for ARMv8-R aarch32
--

with System;

package HiRTOS_Cpu_Arch_Parameters
   with SPARK_Mode => On
is
   --
   --  Width in bits of CPUs interger registers
   --
   Machine_Word_Width_In_Bits : constant := 32;

   --
   --  Cache line size in bytes
   --
   Cache_Line_Size_Bytes : constant := 32;

   --
   --  Alignment in bytes for a memory protection region
   --
   Memory_Region_Alignment : constant := 64;

   --
   --  Required alignment in bytes for the stack pointer
   --
   Stack_Pointer_Alignment : constant := 4;

   --
   --  Width of CPU integer registers in bytes
   --
   Integer_Register_Size_In_Bytes : constant := Machine_Word_Width_In_Bits / System.Storage_Unit;

   --
   --  Size in bytes of the 'BL' machine instruction
   --
   Call_Instruction_Size : constant := 4;

   --
   --  Number of usable external interrupt priorities (levels) in
   --  the interrupt controller
   --
   Num_Interrupt_Priorities : constant := 31;

end HiRTOS_Cpu_Arch_Parameters;
