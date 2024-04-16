--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target CPU architecture interface - hypervisor interrupt handling
--

package HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Hypervisor
   with SPARK_Mode => On
is
   procedure Interrupt_Handler_Prolog
      with Inline_Always;

   procedure Interrupt_Handler_Epilog
      with Inline_Always, No_Return;

   type Hypervisor_Traps_Type is (WFI_Instruction_Executed,
                                  HVC_Instruction_Executed);

   type Hypervisor_Trap_Callback_Type is access procedure (Hypervisor_Trap : Hypervisor_Traps_Type);

   procedure Register_Hypervisor_Trap_Callback (Hypervisor_Trap_Callback : Hypervisor_Trap_Callback_Type);

end HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Hypervisor;
