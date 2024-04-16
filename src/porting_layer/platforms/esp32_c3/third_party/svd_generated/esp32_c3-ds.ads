pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.DS is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  memory that stores Y

   --  memory that stores Y
   type Y_MEM_Registers is array (0 .. 127) of ESP32_C3.UInt32;

   --  memory that stores M

   --  memory that stores M
   type M_MEM_Registers is array (0 .. 127) of ESP32_C3.UInt32;

   --  memory that stores Rb

   --  memory that stores Rb
   type RB_MEM_Registers is array (0 .. 127) of ESP32_C3.UInt32;

   --  memory that stores BOX

   --  memory that stores BOX
   type BOX_MEM_Registers is array (0 .. 11) of ESP32_C3.UInt32;

   --  memory that stores X

   --  memory that stores X
   type X_MEM_Registers is array (0 .. 127) of ESP32_C3.UInt32;

   --  memory that stores Z

   --  memory that stores Z
   type Z_MEM_Registers is array (0 .. 127) of ESP32_C3.UInt32;

   subtype SET_START_SET_START_Field is ESP32_C3.Bit;

   --  DS start control register
   type SET_START_Register is record
      --  Write-only. set this bit to start DS operation.
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

   subtype SET_CONTINUE_SET_CONTINUE_Field is ESP32_C3.Bit;

   --  DS continue control register
   type SET_CONTINUE_Register is record
      --  Write-only. set this bit to continue DS operation.
      SET_CONTINUE  : SET_CONTINUE_SET_CONTINUE_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SET_CONTINUE_Register use record
      SET_CONTINUE  at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype SET_FINISH_SET_FINISH_Field is ESP32_C3.Bit;

   --  DS finish control register
   type SET_FINISH_Register is record
      --  Write-only. Set this bit to finish DS process.
      SET_FINISH    : SET_FINISH_SET_FINISH_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SET_FINISH_Register use record
      SET_FINISH    at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype QUERY_BUSY_QUERY_BUSY_Field is ESP32_C3.Bit;

   --  DS query busy register
   type QUERY_BUSY_Register is record
      --  Read-only. digital signature state. 1'b0: idle, 1'b1: busy
      QUERY_BUSY    : QUERY_BUSY_QUERY_BUSY_Field;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for QUERY_BUSY_Register use record
      QUERY_BUSY    at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype QUERY_KEY_WRONG_QUERY_KEY_WRONG_Field is ESP32_C3.UInt4;

   --  DS query key-wrong counter register
   type QUERY_KEY_WRONG_Register is record
      --  Read-only. digital signature key wrong counter
      QUERY_KEY_WRONG : QUERY_KEY_WRONG_QUERY_KEY_WRONG_Field;
      --  unspecified
      Reserved_4_31   : ESP32_C3.UInt28;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for QUERY_KEY_WRONG_Register use record
      QUERY_KEY_WRONG at 0 range 0 .. 3;
      Reserved_4_31   at 0 range 4 .. 31;
   end record;

   subtype QUERY_CHECK_MD_ERROR_Field is ESP32_C3.Bit;
   subtype QUERY_CHECK_PADDING_BAD_Field is ESP32_C3.Bit;

   --  DS query check result register
   type QUERY_CHECK_Register is record
      --  Read-only. MD checkout result. 1'b0: MD check pass, 1'b1: MD check
      --  fail
      MD_ERROR      : QUERY_CHECK_MD_ERROR_Field;
      --  Read-only. padding checkout result. 1'b0: a good padding, 1'b1: a bad
      --  padding
      PADDING_BAD   : QUERY_CHECK_PADDING_BAD_Field;
      --  unspecified
      Reserved_2_31 : ESP32_C3.UInt30;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for QUERY_CHECK_Register use record
      MD_ERROR      at 0 range 0 .. 0;
      PADDING_BAD   at 0 range 1 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   subtype DATE_DATE_Field is ESP32_C3.UInt30;

   --  DS version control register
   type DATE_Register is record
      --  ds version information
      DATE           : DATE_DATE_Field := 16#20200618#;
      --  unspecified
      Reserved_30_31 : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DATE_Register use record
      DATE           at 0 range 0 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Digital Signature
   type DS_Peripheral is record
      --  memory that stores Y
      Y_MEM           : aliased Y_MEM_Registers;
      --  memory that stores M
      M_MEM           : aliased M_MEM_Registers;
      --  memory that stores Rb
      RB_MEM          : aliased RB_MEM_Registers;
      --  memory that stores BOX
      BOX_MEM         : aliased BOX_MEM_Registers;
      --  memory that stores X
      X_MEM           : aliased X_MEM_Registers;
      --  memory that stores Z
      Z_MEM           : aliased Z_MEM_Registers;
      --  DS start control register
      SET_START       : aliased SET_START_Register;
      --  DS continue control register
      SET_CONTINUE    : aliased SET_CONTINUE_Register;
      --  DS finish control register
      SET_FINISH      : aliased SET_FINISH_Register;
      --  DS query busy register
      QUERY_BUSY      : aliased QUERY_BUSY_Register;
      --  DS query key-wrong counter register
      QUERY_KEY_WRONG : aliased QUERY_KEY_WRONG_Register;
      --  DS query check result register
      QUERY_CHECK     : aliased QUERY_CHECK_Register;
      --  DS version control register
      DATE            : aliased DATE_Register;
   end record
     with Volatile;

   for DS_Peripheral use record
      Y_MEM           at 16#0# range 0 .. 4095;
      M_MEM           at 16#200# range 0 .. 4095;
      RB_MEM          at 16#400# range 0 .. 4095;
      BOX_MEM         at 16#600# range 0 .. 383;
      X_MEM           at 16#800# range 0 .. 4095;
      Z_MEM           at 16#A00# range 0 .. 4095;
      SET_START       at 16#E00# range 0 .. 31;
      SET_CONTINUE    at 16#E04# range 0 .. 31;
      SET_FINISH      at 16#E08# range 0 .. 31;
      QUERY_BUSY      at 16#E0C# range 0 .. 31;
      QUERY_KEY_WRONG at 16#E10# range 0 .. 31;
      QUERY_CHECK     at 16#E14# range 0 .. 31;
      DATE            at 16#E20# range 0 .. 31;
   end record;

   --  Digital Signature
   DS_Periph : aliased DS_Peripheral
     with Import, Address => DS_Base;

end ESP32_C3.DS;
