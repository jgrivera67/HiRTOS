pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.RSA is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  The memory that stores M

   --  The memory that stores M
   type M_MEM_Registers is array (0 .. 95) of ESP32_C3.UInt32;

   --  The memory that stores Z

   --  The memory that stores Z
   type Z_MEM_Registers is array (0 .. 95) of ESP32_C3.UInt32;

   --  The memory that stores Y

   --  The memory that stores Y
   type Y_MEM_Registers is array (0 .. 95) of ESP32_C3.UInt32;

   --  The memory that stores X

   --  The memory that stores X
   type X_MEM_Registers is array (0 .. 95) of ESP32_C3.UInt32;

   subtype MODE_MODE_Field is ESP32_C3.UInt7;

   --  RSA mode register
   type MODE_Register is record
      --  rsa mode (rsa length).
      MODE          : MODE_MODE_Field := 16#0#;
      --  unspecified
      Reserved_7_31 : ESP32_C3.UInt25 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for MODE_Register use record
      MODE          at 0 range 0 .. 6;
      Reserved_7_31 at 0 range 7 .. 31;
   end record;

   subtype QUERY_CLEAN_QUERY_CLEAN_Field is ESP32_C3.Bit;

   --  RSA query clean register
   type QUERY_CLEAN_Register is record
      --  Read-only. query clean
      QUERY_CLEAN   : QUERY_CLEAN_QUERY_CLEAN_Field;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for QUERY_CLEAN_Register use record
      QUERY_CLEAN   at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype SET_START_MODEXP_SET_START_MODEXP_Field is ESP32_C3.Bit;

   --  RSA modular exponentiation trigger register.
   type SET_START_MODEXP_Register is record
      --  Write-only. start modular exponentiation
      SET_START_MODEXP : SET_START_MODEXP_SET_START_MODEXP_Field := 16#0#;
      --  unspecified
      Reserved_1_31    : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SET_START_MODEXP_Register use record
      SET_START_MODEXP at 0 range 0 .. 0;
      Reserved_1_31    at 0 range 1 .. 31;
   end record;

   subtype SET_START_MODMULT_SET_START_MODMULT_Field is ESP32_C3.Bit;

   --  RSA modular multiplication trigger register.
   type SET_START_MODMULT_Register is record
      --  Write-only. start modular multiplication
      SET_START_MODMULT : SET_START_MODMULT_SET_START_MODMULT_Field := 16#0#;
      --  unspecified
      Reserved_1_31     : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SET_START_MODMULT_Register use record
      SET_START_MODMULT at 0 range 0 .. 0;
      Reserved_1_31     at 0 range 1 .. 31;
   end record;

   subtype SET_START_MULT_SET_START_MULT_Field is ESP32_C3.Bit;

   --  RSA normal multiplication trigger register.
   type SET_START_MULT_Register is record
      --  Write-only. start multiplicaiton
      SET_START_MULT : SET_START_MULT_SET_START_MULT_Field := 16#0#;
      --  unspecified
      Reserved_1_31  : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SET_START_MULT_Register use record
      SET_START_MULT at 0 range 0 .. 0;
      Reserved_1_31  at 0 range 1 .. 31;
   end record;

   subtype QUERY_IDLE_QUERY_IDLE_Field is ESP32_C3.Bit;

   --  RSA query idle register
   type QUERY_IDLE_Register is record
      --  Read-only. query rsa idle. 1'b0: busy, 1'b1: idle
      QUERY_IDLE    : QUERY_IDLE_QUERY_IDLE_Field;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for QUERY_IDLE_Register use record
      QUERY_IDLE    at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype INT_CLR_CLEAR_INTERRUPT_Field is ESP32_C3.Bit;

   --  RSA interrupt clear register
   type INT_CLR_Register is record
      --  Write-only. set this bit to clear RSA interrupt.
      CLEAR_INTERRUPT : INT_CLR_CLEAR_INTERRUPT_Field := 16#0#;
      --  unspecified
      Reserved_1_31   : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_CLR_Register use record
      CLEAR_INTERRUPT at 0 range 0 .. 0;
      Reserved_1_31   at 0 range 1 .. 31;
   end record;

   subtype CONSTANT_TIME_CONSTANT_TIME_Field is ESP32_C3.Bit;

   --  RSA constant time option register
   type CONSTANT_TIME_Register is record
      --  Configure this bit to 0 for acceleration. 0: with acceleration, 1:
      --  without acceleration(defalut).
      CONSTANT_TIME : CONSTANT_TIME_CONSTANT_TIME_Field := 16#1#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CONSTANT_TIME_Register use record
      CONSTANT_TIME at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype SEARCH_ENABLE_SEARCH_ENABLE_Field is ESP32_C3.Bit;

   --  RSA search option
   type SEARCH_ENABLE_Register is record
      --  Configure this bit to 1 for acceleration. 1: with acceleration, 0:
      --  without acceleration(default). This option should be used together
      --  with RSA_SEARCH_POS.
      SEARCH_ENABLE : SEARCH_ENABLE_SEARCH_ENABLE_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SEARCH_ENABLE_Register use record
      SEARCH_ENABLE at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype SEARCH_POS_SEARCH_POS_Field is ESP32_C3.UInt12;

   --  RSA search position configure register
   type SEARCH_POS_Register is record
      --  Configure this field to set search position. This field should be
      --  used together with RSA_SEARCH_ENABLE. The field is only meaningful
      --  when RSA_SEARCH_ENABLE is high.
      SEARCH_POS     : SEARCH_POS_SEARCH_POS_Field := 16#0#;
      --  unspecified
      Reserved_12_31 : ESP32_C3.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SEARCH_POS_Register use record
      SEARCH_POS     at 0 range 0 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;

   subtype INT_ENA_INT_ENA_Field is ESP32_C3.Bit;

   --  RSA interrupt enable register
   type INT_ENA_Register is record
      --  Set this bit to enable interrupt that occurs when rsa calculation is
      --  done. 1'b0: disable, 1'b1: enable(default).
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

   --  RSA version control register
   type DATE_Register is record
      --  rsa version information
      DATE           : DATE_DATE_Field := 16#20200618#;
      --  unspecified
      Reserved_30_31 : ESP32_C3.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DATE_Register use record
      DATE           at 0 range 0 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  RSA (Rivest Shamir Adleman) Accelerator
   type RSA_Peripheral is record
      --  The memory that stores M
      M_MEM             : aliased M_MEM_Registers;
      --  The memory that stores Z
      Z_MEM             : aliased Z_MEM_Registers;
      --  The memory that stores Y
      Y_MEM             : aliased Y_MEM_Registers;
      --  The memory that stores X
      X_MEM             : aliased X_MEM_Registers;
      --  RSA M_prime register
      M_PRIME           : aliased ESP32_C3.UInt32;
      --  RSA mode register
      MODE              : aliased MODE_Register;
      --  RSA query clean register
      QUERY_CLEAN       : aliased QUERY_CLEAN_Register;
      --  RSA modular exponentiation trigger register.
      SET_START_MODEXP  : aliased SET_START_MODEXP_Register;
      --  RSA modular multiplication trigger register.
      SET_START_MODMULT : aliased SET_START_MODMULT_Register;
      --  RSA normal multiplication trigger register.
      SET_START_MULT    : aliased SET_START_MULT_Register;
      --  RSA query idle register
      QUERY_IDLE        : aliased QUERY_IDLE_Register;
      --  RSA interrupt clear register
      INT_CLR           : aliased INT_CLR_Register;
      --  RSA constant time option register
      CONSTANT_TIME     : aliased CONSTANT_TIME_Register;
      --  RSA search option
      SEARCH_ENABLE     : aliased SEARCH_ENABLE_Register;
      --  RSA search position configure register
      SEARCH_POS        : aliased SEARCH_POS_Register;
      --  RSA interrupt enable register
      INT_ENA           : aliased INT_ENA_Register;
      --  RSA version control register
      DATE              : aliased DATE_Register;
   end record
     with Volatile;

   for RSA_Peripheral use record
      M_MEM             at 16#0# range 0 .. 3071;
      Z_MEM             at 16#200# range 0 .. 3071;
      Y_MEM             at 16#400# range 0 .. 3071;
      X_MEM             at 16#600# range 0 .. 3071;
      M_PRIME           at 16#800# range 0 .. 31;
      MODE              at 16#804# range 0 .. 31;
      QUERY_CLEAN       at 16#808# range 0 .. 31;
      SET_START_MODEXP  at 16#80C# range 0 .. 31;
      SET_START_MODMULT at 16#810# range 0 .. 31;
      SET_START_MULT    at 16#814# range 0 .. 31;
      QUERY_IDLE        at 16#818# range 0 .. 31;
      INT_CLR           at 16#81C# range 0 .. 31;
      CONSTANT_TIME     at 16#820# range 0 .. 31;
      SEARCH_ENABLE     at 16#824# range 0 .. 31;
      SEARCH_POS        at 16#828# range 0 .. 31;
      INT_ENA           at 16#82C# range 0 .. 31;
      DATE              at 16#830# range 0 .. 31;
   end record;

   --  RSA (Rivest Shamir Adleman) Accelerator
   RSA_Periph : aliased RSA_Peripheral
     with Import, Address => RSA_Base;

end ESP32_C3.RSA;
