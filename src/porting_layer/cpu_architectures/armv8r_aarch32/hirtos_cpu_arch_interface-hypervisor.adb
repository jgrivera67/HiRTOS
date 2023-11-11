--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary RTOS to target platform interface - ARMv8-R hypervisor
--

with HiRTOS_Cpu_Arch_Interface.System_Registers.Hypervisor;

package body HiRTOS_Cpu_Arch_Interface.Hypervisor
   with SPARK_Mode => On
is
   use HiRTOS_Cpu_Arch_Interface.System_Registers.Hypervisor;

   procedure Initialize is
      HCR_Value : HCR_Type := Get_HCR;
   begin
      --  Enable two-stage MPU for memory accesses from EL1/EL0
      HCR_Value.VM := HCR_Virtualization_Enabled;

      --  Route FIQ interrupts to EL2
      HCR_Value.FMO := HCR_FIQ_Mask_Override_Enabled;

      --  trap WFI instruction to EL2
      --??? HCR_Value.TWI := HCR_Trap_WFI_Enabled;

      Set_HCR (HCR_Value);
   end Initialize;

end HiRTOS_Cpu_Arch_Interface.Hypervisor;
