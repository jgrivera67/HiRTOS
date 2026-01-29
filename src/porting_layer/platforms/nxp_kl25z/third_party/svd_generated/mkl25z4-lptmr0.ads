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

--  Low Power Timer
package MKL25Z4.LPTMR0 is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Timer Enable
   type CSR_TEN_Field is
     (
      --  LPTMR is disabled and internal logic is reset.
      CSR_TEN_Field_0,
      --  LPTMR is enabled.
      CSR_TEN_Field_1)
     with Size => 1;
   for CSR_TEN_Field use
     (CSR_TEN_Field_0 => 0,
      CSR_TEN_Field_1 => 1);

   --  Timer Mode Select
   type CSR_TMS_Field is
     (
      --  Time Counter mode.
      CSR_TMS_Field_0,
      --  Pulse Counter mode.
      CSR_TMS_Field_1)
     with Size => 1;
   for CSR_TMS_Field use
     (CSR_TMS_Field_0 => 0,
      CSR_TMS_Field_1 => 1);

   --  Timer Free-Running Counter
   type CSR_TFC_Field is
     (
      --  CNR is reset whenever TCF is set.
      CSR_TFC_Field_0,
      --  CNR is reset on overflow.
      CSR_TFC_Field_1)
     with Size => 1;
   for CSR_TFC_Field use
     (CSR_TFC_Field_0 => 0,
      CSR_TFC_Field_1 => 1);

   --  Timer Pin Polarity
   type CSR_TPP_Field is
     (
      --  Pulse Counter input source is active-high, and the CNR will increment
      --  on the rising-edge.
      CSR_TPP_Field_0,
      --  Pulse Counter input source is active-low, and the CNR will increment
      --  on the falling-edge.
      CSR_TPP_Field_1)
     with Size => 1;
   for CSR_TPP_Field use
     (CSR_TPP_Field_0 => 0,
      CSR_TPP_Field_1 => 1);

   --  Timer Pin Select
   type CSR_TPS_Field is
     (
      --  Pulse counter input 0 is selected.
      CSR_TPS_Field_00,
      --  Pulse counter input 1 is selected.
      CSR_TPS_Field_01,
      --  Pulse counter input 2 is selected.
      CSR_TPS_Field_10,
      --  Pulse counter input 3 is selected.
      CSR_TPS_Field_11)
     with Size => 2;
   for CSR_TPS_Field use
     (CSR_TPS_Field_00 => 0,
      CSR_TPS_Field_01 => 1,
      CSR_TPS_Field_10 => 2,
      CSR_TPS_Field_11 => 3);

   --  Timer Interrupt Enable
   type CSR_TIE_Field is
     (
      --  Timer interrupt disabled.
      CSR_TIE_Field_0,
      --  Timer interrupt enabled.
      CSR_TIE_Field_1)
     with Size => 1;
   for CSR_TIE_Field use
     (CSR_TIE_Field_0 => 0,
      CSR_TIE_Field_1 => 1);

   --  Timer Compare Flag
   type CSR_TCF_Field is
     (
      --  The value of CNR is not equal to CMR and increments.
      CSR_TCF_Field_0,
      --  The value of CNR is equal to CMR and increments.
      CSR_TCF_Field_1)
     with Size => 1;
   for CSR_TCF_Field use
     (CSR_TCF_Field_0 => 0,
      CSR_TCF_Field_1 => 1);

   --  Low Power Timer Control Status Register
   type LPTMR0_CSR_Register is record
      --  Timer Enable
      TEN           : CSR_TEN_Field := MKL25Z4.LPTMR0.CSR_TEN_Field_0;
      --  Timer Mode Select
      TMS           : CSR_TMS_Field := MKL25Z4.LPTMR0.CSR_TMS_Field_0;
      --  Timer Free-Running Counter
      TFC           : CSR_TFC_Field := MKL25Z4.LPTMR0.CSR_TFC_Field_0;
      --  Timer Pin Polarity
      TPP           : CSR_TPP_Field := MKL25Z4.LPTMR0.CSR_TPP_Field_0;
      --  Timer Pin Select
      TPS           : CSR_TPS_Field := MKL25Z4.LPTMR0.CSR_TPS_Field_00;
      --  Timer Interrupt Enable
      TIE           : CSR_TIE_Field := MKL25Z4.LPTMR0.CSR_TIE_Field_0;
      --  Timer Compare Flag
      TCF           : CSR_TCF_Field := MKL25Z4.LPTMR0.CSR_TCF_Field_0;
      --  unspecified
      Reserved_8_31 : MKL25Z4.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPTMR0_CSR_Register use record
      TEN           at 0 range 0 .. 0;
      TMS           at 0 range 1 .. 1;
      TFC           at 0 range 2 .. 2;
      TPP           at 0 range 3 .. 3;
      TPS           at 0 range 4 .. 5;
      TIE           at 0 range 6 .. 6;
      TCF           at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Prescaler Clock Select
   type PSR_PCS_Field is
     (
      --  Prescaler/glitch filter clock 0 selected.
      PSR_PCS_Field_00,
      --  Prescaler/glitch filter clock 1 selected.
      PSR_PCS_Field_01,
      --  Prescaler/glitch filter clock 2 selected.
      PSR_PCS_Field_10,
      --  Prescaler/glitch filter clock 3 selected.
      PSR_PCS_Field_11)
     with Size => 2;
   for PSR_PCS_Field use
     (PSR_PCS_Field_00 => 0,
      PSR_PCS_Field_01 => 1,
      PSR_PCS_Field_10 => 2,
      PSR_PCS_Field_11 => 3);

   --  Prescaler Bypass
   type PSR_PBYP_Field is
     (
      --  Prescaler/glitch filter is enabled.
      PSR_PBYP_Field_0,
      --  Prescaler/glitch filter is bypassed.
      PSR_PBYP_Field_1)
     with Size => 1;
   for PSR_PBYP_Field use
     (PSR_PBYP_Field_0 => 0,
      PSR_PBYP_Field_1 => 1);

   --  Prescale Value
   type PSR_PRESCALE_Field is
     (
      --  Prescaler divides the prescaler clock by 2; glitch filter does not
      --  support this configuration.
      PSR_PRESCALE_Field_0000,
      --  Prescaler divides the prescaler clock by 4; glitch filter recognizes
      --  change on input pin after 2 rising clock edges.
      PSR_PRESCALE_Field_0001,
      --  Prescaler divides the prescaler clock by 8; glitch filter recognizes
      --  change on input pin after 4 rising clock edges.
      PSR_PRESCALE_Field_0010,
      --  Prescaler divides the prescaler clock by 16; glitch filter recognizes
      --  change on input pin after 8 rising clock edges.
      PSR_PRESCALE_Field_0011,
      --  Prescaler divides the prescaler clock by 32; glitch filter recognizes
      --  change on input pin after 16 rising clock edges.
      PSR_PRESCALE_Field_0100,
      --  Prescaler divides the prescaler clock by 64; glitch filter recognizes
      --  change on input pin after 32 rising clock edges.
      PSR_PRESCALE_Field_0101,
      --  Prescaler divides the prescaler clock by 128; glitch filter
      --  recognizes change on input pin after 64 rising clock edges.
      PSR_PRESCALE_Field_0110,
      --  Prescaler divides the prescaler clock by 256; glitch filter
      --  recognizes change on input pin after 128 rising clock edges.
      PSR_PRESCALE_Field_0111,
      --  Prescaler divides the prescaler clock by 512; glitch filter
      --  recognizes change on input pin after 256 rising clock edges.
      PSR_PRESCALE_Field_1000,
      --  Prescaler divides the prescaler clock by 1024; glitch filter
      --  recognizes change on input pin after 512 rising clock edges.
      PSR_PRESCALE_Field_1001,
      --  Prescaler divides the prescaler clock by 2048; glitch filter
      --  recognizes change on input pin after 1024 rising clock edges.
      PSR_PRESCALE_Field_1010,
      --  Prescaler divides the prescaler clock by 4096; glitch filter
      --  recognizes change on input pin after 2048 rising clock edges.
      PSR_PRESCALE_Field_1011,
      --  Prescaler divides the prescaler clock by 8192; glitch filter
      --  recognizes change on input pin after 4096 rising clock edges.
      PSR_PRESCALE_Field_1100,
      --  Prescaler divides the prescaler clock by 16,384; glitch filter
      --  recognizes change on input pin after 8192 rising clock edges.
      PSR_PRESCALE_Field_1101,
      --  Prescaler divides the prescaler clock by 32,768; glitch filter
      --  recognizes change on input pin after 16,384 rising clock edges.
      PSR_PRESCALE_Field_1110,
      --  Prescaler divides the prescaler clock by 65,536; glitch filter
      --  recognizes change on input pin after 32,768 rising clock edges.
      PSR_PRESCALE_Field_1111)
     with Size => 4;
   for PSR_PRESCALE_Field use
     (PSR_PRESCALE_Field_0000 => 0,
      PSR_PRESCALE_Field_0001 => 1,
      PSR_PRESCALE_Field_0010 => 2,
      PSR_PRESCALE_Field_0011 => 3,
      PSR_PRESCALE_Field_0100 => 4,
      PSR_PRESCALE_Field_0101 => 5,
      PSR_PRESCALE_Field_0110 => 6,
      PSR_PRESCALE_Field_0111 => 7,
      PSR_PRESCALE_Field_1000 => 8,
      PSR_PRESCALE_Field_1001 => 9,
      PSR_PRESCALE_Field_1010 => 10,
      PSR_PRESCALE_Field_1011 => 11,
      PSR_PRESCALE_Field_1100 => 12,
      PSR_PRESCALE_Field_1101 => 13,
      PSR_PRESCALE_Field_1110 => 14,
      PSR_PRESCALE_Field_1111 => 15);

   --  Low Power Timer Prescale Register
   type LPTMR0_PSR_Register is record
      --  Prescaler Clock Select
      PCS           : PSR_PCS_Field := MKL25Z4.LPTMR0.PSR_PCS_Field_00;
      --  Prescaler Bypass
      PBYP          : PSR_PBYP_Field := MKL25Z4.LPTMR0.PSR_PBYP_Field_0;
      --  Prescale Value
      PRESCALE      : PSR_PRESCALE_Field :=
                       MKL25Z4.LPTMR0.PSR_PRESCALE_Field_0000;
      --  unspecified
      Reserved_7_31 : MKL25Z4.UInt25 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPTMR0_PSR_Register use record
      PCS           at 0 range 0 .. 1;
      PBYP          at 0 range 2 .. 2;
      PRESCALE      at 0 range 3 .. 6;
      Reserved_7_31 at 0 range 7 .. 31;
   end record;

   subtype CMR_COMPARE_Field is MKL25Z4.Short;

   --  Low Power Timer Compare Register
   type LPTMR0_CMR_Register is record
      --  Compare Value
      COMPARE        : CMR_COMPARE_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MKL25Z4.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPTMR0_CMR_Register use record
      COMPARE        at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype CNR_COUNTER_Field is MKL25Z4.Short;

   --  Low Power Timer Counter Register
   type LPTMR0_CNR_Register is record
      --  Counter Value
      COUNTER        : CNR_COUNTER_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MKL25Z4.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPTMR0_CNR_Register use record
      COUNTER        at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Low Power Timer
   type LPTMR0_Peripheral is record
      --  Low Power Timer Control Status Register
      CSR : LPTMR0_CSR_Register;
      --  Low Power Timer Prescale Register
      PSR : LPTMR0_PSR_Register;
      --  Low Power Timer Compare Register
      CMR : LPTMR0_CMR_Register;
      --  Low Power Timer Counter Register
      CNR : LPTMR0_CNR_Register;
   end record
     with Volatile;

   for LPTMR0_Peripheral use record
      CSR at 0 range 0 .. 31;
      PSR at 4 range 0 .. 31;
      CMR at 8 range 0 .. 31;
      CNR at 12 range 0 .. 31;
   end record;

   --  Low Power Timer
   LPTMR0_Periph : aliased LPTMR0_Peripheral
     with Import, Address => LPTMR0_Base;

end MKL25Z4.LPTMR0;
