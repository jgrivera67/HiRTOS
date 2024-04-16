pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.GPIO is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype OUT_DATA_ORIG_Field is ESP32_C3.UInt26;

   --  GPIO output register
   type OUT_Register is record
      --  GPIO output register for GPIO0-25
      DATA_ORIG      : OUT_DATA_ORIG_Field := 16#0#;
      --  unspecified
      Reserved_26_31 : ESP32_C3.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for OUT_Register use record
      DATA_ORIG      at 0 range 0 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype OUT_W1TS_OUT_W1TS_Field is ESP32_C3.UInt26;

   --  GPIO output set register
   type OUT_W1TS_Register is record
      --  Write-only. GPIO output set register for GPIO0-25
      OUT_W1TS       : OUT_W1TS_OUT_W1TS_Field := 16#0#;
      --  unspecified
      Reserved_26_31 : ESP32_C3.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for OUT_W1TS_Register use record
      OUT_W1TS       at 0 range 0 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype OUT_W1TC_OUT_W1TC_Field is ESP32_C3.UInt26;

   --  GPIO output clear register
   type OUT_W1TC_Register is record
      --  Write-only. GPIO output clear register for GPIO0-25
      OUT_W1TC       : OUT_W1TC_OUT_W1TC_Field := 16#0#;
      --  unspecified
      Reserved_26_31 : ESP32_C3.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for OUT_W1TC_Register use record
      OUT_W1TC       at 0 range 0 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype SDIO_SELECT_SDIO_SEL_Field is ESP32_C3.Byte;

   --  GPIO sdio select register
   type SDIO_SELECT_Register is record
      --  GPIO sdio select register
      SDIO_SEL      : SDIO_SELECT_SDIO_SEL_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : ESP32_C3.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDIO_SELECT_Register use record
      SDIO_SEL      at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype ENABLE_DATA_Field is ESP32_C3.UInt26;

   --  GPIO output enable register
   type ENABLE_Register is record
      --  GPIO output enable register for GPIO0-25
      DATA           : ENABLE_DATA_Field := 16#0#;
      --  unspecified
      Reserved_26_31 : ESP32_C3.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENABLE_Register use record
      DATA           at 0 range 0 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype ENABLE_W1TS_ENABLE_W1TS_Field is ESP32_C3.UInt26;

   --  GPIO output enable set register
   type ENABLE_W1TS_Register is record
      --  Write-only. GPIO output enable set register for GPIO0-25
      ENABLE_W1TS    : ENABLE_W1TS_ENABLE_W1TS_Field := 16#0#;
      --  unspecified
      Reserved_26_31 : ESP32_C3.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENABLE_W1TS_Register use record
      ENABLE_W1TS    at 0 range 0 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype ENABLE_W1TC_ENABLE_W1TC_Field is ESP32_C3.UInt26;

   --  GPIO output enable clear register
   type ENABLE_W1TC_Register is record
      --  Write-only. GPIO output enable clear register for GPIO0-25
      ENABLE_W1TC    : ENABLE_W1TC_ENABLE_W1TC_Field := 16#0#;
      --  unspecified
      Reserved_26_31 : ESP32_C3.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENABLE_W1TC_Register use record
      ENABLE_W1TC    at 0 range 0 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype STRAP_STRAPPING_Field is ESP32_C3.UInt16;

   --  pad strapping register
   type STRAP_Register is record
      --  Read-only. pad strapping register
      STRAPPING      : STRAP_STRAPPING_Field;
      --  unspecified
      Reserved_16_31 : ESP32_C3.UInt16;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for STRAP_Register use record
      STRAPPING      at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype IN_DATA_NEXT_Field is ESP32_C3.UInt26;

   --  GPIO input register
   type IN_Register is record
      --  Read-only. GPIO input register for GPIO0-25
      DATA_NEXT      : IN_DATA_NEXT_Field;
      --  unspecified
      Reserved_26_31 : ESP32_C3.UInt6;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for IN_Register use record
      DATA_NEXT      at 0 range 0 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype STATUS_INTERRUPT_Field is ESP32_C3.UInt26;

   --  GPIO interrupt status register
   type STATUS_Register is record
      --  GPIO interrupt status register for GPIO0-25
      INTERRUPT      : STATUS_INTERRUPT_Field := 16#0#;
      --  unspecified
      Reserved_26_31 : ESP32_C3.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for STATUS_Register use record
      INTERRUPT      at 0 range 0 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype STATUS_W1TS_STATUS_W1TS_Field is ESP32_C3.UInt26;

   --  GPIO interrupt status set register
   type STATUS_W1TS_Register is record
      --  Write-only. GPIO interrupt status set register for GPIO0-25
      STATUS_W1TS    : STATUS_W1TS_STATUS_W1TS_Field := 16#0#;
      --  unspecified
      Reserved_26_31 : ESP32_C3.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for STATUS_W1TS_Register use record
      STATUS_W1TS    at 0 range 0 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype STATUS_W1TC_STATUS_W1TC_Field is ESP32_C3.UInt26;

   --  GPIO interrupt status clear register
   type STATUS_W1TC_Register is record
      --  Write-only. GPIO interrupt status clear register for GPIO0-25
      STATUS_W1TC    : STATUS_W1TC_STATUS_W1TC_Field := 16#0#;
      --  unspecified
      Reserved_26_31 : ESP32_C3.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for STATUS_W1TC_Register use record
      STATUS_W1TC    at 0 range 0 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype PCPU_INT_PROCPU_INT_Field is ESP32_C3.UInt26;

   --  GPIO PRO_CPU interrupt status register
   type PCPU_INT_Register is record
      --  Read-only. GPIO PRO_CPU interrupt status register for GPIO0-25
      PROCPU_INT     : PCPU_INT_PROCPU_INT_Field;
      --  unspecified
      Reserved_26_31 : ESP32_C3.UInt6;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCPU_INT_Register use record
      PROCPU_INT     at 0 range 0 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype PCPU_NMI_INT_PROCPU_NMI_INT_Field is ESP32_C3.UInt26;

   --  GPIO PRO_CPU(not shielded) interrupt status register
   type PCPU_NMI_INT_Register is record
      --  Read-only. GPIO PRO_CPU(not shielded) interrupt status register for
      --  GPIO0-25
      PROCPU_NMI_INT : PCPU_NMI_INT_PROCPU_NMI_INT_Field;
      --  unspecified
      Reserved_26_31 : ESP32_C3.UInt6;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCPU_NMI_INT_Register use record
      PROCPU_NMI_INT at 0 range 0 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype CPUSDIO_INT_SDIO_INT_Field is ESP32_C3.UInt26;

   --  GPIO CPUSDIO interrupt status register
   type CPUSDIO_INT_Register is record
      --  Read-only. GPIO CPUSDIO interrupt status register for GPIO0-25
      SDIO_INT       : CPUSDIO_INT_SDIO_INT_Field;
      --  unspecified
      Reserved_26_31 : ESP32_C3.UInt6;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPUSDIO_INT_Register use record
      SDIO_INT       at 0 range 0 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype PIN_SYNC2_BYPASS_Field is ESP32_C3.UInt2;
   subtype PIN_PAD_DRIVER_Field is ESP32_C3.Bit;
   subtype PIN_SYNC1_BYPASS_Field is ESP32_C3.UInt2;
   subtype PIN_INT_TYPE_Field is ESP32_C3.UInt3;
   subtype PIN_WAKEUP_ENABLE_Field is ESP32_C3.Bit;
   subtype PIN_CONFIG_Field is ESP32_C3.UInt2;
   subtype PIN_INT_ENA_Field is ESP32_C3.UInt5;

   --  GPIO pin configuration register
   type PIN_Register is record
      --  set GPIO input_sync2 signal mode. 0:disable. 1:trigger at negedge.
      --  2or3:trigger at posedge.
      SYNC2_BYPASS   : PIN_SYNC2_BYPASS_Field := 16#0#;
      --  set this bit to select pad driver. 1:open-drain. 0:normal.
      PAD_DRIVER     : PIN_PAD_DRIVER_Field := 16#0#;
      --  set GPIO input_sync1 signal mode. 0:disable. 1:trigger at negedge.
      --  2or3:trigger at posedge.
      SYNC1_BYPASS   : PIN_SYNC1_BYPASS_Field := 16#0#;
      --  unspecified
      Reserved_5_6   : ESP32_C3.UInt2 := 16#0#;
      --  set this value to choose interrupt mode. 0:disable GPIO interrupt.
      --  1:trigger at posedge. 2:trigger at negedge. 3:trigger at any edge.
      --  4:valid at low level. 5:valid at high level
      INT_TYPE       : PIN_INT_TYPE_Field := 16#0#;
      --  set this bit to enable GPIO wakeup.(can only wakeup CPU from
      --  Light-sleep Mode)
      WAKEUP_ENABLE  : PIN_WAKEUP_ENABLE_Field := 16#0#;
      --  reserved
      CONFIG         : PIN_CONFIG_Field := 16#0#;
      --  set bit 13 to enable CPU interrupt. set bit 14 to enable CPU(not
      --  shielded) interrupt.
      INT_ENA        : PIN_INT_ENA_Field := 16#0#;
      --  unspecified
      Reserved_18_31 : ESP32_C3.UInt14 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PIN_Register use record
      SYNC2_BYPASS   at 0 range 0 .. 1;
      PAD_DRIVER     at 0 range 2 .. 2;
      SYNC1_BYPASS   at 0 range 3 .. 4;
      Reserved_5_6   at 0 range 5 .. 6;
      INT_TYPE       at 0 range 7 .. 9;
      WAKEUP_ENABLE  at 0 range 10 .. 10;
      CONFIG         at 0 range 11 .. 12;
      INT_ENA        at 0 range 13 .. 17;
      Reserved_18_31 at 0 range 18 .. 31;
   end record;

   --  GPIO pin configuration register
   type PIN_Registers is array (0 .. 25) of PIN_Register;

   subtype STATUS_NEXT_STATUS_INTERRUPT_NEXT_Field is ESP32_C3.UInt26;

   --  GPIO interrupt source register
   type STATUS_NEXT_Register is record
      --  Read-only. GPIO interrupt source register for GPIO0-25
      STATUS_INTERRUPT_NEXT : STATUS_NEXT_STATUS_INTERRUPT_NEXT_Field;
      --  unspecified
      Reserved_26_31        : ESP32_C3.UInt6;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for STATUS_NEXT_Register use record
      STATUS_INTERRUPT_NEXT at 0 range 0 .. 25;
      Reserved_26_31        at 0 range 26 .. 31;
   end record;

   subtype FUNC_IN_SEL_CFG_IN_SEL_Field is ESP32_C3.UInt5;
   subtype FUNC_IN_SEL_CFG_IN_INV_SEL_Field is ESP32_C3.Bit;
   subtype FUNC_IN_SEL_CFG_SEL_Field is ESP32_C3.Bit;

   --  GPIO input function configuration register
   type FUNC_IN_SEL_CFG_Register is record
      --  set this value: s=0-53: connect GPIO[s] to this port. s=0x38: set
      --  this port always high level. s=0x3C: set this port always low level.
      IN_SEL        : FUNC_IN_SEL_CFG_IN_SEL_Field := 16#0#;
      --  set this bit to invert input signal. 1:invert. 0:not invert.
      IN_INV_SEL    : FUNC_IN_SEL_CFG_IN_INV_SEL_Field := 16#0#;
      --  set this bit to bypass GPIO. 1:do not bypass GPIO. 0:bypass GPIO.
      SEL           : FUNC_IN_SEL_CFG_SEL_Field := 16#0#;
      --  unspecified
      Reserved_7_31 : ESP32_C3.UInt25 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FUNC_IN_SEL_CFG_Register use record
      IN_SEL        at 0 range 0 .. 4;
      IN_INV_SEL    at 0 range 5 .. 5;
      SEL           at 0 range 6 .. 6;
      Reserved_7_31 at 0 range 7 .. 31;
   end record;

   --  GPIO input function configuration register
   type FUNC_IN_SEL_CFG_Registers is array (0 .. 127)
     of FUNC_IN_SEL_CFG_Register;

   subtype FUNC_OUT_SEL_CFG_OUT_SEL_Field is ESP32_C3.Byte;
   subtype FUNC_OUT_SEL_CFG_INV_SEL_Field is ESP32_C3.Bit;
   subtype FUNC_OUT_SEL_CFG_OEN_SEL_Field is ESP32_C3.Bit;
   subtype FUNC_OUT_SEL_CFG_OEN_INV_SEL_Field is ESP32_C3.Bit;

   --  GPIO output function select register
   type FUNC_OUT_SEL_CFG_Register is record
      --  The value of the bits: 0<=s<=256. Set the value to select output
      --  signal. s=0-255: output of GPIO[n] equals input of peripheral[s].
      --  s=256: output of GPIO[n] equals GPIO_OUT_REG[n].
      OUT_SEL        : FUNC_OUT_SEL_CFG_OUT_SEL_Field := 16#80#;
      --  set this bit to invert output signal.1:invert.0:not invert.
      INV_SEL        : FUNC_OUT_SEL_CFG_INV_SEL_Field := 16#0#;
      --  set this bit to select output enable signal.1:use GPIO_ENABLE_REG[n]
      --  as output enable signal.0:use peripheral output enable signal.
      OEN_SEL        : FUNC_OUT_SEL_CFG_OEN_SEL_Field := 16#0#;
      --  set this bit to invert output enable signal.1:invert.0:not invert.
      OEN_INV_SEL    : FUNC_OUT_SEL_CFG_OEN_INV_SEL_Field := 16#0#;
      --  unspecified
      Reserved_11_31 : ESP32_C3.UInt21 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FUNC_OUT_SEL_CFG_Register use record
      OUT_SEL        at 0 range 0 .. 7;
      INV_SEL        at 0 range 8 .. 8;
      OEN_SEL        at 0 range 9 .. 9;
      OEN_INV_SEL    at 0 range 10 .. 10;
      Reserved_11_31 at 0 range 11 .. 31;
   end record;

   --  GPIO output function select register
   type FUNC_OUT_SEL_CFG_Registers is array (0 .. 25)
     of FUNC_OUT_SEL_CFG_Register;

   subtype CLOCK_GATE_CLK_EN_Field is ESP32_C3.Bit;

   --  GPIO clock gate register
   type CLOCK_GATE_Register is record
      --  set this bit to enable GPIO clock gate
      CLK_EN        : CLOCK_GATE_CLK_EN_Field := 16#1#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CLOCK_GATE_Register use record
      CLK_EN        at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype REG_DATE_REG_DATE_Field is ESP32_C3.UInt28;

   --  GPIO version register
   type REG_DATE_Register is record
      --  version register
      REG_DATE       : REG_DATE_REG_DATE_Field := 16#2006130#;
      --  unspecified
      Reserved_28_31 : ESP32_C3.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REG_DATE_Register use record
      REG_DATE       at 0 range 0 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  General Purpose Input/Output
   type GPIO_Peripheral is record
      --  GPIO bit select register
      BT_SELECT        : aliased ESP32_C3.UInt32;
      --  GPIO output register
      OUT_k            : aliased OUT_Register;
      --  GPIO output set register
      OUT_W1TS         : aliased OUT_W1TS_Register;
      --  GPIO output clear register
      OUT_W1TC         : aliased OUT_W1TC_Register;
      --  GPIO sdio select register
      SDIO_SELECT      : aliased SDIO_SELECT_Register;
      --  GPIO output enable register
      ENABLE           : aliased ENABLE_Register;
      --  GPIO output enable set register
      ENABLE_W1TS      : aliased ENABLE_W1TS_Register;
      --  GPIO output enable clear register
      ENABLE_W1TC      : aliased ENABLE_W1TC_Register;
      --  pad strapping register
      STRAP            : aliased STRAP_Register;
      --  GPIO input register
      IN_k             : aliased IN_Register;
      --  GPIO interrupt status register
      STATUS           : aliased STATUS_Register;
      --  GPIO interrupt status set register
      STATUS_W1TS      : aliased STATUS_W1TS_Register;
      --  GPIO interrupt status clear register
      STATUS_W1TC      : aliased STATUS_W1TC_Register;
      --  GPIO PRO_CPU interrupt status register
      PCPU_INT         : aliased PCPU_INT_Register;
      --  GPIO PRO_CPU(not shielded) interrupt status register
      PCPU_NMI_INT     : aliased PCPU_NMI_INT_Register;
      --  GPIO CPUSDIO interrupt status register
      CPUSDIO_INT      : aliased CPUSDIO_INT_Register;
      --  GPIO pin configuration register
      PIN              : aliased PIN_Registers;
      --  GPIO interrupt source register
      STATUS_NEXT      : aliased STATUS_NEXT_Register;
      --  GPIO input function configuration register
      FUNC_IN_SEL_CFG  : aliased FUNC_IN_SEL_CFG_Registers;
      --  GPIO output function select register
      FUNC_OUT_SEL_CFG : aliased FUNC_OUT_SEL_CFG_Registers;
      --  GPIO clock gate register
      CLOCK_GATE       : aliased CLOCK_GATE_Register;
      --  GPIO version register
      REG_DATE         : aliased REG_DATE_Register;
   end record
     with Volatile;

   for GPIO_Peripheral use record
      BT_SELECT        at 16#0# range 0 .. 31;
      OUT_k            at 16#4# range 0 .. 31;
      OUT_W1TS         at 16#8# range 0 .. 31;
      OUT_W1TC         at 16#C# range 0 .. 31;
      SDIO_SELECT      at 16#1C# range 0 .. 31;
      ENABLE           at 16#20# range 0 .. 31;
      ENABLE_W1TS      at 16#24# range 0 .. 31;
      ENABLE_W1TC      at 16#28# range 0 .. 31;
      STRAP            at 16#38# range 0 .. 31;
      IN_k             at 16#3C# range 0 .. 31;
      STATUS           at 16#44# range 0 .. 31;
      STATUS_W1TS      at 16#48# range 0 .. 31;
      STATUS_W1TC      at 16#4C# range 0 .. 31;
      PCPU_INT         at 16#5C# range 0 .. 31;
      PCPU_NMI_INT     at 16#60# range 0 .. 31;
      CPUSDIO_INT      at 16#64# range 0 .. 31;
      PIN              at 16#74# range 0 .. 831;
      STATUS_NEXT      at 16#14C# range 0 .. 31;
      FUNC_IN_SEL_CFG  at 16#154# range 0 .. 4095;
      FUNC_OUT_SEL_CFG at 16#554# range 0 .. 831;
      CLOCK_GATE       at 16#62C# range 0 .. 31;
      REG_DATE         at 16#6FC# range 0 .. 31;
   end record;

   --  General Purpose Input/Output
   GPIO_Periph : aliased GPIO_Peripheral
     with Import, Address => GPIO_Base;

end ESP32_C3.GPIO;
