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
with HiRTOS_Platform_Parameters;

package HiRTOS_Cpu_Arch_Interface.Interrupts
   with SPARK_Mode => On
is
   use Interrupt_Controller;

   type External_Interrupt_Type is
     (DMA0_IRQ,
      DMA1_IRQ,
      DMA2_IRQ,
      DMA3_IRQ,
      Reserved20_IRQ,
      FTFA_IRQ,
      LVD_LVW_IRQ,
      LLWU_IRQ,
      I2C0_IRQ,
      I2C1_IRQ,
      SPI0_IRQ,
      SPI1_IRQ,
      UART0_IRQ,
      UART1_IRQ,
      UART2_IRQ,
      ADC0_IRQ,
      CMP0_IRQ,
      TPM0_IRQ,
      TPM1_IRQ,
      TPM2_IRQ,
      RTC_IRQ,
      RTC_Seconds_IRQ,
      PIT_IRQ,
      Reserved39_IRQ,
      USB0_IRQ,
      DAC0_IRQ,
      TSI0_IRQ,
      MCG_IRQ,
      LPTMR0_IRQ,
      Reserved45_IRQ,
      PORTA_IRQ,
      PORTD_IRQ);

   pragma Compile_Time_Error
     (External_Interrupt_Type'Pos (DMA0_IRQ) /= 0,
      "First IRQ number must be 0");
   pragma Compile_Time_Error
     (External_Interrupt_Type'Pos (PORTD_IRQ) /=
      HiRTOS_Platform_Parameters.Num_External_Interrupts - 1,
      "Last IRQ number is wrong");

   Interrupt_Priorities : constant array (External_Interrupt_Type) of
      Interrupt_Controller.Interrupt_Priority_Type :=
      [
         UART0_IRQ => Interrupt_Controller.Lowest_Interrupt_Priority - 1,
         ADC0_IRQ => Interrupt_Controller.Highest_Interrupt_Priority + 1,
         others => Interrupt_Controller.Lowest_Interrupt_Priority
      ];

end HiRTOS_Cpu_Arch_Interface.Interrupts;
