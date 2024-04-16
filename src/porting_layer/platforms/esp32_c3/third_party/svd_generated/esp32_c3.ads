pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with Interfaces;
with System;

--  32-bit RISC-V MCU & 2.4 GHz Wi-Fi & Bluetooth 5 (LE)
package ESP32_C3 is
   pragma Preelaborate;

   ---------------
   -- Base type --
   ---------------

   type UInt32 is new Interfaces.Unsigned_32;
   type UInt16 is new Interfaces.Unsigned_16;
   type Byte is new Interfaces.Unsigned_8;
   type Bit is mod 2**1
     with Size => 1;
   type UInt2 is mod 2**2
     with Size => 2;
   type UInt3 is mod 2**3
     with Size => 3;
   type UInt4 is mod 2**4
     with Size => 4;
   type UInt5 is mod 2**5
     with Size => 5;
   type UInt6 is mod 2**6
     with Size => 6;
   type UInt7 is mod 2**7
     with Size => 7;
   type UInt9 is mod 2**9
     with Size => 9;
   type UInt10 is mod 2**10
     with Size => 10;
   type UInt11 is mod 2**11
     with Size => 11;
   type UInt12 is mod 2**12
     with Size => 12;
   type UInt13 is mod 2**13
     with Size => 13;
   type UInt14 is mod 2**14
     with Size => 14;
   type UInt15 is mod 2**15
     with Size => 15;
   type UInt17 is mod 2**17
     with Size => 17;
   type UInt18 is mod 2**18
     with Size => 18;
   type UInt19 is mod 2**19
     with Size => 19;
   type UInt20 is mod 2**20
     with Size => 20;
   type UInt21 is mod 2**21
     with Size => 21;
   type UInt22 is mod 2**22
     with Size => 22;
   type UInt23 is mod 2**23
     with Size => 23;
   type UInt24 is mod 2**24
     with Size => 24;
   type UInt25 is mod 2**25
     with Size => 25;
   type UInt26 is mod 2**26
     with Size => 26;
   type UInt27 is mod 2**27
     with Size => 27;
   type UInt28 is mod 2**28
     with Size => 28;
   type UInt29 is mod 2**29
     with Size => 29;
   type UInt30 is mod 2**30
     with Size => 30;
   type UInt31 is mod 2**31
     with Size => 31;

   --------------------
   -- Base addresses --
   --------------------

   AES_Base : constant System.Address := System'To_Address (16#6003A000#);
   APB_CTRL_Base : constant System.Address := System'To_Address (16#60026000#);
   APB_SARADC_Base : constant System.Address := System'To_Address (16#60040000#);
   ASSIST_DEBUG_Base : constant System.Address := System'To_Address (16#600CE000#);
   BB_Base : constant System.Address := System'To_Address (16#6001D000#);
   DMA_Base : constant System.Address := System'To_Address (16#6003F000#);
   DS_Base : constant System.Address := System'To_Address (16#6003D000#);
   EFUSE_Base : constant System.Address := System'To_Address (16#60008800#);
   EXTMEM_Base : constant System.Address := System'To_Address (16#600C4000#);
   GPIO_Base : constant System.Address := System'To_Address (16#60004000#);
   GPIO_SD_Base : constant System.Address := System'To_Address (16#60004F00#);
   HMAC_Base : constant System.Address := System'To_Address (16#6003E000#);
   I2C0_Base : constant System.Address := System'To_Address (16#60013000#);
   I2S0_Base : constant System.Address := System'To_Address (16#6002D000#);
   INTERRUPT_CORE0_Base : constant System.Address := System'To_Address (16#600C2000#);
   IO_MUX_Base : constant System.Address := System'To_Address (16#60009000#);
   LEDC_Base : constant System.Address := System'To_Address (16#60019000#);
   RMT_Base : constant System.Address := System'To_Address (16#60016000#);
   RNG_Base : constant System.Address := System'To_Address (16#60026000#);
   RSA_Base : constant System.Address := System'To_Address (16#6003C000#);
   RTC_CNTL_Base : constant System.Address := System'To_Address (16#60008000#);
   SENSITIVE_Base : constant System.Address := System'To_Address (16#600C1000#);
   SHA_Base : constant System.Address := System'To_Address (16#6003B000#);
   SPI0_Base : constant System.Address := System'To_Address (16#60003000#);
   SPI1_Base : constant System.Address := System'To_Address (16#60002000#);
   SPI2_Base : constant System.Address := System'To_Address (16#60024000#);
   SYSTEM_Base : constant System.Address := System'To_Address (16#600C0000#);
   SYSTIMER_Base : constant System.Address := System'To_Address (16#60023000#);
   TIMG0_Base : constant System.Address := System'To_Address (16#6001F000#);
   TIMG1_Base : constant System.Address := System'To_Address (16#60020000#);
   TWAI0_Base : constant System.Address := System'To_Address (16#6002B000#);
   UART0_Base : constant System.Address := System'To_Address (16#60000000#);
   UART1_Base : constant System.Address := System'To_Address (16#60010000#);
   UHCI0_Base : constant System.Address := System'To_Address (16#60014000#);
   UHCI1_Base : constant System.Address := System'To_Address (16#6000C000#);
   USB_DEVICE_Base : constant System.Address := System'To_Address (16#60043000#);
   XTS_AES_Base : constant System.Address := System'To_Address (16#600CC000#);

end ESP32_C3;
