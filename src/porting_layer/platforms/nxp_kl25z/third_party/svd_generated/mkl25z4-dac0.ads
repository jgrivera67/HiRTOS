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

--  12-Bit Digital-to-Analog Converter
package MKL25Z4.DAC0 is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype DATH0_DATA1_Field is MKL25Z4.UInt4;

   --  DAC Data High Register
   type DATH_Register is record
      --  When the DAC Buffer is not enabled, DATA[11:0] controls the output
      --  voltage based on the following formula
      DATA1        : DATH0_DATA1_Field := 16#0#;
      --  unspecified
      Reserved_4_7 : MKL25Z4.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DATH_Register use record
      DATA1        at 0 range 0 .. 3;
      Reserved_4_7 at 0 range 4 .. 7;
   end record;

   --  DAC Buffer Read Pointer Bottom Position Flag
   type SR_DACBFRPBF_Field is
     (
      --  The DAC buffer read pointer is not equal to C2[DACBFUP].
      SR_DACBFRPBF_Field_0,
      --  The DAC buffer read pointer is equal to C2[DACBFUP].
      SR_DACBFRPBF_Field_1)
     with Size => 1;
   for SR_DACBFRPBF_Field use
     (SR_DACBFRPBF_Field_0 => 0,
      SR_DACBFRPBF_Field_1 => 1);

   --  DAC Buffer Read Pointer Top Position Flag
   type SR_DACBFRPTF_Field is
     (
      --  The DAC buffer read pointer is not zero.
      SR_DACBFRPTF_Field_0,
      --  The DAC buffer read pointer is zero.
      SR_DACBFRPTF_Field_1)
     with Size => 1;
   for SR_DACBFRPTF_Field use
     (SR_DACBFRPTF_Field_0 => 0,
      SR_DACBFRPTF_Field_1 => 1);

   --  DAC Status Register
   type DAC0_SR_Register is record
      --  DAC Buffer Read Pointer Bottom Position Flag
      DACBFRPBF    : SR_DACBFRPBF_Field := MKL25Z4.DAC0.SR_DACBFRPBF_Field_0;
      --  DAC Buffer Read Pointer Top Position Flag
      DACBFRPTF    : SR_DACBFRPTF_Field := MKL25Z4.DAC0.SR_DACBFRPTF_Field_1;
      --  unspecified
      Reserved_2_7 : MKL25Z4.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DAC0_SR_Register use record
      DACBFRPBF    at 0 range 0 .. 0;
      DACBFRPTF    at 0 range 1 .. 1;
      Reserved_2_7 at 0 range 2 .. 7;
   end record;

   --  DAC Buffer Read Pointer Bottom Flag Interrupt Enable
   type C0_DACBBIEN_Field is
     (
      --  The DAC buffer read pointer bottom flag interrupt is disabled.
      C0_DACBBIEN_Field_0,
      --  The DAC buffer read pointer bottom flag interrupt is enabled.
      C0_DACBBIEN_Field_1)
     with Size => 1;
   for C0_DACBBIEN_Field use
     (C0_DACBBIEN_Field_0 => 0,
      C0_DACBBIEN_Field_1 => 1);

   --  DAC Buffer Read Pointer Top Flag Interrupt Enable
   type C0_DACBTIEN_Field is
     (
      --  The DAC buffer read pointer top flag interrupt is disabled.
      C0_DACBTIEN_Field_0,
      --  The DAC buffer read pointer top flag interrupt is enabled.
      C0_DACBTIEN_Field_1)
     with Size => 1;
   for C0_DACBTIEN_Field use
     (C0_DACBTIEN_Field_0 => 0,
      C0_DACBTIEN_Field_1 => 1);

   --  DAC Low Power Control
   type C0_LPEN_Field is
     (
      --  High-Power mode
      C0_LPEN_Field_0,
      --  Low-Power mode
      C0_LPEN_Field_1)
     with Size => 1;
   for C0_LPEN_Field use
     (C0_LPEN_Field_0 => 0,
      C0_LPEN_Field_1 => 1);

   --  DAC Software Trigger
   type C0_DACSWTRG_Field is
     (
      --  The DAC soft trigger is not valid.
      C0_DACSWTRG_Field_0,
      --  The DAC soft trigger is valid.
      C0_DACSWTRG_Field_1)
     with Size => 1;
   for C0_DACSWTRG_Field use
     (C0_DACSWTRG_Field_0 => 0,
      C0_DACSWTRG_Field_1 => 1);

   --  DAC Trigger Select
   type C0_DACTRGSEL_Field is
     (
      --  The DAC hardware trigger is selected.
      C0_DACTRGSEL_Field_0,
      --  The DAC software trigger is selected.
      C0_DACTRGSEL_Field_1)
     with Size => 1;
   for C0_DACTRGSEL_Field use
     (C0_DACTRGSEL_Field_0 => 0,
      C0_DACTRGSEL_Field_1 => 1);

   --  DAC Reference Select
   type C0_DACRFS_Field is
     (
      --  The DAC selects DACREF_1 as the reference voltage.
      C0_DACRFS_Field_0,
      --  The DAC selects DACREF_2 as the reference voltage.
      C0_DACRFS_Field_1)
     with Size => 1;
   for C0_DACRFS_Field use
     (C0_DACRFS_Field_0 => 0,
      C0_DACRFS_Field_1 => 1);

   --  DAC Enable
   type C0_DACEN_Field is
     (
      --  The DAC system is disabled.
      C0_DACEN_Field_0,
      --  The DAC system is enabled.
      C0_DACEN_Field_1)
     with Size => 1;
   for C0_DACEN_Field use
     (C0_DACEN_Field_0 => 0,
      C0_DACEN_Field_1 => 1);

   --  DAC Control Register
   type DAC0_C0_Register is record
      --  DAC Buffer Read Pointer Bottom Flag Interrupt Enable
      DACBBIEN     : C0_DACBBIEN_Field := MKL25Z4.DAC0.C0_DACBBIEN_Field_0;
      --  DAC Buffer Read Pointer Top Flag Interrupt Enable
      DACBTIEN     : C0_DACBTIEN_Field := MKL25Z4.DAC0.C0_DACBTIEN_Field_0;
      --  unspecified
      Reserved_2_2 : MKL25Z4.Bit := 16#0#;
      --  DAC Low Power Control
      LPEN         : C0_LPEN_Field := MKL25Z4.DAC0.C0_LPEN_Field_0;
      --  Write-only. DAC Software Trigger
      DACSWTRG     : C0_DACSWTRG_Field := MKL25Z4.DAC0.C0_DACSWTRG_Field_0;
      --  DAC Trigger Select
      DACTRGSEL    : C0_DACTRGSEL_Field := MKL25Z4.DAC0.C0_DACTRGSEL_Field_0;
      --  DAC Reference Select
      DACRFS       : C0_DACRFS_Field := MKL25Z4.DAC0.C0_DACRFS_Field_0;
      --  DAC Enable
      DACEN        : C0_DACEN_Field := MKL25Z4.DAC0.C0_DACEN_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DAC0_C0_Register use record
      DACBBIEN     at 0 range 0 .. 0;
      DACBTIEN     at 0 range 1 .. 1;
      Reserved_2_2 at 0 range 2 .. 2;
      LPEN         at 0 range 3 .. 3;
      DACSWTRG     at 0 range 4 .. 4;
      DACTRGSEL    at 0 range 5 .. 5;
      DACRFS       at 0 range 6 .. 6;
      DACEN        at 0 range 7 .. 7;
   end record;

   --  DAC Buffer Enable
   type C1_DACBFEN_Field is
     (
      --  Buffer read pointer is disabled. The converted data is always the
      --  first word of the buffer.
      C1_DACBFEN_Field_0,
      --  Buffer read pointer is enabled. The converted data is the word that
      --  the read pointer points to. It means converted data can be from any
      --  word of the buffer.
      C1_DACBFEN_Field_1)
     with Size => 1;
   for C1_DACBFEN_Field use
     (C1_DACBFEN_Field_0 => 0,
      C1_DACBFEN_Field_1 => 1);

   --  DAC Buffer Work Mode Select
   type C1_DACBFMD_Field is
     (
      --  Normal mode
      C1_DACBFMD_Field_0,
      --  One-Time Scan mode
      C1_DACBFMD_Field_1)
     with Size => 1;
   for C1_DACBFMD_Field use
     (C1_DACBFMD_Field_0 => 0,
      C1_DACBFMD_Field_1 => 1);

   --  DMA Enable Select
   type C1_DMAEN_Field is
     (
      --  DMA is disabled.
      C1_DMAEN_Field_0,
      --  DMA is enabled. When DMA is enabled, the DMA request will be
      --  generated by original interrupts. The interrupts will not be
      --  presented on this module at the same time.
      C1_DMAEN_Field_1)
     with Size => 1;
   for C1_DMAEN_Field use
     (C1_DMAEN_Field_0 => 0,
      C1_DMAEN_Field_1 => 1);

   --  DAC Control Register 1
   type DAC0_C1_Register is record
      --  DAC Buffer Enable
      DACBFEN      : C1_DACBFEN_Field := MKL25Z4.DAC0.C1_DACBFEN_Field_0;
      --  unspecified
      Reserved_1_1 : MKL25Z4.Bit := 16#0#;
      --  DAC Buffer Work Mode Select
      DACBFMD      : C1_DACBFMD_Field := MKL25Z4.DAC0.C1_DACBFMD_Field_0;
      --  unspecified
      Reserved_3_6 : MKL25Z4.UInt4 := 16#0#;
      --  DMA Enable Select
      DMAEN        : C1_DMAEN_Field := MKL25Z4.DAC0.C1_DMAEN_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DAC0_C1_Register use record
      DACBFEN      at 0 range 0 .. 0;
      Reserved_1_1 at 0 range 1 .. 1;
      DACBFMD      at 0 range 2 .. 2;
      Reserved_3_6 at 0 range 3 .. 6;
      DMAEN        at 0 range 7 .. 7;
   end record;

   subtype C2_DACBFUP_Field is MKL25Z4.Bit;
   subtype C2_DACBFRP_Field is MKL25Z4.Bit;

   --  DAC Control Register 2
   type DAC0_C2_Register is record
      --  DAC Buffer Upper Limit
      DACBFUP      : C2_DACBFUP_Field := 16#1#;
      --  unspecified
      Reserved_1_3 : MKL25Z4.UInt3 := 16#0#;
      --  DAC Buffer Read Pointer
      DACBFRP      : C2_DACBFRP_Field := 16#0#;
      --  unspecified
      Reserved_5_7 : MKL25Z4.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DAC0_C2_Register use record
      DACBFUP      at 0 range 0 .. 0;
      Reserved_1_3 at 0 range 1 .. 3;
      DACBFRP      at 0 range 4 .. 4;
      Reserved_5_7 at 0 range 5 .. 7;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  12-Bit Digital-to-Analog Converter
   type DAC0_Peripheral is record
      --  DAC Data Low Register
      DATL0 : MKL25Z4.Byte;
      --  DAC Data High Register
      DATH0 : DATH_Register;
      --  DAC Data Low Register
      DATL1 : MKL25Z4.Byte;
      --  DAC Data High Register
      DATH1 : DATH_Register;
      --  DAC Status Register
      SR    : DAC0_SR_Register;
      --  DAC Control Register
      C0    : DAC0_C0_Register;
      --  DAC Control Register 1
      C1    : DAC0_C1_Register;
      --  DAC Control Register 2
      C2    : DAC0_C2_Register;
   end record
     with Volatile;

   for DAC0_Peripheral use record
      DATL0 at 0 range 0 .. 7;
      DATH0 at 1 range 0 .. 7;
      DATL1 at 2 range 0 .. 7;
      DATH1 at 3 range 0 .. 7;
      SR    at 32 range 0 .. 7;
      C0    at 33 range 0 .. 7;
      C1    at 34 range 0 .. 7;
      C2    at 35 range 0 .. 7;
   end record;

   --  12-Bit Digital-to-Analog Converter
   DAC0_Periph : aliased DAC0_Peripheral
     with Import, Address => DAC0_Base;

end MKL25Z4.DAC0;
