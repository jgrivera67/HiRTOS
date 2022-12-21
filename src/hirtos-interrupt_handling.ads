--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with System;

package HiRTOS.Interrupt_Handling
   with SPARK_Mode => On
is

   procedure Enter_Interrupt_Context
      with Inline_Always,
           Suppress => All_Checks;

   procedure Exit_Interrupt_Context
      with Inline_Always,
           Suppress => All_Checks;

   procedure RTOS_Tick_Timer_Interrupt_Handler;

   function Get_Interrupted_PC return System.Address
      with Pre => Current_Execution_Context_Is_Interrupt;

end HiRTOS.Interrupt_Handling;
