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

package MKL25Z4.TPM is

   ---------------
   -- Registers --
   ---------------

   --  Prescale Factor Selection
   type SC_PS_Field is
     (
      --  Divide by 1
      SC_PS_Field_000,
      --  Divide by 2
      SC_PS_Field_001,
      --  Divide by 4
      SC_PS_Field_010,
      --  Divide by 8
      SC_PS_Field_011,
      --  Divide by 16
      SC_PS_Field_100,
      --  Divide by 32
      SC_PS_Field_101,
      --  Divide by 64
      SC_PS_Field_110,
      --  Divide by 128
      SC_PS_Field_111)
     with Size => 3;
   for SC_PS_Field use
     (SC_PS_Field_000 => 0,
      SC_PS_Field_001 => 1,
      SC_PS_Field_010 => 2,
      SC_PS_Field_011 => 3,
      SC_PS_Field_100 => 4,
      SC_PS_Field_101 => 5,
      SC_PS_Field_110 => 6,
      SC_PS_Field_111 => 7);

   --  Clock Mode Selection
   type SC_CMOD_Field is
     (
      --  LPTPM counter is disabled
      SC_CMOD_Field_00,
      --  LPTPM counter increments on every LPTPM counter clock
      SC_CMOD_Field_01,
      --  LPTPM counter increments on rising edge of LPTPM_EXTCLK synchronized
      --  to the LPTPM counter clock
      SC_CMOD_Field_10)
     with Size => 2;
   for SC_CMOD_Field use
     (SC_CMOD_Field_00 => 0,
      SC_CMOD_Field_01 => 1,
      SC_CMOD_Field_10 => 2);

   --  Center-aligned PWM Select
   type SC_CPWMS_Field is
     (
      --  LPTPM counter operates in up counting mode.
      SC_CPWMS_Field_0,
      --  LPTPM counter operates in up-down counting mode.
      SC_CPWMS_Field_1)
     with Size => 1;
   for SC_CPWMS_Field use
     (SC_CPWMS_Field_0 => 0,
      SC_CPWMS_Field_1 => 1);

   --  Timer Overflow Interrupt Enable
   type SC_TOIE_Field is
     (
      --  Disable TOF interrupts. Use software polling or DMA request.
      SC_TOIE_Field_0,
      --  Enable TOF interrupts. An interrupt is generated when TOF equals one.
      SC_TOIE_Field_1)
     with Size => 1;
   for SC_TOIE_Field use
     (SC_TOIE_Field_0 => 0,
      SC_TOIE_Field_1 => 1);

   --  Timer Overflow Flag
   type SC_TOF_Field is
     (
      --  LPTPM counter has not overflowed.
      SC_TOF_Field_0,
      --  LPTPM counter has overflowed.
      SC_TOF_Field_1)
     with Size => 1;
   for SC_TOF_Field use
     (SC_TOF_Field_0 => 0,
      SC_TOF_Field_1 => 1);

   --  DMA Enable
   type SC_DMA_Field is
     (
      --  Disables DMA transfers.
      SC_DMA_Field_0,
      --  Enables DMA transfers.
      SC_DMA_Field_1)
     with Size => 1;
   for SC_DMA_Field use
     (SC_DMA_Field_0 => 0,
      SC_DMA_Field_1 => 1);

   --  Status and Control
   type TPM0_SC_Register is record
      --  Prescale Factor Selection
      PS            : SC_PS_Field := MKL25Z4.TPM.SC_PS_Field_000;
      --  Clock Mode Selection
      CMOD          : SC_CMOD_Field := MKL25Z4.TPM.SC_CMOD_Field_00;
      --  Center-aligned PWM Select
      CPWMS         : SC_CPWMS_Field := MKL25Z4.TPM.SC_CPWMS_Field_0;
      --  Timer Overflow Interrupt Enable
      TOIE          : SC_TOIE_Field := MKL25Z4.TPM.SC_TOIE_Field_0;
      --  Timer Overflow Flag
      TOF           : SC_TOF_Field := MKL25Z4.TPM.SC_TOF_Field_0;
      --  DMA Enable
      DMA           : SC_DMA_Field := MKL25Z4.TPM.SC_DMA_Field_0;
      --  unspecified
      Reserved_9_31 : MKL25Z4.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TPM0_SC_Register use record
      PS            at 0 range 0 .. 2;
      CMOD          at 0 range 3 .. 4;
      CPWMS         at 0 range 5 .. 5;
      TOIE          at 0 range 6 .. 6;
      TOF           at 0 range 7 .. 7;
      DMA           at 0 range 8 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   subtype CNT_COUNT_Field is MKL25Z4.Short;

   --  Counter
   type TPM0_CNT_Register is record
      --  Counter value
      COUNT          : CNT_COUNT_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MKL25Z4.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TPM0_CNT_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype MOD_MOD_Field is MKL25Z4.Short;

   --  Modulo
   type TPM0_MOD_Register is record
      --  Modulo value
      MOD_k          : MOD_MOD_Field := 16#FFFF#;
      --  unspecified
      Reserved_16_31 : MKL25Z4.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TPM0_MOD_Register use record
      MOD_k          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   -------------------------
   -- Cluster's Registers --
   -------------------------

   --  DMA Enable
   type CnSC_DMA_Field is
     (
      --  Disable DMA transfers.
      CnSC_DMA_Field_0,
      --  Enable DMA transfers.
      CnSC_DMA_Field_1)
     with Size => 1;
   for CnSC_DMA_Field use
     (CnSC_DMA_Field_0 => 0,
      CnSC_DMA_Field_1 => 1);

   subtype CnSC_ELSA_Field is MKL25Z4.Bit;
   subtype CnSC_ELSB_Field is MKL25Z4.Bit;
   subtype CnSC_MSA_Field is MKL25Z4.Bit;
   subtype CnSC_MSB_Field is MKL25Z4.Bit;

   --  Channel Interrupt Enable
   type CnSC_CHIE_Field is
     (
      --  Disable channel interrupts.
      CnSC_CHIE_Field_0,
      --  Enable channel interrupts.
      CnSC_CHIE_Field_1)
     with Size => 1;
   for CnSC_CHIE_Field use
     (CnSC_CHIE_Field_0 => 0,
      CnSC_CHIE_Field_1 => 1);

   --  Channel Flag
   type CnSC_CHF_Field is
     (
      --  No channel event has occurred.
      CnSC_CHF_Field_0,
      --  A channel event has occurred.
      CnSC_CHF_Field_1)
     with Size => 1;
   for CnSC_CHF_Field use
     (CnSC_CHF_Field_0 => 0,
      CnSC_CHF_Field_1 => 1);

   --  Channel (n) Status and Control
   type TPM0_CnSC_Register is record
      --  DMA Enable
      DMA           : CnSC_DMA_Field := MKL25Z4.TPM.CnSC_DMA_Field_0;
      --  unspecified
      Reserved_1_1  : MKL25Z4.Bit := 16#0#;
      --  Edge or Level Select
      ELSA          : CnSC_ELSA_Field := 16#0#;
      --  Edge or Level Select
      ELSB          : CnSC_ELSB_Field := 16#0#;
      --  Channel Mode Select
      MSA           : CnSC_MSA_Field := 16#0#;
      --  Channel Mode Select
      MSB           : CnSC_MSB_Field := 16#0#;
      --  Channel Interrupt Enable
      CHIE          : CnSC_CHIE_Field := MKL25Z4.TPM.CnSC_CHIE_Field_0;
      --  Channel Flag
      CHF           : CnSC_CHF_Field := MKL25Z4.TPM.CnSC_CHF_Field_0;
      --  unspecified
      Reserved_8_31 : MKL25Z4.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TPM0_CnSC_Register use record
      DMA           at 0 range 0 .. 0;
      Reserved_1_1  at 0 range 1 .. 1;
      ELSA          at 0 range 2 .. 2;
      ELSB          at 0 range 3 .. 3;
      MSA           at 0 range 4 .. 4;
      MSB           at 0 range 5 .. 5;
      CHIE          at 0 range 6 .. 6;
      CHF           at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype CnV_VAL_Field is MKL25Z4.Short;

   --  Channel (n) Value
   type TPM0_CnV_Register is record
      --  Channel Value
      VAL            : CnV_VAL_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MKL25Z4.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TPM0_CnV_Register use record
      VAL            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Grouping of Channels
   type TPM0_CHANNELS_Cluster is record
      --  Channel (n) Status and Control
      CnSC : TPM0_CnSC_Register;
      --  Channel (n) Value
      CnV  : TPM0_CnV_Register;
   end record
     with Volatile, Size => 64;

   for TPM0_CHANNELS_Cluster use record
      CnSC at 0 range 0 .. 31;
      CnV  at 4 range 0 .. 31;
   end record;

   --  Grouping of Channels
   type TPM0_CHANNELS_Clusters is array (0 .. 5) of TPM0_CHANNELS_Cluster;

   --  Channel 0 Flag
   type STATUS_CH0F_Field is
     (
      --  No channel event has occurred.
      STATUS_CH0F_Field_0,
      --  A channel event has occurred.
      STATUS_CH0F_Field_1)
     with Size => 1;
   for STATUS_CH0F_Field use
     (STATUS_CH0F_Field_0 => 0,
      STATUS_CH0F_Field_1 => 1);

   --  Channel 1 Flag
   type STATUS_CH1F_Field is
     (
      --  No channel event has occurred.
      STATUS_CH1F_Field_0,
      --  A channel event has occurred.
      STATUS_CH1F_Field_1)
     with Size => 1;
   for STATUS_CH1F_Field use
     (STATUS_CH1F_Field_0 => 0,
      STATUS_CH1F_Field_1 => 1);

   --  Channel 2 Flag
   type STATUS_CH2F_Field is
     (
      --  No channel event has occurred.
      STATUS_CH2F_Field_0,
      --  A channel event has occurred.
      STATUS_CH2F_Field_1)
     with Size => 1;
   for STATUS_CH2F_Field use
     (STATUS_CH2F_Field_0 => 0,
      STATUS_CH2F_Field_1 => 1);

   --  Channel 3 Flag
   type STATUS_CH3F_Field is
     (
      --  No channel event has occurred.
      STATUS_CH3F_Field_0,
      --  A channel event has occurred.
      STATUS_CH3F_Field_1)
     with Size => 1;
   for STATUS_CH3F_Field use
     (STATUS_CH3F_Field_0 => 0,
      STATUS_CH3F_Field_1 => 1);

   --  Channel 4 Flag
   type STATUS_CH4F_Field is
     (
      --  No channel event has occurred.
      STATUS_CH4F_Field_0,
      --  A channel event has occurred.
      STATUS_CH4F_Field_1)
     with Size => 1;
   for STATUS_CH4F_Field use
     (STATUS_CH4F_Field_0 => 0,
      STATUS_CH4F_Field_1 => 1);

   --  Channel 5 Flag
   type STATUS_CH5F_Field is
     (
      --  No channel event has occurred.
      STATUS_CH5F_Field_0,
      --  A channel event has occurred.
      STATUS_CH5F_Field_1)
     with Size => 1;
   for STATUS_CH5F_Field use
     (STATUS_CH5F_Field_0 => 0,
      STATUS_CH5F_Field_1 => 1);

   --  Timer Overflow Flag
   type STATUS_TOF_Field is
     (
      --  LPTPM counter has not overflowed.
      STATUS_TOF_Field_0,
      --  LPTPM counter has overflowed.
      STATUS_TOF_Field_1)
     with Size => 1;
   for STATUS_TOF_Field use
     (STATUS_TOF_Field_0 => 0,
      STATUS_TOF_Field_1 => 1);

   --  Capture and Compare Status
   type TPM0_STATUS_Register is record
      --  Channel 0 Flag
      CH0F          : STATUS_CH0F_Field := MKL25Z4.TPM.STATUS_CH0F_Field_0;
      --  Channel 1 Flag
      CH1F          : STATUS_CH1F_Field := MKL25Z4.TPM.STATUS_CH1F_Field_0;
      --  Channel 2 Flag
      CH2F          : STATUS_CH2F_Field := MKL25Z4.TPM.STATUS_CH2F_Field_0;
      --  Channel 3 Flag
      CH3F          : STATUS_CH3F_Field := MKL25Z4.TPM.STATUS_CH3F_Field_0;
      --  Channel 4 Flag
      CH4F          : STATUS_CH4F_Field := MKL25Z4.TPM.STATUS_CH4F_Field_0;
      --  Channel 5 Flag
      CH5F          : STATUS_CH5F_Field := MKL25Z4.TPM.STATUS_CH5F_Field_0;
      --  unspecified
      Reserved_6_7  : MKL25Z4.UInt2 := 16#0#;
      --  Timer Overflow Flag
      TOF           : STATUS_TOF_Field := MKL25Z4.TPM.STATUS_TOF_Field_0;
      --  unspecified
      Reserved_9_31 : MKL25Z4.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TPM0_STATUS_Register use record
      CH0F          at 0 range 0 .. 0;
      CH1F          at 0 range 1 .. 1;
      CH2F          at 0 range 2 .. 2;
      CH3F          at 0 range 3 .. 3;
      CH4F          at 0 range 4 .. 4;
      CH5F          at 0 range 5 .. 5;
      Reserved_6_7  at 0 range 6 .. 7;
      TOF           at 0 range 8 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   --  Doze Enable
   type CONF_DOZEEN_Field is
     (
      --  Internal LPTPM counter continues in Doze mode.
      CONF_DOZEEN_Field_0,
      --  Internal LPTPM counter is paused and does not increment during Doze
      --  mode. Trigger inputs and input capture events are also ignored.
      CONF_DOZEEN_Field_1)
     with Size => 1;
   for CONF_DOZEEN_Field use
     (CONF_DOZEEN_Field_0 => 0,
      CONF_DOZEEN_Field_1 => 1);

   --  Debug Mode
   type CONF_DBGMODE_Field is
     (
      --  LPTPM counter is paused and does not increment during debug mode.
      --  Trigger inputs and input capture events are also ignored.
      CONF_DBGMODE_Field_00,
      --  LPTPM counter continues in debug mode.
      CONF_DBGMODE_Field_11)
     with Size => 2;
   for CONF_DBGMODE_Field use
     (CONF_DBGMODE_Field_00 => 0,
      CONF_DBGMODE_Field_11 => 3);

   --  Global time base enable
   type CONF_GTBEEN_Field is
     (
      --  All channels use the internally generated LPTPM counter as their
      --  timebase
      CONF_GTBEEN_Field_0,
      --  All channels use an externally generated global timebase as their
      --  timebase
      CONF_GTBEEN_Field_1)
     with Size => 1;
   for CONF_GTBEEN_Field use
     (CONF_GTBEEN_Field_0 => 0,
      CONF_GTBEEN_Field_1 => 1);

   --  Counter Start on Trigger
   type CONF_CSOT_Field is
     (
      --  LPTPM counter starts to increment immediately, once it is enabled.
      CONF_CSOT_Field_0,
      --  LPTPM counter only starts to increment when it a rising edge on the
      --  selected input trigger is detected, after it has been enabled or
      --  after it has stopped due to overflow.
      CONF_CSOT_Field_1)
     with Size => 1;
   for CONF_CSOT_Field use
     (CONF_CSOT_Field_0 => 0,
      CONF_CSOT_Field_1 => 1);

   --  Counter Stop On Overflow
   type CONF_CSOO_Field is
     (
      --  LPTPM counter continues incrementing or decrementing after overflow
      CONF_CSOO_Field_0,
      --  LPTPM counter stops incrementing or decrementing after overflow.
      CONF_CSOO_Field_1)
     with Size => 1;
   for CONF_CSOO_Field use
     (CONF_CSOO_Field_0 => 0,
      CONF_CSOO_Field_1 => 1);

   --  Counter Reload On Trigger
   type CONF_CROT_Field is
     (
      --  Counter is not reloaded due to a rising edge on the selected input
      --  trigger
      CONF_CROT_Field_0,
      --  Counter is reloaded when a rising edge is detected on the selected
      --  input trigger
      CONF_CROT_Field_1)
     with Size => 1;
   for CONF_CROT_Field use
     (CONF_CROT_Field_0 => 0,
      CONF_CROT_Field_1 => 1);

   subtype CONF_TRGSEL_Field is MKL25Z4.UInt4;

   --  Configuration
   type TPM0_CONF_Register is record
      --  unspecified
      Reserved_0_4   : MKL25Z4.UInt5 := 16#0#;
      --  Doze Enable
      DOZEEN         : CONF_DOZEEN_Field := MKL25Z4.TPM.CONF_DOZEEN_Field_0;
      --  Debug Mode
      DBGMODE        : CONF_DBGMODE_Field :=
                        MKL25Z4.TPM.CONF_DBGMODE_Field_00;
      --  unspecified
      Reserved_8_8   : MKL25Z4.Bit := 16#0#;
      --  Global time base enable
      GTBEEN         : CONF_GTBEEN_Field := MKL25Z4.TPM.CONF_GTBEEN_Field_0;
      --  unspecified
      Reserved_10_15 : MKL25Z4.UInt6 := 16#0#;
      --  Counter Start on Trigger
      CSOT           : CONF_CSOT_Field := MKL25Z4.TPM.CONF_CSOT_Field_0;
      --  Counter Stop On Overflow
      CSOO           : CONF_CSOO_Field := MKL25Z4.TPM.CONF_CSOO_Field_0;
      --  Counter Reload On Trigger
      CROT           : CONF_CROT_Field := MKL25Z4.TPM.CONF_CROT_Field_0;
      --  unspecified
      Reserved_19_23 : MKL25Z4.UInt5 := 16#0#;
      --  Trigger Select
      TRGSEL         : CONF_TRGSEL_Field := 16#0#;
      --  unspecified
      Reserved_28_31 : MKL25Z4.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TPM0_CONF_Register use record
      Reserved_0_4   at 0 range 0 .. 4;
      DOZEEN         at 0 range 5 .. 5;
      DBGMODE        at 0 range 6 .. 7;
      Reserved_8_8   at 0 range 8 .. 8;
      GTBEEN         at 0 range 9 .. 9;
      Reserved_10_15 at 0 range 10 .. 15;
      CSOT           at 0 range 16 .. 16;
      CSOO           at 0 range 17 .. 17;
      CROT           at 0 range 18 .. 18;
      Reserved_19_23 at 0 range 19 .. 23;
      TRGSEL         at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   --  DMA Enable
   type CSC0_DMA_Field is
     (
      --  Disable DMA transfers.
      CSC0_DMA_Field_0,
      --  Enable DMA transfers.
      CSC0_DMA_Field_1)
     with Size => 1;
   for CSC0_DMA_Field use
     (CSC0_DMA_Field_0 => 0,
      CSC0_DMA_Field_1 => 1);

   subtype CSC0_ELSA_Field is MKL25Z4.Bit;
   subtype CSC0_ELSB_Field is MKL25Z4.Bit;
   subtype CSC0_MSA_Field is MKL25Z4.Bit;
   subtype CSC0_MSB_Field is MKL25Z4.Bit;

   --  Channel Interrupt Enable
   type CSC0_CHIE_Field is
     (
      --  Disable channel interrupts.
      CSC0_CHIE_Field_0,
      --  Enable channel interrupts.
      CSC0_CHIE_Field_1)
     with Size => 1;
   for CSC0_CHIE_Field use
     (CSC0_CHIE_Field_0 => 0,
      CSC0_CHIE_Field_1 => 1);

   --  Channel Flag
   type CSC0_CHF_Field is
     (
      --  No channel event has occurred.
      CSC0_CHF_Field_0,
      --  A channel event has occurred.
      CSC0_CHF_Field_1)
     with Size => 1;
   for CSC0_CHF_Field use
     (CSC0_CHF_Field_0 => 0,
      CSC0_CHF_Field_1 => 1);

   --  Channel (n) Status and Control
   type CSC_Register is record
      --  DMA Enable
      DMA           : CSC0_DMA_Field := MKL25Z4.TPM.CSC0_DMA_Field_0;
      --  unspecified
      Reserved_1_1  : MKL25Z4.Bit := 16#0#;
      --  Edge or Level Select
      ELSA          : CSC0_ELSA_Field := 16#0#;
      --  Edge or Level Select
      ELSB          : CSC0_ELSB_Field := 16#0#;
      --  Channel Mode Select
      MSA           : CSC0_MSA_Field := 16#0#;
      --  Channel Mode Select
      MSB           : CSC0_MSB_Field := 16#0#;
      --  Channel Interrupt Enable
      CHIE          : CSC0_CHIE_Field := MKL25Z4.TPM.CSC0_CHIE_Field_0;
      --  Channel Flag
      CHF           : CSC0_CHF_Field := MKL25Z4.TPM.CSC0_CHF_Field_0;
      --  unspecified
      Reserved_8_31 : MKL25Z4.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CSC_Register use record
      DMA           at 0 range 0 .. 0;
      Reserved_1_1  at 0 range 1 .. 1;
      ELSA          at 0 range 2 .. 2;
      ELSB          at 0 range 3 .. 3;
      MSA           at 0 range 4 .. 4;
      MSB           at 0 range 5 .. 5;
      CHIE          at 0 range 6 .. 6;
      CHF           at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype CV0_VAL_Field is MKL25Z4.Short;

   --  Channel (n) Value
   type CV_Register is record
      --  Channel Value
      VAL            : CV0_VAL_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MKL25Z4.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CV_Register use record
      VAL            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Timer/PWM Module
   type TPM_Peripheral is record
      --  Status and Control
      SC       : TPM0_SC_Register;
      --  Counter
      CNT      : TPM0_CNT_Register;
      --  Modulo
      MOD_k    : TPM0_MOD_Register;
      --  Grouping of Channels
      CHANNELS : TPM0_CHANNELS_Clusters;
      --  Capture and Compare Status
      STATUS   : TPM0_STATUS_Register;
      --  Configuration
      CONF     : TPM0_CONF_Register;
   end record
     with Volatile;

   for TPM_Peripheral use record
      SC       at 0 range 0 .. 31;
      CNT      at 4 range 0 .. 31;
      MOD_k    at 8 range 0 .. 31;
      CHANNELS at 12 range 0 .. 383;
      STATUS   at 80 range 0 .. 31;
      CONF     at 132 range 0 .. 31;
   end record;

   --  Timer/PWM Module
   TPM0_Periph : aliased TPM_Peripheral
     with Import, Address => TPM0_Base;

   --  Timer/PWM Module
   TPM1_Periph : aliased TPM_Peripheral
     with Import, Address => TPM1_Base;

   --  Timer/PWM Module
   TPM2_Periph : aliased TPM_Peripheral
     with Import, Address => TPM2_Base;

end MKL25Z4.TPM;
