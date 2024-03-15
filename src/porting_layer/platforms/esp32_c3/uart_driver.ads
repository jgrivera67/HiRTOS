--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary UART driver for ESP32-C3
--
with HiRTOS_Cpu_Multi_Core_Interface;
private with ESP32_C3.UART;
with Interfaces;

package Uart_Driver
is
   use HiRTOS_Cpu_Multi_Core_Interface;

   procedure Initialize_Uart (Baud_Rate : Interfaces.Unsigned_32;
                              UART_Clock_Frequency_Hz : Interfaces.Unsigned_32);

   procedure Put_Char (C : Character);

   procedure Tx_Flush;

private

   --
   --  UART peripheral instances
   --
   UART_Periph_Pointers : constant
      array (Valid_Cpu_Core_Id_Type) of access ESP32_C3.UART.UART_Peripheral :=
        [Valid_Cpu_Core_Id_Type'First => ESP32_C3.UART.UART0_Periph'Access];

end Uart_Driver;
