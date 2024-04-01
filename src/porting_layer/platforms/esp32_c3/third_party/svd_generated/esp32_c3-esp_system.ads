pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.ESP_SYSTEM is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype CPU_PERI_CLK_EN_CLK_EN_ASSIST_DEBUG_Field is ESP32_C3.Bit;
   subtype CPU_PERI_CLK_EN_CLK_EN_DEDICATED_GPIO_Field is ESP32_C3.Bit;

   --  cpu_peripheral clock gating register
   type CPU_PERI_CLK_EN_Register is record
      --  unspecified
      Reserved_0_5          : ESP32_C3.UInt6 := 16#0#;
      --  reg_clk_en_assist_debug
      CLK_EN_ASSIST_DEBUG   : CPU_PERI_CLK_EN_CLK_EN_ASSIST_DEBUG_Field :=
                               16#0#;
      --  reg_clk_en_dedicated_gpio
      CLK_EN_DEDICATED_GPIO : CPU_PERI_CLK_EN_CLK_EN_DEDICATED_GPIO_Field :=
                               16#0#;
      --  unspecified
      Reserved_8_31         : ESP32_C3.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_PERI_CLK_EN_Register use record
      Reserved_0_5          at 0 range 0 .. 5;
      CLK_EN_ASSIST_DEBUG   at 0 range 6 .. 6;
      CLK_EN_DEDICATED_GPIO at 0 range 7 .. 7;
      Reserved_8_31         at 0 range 8 .. 31;
   end record;

   subtype CPU_PERI_RST_EN_RST_EN_ASSIST_DEBUG_Field is ESP32_C3.Bit;
   subtype CPU_PERI_RST_EN_RST_EN_DEDICATED_GPIO_Field is ESP32_C3.Bit;

   --  cpu_peripheral reset register
   type CPU_PERI_RST_EN_Register is record
      --  unspecified
      Reserved_0_5          : ESP32_C3.UInt6 := 16#0#;
      --  reg_rst_en_assist_debug
      RST_EN_ASSIST_DEBUG   : CPU_PERI_RST_EN_RST_EN_ASSIST_DEBUG_Field :=
                               16#1#;
      --  reg_rst_en_dedicated_gpio
      RST_EN_DEDICATED_GPIO : CPU_PERI_RST_EN_RST_EN_DEDICATED_GPIO_Field :=
                               16#1#;
      --  unspecified
      Reserved_8_31         : ESP32_C3.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_PERI_RST_EN_Register use record
      Reserved_0_5          at 0 range 0 .. 5;
      RST_EN_ASSIST_DEBUG   at 0 range 6 .. 6;
      RST_EN_DEDICATED_GPIO at 0 range 7 .. 7;
      Reserved_8_31         at 0 range 8 .. 31;
   end record;

   subtype CPU_PER_CONF_CPUPERIOD_SEL_Field is ESP32_C3.UInt2;
   subtype CPU_PER_CONF_PLL_FREQ_SEL_Field is ESP32_C3.Bit;
   subtype CPU_PER_CONF_CPU_WAIT_MODE_FORCE_ON_Field is ESP32_C3.Bit;
   subtype CPU_PER_CONF_CPU_WAITI_DELAY_NUM_Field is ESP32_C3.UInt4;

   --  cpu clock config register
   type CPU_PER_CONF_Register is record
      --  reg_cpuperiod_sel
      CPUPERIOD_SEL          : CPU_PER_CONF_CPUPERIOD_SEL_Field := 16#0#;
      --  reg_pll_freq_sel
      PLL_FREQ_SEL           : CPU_PER_CONF_PLL_FREQ_SEL_Field := 16#1#;
      --  reg_cpu_wait_mode_force_on
      CPU_WAIT_MODE_FORCE_ON : CPU_PER_CONF_CPU_WAIT_MODE_FORCE_ON_Field :=
                                16#1#;
      --  reg_cpu_waiti_delay_num
      CPU_WAITI_DELAY_NUM    : CPU_PER_CONF_CPU_WAITI_DELAY_NUM_Field :=
                                16#0#;
      --  unspecified
      Reserved_8_31          : ESP32_C3.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_PER_CONF_Register use record
      CPUPERIOD_SEL          at 0 range 0 .. 1;
      PLL_FREQ_SEL           at 0 range 2 .. 2;
      CPU_WAIT_MODE_FORCE_ON at 0 range 3 .. 3;
      CPU_WAITI_DELAY_NUM    at 0 range 4 .. 7;
      Reserved_8_31          at 0 range 8 .. 31;
   end record;

   subtype MEM_PD_MASK_LSLP_MEM_PD_MASK_Field is ESP32_C3.Bit;

   --  memory power down mask register
   type MEM_PD_MASK_Register is record
      --  reg_lslp_mem_pd_mask
      LSLP_MEM_PD_MASK : MEM_PD_MASK_LSLP_MEM_PD_MASK_Field := 16#1#;
      --  unspecified
      Reserved_1_31    : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for MEM_PD_MASK_Register use record
      LSLP_MEM_PD_MASK at 0 range 0 .. 0;
      Reserved_1_31    at 0 range 1 .. 31;
   end record;

   subtype PERIP_CLK_EN0_TIMERS_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_SPI01_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_UART_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_WDG_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_I2S0_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_UART1_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_SPI2_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_I2C_EXT0_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_UHCI0_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_RMT_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_PCNT_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_LEDC_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_UHCI1_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_TIMERGROUP_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_EFUSE_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_TIMERGROUP1_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_SPI3_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_PWM0_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_EXT1_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_TWAI_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_PWM1_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_I2S1_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_SPI2_DMA_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_USB_DEVICE_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_UART_MEM_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_PWM2_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_PWM3_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_SPI3_DMA_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_APB_SARADC_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_SYSTIMER_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_ADC2_ARB_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN0_SPI4_CLK_EN_Field is ESP32_C3.Bit;

   --  peripheral clock gating register
   type PERIP_CLK_EN0_Register is record
      --  reg_timers_clk_en
      TIMERS_CLK_EN      : PERIP_CLK_EN0_TIMERS_CLK_EN_Field := 16#1#;
      --  reg_spi01_clk_en
      SPI01_CLK_EN       : PERIP_CLK_EN0_SPI01_CLK_EN_Field := 16#1#;
      --  reg_uart_clk_en
      UART_CLK_EN        : PERIP_CLK_EN0_UART_CLK_EN_Field := 16#1#;
      --  reg_wdg_clk_en
      WDG_CLK_EN         : PERIP_CLK_EN0_WDG_CLK_EN_Field := 16#1#;
      --  reg_i2s0_clk_en
      I2S0_CLK_EN        : PERIP_CLK_EN0_I2S0_CLK_EN_Field := 16#0#;
      --  reg_uart1_clk_en
      UART1_CLK_EN       : PERIP_CLK_EN0_UART1_CLK_EN_Field := 16#1#;
      --  reg_spi2_clk_en
      SPI2_CLK_EN        : PERIP_CLK_EN0_SPI2_CLK_EN_Field := 16#1#;
      --  reg_ext0_clk_en
      I2C_EXT0_CLK_EN    : PERIP_CLK_EN0_I2C_EXT0_CLK_EN_Field := 16#0#;
      --  reg_uhci0_clk_en
      UHCI0_CLK_EN       : PERIP_CLK_EN0_UHCI0_CLK_EN_Field := 16#0#;
      --  reg_rmt_clk_en
      RMT_CLK_EN         : PERIP_CLK_EN0_RMT_CLK_EN_Field := 16#0#;
      --  reg_pcnt_clk_en
      PCNT_CLK_EN        : PERIP_CLK_EN0_PCNT_CLK_EN_Field := 16#0#;
      --  reg_ledc_clk_en
      LEDC_CLK_EN        : PERIP_CLK_EN0_LEDC_CLK_EN_Field := 16#0#;
      --  reg_uhci1_clk_en
      UHCI1_CLK_EN       : PERIP_CLK_EN0_UHCI1_CLK_EN_Field := 16#0#;
      --  reg_timergroup_clk_en
      TIMERGROUP_CLK_EN  : PERIP_CLK_EN0_TIMERGROUP_CLK_EN_Field := 16#1#;
      --  reg_efuse_clk_en
      EFUSE_CLK_EN       : PERIP_CLK_EN0_EFUSE_CLK_EN_Field := 16#1#;
      --  reg_timergroup1_clk_en
      TIMERGROUP1_CLK_EN : PERIP_CLK_EN0_TIMERGROUP1_CLK_EN_Field := 16#1#;
      --  reg_spi3_clk_en
      SPI3_CLK_EN        : PERIP_CLK_EN0_SPI3_CLK_EN_Field := 16#1#;
      --  reg_pwm0_clk_en
      PWM0_CLK_EN        : PERIP_CLK_EN0_PWM0_CLK_EN_Field := 16#0#;
      --  reg_ext1_clk_en
      EXT1_CLK_EN        : PERIP_CLK_EN0_EXT1_CLK_EN_Field := 16#0#;
      --  reg_can_clk_en
      TWAI_CLK_EN        : PERIP_CLK_EN0_TWAI_CLK_EN_Field := 16#0#;
      --  reg_pwm1_clk_en
      PWM1_CLK_EN        : PERIP_CLK_EN0_PWM1_CLK_EN_Field := 16#0#;
      --  reg_i2s1_clk_en
      I2S1_CLK_EN        : PERIP_CLK_EN0_I2S1_CLK_EN_Field := 16#0#;
      --  reg_spi2_dma_clk_en
      SPI2_DMA_CLK_EN    : PERIP_CLK_EN0_SPI2_DMA_CLK_EN_Field := 16#1#;
      --  reg_usb_device_clk_en
      USB_DEVICE_CLK_EN  : PERIP_CLK_EN0_USB_DEVICE_CLK_EN_Field := 16#1#;
      --  reg_uart_mem_clk_en
      UART_MEM_CLK_EN    : PERIP_CLK_EN0_UART_MEM_CLK_EN_Field := 16#1#;
      --  reg_pwm2_clk_en
      PWM2_CLK_EN        : PERIP_CLK_EN0_PWM2_CLK_EN_Field := 16#0#;
      --  reg_pwm3_clk_en
      PWM3_CLK_EN        : PERIP_CLK_EN0_PWM3_CLK_EN_Field := 16#0#;
      --  reg_spi3_dma_clk_en
      SPI3_DMA_CLK_EN    : PERIP_CLK_EN0_SPI3_DMA_CLK_EN_Field := 16#1#;
      --  reg_apb_saradc_clk_en
      APB_SARADC_CLK_EN  : PERIP_CLK_EN0_APB_SARADC_CLK_EN_Field := 16#1#;
      --  reg_systimer_clk_en
      SYSTIMER_CLK_EN    : PERIP_CLK_EN0_SYSTIMER_CLK_EN_Field := 16#1#;
      --  reg_adc2_arb_clk_en
      ADC2_ARB_CLK_EN    : PERIP_CLK_EN0_ADC2_ARB_CLK_EN_Field := 16#1#;
      --  reg_spi4_clk_en
      SPI4_CLK_EN        : PERIP_CLK_EN0_SPI4_CLK_EN_Field := 16#1#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PERIP_CLK_EN0_Register use record
      TIMERS_CLK_EN      at 0 range 0 .. 0;
      SPI01_CLK_EN       at 0 range 1 .. 1;
      UART_CLK_EN        at 0 range 2 .. 2;
      WDG_CLK_EN         at 0 range 3 .. 3;
      I2S0_CLK_EN        at 0 range 4 .. 4;
      UART1_CLK_EN       at 0 range 5 .. 5;
      SPI2_CLK_EN        at 0 range 6 .. 6;
      I2C_EXT0_CLK_EN    at 0 range 7 .. 7;
      UHCI0_CLK_EN       at 0 range 8 .. 8;
      RMT_CLK_EN         at 0 range 9 .. 9;
      PCNT_CLK_EN        at 0 range 10 .. 10;
      LEDC_CLK_EN        at 0 range 11 .. 11;
      UHCI1_CLK_EN       at 0 range 12 .. 12;
      TIMERGROUP_CLK_EN  at 0 range 13 .. 13;
      EFUSE_CLK_EN       at 0 range 14 .. 14;
      TIMERGROUP1_CLK_EN at 0 range 15 .. 15;
      SPI3_CLK_EN        at 0 range 16 .. 16;
      PWM0_CLK_EN        at 0 range 17 .. 17;
      EXT1_CLK_EN        at 0 range 18 .. 18;
      TWAI_CLK_EN        at 0 range 19 .. 19;
      PWM1_CLK_EN        at 0 range 20 .. 20;
      I2S1_CLK_EN        at 0 range 21 .. 21;
      SPI2_DMA_CLK_EN    at 0 range 22 .. 22;
      USB_DEVICE_CLK_EN  at 0 range 23 .. 23;
      UART_MEM_CLK_EN    at 0 range 24 .. 24;
      PWM2_CLK_EN        at 0 range 25 .. 25;
      PWM3_CLK_EN        at 0 range 26 .. 26;
      SPI3_DMA_CLK_EN    at 0 range 27 .. 27;
      APB_SARADC_CLK_EN  at 0 range 28 .. 28;
      SYSTIMER_CLK_EN    at 0 range 29 .. 29;
      ADC2_ARB_CLK_EN    at 0 range 30 .. 30;
      SPI4_CLK_EN        at 0 range 31 .. 31;
   end record;

   subtype PERIP_CLK_EN1_CRYPTO_AES_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN1_CRYPTO_SHA_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN1_CRYPTO_RSA_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN1_CRYPTO_DS_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN1_CRYPTO_HMAC_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN1_DMA_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN1_SDIO_HOST_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN1_LCD_CAM_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN1_UART2_CLK_EN_Field is ESP32_C3.Bit;
   subtype PERIP_CLK_EN1_TSENS_CLK_EN_Field is ESP32_C3.Bit;

   --  peripheral clock gating register
   type PERIP_CLK_EN1_Register is record
      --  unspecified
      Reserved_0_0       : ESP32_C3.Bit := 16#0#;
      --  reg_crypto_aes_clk_en
      CRYPTO_AES_CLK_EN  : PERIP_CLK_EN1_CRYPTO_AES_CLK_EN_Field := 16#0#;
      --  reg_crypto_sha_clk_en
      CRYPTO_SHA_CLK_EN  : PERIP_CLK_EN1_CRYPTO_SHA_CLK_EN_Field := 16#0#;
      --  reg_crypto_rsa_clk_en
      CRYPTO_RSA_CLK_EN  : PERIP_CLK_EN1_CRYPTO_RSA_CLK_EN_Field := 16#0#;
      --  reg_crypto_ds_clk_en
      CRYPTO_DS_CLK_EN   : PERIP_CLK_EN1_CRYPTO_DS_CLK_EN_Field := 16#0#;
      --  reg_crypto_hmac_clk_en
      CRYPTO_HMAC_CLK_EN : PERIP_CLK_EN1_CRYPTO_HMAC_CLK_EN_Field := 16#0#;
      --  reg_dma_clk_en
      DMA_CLK_EN         : PERIP_CLK_EN1_DMA_CLK_EN_Field := 16#0#;
      --  reg_sdio_host_clk_en
      SDIO_HOST_CLK_EN   : PERIP_CLK_EN1_SDIO_HOST_CLK_EN_Field := 16#0#;
      --  reg_lcd_cam_clk_en
      LCD_CAM_CLK_EN     : PERIP_CLK_EN1_LCD_CAM_CLK_EN_Field := 16#0#;
      --  reg_uart2_clk_en
      UART2_CLK_EN       : PERIP_CLK_EN1_UART2_CLK_EN_Field := 16#1#;
      --  reg_tsens_clk_en
      TSENS_CLK_EN       : PERIP_CLK_EN1_TSENS_CLK_EN_Field := 16#0#;
      --  unspecified
      Reserved_11_31     : ESP32_C3.UInt21 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PERIP_CLK_EN1_Register use record
      Reserved_0_0       at 0 range 0 .. 0;
      CRYPTO_AES_CLK_EN  at 0 range 1 .. 1;
      CRYPTO_SHA_CLK_EN  at 0 range 2 .. 2;
      CRYPTO_RSA_CLK_EN  at 0 range 3 .. 3;
      CRYPTO_DS_CLK_EN   at 0 range 4 .. 4;
      CRYPTO_HMAC_CLK_EN at 0 range 5 .. 5;
      DMA_CLK_EN         at 0 range 6 .. 6;
      SDIO_HOST_CLK_EN   at 0 range 7 .. 7;
      LCD_CAM_CLK_EN     at 0 range 8 .. 8;
      UART2_CLK_EN       at 0 range 9 .. 9;
      TSENS_CLK_EN       at 0 range 10 .. 10;
      Reserved_11_31     at 0 range 11 .. 31;
   end record;

   subtype PERIP_RST_EN0_TIMERS_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_SPI01_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_UART_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_WDG_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_I2S0_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_UART1_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_SPI2_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_I2C_EXT0_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_UHCI0_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_RMT_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_PCNT_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_LEDC_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_UHCI1_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_TIMERGROUP_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_EFUSE_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_TIMERGROUP1_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_SPI3_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_PWM0_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_EXT1_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_TWAI_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_PWM1_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_I2S1_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_SPI2_DMA_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_USB_DEVICE_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_UART_MEM_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_PWM2_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_PWM3_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_SPI3_DMA_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_APB_SARADC_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_SYSTIMER_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_ADC2_ARB_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN0_SPI4_RST_Field is ESP32_C3.Bit;

   --  reserved
   type PERIP_RST_EN0_Register is record
      --  reg_timers_rst
      TIMERS_RST      : PERIP_RST_EN0_TIMERS_RST_Field := 16#0#;
      --  reg_spi01_rst
      SPI01_RST       : PERIP_RST_EN0_SPI01_RST_Field := 16#0#;
      --  reg_uart_rst
      UART_RST        : PERIP_RST_EN0_UART_RST_Field := 16#0#;
      --  reg_wdg_rst
      WDG_RST         : PERIP_RST_EN0_WDG_RST_Field := 16#0#;
      --  reg_i2s0_rst
      I2S0_RST        : PERIP_RST_EN0_I2S0_RST_Field := 16#0#;
      --  reg_uart1_rst
      UART1_RST       : PERIP_RST_EN0_UART1_RST_Field := 16#0#;
      --  reg_spi2_rst
      SPI2_RST        : PERIP_RST_EN0_SPI2_RST_Field := 16#0#;
      --  reg_ext0_rst
      I2C_EXT0_RST    : PERIP_RST_EN0_I2C_EXT0_RST_Field := 16#0#;
      --  reg_uhci0_rst
      UHCI0_RST       : PERIP_RST_EN0_UHCI0_RST_Field := 16#0#;
      --  reg_rmt_rst
      RMT_RST         : PERIP_RST_EN0_RMT_RST_Field := 16#0#;
      --  reg_pcnt_rst
      PCNT_RST        : PERIP_RST_EN0_PCNT_RST_Field := 16#0#;
      --  reg_ledc_rst
      LEDC_RST        : PERIP_RST_EN0_LEDC_RST_Field := 16#0#;
      --  reg_uhci1_rst
      UHCI1_RST       : PERIP_RST_EN0_UHCI1_RST_Field := 16#0#;
      --  reg_timergroup_rst
      TIMERGROUP_RST  : PERIP_RST_EN0_TIMERGROUP_RST_Field := 16#0#;
      --  reg_efuse_rst
      EFUSE_RST       : PERIP_RST_EN0_EFUSE_RST_Field := 16#0#;
      --  reg_timergroup1_rst
      TIMERGROUP1_RST : PERIP_RST_EN0_TIMERGROUP1_RST_Field := 16#0#;
      --  reg_spi3_rst
      SPI3_RST        : PERIP_RST_EN0_SPI3_RST_Field := 16#0#;
      --  reg_pwm0_rst
      PWM0_RST        : PERIP_RST_EN0_PWM0_RST_Field := 16#0#;
      --  reg_ext1_rst
      EXT1_RST        : PERIP_RST_EN0_EXT1_RST_Field := 16#0#;
      --  reg_can_rst
      TWAI_RST        : PERIP_RST_EN0_TWAI_RST_Field := 16#0#;
      --  reg_pwm1_rst
      PWM1_RST        : PERIP_RST_EN0_PWM1_RST_Field := 16#0#;
      --  reg_i2s1_rst
      I2S1_RST        : PERIP_RST_EN0_I2S1_RST_Field := 16#0#;
      --  reg_spi2_dma_rst
      SPI2_DMA_RST    : PERIP_RST_EN0_SPI2_DMA_RST_Field := 16#0#;
      --  reg_usb_device_rst
      USB_DEVICE_RST  : PERIP_RST_EN0_USB_DEVICE_RST_Field := 16#0#;
      --  reg_uart_mem_rst
      UART_MEM_RST    : PERIP_RST_EN0_UART_MEM_RST_Field := 16#0#;
      --  reg_pwm2_rst
      PWM2_RST        : PERIP_RST_EN0_PWM2_RST_Field := 16#0#;
      --  reg_pwm3_rst
      PWM3_RST        : PERIP_RST_EN0_PWM3_RST_Field := 16#0#;
      --  reg_spi3_dma_rst
      SPI3_DMA_RST    : PERIP_RST_EN0_SPI3_DMA_RST_Field := 16#0#;
      --  reg_apb_saradc_rst
      APB_SARADC_RST  : PERIP_RST_EN0_APB_SARADC_RST_Field := 16#0#;
      --  reg_systimer_rst
      SYSTIMER_RST    : PERIP_RST_EN0_SYSTIMER_RST_Field := 16#0#;
      --  reg_adc2_arb_rst
      ADC2_ARB_RST    : PERIP_RST_EN0_ADC2_ARB_RST_Field := 16#0#;
      --  reg_spi4_rst
      SPI4_RST        : PERIP_RST_EN0_SPI4_RST_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PERIP_RST_EN0_Register use record
      TIMERS_RST      at 0 range 0 .. 0;
      SPI01_RST       at 0 range 1 .. 1;
      UART_RST        at 0 range 2 .. 2;
      WDG_RST         at 0 range 3 .. 3;
      I2S0_RST        at 0 range 4 .. 4;
      UART1_RST       at 0 range 5 .. 5;
      SPI2_RST        at 0 range 6 .. 6;
      I2C_EXT0_RST    at 0 range 7 .. 7;
      UHCI0_RST       at 0 range 8 .. 8;
      RMT_RST         at 0 range 9 .. 9;
      PCNT_RST        at 0 range 10 .. 10;
      LEDC_RST        at 0 range 11 .. 11;
      UHCI1_RST       at 0 range 12 .. 12;
      TIMERGROUP_RST  at 0 range 13 .. 13;
      EFUSE_RST       at 0 range 14 .. 14;
      TIMERGROUP1_RST at 0 range 15 .. 15;
      SPI3_RST        at 0 range 16 .. 16;
      PWM0_RST        at 0 range 17 .. 17;
      EXT1_RST        at 0 range 18 .. 18;
      TWAI_RST        at 0 range 19 .. 19;
      PWM1_RST        at 0 range 20 .. 20;
      I2S1_RST        at 0 range 21 .. 21;
      SPI2_DMA_RST    at 0 range 22 .. 22;
      USB_DEVICE_RST  at 0 range 23 .. 23;
      UART_MEM_RST    at 0 range 24 .. 24;
      PWM2_RST        at 0 range 25 .. 25;
      PWM3_RST        at 0 range 26 .. 26;
      SPI3_DMA_RST    at 0 range 27 .. 27;
      APB_SARADC_RST  at 0 range 28 .. 28;
      SYSTIMER_RST    at 0 range 29 .. 29;
      ADC2_ARB_RST    at 0 range 30 .. 30;
      SPI4_RST        at 0 range 31 .. 31;
   end record;

   subtype PERIP_RST_EN1_CRYPTO_AES_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN1_CRYPTO_SHA_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN1_CRYPTO_RSA_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN1_CRYPTO_DS_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN1_CRYPTO_HMAC_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN1_DMA_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN1_SDIO_HOST_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN1_LCD_CAM_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN1_UART2_RST_Field is ESP32_C3.Bit;
   subtype PERIP_RST_EN1_TSENS_RST_Field is ESP32_C3.Bit;

   --  peripheral reset register
   type PERIP_RST_EN1_Register is record
      --  unspecified
      Reserved_0_0    : ESP32_C3.Bit := 16#0#;
      --  reg_crypto_aes_rst
      CRYPTO_AES_RST  : PERIP_RST_EN1_CRYPTO_AES_RST_Field := 16#1#;
      --  reg_crypto_sha_rst
      CRYPTO_SHA_RST  : PERIP_RST_EN1_CRYPTO_SHA_RST_Field := 16#1#;
      --  reg_crypto_rsa_rst
      CRYPTO_RSA_RST  : PERIP_RST_EN1_CRYPTO_RSA_RST_Field := 16#1#;
      --  reg_crypto_ds_rst
      CRYPTO_DS_RST   : PERIP_RST_EN1_CRYPTO_DS_RST_Field := 16#1#;
      --  reg_crypto_hmac_rst
      CRYPTO_HMAC_RST : PERIP_RST_EN1_CRYPTO_HMAC_RST_Field := 16#1#;
      --  reg_dma_rst
      DMA_RST         : PERIP_RST_EN1_DMA_RST_Field := 16#1#;
      --  reg_sdio_host_rst
      SDIO_HOST_RST   : PERIP_RST_EN1_SDIO_HOST_RST_Field := 16#1#;
      --  reg_lcd_cam_rst
      LCD_CAM_RST     : PERIP_RST_EN1_LCD_CAM_RST_Field := 16#1#;
      --  reg_uart2_rst
      UART2_RST       : PERIP_RST_EN1_UART2_RST_Field := 16#0#;
      --  reg_tsens_rst
      TSENS_RST       : PERIP_RST_EN1_TSENS_RST_Field := 16#0#;
      --  unspecified
      Reserved_11_31  : ESP32_C3.UInt21 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PERIP_RST_EN1_Register use record
      Reserved_0_0    at 0 range 0 .. 0;
      CRYPTO_AES_RST  at 0 range 1 .. 1;
      CRYPTO_SHA_RST  at 0 range 2 .. 2;
      CRYPTO_RSA_RST  at 0 range 3 .. 3;
      CRYPTO_DS_RST   at 0 range 4 .. 4;
      CRYPTO_HMAC_RST at 0 range 5 .. 5;
      DMA_RST         at 0 range 6 .. 6;
      SDIO_HOST_RST   at 0 range 7 .. 7;
      LCD_CAM_RST     at 0 range 8 .. 8;
      UART2_RST       at 0 range 9 .. 9;
      TSENS_RST       at 0 range 10 .. 10;
      Reserved_11_31  at 0 range 11 .. 31;
   end record;

   subtype BT_LPCK_DIV_INT_BT_LPCK_DIV_NUM_Field is ESP32_C3.UInt12;

   --  clock config register
   type BT_LPCK_DIV_INT_Register is record
      --  reg_bt_lpck_div_num
      BT_LPCK_DIV_NUM : BT_LPCK_DIV_INT_BT_LPCK_DIV_NUM_Field := 16#FF#;
      --  unspecified
      Reserved_12_31  : ESP32_C3.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BT_LPCK_DIV_INT_Register use record
      BT_LPCK_DIV_NUM at 0 range 0 .. 11;
      Reserved_12_31  at 0 range 12 .. 31;
   end record;

   subtype BT_LPCK_DIV_FRAC_BT_LPCK_DIV_B_Field is ESP32_C3.UInt12;
   subtype BT_LPCK_DIV_FRAC_BT_LPCK_DIV_A_Field is ESP32_C3.UInt12;
   subtype BT_LPCK_DIV_FRAC_LPCLK_SEL_RTC_SLOW_Field is ESP32_C3.Bit;
   subtype BT_LPCK_DIV_FRAC_LPCLK_SEL_8M_Field is ESP32_C3.Bit;
   subtype BT_LPCK_DIV_FRAC_LPCLK_SEL_XTAL_Field is ESP32_C3.Bit;
   subtype BT_LPCK_DIV_FRAC_LPCLK_SEL_XTAL32K_Field is ESP32_C3.Bit;
   subtype BT_LPCK_DIV_FRAC_LPCLK_RTC_EN_Field is ESP32_C3.Bit;

   --  clock config register
   type BT_LPCK_DIV_FRAC_Register is record
      --  reg_bt_lpck_div_b
      BT_LPCK_DIV_B      : BT_LPCK_DIV_FRAC_BT_LPCK_DIV_B_Field := 16#1#;
      --  reg_bt_lpck_div_a
      BT_LPCK_DIV_A      : BT_LPCK_DIV_FRAC_BT_LPCK_DIV_A_Field := 16#1#;
      --  reg_lpclk_sel_rtc_slow
      LPCLK_SEL_RTC_SLOW : BT_LPCK_DIV_FRAC_LPCLK_SEL_RTC_SLOW_Field := 16#0#;
      --  reg_lpclk_sel_8m
      LPCLK_SEL_8M       : BT_LPCK_DIV_FRAC_LPCLK_SEL_8M_Field := 16#1#;
      --  reg_lpclk_sel_xtal
      LPCLK_SEL_XTAL     : BT_LPCK_DIV_FRAC_LPCLK_SEL_XTAL_Field := 16#0#;
      --  reg_lpclk_sel_xtal32k
      LPCLK_SEL_XTAL32K  : BT_LPCK_DIV_FRAC_LPCLK_SEL_XTAL32K_Field := 16#0#;
      --  reg_lpclk_rtc_en
      LPCLK_RTC_EN       : BT_LPCK_DIV_FRAC_LPCLK_RTC_EN_Field := 16#0#;
      --  unspecified
      Reserved_29_31     : ESP32_C3.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BT_LPCK_DIV_FRAC_Register use record
      BT_LPCK_DIV_B      at 0 range 0 .. 11;
      BT_LPCK_DIV_A      at 0 range 12 .. 23;
      LPCLK_SEL_RTC_SLOW at 0 range 24 .. 24;
      LPCLK_SEL_8M       at 0 range 25 .. 25;
      LPCLK_SEL_XTAL     at 0 range 26 .. 26;
      LPCLK_SEL_XTAL32K  at 0 range 27 .. 27;
      LPCLK_RTC_EN       at 0 range 28 .. 28;
      Reserved_29_31     at 0 range 29 .. 31;
   end record;

   subtype CPU_INTR_FROM_CPU_0_CPU_INTR_FROM_CPU_0_Field is ESP32_C3.Bit;

   --  interrupt generate register
   type CPU_INTR_FROM_CPU_0_Register is record
      --  reg_cpu_intr_from_cpu_0
      CPU_INTR_FROM_CPU_0 : CPU_INTR_FROM_CPU_0_CPU_INTR_FROM_CPU_0_Field :=
                             16#0#;
      --  unspecified
      Reserved_1_31       : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INTR_FROM_CPU_0_Register use record
      CPU_INTR_FROM_CPU_0 at 0 range 0 .. 0;
      Reserved_1_31       at 0 range 1 .. 31;
   end record;

   subtype CPU_INTR_FROM_CPU_1_CPU_INTR_FROM_CPU_1_Field is ESP32_C3.Bit;

   --  interrupt generate register
   type CPU_INTR_FROM_CPU_1_Register is record
      --  reg_cpu_intr_from_cpu_1
      CPU_INTR_FROM_CPU_1 : CPU_INTR_FROM_CPU_1_CPU_INTR_FROM_CPU_1_Field :=
                             16#0#;
      --  unspecified
      Reserved_1_31       : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INTR_FROM_CPU_1_Register use record
      CPU_INTR_FROM_CPU_1 at 0 range 0 .. 0;
      Reserved_1_31       at 0 range 1 .. 31;
   end record;

   subtype CPU_INTR_FROM_CPU_2_CPU_INTR_FROM_CPU_2_Field is ESP32_C3.Bit;

   --  interrupt generate register
   type CPU_INTR_FROM_CPU_2_Register is record
      --  reg_cpu_intr_from_cpu_2
      CPU_INTR_FROM_CPU_2 : CPU_INTR_FROM_CPU_2_CPU_INTR_FROM_CPU_2_Field :=
                             16#0#;
      --  unspecified
      Reserved_1_31       : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INTR_FROM_CPU_2_Register use record
      CPU_INTR_FROM_CPU_2 at 0 range 0 .. 0;
      Reserved_1_31       at 0 range 1 .. 31;
   end record;

   subtype CPU_INTR_FROM_CPU_3_CPU_INTR_FROM_CPU_3_Field is ESP32_C3.Bit;

   --  interrupt generate register
   type CPU_INTR_FROM_CPU_3_Register is record
      --  reg_cpu_intr_from_cpu_3
      CPU_INTR_FROM_CPU_3 : CPU_INTR_FROM_CPU_3_CPU_INTR_FROM_CPU_3_Field :=
                             16#0#;
      --  unspecified
      Reserved_1_31       : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPU_INTR_FROM_CPU_3_Register use record
      CPU_INTR_FROM_CPU_3 at 0 range 0 .. 0;
      Reserved_1_31       at 0 range 1 .. 31;
   end record;

   subtype RSA_PD_CTRL_RSA_MEM_PD_Field is ESP32_C3.Bit;
   subtype RSA_PD_CTRL_RSA_MEM_FORCE_PU_Field is ESP32_C3.Bit;
   subtype RSA_PD_CTRL_RSA_MEM_FORCE_PD_Field is ESP32_C3.Bit;

   --  rsa memory power control register
   type RSA_PD_CTRL_Register is record
      --  reg_rsa_mem_pd
      RSA_MEM_PD       : RSA_PD_CTRL_RSA_MEM_PD_Field := 16#1#;
      --  reg_rsa_mem_force_pu
      RSA_MEM_FORCE_PU : RSA_PD_CTRL_RSA_MEM_FORCE_PU_Field := 16#0#;
      --  reg_rsa_mem_force_pd
      RSA_MEM_FORCE_PD : RSA_PD_CTRL_RSA_MEM_FORCE_PD_Field := 16#0#;
      --  unspecified
      Reserved_3_31    : ESP32_C3.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RSA_PD_CTRL_Register use record
      RSA_MEM_PD       at 0 range 0 .. 0;
      RSA_MEM_FORCE_PU at 0 range 1 .. 1;
      RSA_MEM_FORCE_PD at 0 range 2 .. 2;
      Reserved_3_31    at 0 range 3 .. 31;
   end record;

   subtype EDMA_CTRL_EDMA_CLK_ON_Field is ESP32_C3.Bit;
   subtype EDMA_CTRL_EDMA_RESET_Field is ESP32_C3.Bit;

   --  EDMA clock and reset register
   type EDMA_CTRL_Register is record
      --  reg_edma_clk_on
      EDMA_CLK_ON   : EDMA_CTRL_EDMA_CLK_ON_Field := 16#1#;
      --  reg_edma_reset
      EDMA_RESET    : EDMA_CTRL_EDMA_RESET_Field := 16#0#;
      --  unspecified
      Reserved_2_31 : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for EDMA_CTRL_Register use record
      EDMA_CLK_ON   at 0 range 0 .. 0;
      EDMA_RESET    at 0 range 1 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   subtype CACHE_CONTROL_ICACHE_CLK_ON_Field is ESP32_C3.Bit;
   subtype CACHE_CONTROL_ICACHE_RESET_Field is ESP32_C3.Bit;
   subtype CACHE_CONTROL_DCACHE_CLK_ON_Field is ESP32_C3.Bit;
   subtype CACHE_CONTROL_DCACHE_RESET_Field is ESP32_C3.Bit;

   --  cache control register
   type CACHE_CONTROL_Register is record
      --  reg_icache_clk_on
      ICACHE_CLK_ON : CACHE_CONTROL_ICACHE_CLK_ON_Field := 16#1#;
      --  reg_icache_reset
      ICACHE_RESET  : CACHE_CONTROL_ICACHE_RESET_Field := 16#0#;
      --  reg_dcache_clk_on
      DCACHE_CLK_ON : CACHE_CONTROL_DCACHE_CLK_ON_Field := 16#1#;
      --  reg_dcache_reset
      DCACHE_RESET  : CACHE_CONTROL_DCACHE_RESET_Field := 16#0#;
      --  unspecified
      Reserved_4_31 : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_CONTROL_Register use record
      ICACHE_CLK_ON at 0 range 0 .. 0;
      ICACHE_RESET  at 0 range 1 .. 1;
      DCACHE_CLK_ON at 0 range 2 .. 2;
      DCACHE_RESET  at 0 range 3 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype EXTERNAL_DEVICE_ENCRYPT_DECRYPT_CONTROL_ENABLE_SPI_MANUAL_ENCRYPT_Field is
     ESP32_C3.Bit;
   subtype EXTERNAL_DEVICE_ENCRYPT_DECRYPT_CONTROL_ENABLE_DOWNLOAD_DB_ENCRYPT_Field is
     ESP32_C3.Bit;
   subtype EXTERNAL_DEVICE_ENCRYPT_DECRYPT_CONTROL_ENABLE_DOWNLOAD_G0CB_DECRYPT_Field is
     ESP32_C3.Bit;
   subtype EXTERNAL_DEVICE_ENCRYPT_DECRYPT_CONTROL_ENABLE_DOWNLOAD_MANUAL_ENCRYPT_Field is
     ESP32_C3.Bit;

   --  SYSTEM_EXTERNAL_DEVICE_ENCRYPT_DECRYPT_CONTROL_REG
   type EXTERNAL_DEVICE_ENCRYPT_DECRYPT_CONTROL_Register is record
      --  reg_enable_spi_manual_encrypt
      ENABLE_SPI_MANUAL_ENCRYPT      : EXTERNAL_DEVICE_ENCRYPT_DECRYPT_CONTROL_ENABLE_SPI_MANUAL_ENCRYPT_Field :=
                                        16#0#;
      --  reg_enable_download_db_encrypt
      ENABLE_DOWNLOAD_DB_ENCRYPT     : EXTERNAL_DEVICE_ENCRYPT_DECRYPT_CONTROL_ENABLE_DOWNLOAD_DB_ENCRYPT_Field :=
                                        16#0#;
      --  reg_enable_download_g0cb_decrypt
      ENABLE_DOWNLOAD_G0CB_DECRYPT   : EXTERNAL_DEVICE_ENCRYPT_DECRYPT_CONTROL_ENABLE_DOWNLOAD_G0CB_DECRYPT_Field :=
                                        16#0#;
      --  reg_enable_download_manual_encrypt
      ENABLE_DOWNLOAD_MANUAL_ENCRYPT : EXTERNAL_DEVICE_ENCRYPT_DECRYPT_CONTROL_ENABLE_DOWNLOAD_MANUAL_ENCRYPT_Field :=
                                        16#0#;
      --  unspecified
      Reserved_4_31                  : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for EXTERNAL_DEVICE_ENCRYPT_DECRYPT_CONTROL_Register use record
      ENABLE_SPI_MANUAL_ENCRYPT      at 0 range 0 .. 0;
      ENABLE_DOWNLOAD_DB_ENCRYPT     at 0 range 1 .. 1;
      ENABLE_DOWNLOAD_G0CB_DECRYPT   at 0 range 2 .. 2;
      ENABLE_DOWNLOAD_MANUAL_ENCRYPT at 0 range 3 .. 3;
      Reserved_4_31                  at 0 range 4 .. 31;
   end record;

   subtype RTC_FASTMEM_CONFIG_RTC_MEM_CRC_START_Field is ESP32_C3.Bit;
   subtype RTC_FASTMEM_CONFIG_RTC_MEM_CRC_ADDR_Field is ESP32_C3.UInt11;
   subtype RTC_FASTMEM_CONFIG_RTC_MEM_CRC_LEN_Field is ESP32_C3.UInt11;
   subtype RTC_FASTMEM_CONFIG_RTC_MEM_CRC_FINISH_Field is ESP32_C3.Bit;

   --  fast memory config register
   type RTC_FASTMEM_CONFIG_Register is record
      --  unspecified
      Reserved_0_7       : ESP32_C3.Byte := 16#0#;
      --  reg_rtc_mem_crc_start
      RTC_MEM_CRC_START  : RTC_FASTMEM_CONFIG_RTC_MEM_CRC_START_Field :=
                            16#0#;
      --  reg_rtc_mem_crc_addr
      RTC_MEM_CRC_ADDR   : RTC_FASTMEM_CONFIG_RTC_MEM_CRC_ADDR_Field := 16#0#;
      --  reg_rtc_mem_crc_len
      RTC_MEM_CRC_LEN    : RTC_FASTMEM_CONFIG_RTC_MEM_CRC_LEN_Field :=
                            16#7FF#;
      --  Read-only. reg_rtc_mem_crc_finish
      RTC_MEM_CRC_FINISH : RTC_FASTMEM_CONFIG_RTC_MEM_CRC_FINISH_Field :=
                            16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RTC_FASTMEM_CONFIG_Register use record
      Reserved_0_7       at 0 range 0 .. 7;
      RTC_MEM_CRC_START  at 0 range 8 .. 8;
      RTC_MEM_CRC_ADDR   at 0 range 9 .. 19;
      RTC_MEM_CRC_LEN    at 0 range 20 .. 30;
      RTC_MEM_CRC_FINISH at 0 range 31 .. 31;
   end record;

   subtype REDUNDANT_ECO_CTRL_REDUNDANT_ECO_DRIVE_Field is ESP32_C3.Bit;
   subtype REDUNDANT_ECO_CTRL_REDUNDANT_ECO_RESULT_Field is ESP32_C3.Bit;

   --  eco register
   type REDUNDANT_ECO_CTRL_Register is record
      --  reg_redundant_eco_drive
      REDUNDANT_ECO_DRIVE  : REDUNDANT_ECO_CTRL_REDUNDANT_ECO_DRIVE_Field :=
                              16#0#;
      --  Read-only. reg_redundant_eco_result
      REDUNDANT_ECO_RESULT : REDUNDANT_ECO_CTRL_REDUNDANT_ECO_RESULT_Field :=
                              16#0#;
      --  unspecified
      Reserved_2_31        : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REDUNDANT_ECO_CTRL_Register use record
      REDUNDANT_ECO_DRIVE  at 0 range 0 .. 0;
      REDUNDANT_ECO_RESULT at 0 range 1 .. 1;
      Reserved_2_31        at 0 range 2 .. 31;
   end record;

   subtype CLOCK_GATE_CLK_EN_Field is ESP32_C3.Bit;

   --  clock gating register
   type CLOCK_GATE_Register is record
      --  reg_clk_en
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

   subtype SYSCLK_CONF_PRE_DIV_CNT_Field is ESP32_C3.UInt10;
   subtype SYSCLK_CONF_SOC_CLK_SEL_Field is ESP32_C3.UInt2;
   subtype SYSCLK_CONF_CLK_XTAL_FREQ_Field is ESP32_C3.UInt7;
   subtype SYSCLK_CONF_CLK_DIV_EN_Field is ESP32_C3.Bit;

   --  system clock config register
   type SYSCLK_CONF_Register is record
      --  reg_pre_div_cnt
      PRE_DIV_CNT    : SYSCLK_CONF_PRE_DIV_CNT_Field := 16#1#;
      --  reg_soc_clk_sel
      SOC_CLK_SEL    : SYSCLK_CONF_SOC_CLK_SEL_Field := 16#0#;
      --  Read-only. reg_clk_xtal_freq
      CLK_XTAL_FREQ  : SYSCLK_CONF_CLK_XTAL_FREQ_Field := 16#0#;
      --  Read-only. reg_clk_div_en
      CLK_DIV_EN     : SYSCLK_CONF_CLK_DIV_EN_Field := 16#0#;
      --  unspecified
      Reserved_20_31 : ESP32_C3.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYSCLK_CONF_Register use record
      PRE_DIV_CNT    at 0 range 0 .. 9;
      SOC_CLK_SEL    at 0 range 10 .. 11;
      CLK_XTAL_FREQ  at 0 range 12 .. 18;
      CLK_DIV_EN     at 0 range 19 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype MEM_PVT_MEM_PATH_LEN_Field is ESP32_C3.UInt4;
   subtype MEM_PVT_MEM_ERR_CNT_CLR_Field is ESP32_C3.Bit;
   subtype MEM_PVT_MONITOR_EN_Field is ESP32_C3.Bit;
   subtype MEM_PVT_MEM_TIMING_ERR_CNT_Field is ESP32_C3.UInt16;
   subtype MEM_PVT_MEM_VT_SEL_Field is ESP32_C3.UInt2;

   --  mem pvt register
   type MEM_PVT_Register is record
      --  reg_mem_path_len
      MEM_PATH_LEN       : MEM_PVT_MEM_PATH_LEN_Field := 16#3#;
      --  Write-only. reg_mem_err_cnt_clr
      MEM_ERR_CNT_CLR    : MEM_PVT_MEM_ERR_CNT_CLR_Field := 16#0#;
      --  reg_mem_pvt_monitor_en
      MONITOR_EN         : MEM_PVT_MONITOR_EN_Field := 16#0#;
      --  Read-only. reg_mem_timing_err_cnt
      MEM_TIMING_ERR_CNT : MEM_PVT_MEM_TIMING_ERR_CNT_Field := 16#0#;
      --  reg_mem_vt_sel
      MEM_VT_SEL         : MEM_PVT_MEM_VT_SEL_Field := 16#0#;
      --  unspecified
      Reserved_24_31     : ESP32_C3.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for MEM_PVT_Register use record
      MEM_PATH_LEN       at 0 range 0 .. 3;
      MEM_ERR_CNT_CLR    at 0 range 4 .. 4;
      MONITOR_EN         at 0 range 5 .. 5;
      MEM_TIMING_ERR_CNT at 0 range 6 .. 21;
      MEM_VT_SEL         at 0 range 22 .. 23;
      Reserved_24_31     at 0 range 24 .. 31;
   end record;

   subtype COMB_PVT_LVT_CONF_COMB_PATH_LEN_LVT_Field is ESP32_C3.UInt5;
   subtype COMB_PVT_LVT_CONF_COMB_ERR_CNT_CLR_LVT_Field is ESP32_C3.Bit;
   subtype COMB_PVT_LVT_CONF_COMB_PVT_MONITOR_EN_LVT_Field is ESP32_C3.Bit;

   --  mem pvt register
   type COMB_PVT_LVT_CONF_Register is record
      --  reg_comb_path_len_lvt
      COMB_PATH_LEN_LVT       : COMB_PVT_LVT_CONF_COMB_PATH_LEN_LVT_Field :=
                                 16#3#;
      --  Write-only. reg_comb_err_cnt_clr_lvt
      COMB_ERR_CNT_CLR_LVT    : COMB_PVT_LVT_CONF_COMB_ERR_CNT_CLR_LVT_Field :=
                                 16#0#;
      --  reg_comb_pvt_monitor_en_lvt
      COMB_PVT_MONITOR_EN_LVT : COMB_PVT_LVT_CONF_COMB_PVT_MONITOR_EN_LVT_Field :=
                                 16#0#;
      --  unspecified
      Reserved_7_31           : ESP32_C3.UInt25 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMB_PVT_LVT_CONF_Register use record
      COMB_PATH_LEN_LVT       at 0 range 0 .. 4;
      COMB_ERR_CNT_CLR_LVT    at 0 range 5 .. 5;
      COMB_PVT_MONITOR_EN_LVT at 0 range 6 .. 6;
      Reserved_7_31           at 0 range 7 .. 31;
   end record;

   subtype COMB_PVT_NVT_CONF_COMB_PATH_LEN_NVT_Field is ESP32_C3.UInt5;
   subtype COMB_PVT_NVT_CONF_COMB_ERR_CNT_CLR_NVT_Field is ESP32_C3.Bit;
   subtype COMB_PVT_NVT_CONF_COMB_PVT_MONITOR_EN_NVT_Field is ESP32_C3.Bit;

   --  mem pvt register
   type COMB_PVT_NVT_CONF_Register is record
      --  reg_comb_path_len_nvt
      COMB_PATH_LEN_NVT       : COMB_PVT_NVT_CONF_COMB_PATH_LEN_NVT_Field :=
                                 16#3#;
      --  Write-only. reg_comb_err_cnt_clr_nvt
      COMB_ERR_CNT_CLR_NVT    : COMB_PVT_NVT_CONF_COMB_ERR_CNT_CLR_NVT_Field :=
                                 16#0#;
      --  reg_comb_pvt_monitor_en_nvt
      COMB_PVT_MONITOR_EN_NVT : COMB_PVT_NVT_CONF_COMB_PVT_MONITOR_EN_NVT_Field :=
                                 16#0#;
      --  unspecified
      Reserved_7_31           : ESP32_C3.UInt25 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMB_PVT_NVT_CONF_Register use record
      COMB_PATH_LEN_NVT       at 0 range 0 .. 4;
      COMB_ERR_CNT_CLR_NVT    at 0 range 5 .. 5;
      COMB_PVT_MONITOR_EN_NVT at 0 range 6 .. 6;
      Reserved_7_31           at 0 range 7 .. 31;
   end record;

   subtype COMB_PVT_HVT_CONF_COMB_PATH_LEN_HVT_Field is ESP32_C3.UInt5;
   subtype COMB_PVT_HVT_CONF_COMB_ERR_CNT_CLR_HVT_Field is ESP32_C3.Bit;
   subtype COMB_PVT_HVT_CONF_COMB_PVT_MONITOR_EN_HVT_Field is ESP32_C3.Bit;

   --  mem pvt register
   type COMB_PVT_HVT_CONF_Register is record
      --  reg_comb_path_len_hvt
      COMB_PATH_LEN_HVT       : COMB_PVT_HVT_CONF_COMB_PATH_LEN_HVT_Field :=
                                 16#3#;
      --  Write-only. reg_comb_err_cnt_clr_hvt
      COMB_ERR_CNT_CLR_HVT    : COMB_PVT_HVT_CONF_COMB_ERR_CNT_CLR_HVT_Field :=
                                 16#0#;
      --  reg_comb_pvt_monitor_en_hvt
      COMB_PVT_MONITOR_EN_HVT : COMB_PVT_HVT_CONF_COMB_PVT_MONITOR_EN_HVT_Field :=
                                 16#0#;
      --  unspecified
      Reserved_7_31           : ESP32_C3.UInt25 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMB_PVT_HVT_CONF_Register use record
      COMB_PATH_LEN_HVT       at 0 range 0 .. 4;
      COMB_ERR_CNT_CLR_HVT    at 0 range 5 .. 5;
      COMB_PVT_MONITOR_EN_HVT at 0 range 6 .. 6;
      Reserved_7_31           at 0 range 7 .. 31;
   end record;

   subtype COMB_PVT_ERR_LVT_SITE0_COMB_TIMING_ERR_CNT_LVT_SITE0_Field is
     ESP32_C3.UInt16;

   --  mem pvt register
   type COMB_PVT_ERR_LVT_SITE0_Register is record
      --  Read-only. reg_comb_timing_err_cnt_lvt_site0
      COMB_TIMING_ERR_CNT_LVT_SITE0 : COMB_PVT_ERR_LVT_SITE0_COMB_TIMING_ERR_CNT_LVT_SITE0_Field;
      --  unspecified
      Reserved_16_31                : ESP32_C3.UInt16;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMB_PVT_ERR_LVT_SITE0_Register use record
      COMB_TIMING_ERR_CNT_LVT_SITE0 at 0 range 0 .. 15;
      Reserved_16_31                at 0 range 16 .. 31;
   end record;

   subtype COMB_PVT_ERR_NVT_SITE0_COMB_TIMING_ERR_CNT_NVT_SITE0_Field is
     ESP32_C3.UInt16;

   --  mem pvt register
   type COMB_PVT_ERR_NVT_SITE0_Register is record
      --  Read-only. reg_comb_timing_err_cnt_nvt_site0
      COMB_TIMING_ERR_CNT_NVT_SITE0 : COMB_PVT_ERR_NVT_SITE0_COMB_TIMING_ERR_CNT_NVT_SITE0_Field;
      --  unspecified
      Reserved_16_31                : ESP32_C3.UInt16;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMB_PVT_ERR_NVT_SITE0_Register use record
      COMB_TIMING_ERR_CNT_NVT_SITE0 at 0 range 0 .. 15;
      Reserved_16_31                at 0 range 16 .. 31;
   end record;

   subtype COMB_PVT_ERR_HVT_SITE0_COMB_TIMING_ERR_CNT_HVT_SITE0_Field is
     ESP32_C3.UInt16;

   --  mem pvt register
   type COMB_PVT_ERR_HVT_SITE0_Register is record
      --  Read-only. reg_comb_timing_err_cnt_hvt_site0
      COMB_TIMING_ERR_CNT_HVT_SITE0 : COMB_PVT_ERR_HVT_SITE0_COMB_TIMING_ERR_CNT_HVT_SITE0_Field;
      --  unspecified
      Reserved_16_31                : ESP32_C3.UInt16;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMB_PVT_ERR_HVT_SITE0_Register use record
      COMB_TIMING_ERR_CNT_HVT_SITE0 at 0 range 0 .. 15;
      Reserved_16_31                at 0 range 16 .. 31;
   end record;

   subtype COMB_PVT_ERR_LVT_SITE1_COMB_TIMING_ERR_CNT_LVT_SITE1_Field is
     ESP32_C3.UInt16;

   --  mem pvt register
   type COMB_PVT_ERR_LVT_SITE1_Register is record
      --  Read-only. reg_comb_timing_err_cnt_lvt_site1
      COMB_TIMING_ERR_CNT_LVT_SITE1 : COMB_PVT_ERR_LVT_SITE1_COMB_TIMING_ERR_CNT_LVT_SITE1_Field;
      --  unspecified
      Reserved_16_31                : ESP32_C3.UInt16;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMB_PVT_ERR_LVT_SITE1_Register use record
      COMB_TIMING_ERR_CNT_LVT_SITE1 at 0 range 0 .. 15;
      Reserved_16_31                at 0 range 16 .. 31;
   end record;

   subtype COMB_PVT_ERR_NVT_SITE1_COMB_TIMING_ERR_CNT_NVT_SITE1_Field is
     ESP32_C3.UInt16;

   --  mem pvt register
   type COMB_PVT_ERR_NVT_SITE1_Register is record
      --  Read-only. reg_comb_timing_err_cnt_nvt_site1
      COMB_TIMING_ERR_CNT_NVT_SITE1 : COMB_PVT_ERR_NVT_SITE1_COMB_TIMING_ERR_CNT_NVT_SITE1_Field;
      --  unspecified
      Reserved_16_31                : ESP32_C3.UInt16;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMB_PVT_ERR_NVT_SITE1_Register use record
      COMB_TIMING_ERR_CNT_NVT_SITE1 at 0 range 0 .. 15;
      Reserved_16_31                at 0 range 16 .. 31;
   end record;

   subtype COMB_PVT_ERR_HVT_SITE1_COMB_TIMING_ERR_CNT_HVT_SITE1_Field is
     ESP32_C3.UInt16;

   --  mem pvt register
   type COMB_PVT_ERR_HVT_SITE1_Register is record
      --  Read-only. reg_comb_timing_err_cnt_hvt_site1
      COMB_TIMING_ERR_CNT_HVT_SITE1 : COMB_PVT_ERR_HVT_SITE1_COMB_TIMING_ERR_CNT_HVT_SITE1_Field;
      --  unspecified
      Reserved_16_31                : ESP32_C3.UInt16;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMB_PVT_ERR_HVT_SITE1_Register use record
      COMB_TIMING_ERR_CNT_HVT_SITE1 at 0 range 0 .. 15;
      Reserved_16_31                at 0 range 16 .. 31;
   end record;

   subtype COMB_PVT_ERR_LVT_SITE2_COMB_TIMING_ERR_CNT_LVT_SITE2_Field is
     ESP32_C3.UInt16;

   --  mem pvt register
   type COMB_PVT_ERR_LVT_SITE2_Register is record
      --  Read-only. reg_comb_timing_err_cnt_lvt_site2
      COMB_TIMING_ERR_CNT_LVT_SITE2 : COMB_PVT_ERR_LVT_SITE2_COMB_TIMING_ERR_CNT_LVT_SITE2_Field;
      --  unspecified
      Reserved_16_31                : ESP32_C3.UInt16;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMB_PVT_ERR_LVT_SITE2_Register use record
      COMB_TIMING_ERR_CNT_LVT_SITE2 at 0 range 0 .. 15;
      Reserved_16_31                at 0 range 16 .. 31;
   end record;

   subtype COMB_PVT_ERR_NVT_SITE2_COMB_TIMING_ERR_CNT_NVT_SITE2_Field is
     ESP32_C3.UInt16;

   --  mem pvt register
   type COMB_PVT_ERR_NVT_SITE2_Register is record
      --  Read-only. reg_comb_timing_err_cnt_nvt_site2
      COMB_TIMING_ERR_CNT_NVT_SITE2 : COMB_PVT_ERR_NVT_SITE2_COMB_TIMING_ERR_CNT_NVT_SITE2_Field;
      --  unspecified
      Reserved_16_31                : ESP32_C3.UInt16;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMB_PVT_ERR_NVT_SITE2_Register use record
      COMB_TIMING_ERR_CNT_NVT_SITE2 at 0 range 0 .. 15;
      Reserved_16_31                at 0 range 16 .. 31;
   end record;

   subtype COMB_PVT_ERR_HVT_SITE2_COMB_TIMING_ERR_CNT_HVT_SITE2_Field is
     ESP32_C3.UInt16;

   --  mem pvt register
   type COMB_PVT_ERR_HVT_SITE2_Register is record
      --  Read-only. reg_comb_timing_err_cnt_hvt_site2
      COMB_TIMING_ERR_CNT_HVT_SITE2 : COMB_PVT_ERR_HVT_SITE2_COMB_TIMING_ERR_CNT_HVT_SITE2_Field;
      --  unspecified
      Reserved_16_31                : ESP32_C3.UInt16;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMB_PVT_ERR_HVT_SITE2_Register use record
      COMB_TIMING_ERR_CNT_HVT_SITE2 at 0 range 0 .. 15;
      Reserved_16_31                at 0 range 16 .. 31;
   end record;

   subtype COMB_PVT_ERR_LVT_SITE3_COMB_TIMING_ERR_CNT_LVT_SITE3_Field is
     ESP32_C3.UInt16;

   --  mem pvt register
   type COMB_PVT_ERR_LVT_SITE3_Register is record
      --  Read-only. reg_comb_timing_err_cnt_lvt_site3
      COMB_TIMING_ERR_CNT_LVT_SITE3 : COMB_PVT_ERR_LVT_SITE3_COMB_TIMING_ERR_CNT_LVT_SITE3_Field;
      --  unspecified
      Reserved_16_31                : ESP32_C3.UInt16;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMB_PVT_ERR_LVT_SITE3_Register use record
      COMB_TIMING_ERR_CNT_LVT_SITE3 at 0 range 0 .. 15;
      Reserved_16_31                at 0 range 16 .. 31;
   end record;

   subtype COMB_PVT_ERR_NVT_SITE3_COMB_TIMING_ERR_CNT_NVT_SITE3_Field is
     ESP32_C3.UInt16;

   --  mem pvt register
   type COMB_PVT_ERR_NVT_SITE3_Register is record
      --  Read-only. reg_comb_timing_err_cnt_nvt_site3
      COMB_TIMING_ERR_CNT_NVT_SITE3 : COMB_PVT_ERR_NVT_SITE3_COMB_TIMING_ERR_CNT_NVT_SITE3_Field;
      --  unspecified
      Reserved_16_31                : ESP32_C3.UInt16;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMB_PVT_ERR_NVT_SITE3_Register use record
      COMB_TIMING_ERR_CNT_NVT_SITE3 at 0 range 0 .. 15;
      Reserved_16_31                at 0 range 16 .. 31;
   end record;

   subtype COMB_PVT_ERR_HVT_SITE3_COMB_TIMING_ERR_CNT_HVT_SITE3_Field is
     ESP32_C3.UInt16;

   --  mem pvt register
   type COMB_PVT_ERR_HVT_SITE3_Register is record
      --  Read-only. reg_comb_timing_err_cnt_hvt_site3
      COMB_TIMING_ERR_CNT_HVT_SITE3 : COMB_PVT_ERR_HVT_SITE3_COMB_TIMING_ERR_CNT_HVT_SITE3_Field;
      --  unspecified
      Reserved_16_31                : ESP32_C3.UInt16;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMB_PVT_ERR_HVT_SITE3_Register use record
      COMB_TIMING_ERR_CNT_HVT_SITE3 at 0 range 0 .. 15;
      Reserved_16_31                at 0 range 16 .. 31;
   end record;

   subtype SYSTEM_REG_DATE_SYSTEM_REG_DATE_Field is ESP32_C3.UInt28;

   --  Version register
   type SYSTEM_REG_DATE_Register is record
      --  reg_system_reg_date
      SYSTEM_REG_DATE : SYSTEM_REG_DATE_SYSTEM_REG_DATE_Field := 16#2007150#;
      --  unspecified
      Reserved_28_31  : ESP32_C3.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYSTEM_REG_DATE_Register use record
      SYSTEM_REG_DATE at 0 range 0 .. 27;
      Reserved_28_31  at 0 range 28 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  System Configuration Registers
   type SYSTEM_Peripheral is record
      --  cpu_peripheral clock gating register
      CPU_PERI_CLK_EN                         : aliased CPU_PERI_CLK_EN_Register;
      --  cpu_peripheral reset register
      CPU_PERI_RST_EN                         : aliased CPU_PERI_RST_EN_Register;
      --  cpu clock config register
      CPU_PER_CONF                            : aliased CPU_PER_CONF_Register;
      --  memory power down mask register
      MEM_PD_MASK                             : aliased MEM_PD_MASK_Register;
      --  peripheral clock gating register
      PERIP_CLK_EN0                           : aliased PERIP_CLK_EN0_Register;
      --  peripheral clock gating register
      PERIP_CLK_EN1                           : aliased PERIP_CLK_EN1_Register;
      --  reserved
      PERIP_RST_EN0                           : aliased PERIP_RST_EN0_Register;
      --  peripheral reset register
      PERIP_RST_EN1                           : aliased PERIP_RST_EN1_Register;
      --  clock config register
      BT_LPCK_DIV_INT                         : aliased BT_LPCK_DIV_INT_Register;
      --  clock config register
      BT_LPCK_DIV_FRAC                        : aliased BT_LPCK_DIV_FRAC_Register;
      --  interrupt generate register
      CPU_INTR_FROM_CPU_0                     : aliased CPU_INTR_FROM_CPU_0_Register;
      --  interrupt generate register
      CPU_INTR_FROM_CPU_1                     : aliased CPU_INTR_FROM_CPU_1_Register;
      --  interrupt generate register
      CPU_INTR_FROM_CPU_2                     : aliased CPU_INTR_FROM_CPU_2_Register;
      --  interrupt generate register
      CPU_INTR_FROM_CPU_3                     : aliased CPU_INTR_FROM_CPU_3_Register;
      --  rsa memory power control register
      RSA_PD_CTRL                             : aliased RSA_PD_CTRL_Register;
      --  EDMA clock and reset register
      EDMA_CTRL                               : aliased EDMA_CTRL_Register;
      --  cache control register
      CACHE_CONTROL                           : aliased CACHE_CONTROL_Register;
      --  SYSTEM_EXTERNAL_DEVICE_ENCRYPT_DECRYPT_CONTROL_REG
      EXTERNAL_DEVICE_ENCRYPT_DECRYPT_CONTROL : aliased EXTERNAL_DEVICE_ENCRYPT_DECRYPT_CONTROL_Register;
      --  fast memory config register
      RTC_FASTMEM_CONFIG                      : aliased RTC_FASTMEM_CONFIG_Register;
      --  reserved
      RTC_FASTMEM_CRC                         : aliased ESP32_C3.UInt32;
      --  eco register
      REDUNDANT_ECO_CTRL                      : aliased REDUNDANT_ECO_CTRL_Register;
      --  clock gating register
      CLOCK_GATE                              : aliased CLOCK_GATE_Register;
      --  system clock config register
      SYSCLK_CONF                             : aliased SYSCLK_CONF_Register;
      --  mem pvt register
      MEM_PVT                                 : aliased MEM_PVT_Register;
      --  mem pvt register
      COMB_PVT_LVT_CONF                       : aliased COMB_PVT_LVT_CONF_Register;
      --  mem pvt register
      COMB_PVT_NVT_CONF                       : aliased COMB_PVT_NVT_CONF_Register;
      --  mem pvt register
      COMB_PVT_HVT_CONF                       : aliased COMB_PVT_HVT_CONF_Register;
      --  mem pvt register
      COMB_PVT_ERR_LVT_SITE0                  : aliased COMB_PVT_ERR_LVT_SITE0_Register;
      --  mem pvt register
      COMB_PVT_ERR_NVT_SITE0                  : aliased COMB_PVT_ERR_NVT_SITE0_Register;
      --  mem pvt register
      COMB_PVT_ERR_HVT_SITE0                  : aliased COMB_PVT_ERR_HVT_SITE0_Register;
      --  mem pvt register
      COMB_PVT_ERR_LVT_SITE1                  : aliased COMB_PVT_ERR_LVT_SITE1_Register;
      --  mem pvt register
      COMB_PVT_ERR_NVT_SITE1                  : aliased COMB_PVT_ERR_NVT_SITE1_Register;
      --  mem pvt register
      COMB_PVT_ERR_HVT_SITE1                  : aliased COMB_PVT_ERR_HVT_SITE1_Register;
      --  mem pvt register
      COMB_PVT_ERR_LVT_SITE2                  : aliased COMB_PVT_ERR_LVT_SITE2_Register;
      --  mem pvt register
      COMB_PVT_ERR_NVT_SITE2                  : aliased COMB_PVT_ERR_NVT_SITE2_Register;
      --  mem pvt register
      COMB_PVT_ERR_HVT_SITE2                  : aliased COMB_PVT_ERR_HVT_SITE2_Register;
      --  mem pvt register
      COMB_PVT_ERR_LVT_SITE3                  : aliased COMB_PVT_ERR_LVT_SITE3_Register;
      --  mem pvt register
      COMB_PVT_ERR_NVT_SITE3                  : aliased COMB_PVT_ERR_NVT_SITE3_Register;
      --  mem pvt register
      COMB_PVT_ERR_HVT_SITE3                  : aliased COMB_PVT_ERR_HVT_SITE3_Register;
      --  Version register
      SYSTEM_REG_DATE                         : aliased SYSTEM_REG_DATE_Register;
   end record
     with Volatile;

   for SYSTEM_Peripheral use record
      CPU_PERI_CLK_EN                         at 16#0# range 0 .. 31;
      CPU_PERI_RST_EN                         at 16#4# range 0 .. 31;
      CPU_PER_CONF                            at 16#8# range 0 .. 31;
      MEM_PD_MASK                             at 16#C# range 0 .. 31;
      PERIP_CLK_EN0                           at 16#10# range 0 .. 31;
      PERIP_CLK_EN1                           at 16#14# range 0 .. 31;
      PERIP_RST_EN0                           at 16#18# range 0 .. 31;
      PERIP_RST_EN1                           at 16#1C# range 0 .. 31;
      BT_LPCK_DIV_INT                         at 16#20# range 0 .. 31;
      BT_LPCK_DIV_FRAC                        at 16#24# range 0 .. 31;
      CPU_INTR_FROM_CPU_0                     at 16#28# range 0 .. 31;
      CPU_INTR_FROM_CPU_1                     at 16#2C# range 0 .. 31;
      CPU_INTR_FROM_CPU_2                     at 16#30# range 0 .. 31;
      CPU_INTR_FROM_CPU_3                     at 16#34# range 0 .. 31;
      RSA_PD_CTRL                             at 16#38# range 0 .. 31;
      EDMA_CTRL                               at 16#3C# range 0 .. 31;
      CACHE_CONTROL                           at 16#40# range 0 .. 31;
      EXTERNAL_DEVICE_ENCRYPT_DECRYPT_CONTROL at 16#44# range 0 .. 31;
      RTC_FASTMEM_CONFIG                      at 16#48# range 0 .. 31;
      RTC_FASTMEM_CRC                         at 16#4C# range 0 .. 31;
      REDUNDANT_ECO_CTRL                      at 16#50# range 0 .. 31;
      CLOCK_GATE                              at 16#54# range 0 .. 31;
      SYSCLK_CONF                             at 16#58# range 0 .. 31;
      MEM_PVT                                 at 16#5C# range 0 .. 31;
      COMB_PVT_LVT_CONF                       at 16#60# range 0 .. 31;
      COMB_PVT_NVT_CONF                       at 16#64# range 0 .. 31;
      COMB_PVT_HVT_CONF                       at 16#68# range 0 .. 31;
      COMB_PVT_ERR_LVT_SITE0                  at 16#6C# range 0 .. 31;
      COMB_PVT_ERR_NVT_SITE0                  at 16#70# range 0 .. 31;
      COMB_PVT_ERR_HVT_SITE0                  at 16#74# range 0 .. 31;
      COMB_PVT_ERR_LVT_SITE1                  at 16#78# range 0 .. 31;
      COMB_PVT_ERR_NVT_SITE1                  at 16#7C# range 0 .. 31;
      COMB_PVT_ERR_HVT_SITE1                  at 16#80# range 0 .. 31;
      COMB_PVT_ERR_LVT_SITE2                  at 16#84# range 0 .. 31;
      COMB_PVT_ERR_NVT_SITE2                  at 16#88# range 0 .. 31;
      COMB_PVT_ERR_HVT_SITE2                  at 16#8C# range 0 .. 31;
      COMB_PVT_ERR_LVT_SITE3                  at 16#90# range 0 .. 31;
      COMB_PVT_ERR_NVT_SITE3                  at 16#94# range 0 .. 31;
      COMB_PVT_ERR_HVT_SITE3                  at 16#98# range 0 .. 31;
      SYSTEM_REG_DATE                         at 16#FFC# range 0 .. 31;
   end record;

   --  System Configuration Registers
   SYSTEM_Periph : aliased SYSTEM_Peripheral
     with Import, Address => SYSTEM_Base;

end ESP32_C3.ESP_SYSTEM;
