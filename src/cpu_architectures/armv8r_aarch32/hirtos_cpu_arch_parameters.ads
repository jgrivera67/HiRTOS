--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
--

--
--  @summary HiRTOS target CPU architecture parameters for ARMv8-R aarch32
--

with System;

package HiRTOS_Cpu_Arch_Parameters
   with SPARK_Mode => On,
        No_Elaboration_Code_All
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
