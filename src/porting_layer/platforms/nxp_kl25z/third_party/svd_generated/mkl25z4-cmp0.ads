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

--  High-Speed Comparator (CMP), Voltage Reference (VREF) Digital-to-Analog
--  Converter (DAC), and Analog Mux (ANMUX)
package MKL25Z4.CMP0 is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Comparator hard block hysteresis control
   type CR0_HYSTCTR_Field is
     (
      --  Level 0
      CR0_HYSTCTR_Field_00,
      --  Level 1
      CR0_HYSTCTR_Field_01,
      --  Level 2
      CR0_HYSTCTR_Field_10,
      --  Level 3
      CR0_HYSTCTR_Field_11)
     with Size => 2;
   for CR0_HYSTCTR_Field use
     (CR0_HYSTCTR_Field_00 => 0,
      CR0_HYSTCTR_Field_01 => 1,
      CR0_HYSTCTR_Field_10 => 2,
      CR0_HYSTCTR_Field_11 => 3);

   --  Filter Sample Count
   type CR0_FILTER_CNT_Field is
     (
      --  Filter is disabled. If SE = 1, then COUT is a logic 0. This is not a
      --  legal state, and is not recommended. If SE = 0, COUT = COUTA.
      CR0_FILTER_CNT_Field_000,
      --  One sample must agree. The comparator output is simply sampled.
      CR0_FILTER_CNT_Field_001,
      --  2 consecutive samples must agree.
      CR0_FILTER_CNT_Field_010,
      --  3 consecutive samples must agree.
      CR0_FILTER_CNT_Field_011,
      --  4 consecutive samples must agree.
      CR0_FILTER_CNT_Field_100,
      --  5 consecutive samples must agree.
      CR0_FILTER_CNT_Field_101,
      --  6 consecutive samples must agree.
      CR0_FILTER_CNT_Field_110,
      --  7 consecutive samples must agree.
      CR0_FILTER_CNT_Field_111)
     with Size => 3;
   for CR0_FILTER_CNT_Field use
     (CR0_FILTER_CNT_Field_000 => 0,
      CR0_FILTER_CNT_Field_001 => 1,
      CR0_FILTER_CNT_Field_010 => 2,
      CR0_FILTER_CNT_Field_011 => 3,
      CR0_FILTER_CNT_Field_100 => 4,
      CR0_FILTER_CNT_Field_101 => 5,
      CR0_FILTER_CNT_Field_110 => 6,
      CR0_FILTER_CNT_Field_111 => 7);

   --  CMP Control Register 0
   type CMP0_CR0_Register is record
      --  Comparator hard block hysteresis control
      HYSTCTR      : CR0_HYSTCTR_Field := MKL25Z4.CMP0.CR0_HYSTCTR_Field_00;
      --  unspecified
      Reserved_2_3 : MKL25Z4.UInt2 := 16#0#;
      --  Filter Sample Count
      FILTER_CNT   : CR0_FILTER_CNT_Field :=
                      MKL25Z4.CMP0.CR0_FILTER_CNT_Field_000;
      --  unspecified
      Reserved_7_7 : MKL25Z4.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for CMP0_CR0_Register use record
      HYSTCTR      at 0 range 0 .. 1;
      Reserved_2_3 at 0 range 2 .. 3;
      FILTER_CNT   at 0 range 4 .. 6;
      Reserved_7_7 at 0 range 7 .. 7;
   end record;

   --  Comparator Module Enable
   type CR1_EN_Field is
     (
      --  Analog Comparator is disabled.
      CR1_EN_Field_0,
      --  Analog Comparator is enabled.
      CR1_EN_Field_1)
     with Size => 1;
   for CR1_EN_Field use
     (CR1_EN_Field_0 => 0,
      CR1_EN_Field_1 => 1);

   --  Comparator Output Pin Enable
   type CR1_OPE_Field is
     (
      --  CMPO is not available on the associated CMPO output pin. If the
      --  comparator does not own the pin, this field has no effect.
      CR1_OPE_Field_0,
      --  CMPO is available on the associated CMPO output pin. The comparator
      --  output (CMPO) is driven out on the associated CMPO output pin if the
      --  comparator owns the pin. If the comparator does not own the field,
      --  this bit has no effect.
      CR1_OPE_Field_1)
     with Size => 1;
   for CR1_OPE_Field use
     (CR1_OPE_Field_0 => 0,
      CR1_OPE_Field_1 => 1);

   --  Comparator Output Select
   type CR1_COS_Field is
     (
      --  Set the filtered comparator output (CMPO) to equal COUT.
      CR1_COS_Field_0,
      --  Set the unfiltered comparator output (CMPO) to equal COUTA.
      CR1_COS_Field_1)
     with Size => 1;
   for CR1_COS_Field use
     (CR1_COS_Field_0 => 0,
      CR1_COS_Field_1 => 1);

   --  Comparator INVERT
   type CR1_INV_Field is
     (
      --  Does not invert the comparator output.
      CR1_INV_Field_0,
      --  Inverts the comparator output.
      CR1_INV_Field_1)
     with Size => 1;
   for CR1_INV_Field use
     (CR1_INV_Field_0 => 0,
      CR1_INV_Field_1 => 1);

   --  Power Mode Select
   type CR1_PMODE_Field is
     (
      --  Low-Speed (LS) Comparison mode selected. In this mode, CMP has slower
      --  output propagation delay and lower current consumption.
      CR1_PMODE_Field_0,
      --  High-Speed (HS) Comparison mode selected. In this mode, CMP has
      --  faster output propagation delay and higher current consumption.
      CR1_PMODE_Field_1)
     with Size => 1;
   for CR1_PMODE_Field use
     (CR1_PMODE_Field_0 => 0,
      CR1_PMODE_Field_1 => 1);

   --  Trigger Mode Enable
   type CR1_TRIGM_Field is
     (
      --  Trigger mode is disabled.
      CR1_TRIGM_Field_0,
      --  Trigger mode is enabled.
      CR1_TRIGM_Field_1)
     with Size => 1;
   for CR1_TRIGM_Field use
     (CR1_TRIGM_Field_0 => 0,
      CR1_TRIGM_Field_1 => 1);

   --  Windowing Enable
   type CR1_WE_Field is
     (
      --  Windowing mode is not selected.
      CR1_WE_Field_0,
      --  Windowing mode is selected.
      CR1_WE_Field_1)
     with Size => 1;
   for CR1_WE_Field use
     (CR1_WE_Field_0 => 0,
      CR1_WE_Field_1 => 1);

   --  Sample Enable
   type CR1_SE_Field is
     (
      --  Sampling mode is not selected.
      CR1_SE_Field_0,
      --  Sampling mode is selected.
      CR1_SE_Field_1)
     with Size => 1;
   for CR1_SE_Field use
     (CR1_SE_Field_0 => 0,
      CR1_SE_Field_1 => 1);

   --  CMP Control Register 1
   type CMP0_CR1_Register is record
      --  Comparator Module Enable
      EN    : CR1_EN_Field := MKL25Z4.CMP0.CR1_EN_Field_0;
      --  Comparator Output Pin Enable
      OPE   : CR1_OPE_Field := MKL25Z4.CMP0.CR1_OPE_Field_0;
      --  Comparator Output Select
      COS   : CR1_COS_Field := MKL25Z4.CMP0.CR1_COS_Field_0;
      --  Comparator INVERT
      INV   : CR1_INV_Field := MKL25Z4.CMP0.CR1_INV_Field_0;
      --  Power Mode Select
      PMODE : CR1_PMODE_Field := MKL25Z4.CMP0.CR1_PMODE_Field_0;
      --  Trigger Mode Enable
      TRIGM : CR1_TRIGM_Field := MKL25Z4.CMP0.CR1_TRIGM_Field_0;
      --  Windowing Enable
      WE    : CR1_WE_Field := MKL25Z4.CMP0.CR1_WE_Field_0;
      --  Sample Enable
      SE    : CR1_SE_Field := MKL25Z4.CMP0.CR1_SE_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for CMP0_CR1_Register use record
      EN    at 0 range 0 .. 0;
      OPE   at 0 range 1 .. 1;
      COS   at 0 range 2 .. 2;
      INV   at 0 range 3 .. 3;
      PMODE at 0 range 4 .. 4;
      TRIGM at 0 range 5 .. 5;
      WE    at 0 range 6 .. 6;
      SE    at 0 range 7 .. 7;
   end record;

   subtype SCR_COUT_Field is MKL25Z4.Bit;

   --  Analog Comparator Flag Falling
   type SCR_CFF_Field is
     (
      --  Falling-edge on COUT has not been detected.
      SCR_CFF_Field_0,
      --  Falling-edge on COUT has occurred.
      SCR_CFF_Field_1)
     with Size => 1;
   for SCR_CFF_Field use
     (SCR_CFF_Field_0 => 0,
      SCR_CFF_Field_1 => 1);

   --  Analog Comparator Flag Rising
   type SCR_CFR_Field is
     (
      --  Rising-edge on COUT has not been detected.
      SCR_CFR_Field_0,
      --  Rising-edge on COUT has occurred.
      SCR_CFR_Field_1)
     with Size => 1;
   for SCR_CFR_Field use
     (SCR_CFR_Field_0 => 0,
      SCR_CFR_Field_1 => 1);

   --  Comparator Interrupt Enable Falling
   type SCR_IEF_Field is
     (
      --  Interrupt is disabled.
      SCR_IEF_Field_0,
      --  Interrupt is enabled.
      SCR_IEF_Field_1)
     with Size => 1;
   for SCR_IEF_Field use
     (SCR_IEF_Field_0 => 0,
      SCR_IEF_Field_1 => 1);

   --  Comparator Interrupt Enable Rising
   type SCR_IER_Field is
     (
      --  Interrupt is disabled.
      SCR_IER_Field_0,
      --  Interrupt is enabled.
      SCR_IER_Field_1)
     with Size => 1;
   for SCR_IER_Field use
     (SCR_IER_Field_0 => 0,
      SCR_IER_Field_1 => 1);

   --  DMA Enable Control
   type SCR_DMAEN_Field is
     (
      --  DMA is disabled.
      SCR_DMAEN_Field_0,
      --  DMA is enabled.
      SCR_DMAEN_Field_1)
     with Size => 1;
   for SCR_DMAEN_Field use
     (SCR_DMAEN_Field_0 => 0,
      SCR_DMAEN_Field_1 => 1);

   --  CMP Status and Control Register
   type CMP0_SCR_Register is record
      --  Read-only. Analog Comparator Output
      COUT         : SCR_COUT_Field := 16#0#;
      --  Analog Comparator Flag Falling
      CFF          : SCR_CFF_Field := MKL25Z4.CMP0.SCR_CFF_Field_0;
      --  Analog Comparator Flag Rising
      CFR          : SCR_CFR_Field := MKL25Z4.CMP0.SCR_CFR_Field_0;
      --  Comparator Interrupt Enable Falling
      IEF          : SCR_IEF_Field := MKL25Z4.CMP0.SCR_IEF_Field_0;
      --  Comparator Interrupt Enable Rising
      IER          : SCR_IER_Field := MKL25Z4.CMP0.SCR_IER_Field_0;
      --  unspecified
      Reserved_5_5 : MKL25Z4.Bit := 16#0#;
      --  DMA Enable Control
      DMAEN        : SCR_DMAEN_Field := MKL25Z4.CMP0.SCR_DMAEN_Field_0;
      --  unspecified
      Reserved_7_7 : MKL25Z4.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for CMP0_SCR_Register use record
      COUT         at 0 range 0 .. 0;
      CFF          at 0 range 1 .. 1;
      CFR          at 0 range 2 .. 2;
      IEF          at 0 range 3 .. 3;
      IER          at 0 range 4 .. 4;
      Reserved_5_5 at 0 range 5 .. 5;
      DMAEN        at 0 range 6 .. 6;
      Reserved_7_7 at 0 range 7 .. 7;
   end record;

   subtype DACCR_VOSEL_Field is MKL25Z4.UInt6;

   --  Supply Voltage Reference Source Select
   type DACCR_VRSEL_Field is
     (
      --  V is selected as resistor ladder network supply reference V. in1 in
      DACCR_VRSEL_Field_0,
      --  V is selected as resistor ladder network supply reference V. in2 in
      DACCR_VRSEL_Field_1)
     with Size => 1;
   for DACCR_VRSEL_Field use
     (DACCR_VRSEL_Field_0 => 0,
      DACCR_VRSEL_Field_1 => 1);

   --  DAC Enable
   type DACCR_DACEN_Field is
     (
      --  DAC is disabled.
      DACCR_DACEN_Field_0,
      --  DAC is enabled.
      DACCR_DACEN_Field_1)
     with Size => 1;
   for DACCR_DACEN_Field use
     (DACCR_DACEN_Field_0 => 0,
      DACCR_DACEN_Field_1 => 1);

   --  DAC Control Register
   type CMP0_DACCR_Register is record
      --  DAC Output Voltage Select
      VOSEL : DACCR_VOSEL_Field := 16#0#;
      --  Supply Voltage Reference Source Select
      VRSEL : DACCR_VRSEL_Field := MKL25Z4.CMP0.DACCR_VRSEL_Field_0;
      --  DAC Enable
      DACEN : DACCR_DACEN_Field := MKL25Z4.CMP0.DACCR_DACEN_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for CMP0_DACCR_Register use record
      VOSEL at 0 range 0 .. 5;
      VRSEL at 0 range 6 .. 6;
      DACEN at 0 range 7 .. 7;
   end record;

   --  Minus Input Mux Control
   type MUXCR_MSEL_Field is
     (
      --  IN0
      MUXCR_MSEL_Field_000,
      --  IN1
      MUXCR_MSEL_Field_001,
      --  IN2
      MUXCR_MSEL_Field_010,
      --  IN3
      MUXCR_MSEL_Field_011,
      --  IN4
      MUXCR_MSEL_Field_100,
      --  IN5
      MUXCR_MSEL_Field_101,
      --  IN6
      MUXCR_MSEL_Field_110,
      --  IN7
      MUXCR_MSEL_Field_111)
     with Size => 3;
   for MUXCR_MSEL_Field use
     (MUXCR_MSEL_Field_000 => 0,
      MUXCR_MSEL_Field_001 => 1,
      MUXCR_MSEL_Field_010 => 2,
      MUXCR_MSEL_Field_011 => 3,
      MUXCR_MSEL_Field_100 => 4,
      MUXCR_MSEL_Field_101 => 5,
      MUXCR_MSEL_Field_110 => 6,
      MUXCR_MSEL_Field_111 => 7);

   --  Plus Input Mux Control
   type MUXCR_PSEL_Field is
     (
      --  IN0
      MUXCR_PSEL_Field_000,
      --  IN1
      MUXCR_PSEL_Field_001,
      --  IN2
      MUXCR_PSEL_Field_010,
      --  IN3
      MUXCR_PSEL_Field_011,
      --  IN4
      MUXCR_PSEL_Field_100,
      --  IN5
      MUXCR_PSEL_Field_101,
      --  IN6
      MUXCR_PSEL_Field_110,
      --  IN7
      MUXCR_PSEL_Field_111)
     with Size => 3;
   for MUXCR_PSEL_Field use
     (MUXCR_PSEL_Field_000 => 0,
      MUXCR_PSEL_Field_001 => 1,
      MUXCR_PSEL_Field_010 => 2,
      MUXCR_PSEL_Field_011 => 3,
      MUXCR_PSEL_Field_100 => 4,
      MUXCR_PSEL_Field_101 => 5,
      MUXCR_PSEL_Field_110 => 6,
      MUXCR_PSEL_Field_111 => 7);

   --  Pass Through Mode Enable
   type MUXCR_PSTM_Field is
     (
      --  Pass Through Mode is disabled.
      MUXCR_PSTM_Field_0,
      --  Pass Through Mode is enabled.
      MUXCR_PSTM_Field_1)
     with Size => 1;
   for MUXCR_PSTM_Field use
     (MUXCR_PSTM_Field_0 => 0,
      MUXCR_PSTM_Field_1 => 1);

   --  MUX Control Register
   type CMP0_MUXCR_Register is record
      --  Minus Input Mux Control
      MSEL         : MUXCR_MSEL_Field := MKL25Z4.CMP0.MUXCR_MSEL_Field_000;
      --  Plus Input Mux Control
      PSEL         : MUXCR_PSEL_Field := MKL25Z4.CMP0.MUXCR_PSEL_Field_000;
      --  unspecified
      Reserved_6_6 : MKL25Z4.Bit := 16#0#;
      --  Pass Through Mode Enable
      PSTM         : MUXCR_PSTM_Field := MKL25Z4.CMP0.MUXCR_PSTM_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for CMP0_MUXCR_Register use record
      MSEL         at 0 range 0 .. 2;
      PSEL         at 0 range 3 .. 5;
      Reserved_6_6 at 0 range 6 .. 6;
      PSTM         at 0 range 7 .. 7;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  High-Speed Comparator (CMP), Voltage Reference (VREF) Digital-to-Analog
   --  Converter (DAC), and Analog Mux (ANMUX)
   type CMP0_Peripheral is record
      --  CMP Control Register 0
      CR0   : CMP0_CR0_Register;
      --  CMP Control Register 1
      CR1   : CMP0_CR1_Register;
      --  CMP Filter Period Register
      FPR   : MKL25Z4.Byte;
      --  CMP Status and Control Register
      SCR   : CMP0_SCR_Register;
      --  DAC Control Register
      DACCR : CMP0_DACCR_Register;
      --  MUX Control Register
      MUXCR : CMP0_MUXCR_Register;
   end record
     with Volatile;

   for CMP0_Peripheral use record
      CR0   at 0 range 0 .. 7;
      CR1   at 1 range 0 .. 7;
      FPR   at 2 range 0 .. 7;
      SCR   at 3 range 0 .. 7;
      DACCR at 4 range 0 .. 7;
      MUXCR at 5 range 0 .. 7;
   end record;

   --  High-Speed Comparator (CMP), Voltage Reference (VREF) Digital-to-Analog
   --  Converter (DAC), and Analog Mux (ANMUX)
   CMP0_Periph : aliased CMP0_Peripheral
     with Import, Address => CMP0_Base;

end MKL25Z4.CMP0;
