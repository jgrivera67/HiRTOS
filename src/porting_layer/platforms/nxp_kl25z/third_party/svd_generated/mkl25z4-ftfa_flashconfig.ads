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

--  Flash configuration field
package MKL25Z4.FTFA_FlashConfig is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Flash Security
   type FSEC_SEC_Field is
     (
      --  MCU security status is unsecure
      FSEC_SEC_Field_10,
      --  MCU security status is secure
      FSEC_SEC_Field_11)
     with Size => 2;
   for FSEC_SEC_Field use
     (FSEC_SEC_Field_10 => 2,
      FSEC_SEC_Field_11 => 3);

   --  Freescale Failure Analysis Access Code
   type FSEC_FSLACC_Field is
     (
      --  Freescale factory access denied
      FSEC_FSLACC_Field_10,
      --  Freescale factory access granted
      FSEC_FSLACC_Field_11)
     with Size => 2;
   for FSEC_FSLACC_Field use
     (FSEC_FSLACC_Field_10 => 2,
      FSEC_FSLACC_Field_11 => 3);

   --  no description available
   type FSEC_MEEN_Field is
     (
      --  Mass erase is disabled
      FSEC_MEEN_Field_10,
      --  Mass erase is enabled
      FSEC_MEEN_Field_11)
     with Size => 2;
   for FSEC_MEEN_Field use
     (FSEC_MEEN_Field_10 => 2,
      FSEC_MEEN_Field_11 => 3);

   --  Backdoor Key Security Enable
   type FSEC_KEYEN_Field is
     (
      --  Backdoor key access enabled
      FSEC_KEYEN_Field_10,
      --  Backdoor key access disabled
      FSEC_KEYEN_Field_11)
     with Size => 2;
   for FSEC_KEYEN_Field use
     (FSEC_KEYEN_Field_10 => 2,
      FSEC_KEYEN_Field_11 => 3);

   --  Non-volatile Flash Security Register
   type NV_FSEC_Register is record
      --  Read-only. Flash Security
      SEC    : FSEC_SEC_Field;
      --  Read-only. Freescale Failure Analysis Access Code
      FSLACC : FSEC_FSLACC_Field;
      --  Read-only. no description available
      MEEN   : FSEC_MEEN_Field;
      --  Read-only. Backdoor Key Security Enable
      KEYEN  : FSEC_KEYEN_Field;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for NV_FSEC_Register use record
      SEC    at 0 range 0 .. 1;
      FSLACC at 0 range 2 .. 3;
      MEEN   at 0 range 4 .. 5;
      KEYEN  at 0 range 6 .. 7;
   end record;

   --  no description available
   type FOPT_LPBOOT0_Field is
     (
      --  Core and system clock divider (OUTDIV1) is 0x7 (divide by 8) when
      --  LPBOOT1=0 or 0x1 (divide by 2) when LPBOOT1=1.
      FOPT_LPBOOT0_Field_00,
      --  Core and system clock divider (OUTDIV1) is 0x3 (divide by 4) when
      --  LPBOOT1=0 or 0x0 (divide by 1) when LPBOOT1=1.
      FOPT_LPBOOT0_Field_01)
     with Size => 1;
   for FOPT_LPBOOT0_Field use
     (FOPT_LPBOOT0_Field_00 => 0,
      FOPT_LPBOOT0_Field_01 => 1);

   --  no description available
   type FOPT_NMI_DIS_Field is
     (
      --  NMI interrupts are always blocked
      FOPT_NMI_DIS_Field_00,
      --  NMI_b pin/interrupts reset default to enabled
      FOPT_NMI_DIS_Field_01)
     with Size => 1;
   for FOPT_NMI_DIS_Field use
     (FOPT_NMI_DIS_Field_00 => 0,
      FOPT_NMI_DIS_Field_01 => 1);

   --  no description available
   type FOPT_RESET_PIN_CFG_Field is
     (
      --  RESET pin is disabled following a POR and cannot be enabled as reset
      --  function
      FOPT_RESET_PIN_CFG_Field_00,
      --  RESET_b pin is dedicated
      FOPT_RESET_PIN_CFG_Field_01)
     with Size => 1;
   for FOPT_RESET_PIN_CFG_Field use
     (FOPT_RESET_PIN_CFG_Field_00 => 0,
      FOPT_RESET_PIN_CFG_Field_01 => 1);

   --  no description available
   type FOPT_LPBOOT1_Field is
     (
      --  Core and system clock divider (OUTDIV1) is 0x7 (divide by 8) when
      --  LPBOOT0=0 or 0x3 (divide by 4) when LPBOOT0=1.
      FOPT_LPBOOT1_Field_00,
      --  Core and system clock divider (OUTDIV1) is 0x1 (divide by 2) when
      --  LPBOOT0=0 or 0x0 (divide by 1) when LPBOOT0=1.
      FOPT_LPBOOT1_Field_01)
     with Size => 1;
   for FOPT_LPBOOT1_Field use
     (FOPT_LPBOOT1_Field_00 => 0,
      FOPT_LPBOOT1_Field_01 => 1);

   --  no description available
   type FOPT_FAST_INIT_Field is
     (
      --  Slower initialization
      FOPT_FAST_INIT_Field_00,
      --  Fast Initialization
      FOPT_FAST_INIT_Field_01)
     with Size => 1;
   for FOPT_FAST_INIT_Field use
     (FOPT_FAST_INIT_Field_00 => 0,
      FOPT_FAST_INIT_Field_01 => 1);

   --  Non-volatile Flash Option Register
   type NV_FOPT_Register is record
      --  Read-only. no description available
      LPBOOT0       : FOPT_LPBOOT0_Field;
      --  unspecified
      Reserved_1_1  : MKL25Z4.Bit;
      --  Read-only. no description available
      NMI_DIS       : FOPT_NMI_DIS_Field;
      --  Read-only. no description available
      RESET_PIN_CFG : FOPT_RESET_PIN_CFG_Field;
      --  Read-only. no description available
      LPBOOT1       : FOPT_LPBOOT1_Field;
      --  Read-only. no description available
      FAST_INIT     : FOPT_FAST_INIT_Field;
      --  unspecified
      Reserved_6_7  : MKL25Z4.UInt2;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for NV_FOPT_Register use record
      LPBOOT0       at 0 range 0 .. 0;
      Reserved_1_1  at 0 range 1 .. 1;
      NMI_DIS       at 0 range 2 .. 2;
      RESET_PIN_CFG at 0 range 3 .. 3;
      LPBOOT1       at 0 range 4 .. 4;
      FAST_INIT     at 0 range 5 .. 5;
      Reserved_6_7  at 0 range 6 .. 7;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Flash configuration field
   type FTFA_FlashConfig_Peripheral is record
      --  Backdoor Comparison Key 3.
      BACKKEY3 : MKL25Z4.Byte;
      --  Backdoor Comparison Key 2.
      BACKKEY2 : MKL25Z4.Byte;
      --  Backdoor Comparison Key 1.
      BACKKEY1 : MKL25Z4.Byte;
      --  Backdoor Comparison Key 0.
      BACKKEY0 : MKL25Z4.Byte;
      --  Backdoor Comparison Key 7.
      BACKKEY7 : MKL25Z4.Byte;
      --  Backdoor Comparison Key 6.
      BACKKEY6 : MKL25Z4.Byte;
      --  Backdoor Comparison Key 5.
      BACKKEY5 : MKL25Z4.Byte;
      --  Backdoor Comparison Key 4.
      BACKKEY4 : MKL25Z4.Byte;
      --  Non-volatile P-Flash Protection 1 - Low Register
      FPROT3   : MKL25Z4.Byte;
      --  Non-volatile P-Flash Protection 1 - High Register
      FPROT2   : MKL25Z4.Byte;
      --  Non-volatile P-Flash Protection 0 - Low Register
      FPROT1   : MKL25Z4.Byte;
      --  Non-volatile P-Flash Protection 0 - High Register
      FPROT0   : MKL25Z4.Byte;
      --  Non-volatile Flash Security Register
      FSEC     : NV_FSEC_Register;
      --  Non-volatile Flash Option Register
      FOPT     : NV_FOPT_Register;
   end record
     with Volatile;

   for FTFA_FlashConfig_Peripheral use record
      BACKKEY3 at 0 range 0 .. 7;
      BACKKEY2 at 1 range 0 .. 7;
      BACKKEY1 at 2 range 0 .. 7;
      BACKKEY0 at 3 range 0 .. 7;
      BACKKEY7 at 4 range 0 .. 7;
      BACKKEY6 at 5 range 0 .. 7;
      BACKKEY5 at 6 range 0 .. 7;
      BACKKEY4 at 7 range 0 .. 7;
      FPROT3   at 8 range 0 .. 7;
      FPROT2   at 9 range 0 .. 7;
      FPROT1   at 10 range 0 .. 7;
      FPROT0   at 11 range 0 .. 7;
      FSEC     at 12 range 0 .. 7;
      FOPT     at 13 range 0 .. 7;
   end record;

   --  Flash configuration field
   FTFA_FlashConfig_Periph : aliased FTFA_FlashConfig_Peripheral
     with Import, Address => FTFA_FlashConfig_Base;

end MKL25Z4.FTFA_FlashConfig;
