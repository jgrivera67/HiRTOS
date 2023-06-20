--
--  Copyright (c) 2023, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with System;

package HiRTOS.Separation_Kernel.Interrupt_Handling
   with SPARK_Mode => On
is
   function Enter_Interrupt_Context (Stack_Pointer : System.Address) return System.Address
      with Suppress => All_Checks,
           Export,
           Convention => C,
           External_Name => "hirtos_separation_kernel_enter_interrupt_context";

   function Exit_Interrupt_Context return System.Address
      with Suppress => All_Checks,
           Export,
           Convention => C,
           External_Name => "hirtos_separation_kernel_exit_interrupt_context";

   procedure Tick_Timer_Interrupt_Handler;

end HiRTOS.Separation_Kernel.Interrupt_Handling;
