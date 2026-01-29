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

   procedure Set_Interrupted_PC (PC_Value : System.Address)
      with Pre => Current_Execution_Context_Is_Interrupt;

   type Stop_Executing_Thread_Callback_Type is access procedure;

   type Start_Executing_Thread_Callback_Type is access function return Boolean;

   procedure Register_Executing_Thread_Callbacks (
      Stop_Executing_Thread_Callback : Stop_Executing_Thread_Callback_Type;
      Start_Executing_Thread_Callback : Start_Executing_Thread_Callback_Type);

end HiRTOS.Interrupt_Handling;