pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.RMT is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  RMT_CH%sDATA_REG.

   --  RMT_CH%sDATA_REG.
   type CHDATA_Registers is array (0 .. 3) of ESP32_C3.UInt32;

   subtype CH_TX_CONF0_TX_START_Field is ESP32_C3.Bit;
   subtype CH_TX_CONF0_MEM_RD_RST_Field is ESP32_C3.Bit;
   subtype CH_TX_CONF0_APB_MEM_RST_Field is ESP32_C3.Bit;
   subtype CH_TX_CONF0_TX_CONTI_MODE_Field is ESP32_C3.Bit;
   subtype CH_TX_CONF0_MEM_TX_WRAP_EN_Field is ESP32_C3.Bit;
   subtype CH_TX_CONF0_IDLE_OUT_LV_Field is ESP32_C3.Bit;
   subtype CH_TX_CONF0_IDLE_OUT_EN_Field is ESP32_C3.Bit;
   subtype CH_TX_CONF0_TX_STOP_Field is ESP32_C3.Bit;
   subtype CH_TX_CONF0_DIV_CNT_Field is ESP32_C3.Byte;
   subtype CH_TX_CONF0_MEM_SIZE_Field is ESP32_C3.UInt3;
   subtype CH_TX_CONF0_CARRIER_EFF_EN_Field is ESP32_C3.Bit;
   subtype CH_TX_CONF0_CARRIER_EN_Field is ESP32_C3.Bit;
   subtype CH_TX_CONF0_CARRIER_OUT_LV_Field is ESP32_C3.Bit;
   subtype CH_TX_CONF0_AFIFO_RST_Field is ESP32_C3.Bit;
   subtype CH_TX_CONF0_CONF_UPDATE_Field is ESP32_C3.Bit;

   --  RMT_CH%sCONF%s_REG.
   type CH_TX_CONF0_Register is record
      --  Write-only. reg_tx_start_ch0.
      TX_START       : CH_TX_CONF0_TX_START_Field := 16#0#;
      --  Write-only. reg_mem_rd_rst_ch0.
      MEM_RD_RST     : CH_TX_CONF0_MEM_RD_RST_Field := 16#0#;
      --  Write-only. reg_apb_mem_rst_ch0.
      APB_MEM_RST    : CH_TX_CONF0_APB_MEM_RST_Field := 16#0#;
      --  reg_tx_conti_mode_ch0.
      TX_CONTI_MODE  : CH_TX_CONF0_TX_CONTI_MODE_Field := 16#0#;
      --  reg_mem_tx_wrap_en_ch0.
      MEM_TX_WRAP_EN : CH_TX_CONF0_MEM_TX_WRAP_EN_Field := 16#0#;
      --  reg_idle_out_lv_ch0.
      IDLE_OUT_LV    : CH_TX_CONF0_IDLE_OUT_LV_Field := 16#0#;
      --  reg_idle_out_en_ch0.
      IDLE_OUT_EN    : CH_TX_CONF0_IDLE_OUT_EN_Field := 16#0#;
      --  reg_tx_stop_ch0.
      TX_STOP        : CH_TX_CONF0_TX_STOP_Field := 16#0#;
      --  reg_div_cnt_ch0.
      DIV_CNT        : CH_TX_CONF0_DIV_CNT_Field := 16#2#;
      --  reg_mem_size_ch0.
      MEM_SIZE       : CH_TX_CONF0_MEM_SIZE_Field := 16#1#;
      --  unspecified
      Reserved_19_19 : ESP32_C3.Bit := 16#0#;
      --  reg_carrier_eff_en_ch0.
      CARRIER_EFF_EN : CH_TX_CONF0_CARRIER_EFF_EN_Field := 16#1#;
      --  reg_carrier_en_ch0.
      CARRIER_EN     : CH_TX_CONF0_CARRIER_EN_Field := 16#1#;
      --  reg_carrier_out_lv_ch0.
      CARRIER_OUT_LV : CH_TX_CONF0_CARRIER_OUT_LV_Field := 16#1#;
      --  Write-only. reg_afifo_rst_ch0.
      AFIFO_RST      : CH_TX_CONF0_AFIFO_RST_Field := 16#0#;
      --  Write-only. reg_reg_conf_update_ch0.
      CONF_UPDATE    : CH_TX_CONF0_CONF_UPDATE_Field := 16#0#;
      --  unspecified
      Reserved_25_31 : ESP32_C3.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CH_TX_CONF0_Register use record
      TX_START       at 0 range 0 .. 0;
      MEM_RD_RST     at 0 range 1 .. 1;
      APB_MEM_RST    at 0 range 2 .. 2;
      TX_CONTI_MODE  at 0 range 3 .. 3;
      MEM_TX_WRAP_EN at 0 range 4 .. 4;
      IDLE_OUT_LV    at 0 range 5 .. 5;
      IDLE_OUT_EN    at 0 range 6 .. 6;
      TX_STOP        at 0 range 7 .. 7;
      DIV_CNT        at 0 range 8 .. 15;
      MEM_SIZE       at 0 range 16 .. 18;
      Reserved_19_19 at 0 range 19 .. 19;
      CARRIER_EFF_EN at 0 range 20 .. 20;
      CARRIER_EN     at 0 range 21 .. 21;
      CARRIER_OUT_LV at 0 range 22 .. 22;
      AFIFO_RST      at 0 range 23 .. 23;
      CONF_UPDATE    at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   --  RMT_CH%sCONF%s_REG.
   type CH_TX_CONF0_Registers is array (0 .. 1) of CH_TX_CONF0_Register;

   subtype CH_RX_CONF_DIV_CNT_Field is ESP32_C3.Byte;
   subtype CH_RX_CONF_IDLE_THRES_Field is ESP32_C3.UInt15;
   subtype CH_RX_CONF_MEM_SIZE_Field is ESP32_C3.UInt3;
   subtype CH_RX_CONF_CARRIER_EN_Field is ESP32_C3.Bit;
   subtype CH_RX_CONF_CARRIER_OUT_LV_Field is ESP32_C3.Bit;

   --  RMT_CH2CONF0_REG.
   type CH_RX_CONF_Register is record
      --  reg_div_cnt_ch2.
      DIV_CNT        : CH_RX_CONF_DIV_CNT_Field := 16#2#;
      --  reg_idle_thres_ch2.
      IDLE_THRES     : CH_RX_CONF_IDLE_THRES_Field := 16#7FFF#;
      --  reg_mem_size_ch2.
      MEM_SIZE       : CH_RX_CONF_MEM_SIZE_Field := 16#1#;
      --  unspecified
      Reserved_26_27 : ESP32_C3.UInt2 := 16#0#;
      --  reg_carrier_en_ch2.
      CARRIER_EN     : CH_RX_CONF_CARRIER_EN_Field := 16#1#;
      --  reg_carrier_out_lv_ch2.
      CARRIER_OUT_LV : CH_RX_CONF_CARRIER_OUT_LV_Field := 16#1#;
      --  unspecified
      Reserved_30_31 : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CH_RX_CONF_Register use record
      DIV_CNT        at 0 range 0 .. 7;
      IDLE_THRES     at 0 range 8 .. 22;
      MEM_SIZE       at 0 range 23 .. 25;
      Reserved_26_27 at 0 range 26 .. 27;
      CARRIER_EN     at 0 range 28 .. 28;
      CARRIER_OUT_LV at 0 range 29 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   subtype CH_RX_CONF_RX_EN_Field is ESP32_C3.Bit;
   subtype CH_RX_CONF_MEM_WR_RST_Field is ESP32_C3.Bit;
   subtype CH_RX_CONF_APB_MEM_RST_Field is ESP32_C3.Bit;
   subtype CH_RX_CONF_MEM_OWNER_Field is ESP32_C3.Bit;
   subtype CH_RX_CONF_RX_FILTER_EN_Field is ESP32_C3.Bit;
   subtype CH_RX_CONF_RX_FILTER_THRES_Field is ESP32_C3.Byte;
   subtype CH_RX_CONF_MEM_RX_WRAP_EN_Field is ESP32_C3.Bit;
   subtype CH_RX_CONF_AFIFO_RST_Field is ESP32_C3.Bit;
   subtype CH_RX_CONF_CONF_UPDATE_Field is ESP32_C3.Bit;

   --  RMT_CH2CONF1_REG.
   type CH_RX_CONF_Register_1 is record
      --  reg_rx_en_ch2.
      RX_EN           : CH_RX_CONF_RX_EN_Field := 16#0#;
      --  Write-only. reg_mem_wr_rst_ch2.
      MEM_WR_RST      : CH_RX_CONF_MEM_WR_RST_Field := 16#0#;
      --  Write-only. reg_apb_mem_rst_ch2.
      APB_MEM_RST     : CH_RX_CONF_APB_MEM_RST_Field := 16#0#;
      --  reg_mem_owner_ch2.
      MEM_OWNER       : CH_RX_CONF_MEM_OWNER_Field := 16#1#;
      --  reg_rx_filter_en_ch2.
      RX_FILTER_EN    : CH_RX_CONF_RX_FILTER_EN_Field := 16#0#;
      --  reg_rx_filter_thres_ch2.
      RX_FILTER_THRES : CH_RX_CONF_RX_FILTER_THRES_Field := 16#F#;
      --  reg_mem_rx_wrap_en_ch2.
      MEM_RX_WRAP_EN  : CH_RX_CONF_MEM_RX_WRAP_EN_Field := 16#0#;
      --  Write-only. reg_afifo_rst_ch2.
      AFIFO_RST       : CH_RX_CONF_AFIFO_RST_Field := 16#0#;
      --  Write-only. reg_conf_update_ch2.
      CONF_UPDATE     : CH_RX_CONF_CONF_UPDATE_Field := 16#0#;
      --  unspecified
      Reserved_16_31  : ESP32_C3.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CH_RX_CONF_Register_1 use record
      RX_EN           at 0 range 0 .. 0;
      MEM_WR_RST      at 0 range 1 .. 1;
      APB_MEM_RST     at 0 range 2 .. 2;
      MEM_OWNER       at 0 range 3 .. 3;
      RX_FILTER_EN    at 0 range 4 .. 4;
      RX_FILTER_THRES at 0 range 5 .. 12;
      MEM_RX_WRAP_EN  at 0 range 13 .. 13;
      AFIFO_RST       at 0 range 14 .. 14;
      CONF_UPDATE     at 0 range 15 .. 15;
      Reserved_16_31  at 0 range 16 .. 31;
   end record;

   subtype CH_TX_STATUS_MEM_RADDR_EX_Field is ESP32_C3.UInt9;
   subtype CH_TX_STATUS_STATE_Field is ESP32_C3.UInt3;
   subtype CH_TX_STATUS_APB_MEM_WADDR_Field is ESP32_C3.UInt9;
   subtype CH_TX_STATUS_APB_MEM_RD_ERR_Field is ESP32_C3.Bit;
   subtype CH_TX_STATUS_MEM_EMPTY_Field is ESP32_C3.Bit;
   subtype CH_TX_STATUS_APB_MEM_WR_ERR_Field is ESP32_C3.Bit;
   subtype CH_TX_STATUS_APB_MEM_RADDR_Field is ESP32_C3.Byte;

   --  RMT_CH%sSTATUS_REG.
   type CH_TX_STATUS_Register is record
      --  Read-only. reg_mem_raddr_ex_ch0.
      MEM_RADDR_EX   : CH_TX_STATUS_MEM_RADDR_EX_Field;
      --  Read-only. reg_state_ch0.
      STATE          : CH_TX_STATUS_STATE_Field;
      --  Read-only. reg_apb_mem_waddr_ch0.
      APB_MEM_WADDR  : CH_TX_STATUS_APB_MEM_WADDR_Field;
      --  Read-only. reg_apb_mem_rd_err_ch0.
      APB_MEM_RD_ERR : CH_TX_STATUS_APB_MEM_RD_ERR_Field;
      --  Read-only. reg_mem_empty_ch0.
      MEM_EMPTY      : CH_TX_STATUS_MEM_EMPTY_Field;
      --  Read-only. reg_apb_mem_wr_err_ch0.
      APB_MEM_WR_ERR : CH_TX_STATUS_APB_MEM_WR_ERR_Field;
      --  Read-only. reg_apb_mem_raddr_ch0.
      APB_MEM_RADDR  : CH_TX_STATUS_APB_MEM_RADDR_Field;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CH_TX_STATUS_Register use record
      MEM_RADDR_EX   at 0 range 0 .. 8;
      STATE          at 0 range 9 .. 11;
      APB_MEM_WADDR  at 0 range 12 .. 20;
      APB_MEM_RD_ERR at 0 range 21 .. 21;
      MEM_EMPTY      at 0 range 22 .. 22;
      APB_MEM_WR_ERR at 0 range 23 .. 23;
      APB_MEM_RADDR  at 0 range 24 .. 31;
   end record;

   --  RMT_CH%sSTATUS_REG.
   type CH_TX_STATUS_Registers is array (0 .. 1) of CH_TX_STATUS_Register;

   subtype CH_RX_STATUS_MEM_WADDR_EX_Field is ESP32_C3.UInt9;
   subtype CH_RX_STATUS_APB_MEM_RADDR_Field is ESP32_C3.UInt9;
   subtype CH_RX_STATUS_STATE_Field is ESP32_C3.UInt3;
   subtype CH_RX_STATUS_MEM_OWNER_ERR_Field is ESP32_C3.Bit;
   subtype CH_RX_STATUS_MEM_FULL_Field is ESP32_C3.Bit;
   subtype CH_RX_STATUS_APB_MEM_RD_ERR_Field is ESP32_C3.Bit;

   --  RMT_CH2STATUS_REG.
   type CH_RX_STATUS_Register is record
      --  Read-only. reg_mem_waddr_ex_ch2.
      MEM_WADDR_EX   : CH_RX_STATUS_MEM_WADDR_EX_Field;
      --  unspecified
      Reserved_9_11  : ESP32_C3.UInt3;
      --  Read-only. reg_apb_mem_raddr_ch2.
      APB_MEM_RADDR  : CH_RX_STATUS_APB_MEM_RADDR_Field;
      --  unspecified
      Reserved_21_21 : ESP32_C3.Bit;
      --  Read-only. reg_state_ch2.
      STATE          : CH_RX_STATUS_STATE_Field;
      --  Read-only. reg_mem_owner_err_ch2.
      MEM_OWNER_ERR  : CH_RX_STATUS_MEM_OWNER_ERR_Field;
      --  Read-only. reg_mem_full_ch2.
      MEM_FULL       : CH_RX_STATUS_MEM_FULL_Field;
      --  Read-only. reg_apb_mem_rd_err_ch2.
      APB_MEM_RD_ERR : CH_RX_STATUS_APB_MEM_RD_ERR_Field;
      --  unspecified
      Reserved_28_31 : ESP32_C3.UInt4;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CH_RX_STATUS_Register use record
      MEM_WADDR_EX   at 0 range 0 .. 8;
      Reserved_9_11  at 0 range 9 .. 11;
      APB_MEM_RADDR  at 0 range 12 .. 20;
      Reserved_21_21 at 0 range 21 .. 21;
      STATE          at 0 range 22 .. 24;
      MEM_OWNER_ERR  at 0 range 25 .. 25;
      MEM_FULL       at 0 range 26 .. 26;
      APB_MEM_RD_ERR at 0 range 27 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   --  RMT_CH2STATUS_REG.
   type CH_RX_STATUS_Registers is array (0 .. 1) of CH_RX_STATUS_Register;

   subtype INT_RAW_CH%s_TX_END_Field is ESP32_C3.Bit;
   subtype INT_RAW_CH%s_RX_END_Field is ESP32_C3.Bit;
   subtype INT_RAW_CH%s_TX_ERR_Field is ESP32_C3.Bit;
   subtype INT_RAW_CH%s_RX_ERR_Field is ESP32_C3.Bit;
   subtype INT_RAW_CH%s_TX_THR_EVENT_Field is ESP32_C3.Bit;
   subtype INT_RAW_CH%s_RX_THR_EVENT_Field is ESP32_C3.Bit;
   subtype INT_RAW_CH%s_TX_LOOP_Field is ESP32_C3.Bit;

   --  RMT_INT_RAW_REG.
   type INT_RAW_Register is record
      --  reg_ch%s_tx_end_int_raw.
      CH%s_TX_END       : INT_RAW_CH%s_TX_END_Field := 16#0#;
      --  unspecified
      Reserved_1_1      : ESP32_C3.Bit := 16#0#;
      --  reg_ch2_rx_end_int_raw.
      CH%s_RX_END       : INT_RAW_CH%s_RX_END_Field := 16#0#;
      --  unspecified
      Reserved_3_3      : ESP32_C3.Bit := 16#0#;
      --  reg_ch%s_err_int_raw.
      CH%s_TX_ERR       : INT_RAW_CH%s_TX_ERR_Field := 16#0#;
      --  unspecified
      Reserved_5_5      : ESP32_C3.Bit := 16#0#;
      --  reg_ch2_err_int_raw.
      CH%s_RX_ERR       : INT_RAW_CH%s_RX_ERR_Field := 16#0#;
      --  unspecified
      Reserved_7_7      : ESP32_C3.Bit := 16#0#;
      --  reg_ch%s_tx_thr_event_int_raw.
      CH%s_TX_THR_EVENT : INT_RAW_CH%s_TX_THR_EVENT_Field := 16#0#;
      --  unspecified
      Reserved_9_9      : ESP32_C3.Bit := 16#0#;
      --  reg_ch2_rx_thr_event_int_raw.
      CH%s_RX_THR_EVENT : INT_RAW_CH%s_RX_THR_EVENT_Field := 16#0#;
      --  unspecified
      Reserved_11_11    : ESP32_C3.Bit := 16#0#;
      --  reg_ch%s_tx_loop_int_raw.
      CH%s_TX_LOOP      : INT_RAW_CH%s_TX_LOOP_Field := 16#0#;
      --  unspecified
      Reserved_13_31    : ESP32_C3.UInt19 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_RAW_Register use record
      CH%s_TX_END       at 0 range 0 .. 0;
      Reserved_1_1      at 0 range 1 .. 1;
      CH%s_RX_END       at 0 range 2 .. 2;
      Reserved_3_3      at 0 range 3 .. 3;
      CH%s_TX_ERR       at 0 range 4 .. 4;
      Reserved_5_5      at 0 range 5 .. 5;
      CH%s_RX_ERR       at 0 range 6 .. 6;
      Reserved_7_7      at 0 range 7 .. 7;
      CH%s_TX_THR_EVENT at 0 range 8 .. 8;
      Reserved_9_9      at 0 range 9 .. 9;
      CH%s_RX_THR_EVENT at 0 range 10 .. 10;
      Reserved_11_11    at 0 range 11 .. 11;
      CH%s_TX_LOOP      at 0 range 12 .. 12;
      Reserved_13_31    at 0 range 13 .. 31;
   end record;

   subtype INT_ST_CH%s_TX_END_Field is ESP32_C3.Bit;
   subtype INT_ST_CH%s_RX_END_Field is ESP32_C3.Bit;
   subtype INT_ST_CH%s_TX_ERR_Field is ESP32_C3.Bit;
   subtype INT_ST_CH%s_RX_ERR_Field is ESP32_C3.Bit;
   subtype INT_ST_CH%s_TX_THR_EVENT_Field is ESP32_C3.Bit;
   subtype INT_ST_CH%s_RX_THR_EVENT_Field is ESP32_C3.Bit;
   subtype INT_ST_CH%s_TX_LOOP_Field is ESP32_C3.Bit;

   --  RMT_INT_ST_REG.
   type INT_ST_Register is record
      --  Read-only. reg_ch%s_tx_end_int_st.
      CH%s_TX_END       : INT_ST_CH%s_TX_END_Field;
      --  unspecified
      Reserved_1_1      : ESP32_C3.Bit;
      --  Read-only. reg_ch2_rx_end_int_st.
      CH%s_RX_END       : INT_ST_CH%s_RX_END_Field;
      --  unspecified
      Reserved_3_3      : ESP32_C3.Bit;
      --  Read-only. reg_ch%s_err_int_st.
      CH%s_TX_ERR       : INT_ST_CH%s_TX_ERR_Field;
      --  unspecified
      Reserved_5_5      : ESP32_C3.Bit;
      --  Read-only. reg_ch2_err_int_st.
      CH%s_RX_ERR       : INT_ST_CH%s_RX_ERR_Field;
      --  unspecified
      Reserved_7_7      : ESP32_C3.Bit;
      --  Read-only. reg_ch%s_tx_thr_event_int_st.
      CH%s_TX_THR_EVENT : INT_ST_CH%s_TX_THR_EVENT_Field;
      --  unspecified
      Reserved_9_9      : ESP32_C3.Bit;
      --  Read-only. reg_ch2_rx_thr_event_int_st.
      CH%s_RX_THR_EVENT : INT_ST_CH%s_RX_THR_EVENT_Field;
      --  unspecified
      Reserved_11_11    : ESP32_C3.Bit;
      --  Read-only. reg_ch%s_tx_loop_int_st.
      CH%s_TX_LOOP      : INT_ST_CH%s_TX_LOOP_Field;
      --  unspecified
      Reserved_13_31    : ESP32_C3.UInt19;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_ST_Register use record
      CH%s_TX_END       at 0 range 0 .. 0;
      Reserved_1_1      at 0 range 1 .. 1;
      CH%s_RX_END       at 0 range 2 .. 2;
      Reserved_3_3      at 0 range 3 .. 3;
      CH%s_TX_ERR       at 0 range 4 .. 4;
      Reserved_5_5      at 0 range 5 .. 5;
      CH%s_RX_ERR       at 0 range 6 .. 6;
      Reserved_7_7      at 0 range 7 .. 7;
      CH%s_TX_THR_EVENT at 0 range 8 .. 8;
      Reserved_9_9      at 0 range 9 .. 9;
      CH%s_RX_THR_EVENT at 0 range 10 .. 10;
      Reserved_11_11    at 0 range 11 .. 11;
      CH%s_TX_LOOP      at 0 range 12 .. 12;
      Reserved_13_31    at 0 range 13 .. 31;
   end record;

   subtype INT_ENA_CH%s_TX_END_Field is ESP32_C3.Bit;
   subtype INT_ENA_CH%s_RX_END_Field is ESP32_C3.Bit;
   subtype INT_ENA_CH%s_TX_ERR_Field is ESP32_C3.Bit;
   subtype INT_ENA_CH%s_RX_ERR_Field is ESP32_C3.Bit;
   subtype INT_ENA_CH%s_TX_THR_EVENT_Field is ESP32_C3.Bit;
   subtype INT_ENA_CH%s_RX_THR_EVENT_Field is ESP32_C3.Bit;
   subtype INT_ENA_CH%s_TX_LOOP_Field is ESP32_C3.Bit;

   --  RMT_INT_ENA_REG.
   type INT_ENA_Register is record
      --  reg_ch%s_tx_end_int_ena.
      CH%s_TX_END       : INT_ENA_CH%s_TX_END_Field := 16#0#;
      --  unspecified
      Reserved_1_1      : ESP32_C3.Bit := 16#0#;
      --  reg_ch2_rx_end_int_ena.
      CH%s_RX_END       : INT_ENA_CH%s_RX_END_Field := 16#0#;
      --  unspecified
      Reserved_3_3      : ESP32_C3.Bit := 16#0#;
      --  reg_ch%s_err_int_ena.
      CH%s_TX_ERR       : INT_ENA_CH%s_TX_ERR_Field := 16#0#;
      --  unspecified
      Reserved_5_5      : ESP32_C3.Bit := 16#0#;
      --  reg_ch2_err_int_ena.
      CH%s_RX_ERR       : INT_ENA_CH%s_RX_ERR_Field := 16#0#;
      --  unspecified
      Reserved_7_7      : ESP32_C3.Bit := 16#0#;
      --  reg_ch%s_tx_thr_event_int_ena.
      CH%s_TX_THR_EVENT : INT_ENA_CH%s_TX_THR_EVENT_Field := 16#0#;
      --  unspecified
      Reserved_9_9      : ESP32_C3.Bit := 16#0#;
      --  reg_ch2_rx_thr_event_int_ena.
      CH%s_RX_THR_EVENT : INT_ENA_CH%s_RX_THR_EVENT_Field := 16#0#;
      --  unspecified
      Reserved_11_11    : ESP32_C3.Bit := 16#0#;
      --  reg_ch%s_tx_loop_int_ena.
      CH%s_TX_LOOP      : INT_ENA_CH%s_TX_LOOP_Field := 16#0#;
      --  unspecified
      Reserved_13_31    : ESP32_C3.UInt19 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_ENA_Register use record
      CH%s_TX_END       at 0 range 0 .. 0;
      Reserved_1_1      at 0 range 1 .. 1;
      CH%s_RX_END       at 0 range 2 .. 2;
      Reserved_3_3      at 0 range 3 .. 3;
      CH%s_TX_ERR       at 0 range 4 .. 4;
      Reserved_5_5      at 0 range 5 .. 5;
      CH%s_RX_ERR       at 0 range 6 .. 6;
      Reserved_7_7      at 0 range 7 .. 7;
      CH%s_TX_THR_EVENT at 0 range 8 .. 8;
      Reserved_9_9      at 0 range 9 .. 9;
      CH%s_RX_THR_EVENT at 0 range 10 .. 10;
      Reserved_11_11    at 0 range 11 .. 11;
      CH%s_TX_LOOP      at 0 range 12 .. 12;
      Reserved_13_31    at 0 range 13 .. 31;
   end record;

   subtype INT_CLR_CH%s_TX_END_Field is ESP32_C3.Bit;
   subtype INT_CLR_CH%s_RX_END_Field is ESP32_C3.Bit;
   subtype INT_CLR_CH%s_TX_ERR_Field is ESP32_C3.Bit;
   subtype INT_CLR_CH%s_RX_ERR_Field is ESP32_C3.Bit;
   subtype INT_CLR_CH%s_TX_THR_EVENT_Field is ESP32_C3.Bit;
   subtype INT_CLR_CH%s_RX_THR_EVENT_Field is ESP32_C3.Bit;
   subtype INT_CLR_CH%s_TX_LOOP_Field is ESP32_C3.Bit;

   --  RMT_INT_CLR_REG.
   type INT_CLR_Register is record
      --  Write-only. reg_ch%s_tx_end_int_clr.
      CH%s_TX_END       : INT_CLR_CH%s_TX_END_Field := 16#0#;
      --  unspecified
      Reserved_1_1      : ESP32_C3.Bit := 16#0#;
      --  Write-only. reg_ch2_rx_end_int_clr.
      CH%s_RX_END       : INT_CLR_CH%s_RX_END_Field := 16#0#;
      --  unspecified
      Reserved_3_3      : ESP32_C3.Bit := 16#0#;
      --  Write-only. reg_ch%s_err_int_clr.
      CH%s_TX_ERR       : INT_CLR_CH%s_TX_ERR_Field := 16#0#;
      --  unspecified
      Reserved_5_5      : ESP32_C3.Bit := 16#0#;
      --  Write-only. reg_ch2_err_int_clr.
      CH%s_RX_ERR       : INT_CLR_CH%s_RX_ERR_Field := 16#0#;
      --  unspecified
      Reserved_7_7      : ESP32_C3.Bit := 16#0#;
      --  Write-only. reg_ch%s_tx_thr_event_int_clr.
      CH%s_TX_THR_EVENT : INT_CLR_CH%s_TX_THR_EVENT_Field := 16#0#;
      --  unspecified
      Reserved_9_9      : ESP32_C3.Bit := 16#0#;
      --  Write-only. reg_ch2_rx_thr_event_int_clr.
      CH%s_RX_THR_EVENT : INT_CLR_CH%s_RX_THR_EVENT_Field := 16#0#;
      --  unspecified
      Reserved_11_11    : ESP32_C3.Bit := 16#0#;
      --  Write-only. reg_ch%s_tx_loop_int_clr.
      CH%s_TX_LOOP      : INT_CLR_CH%s_TX_LOOP_Field := 16#0#;
      --  unspecified
      Reserved_13_31    : ESP32_C3.UInt19 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_CLR_Register use record
      CH%s_TX_END       at 0 range 0 .. 0;
      Reserved_1_1      at 0 range 1 .. 1;
      CH%s_RX_END       at 0 range 2 .. 2;
      Reserved_3_3      at 0 range 3 .. 3;
      CH%s_TX_ERR       at 0 range 4 .. 4;
      Reserved_5_5      at 0 range 5 .. 5;
      CH%s_RX_ERR       at 0 range 6 .. 6;
      Reserved_7_7      at 0 range 7 .. 7;
      CH%s_TX_THR_EVENT at 0 range 8 .. 8;
      Reserved_9_9      at 0 range 9 .. 9;
      CH%s_RX_THR_EVENT at 0 range 10 .. 10;
      Reserved_11_11    at 0 range 11 .. 11;
      CH%s_TX_LOOP      at 0 range 12 .. 12;
      Reserved_13_31    at 0 range 13 .. 31;
   end record;

   subtype CHCARRIER_DUTY_CARRIER_LOW_Field is ESP32_C3.UInt16;
   subtype CHCARRIER_DUTY_CARRIER_HIGH_Field is ESP32_C3.UInt16;

   --  RMT_CH%sCARRIER_DUTY_REG.
   type CHCARRIER_DUTY_Register is record
      --  reg_carrier_low_ch0.
      CARRIER_LOW  : CHCARRIER_DUTY_CARRIER_LOW_Field := 16#40#;
      --  reg_carrier_high_ch0.
      CARRIER_HIGH : CHCARRIER_DUTY_CARRIER_HIGH_Field := 16#40#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CHCARRIER_DUTY_Register use record
      CARRIER_LOW  at 0 range 0 .. 15;
      CARRIER_HIGH at 0 range 16 .. 31;
   end record;

   --  RMT_CH%sCARRIER_DUTY_REG.
   type CHCARRIER_DUTY_Registers is array (0 .. 1) of CHCARRIER_DUTY_Register;

   subtype CH_RX_CARRIER_RM_CARRIER_LOW_THRES_Field is ESP32_C3.UInt16;
   subtype CH_RX_CARRIER_RM_CARRIER_HIGH_THRES_Field is ESP32_C3.UInt16;

   --  RMT_CH2_RX_CARRIER_RM_REG.
   type CH_RX_CARRIER_RM_Register is record
      --  reg_carrier_low_thres_ch2.
      CARRIER_LOW_THRES  : CH_RX_CARRIER_RM_CARRIER_LOW_THRES_Field := 16#0#;
      --  reg_carrier_high_thres_ch2.
      CARRIER_HIGH_THRES : CH_RX_CARRIER_RM_CARRIER_HIGH_THRES_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CH_RX_CARRIER_RM_Register use record
      CARRIER_LOW_THRES  at 0 range 0 .. 15;
      CARRIER_HIGH_THRES at 0 range 16 .. 31;
   end record;

   --  RMT_CH2_RX_CARRIER_RM_REG.
   type CH_RX_CARRIER_RM_Registers is array (0 .. 1)
     of CH_RX_CARRIER_RM_Register;

   subtype CH_TX_LIM_TX_LIM_Field is ESP32_C3.UInt9;
   subtype CH_TX_LIM_TX_LOOP_NUM_Field is ESP32_C3.UInt10;
   subtype CH_TX_LIM_TX_LOOP_CNT_EN_Field is ESP32_C3.Bit;
   subtype CH_TX_LIM_LOOP_COUNT_RESET_Field is ESP32_C3.Bit;

   --  RMT_CH%s_TX_LIM_REG.
   type CH_TX_LIM_Register is record
      --  reg_rmt_tx_lim_ch0.
      TX_LIM           : CH_TX_LIM_TX_LIM_Field := 16#80#;
      --  reg_rmt_tx_loop_num_ch0.
      TX_LOOP_NUM      : CH_TX_LIM_TX_LOOP_NUM_Field := 16#0#;
      --  reg_rmt_tx_loop_cnt_en_ch0.
      TX_LOOP_CNT_EN   : CH_TX_LIM_TX_LOOP_CNT_EN_Field := 16#0#;
      --  Write-only. reg_loop_count_reset_ch0.
      LOOP_COUNT_RESET : CH_TX_LIM_LOOP_COUNT_RESET_Field := 16#0#;
      --  unspecified
      Reserved_21_31   : ESP32_C3.UInt11 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CH_TX_LIM_Register use record
      TX_LIM           at 0 range 0 .. 8;
      TX_LOOP_NUM      at 0 range 9 .. 18;
      TX_LOOP_CNT_EN   at 0 range 19 .. 19;
      LOOP_COUNT_RESET at 0 range 20 .. 20;
      Reserved_21_31   at 0 range 21 .. 31;
   end record;

   --  RMT_CH%s_TX_LIM_REG.
   type CH_TX_LIM_Registers is array (0 .. 1) of CH_TX_LIM_Register;

   subtype CH_RX_LIM_RX_LIM_Field is ESP32_C3.UInt9;

   --  RMT_CH2_RX_LIM_REG.
   type CH_RX_LIM_Register is record
      --  reg_rmt_rx_lim_ch2.
      RX_LIM        : CH_RX_LIM_RX_LIM_Field := 16#80#;
      --  unspecified
      Reserved_9_31 : ESP32_C3.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CH_RX_LIM_Register use record
      RX_LIM        at 0 range 0 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   --  RMT_CH2_RX_LIM_REG.
   type CH_RX_LIM_Registers is array (0 .. 1) of CH_RX_LIM_Register;

   subtype SYS_CONF_APB_FIFO_MASK_Field is ESP32_C3.Bit;
   subtype SYS_CONF_MEM_CLK_FORCE_ON_Field is ESP32_C3.Bit;
   subtype SYS_CONF_MEM_FORCE_PD_Field is ESP32_C3.Bit;
   subtype SYS_CONF_MEM_FORCE_PU_Field is ESP32_C3.Bit;
   subtype SYS_CONF_SCLK_DIV_NUM_Field is ESP32_C3.Byte;
   subtype SYS_CONF_SCLK_DIV_A_Field is ESP32_C3.UInt6;
   subtype SYS_CONF_SCLK_DIV_B_Field is ESP32_C3.UInt6;
   subtype SYS_CONF_SCLK_SEL_Field is ESP32_C3.UInt2;
   subtype SYS_CONF_SCLK_ACTIVE_Field is ESP32_C3.Bit;
   subtype SYS_CONF_CLK_EN_Field is ESP32_C3.Bit;

   --  RMT_SYS_CONF_REG.
   type SYS_CONF_Register is record
      --  reg_apb_fifo_mask.
      APB_FIFO_MASK    : SYS_CONF_APB_FIFO_MASK_Field := 16#0#;
      --  reg_mem_clk_force_on.
      MEM_CLK_FORCE_ON : SYS_CONF_MEM_CLK_FORCE_ON_Field := 16#0#;
      --  reg_rmt_mem_force_pd.
      MEM_FORCE_PD     : SYS_CONF_MEM_FORCE_PD_Field := 16#0#;
      --  reg_rmt_mem_force_pu.
      MEM_FORCE_PU     : SYS_CONF_MEM_FORCE_PU_Field := 16#0#;
      --  reg_rmt_sclk_div_num.
      SCLK_DIV_NUM     : SYS_CONF_SCLK_DIV_NUM_Field := 16#1#;
      --  reg_rmt_sclk_div_a.
      SCLK_DIV_A       : SYS_CONF_SCLK_DIV_A_Field := 16#0#;
      --  reg_rmt_sclk_div_b.
      SCLK_DIV_B       : SYS_CONF_SCLK_DIV_B_Field := 16#0#;
      --  reg_rmt_sclk_sel.
      SCLK_SEL         : SYS_CONF_SCLK_SEL_Field := 16#1#;
      --  reg_rmt_sclk_active.
      SCLK_ACTIVE      : SYS_CONF_SCLK_ACTIVE_Field := 16#1#;
      --  unspecified
      Reserved_27_30   : ESP32_C3.UInt4 := 16#0#;
      --  reg_clk_en.
      CLK_EN           : SYS_CONF_CLK_EN_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYS_CONF_Register use record
      APB_FIFO_MASK    at 0 range 0 .. 0;
      MEM_CLK_FORCE_ON at 0 range 1 .. 1;
      MEM_FORCE_PD     at 0 range 2 .. 2;
      MEM_FORCE_PU     at 0 range 3 .. 3;
      SCLK_DIV_NUM     at 0 range 4 .. 11;
      SCLK_DIV_A       at 0 range 12 .. 17;
      SCLK_DIV_B       at 0 range 18 .. 23;
      SCLK_SEL         at 0 range 24 .. 25;
      SCLK_ACTIVE      at 0 range 26 .. 26;
      Reserved_27_30   at 0 range 27 .. 30;
      CLK_EN           at 0 range 31 .. 31;
   end record;

   --  TX_SIM_TX_SIM_CH array element
   subtype TX_SIM_TX_SIM_CH_Element is ESP32_C3.Bit;

   --  TX_SIM_TX_SIM_CH array
   type TX_SIM_TX_SIM_CH_Field_Array is array (0 .. 1)
     of TX_SIM_TX_SIM_CH_Element
     with Component_Size => 1, Size => 2;

   --  Type definition for TX_SIM_TX_SIM_CH
   type TX_SIM_TX_SIM_CH_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  TX_SIM_CH as a value
            Val : ESP32_C3.UInt2;
         when True =>
            --  TX_SIM_CH as an array
            Arr : TX_SIM_TX_SIM_CH_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for TX_SIM_TX_SIM_CH_Field use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   subtype TX_SIM_TX_SIM_EN_Field is ESP32_C3.Bit;

   --  RMT_TX_SIM_REG.
   type TX_SIM_Register is record
      --  reg_rmt_tx_sim_ch0.
      TX_SIM_CH     : TX_SIM_TX_SIM_CH_Field :=
                       (As_Array => False, Val => 16#0#);
      --  reg_rmt_tx_sim_en.
      TX_SIM_EN     : TX_SIM_TX_SIM_EN_Field := 16#0#;
      --  unspecified
      Reserved_3_31 : ESP32_C3.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TX_SIM_Register use record
      TX_SIM_CH     at 0 range 0 .. 1;
      TX_SIM_EN     at 0 range 2 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   --  REF_CNT_RST_CH array element
   subtype REF_CNT_RST_CH_Element is ESP32_C3.Bit;

   --  REF_CNT_RST_CH array
   type REF_CNT_RST_CH_Field_Array is array (0 .. 3)
     of REF_CNT_RST_CH_Element
     with Component_Size => 1, Size => 4;

   --  Type definition for REF_CNT_RST_CH
   type REF_CNT_RST_CH_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  CH as a value
            Val : ESP32_C3.UInt4;
         when True =>
            --  CH as an array
            Arr : REF_CNT_RST_CH_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 4;

   for REF_CNT_RST_CH_Field use record
      Val at 0 range 0 .. 3;
      Arr at 0 range 0 .. 3;
   end record;

   --  RMT_REF_CNT_RST_REG.
   type REF_CNT_RST_Register is record
      --  Write-only. reg_ref_cnt_rst_ch0.
      CH            : REF_CNT_RST_CH_Field :=
                       (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_4_31 : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REF_CNT_RST_Register use record
      CH            at 0 range 0 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype DATE_DATE_Field is ESP32_C3.UInt28;

   --  RMT_DATE_REG.
   type DATE_Register is record
      --  reg_rmt_date.
      DATE           : DATE_DATE_Field := 16#2006231#;
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

   --  Remote Control
   type RMT_Peripheral is record
      --  RMT_CH%sDATA_REG.
      CHDATA           : aliased CHDATA_Registers;
      --  RMT_CH%sCONF%s_REG.
      CH_TX_CONF0      : aliased CH_TX_CONF0_Registers;
      --  RMT_CH2CONF0_REG.
      CH_RX_CONF00     : aliased CH_RX_CONF_Register;
      --  RMT_CH2CONF1_REG.
      CH_RX_CONF10     : aliased CH_RX_CONF_Register_1;
      --  RMT_CH2CONF0_REG.
      CH_RX_CONF01     : aliased CH_RX_CONF_Register;
      --  RMT_CH2CONF1_REG.
      CH_RX_CONF11     : aliased CH_RX_CONF_Register_1;
      --  RMT_CH%sSTATUS_REG.
      CH_TX_STATUS     : aliased CH_TX_STATUS_Registers;
      --  RMT_CH2STATUS_REG.
      CH_RX_STATUS     : aliased CH_RX_STATUS_Registers;
      --  RMT_INT_RAW_REG.
      INT_RAW          : aliased INT_RAW_Register;
      --  RMT_INT_ST_REG.
      INT_ST           : aliased INT_ST_Register;
      --  RMT_INT_ENA_REG.
      INT_ENA          : aliased INT_ENA_Register;
      --  RMT_INT_CLR_REG.
      INT_CLR          : aliased INT_CLR_Register;
      --  RMT_CH%sCARRIER_DUTY_REG.
      CHCARRIER_DUTY   : aliased CHCARRIER_DUTY_Registers;
      --  RMT_CH2_RX_CARRIER_RM_REG.
      CH_RX_CARRIER_RM : aliased CH_RX_CARRIER_RM_Registers;
      --  RMT_CH%s_TX_LIM_REG.
      CH_TX_LIM        : aliased CH_TX_LIM_Registers;
      --  RMT_CH2_RX_LIM_REG.
      CH_RX_LIM        : aliased CH_RX_LIM_Registers;
      --  RMT_SYS_CONF_REG.
      SYS_CONF         : aliased SYS_CONF_Register;
      --  RMT_TX_SIM_REG.
      TX_SIM           : aliased TX_SIM_Register;
      --  RMT_REF_CNT_RST_REG.
      REF_CNT_RST      : aliased REF_CNT_RST_Register;
      --  RMT_DATE_REG.
      DATE             : aliased DATE_Register;
   end record
     with Volatile;

   for RMT_Peripheral use record
      CHDATA           at 16#0# range 0 .. 127;
      CH_TX_CONF0      at 16#10# range 0 .. 63;
      CH_RX_CONF00     at 16#18# range 0 .. 31;
      CH_RX_CONF10     at 16#1C# range 0 .. 31;
      CH_RX_CONF01     at 16#20# range 0 .. 31;
      CH_RX_CONF11     at 16#24# range 0 .. 31;
      CH_TX_STATUS     at 16#28# range 0 .. 63;
      CH_RX_STATUS     at 16#30# range 0 .. 63;
      INT_RAW          at 16#38# range 0 .. 31;
      INT_ST           at 16#3C# range 0 .. 31;
      INT_ENA          at 16#40# range 0 .. 31;
      INT_CLR          at 16#44# range 0 .. 31;
      CHCARRIER_DUTY   at 16#48# range 0 .. 63;
      CH_RX_CARRIER_RM at 16#50# range 0 .. 63;
      CH_TX_LIM        at 16#58# range 0 .. 63;
      CH_RX_LIM        at 16#60# range 0 .. 63;
      SYS_CONF         at 16#68# range 0 .. 31;
      TX_SIM           at 16#6C# range 0 .. 31;
      REF_CNT_RST      at 16#70# range 0 .. 31;
      DATE             at 16#CC# range 0 .. 31;
   end record;

   --  Remote Control
   RMT_Periph : aliased RMT_Peripheral
     with Import, Address => RMT_Base;

end ESP32_C3.RMT;
