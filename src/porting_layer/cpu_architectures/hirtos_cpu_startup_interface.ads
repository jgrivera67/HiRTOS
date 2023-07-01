--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary Startup code
--

package HiRTOS_Cpu_Startup_Interface with No_Elaboration_Code_All
is

   procedure Ada_Reset_Handler
      with Export,
           Convention => C,
           External_Name => "ada_reset_handler",
           No_Return;

end HiRTOS_Cpu_Startup_Interface;
