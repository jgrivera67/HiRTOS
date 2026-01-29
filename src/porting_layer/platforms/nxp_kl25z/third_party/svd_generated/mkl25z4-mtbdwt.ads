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

--  MTB data watchpoint and trace
package MKL25Z4.MTBDWT is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype CTRL_DWTCFGCTRL_Field is MKL25Z4.UInt28;
   subtype CTRL_NUMCMP_Field is MKL25Z4.UInt4;

   --  MTB DWT Control Register
   type MTBDWT_CTRL_Register is record
      --  Read-only. DWT configuration controls
      DWTCFGCTRL : CTRL_DWTCFGCTRL_Field;
      --  Read-only. Number of comparators
      NUMCMP     : CTRL_NUMCMP_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MTBDWT_CTRL_Register use record
      DWTCFGCTRL at 0 range 0 .. 27;
      NUMCMP     at 0 range 28 .. 31;
   end record;

   subtype MASK0_MASK_Field is MKL25Z4.UInt5;

   --  MTB_DWT Comparator Mask Register
   type MASK_Register is record
      --  MASK
      MASK          : MASK0_MASK_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : MKL25Z4.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MASK_Register use record
      MASK          at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   --  Function
   type FCT0_FUNCTION_Field is
     (
      --  Disabled.
      FCT0_FUNCTION_Field_0000,
      --  Instruction fetch.
      FCT0_FUNCTION_Field_0100,
      --  Data operand read.
      FCT0_FUNCTION_Field_0101,
      --  Data operand write.
      FCT0_FUNCTION_Field_0110,
      --  Data operand (read + write).
      FCT0_FUNCTION_Field_0111)
     with Size => 4;
   for FCT0_FUNCTION_Field use
     (FCT0_FUNCTION_Field_0000 => 0,
      FCT0_FUNCTION_Field_0100 => 4,
      FCT0_FUNCTION_Field_0101 => 5,
      FCT0_FUNCTION_Field_0110 => 6,
      FCT0_FUNCTION_Field_0111 => 7);

   --  Data Value Match
   type FCT0_DATAVMATCH_Field is
     (
      --  Perform address comparison.
      FCT0_DATAVMATCH_Field_0,
      --  Perform data value comparison.
      FCT0_DATAVMATCH_Field_1)
     with Size => 1;
   for FCT0_DATAVMATCH_Field use
     (FCT0_DATAVMATCH_Field_0 => 0,
      FCT0_DATAVMATCH_Field_1 => 1);

   --  Data Value Size
   type FCT0_DATAVSIZE_Field is
     (
      --  Byte.
      FCT0_DATAVSIZE_Field_00,
      --  Halfword.
      FCT0_DATAVSIZE_Field_01,
      --  Word.
      FCT0_DATAVSIZE_Field_10,
      --  Reserved. Any attempts to use this value results in UNPREDICTABLE
      --  behavior.
      FCT0_DATAVSIZE_Field_11)
     with Size => 2;
   for FCT0_DATAVSIZE_Field use
     (FCT0_DATAVSIZE_Field_00 => 0,
      FCT0_DATAVSIZE_Field_01 => 1,
      FCT0_DATAVSIZE_Field_10 => 2,
      FCT0_DATAVSIZE_Field_11 => 3);

   subtype FCT0_DATAVADDR0_Field is MKL25Z4.UInt4;

   --  Comparator match
   type FCT0_MATCHED_Field is
     (
      --  No match.
      FCT0_MATCHED_Field_0,
      --  Match occurred.
      FCT0_MATCHED_Field_1)
     with Size => 1;
   for FCT0_MATCHED_Field use
     (FCT0_MATCHED_Field_0 => 0,
      FCT0_MATCHED_Field_1 => 1);

   --  MTB_DWT Comparator Function Register 0
   type MTBDWT_FCT0_Register is record
      --  Function
      FUNCTION_k     : FCT0_FUNCTION_Field :=
                        MKL25Z4.MTBDWT.FCT0_FUNCTION_Field_0000;
      --  unspecified
      Reserved_4_7   : MKL25Z4.UInt4 := 16#0#;
      --  Data Value Match
      DATAVMATCH     : FCT0_DATAVMATCH_Field :=
                        MKL25Z4.MTBDWT.FCT0_DATAVMATCH_Field_0;
      --  unspecified
      Reserved_9_9   : MKL25Z4.Bit := 16#0#;
      --  Data Value Size
      DATAVSIZE      : FCT0_DATAVSIZE_Field :=
                        MKL25Z4.MTBDWT.FCT0_DATAVSIZE_Field_00;
      --  Data Value Address 0
      DATAVADDR0     : FCT0_DATAVADDR0_Field := 16#0#;
      --  unspecified
      Reserved_16_23 : MKL25Z4.Byte := 16#0#;
      --  Read-only. Comparator match
      MATCHED        : FCT0_MATCHED_Field :=
                        MKL25Z4.MTBDWT.FCT0_MATCHED_Field_0;
      --  unspecified
      Reserved_25_31 : MKL25Z4.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MTBDWT_FCT0_Register use record
      FUNCTION_k     at 0 range 0 .. 3;
      Reserved_4_7   at 0 range 4 .. 7;
      DATAVMATCH     at 0 range 8 .. 8;
      Reserved_9_9   at 0 range 9 .. 9;
      DATAVSIZE      at 0 range 10 .. 11;
      DATAVADDR0     at 0 range 12 .. 15;
      Reserved_16_23 at 0 range 16 .. 23;
      MATCHED        at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   --  Function
   type FCT1_FUNCTION_Field is
     (
      --  Disabled.
      FCT1_FUNCTION_Field_0000,
      --  Instruction fetch.
      FCT1_FUNCTION_Field_0100,
      --  Data operand read.
      FCT1_FUNCTION_Field_0101,
      --  Data operand write.
      FCT1_FUNCTION_Field_0110,
      --  Data operand (read + write).
      FCT1_FUNCTION_Field_0111)
     with Size => 4;
   for FCT1_FUNCTION_Field use
     (FCT1_FUNCTION_Field_0000 => 0,
      FCT1_FUNCTION_Field_0100 => 4,
      FCT1_FUNCTION_Field_0101 => 5,
      FCT1_FUNCTION_Field_0110 => 6,
      FCT1_FUNCTION_Field_0111 => 7);

   --  Comparator match
   type FCT1_MATCHED_Field is
     (
      --  No match.
      FCT1_MATCHED_Field_0,
      --  Match occurred.
      FCT1_MATCHED_Field_1)
     with Size => 1;
   for FCT1_MATCHED_Field use
     (FCT1_MATCHED_Field_0 => 0,
      FCT1_MATCHED_Field_1 => 1);

   --  MTB_DWT Comparator Function Register 1
   type MTBDWT_FCT1_Register is record
      --  Function
      FUNCTION_k     : FCT1_FUNCTION_Field :=
                        MKL25Z4.MTBDWT.FCT1_FUNCTION_Field_0000;
      --  unspecified
      Reserved_4_23  : MKL25Z4.UInt20 := 16#0#;
      --  Read-only. Comparator match
      MATCHED        : FCT1_MATCHED_Field :=
                        MKL25Z4.MTBDWT.FCT1_MATCHED_Field_0;
      --  unspecified
      Reserved_25_31 : MKL25Z4.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MTBDWT_FCT1_Register use record
      FUNCTION_k     at 0 range 0 .. 3;
      Reserved_4_23  at 0 range 4 .. 23;
      MATCHED        at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   --  Action based on Comparator 0 match
   type TBCTRL_ACOMP0_Field is
     (
      --  Trigger TSTOP based on the assertion of MTBDWT_FCT0[MATCHED].
      TBCTRL_ACOMP0_Field_0,
      --  Trigger TSTART based on the assertion of MTBDWT_FCT0[MATCHED].
      TBCTRL_ACOMP0_Field_1)
     with Size => 1;
   for TBCTRL_ACOMP0_Field use
     (TBCTRL_ACOMP0_Field_0 => 0,
      TBCTRL_ACOMP0_Field_1 => 1);

   --  Action based on Comparator 1 match
   type TBCTRL_ACOMP1_Field is
     (
      --  Trigger TSTOP based on the assertion of MTBDWT_FCT1[MATCHED].
      TBCTRL_ACOMP1_Field_0,
      --  Trigger TSTART based on the assertion of MTBDWT_FCT1[MATCHED].
      TBCTRL_ACOMP1_Field_1)
     with Size => 1;
   for TBCTRL_ACOMP1_Field use
     (TBCTRL_ACOMP1_Field_0 => 0,
      TBCTRL_ACOMP1_Field_1 => 1);

   subtype TBCTRL_NUMCOMP_Field is MKL25Z4.UInt4;

   --  MTB_DWT Trace Buffer Control Register
   type MTBDWT_TBCTRL_Register is record
      --  Action based on Comparator 0 match
      ACOMP0        : TBCTRL_ACOMP0_Field :=
                       MKL25Z4.MTBDWT.TBCTRL_ACOMP0_Field_0;
      --  Action based on Comparator 1 match
      ACOMP1        : TBCTRL_ACOMP1_Field :=
                       MKL25Z4.MTBDWT.TBCTRL_ACOMP1_Field_0;
      --  unspecified
      Reserved_2_27 : MKL25Z4.UInt26 := 16#0#;
      --  Read-only. Number of Comparators
      NUMCOMP       : TBCTRL_NUMCOMP_Field := 16#2#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MTBDWT_TBCTRL_Register use record
      ACOMP0        at 0 range 0 .. 0;
      ACOMP1        at 0 range 1 .. 1;
      Reserved_2_27 at 0 range 2 .. 27;
      NUMCOMP       at 0 range 28 .. 31;
   end record;

   --  Peripheral ID Register

   --  Peripheral ID Register
   type MTBDWT_PERIPHID_Registers is array (0 .. 7) of MKL25Z4.Word;

   --  Component ID Register

   --  Component ID Register
   type MTBDWT_COMPID_Registers is array (0 .. 3) of MKL25Z4.Word;

   -----------------
   -- Peripherals --
   -----------------

   --  MTB data watchpoint and trace
   type MTBDWT_Peripheral is record
      --  MTB DWT Control Register
      CTRL        : MTBDWT_CTRL_Register;
      --  MTB_DWT Comparator Register
      COMP0       : MKL25Z4.Word;
      --  MTB_DWT Comparator Mask Register
      MASK0       : MASK_Register;
      --  MTB_DWT Comparator Function Register 0
      FCT0        : MTBDWT_FCT0_Register;
      --  MTB_DWT Comparator Register
      COMP1       : MKL25Z4.Word;
      --  MTB_DWT Comparator Mask Register
      MASK1       : MASK_Register;
      --  MTB_DWT Comparator Function Register 1
      FCT1        : MTBDWT_FCT1_Register;
      --  MTB_DWT Trace Buffer Control Register
      TBCTRL      : MTBDWT_TBCTRL_Register;
      --  Device Configuration Register
      DEVICECFG   : MKL25Z4.Word;
      --  Device Type Identifier Register
      DEVICETYPID : MKL25Z4.Word;
      --  Peripheral ID Register
      PERIPHID    : MTBDWT_PERIPHID_Registers;
      --  Component ID Register
      COMPID      : MTBDWT_COMPID_Registers;
   end record
     with Volatile;

   for MTBDWT_Peripheral use record
      CTRL        at 0 range 0 .. 31;
      COMP0       at 32 range 0 .. 31;
      MASK0       at 36 range 0 .. 31;
      FCT0        at 40 range 0 .. 31;
      COMP1       at 48 range 0 .. 31;
      MASK1       at 52 range 0 .. 31;
      FCT1        at 56 range 0 .. 31;
      TBCTRL      at 512 range 0 .. 31;
      DEVICECFG   at 4040 range 0 .. 31;
      DEVICETYPID at 4044 range 0 .. 31;
      PERIPHID    at 4048 range 0 .. 255;
      COMPID      at 4080 range 0 .. 127;
   end record;

   --  MTB data watchpoint and trace
   MTBDWT_Periph : aliased MTBDWT_Peripheral
     with Import, Address => MTBDWT_Base;

end MKL25Z4.MTBDWT;
