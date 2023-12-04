--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary Startup code
--

with HiRTOS_Cpu_Multi_Core_Interface;
with Interfaces;

package HiRTOS_Cpu_Startup_Interface with No_Elaboration_Code_All
is

   procedure Ada_Reset_Handler
      with Export,
           Convention => C,
           External_Name => "ada_reset_handler",
           No_Return;

   HiRTOS_Global_Vars_Elaborated_Flag : HiRTOS_Cpu_Multi_Core_Interface.Atomic_Counter_Type
      with Import,
           Convention => C,
           External_Name => "hirtos_global_vars_elaborated_flag";

   HiRTOS_Booted_As_Partition : constant Boolean
      with Import,
           Convention => C,
           Size => Interfaces.Unsigned_8'Size,
           External_Name => "hirtos_booted_as_partition";

end HiRTOS_Cpu_Startup_Interface;
