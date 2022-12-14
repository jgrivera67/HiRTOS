--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary Startup code
--

with System;

package HiRTOS_Cpu_Startup_Interface with No_Elaboration_Code_All
is

   procedure Ada_Reset_Handler
      with Export,
           Convention => C,
           External_Name => "ada_reset_handler",
           No_Return;
   --
   --  Reset exception handler
   --

   procedure Unexpected_Interrupt_Handler
      with Export,
           Convention => C,
           External_Name => "ada_unexpected_irq_handler";
   --
   --  Default handler of unexpected interrupts
   --

   procedure Last_Chance_Handler (Msg : System.Address; Line : Integer)
     with No_Return;
   pragma Export (C, Last_Chance_Handler, "__gnat_last_chance_handler");

end HiRTOS_Cpu_Startup_Interface;
