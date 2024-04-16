pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.SPI0 is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype CTRL_FDUMMY_OUT_Field is ESP32_C3.Bit;
   subtype CTRL_FCMD_DUAL_Field is ESP32_C3.Bit;
   subtype CTRL_FCMD_QUAD_Field is ESP32_C3.Bit;
   subtype CTRL_FASTRD_MODE_Field is ESP32_C3.Bit;
   subtype CTRL_FREAD_DUAL_Field is ESP32_C3.Bit;
   subtype CTRL_Q_POL_Field is ESP32_C3.Bit;
   subtype CTRL_D_POL_Field is ESP32_C3.Bit;
   subtype CTRL_FREAD_QUAD_Field is ESP32_C3.Bit;
   subtype CTRL_WP_Field is ESP32_C3.Bit;
   subtype CTRL_FREAD_DIO_Field is ESP32_C3.Bit;
   subtype CTRL_FREAD_QIO_Field is ESP32_C3.Bit;

   --  SPI0 control register.
   type CTRL_Register is record
      --  unspecified
      Reserved_0_2   : ESP32_C3.UInt3 := 16#0#;
      --  In the dummy phase the signal level of spi is output by the spi
      --  controller.
      FDUMMY_OUT     : CTRL_FDUMMY_OUT_Field := 16#0#;
      --  unspecified
      Reserved_4_6   : ESP32_C3.UInt3 := 16#0#;
      --  Apply 2 signals during command phase 1:enable 0: disable
      FCMD_DUAL      : CTRL_FCMD_DUAL_Field := 16#0#;
      --  Apply 4 signals during command phase 1:enable 0: disable
      FCMD_QUAD      : CTRL_FCMD_QUAD_Field := 16#0#;
      --  unspecified
      Reserved_9_12  : ESP32_C3.UInt4 := 16#0#;
      --  This bit enable the bits: spi_mem_fread_qio, spi_mem_fread_dio,
      --  spi_mem_fread_qout and spi_mem_fread_dout. 1: enable 0: disable.
      FASTRD_MODE    : CTRL_FASTRD_MODE_Field := 16#1#;
      --  In the read operations, read-data phase apply 2 signals. 1: enable 0:
      --  disable.
      FREAD_DUAL     : CTRL_FREAD_DUAL_Field := 16#0#;
      --  unspecified
      Reserved_15_17 : ESP32_C3.UInt3 := 16#0#;
      --  The bit is used to set MISO line polarity, 1: high 0, low
      Q_POL          : CTRL_Q_POL_Field := 16#1#;
      --  The bit is used to set MOSI line polarity, 1: high 0, low
      D_POL          : CTRL_D_POL_Field := 16#1#;
      --  In the read operations read-data phase apply 4 signals. 1: enable 0:
      --  disable.
      FREAD_QUAD     : CTRL_FREAD_QUAD_Field := 16#0#;
      --  Write protect signal output when SPI is idle. 1: output high, 0:
      --  output low.
      WP             : CTRL_WP_Field := 16#1#;
      --  unspecified
      Reserved_22_22 : ESP32_C3.Bit := 16#0#;
      --  In the read operations address phase and read-data phase apply 2
      --  signals. 1: enable 0: disable.
      FREAD_DIO      : CTRL_FREAD_DIO_Field := 16#0#;
      --  In the read operations address phase and read-data phase apply 4
      --  signals. 1: enable 0: disable.
      FREAD_QIO      : CTRL_FREAD_QIO_Field := 16#0#;
      --  unspecified
      Reserved_25_31 : ESP32_C3.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CTRL_Register use record
      Reserved_0_2   at 0 range 0 .. 2;
      FDUMMY_OUT     at 0 range 3 .. 3;
      Reserved_4_6   at 0 range 4 .. 6;
      FCMD_DUAL      at 0 range 7 .. 7;
      FCMD_QUAD      at 0 range 8 .. 8;
      Reserved_9_12  at 0 range 9 .. 12;
      FASTRD_MODE    at 0 range 13 .. 13;
      FREAD_DUAL     at 0 range 14 .. 14;
      Reserved_15_17 at 0 range 15 .. 17;
      Q_POL          at 0 range 18 .. 18;
      D_POL          at 0 range 19 .. 19;
      FREAD_QUAD     at 0 range 20 .. 20;
      WP             at 0 range 21 .. 21;
      Reserved_22_22 at 0 range 22 .. 22;
      FREAD_DIO      at 0 range 23 .. 23;
      FREAD_QIO      at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   subtype CTRL1_CLK_MODE_Field is ESP32_C3.UInt2;
   subtype CTRL1_RXFIFO_RST_Field is ESP32_C3.Bit;

   --  SPI0 control1 register.
   type CTRL1_Register is record
      --  SPI clock mode bits. 0: SPI clock is off when CS inactive 1: SPI
      --  clock is delayed one cycle after CS inactive 2: SPI clock is delayed
      --  two cycles after CS inactive 3: SPI clock is alwasy on.
      CLK_MODE       : CTRL1_CLK_MODE_Field := 16#0#;
      --  unspecified
      Reserved_2_29  : ESP32_C3.UInt28 := 16#0#;
      --  Write-only. SPI0 RX FIFO reset signal.
      RXFIFO_RST     : CTRL1_RXFIFO_RST_Field := 16#0#;
      --  unspecified
      Reserved_31_31 : ESP32_C3.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CTRL1_Register use record
      CLK_MODE       at 0 range 0 .. 1;
      Reserved_2_29  at 0 range 2 .. 29;
      RXFIFO_RST     at 0 range 30 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   subtype CTRL2_CS_SETUP_TIME_Field is ESP32_C3.UInt5;
   subtype CTRL2_CS_HOLD_TIME_Field is ESP32_C3.UInt5;
   subtype CTRL2_CS_HOLD_DELAY_Field is ESP32_C3.UInt6;
   subtype CTRL2_SYNC_RESET_Field is ESP32_C3.Bit;

   --  SPI0 control2 register.
   type CTRL2_Register is record
      --  (cycles-1) of prepare phase by spi clock this bits are combined with
      --  spi_mem_cs_setup bit.
      CS_SETUP_TIME  : CTRL2_CS_SETUP_TIME_Field := 16#1#;
      --  Spi cs signal is delayed to inactive by spi clock this bits are
      --  combined with spi_mem_cs_hold bit.
      CS_HOLD_TIME   : CTRL2_CS_HOLD_TIME_Field := 16#1#;
      --  unspecified
      Reserved_10_24 : ESP32_C3.UInt15 := 16#0#;
      --  These bits are used to set the minimum CS high time tSHSL between SPI
      --  burst transfer when accesses to flash. tSHSL is
      --  (SPI_MEM_CS_HOLD_DELAY[5:0] + 1) MSPI core clock cycles.
      CS_HOLD_DELAY  : CTRL2_CS_HOLD_DELAY_Field := 16#0#;
      --  Write-only. The FSM will be reset.
      SYNC_RESET     : CTRL2_SYNC_RESET_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CTRL2_Register use record
      CS_SETUP_TIME  at 0 range 0 .. 4;
      CS_HOLD_TIME   at 0 range 5 .. 9;
      Reserved_10_24 at 0 range 10 .. 24;
      CS_HOLD_DELAY  at 0 range 25 .. 30;
      SYNC_RESET     at 0 range 31 .. 31;
   end record;

   subtype CLOCK_CLKCNT_L_Field is ESP32_C3.Byte;
   subtype CLOCK_CLKCNT_H_Field is ESP32_C3.Byte;
   subtype CLOCK_CLKCNT_N_Field is ESP32_C3.Byte;
   subtype CLOCK_CLK_EQU_SYSCLK_Field is ESP32_C3.Bit;

   --  SPI clock division control register.
   type CLOCK_Register is record
      --  In the master mode it must be equal to spi_mem_clkcnt_N.
      CLKCNT_L       : CLOCK_CLKCNT_L_Field := 16#3#;
      --  In the master mode it must be floor((spi_mem_clkcnt_N+1)/2-1).
      CLKCNT_H       : CLOCK_CLKCNT_H_Field := 16#1#;
      --  In the master mode it is the divider of spi_mem_clk. So spi_mem_clk
      --  frequency is system/(spi_mem_clkcnt_N+1)
      CLKCNT_N       : CLOCK_CLKCNT_N_Field := 16#3#;
      --  unspecified
      Reserved_24_30 : ESP32_C3.UInt7 := 16#0#;
      --  Set this bit in 1-division mode.
      CLK_EQU_SYSCLK : CLOCK_CLK_EQU_SYSCLK_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CLOCK_Register use record
      CLKCNT_L       at 0 range 0 .. 7;
      CLKCNT_H       at 0 range 8 .. 15;
      CLKCNT_N       at 0 range 16 .. 23;
      Reserved_24_30 at 0 range 24 .. 30;
      CLK_EQU_SYSCLK at 0 range 31 .. 31;
   end record;

   subtype USER_CS_HOLD_Field is ESP32_C3.Bit;
   subtype USER_CS_SETUP_Field is ESP32_C3.Bit;
   subtype USER_CK_OUT_EDGE_Field is ESP32_C3.Bit;
   subtype USER_USR_DUMMY_IDLE_Field is ESP32_C3.Bit;
   subtype USER_USR_DUMMY_Field is ESP32_C3.Bit;

   --  SPI0 user register.
   type USER_Register is record
      --  unspecified
      Reserved_0_5   : ESP32_C3.UInt6 := 16#0#;
      --  spi cs keep low when spi is in done phase. 1: enable 0: disable.
      CS_HOLD        : USER_CS_HOLD_Field := 16#0#;
      --  spi cs is enable when spi is in prepare phase. 1: enable 0: disable.
      CS_SETUP       : USER_CS_SETUP_Field := 16#0#;
      --  unspecified
      Reserved_8_8   : ESP32_C3.Bit := 16#0#;
      --  the bit combined with spi_mem_mosi_delay_mode bits to set mosi signal
      --  delay mode.
      CK_OUT_EDGE    : USER_CK_OUT_EDGE_Field := 16#0#;
      --  unspecified
      Reserved_10_25 : ESP32_C3.UInt16 := 16#0#;
      --  spi clock is disable in dummy phase when the bit is enable.
      USR_DUMMY_IDLE : USER_USR_DUMMY_IDLE_Field := 16#0#;
      --  unspecified
      Reserved_27_28 : ESP32_C3.UInt2 := 16#0#;
      --  This bit enable the dummy phase of an operation.
      USR_DUMMY      : USER_USR_DUMMY_Field := 16#0#;
      --  unspecified
      Reserved_30_31 : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for USER_Register use record
      Reserved_0_5   at 0 range 0 .. 5;
      CS_HOLD        at 0 range 6 .. 6;
      CS_SETUP       at 0 range 7 .. 7;
      Reserved_8_8   at 0 range 8 .. 8;
      CK_OUT_EDGE    at 0 range 9 .. 9;
      Reserved_10_25 at 0 range 10 .. 25;
      USR_DUMMY_IDLE at 0 range 26 .. 26;
      Reserved_27_28 at 0 range 27 .. 28;
      USR_DUMMY      at 0 range 29 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   subtype USER1_USR_DUMMY_CYCLELEN_Field is ESP32_C3.UInt6;
   subtype USER1_USR_ADDR_BITLEN_Field is ESP32_C3.UInt6;

   --  SPI0 user1 register.
   type USER1_Register is record
      --  The length in spi_mem_clk cycles of dummy phase. The register value
      --  shall be (cycle_num-1).
      USR_DUMMY_CYCLELEN : USER1_USR_DUMMY_CYCLELEN_Field := 16#7#;
      --  unspecified
      Reserved_6_25      : ESP32_C3.UInt20 := 16#0#;
      --  The length in bits of address phase. The register value shall be
      --  (bit_num-1).
      USR_ADDR_BITLEN    : USER1_USR_ADDR_BITLEN_Field := 16#17#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for USER1_Register use record
      USR_DUMMY_CYCLELEN at 0 range 0 .. 5;
      Reserved_6_25      at 0 range 6 .. 25;
      USR_ADDR_BITLEN    at 0 range 26 .. 31;
   end record;

   subtype USER2_USR_COMMAND_VALUE_Field is ESP32_C3.UInt16;
   subtype USER2_USR_COMMAND_BITLEN_Field is ESP32_C3.UInt4;

   --  SPI0 user2 register.
   type USER2_Register is record
      --  The value of command.
      USR_COMMAND_VALUE  : USER2_USR_COMMAND_VALUE_Field := 16#0#;
      --  unspecified
      Reserved_16_27     : ESP32_C3.UInt12 := 16#0#;
      --  The length in bits of command phase. The register value shall be
      --  (bit_num-1)
      USR_COMMAND_BITLEN : USER2_USR_COMMAND_BITLEN_Field := 16#7#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for USER2_Register use record
      USR_COMMAND_VALUE  at 0 range 0 .. 15;
      Reserved_16_27     at 0 range 16 .. 27;
      USR_COMMAND_BITLEN at 0 range 28 .. 31;
   end record;

   subtype RD_STATUS_WB_MODE_Field is ESP32_C3.Byte;

   --  SPI0 read control register.
   type RD_STATUS_Register is record
      --  unspecified
      Reserved_0_15  : ESP32_C3.UInt16 := 16#0#;
      --  Mode bits in the flash fast read mode it is combined with
      --  spi_mem_fastrd_mode bit.
      WB_MODE        : RD_STATUS_WB_MODE_Field := 16#0#;
      --  unspecified
      Reserved_24_31 : ESP32_C3.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RD_STATUS_Register use record
      Reserved_0_15  at 0 range 0 .. 15;
      WB_MODE        at 0 range 16 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   subtype MISC_TRANS_END_Field is ESP32_C3.Bit;
   subtype MISC_TRANS_END_INT_ENA_Field is ESP32_C3.Bit;
   subtype MISC_CSPI_ST_TRANS_END_Field is ESP32_C3.Bit;
   subtype MISC_CSPI_ST_TRANS_END_INT_ENA_Field is ESP32_C3.Bit;
   subtype MISC_CK_IDLE_EDGE_Field is ESP32_C3.Bit;
   subtype MISC_CS_KEEP_ACTIVE_Field is ESP32_C3.Bit;

   --  SPI0 misc register
   type MISC_Register is record
      --  unspecified
      Reserved_0_2              : ESP32_C3.UInt3 := 16#0#;
      --  The bit is used to indicate the spi0_mst_st controlled transmitting
      --  is done.
      TRANS_END                 : MISC_TRANS_END_Field := 16#0#;
      --  The bit is used to enable the interrupt of spi0_mst_st controlled
      --  transmitting is done.
      TRANS_END_INT_ENA         : MISC_TRANS_END_INT_ENA_Field := 16#0#;
      --  The bit is used to indicate the spi0_slv_st controlled transmitting
      --  is done.
      CSPI_ST_TRANS_END         : MISC_CSPI_ST_TRANS_END_Field := 16#0#;
      --  The bit is used to enable the interrupt of spi0_slv_st controlled
      --  transmitting is done.
      CSPI_ST_TRANS_END_INT_ENA : MISC_CSPI_ST_TRANS_END_INT_ENA_Field :=
                                   16#0#;
      --  unspecified
      Reserved_7_8              : ESP32_C3.UInt2 := 16#0#;
      --  1: spi clk line is high when idle 0: spi clk line is low when idle
      CK_IDLE_EDGE              : MISC_CK_IDLE_EDGE_Field := 16#0#;
      --  spi cs line keep low when the bit is set.
      CS_KEEP_ACTIVE            : MISC_CS_KEEP_ACTIVE_Field := 16#0#;
      --  unspecified
      Reserved_11_31            : ESP32_C3.UInt21 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for MISC_Register use record
      Reserved_0_2              at 0 range 0 .. 2;
      TRANS_END                 at 0 range 3 .. 3;
      TRANS_END_INT_ENA         at 0 range 4 .. 4;
      CSPI_ST_TRANS_END         at 0 range 5 .. 5;
      CSPI_ST_TRANS_END_INT_ENA at 0 range 6 .. 6;
      Reserved_7_8              at 0 range 7 .. 8;
      CK_IDLE_EDGE              at 0 range 9 .. 9;
      CS_KEEP_ACTIVE            at 0 range 10 .. 10;
      Reserved_11_31            at 0 range 11 .. 31;
   end record;

   subtype CACHE_FCTRL_CACHE_REQ_EN_Field is ESP32_C3.Bit;
   subtype CACHE_FCTRL_CACHE_USR_ADDR_4BYTE_Field is ESP32_C3.Bit;
   subtype CACHE_FCTRL_CACHE_FLASH_USR_CMD_Field is ESP32_C3.Bit;
   subtype CACHE_FCTRL_FDIN_DUAL_Field is ESP32_C3.Bit;
   subtype CACHE_FCTRL_FDOUT_DUAL_Field is ESP32_C3.Bit;
   subtype CACHE_FCTRL_FADDR_DUAL_Field is ESP32_C3.Bit;
   subtype CACHE_FCTRL_FDIN_QUAD_Field is ESP32_C3.Bit;
   subtype CACHE_FCTRL_FDOUT_QUAD_Field is ESP32_C3.Bit;
   subtype CACHE_FCTRL_FADDR_QUAD_Field is ESP32_C3.Bit;

   --  SPI0 bit mode control register.
   type CACHE_FCTRL_Register is record
      --  For SPI0, Cache access enable, 1: enable, 0:disable.
      CACHE_REQ_EN         : CACHE_FCTRL_CACHE_REQ_EN_Field := 16#0#;
      --  For SPI0, cache read flash with 4 bytes address, 1: enable,
      --  0:disable.
      CACHE_USR_ADDR_4BYTE : CACHE_FCTRL_CACHE_USR_ADDR_4BYTE_Field := 16#0#;
      --  For SPI0, cache read flash for user define command, 1: enable,
      --  0:disable.
      CACHE_FLASH_USR_CMD  : CACHE_FCTRL_CACHE_FLASH_USR_CMD_Field := 16#0#;
      --  For SPI0 flash, din phase apply 2 signals. 1: enable 0: disable. The
      --  bit is the same with spi_mem_fread_dio.
      FDIN_DUAL            : CACHE_FCTRL_FDIN_DUAL_Field := 16#0#;
      --  For SPI0 flash, dout phase apply 2 signals. 1: enable 0: disable. The
      --  bit is the same with spi_mem_fread_dio.
      FDOUT_DUAL           : CACHE_FCTRL_FDOUT_DUAL_Field := 16#0#;
      --  For SPI0 flash, address phase apply 2 signals. 1: enable 0: disable.
      --  The bit is the same with spi_mem_fread_dio.
      FADDR_DUAL           : CACHE_FCTRL_FADDR_DUAL_Field := 16#0#;
      --  For SPI0 flash, din phase apply 4 signals. 1: enable 0: disable. The
      --  bit is the same with spi_mem_fread_qio.
      FDIN_QUAD            : CACHE_FCTRL_FDIN_QUAD_Field := 16#0#;
      --  For SPI0 flash, dout phase apply 4 signals. 1: enable 0: disable. The
      --  bit is the same with spi_mem_fread_qio.
      FDOUT_QUAD           : CACHE_FCTRL_FDOUT_QUAD_Field := 16#0#;
      --  For SPI0 flash, address phase apply 4 signals. 1: enable 0: disable.
      --  The bit is the same with spi_mem_fread_qio.
      FADDR_QUAD           : CACHE_FCTRL_FADDR_QUAD_Field := 16#0#;
      --  unspecified
      Reserved_9_31        : ESP32_C3.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_FCTRL_Register use record
      CACHE_REQ_EN         at 0 range 0 .. 0;
      CACHE_USR_ADDR_4BYTE at 0 range 1 .. 1;
      CACHE_FLASH_USR_CMD  at 0 range 2 .. 2;
      FDIN_DUAL            at 0 range 3 .. 3;
      FDOUT_DUAL           at 0 range 4 .. 4;
      FADDR_DUAL           at 0 range 5 .. 5;
      FDIN_QUAD            at 0 range 6 .. 6;
      FDOUT_QUAD           at 0 range 7 .. 7;
      FADDR_QUAD           at 0 range 8 .. 8;
      Reserved_9_31        at 0 range 9 .. 31;
   end record;

   subtype FSM_CSPI_ST_Field is ESP32_C3.UInt4;
   subtype FSM_EM_ST_Field is ESP32_C3.UInt3;
   subtype FSM_CSPI_LOCK_DELAY_TIME_Field is ESP32_C3.UInt5;

   --  SPI0 FSM status register
   type FSM_Register is record
      --  Read-only. The current status of SPI0 slave FSM: spi0_slv_st. 0: idle
      --  state, 1: preparation state, 2: send command state, 3: send address
      --  state, 4: wait state, 5: read data state, 6:write data state, 7: done
      --  state, 8: read data end state.
      CSPI_ST              : FSM_CSPI_ST_Field := 16#0#;
      --  Read-only. The current status of SPI0 master FSM: spi0_mst_st. 0:
      --  idle state, 1:EM_CACHE_GRANT , 2: program/erase suspend state, 3:
      --  SPI0 read data state, 4: wait cache/EDMA sent data is stored in SPI0
      --  TX FIFO, 5: SPI0 write data state.
      EM_ST                : FSM_EM_ST_Field := 16#0#;
      --  The lock delay time of SPI0/1 arbiter by spi0_slv_st, after PER is
      --  sent by SPI1.
      CSPI_LOCK_DELAY_TIME : FSM_CSPI_LOCK_DELAY_TIME_Field := 16#4#;
      --  unspecified
      Reserved_12_31       : ESP32_C3.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FSM_Register use record
      CSPI_ST              at 0 range 0 .. 3;
      EM_ST                at 0 range 4 .. 6;
      CSPI_LOCK_DELAY_TIME at 0 range 7 .. 11;
      Reserved_12_31       at 0 range 12 .. 31;
   end record;

   subtype TIMING_CALI_TIMING_CLK_ENA_Field is ESP32_C3.Bit;
   subtype TIMING_CALI_TIMING_CALI_Field is ESP32_C3.Bit;
   subtype TIMING_CALI_EXTRA_DUMMY_CYCLELEN_Field is ESP32_C3.UInt3;

   --  SPI0 timing calibration register
   type TIMING_CALI_Register is record
      --  The bit is used to enable timing adjust clock for all reading
      --  operations.
      TIMING_CLK_ENA       : TIMING_CALI_TIMING_CLK_ENA_Field := 16#1#;
      --  The bit is used to enable timing auto-calibration for all reading
      --  operations.
      TIMING_CALI          : TIMING_CALI_TIMING_CALI_Field := 16#0#;
      --  add extra dummy spi clock cycle length for spi clock calibration.
      EXTRA_DUMMY_CYCLELEN : TIMING_CALI_EXTRA_DUMMY_CYCLELEN_Field := 16#0#;
      --  unspecified
      Reserved_5_31        : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIMING_CALI_Register use record
      TIMING_CLK_ENA       at 0 range 0 .. 0;
      TIMING_CALI          at 0 range 1 .. 1;
      EXTRA_DUMMY_CYCLELEN at 0 range 2 .. 4;
      Reserved_5_31        at 0 range 5 .. 31;
   end record;

   subtype DIN_MODE_DIN0_MODE_Field is ESP32_C3.UInt2;
   subtype DIN_MODE_DIN1_MODE_Field is ESP32_C3.UInt2;
   subtype DIN_MODE_DIN2_MODE_Field is ESP32_C3.UInt2;
   subtype DIN_MODE_DIN3_MODE_Field is ESP32_C3.UInt2;

   --  SPI0 input delay mode control register
   type DIN_MODE_Register is record
      --  the input signals are delayed by system clock cycles, 0: input
      --  without delayed, 1: input with the posedge of clk_apb,2 input with
      --  the negedge of clk_apb, 3: input with the posedge of clk_160, 4 input
      --  with the negedge of clk_160, 5: input with the spi_clk high edge, 6:
      --  input with the spi_clk low edge
      DIN0_MODE     : DIN_MODE_DIN0_MODE_Field := 16#0#;
      --  the input signals are delayed by system clock cycles, 0: input
      --  without delayed, 1: input with the posedge of clk_apb,2 input with
      --  the negedge of clk_apb, 3: input with the posedge of clk_160, 4 input
      --  with the negedge of clk_160, 5: input with the spi_clk high edge, 6:
      --  input with the spi_clk low edge
      DIN1_MODE     : DIN_MODE_DIN1_MODE_Field := 16#0#;
      --  the input signals are delayed by system clock cycles, 0: input
      --  without delayed, 1: input with the posedge of clk_apb,2 input with
      --  the negedge of clk_apb, 3: input with the posedge of clk_160, 4 input
      --  with the negedge of clk_160, 5: input with the spi_clk high edge, 6:
      --  input with the spi_clk low edge
      DIN2_MODE     : DIN_MODE_DIN2_MODE_Field := 16#0#;
      --  the input signals are delayed by system clock cycles, 0: input
      --  without delayed, 1: input with the posedge of clk_apb,2 input with
      --  the negedge of clk_apb, 3: input with the posedge of clk_160, 4 input
      --  with the negedge of clk_160, 5: input with the spi_clk high edge, 6:
      --  input with the spi_clk low edge
      DIN3_MODE     : DIN_MODE_DIN3_MODE_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : ESP32_C3.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DIN_MODE_Register use record
      DIN0_MODE     at 0 range 0 .. 1;
      DIN1_MODE     at 0 range 2 .. 3;
      DIN2_MODE     at 0 range 4 .. 5;
      DIN3_MODE     at 0 range 6 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype DIN_NUM_DIN0_NUM_Field is ESP32_C3.UInt2;
   subtype DIN_NUM_DIN1_NUM_Field is ESP32_C3.UInt2;
   subtype DIN_NUM_DIN2_NUM_Field is ESP32_C3.UInt2;
   subtype DIN_NUM_DIN3_NUM_Field is ESP32_C3.UInt2;

   --  SPI0 input delay number control register
   type DIN_NUM_Register is record
      --  the input signals are delayed by system clock cycles, 0: delayed by 1
      --  cycle, 1: delayed by 2 cycles,...
      DIN0_NUM      : DIN_NUM_DIN0_NUM_Field := 16#0#;
      --  the input signals are delayed by system clock cycles, 0: delayed by 1
      --  cycle, 1: delayed by 2 cycles,...
      DIN1_NUM      : DIN_NUM_DIN1_NUM_Field := 16#0#;
      --  the input signals are delayed by system clock cycles, 0: delayed by 1
      --  cycle, 1: delayed by 2 cycles,...
      DIN2_NUM      : DIN_NUM_DIN2_NUM_Field := 16#0#;
      --  the input signals are delayed by system clock cycles, 0: delayed by 1
      --  cycle, 1: delayed by 2 cycles,...
      DIN3_NUM      : DIN_NUM_DIN3_NUM_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : ESP32_C3.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DIN_NUM_Register use record
      DIN0_NUM      at 0 range 0 .. 1;
      DIN1_NUM      at 0 range 2 .. 3;
      DIN2_NUM      at 0 range 4 .. 5;
      DIN3_NUM      at 0 range 6 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype DOUT_MODE_DOUT0_MODE_Field is ESP32_C3.Bit;
   subtype DOUT_MODE_DOUT1_MODE_Field is ESP32_C3.Bit;
   subtype DOUT_MODE_DOUT2_MODE_Field is ESP32_C3.Bit;
   subtype DOUT_MODE_DOUT3_MODE_Field is ESP32_C3.Bit;

   --  SPI0 output delay mode control register
   type DOUT_MODE_Register is record
      --  the output signals are delayed by system clock cycles, 0: output
      --  without delayed, 1: output with the posedge of clk_apb,2 output with
      --  the negedge of clk_apb, 3: output with the posedge of clk_160,4
      --  output with the negedge of clk_160,5: output with the spi_clk high
      --  edge ,6: output with the spi_clk low edge
      DOUT0_MODE    : DOUT_MODE_DOUT0_MODE_Field := 16#0#;
      --  the output signals are delayed by system clock cycles, 0: output
      --  without delayed, 1: output with the posedge of clk_apb,2 output with
      --  the negedge of clk_apb, 3: output with the posedge of clk_160,4
      --  output with the negedge of clk_160,5: output with the spi_clk high
      --  edge ,6: output with the spi_clk low edge
      DOUT1_MODE    : DOUT_MODE_DOUT1_MODE_Field := 16#0#;
      --  the output signals are delayed by system clock cycles, 0: output
      --  without delayed, 1: output with the posedge of clk_apb,2 output with
      --  the negedge of clk_apb, 3: output with the posedge of clk_160,4
      --  output with the negedge of clk_160,5: output with the spi_clk high
      --  edge ,6: output with the spi_clk low edge
      DOUT2_MODE    : DOUT_MODE_DOUT2_MODE_Field := 16#0#;
      --  the output signals are delayed by system clock cycles, 0: output
      --  without delayed, 1: output with the posedge of clk_apb,2 output with
      --  the negedge of clk_apb, 3: output with the posedge of clk_160,4
      --  output with the negedge of clk_160,5: output with the spi_clk high
      --  edge ,6: output with the spi_clk low edge
      DOUT3_MODE    : DOUT_MODE_DOUT3_MODE_Field := 16#0#;
      --  unspecified
      Reserved_4_31 : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DOUT_MODE_Register use record
      DOUT0_MODE    at 0 range 0 .. 0;
      DOUT1_MODE    at 0 range 1 .. 1;
      DOUT2_MODE    at 0 range 2 .. 2;
      DOUT3_MODE    at 0 range 3 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype CLOCK_GATE_CLK_EN_Field is ESP32_C3.Bit;

   --  SPI0 clk_gate register
   type CLOCK_GATE_Register is record
      --  Register clock gate enable signal. 1: Enable. 0: Disable.
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

   subtype CORE_CLK_SEL_SPI01_CLK_SEL_Field is ESP32_C3.UInt2;

   --  SPI0 module clock select register
   type CORE_CLK_SEL_Register is record
      --  When the digital system clock selects PLL clock and the frequency of
      --  PLL clock is 480MHz, the value of reg_spi01_clk_sel: 0: SPI0/1 module
      --  clock (clk) is 80MHz. 1: SPI0/1 module clock (clk) is 120MHz. 2:
      --  SPI0/1 module clock (clk) 160MHz. 3: Not used. When the digital
      --  system clock selects PLL clock and the frequency of PLL clock is
      --  320MHz, the value of reg_spi01_clk_sel: 0: SPI0/1 module clock (clk)
      --  is 80MHz. 1: SPI0/1 module clock (clk) is 80MHz. 2: SPI0/1 module
      --  clock (clk) 160MHz. 3: Not used.
      SPI01_CLK_SEL : CORE_CLK_SEL_SPI01_CLK_SEL_Field := 16#0#;
      --  unspecified
      Reserved_2_31 : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE_CLK_SEL_Register use record
      SPI01_CLK_SEL at 0 range 0 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   subtype DATE_DATE_Field is ESP32_C3.UInt28;

   --  Version control register
   type DATE_Register is record
      --  SPI register version.
      DATE           : DATE_DATE_Field := 16#2007130#;
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

   --  SPI (Serial Peripheral Interface) Controller 0
   type SPI0_Peripheral is record
      --  SPI0 control register.
      CTRL         : aliased CTRL_Register;
      --  SPI0 control1 register.
      CTRL1        : aliased CTRL1_Register;
      --  SPI0 control2 register.
      CTRL2        : aliased CTRL2_Register;
      --  SPI clock division control register.
      CLOCK        : aliased CLOCK_Register;
      --  SPI0 user register.
      USER         : aliased USER_Register;
      --  SPI0 user1 register.
      USER1        : aliased USER1_Register;
      --  SPI0 user2 register.
      USER2        : aliased USER2_Register;
      --  SPI0 read control register.
      RD_STATUS    : aliased RD_STATUS_Register;
      --  SPI0 misc register
      MISC         : aliased MISC_Register;
      --  SPI0 bit mode control register.
      CACHE_FCTRL  : aliased CACHE_FCTRL_Register;
      --  SPI0 FSM status register
      FSM          : aliased FSM_Register;
      --  SPI0 timing calibration register
      TIMING_CALI  : aliased TIMING_CALI_Register;
      --  SPI0 input delay mode control register
      DIN_MODE     : aliased DIN_MODE_Register;
      --  SPI0 input delay number control register
      DIN_NUM      : aliased DIN_NUM_Register;
      --  SPI0 output delay mode control register
      DOUT_MODE    : aliased DOUT_MODE_Register;
      --  SPI0 clk_gate register
      CLOCK_GATE   : aliased CLOCK_GATE_Register;
      --  SPI0 module clock select register
      CORE_CLK_SEL : aliased CORE_CLK_SEL_Register;
      --  Version control register
      DATE         : aliased DATE_Register;
   end record
     with Volatile;

   for SPI0_Peripheral use record
      CTRL         at 16#8# range 0 .. 31;
      CTRL1        at 16#C# range 0 .. 31;
      CTRL2        at 16#10# range 0 .. 31;
      CLOCK        at 16#14# range 0 .. 31;
      USER         at 16#18# range 0 .. 31;
      USER1        at 16#1C# range 0 .. 31;
      USER2        at 16#20# range 0 .. 31;
      RD_STATUS    at 16#2C# range 0 .. 31;
      MISC         at 16#34# range 0 .. 31;
      CACHE_FCTRL  at 16#3C# range 0 .. 31;
      FSM          at 16#54# range 0 .. 31;
      TIMING_CALI  at 16#A8# range 0 .. 31;
      DIN_MODE     at 16#AC# range 0 .. 31;
      DIN_NUM      at 16#B0# range 0 .. 31;
      DOUT_MODE    at 16#B4# range 0 .. 31;
      CLOCK_GATE   at 16#DC# range 0 .. 31;
      CORE_CLK_SEL at 16#E0# range 0 .. 31;
      DATE         at 16#3FC# range 0 .. 31;
   end record;

   --  SPI (Serial Peripheral Interface) Controller 0
   SPI0_Periph : aliased SPI0_Peripheral
     with Import, Address => SPI0_Base;

end ESP32_C3.SPI0;
