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
   use type Interrupt_Controller.Interrupt_Priority_Type;

   System_Timer_Interrupt_Id : constant
      Interrupt_Controller.Interrupt_Id_Type := 5; --  External IRQ line 37

   UART0_Interrupt_Id : constant
      Interrupt_Controller.Interrupt_Id_Type := 21;

   UART1_Interrupt_Id : constant
      Interrupt_Controller.Interrupt_Id_Type := 22;

   Interrupt_Priorities : constant array (Interrupt_Controller.Valid_Interrupt_Id_Type) of
      Interrupt_Controller.Interrupt_Priority_Type :=
      [System_Timer_Interrupt_Id => Interrupt_Controller.Highest_Interrupt_Priority - 1,
       UART0_Interrupt_Id => Interrupt_Controller.Lowest_Interrupt_Priority + 1,
       UART1_Interrupt_Id => Interrupt_Controller.Lowest_Interrupt_Priority + 1,
       others => Interrupt_Controller.Lowest_Interrupt_Priority];

end HiRTOS_Cpu_Arch_Interface.Interrupts;
