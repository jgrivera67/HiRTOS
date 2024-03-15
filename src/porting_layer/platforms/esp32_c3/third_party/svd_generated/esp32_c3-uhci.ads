pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.UHCI is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype CONF0_TX_RST_Field is ESP32_C3.Bit;
   subtype CONF0_RX_RST_Field is ESP32_C3.Bit;
   subtype CONF0_UART0_CE_Field is ESP32_C3.Bit;
   subtype CONF0_UART1_CE_Field is ESP32_C3.Bit;
   subtype CONF0_SEPER_EN_Field is ESP32_C3.Bit;
   subtype CONF0_HEAD_EN_Field is ESP32_C3.Bit;
   subtype CONF0_CRC_REC_EN_Field is ESP32_C3.Bit;
   subtype CONF0_UART_IDLE_EOF_EN_Field is ESP32_C3.Bit;
   subtype CONF0_LEN_EOF_EN_Field is ESP32_C3.Bit;
   subtype CONF0_ENCODE_CRC_EN_Field is ESP32_C3.Bit;
   subtype CONF0_CLK_EN_Field is ESP32_C3.Bit;
   subtype CONF0_UART_RX_BRK_EOF_EN_Field is ESP32_C3.Bit;

   --  a
   type CONF0_Register is record
      --  Write 1, then write 0 to this bit to reset decode state machine.
      TX_RST             : CONF0_TX_RST_Field := 16#0#;
      --  Write 1, then write 0 to this bit to reset encode state machine.
      RX_RST             : CONF0_RX_RST_Field := 16#0#;
      --  Set this bit to link up HCI and UART0.
      UART0_CE           : CONF0_UART0_CE_Field := 16#0#;
      --  Set this bit to link up HCI and UART1.
      UART1_CE           : CONF0_UART1_CE_Field := 16#0#;
      --  unspecified
      Reserved_4_4       : ESP32_C3.Bit := 16#0#;
      --  Set this bit to separate the data frame using a special char.
      SEPER_EN           : CONF0_SEPER_EN_Field := 16#1#;
      --  Set this bit to encode the data packet with a formatting header.
      HEAD_EN            : CONF0_HEAD_EN_Field := 16#1#;
      --  Set this bit to enable UHCI to receive the 16 bit CRC.
      CRC_REC_EN         : CONF0_CRC_REC_EN_Field := 16#1#;
      --  If this bit is set to 1, UHCI will end the payload receiving process
      --  when UART has been in idle state.
      UART_IDLE_EOF_EN   : CONF0_UART_IDLE_EOF_EN_Field := 16#0#;
      --  If this bit is set to 1, UHCI decoder receiving payload data is end
      --  when the receiving byte count has reached the specified value. The
      --  value is payload length indicated by UHCI packet header when
      --  UHCI_HEAD_EN is 1 or the value is configuration value when
      --  UHCI_HEAD_EN is 0. If this bit is set to 0, UHCI decoder receiving
      --  payload data is end when 0xc0 is received.
      LEN_EOF_EN         : CONF0_LEN_EOF_EN_Field := 16#1#;
      --  Set this bit to enable data integrity checking by appending a 16 bit
      --  CCITT-CRC to end of the payload.
      ENCODE_CRC_EN      : CONF0_ENCODE_CRC_EN_Field := 16#1#;
      --  1'b1: Force clock on for register. 1'b0: Support clock only when
      --  application writes registers.
      CLK_EN             : CONF0_CLK_EN_Field := 16#0#;
      --  If this bit is set to 1, UHCI will end payload receive process when
      --  NULL frame is received by UART.
      UART_RX_BRK_EOF_EN : CONF0_UART_RX_BRK_EOF_EN_Field := 16#0#;
      --  unspecified
      Reserved_13_31     : ESP32_C3.UInt19 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CONF0_Register use record
      TX_RST             at 0 range 0 .. 0;
      RX_RST             at 0 range 1 .. 1;
      UART0_CE           at 0 range 2 .. 2;
      UART1_CE           at 0 range 3 .. 3;
      Reserved_4_4       at 0 range 4 .. 4;
      SEPER_EN           at 0 range 5 .. 5;
      HEAD_EN            at 0 range 6 .. 6;
      CRC_REC_EN         at 0 range 7 .. 7;
      UART_IDLE_EOF_EN   at 0 range 8 .. 8;
      LEN_EOF_EN         at 0 range 9 .. 9;
      ENCODE_CRC_EN      at 0 range 10 .. 10;
      CLK_EN             at 0 range 11 .. 11;
      UART_RX_BRK_EOF_EN at 0 range 12 .. 12;
      Reserved_13_31     at 0 range 13 .. 31;
   end record;

   subtype INT_RAW_RX_START_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_TX_START_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_RX_HUNG_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_TX_HUNG_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_SEND_S_REG_Q_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_SEND_A_REG_Q_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_OUT_EOF_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_APP_CTRL0_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_APP_CTRL1_INT_RAW_Field is ESP32_C3.Bit;

   --  a
   type INT_RAW_Register is record
      --  a
      RX_START_INT_RAW     : INT_RAW_RX_START_INT_RAW_Field := 16#0#;
      --  a
      TX_START_INT_RAW     : INT_RAW_TX_START_INT_RAW_Field := 16#0#;
      --  a
      RX_HUNG_INT_RAW      : INT_RAW_RX_HUNG_INT_RAW_Field := 16#0#;
      --  a
      TX_HUNG_INT_RAW      : INT_RAW_TX_HUNG_INT_RAW_Field := 16#0#;
      --  a
      SEND_S_REG_Q_INT_RAW : INT_RAW_SEND_S_REG_Q_INT_RAW_Field := 16#0#;
      --  a
      SEND_A_REG_Q_INT_RAW : INT_RAW_SEND_A_REG_Q_INT_RAW_Field := 16#0#;
      --  This is the interrupt raw bit. Triggered when there are some errors
      --  in EOF in the
      OUT_EOF_INT_RAW      : INT_RAW_OUT_EOF_INT_RAW_Field := 16#0#;
      --  Soft control int raw bit.
      APP_CTRL0_INT_RAW    : INT_RAW_APP_CTRL0_INT_RAW_Field := 16#0#;
      --  Soft control int raw bit.
      APP_CTRL1_INT_RAW    : INT_RAW_APP_CTRL1_INT_RAW_Field := 16#0#;
      --  unspecified
      Reserved_9_31        : ESP32_C3.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_RAW_Register use record
      RX_START_INT_RAW     at 0 range 0 .. 0;
      TX_START_INT_RAW     at 0 range 1 .. 1;
      RX_HUNG_INT_RAW      at 0 range 2 .. 2;
      TX_HUNG_INT_RAW      at 0 range 3 .. 3;
      SEND_S_REG_Q_INT_RAW at 0 range 4 .. 4;
      SEND_A_REG_Q_INT_RAW at 0 range 5 .. 5;
      OUT_EOF_INT_RAW      at 0 range 6 .. 6;
      APP_CTRL0_INT_RAW    at 0 range 7 .. 7;
      APP_CTRL1_INT_RAW    at 0 range 8 .. 8;
      Reserved_9_31        at 0 range 9 .. 31;
   end record;

   subtype INT_ST_RX_START_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_TX_START_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_RX_HUNG_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_TX_HUNG_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_SEND_S_REG_Q_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_SEND_A_REG_Q_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_OUTLINK_EOF_ERR_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_APP_CTRL0_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_APP_CTRL1_INT_ST_Field is ESP32_C3.Bit;

   --  a
   type INT_ST_Register is record
      --  Read-only. a
      RX_START_INT_ST        : INT_ST_RX_START_INT_ST_Field;
      --  Read-only. a
      TX_START_INT_ST        : INT_ST_TX_START_INT_ST_Field;
      --  Read-only. a
      RX_HUNG_INT_ST         : INT_ST_RX_HUNG_INT_ST_Field;
      --  Read-only. a
      TX_HUNG_INT_ST         : INT_ST_TX_HUNG_INT_ST_Field;
      --  Read-only. a
      SEND_S_REG_Q_INT_ST    : INT_ST_SEND_S_REG_Q_INT_ST_Field;
      --  Read-only. a
      SEND_A_REG_Q_INT_ST    : INT_ST_SEND_A_REG_Q_INT_ST_Field;
      --  Read-only. a
      OUTLINK_EOF_ERR_INT_ST : INT_ST_OUTLINK_EOF_ERR_INT_ST_Field;
      --  Read-only. a
      APP_CTRL0_INT_ST       : INT_ST_APP_CTRL0_INT_ST_Field;
      --  Read-only. a
      APP_CTRL1_INT_ST       : INT_ST_APP_CTRL1_INT_ST_Field;
      --  unspecified
      Reserved_9_31          : ESP32_C3.UInt23;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_ST_Register use record
      RX_START_INT_ST        at 0 range 0 .. 0;
      TX_START_INT_ST        at 0 range 1 .. 1;
      RX_HUNG_INT_ST         at 0 range 2 .. 2;
      TX_HUNG_INT_ST         at 0 range 3 .. 3;
      SEND_S_REG_Q_INT_ST    at 0 range 4 .. 4;
      SEND_A_REG_Q_INT_ST    at 0 range 5 .. 5;
      OUTLINK_EOF_ERR_INT_ST at 0 range 6 .. 6;
      APP_CTRL0_INT_ST       at 0 range 7 .. 7;
      APP_CTRL1_INT_ST       at 0 range 8 .. 8;
      Reserved_9_31          at 0 range 9 .. 31;
   end record;

   subtype INT_ENA_RX_START_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_TX_START_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_RX_HUNG_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_TX_HUNG_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_SEND_S_REG_Q_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_SEND_A_REG_Q_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_OUTLINK_EOF_ERR_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_APP_CTRL0_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_APP_CTRL1_INT_ENA_Field is ESP32_C3.Bit;

   --  a
   type INT_ENA_Register is record
      --  a
      RX_START_INT_ENA        : INT_ENA_RX_START_INT_ENA_Field := 16#0#;
      --  a
      TX_START_INT_ENA        : INT_ENA_TX_START_INT_ENA_Field := 16#0#;
      --  a
      RX_HUNG_INT_ENA         : INT_ENA_RX_HUNG_INT_ENA_Field := 16#0#;
      --  a
      TX_HUNG_INT_ENA         : INT_ENA_TX_HUNG_INT_ENA_Field := 16#0#;
      --  a
      SEND_S_REG_Q_INT_ENA    : INT_ENA_SEND_S_REG_Q_INT_ENA_Field := 16#0#;
      --  a
      SEND_A_REG_Q_INT_ENA    : INT_ENA_SEND_A_REG_Q_INT_ENA_Field := 16#0#;
      --  a
      OUTLINK_EOF_ERR_INT_ENA : INT_ENA_OUTLINK_EOF_ERR_INT_ENA_Field :=
                                 16#0#;
      --  a
      APP_CTRL0_INT_ENA       : INT_ENA_APP_CTRL0_INT_ENA_Field := 16#0#;
      --  a
      APP_CTRL1_INT_ENA       : INT_ENA_APP_CTRL1_INT_ENA_Field := 16#0#;
      --  unspecified
      Reserved_9_31           : ESP32_C3.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_ENA_Register use record
      RX_START_INT_ENA        at 0 range 0 .. 0;
      TX_START_INT_ENA        at 0 range 1 .. 1;
      RX_HUNG_INT_ENA         at 0 range 2 .. 2;
      TX_HUNG_INT_ENA         at 0 range 3 .. 3;
      SEND_S_REG_Q_INT_ENA    at 0 range 4 .. 4;
      SEND_A_REG_Q_INT_ENA    at 0 range 5 .. 5;
      OUTLINK_EOF_ERR_INT_ENA at 0 range 6 .. 6;
      APP_CTRL0_INT_ENA       at 0 range 7 .. 7;
      APP_CTRL1_INT_ENA       at 0 range 8 .. 8;
      Reserved_9_31           at 0 range 9 .. 31;
   end record;

   subtype INT_CLR_RX_START_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_TX_START_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_RX_HUNG_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_TX_HUNG_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_SEND_S_REG_Q_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_SEND_A_REG_Q_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_OUTLINK_EOF_ERR_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_APP_CTRL0_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_APP_CTRL1_INT_CLR_Field is ESP32_C3.Bit;

   --  a
   type INT_CLR_Register is record
      --  Write-only. a
      RX_START_INT_CLR        : INT_CLR_RX_START_INT_CLR_Field := 16#0#;
      --  Write-only. a
      TX_START_INT_CLR        : INT_CLR_TX_START_INT_CLR_Field := 16#0#;
      --  Write-only. a
      RX_HUNG_INT_CLR         : INT_CLR_RX_HUNG_INT_CLR_Field := 16#0#;
      --  Write-only. a
      TX_HUNG_INT_CLR         : INT_CLR_TX_HUNG_INT_CLR_Field := 16#0#;
      --  Write-only. a
      SEND_S_REG_Q_INT_CLR    : INT_CLR_SEND_S_REG_Q_INT_CLR_Field := 16#0#;
      --  Write-only. a
      SEND_A_REG_Q_INT_CLR    : INT_CLR_SEND_A_REG_Q_INT_CLR_Field := 16#0#;
      --  Write-only. a
      OUTLINK_EOF_ERR_INT_CLR : INT_CLR_OUTLINK_EOF_ERR_INT_CLR_Field :=
                                 16#0#;
      --  Write-only. a
      APP_CTRL0_INT_CLR       : INT_CLR_APP_CTRL0_INT_CLR_Field := 16#0#;
      --  Write-only. a
      APP_CTRL1_INT_CLR       : INT_CLR_APP_CTRL1_INT_CLR_Field := 16#0#;
      --  unspecified
      Reserved_9_31           : ESP32_C3.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_CLR_Register use record
      RX_START_INT_CLR        at 0 range 0 .. 0;
      TX_START_INT_CLR        at 0 range 1 .. 1;
      RX_HUNG_INT_CLR         at 0 range 2 .. 2;
      TX_HUNG_INT_CLR         at 0 range 3 .. 3;
      SEND_S_REG_Q_INT_CLR    at 0 range 4 .. 4;
      SEND_A_REG_Q_INT_CLR    at 0 range 5 .. 5;
      OUTLINK_EOF_ERR_INT_CLR at 0 range 6 .. 6;
      APP_CTRL0_INT_CLR       at 0 range 7 .. 7;
      APP_CTRL1_INT_CLR       at 0 range 8 .. 8;
      Reserved_9_31           at 0 range 9 .. 31;
   end record;

   subtype CONF1_CHECK_SUM_EN_Field is ESP32_C3.Bit;
   subtype CONF1_CHECK_SEQ_EN_Field is ESP32_C3.Bit;
   subtype CONF1_CRC_DISABLE_Field is ESP32_C3.Bit;
   subtype CONF1_SAVE_HEAD_Field is ESP32_C3.Bit;
   subtype CONF1_TX_CHECK_SUM_RE_Field is ESP32_C3.Bit;
   subtype CONF1_TX_ACK_NUM_RE_Field is ESP32_C3.Bit;
   subtype CONF1_WAIT_SW_START_Field is ESP32_C3.Bit;
   subtype CONF1_SW_START_Field is ESP32_C3.Bit;

   --  a
   type CONF1_Register is record
      --  a
      CHECK_SUM_EN    : CONF1_CHECK_SUM_EN_Field := 16#1#;
      --  a
      CHECK_SEQ_EN    : CONF1_CHECK_SEQ_EN_Field := 16#1#;
      --  a
      CRC_DISABLE     : CONF1_CRC_DISABLE_Field := 16#0#;
      --  a
      SAVE_HEAD       : CONF1_SAVE_HEAD_Field := 16#0#;
      --  a
      TX_CHECK_SUM_RE : CONF1_TX_CHECK_SUM_RE_Field := 16#1#;
      --  a
      TX_ACK_NUM_RE   : CONF1_TX_ACK_NUM_RE_Field := 16#1#;
      --  unspecified
      Reserved_6_6    : ESP32_C3.Bit := 16#0#;
      --  a
      WAIT_SW_START   : CONF1_WAIT_SW_START_Field := 16#0#;
      --  a
      SW_START        : CONF1_SW_START_Field := 16#0#;
      --  unspecified
      Reserved_9_31   : ESP32_C3.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CONF1_Register use record
      CHECK_SUM_EN    at 0 range 0 .. 0;
      CHECK_SEQ_EN    at 0 range 1 .. 1;
      CRC_DISABLE     at 0 range 2 .. 2;
      SAVE_HEAD       at 0 range 3 .. 3;
      TX_CHECK_SUM_RE at 0 range 4 .. 4;
      TX_ACK_NUM_RE   at 0 range 5 .. 5;
      Reserved_6_6    at 0 range 6 .. 6;
      WAIT_SW_START   at 0 range 7 .. 7;
      SW_START        at 0 range 8 .. 8;
      Reserved_9_31   at 0 range 9 .. 31;
   end record;

   subtype STATE0_RX_ERR_CAUSE_Field is ESP32_C3.UInt3;
   subtype STATE0_DECODE_STATE_Field is ESP32_C3.UInt3;

   --  a
   type STATE0_Register is record
      --  Read-only. a
      RX_ERR_CAUSE  : STATE0_RX_ERR_CAUSE_Field;
      --  Read-only. a
      DECODE_STATE  : STATE0_DECODE_STATE_Field;
      --  unspecified
      Reserved_6_31 : ESP32_C3.UInt26;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for STATE0_Register use record
      RX_ERR_CAUSE  at 0 range 0 .. 2;
      DECODE_STATE  at 0 range 3 .. 5;
      Reserved_6_31 at 0 range 6 .. 31;
   end record;

   subtype STATE1_ENCODE_STATE_Field is ESP32_C3.UInt3;

   --  a
   type STATE1_Register is record
      --  Read-only. a
      ENCODE_STATE  : STATE1_ENCODE_STATE_Field;
      --  unspecified
      Reserved_3_31 : ESP32_C3.UInt29;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for STATE1_Register use record
      ENCODE_STATE  at 0 range 0 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   subtype ESCAPE_CONF_TX_C0_ESC_EN_Field is ESP32_C3.Bit;
   subtype ESCAPE_CONF_TX_DB_ESC_EN_Field is ESP32_C3.Bit;
   subtype ESCAPE_CONF_TX_11_ESC_EN_Field is ESP32_C3.Bit;
   subtype ESCAPE_CONF_TX_13_ESC_EN_Field is ESP32_C3.Bit;
   subtype ESCAPE_CONF_RX_C0_ESC_EN_Field is ESP32_C3.Bit;
   subtype ESCAPE_CONF_RX_DB_ESC_EN_Field is ESP32_C3.Bit;
   subtype ESCAPE_CONF_RX_11_ESC_EN_Field is ESP32_C3.Bit;
   subtype ESCAPE_CONF_RX_13_ESC_EN_Field is ESP32_C3.Bit;

   --  a
   type ESCAPE_CONF_Register is record
      --  a
      TX_C0_ESC_EN  : ESCAPE_CONF_TX_C0_ESC_EN_Field := 16#1#;
      --  a
      TX_DB_ESC_EN  : ESCAPE_CONF_TX_DB_ESC_EN_Field := 16#1#;
      --  a
      TX_11_ESC_EN  : ESCAPE_CONF_TX_11_ESC_EN_Field := 16#0#;
      --  a
      TX_13_ESC_EN  : ESCAPE_CONF_TX_13_ESC_EN_Field := 16#0#;
      --  a
      RX_C0_ESC_EN  : ESCAPE_CONF_RX_C0_ESC_EN_Field := 16#1#;
      --  a
      RX_DB_ESC_EN  : ESCAPE_CONF_RX_DB_ESC_EN_Field := 16#1#;
      --  a
      RX_11_ESC_EN  : ESCAPE_CONF_RX_11_ESC_EN_Field := 16#0#;
      --  a
      RX_13_ESC_EN  : ESCAPE_CONF_RX_13_ESC_EN_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : ESP32_C3.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ESCAPE_CONF_Register use record
      TX_C0_ESC_EN  at 0 range 0 .. 0;
      TX_DB_ESC_EN  at 0 range 1 .. 1;
      TX_11_ESC_EN  at 0 range 2 .. 2;
      TX_13_ESC_EN  at 0 range 3 .. 3;
      RX_C0_ESC_EN  at 0 range 4 .. 4;
      RX_DB_ESC_EN  at 0 range 5 .. 5;
      RX_11_ESC_EN  at 0 range 6 .. 6;
      RX_13_ESC_EN  at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype HUNG_CONF_TXFIFO_TIMEOUT_Field is ESP32_C3.Byte;
   subtype HUNG_CONF_TXFIFO_TIMEOUT_SHIFT_Field is ESP32_C3.UInt3;
   subtype HUNG_CONF_TXFIFO_TIMEOUT_ENA_Field is ESP32_C3.Bit;
   subtype HUNG_CONF_RXFIFO_TIMEOUT_Field is ESP32_C3.Byte;
   subtype HUNG_CONF_RXFIFO_TIMEOUT_SHIFT_Field is ESP32_C3.UInt3;
   subtype HUNG_CONF_RXFIFO_TIMEOUT_ENA_Field is ESP32_C3.Bit;

   --  a
   type HUNG_CONF_Register is record
      --  a
      TXFIFO_TIMEOUT       : HUNG_CONF_TXFIFO_TIMEOUT_Field := 16#10#;
      --  a
      TXFIFO_TIMEOUT_SHIFT : HUNG_CONF_TXFIFO_TIMEOUT_SHIFT_Field := 16#0#;
      --  a
      TXFIFO_TIMEOUT_ENA   : HUNG_CONF_TXFIFO_TIMEOUT_ENA_Field := 16#1#;
      --  a
      RXFIFO_TIMEOUT       : HUNG_CONF_RXFIFO_TIMEOUT_Field := 16#10#;
      --  a
      RXFIFO_TIMEOUT_SHIFT : HUNG_CONF_RXFIFO_TIMEOUT_SHIFT_Field := 16#0#;
      --  a
      RXFIFO_TIMEOUT_ENA   : HUNG_CONF_RXFIFO_TIMEOUT_ENA_Field := 16#1#;
      --  unspecified
      Reserved_24_31       : ESP32_C3.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for HUNG_CONF_Register use record
      TXFIFO_TIMEOUT       at 0 range 0 .. 7;
      TXFIFO_TIMEOUT_SHIFT at 0 range 8 .. 10;
      TXFIFO_TIMEOUT_ENA   at 0 range 11 .. 11;
      RXFIFO_TIMEOUT       at 0 range 12 .. 19;
      RXFIFO_TIMEOUT_SHIFT at 0 range 20 .. 22;
      RXFIFO_TIMEOUT_ENA   at 0 range 23 .. 23;
      Reserved_24_31       at 0 range 24 .. 31;
   end record;

   subtype ACK_NUM_ACK_NUM_Field is ESP32_C3.UInt3;
   subtype ACK_NUM_LOAD_Field is ESP32_C3.Bit;

   --  a
   type ACK_NUM_Register is record
      --  a
      ACK_NUM       : ACK_NUM_ACK_NUM_Field := 16#0#;
      --  Write-only. a
      LOAD          : ACK_NUM_LOAD_Field := 16#1#;
      --  unspecified
      Reserved_4_31 : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ACK_NUM_Register use record
      ACK_NUM       at 0 range 0 .. 2;
      LOAD          at 0 range 3 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype QUICK_SENT_SINGLE_SEND_NUM_Field is ESP32_C3.UInt3;
   subtype QUICK_SENT_SINGLE_SEND_EN_Field is ESP32_C3.Bit;
   subtype QUICK_SENT_ALWAYS_SEND_NUM_Field is ESP32_C3.UInt3;
   subtype QUICK_SENT_ALWAYS_SEND_EN_Field is ESP32_C3.Bit;

   --  a
   type QUICK_SENT_Register is record
      --  a
      SINGLE_SEND_NUM : QUICK_SENT_SINGLE_SEND_NUM_Field := 16#0#;
      --  a
      SINGLE_SEND_EN  : QUICK_SENT_SINGLE_SEND_EN_Field := 16#0#;
      --  a
      ALWAYS_SEND_NUM : QUICK_SENT_ALWAYS_SEND_NUM_Field := 16#0#;
      --  a
      ALWAYS_SEND_EN  : QUICK_SENT_ALWAYS_SEND_EN_Field := 16#0#;
      --  unspecified
      Reserved_8_31   : ESP32_C3.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for QUICK_SENT_Register use record
      SINGLE_SEND_NUM at 0 range 0 .. 2;
      SINGLE_SEND_EN  at 0 range 3 .. 3;
      ALWAYS_SEND_NUM at 0 range 4 .. 6;
      ALWAYS_SEND_EN  at 0 range 7 .. 7;
      Reserved_8_31   at 0 range 8 .. 31;
   end record;

   subtype ESC_CONF0_SEPER_CHAR_Field is ESP32_C3.Byte;
   --  ESC_CONF0_SEPER_ESC_CHAR array element
   subtype ESC_CONF0_SEPER_ESC_CHAR_Element is ESP32_C3.Byte;

   --  ESC_CONF0_SEPER_ESC_CHAR array
   type ESC_CONF0_SEPER_ESC_CHAR_Field_Array is array (0 .. 1)
     of ESC_CONF0_SEPER_ESC_CHAR_Element
     with Component_Size => 8, Size => 16;

   --  Type definition for ESC_CONF0_SEPER_ESC_CHAR
   type ESC_CONF0_SEPER_ESC_CHAR_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  SEPER_ESC_CHAR as a value
            Val : ESP32_C3.UInt16;
         when True =>
            --  SEPER_ESC_CHAR as an array
            Arr : ESC_CONF0_SEPER_ESC_CHAR_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 16;

   for ESC_CONF0_SEPER_ESC_CHAR_Field use record
      Val at 0 range 0 .. 15;
      Arr at 0 range 0 .. 15;
   end record;

   --  a
   type ESC_CONF0_Register is record
      --  a
      SEPER_CHAR     : ESC_CONF0_SEPER_CHAR_Field := 16#C0#;
      --  a
      SEPER_ESC_CHAR : ESC_CONF0_SEPER_ESC_CHAR_Field :=
                        (As_Array => False, Val => 16#DB#);
      --  unspecified
      Reserved_24_31 : ESP32_C3.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ESC_CONF0_Register use record
      SEPER_CHAR     at 0 range 0 .. 7;
      SEPER_ESC_CHAR at 0 range 8 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   subtype ESC_CONF1_ESC_SEQ0_Field is ESP32_C3.Byte;
   --  ESC_CONF1_ESC_SEQ0_CHAR array element
   subtype ESC_CONF1_ESC_SEQ0_CHAR_Element is ESP32_C3.Byte;

   --  ESC_CONF1_ESC_SEQ0_CHAR array
   type ESC_CONF1_ESC_SEQ0_CHAR_Field_Array is array (0 .. 1)
     of ESC_CONF1_ESC_SEQ0_CHAR_Element
     with Component_Size => 8, Size => 16;

   --  Type definition for ESC_CONF1_ESC_SEQ0_CHAR
   type ESC_CONF1_ESC_SEQ0_CHAR_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  ESC_SEQ0_CHAR as a value
            Val : ESP32_C3.UInt16;
         when True =>
            --  ESC_SEQ0_CHAR as an array
            Arr : ESC_CONF1_ESC_SEQ0_CHAR_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 16;

   for ESC_CONF1_ESC_SEQ0_CHAR_Field use record
      Val at 0 range 0 .. 15;
      Arr at 0 range 0 .. 15;
   end record;

   --  a
   type ESC_CONF1_Register is record
      --  a
      ESC_SEQ0       : ESC_CONF1_ESC_SEQ0_Field := 16#DB#;
      --  a
      ESC_SEQ0_CHAR  : ESC_CONF1_ESC_SEQ0_CHAR_Field :=
                        (As_Array => False, Val => 16#DB#);
      --  unspecified
      Reserved_24_31 : ESP32_C3.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ESC_CONF1_Register use record
      ESC_SEQ0       at 0 range 0 .. 7;
      ESC_SEQ0_CHAR  at 0 range 8 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   subtype ESC_CONF2_ESC_SEQ1_Field is ESP32_C3.Byte;
   --  ESC_CONF2_ESC_SEQ1_CHAR array element
   subtype ESC_CONF2_ESC_SEQ1_CHAR_Element is ESP32_C3.Byte;

   --  ESC_CONF2_ESC_SEQ1_CHAR array
   type ESC_CONF2_ESC_SEQ1_CHAR_Field_Array is array (0 .. 1)
     of ESC_CONF2_ESC_SEQ1_CHAR_Element
     with Component_Size => 8, Size => 16;

   --  Type definition for ESC_CONF2_ESC_SEQ1_CHAR
   type ESC_CONF2_ESC_SEQ1_CHAR_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  ESC_SEQ1_CHAR as a value
            Val : ESP32_C3.UInt16;
         when True =>
            --  ESC_SEQ1_CHAR as an array
            Arr : ESC_CONF2_ESC_SEQ1_CHAR_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 16;

   for ESC_CONF2_ESC_SEQ1_CHAR_Field use record
      Val at 0 range 0 .. 15;
      Arr at 0 range 0 .. 15;
   end record;

   --  a
   type ESC_CONF2_Register is record
      --  a
      ESC_SEQ1       : ESC_CONF2_ESC_SEQ1_Field := 16#11#;
      --  a
      ESC_SEQ1_CHAR  : ESC_CONF2_ESC_SEQ1_CHAR_Field :=
                        (As_Array => False, Val => 16#DB#);
      --  unspecified
      Reserved_24_31 : ESP32_C3.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ESC_CONF2_Register use record
      ESC_SEQ1       at 0 range 0 .. 7;
      ESC_SEQ1_CHAR  at 0 range 8 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   subtype ESC_CONF3_ESC_SEQ2_Field is ESP32_C3.Byte;
   --  ESC_CONF3_ESC_SEQ2_CHAR array element
   subtype ESC_CONF3_ESC_SEQ2_CHAR_Element is ESP32_C3.Byte;

   --  ESC_CONF3_ESC_SEQ2_CHAR array
   type ESC_CONF3_ESC_SEQ2_CHAR_Field_Array is array (0 .. 1)
     of ESC_CONF3_ESC_SEQ2_CHAR_Element
     with Component_Size => 8, Size => 16;

   --  Type definition for ESC_CONF3_ESC_SEQ2_CHAR
   type ESC_CONF3_ESC_SEQ2_CHAR_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  ESC_SEQ2_CHAR as a value
            Val : ESP32_C3.UInt16;
         when True =>
            --  ESC_SEQ2_CHAR as an array
            Arr : ESC_CONF3_ESC_SEQ2_CHAR_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 16;

   for ESC_CONF3_ESC_SEQ2_CHAR_Field use record
      Val at 0 range 0 .. 15;
      Arr at 0 range 0 .. 15;
   end record;

   --  a
   type ESC_CONF3_Register is record
      --  a
      ESC_SEQ2       : ESC_CONF3_ESC_SEQ2_Field := 16#13#;
      --  a
      ESC_SEQ2_CHAR  : ESC_CONF3_ESC_SEQ2_CHAR_Field :=
                        (As_Array => False, Val => 16#DB#);
      --  unspecified
      Reserved_24_31 : ESP32_C3.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ESC_CONF3_Register use record
      ESC_SEQ2       at 0 range 0 .. 7;
      ESC_SEQ2_CHAR  at 0 range 8 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   subtype PKT_THRES_PKT_THRS_Field is ESP32_C3.UInt13;

   --  a
   type PKT_THRES_Register is record
      --  a
      PKT_THRS       : PKT_THRES_PKT_THRS_Field := 16#80#;
      --  unspecified
      Reserved_13_31 : ESP32_C3.UInt19 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PKT_THRES_Register use record
      PKT_THRS       at 0 range 0 .. 12;
      Reserved_13_31 at 0 range 13 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Universal Host Controller Interface 0
   type UHCI_Peripheral is record
      --  a
      CONF0        : aliased CONF0_Register;
      --  a
      INT_RAW      : aliased INT_RAW_Register;
      --  a
      INT_ST       : aliased INT_ST_Register;
      --  a
      INT_ENA      : aliased INT_ENA_Register;
      --  a
      INT_CLR      : aliased INT_CLR_Register;
      --  a
      CONF1        : aliased CONF1_Register;
      --  a
      STATE0       : aliased STATE0_Register;
      --  a
      STATE1       : aliased STATE1_Register;
      --  a
      ESCAPE_CONF  : aliased ESCAPE_CONF_Register;
      --  a
      HUNG_CONF    : aliased HUNG_CONF_Register;
      --  a
      ACK_NUM      : aliased ACK_NUM_Register;
      --  a
      RX_HEAD      : aliased ESP32_C3.UInt32;
      --  a
      QUICK_SENT   : aliased QUICK_SENT_Register;
      --  a
      REG_Q0_WORD0 : aliased ESP32_C3.UInt32;
      --  a
      REG_Q0_WORD1 : aliased ESP32_C3.UInt32;
      --  a
      REG_Q1_WORD0 : aliased ESP32_C3.UInt32;
      --  a
      REG_Q1_WORD1 : aliased ESP32_C3.UInt32;
      --  a
      REG_Q2_WORD0 : aliased ESP32_C3.UInt32;
      --  a
      REG_Q2_WORD1 : aliased ESP32_C3.UInt32;
      --  a
      REG_Q3_WORD0 : aliased ESP32_C3.UInt32;
      --  a
      REG_Q3_WORD1 : aliased ESP32_C3.UInt32;
      --  a
      REG_Q4_WORD0 : aliased ESP32_C3.UInt32;
      --  a
      REG_Q4_WORD1 : aliased ESP32_C3.UInt32;
      --  a
      REG_Q5_WORD0 : aliased ESP32_C3.UInt32;
      --  a
      REG_Q5_WORD1 : aliased ESP32_C3.UInt32;
      --  a
      REG_Q6_WORD0 : aliased ESP32_C3.UInt32;
      --  a
      REG_Q6_WORD1 : aliased ESP32_C3.UInt32;
      --  a
      ESC_CONF0    : aliased ESC_CONF0_Register;
      --  a
      ESC_CONF1    : aliased ESC_CONF1_Register;
      --  a
      ESC_CONF2    : aliased ESC_CONF2_Register;
      --  a
      ESC_CONF3    : aliased ESC_CONF3_Register;
      --  a
      PKT_THRES    : aliased PKT_THRES_Register;
      --  a
      DATE         : aliased ESP32_C3.UInt32;
   end record
     with Volatile;

   for UHCI_Peripheral use record
      CONF0        at 16#0# range 0 .. 31;
      INT_RAW      at 16#4# range 0 .. 31;
      INT_ST       at 16#8# range 0 .. 31;
      INT_ENA      at 16#C# range 0 .. 31;
      INT_CLR      at 16#10# range 0 .. 31;
      CONF1        at 16#14# range 0 .. 31;
      STATE0       at 16#18# range 0 .. 31;
      STATE1       at 16#1C# range 0 .. 31;
      ESCAPE_CONF  at 16#20# range 0 .. 31;
      HUNG_CONF    at 16#24# range 0 .. 31;
      ACK_NUM      at 16#28# range 0 .. 31;
      RX_HEAD      at 16#2C# range 0 .. 31;
      QUICK_SENT   at 16#30# range 0 .. 31;
      REG_Q0_WORD0 at 16#34# range 0 .. 31;
      REG_Q0_WORD1 at 16#38# range 0 .. 31;
      REG_Q1_WORD0 at 16#3C# range 0 .. 31;
      REG_Q1_WORD1 at 16#40# range 0 .. 31;
      REG_Q2_WORD0 at 16#44# range 0 .. 31;
      REG_Q2_WORD1 at 16#48# range 0 .. 31;
      REG_Q3_WORD0 at 16#4C# range 0 .. 31;
      REG_Q3_WORD1 at 16#50# range 0 .. 31;
      REG_Q4_WORD0 at 16#54# range 0 .. 31;
      REG_Q4_WORD1 at 16#58# range 0 .. 31;
      REG_Q5_WORD0 at 16#5C# range 0 .. 31;
      REG_Q5_WORD1 at 16#60# range 0 .. 31;
      REG_Q6_WORD0 at 16#64# range 0 .. 31;
      REG_Q6_WORD1 at 16#68# range 0 .. 31;
      ESC_CONF0    at 16#6C# range 0 .. 31;
      ESC_CONF1    at 16#70# range 0 .. 31;
      ESC_CONF2    at 16#74# range 0 .. 31;
      ESC_CONF3    at 16#78# range 0 .. 31;
      PKT_THRES    at 16#7C# range 0 .. 31;
      DATE         at 16#80# range 0 .. 31;
   end record;

   --  Universal Host Controller Interface 0
   UHCI0_Periph : aliased UHCI_Peripheral
     with Import, Address => UHCI0_Base;

   --  Universal Host Controller Interface 1
   UHCI1_Periph : aliased UHCI_Peripheral
     with Import, Address => UHCI1_Base;

end ESP32_C3.UHCI;
