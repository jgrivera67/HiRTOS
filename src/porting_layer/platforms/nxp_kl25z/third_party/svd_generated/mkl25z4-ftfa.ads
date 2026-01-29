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

--  Flash Memory Interface
package MKL25Z4.FTFA is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype FSTAT_MGSTAT0_Field is MKL25Z4.Bit;

   --  Flash Protection Violation Flag
   type FSTAT_FPVIOL_Field is
     (
      --  No protection violation detected
      FSTAT_FPVIOL_Field_0,
      --  Protection violation detected
      FSTAT_FPVIOL_Field_1)
     with Size => 1;
   for FSTAT_FPVIOL_Field use
     (FSTAT_FPVIOL_Field_0 => 0,
      FSTAT_FPVIOL_Field_1 => 1);

   --  Flash Access Error Flag
   type FSTAT_ACCERR_Field is
     (
      --  No access error detected
      FSTAT_ACCERR_Field_0,
      --  Access error detected
      FSTAT_ACCERR_Field_1)
     with Size => 1;
   for FSTAT_ACCERR_Field use
     (FSTAT_ACCERR_Field_0 => 0,
      FSTAT_ACCERR_Field_1 => 1);

   --  Flash Read Collision Error Flag
   type FSTAT_RDCOLERR_Field is
     (
      --  No collision error detected
      FSTAT_RDCOLERR_Field_0,
      --  Collision error detected
      FSTAT_RDCOLERR_Field_1)
     with Size => 1;
   for FSTAT_RDCOLERR_Field use
     (FSTAT_RDCOLERR_Field_0 => 0,
      FSTAT_RDCOLERR_Field_1 => 1);

   --  Command Complete Interrupt Flag
   type FSTAT_CCIF_Field is
     (
      --  Flash command in progress
      FSTAT_CCIF_Field_0,
      --  Flash command has completed
      FSTAT_CCIF_Field_1)
     with Size => 1;
   for FSTAT_CCIF_Field use
     (FSTAT_CCIF_Field_0 => 0,
      FSTAT_CCIF_Field_1 => 1);

   --  Flash Status Register
   type FTFA_FSTAT_Register is record
      --  Read-only. Memory Controller Command Completion Status Flag
      MGSTAT0      : FSTAT_MGSTAT0_Field := 16#0#;
      --  unspecified
      Reserved_1_3 : MKL25Z4.UInt3 := 16#0#;
      --  Flash Protection Violation Flag
      FPVIOL       : FSTAT_FPVIOL_Field := MKL25Z4.FTFA.FSTAT_FPVIOL_Field_0;
      --  Flash Access Error Flag
      ACCERR       : FSTAT_ACCERR_Field := MKL25Z4.FTFA.FSTAT_ACCERR_Field_0;
      --  Flash Read Collision Error Flag
      RDCOLERR     : FSTAT_RDCOLERR_Field :=
                      MKL25Z4.FTFA.FSTAT_RDCOLERR_Field_0;
      --  Command Complete Interrupt Flag
      CCIF         : FSTAT_CCIF_Field := MKL25Z4.FTFA.FSTAT_CCIF_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for FTFA_FSTAT_Register use record
      MGSTAT0      at 0 range 0 .. 0;
      Reserved_1_3 at 0 range 1 .. 3;
      FPVIOL       at 0 range 4 .. 4;
      ACCERR       at 0 range 5 .. 5;
      RDCOLERR     at 0 range 6 .. 6;
      CCIF         at 0 range 7 .. 7;
   end record;

   --  Erase Suspend
   type FCNFG_ERSSUSP_Field is
     (
      --  No suspend requested
      FCNFG_ERSSUSP_Field_0,
      --  Suspend the current Erase Flash Sector command execution.
      FCNFG_ERSSUSP_Field_1)
     with Size => 1;
   for FCNFG_ERSSUSP_Field use
     (FCNFG_ERSSUSP_Field_0 => 0,
      FCNFG_ERSSUSP_Field_1 => 1);

   --  Erase All Request
   type FCNFG_ERSAREQ_Field is
     (
      --  No request or request complete
      FCNFG_ERSAREQ_Field_0,
      --  Request to: run the Erase All Blocks command, verify the erased
      --  state, program the security byte in the Flash Configuration Field to
      --  the unsecure state, and release MCU security by setting the FSEC[SEC]
      --  field to the unsecure state.
      FCNFG_ERSAREQ_Field_1)
     with Size => 1;
   for FCNFG_ERSAREQ_Field use
     (FCNFG_ERSAREQ_Field_0 => 0,
      FCNFG_ERSAREQ_Field_1 => 1);

   --  Read Collision Error Interrupt Enable
   type FCNFG_RDCOLLIE_Field is
     (
      --  Read collision error interrupt disabled
      FCNFG_RDCOLLIE_Field_0,
      --  Read collision error interrupt enabled. An interrupt request is
      --  generated whenever a flash memory read collision error is detected
      --  (see the description of FSTAT[RDCOLERR]).
      FCNFG_RDCOLLIE_Field_1)
     with Size => 1;
   for FCNFG_RDCOLLIE_Field use
     (FCNFG_RDCOLLIE_Field_0 => 0,
      FCNFG_RDCOLLIE_Field_1 => 1);

   --  Command Complete Interrupt Enable
   type FCNFG_CCIE_Field is
     (
      --  Command complete interrupt disabled
      FCNFG_CCIE_Field_0,
      --  Command complete interrupt enabled. An interrupt request is generated
      --  whenever the FSTAT[CCIF] flag is set.
      FCNFG_CCIE_Field_1)
     with Size => 1;
   for FCNFG_CCIE_Field use
     (FCNFG_CCIE_Field_0 => 0,
      FCNFG_CCIE_Field_1 => 1);

   --  Flash Configuration Register
   type FTFA_FCNFG_Register is record
      --  unspecified
      Reserved_0_3 : MKL25Z4.UInt4 := 16#0#;
      --  Erase Suspend
      ERSSUSP      : FCNFG_ERSSUSP_Field :=
                      MKL25Z4.FTFA.FCNFG_ERSSUSP_Field_0;
      --  Read-only. Erase All Request
      ERSAREQ      : FCNFG_ERSAREQ_Field :=
                      MKL25Z4.FTFA.FCNFG_ERSAREQ_Field_0;
      --  Read Collision Error Interrupt Enable
      RDCOLLIE     : FCNFG_RDCOLLIE_Field :=
                      MKL25Z4.FTFA.FCNFG_RDCOLLIE_Field_0;
      --  Command Complete Interrupt Enable
      CCIE         : FCNFG_CCIE_Field := MKL25Z4.FTFA.FCNFG_CCIE_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for FTFA_FCNFG_Register use record
      Reserved_0_3 at 0 range 0 .. 3;
      ERSSUSP      at 0 range 4 .. 4;
      ERSAREQ      at 0 range 5 .. 5;
      RDCOLLIE     at 0 range 6 .. 6;
      CCIE         at 0 range 7 .. 7;
   end record;

   --  Flash Security
   type FSEC_SEC_Field is
     (
      --  MCU security status is secure
      FSEC_SEC_Field_00,
      --  MCU security status is secure
      FSEC_SEC_Field_01,
      --  MCU security status is unsecure (The standard shipping condition of
      --  the flash memory module is unsecure.)
      FSEC_SEC_Field_10,
      --  MCU security status is secure
      FSEC_SEC_Field_11)
     with Size => 2;
   for FSEC_SEC_Field use
     (FSEC_SEC_Field_00 => 0,
      FSEC_SEC_Field_01 => 1,
      FSEC_SEC_Field_10 => 2,
      FSEC_SEC_Field_11 => 3);

   --  Freescale Failure Analysis Access Code
   type FSEC_FSLACC_Field is
     (
      --  Freescale factory access granted
      FSEC_FSLACC_Field_00,
      --  Freescale factory access denied
      FSEC_FSLACC_Field_01,
      --  Freescale factory access denied
      FSEC_FSLACC_Field_10,
      --  Freescale factory access granted
      FSEC_FSLACC_Field_11)
     with Size => 2;
   for FSEC_FSLACC_Field use
     (FSEC_FSLACC_Field_00 => 0,
      FSEC_FSLACC_Field_01 => 1,
      FSEC_FSLACC_Field_10 => 2,
      FSEC_FSLACC_Field_11 => 3);

   --  Mass Erase Enable Bits
   type FSEC_MEEN_Field is
     (
      --  Mass erase is enabled
      FSEC_MEEN_Field_00,
      --  Mass erase is enabled
      FSEC_MEEN_Field_01,
      --  Mass erase is disabled
      FSEC_MEEN_Field_10,
      --  Mass erase is enabled
      FSEC_MEEN_Field_11)
     with Size => 2;
   for FSEC_MEEN_Field use
     (FSEC_MEEN_Field_00 => 0,
      FSEC_MEEN_Field_01 => 1,
      FSEC_MEEN_Field_10 => 2,
      FSEC_MEEN_Field_11 => 3);

   --  Backdoor Key Security Enable
   type FSEC_KEYEN_Field is
     (
      --  Backdoor key access disabled
      FSEC_KEYEN_Field_00,
      --  Backdoor key access disabled (preferred KEYEN state to disable
      --  backdoor key access)
      FSEC_KEYEN_Field_01,
      --  Backdoor key access enabled
      FSEC_KEYEN_Field_10,
      --  Backdoor key access disabled
      FSEC_KEYEN_Field_11)
     with Size => 2;
   for FSEC_KEYEN_Field use
     (FSEC_KEYEN_Field_00 => 0,
      FSEC_KEYEN_Field_01 => 1,
      FSEC_KEYEN_Field_10 => 2,
      FSEC_KEYEN_Field_11 => 3);

   --  Flash Security Register
   type FTFA_FSEC_Register is record
      --  Read-only. Flash Security
      SEC    : FSEC_SEC_Field;
      --  Read-only. Freescale Failure Analysis Access Code
      FSLACC : FSEC_FSLACC_Field;
      --  Read-only. Mass Erase Enable Bits
      MEEN   : FSEC_MEEN_Field;
      --  Read-only. Backdoor Key Security Enable
      KEYEN  : FSEC_KEYEN_Field;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for FTFA_FSEC_Register use record
      SEC    at 0 range 0 .. 1;
      FSLACC at 0 range 2 .. 3;
      MEEN   at 0 range 4 .. 5;
      KEYEN  at 0 range 6 .. 7;
   end record;

   --  Flash Common Command Object Registers
   type FTFA_FCCOB_Registers is record
      FCCOB3 : MKL25Z4.Byte;
      FCCOB2 : MKL25Z4.Byte;
      FCCOB1 : MKL25Z4.Byte;
      FCCOB0 : MKL25Z4.Byte;
      FCCOB7 : MKL25Z4.Byte;
      FCCOB6 : MKL25Z4.Byte;
      FCCOB5 : MKL25Z4.Byte;
      FCCOB4 : MKL25Z4.Byte;
      FCCOBB : MKL25Z4.Byte;
      FCCOBA : MKL25Z4.Byte;
      FCCOB9 : MKL25Z4.Byte;
      FCCOB8 : MKL25Z4.Byte;
   end record;

   for FTFA_FCCOB_Registers use record
      FCCOB3 at 0 range 0 .. 7;
      FCCOB2 at 1 range 0 .. 7;
      FCCOB1 at 2 range 0 .. 7;
      FCCOB0 at 3 range 0 .. 7;
      FCCOB7 at 4 range 0 .. 7;
      FCCOB6 at 5 range 0 .. 7;
      FCCOB5 at 6 range 0 .. 7;
      FCCOB4 at 7 range 0 .. 7;
      FCCOBB at 8 range 0 .. 7;
      FCCOBA at 9 range 0 .. 7;
      FCCOB9 at 10 range 0 .. 7;
      FCCOB8 at 11 range 0 .. 7;
   end record;

   --  Program Flash Protection Registers
   type FTFA_FPROT_Registers is record
      FPROT3 : MKL25Z4.Byte;
      FPROT2 : MKL25Z4.Byte;
      FPROT1 : MKL25Z4.Byte;
      FPROT0 : MKL25Z4.Byte;
   end record;

   for FTFA_FPROT_Registers use record
      FPROT3 at 0 range 0 .. 7;
      FPROT2 at 1 range 0 .. 7;
      FPROT1 at 2 range 0 .. 7;
      FPROT0 at 3 range 0 .. 7;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Flash Memory Interface
   type FTFA_Peripheral is record
      --  Flash Status Register
      FSTAT : FTFA_FSTAT_Register;
      --  Flash Configuration Register
      FCNFG : FTFA_FCNFG_Register;
      --  Flash Security Register
      FSEC  : FTFA_FSEC_Register;
      --  Flash Option Register
      FOPT  : MKL25Z4.Byte;
      --  Flash Common Command Object Registers
      FCCOB : FTFA_FCCOB_Registers;
      --  Program Flash Protection Registers
      FPROT : FTFA_FPROT_Registers;
   end record
     with Volatile;

   for FTFA_Peripheral use record
      FSTAT at 0 range 0 .. 7;
      FCNFG at 1 range 0 .. 7;
      FSEC  at 2 range 0 .. 7;
      FOPT  at 3 range 0 .. 7;
      FCCOB at 4 range 0 .. 95;
      FPROT at 16 range 0 .. 31;
   end record;

   --  Flash Memory Interface
   FTFA_Periph : aliased FTFA_Peripheral
     with Import, Address => FTFA_Base;

end MKL25Z4.FTFA;
