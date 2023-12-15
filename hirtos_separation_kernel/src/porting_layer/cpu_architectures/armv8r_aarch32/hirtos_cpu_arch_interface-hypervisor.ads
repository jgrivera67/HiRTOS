--
--  Copyright (c) 2022-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - ARMv8-R hypervisor
--

package HiRTOS_Cpu_Arch_Interface.Hypervisor
   with SPARK_Mode => On,
        No_Elaboration_Code_All
is

   procedure Initialize
      with Pre => Cpu_In_Hypervisor_Mode;

end HiRTOS_Cpu_Arch_Interface.Hypervisor;
