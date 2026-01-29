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

--  Low leakage wakeup unit
package MKL25Z4.LLWU is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Wakeup Pin Enable For LLWU_P0
   type PE1_WUPE0_Field is
     (
      --  External input pin disabled as wakeup input
      PE1_WUPE0_Field_00,
      --  External input pin enabled with rising edge detection
      PE1_WUPE0_Field_01,
      --  External input pin enabled with falling edge detection
      PE1_WUPE0_Field_10,
      --  External input pin enabled with any change detection
      PE1_WUPE0_Field_11)
     with Size => 2;
   for PE1_WUPE0_Field use
     (PE1_WUPE0_Field_00 => 0,
      PE1_WUPE0_Field_01 => 1,
      PE1_WUPE0_Field_10 => 2,
      PE1_WUPE0_Field_11 => 3);

   --  PE1_WUPE array
   type PE1_WUPE_Field_Array is array (0 .. 3) of PE1_WUPE0_Field
     with Component_Size => 2, Size => 8;

   --  LLWU Pin Enable 1 register
   type LLWU_PE1_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  WUPE as a value
            Val : MKL25Z4.Byte;
         when True =>
            --  WUPE as an array
            Arr : PE1_WUPE_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 8, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for LLWU_PE1_Register use record
      Val at 0 range 0 .. 7;
      Arr at 0 range 0 .. 7;
   end record;

   --  Wakeup Pin Enable For LLWU_P4
   type PE2_WUPE4_Field is
     (
      --  External input pin disabled as wakeup input
      PE2_WUPE4_Field_00,
      --  External input pin enabled with rising edge detection
      PE2_WUPE4_Field_01,
      --  External input pin enabled with falling edge detection
      PE2_WUPE4_Field_10,
      --  External input pin enabled with any change detection
      PE2_WUPE4_Field_11)
     with Size => 2;
   for PE2_WUPE4_Field use
     (PE2_WUPE4_Field_00 => 0,
      PE2_WUPE4_Field_01 => 1,
      PE2_WUPE4_Field_10 => 2,
      PE2_WUPE4_Field_11 => 3);

   --  PE2_WUPE array
   type PE2_WUPE_Field_Array is array (4 .. 7) of PE2_WUPE4_Field
     with Component_Size => 2, Size => 8;

   --  LLWU Pin Enable 2 register
   type LLWU_PE2_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  WUPE as a value
            Val : MKL25Z4.Byte;
         when True =>
            --  WUPE as an array
            Arr : PE2_WUPE_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 8, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for LLWU_PE2_Register use record
      Val at 0 range 0 .. 7;
      Arr at 0 range 0 .. 7;
   end record;

   --  Wakeup Pin Enable For LLWU_P8
   type PE3_WUPE8_Field is
     (
      --  External input pin disabled as wakeup input
      PE3_WUPE8_Field_00,
      --  External input pin enabled with rising edge detection
      PE3_WUPE8_Field_01,
      --  External input pin enabled with falling edge detection
      PE3_WUPE8_Field_10,
      --  External input pin enabled with any change detection
      PE3_WUPE8_Field_11)
     with Size => 2;
   for PE3_WUPE8_Field use
     (PE3_WUPE8_Field_00 => 0,
      PE3_WUPE8_Field_01 => 1,
      PE3_WUPE8_Field_10 => 2,
      PE3_WUPE8_Field_11 => 3);

   --  PE3_WUPE array
   type PE3_WUPE_Field_Array is array (8 .. 11) of PE3_WUPE8_Field
     with Component_Size => 2, Size => 8;

   --  LLWU Pin Enable 3 register
   type LLWU_PE3_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  WUPE as a value
            Val : MKL25Z4.Byte;
         when True =>
            --  WUPE as an array
            Arr : PE3_WUPE_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 8, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for LLWU_PE3_Register use record
      Val at 0 range 0 .. 7;
      Arr at 0 range 0 .. 7;
   end record;

   --  Wakeup Pin Enable For LLWU_P12
   type PE4_WUPE12_Field is
     (
      --  External input pin disabled as wakeup input
      PE4_WUPE12_Field_00,
      --  External input pin enabled with rising edge detection
      PE4_WUPE12_Field_01,
      --  External input pin enabled with falling edge detection
      PE4_WUPE12_Field_10,
      --  External input pin enabled with any change detection
      PE4_WUPE12_Field_11)
     with Size => 2;
   for PE4_WUPE12_Field use
     (PE4_WUPE12_Field_00 => 0,
      PE4_WUPE12_Field_01 => 1,
      PE4_WUPE12_Field_10 => 2,
      PE4_WUPE12_Field_11 => 3);

   --  PE4_WUPE array
   type PE4_WUPE_Field_Array is array (12 .. 15) of PE4_WUPE12_Field
     with Component_Size => 2, Size => 8;

   --  LLWU Pin Enable 4 register
   type LLWU_PE4_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  WUPE as a value
            Val : MKL25Z4.Byte;
         when True =>
            --  WUPE as an array
            Arr : PE4_WUPE_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 8, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for LLWU_PE4_Register use record
      Val at 0 range 0 .. 7;
      Arr at 0 range 0 .. 7;
   end record;

   --  Wakeup Module Enable For Module 0
   type ME_WUME0_Field is
     (
      --  Internal module flag not used as wakeup source
      ME_WUME0_Field_0,
      --  Internal module flag used as wakeup source
      ME_WUME0_Field_1)
     with Size => 1;
   for ME_WUME0_Field use
     (ME_WUME0_Field_0 => 0,
      ME_WUME0_Field_1 => 1);

   --  ME_WUME array
   type ME_WUME_Field_Array is array (0 .. 7) of ME_WUME0_Field
     with Component_Size => 1, Size => 8;

   --  LLWU Module Enable register
   type LLWU_ME_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  WUME as a value
            Val : MKL25Z4.Byte;
         when True =>
            --  WUME as an array
            Arr : ME_WUME_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 8, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for LLWU_ME_Register use record
      Val at 0 range 0 .. 7;
      Arr at 0 range 0 .. 7;
   end record;

   --  Wakeup Flag For LLWU_P0
   type F1_WUF0_Field is
     (
      --  LLWU_P0 input was not a wakeup source
      F1_WUF0_Field_0,
      --  LLWU_P0 input was a wakeup source
      F1_WUF0_Field_1)
     with Size => 1;
   for F1_WUF0_Field use
     (F1_WUF0_Field_0 => 0,
      F1_WUF0_Field_1 => 1);

   --  Wakeup Flag For LLWU_P1
   type F1_WUF1_Field is
     (
      --  LLWU_P1 input was not a wakeup source
      F1_WUF1_Field_0,
      --  LLWU_P1 input was a wakeup source
      F1_WUF1_Field_1)
     with Size => 1;
   for F1_WUF1_Field use
     (F1_WUF1_Field_0 => 0,
      F1_WUF1_Field_1 => 1);

   --  Wakeup Flag For LLWU_P2
   type F1_WUF2_Field is
     (
      --  LLWU_P2 input was not a wakeup source
      F1_WUF2_Field_0,
      --  LLWU_P2 input was a wakeup source
      F1_WUF2_Field_1)
     with Size => 1;
   for F1_WUF2_Field use
     (F1_WUF2_Field_0 => 0,
      F1_WUF2_Field_1 => 1);

   --  Wakeup Flag For LLWU_P3
   type F1_WUF3_Field is
     (
      --  LLWU_P3 input was not a wakeup source
      F1_WUF3_Field_0,
      --  LLWU_P3 input was a wakeup source
      F1_WUF3_Field_1)
     with Size => 1;
   for F1_WUF3_Field use
     (F1_WUF3_Field_0 => 0,
      F1_WUF3_Field_1 => 1);

   --  Wakeup Flag For LLWU_P4
   type F1_WUF4_Field is
     (
      --  LLWU_P4 input was not a wakeup source
      F1_WUF4_Field_0,
      --  LLWU_P4 input was a wakeup source
      F1_WUF4_Field_1)
     with Size => 1;
   for F1_WUF4_Field use
     (F1_WUF4_Field_0 => 0,
      F1_WUF4_Field_1 => 1);

   --  Wakeup Flag For LLWU_P5
   type F1_WUF5_Field is
     (
      --  LLWU_P5 input was not a wakeup source
      F1_WUF5_Field_0,
      --  LLWU_P5 input was a wakeup source
      F1_WUF5_Field_1)
     with Size => 1;
   for F1_WUF5_Field use
     (F1_WUF5_Field_0 => 0,
      F1_WUF5_Field_1 => 1);

   --  Wakeup Flag For LLWU_P6
   type F1_WUF6_Field is
     (
      --  LLWU_P6 input was not a wakeup source
      F1_WUF6_Field_0,
      --  LLWU_P6 input was a wakeup source
      F1_WUF6_Field_1)
     with Size => 1;
   for F1_WUF6_Field use
     (F1_WUF6_Field_0 => 0,
      F1_WUF6_Field_1 => 1);

   --  Wakeup Flag For LLWU_P7
   type F1_WUF7_Field is
     (
      --  LLWU_P7 input was not a wakeup source
      F1_WUF7_Field_0,
      --  LLWU_P7 input was a wakeup source
      F1_WUF7_Field_1)
     with Size => 1;
   for F1_WUF7_Field use
     (F1_WUF7_Field_0 => 0,
      F1_WUF7_Field_1 => 1);

   --  LLWU Flag 1 register
   type LLWU_F1_Register is record
      --  Wakeup Flag For LLWU_P0
      WUF0 : F1_WUF0_Field := MKL25Z4.LLWU.F1_WUF0_Field_0;
      --  Wakeup Flag For LLWU_P1
      WUF1 : F1_WUF1_Field := MKL25Z4.LLWU.F1_WUF1_Field_0;
      --  Wakeup Flag For LLWU_P2
      WUF2 : F1_WUF2_Field := MKL25Z4.LLWU.F1_WUF2_Field_0;
      --  Wakeup Flag For LLWU_P3
      WUF3 : F1_WUF3_Field := MKL25Z4.LLWU.F1_WUF3_Field_0;
      --  Wakeup Flag For LLWU_P4
      WUF4 : F1_WUF4_Field := MKL25Z4.LLWU.F1_WUF4_Field_0;
      --  Wakeup Flag For LLWU_P5
      WUF5 : F1_WUF5_Field := MKL25Z4.LLWU.F1_WUF5_Field_0;
      --  Wakeup Flag For LLWU_P6
      WUF6 : F1_WUF6_Field := MKL25Z4.LLWU.F1_WUF6_Field_0;
      --  Wakeup Flag For LLWU_P7
      WUF7 : F1_WUF7_Field := MKL25Z4.LLWU.F1_WUF7_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for LLWU_F1_Register use record
      WUF0 at 0 range 0 .. 0;
      WUF1 at 0 range 1 .. 1;
      WUF2 at 0 range 2 .. 2;
      WUF3 at 0 range 3 .. 3;
      WUF4 at 0 range 4 .. 4;
      WUF5 at 0 range 5 .. 5;
      WUF6 at 0 range 6 .. 6;
      WUF7 at 0 range 7 .. 7;
   end record;

   --  Wakeup Flag For LLWU_P8
   type F2_WUF8_Field is
     (
      --  LLWU_P8 input was not a wakeup source
      F2_WUF8_Field_0,
      --  LLWU_P8 input was a wakeup source
      F2_WUF8_Field_1)
     with Size => 1;
   for F2_WUF8_Field use
     (F2_WUF8_Field_0 => 0,
      F2_WUF8_Field_1 => 1);

   --  Wakeup Flag For LLWU_P9
   type F2_WUF9_Field is
     (
      --  LLWU_P9 input was not a wakeup source
      F2_WUF9_Field_0,
      --  LLWU_P9 input was a wakeup source
      F2_WUF9_Field_1)
     with Size => 1;
   for F2_WUF9_Field use
     (F2_WUF9_Field_0 => 0,
      F2_WUF9_Field_1 => 1);

   --  Wakeup Flag For LLWU_P10
   type F2_WUF10_Field is
     (
      --  LLWU_P10 input was not a wakeup source
      F2_WUF10_Field_0,
      --  LLWU_P10 input was a wakeup source
      F2_WUF10_Field_1)
     with Size => 1;
   for F2_WUF10_Field use
     (F2_WUF10_Field_0 => 0,
      F2_WUF10_Field_1 => 1);

   --  Wakeup Flag For LLWU_P11
   type F2_WUF11_Field is
     (
      --  LLWU_P11 input was not a wakeup source
      F2_WUF11_Field_0,
      --  LLWU_P11 input was a wakeup source
      F2_WUF11_Field_1)
     with Size => 1;
   for F2_WUF11_Field use
     (F2_WUF11_Field_0 => 0,
      F2_WUF11_Field_1 => 1);

   --  Wakeup Flag For LLWU_P12
   type F2_WUF12_Field is
     (
      --  LLWU_P12 input was not a wakeup source
      F2_WUF12_Field_0,
      --  LLWU_P12 input was a wakeup source
      F2_WUF12_Field_1)
     with Size => 1;
   for F2_WUF12_Field use
     (F2_WUF12_Field_0 => 0,
      F2_WUF12_Field_1 => 1);

   --  Wakeup Flag For LLWU_P13
   type F2_WUF13_Field is
     (
      --  LLWU_P13 input was not a wakeup source
      F2_WUF13_Field_0,
      --  LLWU_P13 input was a wakeup source
      F2_WUF13_Field_1)
     with Size => 1;
   for F2_WUF13_Field use
     (F2_WUF13_Field_0 => 0,
      F2_WUF13_Field_1 => 1);

   --  Wakeup Flag For LLWU_P14
   type F2_WUF14_Field is
     (
      --  LLWU_P14 input was not a wakeup source
      F2_WUF14_Field_0,
      --  LLWU_P14 input was a wakeup source
      F2_WUF14_Field_1)
     with Size => 1;
   for F2_WUF14_Field use
     (F2_WUF14_Field_0 => 0,
      F2_WUF14_Field_1 => 1);

   --  Wakeup Flag For LLWU_P15
   type F2_WUF15_Field is
     (
      --  LLWU_P15 input was not a wakeup source
      F2_WUF15_Field_0,
      --  LLWU_P15 input was a wakeup source
      F2_WUF15_Field_1)
     with Size => 1;
   for F2_WUF15_Field use
     (F2_WUF15_Field_0 => 0,
      F2_WUF15_Field_1 => 1);

   --  LLWU Flag 2 register
   type LLWU_F2_Register is record
      --  Wakeup Flag For LLWU_P8
      WUF8  : F2_WUF8_Field := MKL25Z4.LLWU.F2_WUF8_Field_0;
      --  Wakeup Flag For LLWU_P9
      WUF9  : F2_WUF9_Field := MKL25Z4.LLWU.F2_WUF9_Field_0;
      --  Wakeup Flag For LLWU_P10
      WUF10 : F2_WUF10_Field := MKL25Z4.LLWU.F2_WUF10_Field_0;
      --  Wakeup Flag For LLWU_P11
      WUF11 : F2_WUF11_Field := MKL25Z4.LLWU.F2_WUF11_Field_0;
      --  Wakeup Flag For LLWU_P12
      WUF12 : F2_WUF12_Field := MKL25Z4.LLWU.F2_WUF12_Field_0;
      --  Wakeup Flag For LLWU_P13
      WUF13 : F2_WUF13_Field := MKL25Z4.LLWU.F2_WUF13_Field_0;
      --  Wakeup Flag For LLWU_P14
      WUF14 : F2_WUF14_Field := MKL25Z4.LLWU.F2_WUF14_Field_0;
      --  Wakeup Flag For LLWU_P15
      WUF15 : F2_WUF15_Field := MKL25Z4.LLWU.F2_WUF15_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for LLWU_F2_Register use record
      WUF8  at 0 range 0 .. 0;
      WUF9  at 0 range 1 .. 1;
      WUF10 at 0 range 2 .. 2;
      WUF11 at 0 range 3 .. 3;
      WUF12 at 0 range 4 .. 4;
      WUF13 at 0 range 5 .. 5;
      WUF14 at 0 range 6 .. 6;
      WUF15 at 0 range 7 .. 7;
   end record;

   --  Wakeup flag For module 0
   type F3_MWUF0_Field is
     (
      --  Module 0 input was not a wakeup source
      F3_MWUF0_Field_0,
      --  Module 0 input was a wakeup source
      F3_MWUF0_Field_1)
     with Size => 1;
   for F3_MWUF0_Field use
     (F3_MWUF0_Field_0 => 0,
      F3_MWUF0_Field_1 => 1);

   --  Wakeup flag For module 1
   type F3_MWUF1_Field is
     (
      --  Module 1 input was not a wakeup source
      F3_MWUF1_Field_0,
      --  Module 1 input was a wakeup source
      F3_MWUF1_Field_1)
     with Size => 1;
   for F3_MWUF1_Field use
     (F3_MWUF1_Field_0 => 0,
      F3_MWUF1_Field_1 => 1);

   --  Wakeup flag For module 2
   type F3_MWUF2_Field is
     (
      --  Module 2 input was not a wakeup source
      F3_MWUF2_Field_0,
      --  Module 2 input was a wakeup source
      F3_MWUF2_Field_1)
     with Size => 1;
   for F3_MWUF2_Field use
     (F3_MWUF2_Field_0 => 0,
      F3_MWUF2_Field_1 => 1);

   --  Wakeup flag For module 3
   type F3_MWUF3_Field is
     (
      --  Module 3 input was not a wakeup source
      F3_MWUF3_Field_0,
      --  Module 3 input was a wakeup source
      F3_MWUF3_Field_1)
     with Size => 1;
   for F3_MWUF3_Field use
     (F3_MWUF3_Field_0 => 0,
      F3_MWUF3_Field_1 => 1);

   --  Wakeup flag For module 4
   type F3_MWUF4_Field is
     (
      --  Module 4 input was not a wakeup source
      F3_MWUF4_Field_0,
      --  Module 4 input was a wakeup source
      F3_MWUF4_Field_1)
     with Size => 1;
   for F3_MWUF4_Field use
     (F3_MWUF4_Field_0 => 0,
      F3_MWUF4_Field_1 => 1);

   --  Wakeup flag For module 5
   type F3_MWUF5_Field is
     (
      --  Module 5 input was not a wakeup source
      F3_MWUF5_Field_0,
      --  Module 5 input was a wakeup source
      F3_MWUF5_Field_1)
     with Size => 1;
   for F3_MWUF5_Field use
     (F3_MWUF5_Field_0 => 0,
      F3_MWUF5_Field_1 => 1);

   --  Wakeup flag For module 6
   type F3_MWUF6_Field is
     (
      --  Module 6 input was not a wakeup source
      F3_MWUF6_Field_0,
      --  Module 6 input was a wakeup source
      F3_MWUF6_Field_1)
     with Size => 1;
   for F3_MWUF6_Field use
     (F3_MWUF6_Field_0 => 0,
      F3_MWUF6_Field_1 => 1);

   --  Wakeup flag For module 7
   type F3_MWUF7_Field is
     (
      --  Module 7 input was not a wakeup source
      F3_MWUF7_Field_0,
      --  Module 7 input was a wakeup source
      F3_MWUF7_Field_1)
     with Size => 1;
   for F3_MWUF7_Field use
     (F3_MWUF7_Field_0 => 0,
      F3_MWUF7_Field_1 => 1);

   --  LLWU Flag 3 register
   type LLWU_F3_Register is record
      --  Read-only. Wakeup flag For module 0
      MWUF0 : F3_MWUF0_Field;
      --  Read-only. Wakeup flag For module 1
      MWUF1 : F3_MWUF1_Field;
      --  Read-only. Wakeup flag For module 2
      MWUF2 : F3_MWUF2_Field;
      --  Read-only. Wakeup flag For module 3
      MWUF3 : F3_MWUF3_Field;
      --  Read-only. Wakeup flag For module 4
      MWUF4 : F3_MWUF4_Field;
      --  Read-only. Wakeup flag For module 5
      MWUF5 : F3_MWUF5_Field;
      --  Read-only. Wakeup flag For module 6
      MWUF6 : F3_MWUF6_Field;
      --  Read-only. Wakeup flag For module 7
      MWUF7 : F3_MWUF7_Field;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for LLWU_F3_Register use record
      MWUF0 at 0 range 0 .. 0;
      MWUF1 at 0 range 1 .. 1;
      MWUF2 at 0 range 2 .. 2;
      MWUF3 at 0 range 3 .. 3;
      MWUF4 at 0 range 4 .. 4;
      MWUF5 at 0 range 5 .. 5;
      MWUF6 at 0 range 6 .. 6;
      MWUF7 at 0 range 7 .. 7;
   end record;

   --  Filter Pin Select
   type FILT1_FILTSEL_Field is
     (
      --  Select LLWU_P0 for filter
      FILT1_FILTSEL_Field_0000,
      --  Select LLWU_P15 for filter
      FILT1_FILTSEL_Field_1111)
     with Size => 4;
   for FILT1_FILTSEL_Field use
     (FILT1_FILTSEL_Field_0000 => 0,
      FILT1_FILTSEL_Field_1111 => 15);

   --  Digital Filter On External Pin
   type FILT1_FILTE_Field is
     (
      --  Filter disabled
      FILT1_FILTE_Field_00,
      --  Filter posedge detect enabled
      FILT1_FILTE_Field_01,
      --  Filter negedge detect enabled
      FILT1_FILTE_Field_10,
      --  Filter any edge detect enabled
      FILT1_FILTE_Field_11)
     with Size => 2;
   for FILT1_FILTE_Field use
     (FILT1_FILTE_Field_00 => 0,
      FILT1_FILTE_Field_01 => 1,
      FILT1_FILTE_Field_10 => 2,
      FILT1_FILTE_Field_11 => 3);

   --  Filter Detect Flag
   type FILT1_FILTF_Field is
     (
      --  Pin Filter 1 was not a wakeup source
      FILT1_FILTF_Field_0,
      --  Pin Filter 1 was a wakeup source
      FILT1_FILTF_Field_1)
     with Size => 1;
   for FILT1_FILTF_Field use
     (FILT1_FILTF_Field_0 => 0,
      FILT1_FILTF_Field_1 => 1);

   --  LLWU Pin Filter 1 register
   type FILT_Register is record
      --  Filter Pin Select
      FILTSEL      : FILT1_FILTSEL_Field :=
                      MKL25Z4.LLWU.FILT1_FILTSEL_Field_0000;
      --  unspecified
      Reserved_4_4 : MKL25Z4.Bit := 16#0#;
      --  Digital Filter On External Pin
      FILTE        : FILT1_FILTE_Field := MKL25Z4.LLWU.FILT1_FILTE_Field_00;
      --  Filter Detect Flag
      FILTF        : FILT1_FILTF_Field := MKL25Z4.LLWU.FILT1_FILTF_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for FILT_Register use record
      FILTSEL      at 0 range 0 .. 3;
      Reserved_4_4 at 0 range 4 .. 4;
      FILTE        at 0 range 5 .. 6;
      FILTF        at 0 range 7 .. 7;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Low leakage wakeup unit
   type LLWU_Peripheral is record
      --  LLWU Pin Enable 1 register
      PE1   : LLWU_PE1_Register;
      --  LLWU Pin Enable 2 register
      PE2   : LLWU_PE2_Register;
      --  LLWU Pin Enable 3 register
      PE3   : LLWU_PE3_Register;
      --  LLWU Pin Enable 4 register
      PE4   : LLWU_PE4_Register;
      --  LLWU Module Enable register
      ME    : LLWU_ME_Register;
      --  LLWU Flag 1 register
      F1    : LLWU_F1_Register;
      --  LLWU Flag 2 register
      F2    : LLWU_F2_Register;
      --  LLWU Flag 3 register
      F3    : LLWU_F3_Register;
      --  LLWU Pin Filter 1 register
      FILT1 : FILT_Register;
      --  LLWU Pin Filter 2 register
      FILT2 : FILT_Register;
   end record
     with Volatile;

   for LLWU_Peripheral use record
      PE1   at 0 range 0 .. 7;
      PE2   at 1 range 0 .. 7;
      PE3   at 2 range 0 .. 7;
      PE4   at 3 range 0 .. 7;
      ME    at 4 range 0 .. 7;
      F1    at 5 range 0 .. 7;
      F2    at 6 range 0 .. 7;
      F3    at 7 range 0 .. 7;
      FILT1 at 8 range 0 .. 7;
      FILT2 at 9 range 0 .. 7;
   end record;

   --  Low leakage wakeup unit
   LLWU_Periph : aliased LLWU_Peripheral
     with Import, Address => LLWU_Base;

end MKL25Z4.LLWU;
