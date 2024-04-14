--
--  Copyright (c) 2024, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target CPU architecture interface - Architecture-specific interrupt handling
--

package HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Arch_Specific
   with SPARK_Mode => On
is
   procedure Handle_Undefined_Instruction_Exception;

end HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Arch_Specific;
