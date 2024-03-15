pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.AES is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype MODE_MODE_Field is ESP32_C3.UInt3;

   --  AES Mode register
   type MODE_Register is record
      --  This bits decides which one operation mode will be used. 3'd0:
      --  AES-EN-128, 3'd1: AES-EN-192, 3'd2: AES-EN-256, 3'd4: AES-DE-128,
      --  3'd5: AES-DE-192, 3'd6: AES-DE-256.
      MODE          : MODE_MODE_Field := 16#0#;
      --  unspecified
      Reserved_3_31 : ESP32_C3.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for MODE_Register use record
      MODE          at 0 range 0 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   subtype ENDIAN_ENDIAN_Field is ESP32_C3.UInt6;

   --  AES Endian configure register
   type ENDIAN_Register is record
      --  endian. [1:0] key endian, [3:2] text_in endian or in_stream endian,
      --  [5:4] text_out endian or out_stream endian
      ENDIAN        : ENDIAN_ENDIAN_Field := 16#0#;
      --  unspecified
      Reserved_6_31 : ESP32_C3.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENDIAN_Register use record
      ENDIAN        at 0 range 0 .. 5;
      Reserved_6_31 at 0 range 6 .. 31;
   end record;

   subtype TRIGGER_TRIGGER_Field is ESP32_C3.Bit;

   --  AES trigger register
   type TRIGGER_Register is record
      --  Write-only. Set this bit to start AES calculation.
      TRIGGER       : TRIGGER_TRIGGER_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TRIGGER_Register use record
      TRIGGER       at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype STATE_STATE_Field is ESP32_C3.UInt2;

   --  AES state register
   type STATE_Register is record
      --  Read-only. Those bits shows AES status. For typical AES, 0: idle, 1:
      --  busy. For DMA-AES, 0: idle, 1: busy, 2: calculation_done.
      STATE         : STATE_STATE_Field;
      --  unspecified
      Reserved_2_31 : ESP32_C3.UInt30;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for STATE_Register use record
      STATE         at 0 range 0 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   --  The memory that stores initialization vector

   --  The memory that stores initialization vector
   type IV_MEM_Registers is array (0 .. 3) of ESP32_C3.UInt32;

   --  The memory that stores GCM hash subkey

   --  The memory that stores GCM hash subkey
   type H_MEM_Registers is array (0 .. 3) of ESP32_C3.UInt32;

   --  The memory that stores J0

   --  The memory that stores J0
   type J0_MEM_Registers is array (0 .. 3) of ESP32_C3.UInt32;

   --  The memory that stores T0

   --  The memory that stores T0
   type T0_MEM_Registers is array (0 .. 3) of ESP32_C3.UInt32;

   subtype DMA_ENABLE_DMA_ENABLE_Field is ESP32_C3.Bit;

   --  DMA-AES working mode register
   type DMA_ENABLE_Register is record
      --  1'b0: typical AES working mode, 1'b1: DMA-AES working mode.
      DMA_ENABLE    : DMA_ENABLE_DMA_ENABLE_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_ENABLE_Register use record
      DMA_ENABLE    at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype BLOCK_MODE_BLOCK_MODE_Field is ESP32_C3.UInt3;

   --  AES cipher block mode register
   type BLOCK_MODE_Register is record
      --  Those bits decides which block mode will be used. 0x0: ECB, 0x1: CBC,
      --  0x2: OFB, 0x3: CTR, 0x4: CFB-8, 0x5: CFB-128, 0x6: GCM, 0x7:
      --  reserved.
      BLOCK_MODE    : BLOCK_MODE_BLOCK_MODE_Field := 16#0#;
      --  unspecified
      Reserved_3_31 : ESP32_C3.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BLOCK_MODE_Register use record
      BLOCK_MODE    at 0 range 0 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   subtype INC_SEL_INC_SEL_Field is ESP32_C3.Bit;

   --  Standard incrementing function configure register
   type INC_SEL_Register is record
      --  This bit decides the standard incrementing function. 0: INC32. 1:
      --  INC128.
      INC_SEL       : INC_SEL_INC_SEL_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INC_SEL_Register use record
      INC_SEL       at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype REMAINDER_BIT_NUM_REMAINDER_BIT_NUM_Field is ESP32_C3.UInt7;

   --  AES remainder bit number register
   type REMAINDER_BIT_NUM_Register is record
      --  Those bits stores the number of remainder bit.
      REMAINDER_BIT_NUM : REMAINDER_BIT_NUM_REMAINDER_BIT_NUM_Field := 16#0#;
      --  unspecified
      Reserved_7_31     : ESP32_C3.UInt25 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REMAINDER_BIT_NUM_Register use record
      REMAINDER_BIT_NUM at 0 range 0 .. 6;
      Reserved_7_31     at 0 range 7 .. 31;
   end record;

   subtype CONTINUE_CONTINUE_Field is ESP32_C3.Bit;

   --  AES continue register
   type CONTINUE_Register is record
      --  Write-only. Set this bit to continue GCM operation.
      CONTINUE      : CONTINUE_CONTINUE_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CONTINUE_Register use record
      CONTINUE      at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype INT_CLEAR_INT_CLEAR_Field is ESP32_C3.Bit;

   --  AES Interrupt clear register
   type INT_CLEAR_Register is record
      --  Write-only. Set this bit to clear the AES interrupt.
      INT_CLEAR     : INT_CLEAR_INT_CLEAR_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_CLEAR_Register use record
      INT_CLEAR     at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype INT_ENA_INT_ENA_Field is ESP32_C3.Bit;

   --  AES Interrupt enable register
   type INT_ENA_Register is record
      --  Set this bit to enable interrupt that occurs when DMA-AES calculation
      --  is done.
      INT_ENA       : INT_ENA_INT_ENA_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_ENA_Register use record
      INT_ENA       at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype DATE_DATE_Field is ESP32_C3.UInt30;

   --  AES version control register
   type DATE_Register is record
      --  This bits stores the version information of AES.
      DATE           : DATE_DATE_Field := 16#20191210#;
      --  unspecified
      Reserved_30_31 : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DATE_Register use record
      DATE           at 0 range 0 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   subtype DMA_EXIT_DMA_EXIT_Field is ESP32_C3.Bit;

   --  AES-DMA exit config
   type DMA_EXIT_Register is record
      --  Write-only. Set this register to leave calculation done stage.
      --  Recommend to use it after software finishes reading DMA's output
      --  buffer.
      DMA_EXIT      : DMA_EXIT_DMA_EXIT_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMA_EXIT_Register use record
      DMA_EXIT      at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  AES (Advanced Encryption Standard) Accelerator
   type AES_Peripheral is record
      --  Key material key_0 configure register
      KEY_0             : aliased ESP32_C3.UInt32;
      --  Key material key_1 configure register
      KEY_1             : aliased ESP32_C3.UInt32;
      --  Key material key_2 configure register
      KEY_2             : aliased ESP32_C3.UInt32;
      --  Key material key_3 configure register
      KEY_3             : aliased ESP32_C3.UInt32;
      --  Key material key_4 configure register
      KEY_4             : aliased ESP32_C3.UInt32;
      --  Key material key_5 configure register
      KEY_5             : aliased ESP32_C3.UInt32;
      --  Key material key_6 configure register
      KEY_6             : aliased ESP32_C3.UInt32;
      --  Key material key_7 configure register
      KEY_7             : aliased ESP32_C3.UInt32;
      --  source text material text_in_0 configure register
      TEXT_IN_0         : aliased ESP32_C3.UInt32;
      --  source text material text_in_1 configure register
      TEXT_IN_1         : aliased ESP32_C3.UInt32;
      --  source text material text_in_2 configure register
      TEXT_IN_2         : aliased ESP32_C3.UInt32;
      --  source text material text_in_3 configure register
      TEXT_IN_3         : aliased ESP32_C3.UInt32;
      --  result text material text_out_0 configure register
      TEXT_OUT_0        : aliased ESP32_C3.UInt32;
      --  result text material text_out_1 configure register
      TEXT_OUT_1        : aliased ESP32_C3.UInt32;
      --  result text material text_out_2 configure register
      TEXT_OUT_2        : aliased ESP32_C3.UInt32;
      --  result text material text_out_3 configure register
      TEXT_OUT_3        : aliased ESP32_C3.UInt32;
      --  AES Mode register
      MODE              : aliased MODE_Register;
      --  AES Endian configure register
      ENDIAN            : aliased ENDIAN_Register;
      --  AES trigger register
      TRIGGER           : aliased TRIGGER_Register;
      --  AES state register
      STATE             : aliased STATE_Register;
      --  The memory that stores initialization vector
      IV_MEM            : aliased IV_MEM_Registers;
      --  The memory that stores GCM hash subkey
      H_MEM             : aliased H_MEM_Registers;
      --  The memory that stores J0
      J0_MEM            : aliased J0_MEM_Registers;
      --  The memory that stores T0
      T0_MEM            : aliased T0_MEM_Registers;
      --  DMA-AES working mode register
      DMA_ENABLE        : aliased DMA_ENABLE_Register;
      --  AES cipher block mode register
      BLOCK_MODE        : aliased BLOCK_MODE_Register;
      --  AES block number register
      BLOCK_NUM         : aliased ESP32_C3.UInt32;
      --  Standard incrementing function configure register
      INC_SEL           : aliased INC_SEL_Register;
      --  Additional Authential Data block number register
      AAD_BLOCK_NUM     : aliased ESP32_C3.UInt32;
      --  AES remainder bit number register
      REMAINDER_BIT_NUM : aliased REMAINDER_BIT_NUM_Register;
      --  AES continue register
      CONTINUE          : aliased CONTINUE_Register;
      --  AES Interrupt clear register
      INT_CLEAR         : aliased INT_CLEAR_Register;
      --  AES Interrupt enable register
      INT_ENA           : aliased INT_ENA_Register;
      --  AES version control register
      DATE              : aliased DATE_Register;
      --  AES-DMA exit config
      DMA_EXIT          : aliased DMA_EXIT_Register;
   end record
     with Volatile;

   for AES_Peripheral use record
      KEY_0             at 16#0# range 0 .. 31;
      KEY_1             at 16#4# range 0 .. 31;
      KEY_2             at 16#8# range 0 .. 31;
      KEY_3             at 16#C# range 0 .. 31;
      KEY_4             at 16#10# range 0 .. 31;
      KEY_5             at 16#14# range 0 .. 31;
      KEY_6             at 16#18# range 0 .. 31;
      KEY_7             at 16#1C# range 0 .. 31;
      TEXT_IN_0         at 16#20# range 0 .. 31;
      TEXT_IN_1         at 16#24# range 0 .. 31;
      TEXT_IN_2         at 16#28# range 0 .. 31;
      TEXT_IN_3         at 16#2C# range 0 .. 31;
      TEXT_OUT_0        at 16#30# range 0 .. 31;
      TEXT_OUT_1        at 16#34# range 0 .. 31;
      TEXT_OUT_2        at 16#38# range 0 .. 31;
      TEXT_OUT_3        at 16#3C# range 0 .. 31;
      MODE              at 16#40# range 0 .. 31;
      ENDIAN            at 16#44# range 0 .. 31;
      TRIGGER           at 16#48# range 0 .. 31;
      STATE             at 16#4C# range 0 .. 31;
      IV_MEM            at 16#50# range 0 .. 127;
      H_MEM             at 16#60# range 0 .. 127;
      J0_MEM            at 16#70# range 0 .. 127;
      T0_MEM            at 16#80# range 0 .. 127;
      DMA_ENABLE        at 16#90# range 0 .. 31;
      BLOCK_MODE        at 16#94# range 0 .. 31;
      BLOCK_NUM         at 16#98# range 0 .. 31;
      INC_SEL           at 16#9C# range 0 .. 31;
      AAD_BLOCK_NUM     at 16#A0# range 0 .. 31;
      REMAINDER_BIT_NUM at 16#A4# range 0 .. 31;
      CONTINUE          at 16#A8# range 0 .. 31;
      INT_CLEAR         at 16#AC# range 0 .. 31;
      INT_ENA           at 16#B0# range 0 .. 31;
      DATE              at 16#B4# range 0 .. 31;
      DMA_EXIT          at 16#B8# range 0 .. 31;
   end record;

   --  AES (Advanced Encryption Standard) Accelerator
   AES_Periph : aliased AES_Peripheral
     with Import, Address => AES_Base;

end ESP32_C3.AES;
