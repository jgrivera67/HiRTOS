--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary UART driver for ARM PL011
--

package body Uart_Driver is

   use type Bit_Sized_Integer_Types.Bit_Type;

   procedure Initialize_Uart (Baud_Rate : Interfaces.Unsigned_32;
                              UART_Clock_Frequency_Hz : Interfaces.Unsigned_32) is

      procedure Calculate_Divisors (Baudrate : Interfaces.Unsigned_32;
                                    Integer_Div : out Interfaces.Unsigned_16;
                                    Fractional_Div : out Bit_Sized_Integer_Types.Six_Bits_Type) is
         use type Interfaces.Unsigned_32;
      begin
         --  F_UARTCLK / (16 * Baudrate)
         Integer_Div := Interfaces.Unsigned_16 (UART_Clock_Frequency_Hz / (16 * Baudrate));
         Fractional_Div := Bit_Sized_Integer_Types.Six_Bits_Type (0);
      end Calculate_Divisors;

      UARTIBRD_Value : UARTIBRD_Register;
      UARTFBRD_Value : UARTFBRD_Register;
      UARTLCR_H_Value : UARTLCR_H_Register;
      UARTCR_Value : UARTCR_Register;
      UARTIMSC_Value : UARTIMSC_Register;
      UARTICR_Value : UARTICR_Register;
      UARTIFLS_Value : UARTIFLS_Register;
      UART_Periph_Pointer : constant access UART_Peripheral :=
         UART_Periph_Pointers (Get_Cpu_Id);

      procedure Disable_Uart is
      begin
         --  Disable UART Tx/Rx and UART peripheral itself:
         UARTCR_Value := UART_Periph_Pointer.UARTCR;
         UARTCR_Value.TXE := 2#0#;
         UARTCR_Value.RXE := 2#0#;
         UARTCR_Value.UARTEN := 2#0#;
         UART_Periph_Pointer.UARTCR := UARTCR_Value;

         UARTLCR_H_Value := UART_Periph_Pointer.UARTLCR_H;
         UARTLCR_H_Value.FEN := 2#0#;
         UART_Periph_Pointer.UARTLCR_H := UARTLCR_H_Value;
      end Disable_Uart;

      procedure Enable_Uart is
      begin
         --  Enable UART Tx/Rx and UART peripheral itself:
         UARTCR_Value := UART_Periph_Pointer.UARTCR;
         UARTCR_Value.TXE := 2#1#;
         UARTCR_Value.RXE := 2#1#;
         UARTCR_Value.UARTEN := 2#1#;
         UART_Periph_Pointer.UARTCR := UARTCR_Value;
      end Enable_Uart;

   begin
      Disable_Uart;

      --  Set baud rate:
      Calculate_Divisors (Baud_Rate, UARTIBRD_Value.BAUD_DIVINT, UARTFBRD_Value.BAUD_DIVFRAC);

      UART_Periph_Pointer.UARTIBRD := UARTIBRD_Value;
      UART_Periph_Pointer.UARTFBRD := UARTFBRD_Value;

      --  Configure data frame format to be 8-N-1 (8 data bits, no parity, 1 stop bit)
      UARTLCR_H_Value.WLEN := 2#11#;
      UARTLCR_H_Value.STP2 := 2#0#;
      UARTLCR_H_Value.PEN := 2#0#;
      UARTLCR_H_Value.FEN := 2#1#;
      UART_Periph_Pointer.UARTLCR_H := UARTLCR_H_Value;

      --  Enable Rx interrupt and disable other interrupts:
      UARTIMSC_Value := (RXIM => 2#1#, others => 2#0#);
      UART_Periph_Pointer.UARTIMSC := UARTIMSC_Value;

      --  Clear any pending interrupt:
      UARTICR_Value := (others => 2#1#);
      UART_Periph_Pointer.UARTICR := UARTICR_Value;

      --
      --  Disable UART Rx FIFO
      --
      UARTIFLS_Value := UART_Periph_Pointer.UARTIFLS;
      UARTIFLS_Value.RXIFLSEL := 2#000#;
      UART_Periph_Pointer.UARTIFLS := UARTIFLS_Value;

      Enable_Uart;
   end Initialize_Uart;

   procedure Put_Char (C : Character) is
      UARTFR_Value : UARTFR_Register;
      UARTDR_Value : UARTDR_Register;
      --  NOTE For RaspberryPI, we don't use a separate UART per CPU as only UART0 is
      --  going to be used.
      UART_Periph_Pointer : constant access UART_Peripheral := UART_Periph_Pointers (0);
   begin
      loop
         UARTFR_Value := UART_Periph_Pointer.UARTFR;
         exit when UARTFR_Value.TXFF = 0;
      end loop;

      UARTDR_Value.DATA := Interfaces.Unsigned_8 (Character'Pos (C));
      UART_Periph_Pointer.UARTDR := UARTDR_Value;
   end Put_Char;

   procedure Flush_Output is
      UARTFR_Value : UARTFR_Register;
      --  NOTE For RaspberryPI, we don't use a separate UART per CPU as only UART0 is
      --  going to be used.
      UART_Periph_Pointer : constant access UART_Peripheral := UART_Periph_Pointers (0);
   begin
      loop
         UARTFR_Value := UART_Periph_Pointer.UARTFR;
         exit when UARTFR_Value.TXFE = 1;
      end loop;
   end Flush_Output;

   function Get_Char return Character is
      UARTFR_Value : UARTFR_Register;
      UARTDR_Value : UARTDR_Register;
   begin
      declare
         UART_Periph_Pointer : constant access UART_Peripheral :=
            UART_Periph_Pointers (Get_Cpu_Id);
      begin
         loop
            UARTFR_Value := UART_Periph_Pointer.UARTFR;
            exit when UARTFR_Value.RXFE = 0;
         end loop;

         UARTDR_Value := UART_Periph_Pointer.UARTDR;
      end;

      return Character'Val (UARTDR_Value.DATA);
   end Get_Char;

end Uart_Driver;