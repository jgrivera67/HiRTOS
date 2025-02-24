--
--  Copyright (c) 2024, German Rivera
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary ARM FVP platform interface
--

with HiRTOS_Cpu_Arch_Interface;

package HiRTOS_Platform_Interface is

   procedure Initialize_Platform with
      Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode;

end HiRTOS_Platform_Interface;