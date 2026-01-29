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

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;

with System;

package MKL25Z4.I2C is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype A1_AD_Field is MKL25Z4.UInt7;

   --  I2C Address Register 1
   type I2C0_A1_Register is record
      --  unspecified
      Reserved_0_0 : MKL25Z4.Bit := 16#0#;
      --  Address
      AD           : A1_AD_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for I2C0_A1_Register use record
      Reserved_0_0 at 0 range 0 .. 0;
      AD           at 0 range 1 .. 7;
   end record;

   subtype F_ICR_Field is MKL25Z4.UInt6;

   --  The MULT bits define the multiplier factor mul
   type F_MULT_Field is
     (
      --  mul = 1
      F_MULT_Field_00,
      --  mul = 2
      F_MULT_Field_01,
      --  mul = 4
      F_MULT_Field_10)
     with Size => 2;
   for F_MULT_Field use
     (F_MULT_Field_00 => 0,
      F_MULT_Field_01 => 1,
      F_MULT_Field_10 => 2);

   --  I2C Frequency Divider register
   type I2C0_F_Register is record
      --  ClockRate
      ICR  : F_ICR_Field := 16#0#;
      --  The MULT bits define the multiplier factor mul
      MULT : F_MULT_Field := MKL25Z4.I2C.F_MULT_Field_00;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for I2C0_F_Register use record
      ICR  at 0 range 0 .. 5;
      MULT at 0 range 6 .. 7;
   end record;

   --  DMA Enable
   type C1_DMAEN_Field is
     (
      --  All DMA signalling disabled.
      C1_DMAEN_Field_0,
      --  DMA transfer is enabled and the following conditions trigger the DMA
      --  request: While FACK = 0, a data byte is received, either address or
      --  data is transmitted. (ACK/NACK automatic) While FACK = 0, the first
      --  byte received matches the A1 register or is general call address. If
      --  any address matching occurs, IAAS and TCF are set. If the direction
      --  of transfer is known from master to slave, then it is not required to
      --  check the SRW. With this assumption, DMA can also be used in this
      --  case. In other cases, if the master reads data from the slave, then
      --  it is required to rewrite the C1 register operation. With this
      --  assumption, DMA cannot be used. When FACK = 1, an address or a data
      --  byte is transmitted.
      C1_DMAEN_Field_1)
     with Size => 1;
   for C1_DMAEN_Field use
     (C1_DMAEN_Field_0 => 0,
      C1_DMAEN_Field_1 => 1);

   --  Wakeup Enable
   type C1_WUEN_Field is
     (
      --  Normal operation. No interrupt generated when address matching in low
      --  power mode.
      C1_WUEN_Field_0,
      --  Enables the wakeup function in low power mode.
      C1_WUEN_Field_1)
     with Size => 1;
   for C1_WUEN_Field use
     (C1_WUEN_Field_0 => 0,
      C1_WUEN_Field_1 => 1);

   subtype C1_RSTA_Field is MKL25Z4.Bit;

   --  Transmit Acknowledge Enable
   type C1_TXAK_Field is
     (
      --  An acknowledge signal is sent to the bus on the following receiving
      --  byte (if FACK is cleared) or the current receiving byte (if FACK is
      --  set).
      C1_TXAK_Field_0,
      --  No acknowledge signal is sent to the bus on the following receiving
      --  data byte (if FACK is cleared) or the current receiving data byte (if
      --  FACK is set).
      C1_TXAK_Field_1)
     with Size => 1;
   for C1_TXAK_Field use
     (C1_TXAK_Field_0 => 0,
      C1_TXAK_Field_1 => 1);

   --  Transmit Mode Select
   type C1_TX_Field is
     (
      --  Receive
      C1_TX_Field_0,
      --  Transmit
      C1_TX_Field_1)
     with Size => 1;
   for C1_TX_Field use
     (C1_TX_Field_0 => 0,
      C1_TX_Field_1 => 1);

   --  Master Mode Select
   type C1_MST_Field is
     (
      --  Slave mode
      C1_MST_Field_0,
      --  Master mode
      C1_MST_Field_1)
     with Size => 1;
   for C1_MST_Field use
     (C1_MST_Field_0 => 0,
      C1_MST_Field_1 => 1);

   --  I2C Interrupt Enable
   type C1_IICIE_Field is
     (
      --  Disabled
      C1_IICIE_Field_0,
      --  Enabled
      C1_IICIE_Field_1)
     with Size => 1;
   for C1_IICIE_Field use
     (C1_IICIE_Field_0 => 0,
      C1_IICIE_Field_1 => 1);

   --  I2C Enable
   type C1_IICEN_Field is
     (
      --  Disabled
      C1_IICEN_Field_0,
      --  Enabled
      C1_IICEN_Field_1)
     with Size => 1;
   for C1_IICEN_Field use
     (C1_IICEN_Field_0 => 0,
      C1_IICEN_Field_1 => 1);

   --  I2C Control Register 1
   type I2C0_C1_Register is record
      --  DMA Enable
      DMAEN : C1_DMAEN_Field := MKL25Z4.I2C.C1_DMAEN_Field_0;
      --  Wakeup Enable
      WUEN  : C1_WUEN_Field := MKL25Z4.I2C.C1_WUEN_Field_0;
      --  Write-only. Repeat START
      RSTA  : C1_RSTA_Field := 16#0#;
      --  Transmit Acknowledge Enable
      TXAK  : C1_TXAK_Field := MKL25Z4.I2C.C1_TXAK_Field_0;
      --  Transmit Mode Select
      TX    : C1_TX_Field := MKL25Z4.I2C.C1_TX_Field_0;
      --  Master Mode Select
      MST   : C1_MST_Field := MKL25Z4.I2C.C1_MST_Field_0;
      --  I2C Interrupt Enable
      IICIE : C1_IICIE_Field := MKL25Z4.I2C.C1_IICIE_Field_0;
      --  I2C Enable
      IICEN : C1_IICEN_Field := MKL25Z4.I2C.C1_IICEN_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for I2C0_C1_Register use record
      DMAEN at 0 range 0 .. 0;
      WUEN  at 0 range 1 .. 1;
      RSTA  at 0 range 2 .. 2;
      TXAK  at 0 range 3 .. 3;
      TX    at 0 range 4 .. 4;
      MST   at 0 range 5 .. 5;
      IICIE at 0 range 6 .. 6;
      IICEN at 0 range 7 .. 7;
   end record;

   --  Receive Acknowledge
   type S_RXAK_Field is
     (
      --  Acknowledge signal was received after the completion of one byte of
      --  data transmission on the bus
      S_RXAK_Field_0,
      --  No acknowledge signal detected
      S_RXAK_Field_1)
     with Size => 1;
   for S_RXAK_Field use
     (S_RXAK_Field_0 => 0,
      S_RXAK_Field_1 => 1);

   --  Interrupt Flag
   type S_IICIF_Field is
     (
      --  No interrupt pending
      S_IICIF_Field_0,
      --  Interrupt pending
      S_IICIF_Field_1)
     with Size => 1;
   for S_IICIF_Field use
     (S_IICIF_Field_0 => 0,
      S_IICIF_Field_1 => 1);

   --  Slave Read/Write
   type S_SRW_Field is
     (
      --  Slave receive, master writing to slave
      S_SRW_Field_0,
      --  Slave transmit, master reading from slave
      S_SRW_Field_1)
     with Size => 1;
   for S_SRW_Field use
     (S_SRW_Field_0 => 0,
      S_SRW_Field_1 => 1);

   --  Range Address Match
   type S_RAM_Field is
     (
      --  Not addressed
      S_RAM_Field_0,
      --  Addressed as a slave
      S_RAM_Field_1)
     with Size => 1;
   for S_RAM_Field use
     (S_RAM_Field_0 => 0,
      S_RAM_Field_1 => 1);

   --  Arbitration Lost
   type S_ARBL_Field is
     (
      --  Standard bus operation.
      S_ARBL_Field_0,
      --  Loss of arbitration.
      S_ARBL_Field_1)
     with Size => 1;
   for S_ARBL_Field use
     (S_ARBL_Field_0 => 0,
      S_ARBL_Field_1 => 1);

   --  Bus Busy
   type S_BUSY_Field is
     (
      --  Bus is idle
      S_BUSY_Field_0,
      --  Bus is busy
      S_BUSY_Field_1)
     with Size => 1;
   for S_BUSY_Field use
     (S_BUSY_Field_0 => 0,
      S_BUSY_Field_1 => 1);

   --  Addressed As A Slave
   type S_IAAS_Field is
     (
      --  Not addressed
      S_IAAS_Field_0,
      --  Addressed as a slave
      S_IAAS_Field_1)
     with Size => 1;
   for S_IAAS_Field use
     (S_IAAS_Field_0 => 0,
      S_IAAS_Field_1 => 1);

   --  Transfer Complete Flag
   type S_TCF_Field is
     (
      --  Transfer in progress
      S_TCF_Field_0,
      --  Transfer complete
      S_TCF_Field_1)
     with Size => 1;
   for S_TCF_Field use
     (S_TCF_Field_0 => 0,
      S_TCF_Field_1 => 1);

   --  I2C Status register
   type I2C0_S_Register is record
      --  Read-only. Receive Acknowledge
      RXAK  : S_RXAK_Field := MKL25Z4.I2C.S_RXAK_Field_0;
      --  Interrupt Flag
      IICIF : S_IICIF_Field := MKL25Z4.I2C.S_IICIF_Field_0;
      --  Read-only. Slave Read/Write
      SRW   : S_SRW_Field := MKL25Z4.I2C.S_SRW_Field_0;
      --  Range Address Match
      RAM   : S_RAM_Field := MKL25Z4.I2C.S_RAM_Field_0;
      --  Arbitration Lost
      ARBL  : S_ARBL_Field := MKL25Z4.I2C.S_ARBL_Field_0;
      --  Read-only. Bus Busy
      BUSY  : S_BUSY_Field := MKL25Z4.I2C.S_BUSY_Field_0;
      --  Addressed As A Slave
      IAAS  : S_IAAS_Field := MKL25Z4.I2C.S_IAAS_Field_0;
      --  Read-only. Transfer Complete Flag
      TCF   : S_TCF_Field := MKL25Z4.I2C.S_TCF_Field_1;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for I2C0_S_Register use record
      RXAK  at 0 range 0 .. 0;
      IICIF at 0 range 1 .. 1;
      SRW   at 0 range 2 .. 2;
      RAM   at 0 range 3 .. 3;
      ARBL  at 0 range 4 .. 4;
      BUSY  at 0 range 5 .. 5;
      IAAS  at 0 range 6 .. 6;
      TCF   at 0 range 7 .. 7;
   end record;

   subtype C2_AD_Field is MKL25Z4.UInt3;

   --  Range Address Matching Enable
   type C2_RMEN_Field is
     (
      --  Range mode disabled. No address match occurs for an address within
      --  the range of values of the A1 and RA registers.
      C2_RMEN_Field_0,
      --  Range mode enabled. Address matching occurs when a slave receives an
      --  address within the range of values of the A1 and RA registers.
      C2_RMEN_Field_1)
     with Size => 1;
   for C2_RMEN_Field use
     (C2_RMEN_Field_0 => 0,
      C2_RMEN_Field_1 => 1);

   --  Slave Baud Rate Control
   type C2_SBRC_Field is
     (
      --  The slave baud rate follows the master baud rate and clock stretching
      --  may occur
      C2_SBRC_Field_0,
      --  Slave baud rate is independent of the master baud rate
      C2_SBRC_Field_1)
     with Size => 1;
   for C2_SBRC_Field use
     (C2_SBRC_Field_0 => 0,
      C2_SBRC_Field_1 => 1);

   --  High Drive Select
   type C2_HDRS_Field is
     (
      --  Normal drive mode
      C2_HDRS_Field_0,
      --  High drive mode
      C2_HDRS_Field_1)
     with Size => 1;
   for C2_HDRS_Field use
     (C2_HDRS_Field_0 => 0,
      C2_HDRS_Field_1 => 1);

   --  Address Extension
   type C2_ADEXT_Field is
     (
      --  7-bit address scheme
      C2_ADEXT_Field_0,
      --  10-bit address scheme
      C2_ADEXT_Field_1)
     with Size => 1;
   for C2_ADEXT_Field use
     (C2_ADEXT_Field_0 => 0,
      C2_ADEXT_Field_1 => 1);

   --  General Call Address Enable
   type C2_GCAEN_Field is
     (
      --  Disabled
      C2_GCAEN_Field_0,
      --  Enabled
      C2_GCAEN_Field_1)
     with Size => 1;
   for C2_GCAEN_Field use
     (C2_GCAEN_Field_0 => 0,
      C2_GCAEN_Field_1 => 1);

   --  I2C Control Register 2
   type I2C0_C2_Register is record
      --  Slave Address
      AD    : C2_AD_Field := 16#0#;
      --  Range Address Matching Enable
      RMEN  : C2_RMEN_Field := MKL25Z4.I2C.C2_RMEN_Field_0;
      --  Slave Baud Rate Control
      SBRC  : C2_SBRC_Field := MKL25Z4.I2C.C2_SBRC_Field_0;
      --  High Drive Select
      HDRS  : C2_HDRS_Field := MKL25Z4.I2C.C2_HDRS_Field_0;
      --  Address Extension
      ADEXT : C2_ADEXT_Field := MKL25Z4.I2C.C2_ADEXT_Field_0;
      --  General Call Address Enable
      GCAEN : C2_GCAEN_Field := MKL25Z4.I2C.C2_GCAEN_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for I2C0_C2_Register use record
      AD    at 0 range 0 .. 2;
      RMEN  at 0 range 3 .. 3;
      SBRC  at 0 range 4 .. 4;
      HDRS  at 0 range 5 .. 5;
      ADEXT at 0 range 6 .. 6;
      GCAEN at 0 range 7 .. 7;
   end record;

   --  I2C Programmable Filter Factor
   type FLT_FLT_Field is
     (
      --  No filter/bypass
      FLT_FLT_Field_0)
     with Size => 5;
   for FLT_FLT_Field use
     (FLT_FLT_Field_0 => 0);

   --  I2C Bus Stop Interrupt Enable
   type FLT_STOPIE_Field is
     (
      --  Stop detection interrupt is disabled
      FLT_STOPIE_Field_0,
      --  Stop detection interrupt is enabled
      FLT_STOPIE_Field_1)
     with Size => 1;
   for FLT_STOPIE_Field use
     (FLT_STOPIE_Field_0 => 0,
      FLT_STOPIE_Field_1 => 1);

   --  I2C Bus Stop Detect Flag
   type FLT_STOPF_Field is
     (
      --  No stop happens on I2C bus
      FLT_STOPF_Field_0,
      --  Stop detected on I2C bus
      FLT_STOPF_Field_1)
     with Size => 1;
   for FLT_STOPF_Field use
     (FLT_STOPF_Field_0 => 0,
      FLT_STOPF_Field_1 => 1);

   --  Stop Hold Enable
   type FLT_SHEN_Field is
     (
      --  Stop holdoff is disabled. The MCU's entry to stop mode is not gated.
      FLT_SHEN_Field_0,
      --  Stop holdoff is enabled.
      FLT_SHEN_Field_1)
     with Size => 1;
   for FLT_SHEN_Field use
     (FLT_SHEN_Field_0 => 0,
      FLT_SHEN_Field_1 => 1);

   --  I2C Programmable Input Glitch Filter register
   type I2C0_FLT_Register is record
      --  I2C Programmable Filter Factor
      FLT    : FLT_FLT_Field := MKL25Z4.I2C.FLT_FLT_Field_0;
      --  I2C Bus Stop Interrupt Enable
      STOPIE : FLT_STOPIE_Field := MKL25Z4.I2C.FLT_STOPIE_Field_0;
      --  I2C Bus Stop Detect Flag
      STOPF  : FLT_STOPF_Field := MKL25Z4.I2C.FLT_STOPF_Field_0;
      --  Stop Hold Enable
      SHEN   : FLT_SHEN_Field := MKL25Z4.I2C.FLT_SHEN_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for I2C0_FLT_Register use record
      FLT    at 0 range 0 .. 4;
      STOPIE at 0 range 5 .. 5;
      STOPF  at 0 range 6 .. 6;
      SHEN   at 0 range 7 .. 7;
   end record;

   subtype RA_RAD_Field is MKL25Z4.UInt7;

   --  I2C Range Address register
   type I2C0_RA_Register is record
      --  unspecified
      Reserved_0_0 : MKL25Z4.Bit := 16#0#;
      --  Range Slave Address
      RAD          : RA_RAD_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for I2C0_RA_Register use record
      Reserved_0_0 at 0 range 0 .. 0;
      RAD          at 0 range 1 .. 7;
   end record;

   --  SHTF2 Interrupt Enable
   type SMB_SHTF2IE_Field is
     (
      --  SHTF2 interrupt is disabled
      SMB_SHTF2IE_Field_0,
      --  SHTF2 interrupt is enabled
      SMB_SHTF2IE_Field_1)
     with Size => 1;
   for SMB_SHTF2IE_Field use
     (SMB_SHTF2IE_Field_0 => 0,
      SMB_SHTF2IE_Field_1 => 1);

   --  SCL High Timeout Flag 2
   type SMB_SHTF2_Field is
     (
      --  No SCL high and SDA low timeout occurs
      SMB_SHTF2_Field_0,
      --  SCL high and SDA low timeout occurs
      SMB_SHTF2_Field_1)
     with Size => 1;
   for SMB_SHTF2_Field use
     (SMB_SHTF2_Field_0 => 0,
      SMB_SHTF2_Field_1 => 1);

   --  SCL High Timeout Flag 1
   type SMB_SHTF1_Field is
     (
      --  No SCL high and SDA high timeout occurs
      SMB_SHTF1_Field_0,
      --  SCL high and SDA high timeout occurs
      SMB_SHTF1_Field_1)
     with Size => 1;
   for SMB_SHTF1_Field use
     (SMB_SHTF1_Field_0 => 0,
      SMB_SHTF1_Field_1 => 1);

   --  SCL Low Timeout Flag
   type SMB_SLTF_Field is
     (
      --  No low timeout occurs
      SMB_SLTF_Field_0,
      --  Low timeout occurs
      SMB_SLTF_Field_1)
     with Size => 1;
   for SMB_SLTF_Field use
     (SMB_SLTF_Field_0 => 0,
      SMB_SLTF_Field_1 => 1);

   --  Timeout Counter Clock Select
   type SMB_TCKSEL_Field is
     (
      --  Timeout counter counts at the frequency of the bus clock / 64
      SMB_TCKSEL_Field_0,
      --  Timeout counter counts at the frequency of the bus clock
      SMB_TCKSEL_Field_1)
     with Size => 1;
   for SMB_TCKSEL_Field use
     (SMB_TCKSEL_Field_0 => 0,
      SMB_TCKSEL_Field_1 => 1);

   --  Second I2C Address Enable
   type SMB_SIICAEN_Field is
     (
      --  I2C address register 2 matching is disabled
      SMB_SIICAEN_Field_0,
      --  I2C address register 2 matching is enabled
      SMB_SIICAEN_Field_1)
     with Size => 1;
   for SMB_SIICAEN_Field use
     (SMB_SIICAEN_Field_0 => 0,
      SMB_SIICAEN_Field_1 => 1);

   --  SMBus Alert Response Address Enable
   type SMB_ALERTEN_Field is
     (
      --  SMBus alert response address matching is disabled
      SMB_ALERTEN_Field_0,
      --  SMBus alert response address matching is enabled
      SMB_ALERTEN_Field_1)
     with Size => 1;
   for SMB_ALERTEN_Field use
     (SMB_ALERTEN_Field_0 => 0,
      SMB_ALERTEN_Field_1 => 1);

   --  Fast NACK/ACK Enable
   type SMB_FACK_Field is
     (
      --  An ACK or NACK is sent on the following receiving data byte
      SMB_FACK_Field_0,
      --  Writing 0 to TXAK after receiving a data byte generates an ACK.
      --  Writing 1 to TXAK after receiving a data byte generates a NACK.
      SMB_FACK_Field_1)
     with Size => 1;
   for SMB_FACK_Field use
     (SMB_FACK_Field_0 => 0,
      SMB_FACK_Field_1 => 1);

   --  I2C SMBus Control and Status register
   type I2C0_SMB_Register is record
      --  SHTF2 Interrupt Enable
      SHTF2IE : SMB_SHTF2IE_Field := MKL25Z4.I2C.SMB_SHTF2IE_Field_0;
      --  SCL High Timeout Flag 2
      SHTF2   : SMB_SHTF2_Field := MKL25Z4.I2C.SMB_SHTF2_Field_0;
      --  Read-only. SCL High Timeout Flag 1
      SHTF1   : SMB_SHTF1_Field := MKL25Z4.I2C.SMB_SHTF1_Field_0;
      --  SCL Low Timeout Flag
      SLTF    : SMB_SLTF_Field := MKL25Z4.I2C.SMB_SLTF_Field_0;
      --  Timeout Counter Clock Select
      TCKSEL  : SMB_TCKSEL_Field := MKL25Z4.I2C.SMB_TCKSEL_Field_0;
      --  Second I2C Address Enable
      SIICAEN : SMB_SIICAEN_Field := MKL25Z4.I2C.SMB_SIICAEN_Field_0;
      --  SMBus Alert Response Address Enable
      ALERTEN : SMB_ALERTEN_Field := MKL25Z4.I2C.SMB_ALERTEN_Field_0;
      --  Fast NACK/ACK Enable
      FACK    : SMB_FACK_Field := MKL25Z4.I2C.SMB_FACK_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for I2C0_SMB_Register use record
      SHTF2IE at 0 range 0 .. 0;
      SHTF2   at 0 range 1 .. 1;
      SHTF1   at 0 range 2 .. 2;
      SLTF    at 0 range 3 .. 3;
      TCKSEL  at 0 range 4 .. 4;
      SIICAEN at 0 range 5 .. 5;
      ALERTEN at 0 range 6 .. 6;
      FACK    at 0 range 7 .. 7;
   end record;

   subtype A2_SAD_Field is MKL25Z4.UInt7;

   --  I2C Address Register 2
   type I2C0_A2_Register is record
      --  unspecified
      Reserved_0_0 : MKL25Z4.Bit := 16#0#;
      --  SMBus Address
      SAD          : A2_SAD_Field := 16#61#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for I2C0_A2_Register use record
      Reserved_0_0 at 0 range 0 .. 0;
      SAD          at 0 range 1 .. 7;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Inter-Integrated Circuit
   type I2C_Peripheral is record
      --  I2C Address Register 1
      A1   : I2C0_A1_Register;
      --  I2C Frequency Divider register
      F    : I2C0_F_Register;
      --  I2C Control Register 1
      C1   : I2C0_C1_Register;
      --  I2C Status register
      S    : I2C0_S_Register;
      --  I2C Data I/O register
      D    : MKL25Z4.Byte;
      --  I2C Control Register 2
      C2   : I2C0_C2_Register;
      --  I2C Programmable Input Glitch Filter register
      FLT  : I2C0_FLT_Register;
      --  I2C Range Address register
      RA   : I2C0_RA_Register;
      --  I2C SMBus Control and Status register
      SMB  : I2C0_SMB_Register;
      --  I2C Address Register 2
      A2   : I2C0_A2_Register;
      --  I2C SCL Low Timeout Register High
      SLTH : MKL25Z4.Byte;
      --  I2C SCL Low Timeout Register Low
      SLTL : MKL25Z4.Byte;
   end record
     with Volatile;

   for I2C_Peripheral use record
      A1   at 0 range 0 .. 7;
      F    at 1 range 0 .. 7;
      C1   at 2 range 0 .. 7;
      S    at 3 range 0 .. 7;
      D    at 4 range 0 .. 7;
      C2   at 5 range 0 .. 7;
      FLT  at 6 range 0 .. 7;
      RA   at 7 range 0 .. 7;
      SMB  at 8 range 0 .. 7;
      A2   at 9 range 0 .. 7;
      SLTH at 10 range 0 .. 7;
      SLTL at 11 range 0 .. 7;
   end record;

   --  Inter-Integrated Circuit
   I2C0_Periph : aliased I2C_Peripheral
     with Import, Address => I2C0_Base;

   --  Inter-Integrated Circuit
   I2C1_Periph : aliased I2C_Peripheral
     with Import, Address => I2C1_Base;

end MKL25Z4.I2C;
