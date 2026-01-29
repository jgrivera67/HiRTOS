--  Redistribution and use in source and binary forms, with or without modification,
--  are permitted provided that the following conditions are met:
--   o Redistributions of source code must retain the above copyright notice, this list
--   of conditions and the following disclaimer.
--   o Redistributions in binary form must reproduce the above copyright notice, this
--   list of conditions and the following disclaimer in the documentation and/or
--   other materials provided with the distribution.
--   o Neither the name of Freescale Semiconductor, Inc. nor the names of its
--   contributors may be used to endorse or promote products derived from this
--   software without specific prior written permission.
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
--   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
--   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--   DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
--   ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
--   (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
--   ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--  This spec has been automatically generated from MKL25Z4.svd

with System;

--  System Integration Module
package MKL25Z4.SIM is
   pragma SPARK_Mode (Off);

   ---------------
   -- Registers --
   ---------------

   --  32K oscillator clock select
   type SOPT1_OSC32KSEL_Field is
     (
      --  System oscillator (OSC32KCLK)
      SOPT1_OSC32KSEL_Field_00,
      --  RTC_CLKIN
      SOPT1_OSC32KSEL_Field_10,
      --  LPO 1kHz
      SOPT1_OSC32KSEL_Field_11)
     with Size => 2;
   for SOPT1_OSC32KSEL_Field use
     (SOPT1_OSC32KSEL_Field_00 => 0,
      SOPT1_OSC32KSEL_Field_10 => 2,
      SOPT1_OSC32KSEL_Field_11 => 3);

   --  USB voltage regulator in standby mode during VLPR and VLPW modes
   type SOPT1_USBVSTBY_Field is
     (
      --  USB voltage regulator not in standby during VLPR and VLPW modes.
      SOPT1_USBVSTBY_Field_0,
      --  USB voltage regulator in standby during VLPR and VLPW modes.
      SOPT1_USBVSTBY_Field_1)
     with Size => 1;
   for SOPT1_USBVSTBY_Field use
     (SOPT1_USBVSTBY_Field_0 => 0,
      SOPT1_USBVSTBY_Field_1 => 1);

   --  USB voltage regulator in standby mode during Stop, VLPS, LLS and VLLS
   --  modes.
   type SOPT1_USBSSTBY_Field is
     (
      --  USB voltage regulator not in standby during Stop, VLPS, LLS and VLLS
      --  modes.
      SOPT1_USBSSTBY_Field_0,
      --  USB voltage regulator in standby during Stop, VLPS, LLS and VLLS
      --  modes.
      SOPT1_USBSSTBY_Field_1)
     with Size => 1;
   for SOPT1_USBSSTBY_Field use
     (SOPT1_USBSSTBY_Field_0 => 0,
      SOPT1_USBSSTBY_Field_1 => 1);

   --  USB voltage regulator enable
   type SOPT1_USBREGEN_Field is
     (
      --  USB voltage regulator is disabled.
      SOPT1_USBREGEN_Field_0,
      --  USB voltage regulator is enabled.
      SOPT1_USBREGEN_Field_1)
     with Size => 1;
   for SOPT1_USBREGEN_Field use
     (SOPT1_USBREGEN_Field_0 => 0,
      SOPT1_USBREGEN_Field_1 => 1);

   --  System Options Register 1
   type SIM_SOPT1_Register is record
      --  unspecified
      Reserved_0_17  : MKL25Z4.UInt18 := 16#0#;
      --  32K oscillator clock select
      OSC32KSEL      : SOPT1_OSC32KSEL_Field :=
                        MKL25Z4.SIM.SOPT1_OSC32KSEL_Field_00;
      --  unspecified
      Reserved_20_28 : MKL25Z4.UInt9 := 16#0#;
      --  USB voltage regulator in standby mode during VLPR and VLPW modes
      USBVSTBY       : SOPT1_USBVSTBY_Field :=
                        MKL25Z4.SIM.SOPT1_USBVSTBY_Field_0;
      --  USB voltage regulator in standby mode during Stop, VLPS, LLS and VLLS
      --  modes.
      USBSSTBY       : SOPT1_USBSSTBY_Field :=
                        MKL25Z4.SIM.SOPT1_USBSSTBY_Field_0;
      --  USB voltage regulator enable
      USBREGEN       : SOPT1_USBREGEN_Field :=
                        MKL25Z4.SIM.SOPT1_USBREGEN_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_SOPT1_Register use record
      Reserved_0_17  at 0 range 0 .. 17;
      OSC32KSEL      at 0 range 18 .. 19;
      Reserved_20_28 at 0 range 20 .. 28;
      USBVSTBY       at 0 range 29 .. 29;
      USBSSTBY       at 0 range 30 .. 30;
      USBREGEN       at 0 range 31 .. 31;
   end record;

   --  USB voltage regulator enable write enable
   type SOPT1CFG_URWE_Field is
     (
      --  SOPT1 USBREGEN cannot be written.
      SOPT1CFG_URWE_Field_0,
      --  SOPT1 USBREGEN can be written.
      SOPT1CFG_URWE_Field_1)
     with Size => 1;
   for SOPT1CFG_URWE_Field use
     (SOPT1CFG_URWE_Field_0 => 0,
      SOPT1CFG_URWE_Field_1 => 1);

   --  USB voltage regulator VLP standby write enable
   type SOPT1CFG_UVSWE_Field is
     (
      --  SOPT1 USBVSTB cannot be written.
      SOPT1CFG_UVSWE_Field_0,
      --  SOPT1 USBVSTB can be written.
      SOPT1CFG_UVSWE_Field_1)
     with Size => 1;
   for SOPT1CFG_UVSWE_Field use
     (SOPT1CFG_UVSWE_Field_0 => 0,
      SOPT1CFG_UVSWE_Field_1 => 1);

   --  USB voltage regulator stop standby write enable
   type SOPT1CFG_USSWE_Field is
     (
      --  SOPT1 USBSSTB cannot be written.
      SOPT1CFG_USSWE_Field_0,
      --  SOPT1 USBSSTB can be written.
      SOPT1CFG_USSWE_Field_1)
     with Size => 1;
   for SOPT1CFG_USSWE_Field use
     (SOPT1CFG_USSWE_Field_0 => 0,
      SOPT1CFG_USSWE_Field_1 => 1);

   --  SOPT1 Configuration Register
   type SIM_SOPT1CFG_Register is record
      --  unspecified
      Reserved_0_23  : MKL25Z4.UInt24 := 16#0#;
      --  USB voltage regulator enable write enable
      URWE           : SOPT1CFG_URWE_Field :=
                        MKL25Z4.SIM.SOPT1CFG_URWE_Field_0;
      --  USB voltage regulator VLP standby write enable
      UVSWE          : SOPT1CFG_UVSWE_Field :=
                        MKL25Z4.SIM.SOPT1CFG_UVSWE_Field_0;
      --  USB voltage regulator stop standby write enable
      USSWE          : SOPT1CFG_USSWE_Field :=
                        MKL25Z4.SIM.SOPT1CFG_USSWE_Field_0;
      --  unspecified
      Reserved_27_31 : MKL25Z4.UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_SOPT1CFG_Register use record
      Reserved_0_23  at 0 range 0 .. 23;
      URWE           at 0 range 24 .. 24;
      UVSWE          at 0 range 25 .. 25;
      USSWE          at 0 range 26 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   --  RTC clock out select
   type SOPT2_RTCCLKOUTSEL_Field is
     (
      --  RTC 1 Hz clock is output on the RTC_CLKOUT pin.
      SOPT2_RTCCLKOUTSEL_Field_0,
      --  OSCERCLK clock is output on the RTC_CLKOUT pin.
      SOPT2_RTCCLKOUTSEL_Field_1)
     with Size => 1;
   for SOPT2_RTCCLKOUTSEL_Field use
     (SOPT2_RTCCLKOUTSEL_Field_0 => 0,
      SOPT2_RTCCLKOUTSEL_Field_1 => 1);

   --  CLKOUT select
   type SOPT2_CLKOUTSEL_Field is
     (
      --  Reset value for the field
      Sopt2_Clkoutsel_Field_Reset,
      --  Bus clock
      SOPT2_CLKOUTSEL_Field_010,
      --  LPO clock (1 kHz)
      SOPT2_CLKOUTSEL_Field_011,
      --  MCGIRCLK
      SOPT2_CLKOUTSEL_Field_100,
      --  OSCERCLK
      SOPT2_CLKOUTSEL_Field_110)
     with Size => 3;
   for SOPT2_CLKOUTSEL_Field use
     (Sopt2_Clkoutsel_Field_Reset => 0,
      SOPT2_CLKOUTSEL_Field_010 => 2,
      SOPT2_CLKOUTSEL_Field_011 => 3,
      SOPT2_CLKOUTSEL_Field_100 => 4,
      SOPT2_CLKOUTSEL_Field_110 => 6);

   --  PLL/FLL clock select
   type SOPT2_PLLFLLSEL_Field is
     (
      --  MCGFLLCLK clock
      SOPT2_PLLFLLSEL_Field_0,
      --  MCGPLLCLK clock with fixed divide by two
      SOPT2_PLLFLLSEL_Field_1)
     with Size => 1;
   for SOPT2_PLLFLLSEL_Field use
     (SOPT2_PLLFLLSEL_Field_0 => 0,
      SOPT2_PLLFLLSEL_Field_1 => 1);

   --  USB clock source select
   type SOPT2_USBSRC_Field is
     (
      --  External bypass clock (USB_CLKIN).
      SOPT2_USBSRC_Field_0,
      --  MCGPLLCLK/2 or MCGFLLCLK clock
      SOPT2_USBSRC_Field_1)
     with Size => 1;
   for SOPT2_USBSRC_Field use
     (SOPT2_USBSRC_Field_0 => 0,
      SOPT2_USBSRC_Field_1 => 1);

   --  TPM clock source select
   type SOPT2_TPMSRC_Field is
     (
      --  Clock disabled
      SOPT2_TPMSRC_Field_00,
      --  MCGFLLCLK clock or MCGPLLCLK/2
      SOPT2_TPMSRC_Field_01,
      --  OSCERCLK clock
      SOPT2_TPMSRC_Field_10,
      --  MCGIRCLK clock
      SOPT2_TPMSRC_Field_11)
     with Size => 2;
   for SOPT2_TPMSRC_Field use
     (SOPT2_TPMSRC_Field_00 => 0,
      SOPT2_TPMSRC_Field_01 => 1,
      SOPT2_TPMSRC_Field_10 => 2,
      SOPT2_TPMSRC_Field_11 => 3);

   --  UART0 clock source select
   type SOPT2_UART0SRC_Field is
     (
      --  Clock disabled
      SOPT2_UART0SRC_Field_00,
      --  MCGFLLCLK clock or MCGPLLCLK/2 clock
      SOPT2_UART0SRC_Field_01,
      --  OSCERCLK clock
      SOPT2_UART0SRC_Field_10,
      --  MCGIRCLK clock
      SOPT2_UART0SRC_Field_11)
     with Size => 2;
   for SOPT2_UART0SRC_Field use
     (SOPT2_UART0SRC_Field_00 => 0,
      SOPT2_UART0SRC_Field_01 => 1,
      SOPT2_UART0SRC_Field_10 => 2,
      SOPT2_UART0SRC_Field_11 => 3);

   --  System Options Register 2
   type SIM_SOPT2_Register is record
      --  unspecified
      Reserved_0_3   : MKL25Z4.UInt4 := 16#0#;
      --  RTC clock out select
      RTCCLKOUTSEL   : SOPT2_RTCCLKOUTSEL_Field :=
                        MKL25Z4.SIM.SOPT2_RTCCLKOUTSEL_Field_0;
      --  CLKOUT select
      CLKOUTSEL      : SOPT2_CLKOUTSEL_Field := Sopt2_Clkoutsel_Field_Reset;
      --  unspecified
      Reserved_8_15  : MKL25Z4.Byte := 16#0#;
      --  PLL/FLL clock select
      PLLFLLSEL      : SOPT2_PLLFLLSEL_Field :=
                        MKL25Z4.SIM.SOPT2_PLLFLLSEL_Field_0;
      --  unspecified
      Reserved_17_17 : MKL25Z4.Bit := 16#0#;
      --  USB clock source select
      USBSRC         : SOPT2_USBSRC_Field := MKL25Z4.SIM.SOPT2_USBSRC_Field_0;
      --  unspecified
      Reserved_19_23 : MKL25Z4.UInt5 := 16#0#;
      --  TPM clock source select
      TPMSRC         : SOPT2_TPMSRC_Field :=
                        MKL25Z4.SIM.SOPT2_TPMSRC_Field_00;
      --  UART0 clock source select
      UART0SRC       : SOPT2_UART0SRC_Field :=
                        MKL25Z4.SIM.SOPT2_UART0SRC_Field_00;
      --  unspecified
      Reserved_28_31 : MKL25Z4.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_SOPT2_Register use record
      Reserved_0_3   at 0 range 0 .. 3;
      RTCCLKOUTSEL   at 0 range 4 .. 4;
      CLKOUTSEL      at 0 range 5 .. 7;
      Reserved_8_15  at 0 range 8 .. 15;
      PLLFLLSEL      at 0 range 16 .. 16;
      Reserved_17_17 at 0 range 17 .. 17;
      USBSRC         at 0 range 18 .. 18;
      Reserved_19_23 at 0 range 19 .. 23;
      TPMSRC         at 0 range 24 .. 25;
      UART0SRC       at 0 range 26 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   --  TPM1 channel 0 input capture source select
   type SOPT4_TPM1CH0SRC_Field is
     (
      --  TPM1_CH0 signal
      SOPT4_TPM1CH0SRC_Field_0,
      --  CMP0 output
      SOPT4_TPM1CH0SRC_Field_1)
     with Size => 1;
   for SOPT4_TPM1CH0SRC_Field use
     (SOPT4_TPM1CH0SRC_Field_0 => 0,
      SOPT4_TPM1CH0SRC_Field_1 => 1);

   --  TPM2 channel 0 input capture source select
   type SOPT4_TPM2CH0SRC_Field is
     (
      --  TPM2_CH0 signal
      SOPT4_TPM2CH0SRC_Field_0,
      --  CMP0 output
      SOPT4_TPM2CH0SRC_Field_1)
     with Size => 1;
   for SOPT4_TPM2CH0SRC_Field use
     (SOPT4_TPM2CH0SRC_Field_0 => 0,
      SOPT4_TPM2CH0SRC_Field_1 => 1);

   --  TPM0 External Clock Pin Select
   type SOPT4_TPM0CLKSEL_Field is
     (
      --  TPM0 external clock driven by TPM_CLKIN0 pin.
      SOPT4_TPM0CLKSEL_Field_0,
      --  TPM0 external clock driven by TPM_CLKIN1 pin.
      SOPT4_TPM0CLKSEL_Field_1)
     with Size => 1;
   for SOPT4_TPM0CLKSEL_Field use
     (SOPT4_TPM0CLKSEL_Field_0 => 0,
      SOPT4_TPM0CLKSEL_Field_1 => 1);

   --  TPM1 External Clock Pin Select
   type SOPT4_TPM1CLKSEL_Field is
     (
      --  TPM1 external clock driven by TPM_CLKIN0 pin.
      SOPT4_TPM1CLKSEL_Field_0,
      --  TPM1 external clock driven by TPM_CLKIN1 pin.
      SOPT4_TPM1CLKSEL_Field_1)
     with Size => 1;
   for SOPT4_TPM1CLKSEL_Field use
     (SOPT4_TPM1CLKSEL_Field_0 => 0,
      SOPT4_TPM1CLKSEL_Field_1 => 1);

   --  TPM2 External Clock Pin Select
   type SOPT4_TPM2CLKSEL_Field is
     (
      --  TPM2 external clock driven by TPM_CLKIN0 pin.
      SOPT4_TPM2CLKSEL_Field_0,
      --  TPM2 external clock driven by TPM_CLKIN1 pin.
      SOPT4_TPM2CLKSEL_Field_1)
     with Size => 1;
   for SOPT4_TPM2CLKSEL_Field use
     (SOPT4_TPM2CLKSEL_Field_0 => 0,
      SOPT4_TPM2CLKSEL_Field_1 => 1);

   --  System Options Register 4
   type SIM_SOPT4_Register is record
      --  unspecified
      Reserved_0_17  : MKL25Z4.UInt18 := 16#0#;
      --  TPM1 channel 0 input capture source select
      TPM1CH0SRC     : SOPT4_TPM1CH0SRC_Field :=
                        MKL25Z4.SIM.SOPT4_TPM1CH0SRC_Field_0;
      --  unspecified
      Reserved_19_19 : MKL25Z4.Bit := 16#0#;
      --  TPM2 channel 0 input capture source select
      TPM2CH0SRC     : SOPT4_TPM2CH0SRC_Field :=
                        MKL25Z4.SIM.SOPT4_TPM2CH0SRC_Field_0;
      --  unspecified
      Reserved_21_23 : MKL25Z4.UInt3 := 16#0#;
      --  TPM0 External Clock Pin Select
      TPM0CLKSEL     : SOPT4_TPM0CLKSEL_Field :=
                        MKL25Z4.SIM.SOPT4_TPM0CLKSEL_Field_0;
      --  TPM1 External Clock Pin Select
      TPM1CLKSEL     : SOPT4_TPM1CLKSEL_Field :=
                        MKL25Z4.SIM.SOPT4_TPM1CLKSEL_Field_0;
      --  TPM2 External Clock Pin Select
      TPM2CLKSEL     : SOPT4_TPM2CLKSEL_Field :=
                        MKL25Z4.SIM.SOPT4_TPM2CLKSEL_Field_0;
      --  unspecified
      Reserved_27_31 : MKL25Z4.UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_SOPT4_Register use record
      Reserved_0_17  at 0 range 0 .. 17;
      TPM1CH0SRC     at 0 range 18 .. 18;
      Reserved_19_19 at 0 range 19 .. 19;
      TPM2CH0SRC     at 0 range 20 .. 20;
      Reserved_21_23 at 0 range 21 .. 23;
      TPM0CLKSEL     at 0 range 24 .. 24;
      TPM1CLKSEL     at 0 range 25 .. 25;
      TPM2CLKSEL     at 0 range 26 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   --  UART0 transmit data source select
   type SOPT5_UART0TXSRC_Field is
     (
      --  UART0_TX pin
      SOPT5_UART0TXSRC_Field_00,
      --  UART0_TX pin modulated with TPM1 channel 0 output
      SOPT5_UART0TXSRC_Field_01,
      --  UART0_TX pin modulated with TPM2 channel 0 output
      SOPT5_UART0TXSRC_Field_10)
     with Size => 2;
   for SOPT5_UART0TXSRC_Field use
     (SOPT5_UART0TXSRC_Field_00 => 0,
      SOPT5_UART0TXSRC_Field_01 => 1,
      SOPT5_UART0TXSRC_Field_10 => 2);

   --  UART0 receive data source select
   type SOPT5_UART0RXSRC_Field is
     (
      --  UART0_RX pin
      SOPT5_UART0RXSRC_Field_0,
      --  CMP0 output
      SOPT5_UART0RXSRC_Field_1)
     with Size => 1;
   for SOPT5_UART0RXSRC_Field use
     (SOPT5_UART0RXSRC_Field_0 => 0,
      SOPT5_UART0RXSRC_Field_1 => 1);

   --  UART1 transmit data source select
   type SOPT5_UART1TXSRC_Field is
     (
      --  UART1_TX pin
      SOPT5_UART1TXSRC_Field_00,
      --  UART1_TX pin modulated with TPM1 channel 0 output
      SOPT5_UART1TXSRC_Field_01,
      --  UART1_TX pin modulated with TPM2 channel 0 output
      SOPT5_UART1TXSRC_Field_10)
     with Size => 2;
   for SOPT5_UART1TXSRC_Field use
     (SOPT5_UART1TXSRC_Field_00 => 0,
      SOPT5_UART1TXSRC_Field_01 => 1,
      SOPT5_UART1TXSRC_Field_10 => 2);

   --  UART1 receive data source select
   type SOPT5_UART1RXSRC_Field is
     (
      --  UART1_RX pin
      SOPT5_UART1RXSRC_Field_0,
      --  CMP0 output
      SOPT5_UART1RXSRC_Field_1)
     with Size => 1;
   for SOPT5_UART1RXSRC_Field use
     (SOPT5_UART1RXSRC_Field_0 => 0,
      SOPT5_UART1RXSRC_Field_1 => 1);

   --  UART0 Open Drain Enable
   type SOPT5_UART0ODE_Field is
     (
      --  Open drain is disabled on UART0
      SOPT5_UART0ODE_Field_0,
      --  Open drain is enabled on UART0
      SOPT5_UART0ODE_Field_1)
     with Size => 1;
   for SOPT5_UART0ODE_Field use
     (SOPT5_UART0ODE_Field_0 => 0,
      SOPT5_UART0ODE_Field_1 => 1);

   --  UART1 Open Drain Enable
   type SOPT5_UART1ODE_Field is
     (
      --  Open drain is disabled on UART1
      SOPT5_UART1ODE_Field_0,
      --  Open drain is enabled on UART1
      SOPT5_UART1ODE_Field_1)
     with Size => 1;
   for SOPT5_UART1ODE_Field use
     (SOPT5_UART1ODE_Field_0 => 0,
      SOPT5_UART1ODE_Field_1 => 1);

   --  UART2 Open Drain Enable
   type SOPT5_UART2ODE_Field is
     (
      --  Open drain is disabled on UART2
      SOPT5_UART2ODE_Field_0,
      --  Open drain is enabled on UART2
      SOPT5_UART2ODE_Field_1)
     with Size => 1;
   for SOPT5_UART2ODE_Field use
     (SOPT5_UART2ODE_Field_0 => 0,
      SOPT5_UART2ODE_Field_1 => 1);

   --  System Options Register 5
   type SIM_SOPT5_Register is record
      --  UART0 transmit data source select
      UART0TXSRC     : SOPT5_UART0TXSRC_Field :=
                        MKL25Z4.SIM.SOPT5_UART0TXSRC_Field_00;
      --  UART0 receive data source select
      UART0RXSRC     : SOPT5_UART0RXSRC_Field :=
                        MKL25Z4.SIM.SOPT5_UART0RXSRC_Field_0;
      --  unspecified
      Reserved_3_3   : MKL25Z4.Bit := 16#0#;
      --  UART1 transmit data source select
      UART1TXSRC     : SOPT5_UART1TXSRC_Field :=
                        MKL25Z4.SIM.SOPT5_UART1TXSRC_Field_00;
      --  UART1 receive data source select
      UART1RXSRC     : SOPT5_UART1RXSRC_Field :=
                        MKL25Z4.SIM.SOPT5_UART1RXSRC_Field_0;
      --  unspecified
      Reserved_7_15  : MKL25Z4.UInt9 := 16#0#;
      --  UART0 Open Drain Enable
      UART0ODE       : SOPT5_UART0ODE_Field :=
                        MKL25Z4.SIM.SOPT5_UART0ODE_Field_0;
      --  UART1 Open Drain Enable
      UART1ODE       : SOPT5_UART1ODE_Field :=
                        MKL25Z4.SIM.SOPT5_UART1ODE_Field_0;
      --  UART2 Open Drain Enable
      UART2ODE       : SOPT5_UART2ODE_Field :=
                        MKL25Z4.SIM.SOPT5_UART2ODE_Field_0;
      --  unspecified
      Reserved_19_31 : MKL25Z4.UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_SOPT5_Register use record
      UART0TXSRC     at 0 range 0 .. 1;
      UART0RXSRC     at 0 range 2 .. 2;
      Reserved_3_3   at 0 range 3 .. 3;
      UART1TXSRC     at 0 range 4 .. 5;
      UART1RXSRC     at 0 range 6 .. 6;
      Reserved_7_15  at 0 range 7 .. 15;
      UART0ODE       at 0 range 16 .. 16;
      UART1ODE       at 0 range 17 .. 17;
      UART2ODE       at 0 range 18 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   --  ADC0 trigger select
   type SOPT7_ADC0TRGSEL_Field is
     (
      --  External trigger pin input (EXTRG_IN)
      SOPT7_ADC0TRGSEL_Field_0000,
      --  CMP0 output
      SOPT7_ADC0TRGSEL_Field_0001,
      --  PIT trigger 0
      SOPT7_ADC0TRGSEL_Field_0100,
      --  PIT trigger 1
      SOPT7_ADC0TRGSEL_Field_0101,
      --  TPM0 overflow
      SOPT7_ADC0TRGSEL_Field_1000,
      --  TPM1 overflow
      SOPT7_ADC0TRGSEL_Field_1001,
      --  TPM2 overflow
      SOPT7_ADC0TRGSEL_Field_1010,
      --  RTC alarm
      SOPT7_ADC0TRGSEL_Field_1100,
      --  RTC seconds
      SOPT7_ADC0TRGSEL_Field_1101,
      --  LPTMR0 trigger
      SOPT7_ADC0TRGSEL_Field_1110)
     with Size => 4;
   for SOPT7_ADC0TRGSEL_Field use
     (SOPT7_ADC0TRGSEL_Field_0000 => 0,
      SOPT7_ADC0TRGSEL_Field_0001 => 1,
      SOPT7_ADC0TRGSEL_Field_0100 => 4,
      SOPT7_ADC0TRGSEL_Field_0101 => 5,
      SOPT7_ADC0TRGSEL_Field_1000 => 8,
      SOPT7_ADC0TRGSEL_Field_1001 => 9,
      SOPT7_ADC0TRGSEL_Field_1010 => 10,
      SOPT7_ADC0TRGSEL_Field_1100 => 12,
      SOPT7_ADC0TRGSEL_Field_1101 => 13,
      SOPT7_ADC0TRGSEL_Field_1110 => 14);

   --  ADC0 pretrigger select
   type SOPT7_ADC0PRETRGSEL_Field is
     (
      --  Pre-trigger A
      SOPT7_ADC0PRETRGSEL_Field_0,
      --  Pre-trigger B
      SOPT7_ADC0PRETRGSEL_Field_1)
     with Size => 1;
   for SOPT7_ADC0PRETRGSEL_Field use
     (SOPT7_ADC0PRETRGSEL_Field_0 => 0,
      SOPT7_ADC0PRETRGSEL_Field_1 => 1);

   --  ADC0 alternate trigger enable
   type SOPT7_ADC0ALTTRGEN_Field is
     (
      --  TPM1 channel 0 (A) and channel 1 (B) triggers selected for ADC0.
      SOPT7_ADC0ALTTRGEN_Field_0,
      --  Alternate trigger selected for ADC0.
      SOPT7_ADC0ALTTRGEN_Field_1)
     with Size => 1;
   for SOPT7_ADC0ALTTRGEN_Field use
     (SOPT7_ADC0ALTTRGEN_Field_0 => 0,
      SOPT7_ADC0ALTTRGEN_Field_1 => 1);

   --  System Options Register 7
   type SIM_SOPT7_Register is record
      --  ADC0 trigger select
      ADC0TRGSEL    : SOPT7_ADC0TRGSEL_Field :=
                       MKL25Z4.SIM.SOPT7_ADC0TRGSEL_Field_0000;
      --  ADC0 pretrigger select
      ADC0PRETRGSEL : SOPT7_ADC0PRETRGSEL_Field :=
                       MKL25Z4.SIM.SOPT7_ADC0PRETRGSEL_Field_0;
      --  unspecified
      Reserved_5_6  : MKL25Z4.UInt2 := 16#0#;
      --  ADC0 alternate trigger enable
      ADC0ALTTRGEN  : SOPT7_ADC0ALTTRGEN_Field :=
                       MKL25Z4.SIM.SOPT7_ADC0ALTTRGEN_Field_0;
      --  unspecified
      Reserved_8_31 : MKL25Z4.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_SOPT7_Register use record
      ADC0TRGSEL    at 0 range 0 .. 3;
      ADC0PRETRGSEL at 0 range 4 .. 4;
      Reserved_5_6  at 0 range 5 .. 6;
      ADC0ALTTRGEN  at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Pincount identification
   type SDID_PINID_Field is
     (
      --  16-pin
      SDID_PINID_Field_0000,
      --  24-pin
      SDID_PINID_Field_0001,
      --  32-pin
      SDID_PINID_Field_0010,
      --  48-pin
      SDID_PINID_Field_0100,
      --  64-pin
      SDID_PINID_Field_0101,
      --  80-pin
      SDID_PINID_Field_0110,
      --  100-pin
      SDID_PINID_Field_1000)
     with Size => 4;
   for SDID_PINID_Field use
     (SDID_PINID_Field_0000 => 0,
      SDID_PINID_Field_0001 => 1,
      SDID_PINID_Field_0010 => 2,
      SDID_PINID_Field_0100 => 4,
      SDID_PINID_Field_0101 => 5,
      SDID_PINID_Field_0110 => 6,
      SDID_PINID_Field_1000 => 8);

   subtype SDID_DIEID_Field is MKL25Z4.UInt5;
   subtype SDID_REVID_Field is MKL25Z4.UInt4;

   --  System SRAM Size
   type SDID_SRAMSIZE_Field is
     (
      --  0.5 KB
      SDID_SRAMSIZE_Field_0000,
      --  1 KB
      SDID_SRAMSIZE_Field_0001,
      --  2 KB
      SDID_SRAMSIZE_Field_0010,
      --  4 KB
      SDID_SRAMSIZE_Field_0011,
      --  8 KB
      SDID_SRAMSIZE_Field_0100,
      --  16 KB
      SDID_SRAMSIZE_Field_0101,
      --  32 KB
      SDID_SRAMSIZE_Field_0110,
      --  64 KB
      SDID_SRAMSIZE_Field_0111)
     with Size => 4;
   for SDID_SRAMSIZE_Field use
     (SDID_SRAMSIZE_Field_0000 => 0,
      SDID_SRAMSIZE_Field_0001 => 1,
      SDID_SRAMSIZE_Field_0010 => 2,
      SDID_SRAMSIZE_Field_0011 => 3,
      SDID_SRAMSIZE_Field_0100 => 4,
      SDID_SRAMSIZE_Field_0101 => 5,
      SDID_SRAMSIZE_Field_0110 => 6,
      SDID_SRAMSIZE_Field_0111 => 7);

   --  Kinetis Series ID
   type SDID_SERIESID_Field is
     (
      --  KL family
      SDID_SERIESID_Field_0001)
     with Size => 4;
   for SDID_SERIESID_Field use
     (SDID_SERIESID_Field_0001 => 1);

   --  Kinetis Sub-Family ID
   type SDID_SUBFAMID_Field is
     (
      --  KLx2 Subfamily (low end)
      SDID_SUBFAMID_Field_0010,
      --  KLx4 Subfamily (basic analog)
      SDID_SUBFAMID_Field_0100,
      --  KLx5 Subfamily (advanced analog)
      SDID_SUBFAMID_Field_0101,
      --  KLx6 Subfamily (advanced analog with I2S)
      SDID_SUBFAMID_Field_0110)
     with Size => 4;
   for SDID_SUBFAMID_Field use
     (SDID_SUBFAMID_Field_0010 => 2,
      SDID_SUBFAMID_Field_0100 => 4,
      SDID_SUBFAMID_Field_0101 => 5,
      SDID_SUBFAMID_Field_0110 => 6);

   --  Kinetis family ID
   type SDID_FAMID_Field is
     (
      --  KL0x Family (low end)
      SDID_FAMID_Field_0000,
      --  KL1x Family (basic)
      SDID_FAMID_Field_0001,
      --  KL2x Family (USB)
      SDID_FAMID_Field_0010,
      --  KL3x Family (Segment LCD)
      SDID_FAMID_Field_0011,
      --  KL4x Family (USB and Segment LCD)
      SDID_FAMID_Field_0100)
     with Size => 4;
   for SDID_FAMID_Field use
     (SDID_FAMID_Field_0000 => 0,
      SDID_FAMID_Field_0001 => 1,
      SDID_FAMID_Field_0010 => 2,
      SDID_FAMID_Field_0011 => 3,
      SDID_FAMID_Field_0100 => 4);

   --  System Device Identification Register
   type SIM_SDID_Register is record
      --  Read-only. Pincount identification
      PINID        : SDID_PINID_Field;
      --  unspecified
      Reserved_4_6 : MKL25Z4.UInt3;
      --  Read-only. Device die number
      DIEID        : SDID_DIEID_Field;
      --  Read-only. Device revision number
      REVID        : SDID_REVID_Field;
      --  Read-only. System SRAM Size
      SRAMSIZE     : SDID_SRAMSIZE_Field;
      --  Read-only. Kinetis Series ID
      SERIESID     : SDID_SERIESID_Field;
      --  Read-only. Kinetis Sub-Family ID
      SUBFAMID     : SDID_SUBFAMID_Field;
      --  Read-only. Kinetis family ID
      FAMID        : SDID_FAMID_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_SDID_Register use record
      PINID        at 0 range 0 .. 3;
      Reserved_4_6 at 0 range 4 .. 6;
      DIEID        at 0 range 7 .. 11;
      REVID        at 0 range 12 .. 15;
      SRAMSIZE     at 0 range 16 .. 19;
      SERIESID     at 0 range 20 .. 23;
      SUBFAMID     at 0 range 24 .. 27;
      FAMID        at 0 range 28 .. 31;
   end record;

   --  I2C0 Clock Gate Control
   type SCGC4_I2C0_Field is
     (
      --  Clock disabled
      SCGC4_I2C0_Field_0,
      --  Clock enabled
      SCGC4_I2C0_Field_1)
     with Size => 1;
   for SCGC4_I2C0_Field use
     (SCGC4_I2C0_Field_0 => 0,
      SCGC4_I2C0_Field_1 => 1);

   ---------------
   -- SCGC4.I2C --
   ---------------

   --  SCGC4_I2C array
   type SCGC4_I2C_Field_Array is array (0 .. 1) of SCGC4_I2C0_Field
     with Component_Size => 1, Size => 2;

   --  Type definition for SCGC4_I2C
   type SCGC4_I2C_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  I2C as a value
            Val : MKL25Z4.UInt2;
         when True =>
            --  I2C as an array
            Arr : SCGC4_I2C_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for SCGC4_I2C_Field use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   --  UART0 Clock Gate Control
   type SCGC4_UART0_Field is
     (
      --  Clock disabled
      SCGC4_UART0_Field_0,
      --  Clock enabled
      SCGC4_UART0_Field_1)
     with Size => 1;
   for SCGC4_UART0_Field use
     (SCGC4_UART0_Field_0 => 0,
      SCGC4_UART0_Field_1 => 1);

   ----------------
   -- SCGC4.UART --
   ----------------

   --  SCGC4_UART array
   type SCGC4_UART_Field_Array is array (0 .. 2) of SCGC4_UART0_Field
     with Component_Size => 1, Size => 3;

   --  Type definition for SCGC4_UART
   type SCGC4_UART_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  UART as a value
            Val : MKL25Z4.UInt3;
         when True =>
            --  UART as an array
            Arr : SCGC4_UART_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 3;

   for SCGC4_UART_Field use record
      Val at 0 range 0 .. 2;
      Arr at 0 range 0 .. 2;
   end record;

   --  USB Clock Gate Control
   type SCGC4_USBOTG_Field is
     (
      --  Clock disabled
      SCGC4_USBOTG_Field_0,
      --  Clock enabled
      SCGC4_USBOTG_Field_1)
     with Size => 1;
   for SCGC4_USBOTG_Field use
     (SCGC4_USBOTG_Field_0 => 0,
      SCGC4_USBOTG_Field_1 => 1);

   --  Comparator Clock Gate Control
   type SCGC4_CMP_Field is
     (
      --  Clock disabled
      SCGC4_CMP_Field_0,
      --  Clock enabled
      SCGC4_CMP_Field_1)
     with Size => 1;
   for SCGC4_CMP_Field use
     (SCGC4_CMP_Field_0 => 0,
      SCGC4_CMP_Field_1 => 1);

   --  SPI0 Clock Gate Control
   type SCGC4_SPI0_Field is
     (
      --  Clock disabled
      SCGC4_SPI0_Field_0,
      --  Clock enabled
      SCGC4_SPI0_Field_1)
     with Size => 1;
   for SCGC4_SPI0_Field use
     (SCGC4_SPI0_Field_0 => 0,
      SCGC4_SPI0_Field_1 => 1);

   ---------------
   -- SCGC4.SPI --
   ---------------

   --  SCGC4_SPI array
   type SCGC4_SPI_Field_Array is array (0 .. 1) of SCGC4_SPI0_Field
     with Component_Size => 1, Size => 2;

   --  Type definition for SCGC4_SPI
   type SCGC4_SPI_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  SPI as a value
            Val : MKL25Z4.UInt2;
         when True =>
            --  SPI as an array
            Arr : SCGC4_SPI_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for SCGC4_SPI_Field use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   --  System Clock Gating Control Register 4
   type SIM_SCGC4_Register is record
      --  unspecified
      Reserved_0_5   : MKL25Z4.UInt6 := 16#30#;
      --  I2C0 Clock Gate Control
      I2C            : SCGC4_I2C_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_8_9   : MKL25Z4.UInt2 := 16#0#;
      --  UART0 Clock Gate Control
      UART           : SCGC4_UART_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_13_17 : MKL25Z4.UInt5 := 16#0#;
      --  USB Clock Gate Control
      USBOTG         : SCGC4_USBOTG_Field := MKL25Z4.SIM.SCGC4_USBOTG_Field_0;
      --  Comparator Clock Gate Control
      CMP            : SCGC4_CMP_Field := MKL25Z4.SIM.SCGC4_CMP_Field_0;
      --  unspecified
      Reserved_20_21 : MKL25Z4.UInt2 := 16#0#;
      --  SPI0 Clock Gate Control
      SPI            : SCGC4_SPI_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_24_31 : MKL25Z4.Byte := 16#F0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_SCGC4_Register use record
      Reserved_0_5   at 0 range 0 .. 5;
      I2C            at 0 range 6 .. 7;
      Reserved_8_9   at 0 range 8 .. 9;
      UART           at 0 range 10 .. 12;
      Reserved_13_17 at 0 range 13 .. 17;
      USBOTG         at 0 range 18 .. 18;
      CMP            at 0 range 19 .. 19;
      Reserved_20_21 at 0 range 20 .. 21;
      SPI            at 0 range 22 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   --  Low Power Timer Access Control
   type SCGC5_LPTMR_Field is
     (
      --  Access disabled
      SCGC5_LPTMR_Field_0,
      --  Access enabled
      SCGC5_LPTMR_Field_1)
     with Size => 1;
   for SCGC5_LPTMR_Field use
     (SCGC5_LPTMR_Field_0 => 0,
      SCGC5_LPTMR_Field_1 => 1);

   --  TSI Access Control
   type SCGC5_TSI_Field is
     (
      --  Access disabled
      SCGC5_TSI_Field_0,
      --  Access enabled
      SCGC5_TSI_Field_1)
     with Size => 1;
   for SCGC5_TSI_Field use
     (SCGC5_TSI_Field_0 => 0,
      SCGC5_TSI_Field_1 => 1);

   --  Port A Clock Gate Control
   type SCGC5_PORTA_Field is
     (
      --  Clock disabled
      SCGC5_PORTA_Field_0,
      --  Clock enabled
      SCGC5_PORTA_Field_1)
     with Size => 1;
   for SCGC5_PORTA_Field use
     (SCGC5_PORTA_Field_0 => 0,
      SCGC5_PORTA_Field_1 => 1);

   --  Port B Clock Gate Control
   type SCGC5_PORTB_Field is
     (
      --  Clock disabled
      SCGC5_PORTB_Field_0,
      --  Clock enabled
      SCGC5_PORTB_Field_1)
     with Size => 1;
   for SCGC5_PORTB_Field use
     (SCGC5_PORTB_Field_0 => 0,
      SCGC5_PORTB_Field_1 => 1);

   --  Port C Clock Gate Control
   type SCGC5_PORTC_Field is
     (
      --  Clock disabled
      SCGC5_PORTC_Field_0,
      --  Clock enabled
      SCGC5_PORTC_Field_1)
     with Size => 1;
   for SCGC5_PORTC_Field use
     (SCGC5_PORTC_Field_0 => 0,
      SCGC5_PORTC_Field_1 => 1);

   --  Port D Clock Gate Control
   type SCGC5_PORTD_Field is
     (
      --  Clock disabled
      SCGC5_PORTD_Field_0,
      --  Clock enabled
      SCGC5_PORTD_Field_1)
     with Size => 1;
   for SCGC5_PORTD_Field use
     (SCGC5_PORTD_Field_0 => 0,
      SCGC5_PORTD_Field_1 => 1);

   --  Port E Clock Gate Control
   type SCGC5_PORTE_Field is
     (
      --  Clock disabled
      SCGC5_PORTE_Field_0,
      --  Clock enabled
      SCGC5_PORTE_Field_1)
     with Size => 1;
   for SCGC5_PORTE_Field use
     (SCGC5_PORTE_Field_0 => 0,
      SCGC5_PORTE_Field_1 => 1);

   --  System Clock Gating Control Register 5
   type SIM_SCGC5_Register is record
      --  Low Power Timer Access Control
      LPTMR          : SCGC5_LPTMR_Field := MKL25Z4.SIM.SCGC5_LPTMR_Field_0;
      --  unspecified
      Reserved_1_4   : MKL25Z4.UInt4 := 16#0#;
      --  TSI Access Control
      TSI            : SCGC5_TSI_Field := MKL25Z4.SIM.SCGC5_TSI_Field_0;
      --  unspecified
      Reserved_6_8   : MKL25Z4.UInt3 := 16#6#;
      --  Port A Clock Gate Control
      PORTA          : SCGC5_PORTA_Field := MKL25Z4.SIM.SCGC5_PORTA_Field_0;
      --  Port B Clock Gate Control
      PORTB          : SCGC5_PORTB_Field := MKL25Z4.SIM.SCGC5_PORTB_Field_0;
      --  Port C Clock Gate Control
      PORTC          : SCGC5_PORTC_Field := MKL25Z4.SIM.SCGC5_PORTC_Field_0;
      --  Port D Clock Gate Control
      PORTD          : SCGC5_PORTD_Field := MKL25Z4.SIM.SCGC5_PORTD_Field_0;
      --  Port E Clock Gate Control
      PORTE          : SCGC5_PORTE_Field := MKL25Z4.SIM.SCGC5_PORTE_Field_0;
      --  unspecified
      Reserved_14_31 : MKL25Z4.UInt18 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_SCGC5_Register use record
      LPTMR          at 0 range 0 .. 0;
      Reserved_1_4   at 0 range 1 .. 4;
      TSI            at 0 range 5 .. 5;
      Reserved_6_8   at 0 range 6 .. 8;
      PORTA          at 0 range 9 .. 9;
      PORTB          at 0 range 10 .. 10;
      PORTC          at 0 range 11 .. 11;
      PORTD          at 0 range 12 .. 12;
      PORTE          at 0 range 13 .. 13;
      Reserved_14_31 at 0 range 14 .. 31;
   end record;

   --  Flash Memory Clock Gate Control
   type SCGC6_FTF_Field is
     (
      --  Clock disabled
      SCGC6_FTF_Field_0,
      --  Clock enabled
      SCGC6_FTF_Field_1)
     with Size => 1;
   for SCGC6_FTF_Field use
     (SCGC6_FTF_Field_0 => 0,
      SCGC6_FTF_Field_1 => 1);

   --  DMA Mux Clock Gate Control
   type SCGC6_DMAMUX_Field is
     (
      --  Clock disabled
      SCGC6_DMAMUX_Field_0,
      --  Clock enabled
      SCGC6_DMAMUX_Field_1)
     with Size => 1;
   for SCGC6_DMAMUX_Field use
     (SCGC6_DMAMUX_Field_0 => 0,
      SCGC6_DMAMUX_Field_1 => 1);

   --  PIT Clock Gate Control
   type SCGC6_PIT_Field is
     (
      --  Clock disabled
      SCGC6_PIT_Field_0,
      --  Clock enabled
      SCGC6_PIT_Field_1)
     with Size => 1;
   for SCGC6_PIT_Field use
     (SCGC6_PIT_Field_0 => 0,
      SCGC6_PIT_Field_1 => 1);

   --  TPM0 Clock Gate Control
   type SCGC6_TPM0_Field is
     (
      --  Clock disabled
      SCGC6_TPM0_Field_0,
      --  Clock enabled
      SCGC6_TPM0_Field_1)
     with Size => 1;
   for SCGC6_TPM0_Field use
     (SCGC6_TPM0_Field_0 => 0,
      SCGC6_TPM0_Field_1 => 1);

   ---------------
   -- SCGC6.TPM --
   ---------------

   --  SCGC6_TPM array
   type SCGC6_TPM_Field_Array is array (0 .. 2) of SCGC6_TPM0_Field
     with Component_Size => 1, Size => 3;

   --  Type definition for SCGC6_TPM
   type SCGC6_TPM_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  TPM as a value
            Val : MKL25Z4.UInt3;
         when True =>
            --  TPM as an array
            Arr : SCGC6_TPM_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 3;

   for SCGC6_TPM_Field use record
      Val at 0 range 0 .. 2;
      Arr at 0 range 0 .. 2;
   end record;

   --  ADC0 Clock Gate Control
   type SCGC6_ADC0_Field is
     (
      --  Clock disabled
      SCGC6_ADC0_Field_0,
      --  Clock enabled
      SCGC6_ADC0_Field_1)
     with Size => 1;
   for SCGC6_ADC0_Field use
     (SCGC6_ADC0_Field_0 => 0,
      SCGC6_ADC0_Field_1 => 1);

   --  RTC Access Control
   type SCGC6_RTC_Field is
     (
      --  Access and interrupts disabled
      SCGC6_RTC_Field_0,
      --  Access and interrupts enabled
      SCGC6_RTC_Field_1)
     with Size => 1;
   for SCGC6_RTC_Field use
     (SCGC6_RTC_Field_0 => 0,
      SCGC6_RTC_Field_1 => 1);

   --  DAC0 Clock Gate Control
   type SCGC6_DAC0_Field is
     (
      --  Clock disabled
      SCGC6_DAC0_Field_0,
      --  Clock enabled
      SCGC6_DAC0_Field_1)
     with Size => 1;
   for SCGC6_DAC0_Field use
     (SCGC6_DAC0_Field_0 => 0,
      SCGC6_DAC0_Field_1 => 1);

   --  System Clock Gating Control Register 6
   type SIM_SCGC6_Register is record
      --  Flash Memory Clock Gate Control
      FTF            : SCGC6_FTF_Field := MKL25Z4.SIM.SCGC6_FTF_Field_1;
      --  DMA Mux Clock Gate Control
      DMAMUX         : SCGC6_DMAMUX_Field := MKL25Z4.SIM.SCGC6_DMAMUX_Field_0;
      --  unspecified
      Reserved_2_22  : MKL25Z4.UInt21 := 16#0#;
      --  PIT Clock Gate Control
      PIT            : SCGC6_PIT_Field := MKL25Z4.SIM.SCGC6_PIT_Field_0;
      --  TPM0 Clock Gate Control
      TPM            : SCGC6_TPM_Field := (As_Array => False, Val => 16#0#);
      --  ADC0 Clock Gate Control
      ADC0           : SCGC6_ADC0_Field := MKL25Z4.SIM.SCGC6_ADC0_Field_0;
      --  unspecified
      Reserved_28_28 : MKL25Z4.Bit := 16#0#;
      --  RTC Access Control
      RTC            : SCGC6_RTC_Field := MKL25Z4.SIM.SCGC6_RTC_Field_0;
      --  unspecified
      Reserved_30_30 : MKL25Z4.Bit := 16#0#;
      --  DAC0 Clock Gate Control
      DAC0           : SCGC6_DAC0_Field := MKL25Z4.SIM.SCGC6_DAC0_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_SCGC6_Register use record
      FTF            at 0 range 0 .. 0;
      DMAMUX         at 0 range 1 .. 1;
      Reserved_2_22  at 0 range 2 .. 22;
      PIT            at 0 range 23 .. 23;
      TPM            at 0 range 24 .. 26;
      ADC0           at 0 range 27 .. 27;
      Reserved_28_28 at 0 range 28 .. 28;
      RTC            at 0 range 29 .. 29;
      Reserved_30_30 at 0 range 30 .. 30;
      DAC0           at 0 range 31 .. 31;
   end record;

   --  DMA Clock Gate Control
   type SCGC7_DMA_Field is
     (
      --  Clock disabled
      SCGC7_DMA_Field_0,
      --  Clock enabled
      SCGC7_DMA_Field_1)
     with Size => 1;
   for SCGC7_DMA_Field use
     (SCGC7_DMA_Field_0 => 0,
      SCGC7_DMA_Field_1 => 1);

   --  System Clock Gating Control Register 7
   type SIM_SCGC7_Register is record
      --  unspecified
      Reserved_0_7  : MKL25Z4.Byte := 16#0#;
      --  DMA Clock Gate Control
      DMA           : SCGC7_DMA_Field := MKL25Z4.SIM.SCGC7_DMA_Field_1;
      --  unspecified
      Reserved_9_31 : MKL25Z4.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_SCGC7_Register use record
      Reserved_0_7  at 0 range 0 .. 7;
      DMA           at 0 range 8 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   --  Clock 4 output divider value
   type CLKDIV1_OUTDIV4_Field is
     (
      --  Divide-by-1.
      CLKDIV1_OUTDIV4_Field_000,
      --  Divide-by-2.
      CLKDIV1_OUTDIV4_Field_001,
      --  Divide-by-3.
      CLKDIV1_OUTDIV4_Field_010,
      --  Divide-by-4.
      CLKDIV1_OUTDIV4_Field_011,
      --  Divide-by-5.
      CLKDIV1_OUTDIV4_Field_100,
      --  Divide-by-6.
      CLKDIV1_OUTDIV4_Field_101,
      --  Divide-by-7.
      CLKDIV1_OUTDIV4_Field_110,
      --  Divide-by-8.
      CLKDIV1_OUTDIV4_Field_111)
     with Size => 3;
   for CLKDIV1_OUTDIV4_Field use
     (CLKDIV1_OUTDIV4_Field_000 => 0,
      CLKDIV1_OUTDIV4_Field_001 => 1,
      CLKDIV1_OUTDIV4_Field_010 => 2,
      CLKDIV1_OUTDIV4_Field_011 => 3,
      CLKDIV1_OUTDIV4_Field_100 => 4,
      CLKDIV1_OUTDIV4_Field_101 => 5,
      CLKDIV1_OUTDIV4_Field_110 => 6,
      CLKDIV1_OUTDIV4_Field_111 => 7);

   --  Clock 1 output divider value
   type CLKDIV1_OUTDIV1_Field is
     (
      --  Divide-by-1.
      CLKDIV1_OUTDIV1_Field_0000,
      --  Divide-by-2.
      CLKDIV1_OUTDIV1_Field_0001,
      --  Divide-by-3.
      CLKDIV1_OUTDIV1_Field_0010,
      --  Divide-by-4.
      CLKDIV1_OUTDIV1_Field_0011,
      --  Divide-by-5.
      CLKDIV1_OUTDIV1_Field_0100,
      --  Divide-by-6.
      CLKDIV1_OUTDIV1_Field_0101,
      --  Divide-by-7.
      CLKDIV1_OUTDIV1_Field_0110,
      --  Divide-by-8.
      CLKDIV1_OUTDIV1_Field_0111,
      --  Divide-by-9.
      CLKDIV1_OUTDIV1_Field_1000,
      --  Divide-by-10.
      CLKDIV1_OUTDIV1_Field_1001,
      --  Divide-by-11.
      CLKDIV1_OUTDIV1_Field_1010,
      --  Divide-by-12.
      CLKDIV1_OUTDIV1_Field_1011,
      --  Divide-by-13.
      CLKDIV1_OUTDIV1_Field_1100,
      --  Divide-by-14.
      CLKDIV1_OUTDIV1_Field_1101,
      --  Divide-by-15.
      CLKDIV1_OUTDIV1_Field_1110,
      --  Divide-by-16.
      CLKDIV1_OUTDIV1_Field_1111)
     with Size => 4;
   for CLKDIV1_OUTDIV1_Field use
     (CLKDIV1_OUTDIV1_Field_0000 => 0,
      CLKDIV1_OUTDIV1_Field_0001 => 1,
      CLKDIV1_OUTDIV1_Field_0010 => 2,
      CLKDIV1_OUTDIV1_Field_0011 => 3,
      CLKDIV1_OUTDIV1_Field_0100 => 4,
      CLKDIV1_OUTDIV1_Field_0101 => 5,
      CLKDIV1_OUTDIV1_Field_0110 => 6,
      CLKDIV1_OUTDIV1_Field_0111 => 7,
      CLKDIV1_OUTDIV1_Field_1000 => 8,
      CLKDIV1_OUTDIV1_Field_1001 => 9,
      CLKDIV1_OUTDIV1_Field_1010 => 10,
      CLKDIV1_OUTDIV1_Field_1011 => 11,
      CLKDIV1_OUTDIV1_Field_1100 => 12,
      CLKDIV1_OUTDIV1_Field_1101 => 13,
      CLKDIV1_OUTDIV1_Field_1110 => 14,
      CLKDIV1_OUTDIV1_Field_1111 => 15);

   --  System Clock Divider Register 1
   type SIM_CLKDIV1_Register is record
      --  unspecified
      Reserved_0_15  : MKL25Z4.Short := 16#0#;
      --  Clock 4 output divider value
      OUTDIV4        : CLKDIV1_OUTDIV4_Field :=
                        MKL25Z4.SIM.CLKDIV1_OUTDIV4_Field_001;
      --  unspecified
      Reserved_19_27 : MKL25Z4.UInt9 := 16#0#;
      --  Clock 1 output divider value
      OUTDIV1        : CLKDIV1_OUTDIV1_Field :=
                        MKL25Z4.SIM.CLKDIV1_OUTDIV1_Field_0000;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_CLKDIV1_Register use record
      Reserved_0_15  at 0 range 0 .. 15;
      OUTDIV4        at 0 range 16 .. 18;
      Reserved_19_27 at 0 range 19 .. 27;
      OUTDIV1        at 0 range 28 .. 31;
   end record;

   --  Flash Disable
   type FCFG1_FLASHDIS_Field is
     (
      --  Flash is enabled
      FCFG1_FLASHDIS_Field_0,
      --  Flash is disabled
      FCFG1_FLASHDIS_Field_1)
     with Size => 1;
   for FCFG1_FLASHDIS_Field use
     (FCFG1_FLASHDIS_Field_0 => 0,
      FCFG1_FLASHDIS_Field_1 => 1);

   --  Flash Doze
   type FCFG1_FLASHDOZE_Field is
     (
      --  Flash remains enabled during Doze mode
      FCFG1_FLASHDOZE_Field_0,
      --  Flash is disabled for the duration of Doze mode
      FCFG1_FLASHDOZE_Field_1)
     with Size => 1;
   for FCFG1_FLASHDOZE_Field use
     (FCFG1_FLASHDOZE_Field_0 => 0,
      FCFG1_FLASHDOZE_Field_1 => 1);

   --  Program flash size
   type FCFG1_PFSIZE_Field is
     (
      --  8 KB of program flash memory, 0.25 KB protection region
      FCFG1_PFSIZE_Field_0000,
      --  16 KB of program flash memory, 0.5 KB protection region
      FCFG1_PFSIZE_Field_0001,
      --  32 KB of program flash memory, 1 KB protection region
      FCFG1_PFSIZE_Field_0011,
      --  64 KB of program flash memory, 2 KB protection region
      FCFG1_PFSIZE_Field_0101,
      --  128 KB of program flash memory, 4 KB protection region
      FCFG1_PFSIZE_Field_0111,
      --  256 KB of program flash memory, 8 KB protection region
      FCFG1_PFSIZE_Field_1001,
      --  128 KB of program flash memory, 4 KB protection region
      FCFG1_PFSIZE_Field_1111)
     with Size => 4;
   for FCFG1_PFSIZE_Field use
     (FCFG1_PFSIZE_Field_0000 => 0,
      FCFG1_PFSIZE_Field_0001 => 1,
      FCFG1_PFSIZE_Field_0011 => 3,
      FCFG1_PFSIZE_Field_0101 => 5,
      FCFG1_PFSIZE_Field_0111 => 7,
      FCFG1_PFSIZE_Field_1001 => 9,
      FCFG1_PFSIZE_Field_1111 => 15);

   --  Flash Configuration Register 1
   type SIM_FCFG1_Register is record
      --  Flash Disable
      FLASHDIS       : FCFG1_FLASHDIS_Field :=
                        MKL25Z4.SIM.FCFG1_FLASHDIS_Field_0;
      --  Flash Doze
      FLASHDOZE      : FCFG1_FLASHDOZE_Field :=
                        MKL25Z4.SIM.FCFG1_FLASHDOZE_Field_0;
      --  unspecified
      Reserved_2_23  : MKL25Z4.UInt22 := 16#0#;
      --  Read-only. Program flash size
      PFSIZE         : FCFG1_PFSIZE_Field :=
                        MKL25Z4.SIM.FCFG1_PFSIZE_Field_1111;
      --  unspecified
      Reserved_28_31 : MKL25Z4.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_FCFG1_Register use record
      FLASHDIS       at 0 range 0 .. 0;
      FLASHDOZE      at 0 range 1 .. 1;
      Reserved_2_23  at 0 range 2 .. 23;
      PFSIZE         at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   subtype FCFG2_MAXADDR0_Field is MKL25Z4.UInt7;

   --  Flash Configuration Register 2
   type SIM_FCFG2_Register is record
      --  unspecified
      Reserved_0_23  : MKL25Z4.UInt24;
      --  Read-only. Max address block
      MAXADDR0       : FCFG2_MAXADDR0_Field;
      --  unspecified
      Reserved_31_31 : MKL25Z4.Bit;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_FCFG2_Register use record
      Reserved_0_23  at 0 range 0 .. 23;
      MAXADDR0       at 0 range 24 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   subtype UIDMH_UID_Field is MKL25Z4.Short;

   --  Unique Identification Register Mid-High
   type SIM_UIDMH_Register is record
      --  Read-only. Unique Identification
      UID            : UIDMH_UID_Field;
      --  unspecified
      Reserved_16_31 : MKL25Z4.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_UIDMH_Register use record
      UID            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  COP windowed mode
   type COPC_COPW_Field is
     (
      --  Normal mode
      COPC_COPW_Field_0,
      --  Windowed mode
      COPC_COPW_Field_1)
     with Size => 1;
   for COPC_COPW_Field use
     (COPC_COPW_Field_0 => 0,
      COPC_COPW_Field_1 => 1);

   --  COP Clock Select
   type COPC_COPCLKS_Field is
     (
      --  Internal 1 kHz clock is source to COP
      COPC_COPCLKS_Field_0,
      --  Bus clock is source to COP
      COPC_COPCLKS_Field_1)
     with Size => 1;
   for COPC_COPCLKS_Field use
     (COPC_COPCLKS_Field_0 => 0,
      COPC_COPCLKS_Field_1 => 1);

   --  COP Watchdog Timeout
   type COPC_COPT_Field is
     (
      --  COP disabled
      COPC_COPT_Field_00,
      --  COP timeout after 2^5 LPO cycles or 213 bus clock cycles
      COPC_COPT_Field_01,
      --  COP timeout after 2^8 LPO cycles or 216 bus clock cycles
      COPC_COPT_Field_10,
      --  COP timeout after 2^10 LPO cycles or 218 bus clock cycles
      COPC_COPT_Field_11)
     with Size => 2;
   for COPC_COPT_Field use
     (COPC_COPT_Field_00 => 0,
      COPC_COPT_Field_01 => 1,
      COPC_COPT_Field_10 => 2,
      COPC_COPT_Field_11 => 3);

   --  COP Control Register
   type SIM_COPC_Register is record
      --  COP windowed mode
      COPW          : COPC_COPW_Field := MKL25Z4.SIM.COPC_COPW_Field_0;
      --  COP Clock Select
      COPCLKS       : COPC_COPCLKS_Field := MKL25Z4.SIM.COPC_COPCLKS_Field_0;
      --  COP Watchdog Timeout
      COPT          : COPC_COPT_Field := MKL25Z4.SIM.COPC_COPT_Field_11;
      --  unspecified
      Reserved_4_31 : MKL25Z4.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_COPC_Register use record
      COPW          at 0 range 0 .. 0;
      COPCLKS       at 0 range 1 .. 1;
      COPT          at 0 range 2 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype SRVCOP_SRVCOP_Field is MKL25Z4.Byte;

   --  Service COP Register
   type SIM_SRVCOP_Register is record
      --  Write-only. Sevice COP Register
      SRVCOP        : SRVCOP_SRVCOP_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : MKL25Z4.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_SRVCOP_Register use record
      SRVCOP        at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  System Integration Module
   type SIM_Peripheral is record
      --  System Options Register 1
      SOPT1    : SIM_SOPT1_Register;
      --  SOPT1 Configuration Register
      SOPT1CFG : SIM_SOPT1CFG_Register;
      --  System Options Register 2
      SOPT2    : SIM_SOPT2_Register;
      --  System Options Register 4
      SOPT4    : SIM_SOPT4_Register;
      --  System Options Register 5
      SOPT5    : SIM_SOPT5_Register;
      --  System Options Register 7
      SOPT7    : SIM_SOPT7_Register;
      --  System Device Identification Register
      SDID     : SIM_SDID_Register;
      --  System Clock Gating Control Register 4
      SCGC4    : SIM_SCGC4_Register;
      --  System Clock Gating Control Register 5
      SCGC5    : SIM_SCGC5_Register;
      --  System Clock Gating Control Register 6
      SCGC6    : SIM_SCGC6_Register;
      --  System Clock Gating Control Register 7
      SCGC7    : SIM_SCGC7_Register;
      --  System Clock Divider Register 1
      CLKDIV1  : SIM_CLKDIV1_Register;
      --  Flash Configuration Register 1
      FCFG1    : SIM_FCFG1_Register;
      --  Flash Configuration Register 2
      FCFG2    : SIM_FCFG2_Register;
      --  Unique Identification Register Mid-High
      UIDMH    : SIM_UIDMH_Register;
      --  Unique Identification Register Mid Low
      UIDML    : MKL25Z4.Word;
      --  Unique Identification Register Low
      UIDL     : MKL25Z4.Word;
      --  COP Control Register
      COPC     : SIM_COPC_Register;
      --  Service COP Register
      SRVCOP   : SIM_SRVCOP_Register;
   end record
     with Volatile;

   for SIM_Peripheral use record
      SOPT1    at 0 range 0 .. 31;
      SOPT1CFG at 4 range 0 .. 31;
      SOPT2    at 4100 range 0 .. 31;
      SOPT4    at 4108 range 0 .. 31;
      SOPT5    at 4112 range 0 .. 31;
      SOPT7    at 4120 range 0 .. 31;
      SDID     at 4132 range 0 .. 31;
      SCGC4    at 4148 range 0 .. 31;
      SCGC5    at 4152 range 0 .. 31;
      SCGC6    at 4156 range 0 .. 31;
      SCGC7    at 4160 range 0 .. 31;
      CLKDIV1  at 4164 range 0 .. 31;
      FCFG1    at 4172 range 0 .. 31;
      FCFG2    at 4176 range 0 .. 31;
      UIDMH    at 4184 range 0 .. 31;
      UIDML    at 4188 range 0 .. 31;
      UIDL     at 4192 range 0 .. 31;
      COPC     at 4352 range 0 .. 31;
      SRVCOP   at 4356 range 0 .. 31;
   end record;

   --  System Integration Module
   SIM_Periph : aliased SIM_Peripheral
     with Import, Address => SIM_Base;

end MKL25Z4.SIM;
