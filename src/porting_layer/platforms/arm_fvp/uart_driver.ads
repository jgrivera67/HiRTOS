--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary UART driver for ARM PL011
--
with HiRTOS_Cpu_Multi_Core_Interface;
with Bit_Sized_Integer_Types;
with Interfaces;
with System;

package Uart_Driver
   with No_Elaboration_Code_All
is
   use HiRTOS_Cpu_Multi_Core_Interface;

   procedure Initialize_Uart (Baud_Rate : Interfaces.Unsigned_32;
                              UART_Clock_Frequency_Hz : Interfaces.Unsigned_32);

   procedure Put_Char (C : Character);

   function Get_Char return Character;

private
   --
   --  Any peripherals in the memory range [0x0-0x7FFFFFFF] in the Base Platform
   --  are available at the same offset in the memory range [0x80000000-0xFFFFFFFF]
   --  in the BaseR Platform. 
   --
   UART0_Base : constant System.Address := System'To_Address (16#8000_0000# + 16#1C09_0000#);
   UART1_Base : constant System.Address := System'To_Address (16#8000_0000# + 16#1C0A_0000#);
   UART2_Base : constant System.Address := System'To_Address (16#8000_0000# + 16#1C0B_0000#);
   UART3_Base : constant System.Address := System'To_Address (16#8000_0000# + 16#1C0C_0000#);

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

   --
   --  Interrupt Mask Set/Clear Register.
   --
   --  NOTE: You can enable or disable the individual interrupts by changing
   --  the mask bits in the UARTIMSC register. Setting the appropriate mask
   --  bit HIGH enables the interrupt.
   --
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

   UART_Periph_Pointers : constant
      array (Valid_Cpu_Core_Id_Type) of access UART_Peripheral :=
      [ Valid_Cpu_Core_Id_Type'First => UART0_Periph'Access,
         Valid_Cpu_Core_Id_Type'First + 1 => UART1_Periph'Access,
         Valid_Cpu_Core_Id_Type'First + 2 => UART2_Periph'Access,
         Valid_Cpu_Core_Id_Type'First + 3 => UART3_Periph'Access ];

end Uart_Driver;
