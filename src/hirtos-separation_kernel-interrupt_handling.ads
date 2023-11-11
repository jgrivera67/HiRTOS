--
--  Copyright (c) 2023, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Hypervisor;
with System;

package HiRTOS.Separation_Kernel.Interrupt_Handling
   with SPARK_Mode => On
is
   function Exit_Interrupt_Context return System.Address
      with Suppress => All_Checks,
           Export,
           Convention => C,
           External_Name => "hirtos_separation_kernel_exit_interrupt_context";

   procedure Tick_Timer_Interrupt_Handler
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode;

   procedure Hypervisor_Trap_Handler (
      Hypervisor_Trap : HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Hypervisor.Hypervisor_Traps_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode;

end HiRTOS.Separation_Kernel.Interrupt_Handling;
