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
--  @summary RTOS to target platform interface - CPU specific for ARMv7-R architecture
--

package body HiRTOS_Platform_Interface.Cpu_Specific with SPARK_Mode => On is

   procedure Initialize_Thread_Mem_Prot_Regions (Stack_Base_Addr : System.Address;
                                                 Stack_Szie : Interfaces.Unsigned_32;
                                                 Thread_Regions : out Thread_Mem_Prot_Regions_Type)
   is
   begin
      null; --  ???
   end Initialize_Thread_Mem_Prot_Regions;

   procedure Restore_Thread_Mem_Prot_Regions (Thread_Regions : Thread_Mem_Prot_Regions_Type) is
   begin
      null; --  ???
   end Restore_Thread_Mem_Prot_Regions;

   procedure Save_Thread_Mem_Prot_Regions (Thread_Regions : out Thread_Mem_Prot_Regions_Type) is
   begin
      null; --  ???
   end Save_Thread_Mem_Prot_Regions;

   procedure Initialize_Thread_Cpu_Context (Thread_Cpu_Context : out Cpu_Context_Type;
                                            Initial_Stack_Pointer : System.Address) is
   begin
      Thread_Cpu_Context.Sp := To_Integer (Initial_Stack_Pointer);
      Thread_Cpu_Context.Cpu_Privileged_Nesting_Count := 0;
      --??? Floating_Point_Registers : Floating_Point_Registers_Type;
      --??? Integer_Registers
   end Initialize_Thread_Cpu_Context;

end HiRTOS_Platform_Interface.Cpu_Specific;