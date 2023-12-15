--
--  Copyright (c) 2022-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

with System;

package HiRTOS.Interrupt_Handling
   with SPARK_Mode => On
is
   function Enter_Interrupt_Context (Stack_Pointer : System.Address) return System.Address
      with Suppress => All_Checks,
           Export,
           Convention => C,
           External_Name => "hirtos_enter_interrupt_context";

   function Exit_Interrupt_Context (Stack_Pointer : System.Address) return System.Address
      with Suppress => All_Checks,
           Export,
           Convention => C,
           External_Name => "hirtos_exit_interrupt_context";

   procedure RTOS_Tick_Timer_Interrupt_Handler;

   function Get_Interrupted_PC return System.Address
      with Pre => Current_Execution_Context_Is_Interrupt;

end HiRTOS.Interrupt_Handling;
