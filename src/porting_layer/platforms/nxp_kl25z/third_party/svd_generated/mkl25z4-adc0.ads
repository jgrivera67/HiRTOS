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

--  Analog-to-Digital Converter
package MKL25Z4.ADC0 is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Input channel select
   type SC1_ADCH_Field is
     (
      --  When DIFF=0, DADP0 is selected as input; when DIFF=1, DAD0 is
      --  selected as input.
      SC1_ADCH_Field_00000,
      --  When DIFF=0, DADP1 is selected as input; when DIFF=1, DAD1 is
      --  selected as input.
      SC1_ADCH_Field_00001,
      --  When DIFF=0, DADP2 is selected as input; when DIFF=1, DAD2 is
      --  selected as input.
      SC1_ADCH_Field_00010,
      --  When DIFF=0, DADP3 is selected as input; when DIFF=1, DAD3 is
      --  selected as input.
      SC1_ADCH_Field_00011,
      --  When DIFF=0, AD4 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_00100,
      --  When DIFF=0, AD5 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_00101,
      --  When DIFF=0, AD6 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_00110,
      --  When DIFF=0, AD7 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_00111,
      --  When DIFF=0, AD8 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_01000,
      --  When DIFF=0, AD9 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_01001,
      --  When DIFF=0, AD10 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_01010,
      --  When DIFF=0, AD11 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_01011,
      --  When DIFF=0, AD12 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_01100,
      --  When DIFF=0, AD13 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_01101,
      --  When DIFF=0, AD14 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_01110,
      --  When DIFF=0, AD15 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_01111,
      --  When DIFF=0, AD16 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_10000,
      --  When DIFF=0, AD17 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_10001,
      --  When DIFF=0, AD18 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_10010,
      --  When DIFF=0, AD19 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_10011,
      --  When DIFF=0, AD20 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_10100,
      --  When DIFF=0, AD21 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_10101,
      --  When DIFF=0, AD22 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_10110,
      --  When DIFF=0, AD23 is selected as input; when DIFF=1, it is reserved.
      SC1_ADCH_Field_10111,
      --  When DIFF=0, Temp Sensor (single-ended) is selected as input; when
      --  DIFF=1, Temp Sensor (differential) is selected as input.
      SC1_ADCH_Field_11010,
      --  When DIFF=0, Bandgap (single-ended) is selected as input; when
      --  DIFF=1, Bandgap (differential) is selected as input.
      SC1_ADCH_Field_11011,
      --  When DIFF=0,VREFSH is selected as input; when DIFF=1, -VREFSH
      --  (differential) is selected as input. Voltage reference selected is
      --  determined by SC2[REFSEL].
      SC1_ADCH_Field_11101,
      --  When DIFF=0,VREFSL is selected as input; when DIFF=1, it is reserved.
      --  Voltage reference selected is determined by SC2[REFSEL].
      SC1_ADCH_Field_11110,
      --  Module is disabled.
      SC1_ADCH_Field_11111)
     with Size => 5;
   for SC1_ADCH_Field use
     (SC1_ADCH_Field_00000 => 0,
      SC1_ADCH_Field_00001 => 1,
      SC1_ADCH_Field_00010 => 2,
      SC1_ADCH_Field_00011 => 3,
      SC1_ADCH_Field_00100 => 4,
      SC1_ADCH_Field_00101 => 5,
      SC1_ADCH_Field_00110 => 6,
      SC1_ADCH_Field_00111 => 7,
      SC1_ADCH_Field_01000 => 8,
      SC1_ADCH_Field_01001 => 9,
      SC1_ADCH_Field_01010 => 10,
      SC1_ADCH_Field_01011 => 11,
      SC1_ADCH_Field_01100 => 12,
      SC1_ADCH_Field_01101 => 13,
      SC1_ADCH_Field_01110 => 14,
      SC1_ADCH_Field_01111 => 15,
      SC1_ADCH_Field_10000 => 16,
      SC1_ADCH_Field_10001 => 17,
      SC1_ADCH_Field_10010 => 18,
      SC1_ADCH_Field_10011 => 19,
      SC1_ADCH_Field_10100 => 20,
      SC1_ADCH_Field_10101 => 21,
      SC1_ADCH_Field_10110 => 22,
      SC1_ADCH_Field_10111 => 23,
      SC1_ADCH_Field_11010 => 26,
      SC1_ADCH_Field_11011 => 27,
      SC1_ADCH_Field_11101 => 29,
      SC1_ADCH_Field_11110 => 30,
      SC1_ADCH_Field_11111 => 31);

   --  Differential Mode Enable
   type SC1_DIFF_Field is
     (
      --  Single-ended conversions and input channels are selected.
      SC1_DIFF_Field_0,
      --  Differential conversions and input channels are selected.
      SC1_DIFF_Field_1)
     with Size => 1;
   for SC1_DIFF_Field use
     (SC1_DIFF_Field_0 => 0,
      SC1_DIFF_Field_1 => 1);

   --  Interrupt Enable
   type SC1_AIEN_Field is
     (
      --  Conversion complete interrupt is disabled.
      SC1_AIEN_Field_0,
      --  Conversion complete interrupt is enabled.
      SC1_AIEN_Field_1)
     with Size => 1;
   for SC1_AIEN_Field use
     (SC1_AIEN_Field_0 => 0,
      SC1_AIEN_Field_1 => 1);

   --  Conversion Complete Flag
   type SC1_COCO_Field is
     (
      --  Conversion is not completed.
      SC1_COCO_Field_0,
      --  Conversion is completed.
      SC1_COCO_Field_1)
     with Size => 1;
   for SC1_COCO_Field use
     (SC1_COCO_Field_0 => 0,
      SC1_COCO_Field_1 => 1);

   --  ADC Status and Control Registers 1
   type ADC0_SC1_Register is record
      --  Input channel select
      ADCH          : SC1_ADCH_Field := MKL25Z4.ADC0.SC1_ADCH_Field_11111;
      --  Differential Mode Enable
      DIFF          : SC1_DIFF_Field := MKL25Z4.ADC0.SC1_DIFF_Field_0;
      --  Interrupt Enable
      AIEN          : SC1_AIEN_Field := MKL25Z4.ADC0.SC1_AIEN_Field_0;
      --  Read-only. Conversion Complete Flag
      COCO          : SC1_COCO_Field := MKL25Z4.ADC0.SC1_COCO_Field_0;
      --  unspecified
      Reserved_8_31 : MKL25Z4.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_SC1_Register use record
      ADCH          at 0 range 0 .. 4;
      DIFF          at 0 range 5 .. 5;
      AIEN          at 0 range 6 .. 6;
      COCO          at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  ADC Status and Control Registers 1
   type ADC0_SC1_Registers is array (0 .. 1) of ADC0_SC1_Register;

   --  Input Clock Select
   type CFG1_ADICLK_Field is
     (
      --  Bus clock
      CFG1_ADICLK_Field_00,
      --  (Bus clock)/2
      CFG1_ADICLK_Field_01,
      --  Alternate clock (ALTCLK)
      CFG1_ADICLK_Field_10,
      --  Asynchronous clock (ADACK)
      CFG1_ADICLK_Field_11)
     with Size => 2;
   for CFG1_ADICLK_Field use
     (CFG1_ADICLK_Field_00 => 0,
      CFG1_ADICLK_Field_01 => 1,
      CFG1_ADICLK_Field_10 => 2,
      CFG1_ADICLK_Field_11 => 3);

   --  Conversion mode selection
   type CFG1_MODE_Field is
     (
      --  When DIFF=0:It is single-ended 8-bit conversion; when DIFF=1, it is
      --  differential 9-bit conversion with 2's complement output.
      CFG1_MODE_Field_00,
      --  When DIFF=0:It is single-ended 12-bit conversion ; when DIFF=1, it is
      --  differential 13-bit conversion with 2's complement output.
      CFG1_MODE_Field_01,
      --  When DIFF=0:It is single-ended 10-bit conversion ; when DIFF=1, it is
      --  differential 11-bit conversion with 2's complement output.
      CFG1_MODE_Field_10,
      --  When DIFF=0:It is single-ended 16-bit conversion; when DIFF=1, it is
      --  differential 16-bit conversion with 2's complement output.
      CFG1_MODE_Field_11)
     with Size => 2;
   for CFG1_MODE_Field use
     (CFG1_MODE_Field_00 => 0,
      CFG1_MODE_Field_01 => 1,
      CFG1_MODE_Field_10 => 2,
      CFG1_MODE_Field_11 => 3);

   --  Sample time configuration
   type CFG1_ADLSMP_Field is
     (
      --  Short sample time.
      CFG1_ADLSMP_Field_0,
      --  Long sample time.
      CFG1_ADLSMP_Field_1)
     with Size => 1;
   for CFG1_ADLSMP_Field use
     (CFG1_ADLSMP_Field_0 => 0,
      CFG1_ADLSMP_Field_1 => 1);

   --  Clock Divide Select
   type CFG1_ADIV_Field is
     (
      --  The divide ratio is 1 and the clock rate is input clock.
      CFG1_ADIV_Field_00,
      --  The divide ratio is 2 and the clock rate is (input clock)/2.
      CFG1_ADIV_Field_01,
      --  The divide ratio is 4 and the clock rate is (input clock)/4.
      CFG1_ADIV_Field_10,
      --  The divide ratio is 8 and the clock rate is (input clock)/8.
      CFG1_ADIV_Field_11)
     with Size => 2;
   for CFG1_ADIV_Field use
     (CFG1_ADIV_Field_00 => 0,
      CFG1_ADIV_Field_01 => 1,
      CFG1_ADIV_Field_10 => 2,
      CFG1_ADIV_Field_11 => 3);

   --  Low-Power Configuration
   type CFG1_ADLPC_Field is
     (
      --  Normal power configuration.
      CFG1_ADLPC_Field_0,
      --  Low-power configuration. The power is reduced at the expense of
      --  maximum clock speed.
      CFG1_ADLPC_Field_1)
     with Size => 1;
   for CFG1_ADLPC_Field use
     (CFG1_ADLPC_Field_0 => 0,
      CFG1_ADLPC_Field_1 => 1);

   --  ADC Configuration Register 1
   type ADC0_CFG1_Register is record
      --  Input Clock Select
      ADICLK        : CFG1_ADICLK_Field := MKL25Z4.ADC0.CFG1_ADICLK_Field_00;
      --  Conversion mode selection
      MODE          : CFG1_MODE_Field := MKL25Z4.ADC0.CFG1_MODE_Field_00;
      --  Sample time configuration
      ADLSMP        : CFG1_ADLSMP_Field := MKL25Z4.ADC0.CFG1_ADLSMP_Field_0;
      --  Clock Divide Select
      ADIV          : CFG1_ADIV_Field := MKL25Z4.ADC0.CFG1_ADIV_Field_00;
      --  Low-Power Configuration
      ADLPC         : CFG1_ADLPC_Field := MKL25Z4.ADC0.CFG1_ADLPC_Field_0;
      --  unspecified
      Reserved_8_31 : MKL25Z4.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_CFG1_Register use record
      ADICLK        at 0 range 0 .. 1;
      MODE          at 0 range 2 .. 3;
      ADLSMP        at 0 range 4 .. 4;
      ADIV          at 0 range 5 .. 6;
      ADLPC         at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Long Sample Time Select
   type CFG2_ADLSTS_Field is
     (
      --  Default longest sample time; 20 extra ADCK cycles; 24 ADCK cycles
      --  total.
      CFG2_ADLSTS_Field_00,
      --  12 extra ADCK cycles; 16 ADCK cycles total sample time.
      CFG2_ADLSTS_Field_01,
      --  6 extra ADCK cycles; 10 ADCK cycles total sample time.
      CFG2_ADLSTS_Field_10,
      --  2 extra ADCK cycles; 6 ADCK cycles total sample time.
      CFG2_ADLSTS_Field_11)
     with Size => 2;
   for CFG2_ADLSTS_Field use
     (CFG2_ADLSTS_Field_00 => 0,
      CFG2_ADLSTS_Field_01 => 1,
      CFG2_ADLSTS_Field_10 => 2,
      CFG2_ADLSTS_Field_11 => 3);

   --  High-Speed Configuration
   type CFG2_ADHSC_Field is
     (
      --  Normal conversion sequence selected.
      CFG2_ADHSC_Field_0,
      --  High-speed conversion sequence selected with 2 additional ADCK cycles
      --  to total conversion time.
      CFG2_ADHSC_Field_1)
     with Size => 1;
   for CFG2_ADHSC_Field use
     (CFG2_ADHSC_Field_0 => 0,
      CFG2_ADHSC_Field_1 => 1);

   --  Asynchronous Clock Output Enable
   type CFG2_ADACKEN_Field is
     (
      --  Asynchronous clock output disabled; Asynchronous clock is enabled
      --  only if selected by ADICLK and a conversion is active.
      CFG2_ADACKEN_Field_0,
      --  Asynchronous clock and clock output is enabled regardless of the
      --  state of the ADC.
      CFG2_ADACKEN_Field_1)
     with Size => 1;
   for CFG2_ADACKEN_Field use
     (CFG2_ADACKEN_Field_0 => 0,
      CFG2_ADACKEN_Field_1 => 1);

   --  ADC Mux Select
   type CFG2_MUXSEL_Field is
     (
      --  ADxxa channels are selected.
      CFG2_MUXSEL_Field_0,
      --  ADxxb channels are selected.
      CFG2_MUXSEL_Field_1)
     with Size => 1;
   for CFG2_MUXSEL_Field use
     (CFG2_MUXSEL_Field_0 => 0,
      CFG2_MUXSEL_Field_1 => 1);

   --  ADC Configuration Register 2
   type ADC0_CFG2_Register is record
      --  Long Sample Time Select
      ADLSTS        : CFG2_ADLSTS_Field := MKL25Z4.ADC0.CFG2_ADLSTS_Field_00;
      --  High-Speed Configuration
      ADHSC         : CFG2_ADHSC_Field := MKL25Z4.ADC0.CFG2_ADHSC_Field_0;
      --  Asynchronous Clock Output Enable
      ADACKEN       : CFG2_ADACKEN_Field := MKL25Z4.ADC0.CFG2_ADACKEN_Field_0;
      --  ADC Mux Select
      MUXSEL        : CFG2_MUXSEL_Field := MKL25Z4.ADC0.CFG2_MUXSEL_Field_0;
      --  unspecified
      Reserved_5_31 : MKL25Z4.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_CFG2_Register use record
      ADLSTS        at 0 range 0 .. 1;
      ADHSC         at 0 range 2 .. 2;
      ADACKEN       at 0 range 3 .. 3;
      MUXSEL        at 0 range 4 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype R_D_Field is MKL25Z4.Short;

   --  ADC Data Result Register
   type ADC0_R_Register is record
      --  Read-only. Data result
      D              : R_D_Field;
      --  unspecified
      Reserved_16_31 : MKL25Z4.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_R_Register use record
      D              at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  ADC Data Result Register
   type ADC0_R_Registers is array (0 .. 1) of ADC0_R_Register;

   subtype CV_CV_Field is MKL25Z4.Short;

   --  Compare Value Registers
   type ADC0_CV_Register is record
      --  Compare Value.
      CV             : CV_CV_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MKL25Z4.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_CV_Register use record
      CV             at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Compare Value Registers
   type ADC0_CV_Registers is array (0 .. 1) of ADC0_CV_Register;

   --  Voltage Reference Selection
   type SC2_REFSEL_Field is
     (
      --  Default voltage reference pin pair, that is, external pins VREFH and
      --  VREFL
      SC2_REFSEL_Field_00,
      --  Alternate reference pair, that is, VALTH and VALTL . This pair may be
      --  additional external pins or internal sources depending on the MCU
      --  configuration. See the chip configuration information for details
      --  specific to this MCU
      SC2_REFSEL_Field_01)
     with Size => 2;
   for SC2_REFSEL_Field use
     (SC2_REFSEL_Field_00 => 0,
      SC2_REFSEL_Field_01 => 1);

   --  DMA Enable
   type SC2_DMAEN_Field is
     (
      --  DMA is disabled.
      SC2_DMAEN_Field_0,
      --  DMA is enabled and will assert the ADC DMA request during an ADC
      --  conversion complete event noted when any of the SC1n[COCO] flags is
      --  asserted.
      SC2_DMAEN_Field_1)
     with Size => 1;
   for SC2_DMAEN_Field use
     (SC2_DMAEN_Field_0 => 0,
      SC2_DMAEN_Field_1 => 1);

   --  Compare Function Range Enable
   type SC2_ACREN_Field is
     (
      --  Range function disabled. Only CV1 is compared.
      SC2_ACREN_Field_0,
      --  Range function enabled. Both CV1 and CV2 are compared.
      SC2_ACREN_Field_1)
     with Size => 1;
   for SC2_ACREN_Field use
     (SC2_ACREN_Field_0 => 0,
      SC2_ACREN_Field_1 => 1);

   --  Compare Function Greater Than Enable
   type SC2_ACFGT_Field is
     (
      --  Configures less than threshold, outside range not inclusive and
      --  inside range not inclusive; functionality based on the values placed
      --  in CV1 and CV2.
      SC2_ACFGT_Field_0,
      --  Configures greater than or equal to threshold, outside and inside
      --  ranges inclusive; functionality based on the values placed in CV1 and
      --  CV2.
      SC2_ACFGT_Field_1)
     with Size => 1;
   for SC2_ACFGT_Field use
     (SC2_ACFGT_Field_0 => 0,
      SC2_ACFGT_Field_1 => 1);

   --  Compare Function Enable
   type SC2_ACFE_Field is
     (
      --  Compare function disabled.
      SC2_ACFE_Field_0,
      --  Compare function enabled.
      SC2_ACFE_Field_1)
     with Size => 1;
   for SC2_ACFE_Field use
     (SC2_ACFE_Field_0 => 0,
      SC2_ACFE_Field_1 => 1);

   --  Conversion Trigger Select
   type SC2_ADTRG_Field is
     (
      --  Software trigger selected.
      SC2_ADTRG_Field_0,
      --  Hardware trigger selected.
      SC2_ADTRG_Field_1)
     with Size => 1;
   for SC2_ADTRG_Field use
     (SC2_ADTRG_Field_0 => 0,
      SC2_ADTRG_Field_1 => 1);

   --  Conversion Active
   type SC2_ADACT_Field is
     (
      --  Conversion not in progress.
      SC2_ADACT_Field_0,
      --  Conversion in progress.
      SC2_ADACT_Field_1)
     with Size => 1;
   for SC2_ADACT_Field use
     (SC2_ADACT_Field_0 => 0,
      SC2_ADACT_Field_1 => 1);

   --  Status and Control Register 2
   type ADC0_SC2_Register is record
      --  Voltage Reference Selection
      REFSEL        : SC2_REFSEL_Field := MKL25Z4.ADC0.SC2_REFSEL_Field_00;
      --  DMA Enable
      DMAEN         : SC2_DMAEN_Field := MKL25Z4.ADC0.SC2_DMAEN_Field_0;
      --  Compare Function Range Enable
      ACREN         : SC2_ACREN_Field := MKL25Z4.ADC0.SC2_ACREN_Field_0;
      --  Compare Function Greater Than Enable
      ACFGT         : SC2_ACFGT_Field := MKL25Z4.ADC0.SC2_ACFGT_Field_0;
      --  Compare Function Enable
      ACFE          : SC2_ACFE_Field := MKL25Z4.ADC0.SC2_ACFE_Field_0;
      --  Conversion Trigger Select
      ADTRG         : SC2_ADTRG_Field := MKL25Z4.ADC0.SC2_ADTRG_Field_0;
      --  Read-only. Conversion Active
      ADACT         : SC2_ADACT_Field := MKL25Z4.ADC0.SC2_ADACT_Field_0;
      --  unspecified
      Reserved_8_31 : MKL25Z4.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_SC2_Register use record
      REFSEL        at 0 range 0 .. 1;
      DMAEN         at 0 range 2 .. 2;
      ACREN         at 0 range 3 .. 3;
      ACFGT         at 0 range 4 .. 4;
      ACFE          at 0 range 5 .. 5;
      ADTRG         at 0 range 6 .. 6;
      ADACT         at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Hardware Average Select
   type SC3_AVGS_Field is
     (
      --  4 samples averaged.
      SC3_AVGS_Field_00,
      --  8 samples averaged.
      SC3_AVGS_Field_01,
      --  16 samples averaged.
      SC3_AVGS_Field_10,
      --  32 samples averaged.
      SC3_AVGS_Field_11)
     with Size => 2;
   for SC3_AVGS_Field use
     (SC3_AVGS_Field_00 => 0,
      SC3_AVGS_Field_01 => 1,
      SC3_AVGS_Field_10 => 2,
      SC3_AVGS_Field_11 => 3);

   --  Hardware Average Enable
   type SC3_AVGE_Field is
     (
      --  Hardware average function disabled.
      SC3_AVGE_Field_0,
      --  Hardware average function enabled.
      SC3_AVGE_Field_1)
     with Size => 1;
   for SC3_AVGE_Field use
     (SC3_AVGE_Field_0 => 0,
      SC3_AVGE_Field_1 => 1);

   --  Continuous Conversion Enable
   type SC3_ADCO_Field is
     (
      --  One conversion or one set of conversions if the hardware average
      --  function is enabled, that is, AVGE=1, after initiating a conversion.
      SC3_ADCO_Field_0,
      --  Continuous conversions or sets of conversions if the hardware average
      --  function is enabled, that is, AVGE=1, after initiating a conversion.
      SC3_ADCO_Field_1)
     with Size => 1;
   for SC3_ADCO_Field use
     (SC3_ADCO_Field_0 => 0,
      SC3_ADCO_Field_1 => 1);

   --  Calibration Failed Flag
   type SC3_CALF_Field is
     (
      --  Calibration completed normally.
      SC3_CALF_Field_0,
      --  Calibration failed. ADC accuracy specifications are not guaranteed.
      SC3_CALF_Field_1)
     with Size => 1;
   for SC3_CALF_Field use
     (SC3_CALF_Field_0 => 0,
      SC3_CALF_Field_1 => 1);

   subtype SC3_CAL_Field is MKL25Z4.Bit;

   --  Status and Control Register 3
   type ADC0_SC3_Register is record
      --  Hardware Average Select
      AVGS          : SC3_AVGS_Field := MKL25Z4.ADC0.SC3_AVGS_Field_00;
      --  Hardware Average Enable
      AVGE          : SC3_AVGE_Field := MKL25Z4.ADC0.SC3_AVGE_Field_0;
      --  Continuous Conversion Enable
      ADCO          : SC3_ADCO_Field := MKL25Z4.ADC0.SC3_ADCO_Field_0;
      --  unspecified
      Reserved_4_5  : MKL25Z4.UInt2 := 16#0#;
      --  Calibration Failed Flag
      CALF          : SC3_CALF_Field := MKL25Z4.ADC0.SC3_CALF_Field_0;
      --  Calibration
      CAL           : SC3_CAL_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : MKL25Z4.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_SC3_Register use record
      AVGS          at 0 range 0 .. 1;
      AVGE          at 0 range 2 .. 2;
      ADCO          at 0 range 3 .. 3;
      Reserved_4_5  at 0 range 4 .. 5;
      CALF          at 0 range 6 .. 6;
      CAL           at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype OFS_OFS_Field is MKL25Z4.Short;

   --  ADC Offset Correction Register
   type ADC0_OFS_Register is record
      --  Offset Error Correction Value
      OFS            : OFS_OFS_Field := 16#4#;
      --  unspecified
      Reserved_16_31 : MKL25Z4.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_OFS_Register use record
      OFS            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype PG_PG_Field is MKL25Z4.Short;

   --  ADC Plus-Side Gain Register
   type ADC0_PG_Register is record
      --  Plus-Side Gain
      PG             : PG_PG_Field := 16#8200#;
      --  unspecified
      Reserved_16_31 : MKL25Z4.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_PG_Register use record
      PG             at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype MG_MG_Field is MKL25Z4.Short;

   --  ADC Minus-Side Gain Register
   type ADC0_MG_Register is record
      --  Minus-Side Gain
      MG             : MG_MG_Field := 16#8200#;
      --  unspecified
      Reserved_16_31 : MKL25Z4.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_MG_Register use record
      MG             at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype CLPD_CLPD_Field is MKL25Z4.UInt6;

   --  ADC Plus-Side General Calibration Value Register
   type ADC0_CLPD_Register is record
      --  Calibration Value
      CLPD          : CLPD_CLPD_Field := 16#A#;
      --  unspecified
      Reserved_6_31 : MKL25Z4.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_CLPD_Register use record
      CLPD          at 0 range 0 .. 5;
      Reserved_6_31 at 0 range 6 .. 31;
   end record;

   subtype CLPS_CLPS_Field is MKL25Z4.UInt6;

   --  ADC Plus-Side General Calibration Value Register
   type ADC0_CLPS_Register is record
      --  Calibration Value
      CLPS          : CLPS_CLPS_Field := 16#20#;
      --  unspecified
      Reserved_6_31 : MKL25Z4.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_CLPS_Register use record
      CLPS          at 0 range 0 .. 5;
      Reserved_6_31 at 0 range 6 .. 31;
   end record;

   subtype CLP4_CLP4_Field is MKL25Z4.UInt10;

   --  ADC Plus-Side General Calibration Value Register
   type ADC0_CLP4_Register is record
      --  Calibration Value
      CLP4           : CLP4_CLP4_Field := 16#200#;
      --  unspecified
      Reserved_10_31 : MKL25Z4.UInt22 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_CLP4_Register use record
      CLP4           at 0 range 0 .. 9;
      Reserved_10_31 at 0 range 10 .. 31;
   end record;

   subtype CLP3_CLP3_Field is MKL25Z4.UInt9;

   --  ADC Plus-Side General Calibration Value Register
   type ADC0_CLP3_Register is record
      --  Calibration Value
      CLP3          : CLP3_CLP3_Field := 16#100#;
      --  unspecified
      Reserved_9_31 : MKL25Z4.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_CLP3_Register use record
      CLP3          at 0 range 0 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   subtype CLP2_CLP2_Field is MKL25Z4.Byte;

   --  ADC Plus-Side General Calibration Value Register
   type ADC0_CLP2_Register is record
      --  Calibration Value
      CLP2          : CLP2_CLP2_Field := 16#80#;
      --  unspecified
      Reserved_8_31 : MKL25Z4.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_CLP2_Register use record
      CLP2          at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype CLP1_CLP1_Field is MKL25Z4.UInt7;

   --  ADC Plus-Side General Calibration Value Register
   type ADC0_CLP1_Register is record
      --  Calibration Value
      CLP1          : CLP1_CLP1_Field := 16#40#;
      --  unspecified
      Reserved_7_31 : MKL25Z4.UInt25 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_CLP1_Register use record
      CLP1          at 0 range 0 .. 6;
      Reserved_7_31 at 0 range 7 .. 31;
   end record;

   subtype CLP0_CLP0_Field is MKL25Z4.UInt6;

   --  ADC Plus-Side General Calibration Value Register
   type ADC0_CLP0_Register is record
      --  Calibration Value
      CLP0          : CLP0_CLP0_Field := 16#20#;
      --  unspecified
      Reserved_6_31 : MKL25Z4.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_CLP0_Register use record
      CLP0          at 0 range 0 .. 5;
      Reserved_6_31 at 0 range 6 .. 31;
   end record;

   subtype CLMD_CLMD_Field is MKL25Z4.UInt6;

   --  ADC Minus-Side General Calibration Value Register
   type ADC0_CLMD_Register is record
      --  Calibration Value
      CLMD          : CLMD_CLMD_Field := 16#A#;
      --  unspecified
      Reserved_6_31 : MKL25Z4.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_CLMD_Register use record
      CLMD          at 0 range 0 .. 5;
      Reserved_6_31 at 0 range 6 .. 31;
   end record;

   subtype CLMS_CLMS_Field is MKL25Z4.UInt6;

   --  ADC Minus-Side General Calibration Value Register
   type ADC0_CLMS_Register is record
      --  Calibration Value
      CLMS          : CLMS_CLMS_Field := 16#20#;
      --  unspecified
      Reserved_6_31 : MKL25Z4.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_CLMS_Register use record
      CLMS          at 0 range 0 .. 5;
      Reserved_6_31 at 0 range 6 .. 31;
   end record;

   subtype CLM4_CLM4_Field is MKL25Z4.UInt10;

   --  ADC Minus-Side General Calibration Value Register
   type ADC0_CLM4_Register is record
      --  Calibration Value
      CLM4           : CLM4_CLM4_Field := 16#200#;
      --  unspecified
      Reserved_10_31 : MKL25Z4.UInt22 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_CLM4_Register use record
      CLM4           at 0 range 0 .. 9;
      Reserved_10_31 at 0 range 10 .. 31;
   end record;

   subtype CLM3_CLM3_Field is MKL25Z4.UInt9;

   --  ADC Minus-Side General Calibration Value Register
   type ADC0_CLM3_Register is record
      --  Calibration Value
      CLM3          : CLM3_CLM3_Field := 16#100#;
      --  unspecified
      Reserved_9_31 : MKL25Z4.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_CLM3_Register use record
      CLM3          at 0 range 0 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   subtype CLM2_CLM2_Field is MKL25Z4.Byte;

   --  ADC Minus-Side General Calibration Value Register
   type ADC0_CLM2_Register is record
      --  Calibration Value
      CLM2          : CLM2_CLM2_Field := 16#80#;
      --  unspecified
      Reserved_8_31 : MKL25Z4.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_CLM2_Register use record
      CLM2          at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype CLM1_CLM1_Field is MKL25Z4.UInt7;

   --  ADC Minus-Side General Calibration Value Register
   type ADC0_CLM1_Register is record
      --  Calibration Value
      CLM1          : CLM1_CLM1_Field := 16#40#;
      --  unspecified
      Reserved_7_31 : MKL25Z4.UInt25 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_CLM1_Register use record
      CLM1          at 0 range 0 .. 6;
      Reserved_7_31 at 0 range 7 .. 31;
   end record;

   subtype CLM0_CLM0_Field is MKL25Z4.UInt6;

   --  ADC Minus-Side General Calibration Value Register
   type ADC0_CLM0_Register is record
      --  Calibration Value
      CLM0          : CLM0_CLM0_Field := 16#20#;
      --  unspecified
      Reserved_6_31 : MKL25Z4.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ADC0_CLM0_Register use record
      CLM0          at 0 range 0 .. 5;
      Reserved_6_31 at 0 range 6 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Analog-to-Digital Converter
   type ADC0_Peripheral is record
      --  ADC Status and Control Registers 1
      SC1  : ADC0_SC1_Registers;
      --  ADC Configuration Register 1
      CFG1 : ADC0_CFG1_Register;
      --  ADC Configuration Register 2
      CFG2 : ADC0_CFG2_Register;
      --  ADC Data Result Register
      R    : ADC0_R_Registers;
      --  Compare Value Registers
      CV   : ADC0_CV_Registers;
      --  Status and Control Register 2
      SC2  : ADC0_SC2_Register;
      --  Status and Control Register 3
      SC3  : ADC0_SC3_Register;
      --  ADC Offset Correction Register
      OFS  : ADC0_OFS_Register;
      --  ADC Plus-Side Gain Register
      PG   : ADC0_PG_Register;
      --  ADC Minus-Side Gain Register
      MG   : ADC0_MG_Register;
      --  ADC Plus-Side General Calibration Value Register
      CLPD : ADC0_CLPD_Register;
      --  ADC Plus-Side General Calibration Value Register
      CLPS : ADC0_CLPS_Register;
      --  ADC Plus-Side General Calibration Value Register
      CLP4 : ADC0_CLP4_Register;
      --  ADC Plus-Side General Calibration Value Register
      CLP3 : ADC0_CLP3_Register;
      --  ADC Plus-Side General Calibration Value Register
      CLP2 : ADC0_CLP2_Register;
      --  ADC Plus-Side General Calibration Value Register
      CLP1 : ADC0_CLP1_Register;
      --  ADC Plus-Side General Calibration Value Register
      CLP0 : ADC0_CLP0_Register;
      --  ADC Minus-Side General Calibration Value Register
      CLMD : ADC0_CLMD_Register;
      --  ADC Minus-Side General Calibration Value Register
      CLMS : ADC0_CLMS_Register;
      --  ADC Minus-Side General Calibration Value Register
      CLM4 : ADC0_CLM4_Register;
      --  ADC Minus-Side General Calibration Value Register
      CLM3 : ADC0_CLM3_Register;
      --  ADC Minus-Side General Calibration Value Register
      CLM2 : ADC0_CLM2_Register;
      --  ADC Minus-Side General Calibration Value Register
      CLM1 : ADC0_CLM1_Register;
      --  ADC Minus-Side General Calibration Value Register
      CLM0 : ADC0_CLM0_Register;
   end record
     with Volatile;

   for ADC0_Peripheral use record
      SC1  at 0 range 0 .. 63;
      CFG1 at 8 range 0 .. 31;
      CFG2 at 12 range 0 .. 31;
      R    at 16 range 0 .. 63;
      CV   at 24 range 0 .. 63;
      SC2  at 32 range 0 .. 31;
      SC3  at 36 range 0 .. 31;
      OFS  at 40 range 0 .. 31;
      PG   at 44 range 0 .. 31;
      MG   at 48 range 0 .. 31;
      CLPD at 52 range 0 .. 31;
      CLPS at 56 range 0 .. 31;
      CLP4 at 60 range 0 .. 31;
      CLP3 at 64 range 0 .. 31;
      CLP2 at 68 range 0 .. 31;
      CLP1 at 72 range 0 .. 31;
      CLP0 at 76 range 0 .. 31;
      CLMD at 84 range 0 .. 31;
      CLMS at 88 range 0 .. 31;
      CLM4 at 92 range 0 .. 31;
      CLM3 at 96 range 0 .. 31;
      CLM2 at 100 range 0 .. 31;
      CLM1 at 104 range 0 .. 31;
      CLM0 at 108 range 0 .. 31;
   end record;

   --  Analog-to-Digital Converter
   ADC0_Periph : aliased ADC0_Peripheral
     with Import, Address => ADC0_Base;

end MKL25Z4.ADC0;
