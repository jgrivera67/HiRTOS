--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary RTOS to target CPU architecture interface
--

private package HiRTOS_Cpu_Arch_Interface_Private with
 SPARK_Mode => On, No_Elaboration_Code_All
is

   --
   --  Values for CPSR mode field
   --
   CPSR_User_Mode           : constant := 2#1_0000#; --  EL0
   CPSR_Fast_Interrupt_Mode : constant := 2#1_0010#; --  EL1
   CPSR_Supervisor_Mode     : constant := 2#1_0011#; --  EL1
   CPSR_Monitor_Mode        : constant := 2#1_0110#; --  EL3
   CPSR_Abort_Mode          : constant := 2#1_0111#; --  EL1
   CPSR_Hypervisor_Mode     : constant := 2#1_1010#; --  EL2
   CPSR_Undefined_Mode      : constant := 2#1_1011#; --  EL1
   CPSR_System_Mode         : constant := 2#1_1111#; --  EL1

end HiRTOS_Cpu_Arch_Interface_Private;
