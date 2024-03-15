pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.INTERRUPT_CORE0 is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype MAC_INTR_MAP_MAC_INTR_MAP_Field is ESP32_C3.UInt5;

   --  mac intr map register
   type MAC_INTR_MAP_Register is record
      --  core0_mac_intr_map
      MAC_INTR_MAP  : MAC_INTR_MAP_MAC_INTR_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for MAC_INTR_MAP_Register use record
      MAC_INTR_MAP  at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype MAC_NMI_MAP_MAC_NMI_MAP_Field is ESP32_C3.UInt5;

   --  mac nmi_intr map register
   type MAC_NMI_MAP_Register is record
      --  reg_core0_mac_nmi_map
      MAC_NMI_MAP   : MAC_NMI_MAP_MAC_NMI_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for MAC_NMI_MAP_Register use record
      MAC_NMI_MAP   at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype PWR_INTR_MAP_PWR_INTR_MAP_Field is ESP32_C3.UInt5;

   --  pwr intr map register
   type PWR_INTR_MAP_Register is record
      --  reg_core0_pwr_intr_map
      PWR_INTR_MAP  : PWR_INTR_MAP_PWR_INTR_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PWR_INTR_MAP_Register use record
      PWR_INTR_MAP  at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype BB_INT_MAP_BB_INT_MAP_Field is ESP32_C3.UInt5;

   --  bb intr map register
   type BB_INT_MAP_Register is record
      --  reg_core0_bb_int_map
      BB_INT_MAP    : BB_INT_MAP_BB_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BB_INT_MAP_Register use record
      BB_INT_MAP    at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype BT_MAC_INT_MAP_BT_MAC_INT_MAP_Field is ESP32_C3.UInt5;

   --  bt intr map register
   type BT_MAC_INT_MAP_Register is record
      --  reg_core0_bt_mac_int_map
      BT_MAC_INT_MAP : BT_MAC_INT_MAP_BT_MAC_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31  : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BT_MAC_INT_MAP_Register use record
      BT_MAC_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31  at 0 range 5 .. 31;
   end record;

   subtype BT_BB_INT_MAP_BT_BB_INT_MAP_Field is ESP32_C3.UInt5;

   --  bb_bt intr map register
   type BT_BB_INT_MAP_Register is record
      --  reg_core0_bt_bb_int_map
      BT_BB_INT_MAP : BT_BB_INT_MAP_BT_BB_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BT_BB_INT_MAP_Register use record
      BT_BB_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype BT_BB_NMI_MAP_BT_BB_NMI_MAP_Field is ESP32_C3.UInt5;

   --  bb_bt_nmi intr map register
   type BT_BB_NMI_MAP_Register is record
      --  reg_core0_bt_bb_nmi_map
      BT_BB_NMI_MAP : BT_BB_NMI_MAP_BT_BB_NMI_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BT_BB_NMI_MAP_Register use record
      BT_BB_NMI_MAP at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype RWBT_IRQ_MAP_RWBT_IRQ_MAP_Field is ESP32_C3.UInt5;

   --  rwbt intr map register
   type RWBT_IRQ_MAP_Register is record
      --  reg_core0_rwbt_irq_map
      RWBT_IRQ_MAP  : RWBT_IRQ_MAP_RWBT_IRQ_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RWBT_IRQ_MAP_Register use record
      RWBT_IRQ_MAP  at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype RWBLE_IRQ_MAP_RWBLE_IRQ_MAP_Field is ESP32_C3.UInt5;

   --  rwble intr map register
   type RWBLE_IRQ_MAP_Register is record
      --  reg_core0_rwble_irq_map
      RWBLE_IRQ_MAP : RWBLE_IRQ_MAP_RWBLE_IRQ_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RWBLE_IRQ_MAP_Register use record
      RWBLE_IRQ_MAP at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype RWBT_NMI_MAP_RWBT_NMI_MAP_Field is ESP32_C3.UInt5;

   --  rwbt_nmi intr map register
   type RWBT_NMI_MAP_Register is record
      --  reg_core0_rwbt_nmi_map
      RWBT_NMI_MAP  : RWBT_NMI_MAP_RWBT_NMI_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RWBT_NMI_MAP_Register use record
      RWBT_NMI_MAP  at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype RWBLE_NMI_MAP_RWBLE_NMI_MAP_Field is ESP32_C3.UInt5;

   --  rwble_nmi intr map register
   type RWBLE_NMI_MAP_Register is record
      --  reg_core0_rwble_nmi_map
      RWBLE_NMI_MAP : RWBLE_NMI_MAP_RWBLE_NMI_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RWBLE_NMI_MAP_Register use record
      RWBLE_NMI_MAP at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype I2C_MST_INT_MAP_I2C_MST_INT_MAP_Field is ESP32_C3.UInt5;

   --  i2c intr map register
   type I2C_MST_INT_MAP_Register is record
      --  reg_core0_i2c_mst_int_map
      I2C_MST_INT_MAP : I2C_MST_INT_MAP_I2C_MST_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31   : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2C_MST_INT_MAP_Register use record
      I2C_MST_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31   at 0 range 5 .. 31;
   end record;

   subtype SLC0_INTR_MAP_SLC0_INTR_MAP_Field is ESP32_C3.UInt5;

   --  slc0 intr map register
   type SLC0_INTR_MAP_Register is record
      --  reg_core0_slc0_intr_map
      SLC0_INTR_MAP : SLC0_INTR_MAP_SLC0_INTR_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SLC0_INTR_MAP_Register use record
      SLC0_INTR_MAP at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype SLC1_INTR_MAP_SLC1_INTR_MAP_Field is ESP32_C3.UInt5;

   --  slc1 intr map register
   type SLC1_INTR_MAP_Register is record
      --  reg_core0_slc1_intr_map
      SLC1_INTR_MAP : SLC1_INTR_MAP_SLC1_INTR_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SLC1_INTR_MAP_Register use record
      SLC1_INTR_MAP at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype APB_CTRL_INTR_MAP_APB_CTRL_INTR_MAP_Field is ESP32_C3.UInt5;

   --  apb_ctrl intr map register
   type APB_CTRL_INTR_MAP_Register is record
      --  reg_core0_apb_ctrl_intr_map
      APB_CTRL_INTR_MAP : APB_CTRL_INTR_MAP_APB_CTRL_INTR_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31     : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for APB_CTRL_INTR_MAP_Register use record
      APB_CTRL_INTR_MAP at 0 range 0 .. 4;
      Reserved_5_31     at 0 range 5 .. 31;
   end record;

   subtype UHCI0_INTR_MAP_UHCI0_INTR_MAP_Field is ESP32_C3.UInt5;

   --  uchi0 intr map register
   type UHCI0_INTR_MAP_Register is record
      --  reg_core0_uhci0_intr_map
      UHCI0_INTR_MAP : UHCI0_INTR_MAP_UHCI0_INTR_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31  : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UHCI0_INTR_MAP_Register use record
      UHCI0_INTR_MAP at 0 range 0 .. 4;
      Reserved_5_31  at 0 range 5 .. 31;
   end record;

   subtype GPIO_INTERRUPT_PRO_MAP_GPIO_INTERRUPT_PRO_MAP_Field is
     ESP32_C3.UInt5;

   --  gpio intr map register
   type GPIO_INTERRUPT_PRO_MAP_Register is record
      --  reg_core0_gpio_interrupt_pro_map
      GPIO_INTERRUPT_PRO_MAP : GPIO_INTERRUPT_PRO_MAP_GPIO_INTERRUPT_PRO_MAP_Field :=
                                16#0#;
      --  unspecified
      Reserved_5_31          : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for GPIO_INTERRUPT_PRO_MAP_Register use record
      GPIO_INTERRUPT_PRO_MAP at 0 range 0 .. 4;
      Reserved_5_31          at 0 range 5 .. 31;
   end record;

   subtype GPIO_INTERRUPT_PRO_NMI_MAP_GPIO_INTERRUPT_PRO_NMI_MAP_Field is
     ESP32_C3.UInt5;

   --  gpio_pro intr map register
   type GPIO_INTERRUPT_PRO_NMI_MAP_Register is record
      --  reg_core0_gpio_interrupt_pro_nmi_map
      GPIO_INTERRUPT_PRO_NMI_MAP : GPIO_INTERRUPT_PRO_NMI_MAP_GPIO_INTERRUPT_PRO_NMI_MAP_Field :=
                                    16#0#;
      --  unspecified
      Reserved_5_31              : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for GPIO_INTERRUPT_PRO_NMI_MAP_Register use record
      GPIO_INTERRUPT_PRO_NMI_MAP at 0 range 0 .. 4;
      Reserved_5_31              at 0 range 5 .. 31;
   end record;

   subtype SPI_INTR_1_MAP_SPI_INTR_1_MAP_Field is ESP32_C3.UInt5;

   --  gpio_pro_nmi intr map register
   type SPI_INTR_1_MAP_Register is record
      --  reg_core0_spi_intr_1_map
      SPI_INTR_1_MAP : SPI_INTR_1_MAP_SPI_INTR_1_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31  : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SPI_INTR_1_MAP_Register use record
      SPI_INTR_1_MAP at 0 range 0 .. 4;
      Reserved_5_31  at 0 range 5 .. 31;
   end record;

   subtype SPI_INTR_2_MAP_SPI_INTR_2_MAP_Field is ESP32_C3.UInt5;

   --  spi1 intr map register
   type SPI_INTR_2_MAP_Register is record
      --  reg_core0_spi_intr_2_map
      SPI_INTR_2_MAP : SPI_INTR_2_MAP_SPI_INTR_2_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31  : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SPI_INTR_2_MAP_Register use record
      SPI_INTR_2_MAP at 0 range 0 .. 4;
      Reserved_5_31  at 0 range 5 .. 31;
   end record;

   subtype I2S1_INT_MAP_I2S1_INT_MAP_Field is ESP32_C3.UInt5;

   --  spi2 intr map register
   type I2S1_INT_MAP_Register is record
      --  reg_core0_i2s1_int_map
      I2S1_INT_MAP  : I2S1_INT_MAP_I2S1_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2S1_INT_MAP_Register use record
      I2S1_INT_MAP  at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype UART_INTR_MAP_UART_INTR_MAP_Field is ESP32_C3.UInt5;

   --  i2s1 intr map register
   type UART_INTR_MAP_Register is record
      --  reg_core0_uart_intr_map
      UART_INTR_MAP : UART_INTR_MAP_UART_INTR_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UART_INTR_MAP_Register use record
      UART_INTR_MAP at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype UART1_INTR_MAP_UART1_INTR_MAP_Field is ESP32_C3.UInt5;

   --  uart1 intr map register
   type UART1_INTR_MAP_Register is record
      --  reg_core0_uart1_intr_map
      UART1_INTR_MAP : UART1_INTR_MAP_UART1_INTR_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31  : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for UART1_INTR_MAP_Register use record
      UART1_INTR_MAP at 0 range 0 .. 4;
      Reserved_5_31  at 0 range 5 .. 31;
   end record;

   subtype LEDC_INT_MAP_LEDC_INT_MAP_Field is ESP32_C3.UInt5;

   --  ledc intr map register
   type LEDC_INT_MAP_Register is record
      --  reg_core0_ledc_int_map
      LEDC_INT_MAP  : LEDC_INT_MAP_LEDC_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for LEDC_INT_MAP_Register use record
      LEDC_INT_MAP  at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype EFUSE_INT_MAP_EFUSE_INT_MAP_Field is ESP32_C3.UInt5;

   --  efuse intr map register
   type EFUSE_INT_MAP_Register is record
      --  reg_core0_efuse_int_map
      EFUSE_INT_MAP : EFUSE_INT_MAP_EFUSE_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for EFUSE_INT_MAP_Register use record
      EFUSE_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype CAN_INT_MAP_CAN_INT_MAP_Field is ESP32_C3.UInt5;

   --  can intr map register
   type CAN_INT_MAP_Register is record
      --  reg_core0_can_int_map
      CAN_INT_MAP   : CAN_INT_MAP_CAN_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAN_INT_MAP_Register use record
      CAN_INT_MAP   at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype USB_INTR_MAP_USB_INTR_MAP_Field is ESP32_C3.UInt5;

   --  usb intr map register
   type USB_INTR_MAP_Register is record
      --  reg_core0_usb_intr_map
      USB_INTR_MAP  : USB_INTR_MAP_USB_INTR_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for USB_INTR_MAP_Register use record
      USB_INTR_MAP  at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype RTC_CORE_INTR_MAP_RTC_CORE_INTR_MAP_Field is ESP32_C3.UInt5;

   --  rtc intr map register
   type RTC_CORE_INTR_MAP_Register is record
      --  reg_core0_rtc_core_intr_map
      RTC_CORE_INTR_MAP : RTC_CORE_INTR_MAP_RTC_CORE_INTR_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31     : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RTC_CORE_INTR_MAP_Register use record
      RTC_CORE_INTR_MAP at 0 range 0 .. 4;
      Reserved_5_31     at 0 range 5 .. 31;
   end record;

   subtype RMT_INTR_MAP_RMT_INTR_MAP_Field is ESP32_C3.UInt5;

   --  rmt intr map register
   type RMT_INTR_MAP_Register is record
      --  reg_core0_rmt_intr_map
      RMT_INTR_MAP  : RMT_INTR_MAP_RMT_INTR_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RMT_INTR_MAP_Register use record
      RMT_INTR_MAP  at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype I2C_EXT0_INTR_MAP_I2C_EXT0_INTR_MAP_Field is ESP32_C3.UInt5;

   --  i2c intr map register
   type I2C_EXT0_INTR_MAP_Register is record
      --  reg_core0_i2c_ext0_intr_map
      I2C_EXT0_INTR_MAP : I2C_EXT0_INTR_MAP_I2C_EXT0_INTR_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31     : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2C_EXT0_INTR_MAP_Register use record
      I2C_EXT0_INTR_MAP at 0 range 0 .. 4;
      Reserved_5_31     at 0 range 5 .. 31;
   end record;

   subtype TIMER_INT1_MAP_TIMER_INT1_MAP_Field is ESP32_C3.UInt5;

   --  timer1 intr map register
   type TIMER_INT1_MAP_Register is record
      --  reg_core0_timer_int1_map
      TIMER_INT1_MAP : TIMER_INT1_MAP_TIMER_INT1_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31  : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIMER_INT1_MAP_Register use record
      TIMER_INT1_MAP at 0 range 0 .. 4;
      Reserved_5_31  at 0 range 5 .. 31;
   end record;

   subtype TIMER_INT2_MAP_TIMER_INT2_MAP_Field is ESP32_C3.UInt5;

   --  timer2 intr map register
   type TIMER_INT2_MAP_Register is record
      --  reg_core0_timer_int2_map
      TIMER_INT2_MAP : TIMER_INT2_MAP_TIMER_INT2_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31  : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIMER_INT2_MAP_Register use record
      TIMER_INT2_MAP at 0 range 0 .. 4;
      Reserved_5_31  at 0 range 5 .. 31;
   end record;

   subtype TG_T0_INT_MAP_TG_T0_INT_MAP_Field is ESP32_C3.UInt5;

   --  tg to intr map register
   type TG_T0_INT_MAP_Register is record
      --  reg_core0_tg_t0_int_map
      TG_T0_INT_MAP : TG_T0_INT_MAP_TG_T0_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TG_T0_INT_MAP_Register use record
      TG_T0_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype TG_WDT_INT_MAP_TG_WDT_INT_MAP_Field is ESP32_C3.UInt5;

   --  tg wdt intr map register
   type TG_WDT_INT_MAP_Register is record
      --  reg_core0_tg_wdt_int_map
      TG_WDT_INT_MAP : TG_WDT_INT_MAP_TG_WDT_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31  : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TG_WDT_INT_MAP_Register use record
      TG_WDT_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31  at 0 range 5 .. 31;
   end record;

   subtype TG1_T0_INT_MAP_TG1_T0_INT_MAP_Field is ESP32_C3.UInt5;

   --  tg1 to intr map register
   type TG1_T0_INT_MAP_Register is record
      --  reg_core0_tg1_t0_int_map
      TG1_T0_INT_MAP : TG1_T0_INT_MAP_TG1_T0_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31  : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TG1_T0_INT_MAP_Register use record
      TG1_T0_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31  at 0 range 5 .. 31;
   end record;

   subtype TG1_WDT_INT_MAP_TG1_WDT_INT_MAP_Field is ESP32_C3.UInt5;

   --  tg1 wdt intr map register
   type TG1_WDT_INT_MAP_Register is record
      --  reg_core0_tg1_wdt_int_map
      TG1_WDT_INT_MAP : TG1_WDT_INT_MAP_TG1_WDT_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31   : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TG1_WDT_INT_MAP_Register use record
      TG1_WDT_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31   at 0 range 5 .. 31;
   end record;

   subtype CACHE_IA_INT_MAP_CACHE_IA_INT_MAP_Field is ESP32_C3.UInt5;

   --  cache ia intr map register
   type CACHE_IA_INT_MAP_Register is record
      --  reg_core0_cache_ia_int_map
      CACHE_IA_INT_MAP : CACHE_IA_INT_MAP_CACHE_IA_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31    : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_IA_INT_MAP_Register use record
      CACHE_IA_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31    at 0 range 5 .. 31;
   end record;

   subtype SYSTIMER_TARGET0_INT_MAP_SYSTIMER_TARGET0_INT_MAP_Field is
     ESP32_C3.UInt5;

   --  systimer intr map register
   type SYSTIMER_TARGET0_INT_MAP_Register is record
      --  reg_core0_systimer_target0_int_map
      SYSTIMER_TARGET0_INT_MAP : SYSTIMER_TARGET0_INT_MAP_SYSTIMER_TARGET0_INT_MAP_Field :=
                                  16#0#;
      --  unspecified
      Reserved_5_31            : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYSTIMER_TARGET0_INT_MAP_Register use record
      SYSTIMER_TARGET0_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31            at 0 range 5 .. 31;
   end record;

   subtype SYSTIMER_TARGET1_INT_MAP_SYSTIMER_TARGET1_INT_MAP_Field is
     ESP32_C3.UInt5;

   --  systimer target1 intr map register
   type SYSTIMER_TARGET1_INT_MAP_Register is record
      --  reg_core0_systimer_target1_int_map
      SYSTIMER_TARGET1_INT_MAP : SYSTIMER_TARGET1_INT_MAP_SYSTIMER_TARGET1_INT_MAP_Field :=
                                  16#0#;
      --  unspecified
      Reserved_5_31            : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYSTIMER_TARGET1_INT_MAP_Register use record
      SYSTIMER_TARGET1_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31            at 0 range 5 .. 31;
   end record;

   subtype SYSTIMER_TARGET2_INT_MAP_SYSTIMER_TARGET2_INT_MAP_Field is
     ESP32_C3.UInt5;

   --  systimer target2 intr map register
   type SYSTIMER_TARGET2_INT_MAP_Register is record
      --  reg_core0_systimer_target2_int_map
      SYSTIMER_TARGET2_INT_MAP : SYSTIMER_TARGET2_INT_MAP_SYSTIMER_TARGET2_INT_MAP_Field :=
                                  16#0#;
      --  unspecified
      Reserved_5_31            : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYSTIMER_TARGET2_INT_MAP_Register use record
      SYSTIMER_TARGET2_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31            at 0 range 5 .. 31;
   end record;

   subtype SPI_MEM_REJECT_INTR_MAP_SPI_MEM_REJECT_INTR_MAP_Field is
     ESP32_C3.UInt5;

   --  spi mem reject intr map register
   type SPI_MEM_REJECT_INTR_MAP_Register is record
      --  reg_core0_spi_mem_reject_intr_map
      SPI_MEM_REJECT_INTR_MAP : SPI_MEM_REJECT_INTR_MAP_SPI_MEM_REJECT_INTR_MAP_Field :=
                                 16#0#;
      --  unspecified
      Reserved_5_31           : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SPI_MEM_REJECT_INTR_MAP_Register use record
      SPI_MEM_REJECT_INTR_MAP at 0 range 0 .. 4;
      Reserved_5_31           at 0 range 5 .. 31;
   end record;

   subtype ICACHE_PRELOAD_INT_MAP_ICACHE_PRELOAD_INT_MAP_Field is
     ESP32_C3.UInt5;

   --  icache perload intr map register
   type ICACHE_PRELOAD_INT_MAP_Register is record
      --  reg_core0_icache_preload_int_map
      ICACHE_PRELOAD_INT_MAP : ICACHE_PRELOAD_INT_MAP_ICACHE_PRELOAD_INT_MAP_Field :=
                                16#0#;
      --  unspecified
      Reserved_5_31          : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_PRELOAD_INT_MAP_Register use record
      ICACHE_PRELOAD_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31          at 0 range 5 .. 31;
   end record;

   subtype ICACHE_SYNC_INT_MAP_ICACHE_SYNC_INT_MAP_Field is ESP32_C3.UInt5;

   --  icache sync intr map register
   type ICACHE_SYNC_INT_MAP_Register is record
      --  reg_core0_icache_sync_int_map
      ICACHE_SYNC_INT_MAP : ICACHE_SYNC_INT_MAP_ICACHE_SYNC_INT_MAP_Field :=
                             16#0#;
      --  unspecified
      Reserved_5_31       : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_SYNC_INT_MAP_Register use record
      ICACHE_SYNC_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31       at 0 range 5 .. 31;
   end record;

   subtype APB_ADC_INT_MAP_APB_ADC_INT_MAP_Field is ESP32_C3.UInt5;

   --  adc intr map register
   type APB_ADC_INT_MAP_Register is record
      --  reg_core0_apb_adc_int_map
      APB_ADC_INT_MAP : APB_ADC_INT_MAP_APB_ADC_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31   : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for APB_ADC_INT_MAP_Register use record
      APB_ADC_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31   at 0 range 5 .. 31;
   end record;

   subtype DMA_CH0_INT_MAP_DMA_CH0_INT_MAP_Field is ESP32_C3.UInt5;

   --  dma ch0 intr map register
   type DMA_CH0_INT_MAP_Register is record
      --  reg_core0_dma_ch0_int_map
      DMA_CH0_INT_MAP : DMA_CH0_INT_MAP_DMA_CH0_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31   : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_CH0_INT_MAP_Register use record
      DMA_CH0_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31   at 0 range 5 .. 31;
   end record;

   subtype DMA_CH1_INT_MAP_DMA_CH1_INT_MAP_Field is ESP32_C3.UInt5;

   --  dma ch1 intr map register
   type DMA_CH1_INT_MAP_Register is record
      --  reg_core0_dma_ch1_int_map
      DMA_CH1_INT_MAP : DMA_CH1_INT_MAP_DMA_CH1_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31   : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_CH1_INT_MAP_Register use record
      DMA_CH1_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31   at 0 range 5 .. 31;
   end record;

   subtype DMA_CH2_INT_MAP_DMA_CH2_INT_MAP_Field is ESP32_C3.UInt5;

   --  dma ch2 intr map register
   type DMA_CH2_INT_MAP_Register is record
      --  reg_core0_dma_ch2_int_map
      DMA_CH2_INT_MAP : DMA_CH2_INT_MAP_DMA_CH2_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31   : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_CH2_INT_MAP_Register use record
      DMA_CH2_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31   at 0 range 5 .. 31;
   end record;

   subtype RSA_INT_MAP_RSA_INT_MAP_Field is ESP32_C3.UInt5;

   --  rsa intr map register
   type RSA_INT_MAP_Register is record
      --  reg_core0_rsa_int_map
      RSA_INT_MAP   : RSA_INT_MAP_RSA_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RSA_INT_MAP_Register use record
      RSA_INT_MAP   at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype AES_INT_MAP_AES_INT_MAP_Field is ESP32_C3.UInt5;

   --  aes intr map register
   type AES_INT_MAP_Register is record
      --  reg_core0_aes_int_map
      AES_INT_MAP   : AES_INT_MAP_AES_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for AES_INT_MAP_Register use record
      AES_INT_MAP   at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype SHA_INT_MAP_SHA_INT_MAP_Field is ESP32_C3.UInt5;

   --  sha intr map register
   type SHA_INT_MAP_Register is record
      --  reg_core0_sha_int_map
      SHA_INT_MAP   : SHA_INT_MAP_SHA_INT_MAP_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SHA_INT_MAP_Register use record
      SHA_INT_MAP   at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype CPU_INTR_FROM_CPU_0_MAP_CPU_INTR_FROM_CPU_0_MAP_Field is
     ESP32_C3.UInt5;

   --  cpu from cpu 0 intr map register
   type CPU_INTR_FROM_CPU_0_MAP_Register is record
      --  reg_core0_cpu_intr_from_cpu_0_map
      CPU_INTR_FROM_CPU_0_MAP : CPU_INTR_FROM_CPU_0_MAP_CPU_INTR_FROM_CPU_0_MAP_Field :=
                                 16#0#;
      --  unspecified
      Reserved_5_31           : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INTR_FROM_CPU_0_MAP_Register use record
      CPU_INTR_FROM_CPU_0_MAP at 0 range 0 .. 4;
      Reserved_5_31           at 0 range 5 .. 31;
   end record;

   subtype CPU_INTR_FROM_CPU_1_MAP_CPU_INTR_FROM_CPU_1_MAP_Field is
     ESP32_C3.UInt5;

   --  cpu from cpu 0 intr map register
   type CPU_INTR_FROM_CPU_1_MAP_Register is record
      --  reg_core0_cpu_intr_from_cpu_1_map
      CPU_INTR_FROM_CPU_1_MAP : CPU_INTR_FROM_CPU_1_MAP_CPU_INTR_FROM_CPU_1_MAP_Field :=
                                 16#0#;
      --  unspecified
      Reserved_5_31           : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INTR_FROM_CPU_1_MAP_Register use record
      CPU_INTR_FROM_CPU_1_MAP at 0 range 0 .. 4;
      Reserved_5_31           at 0 range 5 .. 31;
   end record;

   subtype CPU_INTR_FROM_CPU_2_MAP_CPU_INTR_FROM_CPU_2_MAP_Field is
     ESP32_C3.UInt5;

   --  cpu from cpu 1 intr map register
   type CPU_INTR_FROM_CPU_2_MAP_Register is record
      --  reg_core0_cpu_intr_from_cpu_2_map
      CPU_INTR_FROM_CPU_2_MAP : CPU_INTR_FROM_CPU_2_MAP_CPU_INTR_FROM_CPU_2_MAP_Field :=
                                 16#0#;
      --  unspecified
      Reserved_5_31           : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INTR_FROM_CPU_2_MAP_Register use record
      CPU_INTR_FROM_CPU_2_MAP at 0 range 0 .. 4;
      Reserved_5_31           at 0 range 5 .. 31;
   end record;

   subtype CPU_INTR_FROM_CPU_3_MAP_CPU_INTR_FROM_CPU_3_MAP_Field is
     ESP32_C3.UInt5;

   --  cpu from cpu 3 intr map register
   type CPU_INTR_FROM_CPU_3_MAP_Register is record
      --  reg_core0_cpu_intr_from_cpu_3_map
      CPU_INTR_FROM_CPU_3_MAP : CPU_INTR_FROM_CPU_3_MAP_CPU_INTR_FROM_CPU_3_MAP_Field :=
                                 16#0#;
      --  unspecified
      Reserved_5_31           : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INTR_FROM_CPU_3_MAP_Register use record
      CPU_INTR_FROM_CPU_3_MAP at 0 range 0 .. 4;
      Reserved_5_31           at 0 range 5 .. 31;
   end record;

   subtype ASSIST_DEBUG_INTR_MAP_ASSIST_DEBUG_INTR_MAP_Field is ESP32_C3.UInt5;

   --  assist debug intr map register
   type ASSIST_DEBUG_INTR_MAP_Register is record
      --  reg_core0_assist_debug_intr_map
      ASSIST_DEBUG_INTR_MAP : ASSIST_DEBUG_INTR_MAP_ASSIST_DEBUG_INTR_MAP_Field :=
                               16#0#;
      --  unspecified
      Reserved_5_31         : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ASSIST_DEBUG_INTR_MAP_Register use record
      ASSIST_DEBUG_INTR_MAP at 0 range 0 .. 4;
      Reserved_5_31         at 0 range 5 .. 31;
   end record;

   subtype DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_MAP_DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_MAP_Field is
     ESP32_C3.UInt5;

   --  dma pms violatile intr map register
   type DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_MAP_Register is record
      --  reg_core0_dma_apbperi_pms_monitor_violate_intr_map
      DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_MAP : DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_MAP_DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_MAP_Field :=
                                                  16#0#;
      --  unspecified
      Reserved_5_31                            : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_MAP_Register use record
      DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_MAP at 0 range 0 .. 4;
      Reserved_5_31                            at 0 range 5 .. 31;
   end record;

   subtype CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_MAP_CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_MAP_Field is
     ESP32_C3.UInt5;

   --  iram0 pms violatile intr map register
   type CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_MAP_Register is record
      --  reg_core0_core_0_iram0_pms_monitor_violate_intr_map
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_MAP : CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_MAP_CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_MAP_Field :=
                                                   16#0#;
      --  unspecified
      Reserved_5_31                             : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_MAP_Register use record
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_MAP at 0 range 0 .. 4;
      Reserved_5_31                             at 0 range 5 .. 31;
   end record;

   subtype CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_MAP_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_MAP_Field is
     ESP32_C3.UInt5;

   --  mac intr map register
   type CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_MAP_Register is record
      --  reg_core0_core_0_dram0_pms_monitor_violate_intr_map
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_MAP : CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_MAP_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_MAP_Field :=
                                                   16#0#;
      --  unspecified
      Reserved_5_31                             : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_MAP_Register use record
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_MAP at 0 range 0 .. 4;
      Reserved_5_31                             at 0 range 5 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_MAP_CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_MAP_Field is
     ESP32_C3.UInt5;

   --  mac intr map register
   type CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_MAP_Register is record
      --  reg_core0_core_0_pif_pms_monitor_violate_intr_map
      CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_MAP : CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_MAP_CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_MAP_Field :=
                                                 16#0#;
      --  unspecified
      Reserved_5_31                           : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_MAP_Register use record
      CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_MAP at 0 range 0 .. 4;
      Reserved_5_31                           at 0 range 5 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_MONITOR_VIOLATE_SIZE_INTR_MAP_CORE_0_PIF_PMS_MONITOR_VIOLATE_SIZE_INTR_MAP_Field is
     ESP32_C3.UInt5;

   --  mac intr map register
   type CORE_0_PIF_PMS_MONITOR_VIOLATE_SIZE_INTR_MAP_Register is record
      --  reg_core0_core_0_pif_pms_monitor_violate_size_intr_map
      CORE_0_PIF_PMS_MONITOR_VIOLATE_SIZE_INTR_MAP : CORE_0_PIF_PMS_MONITOR_VIOLATE_SIZE_INTR_MAP_CORE_0_PIF_PMS_MONITOR_VIOLATE_SIZE_INTR_MAP_Field :=
                                                      16#0#;
      --  unspecified
      Reserved_5_31                                : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_MONITOR_VIOLATE_SIZE_INTR_MAP_Register use record
      CORE_0_PIF_PMS_MONITOR_VIOLATE_SIZE_INTR_MAP at 0 range 0 .. 4;
      Reserved_5_31                                at 0 range 5 .. 31;
   end record;

   subtype BACKUP_PMS_VIOLATE_INTR_MAP_BACKUP_PMS_VIOLATE_INTR_MAP_Field is
     ESP32_C3.UInt5;

   --  mac intr map register
   type BACKUP_PMS_VIOLATE_INTR_MAP_Register is record
      --  reg_core0_backup_pms_violate_intr_map
      BACKUP_PMS_VIOLATE_INTR_MAP : BACKUP_PMS_VIOLATE_INTR_MAP_BACKUP_PMS_VIOLATE_INTR_MAP_Field :=
                                     16#0#;
      --  unspecified
      Reserved_5_31               : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BACKUP_PMS_VIOLATE_INTR_MAP_Register use record
      BACKUP_PMS_VIOLATE_INTR_MAP at 0 range 0 .. 4;
      Reserved_5_31               at 0 range 5 .. 31;
   end record;

   subtype CACHE_CORE0_ACS_INT_MAP_CACHE_CORE0_ACS_INT_MAP_Field is
     ESP32_C3.UInt5;

   --  mac intr map register
   type CACHE_CORE0_ACS_INT_MAP_Register is record
      --  reg_core0_cache_core0_acs_int_map
      CACHE_CORE0_ACS_INT_MAP : CACHE_CORE0_ACS_INT_MAP_CACHE_CORE0_ACS_INT_MAP_Field :=
                                 16#0#;
      --  unspecified
      Reserved_5_31           : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_CORE0_ACS_INT_MAP_Register use record
      CACHE_CORE0_ACS_INT_MAP at 0 range 0 .. 4;
      Reserved_5_31           at 0 range 5 .. 31;
   end record;

   subtype CLOCK_GATE_REG_CLK_EN_Field is ESP32_C3.Bit;

   --  mac intr map register
   type CLOCK_GATE_Register is record
      --  reg_core0_reg_clk_en
      REG_CLK_EN    : CLOCK_GATE_REG_CLK_EN_Field := 16#1#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CLOCK_GATE_Register use record
      REG_CLK_EN    at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype CPU_INT_PRI_0_CPU_PRI_0_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_0_Register is record
      --  reg_core0_cpu_pri_0_map
      CPU_PRI_0_MAP : CPU_INT_PRI_0_CPU_PRI_0_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31 : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_0_Register use record
      CPU_PRI_0_MAP at 0 range 0 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_1_CPU_PRI_1_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_1_Register is record
      --  reg_core0_cpu_pri_1_map
      CPU_PRI_1_MAP : CPU_INT_PRI_1_CPU_PRI_1_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31 : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_1_Register use record
      CPU_PRI_1_MAP at 0 range 0 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_2_CPU_PRI_2_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_2_Register is record
      --  reg_core0_cpu_pri_2_map
      CPU_PRI_2_MAP : CPU_INT_PRI_2_CPU_PRI_2_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31 : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_2_Register use record
      CPU_PRI_2_MAP at 0 range 0 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_3_CPU_PRI_3_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_3_Register is record
      --  reg_core0_cpu_pri_3_map
      CPU_PRI_3_MAP : CPU_INT_PRI_3_CPU_PRI_3_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31 : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_3_Register use record
      CPU_PRI_3_MAP at 0 range 0 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_4_CPU_PRI_4_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_4_Register is record
      --  reg_core0_cpu_pri_4_map
      CPU_PRI_4_MAP : CPU_INT_PRI_4_CPU_PRI_4_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31 : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_4_Register use record
      CPU_PRI_4_MAP at 0 range 0 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_5_CPU_PRI_5_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_5_Register is record
      --  reg_core0_cpu_pri_5_map
      CPU_PRI_5_MAP : CPU_INT_PRI_5_CPU_PRI_5_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31 : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_5_Register use record
      CPU_PRI_5_MAP at 0 range 0 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_6_CPU_PRI_6_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_6_Register is record
      --  reg_core0_cpu_pri_6_map
      CPU_PRI_6_MAP : CPU_INT_PRI_6_CPU_PRI_6_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31 : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_6_Register use record
      CPU_PRI_6_MAP at 0 range 0 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_7_CPU_PRI_7_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_7_Register is record
      --  reg_core0_cpu_pri_7_map
      CPU_PRI_7_MAP : CPU_INT_PRI_7_CPU_PRI_7_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31 : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_7_Register use record
      CPU_PRI_7_MAP at 0 range 0 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_8_CPU_PRI_8_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_8_Register is record
      --  reg_core0_cpu_pri_8_map
      CPU_PRI_8_MAP : CPU_INT_PRI_8_CPU_PRI_8_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31 : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_8_Register use record
      CPU_PRI_8_MAP at 0 range 0 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_9_CPU_PRI_9_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_9_Register is record
      --  reg_core0_cpu_pri_9_map
      CPU_PRI_9_MAP : CPU_INT_PRI_9_CPU_PRI_9_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31 : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_9_Register use record
      CPU_PRI_9_MAP at 0 range 0 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_10_CPU_PRI_10_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_10_Register is record
      --  reg_core0_cpu_pri_10_map
      CPU_PRI_10_MAP : CPU_INT_PRI_10_CPU_PRI_10_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_10_Register use record
      CPU_PRI_10_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_11_CPU_PRI_11_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_11_Register is record
      --  reg_core0_cpu_pri_11_map
      CPU_PRI_11_MAP : CPU_INT_PRI_11_CPU_PRI_11_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_11_Register use record
      CPU_PRI_11_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_12_CPU_PRI_12_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_12_Register is record
      --  reg_core0_cpu_pri_12_map
      CPU_PRI_12_MAP : CPU_INT_PRI_12_CPU_PRI_12_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_12_Register use record
      CPU_PRI_12_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_13_CPU_PRI_13_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_13_Register is record
      --  reg_core0_cpu_pri_13_map
      CPU_PRI_13_MAP : CPU_INT_PRI_13_CPU_PRI_13_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_13_Register use record
      CPU_PRI_13_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_14_CPU_PRI_14_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_14_Register is record
      --  reg_core0_cpu_pri_14_map
      CPU_PRI_14_MAP : CPU_INT_PRI_14_CPU_PRI_14_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_14_Register use record
      CPU_PRI_14_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_15_CPU_PRI_15_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_15_Register is record
      --  reg_core0_cpu_pri_15_map
      CPU_PRI_15_MAP : CPU_INT_PRI_15_CPU_PRI_15_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_15_Register use record
      CPU_PRI_15_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_16_CPU_PRI_16_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_16_Register is record
      --  reg_core0_cpu_pri_16_map
      CPU_PRI_16_MAP : CPU_INT_PRI_16_CPU_PRI_16_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_16_Register use record
      CPU_PRI_16_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_17_CPU_PRI_17_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_17_Register is record
      --  reg_core0_cpu_pri_17_map
      CPU_PRI_17_MAP : CPU_INT_PRI_17_CPU_PRI_17_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_17_Register use record
      CPU_PRI_17_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_18_CPU_PRI_18_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_18_Register is record
      --  reg_core0_cpu_pri_18_map
      CPU_PRI_18_MAP : CPU_INT_PRI_18_CPU_PRI_18_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_18_Register use record
      CPU_PRI_18_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_19_CPU_PRI_19_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_19_Register is record
      --  reg_core0_cpu_pri_19_map
      CPU_PRI_19_MAP : CPU_INT_PRI_19_CPU_PRI_19_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_19_Register use record
      CPU_PRI_19_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_20_CPU_PRI_20_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_20_Register is record
      --  reg_core0_cpu_pri_20_map
      CPU_PRI_20_MAP : CPU_INT_PRI_20_CPU_PRI_20_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_20_Register use record
      CPU_PRI_20_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_21_CPU_PRI_21_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_21_Register is record
      --  reg_core0_cpu_pri_21_map
      CPU_PRI_21_MAP : CPU_INT_PRI_21_CPU_PRI_21_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_21_Register use record
      CPU_PRI_21_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_22_CPU_PRI_22_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_22_Register is record
      --  reg_core0_cpu_pri_22_map
      CPU_PRI_22_MAP : CPU_INT_PRI_22_CPU_PRI_22_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_22_Register use record
      CPU_PRI_22_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_23_CPU_PRI_23_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_23_Register is record
      --  reg_core0_cpu_pri_23_map
      CPU_PRI_23_MAP : CPU_INT_PRI_23_CPU_PRI_23_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_23_Register use record
      CPU_PRI_23_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_24_CPU_PRI_24_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_24_Register is record
      --  reg_core0_cpu_pri_24_map
      CPU_PRI_24_MAP : CPU_INT_PRI_24_CPU_PRI_24_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_24_Register use record
      CPU_PRI_24_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_25_CPU_PRI_25_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_25_Register is record
      --  reg_core0_cpu_pri_25_map
      CPU_PRI_25_MAP : CPU_INT_PRI_25_CPU_PRI_25_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_25_Register use record
      CPU_PRI_25_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_26_CPU_PRI_26_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_26_Register is record
      --  reg_core0_cpu_pri_26_map
      CPU_PRI_26_MAP : CPU_INT_PRI_26_CPU_PRI_26_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_26_Register use record
      CPU_PRI_26_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_27_CPU_PRI_27_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_27_Register is record
      --  reg_core0_cpu_pri_27_map
      CPU_PRI_27_MAP : CPU_INT_PRI_27_CPU_PRI_27_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_27_Register use record
      CPU_PRI_27_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_28_CPU_PRI_28_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_28_Register is record
      --  reg_core0_cpu_pri_28_map
      CPU_PRI_28_MAP : CPU_INT_PRI_28_CPU_PRI_28_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_28_Register use record
      CPU_PRI_28_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_29_CPU_PRI_29_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_29_Register is record
      --  reg_core0_cpu_pri_29_map
      CPU_PRI_29_MAP : CPU_INT_PRI_29_CPU_PRI_29_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_29_Register use record
      CPU_PRI_29_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_30_CPU_PRI_30_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_30_Register is record
      --  reg_core0_cpu_pri_30_map
      CPU_PRI_30_MAP : CPU_INT_PRI_30_CPU_PRI_30_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_30_Register use record
      CPU_PRI_30_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_PRI_31_CPU_PRI_31_MAP_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_PRI_31_Register is record
      --  reg_core0_cpu_pri_31_map
      CPU_PRI_31_MAP : CPU_INT_PRI_31_CPU_PRI_31_MAP_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_PRI_31_Register use record
      CPU_PRI_31_MAP at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype CPU_INT_THRESH_CPU_INT_THRESH_Field is ESP32_C3.UInt4;

   --  mac intr map register
   type CPU_INT_THRESH_Register is record
      --  reg_core0_cpu_int_thresh
      CPU_INT_THRESH : CPU_INT_THRESH_CPU_INT_THRESH_Field := 16#0#;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INT_THRESH_Register use record
      CPU_INT_THRESH at 0 range 0 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype INTERRUPT_REG_DATE_INTERRUPT_REG_DATE_Field is ESP32_C3.UInt28;

   --  mac intr map register
   type INTERRUPT_REG_DATE_Register is record
      --  reg_core0_interrupt_reg_date
      INTERRUPT_REG_DATE : INTERRUPT_REG_DATE_INTERRUPT_REG_DATE_Field :=
                            16#2007210#;
      --  unspecified
      Reserved_28_31     : ESP32_C3.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INTERRUPT_REG_DATE_Register use record
      INTERRUPT_REG_DATE at 0 range 0 .. 27;
      Reserved_28_31     at 0 range 28 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Interrupt Controller (Core 0)
   type INTERRUPT_CORE0_Peripheral is record
      --  mac intr map register
      MAC_INTR_MAP                                 : aliased MAC_INTR_MAP_Register;
      --  mac nmi_intr map register
      MAC_NMI_MAP                                  : aliased MAC_NMI_MAP_Register;
      --  pwr intr map register
      PWR_INTR_MAP                                 : aliased PWR_INTR_MAP_Register;
      --  bb intr map register
      BB_INT_MAP                                   : aliased BB_INT_MAP_Register;
      --  bt intr map register
      BT_MAC_INT_MAP                               : aliased BT_MAC_INT_MAP_Register;
      --  bb_bt intr map register
      BT_BB_INT_MAP                                : aliased BT_BB_INT_MAP_Register;
      --  bb_bt_nmi intr map register
      BT_BB_NMI_MAP                                : aliased BT_BB_NMI_MAP_Register;
      --  rwbt intr map register
      RWBT_IRQ_MAP                                 : aliased RWBT_IRQ_MAP_Register;
      --  rwble intr map register
      RWBLE_IRQ_MAP                                : aliased RWBLE_IRQ_MAP_Register;
      --  rwbt_nmi intr map register
      RWBT_NMI_MAP                                 : aliased RWBT_NMI_MAP_Register;
      --  rwble_nmi intr map register
      RWBLE_NMI_MAP                                : aliased RWBLE_NMI_MAP_Register;
      --  i2c intr map register
      I2C_MST_INT_MAP                              : aliased I2C_MST_INT_MAP_Register;
      --  slc0 intr map register
      SLC0_INTR_MAP                                : aliased SLC0_INTR_MAP_Register;
      --  slc1 intr map register
      SLC1_INTR_MAP                                : aliased SLC1_INTR_MAP_Register;
      --  apb_ctrl intr map register
      APB_CTRL_INTR_MAP                            : aliased APB_CTRL_INTR_MAP_Register;
      --  uchi0 intr map register
      UHCI0_INTR_MAP                               : aliased UHCI0_INTR_MAP_Register;
      --  gpio intr map register
      GPIO_INTERRUPT_PRO_MAP                       : aliased GPIO_INTERRUPT_PRO_MAP_Register;
      --  gpio_pro intr map register
      GPIO_INTERRUPT_PRO_NMI_MAP                   : aliased GPIO_INTERRUPT_PRO_NMI_MAP_Register;
      --  gpio_pro_nmi intr map register
      SPI_INTR_1_MAP                               : aliased SPI_INTR_1_MAP_Register;
      --  spi1 intr map register
      SPI_INTR_2_MAP                               : aliased SPI_INTR_2_MAP_Register;
      --  spi2 intr map register
      I2S1_INT_MAP                                 : aliased I2S1_INT_MAP_Register;
      --  i2s1 intr map register
      UART_INTR_MAP                                : aliased UART_INTR_MAP_Register;
      --  uart1 intr map register
      UART1_INTR_MAP                               : aliased UART1_INTR_MAP_Register;
      --  ledc intr map register
      LEDC_INT_MAP                                 : aliased LEDC_INT_MAP_Register;
      --  efuse intr map register
      EFUSE_INT_MAP                                : aliased EFUSE_INT_MAP_Register;
      --  can intr map register
      CAN_INT_MAP                                  : aliased CAN_INT_MAP_Register;
      --  usb intr map register
      USB_INTR_MAP                                 : aliased USB_INTR_MAP_Register;
      --  rtc intr map register
      RTC_CORE_INTR_MAP                            : aliased RTC_CORE_INTR_MAP_Register;
      --  rmt intr map register
      RMT_INTR_MAP                                 : aliased RMT_INTR_MAP_Register;
      --  i2c intr map register
      I2C_EXT0_INTR_MAP                            : aliased I2C_EXT0_INTR_MAP_Register;
      --  timer1 intr map register
      TIMER_INT1_MAP                               : aliased TIMER_INT1_MAP_Register;
      --  timer2 intr map register
      TIMER_INT2_MAP                               : aliased TIMER_INT2_MAP_Register;
      --  tg to intr map register
      TG_T0_INT_MAP                                : aliased TG_T0_INT_MAP_Register;
      --  tg wdt intr map register
      TG_WDT_INT_MAP                               : aliased TG_WDT_INT_MAP_Register;
      --  tg1 to intr map register
      TG1_T0_INT_MAP                               : aliased TG1_T0_INT_MAP_Register;
      --  tg1 wdt intr map register
      TG1_WDT_INT_MAP                              : aliased TG1_WDT_INT_MAP_Register;
      --  cache ia intr map register
      CACHE_IA_INT_MAP                             : aliased CACHE_IA_INT_MAP_Register;
      --  systimer intr map register
      SYSTIMER_TARGET0_INT_MAP                     : aliased SYSTIMER_TARGET0_INT_MAP_Register;
      --  systimer target1 intr map register
      SYSTIMER_TARGET1_INT_MAP                     : aliased SYSTIMER_TARGET1_INT_MAP_Register;
      --  systimer target2 intr map register
      SYSTIMER_TARGET2_INT_MAP                     : aliased SYSTIMER_TARGET2_INT_MAP_Register;
      --  spi mem reject intr map register
      SPI_MEM_REJECT_INTR_MAP                      : aliased SPI_MEM_REJECT_INTR_MAP_Register;
      --  icache perload intr map register
      ICACHE_PRELOAD_INT_MAP                       : aliased ICACHE_PRELOAD_INT_MAP_Register;
      --  icache sync intr map register
      ICACHE_SYNC_INT_MAP                          : aliased ICACHE_SYNC_INT_MAP_Register;
      --  adc intr map register
      APB_ADC_INT_MAP                              : aliased APB_ADC_INT_MAP_Register;
      --  dma ch0 intr map register
      DMA_CH0_INT_MAP                              : aliased DMA_CH0_INT_MAP_Register;
      --  dma ch1 intr map register
      DMA_CH1_INT_MAP                              : aliased DMA_CH1_INT_MAP_Register;
      --  dma ch2 intr map register
      DMA_CH2_INT_MAP                              : aliased DMA_CH2_INT_MAP_Register;
      --  rsa intr map register
      RSA_INT_MAP                                  : aliased RSA_INT_MAP_Register;
      --  aes intr map register
      AES_INT_MAP                                  : aliased AES_INT_MAP_Register;
      --  sha intr map register
      SHA_INT_MAP                                  : aliased SHA_INT_MAP_Register;
      --  cpu from cpu 0 intr map register
      CPU_INTR_FROM_CPU_0_MAP                      : aliased CPU_INTR_FROM_CPU_0_MAP_Register;
      --  cpu from cpu 0 intr map register
      CPU_INTR_FROM_CPU_1_MAP                      : aliased CPU_INTR_FROM_CPU_1_MAP_Register;
      --  cpu from cpu 1 intr map register
      CPU_INTR_FROM_CPU_2_MAP                      : aliased CPU_INTR_FROM_CPU_2_MAP_Register;
      --  cpu from cpu 3 intr map register
      CPU_INTR_FROM_CPU_3_MAP                      : aliased CPU_INTR_FROM_CPU_3_MAP_Register;
      --  assist debug intr map register
      ASSIST_DEBUG_INTR_MAP                        : aliased ASSIST_DEBUG_INTR_MAP_Register;
      --  dma pms violatile intr map register
      DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_MAP     : aliased DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_MAP_Register;
      --  iram0 pms violatile intr map register
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_MAP    : aliased CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_MAP_Register;
      --  mac intr map register
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_MAP    : aliased CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_MAP_Register;
      --  mac intr map register
      CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_MAP      : aliased CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_MAP_Register;
      --  mac intr map register
      CORE_0_PIF_PMS_MONITOR_VIOLATE_SIZE_INTR_MAP : aliased CORE_0_PIF_PMS_MONITOR_VIOLATE_SIZE_INTR_MAP_Register;
      --  mac intr map register
      BACKUP_PMS_VIOLATE_INTR_MAP                  : aliased BACKUP_PMS_VIOLATE_INTR_MAP_Register;
      --  mac intr map register
      CACHE_CORE0_ACS_INT_MAP                      : aliased CACHE_CORE0_ACS_INT_MAP_Register;
      --  mac intr map register
      INTR_STATUS_REG_0                            : aliased ESP32_C3.UInt32;
      --  mac intr map register
      INTR_STATUS_REG_1                            : aliased ESP32_C3.UInt32;
      --  mac intr map register
      CLOCK_GATE                                   : aliased CLOCK_GATE_Register;
      --  mac intr map register
      CPU_INT_ENABLE                               : aliased ESP32_C3.UInt32;
      --  mac intr map register
      CPU_INT_TYPE                                 : aliased ESP32_C3.UInt32;
      --  mac intr map register
      CPU_INT_CLEAR                                : aliased ESP32_C3.UInt32;
      --  mac intr map register
      CPU_INT_EIP_STATUS                           : aliased ESP32_C3.UInt32;
      --  mac intr map register
      CPU_INT_PRI_0                                : aliased CPU_INT_PRI_0_Register;
      --  mac intr map register
      CPU_INT_PRI_1                                : aliased CPU_INT_PRI_1_Register;
      --  mac intr map register
      CPU_INT_PRI_2                                : aliased CPU_INT_PRI_2_Register;
      --  mac intr map register
      CPU_INT_PRI_3                                : aliased CPU_INT_PRI_3_Register;
      --  mac intr map register
      CPU_INT_PRI_4                                : aliased CPU_INT_PRI_4_Register;
      --  mac intr map register
      CPU_INT_PRI_5                                : aliased CPU_INT_PRI_5_Register;
      --  mac intr map register
      CPU_INT_PRI_6                                : aliased CPU_INT_PRI_6_Register;
      --  mac intr map register
      CPU_INT_PRI_7                                : aliased CPU_INT_PRI_7_Register;
      --  mac intr map register
      CPU_INT_PRI_8                                : aliased CPU_INT_PRI_8_Register;
      --  mac intr map register
      CPU_INT_PRI_9                                : aliased CPU_INT_PRI_9_Register;
      --  mac intr map register
      CPU_INT_PRI_10                               : aliased CPU_INT_PRI_10_Register;
      --  mac intr map register
      CPU_INT_PRI_11                               : aliased CPU_INT_PRI_11_Register;
      --  mac intr map register
      CPU_INT_PRI_12                               : aliased CPU_INT_PRI_12_Register;
      --  mac intr map register
      CPU_INT_PRI_13                               : aliased CPU_INT_PRI_13_Register;
      --  mac intr map register
      CPU_INT_PRI_14                               : aliased CPU_INT_PRI_14_Register;
      --  mac intr map register
      CPU_INT_PRI_15                               : aliased CPU_INT_PRI_15_Register;
      --  mac intr map register
      CPU_INT_PRI_16                               : aliased CPU_INT_PRI_16_Register;
      --  mac intr map register
      CPU_INT_PRI_17                               : aliased CPU_INT_PRI_17_Register;
      --  mac intr map register
      CPU_INT_PRI_18                               : aliased CPU_INT_PRI_18_Register;
      --  mac intr map register
      CPU_INT_PRI_19                               : aliased CPU_INT_PRI_19_Register;
      --  mac intr map register
      CPU_INT_PRI_20                               : aliased CPU_INT_PRI_20_Register;
      --  mac intr map register
      CPU_INT_PRI_21                               : aliased CPU_INT_PRI_21_Register;
      --  mac intr map register
      CPU_INT_PRI_22                               : aliased CPU_INT_PRI_22_Register;
      --  mac intr map register
      CPU_INT_PRI_23                               : aliased CPU_INT_PRI_23_Register;
      --  mac intr map register
      CPU_INT_PRI_24                               : aliased CPU_INT_PRI_24_Register;
      --  mac intr map register
      CPU_INT_PRI_25                               : aliased CPU_INT_PRI_25_Register;
      --  mac intr map register
      CPU_INT_PRI_26                               : aliased CPU_INT_PRI_26_Register;
      --  mac intr map register
      CPU_INT_PRI_27                               : aliased CPU_INT_PRI_27_Register;
      --  mac intr map register
      CPU_INT_PRI_28                               : aliased CPU_INT_PRI_28_Register;
      --  mac intr map register
      CPU_INT_PRI_29                               : aliased CPU_INT_PRI_29_Register;
      --  mac intr map register
      CPU_INT_PRI_30                               : aliased CPU_INT_PRI_30_Register;
      --  mac intr map register
      CPU_INT_PRI_31                               : aliased CPU_INT_PRI_31_Register;
      --  mac intr map register
      CPU_INT_THRESH                               : aliased CPU_INT_THRESH_Register;
      --  mac intr map register
      INTERRUPT_REG_DATE                           : aliased INTERRUPT_REG_DATE_Register;
   end record
     with Volatile;

   for INTERRUPT_CORE0_Peripheral use record
      MAC_INTR_MAP                                 at 16#0# range 0 .. 31;
      MAC_NMI_MAP                                  at 16#4# range 0 .. 31;
      PWR_INTR_MAP                                 at 16#8# range 0 .. 31;
      BB_INT_MAP                                   at 16#C# range 0 .. 31;
      BT_MAC_INT_MAP                               at 16#10# range 0 .. 31;
      BT_BB_INT_MAP                                at 16#14# range 0 .. 31;
      BT_BB_NMI_MAP                                at 16#18# range 0 .. 31;
      RWBT_IRQ_MAP                                 at 16#1C# range 0 .. 31;
      RWBLE_IRQ_MAP                                at 16#20# range 0 .. 31;
      RWBT_NMI_MAP                                 at 16#24# range 0 .. 31;
      RWBLE_NMI_MAP                                at 16#28# range 0 .. 31;
      I2C_MST_INT_MAP                              at 16#2C# range 0 .. 31;
      SLC0_INTR_MAP                                at 16#30# range 0 .. 31;
      SLC1_INTR_MAP                                at 16#34# range 0 .. 31;
      APB_CTRL_INTR_MAP                            at 16#38# range 0 .. 31;
      UHCI0_INTR_MAP                               at 16#3C# range 0 .. 31;
      GPIO_INTERRUPT_PRO_MAP                       at 16#40# range 0 .. 31;
      GPIO_INTERRUPT_PRO_NMI_MAP                   at 16#44# range 0 .. 31;
      SPI_INTR_1_MAP                               at 16#48# range 0 .. 31;
      SPI_INTR_2_MAP                               at 16#4C# range 0 .. 31;
      I2S1_INT_MAP                                 at 16#50# range 0 .. 31;
      UART_INTR_MAP                                at 16#54# range 0 .. 31;
      UART1_INTR_MAP                               at 16#58# range 0 .. 31;
      LEDC_INT_MAP                                 at 16#5C# range 0 .. 31;
      EFUSE_INT_MAP                                at 16#60# range 0 .. 31;
      CAN_INT_MAP                                  at 16#64# range 0 .. 31;
      USB_INTR_MAP                                 at 16#68# range 0 .. 31;
      RTC_CORE_INTR_MAP                            at 16#6C# range 0 .. 31;
      RMT_INTR_MAP                                 at 16#70# range 0 .. 31;
      I2C_EXT0_INTR_MAP                            at 16#74# range 0 .. 31;
      TIMER_INT1_MAP                               at 16#78# range 0 .. 31;
      TIMER_INT2_MAP                               at 16#7C# range 0 .. 31;
      TG_T0_INT_MAP                                at 16#80# range 0 .. 31;
      TG_WDT_INT_MAP                               at 16#84# range 0 .. 31;
      TG1_T0_INT_MAP                               at 16#88# range 0 .. 31;
      TG1_WDT_INT_MAP                              at 16#8C# range 0 .. 31;
      CACHE_IA_INT_MAP                             at 16#90# range 0 .. 31;
      SYSTIMER_TARGET0_INT_MAP                     at 16#94# range 0 .. 31;
      SYSTIMER_TARGET1_INT_MAP                     at 16#98# range 0 .. 31;
      SYSTIMER_TARGET2_INT_MAP                     at 16#9C# range 0 .. 31;
      SPI_MEM_REJECT_INTR_MAP                      at 16#A0# range 0 .. 31;
      ICACHE_PRELOAD_INT_MAP                       at 16#A4# range 0 .. 31;
      ICACHE_SYNC_INT_MAP                          at 16#A8# range 0 .. 31;
      APB_ADC_INT_MAP                              at 16#AC# range 0 .. 31;
      DMA_CH0_INT_MAP                              at 16#B0# range 0 .. 31;
      DMA_CH1_INT_MAP                              at 16#B4# range 0 .. 31;
      DMA_CH2_INT_MAP                              at 16#B8# range 0 .. 31;
      RSA_INT_MAP                                  at 16#BC# range 0 .. 31;
      AES_INT_MAP                                  at 16#C0# range 0 .. 31;
      SHA_INT_MAP                                  at 16#C4# range 0 .. 31;
      CPU_INTR_FROM_CPU_0_MAP                      at 16#C8# range 0 .. 31;
      CPU_INTR_FROM_CPU_1_MAP                      at 16#CC# range 0 .. 31;
      CPU_INTR_FROM_CPU_2_MAP                      at 16#D0# range 0 .. 31;
      CPU_INTR_FROM_CPU_3_MAP                      at 16#D4# range 0 .. 31;
      ASSIST_DEBUG_INTR_MAP                        at 16#D8# range 0 .. 31;
      DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_MAP     at 16#DC# range 0 .. 31;
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_MAP    at 16#E0# range 0 .. 31;
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_MAP    at 16#E4# range 0 .. 31;
      CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_MAP      at 16#E8# range 0 .. 31;
      CORE_0_PIF_PMS_MONITOR_VIOLATE_SIZE_INTR_MAP at 16#EC# range 0 .. 31;
      BACKUP_PMS_VIOLATE_INTR_MAP                  at 16#F0# range 0 .. 31;
      CACHE_CORE0_ACS_INT_MAP                      at 16#F4# range 0 .. 31;
      INTR_STATUS_REG_0                            at 16#F8# range 0 .. 31;
      INTR_STATUS_REG_1                            at 16#FC# range 0 .. 31;
      CLOCK_GATE                                   at 16#100# range 0 .. 31;
      CPU_INT_ENABLE                               at 16#104# range 0 .. 31;
      CPU_INT_TYPE                                 at 16#108# range 0 .. 31;
      CPU_INT_CLEAR                                at 16#10C# range 0 .. 31;
      CPU_INT_EIP_STATUS                           at 16#110# range 0 .. 31;
      CPU_INT_PRI_0                                at 16#114# range 0 .. 31;
      CPU_INT_PRI_1                                at 16#118# range 0 .. 31;
      CPU_INT_PRI_2                                at 16#11C# range 0 .. 31;
      CPU_INT_PRI_3                                at 16#120# range 0 .. 31;
      CPU_INT_PRI_4                                at 16#124# range 0 .. 31;
      CPU_INT_PRI_5                                at 16#128# range 0 .. 31;
      CPU_INT_PRI_6                                at 16#12C# range 0 .. 31;
      CPU_INT_PRI_7                                at 16#130# range 0 .. 31;
      CPU_INT_PRI_8                                at 16#134# range 0 .. 31;
      CPU_INT_PRI_9                                at 16#138# range 0 .. 31;
      CPU_INT_PRI_10                               at 16#13C# range 0 .. 31;
      CPU_INT_PRI_11                               at 16#140# range 0 .. 31;
      CPU_INT_PRI_12                               at 16#144# range 0 .. 31;
      CPU_INT_PRI_13                               at 16#148# range 0 .. 31;
      CPU_INT_PRI_14                               at 16#14C# range 0 .. 31;
      CPU_INT_PRI_15                               at 16#150# range 0 .. 31;
      CPU_INT_PRI_16                               at 16#154# range 0 .. 31;
      CPU_INT_PRI_17                               at 16#158# range 0 .. 31;
      CPU_INT_PRI_18                               at 16#15C# range 0 .. 31;
      CPU_INT_PRI_19                               at 16#160# range 0 .. 31;
      CPU_INT_PRI_20                               at 16#164# range 0 .. 31;
      CPU_INT_PRI_21                               at 16#168# range 0 .. 31;
      CPU_INT_PRI_22                               at 16#16C# range 0 .. 31;
      CPU_INT_PRI_23                               at 16#170# range 0 .. 31;
      CPU_INT_PRI_24                               at 16#174# range 0 .. 31;
      CPU_INT_PRI_25                               at 16#178# range 0 .. 31;
      CPU_INT_PRI_26                               at 16#17C# range 0 .. 31;
      CPU_INT_PRI_27                               at 16#180# range 0 .. 31;
      CPU_INT_PRI_28                               at 16#184# range 0 .. 31;
      CPU_INT_PRI_29                               at 16#188# range 0 .. 31;
      CPU_INT_PRI_30                               at 16#18C# range 0 .. 31;
      CPU_INT_PRI_31                               at 16#190# range 0 .. 31;
      CPU_INT_THRESH                               at 16#194# range 0 .. 31;
      INTERRUPT_REG_DATE                           at 16#7FC# range 0 .. 31;
   end record;

   --  Interrupt Controller (Core 0)
   INTERRUPT_CORE0_Periph : aliased INTERRUPT_CORE0_Peripheral
     with Import, Address => INTERRUPT_CORE0_Base;

end ESP32_C3.INTERRUPT_CORE0;
