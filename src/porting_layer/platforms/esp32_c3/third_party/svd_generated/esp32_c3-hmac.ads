pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.HMAC is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype SET_START_SET_START_Field is ESP32_C3.Bit;

   --  Process control register 0.
   type SET_START_Register is record
      --  Write-only. Start hmac operation.
      SET_START     : SET_START_SET_START_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SET_START_Register use record
      SET_START     at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype SET_PARA_PURPOSE_PURPOSE_SET_Field is ESP32_C3.UInt4;

   --  Configure purpose.
   type SET_PARA_PURPOSE_Register is record
      --  Write-only. Set hmac parameter purpose.
      PURPOSE_SET   : SET_PARA_PURPOSE_PURPOSE_SET_Field := 16#0#;
      --  unspecified
      Reserved_4_31 : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SET_PARA_PURPOSE_Register use record
      PURPOSE_SET   at 0 range 0 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype SET_PARA_KEY_KEY_SET_Field is ESP32_C3.UInt3;

   --  Configure key.
   type SET_PARA_KEY_Register is record
      --  Write-only. Set hmac parameter key.
      KEY_SET       : SET_PARA_KEY_KEY_SET_Field := 16#0#;
      --  unspecified
      Reserved_3_31 : ESP32_C3.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SET_PARA_KEY_Register use record
      KEY_SET       at 0 range 0 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   subtype SET_PARA_FINISH_SET_PARA_END_Field is ESP32_C3.Bit;

   --  Finish initial configuration.
   type SET_PARA_FINISH_Register is record
      --  Write-only. Finish hmac configuration.
      SET_PARA_END  : SET_PARA_FINISH_SET_PARA_END_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SET_PARA_FINISH_Register use record
      SET_PARA_END  at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype SET_MESSAGE_ONE_SET_TEXT_ONE_Field is ESP32_C3.Bit;

   --  Process control register 1.
   type SET_MESSAGE_ONE_Register is record
      --  Write-only. Call SHA to calculate one message block.
      SET_TEXT_ONE  : SET_MESSAGE_ONE_SET_TEXT_ONE_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SET_MESSAGE_ONE_Register use record
      SET_TEXT_ONE  at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype SET_MESSAGE_ING_SET_TEXT_ING_Field is ESP32_C3.Bit;

   --  Process control register 2.
   type SET_MESSAGE_ING_Register is record
      --  Write-only. Continue typical hmac.
      SET_TEXT_ING  : SET_MESSAGE_ING_SET_TEXT_ING_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SET_MESSAGE_ING_Register use record
      SET_TEXT_ING  at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype SET_MESSAGE_END_SET_TEXT_END_Field is ESP32_C3.Bit;

   --  Process control register 3.
   type SET_MESSAGE_END_Register is record
      --  Write-only. Start hardware padding.
      SET_TEXT_END  : SET_MESSAGE_END_SET_TEXT_END_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SET_MESSAGE_END_Register use record
      SET_TEXT_END  at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype SET_RESULT_FINISH_SET_RESULT_END_Field is ESP32_C3.Bit;

   --  Process control register 4.
   type SET_RESULT_FINISH_Register is record
      --  Write-only. After read result from upstream, then let hmac back to
      --  idle.
      SET_RESULT_END : SET_RESULT_FINISH_SET_RESULT_END_Field := 16#0#;
      --  unspecified
      Reserved_1_31  : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SET_RESULT_FINISH_Register use record
      SET_RESULT_END at 0 range 0 .. 0;
      Reserved_1_31  at 0 range 1 .. 31;
   end record;

   subtype SET_INVALIDATE_JTAG_SET_INVALIDATE_JTAG_Field is ESP32_C3.Bit;

   --  Invalidate register 0.
   type SET_INVALIDATE_JTAG_Register is record
      --  Write-only. Clear result from hmac downstream JTAG.
      SET_INVALIDATE_JTAG : SET_INVALIDATE_JTAG_SET_INVALIDATE_JTAG_Field :=
                             16#0#;
      --  unspecified
      Reserved_1_31       : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SET_INVALIDATE_JTAG_Register use record
      SET_INVALIDATE_JTAG at 0 range 0 .. 0;
      Reserved_1_31       at 0 range 1 .. 31;
   end record;

   subtype SET_INVALIDATE_DS_SET_INVALIDATE_DS_Field is ESP32_C3.Bit;

   --  Invalidate register 1.
   type SET_INVALIDATE_DS_Register is record
      --  Write-only. Clear result from hmac downstream DS.
      SET_INVALIDATE_DS : SET_INVALIDATE_DS_SET_INVALIDATE_DS_Field := 16#0#;
      --  unspecified
      Reserved_1_31     : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SET_INVALIDATE_DS_Register use record
      SET_INVALIDATE_DS at 0 range 0 .. 0;
      Reserved_1_31     at 0 range 1 .. 31;
   end record;

   subtype QUERY_ERROR_QUERY_CHECK_Field is ESP32_C3.Bit;

   --  Error register.
   type QUERY_ERROR_Register is record
      --  Read-only. Hmac configuration state. 0: key are agree with purpose.
      --  1: error
      QUERY_CHECK   : QUERY_ERROR_QUERY_CHECK_Field;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for QUERY_ERROR_Register use record
      QUERY_CHECK   at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype QUERY_BUSY_BUSY_STATE_Field is ESP32_C3.Bit;

   --  Busy register.
   type QUERY_BUSY_Register is record
      --  Read-only. Hmac state. 1'b0: idle. 1'b1: busy
      BUSY_STATE    : QUERY_BUSY_BUSY_STATE_Field;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for QUERY_BUSY_Register use record
      BUSY_STATE    at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   --  Message block memory.

   --  Message block memory.
   type WR_MESSAGE_MEM_Registers is array (0 .. 15) of ESP32_C3.UInt32;

   --  Result from upstream.

   --  Result from upstream.
   type RD_RESULT_MEM_Registers is array (0 .. 7) of ESP32_C3.UInt32;

   subtype SET_MESSAGE_PAD_SET_TEXT_PAD_Field is ESP32_C3.Bit;

   --  Process control register 5.
   type SET_MESSAGE_PAD_Register is record
      --  Write-only. Start software padding.
      SET_TEXT_PAD  : SET_MESSAGE_PAD_SET_TEXT_PAD_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SET_MESSAGE_PAD_Register use record
      SET_TEXT_PAD  at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype ONE_BLOCK_SET_ONE_BLOCK_Field is ESP32_C3.Bit;

   --  Process control register 6.
   type ONE_BLOCK_Register is record
      --  Write-only. Don't have to do padding.
      SET_ONE_BLOCK : ONE_BLOCK_SET_ONE_BLOCK_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ONE_BLOCK_Register use record
      SET_ONE_BLOCK at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype SOFT_JTAG_CTRL_SOFT_JTAG_CTRL_Field is ESP32_C3.Bit;

   --  Jtag register 0.
   type SOFT_JTAG_CTRL_Register is record
      --  Write-only. Turn on JTAG verification.
      SOFT_JTAG_CTRL : SOFT_JTAG_CTRL_SOFT_JTAG_CTRL_Field := 16#0#;
      --  unspecified
      Reserved_1_31  : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SOFT_JTAG_CTRL_Register use record
      SOFT_JTAG_CTRL at 0 range 0 .. 0;
      Reserved_1_31  at 0 range 1 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  HMAC (Hash-based Message Authentication Code) Accelerator
   type HMAC_Peripheral is record
      --  Process control register 0.
      SET_START           : aliased SET_START_Register;
      --  Configure purpose.
      SET_PARA_PURPOSE    : aliased SET_PARA_PURPOSE_Register;
      --  Configure key.
      SET_PARA_KEY        : aliased SET_PARA_KEY_Register;
      --  Finish initial configuration.
      SET_PARA_FINISH     : aliased SET_PARA_FINISH_Register;
      --  Process control register 1.
      SET_MESSAGE_ONE     : aliased SET_MESSAGE_ONE_Register;
      --  Process control register 2.
      SET_MESSAGE_ING     : aliased SET_MESSAGE_ING_Register;
      --  Process control register 3.
      SET_MESSAGE_END     : aliased SET_MESSAGE_END_Register;
      --  Process control register 4.
      SET_RESULT_FINISH   : aliased SET_RESULT_FINISH_Register;
      --  Invalidate register 0.
      SET_INVALIDATE_JTAG : aliased SET_INVALIDATE_JTAG_Register;
      --  Invalidate register 1.
      SET_INVALIDATE_DS   : aliased SET_INVALIDATE_DS_Register;
      --  Error register.
      QUERY_ERROR         : aliased QUERY_ERROR_Register;
      --  Busy register.
      QUERY_BUSY          : aliased QUERY_BUSY_Register;
      --  Message block memory.
      WR_MESSAGE_MEM      : aliased WR_MESSAGE_MEM_Registers;
      --  Result from upstream.
      RD_RESULT_MEM       : aliased RD_RESULT_MEM_Registers;
      --  Process control register 5.
      SET_MESSAGE_PAD     : aliased SET_MESSAGE_PAD_Register;
      --  Process control register 6.
      ONE_BLOCK           : aliased ONE_BLOCK_Register;
      --  Jtag register 0.
      SOFT_JTAG_CTRL      : aliased SOFT_JTAG_CTRL_Register;
      --  Jtag register 1.
      WR_JTAG             : aliased ESP32_C3.UInt32;
   end record
     with Volatile;

   for HMAC_Peripheral use record
      SET_START           at 16#40# range 0 .. 31;
      SET_PARA_PURPOSE    at 16#44# range 0 .. 31;
      SET_PARA_KEY        at 16#48# range 0 .. 31;
      SET_PARA_FINISH     at 16#4C# range 0 .. 31;
      SET_MESSAGE_ONE     at 16#50# range 0 .. 31;
      SET_MESSAGE_ING     at 16#54# range 0 .. 31;
      SET_MESSAGE_END     at 16#58# range 0 .. 31;
      SET_RESULT_FINISH   at 16#5C# range 0 .. 31;
      SET_INVALIDATE_JTAG at 16#60# range 0 .. 31;
      SET_INVALIDATE_DS   at 16#64# range 0 .. 31;
      QUERY_ERROR         at 16#68# range 0 .. 31;
      QUERY_BUSY          at 16#6C# range 0 .. 31;
      WR_MESSAGE_MEM      at 16#80# range 0 .. 511;
      RD_RESULT_MEM       at 16#C0# range 0 .. 255;
      SET_MESSAGE_PAD     at 16#F0# range 0 .. 31;
      ONE_BLOCK           at 16#F4# range 0 .. 31;
      SOFT_JTAG_CTRL      at 16#F8# range 0 .. 31;
      WR_JTAG             at 16#FC# range 0 .. 31;
   end record;

   --  HMAC (Hash-based Message Authentication Code) Accelerator
   HMAC_Periph : aliased HMAC_Peripheral
     with Import, Address => HMAC_Base;

end ESP32_C3.HMAC;
