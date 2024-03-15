pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.XTS_AES is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  The memory that stores plaintext

   --  The memory that stores plaintext
   type PLAIN_MEM_Registers is array (0 .. 3) of ESP32_C3.UInt32;

   subtype LINESIZE_LINESIZE_Field is ESP32_C3.Bit;

   --  XTS-AES line-size register
   type LINESIZE_Register is record
      --  This bit stores the line size parameter. 0: 16Byte, 1: 32Byte.
      LINESIZE      : LINESIZE_LINESIZE_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for LINESIZE_Register use record
      LINESIZE      at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype DESTINATION_DESTINATION_Field is ESP32_C3.Bit;

   --  XTS-AES destination register
   type DESTINATION_Register is record
      --  This bit stores the destination. 0: flash(default). 1: reserved.
      DESTINATION   : DESTINATION_DESTINATION_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DESTINATION_Register use record
      DESTINATION   at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype PHYSICAL_ADDRESS_PHYSICAL_ADDRESS_Field is ESP32_C3.UInt30;

   --  XTS-AES physical address register
   type PHYSICAL_ADDRESS_Register is record
      --  Those bits stores the physical address. If linesize is 16-byte, the
      --  physical address should be aligned of 16 bytes. If linesize is
      --  32-byte, the physical address should be aligned of 32 bytes.
      PHYSICAL_ADDRESS : PHYSICAL_ADDRESS_PHYSICAL_ADDRESS_Field := 16#0#;
      --  unspecified
      Reserved_30_31   : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PHYSICAL_ADDRESS_Register use record
      PHYSICAL_ADDRESS at 0 range 0 .. 29;
      Reserved_30_31   at 0 range 30 .. 31;
   end record;

   subtype TRIGGER_TRIGGER_Field is ESP32_C3.Bit;

   --  XTS-AES trigger register
   type TRIGGER_Register is record
      --  Write-only. Set this bit to start manual encryption calculation
      TRIGGER       : TRIGGER_TRIGGER_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TRIGGER_Register use record
      TRIGGER       at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype RELEASE_RELEASE_Field is ESP32_C3.Bit;

   --  XTS-AES release register
   type RELEASE_Register is record
      --  Write-only. Set this bit to release the manual encrypted result,
      --  after that the result will be visible to spi
      RELEASE       : RELEASE_RELEASE_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RELEASE_Register use record
      RELEASE       at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype DESTROY_DESTROY_Field is ESP32_C3.Bit;

   --  XTS-AES destroy register
   type DESTROY_Register is record
      --  Write-only. Set this bit to destroy XTS-AES result.
      DESTROY       : DESTROY_DESTROY_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DESTROY_Register use record
      DESTROY       at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype STATE_STATE_Field is ESP32_C3.UInt2;

   --  XTS-AES status register
   type STATE_Register is record
      --  Read-only. Those bits shows XTS-AES status. 0=IDLE, 1=WORK,
      --  2=RELEASE, 3=USE. IDLE means that XTS-AES is idle. WORK means that
      --  XTS-AES is busy with calculation. RELEASE means the encrypted result
      --  is generated but not visible to mspi. USE means that the encrypted
      --  result is visible to mspi.
      STATE         : STATE_STATE_Field;
      --  unspecified
      Reserved_2_31 : ESP32_C3.UInt30;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for STATE_Register use record
      STATE         at 0 range 0 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   subtype DATE_DATE_Field is ESP32_C3.UInt30;

   --  XTS-AES version control register
   type DATE_Register is record
      --  Those bits stores the version information of XTS-AES.
      DATE           : DATE_DATE_Field := 16#20200623#;
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

   --  XTS-AES-128 Flash Encryption
   type XTS_AES_Peripheral is record
      --  The memory that stores plaintext
      PLAIN_MEM        : aliased PLAIN_MEM_Registers;
      --  XTS-AES line-size register
      LINESIZE         : aliased LINESIZE_Register;
      --  XTS-AES destination register
      DESTINATION      : aliased DESTINATION_Register;
      --  XTS-AES physical address register
      PHYSICAL_ADDRESS : aliased PHYSICAL_ADDRESS_Register;
      --  XTS-AES trigger register
      TRIGGER          : aliased TRIGGER_Register;
      --  XTS-AES release register
      RELEASE          : aliased RELEASE_Register;
      --  XTS-AES destroy register
      DESTROY          : aliased DESTROY_Register;
      --  XTS-AES status register
      STATE            : aliased STATE_Register;
      --  XTS-AES version control register
      DATE             : aliased DATE_Register;
   end record
     with Volatile;

   for XTS_AES_Peripheral use record
      PLAIN_MEM        at 16#0# range 0 .. 127;
      LINESIZE         at 16#40# range 0 .. 31;
      DESTINATION      at 16#44# range 0 .. 31;
      PHYSICAL_ADDRESS at 16#48# range 0 .. 31;
      TRIGGER          at 16#4C# range 0 .. 31;
      RELEASE          at 16#50# range 0 .. 31;
      DESTROY          at 16#54# range 0 .. 31;
      STATE            at 16#58# range 0 .. 31;
      DATE             at 16#5C# range 0 .. 31;
   end record;

   --  XTS-AES-128 Flash Encryption
   XTS_AES_Periph : aliased XTS_AES_Peripheral
     with Import, Address => XTS_AES_Base;

end ESP32_C3.XTS_AES;
