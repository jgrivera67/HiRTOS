pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.IO_MUX is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  PIN_CTRL_CLK_OUT array element
   subtype PIN_CTRL_CLK_OUT_Element is ESP32_C3.UInt4;

   --  PIN_CTRL_CLK_OUT array
   type PIN_CTRL_CLK_OUT_Field_Array is array (1 .. 3)
     of PIN_CTRL_CLK_OUT_Element
     with Component_Size => 4, Size => 12;

   --  Type definition for PIN_CTRL_CLK_OUT
   type PIN_CTRL_CLK_OUT_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  CLK_OUT as a value
            Val : ESP32_C3.UInt12;
         when True =>
            --  CLK_OUT as an array
            Arr : PIN_CTRL_CLK_OUT_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 12;

   for PIN_CTRL_CLK_OUT_Field use record
      Val at 0 range 0 .. 11;
      Arr at 0 range 0 .. 11;
   end record;

   --  Clock Output Configuration Register
   type PIN_CTRL_Register is record
      --  If you want to output clock for I2S to CLK_OUT_out1, set this
      --  register to 0x0. CLK_OUT_out1 can be found in peripheral output
      --  signals.
      CLK_OUT        : PIN_CTRL_CLK_OUT_Field :=
                        (As_Array => False, Val => 16#F#);
      --  unspecified
      Reserved_12_31 : ESP32_C3.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PIN_CTRL_Register use record
      CLK_OUT        at 0 range 0 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;

   subtype GPIO_MCU_OE_Field is ESP32_C3.Bit;
   subtype GPIO_SLP_SEL_Field is ESP32_C3.Bit;
   subtype GPIO_MCU_WPD_Field is ESP32_C3.Bit;
   subtype GPIO_MCU_WPU_Field is ESP32_C3.Bit;
   subtype GPIO_MCU_IE_Field is ESP32_C3.Bit;
   subtype GPIO_FUN_WPD_Field is ESP32_C3.Bit;
   subtype GPIO_FUN_WPU_Field is ESP32_C3.Bit;
   subtype GPIO_FUN_IE_Field is ESP32_C3.Bit;
   subtype GPIO_FUN_DRV_Field is ESP32_C3.UInt2;
   subtype GPIO_MCU_SEL_Field is ESP32_C3.UInt3;
   subtype GPIO_FILTER_EN_Field is ESP32_C3.Bit;

   --  IO MUX Configure Register for pad XTAL_32K_P
   type GPIO_Register is record
      --  Output enable of the pad in sleep mode. 1: output enabled; 0: output
      --  disabled.
      MCU_OE         : GPIO_MCU_OE_Field := 16#0#;
      --  Sleep mode selection of this pad. Set to 1 to put the pad in pad
      --  mode.
      SLP_SEL        : GPIO_SLP_SEL_Field := 16#0#;
      --  Pull-down enable of the pad in sleep mode. 1: internal pull-down
      --  enabled; 0: internal pull-down disabled.
      MCU_WPD        : GPIO_MCU_WPD_Field := 16#0#;
      --  Pull-up enable of the pad during sleep mode. 1: internal pull-up
      --  enabled; 0: internal pull-up disabled.
      MCU_WPU        : GPIO_MCU_WPU_Field := 16#0#;
      --  Input enable of the pad during sleep mode. 1: input enabled; 0: input
      --  disabled.
      MCU_IE         : GPIO_MCU_IE_Field := 16#0#;
      --  unspecified
      Reserved_5_6   : ESP32_C3.UInt2 := 16#0#;
      --  Pull-down enable of the pad. 1: internal pull-down enabled; 0:
      --  internal pull-down disabled.
      FUN_WPD        : GPIO_FUN_WPD_Field := 16#0#;
      --  Pull-up enable of the pad. 1: internal pull-up enabled; 0: internal
      --  pull-up disabled.
      FUN_WPU        : GPIO_FUN_WPU_Field := 16#1#;
      --  Input enable of the pad. 1: input enabled; 0: input disabled.
      FUN_IE         : GPIO_FUN_IE_Field := 16#1#;
      --  Select the drive strength of the pad. 0: ~5 mA; 1: ~10mA; 2: ~20mA;
      --  3: ~40mA.
      FUN_DRV        : GPIO_FUN_DRV_Field := 16#2#;
      --  Select IO MUX function for this signal. 0: Select Function 1; 1:
      --  Select Function 2; etc.
      MCU_SEL        : GPIO_MCU_SEL_Field := 16#0#;
      --  Enable filter for pin input signals. 1: Filter enabled; 2: Filter
      --  disabled.
      FILTER_EN      : GPIO_FILTER_EN_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : ESP32_C3.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for GPIO_Register use record
      MCU_OE         at 0 range 0 .. 0;
      SLP_SEL        at 0 range 1 .. 1;
      MCU_WPD        at 0 range 2 .. 2;
      MCU_WPU        at 0 range 3 .. 3;
      MCU_IE         at 0 range 4 .. 4;
      Reserved_5_6   at 0 range 5 .. 6;
      FUN_WPD        at 0 range 7 .. 7;
      FUN_WPU        at 0 range 8 .. 8;
      FUN_IE         at 0 range 9 .. 9;
      FUN_DRV        at 0 range 10 .. 11;
      MCU_SEL        at 0 range 12 .. 14;
      FILTER_EN      at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  IO MUX Configure Register for pad XTAL_32K_P
   type GPIO_Registers is array (0 .. 21) of GPIO_Register;

   subtype DATE_REG_DATE_Field is ESP32_C3.UInt28;

   --  IO MUX Version Control Register
   type DATE_Register is record
      --  Version control register
      REG_DATE       : DATE_REG_DATE_Field := 16#2006050#;
      --  unspecified
      Reserved_28_31 : ESP32_C3.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DATE_Register use record
      REG_DATE       at 0 range 0 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Input/Output Multiplexer
   type IO_MUX_Peripheral is record
      --  Clock Output Configuration Register
      PIN_CTRL : aliased PIN_CTRL_Register;
      --  IO MUX Configure Register for pad XTAL_32K_P
      GPIO     : aliased GPIO_Registers;
      --  IO MUX Version Control Register
      DATE     : aliased DATE_Register;
   end record
     with Volatile;

   for IO_MUX_Peripheral use record
      PIN_CTRL at 16#0# range 0 .. 31;
      GPIO     at 16#4# range 0 .. 703;
      DATE     at 16#FC# range 0 .. 31;
   end record;

   --  Input/Output Multiplexer
   IO_MUX_Periph : aliased IO_MUX_Peripheral
     with Import, Address => IO_MUX_Base;

end ESP32_C3.IO_MUX;
