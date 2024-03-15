--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary UART driver for ESP32-C3
--

package body Uart_Driver is

   use ESP32_C3.UART;
   use type ESP32_C3.Bit;

   procedure Initialize_Uart (Baud_Rate : Interfaces.Unsigned_32;
                              UART_Clock_Frequency_Hz : Interfaces.Unsigned_32) is

      UART_Periph_Pointer : constant access UART_Peripheral :=
         UART_Periph_Pointers (Get_Cpu_Id) with Unreferenced;

   begin
      --  Set baud rate:

      --  Configure data frame format to be 8-N-1 (8 data bits, no parity, 1 stop bit)

      --  Disable (mask) all interrupts:

      --  Clear any pending interrupt:

      --  Disable UART Rx FIFO

      --  Enable UART Tx/Rx and UART peripheral itself:
      null;
   end Initialize_Uart;

   procedure Put_Char (C : Character) is
      FIFO_Value : FIFO_Register;
      INT_RAW_Value : INT_RAW_Register;
      UART_Periph_Pointer : constant access UART_Peripheral :=
         UART_Periph_Pointers (Get_Cpu_Id);
   begin
      loop
         INT_RAW_Value := UART_Periph_Pointer.INT_RAW;
         exit when INT_RAW_Value.TXFIFO_EMPTY_INT_RAW = 1;
      end loop;

      FIFO_Value.RXFIFO_RD_BYTE := FIFO_RXFIFO_RD_BYTE_Field (Character'Pos (C));
      UART_Periph_Pointer.FIFO := FIFO_Value;
   end Put_Char;

   procedure Tx_Flush is
      INT_RAW_Value : INT_RAW_Register;
      UART_Periph_Pointer : constant access UART_Peripheral :=
         UART_Periph_Pointers (Get_Cpu_Id);
   begin
      loop
         INT_RAW_Value := UART_Periph_Pointer.INT_RAW;
         exit when INT_RAW_Value.TX_DONE_INT_RAW = 1;
      end loop;
   end Tx_Flush;

end Uart_Driver;