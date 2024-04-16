pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.I2C is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype SCL_LOW_PERIOD_SCL_LOW_PERIOD_Field is ESP32_C3.UInt9;

   --  I2C_SCL_LOW_PERIOD_REG
   type SCL_LOW_PERIOD_Register is record
      --  reg_scl_low_period
      SCL_LOW_PERIOD : SCL_LOW_PERIOD_SCL_LOW_PERIOD_Field := 16#0#;
      --  unspecified
      Reserved_9_31  : ESP32_C3.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCL_LOW_PERIOD_Register use record
      SCL_LOW_PERIOD at 0 range 0 .. 8;
      Reserved_9_31  at 0 range 9 .. 31;
   end record;

   subtype CTR_SDA_FORCE_OUT_Field is ESP32_C3.Bit;
   subtype CTR_SCL_FORCE_OUT_Field is ESP32_C3.Bit;
   subtype CTR_SAMPLE_SCL_LEVEL_Field is ESP32_C3.Bit;
   subtype CTR_RX_FULL_ACK_LEVEL_Field is ESP32_C3.Bit;
   subtype CTR_MS_MODE_Field is ESP32_C3.Bit;
   subtype CTR_TRANS_START_Field is ESP32_C3.Bit;
   subtype CTR_TX_LSB_FIRST_Field is ESP32_C3.Bit;
   subtype CTR_RX_LSB_FIRST_Field is ESP32_C3.Bit;
   subtype CTR_CLK_EN_Field is ESP32_C3.Bit;
   subtype CTR_ARBITRATION_EN_Field is ESP32_C3.Bit;
   subtype CTR_FSM_RST_Field is ESP32_C3.Bit;
   subtype CTR_CONF_UPGATE_Field is ESP32_C3.Bit;
   subtype CTR_SLV_TX_AUTO_START_EN_Field is ESP32_C3.Bit;
   subtype CTR_ADDR_10BIT_RW_CHECK_EN_Field is ESP32_C3.Bit;
   subtype CTR_ADDR_BROADCASTING_EN_Field is ESP32_C3.Bit;

   --  I2C_CTR_REG
   type CTR_Register is record
      --  reg_sda_force_out
      SDA_FORCE_OUT          : CTR_SDA_FORCE_OUT_Field := 16#1#;
      --  reg_scl_force_out
      SCL_FORCE_OUT          : CTR_SCL_FORCE_OUT_Field := 16#1#;
      --  reg_sample_scl_level
      SAMPLE_SCL_LEVEL       : CTR_SAMPLE_SCL_LEVEL_Field := 16#0#;
      --  reg_rx_full_ack_level
      RX_FULL_ACK_LEVEL      : CTR_RX_FULL_ACK_LEVEL_Field := 16#1#;
      --  reg_ms_mode
      MS_MODE                : CTR_MS_MODE_Field := 16#0#;
      --  Write-only. reg_trans_start
      TRANS_START            : CTR_TRANS_START_Field := 16#0#;
      --  reg_tx_lsb_first
      TX_LSB_FIRST           : CTR_TX_LSB_FIRST_Field := 16#0#;
      --  reg_rx_lsb_first
      RX_LSB_FIRST           : CTR_RX_LSB_FIRST_Field := 16#0#;
      --  reg_clk_en
      CLK_EN                 : CTR_CLK_EN_Field := 16#0#;
      --  reg_arbitration_en
      ARBITRATION_EN         : CTR_ARBITRATION_EN_Field := 16#1#;
      --  Write-only. reg_fsm_rst
      FSM_RST                : CTR_FSM_RST_Field := 16#0#;
      --  Write-only. reg_conf_upgate
      CONF_UPGATE            : CTR_CONF_UPGATE_Field := 16#0#;
      --  reg_slv_tx_auto_start_en
      SLV_TX_AUTO_START_EN   : CTR_SLV_TX_AUTO_START_EN_Field := 16#0#;
      --  reg_addr_10bit_rw_check_en
      ADDR_10BIT_RW_CHECK_EN : CTR_ADDR_10BIT_RW_CHECK_EN_Field := 16#0#;
      --  reg_addr_broadcasting_en
      ADDR_BROADCASTING_EN   : CTR_ADDR_BROADCASTING_EN_Field := 16#0#;
      --  unspecified
      Reserved_15_31         : ESP32_C3.UInt17 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CTR_Register use record
      SDA_FORCE_OUT          at 0 range 0 .. 0;
      SCL_FORCE_OUT          at 0 range 1 .. 1;
      SAMPLE_SCL_LEVEL       at 0 range 2 .. 2;
      RX_FULL_ACK_LEVEL      at 0 range 3 .. 3;
      MS_MODE                at 0 range 4 .. 4;
      TRANS_START            at 0 range 5 .. 5;
      TX_LSB_FIRST           at 0 range 6 .. 6;
      RX_LSB_FIRST           at 0 range 7 .. 7;
      CLK_EN                 at 0 range 8 .. 8;
      ARBITRATION_EN         at 0 range 9 .. 9;
      FSM_RST                at 0 range 10 .. 10;
      CONF_UPGATE            at 0 range 11 .. 11;
      SLV_TX_AUTO_START_EN   at 0 range 12 .. 12;
      ADDR_10BIT_RW_CHECK_EN at 0 range 13 .. 13;
      ADDR_BROADCASTING_EN   at 0 range 14 .. 14;
      Reserved_15_31         at 0 range 15 .. 31;
   end record;

   subtype SR_RESP_REC_Field is ESP32_C3.Bit;
   subtype SR_SLAVE_RW_Field is ESP32_C3.Bit;
   subtype SR_ARB_LOST_Field is ESP32_C3.Bit;
   subtype SR_BUS_BUSY_Field is ESP32_C3.Bit;
   subtype SR_SLAVE_ADDRESSED_Field is ESP32_C3.Bit;
   subtype SR_RXFIFO_CNT_Field is ESP32_C3.UInt6;
   subtype SR_STRETCH_CAUSE_Field is ESP32_C3.UInt2;
   subtype SR_TXFIFO_CNT_Field is ESP32_C3.UInt6;
   subtype SR_SCL_MAIN_STATE_LAST_Field is ESP32_C3.UInt3;
   subtype SR_SCL_STATE_LAST_Field is ESP32_C3.UInt3;

   --  I2C_SR_REG
   type SR_Register is record
      --  Read-only. reg_resp_rec
      RESP_REC            : SR_RESP_REC_Field;
      --  Read-only. reg_slave_rw
      SLAVE_RW            : SR_SLAVE_RW_Field;
      --  unspecified
      Reserved_2_2        : ESP32_C3.Bit;
      --  Read-only. reg_arb_lost
      ARB_LOST            : SR_ARB_LOST_Field;
      --  Read-only. reg_bus_busy
      BUS_BUSY            : SR_BUS_BUSY_Field;
      --  Read-only. reg_slave_addressed
      SLAVE_ADDRESSED     : SR_SLAVE_ADDRESSED_Field;
      --  unspecified
      Reserved_6_7        : ESP32_C3.UInt2;
      --  Read-only. reg_rxfifo_cnt
      RXFIFO_CNT          : SR_RXFIFO_CNT_Field;
      --  Read-only. reg_stretch_cause
      STRETCH_CAUSE       : SR_STRETCH_CAUSE_Field;
      --  unspecified
      Reserved_16_17      : ESP32_C3.UInt2;
      --  Read-only. reg_txfifo_cnt
      TXFIFO_CNT          : SR_TXFIFO_CNT_Field;
      --  Read-only. reg_scl_main_state_last
      SCL_MAIN_STATE_LAST : SR_SCL_MAIN_STATE_LAST_Field;
      --  unspecified
      Reserved_27_27      : ESP32_C3.Bit;
      --  Read-only. reg_scl_state_last
      SCL_STATE_LAST      : SR_SCL_STATE_LAST_Field;
      --  unspecified
      Reserved_31_31      : ESP32_C3.Bit;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SR_Register use record
      RESP_REC            at 0 range 0 .. 0;
      SLAVE_RW            at 0 range 1 .. 1;
      Reserved_2_2        at 0 range 2 .. 2;
      ARB_LOST            at 0 range 3 .. 3;
      BUS_BUSY            at 0 range 4 .. 4;
      SLAVE_ADDRESSED     at 0 range 5 .. 5;
      Reserved_6_7        at 0 range 6 .. 7;
      RXFIFO_CNT          at 0 range 8 .. 13;
      STRETCH_CAUSE       at 0 range 14 .. 15;
      Reserved_16_17      at 0 range 16 .. 17;
      TXFIFO_CNT          at 0 range 18 .. 23;
      SCL_MAIN_STATE_LAST at 0 range 24 .. 26;
      Reserved_27_27      at 0 range 27 .. 27;
      SCL_STATE_LAST      at 0 range 28 .. 30;
      Reserved_31_31      at 0 range 31 .. 31;
   end record;

   subtype TO_TIME_OUT_VALUE_Field is ESP32_C3.UInt5;
   subtype TO_TIME_OUT_EN_Field is ESP32_C3.Bit;

   --  I2C_TO_REG
   type TO_Register is record
      --  reg_time_out_value
      TIME_OUT_VALUE : TO_TIME_OUT_VALUE_Field := 16#10#;
      --  reg_time_out_en
      TIME_OUT_EN    : TO_TIME_OUT_EN_Field := 16#0#;
      --  unspecified
      Reserved_6_31  : ESP32_C3.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TO_Register use record
      TIME_OUT_VALUE at 0 range 0 .. 4;
      TIME_OUT_EN    at 0 range 5 .. 5;
      Reserved_6_31  at 0 range 6 .. 31;
   end record;

   subtype SLAVE_ADDR_SLAVE_ADDR_Field is ESP32_C3.UInt15;
   subtype SLAVE_ADDR_ADDR_10BIT_EN_Field is ESP32_C3.Bit;

   --  I2C_SLAVE_ADDR_REG
   type SLAVE_ADDR_Register is record
      --  reg_slave_addr
      SLAVE_ADDR     : SLAVE_ADDR_SLAVE_ADDR_Field := 16#0#;
      --  unspecified
      Reserved_15_30 : ESP32_C3.UInt16 := 16#0#;
      --  reg_addr_10bit_en
      ADDR_10BIT_EN  : SLAVE_ADDR_ADDR_10BIT_EN_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SLAVE_ADDR_Register use record
      SLAVE_ADDR     at 0 range 0 .. 14;
      Reserved_15_30 at 0 range 15 .. 30;
      ADDR_10BIT_EN  at 0 range 31 .. 31;
   end record;

   subtype FIFO_ST_RXFIFO_RADDR_Field is ESP32_C3.UInt5;
   subtype FIFO_ST_RXFIFO_WADDR_Field is ESP32_C3.UInt5;
   subtype FIFO_ST_TXFIFO_RADDR_Field is ESP32_C3.UInt5;
   subtype FIFO_ST_TXFIFO_WADDR_Field is ESP32_C3.UInt5;
   subtype FIFO_ST_SLAVE_RW_POINT_Field is ESP32_C3.Byte;

   --  I2C_FIFO_ST_REG
   type FIFO_ST_Register is record
      --  Read-only. reg_rxfifo_raddr
      RXFIFO_RADDR   : FIFO_ST_RXFIFO_RADDR_Field;
      --  Read-only. reg_rxfifo_waddr
      RXFIFO_WADDR   : FIFO_ST_RXFIFO_WADDR_Field;
      --  Read-only. reg_txfifo_raddr
      TXFIFO_RADDR   : FIFO_ST_TXFIFO_RADDR_Field;
      --  Read-only. reg_txfifo_waddr
      TXFIFO_WADDR   : FIFO_ST_TXFIFO_WADDR_Field;
      --  unspecified
      Reserved_20_21 : ESP32_C3.UInt2;
      --  Read-only. reg_slave_rw_point
      SLAVE_RW_POINT : FIFO_ST_SLAVE_RW_POINT_Field;
      --  unspecified
      Reserved_30_31 : ESP32_C3.UInt2;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FIFO_ST_Register use record
      RXFIFO_RADDR   at 0 range 0 .. 4;
      RXFIFO_WADDR   at 0 range 5 .. 9;
      TXFIFO_RADDR   at 0 range 10 .. 14;
      TXFIFO_WADDR   at 0 range 15 .. 19;
      Reserved_20_21 at 0 range 20 .. 21;
      SLAVE_RW_POINT at 0 range 22 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   subtype FIFO_CONF_RXFIFO_WM_THRHD_Field is ESP32_C3.UInt5;
   subtype FIFO_CONF_TXFIFO_WM_THRHD_Field is ESP32_C3.UInt5;
   subtype FIFO_CONF_NONFIFO_EN_Field is ESP32_C3.Bit;
   subtype FIFO_CONF_FIFO_ADDR_CFG_EN_Field is ESP32_C3.Bit;
   subtype FIFO_CONF_RX_FIFO_RST_Field is ESP32_C3.Bit;
   subtype FIFO_CONF_TX_FIFO_RST_Field is ESP32_C3.Bit;
   subtype FIFO_CONF_FIFO_PRT_EN_Field is ESP32_C3.Bit;

   --  I2C_FIFO_CONF_REG
   type FIFO_CONF_Register is record
      --  reg_rxfifo_wm_thrhd
      RXFIFO_WM_THRHD  : FIFO_CONF_RXFIFO_WM_THRHD_Field := 16#B#;
      --  reg_txfifo_wm_thrhd
      TXFIFO_WM_THRHD  : FIFO_CONF_TXFIFO_WM_THRHD_Field := 16#4#;
      --  reg_nonfifo_en
      NONFIFO_EN       : FIFO_CONF_NONFIFO_EN_Field := 16#0#;
      --  reg_fifo_addr_cfg_en
      FIFO_ADDR_CFG_EN : FIFO_CONF_FIFO_ADDR_CFG_EN_Field := 16#0#;
      --  reg_rx_fifo_rst
      RX_FIFO_RST      : FIFO_CONF_RX_FIFO_RST_Field := 16#0#;
      --  reg_tx_fifo_rst
      TX_FIFO_RST      : FIFO_CONF_TX_FIFO_RST_Field := 16#0#;
      --  reg_fifo_prt_en
      FIFO_PRT_EN      : FIFO_CONF_FIFO_PRT_EN_Field := 16#1#;
      --  unspecified
      Reserved_15_31   : ESP32_C3.UInt17 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FIFO_CONF_Register use record
      RXFIFO_WM_THRHD  at 0 range 0 .. 4;
      TXFIFO_WM_THRHD  at 0 range 5 .. 9;
      NONFIFO_EN       at 0 range 10 .. 10;
      FIFO_ADDR_CFG_EN at 0 range 11 .. 11;
      RX_FIFO_RST      at 0 range 12 .. 12;
      TX_FIFO_RST      at 0 range 13 .. 13;
      FIFO_PRT_EN      at 0 range 14 .. 14;
      Reserved_15_31   at 0 range 15 .. 31;
   end record;

   subtype DATA_FIFO_RDATA_Field is ESP32_C3.Byte;

   --  I2C_FIFO_DATA_REG
   type DATA_Register is record
      --  reg_fifo_rdata
      FIFO_RDATA    : DATA_FIFO_RDATA_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : ESP32_C3.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DATA_Register use record
      FIFO_RDATA    at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype INT_RAW_RXFIFO_WM_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_TXFIFO_WM_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_RXFIFO_OVF_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_END_DETECT_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_BYTE_TRANS_DONE_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_ARBITRATION_LOST_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_MST_TXFIFO_UDF_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_TRANS_COMPLETE_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_TIME_OUT_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_TRANS_START_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_NACK_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_TXFIFO_OVF_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_RXFIFO_UDF_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_SCL_ST_TO_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_SCL_MAIN_ST_TO_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_DET_START_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_SLAVE_STRETCH_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_GENERAL_CALL_INT_RAW_Field is ESP32_C3.Bit;

   --  I2C_INT_RAW_REG
   type INT_RAW_Register is record
      --  Read-only. reg_rxfifo_wm_int_raw
      RXFIFO_WM_INT_RAW        : INT_RAW_RXFIFO_WM_INT_RAW_Field;
      --  Read-only. reg_txfifo_wm_int_raw
      TXFIFO_WM_INT_RAW        : INT_RAW_TXFIFO_WM_INT_RAW_Field;
      --  Read-only. reg_rxfifo_ovf_int_raw
      RXFIFO_OVF_INT_RAW       : INT_RAW_RXFIFO_OVF_INT_RAW_Field;
      --  Read-only. reg_end_detect_int_raw
      END_DETECT_INT_RAW       : INT_RAW_END_DETECT_INT_RAW_Field;
      --  Read-only. reg_byte_trans_done_int_raw
      BYTE_TRANS_DONE_INT_RAW  : INT_RAW_BYTE_TRANS_DONE_INT_RAW_Field;
      --  Read-only. reg_arbitration_lost_int_raw
      ARBITRATION_LOST_INT_RAW : INT_RAW_ARBITRATION_LOST_INT_RAW_Field;
      --  Read-only. reg_mst_txfifo_udf_int_raw
      MST_TXFIFO_UDF_INT_RAW   : INT_RAW_MST_TXFIFO_UDF_INT_RAW_Field;
      --  Read-only. reg_trans_complete_int_raw
      TRANS_COMPLETE_INT_RAW   : INT_RAW_TRANS_COMPLETE_INT_RAW_Field;
      --  Read-only. reg_time_out_int_raw
      TIME_OUT_INT_RAW         : INT_RAW_TIME_OUT_INT_RAW_Field;
      --  Read-only. reg_trans_start_int_raw
      TRANS_START_INT_RAW      : INT_RAW_TRANS_START_INT_RAW_Field;
      --  Read-only. reg_nack_int_raw
      NACK_INT_RAW             : INT_RAW_NACK_INT_RAW_Field;
      --  Read-only. reg_txfifo_ovf_int_raw
      TXFIFO_OVF_INT_RAW       : INT_RAW_TXFIFO_OVF_INT_RAW_Field;
      --  Read-only. reg_rxfifo_udf_int_raw
      RXFIFO_UDF_INT_RAW       : INT_RAW_RXFIFO_UDF_INT_RAW_Field;
      --  Read-only. reg_scl_st_to_int_raw
      SCL_ST_TO_INT_RAW        : INT_RAW_SCL_ST_TO_INT_RAW_Field;
      --  Read-only. reg_scl_main_st_to_int_raw
      SCL_MAIN_ST_TO_INT_RAW   : INT_RAW_SCL_MAIN_ST_TO_INT_RAW_Field;
      --  Read-only. reg_det_start_int_raw
      DET_START_INT_RAW        : INT_RAW_DET_START_INT_RAW_Field;
      --  Read-only. reg_slave_stretch_int_raw
      SLAVE_STRETCH_INT_RAW    : INT_RAW_SLAVE_STRETCH_INT_RAW_Field;
      --  Read-only. reg_general_call_int_raw
      GENERAL_CALL_INT_RAW     : INT_RAW_GENERAL_CALL_INT_RAW_Field;
      --  unspecified
      Reserved_18_31           : ESP32_C3.UInt14;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_RAW_Register use record
      RXFIFO_WM_INT_RAW        at 0 range 0 .. 0;
      TXFIFO_WM_INT_RAW        at 0 range 1 .. 1;
      RXFIFO_OVF_INT_RAW       at 0 range 2 .. 2;
      END_DETECT_INT_RAW       at 0 range 3 .. 3;
      BYTE_TRANS_DONE_INT_RAW  at 0 range 4 .. 4;
      ARBITRATION_LOST_INT_RAW at 0 range 5 .. 5;
      MST_TXFIFO_UDF_INT_RAW   at 0 range 6 .. 6;
      TRANS_COMPLETE_INT_RAW   at 0 range 7 .. 7;
      TIME_OUT_INT_RAW         at 0 range 8 .. 8;
      TRANS_START_INT_RAW      at 0 range 9 .. 9;
      NACK_INT_RAW             at 0 range 10 .. 10;
      TXFIFO_OVF_INT_RAW       at 0 range 11 .. 11;
      RXFIFO_UDF_INT_RAW       at 0 range 12 .. 12;
      SCL_ST_TO_INT_RAW        at 0 range 13 .. 13;
      SCL_MAIN_ST_TO_INT_RAW   at 0 range 14 .. 14;
      DET_START_INT_RAW        at 0 range 15 .. 15;
      SLAVE_STRETCH_INT_RAW    at 0 range 16 .. 16;
      GENERAL_CALL_INT_RAW     at 0 range 17 .. 17;
      Reserved_18_31           at 0 range 18 .. 31;
   end record;

   subtype INT_CLR_RXFIFO_WM_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_TXFIFO_WM_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_RXFIFO_OVF_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_END_DETECT_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_BYTE_TRANS_DONE_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_ARBITRATION_LOST_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_MST_TXFIFO_UDF_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_TRANS_COMPLETE_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_TIME_OUT_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_TRANS_START_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_NACK_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_TXFIFO_OVF_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_RXFIFO_UDF_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_SCL_ST_TO_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_SCL_MAIN_ST_TO_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_DET_START_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_SLAVE_STRETCH_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_GENERAL_CALL_INT_CLR_Field is ESP32_C3.Bit;

   --  I2C_INT_CLR_REG
   type INT_CLR_Register is record
      --  Write-only. reg_rxfifo_wm_int_clr
      RXFIFO_WM_INT_CLR        : INT_CLR_RXFIFO_WM_INT_CLR_Field := 16#0#;
      --  Write-only. reg_txfifo_wm_int_clr
      TXFIFO_WM_INT_CLR        : INT_CLR_TXFIFO_WM_INT_CLR_Field := 16#0#;
      --  Write-only. reg_rxfifo_ovf_int_clr
      RXFIFO_OVF_INT_CLR       : INT_CLR_RXFIFO_OVF_INT_CLR_Field := 16#0#;
      --  Write-only. reg_end_detect_int_clr
      END_DETECT_INT_CLR       : INT_CLR_END_DETECT_INT_CLR_Field := 16#0#;
      --  Write-only. reg_byte_trans_done_int_clr
      BYTE_TRANS_DONE_INT_CLR  : INT_CLR_BYTE_TRANS_DONE_INT_CLR_Field :=
                                  16#0#;
      --  Write-only. reg_arbitration_lost_int_clr
      ARBITRATION_LOST_INT_CLR : INT_CLR_ARBITRATION_LOST_INT_CLR_Field :=
                                  16#0#;
      --  Write-only. reg_mst_txfifo_udf_int_clr
      MST_TXFIFO_UDF_INT_CLR   : INT_CLR_MST_TXFIFO_UDF_INT_CLR_Field :=
                                  16#0#;
      --  Write-only. reg_trans_complete_int_clr
      TRANS_COMPLETE_INT_CLR   : INT_CLR_TRANS_COMPLETE_INT_CLR_Field :=
                                  16#0#;
      --  Write-only. reg_time_out_int_clr
      TIME_OUT_INT_CLR         : INT_CLR_TIME_OUT_INT_CLR_Field := 16#0#;
      --  Write-only. reg_trans_start_int_clr
      TRANS_START_INT_CLR      : INT_CLR_TRANS_START_INT_CLR_Field := 16#0#;
      --  Write-only. reg_nack_int_clr
      NACK_INT_CLR             : INT_CLR_NACK_INT_CLR_Field := 16#0#;
      --  Write-only. reg_txfifo_ovf_int_clr
      TXFIFO_OVF_INT_CLR       : INT_CLR_TXFIFO_OVF_INT_CLR_Field := 16#0#;
      --  Write-only. reg_rxfifo_udf_int_clr
      RXFIFO_UDF_INT_CLR       : INT_CLR_RXFIFO_UDF_INT_CLR_Field := 16#0#;
      --  Write-only. reg_scl_st_to_int_clr
      SCL_ST_TO_INT_CLR        : INT_CLR_SCL_ST_TO_INT_CLR_Field := 16#0#;
      --  Write-only. reg_scl_main_st_to_int_clr
      SCL_MAIN_ST_TO_INT_CLR   : INT_CLR_SCL_MAIN_ST_TO_INT_CLR_Field :=
                                  16#0#;
      --  Write-only. reg_det_start_int_clr
      DET_START_INT_CLR        : INT_CLR_DET_START_INT_CLR_Field := 16#0#;
      --  Write-only. reg_slave_stretch_int_clr
      SLAVE_STRETCH_INT_CLR    : INT_CLR_SLAVE_STRETCH_INT_CLR_Field := 16#0#;
      --  Write-only. reg_general_call_int_clr
      GENERAL_CALL_INT_CLR     : INT_CLR_GENERAL_CALL_INT_CLR_Field := 16#0#;
      --  unspecified
      Reserved_18_31           : ESP32_C3.UInt14 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_CLR_Register use record
      RXFIFO_WM_INT_CLR        at 0 range 0 .. 0;
      TXFIFO_WM_INT_CLR        at 0 range 1 .. 1;
      RXFIFO_OVF_INT_CLR       at 0 range 2 .. 2;
      END_DETECT_INT_CLR       at 0 range 3 .. 3;
      BYTE_TRANS_DONE_INT_CLR  at 0 range 4 .. 4;
      ARBITRATION_LOST_INT_CLR at 0 range 5 .. 5;
      MST_TXFIFO_UDF_INT_CLR   at 0 range 6 .. 6;
      TRANS_COMPLETE_INT_CLR   at 0 range 7 .. 7;
      TIME_OUT_INT_CLR         at 0 range 8 .. 8;
      TRANS_START_INT_CLR      at 0 range 9 .. 9;
      NACK_INT_CLR             at 0 range 10 .. 10;
      TXFIFO_OVF_INT_CLR       at 0 range 11 .. 11;
      RXFIFO_UDF_INT_CLR       at 0 range 12 .. 12;
      SCL_ST_TO_INT_CLR        at 0 range 13 .. 13;
      SCL_MAIN_ST_TO_INT_CLR   at 0 range 14 .. 14;
      DET_START_INT_CLR        at 0 range 15 .. 15;
      SLAVE_STRETCH_INT_CLR    at 0 range 16 .. 16;
      GENERAL_CALL_INT_CLR     at 0 range 17 .. 17;
      Reserved_18_31           at 0 range 18 .. 31;
   end record;

   subtype INT_ENA_RXFIFO_WM_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_TXFIFO_WM_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_RXFIFO_OVF_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_END_DETECT_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_BYTE_TRANS_DONE_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_ARBITRATION_LOST_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_MST_TXFIFO_UDF_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_TRANS_COMPLETE_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_TIME_OUT_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_TRANS_START_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_NACK_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_TXFIFO_OVF_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_RXFIFO_UDF_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_SCL_ST_TO_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_SCL_MAIN_ST_TO_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_DET_START_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_SLAVE_STRETCH_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_GENERAL_CALL_INT_ENA_Field is ESP32_C3.Bit;

   --  I2C_INT_ENA_REG
   type INT_ENA_Register is record
      --  reg_rxfifo_wm_int_ena
      RXFIFO_WM_INT_ENA        : INT_ENA_RXFIFO_WM_INT_ENA_Field := 16#0#;
      --  reg_txfifo_wm_int_ena
      TXFIFO_WM_INT_ENA        : INT_ENA_TXFIFO_WM_INT_ENA_Field := 16#0#;
      --  reg_rxfifo_ovf_int_ena
      RXFIFO_OVF_INT_ENA       : INT_ENA_RXFIFO_OVF_INT_ENA_Field := 16#0#;
      --  reg_end_detect_int_ena
      END_DETECT_INT_ENA       : INT_ENA_END_DETECT_INT_ENA_Field := 16#0#;
      --  reg_byte_trans_done_int_ena
      BYTE_TRANS_DONE_INT_ENA  : INT_ENA_BYTE_TRANS_DONE_INT_ENA_Field :=
                                  16#0#;
      --  reg_arbitration_lost_int_ena
      ARBITRATION_LOST_INT_ENA : INT_ENA_ARBITRATION_LOST_INT_ENA_Field :=
                                  16#0#;
      --  reg_mst_txfifo_udf_int_ena
      MST_TXFIFO_UDF_INT_ENA   : INT_ENA_MST_TXFIFO_UDF_INT_ENA_Field :=
                                  16#0#;
      --  reg_trans_complete_int_ena
      TRANS_COMPLETE_INT_ENA   : INT_ENA_TRANS_COMPLETE_INT_ENA_Field :=
                                  16#0#;
      --  reg_time_out_int_ena
      TIME_OUT_INT_ENA         : INT_ENA_TIME_OUT_INT_ENA_Field := 16#0#;
      --  reg_trans_start_int_ena
      TRANS_START_INT_ENA      : INT_ENA_TRANS_START_INT_ENA_Field := 16#0#;
      --  reg_nack_int_ena
      NACK_INT_ENA             : INT_ENA_NACK_INT_ENA_Field := 16#0#;
      --  reg_txfifo_ovf_int_ena
      TXFIFO_OVF_INT_ENA       : INT_ENA_TXFIFO_OVF_INT_ENA_Field := 16#0#;
      --  reg_rxfifo_udf_int_ena
      RXFIFO_UDF_INT_ENA       : INT_ENA_RXFIFO_UDF_INT_ENA_Field := 16#0#;
      --  reg_scl_st_to_int_ena
      SCL_ST_TO_INT_ENA        : INT_ENA_SCL_ST_TO_INT_ENA_Field := 16#0#;
      --  reg_scl_main_st_to_int_ena
      SCL_MAIN_ST_TO_INT_ENA   : INT_ENA_SCL_MAIN_ST_TO_INT_ENA_Field :=
                                  16#0#;
      --  reg_det_start_int_ena
      DET_START_INT_ENA        : INT_ENA_DET_START_INT_ENA_Field := 16#0#;
      --  reg_slave_stretch_int_ena
      SLAVE_STRETCH_INT_ENA    : INT_ENA_SLAVE_STRETCH_INT_ENA_Field := 16#0#;
      --  reg_general_call_int_ena
      GENERAL_CALL_INT_ENA     : INT_ENA_GENERAL_CALL_INT_ENA_Field := 16#0#;
      --  unspecified
      Reserved_18_31           : ESP32_C3.UInt14 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_ENA_Register use record
      RXFIFO_WM_INT_ENA        at 0 range 0 .. 0;
      TXFIFO_WM_INT_ENA        at 0 range 1 .. 1;
      RXFIFO_OVF_INT_ENA       at 0 range 2 .. 2;
      END_DETECT_INT_ENA       at 0 range 3 .. 3;
      BYTE_TRANS_DONE_INT_ENA  at 0 range 4 .. 4;
      ARBITRATION_LOST_INT_ENA at 0 range 5 .. 5;
      MST_TXFIFO_UDF_INT_ENA   at 0 range 6 .. 6;
      TRANS_COMPLETE_INT_ENA   at 0 range 7 .. 7;
      TIME_OUT_INT_ENA         at 0 range 8 .. 8;
      TRANS_START_INT_ENA      at 0 range 9 .. 9;
      NACK_INT_ENA             at 0 range 10 .. 10;
      TXFIFO_OVF_INT_ENA       at 0 range 11 .. 11;
      RXFIFO_UDF_INT_ENA       at 0 range 12 .. 12;
      SCL_ST_TO_INT_ENA        at 0 range 13 .. 13;
      SCL_MAIN_ST_TO_INT_ENA   at 0 range 14 .. 14;
      DET_START_INT_ENA        at 0 range 15 .. 15;
      SLAVE_STRETCH_INT_ENA    at 0 range 16 .. 16;
      GENERAL_CALL_INT_ENA     at 0 range 17 .. 17;
      Reserved_18_31           at 0 range 18 .. 31;
   end record;

   subtype INT_STATUS_RXFIFO_WM_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_STATUS_TXFIFO_WM_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_STATUS_RXFIFO_OVF_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_STATUS_END_DETECT_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_STATUS_BYTE_TRANS_DONE_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_STATUS_ARBITRATION_LOST_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_STATUS_MST_TXFIFO_UDF_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_STATUS_TRANS_COMPLETE_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_STATUS_TIME_OUT_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_STATUS_TRANS_START_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_STATUS_NACK_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_STATUS_TXFIFO_OVF_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_STATUS_RXFIFO_UDF_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_STATUS_SCL_ST_TO_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_STATUS_SCL_MAIN_ST_TO_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_STATUS_DET_START_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_STATUS_SLAVE_STRETCH_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_STATUS_GENERAL_CALL_INT_ST_Field is ESP32_C3.Bit;

   --  I2C_INT_STATUS_REG
   type INT_STATUS_Register is record
      --  Read-only. reg_rxfifo_wm_int_st
      RXFIFO_WM_INT_ST        : INT_STATUS_RXFIFO_WM_INT_ST_Field;
      --  Read-only. reg_txfifo_wm_int_st
      TXFIFO_WM_INT_ST        : INT_STATUS_TXFIFO_WM_INT_ST_Field;
      --  Read-only. reg_rxfifo_ovf_int_st
      RXFIFO_OVF_INT_ST       : INT_STATUS_RXFIFO_OVF_INT_ST_Field;
      --  Read-only. reg_end_detect_int_st
      END_DETECT_INT_ST       : INT_STATUS_END_DETECT_INT_ST_Field;
      --  Read-only. reg_byte_trans_done_int_st
      BYTE_TRANS_DONE_INT_ST  : INT_STATUS_BYTE_TRANS_DONE_INT_ST_Field;
      --  Read-only. reg_arbitration_lost_int_st
      ARBITRATION_LOST_INT_ST : INT_STATUS_ARBITRATION_LOST_INT_ST_Field;
      --  Read-only. reg_mst_txfifo_udf_int_st
      MST_TXFIFO_UDF_INT_ST   : INT_STATUS_MST_TXFIFO_UDF_INT_ST_Field;
      --  Read-only. reg_trans_complete_int_st
      TRANS_COMPLETE_INT_ST   : INT_STATUS_TRANS_COMPLETE_INT_ST_Field;
      --  Read-only. reg_time_out_int_st
      TIME_OUT_INT_ST         : INT_STATUS_TIME_OUT_INT_ST_Field;
      --  Read-only. reg_trans_start_int_st
      TRANS_START_INT_ST      : INT_STATUS_TRANS_START_INT_ST_Field;
      --  Read-only. reg_nack_int_st
      NACK_INT_ST             : INT_STATUS_NACK_INT_ST_Field;
      --  Read-only. reg_txfifo_ovf_int_st
      TXFIFO_OVF_INT_ST       : INT_STATUS_TXFIFO_OVF_INT_ST_Field;
      --  Read-only. reg_rxfifo_udf_int_st
      RXFIFO_UDF_INT_ST       : INT_STATUS_RXFIFO_UDF_INT_ST_Field;
      --  Read-only. reg_scl_st_to_int_st
      SCL_ST_TO_INT_ST        : INT_STATUS_SCL_ST_TO_INT_ST_Field;
      --  Read-only. reg_scl_main_st_to_int_st
      SCL_MAIN_ST_TO_INT_ST   : INT_STATUS_SCL_MAIN_ST_TO_INT_ST_Field;
      --  Read-only. reg_det_start_int_st
      DET_START_INT_ST        : INT_STATUS_DET_START_INT_ST_Field;
      --  Read-only. reg_slave_stretch_int_st
      SLAVE_STRETCH_INT_ST    : INT_STATUS_SLAVE_STRETCH_INT_ST_Field;
      --  Read-only. reg_general_call_int_st
      GENERAL_CALL_INT_ST     : INT_STATUS_GENERAL_CALL_INT_ST_Field;
      --  unspecified
      Reserved_18_31          : ESP32_C3.UInt14;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_STATUS_Register use record
      RXFIFO_WM_INT_ST        at 0 range 0 .. 0;
      TXFIFO_WM_INT_ST        at 0 range 1 .. 1;
      RXFIFO_OVF_INT_ST       at 0 range 2 .. 2;
      END_DETECT_INT_ST       at 0 range 3 .. 3;
      BYTE_TRANS_DONE_INT_ST  at 0 range 4 .. 4;
      ARBITRATION_LOST_INT_ST at 0 range 5 .. 5;
      MST_TXFIFO_UDF_INT_ST   at 0 range 6 .. 6;
      TRANS_COMPLETE_INT_ST   at 0 range 7 .. 7;
      TIME_OUT_INT_ST         at 0 range 8 .. 8;
      TRANS_START_INT_ST      at 0 range 9 .. 9;
      NACK_INT_ST             at 0 range 10 .. 10;
      TXFIFO_OVF_INT_ST       at 0 range 11 .. 11;
      RXFIFO_UDF_INT_ST       at 0 range 12 .. 12;
      SCL_ST_TO_INT_ST        at 0 range 13 .. 13;
      SCL_MAIN_ST_TO_INT_ST   at 0 range 14 .. 14;
      DET_START_INT_ST        at 0 range 15 .. 15;
      SLAVE_STRETCH_INT_ST    at 0 range 16 .. 16;
      GENERAL_CALL_INT_ST     at 0 range 17 .. 17;
      Reserved_18_31          at 0 range 18 .. 31;
   end record;

   subtype SDA_HOLD_TIME_Field is ESP32_C3.UInt9;

   --  I2C_SDA_HOLD_REG
   type SDA_HOLD_Register is record
      --  reg_sda_hold_time
      TIME          : SDA_HOLD_TIME_Field := 16#0#;
      --  unspecified
      Reserved_9_31 : ESP32_C3.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDA_HOLD_Register use record
      TIME          at 0 range 0 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   subtype SDA_SAMPLE_TIME_Field is ESP32_C3.UInt9;

   --  I2C_SDA_SAMPLE_REG
   type SDA_SAMPLE_Register is record
      --  reg_sda_sample_time
      TIME          : SDA_SAMPLE_TIME_Field := 16#0#;
      --  unspecified
      Reserved_9_31 : ESP32_C3.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDA_SAMPLE_Register use record
      TIME          at 0 range 0 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   subtype SCL_HIGH_PERIOD_SCL_HIGH_PERIOD_Field is ESP32_C3.UInt9;
   subtype SCL_HIGH_PERIOD_SCL_WAIT_HIGH_PERIOD_Field is ESP32_C3.UInt7;

   --  I2C_SCL_HIGH_PERIOD_REG
   type SCL_HIGH_PERIOD_Register is record
      --  reg_scl_high_period
      SCL_HIGH_PERIOD      : SCL_HIGH_PERIOD_SCL_HIGH_PERIOD_Field := 16#0#;
      --  reg_scl_wait_high_period
      SCL_WAIT_HIGH_PERIOD : SCL_HIGH_PERIOD_SCL_WAIT_HIGH_PERIOD_Field :=
                              16#0#;
      --  unspecified
      Reserved_16_31       : ESP32_C3.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCL_HIGH_PERIOD_Register use record
      SCL_HIGH_PERIOD      at 0 range 0 .. 8;
      SCL_WAIT_HIGH_PERIOD at 0 range 9 .. 15;
      Reserved_16_31       at 0 range 16 .. 31;
   end record;

   subtype SCL_START_HOLD_TIME_Field is ESP32_C3.UInt9;

   --  I2C_SCL_START_HOLD_REG
   type SCL_START_HOLD_Register is record
      --  reg_scl_start_hold_time
      TIME          : SCL_START_HOLD_TIME_Field := 16#8#;
      --  unspecified
      Reserved_9_31 : ESP32_C3.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCL_START_HOLD_Register use record
      TIME          at 0 range 0 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   subtype SCL_RSTART_SETUP_TIME_Field is ESP32_C3.UInt9;

   --  I2C_SCL_RSTART_SETUP_REG
   type SCL_RSTART_SETUP_Register is record
      --  reg_scl_rstart_setup_time
      TIME          : SCL_RSTART_SETUP_TIME_Field := 16#8#;
      --  unspecified
      Reserved_9_31 : ESP32_C3.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCL_RSTART_SETUP_Register use record
      TIME          at 0 range 0 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   subtype SCL_STOP_HOLD_TIME_Field is ESP32_C3.UInt9;

   --  I2C_SCL_STOP_HOLD_REG
   type SCL_STOP_HOLD_Register is record
      --  reg_scl_stop_hold_time
      TIME          : SCL_STOP_HOLD_TIME_Field := 16#8#;
      --  unspecified
      Reserved_9_31 : ESP32_C3.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCL_STOP_HOLD_Register use record
      TIME          at 0 range 0 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   subtype SCL_STOP_SETUP_TIME_Field is ESP32_C3.UInt9;

   --  I2C_SCL_STOP_SETUP_REG
   type SCL_STOP_SETUP_Register is record
      --  reg_scl_stop_setup_time
      TIME          : SCL_STOP_SETUP_TIME_Field := 16#8#;
      --  unspecified
      Reserved_9_31 : ESP32_C3.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCL_STOP_SETUP_Register use record
      TIME          at 0 range 0 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   subtype FILTER_CFG_SCL_FILTER_THRES_Field is ESP32_C3.UInt4;
   subtype FILTER_CFG_SDA_FILTER_THRES_Field is ESP32_C3.UInt4;
   subtype FILTER_CFG_SCL_FILTER_EN_Field is ESP32_C3.Bit;
   subtype FILTER_CFG_SDA_FILTER_EN_Field is ESP32_C3.Bit;

   --  I2C_FILTER_CFG_REG
   type FILTER_CFG_Register is record
      --  reg_scl_filter_thres
      SCL_FILTER_THRES : FILTER_CFG_SCL_FILTER_THRES_Field := 16#0#;
      --  reg_sda_filter_thres
      SDA_FILTER_THRES : FILTER_CFG_SDA_FILTER_THRES_Field := 16#0#;
      --  reg_scl_filter_en
      SCL_FILTER_EN    : FILTER_CFG_SCL_FILTER_EN_Field := 16#1#;
      --  reg_sda_filter_en
      SDA_FILTER_EN    : FILTER_CFG_SDA_FILTER_EN_Field := 16#1#;
      --  unspecified
      Reserved_10_31   : ESP32_C3.UInt22 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FILTER_CFG_Register use record
      SCL_FILTER_THRES at 0 range 0 .. 3;
      SDA_FILTER_THRES at 0 range 4 .. 7;
      SCL_FILTER_EN    at 0 range 8 .. 8;
      SDA_FILTER_EN    at 0 range 9 .. 9;
      Reserved_10_31   at 0 range 10 .. 31;
   end record;

   subtype CLK_CONF_SCLK_DIV_NUM_Field is ESP32_C3.Byte;
   subtype CLK_CONF_SCLK_DIV_A_Field is ESP32_C3.UInt6;
   subtype CLK_CONF_SCLK_DIV_B_Field is ESP32_C3.UInt6;
   subtype CLK_CONF_SCLK_SEL_Field is ESP32_C3.Bit;
   subtype CLK_CONF_SCLK_ACTIVE_Field is ESP32_C3.Bit;

   --  I2C_CLK_CONF_REG
   type CLK_CONF_Register is record
      --  reg_sclk_div_num
      SCLK_DIV_NUM   : CLK_CONF_SCLK_DIV_NUM_Field := 16#0#;
      --  reg_sclk_div_a
      SCLK_DIV_A     : CLK_CONF_SCLK_DIV_A_Field := 16#0#;
      --  reg_sclk_div_b
      SCLK_DIV_B     : CLK_CONF_SCLK_DIV_B_Field := 16#0#;
      --  reg_sclk_sel
      SCLK_SEL       : CLK_CONF_SCLK_SEL_Field := 16#0#;
      --  reg_sclk_active
      SCLK_ACTIVE    : CLK_CONF_SCLK_ACTIVE_Field := 16#1#;
      --  unspecified
      Reserved_22_31 : ESP32_C3.UInt10 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CLK_CONF_Register use record
      SCLK_DIV_NUM   at 0 range 0 .. 7;
      SCLK_DIV_A     at 0 range 8 .. 13;
      SCLK_DIV_B     at 0 range 14 .. 19;
      SCLK_SEL       at 0 range 20 .. 20;
      SCLK_ACTIVE    at 0 range 21 .. 21;
      Reserved_22_31 at 0 range 22 .. 31;
   end record;

   subtype COMD_COMMAND_Field is ESP32_C3.UInt14;
   subtype COMD_COMMAND_DONE_Field is ESP32_C3.Bit;

   --  I2C_COMD%s_REG
   type COMD_Register is record
      --  reg_command
      COMMAND        : COMD_COMMAND_Field := 16#0#;
      --  unspecified
      Reserved_14_30 : ESP32_C3.UInt17 := 16#0#;
      --  reg_command_done
      COMMAND_DONE   : COMD_COMMAND_DONE_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMD_Register use record
      COMMAND        at 0 range 0 .. 13;
      Reserved_14_30 at 0 range 14 .. 30;
      COMMAND_DONE   at 0 range 31 .. 31;
   end record;

   --  I2C_COMD%s_REG
   type COMD_Registers is array (0 .. 7) of COMD_Register;

   subtype SCL_ST_TIME_OUT_SCL_ST_TO_I2C_Field is ESP32_C3.UInt5;

   --  I2C_SCL_ST_TIME_OUT_REG
   type SCL_ST_TIME_OUT_Register is record
      --  reg_scl_st_to_regno more than 23
      SCL_ST_TO_I2C : SCL_ST_TIME_OUT_SCL_ST_TO_I2C_Field := 16#10#;
      --  unspecified
      Reserved_5_31 : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCL_ST_TIME_OUT_Register use record
      SCL_ST_TO_I2C at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype SCL_MAIN_ST_TIME_OUT_SCL_MAIN_ST_TO_I2C_Field is ESP32_C3.UInt5;

   --  I2C_SCL_MAIN_ST_TIME_OUT_REG
   type SCL_MAIN_ST_TIME_OUT_Register is record
      --  reg_scl_main_st_to_regno more than 23
      SCL_MAIN_ST_TO_I2C : SCL_MAIN_ST_TIME_OUT_SCL_MAIN_ST_TO_I2C_Field :=
                            16#10#;
      --  unspecified
      Reserved_5_31      : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCL_MAIN_ST_TIME_OUT_Register use record
      SCL_MAIN_ST_TO_I2C at 0 range 0 .. 4;
      Reserved_5_31      at 0 range 5 .. 31;
   end record;

   subtype SCL_SP_CONF_SCL_RST_SLV_EN_Field is ESP32_C3.Bit;
   subtype SCL_SP_CONF_SCL_RST_SLV_NUM_Field is ESP32_C3.UInt5;
   subtype SCL_SP_CONF_SCL_PD_EN_Field is ESP32_C3.Bit;
   subtype SCL_SP_CONF_SDA_PD_EN_Field is ESP32_C3.Bit;

   --  I2C_SCL_SP_CONF_REG
   type SCL_SP_CONF_Register is record
      --  reg_scl_rst_slv_en
      SCL_RST_SLV_EN  : SCL_SP_CONF_SCL_RST_SLV_EN_Field := 16#0#;
      --  reg_scl_rst_slv_num
      SCL_RST_SLV_NUM : SCL_SP_CONF_SCL_RST_SLV_NUM_Field := 16#0#;
      --  reg_scl_pd_en
      SCL_PD_EN       : SCL_SP_CONF_SCL_PD_EN_Field := 16#0#;
      --  reg_sda_pd_en
      SDA_PD_EN       : SCL_SP_CONF_SDA_PD_EN_Field := 16#0#;
      --  unspecified
      Reserved_8_31   : ESP32_C3.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCL_SP_CONF_Register use record
      SCL_RST_SLV_EN  at 0 range 0 .. 0;
      SCL_RST_SLV_NUM at 0 range 1 .. 5;
      SCL_PD_EN       at 0 range 6 .. 6;
      SDA_PD_EN       at 0 range 7 .. 7;
      Reserved_8_31   at 0 range 8 .. 31;
   end record;

   subtype SCL_STRETCH_CONF_STRETCH_PROTECT_NUM_Field is ESP32_C3.UInt10;
   subtype SCL_STRETCH_CONF_SLAVE_SCL_STRETCH_EN_Field is ESP32_C3.Bit;
   subtype SCL_STRETCH_CONF_SLAVE_SCL_STRETCH_CLR_Field is ESP32_C3.Bit;
   subtype SCL_STRETCH_CONF_SLAVE_BYTE_ACK_CTL_EN_Field is ESP32_C3.Bit;
   subtype SCL_STRETCH_CONF_SLAVE_BYTE_ACK_LVL_Field is ESP32_C3.Bit;

   --  I2C_SCL_STRETCH_CONF_REG
   type SCL_STRETCH_CONF_Register is record
      --  reg_stretch_protect_num
      STRETCH_PROTECT_NUM   : SCL_STRETCH_CONF_STRETCH_PROTECT_NUM_Field :=
                               16#0#;
      --  reg_slave_scl_stretch_en
      SLAVE_SCL_STRETCH_EN  : SCL_STRETCH_CONF_SLAVE_SCL_STRETCH_EN_Field :=
                               16#0#;
      --  Write-only. reg_slave_scl_stretch_clr
      SLAVE_SCL_STRETCH_CLR : SCL_STRETCH_CONF_SLAVE_SCL_STRETCH_CLR_Field :=
                               16#0#;
      --  reg_slave_byte_ack_ctl_en
      SLAVE_BYTE_ACK_CTL_EN : SCL_STRETCH_CONF_SLAVE_BYTE_ACK_CTL_EN_Field :=
                               16#0#;
      --  reg_slave_byte_ack_lvl
      SLAVE_BYTE_ACK_LVL    : SCL_STRETCH_CONF_SLAVE_BYTE_ACK_LVL_Field :=
                               16#0#;
      --  unspecified
      Reserved_14_31        : ESP32_C3.UInt18 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCL_STRETCH_CONF_Register use record
      STRETCH_PROTECT_NUM   at 0 range 0 .. 9;
      SLAVE_SCL_STRETCH_EN  at 0 range 10 .. 10;
      SLAVE_SCL_STRETCH_CLR at 0 range 11 .. 11;
      SLAVE_BYTE_ACK_CTL_EN at 0 range 12 .. 12;
      SLAVE_BYTE_ACK_LVL    at 0 range 13 .. 13;
      Reserved_14_31        at 0 range 14 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  I2C (Inter-Integrated Circuit) Controller 0
   type I2C0_Peripheral is record
      --  I2C_SCL_LOW_PERIOD_REG
      SCL_LOW_PERIOD       : aliased SCL_LOW_PERIOD_Register;
      --  I2C_CTR_REG
      CTR                  : aliased CTR_Register;
      --  I2C_SR_REG
      SR                   : aliased SR_Register;
      --  I2C_TO_REG
      TO                   : aliased TO_Register;
      --  I2C_SLAVE_ADDR_REG
      SLAVE_ADDR           : aliased SLAVE_ADDR_Register;
      --  I2C_FIFO_ST_REG
      FIFO_ST              : aliased FIFO_ST_Register;
      --  I2C_FIFO_CONF_REG
      FIFO_CONF            : aliased FIFO_CONF_Register;
      --  I2C_FIFO_DATA_REG
      DATA                 : aliased DATA_Register;
      --  I2C_INT_RAW_REG
      INT_RAW              : aliased INT_RAW_Register;
      --  I2C_INT_CLR_REG
      INT_CLR              : aliased INT_CLR_Register;
      --  I2C_INT_ENA_REG
      INT_ENA              : aliased INT_ENA_Register;
      --  I2C_INT_STATUS_REG
      INT_STATUS           : aliased INT_STATUS_Register;
      --  I2C_SDA_HOLD_REG
      SDA_HOLD             : aliased SDA_HOLD_Register;
      --  I2C_SDA_SAMPLE_REG
      SDA_SAMPLE           : aliased SDA_SAMPLE_Register;
      --  I2C_SCL_HIGH_PERIOD_REG
      SCL_HIGH_PERIOD      : aliased SCL_HIGH_PERIOD_Register;
      --  I2C_SCL_START_HOLD_REG
      SCL_START_HOLD       : aliased SCL_START_HOLD_Register;
      --  I2C_SCL_RSTART_SETUP_REG
      SCL_RSTART_SETUP     : aliased SCL_RSTART_SETUP_Register;
      --  I2C_SCL_STOP_HOLD_REG
      SCL_STOP_HOLD        : aliased SCL_STOP_HOLD_Register;
      --  I2C_SCL_STOP_SETUP_REG
      SCL_STOP_SETUP       : aliased SCL_STOP_SETUP_Register;
      --  I2C_FILTER_CFG_REG
      FILTER_CFG           : aliased FILTER_CFG_Register;
      --  I2C_CLK_CONF_REG
      CLK_CONF             : aliased CLK_CONF_Register;
      --  I2C_COMD%s_REG
      COMD                 : aliased COMD_Registers;
      --  I2C_SCL_ST_TIME_OUT_REG
      SCL_ST_TIME_OUT      : aliased SCL_ST_TIME_OUT_Register;
      --  I2C_SCL_MAIN_ST_TIME_OUT_REG
      SCL_MAIN_ST_TIME_OUT : aliased SCL_MAIN_ST_TIME_OUT_Register;
      --  I2C_SCL_SP_CONF_REG
      SCL_SP_CONF          : aliased SCL_SP_CONF_Register;
      --  I2C_SCL_STRETCH_CONF_REG
      SCL_STRETCH_CONF     : aliased SCL_STRETCH_CONF_Register;
      --  I2C_DATE_REG
      DATE                 : aliased ESP32_C3.UInt32;
      --  I2C_TXFIFO_START_ADDR_REG
      TXFIFO_START_ADDR    : aliased ESP32_C3.UInt32;
      --  I2C_RXFIFO_START_ADDR_REG
      RXFIFO_START_ADDR    : aliased ESP32_C3.UInt32;
   end record
     with Volatile;

   for I2C0_Peripheral use record
      SCL_LOW_PERIOD       at 16#0# range 0 .. 31;
      CTR                  at 16#4# range 0 .. 31;
      SR                   at 16#8# range 0 .. 31;
      TO                   at 16#C# range 0 .. 31;
      SLAVE_ADDR           at 16#10# range 0 .. 31;
      FIFO_ST              at 16#14# range 0 .. 31;
      FIFO_CONF            at 16#18# range 0 .. 31;
      DATA                 at 16#1C# range 0 .. 31;
      INT_RAW              at 16#20# range 0 .. 31;
      INT_CLR              at 16#24# range 0 .. 31;
      INT_ENA              at 16#28# range 0 .. 31;
      INT_STATUS           at 16#2C# range 0 .. 31;
      SDA_HOLD             at 16#30# range 0 .. 31;
      SDA_SAMPLE           at 16#34# range 0 .. 31;
      SCL_HIGH_PERIOD      at 16#38# range 0 .. 31;
      SCL_START_HOLD       at 16#40# range 0 .. 31;
      SCL_RSTART_SETUP     at 16#44# range 0 .. 31;
      SCL_STOP_HOLD        at 16#48# range 0 .. 31;
      SCL_STOP_SETUP       at 16#4C# range 0 .. 31;
      FILTER_CFG           at 16#50# range 0 .. 31;
      CLK_CONF             at 16#54# range 0 .. 31;
      COMD                 at 16#58# range 0 .. 255;
      SCL_ST_TIME_OUT      at 16#78# range 0 .. 31;
      SCL_MAIN_ST_TIME_OUT at 16#7C# range 0 .. 31;
      SCL_SP_CONF          at 16#80# range 0 .. 31;
      SCL_STRETCH_CONF     at 16#84# range 0 .. 31;
      DATE                 at 16#F8# range 0 .. 31;
      TXFIFO_START_ADDR    at 16#100# range 0 .. 31;
      RXFIFO_START_ADDR    at 16#180# range 0 .. 31;
   end record;

   --  I2C (Inter-Integrated Circuit) Controller 0
   I2C0_Periph : aliased I2C0_Peripheral
     with Import, Address => I2C0_Base;

end ESP32_C3.I2C;
