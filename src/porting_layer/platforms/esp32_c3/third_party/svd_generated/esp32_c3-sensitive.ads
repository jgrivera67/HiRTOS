pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.SENSITIVE is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype ROM_TABLE_LOCK_ROM_TABLE_LOCK_Field is ESP32_C3.Bit;

   --  SENSITIVE_ROM_TABLE_LOCK_REG
   type ROM_TABLE_LOCK_Register is record
      --  rom_table_lock
      ROM_TABLE_LOCK : ROM_TABLE_LOCK_ROM_TABLE_LOCK_Field := 16#0#;
      --  unspecified
      Reserved_1_31  : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ROM_TABLE_LOCK_Register use record
      ROM_TABLE_LOCK at 0 range 0 .. 0;
      Reserved_1_31  at 0 range 1 .. 31;
   end record;

   subtype PRIVILEGE_MODE_SEL_LOCK_PRIVILEGE_MODE_SEL_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_PRIVILEGE_MODE_SEL_LOCK_REG
   type PRIVILEGE_MODE_SEL_LOCK_Register is record
      --  privilege_mode_sel_lock
      PRIVILEGE_MODE_SEL_LOCK : PRIVILEGE_MODE_SEL_LOCK_PRIVILEGE_MODE_SEL_LOCK_Field :=
                                 16#0#;
      --  unspecified
      Reserved_1_31           : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PRIVILEGE_MODE_SEL_LOCK_Register use record
      PRIVILEGE_MODE_SEL_LOCK at 0 range 0 .. 0;
      Reserved_1_31           at 0 range 1 .. 31;
   end record;

   subtype PRIVILEGE_MODE_SEL_PRIVILEGE_MODE_SEL_Field is ESP32_C3.Bit;

   --  SENSITIVE_PRIVILEGE_MODE_SEL_REG
   type PRIVILEGE_MODE_SEL_Register is record
      --  privilege_mode_sel
      PRIVILEGE_MODE_SEL : PRIVILEGE_MODE_SEL_PRIVILEGE_MODE_SEL_Field :=
                            16#0#;
      --  unspecified
      Reserved_1_31      : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PRIVILEGE_MODE_SEL_Register use record
      PRIVILEGE_MODE_SEL at 0 range 0 .. 0;
      Reserved_1_31      at 0 range 1 .. 31;
   end record;

   subtype APB_PERIPHERAL_ACCESS_0_APB_PERIPHERAL_ACCESS_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_APB_PERIPHERAL_ACCESS_0_REG
   type APB_PERIPHERAL_ACCESS_0_Register is record
      --  apb_peripheral_access_lock
      APB_PERIPHERAL_ACCESS_LOCK : APB_PERIPHERAL_ACCESS_0_APB_PERIPHERAL_ACCESS_LOCK_Field :=
                                    16#0#;
      --  unspecified
      Reserved_1_31              : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for APB_PERIPHERAL_ACCESS_0_Register use record
      APB_PERIPHERAL_ACCESS_LOCK at 0 range 0 .. 0;
      Reserved_1_31              at 0 range 1 .. 31;
   end record;

   subtype APB_PERIPHERAL_ACCESS_1_APB_PERIPHERAL_ACCESS_SPLIT_BURST_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_APB_PERIPHERAL_ACCESS_1_REG
   type APB_PERIPHERAL_ACCESS_1_Register is record
      --  apb_peripheral_access_split_burst
      APB_PERIPHERAL_ACCESS_SPLIT_BURST : APB_PERIPHERAL_ACCESS_1_APB_PERIPHERAL_ACCESS_SPLIT_BURST_Field :=
                                           16#1#;
      --  unspecified
      Reserved_1_31                     : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for APB_PERIPHERAL_ACCESS_1_Register use record
      APB_PERIPHERAL_ACCESS_SPLIT_BURST at 0 range 0 .. 0;
      Reserved_1_31                     at 0 range 1 .. 31;
   end record;

   subtype INTERNAL_SRAM_USAGE_0_INTERNAL_SRAM_USAGE_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_INTERNAL_SRAM_USAGE_0_REG
   type INTERNAL_SRAM_USAGE_0_Register is record
      --  internal_sram_usage_lock
      INTERNAL_SRAM_USAGE_LOCK : INTERNAL_SRAM_USAGE_0_INTERNAL_SRAM_USAGE_LOCK_Field :=
                                  16#0#;
      --  unspecified
      Reserved_1_31            : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INTERNAL_SRAM_USAGE_0_Register use record
      INTERNAL_SRAM_USAGE_LOCK at 0 range 0 .. 0;
      Reserved_1_31            at 0 range 1 .. 31;
   end record;

   subtype INTERNAL_SRAM_USAGE_1_INTERNAL_SRAM_USAGE_CPU_CACHE_Field is
     ESP32_C3.Bit;
   subtype INTERNAL_SRAM_USAGE_1_INTERNAL_SRAM_USAGE_CPU_SRAM_Field is
     ESP32_C3.UInt3;

   --  SENSITIVE_INTERNAL_SRAM_USAGE_1_REG
   type INTERNAL_SRAM_USAGE_1_Register is record
      --  internal_sram_usage_cpu_cache
      INTERNAL_SRAM_USAGE_CPU_CACHE : INTERNAL_SRAM_USAGE_1_INTERNAL_SRAM_USAGE_CPU_CACHE_Field :=
                                       16#1#;
      --  internal_sram_usage_cpu_sram
      INTERNAL_SRAM_USAGE_CPU_SRAM  : INTERNAL_SRAM_USAGE_1_INTERNAL_SRAM_USAGE_CPU_SRAM_Field :=
                                       16#7#;
      --  unspecified
      Reserved_4_31                 : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INTERNAL_SRAM_USAGE_1_Register use record
      INTERNAL_SRAM_USAGE_CPU_CACHE at 0 range 0 .. 0;
      INTERNAL_SRAM_USAGE_CPU_SRAM  at 0 range 1 .. 3;
      Reserved_4_31                 at 0 range 4 .. 31;
   end record;

   subtype INTERNAL_SRAM_USAGE_3_INTERNAL_SRAM_USAGE_MAC_DUMP_SRAM_Field is
     ESP32_C3.UInt3;
   subtype INTERNAL_SRAM_USAGE_3_INTERNAL_SRAM_ALLOC_MAC_DUMP_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_INTERNAL_SRAM_USAGE_3_REG
   type INTERNAL_SRAM_USAGE_3_Register is record
      --  internal_sram_usage_mac_dump_sram
      INTERNAL_SRAM_USAGE_MAC_DUMP_SRAM : INTERNAL_SRAM_USAGE_3_INTERNAL_SRAM_USAGE_MAC_DUMP_SRAM_Field :=
                                           16#0#;
      --  internal_sram_alloc_mac_dump
      INTERNAL_SRAM_ALLOC_MAC_DUMP      : INTERNAL_SRAM_USAGE_3_INTERNAL_SRAM_ALLOC_MAC_DUMP_Field :=
                                           16#0#;
      --  unspecified
      Reserved_4_31                     : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INTERNAL_SRAM_USAGE_3_Register use record
      INTERNAL_SRAM_USAGE_MAC_DUMP_SRAM at 0 range 0 .. 2;
      INTERNAL_SRAM_ALLOC_MAC_DUMP      at 0 range 3 .. 3;
      Reserved_4_31                     at 0 range 4 .. 31;
   end record;

   subtype INTERNAL_SRAM_USAGE_4_INTERNAL_SRAM_USAGE_LOG_SRAM_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_INTERNAL_SRAM_USAGE_4_REG
   type INTERNAL_SRAM_USAGE_4_Register is record
      --  internal_sram_usage_log_sram
      INTERNAL_SRAM_USAGE_LOG_SRAM : INTERNAL_SRAM_USAGE_4_INTERNAL_SRAM_USAGE_LOG_SRAM_Field :=
                                      16#0#;
      --  unspecified
      Reserved_1_31                : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INTERNAL_SRAM_USAGE_4_Register use record
      INTERNAL_SRAM_USAGE_LOG_SRAM at 0 range 0 .. 0;
      Reserved_1_31                at 0 range 1 .. 31;
   end record;

   subtype CACHE_TAG_ACCESS_0_CACHE_TAG_ACCESS_LOCK_Field is ESP32_C3.Bit;

   --  SENSITIVE_CACHE_TAG_ACCESS_0_REG
   type CACHE_TAG_ACCESS_0_Register is record
      --  cache_tag_access_lock
      CACHE_TAG_ACCESS_LOCK : CACHE_TAG_ACCESS_0_CACHE_TAG_ACCESS_LOCK_Field :=
                               16#0#;
      --  unspecified
      Reserved_1_31         : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_TAG_ACCESS_0_Register use record
      CACHE_TAG_ACCESS_LOCK at 0 range 0 .. 0;
      Reserved_1_31         at 0 range 1 .. 31;
   end record;

   subtype CACHE_TAG_ACCESS_1_PRO_I_TAG_RD_ACS_Field is ESP32_C3.Bit;
   subtype CACHE_TAG_ACCESS_1_PRO_I_TAG_WR_ACS_Field is ESP32_C3.Bit;
   subtype CACHE_TAG_ACCESS_1_PRO_D_TAG_RD_ACS_Field is ESP32_C3.Bit;
   subtype CACHE_TAG_ACCESS_1_PRO_D_TAG_WR_ACS_Field is ESP32_C3.Bit;

   --  SENSITIVE_CACHE_TAG_ACCESS_1_REG
   type CACHE_TAG_ACCESS_1_Register is record
      --  pro_i_tag_rd_acs
      PRO_I_TAG_RD_ACS : CACHE_TAG_ACCESS_1_PRO_I_TAG_RD_ACS_Field := 16#1#;
      --  pro_i_tag_wr_acs
      PRO_I_TAG_WR_ACS : CACHE_TAG_ACCESS_1_PRO_I_TAG_WR_ACS_Field := 16#1#;
      --  pro_d_tag_rd_acs
      PRO_D_TAG_RD_ACS : CACHE_TAG_ACCESS_1_PRO_D_TAG_RD_ACS_Field := 16#1#;
      --  pro_d_tag_wr_acs
      PRO_D_TAG_WR_ACS : CACHE_TAG_ACCESS_1_PRO_D_TAG_WR_ACS_Field := 16#1#;
      --  unspecified
      Reserved_4_31    : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_TAG_ACCESS_1_Register use record
      PRO_I_TAG_RD_ACS at 0 range 0 .. 0;
      PRO_I_TAG_WR_ACS at 0 range 1 .. 1;
      PRO_D_TAG_RD_ACS at 0 range 2 .. 2;
      PRO_D_TAG_WR_ACS at 0 range 3 .. 3;
      Reserved_4_31    at 0 range 4 .. 31;
   end record;

   subtype CACHE_MMU_ACCESS_0_CACHE_MMU_ACCESS_LOCK_Field is ESP32_C3.Bit;

   --  SENSITIVE_CACHE_MMU_ACCESS_0_REG
   type CACHE_MMU_ACCESS_0_Register is record
      --  cache_mmu_access_lock
      CACHE_MMU_ACCESS_LOCK : CACHE_MMU_ACCESS_0_CACHE_MMU_ACCESS_LOCK_Field :=
                               16#0#;
      --  unspecified
      Reserved_1_31         : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_MMU_ACCESS_0_Register use record
      CACHE_MMU_ACCESS_LOCK at 0 range 0 .. 0;
      Reserved_1_31         at 0 range 1 .. 31;
   end record;

   subtype CACHE_MMU_ACCESS_1_PRO_MMU_RD_ACS_Field is ESP32_C3.Bit;
   subtype CACHE_MMU_ACCESS_1_PRO_MMU_WR_ACS_Field is ESP32_C3.Bit;

   --  SENSITIVE_CACHE_MMU_ACCESS_1_REG
   type CACHE_MMU_ACCESS_1_Register is record
      --  pro_mmu_rd_acs
      PRO_MMU_RD_ACS : CACHE_MMU_ACCESS_1_PRO_MMU_RD_ACS_Field := 16#1#;
      --  pro_mmu_wr_acs
      PRO_MMU_WR_ACS : CACHE_MMU_ACCESS_1_PRO_MMU_WR_ACS_Field := 16#1#;
      --  unspecified
      Reserved_2_31  : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_MMU_ACCESS_1_Register use record
      PRO_MMU_RD_ACS at 0 range 0 .. 0;
      PRO_MMU_WR_ACS at 0 range 1 .. 1;
      Reserved_2_31  at 0 range 2 .. 31;
   end record;

   subtype DMA_APBPERI_SPI2_PMS_CONSTRAIN_0_DMA_APBPERI_SPI2_PMS_CONSTRAIN_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_DMA_APBPERI_SPI2_PMS_CONSTRAIN_0_REG
   type DMA_APBPERI_SPI2_PMS_CONSTRAIN_0_Register is record
      --  dma_apbperi_spi2_pms_constrain_lock
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_LOCK : DMA_APBPERI_SPI2_PMS_CONSTRAIN_0_DMA_APBPERI_SPI2_PMS_CONSTRAIN_LOCK_Field :=
                                             16#0#;
      --  unspecified
      Reserved_1_31                       : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_SPI2_PMS_CONSTRAIN_0_Register use record
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_LOCK at 0 range 0 .. 0;
      Reserved_1_31                       at 0 range 1 .. 31;
   end record;

   subtype DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_REG
   type DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_Register is record
      --  dma_apbperi_spi2_pms_constrain_sram_world_0_pms_0
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 : DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field :=
                                                           16#3#;
      --  dma_apbperi_spi2_pms_constrain_sram_world_0_pms_1
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 : DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field :=
                                                           16#3#;
      --  dma_apbperi_spi2_pms_constrain_sram_world_0_pms_2
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 : DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field :=
                                                           16#3#;
      --  dma_apbperi_spi2_pms_constrain_sram_world_0_pms_3
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 : DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field :=
                                                           16#3#;
      --  unspecified
      Reserved_8_11                                     : ESP32_C3.UInt4 :=
                                                           16#0#;
      --  dma_apbperi_spi2_pms_constrain_sram_world_1_pms_0
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 : DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field :=
                                                           16#3#;
      --  dma_apbperi_spi2_pms_constrain_sram_world_1_pms_1
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 : DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field :=
                                                           16#3#;
      --  dma_apbperi_spi2_pms_constrain_sram_world_1_pms_2
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 : DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field :=
                                                           16#3#;
      --  dma_apbperi_spi2_pms_constrain_sram_world_1_pms_3
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 : DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field :=
                                                           16#3#;
      --  unspecified
      Reserved_20_31                                    : ESP32_C3.UInt12 :=
                                                           16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_Register use record
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 at 0 range 0 .. 1;
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 at 0 range 2 .. 3;
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 at 0 range 4 .. 5;
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 at 0 range 6 .. 7;
      Reserved_8_11                                     at 0 range 8 .. 11;
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 at 0 range 12 .. 13;
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 at 0 range 14 .. 15;
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 at 0 range 16 .. 17;
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 at 0 range 18 .. 19;
      Reserved_20_31                                    at 0 range 20 .. 31;
   end record;

   subtype DMA_APBPERI_UCHI0_PMS_CONSTRAIN_0_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_0_REG
   type DMA_APBPERI_UCHI0_PMS_CONSTRAIN_0_Register is record
      --  dma_apbperi_uchi0_pms_constrain_lock
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_LOCK : DMA_APBPERI_UCHI0_PMS_CONSTRAIN_0_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_LOCK_Field :=
                                              16#0#;
      --  unspecified
      Reserved_1_31                        : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_UCHI0_PMS_CONSTRAIN_0_Register use record
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_LOCK at 0 range 0 .. 0;
      Reserved_1_31                        at 0 range 1 .. 31;
   end record;

   subtype DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_REG
   type DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_Register is record
      --  dma_apbperi_uchi0_pms_constrain_sram_world_0_pms_0
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 : DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field :=
                                                            16#3#;
      --  dma_apbperi_uchi0_pms_constrain_sram_world_0_pms_1
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 : DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field :=
                                                            16#3#;
      --  dma_apbperi_uchi0_pms_constrain_sram_world_0_pms_2
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 : DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field :=
                                                            16#3#;
      --  dma_apbperi_uchi0_pms_constrain_sram_world_0_pms_3
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 : DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field :=
                                                            16#3#;
      --  unspecified
      Reserved_8_11                                      : ESP32_C3.UInt4 :=
                                                            16#0#;
      --  dma_apbperi_uchi0_pms_constrain_sram_world_1_pms_0
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 : DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field :=
                                                            16#3#;
      --  dma_apbperi_uchi0_pms_constrain_sram_world_1_pms_1
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 : DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field :=
                                                            16#3#;
      --  dma_apbperi_uchi0_pms_constrain_sram_world_1_pms_2
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 : DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field :=
                                                            16#3#;
      --  dma_apbperi_uchi0_pms_constrain_sram_world_1_pms_3
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 : DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field :=
                                                            16#3#;
      --  unspecified
      Reserved_20_31                                     : ESP32_C3.UInt12 :=
                                                            16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_Register use record
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 at 0 range 0 .. 1;
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 at 0 range 2 .. 3;
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 at 0 range 4 .. 5;
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 at 0 range 6 .. 7;
      Reserved_8_11                                      at 0 range 8 .. 11;
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 at 0 range 12 .. 13;
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 at 0 range 14 .. 15;
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 at 0 range 16 .. 17;
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 at 0 range 18 .. 19;
      Reserved_20_31                                     at 0 range 20 .. 31;
   end record;

   subtype DMA_APBPERI_I2S0_PMS_CONSTRAIN_0_DMA_APBPERI_I2S0_PMS_CONSTRAIN_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_DMA_APBPERI_I2S0_PMS_CONSTRAIN_0_REG
   type DMA_APBPERI_I2S0_PMS_CONSTRAIN_0_Register is record
      --  dma_apbperi_i2s0_pms_constrain_lock
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_LOCK : DMA_APBPERI_I2S0_PMS_CONSTRAIN_0_DMA_APBPERI_I2S0_PMS_CONSTRAIN_LOCK_Field :=
                                             16#0#;
      --  unspecified
      Reserved_1_31                       : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_I2S0_PMS_CONSTRAIN_0_Register use record
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_LOCK at 0 range 0 .. 0;
      Reserved_1_31                       at 0 range 1 .. 31;
   end record;

   subtype DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_REG
   type DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_Register is record
      --  dma_apbperi_i2s0_pms_constrain_sram_world_0_pms_0
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 : DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field :=
                                                           16#3#;
      --  dma_apbperi_i2s0_pms_constrain_sram_world_0_pms_1
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 : DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field :=
                                                           16#3#;
      --  dma_apbperi_i2s0_pms_constrain_sram_world_0_pms_2
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 : DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field :=
                                                           16#3#;
      --  dma_apbperi_i2s0_pms_constrain_sram_world_0_pms_3
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 : DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field :=
                                                           16#3#;
      --  unspecified
      Reserved_8_11                                     : ESP32_C3.UInt4 :=
                                                           16#0#;
      --  dma_apbperi_i2s0_pms_constrain_sram_world_1_pms_0
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 : DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field :=
                                                           16#3#;
      --  dma_apbperi_i2s0_pms_constrain_sram_world_1_pms_1
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 : DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field :=
                                                           16#3#;
      --  dma_apbperi_i2s0_pms_constrain_sram_world_1_pms_2
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 : DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field :=
                                                           16#3#;
      --  dma_apbperi_i2s0_pms_constrain_sram_world_1_pms_3
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 : DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field :=
                                                           16#3#;
      --  unspecified
      Reserved_20_31                                    : ESP32_C3.UInt12 :=
                                                           16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_Register use record
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 at 0 range 0 .. 1;
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 at 0 range 2 .. 3;
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 at 0 range 4 .. 5;
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 at 0 range 6 .. 7;
      Reserved_8_11                                     at 0 range 8 .. 11;
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 at 0 range 12 .. 13;
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 at 0 range 14 .. 15;
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 at 0 range 16 .. 17;
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 at 0 range 18 .. 19;
      Reserved_20_31                                    at 0 range 20 .. 31;
   end record;

   subtype DMA_APBPERI_MAC_PMS_CONSTRAIN_0_DMA_APBPERI_MAC_PMS_CONSTRAIN_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_DMA_APBPERI_MAC_PMS_CONSTRAIN_0_REG
   type DMA_APBPERI_MAC_PMS_CONSTRAIN_0_Register is record
      --  dma_apbperi_mac_pms_constrain_lock
      DMA_APBPERI_MAC_PMS_CONSTRAIN_LOCK : DMA_APBPERI_MAC_PMS_CONSTRAIN_0_DMA_APBPERI_MAC_PMS_CONSTRAIN_LOCK_Field :=
                                            16#0#;
      --  unspecified
      Reserved_1_31                      : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_MAC_PMS_CONSTRAIN_0_Register use record
      DMA_APBPERI_MAC_PMS_CONSTRAIN_LOCK at 0 range 0 .. 0;
      Reserved_1_31                      at 0 range 1 .. 31;
   end record;

   subtype DMA_APBPERI_MAC_PMS_CONSTRAIN_1_DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_MAC_PMS_CONSTRAIN_1_DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_MAC_PMS_CONSTRAIN_1_DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_MAC_PMS_CONSTRAIN_1_DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_MAC_PMS_CONSTRAIN_1_DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_MAC_PMS_CONSTRAIN_1_DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_MAC_PMS_CONSTRAIN_1_DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_MAC_PMS_CONSTRAIN_1_DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_DMA_APBPERI_MAC_PMS_CONSTRAIN_1_REG
   type DMA_APBPERI_MAC_PMS_CONSTRAIN_1_Register is record
      --  dma_apbperi_mac_pms_constrain_sram_world_0_pms_0
      DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 : DMA_APBPERI_MAC_PMS_CONSTRAIN_1_DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field :=
                                                          16#3#;
      --  dma_apbperi_mac_pms_constrain_sram_world_0_pms_1
      DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 : DMA_APBPERI_MAC_PMS_CONSTRAIN_1_DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field :=
                                                          16#3#;
      --  dma_apbperi_mac_pms_constrain_sram_world_0_pms_2
      DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 : DMA_APBPERI_MAC_PMS_CONSTRAIN_1_DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field :=
                                                          16#3#;
      --  dma_apbperi_mac_pms_constrain_sram_world_0_pms_3
      DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 : DMA_APBPERI_MAC_PMS_CONSTRAIN_1_DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field :=
                                                          16#3#;
      --  unspecified
      Reserved_8_11                                    : ESP32_C3.UInt4 :=
                                                          16#0#;
      --  dma_apbperi_mac_pms_constrain_sram_world_1_pms_0
      DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 : DMA_APBPERI_MAC_PMS_CONSTRAIN_1_DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field :=
                                                          16#3#;
      --  dma_apbperi_mac_pms_constrain_sram_world_1_pms_1
      DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 : DMA_APBPERI_MAC_PMS_CONSTRAIN_1_DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field :=
                                                          16#3#;
      --  dma_apbperi_mac_pms_constrain_sram_world_1_pms_2
      DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 : DMA_APBPERI_MAC_PMS_CONSTRAIN_1_DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field :=
                                                          16#3#;
      --  dma_apbperi_mac_pms_constrain_sram_world_1_pms_3
      DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 : DMA_APBPERI_MAC_PMS_CONSTRAIN_1_DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field :=
                                                          16#3#;
      --  unspecified
      Reserved_20_31                                   : ESP32_C3.UInt12 :=
                                                          16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_MAC_PMS_CONSTRAIN_1_Register use record
      DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 at 0 range 0 .. 1;
      DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 at 0 range 2 .. 3;
      DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 at 0 range 4 .. 5;
      DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 at 0 range 6 .. 7;
      Reserved_8_11                                    at 0 range 8 .. 11;
      DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 at 0 range 12 .. 13;
      DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 at 0 range 14 .. 15;
      DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 at 0 range 16 .. 17;
      DMA_APBPERI_MAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 at 0 range 18 .. 19;
      Reserved_20_31                                   at 0 range 20 .. 31;
   end record;

   subtype DMA_APBPERI_BACKUP_PMS_CONSTRAIN_0_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_0_REG
   type DMA_APBPERI_BACKUP_PMS_CONSTRAIN_0_Register is record
      --  dma_apbperi_backup_pms_constrain_lock
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_LOCK : DMA_APBPERI_BACKUP_PMS_CONSTRAIN_0_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_LOCK_Field :=
                                               16#0#;
      --  unspecified
      Reserved_1_31                         : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_BACKUP_PMS_CONSTRAIN_0_Register use record
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_LOCK at 0 range 0 .. 0;
      Reserved_1_31                         at 0 range 1 .. 31;
   end record;

   subtype DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_REG
   type DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_Register is record
      --  dma_apbperi_backup_pms_constrain_sram_world_0_pms_0
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 : DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field :=
                                                             16#3#;
      --  dma_apbperi_backup_pms_constrain_sram_world_0_pms_1
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 : DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field :=
                                                             16#3#;
      --  dma_apbperi_backup_pms_constrain_sram_world_0_pms_2
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 : DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field :=
                                                             16#3#;
      --  dma_apbperi_backup_pms_constrain_sram_world_0_pms_3
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 : DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field :=
                                                             16#3#;
      --  unspecified
      Reserved_8_11                                       : ESP32_C3.UInt4 :=
                                                             16#0#;
      --  dma_apbperi_backup_pms_constrain_sram_world_1_pms_0
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 : DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field :=
                                                             16#3#;
      --  dma_apbperi_backup_pms_constrain_sram_world_1_pms_1
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 : DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field :=
                                                             16#3#;
      --  dma_apbperi_backup_pms_constrain_sram_world_1_pms_2
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 : DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field :=
                                                             16#3#;
      --  dma_apbperi_backup_pms_constrain_sram_world_1_pms_3
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 : DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field :=
                                                             16#3#;
      --  unspecified
      Reserved_20_31                                      : ESP32_C3.UInt12 :=
                                                             16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_Register use record
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 at 0 range 0 .. 1;
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 at 0 range 2 .. 3;
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 at 0 range 4 .. 5;
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 at 0 range 6 .. 7;
      Reserved_8_11                                       at 0 range 8 .. 11;
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 at 0 range 12 .. 13;
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 at 0 range 14 .. 15;
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 at 0 range 16 .. 17;
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 at 0 range 18 .. 19;
      Reserved_20_31                                      at 0 range 20 .. 31;
   end record;

   subtype DMA_APBPERI_LC_PMS_CONSTRAIN_0_DMA_APBPERI_LC_PMS_CONSTRAIN_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_DMA_APBPERI_LC_PMS_CONSTRAIN_0_REG
   type DMA_APBPERI_LC_PMS_CONSTRAIN_0_Register is record
      --  dma_apbperi_lc_pms_constrain_lock
      DMA_APBPERI_LC_PMS_CONSTRAIN_LOCK : DMA_APBPERI_LC_PMS_CONSTRAIN_0_DMA_APBPERI_LC_PMS_CONSTRAIN_LOCK_Field :=
                                           16#0#;
      --  unspecified
      Reserved_1_31                     : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_LC_PMS_CONSTRAIN_0_Register use record
      DMA_APBPERI_LC_PMS_CONSTRAIN_LOCK at 0 range 0 .. 0;
      Reserved_1_31                     at 0 range 1 .. 31;
   end record;

   subtype DMA_APBPERI_LC_PMS_CONSTRAIN_1_DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_LC_PMS_CONSTRAIN_1_DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_LC_PMS_CONSTRAIN_1_DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_LC_PMS_CONSTRAIN_1_DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_LC_PMS_CONSTRAIN_1_DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_LC_PMS_CONSTRAIN_1_DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_LC_PMS_CONSTRAIN_1_DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_LC_PMS_CONSTRAIN_1_DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_DMA_APBPERI_LC_PMS_CONSTRAIN_1_REG
   type DMA_APBPERI_LC_PMS_CONSTRAIN_1_Register is record
      --  dma_apbperi_lc_pms_constrain_sram_world_0_pms_0
      DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 : DMA_APBPERI_LC_PMS_CONSTRAIN_1_DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field :=
                                                         16#3#;
      --  dma_apbperi_lc_pms_constrain_sram_world_0_pms_1
      DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 : DMA_APBPERI_LC_PMS_CONSTRAIN_1_DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field :=
                                                         16#3#;
      --  dma_apbperi_lc_pms_constrain_sram_world_0_pms_2
      DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 : DMA_APBPERI_LC_PMS_CONSTRAIN_1_DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field :=
                                                         16#3#;
      --  dma_apbperi_lc_pms_constrain_sram_world_0_pms_3
      DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 : DMA_APBPERI_LC_PMS_CONSTRAIN_1_DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field :=
                                                         16#3#;
      --  unspecified
      Reserved_8_11                                   : ESP32_C3.UInt4 :=
                                                         16#0#;
      --  dma_apbperi_lc_pms_constrain_sram_world_1_pms_0
      DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 : DMA_APBPERI_LC_PMS_CONSTRAIN_1_DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field :=
                                                         16#3#;
      --  dma_apbperi_lc_pms_constrain_sram_world_1_pms_1
      DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 : DMA_APBPERI_LC_PMS_CONSTRAIN_1_DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field :=
                                                         16#3#;
      --  dma_apbperi_lc_pms_constrain_sram_world_1_pms_2
      DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 : DMA_APBPERI_LC_PMS_CONSTRAIN_1_DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field :=
                                                         16#3#;
      --  dma_apbperi_lc_pms_constrain_sram_world_1_pms_3
      DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 : DMA_APBPERI_LC_PMS_CONSTRAIN_1_DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field :=
                                                         16#3#;
      --  unspecified
      Reserved_20_31                                  : ESP32_C3.UInt12 :=
                                                         16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_LC_PMS_CONSTRAIN_1_Register use record
      DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 at 0 range 0 .. 1;
      DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 at 0 range 2 .. 3;
      DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 at 0 range 4 .. 5;
      DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 at 0 range 6 .. 7;
      Reserved_8_11                                   at 0 range 8 .. 11;
      DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 at 0 range 12 .. 13;
      DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 at 0 range 14 .. 15;
      DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 at 0 range 16 .. 17;
      DMA_APBPERI_LC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 at 0 range 18 .. 19;
      Reserved_20_31                                  at 0 range 20 .. 31;
   end record;

   subtype DMA_APBPERI_AES_PMS_CONSTRAIN_0_DMA_APBPERI_AES_PMS_CONSTRAIN_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_DMA_APBPERI_AES_PMS_CONSTRAIN_0_REG
   type DMA_APBPERI_AES_PMS_CONSTRAIN_0_Register is record
      --  dma_apbperi_aes_pms_constrain_lock
      DMA_APBPERI_AES_PMS_CONSTRAIN_LOCK : DMA_APBPERI_AES_PMS_CONSTRAIN_0_DMA_APBPERI_AES_PMS_CONSTRAIN_LOCK_Field :=
                                            16#0#;
      --  unspecified
      Reserved_1_31                      : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_AES_PMS_CONSTRAIN_0_Register use record
      DMA_APBPERI_AES_PMS_CONSTRAIN_LOCK at 0 range 0 .. 0;
      Reserved_1_31                      at 0 range 1 .. 31;
   end record;

   subtype DMA_APBPERI_AES_PMS_CONSTRAIN_1_DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_AES_PMS_CONSTRAIN_1_DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_AES_PMS_CONSTRAIN_1_DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_AES_PMS_CONSTRAIN_1_DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_AES_PMS_CONSTRAIN_1_DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_AES_PMS_CONSTRAIN_1_DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_AES_PMS_CONSTRAIN_1_DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_AES_PMS_CONSTRAIN_1_DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_DMA_APBPERI_AES_PMS_CONSTRAIN_1_REG
   type DMA_APBPERI_AES_PMS_CONSTRAIN_1_Register is record
      --  dma_apbperi_aes_pms_constrain_sram_world_0_pms_0
      DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 : DMA_APBPERI_AES_PMS_CONSTRAIN_1_DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field :=
                                                          16#3#;
      --  dma_apbperi_aes_pms_constrain_sram_world_0_pms_1
      DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 : DMA_APBPERI_AES_PMS_CONSTRAIN_1_DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field :=
                                                          16#3#;
      --  dma_apbperi_aes_pms_constrain_sram_world_0_pms_2
      DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 : DMA_APBPERI_AES_PMS_CONSTRAIN_1_DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field :=
                                                          16#3#;
      --  dma_apbperi_aes_pms_constrain_sram_world_0_pms_3
      DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 : DMA_APBPERI_AES_PMS_CONSTRAIN_1_DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field :=
                                                          16#3#;
      --  unspecified
      Reserved_8_11                                    : ESP32_C3.UInt4 :=
                                                          16#0#;
      --  dma_apbperi_aes_pms_constrain_sram_world_1_pms_0
      DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 : DMA_APBPERI_AES_PMS_CONSTRAIN_1_DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field :=
                                                          16#3#;
      --  dma_apbperi_aes_pms_constrain_sram_world_1_pms_1
      DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 : DMA_APBPERI_AES_PMS_CONSTRAIN_1_DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field :=
                                                          16#3#;
      --  dma_apbperi_aes_pms_constrain_sram_world_1_pms_2
      DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 : DMA_APBPERI_AES_PMS_CONSTRAIN_1_DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field :=
                                                          16#3#;
      --  dma_apbperi_aes_pms_constrain_sram_world_1_pms_3
      DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 : DMA_APBPERI_AES_PMS_CONSTRAIN_1_DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field :=
                                                          16#3#;
      --  unspecified
      Reserved_20_31                                   : ESP32_C3.UInt12 :=
                                                          16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_AES_PMS_CONSTRAIN_1_Register use record
      DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 at 0 range 0 .. 1;
      DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 at 0 range 2 .. 3;
      DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 at 0 range 4 .. 5;
      DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 at 0 range 6 .. 7;
      Reserved_8_11                                    at 0 range 8 .. 11;
      DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 at 0 range 12 .. 13;
      DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 at 0 range 14 .. 15;
      DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 at 0 range 16 .. 17;
      DMA_APBPERI_AES_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 at 0 range 18 .. 19;
      Reserved_20_31                                   at 0 range 20 .. 31;
   end record;

   subtype DMA_APBPERI_SHA_PMS_CONSTRAIN_0_DMA_APBPERI_SHA_PMS_CONSTRAIN_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_DMA_APBPERI_SHA_PMS_CONSTRAIN_0_REG
   type DMA_APBPERI_SHA_PMS_CONSTRAIN_0_Register is record
      --  dma_apbperi_sha_pms_constrain_lock
      DMA_APBPERI_SHA_PMS_CONSTRAIN_LOCK : DMA_APBPERI_SHA_PMS_CONSTRAIN_0_DMA_APBPERI_SHA_PMS_CONSTRAIN_LOCK_Field :=
                                            16#0#;
      --  unspecified
      Reserved_1_31                      : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_SHA_PMS_CONSTRAIN_0_Register use record
      DMA_APBPERI_SHA_PMS_CONSTRAIN_LOCK at 0 range 0 .. 0;
      Reserved_1_31                      at 0 range 1 .. 31;
   end record;

   subtype DMA_APBPERI_SHA_PMS_CONSTRAIN_1_DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_SHA_PMS_CONSTRAIN_1_DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_SHA_PMS_CONSTRAIN_1_DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_SHA_PMS_CONSTRAIN_1_DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_SHA_PMS_CONSTRAIN_1_DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_SHA_PMS_CONSTRAIN_1_DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_SHA_PMS_CONSTRAIN_1_DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_SHA_PMS_CONSTRAIN_1_DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_DMA_APBPERI_SHA_PMS_CONSTRAIN_1_REG
   type DMA_APBPERI_SHA_PMS_CONSTRAIN_1_Register is record
      --  dma_apbperi_sha_pms_constrain_sram_world_0_pms_0
      DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 : DMA_APBPERI_SHA_PMS_CONSTRAIN_1_DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field :=
                                                          16#3#;
      --  dma_apbperi_sha_pms_constrain_sram_world_0_pms_1
      DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 : DMA_APBPERI_SHA_PMS_CONSTRAIN_1_DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field :=
                                                          16#3#;
      --  dma_apbperi_sha_pms_constrain_sram_world_0_pms_2
      DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 : DMA_APBPERI_SHA_PMS_CONSTRAIN_1_DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field :=
                                                          16#3#;
      --  dma_apbperi_sha_pms_constrain_sram_world_0_pms_3
      DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 : DMA_APBPERI_SHA_PMS_CONSTRAIN_1_DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field :=
                                                          16#3#;
      --  unspecified
      Reserved_8_11                                    : ESP32_C3.UInt4 :=
                                                          16#0#;
      --  dma_apbperi_sha_pms_constrain_sram_world_1_pms_0
      DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 : DMA_APBPERI_SHA_PMS_CONSTRAIN_1_DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field :=
                                                          16#3#;
      --  dma_apbperi_sha_pms_constrain_sram_world_1_pms_1
      DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 : DMA_APBPERI_SHA_PMS_CONSTRAIN_1_DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field :=
                                                          16#3#;
      --  dma_apbperi_sha_pms_constrain_sram_world_1_pms_2
      DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 : DMA_APBPERI_SHA_PMS_CONSTRAIN_1_DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field :=
                                                          16#3#;
      --  dma_apbperi_sha_pms_constrain_sram_world_1_pms_3
      DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 : DMA_APBPERI_SHA_PMS_CONSTRAIN_1_DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field :=
                                                          16#3#;
      --  unspecified
      Reserved_20_31                                   : ESP32_C3.UInt12 :=
                                                          16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_SHA_PMS_CONSTRAIN_1_Register use record
      DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 at 0 range 0 .. 1;
      DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 at 0 range 2 .. 3;
      DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 at 0 range 4 .. 5;
      DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 at 0 range 6 .. 7;
      Reserved_8_11                                    at 0 range 8 .. 11;
      DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 at 0 range 12 .. 13;
      DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 at 0 range 14 .. 15;
      DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 at 0 range 16 .. 17;
      DMA_APBPERI_SHA_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 at 0 range 18 .. 19;
      Reserved_20_31                                   at 0 range 20 .. 31;
   end record;

   subtype DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_0_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_0_REG
   type DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_0_Register is record
      --  dma_apbperi_adc_dac_pms_constrain_lock
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_LOCK : DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_0_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_LOCK_Field :=
                                                16#0#;
      --  unspecified
      Reserved_1_31                          : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_0_Register use record
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_LOCK at 0 range 0 .. 0;
      Reserved_1_31                          at 0 range 1 .. 31;
   end record;

   subtype DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_REG
   type DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_Register is record
      --  dma_apbperi_adc_dac_pms_constrain_sram_world_0_pms_0
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 : DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field :=
                                                              16#3#;
      --  dma_apbperi_adc_dac_pms_constrain_sram_world_0_pms_1
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 : DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field :=
                                                              16#3#;
      --  dma_apbperi_adc_dac_pms_constrain_sram_world_0_pms_2
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 : DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field :=
                                                              16#3#;
      --  dma_apbperi_adc_dac_pms_constrain_sram_world_0_pms_3
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 : DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field :=
                                                              16#3#;
      --  unspecified
      Reserved_8_11                                        : ESP32_C3.UInt4 :=
                                                              16#0#;
      --  dma_apbperi_adc_dac_pms_constrain_sram_world_1_pms_0
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 : DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field :=
                                                              16#3#;
      --  dma_apbperi_adc_dac_pms_constrain_sram_world_1_pms_1
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 : DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field :=
                                                              16#3#;
      --  dma_apbperi_adc_dac_pms_constrain_sram_world_1_pms_2
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 : DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field :=
                                                              16#3#;
      --  dma_apbperi_adc_dac_pms_constrain_sram_world_1_pms_3
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 : DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field :=
                                                              16#3#;
      --  unspecified
      Reserved_20_31                                       : ESP32_C3.UInt12 :=
                                                              16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_Register use record
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 at 0 range 0 .. 1;
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 at 0 range 2 .. 3;
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 at 0 range 4 .. 5;
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 at 0 range 6 .. 7;
      Reserved_8_11                                        at 0 range 8 .. 11;
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 at 0 range 12 .. 13;
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 at 0 range 14 .. 15;
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 at 0 range 16 .. 17;
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 at 0 range 18 .. 19;
      Reserved_20_31                                       at 0 range 20 .. 31;
   end record;

   subtype DMA_APBPERI_PMS_MONITOR_0_DMA_APBPERI_PMS_MONITOR_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_DMA_APBPERI_PMS_MONITOR_0_REG
   type DMA_APBPERI_PMS_MONITOR_0_Register is record
      --  dma_apbperi_pms_monitor_lock
      DMA_APBPERI_PMS_MONITOR_LOCK : DMA_APBPERI_PMS_MONITOR_0_DMA_APBPERI_PMS_MONITOR_LOCK_Field :=
                                      16#0#;
      --  unspecified
      Reserved_1_31                : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_PMS_MONITOR_0_Register use record
      DMA_APBPERI_PMS_MONITOR_LOCK at 0 range 0 .. 0;
      Reserved_1_31                at 0 range 1 .. 31;
   end record;

   subtype DMA_APBPERI_PMS_MONITOR_1_DMA_APBPERI_PMS_MONITOR_VIOLATE_CLR_Field is
     ESP32_C3.Bit;
   subtype DMA_APBPERI_PMS_MONITOR_1_DMA_APBPERI_PMS_MONITOR_VIOLATE_EN_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_DMA_APBPERI_PMS_MONITOR_1_REG
   type DMA_APBPERI_PMS_MONITOR_1_Register is record
      --  dma_apbperi_pms_monitor_violate_clr
      DMA_APBPERI_PMS_MONITOR_VIOLATE_CLR : DMA_APBPERI_PMS_MONITOR_1_DMA_APBPERI_PMS_MONITOR_VIOLATE_CLR_Field :=
                                             16#1#;
      --  dma_apbperi_pms_monitor_violate_en
      DMA_APBPERI_PMS_MONITOR_VIOLATE_EN  : DMA_APBPERI_PMS_MONITOR_1_DMA_APBPERI_PMS_MONITOR_VIOLATE_EN_Field :=
                                             16#1#;
      --  unspecified
      Reserved_2_31                       : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_PMS_MONITOR_1_Register use record
      DMA_APBPERI_PMS_MONITOR_VIOLATE_CLR at 0 range 0 .. 0;
      DMA_APBPERI_PMS_MONITOR_VIOLATE_EN  at 0 range 1 .. 1;
      Reserved_2_31                       at 0 range 2 .. 31;
   end record;

   subtype DMA_APBPERI_PMS_MONITOR_2_DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_Field is
     ESP32_C3.Bit;
   subtype DMA_APBPERI_PMS_MONITOR_2_DMA_APBPERI_PMS_MONITOR_VIOLATE_STATUS_WORLD_Field is
     ESP32_C3.UInt2;
   subtype DMA_APBPERI_PMS_MONITOR_2_DMA_APBPERI_PMS_MONITOR_VIOLATE_STATUS_ADDR_Field is
     ESP32_C3.UInt24;

   --  SENSITIVE_DMA_APBPERI_PMS_MONITOR_2_REG
   type DMA_APBPERI_PMS_MONITOR_2_Register is record
      --  Read-only. dma_apbperi_pms_monitor_violate_intr
      DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR         : DMA_APBPERI_PMS_MONITOR_2_DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_Field;
      --  Read-only. dma_apbperi_pms_monitor_violate_status_world
      DMA_APBPERI_PMS_MONITOR_VIOLATE_STATUS_WORLD : DMA_APBPERI_PMS_MONITOR_2_DMA_APBPERI_PMS_MONITOR_VIOLATE_STATUS_WORLD_Field;
      --  Read-only. dma_apbperi_pms_monitor_violate_status_addr
      DMA_APBPERI_PMS_MONITOR_VIOLATE_STATUS_ADDR  : DMA_APBPERI_PMS_MONITOR_2_DMA_APBPERI_PMS_MONITOR_VIOLATE_STATUS_ADDR_Field;
      --  unspecified
      Reserved_27_31                               : ESP32_C3.UInt5;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_PMS_MONITOR_2_Register use record
      DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR         at 0 range 0 .. 0;
      DMA_APBPERI_PMS_MONITOR_VIOLATE_STATUS_WORLD at 0 range 1 .. 2;
      DMA_APBPERI_PMS_MONITOR_VIOLATE_STATUS_ADDR  at 0 range 3 .. 26;
      Reserved_27_31                               at 0 range 27 .. 31;
   end record;

   subtype DMA_APBPERI_PMS_MONITOR_3_DMA_APBPERI_PMS_MONITOR_VIOLATE_STATUS_WR_Field is
     ESP32_C3.Bit;
   subtype DMA_APBPERI_PMS_MONITOR_3_DMA_APBPERI_PMS_MONITOR_VIOLATE_STATUS_BYTEEN_Field is
     ESP32_C3.UInt4;

   --  SENSITIVE_DMA_APBPERI_PMS_MONITOR_3_REG
   type DMA_APBPERI_PMS_MONITOR_3_Register is record
      --  Read-only. dma_apbperi_pms_monitor_violate_status_wr
      DMA_APBPERI_PMS_MONITOR_VIOLATE_STATUS_WR     : DMA_APBPERI_PMS_MONITOR_3_DMA_APBPERI_PMS_MONITOR_VIOLATE_STATUS_WR_Field;
      --  Read-only. dma_apbperi_pms_monitor_violate_status_byteen
      DMA_APBPERI_PMS_MONITOR_VIOLATE_STATUS_BYTEEN : DMA_APBPERI_PMS_MONITOR_3_DMA_APBPERI_PMS_MONITOR_VIOLATE_STATUS_BYTEEN_Field;
      --  unspecified
      Reserved_5_31                                 : ESP32_C3.UInt27;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_APBPERI_PMS_MONITOR_3_Register use record
      DMA_APBPERI_PMS_MONITOR_VIOLATE_STATUS_WR     at 0 range 0 .. 0;
      DMA_APBPERI_PMS_MONITOR_VIOLATE_STATUS_BYTEEN at 0 range 1 .. 4;
      Reserved_5_31                                 at 0 range 5 .. 31;
   end record;

   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_0_CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_0_REG
   type CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_0_Register is record
      --  core_x_iram0_dram0_dma_split_line_constrain_lock
      CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_LOCK : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_0_CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_LOCK_Field :=
                                                          16#0#;
      --  unspecified
      Reserved_1_31                                    : ESP32_C3.UInt31 :=
                                                          16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_0_Register use record
      CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_LOCK at 0 range 0 .. 0;
      Reserved_1_31                                    at 0 range 1 .. 31;
   end record;

   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_1_CORE_X_IRAM0_DRAM0_DMA_SRAM_CATEGORY_0_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_1_CORE_X_IRAM0_DRAM0_DMA_SRAM_CATEGORY_1_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_1_CORE_X_IRAM0_DRAM0_DMA_SRAM_CATEGORY_2_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_1_CORE_X_IRAM0_DRAM0_DMA_SRAM_SPLITADDR_Field is
     ESP32_C3.Byte;

   --  SENSITIVE_CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_1_REG
   type CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_1_Register is record
      --  core_x_iram0_dram0_dma_sram_category_0
      CORE_X_IRAM0_DRAM0_DMA_SRAM_CATEGORY_0 : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_1_CORE_X_IRAM0_DRAM0_DMA_SRAM_CATEGORY_0_Field :=
                                                16#0#;
      --  core_x_iram0_dram0_dma_sram_category_1
      CORE_X_IRAM0_DRAM0_DMA_SRAM_CATEGORY_1 : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_1_CORE_X_IRAM0_DRAM0_DMA_SRAM_CATEGORY_1_Field :=
                                                16#0#;
      --  core_x_iram0_dram0_dma_sram_category_2
      CORE_X_IRAM0_DRAM0_DMA_SRAM_CATEGORY_2 : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_1_CORE_X_IRAM0_DRAM0_DMA_SRAM_CATEGORY_2_Field :=
                                                16#0#;
      --  unspecified
      Reserved_6_13                          : ESP32_C3.Byte := 16#0#;
      --  core_x_iram0_dram0_dma_sram_splitaddr
      CORE_X_IRAM0_DRAM0_DMA_SRAM_SPLITADDR  : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_1_CORE_X_IRAM0_DRAM0_DMA_SRAM_SPLITADDR_Field :=
                                                16#0#;
      --  unspecified
      Reserved_22_31                         : ESP32_C3.UInt10 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_1_Register use record
      CORE_X_IRAM0_DRAM0_DMA_SRAM_CATEGORY_0 at 0 range 0 .. 1;
      CORE_X_IRAM0_DRAM0_DMA_SRAM_CATEGORY_1 at 0 range 2 .. 3;
      CORE_X_IRAM0_DRAM0_DMA_SRAM_CATEGORY_2 at 0 range 4 .. 5;
      Reserved_6_13                          at 0 range 6 .. 13;
      CORE_X_IRAM0_DRAM0_DMA_SRAM_SPLITADDR  at 0 range 14 .. 21;
      Reserved_22_31                         at 0 range 22 .. 31;
   end record;

   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_2_CORE_X_IRAM0_SRAM_LINE_0_CATEGORY_0_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_2_CORE_X_IRAM0_SRAM_LINE_0_CATEGORY_1_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_2_CORE_X_IRAM0_SRAM_LINE_0_CATEGORY_2_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_2_CORE_X_IRAM0_SRAM_LINE_0_SPLITADDR_Field is
     ESP32_C3.Byte;

   --  SENSITIVE_CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_2_REG
   type CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_2_Register is record
      --  core_x_iram0_sram_line_0_category_0
      CORE_X_IRAM0_SRAM_LINE_0_CATEGORY_0 : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_2_CORE_X_IRAM0_SRAM_LINE_0_CATEGORY_0_Field :=
                                             16#0#;
      --  core_x_iram0_sram_line_0_category_1
      CORE_X_IRAM0_SRAM_LINE_0_CATEGORY_1 : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_2_CORE_X_IRAM0_SRAM_LINE_0_CATEGORY_1_Field :=
                                             16#0#;
      --  core_x_iram0_sram_line_0_category_2
      CORE_X_IRAM0_SRAM_LINE_0_CATEGORY_2 : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_2_CORE_X_IRAM0_SRAM_LINE_0_CATEGORY_2_Field :=
                                             16#0#;
      --  unspecified
      Reserved_6_13                       : ESP32_C3.Byte := 16#0#;
      --  core_x_iram0_sram_line_0_splitaddr
      CORE_X_IRAM0_SRAM_LINE_0_SPLITADDR  : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_2_CORE_X_IRAM0_SRAM_LINE_0_SPLITADDR_Field :=
                                             16#0#;
      --  unspecified
      Reserved_22_31                      : ESP32_C3.UInt10 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_2_Register use record
      CORE_X_IRAM0_SRAM_LINE_0_CATEGORY_0 at 0 range 0 .. 1;
      CORE_X_IRAM0_SRAM_LINE_0_CATEGORY_1 at 0 range 2 .. 3;
      CORE_X_IRAM0_SRAM_LINE_0_CATEGORY_2 at 0 range 4 .. 5;
      Reserved_6_13                       at 0 range 6 .. 13;
      CORE_X_IRAM0_SRAM_LINE_0_SPLITADDR  at 0 range 14 .. 21;
      Reserved_22_31                      at 0 range 22 .. 31;
   end record;

   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_3_CORE_X_IRAM0_SRAM_LINE_1_CATEGORY_0_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_3_CORE_X_IRAM0_SRAM_LINE_1_CATEGORY_1_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_3_CORE_X_IRAM0_SRAM_LINE_1_CATEGORY_2_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_3_CORE_X_IRAM0_SRAM_LINE_1_SPLITADDR_Field is
     ESP32_C3.Byte;

   --  SENSITIVE_CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_3_REG
   type CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_3_Register is record
      --  core_x_iram0_sram_line_1_category_0
      CORE_X_IRAM0_SRAM_LINE_1_CATEGORY_0 : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_3_CORE_X_IRAM0_SRAM_LINE_1_CATEGORY_0_Field :=
                                             16#0#;
      --  core_x_iram0_sram_line_1_category_1
      CORE_X_IRAM0_SRAM_LINE_1_CATEGORY_1 : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_3_CORE_X_IRAM0_SRAM_LINE_1_CATEGORY_1_Field :=
                                             16#0#;
      --  core_x_iram0_sram_line_1_category_2
      CORE_X_IRAM0_SRAM_LINE_1_CATEGORY_2 : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_3_CORE_X_IRAM0_SRAM_LINE_1_CATEGORY_2_Field :=
                                             16#0#;
      --  unspecified
      Reserved_6_13                       : ESP32_C3.Byte := 16#0#;
      --  core_x_iram0_sram_line_1_splitaddr
      CORE_X_IRAM0_SRAM_LINE_1_SPLITADDR  : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_3_CORE_X_IRAM0_SRAM_LINE_1_SPLITADDR_Field :=
                                             16#0#;
      --  unspecified
      Reserved_22_31                      : ESP32_C3.UInt10 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_3_Register use record
      CORE_X_IRAM0_SRAM_LINE_1_CATEGORY_0 at 0 range 0 .. 1;
      CORE_X_IRAM0_SRAM_LINE_1_CATEGORY_1 at 0 range 2 .. 3;
      CORE_X_IRAM0_SRAM_LINE_1_CATEGORY_2 at 0 range 4 .. 5;
      Reserved_6_13                       at 0 range 6 .. 13;
      CORE_X_IRAM0_SRAM_LINE_1_SPLITADDR  at 0 range 14 .. 21;
      Reserved_22_31                      at 0 range 22 .. 31;
   end record;

   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_4_CORE_X_DRAM0_DMA_SRAM_LINE_0_CATEGORY_0_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_4_CORE_X_DRAM0_DMA_SRAM_LINE_0_CATEGORY_1_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_4_CORE_X_DRAM0_DMA_SRAM_LINE_0_CATEGORY_2_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_4_CORE_X_DRAM0_DMA_SRAM_LINE_0_SPLITADDR_Field is
     ESP32_C3.Byte;

   --  SENSITIVE_CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_4_REG
   type CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_4_Register is record
      --  core_x_dram0_dma_sram_line_0_category_0
      CORE_X_DRAM0_DMA_SRAM_LINE_0_CATEGORY_0 : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_4_CORE_X_DRAM0_DMA_SRAM_LINE_0_CATEGORY_0_Field :=
                                                 16#0#;
      --  core_x_dram0_dma_sram_line_0_category_1
      CORE_X_DRAM0_DMA_SRAM_LINE_0_CATEGORY_1 : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_4_CORE_X_DRAM0_DMA_SRAM_LINE_0_CATEGORY_1_Field :=
                                                 16#0#;
      --  core_x_dram0_dma_sram_line_0_category_2
      CORE_X_DRAM0_DMA_SRAM_LINE_0_CATEGORY_2 : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_4_CORE_X_DRAM0_DMA_SRAM_LINE_0_CATEGORY_2_Field :=
                                                 16#0#;
      --  unspecified
      Reserved_6_13                           : ESP32_C3.Byte := 16#0#;
      --  core_x_dram0_dma_sram_line_0_splitaddr
      CORE_X_DRAM0_DMA_SRAM_LINE_0_SPLITADDR  : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_4_CORE_X_DRAM0_DMA_SRAM_LINE_0_SPLITADDR_Field :=
                                                 16#0#;
      --  unspecified
      Reserved_22_31                          : ESP32_C3.UInt10 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_4_Register use record
      CORE_X_DRAM0_DMA_SRAM_LINE_0_CATEGORY_0 at 0 range 0 .. 1;
      CORE_X_DRAM0_DMA_SRAM_LINE_0_CATEGORY_1 at 0 range 2 .. 3;
      CORE_X_DRAM0_DMA_SRAM_LINE_0_CATEGORY_2 at 0 range 4 .. 5;
      Reserved_6_13                           at 0 range 6 .. 13;
      CORE_X_DRAM0_DMA_SRAM_LINE_0_SPLITADDR  at 0 range 14 .. 21;
      Reserved_22_31                          at 0 range 22 .. 31;
   end record;

   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_5_CORE_X_DRAM0_DMA_SRAM_LINE_1_CATEGORY_0_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_5_CORE_X_DRAM0_DMA_SRAM_LINE_1_CATEGORY_1_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_5_CORE_X_DRAM0_DMA_SRAM_LINE_1_CATEGORY_2_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_5_CORE_X_DRAM0_DMA_SRAM_LINE_1_SPLITADDR_Field is
     ESP32_C3.Byte;

   --  SENSITIVE_CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_5_REG
   type CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_5_Register is record
      --  core_x_dram0_dma_sram_line_1_category_0
      CORE_X_DRAM0_DMA_SRAM_LINE_1_CATEGORY_0 : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_5_CORE_X_DRAM0_DMA_SRAM_LINE_1_CATEGORY_0_Field :=
                                                 16#0#;
      --  core_x_dram0_dma_sram_line_1_category_1
      CORE_X_DRAM0_DMA_SRAM_LINE_1_CATEGORY_1 : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_5_CORE_X_DRAM0_DMA_SRAM_LINE_1_CATEGORY_1_Field :=
                                                 16#0#;
      --  core_x_dram0_dma_sram_line_1_category_2
      CORE_X_DRAM0_DMA_SRAM_LINE_1_CATEGORY_2 : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_5_CORE_X_DRAM0_DMA_SRAM_LINE_1_CATEGORY_2_Field :=
                                                 16#0#;
      --  unspecified
      Reserved_6_13                           : ESP32_C3.Byte := 16#0#;
      --  core_x_dram0_dma_sram_line_1_splitaddr
      CORE_X_DRAM0_DMA_SRAM_LINE_1_SPLITADDR  : CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_5_CORE_X_DRAM0_DMA_SRAM_LINE_1_SPLITADDR_Field :=
                                                 16#0#;
      --  unspecified
      Reserved_22_31                          : ESP32_C3.UInt10 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_5_Register use record
      CORE_X_DRAM0_DMA_SRAM_LINE_1_CATEGORY_0 at 0 range 0 .. 1;
      CORE_X_DRAM0_DMA_SRAM_LINE_1_CATEGORY_1 at 0 range 2 .. 3;
      CORE_X_DRAM0_DMA_SRAM_LINE_1_CATEGORY_2 at 0 range 4 .. 5;
      Reserved_6_13                           at 0 range 6 .. 13;
      CORE_X_DRAM0_DMA_SRAM_LINE_1_SPLITADDR  at 0 range 14 .. 21;
      Reserved_22_31                          at 0 range 22 .. 31;
   end record;

   subtype CORE_X_IRAM0_PMS_CONSTRAIN_0_CORE_X_IRAM0_PMS_CONSTRAIN_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_CORE_X_IRAM0_PMS_CONSTRAIN_0_REG
   type CORE_X_IRAM0_PMS_CONSTRAIN_0_Register is record
      --  core_x_iram0_pms_constrain_lock
      CORE_X_IRAM0_PMS_CONSTRAIN_LOCK : CORE_X_IRAM0_PMS_CONSTRAIN_0_CORE_X_IRAM0_PMS_CONSTRAIN_LOCK_Field :=
                                         16#0#;
      --  unspecified
      Reserved_1_31                   : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_X_IRAM0_PMS_CONSTRAIN_0_Register use record
      CORE_X_IRAM0_PMS_CONSTRAIN_LOCK at 0 range 0 .. 0;
      Reserved_1_31                   at 0 range 1 .. 31;
   end record;

   subtype CORE_X_IRAM0_PMS_CONSTRAIN_1_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field is
     ESP32_C3.UInt3;
   subtype CORE_X_IRAM0_PMS_CONSTRAIN_1_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field is
     ESP32_C3.UInt3;
   subtype CORE_X_IRAM0_PMS_CONSTRAIN_1_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field is
     ESP32_C3.UInt3;
   subtype CORE_X_IRAM0_PMS_CONSTRAIN_1_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field is
     ESP32_C3.UInt3;
   subtype CORE_X_IRAM0_PMS_CONSTRAIN_1_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_CACHEDATAARRAY_PMS_0_Field is
     ESP32_C3.UInt3;
   subtype CORE_X_IRAM0_PMS_CONSTRAIN_1_CORE_X_IRAM0_PMS_CONSTRAIN_ROM_WORLD_1_PMS_Field is
     ESP32_C3.UInt3;

   --  SENSITIVE_CORE_X_IRAM0_PMS_CONSTRAIN_1_REG
   type CORE_X_IRAM0_PMS_CONSTRAIN_1_Register is record
      --  core_x_iram0_pms_constrain_sram_world_1_pms_0
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0                : CORE_X_IRAM0_PMS_CONSTRAIN_1_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field :=
                                                                      16#7#;
      --  core_x_iram0_pms_constrain_sram_world_1_pms_1
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1                : CORE_X_IRAM0_PMS_CONSTRAIN_1_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field :=
                                                                      16#7#;
      --  core_x_iram0_pms_constrain_sram_world_1_pms_2
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2                : CORE_X_IRAM0_PMS_CONSTRAIN_1_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field :=
                                                                      16#7#;
      --  core_x_iram0_pms_constrain_sram_world_1_pms_3
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3                : CORE_X_IRAM0_PMS_CONSTRAIN_1_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field :=
                                                                      16#7#;
      --  core_x_iram0_pms_constrain_sram_world_1_cachedataarray_pms_0
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_CACHEDATAARRAY_PMS_0 : CORE_X_IRAM0_PMS_CONSTRAIN_1_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_CACHEDATAARRAY_PMS_0_Field :=
                                                                      16#7#;
      --  unspecified
      Reserved_15_17                                               : ESP32_C3.UInt3 :=
                                                                      16#0#;
      --  core_x_iram0_pms_constrain_rom_world_1_pms
      CORE_X_IRAM0_PMS_CONSTRAIN_ROM_WORLD_1_PMS                   : CORE_X_IRAM0_PMS_CONSTRAIN_1_CORE_X_IRAM0_PMS_CONSTRAIN_ROM_WORLD_1_PMS_Field :=
                                                                      16#7#;
      --  unspecified
      Reserved_21_31                                               : ESP32_C3.UInt11 :=
                                                                      16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_X_IRAM0_PMS_CONSTRAIN_1_Register use record
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0                at 0 range 0 .. 2;
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1                at 0 range 3 .. 5;
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2                at 0 range 6 .. 8;
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3                at 0 range 9 .. 11;
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_CACHEDATAARRAY_PMS_0 at 0 range 12 .. 14;
      Reserved_15_17                                               at 0 range 15 .. 17;
      CORE_X_IRAM0_PMS_CONSTRAIN_ROM_WORLD_1_PMS                   at 0 range 18 .. 20;
      Reserved_21_31                                               at 0 range 21 .. 31;
   end record;

   subtype CORE_X_IRAM0_PMS_CONSTRAIN_2_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field is
     ESP32_C3.UInt3;
   subtype CORE_X_IRAM0_PMS_CONSTRAIN_2_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field is
     ESP32_C3.UInt3;
   subtype CORE_X_IRAM0_PMS_CONSTRAIN_2_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field is
     ESP32_C3.UInt3;
   subtype CORE_X_IRAM0_PMS_CONSTRAIN_2_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field is
     ESP32_C3.UInt3;
   subtype CORE_X_IRAM0_PMS_CONSTRAIN_2_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_CACHEDATAARRAY_PMS_0_Field is
     ESP32_C3.UInt3;
   subtype CORE_X_IRAM0_PMS_CONSTRAIN_2_CORE_X_IRAM0_PMS_CONSTRAIN_ROM_WORLD_0_PMS_Field is
     ESP32_C3.UInt3;

   --  SENSITIVE_CORE_X_IRAM0_PMS_CONSTRAIN_2_REG
   type CORE_X_IRAM0_PMS_CONSTRAIN_2_Register is record
      --  core_x_iram0_pms_constrain_sram_world_0_pms_0
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0                : CORE_X_IRAM0_PMS_CONSTRAIN_2_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field :=
                                                                      16#7#;
      --  core_x_iram0_pms_constrain_sram_world_0_pms_1
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1                : CORE_X_IRAM0_PMS_CONSTRAIN_2_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field :=
                                                                      16#7#;
      --  core_x_iram0_pms_constrain_sram_world_0_pms_2
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2                : CORE_X_IRAM0_PMS_CONSTRAIN_2_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field :=
                                                                      16#7#;
      --  core_x_iram0_pms_constrain_sram_world_0_pms_3
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3                : CORE_X_IRAM0_PMS_CONSTRAIN_2_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field :=
                                                                      16#7#;
      --  core_x_iram0_pms_constrain_sram_world_0_cachedataarray_pms_0
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_CACHEDATAARRAY_PMS_0 : CORE_X_IRAM0_PMS_CONSTRAIN_2_CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_CACHEDATAARRAY_PMS_0_Field :=
                                                                      16#7#;
      --  unspecified
      Reserved_15_17                                               : ESP32_C3.UInt3 :=
                                                                      16#0#;
      --  core_x_iram0_pms_constrain_rom_world_0_pms
      CORE_X_IRAM0_PMS_CONSTRAIN_ROM_WORLD_0_PMS                   : CORE_X_IRAM0_PMS_CONSTRAIN_2_CORE_X_IRAM0_PMS_CONSTRAIN_ROM_WORLD_0_PMS_Field :=
                                                                      16#7#;
      --  unspecified
      Reserved_21_31                                               : ESP32_C3.UInt11 :=
                                                                      16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_X_IRAM0_PMS_CONSTRAIN_2_Register use record
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0                at 0 range 0 .. 2;
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1                at 0 range 3 .. 5;
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2                at 0 range 6 .. 8;
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3                at 0 range 9 .. 11;
      CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_CACHEDATAARRAY_PMS_0 at 0 range 12 .. 14;
      Reserved_15_17                                               at 0 range 15 .. 17;
      CORE_X_IRAM0_PMS_CONSTRAIN_ROM_WORLD_0_PMS                   at 0 range 18 .. 20;
      Reserved_21_31                                               at 0 range 21 .. 31;
   end record;

   subtype CORE_0_IRAM0_PMS_MONITOR_0_CORE_0_IRAM0_PMS_MONITOR_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_CORE_0_IRAM0_PMS_MONITOR_0_REG
   type CORE_0_IRAM0_PMS_MONITOR_0_Register is record
      --  core_0_iram0_pms_monitor_lock
      CORE_0_IRAM0_PMS_MONITOR_LOCK : CORE_0_IRAM0_PMS_MONITOR_0_CORE_0_IRAM0_PMS_MONITOR_LOCK_Field :=
                                       16#0#;
      --  unspecified
      Reserved_1_31                 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_IRAM0_PMS_MONITOR_0_Register use record
      CORE_0_IRAM0_PMS_MONITOR_LOCK at 0 range 0 .. 0;
      Reserved_1_31                 at 0 range 1 .. 31;
   end record;

   subtype CORE_0_IRAM0_PMS_MONITOR_1_CORE_0_IRAM0_PMS_MONITOR_VIOLATE_CLR_Field is
     ESP32_C3.Bit;
   subtype CORE_0_IRAM0_PMS_MONITOR_1_CORE_0_IRAM0_PMS_MONITOR_VIOLATE_EN_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_CORE_0_IRAM0_PMS_MONITOR_1_REG
   type CORE_0_IRAM0_PMS_MONITOR_1_Register is record
      --  core_0_iram0_pms_monitor_violate_clr
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_CLR : CORE_0_IRAM0_PMS_MONITOR_1_CORE_0_IRAM0_PMS_MONITOR_VIOLATE_CLR_Field :=
                                              16#1#;
      --  core_0_iram0_pms_monitor_violate_en
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_EN  : CORE_0_IRAM0_PMS_MONITOR_1_CORE_0_IRAM0_PMS_MONITOR_VIOLATE_EN_Field :=
                                              16#1#;
      --  unspecified
      Reserved_2_31                        : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_IRAM0_PMS_MONITOR_1_Register use record
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_CLR at 0 range 0 .. 0;
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_EN  at 0 range 1 .. 1;
      Reserved_2_31                        at 0 range 2 .. 31;
   end record;

   subtype CORE_0_IRAM0_PMS_MONITOR_2_CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_Field is
     ESP32_C3.Bit;
   subtype CORE_0_IRAM0_PMS_MONITOR_2_CORE_0_IRAM0_PMS_MONITOR_VIOLATE_STATUS_WR_Field is
     ESP32_C3.Bit;
   subtype CORE_0_IRAM0_PMS_MONITOR_2_CORE_0_IRAM0_PMS_MONITOR_VIOLATE_STATUS_LOADSTORE_Field is
     ESP32_C3.Bit;
   subtype CORE_0_IRAM0_PMS_MONITOR_2_CORE_0_IRAM0_PMS_MONITOR_VIOLATE_STATUS_WORLD_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_IRAM0_PMS_MONITOR_2_CORE_0_IRAM0_PMS_MONITOR_VIOLATE_STATUS_ADDR_Field is
     ESP32_C3.UInt24;

   --  SENSITIVE_CORE_0_IRAM0_PMS_MONITOR_2_REG
   type CORE_0_IRAM0_PMS_MONITOR_2_Register is record
      --  Read-only. core_0_iram0_pms_monitor_violate_intr
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR             : CORE_0_IRAM0_PMS_MONITOR_2_CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_Field;
      --  Read-only. core_0_iram0_pms_monitor_violate_status_wr
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_STATUS_WR        : CORE_0_IRAM0_PMS_MONITOR_2_CORE_0_IRAM0_PMS_MONITOR_VIOLATE_STATUS_WR_Field;
      --  Read-only. core_0_iram0_pms_monitor_violate_status_loadstore
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_STATUS_LOADSTORE : CORE_0_IRAM0_PMS_MONITOR_2_CORE_0_IRAM0_PMS_MONITOR_VIOLATE_STATUS_LOADSTORE_Field;
      --  Read-only. core_0_iram0_pms_monitor_violate_status_world
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_STATUS_WORLD     : CORE_0_IRAM0_PMS_MONITOR_2_CORE_0_IRAM0_PMS_MONITOR_VIOLATE_STATUS_WORLD_Field;
      --  Read-only. core_0_iram0_pms_monitor_violate_status_addr
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_STATUS_ADDR      : CORE_0_IRAM0_PMS_MONITOR_2_CORE_0_IRAM0_PMS_MONITOR_VIOLATE_STATUS_ADDR_Field;
      --  unspecified
      Reserved_29_31                                    : ESP32_C3.UInt3;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_IRAM0_PMS_MONITOR_2_Register use record
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR             at 0 range 0 .. 0;
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_STATUS_WR        at 0 range 1 .. 1;
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_STATUS_LOADSTORE at 0 range 2 .. 2;
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_STATUS_WORLD     at 0 range 3 .. 4;
      CORE_0_IRAM0_PMS_MONITOR_VIOLATE_STATUS_ADDR      at 0 range 5 .. 28;
      Reserved_29_31                                    at 0 range 29 .. 31;
   end record;

   subtype CORE_X_DRAM0_PMS_CONSTRAIN_0_CORE_X_DRAM0_PMS_CONSTRAIN_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_CORE_X_DRAM0_PMS_CONSTRAIN_0_REG
   type CORE_X_DRAM0_PMS_CONSTRAIN_0_Register is record
      --  core_x_dram0_pms_constrain_lock
      CORE_X_DRAM0_PMS_CONSTRAIN_LOCK : CORE_X_DRAM0_PMS_CONSTRAIN_0_CORE_X_DRAM0_PMS_CONSTRAIN_LOCK_Field :=
                                         16#0#;
      --  unspecified
      Reserved_1_31                   : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_X_DRAM0_PMS_CONSTRAIN_0_Register use record
      CORE_X_DRAM0_PMS_CONSTRAIN_LOCK at 0 range 0 .. 0;
      Reserved_1_31                   at 0 range 1 .. 31;
   end record;

   subtype CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_ROM_WORLD_0_PMS_Field is
     ESP32_C3.UInt2;
   subtype CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_ROM_WORLD_1_PMS_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_CORE_X_DRAM0_PMS_CONSTRAIN_1_REG
   type CORE_X_DRAM0_PMS_CONSTRAIN_1_Register is record
      --  core_x_dram0_pms_constrain_sram_world_0_pms_0
      CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 : CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0_Field :=
                                                       16#3#;
      --  core_x_dram0_pms_constrain_sram_world_0_pms_1
      CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 : CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1_Field :=
                                                       16#3#;
      --  core_x_dram0_pms_constrain_sram_world_0_pms_2
      CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 : CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2_Field :=
                                                       16#3#;
      --  core_x_dram0_pms_constrain_sram_world_0_pms_3
      CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 : CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3_Field :=
                                                       16#3#;
      --  unspecified
      Reserved_8_11                                 : ESP32_C3.UInt4 := 16#0#;
      --  core_x_dram0_pms_constrain_sram_world_1_pms_0
      CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 : CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0_Field :=
                                                       16#3#;
      --  core_x_dram0_pms_constrain_sram_world_1_pms_1
      CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 : CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1_Field :=
                                                       16#3#;
      --  core_x_dram0_pms_constrain_sram_world_1_pms_2
      CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 : CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2_Field :=
                                                       16#3#;
      --  core_x_dram0_pms_constrain_sram_world_1_pms_3
      CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 : CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3_Field :=
                                                       16#3#;
      --  unspecified
      Reserved_20_23                                : ESP32_C3.UInt4 := 16#0#;
      --  core_x_dram0_pms_constrain_rom_world_0_pms
      CORE_X_DRAM0_PMS_CONSTRAIN_ROM_WORLD_0_PMS    : CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_ROM_WORLD_0_PMS_Field :=
                                                       16#3#;
      --  core_x_dram0_pms_constrain_rom_world_1_pms
      CORE_X_DRAM0_PMS_CONSTRAIN_ROM_WORLD_1_PMS    : CORE_X_DRAM0_PMS_CONSTRAIN_1_CORE_X_DRAM0_PMS_CONSTRAIN_ROM_WORLD_1_PMS_Field :=
                                                       16#3#;
      --  unspecified
      Reserved_28_31                                : ESP32_C3.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_X_DRAM0_PMS_CONSTRAIN_1_Register use record
      CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_0 at 0 range 0 .. 1;
      CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_1 at 0 range 2 .. 3;
      CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_2 at 0 range 4 .. 5;
      CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_0_PMS_3 at 0 range 6 .. 7;
      Reserved_8_11                                 at 0 range 8 .. 11;
      CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 at 0 range 12 .. 13;
      CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 at 0 range 14 .. 15;
      CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 at 0 range 16 .. 17;
      CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 at 0 range 18 .. 19;
      Reserved_20_23                                at 0 range 20 .. 23;
      CORE_X_DRAM0_PMS_CONSTRAIN_ROM_WORLD_0_PMS    at 0 range 24 .. 25;
      CORE_X_DRAM0_PMS_CONSTRAIN_ROM_WORLD_1_PMS    at 0 range 26 .. 27;
      Reserved_28_31                                at 0 range 28 .. 31;
   end record;

   subtype CORE_0_DRAM0_PMS_MONITOR_0_CORE_0_DRAM0_PMS_MONITOR_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_CORE_0_DRAM0_PMS_MONITOR_0_REG
   type CORE_0_DRAM0_PMS_MONITOR_0_Register is record
      --  core_0_dram0_pms_monitor_lock
      CORE_0_DRAM0_PMS_MONITOR_LOCK : CORE_0_DRAM0_PMS_MONITOR_0_CORE_0_DRAM0_PMS_MONITOR_LOCK_Field :=
                                       16#0#;
      --  unspecified
      Reserved_1_31                 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_DRAM0_PMS_MONITOR_0_Register use record
      CORE_0_DRAM0_PMS_MONITOR_LOCK at 0 range 0 .. 0;
      Reserved_1_31                 at 0 range 1 .. 31;
   end record;

   subtype CORE_0_DRAM0_PMS_MONITOR_1_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_CLR_Field is
     ESP32_C3.Bit;
   subtype CORE_0_DRAM0_PMS_MONITOR_1_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_EN_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_CORE_0_DRAM0_PMS_MONITOR_1_REG
   type CORE_0_DRAM0_PMS_MONITOR_1_Register is record
      --  core_0_dram0_pms_monitor_violate_clr
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_CLR : CORE_0_DRAM0_PMS_MONITOR_1_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_CLR_Field :=
                                              16#1#;
      --  core_0_dram0_pms_monitor_violate_en
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_EN  : CORE_0_DRAM0_PMS_MONITOR_1_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_EN_Field :=
                                              16#1#;
      --  unspecified
      Reserved_2_31                        : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_DRAM0_PMS_MONITOR_1_Register use record
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_CLR at 0 range 0 .. 0;
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_EN  at 0 range 1 .. 1;
      Reserved_2_31                        at 0 range 2 .. 31;
   end record;

   subtype CORE_0_DRAM0_PMS_MONITOR_2_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_Field is
     ESP32_C3.Bit;
   subtype CORE_0_DRAM0_PMS_MONITOR_2_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_LOCK_Field is
     ESP32_C3.Bit;
   subtype CORE_0_DRAM0_PMS_MONITOR_2_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_WORLD_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_DRAM0_PMS_MONITOR_2_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_ADDR_Field is
     ESP32_C3.UInt24;

   --  SENSITIVE_CORE_0_DRAM0_PMS_MONITOR_2_REG
   type CORE_0_DRAM0_PMS_MONITOR_2_Register is record
      --  Read-only. core_0_dram0_pms_monitor_violate_intr
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR         : CORE_0_DRAM0_PMS_MONITOR_2_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_Field;
      --  Read-only. core_0_dram0_pms_monitor_violate_status_lock
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_LOCK  : CORE_0_DRAM0_PMS_MONITOR_2_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_LOCK_Field;
      --  Read-only. core_0_dram0_pms_monitor_violate_status_world
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_WORLD : CORE_0_DRAM0_PMS_MONITOR_2_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_WORLD_Field;
      --  Read-only. core_0_dram0_pms_monitor_violate_status_addr
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_ADDR  : CORE_0_DRAM0_PMS_MONITOR_2_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_ADDR_Field;
      --  unspecified
      Reserved_28_31                                : ESP32_C3.UInt4;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_DRAM0_PMS_MONITOR_2_Register use record
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR         at 0 range 0 .. 0;
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_LOCK  at 0 range 1 .. 1;
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_WORLD at 0 range 2 .. 3;
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_ADDR  at 0 range 4 .. 27;
      Reserved_28_31                                at 0 range 28 .. 31;
   end record;

   subtype CORE_0_DRAM0_PMS_MONITOR_3_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_WR_Field is
     ESP32_C3.Bit;
   subtype CORE_0_DRAM0_PMS_MONITOR_3_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_BYTEEN_Field is
     ESP32_C3.UInt4;

   --  SENSITIVE_CORE_0_DRAM0_PMS_MONITOR_3_REG
   type CORE_0_DRAM0_PMS_MONITOR_3_Register is record
      --  Read-only. core_0_dram0_pms_monitor_violate_status_wr
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_WR     : CORE_0_DRAM0_PMS_MONITOR_3_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_WR_Field;
      --  Read-only. core_0_dram0_pms_monitor_violate_status_byteen
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_BYTEEN : CORE_0_DRAM0_PMS_MONITOR_3_CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_BYTEEN_Field;
      --  unspecified
      Reserved_5_31                                  : ESP32_C3.UInt27;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_DRAM0_PMS_MONITOR_3_Register use record
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_WR     at 0 range 0 .. 0;
      CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_BYTEEN at 0 range 1 .. 4;
      Reserved_5_31                                  at 0 range 5 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_CONSTRAIN_0_CORE_0_PIF_PMS_CONSTRAIN_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_0_REG
   type CORE_0_PIF_PMS_CONSTRAIN_0_Register is record
      --  core_0_pif_pms_constrain_lock
      CORE_0_PIF_PMS_CONSTRAIN_LOCK : CORE_0_PIF_PMS_CONSTRAIN_0_CORE_0_PIF_PMS_CONSTRAIN_LOCK_Field :=
                                       16#0#;
      --  unspecified
      Reserved_1_31                 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_CONSTRAIN_0_Register use record
      CORE_0_PIF_PMS_CONSTRAIN_LOCK at 0 range 0 .. 0;
      Reserved_1_31                 at 0 range 1 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_UART_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_G0SPI_1_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_G0SPI_0_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_GPIO_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_FE2_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_FE_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMER_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_RTC_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_IO_MUX_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_WDG_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_MISC_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_I2C_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_UART1_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_1_REG
   type CORE_0_PIF_PMS_CONSTRAIN_1_Register is record
      --  core_0_pif_pms_constrain_world_0_uart
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_UART    : CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_UART_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_0_g0spi_1
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_G0SPI_1 : CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_G0SPI_1_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_0_g0spi_0
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_G0SPI_0 : CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_G0SPI_0_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_0_gpio
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_GPIO    : CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_GPIO_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_0_fe2
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_FE2     : CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_FE2_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_0_fe
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_FE      : CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_FE_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_0_timer
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMER   : CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMER_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_0_rtc
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_RTC     : CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_RTC_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_0_io_mux
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_IO_MUX  : CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_IO_MUX_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_0_wdg
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_WDG     : CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_WDG_Field :=
                                                  16#3#;
      --  unspecified
      Reserved_20_23                           : ESP32_C3.UInt4 := 16#0#;
      --  core_0_pif_pms_constrain_world_0_misc
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_MISC    : CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_MISC_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_0_i2c
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_I2C     : CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_I2C_Field :=
                                                  16#3#;
      --  unspecified
      Reserved_28_29                           : ESP32_C3.UInt2 := 16#0#;
      --  core_0_pif_pms_constrain_world_0_uart1
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_UART1   : CORE_0_PIF_PMS_CONSTRAIN_1_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_UART1_Field :=
                                                  16#3#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_CONSTRAIN_1_Register use record
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_UART    at 0 range 0 .. 1;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_G0SPI_1 at 0 range 2 .. 3;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_G0SPI_0 at 0 range 4 .. 5;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_GPIO    at 0 range 6 .. 7;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_FE2     at 0 range 8 .. 9;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_FE      at 0 range 10 .. 11;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMER   at 0 range 12 .. 13;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_RTC     at 0 range 14 .. 15;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_IO_MUX  at 0 range 16 .. 17;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_WDG     at 0 range 18 .. 19;
      Reserved_20_23                           at 0 range 20 .. 23;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_MISC    at 0 range 24 .. 25;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_I2C     at 0 range 26 .. 27;
      Reserved_28_29                           at 0 range 28 .. 29;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_UART1   at 0 range 30 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_BT_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_I2C_EXT0_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_UHCI0_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_RMT_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_LEDC_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_BB_Field is
     ESP32_C3.UInt2;
   --  CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMERGROUP
   --  array element
   subtype CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMERGROUP_Element is
     ESP32_C3.UInt2;

   --  CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMERGROUP
   --  array
   type CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMERGROUP_Field_Array is array (1 .. 2)
     of CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMERGROUP_Element
     with Component_Size => 2, Size => 4;

   --  Type definition for
   --  CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMERGROUP
   type CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMERGROUP_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMERGROUP as a value
            Val : ESP32_C3.UInt4;
         when True =>
            --  CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMERGROUP as an array
            Arr : CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMERGROUP_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 4;

   for CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMERGROUP_Field use record
      Val at 0 range 0 .. 3;
      Arr at 0 range 0 .. 3;
   end record;

   subtype CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_SYSTIMER_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_2_REG
   type CORE_0_PIF_PMS_CONSTRAIN_2_Register is record
      --  core_0_pif_pms_constrain_world_0_bt
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_BT         : CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_BT_Field :=
                                                     16#3#;
      --  unspecified
      Reserved_2_3                                : ESP32_C3.UInt2 := 16#0#;
      --  core_0_pif_pms_constrain_world_0_i2c_ext0
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_I2C_EXT0   : CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_I2C_EXT0_Field :=
                                                     16#3#;
      --  core_0_pif_pms_constrain_world_0_uhci0
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_UHCI0      : CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_UHCI0_Field :=
                                                     16#3#;
      --  unspecified
      Reserved_8_9                                : ESP32_C3.UInt2 := 16#0#;
      --  core_0_pif_pms_constrain_world_0_rmt
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_RMT        : CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_RMT_Field :=
                                                     16#3#;
      --  unspecified
      Reserved_12_15                              : ESP32_C3.UInt4 := 16#0#;
      --  core_0_pif_pms_constrain_world_0_ledc
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_LEDC       : CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_LEDC_Field :=
                                                     16#3#;
      --  unspecified
      Reserved_18_21                              : ESP32_C3.UInt4 := 16#0#;
      --  core_0_pif_pms_constrain_world_0_bb
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_BB         : CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_BB_Field :=
                                                     16#3#;
      --  unspecified
      Reserved_24_25                              : ESP32_C3.UInt2 := 16#0#;
      --  core_0_pif_pms_constrain_world_0_timergroup
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMERGROUP : CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMERGROUP_Field :=
                                                     (As_Array => False, Val => 16#3#);
      --  core_0_pif_pms_constrain_world_0_systimer
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_SYSTIMER   : CORE_0_PIF_PMS_CONSTRAIN_2_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_SYSTIMER_Field :=
                                                     16#3#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_CONSTRAIN_2_Register use record
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_BT         at 0 range 0 .. 1;
      Reserved_2_3                                at 0 range 2 .. 3;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_I2C_EXT0   at 0 range 4 .. 5;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_UHCI0      at 0 range 6 .. 7;
      Reserved_8_9                                at 0 range 8 .. 9;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_RMT        at 0 range 10 .. 11;
      Reserved_12_15                              at 0 range 12 .. 15;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_LEDC       at 0 range 16 .. 17;
      Reserved_18_21                              at 0 range 18 .. 21;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_BB         at 0 range 22 .. 23;
      Reserved_24_25                              at 0 range 24 .. 25;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_TIMERGROUP at 0 range 26 .. 29;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_SYSTIMER   at 0 range 30 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_CONSTRAIN_3_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_SPI_2_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_3_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_APB_CTRL_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_3_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_CAN_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_3_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_I2S1_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_3_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_RWBT_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_3_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_WIFIMAC_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_3_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_PWR_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_3_REG
   type CORE_0_PIF_PMS_CONSTRAIN_3_Register is record
      --  core_0_pif_pms_constrain_world_0_spi_2
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_SPI_2    : CORE_0_PIF_PMS_CONSTRAIN_3_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_SPI_2_Field :=
                                                   16#3#;
      --  unspecified
      Reserved_2_3                              : ESP32_C3.UInt2 := 16#0#;
      --  core_0_pif_pms_constrain_world_0_apb_ctrl
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_APB_CTRL : CORE_0_PIF_PMS_CONSTRAIN_3_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_APB_CTRL_Field :=
                                                   16#3#;
      --  unspecified
      Reserved_6_9                              : ESP32_C3.UInt4 := 16#0#;
      --  core_0_pif_pms_constrain_world_0_can
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_CAN      : CORE_0_PIF_PMS_CONSTRAIN_3_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_CAN_Field :=
                                                   16#3#;
      --  unspecified
      Reserved_12_13                            : ESP32_C3.UInt2 := 16#0#;
      --  core_0_pif_pms_constrain_world_0_i2s1
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_I2S1     : CORE_0_PIF_PMS_CONSTRAIN_3_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_I2S1_Field :=
                                                   16#3#;
      --  unspecified
      Reserved_16_21                            : ESP32_C3.UInt6 := 16#0#;
      --  core_0_pif_pms_constrain_world_0_rwbt
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_RWBT     : CORE_0_PIF_PMS_CONSTRAIN_3_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_RWBT_Field :=
                                                   16#3#;
      --  unspecified
      Reserved_24_25                            : ESP32_C3.UInt2 := 16#0#;
      --  core_0_pif_pms_constrain_world_0_wifimac
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_WIFIMAC  : CORE_0_PIF_PMS_CONSTRAIN_3_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_WIFIMAC_Field :=
                                                   16#3#;
      --  core_0_pif_pms_constrain_world_0_pwr
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_PWR      : CORE_0_PIF_PMS_CONSTRAIN_3_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_PWR_Field :=
                                                   16#3#;
      --  unspecified
      Reserved_30_31                            : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_CONSTRAIN_3_Register use record
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_SPI_2    at 0 range 0 .. 1;
      Reserved_2_3                              at 0 range 2 .. 3;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_APB_CTRL at 0 range 4 .. 5;
      Reserved_6_9                              at 0 range 6 .. 9;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_CAN      at 0 range 10 .. 11;
      Reserved_12_13                            at 0 range 12 .. 13;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_I2S1     at 0 range 14 .. 15;
      Reserved_16_21                            at 0 range 16 .. 21;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_RWBT     at 0 range 22 .. 23;
      Reserved_24_25                            at 0 range 24 .. 25;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_WIFIMAC  at 0 range 26 .. 27;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_PWR      at 0 range 28 .. 29;
      Reserved_30_31                            at 0 range 30 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_USB_WRAP_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_CRYPTO_PERI_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_CRYPTO_DMA_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_APB_ADC_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_BT_PWR_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_USB_DEVICE_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_SYSTEM_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_SENSITIVE_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_INTERRUPT_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_DMA_COPY_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_CACHE_CONFIG_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_AD_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_DIO_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_WORLD_CONTROLLER_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_4_REG
   type CORE_0_PIF_PMS_CONSTRAIN_4_Register is record
      --  unspecified
      Reserved_0_1                                      : ESP32_C3.UInt2 :=
                                                           16#0#;
      --  core_0_pif_pms_constrain_world_0_usb_wrap
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_USB_WRAP         : CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_USB_WRAP_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_0_crypto_peri
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_CRYPTO_PERI      : CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_CRYPTO_PERI_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_0_crypto_dma
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_CRYPTO_DMA       : CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_CRYPTO_DMA_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_0_apb_adc
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_APB_ADC          : CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_APB_ADC_Field :=
                                                           16#3#;
      --  unspecified
      Reserved_10_11                                    : ESP32_C3.UInt2 :=
                                                           16#0#;
      --  core_0_pif_pms_constrain_world_0_bt_pwr
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_BT_PWR           : CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_BT_PWR_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_0_usb_device
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_USB_DEVICE       : CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_USB_DEVICE_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_0_system
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_SYSTEM           : CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_SYSTEM_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_0_sensitive
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_SENSITIVE        : CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_SENSITIVE_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_0_interrupt
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_INTERRUPT        : CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_INTERRUPT_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_0_dma_copy
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_DMA_COPY         : CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_DMA_COPY_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_0_cache_config
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_CACHE_CONFIG     : CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_CACHE_CONFIG_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_0_ad
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_AD               : CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_AD_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_0_dio
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_DIO              : CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_DIO_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_0_world_controller
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_WORLD_CONTROLLER : CORE_0_PIF_PMS_CONSTRAIN_4_CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_WORLD_CONTROLLER_Field :=
                                                           16#3#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_CONSTRAIN_4_Register use record
      Reserved_0_1                                      at 0 range 0 .. 1;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_USB_WRAP         at 0 range 2 .. 3;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_CRYPTO_PERI      at 0 range 4 .. 5;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_CRYPTO_DMA       at 0 range 6 .. 7;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_APB_ADC          at 0 range 8 .. 9;
      Reserved_10_11                                    at 0 range 10 .. 11;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_BT_PWR           at 0 range 12 .. 13;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_USB_DEVICE       at 0 range 14 .. 15;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_SYSTEM           at 0 range 16 .. 17;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_SENSITIVE        at 0 range 18 .. 19;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_INTERRUPT        at 0 range 20 .. 21;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_DMA_COPY         at 0 range 22 .. 23;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_CACHE_CONFIG     at 0 range 24 .. 25;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_AD               at 0 range 26 .. 27;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_DIO              at 0 range 28 .. 29;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_0_WORLD_CONTROLLER at 0 range 30 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_UART_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_G0SPI_1_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_G0SPI_0_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_GPIO_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_FE2_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_FE_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMER_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_RTC_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_IO_MUX_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_WDG_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_MISC_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_I2C_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_UART1_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_5_REG
   type CORE_0_PIF_PMS_CONSTRAIN_5_Register is record
      --  core_0_pif_pms_constrain_world_1_uart
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_UART    : CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_UART_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_1_g0spi_1
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_G0SPI_1 : CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_G0SPI_1_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_1_g0spi_0
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_G0SPI_0 : CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_G0SPI_0_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_1_gpio
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_GPIO    : CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_GPIO_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_1_fe2
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_FE2     : CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_FE2_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_1_fe
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_FE      : CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_FE_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_1_timer
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMER   : CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMER_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_1_rtc
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_RTC     : CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_RTC_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_1_io_mux
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_IO_MUX  : CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_IO_MUX_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_1_wdg
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_WDG     : CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_WDG_Field :=
                                                  16#3#;
      --  unspecified
      Reserved_20_23                           : ESP32_C3.UInt4 := 16#0#;
      --  core_0_pif_pms_constrain_world_1_misc
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_MISC    : CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_MISC_Field :=
                                                  16#3#;
      --  core_0_pif_pms_constrain_world_1_i2c
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_I2C     : CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_I2C_Field :=
                                                  16#3#;
      --  unspecified
      Reserved_28_29                           : ESP32_C3.UInt2 := 16#0#;
      --  core_0_pif_pms_constrain_world_1_uart1
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_UART1   : CORE_0_PIF_PMS_CONSTRAIN_5_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_UART1_Field :=
                                                  16#3#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_CONSTRAIN_5_Register use record
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_UART    at 0 range 0 .. 1;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_G0SPI_1 at 0 range 2 .. 3;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_G0SPI_0 at 0 range 4 .. 5;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_GPIO    at 0 range 6 .. 7;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_FE2     at 0 range 8 .. 9;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_FE      at 0 range 10 .. 11;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMER   at 0 range 12 .. 13;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_RTC     at 0 range 14 .. 15;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_IO_MUX  at 0 range 16 .. 17;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_WDG     at 0 range 18 .. 19;
      Reserved_20_23                           at 0 range 20 .. 23;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_MISC    at 0 range 24 .. 25;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_I2C     at 0 range 26 .. 27;
      Reserved_28_29                           at 0 range 28 .. 29;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_UART1   at 0 range 30 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_BT_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_I2C_EXT0_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_UHCI0_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_RMT_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_LEDC_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_BB_Field is
     ESP32_C3.UInt2;
   --  CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMERGROUP
   --  array element
   subtype CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMERGROUP_Element is
     ESP32_C3.UInt2;

   --  CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMERGROUP
   --  array
   type CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMERGROUP_Field_Array is array (1 .. 2)
     of CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMERGROUP_Element
     with Component_Size => 2, Size => 4;

   --  Type definition for
   --  CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMERGROUP
   type CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMERGROUP_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMERGROUP as a value
            Val : ESP32_C3.UInt4;
         when True =>
            --  CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMERGROUP as an array
            Arr : CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMERGROUP_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 4;

   for CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMERGROUP_Field use record
      Val at 0 range 0 .. 3;
      Arr at 0 range 0 .. 3;
   end record;

   subtype CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_SYSTIMER_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_6_REG
   type CORE_0_PIF_PMS_CONSTRAIN_6_Register is record
      --  core_0_pif_pms_constrain_world_1_bt
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_BT         : CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_BT_Field :=
                                                     16#3#;
      --  unspecified
      Reserved_2_3                                : ESP32_C3.UInt2 := 16#0#;
      --  core_0_pif_pms_constrain_world_1_i2c_ext0
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_I2C_EXT0   : CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_I2C_EXT0_Field :=
                                                     16#3#;
      --  core_0_pif_pms_constrain_world_1_uhci0
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_UHCI0      : CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_UHCI0_Field :=
                                                     16#3#;
      --  unspecified
      Reserved_8_9                                : ESP32_C3.UInt2 := 16#0#;
      --  core_0_pif_pms_constrain_world_1_rmt
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_RMT        : CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_RMT_Field :=
                                                     16#3#;
      --  unspecified
      Reserved_12_15                              : ESP32_C3.UInt4 := 16#0#;
      --  core_0_pif_pms_constrain_world_1_ledc
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_LEDC       : CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_LEDC_Field :=
                                                     16#3#;
      --  unspecified
      Reserved_18_21                              : ESP32_C3.UInt4 := 16#0#;
      --  core_0_pif_pms_constrain_world_1_bb
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_BB         : CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_BB_Field :=
                                                     16#3#;
      --  unspecified
      Reserved_24_25                              : ESP32_C3.UInt2 := 16#0#;
      --  core_0_pif_pms_constrain_world_1_timergroup
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMERGROUP : CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMERGROUP_Field :=
                                                     (As_Array => False, Val => 16#3#);
      --  core_0_pif_pms_constrain_world_1_systimer
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_SYSTIMER   : CORE_0_PIF_PMS_CONSTRAIN_6_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_SYSTIMER_Field :=
                                                     16#3#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_CONSTRAIN_6_Register use record
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_BT         at 0 range 0 .. 1;
      Reserved_2_3                                at 0 range 2 .. 3;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_I2C_EXT0   at 0 range 4 .. 5;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_UHCI0      at 0 range 6 .. 7;
      Reserved_8_9                                at 0 range 8 .. 9;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_RMT        at 0 range 10 .. 11;
      Reserved_12_15                              at 0 range 12 .. 15;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_LEDC       at 0 range 16 .. 17;
      Reserved_18_21                              at 0 range 18 .. 21;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_BB         at 0 range 22 .. 23;
      Reserved_24_25                              at 0 range 24 .. 25;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_TIMERGROUP at 0 range 26 .. 29;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_SYSTIMER   at 0 range 30 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_CONSTRAIN_7_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_SPI_2_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_7_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_APB_CTRL_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_7_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_CAN_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_7_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_I2S1_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_7_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_RWBT_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_7_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_WIFIMAC_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_7_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_PWR_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_7_REG
   type CORE_0_PIF_PMS_CONSTRAIN_7_Register is record
      --  core_0_pif_pms_constrain_world_1_spi_2
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_SPI_2    : CORE_0_PIF_PMS_CONSTRAIN_7_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_SPI_2_Field :=
                                                   16#3#;
      --  unspecified
      Reserved_2_3                              : ESP32_C3.UInt2 := 16#0#;
      --  core_0_pif_pms_constrain_world_1_apb_ctrl
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_APB_CTRL : CORE_0_PIF_PMS_CONSTRAIN_7_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_APB_CTRL_Field :=
                                                   16#3#;
      --  unspecified
      Reserved_6_9                              : ESP32_C3.UInt4 := 16#0#;
      --  core_0_pif_pms_constrain_world_1_can
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_CAN      : CORE_0_PIF_PMS_CONSTRAIN_7_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_CAN_Field :=
                                                   16#3#;
      --  unspecified
      Reserved_12_13                            : ESP32_C3.UInt2 := 16#0#;
      --  core_0_pif_pms_constrain_world_1_i2s1
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_I2S1     : CORE_0_PIF_PMS_CONSTRAIN_7_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_I2S1_Field :=
                                                   16#3#;
      --  unspecified
      Reserved_16_21                            : ESP32_C3.UInt6 := 16#0#;
      --  core_0_pif_pms_constrain_world_1_rwbt
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_RWBT     : CORE_0_PIF_PMS_CONSTRAIN_7_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_RWBT_Field :=
                                                   16#3#;
      --  unspecified
      Reserved_24_25                            : ESP32_C3.UInt2 := 16#0#;
      --  core_0_pif_pms_constrain_world_1_wifimac
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_WIFIMAC  : CORE_0_PIF_PMS_CONSTRAIN_7_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_WIFIMAC_Field :=
                                                   16#3#;
      --  core_0_pif_pms_constrain_world_1_pwr
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_PWR      : CORE_0_PIF_PMS_CONSTRAIN_7_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_PWR_Field :=
                                                   16#3#;
      --  unspecified
      Reserved_30_31                            : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_CONSTRAIN_7_Register use record
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_SPI_2    at 0 range 0 .. 1;
      Reserved_2_3                              at 0 range 2 .. 3;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_APB_CTRL at 0 range 4 .. 5;
      Reserved_6_9                              at 0 range 6 .. 9;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_CAN      at 0 range 10 .. 11;
      Reserved_12_13                            at 0 range 12 .. 13;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_I2S1     at 0 range 14 .. 15;
      Reserved_16_21                            at 0 range 16 .. 21;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_RWBT     at 0 range 22 .. 23;
      Reserved_24_25                            at 0 range 24 .. 25;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_WIFIMAC  at 0 range 26 .. 27;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_PWR      at 0 range 28 .. 29;
      Reserved_30_31                            at 0 range 30 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_USB_WRAP_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_CRYPTO_PERI_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_CRYPTO_DMA_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_APB_ADC_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_BT_PWR_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_USB_DEVICE_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_SYSTEM_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_SENSITIVE_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_INTERRUPT_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_DMA_COPY_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_CACHE_CONFIG_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_AD_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_DIO_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_WORLD_CONTROLLER_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_8_REG
   type CORE_0_PIF_PMS_CONSTRAIN_8_Register is record
      --  unspecified
      Reserved_0_1                                      : ESP32_C3.UInt2 :=
                                                           16#0#;
      --  core_0_pif_pms_constrain_world_1_usb_wrap
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_USB_WRAP         : CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_USB_WRAP_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_1_crypto_peri
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_CRYPTO_PERI      : CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_CRYPTO_PERI_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_1_crypto_dma
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_CRYPTO_DMA       : CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_CRYPTO_DMA_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_1_apb_adc
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_APB_ADC          : CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_APB_ADC_Field :=
                                                           16#3#;
      --  unspecified
      Reserved_10_11                                    : ESP32_C3.UInt2 :=
                                                           16#0#;
      --  core_0_pif_pms_constrain_world_1_bt_pwr
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_BT_PWR           : CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_BT_PWR_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_1_usb_device
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_USB_DEVICE       : CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_USB_DEVICE_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_1_system
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_SYSTEM           : CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_SYSTEM_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_1_sensitive
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_SENSITIVE        : CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_SENSITIVE_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_1_interrupt
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_INTERRUPT        : CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_INTERRUPT_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_1_dma_copy
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_DMA_COPY         : CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_DMA_COPY_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_1_cache_config
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_CACHE_CONFIG     : CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_CACHE_CONFIG_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_1_ad
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_AD               : CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_AD_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_1_dio
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_DIO              : CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_DIO_Field :=
                                                           16#3#;
      --  core_0_pif_pms_constrain_world_1_world_controller
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_WORLD_CONTROLLER : CORE_0_PIF_PMS_CONSTRAIN_8_CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_WORLD_CONTROLLER_Field :=
                                                           16#3#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_CONSTRAIN_8_Register use record
      Reserved_0_1                                      at 0 range 0 .. 1;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_USB_WRAP         at 0 range 2 .. 3;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_CRYPTO_PERI      at 0 range 4 .. 5;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_CRYPTO_DMA       at 0 range 6 .. 7;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_APB_ADC          at 0 range 8 .. 9;
      Reserved_10_11                                    at 0 range 10 .. 11;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_BT_PWR           at 0 range 12 .. 13;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_USB_DEVICE       at 0 range 14 .. 15;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_SYSTEM           at 0 range 16 .. 17;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_SENSITIVE        at 0 range 18 .. 19;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_INTERRUPT        at 0 range 20 .. 21;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_DMA_COPY         at 0 range 22 .. 23;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_CACHE_CONFIG     at 0 range 24 .. 25;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_AD               at 0 range 26 .. 27;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_DIO              at 0 range 28 .. 29;
      CORE_0_PIF_PMS_CONSTRAIN_WORLD_1_WORLD_CONTROLLER at 0 range 30 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_CONSTRAIN_9_CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_SPLTADDR_WORLD_0_Field is
     ESP32_C3.UInt11;
   subtype CORE_0_PIF_PMS_CONSTRAIN_9_CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_SPLTADDR_WORLD_1_Field is
     ESP32_C3.UInt11;

   --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_9_REG
   type CORE_0_PIF_PMS_CONSTRAIN_9_Register is record
      --  core_0_pif_pms_constrain_rtcfast_spltaddr_world_0
      CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_SPLTADDR_WORLD_0 : CORE_0_PIF_PMS_CONSTRAIN_9_CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_SPLTADDR_WORLD_0_Field :=
                                                           16#7FF#;
      --  core_0_pif_pms_constrain_rtcfast_spltaddr_world_1
      CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_SPLTADDR_WORLD_1 : CORE_0_PIF_PMS_CONSTRAIN_9_CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_SPLTADDR_WORLD_1_Field :=
                                                           16#7FF#;
      --  unspecified
      Reserved_22_31                                    : ESP32_C3.UInt10 :=
                                                           16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_CONSTRAIN_9_Register use record
      CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_SPLTADDR_WORLD_0 at 0 range 0 .. 10;
      CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_SPLTADDR_WORLD_1 at 0 range 11 .. 21;
      Reserved_22_31                                    at 0 range 22 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_CONSTRAIN_10_CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_WORLD_0_L_Field is
     ESP32_C3.UInt3;
   subtype CORE_0_PIF_PMS_CONSTRAIN_10_CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_WORLD_0_H_Field is
     ESP32_C3.UInt3;
   subtype CORE_0_PIF_PMS_CONSTRAIN_10_CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_WORLD_1_L_Field is
     ESP32_C3.UInt3;
   subtype CORE_0_PIF_PMS_CONSTRAIN_10_CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_WORLD_1_H_Field is
     ESP32_C3.UInt3;

   --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_10_REG
   type CORE_0_PIF_PMS_CONSTRAIN_10_Register is record
      --  core_0_pif_pms_constrain_rtcfast_world_0_l
      CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_WORLD_0_L : CORE_0_PIF_PMS_CONSTRAIN_10_CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_WORLD_0_L_Field :=
                                                    16#7#;
      --  core_0_pif_pms_constrain_rtcfast_world_0_h
      CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_WORLD_0_H : CORE_0_PIF_PMS_CONSTRAIN_10_CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_WORLD_0_H_Field :=
                                                    16#7#;
      --  core_0_pif_pms_constrain_rtcfast_world_1_l
      CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_WORLD_1_L : CORE_0_PIF_PMS_CONSTRAIN_10_CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_WORLD_1_L_Field :=
                                                    16#7#;
      --  core_0_pif_pms_constrain_rtcfast_world_1_h
      CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_WORLD_1_H : CORE_0_PIF_PMS_CONSTRAIN_10_CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_WORLD_1_H_Field :=
                                                    16#7#;
      --  unspecified
      Reserved_12_31                             : ESP32_C3.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_CONSTRAIN_10_Register use record
      CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_WORLD_0_L at 0 range 0 .. 2;
      CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_WORLD_0_H at 0 range 3 .. 5;
      CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_WORLD_1_L at 0 range 6 .. 8;
      CORE_0_PIF_PMS_CONSTRAIN_RTCFAST_WORLD_1_H at 0 range 9 .. 11;
      Reserved_12_31                             at 0 range 12 .. 31;
   end record;

   subtype REGION_PMS_CONSTRAIN_0_REGION_PMS_CONSTRAIN_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_REGION_PMS_CONSTRAIN_0_REG
   type REGION_PMS_CONSTRAIN_0_Register is record
      --  region_pms_constrain_lock
      REGION_PMS_CONSTRAIN_LOCK : REGION_PMS_CONSTRAIN_0_REGION_PMS_CONSTRAIN_LOCK_Field :=
                                   16#0#;
      --  unspecified
      Reserved_1_31             : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REGION_PMS_CONSTRAIN_0_Register use record
      REGION_PMS_CONSTRAIN_LOCK at 0 range 0 .. 0;
      Reserved_1_31             at 0 range 1 .. 31;
   end record;

   subtype REGION_PMS_CONSTRAIN_1_REGION_PMS_CONSTRAIN_WORLD_0_AREA_0_Field is
     ESP32_C3.UInt2;
   subtype REGION_PMS_CONSTRAIN_1_REGION_PMS_CONSTRAIN_WORLD_0_AREA_1_Field is
     ESP32_C3.UInt2;
   subtype REGION_PMS_CONSTRAIN_1_REGION_PMS_CONSTRAIN_WORLD_0_AREA_2_Field is
     ESP32_C3.UInt2;
   subtype REGION_PMS_CONSTRAIN_1_REGION_PMS_CONSTRAIN_WORLD_0_AREA_3_Field is
     ESP32_C3.UInt2;
   subtype REGION_PMS_CONSTRAIN_1_REGION_PMS_CONSTRAIN_WORLD_0_AREA_4_Field is
     ESP32_C3.UInt2;
   subtype REGION_PMS_CONSTRAIN_1_REGION_PMS_CONSTRAIN_WORLD_0_AREA_5_Field is
     ESP32_C3.UInt2;
   subtype REGION_PMS_CONSTRAIN_1_REGION_PMS_CONSTRAIN_WORLD_0_AREA_6_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_REGION_PMS_CONSTRAIN_1_REG
   type REGION_PMS_CONSTRAIN_1_Register is record
      --  region_pms_constrain_world_0_area_0
      REGION_PMS_CONSTRAIN_WORLD_0_AREA_0 : REGION_PMS_CONSTRAIN_1_REGION_PMS_CONSTRAIN_WORLD_0_AREA_0_Field :=
                                             16#3#;
      --  region_pms_constrain_world_0_area_1
      REGION_PMS_CONSTRAIN_WORLD_0_AREA_1 : REGION_PMS_CONSTRAIN_1_REGION_PMS_CONSTRAIN_WORLD_0_AREA_1_Field :=
                                             16#3#;
      --  region_pms_constrain_world_0_area_2
      REGION_PMS_CONSTRAIN_WORLD_0_AREA_2 : REGION_PMS_CONSTRAIN_1_REGION_PMS_CONSTRAIN_WORLD_0_AREA_2_Field :=
                                             16#3#;
      --  region_pms_constrain_world_0_area_3
      REGION_PMS_CONSTRAIN_WORLD_0_AREA_3 : REGION_PMS_CONSTRAIN_1_REGION_PMS_CONSTRAIN_WORLD_0_AREA_3_Field :=
                                             16#3#;
      --  region_pms_constrain_world_0_area_4
      REGION_PMS_CONSTRAIN_WORLD_0_AREA_4 : REGION_PMS_CONSTRAIN_1_REGION_PMS_CONSTRAIN_WORLD_0_AREA_4_Field :=
                                             16#3#;
      --  region_pms_constrain_world_0_area_5
      REGION_PMS_CONSTRAIN_WORLD_0_AREA_5 : REGION_PMS_CONSTRAIN_1_REGION_PMS_CONSTRAIN_WORLD_0_AREA_5_Field :=
                                             16#3#;
      --  region_pms_constrain_world_0_area_6
      REGION_PMS_CONSTRAIN_WORLD_0_AREA_6 : REGION_PMS_CONSTRAIN_1_REGION_PMS_CONSTRAIN_WORLD_0_AREA_6_Field :=
                                             16#3#;
      --  unspecified
      Reserved_14_31                      : ESP32_C3.UInt18 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REGION_PMS_CONSTRAIN_1_Register use record
      REGION_PMS_CONSTRAIN_WORLD_0_AREA_0 at 0 range 0 .. 1;
      REGION_PMS_CONSTRAIN_WORLD_0_AREA_1 at 0 range 2 .. 3;
      REGION_PMS_CONSTRAIN_WORLD_0_AREA_2 at 0 range 4 .. 5;
      REGION_PMS_CONSTRAIN_WORLD_0_AREA_3 at 0 range 6 .. 7;
      REGION_PMS_CONSTRAIN_WORLD_0_AREA_4 at 0 range 8 .. 9;
      REGION_PMS_CONSTRAIN_WORLD_0_AREA_5 at 0 range 10 .. 11;
      REGION_PMS_CONSTRAIN_WORLD_0_AREA_6 at 0 range 12 .. 13;
      Reserved_14_31                      at 0 range 14 .. 31;
   end record;

   subtype REGION_PMS_CONSTRAIN_2_REGION_PMS_CONSTRAIN_WORLD_1_AREA_0_Field is
     ESP32_C3.UInt2;
   subtype REGION_PMS_CONSTRAIN_2_REGION_PMS_CONSTRAIN_WORLD_1_AREA_1_Field is
     ESP32_C3.UInt2;
   subtype REGION_PMS_CONSTRAIN_2_REGION_PMS_CONSTRAIN_WORLD_1_AREA_2_Field is
     ESP32_C3.UInt2;
   subtype REGION_PMS_CONSTRAIN_2_REGION_PMS_CONSTRAIN_WORLD_1_AREA_3_Field is
     ESP32_C3.UInt2;
   subtype REGION_PMS_CONSTRAIN_2_REGION_PMS_CONSTRAIN_WORLD_1_AREA_4_Field is
     ESP32_C3.UInt2;
   subtype REGION_PMS_CONSTRAIN_2_REGION_PMS_CONSTRAIN_WORLD_1_AREA_5_Field is
     ESP32_C3.UInt2;
   subtype REGION_PMS_CONSTRAIN_2_REGION_PMS_CONSTRAIN_WORLD_1_AREA_6_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_REGION_PMS_CONSTRAIN_2_REG
   type REGION_PMS_CONSTRAIN_2_Register is record
      --  region_pms_constrain_world_1_area_0
      REGION_PMS_CONSTRAIN_WORLD_1_AREA_0 : REGION_PMS_CONSTRAIN_2_REGION_PMS_CONSTRAIN_WORLD_1_AREA_0_Field :=
                                             16#3#;
      --  region_pms_constrain_world_1_area_1
      REGION_PMS_CONSTRAIN_WORLD_1_AREA_1 : REGION_PMS_CONSTRAIN_2_REGION_PMS_CONSTRAIN_WORLD_1_AREA_1_Field :=
                                             16#3#;
      --  region_pms_constrain_world_1_area_2
      REGION_PMS_CONSTRAIN_WORLD_1_AREA_2 : REGION_PMS_CONSTRAIN_2_REGION_PMS_CONSTRAIN_WORLD_1_AREA_2_Field :=
                                             16#3#;
      --  region_pms_constrain_world_1_area_3
      REGION_PMS_CONSTRAIN_WORLD_1_AREA_3 : REGION_PMS_CONSTRAIN_2_REGION_PMS_CONSTRAIN_WORLD_1_AREA_3_Field :=
                                             16#3#;
      --  region_pms_constrain_world_1_area_4
      REGION_PMS_CONSTRAIN_WORLD_1_AREA_4 : REGION_PMS_CONSTRAIN_2_REGION_PMS_CONSTRAIN_WORLD_1_AREA_4_Field :=
                                             16#3#;
      --  region_pms_constrain_world_1_area_5
      REGION_PMS_CONSTRAIN_WORLD_1_AREA_5 : REGION_PMS_CONSTRAIN_2_REGION_PMS_CONSTRAIN_WORLD_1_AREA_5_Field :=
                                             16#3#;
      --  region_pms_constrain_world_1_area_6
      REGION_PMS_CONSTRAIN_WORLD_1_AREA_6 : REGION_PMS_CONSTRAIN_2_REGION_PMS_CONSTRAIN_WORLD_1_AREA_6_Field :=
                                             16#3#;
      --  unspecified
      Reserved_14_31                      : ESP32_C3.UInt18 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REGION_PMS_CONSTRAIN_2_Register use record
      REGION_PMS_CONSTRAIN_WORLD_1_AREA_0 at 0 range 0 .. 1;
      REGION_PMS_CONSTRAIN_WORLD_1_AREA_1 at 0 range 2 .. 3;
      REGION_PMS_CONSTRAIN_WORLD_1_AREA_2 at 0 range 4 .. 5;
      REGION_PMS_CONSTRAIN_WORLD_1_AREA_3 at 0 range 6 .. 7;
      REGION_PMS_CONSTRAIN_WORLD_1_AREA_4 at 0 range 8 .. 9;
      REGION_PMS_CONSTRAIN_WORLD_1_AREA_5 at 0 range 10 .. 11;
      REGION_PMS_CONSTRAIN_WORLD_1_AREA_6 at 0 range 12 .. 13;
      Reserved_14_31                      at 0 range 14 .. 31;
   end record;

   subtype REGION_PMS_CONSTRAIN_3_REGION_PMS_CONSTRAIN_ADDR_0_Field is
     ESP32_C3.UInt30;

   --  SENSITIVE_REGION_PMS_CONSTRAIN_3_REG
   type REGION_PMS_CONSTRAIN_3_Register is record
      --  region_pms_constrain_addr_0
      REGION_PMS_CONSTRAIN_ADDR_0 : REGION_PMS_CONSTRAIN_3_REGION_PMS_CONSTRAIN_ADDR_0_Field :=
                                     16#0#;
      --  unspecified
      Reserved_30_31              : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REGION_PMS_CONSTRAIN_3_Register use record
      REGION_PMS_CONSTRAIN_ADDR_0 at 0 range 0 .. 29;
      Reserved_30_31              at 0 range 30 .. 31;
   end record;

   subtype REGION_PMS_CONSTRAIN_4_REGION_PMS_CONSTRAIN_ADDR_1_Field is
     ESP32_C3.UInt30;

   --  SENSITIVE_REGION_PMS_CONSTRAIN_4_REG
   type REGION_PMS_CONSTRAIN_4_Register is record
      --  region_pms_constrain_addr_1
      REGION_PMS_CONSTRAIN_ADDR_1 : REGION_PMS_CONSTRAIN_4_REGION_PMS_CONSTRAIN_ADDR_1_Field :=
                                     16#0#;
      --  unspecified
      Reserved_30_31              : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REGION_PMS_CONSTRAIN_4_Register use record
      REGION_PMS_CONSTRAIN_ADDR_1 at 0 range 0 .. 29;
      Reserved_30_31              at 0 range 30 .. 31;
   end record;

   subtype REGION_PMS_CONSTRAIN_5_REGION_PMS_CONSTRAIN_ADDR_2_Field is
     ESP32_C3.UInt30;

   --  SENSITIVE_REGION_PMS_CONSTRAIN_5_REG
   type REGION_PMS_CONSTRAIN_5_Register is record
      --  region_pms_constrain_addr_2
      REGION_PMS_CONSTRAIN_ADDR_2 : REGION_PMS_CONSTRAIN_5_REGION_PMS_CONSTRAIN_ADDR_2_Field :=
                                     16#0#;
      --  unspecified
      Reserved_30_31              : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REGION_PMS_CONSTRAIN_5_Register use record
      REGION_PMS_CONSTRAIN_ADDR_2 at 0 range 0 .. 29;
      Reserved_30_31              at 0 range 30 .. 31;
   end record;

   subtype REGION_PMS_CONSTRAIN_6_REGION_PMS_CONSTRAIN_ADDR_3_Field is
     ESP32_C3.UInt30;

   --  SENSITIVE_REGION_PMS_CONSTRAIN_6_REG
   type REGION_PMS_CONSTRAIN_6_Register is record
      --  region_pms_constrain_addr_3
      REGION_PMS_CONSTRAIN_ADDR_3 : REGION_PMS_CONSTRAIN_6_REGION_PMS_CONSTRAIN_ADDR_3_Field :=
                                     16#0#;
      --  unspecified
      Reserved_30_31              : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REGION_PMS_CONSTRAIN_6_Register use record
      REGION_PMS_CONSTRAIN_ADDR_3 at 0 range 0 .. 29;
      Reserved_30_31              at 0 range 30 .. 31;
   end record;

   subtype REGION_PMS_CONSTRAIN_7_REGION_PMS_CONSTRAIN_ADDR_4_Field is
     ESP32_C3.UInt30;

   --  SENSITIVE_REGION_PMS_CONSTRAIN_7_REG
   type REGION_PMS_CONSTRAIN_7_Register is record
      --  region_pms_constrain_addr_4
      REGION_PMS_CONSTRAIN_ADDR_4 : REGION_PMS_CONSTRAIN_7_REGION_PMS_CONSTRAIN_ADDR_4_Field :=
                                     16#0#;
      --  unspecified
      Reserved_30_31              : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REGION_PMS_CONSTRAIN_7_Register use record
      REGION_PMS_CONSTRAIN_ADDR_4 at 0 range 0 .. 29;
      Reserved_30_31              at 0 range 30 .. 31;
   end record;

   subtype REGION_PMS_CONSTRAIN_8_REGION_PMS_CONSTRAIN_ADDR_5_Field is
     ESP32_C3.UInt30;

   --  SENSITIVE_REGION_PMS_CONSTRAIN_8_REG
   type REGION_PMS_CONSTRAIN_8_Register is record
      --  region_pms_constrain_addr_5
      REGION_PMS_CONSTRAIN_ADDR_5 : REGION_PMS_CONSTRAIN_8_REGION_PMS_CONSTRAIN_ADDR_5_Field :=
                                     16#0#;
      --  unspecified
      Reserved_30_31              : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REGION_PMS_CONSTRAIN_8_Register use record
      REGION_PMS_CONSTRAIN_ADDR_5 at 0 range 0 .. 29;
      Reserved_30_31              at 0 range 30 .. 31;
   end record;

   subtype REGION_PMS_CONSTRAIN_9_REGION_PMS_CONSTRAIN_ADDR_6_Field is
     ESP32_C3.UInt30;

   --  SENSITIVE_REGION_PMS_CONSTRAIN_9_REG
   type REGION_PMS_CONSTRAIN_9_Register is record
      --  region_pms_constrain_addr_6
      REGION_PMS_CONSTRAIN_ADDR_6 : REGION_PMS_CONSTRAIN_9_REGION_PMS_CONSTRAIN_ADDR_6_Field :=
                                     16#0#;
      --  unspecified
      Reserved_30_31              : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REGION_PMS_CONSTRAIN_9_Register use record
      REGION_PMS_CONSTRAIN_ADDR_6 at 0 range 0 .. 29;
      Reserved_30_31              at 0 range 30 .. 31;
   end record;

   subtype REGION_PMS_CONSTRAIN_10_REGION_PMS_CONSTRAIN_ADDR_7_Field is
     ESP32_C3.UInt30;

   --  SENSITIVE_REGION_PMS_CONSTRAIN_10_REG
   type REGION_PMS_CONSTRAIN_10_Register is record
      --  region_pms_constrain_addr_7
      REGION_PMS_CONSTRAIN_ADDR_7 : REGION_PMS_CONSTRAIN_10_REGION_PMS_CONSTRAIN_ADDR_7_Field :=
                                     16#0#;
      --  unspecified
      Reserved_30_31              : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REGION_PMS_CONSTRAIN_10_Register use record
      REGION_PMS_CONSTRAIN_ADDR_7 at 0 range 0 .. 29;
      Reserved_30_31              at 0 range 30 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_MONITOR_0_CORE_0_PIF_PMS_MONITOR_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_CORE_0_PIF_PMS_MONITOR_0_REG
   type CORE_0_PIF_PMS_MONITOR_0_Register is record
      --  core_0_pif_pms_monitor_lock
      CORE_0_PIF_PMS_MONITOR_LOCK : CORE_0_PIF_PMS_MONITOR_0_CORE_0_PIF_PMS_MONITOR_LOCK_Field :=
                                     16#0#;
      --  unspecified
      Reserved_1_31               : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_MONITOR_0_Register use record
      CORE_0_PIF_PMS_MONITOR_LOCK at 0 range 0 .. 0;
      Reserved_1_31               at 0 range 1 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_MONITOR_1_CORE_0_PIF_PMS_MONITOR_VIOLATE_CLR_Field is
     ESP32_C3.Bit;
   subtype CORE_0_PIF_PMS_MONITOR_1_CORE_0_PIF_PMS_MONITOR_VIOLATE_EN_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_CORE_0_PIF_PMS_MONITOR_1_REG
   type CORE_0_PIF_PMS_MONITOR_1_Register is record
      --  core_0_pif_pms_monitor_violate_clr
      CORE_0_PIF_PMS_MONITOR_VIOLATE_CLR : CORE_0_PIF_PMS_MONITOR_1_CORE_0_PIF_PMS_MONITOR_VIOLATE_CLR_Field :=
                                            16#1#;
      --  core_0_pif_pms_monitor_violate_en
      CORE_0_PIF_PMS_MONITOR_VIOLATE_EN  : CORE_0_PIF_PMS_MONITOR_1_CORE_0_PIF_PMS_MONITOR_VIOLATE_EN_Field :=
                                            16#1#;
      --  unspecified
      Reserved_2_31                      : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_MONITOR_1_Register use record
      CORE_0_PIF_PMS_MONITOR_VIOLATE_CLR at 0 range 0 .. 0;
      CORE_0_PIF_PMS_MONITOR_VIOLATE_EN  at 0 range 1 .. 1;
      Reserved_2_31                      at 0 range 2 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_MONITOR_2_CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_Field is
     ESP32_C3.Bit;
   subtype CORE_0_PIF_PMS_MONITOR_2_CORE_0_PIF_PMS_MONITOR_VIOLATE_STATUS_HPORT_0_Field is
     ESP32_C3.Bit;
   subtype CORE_0_PIF_PMS_MONITOR_2_CORE_0_PIF_PMS_MONITOR_VIOLATE_STATUS_HSIZE_Field is
     ESP32_C3.UInt3;
   subtype CORE_0_PIF_PMS_MONITOR_2_CORE_0_PIF_PMS_MONITOR_VIOLATE_STATUS_HWRITE_Field is
     ESP32_C3.Bit;
   subtype CORE_0_PIF_PMS_MONITOR_2_CORE_0_PIF_PMS_MONITOR_VIOLATE_STATUS_HWORLD_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_CORE_0_PIF_PMS_MONITOR_2_REG
   type CORE_0_PIF_PMS_MONITOR_2_Register is record
      --  Read-only. core_0_pif_pms_monitor_violate_intr
      CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR           : CORE_0_PIF_PMS_MONITOR_2_CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_Field;
      --  Read-only. core_0_pif_pms_monitor_violate_status_hport_0
      CORE_0_PIF_PMS_MONITOR_VIOLATE_STATUS_HPORT_0 : CORE_0_PIF_PMS_MONITOR_2_CORE_0_PIF_PMS_MONITOR_VIOLATE_STATUS_HPORT_0_Field;
      --  Read-only. core_0_pif_pms_monitor_violate_status_hsize
      CORE_0_PIF_PMS_MONITOR_VIOLATE_STATUS_HSIZE   : CORE_0_PIF_PMS_MONITOR_2_CORE_0_PIF_PMS_MONITOR_VIOLATE_STATUS_HSIZE_Field;
      --  Read-only. core_0_pif_pms_monitor_violate_status_hwrite
      CORE_0_PIF_PMS_MONITOR_VIOLATE_STATUS_HWRITE  : CORE_0_PIF_PMS_MONITOR_2_CORE_0_PIF_PMS_MONITOR_VIOLATE_STATUS_HWRITE_Field;
      --  Read-only. core_0_pif_pms_monitor_violate_status_hworld
      CORE_0_PIF_PMS_MONITOR_VIOLATE_STATUS_HWORLD  : CORE_0_PIF_PMS_MONITOR_2_CORE_0_PIF_PMS_MONITOR_VIOLATE_STATUS_HWORLD_Field;
      --  unspecified
      Reserved_8_31                                 : ESP32_C3.UInt24;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_MONITOR_2_Register use record
      CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR           at 0 range 0 .. 0;
      CORE_0_PIF_PMS_MONITOR_VIOLATE_STATUS_HPORT_0 at 0 range 1 .. 1;
      CORE_0_PIF_PMS_MONITOR_VIOLATE_STATUS_HSIZE   at 0 range 2 .. 4;
      CORE_0_PIF_PMS_MONITOR_VIOLATE_STATUS_HWRITE  at 0 range 5 .. 5;
      CORE_0_PIF_PMS_MONITOR_VIOLATE_STATUS_HWORLD  at 0 range 6 .. 7;
      Reserved_8_31                                 at 0 range 8 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_MONITOR_4_CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_CLR_Field is
     ESP32_C3.Bit;
   subtype CORE_0_PIF_PMS_MONITOR_4_CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_EN_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_CORE_0_PIF_PMS_MONITOR_4_REG
   type CORE_0_PIF_PMS_MONITOR_4_Register is record
      --  core_0_pif_pms_monitor_nonword_violate_clr
      CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_CLR : CORE_0_PIF_PMS_MONITOR_4_CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_CLR_Field :=
                                                    16#1#;
      --  core_0_pif_pms_monitor_nonword_violate_en
      CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_EN  : CORE_0_PIF_PMS_MONITOR_4_CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_EN_Field :=
                                                    16#1#;
      --  unspecified
      Reserved_2_31                              : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_MONITOR_4_Register use record
      CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_CLR at 0 range 0 .. 0;
      CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_EN  at 0 range 1 .. 1;
      Reserved_2_31                              at 0 range 2 .. 31;
   end record;

   subtype CORE_0_PIF_PMS_MONITOR_5_CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_INTR_Field is
     ESP32_C3.Bit;
   subtype CORE_0_PIF_PMS_MONITOR_5_CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_STATUS_HSIZE_Field is
     ESP32_C3.UInt2;
   subtype CORE_0_PIF_PMS_MONITOR_5_CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_STATUS_HWORLD_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_CORE_0_PIF_PMS_MONITOR_5_REG
   type CORE_0_PIF_PMS_MONITOR_5_Register is record
      --  Read-only. core_0_pif_pms_monitor_nonword_violate_intr
      CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_INTR          : CORE_0_PIF_PMS_MONITOR_5_CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_INTR_Field;
      --  Read-only. core_0_pif_pms_monitor_nonword_violate_status_hsize
      CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_STATUS_HSIZE  : CORE_0_PIF_PMS_MONITOR_5_CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_STATUS_HSIZE_Field;
      --  Read-only. core_0_pif_pms_monitor_nonword_violate_status_hworld
      CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_STATUS_HWORLD : CORE_0_PIF_PMS_MONITOR_5_CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_STATUS_HWORLD_Field;
      --  unspecified
      Reserved_5_31                                        : ESP32_C3.UInt27;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_PIF_PMS_MONITOR_5_Register use record
      CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_INTR          at 0 range 0 .. 0;
      CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_STATUS_HSIZE  at 0 range 1 .. 2;
      CORE_0_PIF_PMS_MONITOR_NONWORD_VIOLATE_STATUS_HWORLD at 0 range 3 .. 4;
      Reserved_5_31                                        at 0 range 5 .. 31;
   end record;

   subtype BACKUP_BUS_PMS_CONSTRAIN_0_BACKUP_BUS_PMS_CONSTRAIN_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_BACKUP_BUS_PMS_CONSTRAIN_0_REG
   type BACKUP_BUS_PMS_CONSTRAIN_0_Register is record
      --  backup_bus_pms_constrain_lock
      BACKUP_BUS_PMS_CONSTRAIN_LOCK : BACKUP_BUS_PMS_CONSTRAIN_0_BACKUP_BUS_PMS_CONSTRAIN_LOCK_Field :=
                                       16#0#;
      --  unspecified
      Reserved_1_31                 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BACKUP_BUS_PMS_CONSTRAIN_0_Register use record
      BACKUP_BUS_PMS_CONSTRAIN_LOCK at 0 range 0 .. 0;
      Reserved_1_31                 at 0 range 1 .. 31;
   end record;

   subtype BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_UART_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_G0SPI_1_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_G0SPI_0_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_GPIO_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_FE2_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_FE_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_TIMER_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_RTC_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_IO_MUX_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_WDG_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_MISC_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_I2C_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_UART1_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_BACKUP_BUS_PMS_CONSTRAIN_1_REG
   type BACKUP_BUS_PMS_CONSTRAIN_1_Register is record
      --  backup_bus_pms_constrain_uart
      BACKUP_BUS_PMS_CONSTRAIN_UART    : BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_UART_Field :=
                                          16#3#;
      --  backup_bus_pms_constrain_g0spi_1
      BACKUP_BUS_PMS_CONSTRAIN_G0SPI_1 : BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_G0SPI_1_Field :=
                                          16#3#;
      --  backup_bus_pms_constrain_g0spi_0
      BACKUP_BUS_PMS_CONSTRAIN_G0SPI_0 : BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_G0SPI_0_Field :=
                                          16#3#;
      --  backup_bus_pms_constrain_gpio
      BACKUP_BUS_PMS_CONSTRAIN_GPIO    : BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_GPIO_Field :=
                                          16#3#;
      --  backup_bus_pms_constrain_fe2
      BACKUP_BUS_PMS_CONSTRAIN_FE2     : BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_FE2_Field :=
                                          16#3#;
      --  backup_bus_pms_constrain_fe
      BACKUP_BUS_PMS_CONSTRAIN_FE      : BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_FE_Field :=
                                          16#3#;
      --  backup_bus_pms_constrain_timer
      BACKUP_BUS_PMS_CONSTRAIN_TIMER   : BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_TIMER_Field :=
                                          16#3#;
      --  backup_bus_pms_constrain_rtc
      BACKUP_BUS_PMS_CONSTRAIN_RTC     : BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_RTC_Field :=
                                          16#3#;
      --  backup_bus_pms_constrain_io_mux
      BACKUP_BUS_PMS_CONSTRAIN_IO_MUX  : BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_IO_MUX_Field :=
                                          16#3#;
      --  backup_bus_pms_constrain_wdg
      BACKUP_BUS_PMS_CONSTRAIN_WDG     : BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_WDG_Field :=
                                          16#3#;
      --  unspecified
      Reserved_20_23                   : ESP32_C3.UInt4 := 16#0#;
      --  backup_bus_pms_constrain_misc
      BACKUP_BUS_PMS_CONSTRAIN_MISC    : BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_MISC_Field :=
                                          16#3#;
      --  backup_bus_pms_constrain_i2c
      BACKUP_BUS_PMS_CONSTRAIN_I2C     : BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_I2C_Field :=
                                          16#3#;
      --  unspecified
      Reserved_28_29                   : ESP32_C3.UInt2 := 16#0#;
      --  backup_bus_pms_constrain_uart1
      BACKUP_BUS_PMS_CONSTRAIN_UART1   : BACKUP_BUS_PMS_CONSTRAIN_1_BACKUP_BUS_PMS_CONSTRAIN_UART1_Field :=
                                          16#3#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BACKUP_BUS_PMS_CONSTRAIN_1_Register use record
      BACKUP_BUS_PMS_CONSTRAIN_UART    at 0 range 0 .. 1;
      BACKUP_BUS_PMS_CONSTRAIN_G0SPI_1 at 0 range 2 .. 3;
      BACKUP_BUS_PMS_CONSTRAIN_G0SPI_0 at 0 range 4 .. 5;
      BACKUP_BUS_PMS_CONSTRAIN_GPIO    at 0 range 6 .. 7;
      BACKUP_BUS_PMS_CONSTRAIN_FE2     at 0 range 8 .. 9;
      BACKUP_BUS_PMS_CONSTRAIN_FE      at 0 range 10 .. 11;
      BACKUP_BUS_PMS_CONSTRAIN_TIMER   at 0 range 12 .. 13;
      BACKUP_BUS_PMS_CONSTRAIN_RTC     at 0 range 14 .. 15;
      BACKUP_BUS_PMS_CONSTRAIN_IO_MUX  at 0 range 16 .. 17;
      BACKUP_BUS_PMS_CONSTRAIN_WDG     at 0 range 18 .. 19;
      Reserved_20_23                   at 0 range 20 .. 23;
      BACKUP_BUS_PMS_CONSTRAIN_MISC    at 0 range 24 .. 25;
      BACKUP_BUS_PMS_CONSTRAIN_I2C     at 0 range 26 .. 27;
      Reserved_28_29                   at 0 range 28 .. 29;
      BACKUP_BUS_PMS_CONSTRAIN_UART1   at 0 range 30 .. 31;
   end record;

   subtype BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_BT_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_I2C_EXT0_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_UHCI0_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_RMT_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_LEDC_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_BB_Field is
     ESP32_C3.UInt2;
   --  BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_TIMERGROUP array
   --  element
   subtype BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_TIMERGROUP_Element is
     ESP32_C3.UInt2;

   --  BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_TIMERGROUP array
   type BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_TIMERGROUP_Field_Array is array (1 .. 2)
     of BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_TIMERGROUP_Element
     with Component_Size => 2, Size => 4;

   --  Type definition for
   --  BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_TIMERGROUP
   type BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_TIMERGROUP_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  BACKUP_BUS_PMS_CONSTRAIN_TIMERGROUP as a value
            Val : ESP32_C3.UInt4;
         when True =>
            --  BACKUP_BUS_PMS_CONSTRAIN_TIMERGROUP as an array
            Arr : BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_TIMERGROUP_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 4;

   for BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_TIMERGROUP_Field use record
      Val at 0 range 0 .. 3;
      Arr at 0 range 0 .. 3;
   end record;

   subtype BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_SYSTIMER_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_BACKUP_BUS_PMS_CONSTRAIN_2_REG
   type BACKUP_BUS_PMS_CONSTRAIN_2_Register is record
      --  backup_bus_pms_constrain_bt
      BACKUP_BUS_PMS_CONSTRAIN_BT         : BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_BT_Field :=
                                             16#3#;
      --  unspecified
      Reserved_2_3                        : ESP32_C3.UInt2 := 16#0#;
      --  backup_bus_pms_constrain_i2c_ext0
      BACKUP_BUS_PMS_CONSTRAIN_I2C_EXT0   : BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_I2C_EXT0_Field :=
                                             16#3#;
      --  backup_bus_pms_constrain_uhci0
      BACKUP_BUS_PMS_CONSTRAIN_UHCI0      : BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_UHCI0_Field :=
                                             16#3#;
      --  unspecified
      Reserved_8_9                        : ESP32_C3.UInt2 := 16#0#;
      --  backup_bus_pms_constrain_rmt
      BACKUP_BUS_PMS_CONSTRAIN_RMT        : BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_RMT_Field :=
                                             16#3#;
      --  unspecified
      Reserved_12_15                      : ESP32_C3.UInt4 := 16#0#;
      --  backup_bus_pms_constrain_ledc
      BACKUP_BUS_PMS_CONSTRAIN_LEDC       : BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_LEDC_Field :=
                                             16#3#;
      --  unspecified
      Reserved_18_21                      : ESP32_C3.UInt4 := 16#0#;
      --  backup_bus_pms_constrain_bb
      BACKUP_BUS_PMS_CONSTRAIN_BB         : BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_BB_Field :=
                                             16#3#;
      --  unspecified
      Reserved_24_25                      : ESP32_C3.UInt2 := 16#0#;
      --  backup_bus_pms_constrain_timergroup
      BACKUP_BUS_PMS_CONSTRAIN_TIMERGROUP : BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_TIMERGROUP_Field :=
                                             (As_Array => False, Val => 16#3#);
      --  backup_bus_pms_constrain_systimer
      BACKUP_BUS_PMS_CONSTRAIN_SYSTIMER   : BACKUP_BUS_PMS_CONSTRAIN_2_BACKUP_BUS_PMS_CONSTRAIN_SYSTIMER_Field :=
                                             16#3#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BACKUP_BUS_PMS_CONSTRAIN_2_Register use record
      BACKUP_BUS_PMS_CONSTRAIN_BT         at 0 range 0 .. 1;
      Reserved_2_3                        at 0 range 2 .. 3;
      BACKUP_BUS_PMS_CONSTRAIN_I2C_EXT0   at 0 range 4 .. 5;
      BACKUP_BUS_PMS_CONSTRAIN_UHCI0      at 0 range 6 .. 7;
      Reserved_8_9                        at 0 range 8 .. 9;
      BACKUP_BUS_PMS_CONSTRAIN_RMT        at 0 range 10 .. 11;
      Reserved_12_15                      at 0 range 12 .. 15;
      BACKUP_BUS_PMS_CONSTRAIN_LEDC       at 0 range 16 .. 17;
      Reserved_18_21                      at 0 range 18 .. 21;
      BACKUP_BUS_PMS_CONSTRAIN_BB         at 0 range 22 .. 23;
      Reserved_24_25                      at 0 range 24 .. 25;
      BACKUP_BUS_PMS_CONSTRAIN_TIMERGROUP at 0 range 26 .. 29;
      BACKUP_BUS_PMS_CONSTRAIN_SYSTIMER   at 0 range 30 .. 31;
   end record;

   subtype BACKUP_BUS_PMS_CONSTRAIN_3_BACKUP_BUS_PMS_CONSTRAIN_SPI_2_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_3_BACKUP_BUS_PMS_CONSTRAIN_APB_CTRL_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_3_BACKUP_BUS_PMS_CONSTRAIN_CAN_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_3_BACKUP_BUS_PMS_CONSTRAIN_I2S1_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_3_BACKUP_BUS_PMS_CONSTRAIN_RWBT_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_3_BACKUP_BUS_PMS_CONSTRAIN_WIFIMAC_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_3_BACKUP_BUS_PMS_CONSTRAIN_PWR_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_BACKUP_BUS_PMS_CONSTRAIN_3_REG
   type BACKUP_BUS_PMS_CONSTRAIN_3_Register is record
      --  backup_bus_pms_constrain_spi_2
      BACKUP_BUS_PMS_CONSTRAIN_SPI_2    : BACKUP_BUS_PMS_CONSTRAIN_3_BACKUP_BUS_PMS_CONSTRAIN_SPI_2_Field :=
                                           16#3#;
      --  unspecified
      Reserved_2_3                      : ESP32_C3.UInt2 := 16#0#;
      --  backup_bus_pms_constrain_apb_ctrl
      BACKUP_BUS_PMS_CONSTRAIN_APB_CTRL : BACKUP_BUS_PMS_CONSTRAIN_3_BACKUP_BUS_PMS_CONSTRAIN_APB_CTRL_Field :=
                                           16#3#;
      --  unspecified
      Reserved_6_9                      : ESP32_C3.UInt4 := 16#0#;
      --  backup_bus_pms_constrain_can
      BACKUP_BUS_PMS_CONSTRAIN_CAN      : BACKUP_BUS_PMS_CONSTRAIN_3_BACKUP_BUS_PMS_CONSTRAIN_CAN_Field :=
                                           16#3#;
      --  unspecified
      Reserved_12_13                    : ESP32_C3.UInt2 := 16#0#;
      --  backup_bus_pms_constrain_i2s1
      BACKUP_BUS_PMS_CONSTRAIN_I2S1     : BACKUP_BUS_PMS_CONSTRAIN_3_BACKUP_BUS_PMS_CONSTRAIN_I2S1_Field :=
                                           16#3#;
      --  unspecified
      Reserved_16_21                    : ESP32_C3.UInt6 := 16#0#;
      --  backup_bus_pms_constrain_rwbt
      BACKUP_BUS_PMS_CONSTRAIN_RWBT     : BACKUP_BUS_PMS_CONSTRAIN_3_BACKUP_BUS_PMS_CONSTRAIN_RWBT_Field :=
                                           16#3#;
      --  unspecified
      Reserved_24_25                    : ESP32_C3.UInt2 := 16#0#;
      --  backup_bus_pms_constrain_wifimac
      BACKUP_BUS_PMS_CONSTRAIN_WIFIMAC  : BACKUP_BUS_PMS_CONSTRAIN_3_BACKUP_BUS_PMS_CONSTRAIN_WIFIMAC_Field :=
                                           16#3#;
      --  backup_bus_pms_constrain_pwr
      BACKUP_BUS_PMS_CONSTRAIN_PWR      : BACKUP_BUS_PMS_CONSTRAIN_3_BACKUP_BUS_PMS_CONSTRAIN_PWR_Field :=
                                           16#3#;
      --  unspecified
      Reserved_30_31                    : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BACKUP_BUS_PMS_CONSTRAIN_3_Register use record
      BACKUP_BUS_PMS_CONSTRAIN_SPI_2    at 0 range 0 .. 1;
      Reserved_2_3                      at 0 range 2 .. 3;
      BACKUP_BUS_PMS_CONSTRAIN_APB_CTRL at 0 range 4 .. 5;
      Reserved_6_9                      at 0 range 6 .. 9;
      BACKUP_BUS_PMS_CONSTRAIN_CAN      at 0 range 10 .. 11;
      Reserved_12_13                    at 0 range 12 .. 13;
      BACKUP_BUS_PMS_CONSTRAIN_I2S1     at 0 range 14 .. 15;
      Reserved_16_21                    at 0 range 16 .. 21;
      BACKUP_BUS_PMS_CONSTRAIN_RWBT     at 0 range 22 .. 23;
      Reserved_24_25                    at 0 range 24 .. 25;
      BACKUP_BUS_PMS_CONSTRAIN_WIFIMAC  at 0 range 26 .. 27;
      BACKUP_BUS_PMS_CONSTRAIN_PWR      at 0 range 28 .. 29;
      Reserved_30_31                    at 0 range 30 .. 31;
   end record;

   subtype BACKUP_BUS_PMS_CONSTRAIN_4_BACKUP_BUS_PMS_CONSTRAIN_USB_WRAP_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_4_BACKUP_BUS_PMS_CONSTRAIN_CRYPTO_PERI_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_4_BACKUP_BUS_PMS_CONSTRAIN_CRYPTO_DMA_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_4_BACKUP_BUS_PMS_CONSTRAIN_APB_ADC_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_4_BACKUP_BUS_PMS_CONSTRAIN_BT_PWR_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_CONSTRAIN_4_BACKUP_BUS_PMS_CONSTRAIN_USB_DEVICE_Field is
     ESP32_C3.UInt2;

   --  SENSITIVE_BACKUP_BUS_PMS_CONSTRAIN_4_REG
   type BACKUP_BUS_PMS_CONSTRAIN_4_Register is record
      --  unspecified
      Reserved_0_1                         : ESP32_C3.UInt2 := 16#0#;
      --  backup_bus_pms_constrain_usb_wrap
      BACKUP_BUS_PMS_CONSTRAIN_USB_WRAP    : BACKUP_BUS_PMS_CONSTRAIN_4_BACKUP_BUS_PMS_CONSTRAIN_USB_WRAP_Field :=
                                              16#3#;
      --  backup_bus_pms_constrain_crypto_peri
      BACKUP_BUS_PMS_CONSTRAIN_CRYPTO_PERI : BACKUP_BUS_PMS_CONSTRAIN_4_BACKUP_BUS_PMS_CONSTRAIN_CRYPTO_PERI_Field :=
                                              16#3#;
      --  backup_bus_pms_constrain_crypto_dma
      BACKUP_BUS_PMS_CONSTRAIN_CRYPTO_DMA  : BACKUP_BUS_PMS_CONSTRAIN_4_BACKUP_BUS_PMS_CONSTRAIN_CRYPTO_DMA_Field :=
                                              16#3#;
      --  backup_bus_pms_constrain_apb_adc
      BACKUP_BUS_PMS_CONSTRAIN_APB_ADC     : BACKUP_BUS_PMS_CONSTRAIN_4_BACKUP_BUS_PMS_CONSTRAIN_APB_ADC_Field :=
                                              16#3#;
      --  unspecified
      Reserved_10_11                       : ESP32_C3.UInt2 := 16#0#;
      --  backup_bus_pms_constrain_bt_pwr
      BACKUP_BUS_PMS_CONSTRAIN_BT_PWR      : BACKUP_BUS_PMS_CONSTRAIN_4_BACKUP_BUS_PMS_CONSTRAIN_BT_PWR_Field :=
                                              16#3#;
      --  backup_bus_pms_constrain_usb_device
      BACKUP_BUS_PMS_CONSTRAIN_USB_DEVICE  : BACKUP_BUS_PMS_CONSTRAIN_4_BACKUP_BUS_PMS_CONSTRAIN_USB_DEVICE_Field :=
                                              16#3#;
      --  unspecified
      Reserved_16_31                       : ESP32_C3.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BACKUP_BUS_PMS_CONSTRAIN_4_Register use record
      Reserved_0_1                         at 0 range 0 .. 1;
      BACKUP_BUS_PMS_CONSTRAIN_USB_WRAP    at 0 range 2 .. 3;
      BACKUP_BUS_PMS_CONSTRAIN_CRYPTO_PERI at 0 range 4 .. 5;
      BACKUP_BUS_PMS_CONSTRAIN_CRYPTO_DMA  at 0 range 6 .. 7;
      BACKUP_BUS_PMS_CONSTRAIN_APB_ADC     at 0 range 8 .. 9;
      Reserved_10_11                       at 0 range 10 .. 11;
      BACKUP_BUS_PMS_CONSTRAIN_BT_PWR      at 0 range 12 .. 13;
      BACKUP_BUS_PMS_CONSTRAIN_USB_DEVICE  at 0 range 14 .. 15;
      Reserved_16_31                       at 0 range 16 .. 31;
   end record;

   subtype BACKUP_BUS_PMS_MONITOR_0_BACKUP_BUS_PMS_MONITOR_LOCK_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_BACKUP_BUS_PMS_MONITOR_0_REG
   type BACKUP_BUS_PMS_MONITOR_0_Register is record
      --  backup_bus_pms_monitor_lock
      BACKUP_BUS_PMS_MONITOR_LOCK : BACKUP_BUS_PMS_MONITOR_0_BACKUP_BUS_PMS_MONITOR_LOCK_Field :=
                                     16#0#;
      --  unspecified
      Reserved_1_31               : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BACKUP_BUS_PMS_MONITOR_0_Register use record
      BACKUP_BUS_PMS_MONITOR_LOCK at 0 range 0 .. 0;
      Reserved_1_31               at 0 range 1 .. 31;
   end record;

   subtype BACKUP_BUS_PMS_MONITOR_1_BACKUP_BUS_PMS_MONITOR_VIOLATE_CLR_Field is
     ESP32_C3.Bit;
   subtype BACKUP_BUS_PMS_MONITOR_1_BACKUP_BUS_PMS_MONITOR_VIOLATE_EN_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_BACKUP_BUS_PMS_MONITOR_1_REG
   type BACKUP_BUS_PMS_MONITOR_1_Register is record
      --  backup_bus_pms_monitor_violate_clr
      BACKUP_BUS_PMS_MONITOR_VIOLATE_CLR : BACKUP_BUS_PMS_MONITOR_1_BACKUP_BUS_PMS_MONITOR_VIOLATE_CLR_Field :=
                                            16#1#;
      --  backup_bus_pms_monitor_violate_en
      BACKUP_BUS_PMS_MONITOR_VIOLATE_EN  : BACKUP_BUS_PMS_MONITOR_1_BACKUP_BUS_PMS_MONITOR_VIOLATE_EN_Field :=
                                            16#1#;
      --  unspecified
      Reserved_2_31                      : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BACKUP_BUS_PMS_MONITOR_1_Register use record
      BACKUP_BUS_PMS_MONITOR_VIOLATE_CLR at 0 range 0 .. 0;
      BACKUP_BUS_PMS_MONITOR_VIOLATE_EN  at 0 range 1 .. 1;
      Reserved_2_31                      at 0 range 2 .. 31;
   end record;

   subtype BACKUP_BUS_PMS_MONITOR_2_BACKUP_BUS_PMS_MONITOR_VIOLATE_INTR_Field is
     ESP32_C3.Bit;
   subtype BACKUP_BUS_PMS_MONITOR_2_BACKUP_BUS_PMS_MONITOR_VIOLATE_STATUS_HTRANS_Field is
     ESP32_C3.UInt2;
   subtype BACKUP_BUS_PMS_MONITOR_2_BACKUP_BUS_PMS_MONITOR_VIOLATE_STATUS_HSIZE_Field is
     ESP32_C3.UInt3;
   subtype BACKUP_BUS_PMS_MONITOR_2_BACKUP_BUS_PMS_MONITOR_VIOLATE_STATUS_HWRITE_Field is
     ESP32_C3.Bit;

   --  SENSITIVE_BACKUP_BUS_PMS_MONITOR_2_REG
   type BACKUP_BUS_PMS_MONITOR_2_Register is record
      --  Read-only. backup_bus_pms_monitor_violate_intr
      BACKUP_BUS_PMS_MONITOR_VIOLATE_INTR          : BACKUP_BUS_PMS_MONITOR_2_BACKUP_BUS_PMS_MONITOR_VIOLATE_INTR_Field;
      --  Read-only. backup_bus_pms_monitor_violate_status_htrans
      BACKUP_BUS_PMS_MONITOR_VIOLATE_STATUS_HTRANS : BACKUP_BUS_PMS_MONITOR_2_BACKUP_BUS_PMS_MONITOR_VIOLATE_STATUS_HTRANS_Field;
      --  Read-only. backup_bus_pms_monitor_violate_status_hsize
      BACKUP_BUS_PMS_MONITOR_VIOLATE_STATUS_HSIZE  : BACKUP_BUS_PMS_MONITOR_2_BACKUP_BUS_PMS_MONITOR_VIOLATE_STATUS_HSIZE_Field;
      --  Read-only. backup_bus_pms_monitor_violate_status_hwrite
      BACKUP_BUS_PMS_MONITOR_VIOLATE_STATUS_HWRITE : BACKUP_BUS_PMS_MONITOR_2_BACKUP_BUS_PMS_MONITOR_VIOLATE_STATUS_HWRITE_Field;
      --  unspecified
      Reserved_7_31                                : ESP32_C3.UInt25;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BACKUP_BUS_PMS_MONITOR_2_Register use record
      BACKUP_BUS_PMS_MONITOR_VIOLATE_INTR          at 0 range 0 .. 0;
      BACKUP_BUS_PMS_MONITOR_VIOLATE_STATUS_HTRANS at 0 range 1 .. 2;
      BACKUP_BUS_PMS_MONITOR_VIOLATE_STATUS_HSIZE  at 0 range 3 .. 5;
      BACKUP_BUS_PMS_MONITOR_VIOLATE_STATUS_HWRITE at 0 range 6 .. 6;
      Reserved_7_31                                at 0 range 7 .. 31;
   end record;

   subtype CLOCK_GATE_CLK_EN_Field is ESP32_C3.Bit;

   --  SENSITIVE_CLOCK_GATE_REG_REG
   type CLOCK_GATE_Register is record
      --  clk_en
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

   subtype DATE_DATE_Field is ESP32_C3.UInt28;

   --  SENSITIVE_DATE_REG
   type DATE_Register is record
      --  reg_date
      DATE           : DATE_DATE_Field := 16#2010200#;
      --  unspecified
      Reserved_28_31 : ESP32_C3.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DATE_Register use record
      DATE           at 0 range 0 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  SENSITIVE Peripheral
   type SENSITIVE_Peripheral is record
      --  SENSITIVE_ROM_TABLE_LOCK_REG
      ROM_TABLE_LOCK                                : aliased ROM_TABLE_LOCK_Register;
      --  SENSITIVE_ROM_TABLE_REG
      ROM_TABLE                                     : aliased ESP32_C3.UInt32;
      --  SENSITIVE_PRIVILEGE_MODE_SEL_LOCK_REG
      PRIVILEGE_MODE_SEL_LOCK                       : aliased PRIVILEGE_MODE_SEL_LOCK_Register;
      --  SENSITIVE_PRIVILEGE_MODE_SEL_REG
      PRIVILEGE_MODE_SEL                            : aliased PRIVILEGE_MODE_SEL_Register;
      --  SENSITIVE_APB_PERIPHERAL_ACCESS_0_REG
      APB_PERIPHERAL_ACCESS_0                       : aliased APB_PERIPHERAL_ACCESS_0_Register;
      --  SENSITIVE_APB_PERIPHERAL_ACCESS_1_REG
      APB_PERIPHERAL_ACCESS_1                       : aliased APB_PERIPHERAL_ACCESS_1_Register;
      --  SENSITIVE_INTERNAL_SRAM_USAGE_0_REG
      INTERNAL_SRAM_USAGE_0                         : aliased INTERNAL_SRAM_USAGE_0_Register;
      --  SENSITIVE_INTERNAL_SRAM_USAGE_1_REG
      INTERNAL_SRAM_USAGE_1                         : aliased INTERNAL_SRAM_USAGE_1_Register;
      --  SENSITIVE_INTERNAL_SRAM_USAGE_3_REG
      INTERNAL_SRAM_USAGE_3                         : aliased INTERNAL_SRAM_USAGE_3_Register;
      --  SENSITIVE_INTERNAL_SRAM_USAGE_4_REG
      INTERNAL_SRAM_USAGE_4                         : aliased INTERNAL_SRAM_USAGE_4_Register;
      --  SENSITIVE_CACHE_TAG_ACCESS_0_REG
      CACHE_TAG_ACCESS_0                            : aliased CACHE_TAG_ACCESS_0_Register;
      --  SENSITIVE_CACHE_TAG_ACCESS_1_REG
      CACHE_TAG_ACCESS_1                            : aliased CACHE_TAG_ACCESS_1_Register;
      --  SENSITIVE_CACHE_MMU_ACCESS_0_REG
      CACHE_MMU_ACCESS_0                            : aliased CACHE_MMU_ACCESS_0_Register;
      --  SENSITIVE_CACHE_MMU_ACCESS_1_REG
      CACHE_MMU_ACCESS_1                            : aliased CACHE_MMU_ACCESS_1_Register;
      --  SENSITIVE_DMA_APBPERI_SPI2_PMS_CONSTRAIN_0_REG
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_0              : aliased DMA_APBPERI_SPI2_PMS_CONSTRAIN_0_Register;
      --  SENSITIVE_DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_REG
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_1              : aliased DMA_APBPERI_SPI2_PMS_CONSTRAIN_1_Register;
      --  SENSITIVE_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_0_REG
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_0             : aliased DMA_APBPERI_UCHI0_PMS_CONSTRAIN_0_Register;
      --  SENSITIVE_DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_REG
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1             : aliased DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1_Register;
      --  SENSITIVE_DMA_APBPERI_I2S0_PMS_CONSTRAIN_0_REG
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_0              : aliased DMA_APBPERI_I2S0_PMS_CONSTRAIN_0_Register;
      --  SENSITIVE_DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_REG
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_1              : aliased DMA_APBPERI_I2S0_PMS_CONSTRAIN_1_Register;
      --  SENSITIVE_DMA_APBPERI_MAC_PMS_CONSTRAIN_0_REG
      DMA_APBPERI_MAC_PMS_CONSTRAIN_0               : aliased DMA_APBPERI_MAC_PMS_CONSTRAIN_0_Register;
      --  SENSITIVE_DMA_APBPERI_MAC_PMS_CONSTRAIN_1_REG
      DMA_APBPERI_MAC_PMS_CONSTRAIN_1               : aliased DMA_APBPERI_MAC_PMS_CONSTRAIN_1_Register;
      --  SENSITIVE_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_0_REG
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_0            : aliased DMA_APBPERI_BACKUP_PMS_CONSTRAIN_0_Register;
      --  SENSITIVE_DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_REG
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1            : aliased DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1_Register;
      --  SENSITIVE_DMA_APBPERI_LC_PMS_CONSTRAIN_0_REG
      DMA_APBPERI_LC_PMS_CONSTRAIN_0                : aliased DMA_APBPERI_LC_PMS_CONSTRAIN_0_Register;
      --  SENSITIVE_DMA_APBPERI_LC_PMS_CONSTRAIN_1_REG
      DMA_APBPERI_LC_PMS_CONSTRAIN_1                : aliased DMA_APBPERI_LC_PMS_CONSTRAIN_1_Register;
      --  SENSITIVE_DMA_APBPERI_AES_PMS_CONSTRAIN_0_REG
      DMA_APBPERI_AES_PMS_CONSTRAIN_0               : aliased DMA_APBPERI_AES_PMS_CONSTRAIN_0_Register;
      --  SENSITIVE_DMA_APBPERI_AES_PMS_CONSTRAIN_1_REG
      DMA_APBPERI_AES_PMS_CONSTRAIN_1               : aliased DMA_APBPERI_AES_PMS_CONSTRAIN_1_Register;
      --  SENSITIVE_DMA_APBPERI_SHA_PMS_CONSTRAIN_0_REG
      DMA_APBPERI_SHA_PMS_CONSTRAIN_0               : aliased DMA_APBPERI_SHA_PMS_CONSTRAIN_0_Register;
      --  SENSITIVE_DMA_APBPERI_SHA_PMS_CONSTRAIN_1_REG
      DMA_APBPERI_SHA_PMS_CONSTRAIN_1               : aliased DMA_APBPERI_SHA_PMS_CONSTRAIN_1_Register;
      --  SENSITIVE_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_0_REG
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_0           : aliased DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_0_Register;
      --  SENSITIVE_DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_REG
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1           : aliased DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1_Register;
      --  SENSITIVE_DMA_APBPERI_PMS_MONITOR_0_REG
      DMA_APBPERI_PMS_MONITOR_0                     : aliased DMA_APBPERI_PMS_MONITOR_0_Register;
      --  SENSITIVE_DMA_APBPERI_PMS_MONITOR_1_REG
      DMA_APBPERI_PMS_MONITOR_1                     : aliased DMA_APBPERI_PMS_MONITOR_1_Register;
      --  SENSITIVE_DMA_APBPERI_PMS_MONITOR_2_REG
      DMA_APBPERI_PMS_MONITOR_2                     : aliased DMA_APBPERI_PMS_MONITOR_2_Register;
      --  SENSITIVE_DMA_APBPERI_PMS_MONITOR_3_REG
      DMA_APBPERI_PMS_MONITOR_3                     : aliased DMA_APBPERI_PMS_MONITOR_3_Register;
      --  SENSITIVE_CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_0_REG
      CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_0 : aliased CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_0_Register;
      --  SENSITIVE_CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_1_REG
      CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_1 : aliased CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_1_Register;
      --  SENSITIVE_CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_2_REG
      CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_2 : aliased CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_2_Register;
      --  SENSITIVE_CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_3_REG
      CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_3 : aliased CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_3_Register;
      --  SENSITIVE_CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_4_REG
      CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_4 : aliased CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_4_Register;
      --  SENSITIVE_CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_5_REG
      CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_5 : aliased CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_5_Register;
      --  SENSITIVE_CORE_X_IRAM0_PMS_CONSTRAIN_0_REG
      CORE_X_IRAM0_PMS_CONSTRAIN_0                  : aliased CORE_X_IRAM0_PMS_CONSTRAIN_0_Register;
      --  SENSITIVE_CORE_X_IRAM0_PMS_CONSTRAIN_1_REG
      CORE_X_IRAM0_PMS_CONSTRAIN_1                  : aliased CORE_X_IRAM0_PMS_CONSTRAIN_1_Register;
      --  SENSITIVE_CORE_X_IRAM0_PMS_CONSTRAIN_2_REG
      CORE_X_IRAM0_PMS_CONSTRAIN_2                  : aliased CORE_X_IRAM0_PMS_CONSTRAIN_2_Register;
      --  SENSITIVE_CORE_0_IRAM0_PMS_MONITOR_0_REG
      CORE_0_IRAM0_PMS_MONITOR_0                    : aliased CORE_0_IRAM0_PMS_MONITOR_0_Register;
      --  SENSITIVE_CORE_0_IRAM0_PMS_MONITOR_1_REG
      CORE_0_IRAM0_PMS_MONITOR_1                    : aliased CORE_0_IRAM0_PMS_MONITOR_1_Register;
      --  SENSITIVE_CORE_0_IRAM0_PMS_MONITOR_2_REG
      CORE_0_IRAM0_PMS_MONITOR_2                    : aliased CORE_0_IRAM0_PMS_MONITOR_2_Register;
      --  SENSITIVE_CORE_X_DRAM0_PMS_CONSTRAIN_0_REG
      CORE_X_DRAM0_PMS_CONSTRAIN_0                  : aliased CORE_X_DRAM0_PMS_CONSTRAIN_0_Register;
      --  SENSITIVE_CORE_X_DRAM0_PMS_CONSTRAIN_1_REG
      CORE_X_DRAM0_PMS_CONSTRAIN_1                  : aliased CORE_X_DRAM0_PMS_CONSTRAIN_1_Register;
      --  SENSITIVE_CORE_0_DRAM0_PMS_MONITOR_0_REG
      CORE_0_DRAM0_PMS_MONITOR_0                    : aliased CORE_0_DRAM0_PMS_MONITOR_0_Register;
      --  SENSITIVE_CORE_0_DRAM0_PMS_MONITOR_1_REG
      CORE_0_DRAM0_PMS_MONITOR_1                    : aliased CORE_0_DRAM0_PMS_MONITOR_1_Register;
      --  SENSITIVE_CORE_0_DRAM0_PMS_MONITOR_2_REG
      CORE_0_DRAM0_PMS_MONITOR_2                    : aliased CORE_0_DRAM0_PMS_MONITOR_2_Register;
      --  SENSITIVE_CORE_0_DRAM0_PMS_MONITOR_3_REG
      CORE_0_DRAM0_PMS_MONITOR_3                    : aliased CORE_0_DRAM0_PMS_MONITOR_3_Register;
      --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_0_REG
      CORE_0_PIF_PMS_CONSTRAIN_0                    : aliased CORE_0_PIF_PMS_CONSTRAIN_0_Register;
      --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_1_REG
      CORE_0_PIF_PMS_CONSTRAIN_1                    : aliased CORE_0_PIF_PMS_CONSTRAIN_1_Register;
      --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_2_REG
      CORE_0_PIF_PMS_CONSTRAIN_2                    : aliased CORE_0_PIF_PMS_CONSTRAIN_2_Register;
      --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_3_REG
      CORE_0_PIF_PMS_CONSTRAIN_3                    : aliased CORE_0_PIF_PMS_CONSTRAIN_3_Register;
      --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_4_REG
      CORE_0_PIF_PMS_CONSTRAIN_4                    : aliased CORE_0_PIF_PMS_CONSTRAIN_4_Register;
      --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_5_REG
      CORE_0_PIF_PMS_CONSTRAIN_5                    : aliased CORE_0_PIF_PMS_CONSTRAIN_5_Register;
      --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_6_REG
      CORE_0_PIF_PMS_CONSTRAIN_6                    : aliased CORE_0_PIF_PMS_CONSTRAIN_6_Register;
      --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_7_REG
      CORE_0_PIF_PMS_CONSTRAIN_7                    : aliased CORE_0_PIF_PMS_CONSTRAIN_7_Register;
      --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_8_REG
      CORE_0_PIF_PMS_CONSTRAIN_8                    : aliased CORE_0_PIF_PMS_CONSTRAIN_8_Register;
      --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_9_REG
      CORE_0_PIF_PMS_CONSTRAIN_9                    : aliased CORE_0_PIF_PMS_CONSTRAIN_9_Register;
      --  SENSITIVE_CORE_0_PIF_PMS_CONSTRAIN_10_REG
      CORE_0_PIF_PMS_CONSTRAIN_10                   : aliased CORE_0_PIF_PMS_CONSTRAIN_10_Register;
      --  SENSITIVE_REGION_PMS_CONSTRAIN_0_REG
      REGION_PMS_CONSTRAIN_0                        : aliased REGION_PMS_CONSTRAIN_0_Register;
      --  SENSITIVE_REGION_PMS_CONSTRAIN_1_REG
      REGION_PMS_CONSTRAIN_1                        : aliased REGION_PMS_CONSTRAIN_1_Register;
      --  SENSITIVE_REGION_PMS_CONSTRAIN_2_REG
      REGION_PMS_CONSTRAIN_2                        : aliased REGION_PMS_CONSTRAIN_2_Register;
      --  SENSITIVE_REGION_PMS_CONSTRAIN_3_REG
      REGION_PMS_CONSTRAIN_3                        : aliased REGION_PMS_CONSTRAIN_3_Register;
      --  SENSITIVE_REGION_PMS_CONSTRAIN_4_REG
      REGION_PMS_CONSTRAIN_4                        : aliased REGION_PMS_CONSTRAIN_4_Register;
      --  SENSITIVE_REGION_PMS_CONSTRAIN_5_REG
      REGION_PMS_CONSTRAIN_5                        : aliased REGION_PMS_CONSTRAIN_5_Register;
      --  SENSITIVE_REGION_PMS_CONSTRAIN_6_REG
      REGION_PMS_CONSTRAIN_6                        : aliased REGION_PMS_CONSTRAIN_6_Register;
      --  SENSITIVE_REGION_PMS_CONSTRAIN_7_REG
      REGION_PMS_CONSTRAIN_7                        : aliased REGION_PMS_CONSTRAIN_7_Register;
      --  SENSITIVE_REGION_PMS_CONSTRAIN_8_REG
      REGION_PMS_CONSTRAIN_8                        : aliased REGION_PMS_CONSTRAIN_8_Register;
      --  SENSITIVE_REGION_PMS_CONSTRAIN_9_REG
      REGION_PMS_CONSTRAIN_9                        : aliased REGION_PMS_CONSTRAIN_9_Register;
      --  SENSITIVE_REGION_PMS_CONSTRAIN_10_REG
      REGION_PMS_CONSTRAIN_10                       : aliased REGION_PMS_CONSTRAIN_10_Register;
      --  SENSITIVE_CORE_0_PIF_PMS_MONITOR_0_REG
      CORE_0_PIF_PMS_MONITOR_0                      : aliased CORE_0_PIF_PMS_MONITOR_0_Register;
      --  SENSITIVE_CORE_0_PIF_PMS_MONITOR_1_REG
      CORE_0_PIF_PMS_MONITOR_1                      : aliased CORE_0_PIF_PMS_MONITOR_1_Register;
      --  SENSITIVE_CORE_0_PIF_PMS_MONITOR_2_REG
      CORE_0_PIF_PMS_MONITOR_2                      : aliased CORE_0_PIF_PMS_MONITOR_2_Register;
      --  SENSITIVE_CORE_0_PIF_PMS_MONITOR_3_REG
      CORE_0_PIF_PMS_MONITOR_3                      : aliased ESP32_C3.UInt32;
      --  SENSITIVE_CORE_0_PIF_PMS_MONITOR_4_REG
      CORE_0_PIF_PMS_MONITOR_4                      : aliased CORE_0_PIF_PMS_MONITOR_4_Register;
      --  SENSITIVE_CORE_0_PIF_PMS_MONITOR_5_REG
      CORE_0_PIF_PMS_MONITOR_5                      : aliased CORE_0_PIF_PMS_MONITOR_5_Register;
      --  SENSITIVE_CORE_0_PIF_PMS_MONITOR_6_REG
      CORE_0_PIF_PMS_MONITOR_6                      : aliased ESP32_C3.UInt32;
      --  SENSITIVE_BACKUP_BUS_PMS_CONSTRAIN_0_REG
      BACKUP_BUS_PMS_CONSTRAIN_0                    : aliased BACKUP_BUS_PMS_CONSTRAIN_0_Register;
      --  SENSITIVE_BACKUP_BUS_PMS_CONSTRAIN_1_REG
      BACKUP_BUS_PMS_CONSTRAIN_1                    : aliased BACKUP_BUS_PMS_CONSTRAIN_1_Register;
      --  SENSITIVE_BACKUP_BUS_PMS_CONSTRAIN_2_REG
      BACKUP_BUS_PMS_CONSTRAIN_2                    : aliased BACKUP_BUS_PMS_CONSTRAIN_2_Register;
      --  SENSITIVE_BACKUP_BUS_PMS_CONSTRAIN_3_REG
      BACKUP_BUS_PMS_CONSTRAIN_3                    : aliased BACKUP_BUS_PMS_CONSTRAIN_3_Register;
      --  SENSITIVE_BACKUP_BUS_PMS_CONSTRAIN_4_REG
      BACKUP_BUS_PMS_CONSTRAIN_4                    : aliased BACKUP_BUS_PMS_CONSTRAIN_4_Register;
      --  SENSITIVE_BACKUP_BUS_PMS_MONITOR_0_REG
      BACKUP_BUS_PMS_MONITOR_0                      : aliased BACKUP_BUS_PMS_MONITOR_0_Register;
      --  SENSITIVE_BACKUP_BUS_PMS_MONITOR_1_REG
      BACKUP_BUS_PMS_MONITOR_1                      : aliased BACKUP_BUS_PMS_MONITOR_1_Register;
      --  SENSITIVE_BACKUP_BUS_PMS_MONITOR_2_REG
      BACKUP_BUS_PMS_MONITOR_2                      : aliased BACKUP_BUS_PMS_MONITOR_2_Register;
      --  SENSITIVE_BACKUP_BUS_PMS_MONITOR_3_REG
      BACKUP_BUS_PMS_MONITOR_3                      : aliased ESP32_C3.UInt32;
      --  SENSITIVE_CLOCK_GATE_REG_REG
      CLOCK_GATE                                    : aliased CLOCK_GATE_Register;
      --  SENSITIVE_DATE_REG
      DATE                                          : aliased DATE_Register;
   end record
     with Volatile;

   for SENSITIVE_Peripheral use record
      ROM_TABLE_LOCK                                at 16#0# range 0 .. 31;
      ROM_TABLE                                     at 16#4# range 0 .. 31;
      PRIVILEGE_MODE_SEL_LOCK                       at 16#8# range 0 .. 31;
      PRIVILEGE_MODE_SEL                            at 16#C# range 0 .. 31;
      APB_PERIPHERAL_ACCESS_0                       at 16#10# range 0 .. 31;
      APB_PERIPHERAL_ACCESS_1                       at 16#14# range 0 .. 31;
      INTERNAL_SRAM_USAGE_0                         at 16#18# range 0 .. 31;
      INTERNAL_SRAM_USAGE_1                         at 16#1C# range 0 .. 31;
      INTERNAL_SRAM_USAGE_3                         at 16#20# range 0 .. 31;
      INTERNAL_SRAM_USAGE_4                         at 16#24# range 0 .. 31;
      CACHE_TAG_ACCESS_0                            at 16#28# range 0 .. 31;
      CACHE_TAG_ACCESS_1                            at 16#2C# range 0 .. 31;
      CACHE_MMU_ACCESS_0                            at 16#30# range 0 .. 31;
      CACHE_MMU_ACCESS_1                            at 16#34# range 0 .. 31;
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_0              at 16#38# range 0 .. 31;
      DMA_APBPERI_SPI2_PMS_CONSTRAIN_1              at 16#3C# range 0 .. 31;
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_0             at 16#40# range 0 .. 31;
      DMA_APBPERI_UCHI0_PMS_CONSTRAIN_1             at 16#44# range 0 .. 31;
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_0              at 16#48# range 0 .. 31;
      DMA_APBPERI_I2S0_PMS_CONSTRAIN_1              at 16#4C# range 0 .. 31;
      DMA_APBPERI_MAC_PMS_CONSTRAIN_0               at 16#50# range 0 .. 31;
      DMA_APBPERI_MAC_PMS_CONSTRAIN_1               at 16#54# range 0 .. 31;
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_0            at 16#58# range 0 .. 31;
      DMA_APBPERI_BACKUP_PMS_CONSTRAIN_1            at 16#5C# range 0 .. 31;
      DMA_APBPERI_LC_PMS_CONSTRAIN_0                at 16#60# range 0 .. 31;
      DMA_APBPERI_LC_PMS_CONSTRAIN_1                at 16#64# range 0 .. 31;
      DMA_APBPERI_AES_PMS_CONSTRAIN_0               at 16#68# range 0 .. 31;
      DMA_APBPERI_AES_PMS_CONSTRAIN_1               at 16#6C# range 0 .. 31;
      DMA_APBPERI_SHA_PMS_CONSTRAIN_0               at 16#70# range 0 .. 31;
      DMA_APBPERI_SHA_PMS_CONSTRAIN_1               at 16#74# range 0 .. 31;
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_0           at 16#78# range 0 .. 31;
      DMA_APBPERI_ADC_DAC_PMS_CONSTRAIN_1           at 16#7C# range 0 .. 31;
      DMA_APBPERI_PMS_MONITOR_0                     at 16#80# range 0 .. 31;
      DMA_APBPERI_PMS_MONITOR_1                     at 16#84# range 0 .. 31;
      DMA_APBPERI_PMS_MONITOR_2                     at 16#88# range 0 .. 31;
      DMA_APBPERI_PMS_MONITOR_3                     at 16#8C# range 0 .. 31;
      CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_0 at 16#90# range 0 .. 31;
      CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_1 at 16#94# range 0 .. 31;
      CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_2 at 16#98# range 0 .. 31;
      CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_3 at 16#9C# range 0 .. 31;
      CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_4 at 16#A0# range 0 .. 31;
      CORE_X_IRAM0_DRAM0_DMA_SPLIT_LINE_CONSTRAIN_5 at 16#A4# range 0 .. 31;
      CORE_X_IRAM0_PMS_CONSTRAIN_0                  at 16#A8# range 0 .. 31;
      CORE_X_IRAM0_PMS_CONSTRAIN_1                  at 16#AC# range 0 .. 31;
      CORE_X_IRAM0_PMS_CONSTRAIN_2                  at 16#B0# range 0 .. 31;
      CORE_0_IRAM0_PMS_MONITOR_0                    at 16#B4# range 0 .. 31;
      CORE_0_IRAM0_PMS_MONITOR_1                    at 16#B8# range 0 .. 31;
      CORE_0_IRAM0_PMS_MONITOR_2                    at 16#BC# range 0 .. 31;
      CORE_X_DRAM0_PMS_CONSTRAIN_0                  at 16#C0# range 0 .. 31;
      CORE_X_DRAM0_PMS_CONSTRAIN_1                  at 16#C4# range 0 .. 31;
      CORE_0_DRAM0_PMS_MONITOR_0                    at 16#C8# range 0 .. 31;
      CORE_0_DRAM0_PMS_MONITOR_1                    at 16#CC# range 0 .. 31;
      CORE_0_DRAM0_PMS_MONITOR_2                    at 16#D0# range 0 .. 31;
      CORE_0_DRAM0_PMS_MONITOR_3                    at 16#D4# range 0 .. 31;
      CORE_0_PIF_PMS_CONSTRAIN_0                    at 16#D8# range 0 .. 31;
      CORE_0_PIF_PMS_CONSTRAIN_1                    at 16#DC# range 0 .. 31;
      CORE_0_PIF_PMS_CONSTRAIN_2                    at 16#E0# range 0 .. 31;
      CORE_0_PIF_PMS_CONSTRAIN_3                    at 16#E4# range 0 .. 31;
      CORE_0_PIF_PMS_CONSTRAIN_4                    at 16#E8# range 0 .. 31;
      CORE_0_PIF_PMS_CONSTRAIN_5                    at 16#EC# range 0 .. 31;
      CORE_0_PIF_PMS_CONSTRAIN_6                    at 16#F0# range 0 .. 31;
      CORE_0_PIF_PMS_CONSTRAIN_7                    at 16#F4# range 0 .. 31;
      CORE_0_PIF_PMS_CONSTRAIN_8                    at 16#F8# range 0 .. 31;
      CORE_0_PIF_PMS_CONSTRAIN_9                    at 16#FC# range 0 .. 31;
      CORE_0_PIF_PMS_CONSTRAIN_10                   at 16#100# range 0 .. 31;
      REGION_PMS_CONSTRAIN_0                        at 16#104# range 0 .. 31;
      REGION_PMS_CONSTRAIN_1                        at 16#108# range 0 .. 31;
      REGION_PMS_CONSTRAIN_2                        at 16#10C# range 0 .. 31;
      REGION_PMS_CONSTRAIN_3                        at 16#110# range 0 .. 31;
      REGION_PMS_CONSTRAIN_4                        at 16#114# range 0 .. 31;
      REGION_PMS_CONSTRAIN_5                        at 16#118# range 0 .. 31;
      REGION_PMS_CONSTRAIN_6                        at 16#11C# range 0 .. 31;
      REGION_PMS_CONSTRAIN_7                        at 16#120# range 0 .. 31;
      REGION_PMS_CONSTRAIN_8                        at 16#124# range 0 .. 31;
      REGION_PMS_CONSTRAIN_9                        at 16#128# range 0 .. 31;
      REGION_PMS_CONSTRAIN_10                       at 16#12C# range 0 .. 31;
      CORE_0_PIF_PMS_MONITOR_0                      at 16#130# range 0 .. 31;
      CORE_0_PIF_PMS_MONITOR_1                      at 16#134# range 0 .. 31;
      CORE_0_PIF_PMS_MONITOR_2                      at 16#138# range 0 .. 31;
      CORE_0_PIF_PMS_MONITOR_3                      at 16#13C# range 0 .. 31;
      CORE_0_PIF_PMS_MONITOR_4                      at 16#140# range 0 .. 31;
      CORE_0_PIF_PMS_MONITOR_5                      at 16#144# range 0 .. 31;
      CORE_0_PIF_PMS_MONITOR_6                      at 16#148# range 0 .. 31;
      BACKUP_BUS_PMS_CONSTRAIN_0                    at 16#14C# range 0 .. 31;
      BACKUP_BUS_PMS_CONSTRAIN_1                    at 16#150# range 0 .. 31;
      BACKUP_BUS_PMS_CONSTRAIN_2                    at 16#154# range 0 .. 31;
      BACKUP_BUS_PMS_CONSTRAIN_3                    at 16#158# range 0 .. 31;
      BACKUP_BUS_PMS_CONSTRAIN_4                    at 16#15C# range 0 .. 31;
      BACKUP_BUS_PMS_MONITOR_0                      at 16#160# range 0 .. 31;
      BACKUP_BUS_PMS_MONITOR_1                      at 16#164# range 0 .. 31;
      BACKUP_BUS_PMS_MONITOR_2                      at 16#168# range 0 .. 31;
      BACKUP_BUS_PMS_MONITOR_3                      at 16#16C# range 0 .. 31;
      CLOCK_GATE                                    at 16#170# range 0 .. 31;
      DATE                                          at 16#FFC# range 0 .. 31;
   end record;

   --  SENSITIVE Peripheral
   SENSITIVE_Periph : aliased SENSITIVE_Peripheral
     with Import, Address => SENSITIVE_Base;

end ESP32_C3.SENSITIVE;
