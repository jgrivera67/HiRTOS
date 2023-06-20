--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS to target CPU architecture interface - hypervisor interrupt handling
--

package HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Hypervisor
   with SPARK_Mode => On
is
   procedure Interrupt_Handler_Epilog
      with Inline_Always, No_Return;

end HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Hypervisor;
