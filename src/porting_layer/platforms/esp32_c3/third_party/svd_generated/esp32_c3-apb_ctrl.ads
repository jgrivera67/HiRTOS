pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.APB_CTRL is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype SYSCLK_CONF_PRE_DIV_CNT_Field is ESP32_C3.UInt10;
   subtype SYSCLK_CONF_CLK_320M_EN_Field is ESP32_C3.Bit;
   subtype SYSCLK_CONF_CLK_EN_Field is ESP32_C3.Bit;
   subtype SYSCLK_CONF_RST_TICK_CNT_Field is ESP32_C3.Bit;

   --  APB_CTRL_SYSCLK_CONF_REG
   type SYSCLK_CONF_Register is record
      --  reg_pre_div_cnt
      PRE_DIV_CNT    : SYSCLK_CONF_PRE_DIV_CNT_Field := 16#1#;
      --  reg_clk_320m_en
      CLK_320M_EN    : SYSCLK_CONF_CLK_320M_EN_Field := 16#0#;
      --  reg_clk_en
      CLK_EN         : SYSCLK_CONF_CLK_EN_Field := 16#0#;
      --  reg_rst_tick_cnt
      RST_TICK_CNT   : SYSCLK_CONF_RST_TICK_CNT_Field := 16#0#;
      --  unspecified
      Reserved_13_31 : ESP32_C3.UInt19 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYSCLK_CONF_Register use record
      PRE_DIV_CNT    at 0 range 0 .. 9;
      CLK_320M_EN    at 0 range 10 .. 10;
      CLK_EN         at 0 range 11 .. 11;
      RST_TICK_CNT   at 0 range 12 .. 12;
      Reserved_13_31 at 0 range 13 .. 31;
   end record;

   subtype TICK_CONF_XTAL_TICK_NUM_Field is ESP32_C3.Byte;
   subtype TICK_CONF_CK8M_TICK_NUM_Field is ESP32_C3.Byte;
   subtype TICK_CONF_TICK_ENABLE_Field is ESP32_C3.Bit;

   --  APB_CTRL_TICK_CONF_REG
   type TICK_CONF_Register is record
      --  reg_xtal_tick_num
      XTAL_TICK_NUM  : TICK_CONF_XTAL_TICK_NUM_Field := 16#27#;
      --  reg_ck8m_tick_num
      CK8M_TICK_NUM  : TICK_CONF_CK8M_TICK_NUM_Field := 16#7#;
      --  reg_tick_enable
      TICK_ENABLE    : TICK_CONF_TICK_ENABLE_Field := 16#1#;
      --  unspecified
      Reserved_17_31 : ESP32_C3.UInt15 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TICK_CONF_Register use record
      XTAL_TICK_NUM  at 0 range 0 .. 7;
      CK8M_TICK_NUM  at 0 range 8 .. 15;
      TICK_ENABLE    at 0 range 16 .. 16;
      Reserved_17_31 at 0 range 17 .. 31;
   end record;

   subtype CLK_OUT_EN_CLK20_OEN_Field is ESP32_C3.Bit;
   subtype CLK_OUT_EN_CLK22_OEN_Field is ESP32_C3.Bit;
   subtype CLK_OUT_EN_CLK44_OEN_Field is ESP32_C3.Bit;
   subtype CLK_OUT_EN_CLK_BB_OEN_Field is ESP32_C3.Bit;
   subtype CLK_OUT_EN_CLK80_OEN_Field is ESP32_C3.Bit;
   subtype CLK_OUT_EN_CLK160_OEN_Field is ESP32_C3.Bit;
   subtype CLK_OUT_EN_CLK_320M_OEN_Field is ESP32_C3.Bit;
   subtype CLK_OUT_EN_CLK_ADC_INF_OEN_Field is ESP32_C3.Bit;
   subtype CLK_OUT_EN_CLK_DAC_CPU_OEN_Field is ESP32_C3.Bit;
   subtype CLK_OUT_EN_CLK40X_BB_OEN_Field is ESP32_C3.Bit;
   subtype CLK_OUT_EN_CLK_XTAL_OEN_Field is ESP32_C3.Bit;

   --  APB_CTRL_CLK_OUT_EN_REG
   type CLK_OUT_EN_Register is record
      --  reg_clk20_oen
      CLK20_OEN       : CLK_OUT_EN_CLK20_OEN_Field := 16#1#;
      --  reg_clk22_oen
      CLK22_OEN       : CLK_OUT_EN_CLK22_OEN_Field := 16#1#;
      --  reg_clk44_oen
      CLK44_OEN       : CLK_OUT_EN_CLK44_OEN_Field := 16#1#;
      --  reg_clk_bb_oen
      CLK_BB_OEN      : CLK_OUT_EN_CLK_BB_OEN_Field := 16#1#;
      --  reg_clk80_oen
      CLK80_OEN       : CLK_OUT_EN_CLK80_OEN_Field := 16#1#;
      --  reg_clk160_oen
      CLK160_OEN      : CLK_OUT_EN_CLK160_OEN_Field := 16#1#;
      --  reg_clk_320m_oen
      CLK_320M_OEN    : CLK_OUT_EN_CLK_320M_OEN_Field := 16#1#;
      --  reg_clk_adc_inf_oen
      CLK_ADC_INF_OEN : CLK_OUT_EN_CLK_ADC_INF_OEN_Field := 16#1#;
      --  reg_clk_dac_cpu_oen
      CLK_DAC_CPU_OEN : CLK_OUT_EN_CLK_DAC_CPU_OEN_Field := 16#1#;
      --  reg_clk40x_bb_oen
      CLK40X_BB_OEN   : CLK_OUT_EN_CLK40X_BB_OEN_Field := 16#1#;
      --  reg_clk_xtal_oen
      CLK_XTAL_OEN    : CLK_OUT_EN_CLK_XTAL_OEN_Field := 16#1#;
      --  unspecified
      Reserved_11_31  : ESP32_C3.UInt21 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CLK_OUT_EN_Register use record
      CLK20_OEN       at 0 range 0 .. 0;
      CLK22_OEN       at 0 range 1 .. 1;
      CLK44_OEN       at 0 range 2 .. 2;
      CLK_BB_OEN      at 0 range 3 .. 3;
      CLK80_OEN       at 0 range 4 .. 4;
      CLK160_OEN      at 0 range 5 .. 5;
      CLK_320M_OEN    at 0 range 6 .. 6;
      CLK_ADC_INF_OEN at 0 range 7 .. 7;
      CLK_DAC_CPU_OEN at 0 range 8 .. 8;
      CLK40X_BB_OEN   at 0 range 9 .. 9;
      CLK_XTAL_OEN    at 0 range 10 .. 10;
      Reserved_11_31  at 0 range 11 .. 31;
   end record;

   subtype HOST_INF_SEL_PERI_IO_SWAP_Field is ESP32_C3.Byte;

   --  APB_CTRL_HOST_INF_SEL_REG
   type HOST_INF_SEL_Register is record
      --  reg_peri_io_swap
      PERI_IO_SWAP  : HOST_INF_SEL_PERI_IO_SWAP_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : ESP32_C3.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for HOST_INF_SEL_Register use record
      PERI_IO_SWAP  at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype EXT_MEM_PMS_LOCK_EXT_MEM_PMS_LOCK_Field is ESP32_C3.Bit;

   --  APB_CTRL_EXT_MEM_PMS_LOCK_REG
   type EXT_MEM_PMS_LOCK_Register is record
      --  reg_ext_mem_pms_lock
      EXT_MEM_PMS_LOCK : EXT_MEM_PMS_LOCK_EXT_MEM_PMS_LOCK_Field := 16#0#;
      --  unspecified
      Reserved_1_31    : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for EXT_MEM_PMS_LOCK_Register use record
      EXT_MEM_PMS_LOCK at 0 range 0 .. 0;
      Reserved_1_31    at 0 range 1 .. 31;
   end record;

   subtype FLASH_ACE0_ATTR_FLASH_ACE0_ATTR_Field is ESP32_C3.UInt2;

   --  APB_CTRL_FLASH_ACE0_ATTR_REG
   type FLASH_ACE0_ATTR_Register is record
      --  reg_flash_ace0_attr
      FLASH_ACE0_ATTR : FLASH_ACE0_ATTR_FLASH_ACE0_ATTR_Field := 16#3#;
      --  unspecified
      Reserved_2_31   : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_ACE0_ATTR_Register use record
      FLASH_ACE0_ATTR at 0 range 0 .. 1;
      Reserved_2_31   at 0 range 2 .. 31;
   end record;

   subtype FLASH_ACE1_ATTR_FLASH_ACE1_ATTR_Field is ESP32_C3.UInt2;

   --  APB_CTRL_FLASH_ACE1_ATTR_REG
   type FLASH_ACE1_ATTR_Register is record
      --  reg_flash_ace1_attr
      FLASH_ACE1_ATTR : FLASH_ACE1_ATTR_FLASH_ACE1_ATTR_Field := 16#3#;
      --  unspecified
      Reserved_2_31   : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_ACE1_ATTR_Register use record
      FLASH_ACE1_ATTR at 0 range 0 .. 1;
      Reserved_2_31   at 0 range 2 .. 31;
   end record;

   subtype FLASH_ACE2_ATTR_FLASH_ACE2_ATTR_Field is ESP32_C3.UInt2;

   --  APB_CTRL_FLASH_ACE2_ATTR_REG
   type FLASH_ACE2_ATTR_Register is record
      --  reg_flash_ace2_attr
      FLASH_ACE2_ATTR : FLASH_ACE2_ATTR_FLASH_ACE2_ATTR_Field := 16#3#;
      --  unspecified
      Reserved_2_31   : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_ACE2_ATTR_Register use record
      FLASH_ACE2_ATTR at 0 range 0 .. 1;
      Reserved_2_31   at 0 range 2 .. 31;
   end record;

   subtype FLASH_ACE3_ATTR_FLASH_ACE3_ATTR_Field is ESP32_C3.UInt2;

   --  APB_CTRL_FLASH_ACE3_ATTR_REG
   type FLASH_ACE3_ATTR_Register is record
      --  reg_flash_ace3_attr
      FLASH_ACE3_ATTR : FLASH_ACE3_ATTR_FLASH_ACE3_ATTR_Field := 16#3#;
      --  unspecified
      Reserved_2_31   : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_ACE3_ATTR_Register use record
      FLASH_ACE3_ATTR at 0 range 0 .. 1;
      Reserved_2_31   at 0 range 2 .. 31;
   end record;

   subtype FLASH_ACE0_SIZE_FLASH_ACE0_SIZE_Field is ESP32_C3.UInt13;

   --  APB_CTRL_FLASH_ACE0_SIZE_REG
   type FLASH_ACE0_SIZE_Register is record
      --  reg_flash_ace0_size
      FLASH_ACE0_SIZE : FLASH_ACE0_SIZE_FLASH_ACE0_SIZE_Field := 16#400#;
      --  unspecified
      Reserved_13_31  : ESP32_C3.UInt19 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_ACE0_SIZE_Register use record
      FLASH_ACE0_SIZE at 0 range 0 .. 12;
      Reserved_13_31  at 0 range 13 .. 31;
   end record;

   subtype FLASH_ACE1_SIZE_FLASH_ACE1_SIZE_Field is ESP32_C3.UInt13;

   --  APB_CTRL_FLASH_ACE1_SIZE_REG
   type FLASH_ACE1_SIZE_Register is record
      --  reg_flash_ace1_size
      FLASH_ACE1_SIZE : FLASH_ACE1_SIZE_FLASH_ACE1_SIZE_Field := 16#400#;
      --  unspecified
      Reserved_13_31  : ESP32_C3.UInt19 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_ACE1_SIZE_Register use record
      FLASH_ACE1_SIZE at 0 range 0 .. 12;
      Reserved_13_31  at 0 range 13 .. 31;
   end record;

   subtype FLASH_ACE2_SIZE_FLASH_ACE2_SIZE_Field is ESP32_C3.UInt13;

   --  APB_CTRL_FLASH_ACE2_SIZE_REG
   type FLASH_ACE2_SIZE_Register is record
      --  reg_flash_ace2_size
      FLASH_ACE2_SIZE : FLASH_ACE2_SIZE_FLASH_ACE2_SIZE_Field := 16#400#;
      --  unspecified
      Reserved_13_31  : ESP32_C3.UInt19 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_ACE2_SIZE_Register use record
      FLASH_ACE2_SIZE at 0 range 0 .. 12;
      Reserved_13_31  at 0 range 13 .. 31;
   end record;

   subtype FLASH_ACE3_SIZE_FLASH_ACE3_SIZE_Field is ESP32_C3.UInt13;

   --  APB_CTRL_FLASH_ACE3_SIZE_REG
   type FLASH_ACE3_SIZE_Register is record
      --  reg_flash_ace3_size
      FLASH_ACE3_SIZE : FLASH_ACE3_SIZE_FLASH_ACE3_SIZE_Field := 16#400#;
      --  unspecified
      Reserved_13_31  : ESP32_C3.UInt19 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_ACE3_SIZE_Register use record
      FLASH_ACE3_SIZE at 0 range 0 .. 12;
      Reserved_13_31  at 0 range 13 .. 31;
   end record;

   subtype SPI_MEM_PMS_CTRL_SPI_MEM_REJECT_INT_Field is ESP32_C3.Bit;
   subtype SPI_MEM_PMS_CTRL_SPI_MEM_REJECT_CLR_Field is ESP32_C3.Bit;
   subtype SPI_MEM_PMS_CTRL_SPI_MEM_REJECT_CDE_Field is ESP32_C3.UInt5;

   --  APB_CTRL_SPI_MEM_PMS_CTRL_REG
   type SPI_MEM_PMS_CTRL_Register is record
      --  Read-only. reg_spi_mem_reject_int
      SPI_MEM_REJECT_INT : SPI_MEM_PMS_CTRL_SPI_MEM_REJECT_INT_Field := 16#0#;
      --  Write-only. reg_spi_mem_reject_clr
      SPI_MEM_REJECT_CLR : SPI_MEM_PMS_CTRL_SPI_MEM_REJECT_CLR_Field := 16#0#;
      --  Read-only. reg_spi_mem_reject_cde
      SPI_MEM_REJECT_CDE : SPI_MEM_PMS_CTRL_SPI_MEM_REJECT_CDE_Field := 16#0#;
      --  unspecified
      Reserved_7_31      : ESP32_C3.UInt25 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SPI_MEM_PMS_CTRL_Register use record
      SPI_MEM_REJECT_INT at 0 range 0 .. 0;
      SPI_MEM_REJECT_CLR at 0 range 1 .. 1;
      SPI_MEM_REJECT_CDE at 0 range 2 .. 6;
      Reserved_7_31      at 0 range 7 .. 31;
   end record;

   subtype SDIO_CTRL_SDIO_WIN_ACCESS_EN_Field is ESP32_C3.Bit;

   --  APB_CTRL_SDIO_CTRL_REG
   type SDIO_CTRL_Register is record
      --  reg_sdio_win_access_en
      SDIO_WIN_ACCESS_EN : SDIO_CTRL_SDIO_WIN_ACCESS_EN_Field := 16#0#;
      --  unspecified
      Reserved_1_31      : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDIO_CTRL_Register use record
      SDIO_WIN_ACCESS_EN at 0 range 0 .. 0;
      Reserved_1_31      at 0 range 1 .. 31;
   end record;

   subtype REDCY_SIG0_REDCY_SIG0_Field is ESP32_C3.UInt31;
   subtype REDCY_SIG0_REDCY_ANDOR_Field is ESP32_C3.Bit;

   --  APB_CTRL_REDCY_SIG0_REG_REG
   type REDCY_SIG0_Register is record
      --  reg_redcy_sig0
      REDCY_SIG0  : REDCY_SIG0_REDCY_SIG0_Field := 16#0#;
      --  Read-only. reg_redcy_andor
      REDCY_ANDOR : REDCY_SIG0_REDCY_ANDOR_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REDCY_SIG0_Register use record
      REDCY_SIG0  at 0 range 0 .. 30;
      REDCY_ANDOR at 0 range 31 .. 31;
   end record;

   subtype REDCY_SIG1_REDCY_SIG1_Field is ESP32_C3.UInt31;
   subtype REDCY_SIG1_REDCY_NANDOR_Field is ESP32_C3.Bit;

   --  APB_CTRL_REDCY_SIG1_REG_REG
   type REDCY_SIG1_Register is record
      --  reg_redcy_sig1
      REDCY_SIG1   : REDCY_SIG1_REDCY_SIG1_Field := 16#0#;
      --  Read-only. reg_redcy_nandor
      REDCY_NANDOR : REDCY_SIG1_REDCY_NANDOR_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REDCY_SIG1_Register use record
      REDCY_SIG1   at 0 range 0 .. 30;
      REDCY_NANDOR at 0 range 31 .. 31;
   end record;

   subtype FRONT_END_MEM_PD_AGC_MEM_FORCE_PU_Field is ESP32_C3.Bit;
   subtype FRONT_END_MEM_PD_AGC_MEM_FORCE_PD_Field is ESP32_C3.Bit;
   subtype FRONT_END_MEM_PD_PBUS_MEM_FORCE_PU_Field is ESP32_C3.Bit;
   subtype FRONT_END_MEM_PD_PBUS_MEM_FORCE_PD_Field is ESP32_C3.Bit;
   subtype FRONT_END_MEM_PD_DC_MEM_FORCE_PU_Field is ESP32_C3.Bit;
   subtype FRONT_END_MEM_PD_DC_MEM_FORCE_PD_Field is ESP32_C3.Bit;

   --  APB_CTRL_FRONT_END_MEM_PD_REG
   type FRONT_END_MEM_PD_Register is record
      --  reg_agc_mem_force_pu
      AGC_MEM_FORCE_PU  : FRONT_END_MEM_PD_AGC_MEM_FORCE_PU_Field := 16#1#;
      --  reg_agc_mem_force_pd
      AGC_MEM_FORCE_PD  : FRONT_END_MEM_PD_AGC_MEM_FORCE_PD_Field := 16#0#;
      --  reg_pbus_mem_force_pu
      PBUS_MEM_FORCE_PU : FRONT_END_MEM_PD_PBUS_MEM_FORCE_PU_Field := 16#1#;
      --  reg_pbus_mem_force_pd
      PBUS_MEM_FORCE_PD : FRONT_END_MEM_PD_PBUS_MEM_FORCE_PD_Field := 16#0#;
      --  reg_dc_mem_force_pu
      DC_MEM_FORCE_PU   : FRONT_END_MEM_PD_DC_MEM_FORCE_PU_Field := 16#1#;
      --  reg_dc_mem_force_pd
      DC_MEM_FORCE_PD   : FRONT_END_MEM_PD_DC_MEM_FORCE_PD_Field := 16#0#;
      --  unspecified
      Reserved_6_31     : ESP32_C3.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FRONT_END_MEM_PD_Register use record
      AGC_MEM_FORCE_PU  at 0 range 0 .. 0;
      AGC_MEM_FORCE_PD  at 0 range 1 .. 1;
      PBUS_MEM_FORCE_PU at 0 range 2 .. 2;
      PBUS_MEM_FORCE_PD at 0 range 3 .. 3;
      DC_MEM_FORCE_PU   at 0 range 4 .. 4;
      DC_MEM_FORCE_PD   at 0 range 5 .. 5;
      Reserved_6_31     at 0 range 6 .. 31;
   end record;

   subtype RETENTION_CTRL_RETENTION_LINK_ADDR_Field is ESP32_C3.UInt27;
   subtype RETENTION_CTRL_NOBYPASS_CPU_ISO_RST_Field is ESP32_C3.Bit;

   --  APB_CTRL_RETENTION_CTRL_REG
   type RETENTION_CTRL_Register is record
      --  reg_retention_link_addr
      RETENTION_LINK_ADDR  : RETENTION_CTRL_RETENTION_LINK_ADDR_Field :=
                              16#0#;
      --  reg_nobypass_cpu_iso_rst
      NOBYPASS_CPU_ISO_RST : RETENTION_CTRL_NOBYPASS_CPU_ISO_RST_Field :=
                              16#0#;
      --  unspecified
      Reserved_28_31       : ESP32_C3.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RETENTION_CTRL_Register use record
      RETENTION_LINK_ADDR  at 0 range 0 .. 26;
      NOBYPASS_CPU_ISO_RST at 0 range 27 .. 27;
      Reserved_28_31       at 0 range 28 .. 31;
   end record;

   subtype CLKGATE_FORCE_ON_ROM_CLKGATE_FORCE_ON_Field is ESP32_C3.UInt2;
   subtype CLKGATE_FORCE_ON_SRAM_CLKGATE_FORCE_ON_Field is ESP32_C3.UInt4;

   --  APB_CTRL_CLKGATE_FORCE_ON_REG
   type CLKGATE_FORCE_ON_Register is record
      --  reg_rom_clkgate_force_on
      ROM_CLKGATE_FORCE_ON  : CLKGATE_FORCE_ON_ROM_CLKGATE_FORCE_ON_Field :=
                               16#3#;
      --  reg_sram_clkgate_force_on
      SRAM_CLKGATE_FORCE_ON : CLKGATE_FORCE_ON_SRAM_CLKGATE_FORCE_ON_Field :=
                               16#F#;
      --  unspecified
      Reserved_6_31         : ESP32_C3.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CLKGATE_FORCE_ON_Register use record
      ROM_CLKGATE_FORCE_ON  at 0 range 0 .. 1;
      SRAM_CLKGATE_FORCE_ON at 0 range 2 .. 5;
      Reserved_6_31         at 0 range 6 .. 31;
   end record;

   subtype MEM_POWER_DOWN_ROM_POWER_DOWN_Field is ESP32_C3.UInt2;
   subtype MEM_POWER_DOWN_SRAM_POWER_DOWN_Field is ESP32_C3.UInt4;

   --  APB_CTRL_MEM_POWER_DOWN_REG
   type MEM_POWER_DOWN_Register is record
      --  reg_rom_power_down
      ROM_POWER_DOWN  : MEM_POWER_DOWN_ROM_POWER_DOWN_Field := 16#0#;
      --  reg_sram_power_down
      SRAM_POWER_DOWN : MEM_POWER_DOWN_SRAM_POWER_DOWN_Field := 16#0#;
      --  unspecified
      Reserved_6_31   : ESP32_C3.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for MEM_POWER_DOWN_Register use record
      ROM_POWER_DOWN  at 0 range 0 .. 1;
      SRAM_POWER_DOWN at 0 range 2 .. 5;
      Reserved_6_31   at 0 range 6 .. 31;
   end record;

   subtype MEM_POWER_UP_ROM_POWER_UP_Field is ESP32_C3.UInt2;
   subtype MEM_POWER_UP_SRAM_POWER_UP_Field is ESP32_C3.UInt4;

   --  APB_CTRL_MEM_POWER_UP_REG
   type MEM_POWER_UP_Register is record
      --  reg_rom_power_up
      ROM_POWER_UP  : MEM_POWER_UP_ROM_POWER_UP_Field := 16#3#;
      --  reg_sram_power_up
      SRAM_POWER_UP : MEM_POWER_UP_SRAM_POWER_UP_Field := 16#F#;
      --  unspecified
      Reserved_6_31 : ESP32_C3.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for MEM_POWER_UP_Register use record
      ROM_POWER_UP  at 0 range 0 .. 1;
      SRAM_POWER_UP at 0 range 2 .. 5;
      Reserved_6_31 at 0 range 6 .. 31;
   end record;

   subtype PERI_BACKUP_CONFIG_PERI_BACKUP_FLOW_ERR_Field is ESP32_C3.UInt2;
   subtype PERI_BACKUP_CONFIG_PERI_BACKUP_BURST_LIMIT_Field is ESP32_C3.UInt5;
   subtype PERI_BACKUP_CONFIG_PERI_BACKUP_TOUT_THRES_Field is ESP32_C3.UInt10;
   subtype PERI_BACKUP_CONFIG_PERI_BACKUP_SIZE_Field is ESP32_C3.UInt10;
   subtype PERI_BACKUP_CONFIG_PERI_BACKUP_START_Field is ESP32_C3.Bit;
   subtype PERI_BACKUP_CONFIG_PERI_BACKUP_TO_MEM_Field is ESP32_C3.Bit;
   subtype PERI_BACKUP_CONFIG_PERI_BACKUP_ENA_Field is ESP32_C3.Bit;

   --  APB_CTRL_PERI_BACKUP_CONFIG_REG_REG
   type PERI_BACKUP_CONFIG_Register is record
      --  unspecified
      Reserved_0_0            : ESP32_C3.Bit := 16#0#;
      --  Read-only. reg_peri_backup_flow_err
      PERI_BACKUP_FLOW_ERR    : PERI_BACKUP_CONFIG_PERI_BACKUP_FLOW_ERR_Field :=
                                 16#0#;
      --  unspecified
      Reserved_3_3            : ESP32_C3.Bit := 16#0#;
      --  reg_peri_backup_burst_limit
      PERI_BACKUP_BURST_LIMIT : PERI_BACKUP_CONFIG_PERI_BACKUP_BURST_LIMIT_Field :=
                                 16#8#;
      --  reg_peri_backup_tout_thres
      PERI_BACKUP_TOUT_THRES  : PERI_BACKUP_CONFIG_PERI_BACKUP_TOUT_THRES_Field :=
                                 16#32#;
      --  reg_peri_backup_size
      PERI_BACKUP_SIZE        : PERI_BACKUP_CONFIG_PERI_BACKUP_SIZE_Field :=
                                 16#0#;
      --  Write-only. reg_peri_backup_start
      PERI_BACKUP_START       : PERI_BACKUP_CONFIG_PERI_BACKUP_START_Field :=
                                 16#0#;
      --  reg_peri_backup_to_mem
      PERI_BACKUP_TO_MEM      : PERI_BACKUP_CONFIG_PERI_BACKUP_TO_MEM_Field :=
                                 16#0#;
      --  reg_peri_backup_ena
      PERI_BACKUP_ENA         : PERI_BACKUP_CONFIG_PERI_BACKUP_ENA_Field :=
                                 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PERI_BACKUP_CONFIG_Register use record
      Reserved_0_0            at 0 range 0 .. 0;
      PERI_BACKUP_FLOW_ERR    at 0 range 1 .. 2;
      Reserved_3_3            at 0 range 3 .. 3;
      PERI_BACKUP_BURST_LIMIT at 0 range 4 .. 8;
      PERI_BACKUP_TOUT_THRES  at 0 range 9 .. 18;
      PERI_BACKUP_SIZE        at 0 range 19 .. 28;
      PERI_BACKUP_START       at 0 range 29 .. 29;
      PERI_BACKUP_TO_MEM      at 0 range 30 .. 30;
      PERI_BACKUP_ENA         at 0 range 31 .. 31;
   end record;

   subtype PERI_BACKUP_INT_RAW_PERI_BACKUP_DONE_INT_RAW_Field is ESP32_C3.Bit;
   subtype PERI_BACKUP_INT_RAW_PERI_BACKUP_ERR_INT_RAW_Field is ESP32_C3.Bit;

   --  APB_CTRL_PERI_BACKUP_INT_RAW_REG
   type PERI_BACKUP_INT_RAW_Register is record
      --  Read-only. reg_peri_backup_done_int_raw
      PERI_BACKUP_DONE_INT_RAW : PERI_BACKUP_INT_RAW_PERI_BACKUP_DONE_INT_RAW_Field;
      --  Read-only. reg_peri_backup_err_int_raw
      PERI_BACKUP_ERR_INT_RAW  : PERI_BACKUP_INT_RAW_PERI_BACKUP_ERR_INT_RAW_Field;
      --  unspecified
      Reserved_2_31            : ESP32_C3.UInt30;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PERI_BACKUP_INT_RAW_Register use record
      PERI_BACKUP_DONE_INT_RAW at 0 range 0 .. 0;
      PERI_BACKUP_ERR_INT_RAW  at 0 range 1 .. 1;
      Reserved_2_31            at 0 range 2 .. 31;
   end record;

   subtype PERI_BACKUP_INT_ST_PERI_BACKUP_DONE_INT_ST_Field is ESP32_C3.Bit;
   subtype PERI_BACKUP_INT_ST_PERI_BACKUP_ERR_INT_ST_Field is ESP32_C3.Bit;

   --  APB_CTRL_PERI_BACKUP_INT_ST_REG
   type PERI_BACKUP_INT_ST_Register is record
      --  Read-only. reg_peri_backup_done_int_st
      PERI_BACKUP_DONE_INT_ST : PERI_BACKUP_INT_ST_PERI_BACKUP_DONE_INT_ST_Field;
      --  Read-only. reg_peri_backup_err_int_st
      PERI_BACKUP_ERR_INT_ST  : PERI_BACKUP_INT_ST_PERI_BACKUP_ERR_INT_ST_Field;
      --  unspecified
      Reserved_2_31           : ESP32_C3.UInt30;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PERI_BACKUP_INT_ST_Register use record
      PERI_BACKUP_DONE_INT_ST at 0 range 0 .. 0;
      PERI_BACKUP_ERR_INT_ST  at 0 range 1 .. 1;
      Reserved_2_31           at 0 range 2 .. 31;
   end record;

   subtype PERI_BACKUP_INT_ENA_PERI_BACKUP_DONE_INT_ENA_Field is ESP32_C3.Bit;
   subtype PERI_BACKUP_INT_ENA_PERI_BACKUP_ERR_INT_ENA_Field is ESP32_C3.Bit;

   --  APB_CTRL_PERI_BACKUP_INT_ENA_REG
   type PERI_BACKUP_INT_ENA_Register is record
      --  reg_peri_backup_done_int_ena
      PERI_BACKUP_DONE_INT_ENA : PERI_BACKUP_INT_ENA_PERI_BACKUP_DONE_INT_ENA_Field :=
                                  16#0#;
      --  reg_peri_backup_err_int_ena
      PERI_BACKUP_ERR_INT_ENA  : PERI_BACKUP_INT_ENA_PERI_BACKUP_ERR_INT_ENA_Field :=
                                  16#0#;
      --  unspecified
      Reserved_2_31            : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PERI_BACKUP_INT_ENA_Register use record
      PERI_BACKUP_DONE_INT_ENA at 0 range 0 .. 0;
      PERI_BACKUP_ERR_INT_ENA  at 0 range 1 .. 1;
      Reserved_2_31            at 0 range 2 .. 31;
   end record;

   subtype PERI_BACKUP_INT_CLR_PERI_BACKUP_DONE_INT_CLR_Field is ESP32_C3.Bit;
   subtype PERI_BACKUP_INT_CLR_PERI_BACKUP_ERR_INT_CLR_Field is ESP32_C3.Bit;

   --  APB_CTRL_PERI_BACKUP_INT_CLR_REG
   type PERI_BACKUP_INT_CLR_Register is record
      --  Write-only. reg_peri_backup_done_int_clr
      PERI_BACKUP_DONE_INT_CLR : PERI_BACKUP_INT_CLR_PERI_BACKUP_DONE_INT_CLR_Field :=
                                  16#0#;
      --  Write-only. reg_peri_backup_err_int_clr
      PERI_BACKUP_ERR_INT_CLR  : PERI_BACKUP_INT_CLR_PERI_BACKUP_ERR_INT_CLR_Field :=
                                  16#0#;
      --  unspecified
      Reserved_2_31            : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PERI_BACKUP_INT_CLR_Register use record
      PERI_BACKUP_DONE_INT_CLR at 0 range 0 .. 0;
      PERI_BACKUP_ERR_INT_CLR  at 0 range 1 .. 1;
      Reserved_2_31            at 0 range 2 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  APB (Advanced Peripheral Bus) Controller
   type APB_CTRL_Peripheral is record
      --  APB_CTRL_SYSCLK_CONF_REG
      SYSCLK_CONF          : aliased SYSCLK_CONF_Register;
      --  APB_CTRL_TICK_CONF_REG
      TICK_CONF            : aliased TICK_CONF_Register;
      --  APB_CTRL_CLK_OUT_EN_REG
      CLK_OUT_EN           : aliased CLK_OUT_EN_Register;
      --  APB_CTRL_WIFI_BB_CFG_REG
      WIFI_BB_CFG          : aliased ESP32_C3.UInt32;
      --  APB_CTRL_WIFI_BB_CFG_2_REG
      WIFI_BB_CFG_2        : aliased ESP32_C3.UInt32;
      --  APB_CTRL_WIFI_CLK_EN_REG
      WIFI_CLK_EN          : aliased ESP32_C3.UInt32;
      --  APB_CTRL_WIFI_RST_EN_REG
      WIFI_RST_EN          : aliased ESP32_C3.UInt32;
      --  APB_CTRL_HOST_INF_SEL_REG
      HOST_INF_SEL         : aliased HOST_INF_SEL_Register;
      --  APB_CTRL_EXT_MEM_PMS_LOCK_REG
      EXT_MEM_PMS_LOCK     : aliased EXT_MEM_PMS_LOCK_Register;
      --  APB_CTRL_FLASH_ACE0_ATTR_REG
      FLASH_ACE0_ATTR      : aliased FLASH_ACE0_ATTR_Register;
      --  APB_CTRL_FLASH_ACE1_ATTR_REG
      FLASH_ACE1_ATTR      : aliased FLASH_ACE1_ATTR_Register;
      --  APB_CTRL_FLASH_ACE2_ATTR_REG
      FLASH_ACE2_ATTR      : aliased FLASH_ACE2_ATTR_Register;
      --  APB_CTRL_FLASH_ACE3_ATTR_REG
      FLASH_ACE3_ATTR      : aliased FLASH_ACE3_ATTR_Register;
      --  APB_CTRL_FLASH_ACE0_ADDR_REG
      FLASH_ACE0_ADDR      : aliased ESP32_C3.UInt32;
      --  APB_CTRL_FLASH_ACE1_ADDR_REG
      FLASH_ACE1_ADDR      : aliased ESP32_C3.UInt32;
      --  APB_CTRL_FLASH_ACE2_ADDR_REG
      FLASH_ACE2_ADDR      : aliased ESP32_C3.UInt32;
      --  APB_CTRL_FLASH_ACE3_ADDR_REG
      FLASH_ACE3_ADDR      : aliased ESP32_C3.UInt32;
      --  APB_CTRL_FLASH_ACE0_SIZE_REG
      FLASH_ACE0_SIZE      : aliased FLASH_ACE0_SIZE_Register;
      --  APB_CTRL_FLASH_ACE1_SIZE_REG
      FLASH_ACE1_SIZE      : aliased FLASH_ACE1_SIZE_Register;
      --  APB_CTRL_FLASH_ACE2_SIZE_REG
      FLASH_ACE2_SIZE      : aliased FLASH_ACE2_SIZE_Register;
      --  APB_CTRL_FLASH_ACE3_SIZE_REG
      FLASH_ACE3_SIZE      : aliased FLASH_ACE3_SIZE_Register;
      --  APB_CTRL_SPI_MEM_PMS_CTRL_REG
      SPI_MEM_PMS_CTRL     : aliased SPI_MEM_PMS_CTRL_Register;
      --  APB_CTRL_SPI_MEM_REJECT_ADDR_REG
      SPI_MEM_REJECT_ADDR  : aliased ESP32_C3.UInt32;
      --  APB_CTRL_SDIO_CTRL_REG
      SDIO_CTRL            : aliased SDIO_CTRL_Register;
      --  APB_CTRL_REDCY_SIG0_REG_REG
      REDCY_SIG0           : aliased REDCY_SIG0_Register;
      --  APB_CTRL_REDCY_SIG1_REG_REG
      REDCY_SIG1           : aliased REDCY_SIG1_Register;
      --  APB_CTRL_FRONT_END_MEM_PD_REG
      FRONT_END_MEM_PD     : aliased FRONT_END_MEM_PD_Register;
      --  APB_CTRL_RETENTION_CTRL_REG
      RETENTION_CTRL       : aliased RETENTION_CTRL_Register;
      --  APB_CTRL_CLKGATE_FORCE_ON_REG
      CLKGATE_FORCE_ON     : aliased CLKGATE_FORCE_ON_Register;
      --  APB_CTRL_MEM_POWER_DOWN_REG
      MEM_POWER_DOWN       : aliased MEM_POWER_DOWN_Register;
      --  APB_CTRL_MEM_POWER_UP_REG
      MEM_POWER_UP         : aliased MEM_POWER_UP_Register;
      --  APB_CTRL_RND_DATA_REG
      RND_DATA             : aliased ESP32_C3.UInt32;
      --  APB_CTRL_PERI_BACKUP_CONFIG_REG_REG
      PERI_BACKUP_CONFIG   : aliased PERI_BACKUP_CONFIG_Register;
      --  APB_CTRL_PERI_BACKUP_APB_ADDR_REG_REG
      PERI_BACKUP_APB_ADDR : aliased ESP32_C3.UInt32;
      --  APB_CTRL_PERI_BACKUP_MEM_ADDR_REG_REG
      PERI_BACKUP_MEM_ADDR : aliased ESP32_C3.UInt32;
      --  APB_CTRL_PERI_BACKUP_INT_RAW_REG
      PERI_BACKUP_INT_RAW  : aliased PERI_BACKUP_INT_RAW_Register;
      --  APB_CTRL_PERI_BACKUP_INT_ST_REG
      PERI_BACKUP_INT_ST   : aliased PERI_BACKUP_INT_ST_Register;
      --  APB_CTRL_PERI_BACKUP_INT_ENA_REG
      PERI_BACKUP_INT_ENA  : aliased PERI_BACKUP_INT_ENA_Register;
      --  APB_CTRL_PERI_BACKUP_INT_CLR_REG
      PERI_BACKUP_INT_CLR  : aliased PERI_BACKUP_INT_CLR_Register;
      --  APB_CTRL_DATE_REG
      DATE                 : aliased ESP32_C3.UInt32;
   end record
     with Volatile;

   for APB_CTRL_Peripheral use record
      SYSCLK_CONF          at 16#0# range 0 .. 31;
      TICK_CONF            at 16#4# range 0 .. 31;
      CLK_OUT_EN           at 16#8# range 0 .. 31;
      WIFI_BB_CFG          at 16#C# range 0 .. 31;
      WIFI_BB_CFG_2        at 16#10# range 0 .. 31;
      WIFI_CLK_EN          at 16#14# range 0 .. 31;
      WIFI_RST_EN          at 16#18# range 0 .. 31;
      HOST_INF_SEL         at 16#1C# range 0 .. 31;
      EXT_MEM_PMS_LOCK     at 16#20# range 0 .. 31;
      FLASH_ACE0_ATTR      at 16#28# range 0 .. 31;
      FLASH_ACE1_ATTR      at 16#2C# range 0 .. 31;
      FLASH_ACE2_ATTR      at 16#30# range 0 .. 31;
      FLASH_ACE3_ATTR      at 16#34# range 0 .. 31;
      FLASH_ACE0_ADDR      at 16#38# range 0 .. 31;
      FLASH_ACE1_ADDR      at 16#3C# range 0 .. 31;
      FLASH_ACE2_ADDR      at 16#40# range 0 .. 31;
      FLASH_ACE3_ADDR      at 16#44# range 0 .. 31;
      FLASH_ACE0_SIZE      at 16#48# range 0 .. 31;
      FLASH_ACE1_SIZE      at 16#4C# range 0 .. 31;
      FLASH_ACE2_SIZE      at 16#50# range 0 .. 31;
      FLASH_ACE3_SIZE      at 16#54# range 0 .. 31;
      SPI_MEM_PMS_CTRL     at 16#88# range 0 .. 31;
      SPI_MEM_REJECT_ADDR  at 16#8C# range 0 .. 31;
      SDIO_CTRL            at 16#90# range 0 .. 31;
      REDCY_SIG0           at 16#94# range 0 .. 31;
      REDCY_SIG1           at 16#98# range 0 .. 31;
      FRONT_END_MEM_PD     at 16#9C# range 0 .. 31;
      RETENTION_CTRL       at 16#A0# range 0 .. 31;
      CLKGATE_FORCE_ON     at 16#A4# range 0 .. 31;
      MEM_POWER_DOWN       at 16#A8# range 0 .. 31;
      MEM_POWER_UP         at 16#AC# range 0 .. 31;
      RND_DATA             at 16#B0# range 0 .. 31;
      PERI_BACKUP_CONFIG   at 16#B4# range 0 .. 31;
      PERI_BACKUP_APB_ADDR at 16#B8# range 0 .. 31;
      PERI_BACKUP_MEM_ADDR at 16#BC# range 0 .. 31;
      PERI_BACKUP_INT_RAW  at 16#C0# range 0 .. 31;
      PERI_BACKUP_INT_ST   at 16#C4# range 0 .. 31;
      PERI_BACKUP_INT_ENA  at 16#C8# range 0 .. 31;
      PERI_BACKUP_INT_CLR  at 16#D0# range 0 .. 31;
      DATE                 at 16#3FC# range 0 .. 31;
   end record;

   --  APB (Advanced Peripheral Bus) Controller
   APB_CTRL_Periph : aliased APB_CTRL_Peripheral
     with Import, Address => APB_CTRL_Base;

end ESP32_C3.APB_CTRL;
