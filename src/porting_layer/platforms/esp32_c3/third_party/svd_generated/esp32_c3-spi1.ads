pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.SPI1 is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype CMD_SPI1_MST_ST_Field is ESP32_C3.UInt4;
   subtype CMD_MSPI_ST_Field is ESP32_C3.UInt4;
   subtype CMD_FLASH_PE_Field is ESP32_C3.Bit;
   subtype CMD_USR_Field is ESP32_C3.Bit;
   subtype CMD_FLASH_HPM_Field is ESP32_C3.Bit;
   subtype CMD_FLASH_RES_Field is ESP32_C3.Bit;
   subtype CMD_FLASH_DP_Field is ESP32_C3.Bit;
   subtype CMD_FLASH_CE_Field is ESP32_C3.Bit;
   subtype CMD_FLASH_BE_Field is ESP32_C3.Bit;
   subtype CMD_FLASH_SE_Field is ESP32_C3.Bit;
   subtype CMD_FLASH_PP_Field is ESP32_C3.Bit;
   subtype CMD_FLASH_WRSR_Field is ESP32_C3.Bit;
   subtype CMD_FLASH_RDSR_Field is ESP32_C3.Bit;
   subtype CMD_FLASH_RDID_Field is ESP32_C3.Bit;
   subtype CMD_FLASH_WRDI_Field is ESP32_C3.Bit;
   subtype CMD_FLASH_WREN_Field is ESP32_C3.Bit;
   subtype CMD_FLASH_READ_Field is ESP32_C3.Bit;

   --  SPI1 memory command register
   type CMD_Register is record
      --  Read-only. The current status of SPI1 master FSM.
      SPI1_MST_ST   : CMD_SPI1_MST_ST_Field := 16#0#;
      --  Read-only. The current status of SPI1 slave FSM: mspi_st. 0: idle
      --  state, 1: preparation state, 2: send command state, 3: send address
      --  state, 4: wait state, 5: read data state, 6:write data state, 7: done
      --  state, 8: read data end state.
      MSPI_ST       : CMD_MSPI_ST_Field := 16#0#;
      --  unspecified
      Reserved_8_16 : ESP32_C3.UInt9 := 16#0#;
      --  In user mode, it is set to indicate that program/erase operation will
      --  be triggered. The bit is combined with spi_mem_usr bit. The bit will
      --  be cleared once the operation done.1: enable 0: disable.
      FLASH_PE      : CMD_FLASH_PE_Field := 16#0#;
      --  User define command enable. An operation will be triggered when the
      --  bit is set. The bit will be cleared once the operation done.1: enable
      --  0: disable.
      USR           : CMD_USR_Field := 16#0#;
      --  Drive Flash into high performance mode. The bit will be cleared once
      --  the operation done.1: enable 0: disable.
      FLASH_HPM     : CMD_FLASH_HPM_Field := 16#0#;
      --  This bit combined with reg_resandres bit releases Flash from the
      --  power-down state or high performance mode and obtains the devices ID.
      --  The bit will be cleared once the operation done.1: enable 0: disable.
      FLASH_RES     : CMD_FLASH_RES_Field := 16#0#;
      --  Drive Flash into power down. An operation will be triggered when the
      --  bit is set. The bit will be cleared once the operation done.1: enable
      --  0: disable.
      FLASH_DP      : CMD_FLASH_DP_Field := 16#0#;
      --  Chip erase enable. Chip erase operation will be triggered when the
      --  bit is set. The bit will be cleared once the operation done.1: enable
      --  0: disable.
      FLASH_CE      : CMD_FLASH_CE_Field := 16#0#;
      --  Block erase enable(32KB) . Block erase operation will be triggered
      --  when the bit is set. The bit will be cleared once the operation
      --  done.1: enable 0: disable.
      FLASH_BE      : CMD_FLASH_BE_Field := 16#0#;
      --  Sector erase enable(4KB). Sector erase operation will be triggered
      --  when the bit is set. The bit will be cleared once the operation
      --  done.1: enable 0: disable.
      FLASH_SE      : CMD_FLASH_SE_Field := 16#0#;
      --  Page program enable(1 byte ~256 bytes data to be programmed). Page
      --  program operation will be triggered when the bit is set. The bit will
      --  be cleared once the operation done .1: enable 0: disable.
      FLASH_PP      : CMD_FLASH_PP_Field := 16#0#;
      --  Write status register enable. Write status operation will be
      --  triggered when the bit is set. The bit will be cleared once the
      --  operation done.1: enable 0: disable.
      FLASH_WRSR    : CMD_FLASH_WRSR_Field := 16#0#;
      --  Read status register-1. Read status operation will be triggered when
      --  the bit is set. The bit will be cleared once the operation done.1:
      --  enable 0: disable.
      FLASH_RDSR    : CMD_FLASH_RDSR_Field := 16#0#;
      --  Read JEDEC ID . Read ID command will be sent when the bit is set. The
      --  bit will be cleared once the operation done. 1: enable 0: disable.
      FLASH_RDID    : CMD_FLASH_RDID_Field := 16#0#;
      --  Write flash disable. Write disable command will be sent when the bit
      --  is set. The bit will be cleared once the operation done. 1: enable 0:
      --  disable.
      FLASH_WRDI    : CMD_FLASH_WRDI_Field := 16#0#;
      --  Write flash enable. Write enable command will be sent when the bit is
      --  set. The bit will be cleared once the operation done. 1: enable 0:
      --  disable.
      FLASH_WREN    : CMD_FLASH_WREN_Field := 16#0#;
      --  Read flash enable. Read flash operation will be triggered when the
      --  bit is set. The bit will be cleared once the operation done. 1:
      --  enable 0: disable.
      FLASH_READ    : CMD_FLASH_READ_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CMD_Register use record
      SPI1_MST_ST   at 0 range 0 .. 3;
      MSPI_ST       at 0 range 4 .. 7;
      Reserved_8_16 at 0 range 8 .. 16;
      FLASH_PE      at 0 range 17 .. 17;
      USR           at 0 range 18 .. 18;
      FLASH_HPM     at 0 range 19 .. 19;
      FLASH_RES     at 0 range 20 .. 20;
      FLASH_DP      at 0 range 21 .. 21;
      FLASH_CE      at 0 range 22 .. 22;
      FLASH_BE      at 0 range 23 .. 23;
      FLASH_SE      at 0 range 24 .. 24;
      FLASH_PP      at 0 range 25 .. 25;
      FLASH_WRSR    at 0 range 26 .. 26;
      FLASH_RDSR    at 0 range 27 .. 27;
      FLASH_RDID    at 0 range 28 .. 28;
      FLASH_WRDI    at 0 range 29 .. 29;
      FLASH_WREN    at 0 range 30 .. 30;
      FLASH_READ    at 0 range 31 .. 31;
   end record;

   subtype CTRL_FDUMMY_OUT_Field is ESP32_C3.Bit;
   subtype CTRL_FCMD_DUAL_Field is ESP32_C3.Bit;
   subtype CTRL_FCMD_QUAD_Field is ESP32_C3.Bit;
   subtype CTRL_FCS_CRC_EN_Field is ESP32_C3.Bit;
   subtype CTRL_TX_CRC_EN_Field is ESP32_C3.Bit;
   subtype CTRL_FASTRD_MODE_Field is ESP32_C3.Bit;
   subtype CTRL_FREAD_DUAL_Field is ESP32_C3.Bit;
   subtype CTRL_RESANDRES_Field is ESP32_C3.Bit;
   subtype CTRL_Q_POL_Field is ESP32_C3.Bit;
   subtype CTRL_D_POL_Field is ESP32_C3.Bit;
   subtype CTRL_FREAD_QUAD_Field is ESP32_C3.Bit;
   subtype CTRL_WP_Field is ESP32_C3.Bit;
   subtype CTRL_WRSR_2B_Field is ESP32_C3.Bit;
   subtype CTRL_FREAD_DIO_Field is ESP32_C3.Bit;
   subtype CTRL_FREAD_QIO_Field is ESP32_C3.Bit;

   --  SPI1 control register.
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
      Reserved_9_9   : ESP32_C3.Bit := 16#0#;
      --  For SPI1, initialize crc32 module before writing encrypted data to
      --  flash. Active low.
      FCS_CRC_EN     : CTRL_FCS_CRC_EN_Field := 16#0#;
      --  For SPI1, enable crc32 when writing encrypted data to flash. 1:
      --  enable 0:disable
      TX_CRC_EN      : CTRL_TX_CRC_EN_Field := 16#0#;
      --  unspecified
      Reserved_12_12 : ESP32_C3.Bit := 16#0#;
      --  This bit enable the bits: spi_mem_fread_qio, spi_mem_fread_dio,
      --  spi_mem_fread_qout and spi_mem_fread_dout. 1: enable 0: disable.
      FASTRD_MODE    : CTRL_FASTRD_MODE_Field := 16#1#;
      --  In the read operations, read-data phase apply 2 signals. 1: enable 0:
      --  disable.
      FREAD_DUAL     : CTRL_FREAD_DUAL_Field := 16#0#;
      --  The Device ID is read out to SPI_MEM_RD_STATUS register, this bit
      --  combine with spi_mem_flash_res bit. 1: enable 0: disable.
      RESANDRES      : CTRL_RESANDRES_Field := 16#1#;
      --  unspecified
      Reserved_16_17 : ESP32_C3.UInt2 := 16#0#;
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
      --  two bytes data will be written to status register when it is set. 1:
      --  enable 0: disable.
      WRSR_2B        : CTRL_WRSR_2B_Field := 16#0#;
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
      Reserved_9_9   at 0 range 9 .. 9;
      FCS_CRC_EN     at 0 range 10 .. 10;
      TX_CRC_EN      at 0 range 11 .. 11;
      Reserved_12_12 at 0 range 12 .. 12;
      FASTRD_MODE    at 0 range 13 .. 13;
      FREAD_DUAL     at 0 range 14 .. 14;
      RESANDRES      at 0 range 15 .. 15;
      Reserved_16_17 at 0 range 16 .. 17;
      Q_POL          at 0 range 18 .. 18;
      D_POL          at 0 range 19 .. 19;
      FREAD_QUAD     at 0 range 20 .. 20;
      WP             at 0 range 21 .. 21;
      WRSR_2B        at 0 range 22 .. 22;
      FREAD_DIO      at 0 range 23 .. 23;
      FREAD_QIO      at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   subtype CTRL1_CLK_MODE_Field is ESP32_C3.UInt2;
   subtype CTRL1_CS_HOLD_DLY_RES_Field is ESP32_C3.UInt10;

   --  SPI1 control1 register.
   type CTRL1_Register is record
      --  SPI clock mode bits. 0: SPI clock is off when CS inactive 1: SPI
      --  clock is delayed one cycle after CS inactive 2: SPI clock is delayed
      --  two cycles after CS inactive 3: SPI clock is alwasy on.
      CLK_MODE        : CTRL1_CLK_MODE_Field := 16#0#;
      --  After RES/DP/HPM command is sent, SPI1 waits
      --  (SPI_MEM_CS_HOLD_DELAY_RES[9:0] * 512) SPI_CLK cycles.
      CS_HOLD_DLY_RES : CTRL1_CS_HOLD_DLY_RES_Field := 16#3FF#;
      --  unspecified
      Reserved_12_31  : ESP32_C3.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CTRL1_Register use record
      CLK_MODE        at 0 range 0 .. 1;
      CS_HOLD_DLY_RES at 0 range 2 .. 11;
      Reserved_12_31  at 0 range 12 .. 31;
   end record;

   subtype CTRL2_SYNC_RESET_Field is ESP32_C3.Bit;

   --  SPI1 control2 register.
   type CTRL2_Register is record
      --  unspecified
      Reserved_0_30 : ESP32_C3.UInt31 := 16#0#;
      --  Write-only. The FSM will be reset.
      SYNC_RESET    : CTRL2_SYNC_RESET_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CTRL2_Register use record
      Reserved_0_30 at 0 range 0 .. 30;
      SYNC_RESET    at 0 range 31 .. 31;
   end record;

   subtype CLOCK_CLKCNT_L_Field is ESP32_C3.Byte;
   subtype CLOCK_CLKCNT_H_Field is ESP32_C3.Byte;
   subtype CLOCK_CLKCNT_N_Field is ESP32_C3.Byte;
   subtype CLOCK_CLK_EQU_SYSCLK_Field is ESP32_C3.Bit;

   --  SPI1 clock division control register.
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
      --  reserved
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

   subtype USER_CK_OUT_EDGE_Field is ESP32_C3.Bit;
   subtype USER_FWRITE_DUAL_Field is ESP32_C3.Bit;
   subtype USER_FWRITE_QUAD_Field is ESP32_C3.Bit;
   subtype USER_FWRITE_DIO_Field is ESP32_C3.Bit;
   subtype USER_FWRITE_QIO_Field is ESP32_C3.Bit;
   subtype USER_USR_MISO_HIGHPART_Field is ESP32_C3.Bit;
   subtype USER_USR_MOSI_HIGHPART_Field is ESP32_C3.Bit;
   subtype USER_USR_DUMMY_IDLE_Field is ESP32_C3.Bit;
   subtype USER_USR_MOSI_Field is ESP32_C3.Bit;
   subtype USER_USR_MISO_Field is ESP32_C3.Bit;
   subtype USER_USR_DUMMY_Field is ESP32_C3.Bit;
   subtype USER_USR_ADDR_Field is ESP32_C3.Bit;
   subtype USER_USR_COMMAND_Field is ESP32_C3.Bit;

   --  SPI1 user register.
   type USER_Register is record
      --  unspecified
      Reserved_0_8      : ESP32_C3.UInt9 := 16#0#;
      --  the bit combined with spi_mem_mosi_delay_mode bits to set mosi signal
      --  delay mode.
      CK_OUT_EDGE       : USER_CK_OUT_EDGE_Field := 16#0#;
      --  unspecified
      Reserved_10_11    : ESP32_C3.UInt2 := 16#0#;
      --  In the write operations read-data phase apply 2 signals
      FWRITE_DUAL       : USER_FWRITE_DUAL_Field := 16#0#;
      --  In the write operations read-data phase apply 4 signals
      FWRITE_QUAD       : USER_FWRITE_QUAD_Field := 16#0#;
      --  In the write operations address phase and read-data phase apply 2
      --  signals.
      FWRITE_DIO        : USER_FWRITE_DIO_Field := 16#0#;
      --  In the write operations address phase and read-data phase apply 4
      --  signals.
      FWRITE_QIO        : USER_FWRITE_QIO_Field := 16#0#;
      --  unspecified
      Reserved_16_23    : ESP32_C3.Byte := 16#0#;
      --  read-data phase only access to high-part of the buffer
      --  spi_mem_w8~spi_mem_w15. 1: enable 0: disable.
      USR_MISO_HIGHPART : USER_USR_MISO_HIGHPART_Field := 16#0#;
      --  write-data phase only access to high-part of the buffer
      --  spi_mem_w8~spi_mem_w15. 1: enable 0: disable.
      USR_MOSI_HIGHPART : USER_USR_MOSI_HIGHPART_Field := 16#0#;
      --  SPI clock is disable in dummy phase when the bit is enable.
      USR_DUMMY_IDLE    : USER_USR_DUMMY_IDLE_Field := 16#0#;
      --  This bit enable the write-data phase of an operation.
      USR_MOSI          : USER_USR_MOSI_Field := 16#0#;
      --  This bit enable the read-data phase of an operation.
      USR_MISO          : USER_USR_MISO_Field := 16#0#;
      --  This bit enable the dummy phase of an operation.
      USR_DUMMY         : USER_USR_DUMMY_Field := 16#0#;
      --  This bit enable the address phase of an operation.
      USR_ADDR          : USER_USR_ADDR_Field := 16#0#;
      --  This bit enable the command phase of an operation.
      USR_COMMAND       : USER_USR_COMMAND_Field := 16#1#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for USER_Register use record
      Reserved_0_8      at 0 range 0 .. 8;
      CK_OUT_EDGE       at 0 range 9 .. 9;
      Reserved_10_11    at 0 range 10 .. 11;
      FWRITE_DUAL       at 0 range 12 .. 12;
      FWRITE_QUAD       at 0 range 13 .. 13;
      FWRITE_DIO        at 0 range 14 .. 14;
      FWRITE_QIO        at 0 range 15 .. 15;
      Reserved_16_23    at 0 range 16 .. 23;
      USR_MISO_HIGHPART at 0 range 24 .. 24;
      USR_MOSI_HIGHPART at 0 range 25 .. 25;
      USR_DUMMY_IDLE    at 0 range 26 .. 26;
      USR_MOSI          at 0 range 27 .. 27;
      USR_MISO          at 0 range 28 .. 28;
      USR_DUMMY         at 0 range 29 .. 29;
      USR_ADDR          at 0 range 30 .. 30;
      USR_COMMAND       at 0 range 31 .. 31;
   end record;

   subtype USER1_USR_DUMMY_CYCLELEN_Field is ESP32_C3.UInt6;
   subtype USER1_USR_ADDR_BITLEN_Field is ESP32_C3.UInt6;

   --  SPI1 user1 register.
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

   --  SPI1 user2 register.
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

   subtype MOSI_DLEN_USR_MOSI_DBITLEN_Field is ESP32_C3.UInt10;

   --  SPI1 send data bit length control register.
   type MOSI_DLEN_Register is record
      --  The length in bits of write-data. The register value shall be
      --  (bit_num-1).
      USR_MOSI_DBITLEN : MOSI_DLEN_USR_MOSI_DBITLEN_Field := 16#0#;
      --  unspecified
      Reserved_10_31   : ESP32_C3.UInt22 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for MOSI_DLEN_Register use record
      USR_MOSI_DBITLEN at 0 range 0 .. 9;
      Reserved_10_31   at 0 range 10 .. 31;
   end record;

   subtype MISO_DLEN_USR_MISO_DBITLEN_Field is ESP32_C3.UInt10;

   --  SPI1 receive data bit length control register.
   type MISO_DLEN_Register is record
      --  The length in bits of read-data. The register value shall be
      --  (bit_num-1).
      USR_MISO_DBITLEN : MISO_DLEN_USR_MISO_DBITLEN_Field := 16#0#;
      --  unspecified
      Reserved_10_31   : ESP32_C3.UInt22 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for MISO_DLEN_Register use record
      USR_MISO_DBITLEN at 0 range 0 .. 9;
      Reserved_10_31   at 0 range 10 .. 31;
   end record;

   subtype RD_STATUS_STATUS_Field is ESP32_C3.UInt16;
   subtype RD_STATUS_WB_MODE_Field is ESP32_C3.Byte;

   --  SPI1 status register.
   type RD_STATUS_Register is record
      --  The value is stored when set spi_mem_flash_rdsr bit and
      --  spi_mem_flash_res bit.
      STATUS         : RD_STATUS_STATUS_Field := 16#0#;
      --  Mode bits in the flash fast read mode it is combined with
      --  spi_mem_fastrd_mode bit.
      WB_MODE        : RD_STATUS_WB_MODE_Field := 16#0#;
      --  unspecified
      Reserved_24_31 : ESP32_C3.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RD_STATUS_Register use record
      STATUS         at 0 range 0 .. 15;
      WB_MODE        at 0 range 16 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   subtype MISC_CS0_DIS_Field is ESP32_C3.Bit;
   subtype MISC_CS1_DIS_Field is ESP32_C3.Bit;
   subtype MISC_CK_IDLE_EDGE_Field is ESP32_C3.Bit;
   subtype MISC_CS_KEEP_ACTIVE_Field is ESP32_C3.Bit;

   --  SPI1 misc register
   type MISC_Register is record
      --  SPI_CS0 pin enable, 1: disable SPI_CS0, 0: SPI_CS0 pin is active to
      --  select SPI device, such as flash, external RAM and so on.
      CS0_DIS        : MISC_CS0_DIS_Field := 16#0#;
      --  SPI_CS1 pin enable, 1: disable SPI_CS1, 0: SPI_CS1 pin is active to
      --  select SPI device, such as flash, external RAM and so on.
      CS1_DIS        : MISC_CS1_DIS_Field := 16#1#;
      --  unspecified
      Reserved_2_8   : ESP32_C3.UInt7 := 16#0#;
      --  1: spi clk line is high when idle 0: spi clk line is low when idle
      CK_IDLE_EDGE   : MISC_CK_IDLE_EDGE_Field := 16#0#;
      --  spi cs line keep low when the bit is set.
      CS_KEEP_ACTIVE : MISC_CS_KEEP_ACTIVE_Field := 16#0#;
      --  unspecified
      Reserved_11_31 : ESP32_C3.UInt21 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for MISC_Register use record
      CS0_DIS        at 0 range 0 .. 0;
      CS1_DIS        at 0 range 1 .. 1;
      Reserved_2_8   at 0 range 2 .. 8;
      CK_IDLE_EDGE   at 0 range 9 .. 9;
      CS_KEEP_ACTIVE at 0 range 10 .. 10;
      Reserved_11_31 at 0 range 11 .. 31;
   end record;

   subtype CACHE_FCTRL_CACHE_USR_ADDR_4BYTE_Field is ESP32_C3.Bit;
   subtype CACHE_FCTRL_FDIN_DUAL_Field is ESP32_C3.Bit;
   subtype CACHE_FCTRL_FDOUT_DUAL_Field is ESP32_C3.Bit;
   subtype CACHE_FCTRL_FADDR_DUAL_Field is ESP32_C3.Bit;
   subtype CACHE_FCTRL_FDIN_QUAD_Field is ESP32_C3.Bit;
   subtype CACHE_FCTRL_FDOUT_QUAD_Field is ESP32_C3.Bit;
   subtype CACHE_FCTRL_FADDR_QUAD_Field is ESP32_C3.Bit;

   --  SPI1 bit mode control register.
   type CACHE_FCTRL_Register is record
      --  unspecified
      Reserved_0_0         : ESP32_C3.Bit := 16#0#;
      --  For SPI1, cache read flash with 4 bytes address, 1: enable,
      --  0:disable.
      CACHE_USR_ADDR_4BYTE : CACHE_FCTRL_CACHE_USR_ADDR_4BYTE_Field := 16#0#;
      --  unspecified
      Reserved_2_2         : ESP32_C3.Bit := 16#0#;
      --  For SPI1, din phase apply 2 signals. 1: enable 0: disable. The bit is
      --  the same with spi_mem_fread_dio.
      FDIN_DUAL            : CACHE_FCTRL_FDIN_DUAL_Field := 16#0#;
      --  For SPI1, dout phase apply 2 signals. 1: enable 0: disable. The bit
      --  is the same with spi_mem_fread_dio.
      FDOUT_DUAL           : CACHE_FCTRL_FDOUT_DUAL_Field := 16#0#;
      --  For SPI1, address phase apply 2 signals. 1: enable 0: disable. The
      --  bit is the same with spi_mem_fread_dio.
      FADDR_DUAL           : CACHE_FCTRL_FADDR_DUAL_Field := 16#0#;
      --  For SPI1, din phase apply 4 signals. 1: enable 0: disable. The bit is
      --  the same with spi_mem_fread_qio.
      FDIN_QUAD            : CACHE_FCTRL_FDIN_QUAD_Field := 16#0#;
      --  For SPI1, dout phase apply 4 signals. 1: enable 0: disable. The bit
      --  is the same with spi_mem_fread_qio.
      FDOUT_QUAD           : CACHE_FCTRL_FDOUT_QUAD_Field := 16#0#;
      --  For SPI1, address phase apply 4 signals. 1: enable 0: disable. The
      --  bit is the same with spi_mem_fread_qio.
      FADDR_QUAD           : CACHE_FCTRL_FADDR_QUAD_Field := 16#0#;
      --  unspecified
      Reserved_9_31        : ESP32_C3.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_FCTRL_Register use record
      Reserved_0_0         at 0 range 0 .. 0;
      CACHE_USR_ADDR_4BYTE at 0 range 1 .. 1;
      Reserved_2_2         at 0 range 2 .. 2;
      FDIN_DUAL            at 0 range 3 .. 3;
      FDOUT_DUAL           at 0 range 4 .. 4;
      FADDR_DUAL           at 0 range 5 .. 5;
      FDIN_QUAD            at 0 range 6 .. 6;
      FDOUT_QUAD           at 0 range 7 .. 7;
      FADDR_QUAD           at 0 range 8 .. 8;
      Reserved_9_31        at 0 range 9 .. 31;
   end record;

   subtype FLASH_WAITI_CTRL_WAITI_DUMMY_Field is ESP32_C3.Bit;
   subtype FLASH_WAITI_CTRL_WAITI_CMD_Field is ESP32_C3.Byte;
   subtype FLASH_WAITI_CTRL_WAITI_DUMMY_CYCLELEN_Field is ESP32_C3.UInt6;

   --  SPI1 wait idle control register
   type FLASH_WAITI_CTRL_Register is record
      --  unspecified
      Reserved_0_0         : ESP32_C3.Bit := 16#0#;
      --  The dummy phase enable when wait flash idle (RDSR)
      WAITI_DUMMY          : FLASH_WAITI_CTRL_WAITI_DUMMY_Field := 16#0#;
      --  The command to wait flash idle(RDSR).
      WAITI_CMD            : FLASH_WAITI_CTRL_WAITI_CMD_Field := 16#5#;
      --  The dummy cycle length when wait flash idle(RDSR).
      WAITI_DUMMY_CYCLELEN : FLASH_WAITI_CTRL_WAITI_DUMMY_CYCLELEN_Field :=
                              16#0#;
      --  unspecified
      Reserved_16_31       : ESP32_C3.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_WAITI_CTRL_Register use record
      Reserved_0_0         at 0 range 0 .. 0;
      WAITI_DUMMY          at 0 range 1 .. 1;
      WAITI_CMD            at 0 range 2 .. 9;
      WAITI_DUMMY_CYCLELEN at 0 range 10 .. 15;
      Reserved_16_31       at 0 range 16 .. 31;
   end record;

   subtype FLASH_SUS_CTRL_FLASH_PER_Field is ESP32_C3.Bit;
   subtype FLASH_SUS_CTRL_FLASH_PES_Field is ESP32_C3.Bit;
   subtype FLASH_SUS_CTRL_FLASH_PER_WAIT_EN_Field is ESP32_C3.Bit;
   subtype FLASH_SUS_CTRL_FLASH_PES_WAIT_EN_Field is ESP32_C3.Bit;
   subtype FLASH_SUS_CTRL_PES_PER_EN_Field is ESP32_C3.Bit;
   subtype FLASH_SUS_CTRL_FLASH_PES_EN_Field is ESP32_C3.Bit;
   subtype FLASH_SUS_CTRL_PESR_END_MSK_Field is ESP32_C3.UInt16;
   subtype FLASH_SUS_CTRL_RD_SUS_2B_Field is ESP32_C3.Bit;
   subtype FLASH_SUS_CTRL_PER_END_EN_Field is ESP32_C3.Bit;
   subtype FLASH_SUS_CTRL_PES_END_EN_Field is ESP32_C3.Bit;
   subtype FLASH_SUS_CTRL_SUS_TIMEOUT_CNT_Field is ESP32_C3.UInt7;

   --  SPI1 flash suspend control register
   type FLASH_SUS_CTRL_Register is record
      --  program erase resume bit, program erase suspend operation will be
      --  triggered when the bit is set. The bit will be cleared once the
      --  operation done.1: enable 0: disable.
      FLASH_PER         : FLASH_SUS_CTRL_FLASH_PER_Field := 16#0#;
      --  program erase suspend bit, program erase suspend operation will be
      --  triggered when the bit is set. The bit will be cleared once the
      --  operation done.1: enable 0: disable.
      FLASH_PES         : FLASH_SUS_CTRL_FLASH_PES_Field := 16#0#;
      --  1: SPI1 waits (SPI_MEM_CS_HOLD_DELAY_RES[9:0] * 4 or *128) SPI_CLK
      --  cycles after program erase resume command is sent. 0: SPI1 does not
      --  wait after program erase resume command is sent.
      FLASH_PER_WAIT_EN : FLASH_SUS_CTRL_FLASH_PER_WAIT_EN_Field := 16#0#;
      --  1: SPI1 waits (SPI_MEM_CS_HOLD_DELAY_RES[9:0] * 4 or *128) SPI_CLK
      --  cycles after program erase suspend command is sent. 0: SPI1 does not
      --  wait after program erase suspend command is sent.
      FLASH_PES_WAIT_EN : FLASH_SUS_CTRL_FLASH_PES_WAIT_EN_Field := 16#0#;
      --  Set this bit to enable PES end triggers PER transfer option. If this
      --  bit is 0, application should send PER after PES is done.
      PES_PER_EN        : FLASH_SUS_CTRL_PES_PER_EN_Field := 16#0#;
      --  Set this bit to enable Auto-suspending function.
      FLASH_PES_EN      : FLASH_SUS_CTRL_FLASH_PES_EN_Field := 16#0#;
      --  The mask value when check SUS/SUS1/SUS2 status bit. If the read
      --  status value is status_in[15:0](only status_in[7:0] is valid when
      --  only one byte of data is read out, status_in[15:0] is valid when two
      --  bytes of data are read out), SUS/SUS1/SUS2 = status_in[15:0]^
      --  SPI_MEM_PESR_END_MSK[15:0].
      PESR_END_MSK      : FLASH_SUS_CTRL_PESR_END_MSK_Field := 16#80#;
      --  1: Read two bytes when check flash SUS/SUS1/SUS2 status bit. 0: Read
      --  one byte when check flash SUS/SUS1/SUS2 status bit
      RD_SUS_2B         : FLASH_SUS_CTRL_RD_SUS_2B_Field := 16#0#;
      --  1: Both WIP and SUS/SUS1/SUS2 bits should be checked to insure the
      --  resume status of flash. 0: Only need to check WIP is 0.
      PER_END_EN        : FLASH_SUS_CTRL_PER_END_EN_Field := 16#0#;
      --  1: Both WIP and SUS/SUS1/SUS2 bits should be checked to insure the
      --  suspend status of flash. 0: Only need to check WIP is 0.
      PES_END_EN        : FLASH_SUS_CTRL_PES_END_EN_Field := 16#0#;
      --  When SPI1 checks SUS/SUS1/SUS2 bits fail for
      --  SPI_MEM_SUS_TIMEOUT_CNT[6:0] times, it will be treated as check pass.
      SUS_TIMEOUT_CNT   : FLASH_SUS_CTRL_SUS_TIMEOUT_CNT_Field := 16#4#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_SUS_CTRL_Register use record
      FLASH_PER         at 0 range 0 .. 0;
      FLASH_PES         at 0 range 1 .. 1;
      FLASH_PER_WAIT_EN at 0 range 2 .. 2;
      FLASH_PES_WAIT_EN at 0 range 3 .. 3;
      PES_PER_EN        at 0 range 4 .. 4;
      FLASH_PES_EN      at 0 range 5 .. 5;
      PESR_END_MSK      at 0 range 6 .. 21;
      RD_SUS_2B         at 0 range 22 .. 22;
      PER_END_EN        at 0 range 23 .. 23;
      PES_END_EN        at 0 range 24 .. 24;
      SUS_TIMEOUT_CNT   at 0 range 25 .. 31;
   end record;

   subtype FLASH_SUS_CMD_FLASH_PER_COMMAND_Field is ESP32_C3.Byte;
   subtype FLASH_SUS_CMD_FLASH_PES_COMMAND_Field is ESP32_C3.Byte;
   subtype FLASH_SUS_CMD_WAIT_PESR_COMMAND_Field is ESP32_C3.UInt16;

   --  SPI1 flash suspend command register
   type FLASH_SUS_CMD_Register is record
      --  Program/Erase resume command.
      FLASH_PER_COMMAND : FLASH_SUS_CMD_FLASH_PER_COMMAND_Field := 16#7A#;
      --  Program/Erase suspend command.
      FLASH_PES_COMMAND : FLASH_SUS_CMD_FLASH_PES_COMMAND_Field := 16#75#;
      --  Flash SUS/SUS1/SUS2 status bit read command. The command should be
      --  sent when SUS/SUS1/SUS2 bit should be checked to insure the suspend
      --  or resume status of flash.
      WAIT_PESR_COMMAND : FLASH_SUS_CMD_WAIT_PESR_COMMAND_Field := 16#5#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLASH_SUS_CMD_Register use record
      FLASH_PER_COMMAND at 0 range 0 .. 7;
      FLASH_PES_COMMAND at 0 range 8 .. 15;
      WAIT_PESR_COMMAND at 0 range 16 .. 31;
   end record;

   subtype SUS_STATUS_FLASH_SUS_Field is ESP32_C3.Bit;
   subtype SUS_STATUS_WAIT_PESR_CMD_2B_Field is ESP32_C3.Bit;
   subtype SUS_STATUS_FLASH_HPM_DLY_128_Field is ESP32_C3.Bit;
   subtype SUS_STATUS_FLASH_RES_DLY_128_Field is ESP32_C3.Bit;
   subtype SUS_STATUS_FLASH_DP_DLY_128_Field is ESP32_C3.Bit;
   subtype SUS_STATUS_FLASH_PER_DLY_128_Field is ESP32_C3.Bit;
   subtype SUS_STATUS_FLASH_PES_DLY_128_Field is ESP32_C3.Bit;
   subtype SUS_STATUS_SPI0_LOCK_EN_Field is ESP32_C3.Bit;

   --  SPI1 flash suspend status register
   type SUS_STATUS_Register is record
      --  The status of flash suspend, only used in SPI1.
      FLASH_SUS         : SUS_STATUS_FLASH_SUS_Field := 16#0#;
      --  1: SPI1 sends out SPI_MEM_WAIT_PESR_COMMAND[15:0] to check
      --  SUS/SUS1/SUS2 bit. 0: SPI1 sends out SPI_MEM_WAIT_PESR_COMMAND[7:0]
      --  to check SUS/SUS1/SUS2 bit.
      WAIT_PESR_CMD_2B  : SUS_STATUS_WAIT_PESR_CMD_2B_Field := 16#0#;
      --  1: SPI1 waits (SPI_MEM_CS_HOLD_DELAY_RES[9:0] * 128) SPI_CLK cycles
      --  after HPM command is sent. 0: SPI1 waits
      --  (SPI_MEM_CS_HOLD_DELAY_RES[9:0] * 4) SPI_CLK cycles after HPM command
      --  is sent.
      FLASH_HPM_DLY_128 : SUS_STATUS_FLASH_HPM_DLY_128_Field := 16#0#;
      --  1: SPI1 waits (SPI_MEM_CS_HOLD_DELAY_RES[9:0] * 128) SPI_CLK cycles
      --  after RES command is sent. 0: SPI1 waits
      --  (SPI_MEM_CS_HOLD_DELAY_RES[9:0] * 4) SPI_CLK cycles after RES command
      --  is sent.
      FLASH_RES_DLY_128 : SUS_STATUS_FLASH_RES_DLY_128_Field := 16#0#;
      --  1: SPI1 waits (SPI_MEM_CS_HOLD_DELAY_RES[9:0] * 128) SPI_CLK cycles
      --  after DP command is sent. 0: SPI1 waits
      --  (SPI_MEM_CS_HOLD_DELAY_RES[9:0] * 4) SPI_CLK cycles after DP command
      --  is sent.
      FLASH_DP_DLY_128  : SUS_STATUS_FLASH_DP_DLY_128_Field := 16#0#;
      --  Valid when SPI_MEM_FLASH_PER_WAIT_EN is 1. 1: SPI1 waits
      --  (SPI_MEM_CS_HOLD_DELAY_RES[9:0] * 128) SPI_CLK cycles after PER
      --  command is sent. 0: SPI1 waits (SPI_MEM_CS_HOLD_DELAY_RES[9:0] * 4)
      --  SPI_CLK cycles after PER command is sent.
      FLASH_PER_DLY_128 : SUS_STATUS_FLASH_PER_DLY_128_Field := 16#0#;
      --  Valid when SPI_MEM_FLASH_PES_WAIT_EN is 1. 1: SPI1 waits
      --  (SPI_MEM_CS_HOLD_DELAY_RES[9:0] * 128) SPI_CLK cycles after PES
      --  command is sent. 0: SPI1 waits (SPI_MEM_CS_HOLD_DELAY_RES[9:0] * 4)
      --  SPI_CLK cycles after PES command is sent.
      FLASH_PES_DLY_128 : SUS_STATUS_FLASH_PES_DLY_128_Field := 16#0#;
      --  1: Enable SPI0 lock SPI0/1 arbiter option. 0: Disable it.
      SPI0_LOCK_EN      : SUS_STATUS_SPI0_LOCK_EN_Field := 16#0#;
      --  unspecified
      Reserved_8_31     : ESP32_C3.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SUS_STATUS_Register use record
      FLASH_SUS         at 0 range 0 .. 0;
      WAIT_PESR_CMD_2B  at 0 range 1 .. 1;
      FLASH_HPM_DLY_128 at 0 range 2 .. 2;
      FLASH_RES_DLY_128 at 0 range 3 .. 3;
      FLASH_DP_DLY_128  at 0 range 4 .. 4;
      FLASH_PER_DLY_128 at 0 range 5 .. 5;
      FLASH_PES_DLY_128 at 0 range 6 .. 6;
      SPI0_LOCK_EN      at 0 range 7 .. 7;
      Reserved_8_31     at 0 range 8 .. 31;
   end record;

   subtype TIMING_CALI_TIMING_CALI_Field is ESP32_C3.Bit;
   subtype TIMING_CALI_EXTRA_DUMMY_CYCLELEN_Field is ESP32_C3.UInt3;

   --  SPI1 timing control register
   type TIMING_CALI_Register is record
      --  unspecified
      Reserved_0_0         : ESP32_C3.Bit := 16#0#;
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
      Reserved_0_0         at 0 range 0 .. 0;
      TIMING_CALI          at 0 range 1 .. 1;
      EXTRA_DUMMY_CYCLELEN at 0 range 2 .. 4;
      Reserved_5_31        at 0 range 5 .. 31;
   end record;

   subtype INT_ENA_PER_END_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_PES_END_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_WPE_END_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_SLV_ST_END_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_MST_ST_END_INT_ENA_Field is ESP32_C3.Bit;

   --  SPI1 interrupt enable register
   type INT_ENA_Register is record
      --  The enable bit for SPI_MEM_PER_END_INT interrupt.
      PER_END_INT_ENA    : INT_ENA_PER_END_INT_ENA_Field := 16#0#;
      --  The enable bit for SPI_MEM_PES_END_INT interrupt.
      PES_END_INT_ENA    : INT_ENA_PES_END_INT_ENA_Field := 16#0#;
      --  The enable bit for SPI_MEM_WPE_END_INT interrupt.
      WPE_END_INT_ENA    : INT_ENA_WPE_END_INT_ENA_Field := 16#0#;
      --  The enable bit for SPI_MEM_SLV_ST_END_INT interrupt.
      SLV_ST_END_INT_ENA : INT_ENA_SLV_ST_END_INT_ENA_Field := 16#0#;
      --  The enable bit for SPI_MEM_MST_ST_END_INT interrupt.
      MST_ST_END_INT_ENA : INT_ENA_MST_ST_END_INT_ENA_Field := 16#0#;
      --  unspecified
      Reserved_5_31      : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_ENA_Register use record
      PER_END_INT_ENA    at 0 range 0 .. 0;
      PES_END_INT_ENA    at 0 range 1 .. 1;
      WPE_END_INT_ENA    at 0 range 2 .. 2;
      SLV_ST_END_INT_ENA at 0 range 3 .. 3;
      MST_ST_END_INT_ENA at 0 range 4 .. 4;
      Reserved_5_31      at 0 range 5 .. 31;
   end record;

   subtype INT_CLR_PER_END_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_PES_END_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_WPE_END_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_SLV_ST_END_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_MST_ST_END_INT_CLR_Field is ESP32_C3.Bit;

   --  SPI1 interrupt clear register
   type INT_CLR_Register is record
      --  Write-only. The clear bit for SPI_MEM_PER_END_INT interrupt.
      PER_END_INT_CLR    : INT_CLR_PER_END_INT_CLR_Field := 16#0#;
      --  Write-only. The clear bit for SPI_MEM_PES_END_INT interrupt.
      PES_END_INT_CLR    : INT_CLR_PES_END_INT_CLR_Field := 16#0#;
      --  Write-only. The clear bit for SPI_MEM_WPE_END_INT interrupt.
      WPE_END_INT_CLR    : INT_CLR_WPE_END_INT_CLR_Field := 16#0#;
      --  Write-only. The clear bit for SPI_MEM_SLV_ST_END_INT interrupt.
      SLV_ST_END_INT_CLR : INT_CLR_SLV_ST_END_INT_CLR_Field := 16#0#;
      --  Write-only. The clear bit for SPI_MEM_MST_ST_END_INT interrupt.
      MST_ST_END_INT_CLR : INT_CLR_MST_ST_END_INT_CLR_Field := 16#0#;
      --  unspecified
      Reserved_5_31      : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_CLR_Register use record
      PER_END_INT_CLR    at 0 range 0 .. 0;
      PES_END_INT_CLR    at 0 range 1 .. 1;
      WPE_END_INT_CLR    at 0 range 2 .. 2;
      SLV_ST_END_INT_CLR at 0 range 3 .. 3;
      MST_ST_END_INT_CLR at 0 range 4 .. 4;
      Reserved_5_31      at 0 range 5 .. 31;
   end record;

   subtype INT_RAW_PER_END_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_PES_END_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_WPE_END_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_SLV_ST_END_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_MST_ST_END_INT_RAW_Field is ESP32_C3.Bit;

   --  SPI1 interrupt raw register
   type INT_RAW_Register is record
      --  The raw bit for SPI_MEM_PER_END_INT interrupt. 1: Triggered when Auto
      --  Resume command (0x7A) is sent and flash is resumed. 0: Others.
      PER_END_INT_RAW    : INT_RAW_PER_END_INT_RAW_Field := 16#0#;
      --  The raw bit for SPI_MEM_PES_END_INT interrupt.1: Triggered when Auto
      --  Suspend command (0x75) is sent and flash is suspended. 0: Others.
      PES_END_INT_RAW    : INT_RAW_PES_END_INT_RAW_Field := 16#0#;
      --  The raw bit for SPI_MEM_WPE_END_INT interrupt. 1: Triggered when
      --  WRSR/PP/SE/BE/CE is sent and flash is already idle. 0: Others.
      WPE_END_INT_RAW    : INT_RAW_WPE_END_INT_RAW_Field := 16#0#;
      --  The raw bit for SPI_MEM_SLV_ST_END_INT interrupt. 1: Triggered when
      --  spi1_slv_st is changed from non idle state to idle state. It means
      --  that SPI_CS raises high. 0: Others
      SLV_ST_END_INT_RAW : INT_RAW_SLV_ST_END_INT_RAW_Field := 16#0#;
      --  The raw bit for SPI_MEM_MST_ST_END_INT interrupt. 1: Triggered when
      --  spi1_mst_st is changed from non idle state to idle state. 0: Others.
      MST_ST_END_INT_RAW : INT_RAW_MST_ST_END_INT_RAW_Field := 16#0#;
      --  unspecified
      Reserved_5_31      : ESP32_C3.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_RAW_Register use record
      PER_END_INT_RAW    at 0 range 0 .. 0;
      PES_END_INT_RAW    at 0 range 1 .. 1;
      WPE_END_INT_RAW    at 0 range 2 .. 2;
      SLV_ST_END_INT_RAW at 0 range 3 .. 3;
      MST_ST_END_INT_RAW at 0 range 4 .. 4;
      Reserved_5_31      at 0 range 5 .. 31;
   end record;

   subtype INT_ST_PER_END_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_PES_END_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_WPE_END_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_SLV_ST_END_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_MST_ST_END_INT_ST_Field is ESP32_C3.Bit;

   --  SPI1 interrupt status register
   type INT_ST_Register is record
      --  Read-only. The status bit for SPI_MEM_PER_END_INT interrupt.
      PER_END_INT_ST    : INT_ST_PER_END_INT_ST_Field;
      --  Read-only. The status bit for SPI_MEM_PES_END_INT interrupt.
      PES_END_INT_ST    : INT_ST_PES_END_INT_ST_Field;
      --  Read-only. The status bit for SPI_MEM_WPE_END_INT interrupt.
      WPE_END_INT_ST    : INT_ST_WPE_END_INT_ST_Field;
      --  Read-only. The status bit for SPI_MEM_SLV_ST_END_INT interrupt.
      SLV_ST_END_INT_ST : INT_ST_SLV_ST_END_INT_ST_Field;
      --  Read-only. The status bit for SPI_MEM_MST_ST_END_INT interrupt.
      MST_ST_END_INT_ST : INT_ST_MST_ST_END_INT_ST_Field;
      --  unspecified
      Reserved_5_31     : ESP32_C3.UInt27;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_ST_Register use record
      PER_END_INT_ST    at 0 range 0 .. 0;
      PES_END_INT_ST    at 0 range 1 .. 1;
      WPE_END_INT_ST    at 0 range 2 .. 2;
      SLV_ST_END_INT_ST at 0 range 3 .. 3;
      MST_ST_END_INT_ST at 0 range 4 .. 4;
      Reserved_5_31     at 0 range 5 .. 31;
   end record;

   subtype CLOCK_GATE_CLK_EN_Field is ESP32_C3.Bit;

   --  SPI1 clk_gate register
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

   subtype DATE_DATE_Field is ESP32_C3.UInt28;

   --  Version control register
   type DATE_Register is record
      --  Version control register
      DATE           : DATE_DATE_Field := 16#2007170#;
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

   --  SPI (Serial Peripheral Interface) Controller 1
   type SPI1_Peripheral is record
      --  SPI1 memory command register
      CMD              : aliased CMD_Register;
      --  SPI1 address register
      ADDR             : aliased ESP32_C3.UInt32;
      --  SPI1 control register.
      CTRL             : aliased CTRL_Register;
      --  SPI1 control1 register.
      CTRL1            : aliased CTRL1_Register;
      --  SPI1 control2 register.
      CTRL2            : aliased CTRL2_Register;
      --  SPI1 clock division control register.
      CLOCK            : aliased CLOCK_Register;
      --  SPI1 user register.
      USER             : aliased USER_Register;
      --  SPI1 user1 register.
      USER1            : aliased USER1_Register;
      --  SPI1 user2 register.
      USER2            : aliased USER2_Register;
      --  SPI1 send data bit length control register.
      MOSI_DLEN        : aliased MOSI_DLEN_Register;
      --  SPI1 receive data bit length control register.
      MISO_DLEN        : aliased MISO_DLEN_Register;
      --  SPI1 status register.
      RD_STATUS        : aliased RD_STATUS_Register;
      --  SPI1 misc register
      MISC             : aliased MISC_Register;
      --  SPI1 TX CRC data register.
      TX_CRC           : aliased ESP32_C3.UInt32;
      --  SPI1 bit mode control register.
      CACHE_FCTRL      : aliased CACHE_FCTRL_Register;
      --  SPI1 memory data buffer0
      W0               : aliased ESP32_C3.UInt32;
      --  SPI1 memory data buffer1
      W1               : aliased ESP32_C3.UInt32;
      --  SPI1 memory data buffer2
      W2               : aliased ESP32_C3.UInt32;
      --  SPI1 memory data buffer3
      W3               : aliased ESP32_C3.UInt32;
      --  SPI1 memory data buffer4
      W4               : aliased ESP32_C3.UInt32;
      --  SPI1 memory data buffer5
      W5               : aliased ESP32_C3.UInt32;
      --  SPI1 memory data buffer6
      W6               : aliased ESP32_C3.UInt32;
      --  SPI1 memory data buffer7
      W7               : aliased ESP32_C3.UInt32;
      --  SPI1 memory data buffer8
      W8               : aliased ESP32_C3.UInt32;
      --  SPI1 memory data buffer9
      W9               : aliased ESP32_C3.UInt32;
      --  SPI1 memory data buffer10
      W10              : aliased ESP32_C3.UInt32;
      --  SPI1 memory data buffer11
      W11              : aliased ESP32_C3.UInt32;
      --  SPI1 memory data buffer12
      W12              : aliased ESP32_C3.UInt32;
      --  SPI1 memory data buffer13
      W13              : aliased ESP32_C3.UInt32;
      --  SPI1 memory data buffer14
      W14              : aliased ESP32_C3.UInt32;
      --  SPI1 memory data buffer15
      W15              : aliased ESP32_C3.UInt32;
      --  SPI1 wait idle control register
      FLASH_WAITI_CTRL : aliased FLASH_WAITI_CTRL_Register;
      --  SPI1 flash suspend control register
      FLASH_SUS_CTRL   : aliased FLASH_SUS_CTRL_Register;
      --  SPI1 flash suspend command register
      FLASH_SUS_CMD    : aliased FLASH_SUS_CMD_Register;
      --  SPI1 flash suspend status register
      SUS_STATUS       : aliased SUS_STATUS_Register;
      --  SPI1 timing control register
      TIMING_CALI      : aliased TIMING_CALI_Register;
      --  SPI1 interrupt enable register
      INT_ENA          : aliased INT_ENA_Register;
      --  SPI1 interrupt clear register
      INT_CLR          : aliased INT_CLR_Register;
      --  SPI1 interrupt raw register
      INT_RAW          : aliased INT_RAW_Register;
      --  SPI1 interrupt status register
      INT_ST           : aliased INT_ST_Register;
      --  SPI1 clk_gate register
      CLOCK_GATE       : aliased CLOCK_GATE_Register;
      --  Version control register
      DATE             : aliased DATE_Register;
   end record
     with Volatile;

   for SPI1_Peripheral use record
      CMD              at 16#0# range 0 .. 31;
      ADDR             at 16#4# range 0 .. 31;
      CTRL             at 16#8# range 0 .. 31;
      CTRL1            at 16#C# range 0 .. 31;
      CTRL2            at 16#10# range 0 .. 31;
      CLOCK            at 16#14# range 0 .. 31;
      USER             at 16#18# range 0 .. 31;
      USER1            at 16#1C# range 0 .. 31;
      USER2            at 16#20# range 0 .. 31;
      MOSI_DLEN        at 16#24# range 0 .. 31;
      MISO_DLEN        at 16#28# range 0 .. 31;
      RD_STATUS        at 16#2C# range 0 .. 31;
      MISC             at 16#34# range 0 .. 31;
      TX_CRC           at 16#38# range 0 .. 31;
      CACHE_FCTRL      at 16#3C# range 0 .. 31;
      W0               at 16#58# range 0 .. 31;
      W1               at 16#5C# range 0 .. 31;
      W2               at 16#60# range 0 .. 31;
      W3               at 16#64# range 0 .. 31;
      W4               at 16#68# range 0 .. 31;
      W5               at 16#6C# range 0 .. 31;
      W6               at 16#70# range 0 .. 31;
      W7               at 16#74# range 0 .. 31;
      W8               at 16#78# range 0 .. 31;
      W9               at 16#7C# range 0 .. 31;
      W10              at 16#80# range 0 .. 31;
      W11              at 16#84# range 0 .. 31;
      W12              at 16#88# range 0 .. 31;
      W13              at 16#8C# range 0 .. 31;
      W14              at 16#90# range 0 .. 31;
      W15              at 16#94# range 0 .. 31;
      FLASH_WAITI_CTRL at 16#98# range 0 .. 31;
      FLASH_SUS_CTRL   at 16#9C# range 0 .. 31;
      FLASH_SUS_CMD    at 16#A0# range 0 .. 31;
      SUS_STATUS       at 16#A4# range 0 .. 31;
      TIMING_CALI      at 16#A8# range 0 .. 31;
      INT_ENA          at 16#C0# range 0 .. 31;
      INT_CLR          at 16#C4# range 0 .. 31;
      INT_RAW          at 16#C8# range 0 .. 31;
      INT_ST           at 16#CC# range 0 .. 31;
      CLOCK_GATE       at 16#DC# range 0 .. 31;
      DATE             at 16#3FC# range 0 .. 31;
   end record;

   --  SPI (Serial Peripheral Interface) Controller 1
   SPI1_Periph : aliased SPI1_Peripheral
     with Import, Address => SPI1_Base;

end ESP32_C3.SPI1;
