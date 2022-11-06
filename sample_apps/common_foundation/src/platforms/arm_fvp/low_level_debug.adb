--
--  Copyright (c) 2012, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
--

with Number_Conversion_Utils;
with Bit_Sized_Integer_Types;
with System;

package body Low_Level_Debug with SPARK_Mode => Off is
   use type Bit_Sized_Integer_Types.Bit_Type;

   --
   --  Red/yellow/green LEDs on the VE hardware, which are mapped to bits [7:0] of the
   --  SYS_LED register
   --
   SYS_LED_Base : constant System.Address := System'To_Address (16#8000_0000# + 16#1C01_0008#);

   --
   --  User DIP switches mapped to bits [7:0] of the SYS_SW register
   --
   SYS_SW_Base : constant System.Address := System'To_Address (16#8000_0000# + 16#1C01_0004#);

   type Word_Bit_Index_Type is range 0 .. Interfaces.Unsigned_32'Size - 1;

   type Word_Bit_Array_Type is array (Word_Bit_Index_Type) of Bit_Sized_Integer_Types.Bit_Type
     with Component_Size => 1, Size => Interfaces.Unsigned_32'Size;

   --
   --  Array LED instance
   --
   SYS_LED_Periph : aliased Word_Bit_Array_Type
     with Import, Volatile_Full_Access, Address => SYS_LED_Base;

   --
   --  Array of dip switches
   --
   SYS_SW_Periph : aliased Word_Bit_Array_Type
     with Import, Volatile_Full_Access, Address => SYS_SW_Base;

   package UART is
      --
      --  Any peripherals in the memory range [0x0-0x7FFFFFFF] in the Base Platform
      --  are available at the same offset in the memory range [0x80000000-0xFFFFFFFF]
      --  in the BaseR Platform. 
      --
      UART0_Base : constant System.Address := System'To_Address (16#8000_0000# + 16#1C09_0000#);
      UART1_Base : constant System.Address := System'To_Address (16#8000_0000# + 16#1C0A_0000#);
      UART2_Base : constant System.Address := System'To_Address (16#8000_0000# + 16#1C0B_0000#);
      UART3_Base : constant System.Address := System'To_Address (16#8000_0000# + 16#1C0C_0000#);

      UART_Clock_Frequency_Hz : constant := 24_000_000; --- 24 MHz

      --  Data Register.
      type UARTDR_Register is record
         --  Overrun error
         OE : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Break error
         BE : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Parity error
         PE : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Framing error
         FE : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Data byte
         DATA : Interfaces.Unsigned_8 := 16#0#;
      end record
      with Volatile_Full_Access, Size => 32,
            Bit_Order => System.Low_Order_First;

      for UARTDR_Register use record
         DATA at 0 range 0 .. 7;
         FE at 0 range 8 .. 8;
         PE at 0 range 9 .. 9;
         BE at 0 range 10 .. 10;
         OE at 0 range 11 .. 11;
      end record;

      --  Receive Status / Error Clear Register.
      type UARTRSR_Register is record
         --  Framing error
         FE : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Parity error
         PE : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Break error
         BE : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Overrun error
         OE : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
      end record
      with Volatile_Full_Access, Size => 32,
            Bit_Order => System.Low_Order_First;

      for UARTRSR_Register use record
         FE at 0 range 0 .. 0;
         PE at 0 range 1 .. 1;
         BE at 0 range 2 .. 2;
         OE at 0 range 3 .. 3;
      end record;

      --  Flag Register.
      type UARTFR_Register is record
         --  Clear to send
         CTS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Data set ready
         DSR : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Data carrier detect
         DCD : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  UART busy
         BUSY : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Receive FIFO empty
         RXFE : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Transmit FIFO full
         TXFF : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Receive FIFO full
         RXFF : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Transmit FIFO empty
         TXFE : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Ring indicator
         RI : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
      end record
      with Volatile_Full_Access, Size => 32,
            Bit_Order => System.Low_Order_First;

      for UARTFR_Register use record
         CTS at 0 range 0 .. 0;
         DSR at 0 range 1 .. 1;
         DCD at 0 range 2 .. 2;
         BUSY at 0 range 3 .. 3;
         RXFE at 0 range 4 .. 4;
         TXFF at 0 range 5 .. 5;
         RXFF at 0 range 6 .. 6;
         TXFE at 0 range 7 .. 7;
         RI at 0 range 8 .. 8;
      end record;

      --  IrDA low-power counter Register.
      type UARTILPR_Register is record
         --  8-bit low-power divisor value
         ILPDVSR : Interfaces.Unsigned_8 := 16#0#;
      end record
      with Volatile_Full_Access, Size => 32,
            Bit_Order => System.Low_Order_First;

      for UARTILPR_Register use record
         ILPDVSR at 0 range 0 .. 7;
      end record;

      --  Integer baud rate Register.
      type UARTIBRD_Register is record
         BAUD_DIVINT : Interfaces.Unsigned_16 := 16#0#;
      end record
      with Volatile_Full_Access, Size => 32,
            Bit_Order => System.Low_Order_First;

      for UARTIBRD_Register use record
         BAUD_DIVINT at 0 range 0 .. 15;
      end record;

      --  Fractional baud rate Register.
      type UARTFBRD_Register is record
         BAUD_DIVFRAC : Bit_Sized_Integer_Types.Six_Bits_Type := 16#0#;
      end record
      with Volatile_Full_Access, Size => 32,
            Bit_Order => System.Low_Order_First;

      for UARTFBRD_Register use record
         BAUD_DIVFRAC at 0 range 0 .. 5;
      end record;

      --  Line Control Register.
      type UARTLCR_H_Register is record
         --  Send break
         BRK : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Parity enable
         PEN : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Even parity select
         EPS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Two stop bits select
         STP2 : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Enable FIFOs
         FEN : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Word length
         WLEN : Bit_Sized_Integer_Types.Two_Bits_Type := 16#0#;
         --  Stick parity select
         SPS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
      end record
      with Volatile_Full_Access, Size => 32,
            Bit_Order => System.Low_Order_First;

      for UARTLCR_H_Register use record
         BRK at 0 range 0 .. 0;
         PEN at 0 range 1 .. 1;
         EPS at 0 range 2 .. 2;
         STP2 at 0 range 3 .. 3;
         FEN at 0 range 4 .. 4;
         WLEN at 0 range 5 .. 6;
         SPS at 0 range 7 .. 7;
      end record;

      --  Control Register.
      type UARTCR_Register is record
         --  UART enable
         UARTEN : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  SIR enable
         SIREN : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  SIR low-power lrDA mode
         SIRLP : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Loopback enable
         LBE : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Transmit enable
         TXE : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Receive enable
         RXE : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Data transmit ready
         DTR : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Request to send
         RTS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  This bit is the complement of the UART Out1 (nUARTOut1) modem status
         --  output. That is, when the bit is programmed to a 1 the output is 0.
         --  For DTE this can be used as Data Carrier Detect (DCD).
         Out1 : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  This bit is the complement of the UART Out2 (nUARTOut2) modem status
         --  output. That is, when the bit is programmed to a 1, the output is 0.
         --  For DTE this can be used as Ring Indicator (RI).
         Out2 : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  RTS hardware flow control enable. If this bit is set to 1, RTS
         --  hardware flow control is enabled. Data is only requested when
         --  there is space in the receive FIFO for it to be received.
         RTSEn : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  CTS hardware flow control enable. If this bit is set to 1, CTS
         --  hardware flow control is enabled. Data is only transmitted when
         --  the nUARTCTS signal is asserted.
         CTSEn : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
      end record
      with Volatile_Full_Access, Size => 32,
            Bit_Order => System.Low_Order_First;

      for UARTCR_Register use record
         UARTEN at 0 range 0 .. 0;
         SIREN at 0 range 1 .. 1;
         SIRLP at 0 range 2 .. 2;
         LBE at 0 range 7 .. 7;
         TXE at 0 range 8 .. 8;
         RXE at 0 range 9 .. 9;
         DTR at 0 range 10 .. 10;
         RTS at 0 range 11 .. 11;
         Out1 at 0 range 12 .. 12;
         Out2 at 0 range 13 .. 13;
         RTSEn at 0 range 14 .. 14;
         CTSEn at 0 range 15 .. 15;
      end record;

      --  Interrupt FIFO level select Register.
      type UARTIFLS_Register is record
         --  Transmit interrupt FIFO level select
         TXIFLSEL : Bit_Sized_Integer_Types.Three_Bits_Type := 16#0#;
         --  Receive interrupt FIFO level select
         RXIFLSEL : Bit_Sized_Integer_Types.Three_Bits_Type := 16#0#;
      end record
      with Volatile_Full_Access, Size => 32,
            Bit_Order => System.Low_Order_First;

      for UARTIFLS_Register use record
         TXIFLSEL at 0 range 0 .. 2;
         RXIFLSEL at 0 range 3 .. 5;
      end record;

      --  Interrupt Mask Set/Clear Register.
      type UARTIMSC_Register is record
         --  nUARTRI modem interrupt mask
         RIMIM : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  nUARTCTS modem interrupt mask
         CTSMIM : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  nUARTDCD modem interrupt mask
         DCDMIM : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  nUARTDSR modem interrupt mask
         DSRMIM : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Receive interrupt mask
         RXIM : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Transmit interrupt mask
         TXIM : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Receive timeout interrupt mask
         RTIM : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Framing error interrupt mask
         FEIM : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Parity error interrupt mask
         PEIM : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Break error interrupt mask
         BEIM : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Overrun error interrupt mask
         OEIM : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
      end record
      with Volatile_Full_Access, Size => 32,
            Bit_Order => System.Low_Order_First;

      for UARTIMSC_Register use record
         RIMIM at 0 range 0 .. 0;
         CTSMIM at 0 range 1 .. 1;
         DCDMIM at 0 range 2 .. 2;
         DSRMIM at 0 range 3 .. 3;
         RXIM at 0 range 4 .. 4;
         TXIM at 0 range 5 .. 5;
         RTIM at 0 range 6 .. 6;
         FEIM at 0 range 7 .. 7;
         PEIM at 0 range 8 .. 8;
         BEIM at 0 range 9 .. 9;
         OEIM at 0 range 10 .. 10;
      end record;

      --  Raw Interrupt Status Register.
      type UARTRIS_Register is record
         --  nUARTRI modem raw interrupt status
         RIRMIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  nUARTCTS modem raw interrupt status
         CTSRMIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  nUARTDCD modem raw interrupt status
         DCDRMIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  nUARTDSR modem raw interrupt status
         DSRRMIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Receive raw interrupt status
         RXRIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Transmit raw interrupt status
         TXRIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Receive raw timeout interrupt status
         RTRIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Framing error raw interrupt status
         FERIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Parity error raw interrupt status
         PERIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Break error raw interrupt status
         BERIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Overrun error raw interrupt status
         OERIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
      end record
      with Volatile_Full_Access, Size => 32,
            Bit_Order => System.Low_Order_First;

      for UARTRIS_Register use record
         RIRMIS at 0 range 0 .. 0;
         CTSRMIS at 0 range 1 .. 1;
         DCDRMIS at 0 range 2 .. 2;
         DSRRMIS at 0 range 3 .. 3;
         RXRIS at 0 range 4 .. 4;
         TXRIS at 0 range 5 .. 5;
         RTRIS at 0 range 6 .. 6;
         FERIS at 0 range 7 .. 7;
         PERIS at 0 range 8 .. 8;
         BERIS at 0 range 9 .. 9;
         OERIS at 0 range 10 .. 10;
      end record;

      --  Masked Interrupt Status Register.
      type UARTMIS_Register is record
         --  nUARTRI modem masked interrupt status
         RIMMIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  nUARTCTS modem masked interrupt status
         CTSMMIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  nUARTDCD modem masked interrupt status
         DCDMMIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  nUARTDSR modem masked interrupt status
         DSRMMIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Receive masked interrupt status
         RXMIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Transmit masked interrupt status
         TXMIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Receive timeout masked interrupt status
         RTMIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Framing error masked interrupt status
         FEMIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Parity error masked interrupt status
         PEMIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Break error masked interrupt status
         BEMIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Overrun error masked interrupt status
         OEMIS : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
      end record
      with Volatile_Full_Access, Size => 32,
            Bit_Order => System.Low_Order_First;

      for UARTMIS_Register use record
         RIMMIS at 0 range 0 .. 0;
         CTSMMIS at 0 range 1 .. 1;
         DCDMMIS at 0 range 2 .. 2;
         DSRMMIS at 0 range 3 .. 3;
         RXMIS at 0 range 4 .. 4;
         TXMIS at 0 range 5 .. 5;
         RTMIS at 0 range 6 .. 6;
         FEMIS at 0 range 7 .. 7;
         PEMIS at 0 range 8 .. 8;
         BEMIS at 0 range 9 .. 9;
         OEMIS at 0 range 10 .. 10;
      end record;

      --  Interrupt Clear Register.
      type UARTICR_Register is record
         --  nUARTRI modem interrupt clear
         RIMMIC : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  nUARTCTS modem interrupt clear
         CTSMMIC : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  nUARTDCD modem interrupt clear
         DCDMMIC : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  nUARTDSR modem interrupt clear
         DSRMMIC : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Receive interrupt clear
         RXMIC : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Transmit interrupt clear
         TXMIC : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Receive timeout interrupt clear
         RTMIC : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Framing error interrupt clear
         FEMIC : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Parity error interrupt clear
         PEMIC : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Break error interrupt clear
         BEMIC : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Overrun error interrupt clear
         OEMIC : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
      end record
      with Volatile_Full_Access, Size => 32,
            Bit_Order => System.Low_Order_First;

      for UARTICR_Register use record
         RIMMIC at 0 range 0 .. 0;
         CTSMMIC at 0 range 1 .. 1;
         DCDMMIC at 0 range 2 .. 2;
         DSRMMIC at 0 range 3 .. 3;
         RXMIC at 0 range 4 .. 4;
         TXMIC at 0 range 5 .. 5;
         RTMIC at 0 range 6 .. 6;
         FEMIC at 0 range 7 .. 7;
         PEMIC at 0 range 8 .. 8;
         BEMIC at 0 range 9 .. 9;
            OEMIC at 0 range 10 .. 10;
      end record;

      --  DMA Control Register.
      type UARTDMACR_Register is record
         --  Receive DMA enable
         RXDMAE : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  Transmit DMA enable
         TXDMAE : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
         --  DMA on error
         DMAONERR : Bit_Sized_Integer_Types.Bit_Type := 16#0#;
      end record
      with Volatile_Full_Access, Size => 32,
            Bit_Order => System.Low_Order_First;

      for UARTDMACR_Register use record
         RXDMAE at 0 range 0 .. 0;
         TXDMAE at 0 range 1 .. 1;
         DMAONERR at 0 range 2 .. 2;
      end record;

      type UART_Peripheral is limited record
         UARTDR : aliased UARTDR_Register;
         UARTRSR : aliased UARTRSR_Register;
         UARTFR : aliased UARTFR_Register;
         UARTILPR : aliased UARTILPR_Register;
         UARTIBRD : aliased UARTIBRD_Register;
         UARTFBRD : aliased UARTFBRD_Register;
         UARTLCR_H : aliased UARTLCR_H_Register;
         UARTCR : aliased UARTCR_Register;
         UARTIFLS : aliased UARTIFLS_Register;
         UARTIMSC : aliased UARTIMSC_Register;
         UARTRIS : aliased UARTRIS_Register;
         UARTMIS : aliased UARTMIS_Register;
         UARTICR : aliased UARTICR_Register;
         UARTDMACR : aliased UARTDMACR_Register;
      end record
      with Volatile;

      for UART_Peripheral use record
         UARTDR at 16#0# range 0 .. 31;
         UARTRSR at 16#4# range 0 .. 31;
         UARTFR at 16#18# range 0 .. 31;
         UARTILPR at 16#20# range 0 .. 31;
         UARTIBRD at 16#24# range 0 .. 31;
         UARTFBRD at 16#28# range 0 .. 31;
         UARTLCR_H at 16#2c# range 0 .. 31;
         UARTCR at 16#30# range 0 .. 31;
         UARTIFLS at 16#34# range 0 .. 31;
         UARTIMSC at 16#38# range 0 .. 31;
         UARTRIS at 16#3c# range 0 .. 31;
         UARTMIS at 16#40# range 0 .. 31;
         UARTICR at 16#44# range 0 .. 31;
         UARTDMACR at 16#48# range 0 .. 31;
      end record;

      --
      --  UART peripheral instances
      --
      UART0_Periph : aliased UART_Peripheral
      with Import, Address => UART0_Base;

      UART1_Periph : aliased UART_Peripheral
      with Import, Address => UART1_Base;

      UART2_Periph : aliased UART_Peripheral
      with Import, Address => UART2_Base;

      UART3_Periph : aliased UART_Peripheral
      with Import, Address => UART3_Base;
   end UART;

   Baud_Rate : constant := 115_200;

   --------------
   -- Get_Char --
   --------------

   function Get_Char return Character is
      UARTFR_Value : UART.UARTFR_Register;
      UARTDR_Value : UART.UARTDR_Register;
   begin
      loop
         UARTFR_Value := UART.UART0_Periph.UARTFR;
         exit when UARTFR_Value.RXFE /= 0;
      end loop;

      UARTDR_Value := UART.UART0_Periph.UARTDR;
      return Character'Val (UARTDR_Value.DATA);
   end Get_Char;

   ------------------------
   -- Initialize_Rgb_Led --
   ------------------------

   procedure Initialize_Rgb_Led is
   begin
      SYS_LED_Periph := [others => 0];
   end Initialize_Rgb_Led;

   ---------------------
   -- Initialize_Uart --
   ---------------------

   procedure Initialize_Uart is
      procedure Calculate_Divisors (Baudrate : Interfaces.Unsigned_32;
                                    Integer_Div : out Interfaces.Unsigned_16;
                                    Fractional_Div : out Bit_Sized_Integer_Types.Six_Bits_Type) is
         --  64 * F_UARTCLK / (16 * Baudrate) = 4 * F_UARTCLK / Baudrate
         Divider : constant Interfaces.Unsigned_32 :=
            4 * UART.UART_Clock_Frequency_Hz / Baudrate;
      begin
         Integer_Div := Interfaces.Unsigned_16 (Interfaces.Shift_Left (Divider, 6) and 16#ffff#);
         Fractional_Div := Bit_Sized_Integer_Types.Six_Bits_Type (Divider and 2#111111#);
      end Calculate_Divisors;

      UARTIBRD_Value : UART.UARTIBRD_Register;
      UARTFBRD_Value : UART.UARTFBRD_Register;
      UARTLCR_H_Value : UART.UARTLCR_H_Register;
      UARTCR_Value : UART.UARTCR_Register;
      UARTIMSC_Value : UART.UARTIMSC_Register;
   begin
      --  Set baud rate:
      Calculate_Divisors (Baud_Rate, UARTIBRD_Value.BAUD_DIVINT, UARTFBRD_Value.BAUD_DIVFRAC);

      UART.UART0_Periph.UARTIBRD := UARTIBRD_Value;
      UART.UART0_Periph.UARTFBRD := UARTFBRD_Value;

      --  Configure data frame format to be 8-N-1 (8 data bits, no parity, 1 stop bit)
      UARTLCR_H_Value.WLEN := 2#11#;
      UARTLCR_H_Value.STP2 := 2#0#;
      UARTLCR_H_Value.PEN := 2#0#;
      UART.UART0_Periph.UARTLCR_H := UARTLCR_H_Value;

      --  Disable (mask) all interrupts:
      UARTIMSC_Value := (others => 2#1#);
      UART.UART0_Periph.UARTIMSC := UARTIMSC_Value;

      --  Enable UART Tx/Rx and UART peripheral itself:
      UARTCR_Value := UART.UART0_Periph.UARTCR;
      UARTCR_Value.TXE := 2#1#;
      UARTCR_Value.RXE := 2#1#;
      UARTCR_Value.UARTEN := 2#1#;
      UART.UART0_Periph.UARTCR := UARTCR_Value;
   end Initialize_Uart;

   ------------------
   -- Print_String --
   ------------------

   procedure Print_String (S : String; End_Line : Boolean := False) is
   begin
      for C of S loop
         Put_Char (C);
         if C = ASCII.LF then
            Put_Char (ASCII.CR);
         end if;
      end loop;

      if End_Line then
         Put_Char (ASCII.LF);
         Put_Char (ASCII.CR);
      end if;
   end Print_String;

   --------------------------
   -- Print_Number_Decimal --
   --------------------------

   procedure Print_Number_Decimal (Value : Unsigned_32;
                                   End_Line : Boolean := False)
   is
      Str : String (1 .. 10);
      Str_Len : Positive;
   begin
      Number_Conversion_Utils.Unsigned_To_Decimal_String (Value, Str, Str_Len);
      Print_String (Str (1 .. Str_Len), End_Line);
   end Print_Number_Decimal;

   ------------------------------
   -- Print_Number_Hexadecimal --
   ------------------------------

   procedure Print_Number_Hexadecimal (Value : Unsigned_32;
                                       End_Line : Boolean := False)
   is
      Str : String (1 .. 8);
   begin
      Number_Conversion_Utils.Unsigned_To_Hexadecimal_String (Value, Str);
      Print_String (Str, End_Line);
   end Print_Number_Hexadecimal;

   --------------
   -- Put_Char --
   --------------

   procedure Put_Char (C : Character) is
      UARTFR_Value : UART.UARTFR_Register;
      UARTDR_Value : UART.UARTDR_Register;
   begin
      loop
         UARTFR_Value := UART.UART0_Periph.UARTFR;
         exit when UARTFR_Value.TXFF = 0;
      end loop;

      UARTDR_Value.DATA := Interfaces.Unsigned_8 (Character'Pos (C));
      UART.UART0_Periph.UARTDR := UARTDR_Value;
   end Put_Char;

   -------------
   -- Set_Led --
   -------------

   procedure Set_Rgb_Led (Red_On, Green_On, Blue_On : Boolean := False) is
      SYS_LED_Value : Word_Bit_Array_Type;
   begin
      SYS_LED_Value := SYS_LED_Periph;
      SYS_LED_Value (0) := Boolean'Pos (Red_On);
      SYS_LED_Value (1) := Boolean'Pos (Green_On);
      SYS_LED_Value (2) := Boolean'Pos (Blue_On);
      SYS_LED_Periph := SYS_LED_Value;
   end Set_Rgb_Led;

end Low_Level_Debug;
