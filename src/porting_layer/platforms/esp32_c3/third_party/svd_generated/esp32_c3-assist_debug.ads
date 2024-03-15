pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.ASSIST_DEBUG is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype CORE_0_MONTR_ENA_CORE_0_AREA_DRAM0_0_RD_ENA_Field is ESP32_C3.Bit;
   subtype CORE_0_MONTR_ENA_CORE_0_AREA_DRAM0_0_WR_ENA_Field is ESP32_C3.Bit;
   subtype CORE_0_MONTR_ENA_CORE_0_AREA_DRAM0_1_RD_ENA_Field is ESP32_C3.Bit;
   subtype CORE_0_MONTR_ENA_CORE_0_AREA_DRAM0_1_WR_ENA_Field is ESP32_C3.Bit;
   subtype CORE_0_MONTR_ENA_CORE_0_AREA_PIF_0_RD_ENA_Field is ESP32_C3.Bit;
   subtype CORE_0_MONTR_ENA_CORE_0_AREA_PIF_0_WR_ENA_Field is ESP32_C3.Bit;
   subtype CORE_0_MONTR_ENA_CORE_0_AREA_PIF_1_RD_ENA_Field is ESP32_C3.Bit;
   subtype CORE_0_MONTR_ENA_CORE_0_AREA_PIF_1_WR_ENA_Field is ESP32_C3.Bit;
   subtype CORE_0_MONTR_ENA_CORE_0_SP_SPILL_MIN_ENA_Field is ESP32_C3.Bit;
   subtype CORE_0_MONTR_ENA_CORE_0_SP_SPILL_MAX_ENA_Field is ESP32_C3.Bit;
   subtype CORE_0_MONTR_ENA_CORE_0_IRAM0_EXCEPTION_MONITOR_ENA_Field is
     ESP32_C3.Bit;
   subtype CORE_0_MONTR_ENA_CORE_0_DRAM0_EXCEPTION_MONITOR_ENA_Field is
     ESP32_C3.Bit;

   --  ASSIST_DEBUG_C0RE_0_MONTR_ENA_REG
   type CORE_0_MONTR_ENA_Register is record
      --  reg_core_0_area_dram0_0_rd_ena
      CORE_0_AREA_DRAM0_0_RD_ENA         : CORE_0_MONTR_ENA_CORE_0_AREA_DRAM0_0_RD_ENA_Field :=
                                            16#0#;
      --  reg_core_0_area_dram0_0_wr_ena
      CORE_0_AREA_DRAM0_0_WR_ENA         : CORE_0_MONTR_ENA_CORE_0_AREA_DRAM0_0_WR_ENA_Field :=
                                            16#0#;
      --  reg_core_0_area_dram0_1_rd_ena
      CORE_0_AREA_DRAM0_1_RD_ENA         : CORE_0_MONTR_ENA_CORE_0_AREA_DRAM0_1_RD_ENA_Field :=
                                            16#0#;
      --  reg_core_0_area_dram0_1_wr_ena
      CORE_0_AREA_DRAM0_1_WR_ENA         : CORE_0_MONTR_ENA_CORE_0_AREA_DRAM0_1_WR_ENA_Field :=
                                            16#0#;
      --  reg_core_0_area_pif_0_rd_ena
      CORE_0_AREA_PIF_0_RD_ENA           : CORE_0_MONTR_ENA_CORE_0_AREA_PIF_0_RD_ENA_Field :=
                                            16#0#;
      --  reg_core_0_area_pif_0_wr_ena
      CORE_0_AREA_PIF_0_WR_ENA           : CORE_0_MONTR_ENA_CORE_0_AREA_PIF_0_WR_ENA_Field :=
                                            16#0#;
      --  reg_core_0_area_pif_1_rd_ena
      CORE_0_AREA_PIF_1_RD_ENA           : CORE_0_MONTR_ENA_CORE_0_AREA_PIF_1_RD_ENA_Field :=
                                            16#0#;
      --  reg_core_0_area_pif_1_wr_ena
      CORE_0_AREA_PIF_1_WR_ENA           : CORE_0_MONTR_ENA_CORE_0_AREA_PIF_1_WR_ENA_Field :=
                                            16#0#;
      --  reg_core_0_sp_spill_min_ena
      CORE_0_SP_SPILL_MIN_ENA            : CORE_0_MONTR_ENA_CORE_0_SP_SPILL_MIN_ENA_Field :=
                                            16#0#;
      --  reg_core_0_sp_spill_max_ena
      CORE_0_SP_SPILL_MAX_ENA            : CORE_0_MONTR_ENA_CORE_0_SP_SPILL_MAX_ENA_Field :=
                                            16#0#;
      --  reg_core_0_iram0_exception_monitor_ena
      CORE_0_IRAM0_EXCEPTION_MONITOR_ENA : CORE_0_MONTR_ENA_CORE_0_IRAM0_EXCEPTION_MONITOR_ENA_Field :=
                                            16#0#;
      --  reg_core_0_dram0_exception_monitor_ena
      CORE_0_DRAM0_EXCEPTION_MONITOR_ENA : CORE_0_MONTR_ENA_CORE_0_DRAM0_EXCEPTION_MONITOR_ENA_Field :=
                                            16#0#;
      --  unspecified
      Reserved_12_31                     : ESP32_C3.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_MONTR_ENA_Register use record
      CORE_0_AREA_DRAM0_0_RD_ENA         at 0 range 0 .. 0;
      CORE_0_AREA_DRAM0_0_WR_ENA         at 0 range 1 .. 1;
      CORE_0_AREA_DRAM0_1_RD_ENA         at 0 range 2 .. 2;
      CORE_0_AREA_DRAM0_1_WR_ENA         at 0 range 3 .. 3;
      CORE_0_AREA_PIF_0_RD_ENA           at 0 range 4 .. 4;
      CORE_0_AREA_PIF_0_WR_ENA           at 0 range 5 .. 5;
      CORE_0_AREA_PIF_1_RD_ENA           at 0 range 6 .. 6;
      CORE_0_AREA_PIF_1_WR_ENA           at 0 range 7 .. 7;
      CORE_0_SP_SPILL_MIN_ENA            at 0 range 8 .. 8;
      CORE_0_SP_SPILL_MAX_ENA            at 0 range 9 .. 9;
      CORE_0_IRAM0_EXCEPTION_MONITOR_ENA at 0 range 10 .. 10;
      CORE_0_DRAM0_EXCEPTION_MONITOR_ENA at 0 range 11 .. 11;
      Reserved_12_31                     at 0 range 12 .. 31;
   end record;

   subtype CORE_0_INTR_RAW_CORE_0_AREA_DRAM0_0_RD_RAW_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_RAW_CORE_0_AREA_DRAM0_0_WR_RAW_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_RAW_CORE_0_AREA_DRAM0_1_RD_RAW_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_RAW_CORE_0_AREA_DRAM0_1_WR_RAW_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_RAW_CORE_0_AREA_PIF_0_RD_RAW_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_RAW_CORE_0_AREA_PIF_0_WR_RAW_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_RAW_CORE_0_AREA_PIF_1_RD_RAW_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_RAW_CORE_0_AREA_PIF_1_WR_RAW_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_RAW_CORE_0_SP_SPILL_MIN_RAW_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_RAW_CORE_0_SP_SPILL_MAX_RAW_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_RAW_CORE_0_IRAM0_EXCEPTION_MONITOR_RAW_Field is
     ESP32_C3.Bit;
   subtype CORE_0_INTR_RAW_CORE_0_DRAM0_EXCEPTION_MONITOR_RAW_Field is
     ESP32_C3.Bit;

   --  ASSIST_DEBUG_CORE_0_INTR_RAW_REG
   type CORE_0_INTR_RAW_Register is record
      --  Read-only. reg_core_0_area_dram0_0_rd_raw
      CORE_0_AREA_DRAM0_0_RD_RAW         : CORE_0_INTR_RAW_CORE_0_AREA_DRAM0_0_RD_RAW_Field;
      --  Read-only. reg_core_0_area_dram0_0_wr_raw
      CORE_0_AREA_DRAM0_0_WR_RAW         : CORE_0_INTR_RAW_CORE_0_AREA_DRAM0_0_WR_RAW_Field;
      --  Read-only. reg_core_0_area_dram0_1_rd_raw
      CORE_0_AREA_DRAM0_1_RD_RAW         : CORE_0_INTR_RAW_CORE_0_AREA_DRAM0_1_RD_RAW_Field;
      --  Read-only. reg_core_0_area_dram0_1_wr_raw
      CORE_0_AREA_DRAM0_1_WR_RAW         : CORE_0_INTR_RAW_CORE_0_AREA_DRAM0_1_WR_RAW_Field;
      --  Read-only. reg_core_0_area_pif_0_rd_raw
      CORE_0_AREA_PIF_0_RD_RAW           : CORE_0_INTR_RAW_CORE_0_AREA_PIF_0_RD_RAW_Field;
      --  Read-only. reg_core_0_area_pif_0_wr_raw
      CORE_0_AREA_PIF_0_WR_RAW           : CORE_0_INTR_RAW_CORE_0_AREA_PIF_0_WR_RAW_Field;
      --  Read-only. reg_core_0_area_pif_1_rd_raw
      CORE_0_AREA_PIF_1_RD_RAW           : CORE_0_INTR_RAW_CORE_0_AREA_PIF_1_RD_RAW_Field;
      --  Read-only. reg_core_0_area_pif_1_wr_raw
      CORE_0_AREA_PIF_1_WR_RAW           : CORE_0_INTR_RAW_CORE_0_AREA_PIF_1_WR_RAW_Field;
      --  Read-only. reg_core_0_sp_spill_min_raw
      CORE_0_SP_SPILL_MIN_RAW            : CORE_0_INTR_RAW_CORE_0_SP_SPILL_MIN_RAW_Field;
      --  Read-only. reg_core_0_sp_spill_max_raw
      CORE_0_SP_SPILL_MAX_RAW            : CORE_0_INTR_RAW_CORE_0_SP_SPILL_MAX_RAW_Field;
      --  Read-only. reg_core_0_iram0_exception_monitor_raw
      CORE_0_IRAM0_EXCEPTION_MONITOR_RAW : CORE_0_INTR_RAW_CORE_0_IRAM0_EXCEPTION_MONITOR_RAW_Field;
      --  Read-only. reg_core_0_dram0_exception_monitor_raw
      CORE_0_DRAM0_EXCEPTION_MONITOR_RAW : CORE_0_INTR_RAW_CORE_0_DRAM0_EXCEPTION_MONITOR_RAW_Field;
      --  unspecified
      Reserved_12_31                     : ESP32_C3.UInt20;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_INTR_RAW_Register use record
      CORE_0_AREA_DRAM0_0_RD_RAW         at 0 range 0 .. 0;
      CORE_0_AREA_DRAM0_0_WR_RAW         at 0 range 1 .. 1;
      CORE_0_AREA_DRAM0_1_RD_RAW         at 0 range 2 .. 2;
      CORE_0_AREA_DRAM0_1_WR_RAW         at 0 range 3 .. 3;
      CORE_0_AREA_PIF_0_RD_RAW           at 0 range 4 .. 4;
      CORE_0_AREA_PIF_0_WR_RAW           at 0 range 5 .. 5;
      CORE_0_AREA_PIF_1_RD_RAW           at 0 range 6 .. 6;
      CORE_0_AREA_PIF_1_WR_RAW           at 0 range 7 .. 7;
      CORE_0_SP_SPILL_MIN_RAW            at 0 range 8 .. 8;
      CORE_0_SP_SPILL_MAX_RAW            at 0 range 9 .. 9;
      CORE_0_IRAM0_EXCEPTION_MONITOR_RAW at 0 range 10 .. 10;
      CORE_0_DRAM0_EXCEPTION_MONITOR_RAW at 0 range 11 .. 11;
      Reserved_12_31                     at 0 range 12 .. 31;
   end record;

   subtype CORE_0_INTR_ENA_CORE_0_AREA_DRAM0_0_RD_INTR_ENA_Field is
     ESP32_C3.Bit;
   subtype CORE_0_INTR_ENA_CORE_0_AREA_DRAM0_0_WR_INTR_ENA_Field is
     ESP32_C3.Bit;
   subtype CORE_0_INTR_ENA_CORE_0_AREA_DRAM0_1_RD_INTR_ENA_Field is
     ESP32_C3.Bit;
   subtype CORE_0_INTR_ENA_CORE_0_AREA_DRAM0_1_WR_INTR_ENA_Field is
     ESP32_C3.Bit;
   subtype CORE_0_INTR_ENA_CORE_0_AREA_PIF_0_RD_INTR_ENA_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_ENA_CORE_0_AREA_PIF_0_WR_INTR_ENA_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_ENA_CORE_0_AREA_PIF_1_RD_INTR_ENA_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_ENA_CORE_0_AREA_PIF_1_WR_INTR_ENA_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_ENA_CORE_0_SP_SPILL_MIN_INTR_ENA_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_ENA_CORE_0_SP_SPILL_MAX_INTR_ENA_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_ENA_CORE_0_IRAM0_EXCEPTION_MONITOR_RLS_Field is
     ESP32_C3.Bit;
   subtype CORE_0_INTR_ENA_CORE_0_DRAM0_EXCEPTION_MONITOR_RLS_Field is
     ESP32_C3.Bit;

   --  ASSIST_DEBUG_CORE_0_INTR_ENA_REG
   type CORE_0_INTR_ENA_Register is record
      --  reg_core_0_area_dram0_0_rd_intr_ena
      CORE_0_AREA_DRAM0_0_RD_INTR_ENA    : CORE_0_INTR_ENA_CORE_0_AREA_DRAM0_0_RD_INTR_ENA_Field :=
                                            16#0#;
      --  reg_core_0_area_dram0_0_wr_intr_ena
      CORE_0_AREA_DRAM0_0_WR_INTR_ENA    : CORE_0_INTR_ENA_CORE_0_AREA_DRAM0_0_WR_INTR_ENA_Field :=
                                            16#0#;
      --  reg_core_0_area_dram0_1_rd_intr_ena
      CORE_0_AREA_DRAM0_1_RD_INTR_ENA    : CORE_0_INTR_ENA_CORE_0_AREA_DRAM0_1_RD_INTR_ENA_Field :=
                                            16#0#;
      --  reg_core_0_area_dram0_1_wr_intr_ena
      CORE_0_AREA_DRAM0_1_WR_INTR_ENA    : CORE_0_INTR_ENA_CORE_0_AREA_DRAM0_1_WR_INTR_ENA_Field :=
                                            16#0#;
      --  reg_core_0_area_pif_0_rd_intr_ena
      CORE_0_AREA_PIF_0_RD_INTR_ENA      : CORE_0_INTR_ENA_CORE_0_AREA_PIF_0_RD_INTR_ENA_Field :=
                                            16#0#;
      --  reg_core_0_area_pif_0_wr_intr_ena
      CORE_0_AREA_PIF_0_WR_INTR_ENA      : CORE_0_INTR_ENA_CORE_0_AREA_PIF_0_WR_INTR_ENA_Field :=
                                            16#0#;
      --  reg_core_0_area_pif_1_rd_intr_ena
      CORE_0_AREA_PIF_1_RD_INTR_ENA      : CORE_0_INTR_ENA_CORE_0_AREA_PIF_1_RD_INTR_ENA_Field :=
                                            16#0#;
      --  reg_core_0_area_pif_1_wr_intr_ena
      CORE_0_AREA_PIF_1_WR_INTR_ENA      : CORE_0_INTR_ENA_CORE_0_AREA_PIF_1_WR_INTR_ENA_Field :=
                                            16#0#;
      --  reg_core_0_sp_spill_min_intr_ena
      CORE_0_SP_SPILL_MIN_INTR_ENA       : CORE_0_INTR_ENA_CORE_0_SP_SPILL_MIN_INTR_ENA_Field :=
                                            16#0#;
      --  reg_core_0_sp_spill_max_intr_ena
      CORE_0_SP_SPILL_MAX_INTR_ENA       : CORE_0_INTR_ENA_CORE_0_SP_SPILL_MAX_INTR_ENA_Field :=
                                            16#0#;
      --  reg_core_0_iram0_exception_monitor_ena
      CORE_0_IRAM0_EXCEPTION_MONITOR_RLS : CORE_0_INTR_ENA_CORE_0_IRAM0_EXCEPTION_MONITOR_RLS_Field :=
                                            16#0#;
      --  reg_core_0_dram0_exception_monitor_ena
      CORE_0_DRAM0_EXCEPTION_MONITOR_RLS : CORE_0_INTR_ENA_CORE_0_DRAM0_EXCEPTION_MONITOR_RLS_Field :=
                                            16#0#;
      --  unspecified
      Reserved_12_31                     : ESP32_C3.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_INTR_ENA_Register use record
      CORE_0_AREA_DRAM0_0_RD_INTR_ENA    at 0 range 0 .. 0;
      CORE_0_AREA_DRAM0_0_WR_INTR_ENA    at 0 range 1 .. 1;
      CORE_0_AREA_DRAM0_1_RD_INTR_ENA    at 0 range 2 .. 2;
      CORE_0_AREA_DRAM0_1_WR_INTR_ENA    at 0 range 3 .. 3;
      CORE_0_AREA_PIF_0_RD_INTR_ENA      at 0 range 4 .. 4;
      CORE_0_AREA_PIF_0_WR_INTR_ENA      at 0 range 5 .. 5;
      CORE_0_AREA_PIF_1_RD_INTR_ENA      at 0 range 6 .. 6;
      CORE_0_AREA_PIF_1_WR_INTR_ENA      at 0 range 7 .. 7;
      CORE_0_SP_SPILL_MIN_INTR_ENA       at 0 range 8 .. 8;
      CORE_0_SP_SPILL_MAX_INTR_ENA       at 0 range 9 .. 9;
      CORE_0_IRAM0_EXCEPTION_MONITOR_RLS at 0 range 10 .. 10;
      CORE_0_DRAM0_EXCEPTION_MONITOR_RLS at 0 range 11 .. 11;
      Reserved_12_31                     at 0 range 12 .. 31;
   end record;

   subtype CORE_0_INTR_CLR_CORE_0_AREA_DRAM0_0_RD_CLR_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_CLR_CORE_0_AREA_DRAM0_0_WR_CLR_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_CLR_CORE_0_AREA_DRAM0_1_RD_CLR_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_CLR_CORE_0_AREA_DRAM0_1_WR_CLR_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_CLR_CORE_0_AREA_PIF_0_RD_CLR_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_CLR_CORE_0_AREA_PIF_0_WR_CLR_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_CLR_CORE_0_AREA_PIF_1_RD_CLR_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_CLR_CORE_0_AREA_PIF_1_WR_CLR_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_CLR_CORE_0_SP_SPILL_MIN_CLR_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_CLR_CORE_0_SP_SPILL_MAX_CLR_Field is ESP32_C3.Bit;
   subtype CORE_0_INTR_CLR_CORE_0_IRAM0_EXCEPTION_MONITOR_CLR_Field is
     ESP32_C3.Bit;
   subtype CORE_0_INTR_CLR_CORE_0_DRAM0_EXCEPTION_MONITOR_CLR_Field is
     ESP32_C3.Bit;

   --  ASSIST_DEBUG_CORE_0_INTR_CLR_REG
   type CORE_0_INTR_CLR_Register is record
      --  reg_core_0_area_dram0_0_rd_clr
      CORE_0_AREA_DRAM0_0_RD_CLR         : CORE_0_INTR_CLR_CORE_0_AREA_DRAM0_0_RD_CLR_Field :=
                                            16#0#;
      --  reg_core_0_area_dram0_0_wr_clr
      CORE_0_AREA_DRAM0_0_WR_CLR         : CORE_0_INTR_CLR_CORE_0_AREA_DRAM0_0_WR_CLR_Field :=
                                            16#0#;
      --  reg_core_0_area_dram0_1_rd_clr
      CORE_0_AREA_DRAM0_1_RD_CLR         : CORE_0_INTR_CLR_CORE_0_AREA_DRAM0_1_RD_CLR_Field :=
                                            16#0#;
      --  reg_core_0_area_dram0_1_wr_clr
      CORE_0_AREA_DRAM0_1_WR_CLR         : CORE_0_INTR_CLR_CORE_0_AREA_DRAM0_1_WR_CLR_Field :=
                                            16#0#;
      --  reg_core_0_area_pif_0_rd_clr
      CORE_0_AREA_PIF_0_RD_CLR           : CORE_0_INTR_CLR_CORE_0_AREA_PIF_0_RD_CLR_Field :=
                                            16#0#;
      --  reg_core_0_area_pif_0_wr_clr
      CORE_0_AREA_PIF_0_WR_CLR           : CORE_0_INTR_CLR_CORE_0_AREA_PIF_0_WR_CLR_Field :=
                                            16#0#;
      --  reg_core_0_area_pif_1_rd_clr
      CORE_0_AREA_PIF_1_RD_CLR           : CORE_0_INTR_CLR_CORE_0_AREA_PIF_1_RD_CLR_Field :=
                                            16#0#;
      --  reg_core_0_area_pif_1_wr_clr
      CORE_0_AREA_PIF_1_WR_CLR           : CORE_0_INTR_CLR_CORE_0_AREA_PIF_1_WR_CLR_Field :=
                                            16#0#;
      --  reg_core_0_sp_spill_min_clr
      CORE_0_SP_SPILL_MIN_CLR            : CORE_0_INTR_CLR_CORE_0_SP_SPILL_MIN_CLR_Field :=
                                            16#0#;
      --  reg_core_0_sp_spill_max_clr
      CORE_0_SP_SPILL_MAX_CLR            : CORE_0_INTR_CLR_CORE_0_SP_SPILL_MAX_CLR_Field :=
                                            16#0#;
      --  reg_core_0_iram0_exception_monitor_clr
      CORE_0_IRAM0_EXCEPTION_MONITOR_CLR : CORE_0_INTR_CLR_CORE_0_IRAM0_EXCEPTION_MONITOR_CLR_Field :=
                                            16#0#;
      --  reg_core_0_dram0_exception_monitor_clr
      CORE_0_DRAM0_EXCEPTION_MONITOR_CLR : CORE_0_INTR_CLR_CORE_0_DRAM0_EXCEPTION_MONITOR_CLR_Field :=
                                            16#0#;
      --  unspecified
      Reserved_12_31                     : ESP32_C3.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_INTR_CLR_Register use record
      CORE_0_AREA_DRAM0_0_RD_CLR         at 0 range 0 .. 0;
      CORE_0_AREA_DRAM0_0_WR_CLR         at 0 range 1 .. 1;
      CORE_0_AREA_DRAM0_1_RD_CLR         at 0 range 2 .. 2;
      CORE_0_AREA_DRAM0_1_WR_CLR         at 0 range 3 .. 3;
      CORE_0_AREA_PIF_0_RD_CLR           at 0 range 4 .. 4;
      CORE_0_AREA_PIF_0_WR_CLR           at 0 range 5 .. 5;
      CORE_0_AREA_PIF_1_RD_CLR           at 0 range 6 .. 6;
      CORE_0_AREA_PIF_1_WR_CLR           at 0 range 7 .. 7;
      CORE_0_SP_SPILL_MIN_CLR            at 0 range 8 .. 8;
      CORE_0_SP_SPILL_MAX_CLR            at 0 range 9 .. 9;
      CORE_0_IRAM0_EXCEPTION_MONITOR_CLR at 0 range 10 .. 10;
      CORE_0_DRAM0_EXCEPTION_MONITOR_CLR at 0 range 11 .. 11;
      Reserved_12_31                     at 0 range 12 .. 31;
   end record;

   subtype CORE_0_RCD_EN_CORE_0_RCD_RECORDEN_Field is ESP32_C3.Bit;
   subtype CORE_0_RCD_EN_CORE_0_RCD_PDEBUGEN_Field is ESP32_C3.Bit;

   --  ASSIST_DEBUG_CORE_0_RCD_EN_REG
   type CORE_0_RCD_EN_Register is record
      --  reg_core_0_rcd_recorden
      CORE_0_RCD_RECORDEN : CORE_0_RCD_EN_CORE_0_RCD_RECORDEN_Field := 16#0#;
      --  reg_core_0_rcd_pdebugen
      CORE_0_RCD_PDEBUGEN : CORE_0_RCD_EN_CORE_0_RCD_PDEBUGEN_Field := 16#0#;
      --  unspecified
      Reserved_2_31       : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_RCD_EN_Register use record
      CORE_0_RCD_RECORDEN at 0 range 0 .. 0;
      CORE_0_RCD_PDEBUGEN at 0 range 1 .. 1;
      Reserved_2_31       at 0 range 2 .. 31;
   end record;

   subtype CORE_0_IRAM0_EXCEPTION_MONITOR_0_CORE_0_IRAM0_RECORDING_ADDR_0_Field is
     ESP32_C3.UInt24;
   subtype CORE_0_IRAM0_EXCEPTION_MONITOR_0_CORE_0_IRAM0_RECORDING_WR_0_Field is
     ESP32_C3.Bit;
   subtype CORE_0_IRAM0_EXCEPTION_MONITOR_0_CORE_0_IRAM0_RECORDING_LOADSTORE_0_Field is
     ESP32_C3.Bit;

   --  ASSIST_DEBUG_CORE_0_RCD_PDEBUGSP_REG
   type CORE_0_IRAM0_EXCEPTION_MONITOR_0_Register is record
      --  Read-only. reg_core_0_iram0_recording_addr_0
      CORE_0_IRAM0_RECORDING_ADDR_0      : CORE_0_IRAM0_EXCEPTION_MONITOR_0_CORE_0_IRAM0_RECORDING_ADDR_0_Field;
      --  Read-only. reg_core_0_iram0_recording_wr_0
      CORE_0_IRAM0_RECORDING_WR_0        : CORE_0_IRAM0_EXCEPTION_MONITOR_0_CORE_0_IRAM0_RECORDING_WR_0_Field;
      --  Read-only. reg_core_0_iram0_recording_loadstore_0
      CORE_0_IRAM0_RECORDING_LOADSTORE_0 : CORE_0_IRAM0_EXCEPTION_MONITOR_0_CORE_0_IRAM0_RECORDING_LOADSTORE_0_Field;
      --  unspecified
      Reserved_26_31                     : ESP32_C3.UInt6;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_IRAM0_EXCEPTION_MONITOR_0_Register use record
      CORE_0_IRAM0_RECORDING_ADDR_0      at 0 range 0 .. 23;
      CORE_0_IRAM0_RECORDING_WR_0        at 0 range 24 .. 24;
      CORE_0_IRAM0_RECORDING_LOADSTORE_0 at 0 range 25 .. 25;
      Reserved_26_31                     at 0 range 26 .. 31;
   end record;

   subtype CORE_0_IRAM0_EXCEPTION_MONITOR_1_CORE_0_IRAM0_RECORDING_ADDR_1_Field is
     ESP32_C3.UInt24;
   subtype CORE_0_IRAM0_EXCEPTION_MONITOR_1_CORE_0_IRAM0_RECORDING_WR_1_Field is
     ESP32_C3.Bit;
   subtype CORE_0_IRAM0_EXCEPTION_MONITOR_1_CORE_0_IRAM0_RECORDING_LOADSTORE_1_Field is
     ESP32_C3.Bit;

   --  ASSIST_DEBUG_CORE_0_IRAM0_EXCEPTION_MONITOR_1_REG
   type CORE_0_IRAM0_EXCEPTION_MONITOR_1_Register is record
      --  Read-only. reg_core_0_iram0_recording_addr_1
      CORE_0_IRAM0_RECORDING_ADDR_1      : CORE_0_IRAM0_EXCEPTION_MONITOR_1_CORE_0_IRAM0_RECORDING_ADDR_1_Field;
      --  Read-only. reg_core_0_iram0_recording_wr_1
      CORE_0_IRAM0_RECORDING_WR_1        : CORE_0_IRAM0_EXCEPTION_MONITOR_1_CORE_0_IRAM0_RECORDING_WR_1_Field;
      --  Read-only. reg_core_0_iram0_recording_loadstore_1
      CORE_0_IRAM0_RECORDING_LOADSTORE_1 : CORE_0_IRAM0_EXCEPTION_MONITOR_1_CORE_0_IRAM0_RECORDING_LOADSTORE_1_Field;
      --  unspecified
      Reserved_26_31                     : ESP32_C3.UInt6;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_IRAM0_EXCEPTION_MONITOR_1_Register use record
      CORE_0_IRAM0_RECORDING_ADDR_1      at 0 range 0 .. 23;
      CORE_0_IRAM0_RECORDING_WR_1        at 0 range 24 .. 24;
      CORE_0_IRAM0_RECORDING_LOADSTORE_1 at 0 range 25 .. 25;
      Reserved_26_31                     at 0 range 26 .. 31;
   end record;

   subtype CORE_0_DRAM0_EXCEPTION_MONITOR_0_CORE_0_DRAM0_RECORDING_ADDR_0_Field is
     ESP32_C3.UInt24;
   subtype CORE_0_DRAM0_EXCEPTION_MONITOR_0_CORE_0_DRAM0_RECORDING_WR_0_Field is
     ESP32_C3.Bit;
   subtype CORE_0_DRAM0_EXCEPTION_MONITOR_0_CORE_0_DRAM0_RECORDING_BYTEEN_0_Field is
     ESP32_C3.UInt4;

   --  ASSIST_DEBUG_CORE_0_DRAM0_EXCEPTION_MONITOR_0_REG
   type CORE_0_DRAM0_EXCEPTION_MONITOR_0_Register is record
      --  Read-only. reg_core_0_dram0_recording_addr_0
      CORE_0_DRAM0_RECORDING_ADDR_0   : CORE_0_DRAM0_EXCEPTION_MONITOR_0_CORE_0_DRAM0_RECORDING_ADDR_0_Field;
      --  Read-only. reg_core_0_dram0_recording_wr_0
      CORE_0_DRAM0_RECORDING_WR_0     : CORE_0_DRAM0_EXCEPTION_MONITOR_0_CORE_0_DRAM0_RECORDING_WR_0_Field;
      --  Read-only. reg_core_0_dram0_recording_byteen_0
      CORE_0_DRAM0_RECORDING_BYTEEN_0 : CORE_0_DRAM0_EXCEPTION_MONITOR_0_CORE_0_DRAM0_RECORDING_BYTEEN_0_Field;
      --  unspecified
      Reserved_29_31                  : ESP32_C3.UInt3;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_DRAM0_EXCEPTION_MONITOR_0_Register use record
      CORE_0_DRAM0_RECORDING_ADDR_0   at 0 range 0 .. 23;
      CORE_0_DRAM0_RECORDING_WR_0     at 0 range 24 .. 24;
      CORE_0_DRAM0_RECORDING_BYTEEN_0 at 0 range 25 .. 28;
      Reserved_29_31                  at 0 range 29 .. 31;
   end record;

   subtype CORE_0_DRAM0_EXCEPTION_MONITOR_2_CORE_0_DRAM0_RECORDING_ADDR_1_Field is
     ESP32_C3.UInt24;
   subtype CORE_0_DRAM0_EXCEPTION_MONITOR_2_CORE_0_DRAM0_RECORDING_WR_1_Field is
     ESP32_C3.Bit;
   subtype CORE_0_DRAM0_EXCEPTION_MONITOR_2_CORE_0_DRAM0_RECORDING_BYTEEN_1_Field is
     ESP32_C3.UInt4;

   --  ASSIST_DEBUG_CORE_0_DRAM0_EXCEPTION_MONITOR_1_REG
   type CORE_0_DRAM0_EXCEPTION_MONITOR_2_Register is record
      --  Read-only. reg_core_0_dram0_recording_addr_1
      CORE_0_DRAM0_RECORDING_ADDR_1   : CORE_0_DRAM0_EXCEPTION_MONITOR_2_CORE_0_DRAM0_RECORDING_ADDR_1_Field;
      --  Read-only. reg_core_0_dram0_recording_wr_1
      CORE_0_DRAM0_RECORDING_WR_1     : CORE_0_DRAM0_EXCEPTION_MONITOR_2_CORE_0_DRAM0_RECORDING_WR_1_Field;
      --  Read-only. reg_core_0_dram0_recording_byteen_1
      CORE_0_DRAM0_RECORDING_BYTEEN_1 : CORE_0_DRAM0_EXCEPTION_MONITOR_2_CORE_0_DRAM0_RECORDING_BYTEEN_1_Field;
      --  unspecified
      Reserved_29_31                  : ESP32_C3.UInt3;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_0_DRAM0_EXCEPTION_MONITOR_2_Register use record
      CORE_0_DRAM0_RECORDING_ADDR_1   at 0 range 0 .. 23;
      CORE_0_DRAM0_RECORDING_WR_1     at 0 range 24 .. 24;
      CORE_0_DRAM0_RECORDING_BYTEEN_1 at 0 range 25 .. 28;
      Reserved_29_31                  at 0 range 29 .. 31;
   end record;

   subtype CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_0_CORE_X_IRAM0_DRAM0_LIMIT_CYCLE_0_Field is
     ESP32_C3.UInt20;

   --  ASSIST_DEBUG_CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_0_REG
   type CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_0_Register is record
      --  reg_core_x_iram0_dram0_limit_cycle_0
      CORE_X_IRAM0_DRAM0_LIMIT_CYCLE_0 : CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_0_CORE_X_IRAM0_DRAM0_LIMIT_CYCLE_0_Field :=
                                          16#0#;
      --  unspecified
      Reserved_20_31                   : ESP32_C3.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_0_Register use record
      CORE_X_IRAM0_DRAM0_LIMIT_CYCLE_0 at 0 range 0 .. 19;
      Reserved_20_31                   at 0 range 20 .. 31;
   end record;

   subtype CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_1_CORE_X_IRAM0_DRAM0_LIMIT_CYCLE_1_Field is
     ESP32_C3.UInt20;

   --  ASSIST_DEBUG_CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_1_REG
   type CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_1_Register is record
      --  reg_core_x_iram0_dram0_limit_cycle_1
      CORE_X_IRAM0_DRAM0_LIMIT_CYCLE_1 : CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_1_CORE_X_IRAM0_DRAM0_LIMIT_CYCLE_1_Field :=
                                          16#0#;
      --  unspecified
      Reserved_20_31                   : ESP32_C3.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_1_Register use record
      CORE_X_IRAM0_DRAM0_LIMIT_CYCLE_1 at 0 range 0 .. 19;
      Reserved_20_31                   at 0 range 20 .. 31;
   end record;

   subtype LOG_SETTING_LOG_ENA_Field is ESP32_C3.UInt3;
   subtype LOG_SETTING_LOG_MODE_Field is ESP32_C3.UInt4;
   subtype LOG_SETTING_LOG_MEM_LOOP_ENABLE_Field is ESP32_C3.Bit;

   --  ASSIST_DEBUG_LOG_SETTING
   type LOG_SETTING_Register is record
      --  reg_log_ena
      LOG_ENA             : LOG_SETTING_LOG_ENA_Field := 16#0#;
      --  reg_log_mode
      LOG_MODE            : LOG_SETTING_LOG_MODE_Field := 16#0#;
      --  reg_log_mem_loop_enable
      LOG_MEM_LOOP_ENABLE : LOG_SETTING_LOG_MEM_LOOP_ENABLE_Field := 16#1#;
      --  unspecified
      Reserved_8_31       : ESP32_C3.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for LOG_SETTING_Register use record
      LOG_ENA             at 0 range 0 .. 2;
      LOG_MODE            at 0 range 3 .. 6;
      LOG_MEM_LOOP_ENABLE at 0 range 7 .. 7;
      Reserved_8_31       at 0 range 8 .. 31;
   end record;

   subtype LOG_DATA_MASK_LOG_DATA_SIZE_Field is ESP32_C3.UInt16;

   --  ASSIST_DEBUG_LOG_DATA_MASK_REG
   type LOG_DATA_MASK_Register is record
      --  reg_log_data_size
      LOG_DATA_SIZE  : LOG_DATA_MASK_LOG_DATA_SIZE_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : ESP32_C3.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for LOG_DATA_MASK_Register use record
      LOG_DATA_SIZE  at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype LOG_MEM_FULL_FLAG_LOG_MEM_FULL_FLAG_Field is ESP32_C3.Bit;
   subtype LOG_MEM_FULL_FLAG_CLR_LOG_MEM_FULL_FLAG_Field is ESP32_C3.Bit;

   --  ASSIST_DEBUG_LOG_MEM_FULL_FLAG_REG
   type LOG_MEM_FULL_FLAG_Register is record
      --  Read-only. reg_log_mem_full_flag
      LOG_MEM_FULL_FLAG     : LOG_MEM_FULL_FLAG_LOG_MEM_FULL_FLAG_Field :=
                               16#0#;
      --  reg_clr_log_mem_full_flag
      CLR_LOG_MEM_FULL_FLAG : LOG_MEM_FULL_FLAG_CLR_LOG_MEM_FULL_FLAG_Field :=
                               16#0#;
      --  unspecified
      Reserved_2_31         : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for LOG_MEM_FULL_FLAG_Register use record
      LOG_MEM_FULL_FLAG     at 0 range 0 .. 0;
      CLR_LOG_MEM_FULL_FLAG at 0 range 1 .. 1;
      Reserved_2_31         at 0 range 2 .. 31;
   end record;

   subtype C0RE_0_DEBUG_MODE_CORE_0_DEBUG_MODE_Field is ESP32_C3.Bit;
   subtype C0RE_0_DEBUG_MODE_CORE_0_DEBUG_MODULE_ACTIVE_Field is ESP32_C3.Bit;

   --  ASSIST_DEBUG_C0RE_0_DEBUG_MODE
   type C0RE_0_DEBUG_MODE_Register is record
      --  Read-only. reg_core_0_debug_mode
      CORE_0_DEBUG_MODE          : C0RE_0_DEBUG_MODE_CORE_0_DEBUG_MODE_Field;
      --  Read-only. reg_core_0_debug_module_active
      CORE_0_DEBUG_MODULE_ACTIVE : C0RE_0_DEBUG_MODE_CORE_0_DEBUG_MODULE_ACTIVE_Field;
      --  unspecified
      Reserved_2_31              : ESP32_C3.UInt30;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for C0RE_0_DEBUG_MODE_Register use record
      CORE_0_DEBUG_MODE          at 0 range 0 .. 0;
      CORE_0_DEBUG_MODULE_ACTIVE at 0 range 1 .. 1;
      Reserved_2_31              at 0 range 2 .. 31;
   end record;

   subtype DATE_ASSIST_DEBUG_DATE_Field is ESP32_C3.UInt28;

   --  ASSIST_DEBUG_DATE_REG
   type DATE_Register is record
      --  reg_assist_debug_date
      ASSIST_DEBUG_DATE : DATE_ASSIST_DEBUG_DATE_Field := 16#2008010#;
      --  unspecified
      Reserved_28_31    : ESP32_C3.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DATE_Register use record
      ASSIST_DEBUG_DATE at 0 range 0 .. 27;
      Reserved_28_31    at 0 range 28 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Debug Assist
   type ASSIST_DEBUG_Peripheral is record
      --  ASSIST_DEBUG_C0RE_0_MONTR_ENA_REG
      CORE_0_MONTR_ENA                       : aliased CORE_0_MONTR_ENA_Register;
      --  ASSIST_DEBUG_CORE_0_INTR_RAW_REG
      CORE_0_INTR_RAW                        : aliased CORE_0_INTR_RAW_Register;
      --  ASSIST_DEBUG_CORE_0_INTR_ENA_REG
      CORE_0_INTR_ENA                        : aliased CORE_0_INTR_ENA_Register;
      --  ASSIST_DEBUG_CORE_0_INTR_CLR_REG
      CORE_0_INTR_CLR                        : aliased CORE_0_INTR_CLR_Register;
      --  ASSIST_DEBUG_CORE_0_AREA_DRAM0_0_MIN_REG
      CORE_0_AREA_DRAM0_0_MIN                : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_CORE_0_AREA_DRAM0_0_MAX_REG
      CORE_0_AREA_DRAM0_0_MAX                : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_CORE_0_AREA_DRAM0_1_MIN_REG
      CORE_0_AREA_DRAM0_1_MIN                : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_CORE_0_AREA_DRAM0_1_MAX_REG
      CORE_0_AREA_DRAM0_1_MAX                : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_CORE_0_AREA_PIF_0_MIN_REG
      CORE_0_AREA_PIF_0_MIN                  : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_CORE_0_AREA_PIF_0_MAX_REG
      CORE_0_AREA_PIF_0_MAX                  : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_CORE_0_AREA_PIF_1_MIN_REG
      CORE_0_AREA_PIF_1_MIN                  : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_CORE_0_AREA_PIF_1_MAX_REG
      CORE_0_AREA_PIF_1_MAX                  : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_CORE_0_AREA_PC_REG
      CORE_0_AREA_PC                         : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_CORE_0_AREA_SP_REG
      CORE_0_AREA_SP                         : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_CORE_0_SP_MIN_REG
      CORE_0_SP_MIN                          : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_CORE_0_SP_MAX_REG
      CORE_0_SP_MAX                          : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_CORE_0_SP_PC_REG
      CORE_0_SP_PC                           : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_CORE_0_RCD_EN_REG
      CORE_0_RCD_EN                          : aliased CORE_0_RCD_EN_Register;
      --  ASSIST_DEBUG_CORE_0_RCD_PDEBUGPC_REG
      CORE_0_RCD_PDEBUGPC                    : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_CORE_0_RCD_PDEBUGSP_REG
      CORE_0_RCD_PDEBUGSP                    : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_CORE_0_RCD_PDEBUGSP_REG
      CORE_0_IRAM0_EXCEPTION_MONITOR_0       : aliased CORE_0_IRAM0_EXCEPTION_MONITOR_0_Register;
      --  ASSIST_DEBUG_CORE_0_IRAM0_EXCEPTION_MONITOR_1_REG
      CORE_0_IRAM0_EXCEPTION_MONITOR_1       : aliased CORE_0_IRAM0_EXCEPTION_MONITOR_1_Register;
      --  ASSIST_DEBUG_CORE_0_DRAM0_EXCEPTION_MONITOR_0_REG
      CORE_0_DRAM0_EXCEPTION_MONITOR_0       : aliased CORE_0_DRAM0_EXCEPTION_MONITOR_0_Register;
      --  ASSIST_DEBUG_CORE_0_DRAM0_EXCEPTION_MONITOR_1_REG
      CORE_0_DRAM0_EXCEPTION_MONITOR_1       : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_CORE_0_DRAM0_EXCEPTION_MONITOR_1_REG
      CORE_0_DRAM0_EXCEPTION_MONITOR_2       : aliased CORE_0_DRAM0_EXCEPTION_MONITOR_2_Register;
      --  ASSIST_DEBUG_CORE_0_DRAM0_EXCEPTION_MONITOR_3_REG
      CORE_0_DRAM0_EXCEPTION_MONITOR_3       : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_0_REG
      CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_0 : aliased CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_0_Register;
      --  ASSIST_DEBUG_CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_1_REG
      CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_1 : aliased CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_1_Register;
      --  ASSIST_DEBUG_LOG_SETTING
      LOG_SETTING                            : aliased LOG_SETTING_Register;
      --  ASSIST_DEBUG_LOG_DATA_0_REG
      LOG_DATA_0                             : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_LOG_DATA_MASK_REG
      LOG_DATA_MASK                          : aliased LOG_DATA_MASK_Register;
      --  ASSIST_DEBUG_LOG_MIN_REG
      LOG_MIN                                : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_LOG_MAX_REG
      LOG_MAX                                : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_LOG_MEM_START_REG
      LOG_MEM_START                          : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_LOG_MEM_END_REG
      LOG_MEM_END                            : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_LOG_MEM_WRITING_ADDR_REG
      LOG_MEM_WRITING_ADDR                   : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_LOG_MEM_FULL_FLAG_REG
      LOG_MEM_FULL_FLAG                      : aliased LOG_MEM_FULL_FLAG_Register;
      --  ASSIST_DEBUG_C0RE_0_LASTPC_BEFORE_EXCEPTION
      C0RE_0_LASTPC_BEFORE_EXCEPTION         : aliased ESP32_C3.UInt32;
      --  ASSIST_DEBUG_C0RE_0_DEBUG_MODE
      C0RE_0_DEBUG_MODE                      : aliased C0RE_0_DEBUG_MODE_Register;
      --  ASSIST_DEBUG_DATE_REG
      DATE                                   : aliased DATE_Register;
   end record
     with Volatile;

   for ASSIST_DEBUG_Peripheral use record
      CORE_0_MONTR_ENA                       at 16#0# range 0 .. 31;
      CORE_0_INTR_RAW                        at 16#4# range 0 .. 31;
      CORE_0_INTR_ENA                        at 16#8# range 0 .. 31;
      CORE_0_INTR_CLR                        at 16#C# range 0 .. 31;
      CORE_0_AREA_DRAM0_0_MIN                at 16#10# range 0 .. 31;
      CORE_0_AREA_DRAM0_0_MAX                at 16#14# range 0 .. 31;
      CORE_0_AREA_DRAM0_1_MIN                at 16#18# range 0 .. 31;
      CORE_0_AREA_DRAM0_1_MAX                at 16#1C# range 0 .. 31;
      CORE_0_AREA_PIF_0_MIN                  at 16#20# range 0 .. 31;
      CORE_0_AREA_PIF_0_MAX                  at 16#24# range 0 .. 31;
      CORE_0_AREA_PIF_1_MIN                  at 16#28# range 0 .. 31;
      CORE_0_AREA_PIF_1_MAX                  at 16#2C# range 0 .. 31;
      CORE_0_AREA_PC                         at 16#30# range 0 .. 31;
      CORE_0_AREA_SP                         at 16#34# range 0 .. 31;
      CORE_0_SP_MIN                          at 16#38# range 0 .. 31;
      CORE_0_SP_MAX                          at 16#3C# range 0 .. 31;
      CORE_0_SP_PC                           at 16#40# range 0 .. 31;
      CORE_0_RCD_EN                          at 16#44# range 0 .. 31;
      CORE_0_RCD_PDEBUGPC                    at 16#48# range 0 .. 31;
      CORE_0_RCD_PDEBUGSP                    at 16#4C# range 0 .. 31;
      CORE_0_IRAM0_EXCEPTION_MONITOR_0       at 16#50# range 0 .. 31;
      CORE_0_IRAM0_EXCEPTION_MONITOR_1       at 16#54# range 0 .. 31;
      CORE_0_DRAM0_EXCEPTION_MONITOR_0       at 16#58# range 0 .. 31;
      CORE_0_DRAM0_EXCEPTION_MONITOR_1       at 16#5C# range 0 .. 31;
      CORE_0_DRAM0_EXCEPTION_MONITOR_2       at 16#60# range 0 .. 31;
      CORE_0_DRAM0_EXCEPTION_MONITOR_3       at 16#64# range 0 .. 31;
      CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_0 at 16#68# range 0 .. 31;
      CORE_X_IRAM0_DRAM0_EXCEPTION_MONITOR_1 at 16#6C# range 0 .. 31;
      LOG_SETTING                            at 16#70# range 0 .. 31;
      LOG_DATA_0                             at 16#74# range 0 .. 31;
      LOG_DATA_MASK                          at 16#78# range 0 .. 31;
      LOG_MIN                                at 16#7C# range 0 .. 31;
      LOG_MAX                                at 16#80# range 0 .. 31;
      LOG_MEM_START                          at 16#84# range 0 .. 31;
      LOG_MEM_END                            at 16#88# range 0 .. 31;
      LOG_MEM_WRITING_ADDR                   at 16#8C# range 0 .. 31;
      LOG_MEM_FULL_FLAG                      at 16#90# range 0 .. 31;
      C0RE_0_LASTPC_BEFORE_EXCEPTION         at 16#94# range 0 .. 31;
      C0RE_0_DEBUG_MODE                      at 16#98# range 0 .. 31;
      DATE                                   at 16#1FC# range 0 .. 31;
   end record;

   --  Debug Assist
   ASSIST_DEBUG_Periph : aliased ASSIST_DEBUG_Peripheral
     with Import, Address => ASSIST_DEBUG_Base;

end ESP32_C3.ASSIST_DEBUG;
