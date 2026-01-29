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

--  Touch sense input
package MKL25Z4.TSI0 is

   ---------------
   -- Registers --
   ---------------

   --  CURSW
   type GENCS_CURSW_Field is
     (
      --  The current source pair are not swapped.
      GENCS_CURSW_Field_0,
      --  The current source pair are swapped.
      GENCS_CURSW_Field_1)
     with Size => 1;
   for GENCS_CURSW_Field use
     (GENCS_CURSW_Field_0 => 0,
      GENCS_CURSW_Field_1 => 1);

   --  End of Scan Flag
   type GENCS_EOSF_Field is
     (
      --  Scan not complete.
      GENCS_EOSF_Field_0,
      --  Scan complete.
      GENCS_EOSF_Field_1)
     with Size => 1;
   for GENCS_EOSF_Field use
     (GENCS_EOSF_Field_0 => 0,
      GENCS_EOSF_Field_1 => 1);

   --  Scan In Progress Status
   type GENCS_SCNIP_Field is
     (
      --  No scan in progress.
      GENCS_SCNIP_Field_0,
      --  Scan in progress.
      GENCS_SCNIP_Field_1)
     with Size => 1;
   for GENCS_SCNIP_Field use
     (GENCS_SCNIP_Field_0 => 0,
      GENCS_SCNIP_Field_1 => 1);

   --  Scan Trigger Mode
   type GENCS_STM_Field is
     (
      --  Software trigger scan.
      GENCS_STM_Field_0,
      --  Hardware trigger scan.
      GENCS_STM_Field_1)
     with Size => 1;
   for GENCS_STM_Field use
     (GENCS_STM_Field_0 => 0,
      GENCS_STM_Field_1 => 1);

   --  TSI STOP Enable
   type GENCS_STPE_Field is
     (
      --  TSI is disabled when MCU goes into low power mode.
      GENCS_STPE_Field_0,
      --  Allows TSI to continue running in all low power modes.
      GENCS_STPE_Field_1)
     with Size => 1;
   for GENCS_STPE_Field use
     (GENCS_STPE_Field_0 => 0,
      GENCS_STPE_Field_1 => 1);

   --  Touch Sensing Input Interrupt Enable
   type GENCS_TSIIEN_Field is
     (
      --  TSI interrupt is disabled.
      GENCS_TSIIEN_Field_0,
      --  TSI interrupt is enabled.
      GENCS_TSIIEN_Field_1)
     with Size => 1;
   for GENCS_TSIIEN_Field use
     (GENCS_TSIIEN_Field_0 => 0,
      GENCS_TSIIEN_Field_1 => 1);

   --  Touch Sensing Input Module Enable
   type GENCS_TSIEN_Field is
     (
      --  TSI module disabled.
      GENCS_TSIEN_Field_0,
      --  TSI module enabled.
      GENCS_TSIEN_Field_1)
     with Size => 1;
   for GENCS_TSIEN_Field use
     (GENCS_TSIEN_Field_0 => 0,
      GENCS_TSIEN_Field_1 => 1);

   --  NSCN
   type GENCS_NSCN_Field is
     (
      --  Once per electrode
      GENCS_NSCN_Field_00000,
      --  Twice per electrode
      GENCS_NSCN_Field_00001,
      --  3 times per electrode
      GENCS_NSCN_Field_00010,
      --  4 times per electrode
      GENCS_NSCN_Field_00011,
      --  5 times per electrode
      GENCS_NSCN_Field_00100,
      --  6 times per electrode
      GENCS_NSCN_Field_00101,
      --  7 times per electrode
      GENCS_NSCN_Field_00110,
      --  8 times per electrode
      GENCS_NSCN_Field_00111,
      --  9 times per electrode
      GENCS_NSCN_Field_01000,
      --  10 times per electrode
      GENCS_NSCN_Field_01001,
      --  11 times per electrode
      GENCS_NSCN_Field_01010,
      --  12 times per electrode
      GENCS_NSCN_Field_01011,
      --  13 times per electrode
      GENCS_NSCN_Field_01100,
      --  14 times per electrode
      GENCS_NSCN_Field_01101,
      --  15 times per electrode
      GENCS_NSCN_Field_01110,
      --  16 times per electrode
      GENCS_NSCN_Field_01111,
      --  17 times per electrode
      GENCS_NSCN_Field_10000,
      --  18 times per electrode
      GENCS_NSCN_Field_10001,
      --  19 times per electrode
      GENCS_NSCN_Field_10010,
      --  20 times per electrode
      GENCS_NSCN_Field_10011,
      --  21 times per electrode
      GENCS_NSCN_Field_10100,
      --  22 times per electrode
      GENCS_NSCN_Field_10101,
      --  23 times per electrode
      GENCS_NSCN_Field_10110,
      --  24 times per electrode
      GENCS_NSCN_Field_10111,
      --  25 times per electrode
      GENCS_NSCN_Field_11000,
      --  26 times per electrode
      GENCS_NSCN_Field_11001,
      --  27 times per electrode
      GENCS_NSCN_Field_11010,
      --  28 times per electrode
      GENCS_NSCN_Field_11011,
      --  29 times per electrode
      GENCS_NSCN_Field_11100,
      --  30 times per electrode
      GENCS_NSCN_Field_11101,
      --  31 times per electrode
      GENCS_NSCN_Field_11110,
      --  32 times per electrode
      GENCS_NSCN_Field_11111)
     with Size => 5;
   for GENCS_NSCN_Field use
     (GENCS_NSCN_Field_00000 => 0,
      GENCS_NSCN_Field_00001 => 1,
      GENCS_NSCN_Field_00010 => 2,
      GENCS_NSCN_Field_00011 => 3,
      GENCS_NSCN_Field_00100 => 4,
      GENCS_NSCN_Field_00101 => 5,
      GENCS_NSCN_Field_00110 => 6,
      GENCS_NSCN_Field_00111 => 7,
      GENCS_NSCN_Field_01000 => 8,
      GENCS_NSCN_Field_01001 => 9,
      GENCS_NSCN_Field_01010 => 10,
      GENCS_NSCN_Field_01011 => 11,
      GENCS_NSCN_Field_01100 => 12,
      GENCS_NSCN_Field_01101 => 13,
      GENCS_NSCN_Field_01110 => 14,
      GENCS_NSCN_Field_01111 => 15,
      GENCS_NSCN_Field_10000 => 16,
      GENCS_NSCN_Field_10001 => 17,
      GENCS_NSCN_Field_10010 => 18,
      GENCS_NSCN_Field_10011 => 19,
      GENCS_NSCN_Field_10100 => 20,
      GENCS_NSCN_Field_10101 => 21,
      GENCS_NSCN_Field_10110 => 22,
      GENCS_NSCN_Field_10111 => 23,
      GENCS_NSCN_Field_11000 => 24,
      GENCS_NSCN_Field_11001 => 25,
      GENCS_NSCN_Field_11010 => 26,
      GENCS_NSCN_Field_11011 => 27,
      GENCS_NSCN_Field_11100 => 28,
      GENCS_NSCN_Field_11101 => 29,
      GENCS_NSCN_Field_11110 => 30,
      GENCS_NSCN_Field_11111 => 31);

   --  PS
   type GENCS_PS_Field is
     (
      --  Electrode Oscillator Frequency divided by 1
      GENCS_PS_Field_000,
      --  Electrode Oscillator Frequency divided by 2
      GENCS_PS_Field_001,
      --  Electrode Oscillator Frequency divided by 4
      GENCS_PS_Field_010,
      --  Electrode Oscillator Frequency divided by 8
      GENCS_PS_Field_011,
      --  Electrode Oscillator Frequency divided by 16
      GENCS_PS_Field_100,
      --  Electrode Oscillator Frequency divided by 32
      GENCS_PS_Field_101,
      --  Electrode Oscillator Frequency divided by 64
      GENCS_PS_Field_110,
      --  Electrode Oscillator Frequency divided by 128
      GENCS_PS_Field_111)
     with Size => 3;
   for GENCS_PS_Field use
     (GENCS_PS_Field_000 => 0,
      GENCS_PS_Field_001 => 1,
      GENCS_PS_Field_010 => 2,
      GENCS_PS_Field_011 => 3,
      GENCS_PS_Field_100 => 4,
      GENCS_PS_Field_101 => 5,
      GENCS_PS_Field_110 => 6,
      GENCS_PS_Field_111 => 7);

   --  EXTCHRG
   type GENCS_EXTCHRG_Field is
     (
      --  500 nA.
      GENCS_EXTCHRG_Field_000,
      --  1 uA.
      GENCS_EXTCHRG_Field_001,
      --  2 uA.
      GENCS_EXTCHRG_Field_010,
      --  4 uA.
      GENCS_EXTCHRG_Field_011,
      --  8 uA.
      GENCS_EXTCHRG_Field_100,
      --  16 uA.
      GENCS_EXTCHRG_Field_101,
      --  32 uA.
      GENCS_EXTCHRG_Field_110,
      --  64 uA.
      GENCS_EXTCHRG_Field_111)
     with Size => 3;
   for GENCS_EXTCHRG_Field use
     (GENCS_EXTCHRG_Field_000 => 0,
      GENCS_EXTCHRG_Field_001 => 1,
      GENCS_EXTCHRG_Field_010 => 2,
      GENCS_EXTCHRG_Field_011 => 3,
      GENCS_EXTCHRG_Field_100 => 4,
      GENCS_EXTCHRG_Field_101 => 5,
      GENCS_EXTCHRG_Field_110 => 6,
      GENCS_EXTCHRG_Field_111 => 7);

   --  DVOLT
   type GENCS_DVOLT_Field is
     (
      --  DV = 1.03 V; VP = 1.33 V; Vm = 0.30 V.
      GENCS_DVOLT_Field_00,
      --  DV = 0.73 V; VP = 1.18 V; Vm = 0.45 V.
      GENCS_DVOLT_Field_01,
      --  DV = 0.43 V; VP = 1.03 V; Vm = 0.60 V.
      GENCS_DVOLT_Field_10,
      --  DV = 0.29 V; VP = 0.95 V; Vm = 0.67 V.
      GENCS_DVOLT_Field_11)
     with Size => 2;
   for GENCS_DVOLT_Field use
     (GENCS_DVOLT_Field_00 => 0,
      GENCS_DVOLT_Field_01 => 1,
      GENCS_DVOLT_Field_10 => 2,
      GENCS_DVOLT_Field_11 => 3);

   --  REFCHRG
   type GENCS_REFCHRG_Field is
     (
      --  500 nA.
      GENCS_REFCHRG_Field_000,
      --  1 uA.
      GENCS_REFCHRG_Field_001,
      --  2 uA.
      GENCS_REFCHRG_Field_010,
      --  4 uA.
      GENCS_REFCHRG_Field_011,
      --  8 uA.
      GENCS_REFCHRG_Field_100,
      --  16 uA.
      GENCS_REFCHRG_Field_101,
      --  32 uA.
      GENCS_REFCHRG_Field_110,
      --  64 uA.
      GENCS_REFCHRG_Field_111)
     with Size => 3;
   for GENCS_REFCHRG_Field use
     (GENCS_REFCHRG_Field_000 => 0,
      GENCS_REFCHRG_Field_001 => 1,
      GENCS_REFCHRG_Field_010 => 2,
      GENCS_REFCHRG_Field_011 => 3,
      GENCS_REFCHRG_Field_100 => 4,
      GENCS_REFCHRG_Field_101 => 5,
      GENCS_REFCHRG_Field_110 => 6,
      GENCS_REFCHRG_Field_111 => 7);

   --  TSI analog modes setup and status bits.
   type GENCS_MODE_Field is
     (
      --  Set TSI in capacitive sensing(non-noise detection) mode.
      GENCS_MODE_Field_0000,
      --  Set TSI analog to work in single threshold noise detection mode and
      --  the frequency limitation circuit is disabled.
      GENCS_MODE_Field_0100,
      --  Set TSI analog to work in single threshold noise detection mode and
      --  the frequency limitation circuit is enabled to work in higher
      --  frequencies operations.
      GENCS_MODE_Field_1000,
      --  Set TSI analog to work in automatic noise detection mode.
      GENCS_MODE_Field_1100)
     with Size => 4;
   for GENCS_MODE_Field use
     (GENCS_MODE_Field_0000 => 0,
      GENCS_MODE_Field_0100 => 4,
      GENCS_MODE_Field_1000 => 8,
      GENCS_MODE_Field_1100 => 12);

   --  End-of-scan or Out-of-Range Interrupt Selection
   type GENCS_ESOR_Field is
     (
      --  Out-of-range interrupt is allowed.
      GENCS_ESOR_Field_0,
      --  End-of-scan interrupt is allowed.
      GENCS_ESOR_Field_1)
     with Size => 1;
   for GENCS_ESOR_Field use
     (GENCS_ESOR_Field_0 => 0,
      GENCS_ESOR_Field_1 => 1);

   subtype GENCS_OUTRGF_Field is MKL25Z4.Bit;

   --  TSI General Control and Status Register
   type TSI0_GENCS_Register is record
      --  unspecified
      Reserved_0_0   : MKL25Z4.Bit := 16#0#;
      --  CURSW
      CURSW          : GENCS_CURSW_Field := MKL25Z4.TSI0.GENCS_CURSW_Field_0;
      --  End of Scan Flag
      EOSF           : GENCS_EOSF_Field := MKL25Z4.TSI0.GENCS_EOSF_Field_0;
      --  Read-only. Scan In Progress Status
      SCNIP          : GENCS_SCNIP_Field := MKL25Z4.TSI0.GENCS_SCNIP_Field_0;
      --  Scan Trigger Mode
      STM            : GENCS_STM_Field := MKL25Z4.TSI0.GENCS_STM_Field_0;
      --  TSI STOP Enable
      STPE           : GENCS_STPE_Field := MKL25Z4.TSI0.GENCS_STPE_Field_0;
      --  Touch Sensing Input Interrupt Enable
      TSIIEN         : GENCS_TSIIEN_Field :=
                        MKL25Z4.TSI0.GENCS_TSIIEN_Field_0;
      --  Touch Sensing Input Module Enable
      TSIEN          : GENCS_TSIEN_Field := MKL25Z4.TSI0.GENCS_TSIEN_Field_0;
      --  NSCN
      NSCN           : GENCS_NSCN_Field :=
                        MKL25Z4.TSI0.GENCS_NSCN_Field_00000;
      --  PS
      PS             : GENCS_PS_Field := MKL25Z4.TSI0.GENCS_PS_Field_000;
      --  EXTCHRG
      EXTCHRG        : GENCS_EXTCHRG_Field :=
                        MKL25Z4.TSI0.GENCS_EXTCHRG_Field_000;
      --  DVOLT
      DVOLT          : GENCS_DVOLT_Field := MKL25Z4.TSI0.GENCS_DVOLT_Field_00;
      --  REFCHRG
      REFCHRG        : GENCS_REFCHRG_Field :=
                        MKL25Z4.TSI0.GENCS_REFCHRG_Field_000;
      --  TSI analog modes setup and status bits.
      MODE           : GENCS_MODE_Field := MKL25Z4.TSI0.GENCS_MODE_Field_0000;
      --  End-of-scan or Out-of-Range Interrupt Selection
      ESOR           : GENCS_ESOR_Field := MKL25Z4.TSI0.GENCS_ESOR_Field_0;
      --  unspecified
      Reserved_29_30 : MKL25Z4.UInt2 := 16#0#;
      --  Out of Range Flag.
      OUTRGF         : GENCS_OUTRGF_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TSI0_GENCS_Register use record
      Reserved_0_0   at 0 range 0 .. 0;
      CURSW          at 0 range 1 .. 1;
      EOSF           at 0 range 2 .. 2;
      SCNIP          at 0 range 3 .. 3;
      STM            at 0 range 4 .. 4;
      STPE           at 0 range 5 .. 5;
      TSIIEN         at 0 range 6 .. 6;
      TSIEN          at 0 range 7 .. 7;
      NSCN           at 0 range 8 .. 12;
      PS             at 0 range 13 .. 15;
      EXTCHRG        at 0 range 16 .. 18;
      DVOLT          at 0 range 19 .. 20;
      REFCHRG        at 0 range 21 .. 23;
      MODE           at 0 range 24 .. 27;
      ESOR           at 0 range 28 .. 28;
      Reserved_29_30 at 0 range 29 .. 30;
      OUTRGF         at 0 range 31 .. 31;
   end record;

   subtype DATA_TSICNT_Field is MKL25Z4.Short;

   --  Software Trigger Start
   type DATA_SWTS_Field is
     (
      --  No effect.
      DATA_SWTS_Field_0,
      --  Start a scan to determine which channel is specified by
      --  TSI_DATA[TSICH].
      DATA_SWTS_Field_1)
     with Size => 1;
   for DATA_SWTS_Field use
     (DATA_SWTS_Field_0 => 0,
      DATA_SWTS_Field_1 => 1);

   --  DMA Transfer Enabled
   type DATA_DMAEN_Field is
     (
      --  Interrupt is selected when the interrupt enable bit is set and the
      --  corresponding TSI events assert.
      DATA_DMAEN_Field_0,
      --  DMA transfer request is selected when the interrupt enable bit is set
      --  and the corresponding TSI events assert.
      DATA_DMAEN_Field_1)
     with Size => 1;
   for DATA_DMAEN_Field use
     (DATA_DMAEN_Field_0 => 0,
      DATA_DMAEN_Field_1 => 1);

   --  TSICH
   type DATA_TSICH_Field is
     (
      --  Channel 0.
      DATA_TSICH_Field_0000,
      --  Channel 1.
      DATA_TSICH_Field_0001,
      --  Channel 2.
      DATA_TSICH_Field_0010,
      --  Channel 3.
      DATA_TSICH_Field_0011,
      --  Channel 4.
      DATA_TSICH_Field_0100,
      --  Channel 5.
      DATA_TSICH_Field_0101,
      --  Channel 6.
      DATA_TSICH_Field_0110,
      --  Channel 7.
      DATA_TSICH_Field_0111,
      --  Channel 8.
      DATA_TSICH_Field_1000,
      --  Channel 9.
      DATA_TSICH_Field_1001,
      --  Channel 10.
      DATA_TSICH_Field_1010,
      --  Channel 11.
      DATA_TSICH_Field_1011,
      --  Channel 12.
      DATA_TSICH_Field_1100,
      --  Channel 13.
      DATA_TSICH_Field_1101,
      --  Channel 14.
      DATA_TSICH_Field_1110,
      --  Channel 15.
      DATA_TSICH_Field_1111)
     with Size => 4;
   for DATA_TSICH_Field use
     (DATA_TSICH_Field_0000 => 0,
      DATA_TSICH_Field_0001 => 1,
      DATA_TSICH_Field_0010 => 2,
      DATA_TSICH_Field_0011 => 3,
      DATA_TSICH_Field_0100 => 4,
      DATA_TSICH_Field_0101 => 5,
      DATA_TSICH_Field_0110 => 6,
      DATA_TSICH_Field_0111 => 7,
      DATA_TSICH_Field_1000 => 8,
      DATA_TSICH_Field_1001 => 9,
      DATA_TSICH_Field_1010 => 10,
      DATA_TSICH_Field_1011 => 11,
      DATA_TSICH_Field_1100 => 12,
      DATA_TSICH_Field_1101 => 13,
      DATA_TSICH_Field_1110 => 14,
      DATA_TSICH_Field_1111 => 15);

   --  TSI DATA Register
   type TSI0_DATA_Register is record
      --  Read-only. TSI Conversion Counter Value
      TSICNT         : DATA_TSICNT_Field := 16#0#;
      --  unspecified
      Reserved_16_21 : MKL25Z4.UInt6 := 16#0#;
      --  Write-only. Software Trigger Start
      SWTS           : DATA_SWTS_Field := MKL25Z4.TSI0.DATA_SWTS_Field_0;
      --  DMA Transfer Enabled
      DMAEN          : DATA_DMAEN_Field := MKL25Z4.TSI0.DATA_DMAEN_Field_0;
      --  unspecified
      Reserved_24_27 : MKL25Z4.UInt4 := 16#0#;
      --  TSICH
      TSICH          : DATA_TSICH_Field := MKL25Z4.TSI0.DATA_TSICH_Field_0000;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TSI0_DATA_Register use record
      TSICNT         at 0 range 0 .. 15;
      Reserved_16_21 at 0 range 16 .. 21;
      SWTS           at 0 range 22 .. 22;
      DMAEN          at 0 range 23 .. 23;
      Reserved_24_27 at 0 range 24 .. 27;
      TSICH          at 0 range 28 .. 31;
   end record;

   subtype TSHD_THRESL_Field is MKL25Z4.Short;
   subtype TSHD_THRESH_Field is MKL25Z4.Short;

   --  TSI Threshold Register
   type TSI0_TSHD_Register is record
      --  TSI Wakeup Channel Low-threshold
      THRESL : TSHD_THRESL_Field := 16#0#;
      --  TSI Wakeup Channel High-threshold
      THRESH : TSHD_THRESH_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TSI0_TSHD_Register use record
      THRESL at 0 range 0 .. 15;
      THRESH at 0 range 16 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Touch sense input
   type TSI0_Peripheral is record
      --  TSI General Control and Status Register
      GENCS : TSI0_GENCS_Register;
      --  TSI DATA Register
      DATA  : TSI0_DATA_Register;
      --  TSI Threshold Register
      TSHD  : TSI0_TSHD_Register;
   end record
     with Volatile;

   for TSI0_Peripheral use record
      GENCS at 0 range 0 .. 31;
      DATA  at 4 range 0 .. 31;
      TSHD  at 8 range 0 .. 31;
   end record;

   --  Touch sense input
   TSI0_Periph : aliased TSI0_Peripheral
     with Import, Address => TSI0_Base;

end MKL25Z4.TSI0;
