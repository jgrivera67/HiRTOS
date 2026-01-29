--
--  Copyright (c) 2024, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  Platform interface
--

with HiRTOS_Cpu_Arch_Interface;

package HiRTOS_Platform_Interface
   with SPARK_Mode => On
is
   use HiRTOS_Cpu_Arch_Interface;

   procedure Initialize_Platform with
      Pre => Cpu_In_Privileged_Mode and then Cpu_Interrupting_Disabled;

end HiRTOS_Platform_Interface;
