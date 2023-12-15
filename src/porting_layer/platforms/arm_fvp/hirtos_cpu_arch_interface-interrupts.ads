--
--  Copyright (c) 2022-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary Platform-specfic interrupt information
--

with HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;

package HiRTOS_Cpu_Arch_Interface.Interrupts
   with SPARK_Mode => On
is
   use type HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Interrupt_Priority_Type;

   Generic_Hypervisor_Timer_Interrupt_Id : constant
      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Internal_Interrupt_Id_Type := 26;

   Generic_Virtual_Timer_Interrupt_Id : constant
      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Internal_Interrupt_Id_Type := 27;

   Generic_Physical_Timer_Interrupt_Id : constant
      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Internal_Interrupt_Id_Type := 30;

   UART0_Interrupt_Id : constant
      Interrupt_Controller.External_Interrupt_Id_Type := 37;

   UART1_Interrupt_Id : constant
      Interrupt_Controller.External_Interrupt_Id_Type := 38;

   UART2_Interrupt_Id : constant
      Interrupt_Controller.External_Interrupt_Id_Type := 39;

   UART3_Interrupt_Id : constant
      Interrupt_Controller.External_Interrupt_Id_Type := 40;

   Interrupt_Priorities : constant array (Interrupt_Controller.Valid_Interrupt_Id_Type) of
      Interrupt_Controller.Interrupt_Priority_Type :=
      [Generic_Physical_Timer_Interrupt_Id => Interrupt_Controller.Highest_Interrupt_Priority + 1,
       Generic_Virtual_Timer_Interrupt_Id => Interrupt_Controller.Highest_Interrupt_Priority + 1,
       Generic_Hypervisor_Timer_Interrupt_Id => Interrupt_Controller.Highest_Interrupt_Priority + 1,
       UART0_Interrupt_Id => Interrupt_Controller.Lowest_Interrupt_Priority - 1,
       UART1_Interrupt_Id => Interrupt_Controller.Lowest_Interrupt_Priority - 1,
       UART2_Interrupt_Id => Interrupt_Controller.Lowest_Interrupt_Priority - 1,
       UART3_Interrupt_Id => Interrupt_Controller.Lowest_Interrupt_Priority - 1,
       others => Interrupt_Controller.Lowest_Interrupt_Priority];

end HiRTOS_Cpu_Arch_Interface.Interrupts;
