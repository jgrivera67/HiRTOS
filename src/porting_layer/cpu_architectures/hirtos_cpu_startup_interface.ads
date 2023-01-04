--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary Startup code
--

with Interfaces;
with HiRTOS_Cpu_Arch_Parameters;

package HiRTOS_Cpu_Startup_Interface with No_Elaboration_Code_All
is

   C_Global_Variables_Initialized_Flag : Boolean with Import,
                                                      Volatile,
                                                      Size => Interfaces.Unsigned_32'Size,
                                                      --Alignment => HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes,
                                                      Convention => C,
                                                      External_Name => "c_global_vars_initialized_flag";

   HiRTOS_Global_Variables_Elaborated_Flag : Boolean with Import,
                                                         Volatile,
                                                         Size => Interfaces.Unsigned_32'Size,
                                                         --Alignment => HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes,
                                                         Convention => C,
                                                         External_Name => "hirtos_global_vars_elaborated_flag";

   procedure Ada_Reset_Handler
      with Export,
           Convention => C,
           External_Name => "ada_reset_handler",
           No_Return;

end HiRTOS_Cpu_Startup_Interface;
