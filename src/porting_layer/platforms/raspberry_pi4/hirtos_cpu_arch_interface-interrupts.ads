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
   use type Interrupt_Controller.External_Interrupt_Id_Type;
   use type HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Interrupt_Priority_Type;

   Generic_Hypervisor_Timer_Interrupt_Id : constant
      Interrupt_Controller.Internal_Interrupt_Id_Type := 26;

   Generic_Virtual_Timer_Interrupt_Id : constant
      Interrupt_Controller.Internal_Interrupt_Id_Type := 27;

   Generic_Physical_Timer_Interrupt_Id : constant
      Interrupt_Controller.Internal_Interrupt_Id_Type := 30;

   VC_Peripheral_IRQs_Base_Interrupt_Id : constant
      Interrupt_Controller.External_Interrupt_Id_Type := 96;

   VC_Peripheral_PL011_UARTs_Interrupt_Id : constant
      Interrupt_Controller.External_Interrupt_Id_Type :=
         VC_Peripheral_IRQs_Base_Interrupt_Id + 57;

   UART0_Interrupt_Id : constant Interrupt_Controller.External_Interrupt_Id_Type :=
      VC_Peripheral_PL011_UARTs_Interrupt_Id;

   UART2_Interrupt_Id : constant Interrupt_Controller.External_Interrupt_Id_Type :=
      VC_Peripheral_PL011_UARTs_Interrupt_Id;

   UART3_Interrupt_Id : constant Interrupt_Controller.External_Interrupt_Id_Type :=
      VC_Peripheral_PL011_UARTs_Interrupt_Id;

   UART4_Interrupt_Id : constant Interrupt_Controller.External_Interrupt_Id_Type :=
      VC_Peripheral_PL011_UARTs_Interrupt_Id;

   UART5_Interrupt_Id : constant Interrupt_Controller.External_Interrupt_Id_Type :=
      VC_Peripheral_PL011_UARTs_Interrupt_Id;

   Interrupt_Priorities : constant array (Interrupt_Controller.Valid_Interrupt_Id_Type) of
      Interrupt_Controller.Interrupt_Priority_Type :=
      [Generic_Physical_Timer_Interrupt_Id => Interrupt_Controller.Highest_Interrupt_Priority + 1,
       Generic_Virtual_Timer_Interrupt_Id => Interrupt_Controller.Highest_Interrupt_Priority + 1,
       Generic_Hypervisor_Timer_Interrupt_Id => Interrupt_Controller.Highest_Interrupt_Priority,
       VC_Peripheral_PL011_UARTs_Interrupt_Id => Interrupt_Controller.Lowest_Interrupt_Priority - 1,
       others => Interrupt_Controller.Lowest_Interrupt_Priority];

end HiRTOS_Cpu_Arch_Interface.Interrupts;
