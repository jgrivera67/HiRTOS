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

package MKL25Z4.SPI with No_Elaboration_Code_All is

   ---------------
   -- Registers --
   ---------------

   --  LSB first (shifter direction)
   type C1_LSBFE_Field is
     (
      --  SPI serial data transfers start with most significant bit
      C1_LSBFE_Field_0,
      --  SPI serial data transfers start with least significant bit
      C1_LSBFE_Field_1)
     with Size => 1;
   for C1_LSBFE_Field use
     (C1_LSBFE_Field_0 => 0,
      C1_LSBFE_Field_1 => 1);

   --  Slave select output enable
   type C1_SSOE_Field is
     (
      --  When MODFEN is 0: In master mode, SS pin function is general-purpose
      --  I/O (not SPI). In slave mode, SS pin function is slave select input.
      --  When MODFEN is 1: In master mode, SS pin function is SS input for
      --  mode fault. In slave mode, SS pin function is slave select input.
      C1_SSOE_Field_0,
      --  When MODFEN is 0: In master mode, SS pin function is general-purpose
      --  I/O (not SPI). In slave mode, SS pin function is slave select input.
      --  When MODFEN is 1: In master mode, SS pin function is automatic SS
      --  output. In slave mode: SS pin function is slave select input.
      C1_SSOE_Field_1)
     with Size => 1;
   for C1_SSOE_Field use
     (C1_SSOE_Field_0 => 0,
      C1_SSOE_Field_1 => 1);

   --  Clock phase
   type C1_CPHA_Field is
     (
      --  First edge on SPSCK occurs at the middle of the first cycle of a data
      --  transfer
      C1_CPHA_Field_0,
      --  First edge on SPSCK occurs at the start of the first cycle of a data
      --  transfer
      C1_CPHA_Field_1)
     with Size => 1;
   for C1_CPHA_Field use
     (C1_CPHA_Field_0 => 0,
      C1_CPHA_Field_1 => 1);

   --  Clock polarity
   type C1_CPOL_Field is
     (
      --  Active-high SPI clock (idles low)
      C1_CPOL_Field_0,
      --  Active-low SPI clock (idles high)
      C1_CPOL_Field_1)
     with Size => 1;
   for C1_CPOL_Field use
     (C1_CPOL_Field_0 => 0,
      C1_CPOL_Field_1 => 1);

   --  Master/slave mode select
   type C1_MSTR_Field is
     (
      --  SPI module configured as a slave SPI device
      C1_MSTR_Field_0,
      --  SPI module configured as a master SPI device
      C1_MSTR_Field_1)
     with Size => 1;
   for C1_MSTR_Field use
     (C1_MSTR_Field_0 => 0,
      C1_MSTR_Field_1 => 1);

   --  SPI transmit interrupt enable
   type C1_SPTIE_Field is
     (
      --  Interrupts from SPTEF inhibited (use polling)
      C1_SPTIE_Field_0,
      --  When SPTEF is 1, hardware interrupt requested
      C1_SPTIE_Field_1)
     with Size => 1;
   for C1_SPTIE_Field use
     (C1_SPTIE_Field_0 => 0,
      C1_SPTIE_Field_1 => 1);

   --  SPI system enable
   type C1_SPE_Field is
     (
      --  SPI system inactive
      C1_SPE_Field_0,
      --  SPI system enabled
      C1_SPE_Field_1)
     with Size => 1;
   for C1_SPE_Field use
     (C1_SPE_Field_0 => 0,
      C1_SPE_Field_1 => 1);

   --  SPI interrupt enable: for SPRF and MODF
   type C1_SPIE_Field is
     (
      --  Interrupts from SPRF and MODF are inhibited-use polling
      C1_SPIE_Field_0,
      --  Request a hardware interrupt when SPRF or MODF is 1
      C1_SPIE_Field_1)
     with Size => 1;
   for C1_SPIE_Field use
     (C1_SPIE_Field_0 => 0,
      C1_SPIE_Field_1 => 1);

   --  SPI control register 1
   type SPI0_C1_Register is record
      --  LSB first (shifter direction)
      LSBFE : C1_LSBFE_Field := MKL25Z4.SPI.C1_LSBFE_Field_0;
      --  Slave select output enable
      SSOE  : C1_SSOE_Field := MKL25Z4.SPI.C1_SSOE_Field_0;
      --  Clock phase
      CPHA  : C1_CPHA_Field := MKL25Z4.SPI.C1_CPHA_Field_1;
      --  Clock polarity
      CPOL  : C1_CPOL_Field := MKL25Z4.SPI.C1_CPOL_Field_0;
      --  Master/slave mode select
      MSTR  : C1_MSTR_Field := MKL25Z4.SPI.C1_MSTR_Field_0;
      --  SPI transmit interrupt enable
      SPTIE : C1_SPTIE_Field := MKL25Z4.SPI.C1_SPTIE_Field_0;
      --  SPI system enable
      SPE   : C1_SPE_Field := MKL25Z4.SPI.C1_SPE_Field_0;
      --  SPI interrupt enable: for SPRF and MODF
      SPIE  : C1_SPIE_Field := MKL25Z4.SPI.C1_SPIE_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for SPI0_C1_Register use record
      LSBFE at 0 range 0 .. 0;
      SSOE  at 0 range 1 .. 1;
      CPHA  at 0 range 2 .. 2;
      CPOL  at 0 range 3 .. 3;
      MSTR  at 0 range 4 .. 4;
      SPTIE at 0 range 5 .. 5;
      SPE   at 0 range 6 .. 6;
      SPIE  at 0 range 7 .. 7;
   end record;

   --  SPI pin control 0
   type C2_SPC0_Field is
     (
      --  SPI uses separate pins for data input and data output (pin mode is
      --  normal). In master mode of operation: MISO is master in and MOSI is
      --  master out. In slave mode of operation: MISO is slave out and MOSI is
      --  slave in.
      C2_SPC0_Field_0,
      --  SPI configured for single-wire bidirectional operation (pin mode is
      --  bidirectional). In master mode of operation: MISO is not used by SPI;
      --  MOSI is master in when BIDIROE is 0 or master I/O when BIDIROE is 1.
      --  In slave mode of operation: MISO is slave in when BIDIROE is 0 or
      --  slave I/O when BIDIROE is 1; MOSI is not used by SPI.
      C2_SPC0_Field_1)
     with Size => 1;
   for C2_SPC0_Field use
     (C2_SPC0_Field_0 => 0,
      C2_SPC0_Field_1 => 1);

   --  SPI stop in wait mode
   type C2_SPISWAI_Field is
     (
      --  SPI clocks continue to operate in wait mode
      C2_SPISWAI_Field_0,
      --  SPI clocks stop when the MCU enters wait mode
      C2_SPISWAI_Field_1)
     with Size => 1;
   for C2_SPISWAI_Field use
     (C2_SPISWAI_Field_0 => 0,
      C2_SPISWAI_Field_1 => 1);

   --  Receive DMA enable
   type C2_RXDMAE_Field is
     (
      --  DMA request for receive is disabled and interrupt from SPRF is
      --  allowed
      C2_RXDMAE_Field_0,
      --  DMA request for receive is enabled and interrupt from SPRF is
      --  disabled
      C2_RXDMAE_Field_1)
     with Size => 1;
   for C2_RXDMAE_Field use
     (C2_RXDMAE_Field_0 => 0,
      C2_RXDMAE_Field_1 => 1);

   --  Bidirectional mode output enable
   type C2_BIDIROE_Field is
     (
      --  Output driver disabled so SPI data I/O pin acts as an input
      C2_BIDIROE_Field_0,
      --  SPI I/O pin enabled as an output
      C2_BIDIROE_Field_1)
     with Size => 1;
   for C2_BIDIROE_Field use
     (C2_BIDIROE_Field_0 => 0,
      C2_BIDIROE_Field_1 => 1);

   --  Master mode-fault function enable
   type C2_MODFEN_Field is
     (
      --  Mode fault function disabled, master SS pin reverts to
      --  general-purpose I/O not controlled by SPI
      C2_MODFEN_Field_0,
      --  Mode fault function enabled, master SS pin acts as the mode fault
      --  input or the slave select output
      C2_MODFEN_Field_1)
     with Size => 1;
   for C2_MODFEN_Field use
     (C2_MODFEN_Field_0 => 0,
      C2_MODFEN_Field_1 => 1);

   --  Transmit DMA enable
   type C2_TXDMAE_Field is
     (
      --  DMA request for transmit is disabled and interrupt from SPTEF is
      --  allowed
      C2_TXDMAE_Field_0,
      --  DMA request for transmit is enabled and interrupt from SPTEF is
      --  disabled
      C2_TXDMAE_Field_1)
     with Size => 1;
   for C2_TXDMAE_Field use
     (C2_TXDMAE_Field_0 => 0,
      C2_TXDMAE_Field_1 => 1);

   --  SPI match interrupt enable
   type C2_SPMIE_Field is
     (
      --  Interrupts from SPMF inhibited (use polling)
      C2_SPMIE_Field_0,
      --  When SPMF is 1, requests a hardware interrupt
      C2_SPMIE_Field_1)
     with Size => 1;
   for C2_SPMIE_Field use
     (C2_SPMIE_Field_0 => 0,
      C2_SPMIE_Field_1 => 1);

   --  SPI control register 2
   type SPI0_C2_Register is record
      --  SPI pin control 0
      SPC0         : C2_SPC0_Field := MKL25Z4.SPI.C2_SPC0_Field_0;
      --  SPI stop in wait mode
      SPISWAI      : C2_SPISWAI_Field := MKL25Z4.SPI.C2_SPISWAI_Field_0;
      --  Receive DMA enable
      RXDMAE       : C2_RXDMAE_Field := MKL25Z4.SPI.C2_RXDMAE_Field_0;
      --  Bidirectional mode output enable
      BIDIROE      : C2_BIDIROE_Field := MKL25Z4.SPI.C2_BIDIROE_Field_0;
      --  Master mode-fault function enable
      MODFEN       : C2_MODFEN_Field := MKL25Z4.SPI.C2_MODFEN_Field_0;
      --  Transmit DMA enable
      TXDMAE       : C2_TXDMAE_Field := MKL25Z4.SPI.C2_TXDMAE_Field_0;
      --  unspecified
      Reserved_6_6 : MKL25Z4.Bit := 16#0#;
      --  SPI match interrupt enable
      SPMIE        : C2_SPMIE_Field := MKL25Z4.SPI.C2_SPMIE_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for SPI0_C2_Register use record
      SPC0         at 0 range 0 .. 0;
      SPISWAI      at 0 range 1 .. 1;
      RXDMAE       at 0 range 2 .. 2;
      BIDIROE      at 0 range 3 .. 3;
      MODFEN       at 0 range 4 .. 4;
      TXDMAE       at 0 range 5 .. 5;
      Reserved_6_6 at 0 range 6 .. 6;
      SPMIE        at 0 range 7 .. 7;
   end record;

   --  SPI baud rate divisor
   type BR_SPR_Field is
     (
      --  Baud rate divisor is 2
      BR_SPR_Field_0000,
      --  Baud rate divisor is 4
      BR_SPR_Field_0001,
      --  Baud rate divisor is 8
      BR_SPR_Field_0010,
      --  Baud rate divisor is 16
      BR_SPR_Field_0011,
      --  Baud rate divisor is 32
      BR_SPR_Field_0100,
      --  Baud rate divisor is 64
      BR_SPR_Field_0101,
      --  Baud rate divisor is 128
      BR_SPR_Field_0110,
      --  Baud rate divisor is 256
      BR_SPR_Field_0111,
      --  Baud rate divisor is 512
      BR_SPR_Field_1000)
     with Size => 4;
   for BR_SPR_Field use
     (BR_SPR_Field_0000 => 0,
      BR_SPR_Field_0001 => 1,
      BR_SPR_Field_0010 => 2,
      BR_SPR_Field_0011 => 3,
      BR_SPR_Field_0100 => 4,
      BR_SPR_Field_0101 => 5,
      BR_SPR_Field_0110 => 6,
      BR_SPR_Field_0111 => 7,
      BR_SPR_Field_1000 => 8);

   --  SPI baud rate prescale divisor
   type BR_SPPR_Field is
     (
      --  Baud rate prescaler divisor is 1
      BR_SPPR_Field_000,
      --  Baud rate prescaler divisor is 2
      BR_SPPR_Field_001,
      --  Baud rate prescaler divisor is 3
      BR_SPPR_Field_010,
      --  Baud rate prescaler divisor is 4
      BR_SPPR_Field_011,
      --  Baud rate prescaler divisor is 5
      BR_SPPR_Field_100,
      --  Baud rate prescaler divisor is 6
      BR_SPPR_Field_101,
      --  Baud rate prescaler divisor is 7
      BR_SPPR_Field_110,
      --  Baud rate prescaler divisor is 8
      BR_SPPR_Field_111)
     with Size => 3;
   for BR_SPPR_Field use
     (BR_SPPR_Field_000 => 0,
      BR_SPPR_Field_001 => 1,
      BR_SPPR_Field_010 => 2,
      BR_SPPR_Field_011 => 3,
      BR_SPPR_Field_100 => 4,
      BR_SPPR_Field_101 => 5,
      BR_SPPR_Field_110 => 6,
      BR_SPPR_Field_111 => 7);

   --  SPI baud rate register
   type SPI0_BR_Register is record
      --  SPI baud rate divisor
      SPR          : BR_SPR_Field := MKL25Z4.SPI.BR_SPR_Field_0000;
      --  SPI baud rate prescale divisor
      SPPR         : BR_SPPR_Field := MKL25Z4.SPI.BR_SPPR_Field_000;
      --  unspecified
      Reserved_7_7 : MKL25Z4.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for SPI0_BR_Register use record
      SPR          at 0 range 0 .. 3;
      SPPR         at 0 range 4 .. 6;
      Reserved_7_7 at 0 range 7 .. 7;
   end record;

   --  Master mode fault flag
   type S_MODF_Field is
     (
      --  No mode fault error
      S_MODF_Field_0,
      --  Mode fault error detected
      S_MODF_Field_1)
     with Size => 1;
   for S_MODF_Field use
     (S_MODF_Field_0 => 0,
      S_MODF_Field_1 => 1);

   --  SPI transmit buffer empty flag
   type S_SPTEF_Field is
     (
      --  SPI transmit buffer not empty
      S_SPTEF_Field_0,
      --  SPI transmit buffer empty
      S_SPTEF_Field_1)
     with Size => 1;
   for S_SPTEF_Field use
     (S_SPTEF_Field_0 => 0,
      S_SPTEF_Field_1 => 1);

   --  SPI match flag
   type S_SPMF_Field is
     (
      --  Value in the receive data buffer does not match the value in the M
      --  register
      S_SPMF_Field_0,
      --  Value in the receive data buffer matches the value in the M register
      S_SPMF_Field_1)
     with Size => 1;
   for S_SPMF_Field use
     (S_SPMF_Field_0 => 0,
      S_SPMF_Field_1 => 1);

   --  SPI read buffer full flag
   type S_SPRF_Field is
     (
      --  No data available in the receive data buffer
      S_SPRF_Field_0,
      --  Data available in the receive data buffer
      S_SPRF_Field_1)
     with Size => 1;
   for S_SPRF_Field use
     (S_SPRF_Field_0 => 0,
      S_SPRF_Field_1 => 1);

   --  SPI status register
   type SPI0_S_Register is record
      --  unspecified
      Reserved_0_3 : MKL25Z4.UInt4 := 16#0#;
      --  Read-only. Master mode fault flag
      MODF         : S_MODF_Field := MKL25Z4.SPI.S_MODF_Field_0;
      --  Read-only. SPI transmit buffer empty flag
      SPTEF        : S_SPTEF_Field := MKL25Z4.SPI.S_SPTEF_Field_1;
      --  SPI match flag
      SPMF         : S_SPMF_Field := MKL25Z4.SPI.S_SPMF_Field_0;
      --  Read-only. SPI read buffer full flag
      SPRF         : S_SPRF_Field := MKL25Z4.SPI.S_SPRF_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for SPI0_S_Register use record
      Reserved_0_3 at 0 range 0 .. 3;
      MODF         at 0 range 4 .. 4;
      SPTEF        at 0 range 5 .. 5;
      SPMF         at 0 range 6 .. 6;
      SPRF         at 0 range 7 .. 7;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Serial Peripheral Interface
   type SPI_Peripheral is record
      --  SPI control register 1
      C1 : SPI0_C1_Register;
      --  SPI control register 2
      C2 : SPI0_C2_Register;
      --  SPI baud rate register
      BR : SPI0_BR_Register;
      --  SPI status register
      S  : SPI0_S_Register;
      --  SPI data register
      D  : MKL25Z4.Byte;
      --  SPI match register
      M  : MKL25Z4.Byte;
   end record
     with Volatile;

   for SPI_Peripheral use record
      C1 at 0 range 0 .. 7;
      C2 at 1 range 0 .. 7;
      BR at 2 range 0 .. 7;
      S  at 3 range 0 .. 7;
      D  at 5 range 0 .. 7;
      M  at 7 range 0 .. 7;
   end record;

   --  Serial Peripheral Interface
   SPI0_Periph : aliased SPI_Peripheral
     with Import, Address => SPI0_Base;

   --  Serial Peripheral Interface
   SPI1_Periph : aliased SPI_Peripheral
     with Import, Address => SPI1_Base;

end MKL25Z4.SPI;
