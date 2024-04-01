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
   use Interrupt_Controller;
   use type Interrupt_Controller.Interrupt_Priority_Type;

   type External_Irq_Number_Type is range 0 .. 61;

   UART0_Interrupt_Id : constant Valid_Interrupt_Id_Type := Valid_Interrupt_Id_Type'First;
   UART1_Interrupt_Id : constant Valid_Interrupt_Id_Type := Valid_Interrupt_Id_Type'First + 1;
   System_Timer_Target0_Interrupt_Id : constant Valid_Interrupt_Id_Type := Valid_Interrupt_Id_Type'First + 2;
   System_Timer_Target1_Interrupt_Id : constant Valid_Interrupt_Id_Type := Valid_Interrupt_Id_Type'First + 3;
   System_Timer_Target2_Interrupt_Id : constant Valid_Interrupt_Id_Type := Valid_Interrupt_Id_Type'First + 4;
   Assist_Debug_Interrupt_Id : constant Valid_Interrupt_Id_Type := Valid_Interrupt_Id_Type'First + 5;
   PMS_DMA_VIO_Interrupt_Id : constant Valid_Interrupt_Id_Type := Valid_Interrupt_Id_Type'First + 6;
   PMS_IBUS_VIO_Interrupt_Id : constant Valid_Interrupt_Id_Type := Valid_Interrupt_Id_Type'First + 7;
   PMS_DBUS_VIO_Interrupt_Id : constant Valid_Interrupt_Id_Type := Valid_Interrupt_Id_Type'First + 8;
   PMS_PERI_VIO_Interrupt_Id : constant Valid_Interrupt_Id_Type := Valid_Interrupt_Id_Type'First + 9;
   PMS_PERI_VIO_Size_Interrupt_Id : constant Valid_Interrupt_Id_Type := Valid_Interrupt_Id_Type'First + 10;

   Interrupt_To_External_Irq_Map : constant array (Interrupt_Controller.Valid_Interrupt_Id_Type) of
      External_Irq_Number_Type :=
      [
         UART0_Interrupt_Id => 21,
         UART1_Interrupt_Id => 22,
         System_Timer_Target0_Interrupt_Id => 37,
         System_Timer_Target1_Interrupt_Id => 38,
         System_Timer_Target2_Interrupt_Id => 39,
         Assist_Debug_Interrupt_Id => 54,
         PMS_DMA_VIO_Interrupt_Id => 55,
         PMS_IBUS_VIO_Interrupt_Id => 56,
         PMS_DBUS_VIO_Interrupt_Id => 57,
         PMS_PERI_VIO_Interrupt_Id => 58,
         PMS_PERI_VIO_Size_Interrupt_Id => 59,
         others => 0
      ];

   Interrupt_Priorities : constant array (Interrupt_Controller.Valid_Interrupt_Id_Type) of
      Interrupt_Controller.Interrupt_Priority_Type :=
      [
         UART0_Interrupt_Id => Interrupt_Controller.Lowest_Interrupt_Priority + 1,
         UART1_Interrupt_Id => Interrupt_Controller.Lowest_Interrupt_Priority + 1,

         System_Timer_Target0_Interrupt_Id => Interrupt_Controller.Highest_Interrupt_Priority - 1,
         System_Timer_Target1_Interrupt_Id => Interrupt_Controller.Highest_Interrupt_Priority - 1,
         System_Timer_Target2_Interrupt_Id => Interrupt_Controller.Highest_Interrupt_Priority - 1,

         Assist_Debug_Interrupt_Id => Interrupt_Controller.Highest_Interrupt_Priority,
         PMS_DMA_VIO_Interrupt_Id => Interrupt_Controller.Highest_Interrupt_Priority,
         PMS_IBUS_VIO_Interrupt_Id => Interrupt_Controller.Highest_Interrupt_Priority,
         PMS_DBUS_VIO_Interrupt_Id => Interrupt_Controller.Highest_Interrupt_Priority,
         PMS_PERI_VIO_Interrupt_Id => Interrupt_Controller.Highest_Interrupt_Priority,
         PMS_PERI_VIO_Size_Interrupt_Id => Interrupt_Controller.Highest_Interrupt_Priority,

         others => Interrupt_Controller.Lowest_Interrupt_Priority
      ];

end HiRTOS_Cpu_Arch_Interface.Interrupts;
