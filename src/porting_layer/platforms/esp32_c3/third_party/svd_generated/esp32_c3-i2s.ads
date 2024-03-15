pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.I2S is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype INT_RAW_RX_DONE_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_TX_DONE_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_RX_HUNG_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_TX_HUNG_INT_RAW_Field is ESP32_C3.Bit;

   --  I2S interrupt raw register, valid in level.
   type INT_RAW_Register is record
      --  Read-only. The raw interrupt status bit for the i2s_rx_done_int
      --  interrupt
      RX_DONE_INT_RAW : INT_RAW_RX_DONE_INT_RAW_Field;
      --  Read-only. The raw interrupt status bit for the i2s_tx_done_int
      --  interrupt
      TX_DONE_INT_RAW : INT_RAW_TX_DONE_INT_RAW_Field;
      --  Read-only. The raw interrupt status bit for the i2s_rx_hung_int
      --  interrupt
      RX_HUNG_INT_RAW : INT_RAW_RX_HUNG_INT_RAW_Field;
      --  Read-only. The raw interrupt status bit for the i2s_tx_hung_int
      --  interrupt
      TX_HUNG_INT_RAW : INT_RAW_TX_HUNG_INT_RAW_Field;
      --  unspecified
      Reserved_4_31   : ESP32_C3.UInt28;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_RAW_Register use record
      RX_DONE_INT_RAW at 0 range 0 .. 0;
      TX_DONE_INT_RAW at 0 range 1 .. 1;
      RX_HUNG_INT_RAW at 0 range 2 .. 2;
      TX_HUNG_INT_RAW at 0 range 3 .. 3;
      Reserved_4_31   at 0 range 4 .. 31;
   end record;

   subtype INT_ST_RX_DONE_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_TX_DONE_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_RX_HUNG_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_TX_HUNG_INT_ST_Field is ESP32_C3.Bit;

   --  I2S interrupt status register.
   type INT_ST_Register is record
      --  Read-only. The masked interrupt status bit for the i2s_rx_done_int
      --  interrupt
      RX_DONE_INT_ST : INT_ST_RX_DONE_INT_ST_Field;
      --  Read-only. The masked interrupt status bit for the i2s_tx_done_int
      --  interrupt
      TX_DONE_INT_ST : INT_ST_TX_DONE_INT_ST_Field;
      --  Read-only. The masked interrupt status bit for the i2s_rx_hung_int
      --  interrupt
      RX_HUNG_INT_ST : INT_ST_RX_HUNG_INT_ST_Field;
      --  Read-only. The masked interrupt status bit for the i2s_tx_hung_int
      --  interrupt
      TX_HUNG_INT_ST : INT_ST_TX_HUNG_INT_ST_Field;
      --  unspecified
      Reserved_4_31  : ESP32_C3.UInt28;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_ST_Register use record
      RX_DONE_INT_ST at 0 range 0 .. 0;
      TX_DONE_INT_ST at 0 range 1 .. 1;
      RX_HUNG_INT_ST at 0 range 2 .. 2;
      TX_HUNG_INT_ST at 0 range 3 .. 3;
      Reserved_4_31  at 0 range 4 .. 31;
   end record;

   subtype INT_ENA_RX_DONE_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_TX_DONE_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_RX_HUNG_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_TX_HUNG_INT_ENA_Field is ESP32_C3.Bit;

   --  I2S interrupt enable register.
   type INT_ENA_Register is record
      --  The interrupt enable bit for the i2s_rx_done_int interrupt
      RX_DONE_INT_ENA : INT_ENA_RX_DONE_INT_ENA_Field := 16#0#;
      --  The interrupt enable bit for the i2s_tx_done_int interrupt
      TX_DONE_INT_ENA : INT_ENA_TX_DONE_INT_ENA_Field := 16#0#;
      --  The interrupt enable bit for the i2s_rx_hung_int interrupt
      RX_HUNG_INT_ENA : INT_ENA_RX_HUNG_INT_ENA_Field := 16#0#;
      --  The interrupt enable bit for the i2s_tx_hung_int interrupt
      TX_HUNG_INT_ENA : INT_ENA_TX_HUNG_INT_ENA_Field := 16#0#;
      --  unspecified
      Reserved_4_31   : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_ENA_Register use record
      RX_DONE_INT_ENA at 0 range 0 .. 0;
      TX_DONE_INT_ENA at 0 range 1 .. 1;
      RX_HUNG_INT_ENA at 0 range 2 .. 2;
      TX_HUNG_INT_ENA at 0 range 3 .. 3;
      Reserved_4_31   at 0 range 4 .. 31;
   end record;

   subtype INT_CLR_RX_DONE_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_TX_DONE_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_RX_HUNG_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_TX_HUNG_INT_CLR_Field is ESP32_C3.Bit;

   --  I2S interrupt clear register.
   type INT_CLR_Register is record
      --  Write-only. Set this bit to clear the i2s_rx_done_int interrupt
      RX_DONE_INT_CLR : INT_CLR_RX_DONE_INT_CLR_Field := 16#0#;
      --  Write-only. Set this bit to clear the i2s_tx_done_int interrupt
      TX_DONE_INT_CLR : INT_CLR_TX_DONE_INT_CLR_Field := 16#0#;
      --  Write-only. Set this bit to clear the i2s_rx_hung_int interrupt
      RX_HUNG_INT_CLR : INT_CLR_RX_HUNG_INT_CLR_Field := 16#0#;
      --  Write-only. Set this bit to clear the i2s_tx_hung_int interrupt
      TX_HUNG_INT_CLR : INT_CLR_TX_HUNG_INT_CLR_Field := 16#0#;
      --  unspecified
      Reserved_4_31   : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_CLR_Register use record
      RX_DONE_INT_CLR at 0 range 0 .. 0;
      TX_DONE_INT_CLR at 0 range 1 .. 1;
      RX_HUNG_INT_CLR at 0 range 2 .. 2;
      TX_HUNG_INT_CLR at 0 range 3 .. 3;
      Reserved_4_31   at 0 range 4 .. 31;
   end record;

   subtype RX_CONF_RX_RESET_Field is ESP32_C3.Bit;
   subtype RX_CONF_RX_FIFO_RESET_Field is ESP32_C3.Bit;
   subtype RX_CONF_RX_START_Field is ESP32_C3.Bit;
   subtype RX_CONF_RX_SLAVE_MOD_Field is ESP32_C3.Bit;
   subtype RX_CONF_RX_MONO_Field is ESP32_C3.Bit;
   subtype RX_CONF_RX_BIG_ENDIAN_Field is ESP32_C3.Bit;
   subtype RX_CONF_RX_UPDATE_Field is ESP32_C3.Bit;
   subtype RX_CONF_RX_MONO_FST_VLD_Field is ESP32_C3.Bit;
   subtype RX_CONF_RX_PCM_CONF_Field is ESP32_C3.UInt2;
   subtype RX_CONF_RX_PCM_BYPASS_Field is ESP32_C3.Bit;
   subtype RX_CONF_RX_STOP_MODE_Field is ESP32_C3.UInt2;
   subtype RX_CONF_RX_LEFT_ALIGN_Field is ESP32_C3.Bit;
   subtype RX_CONF_RX_24_FILL_EN_Field is ESP32_C3.Bit;
   subtype RX_CONF_RX_WS_IDLE_POL_Field is ESP32_C3.Bit;
   subtype RX_CONF_RX_BIT_ORDER_Field is ESP32_C3.Bit;
   subtype RX_CONF_RX_TDM_EN_Field is ESP32_C3.Bit;
   subtype RX_CONF_RX_PDM_EN_Field is ESP32_C3.Bit;

   --  I2S RX configure register
   type RX_CONF_Register is record
      --  Write-only. Set this bit to reset receiver
      RX_RESET        : RX_CONF_RX_RESET_Field := 16#0#;
      --  Write-only. Set this bit to reset Rx AFIFO
      RX_FIFO_RESET   : RX_CONF_RX_FIFO_RESET_Field := 16#0#;
      --  Set this bit to start receiving data
      RX_START        : RX_CONF_RX_START_Field := 16#0#;
      --  Set this bit to enable slave receiver mode
      RX_SLAVE_MOD    : RX_CONF_RX_SLAVE_MOD_Field := 16#0#;
      --  unspecified
      Reserved_4_4    : ESP32_C3.Bit := 16#0#;
      --  Set this bit to enable receiver in mono mode
      RX_MONO         : RX_CONF_RX_MONO_Field := 16#0#;
      --  unspecified
      Reserved_6_6    : ESP32_C3.Bit := 16#0#;
      --  I2S Rx byte endian, 1: low addr value to high addr. 0: low addr with
      --  low addr value.
      RX_BIG_ENDIAN   : RX_CONF_RX_BIG_ENDIAN_Field := 16#0#;
      --  Set 1 to update I2S RX registers from APB clock domain to I2S RX
      --  clock domain. This bit will be cleared by hardware after update
      --  register done.
      RX_UPDATE       : RX_CONF_RX_UPDATE_Field := 16#0#;
      --  1: The first channel data value is valid in I2S RX mono mode. 0: The
      --  second channel data value is valid in I2S RX mono mode.
      RX_MONO_FST_VLD : RX_CONF_RX_MONO_FST_VLD_Field := 16#1#;
      --  I2S RX compress/decompress configuration bit. & 0 (atol): A-Law
      --  decompress, 1 (ltoa) : A-Law compress, 2 (utol) : u-Law decompress, 3
      --  (ltou) : u-Law compress. &
      RX_PCM_CONF     : RX_CONF_RX_PCM_CONF_Field := 16#1#;
      --  Set this bit to bypass Compress/Decompress module for received data.
      RX_PCM_BYPASS   : RX_CONF_RX_PCM_BYPASS_Field := 16#1#;
      --  0 : I2S Rx only stop when reg_rx_start is cleared. 1: Stop when
      --  reg_rx_start is 0 or in_suc_eof is 1. 2: Stop I2S RX when
      --  reg_rx_start is 0 or RX FIFO is full.
      RX_STOP_MODE    : RX_CONF_RX_STOP_MODE_Field := 16#0#;
      --  1: I2S RX left alignment mode. 0: I2S RX right alignment mode.
      RX_LEFT_ALIGN   : RX_CONF_RX_LEFT_ALIGN_Field := 16#1#;
      --  1: store 24 channel bits to 32 bits. 0:store 24 channel bits to 24
      --  bits.
      RX_24_FILL_EN   : RX_CONF_RX_24_FILL_EN_Field := 16#0#;
      --  0: WS should be 0 when receiving left channel data, and WS is 1in
      --  right channel. 1: WS should be 1 when receiving left channel data,
      --  and WS is 0in right channel.
      RX_WS_IDLE_POL  : RX_CONF_RX_WS_IDLE_POL_Field := 16#0#;
      --  I2S Rx bit endian. 1:small endian, the LSB is received first. 0:big
      --  endian, the MSB is received first.
      RX_BIT_ORDER    : RX_CONF_RX_BIT_ORDER_Field := 16#0#;
      --  1: Enable I2S TDM Rx mode . 0: Disable.
      RX_TDM_EN       : RX_CONF_RX_TDM_EN_Field := 16#0#;
      --  1: Enable I2S PDM Rx mode . 0: Disable.
      RX_PDM_EN       : RX_CONF_RX_PDM_EN_Field := 16#0#;
      --  unspecified
      Reserved_21_31  : ESP32_C3.UInt11 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RX_CONF_Register use record
      RX_RESET        at 0 range 0 .. 0;
      RX_FIFO_RESET   at 0 range 1 .. 1;
      RX_START        at 0 range 2 .. 2;
      RX_SLAVE_MOD    at 0 range 3 .. 3;
      Reserved_4_4    at 0 range 4 .. 4;
      RX_MONO         at 0 range 5 .. 5;
      Reserved_6_6    at 0 range 6 .. 6;
      RX_BIG_ENDIAN   at 0 range 7 .. 7;
      RX_UPDATE       at 0 range 8 .. 8;
      RX_MONO_FST_VLD at 0 range 9 .. 9;
      RX_PCM_CONF     at 0 range 10 .. 11;
      RX_PCM_BYPASS   at 0 range 12 .. 12;
      RX_STOP_MODE    at 0 range 13 .. 14;
      RX_LEFT_ALIGN   at 0 range 15 .. 15;
      RX_24_FILL_EN   at 0 range 16 .. 16;
      RX_WS_IDLE_POL  at 0 range 17 .. 17;
      RX_BIT_ORDER    at 0 range 18 .. 18;
      RX_TDM_EN       at 0 range 19 .. 19;
      RX_PDM_EN       at 0 range 20 .. 20;
      Reserved_21_31  at 0 range 21 .. 31;
   end record;

   subtype TX_CONF_TX_RESET_Field is ESP32_C3.Bit;
   subtype TX_CONF_TX_FIFO_RESET_Field is ESP32_C3.Bit;
   subtype TX_CONF_TX_START_Field is ESP32_C3.Bit;
   subtype TX_CONF_TX_SLAVE_MOD_Field is ESP32_C3.Bit;
   subtype TX_CONF_TX_MONO_Field is ESP32_C3.Bit;
   subtype TX_CONF_TX_CHAN_EQUAL_Field is ESP32_C3.Bit;
   subtype TX_CONF_TX_BIG_ENDIAN_Field is ESP32_C3.Bit;
   subtype TX_CONF_TX_UPDATE_Field is ESP32_C3.Bit;
   subtype TX_CONF_TX_MONO_FST_VLD_Field is ESP32_C3.Bit;
   subtype TX_CONF_TX_PCM_CONF_Field is ESP32_C3.UInt2;
   subtype TX_CONF_TX_PCM_BYPASS_Field is ESP32_C3.Bit;
   subtype TX_CONF_TX_STOP_EN_Field is ESP32_C3.Bit;
   subtype TX_CONF_TX_LEFT_ALIGN_Field is ESP32_C3.Bit;
   subtype TX_CONF_TX_24_FILL_EN_Field is ESP32_C3.Bit;
   subtype TX_CONF_TX_WS_IDLE_POL_Field is ESP32_C3.Bit;
   subtype TX_CONF_TX_BIT_ORDER_Field is ESP32_C3.Bit;
   subtype TX_CONF_TX_TDM_EN_Field is ESP32_C3.Bit;
   subtype TX_CONF_TX_PDM_EN_Field is ESP32_C3.Bit;
   subtype TX_CONF_TX_CHAN_MOD_Field is ESP32_C3.UInt3;
   subtype TX_CONF_SIG_LOOPBACK_Field is ESP32_C3.Bit;

   --  I2S TX configure register
   type TX_CONF_Register is record
      --  Write-only. Set this bit to reset transmitter
      TX_RESET        : TX_CONF_TX_RESET_Field := 16#0#;
      --  Write-only. Set this bit to reset Tx AFIFO
      TX_FIFO_RESET   : TX_CONF_TX_FIFO_RESET_Field := 16#0#;
      --  Set this bit to start transmitting data
      TX_START        : TX_CONF_TX_START_Field := 16#0#;
      --  Set this bit to enable slave transmitter mode
      TX_SLAVE_MOD    : TX_CONF_TX_SLAVE_MOD_Field := 16#0#;
      --  unspecified
      Reserved_4_4    : ESP32_C3.Bit := 16#0#;
      --  Set this bit to enable transmitter in mono mode
      TX_MONO         : TX_CONF_TX_MONO_Field := 16#0#;
      --  1: The value of Left channel data is equal to the value of right
      --  channel data in I2S TX mono mode or TDM channel select mode. 0: The
      --  invalid channel data is reg_i2s_single_data in I2S TX mono mode or
      --  TDM channel select mode.
      TX_CHAN_EQUAL   : TX_CONF_TX_CHAN_EQUAL_Field := 16#0#;
      --  I2S Tx byte endian, 1: low addr value to high addr. 0: low addr with
      --  low addr value.
      TX_BIG_ENDIAN   : TX_CONF_TX_BIG_ENDIAN_Field := 16#0#;
      --  Set 1 to update I2S TX registers from APB clock domain to I2S TX
      --  clock domain. This bit will be cleared by hardware after update
      --  register done.
      TX_UPDATE       : TX_CONF_TX_UPDATE_Field := 16#0#;
      --  1: The first channel data value is valid in I2S TX mono mode. 0: The
      --  second channel data value is valid in I2S TX mono mode.
      TX_MONO_FST_VLD : TX_CONF_TX_MONO_FST_VLD_Field := 16#1#;
      --  I2S TX compress/decompress configuration bit. & 0 (atol): A-Law
      --  decompress, 1 (ltoa) : A-Law compress, 2 (utol) : u-Law decompress, 3
      --  (ltou) : u-Law compress. &
      TX_PCM_CONF     : TX_CONF_TX_PCM_CONF_Field := 16#0#;
      --  Set this bit to bypass Compress/Decompress module for transmitted
      --  data.
      TX_PCM_BYPASS   : TX_CONF_TX_PCM_BYPASS_Field := 16#1#;
      --  Set this bit to stop disable output BCK signal and WS signal when tx
      --  FIFO is emtpy
      TX_STOP_EN      : TX_CONF_TX_STOP_EN_Field := 16#1#;
      --  unspecified
      Reserved_14_14  : ESP32_C3.Bit := 16#0#;
      --  1: I2S TX left alignment mode. 0: I2S TX right alignment mode.
      TX_LEFT_ALIGN   : TX_CONF_TX_LEFT_ALIGN_Field := 16#1#;
      --  1: Sent 32 bits in 24 channel bits mode. 0: Sent 24 bits in 24
      --  channel bits mode
      TX_24_FILL_EN   : TX_CONF_TX_24_FILL_EN_Field := 16#0#;
      --  0: WS should be 0 when sending left channel data, and WS is 1in right
      --  channel. 1: WS should be 1 when sending left channel data, and WS is
      --  0in right channel.
      TX_WS_IDLE_POL  : TX_CONF_TX_WS_IDLE_POL_Field := 16#0#;
      --  I2S Tx bit endian. 1:small endian, the LSB is sent first. 0:big
      --  endian, the MSB is sent first.
      TX_BIT_ORDER    : TX_CONF_TX_BIT_ORDER_Field := 16#0#;
      --  1: Enable I2S TDM Tx mode . 0: Disable.
      TX_TDM_EN       : TX_CONF_TX_TDM_EN_Field := 16#0#;
      --  1: Enable I2S PDM Tx mode . 0: Disable.
      TX_PDM_EN       : TX_CONF_TX_PDM_EN_Field := 16#0#;
      --  unspecified
      Reserved_21_23  : ESP32_C3.UInt3 := 16#0#;
      --  I2S transmitter channel mode configuration bits.
      TX_CHAN_MOD     : TX_CONF_TX_CHAN_MOD_Field := 16#0#;
      --  Enable signal loop back mode with transmitter module and receiver
      --  module sharing the same WS and BCK signals.
      SIG_LOOPBACK    : TX_CONF_SIG_LOOPBACK_Field := 16#0#;
      --  unspecified
      Reserved_28_31  : ESP32_C3.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TX_CONF_Register use record
      TX_RESET        at 0 range 0 .. 0;
      TX_FIFO_RESET   at 0 range 1 .. 1;
      TX_START        at 0 range 2 .. 2;
      TX_SLAVE_MOD    at 0 range 3 .. 3;
      Reserved_4_4    at 0 range 4 .. 4;
      TX_MONO         at 0 range 5 .. 5;
      TX_CHAN_EQUAL   at 0 range 6 .. 6;
      TX_BIG_ENDIAN   at 0 range 7 .. 7;
      TX_UPDATE       at 0 range 8 .. 8;
      TX_MONO_FST_VLD at 0 range 9 .. 9;
      TX_PCM_CONF     at 0 range 10 .. 11;
      TX_PCM_BYPASS   at 0 range 12 .. 12;
      TX_STOP_EN      at 0 range 13 .. 13;
      Reserved_14_14  at 0 range 14 .. 14;
      TX_LEFT_ALIGN   at 0 range 15 .. 15;
      TX_24_FILL_EN   at 0 range 16 .. 16;
      TX_WS_IDLE_POL  at 0 range 17 .. 17;
      TX_BIT_ORDER    at 0 range 18 .. 18;
      TX_TDM_EN       at 0 range 19 .. 19;
      TX_PDM_EN       at 0 range 20 .. 20;
      Reserved_21_23  at 0 range 21 .. 23;
      TX_CHAN_MOD     at 0 range 24 .. 26;
      SIG_LOOPBACK    at 0 range 27 .. 27;
      Reserved_28_31  at 0 range 28 .. 31;
   end record;

   subtype RX_CONF1_RX_TDM_WS_WIDTH_Field is ESP32_C3.UInt7;
   subtype RX_CONF1_RX_BCK_DIV_NUM_Field is ESP32_C3.UInt6;
   subtype RX_CONF1_RX_BITS_MOD_Field is ESP32_C3.UInt5;
   subtype RX_CONF1_RX_HALF_SAMPLE_BITS_Field is ESP32_C3.UInt6;
   subtype RX_CONF1_RX_TDM_CHAN_BITS_Field is ESP32_C3.UInt5;
   subtype RX_CONF1_RX_MSB_SHIFT_Field is ESP32_C3.Bit;

   --  I2S RX configure register 1
   type RX_CONF1_Register is record
      --  The width of rx_ws_out in TDM mode is (I2S_RX_TDM_WS_WIDTH[6:0] +1) *
      --  T_bck
      RX_TDM_WS_WIDTH     : RX_CONF1_RX_TDM_WS_WIDTH_Field := 16#0#;
      --  Bit clock configuration bits in receiver mode.
      RX_BCK_DIV_NUM      : RX_CONF1_RX_BCK_DIV_NUM_Field := 16#6#;
      --  Set the bits to configure the valid data bit length of I2S receiver
      --  channel. 7: all the valid channel data is in 8-bit-mode. 15: all the
      --  valid channel data is in 16-bit-mode. 23: all the valid channel data
      --  is in 24-bit-mode. 31:all the valid channel data is in 32-bit-mode.
      RX_BITS_MOD         : RX_CONF1_RX_BITS_MOD_Field := 16#F#;
      --  I2S Rx half sample bits -1.
      RX_HALF_SAMPLE_BITS : RX_CONF1_RX_HALF_SAMPLE_BITS_Field := 16#F#;
      --  The Rx bit number for each channel minus 1in TDM mode.
      RX_TDM_CHAN_BITS    : RX_CONF1_RX_TDM_CHAN_BITS_Field := 16#F#;
      --  Set this bit to enable receiver in Phillips standard mode
      RX_MSB_SHIFT        : RX_CONF1_RX_MSB_SHIFT_Field := 16#1#;
      --  unspecified
      Reserved_30_31      : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RX_CONF1_Register use record
      RX_TDM_WS_WIDTH     at 0 range 0 .. 6;
      RX_BCK_DIV_NUM      at 0 range 7 .. 12;
      RX_BITS_MOD         at 0 range 13 .. 17;
      RX_HALF_SAMPLE_BITS at 0 range 18 .. 23;
      RX_TDM_CHAN_BITS    at 0 range 24 .. 28;
      RX_MSB_SHIFT        at 0 range 29 .. 29;
      Reserved_30_31      at 0 range 30 .. 31;
   end record;

   subtype TX_CONF1_TX_TDM_WS_WIDTH_Field is ESP32_C3.UInt7;
   subtype TX_CONF1_TX_BCK_DIV_NUM_Field is ESP32_C3.UInt6;
   subtype TX_CONF1_TX_BITS_MOD_Field is ESP32_C3.UInt5;
   subtype TX_CONF1_TX_HALF_SAMPLE_BITS_Field is ESP32_C3.UInt6;
   subtype TX_CONF1_TX_TDM_CHAN_BITS_Field is ESP32_C3.UInt5;
   subtype TX_CONF1_TX_MSB_SHIFT_Field is ESP32_C3.Bit;
   subtype TX_CONF1_TX_BCK_NO_DLY_Field is ESP32_C3.Bit;

   --  I2S TX configure register 1
   type TX_CONF1_Register is record
      --  The width of tx_ws_out in TDM mode is (I2S_TX_TDM_WS_WIDTH[6:0] +1) *
      --  T_bck
      TX_TDM_WS_WIDTH     : TX_CONF1_TX_TDM_WS_WIDTH_Field := 16#0#;
      --  Bit clock configuration bits in transmitter mode.
      TX_BCK_DIV_NUM      : TX_CONF1_TX_BCK_DIV_NUM_Field := 16#6#;
      --  Set the bits to configure the valid data bit length of I2S
      --  transmitter channel. 7: all the valid channel data is in 8-bit-mode.
      --  15: all the valid channel data is in 16-bit-mode. 23: all the valid
      --  channel data is in 24-bit-mode. 31:all the valid channel data is in
      --  32-bit-mode.
      TX_BITS_MOD         : TX_CONF1_TX_BITS_MOD_Field := 16#F#;
      --  I2S Tx half sample bits -1.
      TX_HALF_SAMPLE_BITS : TX_CONF1_TX_HALF_SAMPLE_BITS_Field := 16#F#;
      --  The Tx bit number for each channel minus 1in TDM mode.
      TX_TDM_CHAN_BITS    : TX_CONF1_TX_TDM_CHAN_BITS_Field := 16#F#;
      --  Set this bit to enable transmitter in Phillips standard mode
      TX_MSB_SHIFT        : TX_CONF1_TX_MSB_SHIFT_Field := 16#1#;
      --  1: BCK is not delayed to generate pos/neg edge in master mode. 0: BCK
      --  is delayed to generate pos/neg edge in master mode.
      TX_BCK_NO_DLY       : TX_CONF1_TX_BCK_NO_DLY_Field := 16#1#;
      --  unspecified
      Reserved_31_31      : ESP32_C3.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TX_CONF1_Register use record
      TX_TDM_WS_WIDTH     at 0 range 0 .. 6;
      TX_BCK_DIV_NUM      at 0 range 7 .. 12;
      TX_BITS_MOD         at 0 range 13 .. 17;
      TX_HALF_SAMPLE_BITS at 0 range 18 .. 23;
      TX_TDM_CHAN_BITS    at 0 range 24 .. 28;
      TX_MSB_SHIFT        at 0 range 29 .. 29;
      TX_BCK_NO_DLY       at 0 range 30 .. 30;
      Reserved_31_31      at 0 range 31 .. 31;
   end record;

   subtype RX_CLKM_CONF_RX_CLKM_DIV_NUM_Field is ESP32_C3.Byte;
   subtype RX_CLKM_CONF_RX_CLK_ACTIVE_Field is ESP32_C3.Bit;
   subtype RX_CLKM_CONF_RX_CLK_SEL_Field is ESP32_C3.UInt2;
   subtype RX_CLKM_CONF_MCLK_SEL_Field is ESP32_C3.Bit;

   --  I2S RX clock configure register
   type RX_CLKM_CONF_Register is record
      --  Integral I2S clock divider value
      RX_CLKM_DIV_NUM : RX_CLKM_CONF_RX_CLKM_DIV_NUM_Field := 16#2#;
      --  unspecified
      Reserved_8_25   : ESP32_C3.UInt18 := 16#0#;
      --  I2S Rx module clock enable signal.
      RX_CLK_ACTIVE   : RX_CLKM_CONF_RX_CLK_ACTIVE_Field := 16#0#;
      --  Select I2S Rx module source clock. 0: no clock. 1: APLL. 2: CLK160.
      --  3: I2S_MCLK_in.
      RX_CLK_SEL      : RX_CLKM_CONF_RX_CLK_SEL_Field := 16#0#;
      --  0: UseI2S Tx module clock as I2S_MCLK_OUT. 1: UseI2S Rx module clock
      --  as I2S_MCLK_OUT.
      MCLK_SEL        : RX_CLKM_CONF_MCLK_SEL_Field := 16#0#;
      --  unspecified
      Reserved_30_31  : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RX_CLKM_CONF_Register use record
      RX_CLKM_DIV_NUM at 0 range 0 .. 7;
      Reserved_8_25   at 0 range 8 .. 25;
      RX_CLK_ACTIVE   at 0 range 26 .. 26;
      RX_CLK_SEL      at 0 range 27 .. 28;
      MCLK_SEL        at 0 range 29 .. 29;
      Reserved_30_31  at 0 range 30 .. 31;
   end record;

   subtype TX_CLKM_CONF_TX_CLKM_DIV_NUM_Field is ESP32_C3.Byte;
   subtype TX_CLKM_CONF_TX_CLK_ACTIVE_Field is ESP32_C3.Bit;
   subtype TX_CLKM_CONF_TX_CLK_SEL_Field is ESP32_C3.UInt2;
   subtype TX_CLKM_CONF_CLK_EN_Field is ESP32_C3.Bit;

   --  I2S TX clock configure register
   type TX_CLKM_CONF_Register is record
      --  Integral I2S TX clock divider value. f_I2S_CLK = f_I2S_CLK_S/(N+b/a).
      --  There will be (a-b) * n-div and b * (n+1)-div. So the average
      --  combination will be: for b <= a/2, z * [x * n-div + (n+1)-div] + y *
      --  n-div. For b > a/2, z * [n-div + x * (n+1)-div] + y * (n+1)-div.
      TX_CLKM_DIV_NUM : TX_CLKM_CONF_TX_CLKM_DIV_NUM_Field := 16#2#;
      --  unspecified
      Reserved_8_25   : ESP32_C3.UInt18 := 16#0#;
      --  I2S Tx module clock enable signal.
      TX_CLK_ACTIVE   : TX_CLKM_CONF_TX_CLK_ACTIVE_Field := 16#0#;
      --  Select I2S Tx module source clock. 0: XTAL clock. 1: APLL. 2: CLK160.
      --  3: I2S_MCLK_in.
      TX_CLK_SEL      : TX_CLKM_CONF_TX_CLK_SEL_Field := 16#0#;
      --  Set this bit to enable clk gate
      CLK_EN          : TX_CLKM_CONF_CLK_EN_Field := 16#0#;
      --  unspecified
      Reserved_30_31  : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TX_CLKM_CONF_Register use record
      TX_CLKM_DIV_NUM at 0 range 0 .. 7;
      Reserved_8_25   at 0 range 8 .. 25;
      TX_CLK_ACTIVE   at 0 range 26 .. 26;
      TX_CLK_SEL      at 0 range 27 .. 28;
      CLK_EN          at 0 range 29 .. 29;
      Reserved_30_31  at 0 range 30 .. 31;
   end record;

   subtype RX_CLKM_DIV_CONF_RX_CLKM_DIV_Z_Field is ESP32_C3.UInt9;
   subtype RX_CLKM_DIV_CONF_RX_CLKM_DIV_Y_Field is ESP32_C3.UInt9;
   subtype RX_CLKM_DIV_CONF_RX_CLKM_DIV_X_Field is ESP32_C3.UInt9;
   subtype RX_CLKM_DIV_CONF_RX_CLKM_DIV_YN1_Field is ESP32_C3.Bit;

   --  I2S RX module clock divider configure register
   type RX_CLKM_DIV_CONF_Register is record
      --  For b <= a/2, the value of I2S_RX_CLKM_DIV_Z is b. For b > a/2, the
      --  value of I2S_RX_CLKM_DIV_Z is (a-b).
      RX_CLKM_DIV_Z   : RX_CLKM_DIV_CONF_RX_CLKM_DIV_Z_Field := 16#0#;
      --  For b <= a/2, the value of I2S_RX_CLKM_DIV_Y is (a%b) . For b > a/2,
      --  the value of I2S_RX_CLKM_DIV_Y is (a%(a-b)).
      RX_CLKM_DIV_Y   : RX_CLKM_DIV_CONF_RX_CLKM_DIV_Y_Field := 16#1#;
      --  For b <= a/2, the value of I2S_RX_CLKM_DIV_X is (a/b) - 1. For b >
      --  a/2, the value of I2S_RX_CLKM_DIV_X is (a/(a-b)) - 1.
      RX_CLKM_DIV_X   : RX_CLKM_DIV_CONF_RX_CLKM_DIV_X_Field := 16#0#;
      --  For b <= a/2, the value of I2S_RX_CLKM_DIV_YN1 is 0 . For b > a/2,
      --  the value of I2S_RX_CLKM_DIV_YN1 is 1.
      RX_CLKM_DIV_YN1 : RX_CLKM_DIV_CONF_RX_CLKM_DIV_YN1_Field := 16#0#;
      --  unspecified
      Reserved_28_31  : ESP32_C3.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RX_CLKM_DIV_CONF_Register use record
      RX_CLKM_DIV_Z   at 0 range 0 .. 8;
      RX_CLKM_DIV_Y   at 0 range 9 .. 17;
      RX_CLKM_DIV_X   at 0 range 18 .. 26;
      RX_CLKM_DIV_YN1 at 0 range 27 .. 27;
      Reserved_28_31  at 0 range 28 .. 31;
   end record;

   subtype TX_CLKM_DIV_CONF_TX_CLKM_DIV_Z_Field is ESP32_C3.UInt9;
   subtype TX_CLKM_DIV_CONF_TX_CLKM_DIV_Y_Field is ESP32_C3.UInt9;
   subtype TX_CLKM_DIV_CONF_TX_CLKM_DIV_X_Field is ESP32_C3.UInt9;
   subtype TX_CLKM_DIV_CONF_TX_CLKM_DIV_YN1_Field is ESP32_C3.Bit;

   --  I2S TX module clock divider configure register
   type TX_CLKM_DIV_CONF_Register is record
      --  For b <= a/2, the value of I2S_TX_CLKM_DIV_Z is b. For b > a/2, the
      --  value of I2S_TX_CLKM_DIV_Z is (a-b).
      TX_CLKM_DIV_Z   : TX_CLKM_DIV_CONF_TX_CLKM_DIV_Z_Field := 16#0#;
      --  For b <= a/2, the value of I2S_TX_CLKM_DIV_Y is (a%b) . For b > a/2,
      --  the value of I2S_TX_CLKM_DIV_Y is (a%(a-b)).
      TX_CLKM_DIV_Y   : TX_CLKM_DIV_CONF_TX_CLKM_DIV_Y_Field := 16#1#;
      --  For b <= a/2, the value of I2S_TX_CLKM_DIV_X is (a/b) - 1. For b >
      --  a/2, the value of I2S_TX_CLKM_DIV_X is (a/(a-b)) - 1.
      TX_CLKM_DIV_X   : TX_CLKM_DIV_CONF_TX_CLKM_DIV_X_Field := 16#0#;
      --  For b <= a/2, the value of I2S_TX_CLKM_DIV_YN1 is 0 . For b > a/2,
      --  the value of I2S_TX_CLKM_DIV_YN1 is 1.
      TX_CLKM_DIV_YN1 : TX_CLKM_DIV_CONF_TX_CLKM_DIV_YN1_Field := 16#0#;
      --  unspecified
      Reserved_28_31  : ESP32_C3.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TX_CLKM_DIV_CONF_Register use record
      TX_CLKM_DIV_Z   at 0 range 0 .. 8;
      TX_CLKM_DIV_Y   at 0 range 9 .. 17;
      TX_CLKM_DIV_X   at 0 range 18 .. 26;
      TX_CLKM_DIV_YN1 at 0 range 27 .. 27;
      Reserved_28_31  at 0 range 28 .. 31;
   end record;

   subtype TX_PCM2PDM_CONF_TX_PDM_HP_BYPASS_Field is ESP32_C3.Bit;
   subtype TX_PCM2PDM_CONF_TX_PDM_SINC_OSR2_Field is ESP32_C3.UInt4;
   subtype TX_PCM2PDM_CONF_TX_PDM_PRESCALE_Field is ESP32_C3.Byte;
   subtype TX_PCM2PDM_CONF_TX_PDM_HP_IN_SHIFT_Field is ESP32_C3.UInt2;
   subtype TX_PCM2PDM_CONF_TX_PDM_LP_IN_SHIFT_Field is ESP32_C3.UInt2;
   subtype TX_PCM2PDM_CONF_TX_PDM_SINC_IN_SHIFT_Field is ESP32_C3.UInt2;
   subtype TX_PCM2PDM_CONF_TX_PDM_SIGMADELTA_IN_SHIFT_Field is ESP32_C3.UInt2;
   subtype TX_PCM2PDM_CONF_TX_PDM_SIGMADELTA_DITHER2_Field is ESP32_C3.Bit;
   subtype TX_PCM2PDM_CONF_TX_PDM_SIGMADELTA_DITHER_Field is ESP32_C3.Bit;
   subtype TX_PCM2PDM_CONF_TX_PDM_DAC_2OUT_EN_Field is ESP32_C3.Bit;
   subtype TX_PCM2PDM_CONF_TX_PDM_DAC_MODE_EN_Field is ESP32_C3.Bit;
   subtype TX_PCM2PDM_CONF_PCM2PDM_CONV_EN_Field is ESP32_C3.Bit;

   --  I2S TX PCM2PDM configuration register
   type TX_PCM2PDM_CONF_Register is record
      --  I2S TX PDM bypass hp filter or not. The option has been removed.
      TX_PDM_HP_BYPASS           : TX_PCM2PDM_CONF_TX_PDM_HP_BYPASS_Field :=
                                    16#0#;
      --  I2S TX PDM OSR2 value
      TX_PDM_SINC_OSR2           : TX_PCM2PDM_CONF_TX_PDM_SINC_OSR2_Field :=
                                    16#2#;
      --  I2S TX PDM prescale for sigmadelta
      TX_PDM_PRESCALE            : TX_PCM2PDM_CONF_TX_PDM_PRESCALE_Field :=
                                    16#0#;
      --  I2S TX PDM sigmadelta scale shift number: 0:/2 , 1:x1 , 2:x2 , 3: x4
      TX_PDM_HP_IN_SHIFT         : TX_PCM2PDM_CONF_TX_PDM_HP_IN_SHIFT_Field :=
                                    16#1#;
      --  I2S TX PDM sigmadelta scale shift number: 0:/2 , 1:x1 , 2:x2 , 3: x4
      TX_PDM_LP_IN_SHIFT         : TX_PCM2PDM_CONF_TX_PDM_LP_IN_SHIFT_Field :=
                                    16#1#;
      --  I2S TX PDM sigmadelta scale shift number: 0:/2 , 1:x1 , 2:x2 , 3: x4
      TX_PDM_SINC_IN_SHIFT       : TX_PCM2PDM_CONF_TX_PDM_SINC_IN_SHIFT_Field :=
                                    16#1#;
      --  I2S TX PDM sigmadelta scale shift number: 0:/2 , 1:x1 , 2:x2 , 3: x4
      TX_PDM_SIGMADELTA_IN_SHIFT : TX_PCM2PDM_CONF_TX_PDM_SIGMADELTA_IN_SHIFT_Field :=
                                    16#1#;
      --  I2S TX PDM sigmadelta dither2 value
      TX_PDM_SIGMADELTA_DITHER2  : TX_PCM2PDM_CONF_TX_PDM_SIGMADELTA_DITHER2_Field :=
                                    16#0#;
      --  I2S TX PDM sigmadelta dither value
      TX_PDM_SIGMADELTA_DITHER   : TX_PCM2PDM_CONF_TX_PDM_SIGMADELTA_DITHER_Field :=
                                    16#1#;
      --  I2S TX PDM dac mode enable
      TX_PDM_DAC_2OUT_EN         : TX_PCM2PDM_CONF_TX_PDM_DAC_2OUT_EN_Field :=
                                    16#0#;
      --  I2S TX PDM dac 2channel enable
      TX_PDM_DAC_MODE_EN         : TX_PCM2PDM_CONF_TX_PDM_DAC_MODE_EN_Field :=
                                    16#0#;
      --  I2S TX PDM Converter enable
      PCM2PDM_CONV_EN            : TX_PCM2PDM_CONF_PCM2PDM_CONV_EN_Field :=
                                    16#0#;
      --  unspecified
      Reserved_26_31             : ESP32_C3.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TX_PCM2PDM_CONF_Register use record
      TX_PDM_HP_BYPASS           at 0 range 0 .. 0;
      TX_PDM_SINC_OSR2           at 0 range 1 .. 4;
      TX_PDM_PRESCALE            at 0 range 5 .. 12;
      TX_PDM_HP_IN_SHIFT         at 0 range 13 .. 14;
      TX_PDM_LP_IN_SHIFT         at 0 range 15 .. 16;
      TX_PDM_SINC_IN_SHIFT       at 0 range 17 .. 18;
      TX_PDM_SIGMADELTA_IN_SHIFT at 0 range 19 .. 20;
      TX_PDM_SIGMADELTA_DITHER2  at 0 range 21 .. 21;
      TX_PDM_SIGMADELTA_DITHER   at 0 range 22 .. 22;
      TX_PDM_DAC_2OUT_EN         at 0 range 23 .. 23;
      TX_PDM_DAC_MODE_EN         at 0 range 24 .. 24;
      PCM2PDM_CONV_EN            at 0 range 25 .. 25;
      Reserved_26_31             at 0 range 26 .. 31;
   end record;

   subtype TX_PCM2PDM_CONF1_TX_PDM_FP_Field is ESP32_C3.UInt10;
   subtype TX_PCM2PDM_CONF1_TX_PDM_FS_Field is ESP32_C3.UInt10;
   subtype TX_PCM2PDM_CONF1_TX_IIR_HP_MULT12_5_Field is ESP32_C3.UInt3;
   subtype TX_PCM2PDM_CONF1_TX_IIR_HP_MULT12_0_Field is ESP32_C3.UInt3;

   --  I2S TX PCM2PDM configuration register
   type TX_PCM2PDM_CONF1_Register is record
      --  I2S TX PDM Fp
      TX_PDM_FP          : TX_PCM2PDM_CONF1_TX_PDM_FP_Field := 16#3C0#;
      --  I2S TX PDM Fs
      TX_PDM_FS          : TX_PCM2PDM_CONF1_TX_PDM_FS_Field := 16#1E0#;
      --  The fourth parameter of PDM TX IIR_HP filter stage 2 is (504 +
      --  I2S_TX_IIR_HP_MULT12_5[2:0])
      TX_IIR_HP_MULT12_5 : TX_PCM2PDM_CONF1_TX_IIR_HP_MULT12_5_Field := 16#7#;
      --  The fourth parameter of PDM TX IIR_HP filter stage 1 is (504 +
      --  I2S_TX_IIR_HP_MULT12_0[2:0])
      TX_IIR_HP_MULT12_0 : TX_PCM2PDM_CONF1_TX_IIR_HP_MULT12_0_Field := 16#7#;
      --  unspecified
      Reserved_26_31     : ESP32_C3.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TX_PCM2PDM_CONF1_Register use record
      TX_PDM_FP          at 0 range 0 .. 9;
      TX_PDM_FS          at 0 range 10 .. 19;
      TX_IIR_HP_MULT12_5 at 0 range 20 .. 22;
      TX_IIR_HP_MULT12_0 at 0 range 23 .. 25;
      Reserved_26_31     at 0 range 26 .. 31;
   end record;

   subtype RX_TDM_CTRL_RX_TDM_PDM_CHAN0_EN_Field is ESP32_C3.Bit;
   subtype RX_TDM_CTRL_RX_TDM_PDM_CHAN1_EN_Field is ESP32_C3.Bit;
   subtype RX_TDM_CTRL_RX_TDM_PDM_CHAN2_EN_Field is ESP32_C3.Bit;
   subtype RX_TDM_CTRL_RX_TDM_PDM_CHAN3_EN_Field is ESP32_C3.Bit;
   subtype RX_TDM_CTRL_RX_TDM_PDM_CHAN4_EN_Field is ESP32_C3.Bit;
   subtype RX_TDM_CTRL_RX_TDM_PDM_CHAN5_EN_Field is ESP32_C3.Bit;
   subtype RX_TDM_CTRL_RX_TDM_PDM_CHAN6_EN_Field is ESP32_C3.Bit;
   subtype RX_TDM_CTRL_RX_TDM_PDM_CHAN7_EN_Field is ESP32_C3.Bit;
   subtype RX_TDM_CTRL_RX_TDM_CHAN8_EN_Field is ESP32_C3.Bit;
   subtype RX_TDM_CTRL_RX_TDM_CHAN9_EN_Field is ESP32_C3.Bit;
   subtype RX_TDM_CTRL_RX_TDM_CHAN10_EN_Field is ESP32_C3.Bit;
   subtype RX_TDM_CTRL_RX_TDM_CHAN11_EN_Field is ESP32_C3.Bit;
   subtype RX_TDM_CTRL_RX_TDM_CHAN12_EN_Field is ESP32_C3.Bit;
   subtype RX_TDM_CTRL_RX_TDM_CHAN13_EN_Field is ESP32_C3.Bit;
   subtype RX_TDM_CTRL_RX_TDM_CHAN14_EN_Field is ESP32_C3.Bit;
   subtype RX_TDM_CTRL_RX_TDM_CHAN15_EN_Field is ESP32_C3.Bit;
   subtype RX_TDM_CTRL_RX_TDM_TOT_CHAN_NUM_Field is ESP32_C3.UInt4;

   --  I2S TX TDM mode control register
   type RX_TDM_CTRL_Register is record
      --  1: Enable the valid data input of I2S RX TDM or PDM channel 0. 0:
      --  Disable, just input 0 in this channel.
      RX_TDM_PDM_CHAN0_EN : RX_TDM_CTRL_RX_TDM_PDM_CHAN0_EN_Field := 16#1#;
      --  1: Enable the valid data input of I2S RX TDM or PDM channel 1. 0:
      --  Disable, just input 0 in this channel.
      RX_TDM_PDM_CHAN1_EN : RX_TDM_CTRL_RX_TDM_PDM_CHAN1_EN_Field := 16#1#;
      --  1: Enable the valid data input of I2S RX TDM or PDM channel 2. 0:
      --  Disable, just input 0 in this channel.
      RX_TDM_PDM_CHAN2_EN : RX_TDM_CTRL_RX_TDM_PDM_CHAN2_EN_Field := 16#1#;
      --  1: Enable the valid data input of I2S RX TDM or PDM channel 3. 0:
      --  Disable, just input 0 in this channel.
      RX_TDM_PDM_CHAN3_EN : RX_TDM_CTRL_RX_TDM_PDM_CHAN3_EN_Field := 16#1#;
      --  1: Enable the valid data input of I2S RX TDM or PDM channel 4. 0:
      --  Disable, just input 0 in this channel.
      RX_TDM_PDM_CHAN4_EN : RX_TDM_CTRL_RX_TDM_PDM_CHAN4_EN_Field := 16#1#;
      --  1: Enable the valid data input of I2S RX TDM or PDM channel 5. 0:
      --  Disable, just input 0 in this channel.
      RX_TDM_PDM_CHAN5_EN : RX_TDM_CTRL_RX_TDM_PDM_CHAN5_EN_Field := 16#1#;
      --  1: Enable the valid data input of I2S RX TDM or PDM channel 6. 0:
      --  Disable, just input 0 in this channel.
      RX_TDM_PDM_CHAN6_EN : RX_TDM_CTRL_RX_TDM_PDM_CHAN6_EN_Field := 16#1#;
      --  1: Enable the valid data input of I2S RX TDM or PDM channel 7. 0:
      --  Disable, just input 0 in this channel.
      RX_TDM_PDM_CHAN7_EN : RX_TDM_CTRL_RX_TDM_PDM_CHAN7_EN_Field := 16#1#;
      --  1: Enable the valid data input of I2S RX TDM channel 8. 0: Disable,
      --  just input 0 in this channel.
      RX_TDM_CHAN8_EN     : RX_TDM_CTRL_RX_TDM_CHAN8_EN_Field := 16#1#;
      --  1: Enable the valid data input of I2S RX TDM channel 9. 0: Disable,
      --  just input 0 in this channel.
      RX_TDM_CHAN9_EN     : RX_TDM_CTRL_RX_TDM_CHAN9_EN_Field := 16#1#;
      --  1: Enable the valid data input of I2S RX TDM channel 10. 0: Disable,
      --  just input 0 in this channel.
      RX_TDM_CHAN10_EN    : RX_TDM_CTRL_RX_TDM_CHAN10_EN_Field := 16#1#;
      --  1: Enable the valid data input of I2S RX TDM channel 11. 0: Disable,
      --  just input 0 in this channel.
      RX_TDM_CHAN11_EN    : RX_TDM_CTRL_RX_TDM_CHAN11_EN_Field := 16#1#;
      --  1: Enable the valid data input of I2S RX TDM channel 12. 0: Disable,
      --  just input 0 in this channel.
      RX_TDM_CHAN12_EN    : RX_TDM_CTRL_RX_TDM_CHAN12_EN_Field := 16#1#;
      --  1: Enable the valid data input of I2S RX TDM channel 13. 0: Disable,
      --  just input 0 in this channel.
      RX_TDM_CHAN13_EN    : RX_TDM_CTRL_RX_TDM_CHAN13_EN_Field := 16#1#;
      --  1: Enable the valid data input of I2S RX TDM channel 14. 0: Disable,
      --  just input 0 in this channel.
      RX_TDM_CHAN14_EN    : RX_TDM_CTRL_RX_TDM_CHAN14_EN_Field := 16#1#;
      --  1: Enable the valid data input of I2S RX TDM channel 15. 0: Disable,
      --  just input 0 in this channel.
      RX_TDM_CHAN15_EN    : RX_TDM_CTRL_RX_TDM_CHAN15_EN_Field := 16#1#;
      --  The total channel number of I2S TX TDM mode.
      RX_TDM_TOT_CHAN_NUM : RX_TDM_CTRL_RX_TDM_TOT_CHAN_NUM_Field := 16#0#;
      --  unspecified
      Reserved_20_31      : ESP32_C3.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RX_TDM_CTRL_Register use record
      RX_TDM_PDM_CHAN0_EN at 0 range 0 .. 0;
      RX_TDM_PDM_CHAN1_EN at 0 range 1 .. 1;
      RX_TDM_PDM_CHAN2_EN at 0 range 2 .. 2;
      RX_TDM_PDM_CHAN3_EN at 0 range 3 .. 3;
      RX_TDM_PDM_CHAN4_EN at 0 range 4 .. 4;
      RX_TDM_PDM_CHAN5_EN at 0 range 5 .. 5;
      RX_TDM_PDM_CHAN6_EN at 0 range 6 .. 6;
      RX_TDM_PDM_CHAN7_EN at 0 range 7 .. 7;
      RX_TDM_CHAN8_EN     at 0 range 8 .. 8;
      RX_TDM_CHAN9_EN     at 0 range 9 .. 9;
      RX_TDM_CHAN10_EN    at 0 range 10 .. 10;
      RX_TDM_CHAN11_EN    at 0 range 11 .. 11;
      RX_TDM_CHAN12_EN    at 0 range 12 .. 12;
      RX_TDM_CHAN13_EN    at 0 range 13 .. 13;
      RX_TDM_CHAN14_EN    at 0 range 14 .. 14;
      RX_TDM_CHAN15_EN    at 0 range 15 .. 15;
      RX_TDM_TOT_CHAN_NUM at 0 range 16 .. 19;
      Reserved_20_31      at 0 range 20 .. 31;
   end record;

   subtype TX_TDM_CTRL_TX_TDM_CHAN0_EN_Field is ESP32_C3.Bit;
   subtype TX_TDM_CTRL_TX_TDM_CHAN1_EN_Field is ESP32_C3.Bit;
   subtype TX_TDM_CTRL_TX_TDM_CHAN2_EN_Field is ESP32_C3.Bit;
   subtype TX_TDM_CTRL_TX_TDM_CHAN3_EN_Field is ESP32_C3.Bit;
   subtype TX_TDM_CTRL_TX_TDM_CHAN4_EN_Field is ESP32_C3.Bit;
   subtype TX_TDM_CTRL_TX_TDM_CHAN5_EN_Field is ESP32_C3.Bit;
   subtype TX_TDM_CTRL_TX_TDM_CHAN6_EN_Field is ESP32_C3.Bit;
   subtype TX_TDM_CTRL_TX_TDM_CHAN7_EN_Field is ESP32_C3.Bit;
   subtype TX_TDM_CTRL_TX_TDM_CHAN8_EN_Field is ESP32_C3.Bit;
   subtype TX_TDM_CTRL_TX_TDM_CHAN9_EN_Field is ESP32_C3.Bit;
   subtype TX_TDM_CTRL_TX_TDM_CHAN10_EN_Field is ESP32_C3.Bit;
   subtype TX_TDM_CTRL_TX_TDM_CHAN11_EN_Field is ESP32_C3.Bit;
   subtype TX_TDM_CTRL_TX_TDM_CHAN12_EN_Field is ESP32_C3.Bit;
   subtype TX_TDM_CTRL_TX_TDM_CHAN13_EN_Field is ESP32_C3.Bit;
   subtype TX_TDM_CTRL_TX_TDM_CHAN14_EN_Field is ESP32_C3.Bit;
   subtype TX_TDM_CTRL_TX_TDM_CHAN15_EN_Field is ESP32_C3.Bit;
   subtype TX_TDM_CTRL_TX_TDM_TOT_CHAN_NUM_Field is ESP32_C3.UInt4;
   subtype TX_TDM_CTRL_TX_TDM_SKIP_MSK_EN_Field is ESP32_C3.Bit;

   --  I2S TX TDM mode control register
   type TX_TDM_CTRL_Register is record
      --  1: Enable the valid data output of I2S TX TDM channel 0. 0: Disable,
      --  just output 0 in this channel.
      TX_TDM_CHAN0_EN     : TX_TDM_CTRL_TX_TDM_CHAN0_EN_Field := 16#1#;
      --  1: Enable the valid data output of I2S TX TDM channel 1. 0: Disable,
      --  just output 0 in this channel.
      TX_TDM_CHAN1_EN     : TX_TDM_CTRL_TX_TDM_CHAN1_EN_Field := 16#1#;
      --  1: Enable the valid data output of I2S TX TDM channel 2. 0: Disable,
      --  just output 0 in this channel.
      TX_TDM_CHAN2_EN     : TX_TDM_CTRL_TX_TDM_CHAN2_EN_Field := 16#1#;
      --  1: Enable the valid data output of I2S TX TDM channel 3. 0: Disable,
      --  just output 0 in this channel.
      TX_TDM_CHAN3_EN     : TX_TDM_CTRL_TX_TDM_CHAN3_EN_Field := 16#1#;
      --  1: Enable the valid data output of I2S TX TDM channel 4. 0: Disable,
      --  just output 0 in this channel.
      TX_TDM_CHAN4_EN     : TX_TDM_CTRL_TX_TDM_CHAN4_EN_Field := 16#1#;
      --  1: Enable the valid data output of I2S TX TDM channel 5. 0: Disable,
      --  just output 0 in this channel.
      TX_TDM_CHAN5_EN     : TX_TDM_CTRL_TX_TDM_CHAN5_EN_Field := 16#1#;
      --  1: Enable the valid data output of I2S TX TDM channel 6. 0: Disable,
      --  just output 0 in this channel.
      TX_TDM_CHAN6_EN     : TX_TDM_CTRL_TX_TDM_CHAN6_EN_Field := 16#1#;
      --  1: Enable the valid data output of I2S TX TDM channel 7. 0: Disable,
      --  just output 0 in this channel.
      TX_TDM_CHAN7_EN     : TX_TDM_CTRL_TX_TDM_CHAN7_EN_Field := 16#1#;
      --  1: Enable the valid data output of I2S TX TDM channel 8. 0: Disable,
      --  just output 0 in this channel.
      TX_TDM_CHAN8_EN     : TX_TDM_CTRL_TX_TDM_CHAN8_EN_Field := 16#1#;
      --  1: Enable the valid data output of I2S TX TDM channel 9. 0: Disable,
      --  just output 0 in this channel.
      TX_TDM_CHAN9_EN     : TX_TDM_CTRL_TX_TDM_CHAN9_EN_Field := 16#1#;
      --  1: Enable the valid data output of I2S TX TDM channel 10. 0: Disable,
      --  just output 0 in this channel.
      TX_TDM_CHAN10_EN    : TX_TDM_CTRL_TX_TDM_CHAN10_EN_Field := 16#1#;
      --  1: Enable the valid data output of I2S TX TDM channel 11. 0: Disable,
      --  just output 0 in this channel.
      TX_TDM_CHAN11_EN    : TX_TDM_CTRL_TX_TDM_CHAN11_EN_Field := 16#1#;
      --  1: Enable the valid data output of I2S TX TDM channel 12. 0: Disable,
      --  just output 0 in this channel.
      TX_TDM_CHAN12_EN    : TX_TDM_CTRL_TX_TDM_CHAN12_EN_Field := 16#1#;
      --  1: Enable the valid data output of I2S TX TDM channel 13. 0: Disable,
      --  just output 0 in this channel.
      TX_TDM_CHAN13_EN    : TX_TDM_CTRL_TX_TDM_CHAN13_EN_Field := 16#1#;
      --  1: Enable the valid data output of I2S TX TDM channel 14. 0: Disable,
      --  just output 0 in this channel.
      TX_TDM_CHAN14_EN    : TX_TDM_CTRL_TX_TDM_CHAN14_EN_Field := 16#1#;
      --  1: Enable the valid data output of I2S TX TDM channel 15. 0: Disable,
      --  just output 0 in this channel.
      TX_TDM_CHAN15_EN    : TX_TDM_CTRL_TX_TDM_CHAN15_EN_Field := 16#1#;
      --  The total channel number of I2S TX TDM mode.
      TX_TDM_TOT_CHAN_NUM : TX_TDM_CTRL_TX_TDM_TOT_CHAN_NUM_Field := 16#0#;
      --  When DMA TX buffer stores the data of (REG_TX_TDM_TOT_CHAN_NUM + 1)
      --  channels, and only the data of the enabled channels is sent, then
      --  this bit should be set. Clear it when all the data stored in DMA TX
      --  buffer is for enabled channels.
      TX_TDM_SKIP_MSK_EN  : TX_TDM_CTRL_TX_TDM_SKIP_MSK_EN_Field := 16#0#;
      --  unspecified
      Reserved_21_31      : ESP32_C3.UInt11 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TX_TDM_CTRL_Register use record
      TX_TDM_CHAN0_EN     at 0 range 0 .. 0;
      TX_TDM_CHAN1_EN     at 0 range 1 .. 1;
      TX_TDM_CHAN2_EN     at 0 range 2 .. 2;
      TX_TDM_CHAN3_EN     at 0 range 3 .. 3;
      TX_TDM_CHAN4_EN     at 0 range 4 .. 4;
      TX_TDM_CHAN5_EN     at 0 range 5 .. 5;
      TX_TDM_CHAN6_EN     at 0 range 6 .. 6;
      TX_TDM_CHAN7_EN     at 0 range 7 .. 7;
      TX_TDM_CHAN8_EN     at 0 range 8 .. 8;
      TX_TDM_CHAN9_EN     at 0 range 9 .. 9;
      TX_TDM_CHAN10_EN    at 0 range 10 .. 10;
      TX_TDM_CHAN11_EN    at 0 range 11 .. 11;
      TX_TDM_CHAN12_EN    at 0 range 12 .. 12;
      TX_TDM_CHAN13_EN    at 0 range 13 .. 13;
      TX_TDM_CHAN14_EN    at 0 range 14 .. 14;
      TX_TDM_CHAN15_EN    at 0 range 15 .. 15;
      TX_TDM_TOT_CHAN_NUM at 0 range 16 .. 19;
      TX_TDM_SKIP_MSK_EN  at 0 range 20 .. 20;
      Reserved_21_31      at 0 range 21 .. 31;
   end record;

   subtype RX_TIMING_RX_SD_IN_DM_Field is ESP32_C3.UInt2;
   subtype RX_TIMING_RX_WS_OUT_DM_Field is ESP32_C3.UInt2;
   subtype RX_TIMING_RX_BCK_OUT_DM_Field is ESP32_C3.UInt2;
   subtype RX_TIMING_RX_WS_IN_DM_Field is ESP32_C3.UInt2;
   subtype RX_TIMING_RX_BCK_IN_DM_Field is ESP32_C3.UInt2;

   --  I2S RX timing control register
   type RX_TIMING_Register is record
      --  The delay mode of I2S Rx SD input signal. 0: bypass. 1: delay by pos
      --  edge. 2: delay by neg edge. 3: not used.
      RX_SD_IN_DM    : RX_TIMING_RX_SD_IN_DM_Field := 16#0#;
      --  unspecified
      Reserved_2_15  : ESP32_C3.UInt14 := 16#0#;
      --  The delay mode of I2S Rx WS output signal. 0: bypass. 1: delay by pos
      --  edge. 2: delay by neg edge. 3: not used.
      RX_WS_OUT_DM   : RX_TIMING_RX_WS_OUT_DM_Field := 16#0#;
      --  unspecified
      Reserved_18_19 : ESP32_C3.UInt2 := 16#0#;
      --  The delay mode of I2S Rx BCK output signal. 0: bypass. 1: delay by
      --  pos edge. 2: delay by neg edge. 3: not used.
      RX_BCK_OUT_DM  : RX_TIMING_RX_BCK_OUT_DM_Field := 16#0#;
      --  unspecified
      Reserved_22_23 : ESP32_C3.UInt2 := 16#0#;
      --  The delay mode of I2S Rx WS input signal. 0: bypass. 1: delay by pos
      --  edge. 2: delay by neg edge. 3: not used.
      RX_WS_IN_DM    : RX_TIMING_RX_WS_IN_DM_Field := 16#0#;
      --  unspecified
      Reserved_26_27 : ESP32_C3.UInt2 := 16#0#;
      --  The delay mode of I2S Rx BCK input signal. 0: bypass. 1: delay by pos
      --  edge. 2: delay by neg edge. 3: not used.
      RX_BCK_IN_DM   : RX_TIMING_RX_BCK_IN_DM_Field := 16#0#;
      --  unspecified
      Reserved_30_31 : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RX_TIMING_Register use record
      RX_SD_IN_DM    at 0 range 0 .. 1;
      Reserved_2_15  at 0 range 2 .. 15;
      RX_WS_OUT_DM   at 0 range 16 .. 17;
      Reserved_18_19 at 0 range 18 .. 19;
      RX_BCK_OUT_DM  at 0 range 20 .. 21;
      Reserved_22_23 at 0 range 22 .. 23;
      RX_WS_IN_DM    at 0 range 24 .. 25;
      Reserved_26_27 at 0 range 26 .. 27;
      RX_BCK_IN_DM   at 0 range 28 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   subtype TX_TIMING_TX_SD_OUT_DM_Field is ESP32_C3.UInt2;
   subtype TX_TIMING_TX_SD1_OUT_DM_Field is ESP32_C3.UInt2;
   subtype TX_TIMING_TX_WS_OUT_DM_Field is ESP32_C3.UInt2;
   subtype TX_TIMING_TX_BCK_OUT_DM_Field is ESP32_C3.UInt2;
   subtype TX_TIMING_TX_WS_IN_DM_Field is ESP32_C3.UInt2;
   subtype TX_TIMING_TX_BCK_IN_DM_Field is ESP32_C3.UInt2;

   --  I2S TX timing control register
   type TX_TIMING_Register is record
      --  The delay mode of I2S TX SD output signal. 0: bypass. 1: delay by pos
      --  edge. 2: delay by neg edge. 3: not used.
      TX_SD_OUT_DM   : TX_TIMING_TX_SD_OUT_DM_Field := 16#0#;
      --  unspecified
      Reserved_2_3   : ESP32_C3.UInt2 := 16#0#;
      --  The delay mode of I2S TX SD1 output signal. 0: bypass. 1: delay by
      --  pos edge. 2: delay by neg edge. 3: not used.
      TX_SD1_OUT_DM  : TX_TIMING_TX_SD1_OUT_DM_Field := 16#0#;
      --  unspecified
      Reserved_6_15  : ESP32_C3.UInt10 := 16#0#;
      --  The delay mode of I2S TX WS output signal. 0: bypass. 1: delay by pos
      --  edge. 2: delay by neg edge. 3: not used.
      TX_WS_OUT_DM   : TX_TIMING_TX_WS_OUT_DM_Field := 16#0#;
      --  unspecified
      Reserved_18_19 : ESP32_C3.UInt2 := 16#0#;
      --  The delay mode of I2S TX BCK output signal. 0: bypass. 1: delay by
      --  pos edge. 2: delay by neg edge. 3: not used.
      TX_BCK_OUT_DM  : TX_TIMING_TX_BCK_OUT_DM_Field := 16#0#;
      --  unspecified
      Reserved_22_23 : ESP32_C3.UInt2 := 16#0#;
      --  The delay mode of I2S TX WS input signal. 0: bypass. 1: delay by pos
      --  edge. 2: delay by neg edge. 3: not used.
      TX_WS_IN_DM    : TX_TIMING_TX_WS_IN_DM_Field := 16#0#;
      --  unspecified
      Reserved_26_27 : ESP32_C3.UInt2 := 16#0#;
      --  The delay mode of I2S TX BCK input signal. 0: bypass. 1: delay by pos
      --  edge. 2: delay by neg edge. 3: not used.
      TX_BCK_IN_DM   : TX_TIMING_TX_BCK_IN_DM_Field := 16#0#;
      --  unspecified
      Reserved_30_31 : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TX_TIMING_Register use record
      TX_SD_OUT_DM   at 0 range 0 .. 1;
      Reserved_2_3   at 0 range 2 .. 3;
      TX_SD1_OUT_DM  at 0 range 4 .. 5;
      Reserved_6_15  at 0 range 6 .. 15;
      TX_WS_OUT_DM   at 0 range 16 .. 17;
      Reserved_18_19 at 0 range 18 .. 19;
      TX_BCK_OUT_DM  at 0 range 20 .. 21;
      Reserved_22_23 at 0 range 22 .. 23;
      TX_WS_IN_DM    at 0 range 24 .. 25;
      Reserved_26_27 at 0 range 26 .. 27;
      TX_BCK_IN_DM   at 0 range 28 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   subtype LC_HUNG_CONF_LC_FIFO_TIMEOUT_Field is ESP32_C3.Byte;
   subtype LC_HUNG_CONF_LC_FIFO_TIMEOUT_SHIFT_Field is ESP32_C3.UInt3;
   subtype LC_HUNG_CONF_LC_FIFO_TIMEOUT_ENA_Field is ESP32_C3.Bit;

   --  I2S HUNG configure register.
   type LC_HUNG_CONF_Register is record
      --  the i2s_tx_hung_int interrupt or the i2s_rx_hung_int interrupt will
      --  be triggered when fifo hung counter is equal to this value
      LC_FIFO_TIMEOUT       : LC_HUNG_CONF_LC_FIFO_TIMEOUT_Field := 16#10#;
      --  The bits are used to scale tick counter threshold. The tick counter
      --  is reset when counter value >= 88000/2^i2s_lc_fifo_timeout_shift
      LC_FIFO_TIMEOUT_SHIFT : LC_HUNG_CONF_LC_FIFO_TIMEOUT_SHIFT_Field :=
                               16#0#;
      --  The enable bit for FIFO timeout
      LC_FIFO_TIMEOUT_ENA   : LC_HUNG_CONF_LC_FIFO_TIMEOUT_ENA_Field := 16#1#;
      --  unspecified
      Reserved_12_31        : ESP32_C3.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for LC_HUNG_CONF_Register use record
      LC_FIFO_TIMEOUT       at 0 range 0 .. 7;
      LC_FIFO_TIMEOUT_SHIFT at 0 range 8 .. 10;
      LC_FIFO_TIMEOUT_ENA   at 0 range 11 .. 11;
      Reserved_12_31        at 0 range 12 .. 31;
   end record;

   subtype RXEOF_NUM_RX_EOF_NUM_Field is ESP32_C3.UInt12;

   --  I2S RX data number control register.
   type RXEOF_NUM_Register is record
      --  The receive data bit length is (I2S_RX_BITS_MOD[4:0] + 1) *
      --  (REG_RX_EOF_NUM[11:0] + 1) . It will trigger in_suc_eof interrupt in
      --  the configured DMA RX channel.
      RX_EOF_NUM     : RXEOF_NUM_RX_EOF_NUM_Field := 16#40#;
      --  unspecified
      Reserved_12_31 : ESP32_C3.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RXEOF_NUM_Register use record
      RX_EOF_NUM     at 0 range 0 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;

   subtype STATE_TX_IDLE_Field is ESP32_C3.Bit;

   --  I2S TX status register
   type STATE_Register is record
      --  Read-only. 1: i2s_tx is idle state. 0: i2s_tx is working.
      TX_IDLE       : STATE_TX_IDLE_Field;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for STATE_Register use record
      TX_IDLE       at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype DATE_DATE_Field is ESP32_C3.UInt28;

   --  Version control register
   type DATE_Register is record
      --  I2S version control register
      DATE           : DATE_DATE_Field := 16#2007220#;
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

   --  I2S (Inter-IC Sound) Controller 0
   type I2S0_Peripheral is record
      --  I2S interrupt raw register, valid in level.
      INT_RAW          : aliased INT_RAW_Register;
      --  I2S interrupt status register.
      INT_ST           : aliased INT_ST_Register;
      --  I2S interrupt enable register.
      INT_ENA          : aliased INT_ENA_Register;
      --  I2S interrupt clear register.
      INT_CLR          : aliased INT_CLR_Register;
      --  I2S RX configure register
      RX_CONF          : aliased RX_CONF_Register;
      --  I2S TX configure register
      TX_CONF          : aliased TX_CONF_Register;
      --  I2S RX configure register 1
      RX_CONF1         : aliased RX_CONF1_Register;
      --  I2S TX configure register 1
      TX_CONF1         : aliased TX_CONF1_Register;
      --  I2S RX clock configure register
      RX_CLKM_CONF     : aliased RX_CLKM_CONF_Register;
      --  I2S TX clock configure register
      TX_CLKM_CONF     : aliased TX_CLKM_CONF_Register;
      --  I2S RX module clock divider configure register
      RX_CLKM_DIV_CONF : aliased RX_CLKM_DIV_CONF_Register;
      --  I2S TX module clock divider configure register
      TX_CLKM_DIV_CONF : aliased TX_CLKM_DIV_CONF_Register;
      --  I2S TX PCM2PDM configuration register
      TX_PCM2PDM_CONF  : aliased TX_PCM2PDM_CONF_Register;
      --  I2S TX PCM2PDM configuration register
      TX_PCM2PDM_CONF1 : aliased TX_PCM2PDM_CONF1_Register;
      --  I2S TX TDM mode control register
      RX_TDM_CTRL      : aliased RX_TDM_CTRL_Register;
      --  I2S TX TDM mode control register
      TX_TDM_CTRL      : aliased TX_TDM_CTRL_Register;
      --  I2S RX timing control register
      RX_TIMING        : aliased RX_TIMING_Register;
      --  I2S TX timing control register
      TX_TIMING        : aliased TX_TIMING_Register;
      --  I2S HUNG configure register.
      LC_HUNG_CONF     : aliased LC_HUNG_CONF_Register;
      --  I2S RX data number control register.
      RXEOF_NUM        : aliased RXEOF_NUM_Register;
      --  I2S signal data register
      CONF_SIGLE_DATA  : aliased ESP32_C3.UInt32;
      --  I2S TX status register
      STATE            : aliased STATE_Register;
      --  Version control register
      DATE             : aliased DATE_Register;
   end record
     with Volatile;

   for I2S0_Peripheral use record
      INT_RAW          at 16#C# range 0 .. 31;
      INT_ST           at 16#10# range 0 .. 31;
      INT_ENA          at 16#14# range 0 .. 31;
      INT_CLR          at 16#18# range 0 .. 31;
      RX_CONF          at 16#20# range 0 .. 31;
      TX_CONF          at 16#24# range 0 .. 31;
      RX_CONF1         at 16#28# range 0 .. 31;
      TX_CONF1         at 16#2C# range 0 .. 31;
      RX_CLKM_CONF     at 16#30# range 0 .. 31;
      TX_CLKM_CONF     at 16#34# range 0 .. 31;
      RX_CLKM_DIV_CONF at 16#38# range 0 .. 31;
      TX_CLKM_DIV_CONF at 16#3C# range 0 .. 31;
      TX_PCM2PDM_CONF  at 16#40# range 0 .. 31;
      TX_PCM2PDM_CONF1 at 16#44# range 0 .. 31;
      RX_TDM_CTRL      at 16#50# range 0 .. 31;
      TX_TDM_CTRL      at 16#54# range 0 .. 31;
      RX_TIMING        at 16#58# range 0 .. 31;
      TX_TIMING        at 16#5C# range 0 .. 31;
      LC_HUNG_CONF     at 16#60# range 0 .. 31;
      RXEOF_NUM        at 16#64# range 0 .. 31;
      CONF_SIGLE_DATA  at 16#68# range 0 .. 31;
      STATE            at 16#6C# range 0 .. 31;
      DATE             at 16#80# range 0 .. 31;
   end record;

   --  I2S (Inter-IC Sound) Controller 0
   I2S0_Periph : aliased I2S0_Peripheral
     with Import, Address => I2S0_Base;

end ESP32_C3.I2S;
