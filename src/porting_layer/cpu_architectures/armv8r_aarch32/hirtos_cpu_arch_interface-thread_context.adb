--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS to target platform interface - Thread CPU context
--  for ARMv8-R architecture
--

with HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface.Thread_Context with SPARK_Mode => On is
   use ASCII;

   procedure Initialize_Thread_Cpu_Context (Thread_Cpu_Context : out Cpu_Context_Type;
                                            Initial_Stack_Pointer : Cpu_Register_Type) is
   begin
      Thread_Cpu_Context.Sp := Initial_Stack_Pointer;
      Thread_Cpu_Context.Cpu_Privileged_Nesting_Count := 0;
      --??? Floating_Point_Registers : Floating_Point_Registers_Type;
      --??? Integer_Registers
      pragma Assert (False); --  ???
   end Initialize_Thread_Cpu_Context;

   procedure First_Thread_Context_Switch is
   begin
      --
      --  NOTE: To start executing the first thread, we pretend that we are returning from an
      --  interrupt, since before RTOS tasking is started, we have executing in the reset exception
      --  handler.
      --
      HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Interrupt_Handler_Epilog;
   end First_Thread_Context_Switch;

   procedure Synchronous_Thread_Context_Switch is
   begin
      --
      --  Initiate a synchronous thread context switch by doing
      --  a Supervisor call, passing 0 in r0
      --
      System.Machine_Code.Asm (
         "mov r0, #0" & LF &
         "svc #0",
         Clobber => "r0",
         Volatile => True);
   end Synchronous_Thread_Context_Switch;

end HiRTOS_Cpu_Arch_Interface.Thread_Context;
