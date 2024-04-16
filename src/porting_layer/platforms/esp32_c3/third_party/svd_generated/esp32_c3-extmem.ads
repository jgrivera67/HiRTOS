pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.EXTMEM is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype ICACHE_CTRL_ICACHE_ENABLE_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type ICACHE_CTRL_Register is record
      --  The bit is used to activate the data cache. 0: disable, 1: enable
      ICACHE_ENABLE : ICACHE_CTRL_ICACHE_ENABLE_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_CTRL_Register use record
      ICACHE_ENABLE at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype ICACHE_CTRL1_ICACHE_SHUT_IBUS_Field is ESP32_C3.Bit;
   subtype ICACHE_CTRL1_ICACHE_SHUT_DBUS_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type ICACHE_CTRL1_Register is record
      --  The bit is used to disable core0 ibus, 0: enable, 1: disable
      ICACHE_SHUT_IBUS : ICACHE_CTRL1_ICACHE_SHUT_IBUS_Field := 16#1#;
      --  The bit is used to disable core1 ibus, 0: enable, 1: disable
      ICACHE_SHUT_DBUS : ICACHE_CTRL1_ICACHE_SHUT_DBUS_Field := 16#1#;
      --  unspecified
      Reserved_2_31    : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_CTRL1_Register use record
      ICACHE_SHUT_IBUS at 0 range 0 .. 0;
      ICACHE_SHUT_DBUS at 0 range 1 .. 1;
      Reserved_2_31    at 0 range 2 .. 31;
   end record;

   subtype ICACHE_TAG_POWER_CTRL_ICACHE_TAG_MEM_FORCE_ON_Field is ESP32_C3.Bit;
   subtype ICACHE_TAG_POWER_CTRL_ICACHE_TAG_MEM_FORCE_PD_Field is ESP32_C3.Bit;
   subtype ICACHE_TAG_POWER_CTRL_ICACHE_TAG_MEM_FORCE_PU_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type ICACHE_TAG_POWER_CTRL_Register is record
      --  The bit is used to close clock gating of icache tag memory. 1: close
      --  gating, 0: open clock gating.
      ICACHE_TAG_MEM_FORCE_ON : ICACHE_TAG_POWER_CTRL_ICACHE_TAG_MEM_FORCE_ON_Field :=
                                 16#1#;
      --  The bit is used to power icache tag memory down, 0: follow rtc_lslp,
      --  1: power down
      ICACHE_TAG_MEM_FORCE_PD : ICACHE_TAG_POWER_CTRL_ICACHE_TAG_MEM_FORCE_PD_Field :=
                                 16#0#;
      --  The bit is used to power icache tag memory up, 0: follow rtc_lslp, 1:
      --  power up
      ICACHE_TAG_MEM_FORCE_PU : ICACHE_TAG_POWER_CTRL_ICACHE_TAG_MEM_FORCE_PU_Field :=
                                 16#1#;
      --  unspecified
      Reserved_3_31           : ESP32_C3.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_TAG_POWER_CTRL_Register use record
      ICACHE_TAG_MEM_FORCE_ON at 0 range 0 .. 0;
      ICACHE_TAG_MEM_FORCE_PD at 0 range 1 .. 1;
      ICACHE_TAG_MEM_FORCE_PU at 0 range 2 .. 2;
      Reserved_3_31           at 0 range 3 .. 31;
   end record;

   subtype ICACHE_PRELOCK_CTRL_ICACHE_PRELOCK_SCT0_EN_Field is ESP32_C3.Bit;
   subtype ICACHE_PRELOCK_CTRL_ICACHE_PRELOCK_SCT1_EN_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type ICACHE_PRELOCK_CTRL_Register is record
      --  The bit is used to enable the first section of prelock function.
      ICACHE_PRELOCK_SCT0_EN : ICACHE_PRELOCK_CTRL_ICACHE_PRELOCK_SCT0_EN_Field :=
                                16#0#;
      --  The bit is used to enable the second section of prelock function.
      ICACHE_PRELOCK_SCT1_EN : ICACHE_PRELOCK_CTRL_ICACHE_PRELOCK_SCT1_EN_Field :=
                                16#0#;
      --  unspecified
      Reserved_2_31          : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_PRELOCK_CTRL_Register use record
      ICACHE_PRELOCK_SCT0_EN at 0 range 0 .. 0;
      ICACHE_PRELOCK_SCT1_EN at 0 range 1 .. 1;
      Reserved_2_31          at 0 range 2 .. 31;
   end record;

   subtype ICACHE_PRELOCK_SCT_SIZE_ICACHE_PRELOCK_SCT1_SIZE_Field is
     ESP32_C3.UInt16;
   subtype ICACHE_PRELOCK_SCT_SIZE_ICACHE_PRELOCK_SCT0_SIZE_Field is
     ESP32_C3.UInt16;

   --  This description will be updated in the near future.
   type ICACHE_PRELOCK_SCT_SIZE_Register is record
      --  The bits are used to configure the second length of data locking,
      --  which is combined with ICACHE_PRELOCK_SCT1_ADDR_REG
      ICACHE_PRELOCK_SCT1_SIZE : ICACHE_PRELOCK_SCT_SIZE_ICACHE_PRELOCK_SCT1_SIZE_Field :=
                                  16#0#;
      --  The bits are used to configure the first length of data locking,
      --  which is combined with ICACHE_PRELOCK_SCT0_ADDR_REG
      ICACHE_PRELOCK_SCT0_SIZE : ICACHE_PRELOCK_SCT_SIZE_ICACHE_PRELOCK_SCT0_SIZE_Field :=
                                  16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_PRELOCK_SCT_SIZE_Register use record
      ICACHE_PRELOCK_SCT1_SIZE at 0 range 0 .. 15;
      ICACHE_PRELOCK_SCT0_SIZE at 0 range 16 .. 31;
   end record;

   subtype ICACHE_LOCK_CTRL_ICACHE_LOCK_ENA_Field is ESP32_C3.Bit;
   subtype ICACHE_LOCK_CTRL_ICACHE_UNLOCK_ENA_Field is ESP32_C3.Bit;
   subtype ICACHE_LOCK_CTRL_ICACHE_LOCK_DONE_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type ICACHE_LOCK_CTRL_Register is record
      --  The bit is used to enable lock operation. It will be cleared by
      --  hardware after lock operation done.
      ICACHE_LOCK_ENA   : ICACHE_LOCK_CTRL_ICACHE_LOCK_ENA_Field := 16#0#;
      --  The bit is used to enable unlock operation. It will be cleared by
      --  hardware after unlock operation done.
      ICACHE_UNLOCK_ENA : ICACHE_LOCK_CTRL_ICACHE_UNLOCK_ENA_Field := 16#0#;
      --  Read-only. The bit is used to indicate unlock/lock operation is
      --  finished.
      ICACHE_LOCK_DONE  : ICACHE_LOCK_CTRL_ICACHE_LOCK_DONE_Field := 16#1#;
      --  unspecified
      Reserved_3_31     : ESP32_C3.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_LOCK_CTRL_Register use record
      ICACHE_LOCK_ENA   at 0 range 0 .. 0;
      ICACHE_UNLOCK_ENA at 0 range 1 .. 1;
      ICACHE_LOCK_DONE  at 0 range 2 .. 2;
      Reserved_3_31     at 0 range 3 .. 31;
   end record;

   subtype ICACHE_LOCK_SIZE_ICACHE_LOCK_SIZE_Field is ESP32_C3.UInt16;

   --  This description will be updated in the near future.
   type ICACHE_LOCK_SIZE_Register is record
      --  The bits are used to configure the length for lock operations. The
      --  bits are the counts of cache block. It should be combined with
      --  ICACHE_LOCK_ADDR_REG.
      ICACHE_LOCK_SIZE : ICACHE_LOCK_SIZE_ICACHE_LOCK_SIZE_Field := 16#0#;
      --  unspecified
      Reserved_16_31   : ESP32_C3.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_LOCK_SIZE_Register use record
      ICACHE_LOCK_SIZE at 0 range 0 .. 15;
      Reserved_16_31   at 0 range 16 .. 31;
   end record;

   subtype ICACHE_SYNC_CTRL_ICACHE_INVALIDATE_ENA_Field is ESP32_C3.Bit;
   subtype ICACHE_SYNC_CTRL_ICACHE_SYNC_DONE_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type ICACHE_SYNC_CTRL_Register is record
      --  The bit is used to enable invalidate operation. It will be cleared by
      --  hardware after invalidate operation done.
      ICACHE_INVALIDATE_ENA : ICACHE_SYNC_CTRL_ICACHE_INVALIDATE_ENA_Field :=
                               16#1#;
      --  Read-only. The bit is used to indicate invalidate operation is
      --  finished.
      ICACHE_SYNC_DONE      : ICACHE_SYNC_CTRL_ICACHE_SYNC_DONE_Field :=
                               16#0#;
      --  unspecified
      Reserved_2_31         : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_SYNC_CTRL_Register use record
      ICACHE_INVALIDATE_ENA at 0 range 0 .. 0;
      ICACHE_SYNC_DONE      at 0 range 1 .. 1;
      Reserved_2_31         at 0 range 2 .. 31;
   end record;

   subtype ICACHE_SYNC_SIZE_ICACHE_SYNC_SIZE_Field is ESP32_C3.UInt23;

   --  This description will be updated in the near future.
   type ICACHE_SYNC_SIZE_Register is record
      --  The bits are used to configure the length for sync operations. The
      --  bits are the counts of cache block. It should be combined with
      --  ICACHE_SYNC_ADDR_REG.
      ICACHE_SYNC_SIZE : ICACHE_SYNC_SIZE_ICACHE_SYNC_SIZE_Field := 16#0#;
      --  unspecified
      Reserved_23_31   : ESP32_C3.UInt9 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_SYNC_SIZE_Register use record
      ICACHE_SYNC_SIZE at 0 range 0 .. 22;
      Reserved_23_31   at 0 range 23 .. 31;
   end record;

   subtype ICACHE_PRELOAD_CTRL_ICACHE_PRELOAD_ENA_Field is ESP32_C3.Bit;
   subtype ICACHE_PRELOAD_CTRL_ICACHE_PRELOAD_DONE_Field is ESP32_C3.Bit;
   subtype ICACHE_PRELOAD_CTRL_ICACHE_PRELOAD_ORDER_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type ICACHE_PRELOAD_CTRL_Register is record
      --  The bit is used to enable preload operation. It will be cleared by
      --  hardware after preload operation done.
      ICACHE_PRELOAD_ENA   : ICACHE_PRELOAD_CTRL_ICACHE_PRELOAD_ENA_Field :=
                              16#0#;
      --  Read-only. The bit is used to indicate preload operation is finished.
      ICACHE_PRELOAD_DONE  : ICACHE_PRELOAD_CTRL_ICACHE_PRELOAD_DONE_Field :=
                              16#1#;
      --  The bit is used to configure the direction of preload operation. 1:
      --  descending, 0: ascending.
      ICACHE_PRELOAD_ORDER : ICACHE_PRELOAD_CTRL_ICACHE_PRELOAD_ORDER_Field :=
                              16#0#;
      --  unspecified
      Reserved_3_31        : ESP32_C3.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_PRELOAD_CTRL_Register use record
      ICACHE_PRELOAD_ENA   at 0 range 0 .. 0;
      ICACHE_PRELOAD_DONE  at 0 range 1 .. 1;
      ICACHE_PRELOAD_ORDER at 0 range 2 .. 2;
      Reserved_3_31        at 0 range 3 .. 31;
   end record;

   subtype ICACHE_PRELOAD_SIZE_ICACHE_PRELOAD_SIZE_Field is ESP32_C3.UInt16;

   --  This description will be updated in the near future.
   type ICACHE_PRELOAD_SIZE_Register is record
      --  The bits are used to configure the length for preload operation. The
      --  bits are the counts of cache block. It should be combined with
      --  ICACHE_PRELOAD_ADDR_REG..
      ICACHE_PRELOAD_SIZE : ICACHE_PRELOAD_SIZE_ICACHE_PRELOAD_SIZE_Field :=
                             16#0#;
      --  unspecified
      Reserved_16_31      : ESP32_C3.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_PRELOAD_SIZE_Register use record
      ICACHE_PRELOAD_SIZE at 0 range 0 .. 15;
      Reserved_16_31      at 0 range 16 .. 31;
   end record;

   subtype ICACHE_AUTOLOAD_CTRL_ICACHE_AUTOLOAD_SCT0_ENA_Field is ESP32_C3.Bit;
   subtype ICACHE_AUTOLOAD_CTRL_ICACHE_AUTOLOAD_SCT1_ENA_Field is ESP32_C3.Bit;
   subtype ICACHE_AUTOLOAD_CTRL_ICACHE_AUTOLOAD_ENA_Field is ESP32_C3.Bit;
   subtype ICACHE_AUTOLOAD_CTRL_ICACHE_AUTOLOAD_DONE_Field is ESP32_C3.Bit;
   subtype ICACHE_AUTOLOAD_CTRL_ICACHE_AUTOLOAD_ORDER_Field is ESP32_C3.Bit;
   subtype ICACHE_AUTOLOAD_CTRL_ICACHE_AUTOLOAD_RQST_Field is ESP32_C3.UInt2;

   --  This description will be updated in the near future.
   type ICACHE_AUTOLOAD_CTRL_Register is record
      --  The bits are used to enable the first section for autoload operation.
      ICACHE_AUTOLOAD_SCT0_ENA : ICACHE_AUTOLOAD_CTRL_ICACHE_AUTOLOAD_SCT0_ENA_Field :=
                                  16#0#;
      --  The bits are used to enable the second section for autoload
      --  operation.
      ICACHE_AUTOLOAD_SCT1_ENA : ICACHE_AUTOLOAD_CTRL_ICACHE_AUTOLOAD_SCT1_ENA_Field :=
                                  16#0#;
      --  The bit is used to enable and disable autoload operation. It is
      --  combined with icache_autoload_done. 1: enable, 0: disable.
      ICACHE_AUTOLOAD_ENA      : ICACHE_AUTOLOAD_CTRL_ICACHE_AUTOLOAD_ENA_Field :=
                                  16#0#;
      --  Read-only. The bit is used to indicate autoload operation is
      --  finished.
      ICACHE_AUTOLOAD_DONE     : ICACHE_AUTOLOAD_CTRL_ICACHE_AUTOLOAD_DONE_Field :=
                                  16#1#;
      --  The bits are used to configure the direction of autoload. 1:
      --  descending, 0: ascending.
      ICACHE_AUTOLOAD_ORDER    : ICACHE_AUTOLOAD_CTRL_ICACHE_AUTOLOAD_ORDER_Field :=
                                  16#0#;
      --  The bits are used to configure trigger conditions for autoload. 0/3:
      --  cache miss, 1: cache hit, 2: both cache miss and hit.
      ICACHE_AUTOLOAD_RQST     : ICACHE_AUTOLOAD_CTRL_ICACHE_AUTOLOAD_RQST_Field :=
                                  16#0#;
      --  unspecified
      Reserved_7_31            : ESP32_C3.UInt25 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_AUTOLOAD_CTRL_Register use record
      ICACHE_AUTOLOAD_SCT0_ENA at 0 range 0 .. 0;
      ICACHE_AUTOLOAD_SCT1_ENA at 0 range 1 .. 1;
      ICACHE_AUTOLOAD_ENA      at 0 range 2 .. 2;
      ICACHE_AUTOLOAD_DONE     at 0 range 3 .. 3;
      ICACHE_AUTOLOAD_ORDER    at 0 range 4 .. 4;
      ICACHE_AUTOLOAD_RQST     at 0 range 5 .. 6;
      Reserved_7_31            at 0 range 7 .. 31;
   end record;

   subtype ICACHE_AUTOLOAD_SCT0_SIZE_ICACHE_AUTOLOAD_SCT0_SIZE_Field is
     ESP32_C3.UInt27;

   --  This description will be updated in the near future.
   type ICACHE_AUTOLOAD_SCT0_SIZE_Register is record
      --  The bits are used to configure the length of the first section for
      --  autoload operation. It should be combined with
      --  icache_autoload_sct0_ena.
      ICACHE_AUTOLOAD_SCT0_SIZE : ICACHE_AUTOLOAD_SCT0_SIZE_ICACHE_AUTOLOAD_SCT0_SIZE_Field :=
                                   16#0#;
      --  unspecified
      Reserved_27_31            : ESP32_C3.UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_AUTOLOAD_SCT0_SIZE_Register use record
      ICACHE_AUTOLOAD_SCT0_SIZE at 0 range 0 .. 26;
      Reserved_27_31            at 0 range 27 .. 31;
   end record;

   subtype ICACHE_AUTOLOAD_SCT1_SIZE_ICACHE_AUTOLOAD_SCT1_SIZE_Field is
     ESP32_C3.UInt27;

   --  This description will be updated in the near future.
   type ICACHE_AUTOLOAD_SCT1_SIZE_Register is record
      --  The bits are used to configure the length of the second section for
      --  autoload operation. It should be combined with
      --  icache_autoload_sct1_ena.
      ICACHE_AUTOLOAD_SCT1_SIZE : ICACHE_AUTOLOAD_SCT1_SIZE_ICACHE_AUTOLOAD_SCT1_SIZE_Field :=
                                   16#0#;
      --  unspecified
      Reserved_27_31            : ESP32_C3.UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_AUTOLOAD_SCT1_SIZE_Register use record
      ICACHE_AUTOLOAD_SCT1_SIZE at 0 range 0 .. 26;
      Reserved_27_31            at 0 range 27 .. 31;
   end record;

   subtype CACHE_ACS_CNT_CLR_IBUS_ACS_CNT_CLR_Field is ESP32_C3.Bit;
   subtype CACHE_ACS_CNT_CLR_DBUS_ACS_CNT_CLR_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CACHE_ACS_CNT_CLR_Register is record
      --  Write-only. The bit is used to clear ibus counter.
      IBUS_ACS_CNT_CLR : CACHE_ACS_CNT_CLR_IBUS_ACS_CNT_CLR_Field := 16#0#;
      --  Write-only. The bit is used to clear dbus counter.
      DBUS_ACS_CNT_CLR : CACHE_ACS_CNT_CLR_DBUS_ACS_CNT_CLR_Field := 16#0#;
      --  unspecified
      Reserved_2_31    : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_ACS_CNT_CLR_Register use record
      IBUS_ACS_CNT_CLR at 0 range 0 .. 0;
      DBUS_ACS_CNT_CLR at 0 range 1 .. 1;
      Reserved_2_31    at 0 range 2 .. 31;
   end record;

   subtype CACHE_ILG_INT_ENA_ICACHE_SYNC_OP_FAULT_INT_ENA_Field is
     ESP32_C3.Bit;
   subtype CACHE_ILG_INT_ENA_ICACHE_PRELOAD_OP_FAULT_INT_ENA_Field is
     ESP32_C3.Bit;
   subtype CACHE_ILG_INT_ENA_MMU_ENTRY_FAULT_INT_ENA_Field is ESP32_C3.Bit;
   subtype CACHE_ILG_INT_ENA_IBUS_CNT_OVF_INT_ENA_Field is ESP32_C3.Bit;
   subtype CACHE_ILG_INT_ENA_DBUS_CNT_OVF_INT_ENA_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CACHE_ILG_INT_ENA_Register is record
      --  The bit is used to enable interrupt by sync configurations fault.
      ICACHE_SYNC_OP_FAULT_INT_ENA    : CACHE_ILG_INT_ENA_ICACHE_SYNC_OP_FAULT_INT_ENA_Field :=
                                         16#0#;
      --  The bit is used to enable interrupt by preload configurations fault.
      ICACHE_PRELOAD_OP_FAULT_INT_ENA : CACHE_ILG_INT_ENA_ICACHE_PRELOAD_OP_FAULT_INT_ENA_Field :=
                                         16#0#;
      --  unspecified
      Reserved_2_4                    : ESP32_C3.UInt3 := 16#0#;
      --  The bit is used to enable interrupt by mmu entry fault.
      MMU_ENTRY_FAULT_INT_ENA         : CACHE_ILG_INT_ENA_MMU_ENTRY_FAULT_INT_ENA_Field :=
                                         16#0#;
      --  unspecified
      Reserved_6_6                    : ESP32_C3.Bit := 16#0#;
      --  The bit is used to enable interrupt by ibus counter overflow.
      IBUS_CNT_OVF_INT_ENA            : CACHE_ILG_INT_ENA_IBUS_CNT_OVF_INT_ENA_Field :=
                                         16#0#;
      --  The bit is used to enable interrupt by dbus counter overflow.
      DBUS_CNT_OVF_INT_ENA            : CACHE_ILG_INT_ENA_DBUS_CNT_OVF_INT_ENA_Field :=
                                         16#0#;
      --  unspecified
      Reserved_9_31                   : ESP32_C3.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_ILG_INT_ENA_Register use record
      ICACHE_SYNC_OP_FAULT_INT_ENA    at 0 range 0 .. 0;
      ICACHE_PRELOAD_OP_FAULT_INT_ENA at 0 range 1 .. 1;
      Reserved_2_4                    at 0 range 2 .. 4;
      MMU_ENTRY_FAULT_INT_ENA         at 0 range 5 .. 5;
      Reserved_6_6                    at 0 range 6 .. 6;
      IBUS_CNT_OVF_INT_ENA            at 0 range 7 .. 7;
      DBUS_CNT_OVF_INT_ENA            at 0 range 8 .. 8;
      Reserved_9_31                   at 0 range 9 .. 31;
   end record;

   subtype CACHE_ILG_INT_CLR_ICACHE_SYNC_OP_FAULT_INT_CLR_Field is
     ESP32_C3.Bit;
   subtype CACHE_ILG_INT_CLR_ICACHE_PRELOAD_OP_FAULT_INT_CLR_Field is
     ESP32_C3.Bit;
   subtype CACHE_ILG_INT_CLR_MMU_ENTRY_FAULT_INT_CLR_Field is ESP32_C3.Bit;
   subtype CACHE_ILG_INT_CLR_IBUS_CNT_OVF_INT_CLR_Field is ESP32_C3.Bit;
   subtype CACHE_ILG_INT_CLR_DBUS_CNT_OVF_INT_CLR_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CACHE_ILG_INT_CLR_Register is record
      --  Write-only. The bit is used to clear interrupt by sync configurations
      --  fault.
      ICACHE_SYNC_OP_FAULT_INT_CLR    : CACHE_ILG_INT_CLR_ICACHE_SYNC_OP_FAULT_INT_CLR_Field :=
                                         16#0#;
      --  Write-only. The bit is used to clear interrupt by preload
      --  configurations fault.
      ICACHE_PRELOAD_OP_FAULT_INT_CLR : CACHE_ILG_INT_CLR_ICACHE_PRELOAD_OP_FAULT_INT_CLR_Field :=
                                         16#0#;
      --  unspecified
      Reserved_2_4                    : ESP32_C3.UInt3 := 16#0#;
      --  Write-only. The bit is used to clear interrupt by mmu entry fault.
      MMU_ENTRY_FAULT_INT_CLR         : CACHE_ILG_INT_CLR_MMU_ENTRY_FAULT_INT_CLR_Field :=
                                         16#0#;
      --  unspecified
      Reserved_6_6                    : ESP32_C3.Bit := 16#0#;
      --  Write-only. The bit is used to clear interrupt by ibus counter
      --  overflow.
      IBUS_CNT_OVF_INT_CLR            : CACHE_ILG_INT_CLR_IBUS_CNT_OVF_INT_CLR_Field :=
                                         16#0#;
      --  Write-only. The bit is used to clear interrupt by dbus counter
      --  overflow.
      DBUS_CNT_OVF_INT_CLR            : CACHE_ILG_INT_CLR_DBUS_CNT_OVF_INT_CLR_Field :=
                                         16#0#;
      --  unspecified
      Reserved_9_31                   : ESP32_C3.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_ILG_INT_CLR_Register use record
      ICACHE_SYNC_OP_FAULT_INT_CLR    at 0 range 0 .. 0;
      ICACHE_PRELOAD_OP_FAULT_INT_CLR at 0 range 1 .. 1;
      Reserved_2_4                    at 0 range 2 .. 4;
      MMU_ENTRY_FAULT_INT_CLR         at 0 range 5 .. 5;
      Reserved_6_6                    at 0 range 6 .. 6;
      IBUS_CNT_OVF_INT_CLR            at 0 range 7 .. 7;
      DBUS_CNT_OVF_INT_CLR            at 0 range 8 .. 8;
      Reserved_9_31                   at 0 range 9 .. 31;
   end record;

   subtype CACHE_ILG_INT_ST_ICACHE_SYNC_OP_FAULT_ST_Field is ESP32_C3.Bit;
   subtype CACHE_ILG_INT_ST_ICACHE_PRELOAD_OP_FAULT_ST_Field is ESP32_C3.Bit;
   subtype CACHE_ILG_INT_ST_MMU_ENTRY_FAULT_ST_Field is ESP32_C3.Bit;
   subtype CACHE_ILG_INT_ST_IBUS_ACS_CNT_OVF_ST_Field is ESP32_C3.Bit;
   subtype CACHE_ILG_INT_ST_IBUS_ACS_MISS_CNT_OVF_ST_Field is ESP32_C3.Bit;
   subtype CACHE_ILG_INT_ST_DBUS_ACS_CNT_OVF_ST_Field is ESP32_C3.Bit;
   subtype CACHE_ILG_INT_ST_DBUS_ACS_FLASH_MISS_CNT_OVF_ST_Field is
     ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CACHE_ILG_INT_ST_Register is record
      --  Read-only. The bit is used to indicate interrupt by sync
      --  configurations fault.
      ICACHE_SYNC_OP_FAULT_ST        : CACHE_ILG_INT_ST_ICACHE_SYNC_OP_FAULT_ST_Field;
      --  Read-only. The bit is used to indicate interrupt by preload
      --  configurations fault.
      ICACHE_PRELOAD_OP_FAULT_ST     : CACHE_ILG_INT_ST_ICACHE_PRELOAD_OP_FAULT_ST_Field;
      --  unspecified
      Reserved_2_4                   : ESP32_C3.UInt3;
      --  Read-only. The bit is used to indicate interrupt by mmu entry fault.
      MMU_ENTRY_FAULT_ST             : CACHE_ILG_INT_ST_MMU_ENTRY_FAULT_ST_Field;
      --  unspecified
      Reserved_6_6                   : ESP32_C3.Bit;
      --  Read-only. The bit is used to indicate interrupt by ibus access
      --  flash/spiram counter overflow.
      IBUS_ACS_CNT_OVF_ST            : CACHE_ILG_INT_ST_IBUS_ACS_CNT_OVF_ST_Field;
      --  Read-only. The bit is used to indicate interrupt by ibus access
      --  flash/spiram miss counter overflow.
      IBUS_ACS_MISS_CNT_OVF_ST       : CACHE_ILG_INT_ST_IBUS_ACS_MISS_CNT_OVF_ST_Field;
      --  Read-only. The bit is used to indicate interrupt by dbus access
      --  flash/spiram counter overflow.
      DBUS_ACS_CNT_OVF_ST            : CACHE_ILG_INT_ST_DBUS_ACS_CNT_OVF_ST_Field;
      --  Read-only. The bit is used to indicate interrupt by dbus access flash
      --  miss counter overflow.
      DBUS_ACS_FLASH_MISS_CNT_OVF_ST : CACHE_ILG_INT_ST_DBUS_ACS_FLASH_MISS_CNT_OVF_ST_Field;
      --  unspecified
      Reserved_11_31                 : ESP32_C3.UInt21;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_ILG_INT_ST_Register use record
      ICACHE_SYNC_OP_FAULT_ST        at 0 range 0 .. 0;
      ICACHE_PRELOAD_OP_FAULT_ST     at 0 range 1 .. 1;
      Reserved_2_4                   at 0 range 2 .. 4;
      MMU_ENTRY_FAULT_ST             at 0 range 5 .. 5;
      Reserved_6_6                   at 0 range 6 .. 6;
      IBUS_ACS_CNT_OVF_ST            at 0 range 7 .. 7;
      IBUS_ACS_MISS_CNT_OVF_ST       at 0 range 8 .. 8;
      DBUS_ACS_CNT_OVF_ST            at 0 range 9 .. 9;
      DBUS_ACS_FLASH_MISS_CNT_OVF_ST at 0 range 10 .. 10;
      Reserved_11_31                 at 0 range 11 .. 31;
   end record;

   subtype CORE0_ACS_CACHE_INT_ENA_CORE0_IBUS_ACS_MSK_IC_INT_ENA_Field is
     ESP32_C3.Bit;
   subtype CORE0_ACS_CACHE_INT_ENA_CORE0_IBUS_WR_IC_INT_ENA_Field is
     ESP32_C3.Bit;
   subtype CORE0_ACS_CACHE_INT_ENA_CORE0_IBUS_REJECT_INT_ENA_Field is
     ESP32_C3.Bit;
   subtype CORE0_ACS_CACHE_INT_ENA_CORE0_DBUS_ACS_MSK_IC_INT_ENA_Field is
     ESP32_C3.Bit;
   subtype CORE0_ACS_CACHE_INT_ENA_CORE0_DBUS_REJECT_INT_ENA_Field is
     ESP32_C3.Bit;
   subtype CORE0_ACS_CACHE_INT_ENA_CORE0_DBUS_WR_IC_INT_ENA_Field is
     ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CORE0_ACS_CACHE_INT_ENA_Register is record
      --  The bit is used to enable interrupt by cpu access icache while the
      --  corresponding ibus is disabled which include speculative access.
      CORE0_IBUS_ACS_MSK_IC_INT_ENA : CORE0_ACS_CACHE_INT_ENA_CORE0_IBUS_ACS_MSK_IC_INT_ENA_Field :=
                                       16#0#;
      --  The bit is used to enable interrupt by ibus trying to write icache
      CORE0_IBUS_WR_IC_INT_ENA      : CORE0_ACS_CACHE_INT_ENA_CORE0_IBUS_WR_IC_INT_ENA_Field :=
                                       16#0#;
      --  The bit is used to enable interrupt by authentication fail.
      CORE0_IBUS_REJECT_INT_ENA     : CORE0_ACS_CACHE_INT_ENA_CORE0_IBUS_REJECT_INT_ENA_Field :=
                                       16#0#;
      --  The bit is used to enable interrupt by cpu access icache while the
      --  corresponding dbus is disabled which include speculative access.
      CORE0_DBUS_ACS_MSK_IC_INT_ENA : CORE0_ACS_CACHE_INT_ENA_CORE0_DBUS_ACS_MSK_IC_INT_ENA_Field :=
                                       16#0#;
      --  The bit is used to enable interrupt by authentication fail.
      CORE0_DBUS_REJECT_INT_ENA     : CORE0_ACS_CACHE_INT_ENA_CORE0_DBUS_REJECT_INT_ENA_Field :=
                                       16#0#;
      --  The bit is used to enable interrupt by dbus trying to write icache
      CORE0_DBUS_WR_IC_INT_ENA      : CORE0_ACS_CACHE_INT_ENA_CORE0_DBUS_WR_IC_INT_ENA_Field :=
                                       16#0#;
      --  unspecified
      Reserved_6_31                 : ESP32_C3.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE0_ACS_CACHE_INT_ENA_Register use record
      CORE0_IBUS_ACS_MSK_IC_INT_ENA at 0 range 0 .. 0;
      CORE0_IBUS_WR_IC_INT_ENA      at 0 range 1 .. 1;
      CORE0_IBUS_REJECT_INT_ENA     at 0 range 2 .. 2;
      CORE0_DBUS_ACS_MSK_IC_INT_ENA at 0 range 3 .. 3;
      CORE0_DBUS_REJECT_INT_ENA     at 0 range 4 .. 4;
      CORE0_DBUS_WR_IC_INT_ENA      at 0 range 5 .. 5;
      Reserved_6_31                 at 0 range 6 .. 31;
   end record;

   subtype CORE0_ACS_CACHE_INT_CLR_CORE0_IBUS_ACS_MSK_IC_INT_CLR_Field is
     ESP32_C3.Bit;
   subtype CORE0_ACS_CACHE_INT_CLR_CORE0_IBUS_WR_IC_INT_CLR_Field is
     ESP32_C3.Bit;
   subtype CORE0_ACS_CACHE_INT_CLR_CORE0_IBUS_REJECT_INT_CLR_Field is
     ESP32_C3.Bit;
   subtype CORE0_ACS_CACHE_INT_CLR_CORE0_DBUS_ACS_MSK_IC_INT_CLR_Field is
     ESP32_C3.Bit;
   subtype CORE0_ACS_CACHE_INT_CLR_CORE0_DBUS_REJECT_INT_CLR_Field is
     ESP32_C3.Bit;
   subtype CORE0_ACS_CACHE_INT_CLR_CORE0_DBUS_WR_IC_INT_CLR_Field is
     ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CORE0_ACS_CACHE_INT_CLR_Register is record
      --  Write-only. The bit is used to clear interrupt by cpu access icache
      --  while the corresponding ibus is disabled or icache is disabled which
      --  include speculative access.
      CORE0_IBUS_ACS_MSK_IC_INT_CLR : CORE0_ACS_CACHE_INT_CLR_CORE0_IBUS_ACS_MSK_IC_INT_CLR_Field :=
                                       16#0#;
      --  Write-only. The bit is used to clear interrupt by ibus trying to
      --  write icache
      CORE0_IBUS_WR_IC_INT_CLR      : CORE0_ACS_CACHE_INT_CLR_CORE0_IBUS_WR_IC_INT_CLR_Field :=
                                       16#0#;
      --  Write-only. The bit is used to clear interrupt by authentication
      --  fail.
      CORE0_IBUS_REJECT_INT_CLR     : CORE0_ACS_CACHE_INT_CLR_CORE0_IBUS_REJECT_INT_CLR_Field :=
                                       16#0#;
      --  Write-only. The bit is used to clear interrupt by cpu access icache
      --  while the corresponding dbus is disabled or icache is disabled which
      --  include speculative access.
      CORE0_DBUS_ACS_MSK_IC_INT_CLR : CORE0_ACS_CACHE_INT_CLR_CORE0_DBUS_ACS_MSK_IC_INT_CLR_Field :=
                                       16#0#;
      --  Write-only. The bit is used to clear interrupt by authentication
      --  fail.
      CORE0_DBUS_REJECT_INT_CLR     : CORE0_ACS_CACHE_INT_CLR_CORE0_DBUS_REJECT_INT_CLR_Field :=
                                       16#0#;
      --  Write-only. The bit is used to clear interrupt by dbus trying to
      --  write icache
      CORE0_DBUS_WR_IC_INT_CLR      : CORE0_ACS_CACHE_INT_CLR_CORE0_DBUS_WR_IC_INT_CLR_Field :=
                                       16#0#;
      --  unspecified
      Reserved_6_31                 : ESP32_C3.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE0_ACS_CACHE_INT_CLR_Register use record
      CORE0_IBUS_ACS_MSK_IC_INT_CLR at 0 range 0 .. 0;
      CORE0_IBUS_WR_IC_INT_CLR      at 0 range 1 .. 1;
      CORE0_IBUS_REJECT_INT_CLR     at 0 range 2 .. 2;
      CORE0_DBUS_ACS_MSK_IC_INT_CLR at 0 range 3 .. 3;
      CORE0_DBUS_REJECT_INT_CLR     at 0 range 4 .. 4;
      CORE0_DBUS_WR_IC_INT_CLR      at 0 range 5 .. 5;
      Reserved_6_31                 at 0 range 6 .. 31;
   end record;

   subtype CORE0_ACS_CACHE_INT_ST_CORE0_IBUS_ACS_MSK_ICACHE_ST_Field is
     ESP32_C3.Bit;
   subtype CORE0_ACS_CACHE_INT_ST_CORE0_IBUS_WR_ICACHE_ST_Field is
     ESP32_C3.Bit;
   subtype CORE0_ACS_CACHE_INT_ST_CORE0_IBUS_REJECT_ST_Field is ESP32_C3.Bit;
   subtype CORE0_ACS_CACHE_INT_ST_CORE0_DBUS_ACS_MSK_ICACHE_ST_Field is
     ESP32_C3.Bit;
   subtype CORE0_ACS_CACHE_INT_ST_CORE0_DBUS_REJECT_ST_Field is ESP32_C3.Bit;
   subtype CORE0_ACS_CACHE_INT_ST_CORE0_DBUS_WR_ICACHE_ST_Field is
     ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CORE0_ACS_CACHE_INT_ST_Register is record
      --  Read-only. The bit is used to indicate interrupt by cpu access icache
      --  while the core0_ibus is disabled or icache is disabled which include
      --  speculative access.
      CORE0_IBUS_ACS_MSK_ICACHE_ST : CORE0_ACS_CACHE_INT_ST_CORE0_IBUS_ACS_MSK_ICACHE_ST_Field;
      --  Read-only. The bit is used to indicate interrupt by ibus trying to
      --  write icache
      CORE0_IBUS_WR_ICACHE_ST      : CORE0_ACS_CACHE_INT_ST_CORE0_IBUS_WR_ICACHE_ST_Field;
      --  Read-only. The bit is used to indicate interrupt by authentication
      --  fail.
      CORE0_IBUS_REJECT_ST         : CORE0_ACS_CACHE_INT_ST_CORE0_IBUS_REJECT_ST_Field;
      --  Read-only. The bit is used to indicate interrupt by cpu access icache
      --  while the core0_dbus is disabled or icache is disabled which include
      --  speculative access.
      CORE0_DBUS_ACS_MSK_ICACHE_ST : CORE0_ACS_CACHE_INT_ST_CORE0_DBUS_ACS_MSK_ICACHE_ST_Field;
      --  Read-only. The bit is used to indicate interrupt by authentication
      --  fail.
      CORE0_DBUS_REJECT_ST         : CORE0_ACS_CACHE_INT_ST_CORE0_DBUS_REJECT_ST_Field;
      --  Read-only. The bit is used to indicate interrupt by dbus trying to
      --  write icache
      CORE0_DBUS_WR_ICACHE_ST      : CORE0_ACS_CACHE_INT_ST_CORE0_DBUS_WR_ICACHE_ST_Field;
      --  unspecified
      Reserved_6_31                : ESP32_C3.UInt26;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE0_ACS_CACHE_INT_ST_Register use record
      CORE0_IBUS_ACS_MSK_ICACHE_ST at 0 range 0 .. 0;
      CORE0_IBUS_WR_ICACHE_ST      at 0 range 1 .. 1;
      CORE0_IBUS_REJECT_ST         at 0 range 2 .. 2;
      CORE0_DBUS_ACS_MSK_ICACHE_ST at 0 range 3 .. 3;
      CORE0_DBUS_REJECT_ST         at 0 range 4 .. 4;
      CORE0_DBUS_WR_ICACHE_ST      at 0 range 5 .. 5;
      Reserved_6_31                at 0 range 6 .. 31;
   end record;

   subtype CORE0_DBUS_REJECT_ST_CORE0_DBUS_ATTR_Field is ESP32_C3.UInt3;
   subtype CORE0_DBUS_REJECT_ST_CORE0_DBUS_WORLD_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CORE0_DBUS_REJECT_ST_Register is record
      --  Read-only. The bits are used to indicate the attribute of CPU access
      --  dbus when authentication fail. 0: invalidate, 1: execute-able, 2:
      --  read-able, 4: write-able.
      CORE0_DBUS_ATTR  : CORE0_DBUS_REJECT_ST_CORE0_DBUS_ATTR_Field;
      --  Read-only. The bit is used to indicate the world of CPU access dbus
      --  when authentication fail. 0: WORLD0, 1: WORLD1
      CORE0_DBUS_WORLD : CORE0_DBUS_REJECT_ST_CORE0_DBUS_WORLD_Field;
      --  unspecified
      Reserved_4_31    : ESP32_C3.UInt28;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE0_DBUS_REJECT_ST_Register use record
      CORE0_DBUS_ATTR  at 0 range 0 .. 2;
      CORE0_DBUS_WORLD at 0 range 3 .. 3;
      Reserved_4_31    at 0 range 4 .. 31;
   end record;

   subtype CORE0_IBUS_REJECT_ST_CORE0_IBUS_ATTR_Field is ESP32_C3.UInt3;
   subtype CORE0_IBUS_REJECT_ST_CORE0_IBUS_WORLD_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CORE0_IBUS_REJECT_ST_Register is record
      --  Read-only. The bits are used to indicate the attribute of CPU access
      --  ibus when authentication fail. 0: invalidate, 1: execute-able, 2:
      --  read-able
      CORE0_IBUS_ATTR  : CORE0_IBUS_REJECT_ST_CORE0_IBUS_ATTR_Field;
      --  Read-only. The bit is used to indicate the world of CPU access ibus
      --  when authentication fail. 0: WORLD0, 1: WORLD1
      CORE0_IBUS_WORLD : CORE0_IBUS_REJECT_ST_CORE0_IBUS_WORLD_Field;
      --  unspecified
      Reserved_4_31    : ESP32_C3.UInt28;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CORE0_IBUS_REJECT_ST_Register use record
      CORE0_IBUS_ATTR  at 0 range 0 .. 2;
      CORE0_IBUS_WORLD at 0 range 3 .. 3;
      Reserved_4_31    at 0 range 4 .. 31;
   end record;

   subtype CACHE_MMU_FAULT_CONTENT_CACHE_MMU_FAULT_CONTENT_Field is
     ESP32_C3.UInt10;
   subtype CACHE_MMU_FAULT_CONTENT_CACHE_MMU_FAULT_CODE_Field is
     ESP32_C3.UInt4;

   --  This description will be updated in the near future.
   type CACHE_MMU_FAULT_CONTENT_Register is record
      --  Read-only. The bits are used to indicate the content of mmu entry
      --  which cause mmu fault..
      CACHE_MMU_FAULT_CONTENT : CACHE_MMU_FAULT_CONTENT_CACHE_MMU_FAULT_CONTENT_Field;
      --  Read-only. The right-most 3 bits are used to indicate the operations
      --  which cause mmu fault occurrence. 0: default, 1: cpu miss, 2: preload
      --  miss, 3: writeback, 4: cpu miss evict recovery address, 5: load miss
      --  evict recovery address, 6: external dma tx, 7: external dma rx. The
      --  most significant bit is used to indicate this operation occurs in
      --  which one icache.
      CACHE_MMU_FAULT_CODE    : CACHE_MMU_FAULT_CONTENT_CACHE_MMU_FAULT_CODE_Field;
      --  unspecified
      Reserved_14_31          : ESP32_C3.UInt18;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_MMU_FAULT_CONTENT_Register use record
      CACHE_MMU_FAULT_CONTENT at 0 range 0 .. 9;
      CACHE_MMU_FAULT_CODE    at 0 range 10 .. 13;
      Reserved_14_31          at 0 range 14 .. 31;
   end record;

   subtype CACHE_WRAP_AROUND_CTRL_CACHE_FLASH_WRAP_AROUND_Field is
     ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CACHE_WRAP_AROUND_CTRL_Register is record
      --  The bit is used to enable wrap around mode when read data from flash.
      CACHE_FLASH_WRAP_AROUND : CACHE_WRAP_AROUND_CTRL_CACHE_FLASH_WRAP_AROUND_Field :=
                                 16#0#;
      --  unspecified
      Reserved_1_31           : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_WRAP_AROUND_CTRL_Register use record
      CACHE_FLASH_WRAP_AROUND at 0 range 0 .. 0;
      Reserved_1_31           at 0 range 1 .. 31;
   end record;

   subtype CACHE_MMU_POWER_CTRL_CACHE_MMU_MEM_FORCE_ON_Field is ESP32_C3.Bit;
   subtype CACHE_MMU_POWER_CTRL_CACHE_MMU_MEM_FORCE_PD_Field is ESP32_C3.Bit;
   subtype CACHE_MMU_POWER_CTRL_CACHE_MMU_MEM_FORCE_PU_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CACHE_MMU_POWER_CTRL_Register is record
      --  The bit is used to enable clock gating to save power when access mmu
      --  memory, 0: enable, 1: disable
      CACHE_MMU_MEM_FORCE_ON : CACHE_MMU_POWER_CTRL_CACHE_MMU_MEM_FORCE_ON_Field :=
                                16#1#;
      --  The bit is used to power mmu memory down, 0: follow_rtc_lslp_pd, 1:
      --  power down
      CACHE_MMU_MEM_FORCE_PD : CACHE_MMU_POWER_CTRL_CACHE_MMU_MEM_FORCE_PD_Field :=
                                16#0#;
      --  The bit is used to power mmu memory down, 0: follow_rtc_lslp_pd, 1:
      --  power up
      CACHE_MMU_MEM_FORCE_PU : CACHE_MMU_POWER_CTRL_CACHE_MMU_MEM_FORCE_PU_Field :=
                                16#1#;
      --  unspecified
      Reserved_3_31          : ESP32_C3.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_MMU_POWER_CTRL_Register use record
      CACHE_MMU_MEM_FORCE_ON at 0 range 0 .. 0;
      CACHE_MMU_MEM_FORCE_PD at 0 range 1 .. 1;
      CACHE_MMU_MEM_FORCE_PU at 0 range 2 .. 2;
      Reserved_3_31          at 0 range 3 .. 31;
   end record;

   subtype CACHE_STATE_ICACHE_STATE_Field is ESP32_C3.UInt12;

   --  This description will be updated in the near future.
   type CACHE_STATE_Register is record
      --  Read-only. The bit is used to indicate whether icache main fsm is in
      --  idle state or not. 1: in idle state, 0: not in idle state
      ICACHE_STATE   : CACHE_STATE_ICACHE_STATE_Field;
      --  unspecified
      Reserved_12_31 : ESP32_C3.UInt20;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_STATE_Register use record
      ICACHE_STATE   at 0 range 0 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;

   subtype CACHE_ENCRYPT_DECRYPT_RECORD_DISABLE_RECORD_DISABLE_DB_ENCRYPT_Field is
     ESP32_C3.Bit;
   subtype CACHE_ENCRYPT_DECRYPT_RECORD_DISABLE_RECORD_DISABLE_G0CB_DECRYPT_Field is
     ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CACHE_ENCRYPT_DECRYPT_RECORD_DISABLE_Register is record
      --  Reserved.
      RECORD_DISABLE_DB_ENCRYPT   : CACHE_ENCRYPT_DECRYPT_RECORD_DISABLE_RECORD_DISABLE_DB_ENCRYPT_Field :=
                                     16#0#;
      --  Reserved.
      RECORD_DISABLE_G0CB_DECRYPT : CACHE_ENCRYPT_DECRYPT_RECORD_DISABLE_RECORD_DISABLE_G0CB_DECRYPT_Field :=
                                     16#0#;
      --  unspecified
      Reserved_2_31               : ESP32_C3.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_ENCRYPT_DECRYPT_RECORD_DISABLE_Register use record
      RECORD_DISABLE_DB_ENCRYPT   at 0 range 0 .. 0;
      RECORD_DISABLE_G0CB_DECRYPT at 0 range 1 .. 1;
      Reserved_2_31               at 0 range 2 .. 31;
   end record;

   subtype CACHE_ENCRYPT_DECRYPT_CLK_FORCE_ON_CLK_FORCE_ON_MANUAL_CRYPT_Field is
     ESP32_C3.Bit;
   subtype CACHE_ENCRYPT_DECRYPT_CLK_FORCE_ON_CLK_FORCE_ON_AUTO_CRYPT_Field is
     ESP32_C3.Bit;
   subtype CACHE_ENCRYPT_DECRYPT_CLK_FORCE_ON_CLK_FORCE_ON_CRYPT_Field is
     ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CACHE_ENCRYPT_DECRYPT_CLK_FORCE_ON_Register is record
      --  The bit is used to close clock gating of manual crypt clock. 1: close
      --  gating, 0: open clock gating.
      CLK_FORCE_ON_MANUAL_CRYPT : CACHE_ENCRYPT_DECRYPT_CLK_FORCE_ON_CLK_FORCE_ON_MANUAL_CRYPT_Field :=
                                   16#1#;
      --  The bit is used to close clock gating of automatic crypt clock. 1:
      --  close gating, 0: open clock gating.
      CLK_FORCE_ON_AUTO_CRYPT   : CACHE_ENCRYPT_DECRYPT_CLK_FORCE_ON_CLK_FORCE_ON_AUTO_CRYPT_Field :=
                                   16#1#;
      --  The bit is used to close clock gating of external memory encrypt and
      --  decrypt clock. 1: close gating, 0: open clock gating.
      CLK_FORCE_ON_CRYPT        : CACHE_ENCRYPT_DECRYPT_CLK_FORCE_ON_CLK_FORCE_ON_CRYPT_Field :=
                                   16#1#;
      --  unspecified
      Reserved_3_31             : ESP32_C3.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_ENCRYPT_DECRYPT_CLK_FORCE_ON_Register use record
      CLK_FORCE_ON_MANUAL_CRYPT at 0 range 0 .. 0;
      CLK_FORCE_ON_AUTO_CRYPT   at 0 range 1 .. 1;
      CLK_FORCE_ON_CRYPT        at 0 range 2 .. 2;
      Reserved_3_31             at 0 range 3 .. 31;
   end record;

   subtype CACHE_PRELOAD_INT_CTRL_ICACHE_PRELOAD_INT_ST_Field is ESP32_C3.Bit;
   subtype CACHE_PRELOAD_INT_CTRL_ICACHE_PRELOAD_INT_ENA_Field is ESP32_C3.Bit;
   subtype CACHE_PRELOAD_INT_CTRL_ICACHE_PRELOAD_INT_CLR_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CACHE_PRELOAD_INT_CTRL_Register is record
      --  Read-only. The bit is used to indicate the interrupt by icache
      --  pre-load done.
      ICACHE_PRELOAD_INT_ST  : CACHE_PRELOAD_INT_CTRL_ICACHE_PRELOAD_INT_ST_Field :=
                                16#0#;
      --  The bit is used to enable the interrupt by icache pre-load done.
      ICACHE_PRELOAD_INT_ENA : CACHE_PRELOAD_INT_CTRL_ICACHE_PRELOAD_INT_ENA_Field :=
                                16#0#;
      --  Write-only. The bit is used to clear the interrupt by icache pre-load
      --  done.
      ICACHE_PRELOAD_INT_CLR : CACHE_PRELOAD_INT_CTRL_ICACHE_PRELOAD_INT_CLR_Field :=
                                16#0#;
      --  unspecified
      Reserved_3_31          : ESP32_C3.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_PRELOAD_INT_CTRL_Register use record
      ICACHE_PRELOAD_INT_ST  at 0 range 0 .. 0;
      ICACHE_PRELOAD_INT_ENA at 0 range 1 .. 1;
      ICACHE_PRELOAD_INT_CLR at 0 range 2 .. 2;
      Reserved_3_31          at 0 range 3 .. 31;
   end record;

   subtype CACHE_SYNC_INT_CTRL_ICACHE_SYNC_INT_ST_Field is ESP32_C3.Bit;
   subtype CACHE_SYNC_INT_CTRL_ICACHE_SYNC_INT_ENA_Field is ESP32_C3.Bit;
   subtype CACHE_SYNC_INT_CTRL_ICACHE_SYNC_INT_CLR_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CACHE_SYNC_INT_CTRL_Register is record
      --  Read-only. The bit is used to indicate the interrupt by icache sync
      --  done.
      ICACHE_SYNC_INT_ST  : CACHE_SYNC_INT_CTRL_ICACHE_SYNC_INT_ST_Field :=
                             16#0#;
      --  The bit is used to enable the interrupt by icache sync done.
      ICACHE_SYNC_INT_ENA : CACHE_SYNC_INT_CTRL_ICACHE_SYNC_INT_ENA_Field :=
                             16#0#;
      --  Write-only. The bit is used to clear the interrupt by icache sync
      --  done.
      ICACHE_SYNC_INT_CLR : CACHE_SYNC_INT_CTRL_ICACHE_SYNC_INT_CLR_Field :=
                             16#0#;
      --  unspecified
      Reserved_3_31       : ESP32_C3.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_SYNC_INT_CTRL_Register use record
      ICACHE_SYNC_INT_ST  at 0 range 0 .. 0;
      ICACHE_SYNC_INT_ENA at 0 range 1 .. 1;
      ICACHE_SYNC_INT_CLR at 0 range 2 .. 2;
      Reserved_3_31       at 0 range 3 .. 31;
   end record;

   subtype CACHE_MMU_OWNER_CACHE_MMU_OWNER_Field is ESP32_C3.UInt4;

   --  This description will be updated in the near future.
   type CACHE_MMU_OWNER_Register is record
      --  The bits are used to specify the owner of MMU.bit0/bit2: ibus,
      --  bit1/bit3: dbus
      CACHE_MMU_OWNER : CACHE_MMU_OWNER_CACHE_MMU_OWNER_Field := 16#0#;
      --  unspecified
      Reserved_4_31   : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_MMU_OWNER_Register use record
      CACHE_MMU_OWNER at 0 range 0 .. 3;
      Reserved_4_31   at 0 range 4 .. 31;
   end record;

   subtype CACHE_CONF_MISC_CACHE_IGNORE_PRELOAD_MMU_ENTRY_FAULT_Field is
     ESP32_C3.Bit;
   subtype CACHE_CONF_MISC_CACHE_IGNORE_SYNC_MMU_ENTRY_FAULT_Field is
     ESP32_C3.Bit;
   subtype CACHE_CONF_MISC_CACHE_TRACE_ENA_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CACHE_CONF_MISC_Register is record
      --  The bit is used to disable checking mmu entry fault by preload
      --  operation.
      CACHE_IGNORE_PRELOAD_MMU_ENTRY_FAULT : CACHE_CONF_MISC_CACHE_IGNORE_PRELOAD_MMU_ENTRY_FAULT_Field :=
                                              16#1#;
      --  The bit is used to disable checking mmu entry fault by sync
      --  operation.
      CACHE_IGNORE_SYNC_MMU_ENTRY_FAULT    : CACHE_CONF_MISC_CACHE_IGNORE_SYNC_MMU_ENTRY_FAULT_Field :=
                                              16#1#;
      --  The bit is used to enable cache trace function.
      CACHE_TRACE_ENA                      : CACHE_CONF_MISC_CACHE_TRACE_ENA_Field :=
                                              16#1#;
      --  unspecified
      Reserved_3_31                        : ESP32_C3.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_CONF_MISC_Register use record
      CACHE_IGNORE_PRELOAD_MMU_ENTRY_FAULT at 0 range 0 .. 0;
      CACHE_IGNORE_SYNC_MMU_ENTRY_FAULT    at 0 range 1 .. 1;
      CACHE_TRACE_ENA                      at 0 range 2 .. 2;
      Reserved_3_31                        at 0 range 3 .. 31;
   end record;

   subtype ICACHE_FREEZE_ENA_Field is ESP32_C3.Bit;
   subtype ICACHE_FREEZE_MODE_Field is ESP32_C3.Bit;
   subtype ICACHE_FREEZE_DONE_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type ICACHE_FREEZE_Register is record
      --  The bit is used to enable icache freeze mode
      ENA           : ICACHE_FREEZE_ENA_Field := 16#0#;
      --  The bit is used to configure freeze mode, 0: assert busy if CPU miss
      --  1: assert hit if CPU miss
      MODE          : ICACHE_FREEZE_MODE_Field := 16#0#;
      --  Read-only. The bit is used to indicate icache freeze success
      DONE          : ICACHE_FREEZE_DONE_Field := 16#0#;
      --  unspecified
      Reserved_3_31 : ESP32_C3.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_FREEZE_Register use record
      ENA           at 0 range 0 .. 0;
      MODE          at 0 range 1 .. 1;
      DONE          at 0 range 2 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   subtype ICACHE_ATOMIC_OPERATE_ENA_ICACHE_ATOMIC_OPERATE_ENA_Field is
     ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type ICACHE_ATOMIC_OPERATE_ENA_Register is record
      --  The bit is used to activate icache atomic operation protection. In
      --  this case, sync/lock operation can not interrupt miss-work. This
      --  feature does not work during invalidateAll operation.
      ICACHE_ATOMIC_OPERATE_ENA : ICACHE_ATOMIC_OPERATE_ENA_ICACHE_ATOMIC_OPERATE_ENA_Field :=
                                   16#1#;
      --  unspecified
      Reserved_1_31             : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICACHE_ATOMIC_OPERATE_ENA_Register use record
      ICACHE_ATOMIC_OPERATE_ENA at 0 range 0 .. 0;
      Reserved_1_31             at 0 range 1 .. 31;
   end record;

   subtype CACHE_REQUEST_BYPASS_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CACHE_REQUEST_Register is record
      --  The bit is used to disable request recording which could cause
      --  performance issue
      BYPASS        : CACHE_REQUEST_BYPASS_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CACHE_REQUEST_Register use record
      BYPASS        at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype IBUS_PMS_TBL_LOCK_IBUS_PMS_LOCK_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type IBUS_PMS_TBL_LOCK_Register is record
      --  The bit is used to configure the ibus permission control section
      --  boundary0
      IBUS_PMS_LOCK : IBUS_PMS_TBL_LOCK_IBUS_PMS_LOCK_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for IBUS_PMS_TBL_LOCK_Register use record
      IBUS_PMS_LOCK at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype IBUS_PMS_TBL_BOUNDARY0_IBUS_PMS_BOUNDARY0_Field is ESP32_C3.UInt12;

   --  This description will be updated in the near future.
   type IBUS_PMS_TBL_BOUNDARY0_Register is record
      --  The bit is used to configure the ibus permission control section
      --  boundary0
      IBUS_PMS_BOUNDARY0 : IBUS_PMS_TBL_BOUNDARY0_IBUS_PMS_BOUNDARY0_Field :=
                            16#0#;
      --  unspecified
      Reserved_12_31     : ESP32_C3.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for IBUS_PMS_TBL_BOUNDARY0_Register use record
      IBUS_PMS_BOUNDARY0 at 0 range 0 .. 11;
      Reserved_12_31     at 0 range 12 .. 31;
   end record;

   subtype IBUS_PMS_TBL_BOUNDARY1_IBUS_PMS_BOUNDARY1_Field is ESP32_C3.UInt12;

   --  This description will be updated in the near future.
   type IBUS_PMS_TBL_BOUNDARY1_Register is record
      --  The bit is used to configure the ibus permission control section
      --  boundary1
      IBUS_PMS_BOUNDARY1 : IBUS_PMS_TBL_BOUNDARY1_IBUS_PMS_BOUNDARY1_Field :=
                            16#800#;
      --  unspecified
      Reserved_12_31     : ESP32_C3.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for IBUS_PMS_TBL_BOUNDARY1_Register use record
      IBUS_PMS_BOUNDARY1 at 0 range 0 .. 11;
      Reserved_12_31     at 0 range 12 .. 31;
   end record;

   subtype IBUS_PMS_TBL_BOUNDARY2_IBUS_PMS_BOUNDARY2_Field is ESP32_C3.UInt12;

   --  This description will be updated in the near future.
   type IBUS_PMS_TBL_BOUNDARY2_Register is record
      --  The bit is used to configure the ibus permission control section
      --  boundary2
      IBUS_PMS_BOUNDARY2 : IBUS_PMS_TBL_BOUNDARY2_IBUS_PMS_BOUNDARY2_Field :=
                            16#800#;
      --  unspecified
      Reserved_12_31     : ESP32_C3.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for IBUS_PMS_TBL_BOUNDARY2_Register use record
      IBUS_PMS_BOUNDARY2 at 0 range 0 .. 11;
      Reserved_12_31     at 0 range 12 .. 31;
   end record;

   subtype IBUS_PMS_TBL_ATTR_IBUS_PMS_SCT1_ATTR_Field is ESP32_C3.UInt4;
   subtype IBUS_PMS_TBL_ATTR_IBUS_PMS_SCT2_ATTR_Field is ESP32_C3.UInt4;

   --  This description will be updated in the near future.
   type IBUS_PMS_TBL_ATTR_Register is record
      --  The bit is used to configure attribute of the ibus permission control
      --  section1, bit0: fetch in world0, bit1: load in world0, bit2: fetch in
      --  world1, bit3: load in world1
      IBUS_PMS_SCT1_ATTR : IBUS_PMS_TBL_ATTR_IBUS_PMS_SCT1_ATTR_Field :=
                            16#F#;
      --  The bit is used to configure attribute of the ibus permission control
      --  section2, bit0: fetch in world0, bit1: load in world0, bit2: fetch in
      --  world1, bit3: load in world1
      IBUS_PMS_SCT2_ATTR : IBUS_PMS_TBL_ATTR_IBUS_PMS_SCT2_ATTR_Field :=
                            16#F#;
      --  unspecified
      Reserved_8_31      : ESP32_C3.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for IBUS_PMS_TBL_ATTR_Register use record
      IBUS_PMS_SCT1_ATTR at 0 range 0 .. 3;
      IBUS_PMS_SCT2_ATTR at 0 range 4 .. 7;
      Reserved_8_31      at 0 range 8 .. 31;
   end record;

   subtype DBUS_PMS_TBL_LOCK_DBUS_PMS_LOCK_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type DBUS_PMS_TBL_LOCK_Register is record
      --  The bit is used to configure the ibus permission control section
      --  boundary0
      DBUS_PMS_LOCK : DBUS_PMS_TBL_LOCK_DBUS_PMS_LOCK_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : ESP32_C3.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DBUS_PMS_TBL_LOCK_Register use record
      DBUS_PMS_LOCK at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype DBUS_PMS_TBL_BOUNDARY0_DBUS_PMS_BOUNDARY0_Field is ESP32_C3.UInt12;

   --  This description will be updated in the near future.
   type DBUS_PMS_TBL_BOUNDARY0_Register is record
      --  The bit is used to configure the dbus permission control section
      --  boundary0
      DBUS_PMS_BOUNDARY0 : DBUS_PMS_TBL_BOUNDARY0_DBUS_PMS_BOUNDARY0_Field :=
                            16#0#;
      --  unspecified
      Reserved_12_31     : ESP32_C3.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DBUS_PMS_TBL_BOUNDARY0_Register use record
      DBUS_PMS_BOUNDARY0 at 0 range 0 .. 11;
      Reserved_12_31     at 0 range 12 .. 31;
   end record;

   subtype DBUS_PMS_TBL_BOUNDARY1_DBUS_PMS_BOUNDARY1_Field is ESP32_C3.UInt12;

   --  This description will be updated in the near future.
   type DBUS_PMS_TBL_BOUNDARY1_Register is record
      --  The bit is used to configure the dbus permission control section
      --  boundary1
      DBUS_PMS_BOUNDARY1 : DBUS_PMS_TBL_BOUNDARY1_DBUS_PMS_BOUNDARY1_Field :=
                            16#800#;
      --  unspecified
      Reserved_12_31     : ESP32_C3.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DBUS_PMS_TBL_BOUNDARY1_Register use record
      DBUS_PMS_BOUNDARY1 at 0 range 0 .. 11;
      Reserved_12_31     at 0 range 12 .. 31;
   end record;

   subtype DBUS_PMS_TBL_BOUNDARY2_DBUS_PMS_BOUNDARY2_Field is ESP32_C3.UInt12;

   --  This description will be updated in the near future.
   type DBUS_PMS_TBL_BOUNDARY2_Register is record
      --  The bit is used to configure the dbus permission control section
      --  boundary2
      DBUS_PMS_BOUNDARY2 : DBUS_PMS_TBL_BOUNDARY2_DBUS_PMS_BOUNDARY2_Field :=
                            16#800#;
      --  unspecified
      Reserved_12_31     : ESP32_C3.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DBUS_PMS_TBL_BOUNDARY2_Register use record
      DBUS_PMS_BOUNDARY2 at 0 range 0 .. 11;
      Reserved_12_31     at 0 range 12 .. 31;
   end record;

   subtype DBUS_PMS_TBL_ATTR_DBUS_PMS_SCT1_ATTR_Field is ESP32_C3.UInt2;
   subtype DBUS_PMS_TBL_ATTR_DBUS_PMS_SCT2_ATTR_Field is ESP32_C3.UInt2;

   --  This description will be updated in the near future.
   type DBUS_PMS_TBL_ATTR_Register is record
      --  The bit is used to configure attribute of the dbus permission control
      --  section1, bit0: load in world0, bit2: load in world1
      DBUS_PMS_SCT1_ATTR : DBUS_PMS_TBL_ATTR_DBUS_PMS_SCT1_ATTR_Field :=
                            16#3#;
      --  The bit is used to configure attribute of the dbus permission control
      --  section2, bit0: load in world0, bit2: load in world1
      DBUS_PMS_SCT2_ATTR : DBUS_PMS_TBL_ATTR_DBUS_PMS_SCT2_ATTR_Field :=
                            16#3#;
      --  unspecified
      Reserved_4_31      : ESP32_C3.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DBUS_PMS_TBL_ATTR_Register use record
      DBUS_PMS_SCT1_ATTR at 0 range 0 .. 1;
      DBUS_PMS_SCT2_ATTR at 0 range 2 .. 3;
      Reserved_4_31      at 0 range 4 .. 31;
   end record;

   subtype CLOCK_GATE_CLK_EN_Field is ESP32_C3.Bit;

   --  This description will be updated in the near future.
   type CLOCK_GATE_Register is record
      --  clock gate enable.
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

   subtype REG_DATE_DATE_Field is ESP32_C3.UInt28;

   --  This description will be updated in the near future.
   type REG_DATE_Register is record
      --  version information
      DATE           : REG_DATE_DATE_Field := 16#2007160#;
      --  unspecified
      Reserved_28_31 : ESP32_C3.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for REG_DATE_Register use record
      DATE           at 0 range 0 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  External Memory
   type EXTMEM_Peripheral is record
      --  This description will be updated in the near future.
      ICACHE_CTRL                          : aliased ICACHE_CTRL_Register;
      --  This description will be updated in the near future.
      ICACHE_CTRL1                         : aliased ICACHE_CTRL1_Register;
      --  This description will be updated in the near future.
      ICACHE_TAG_POWER_CTRL                : aliased ICACHE_TAG_POWER_CTRL_Register;
      --  This description will be updated in the near future.
      ICACHE_PRELOCK_CTRL                  : aliased ICACHE_PRELOCK_CTRL_Register;
      --  This description will be updated in the near future.
      ICACHE_PRELOCK_SCT0_ADDR             : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      ICACHE_PRELOCK_SCT1_ADDR             : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      ICACHE_PRELOCK_SCT_SIZE              : aliased ICACHE_PRELOCK_SCT_SIZE_Register;
      --  This description will be updated in the near future.
      ICACHE_LOCK_CTRL                     : aliased ICACHE_LOCK_CTRL_Register;
      --  This description will be updated in the near future.
      ICACHE_LOCK_ADDR                     : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      ICACHE_LOCK_SIZE                     : aliased ICACHE_LOCK_SIZE_Register;
      --  This description will be updated in the near future.
      ICACHE_SYNC_CTRL                     : aliased ICACHE_SYNC_CTRL_Register;
      --  This description will be updated in the near future.
      ICACHE_SYNC_ADDR                     : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      ICACHE_SYNC_SIZE                     : aliased ICACHE_SYNC_SIZE_Register;
      --  This description will be updated in the near future.
      ICACHE_PRELOAD_CTRL                  : aliased ICACHE_PRELOAD_CTRL_Register;
      --  This description will be updated in the near future.
      ICACHE_PRELOAD_ADDR                  : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      ICACHE_PRELOAD_SIZE                  : aliased ICACHE_PRELOAD_SIZE_Register;
      --  This description will be updated in the near future.
      ICACHE_AUTOLOAD_CTRL                 : aliased ICACHE_AUTOLOAD_CTRL_Register;
      --  This description will be updated in the near future.
      ICACHE_AUTOLOAD_SCT0_ADDR            : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      ICACHE_AUTOLOAD_SCT0_SIZE            : aliased ICACHE_AUTOLOAD_SCT0_SIZE_Register;
      --  This description will be updated in the near future.
      ICACHE_AUTOLOAD_SCT1_ADDR            : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      ICACHE_AUTOLOAD_SCT1_SIZE            : aliased ICACHE_AUTOLOAD_SCT1_SIZE_Register;
      --  This description will be updated in the near future.
      IBUS_TO_FLASH_START_VADDR            : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      IBUS_TO_FLASH_END_VADDR              : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      DBUS_TO_FLASH_START_VADDR            : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      DBUS_TO_FLASH_END_VADDR              : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      CACHE_ACS_CNT_CLR                    : aliased CACHE_ACS_CNT_CLR_Register;
      --  This description will be updated in the near future.
      IBUS_ACS_MISS_CNT                    : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      IBUS_ACS_CNT                         : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      DBUS_ACS_FLASH_MISS_CNT              : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      DBUS_ACS_CNT                         : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      CACHE_ILG_INT_ENA                    : aliased CACHE_ILG_INT_ENA_Register;
      --  This description will be updated in the near future.
      CACHE_ILG_INT_CLR                    : aliased CACHE_ILG_INT_CLR_Register;
      --  This description will be updated in the near future.
      CACHE_ILG_INT_ST                     : aliased CACHE_ILG_INT_ST_Register;
      --  This description will be updated in the near future.
      CORE0_ACS_CACHE_INT_ENA              : aliased CORE0_ACS_CACHE_INT_ENA_Register;
      --  This description will be updated in the near future.
      CORE0_ACS_CACHE_INT_CLR              : aliased CORE0_ACS_CACHE_INT_CLR_Register;
      --  This description will be updated in the near future.
      CORE0_ACS_CACHE_INT_ST               : aliased CORE0_ACS_CACHE_INT_ST_Register;
      --  This description will be updated in the near future.
      CORE0_DBUS_REJECT_ST                 : aliased CORE0_DBUS_REJECT_ST_Register;
      --  This description will be updated in the near future.
      CORE0_DBUS_REJECT_VADDR              : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      CORE0_IBUS_REJECT_ST                 : aliased CORE0_IBUS_REJECT_ST_Register;
      --  This description will be updated in the near future.
      CORE0_IBUS_REJECT_VADDR              : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      CACHE_MMU_FAULT_CONTENT              : aliased CACHE_MMU_FAULT_CONTENT_Register;
      --  This description will be updated in the near future.
      CACHE_MMU_FAULT_VADDR                : aliased ESP32_C3.UInt32;
      --  This description will be updated in the near future.
      CACHE_WRAP_AROUND_CTRL               : aliased CACHE_WRAP_AROUND_CTRL_Register;
      --  This description will be updated in the near future.
      CACHE_MMU_POWER_CTRL                 : aliased CACHE_MMU_POWER_CTRL_Register;
      --  This description will be updated in the near future.
      CACHE_STATE                          : aliased CACHE_STATE_Register;
      --  This description will be updated in the near future.
      CACHE_ENCRYPT_DECRYPT_RECORD_DISABLE : aliased CACHE_ENCRYPT_DECRYPT_RECORD_DISABLE_Register;
      --  This description will be updated in the near future.
      CACHE_ENCRYPT_DECRYPT_CLK_FORCE_ON   : aliased CACHE_ENCRYPT_DECRYPT_CLK_FORCE_ON_Register;
      --  This description will be updated in the near future.
      CACHE_PRELOAD_INT_CTRL               : aliased CACHE_PRELOAD_INT_CTRL_Register;
      --  This description will be updated in the near future.
      CACHE_SYNC_INT_CTRL                  : aliased CACHE_SYNC_INT_CTRL_Register;
      --  This description will be updated in the near future.
      CACHE_MMU_OWNER                      : aliased CACHE_MMU_OWNER_Register;
      --  This description will be updated in the near future.
      CACHE_CONF_MISC                      : aliased CACHE_CONF_MISC_Register;
      --  This description will be updated in the near future.
      ICACHE_FREEZE                        : aliased ICACHE_FREEZE_Register;
      --  This description will be updated in the near future.
      ICACHE_ATOMIC_OPERATE_ENA            : aliased ICACHE_ATOMIC_OPERATE_ENA_Register;
      --  This description will be updated in the near future.
      CACHE_REQUEST                        : aliased CACHE_REQUEST_Register;
      --  This description will be updated in the near future.
      IBUS_PMS_TBL_LOCK                    : aliased IBUS_PMS_TBL_LOCK_Register;
      --  This description will be updated in the near future.
      IBUS_PMS_TBL_BOUNDARY0               : aliased IBUS_PMS_TBL_BOUNDARY0_Register;
      --  This description will be updated in the near future.
      IBUS_PMS_TBL_BOUNDARY1               : aliased IBUS_PMS_TBL_BOUNDARY1_Register;
      --  This description will be updated in the near future.
      IBUS_PMS_TBL_BOUNDARY2               : aliased IBUS_PMS_TBL_BOUNDARY2_Register;
      --  This description will be updated in the near future.
      IBUS_PMS_TBL_ATTR                    : aliased IBUS_PMS_TBL_ATTR_Register;
      --  This description will be updated in the near future.
      DBUS_PMS_TBL_LOCK                    : aliased DBUS_PMS_TBL_LOCK_Register;
      --  This description will be updated in the near future.
      DBUS_PMS_TBL_BOUNDARY0               : aliased DBUS_PMS_TBL_BOUNDARY0_Register;
      --  This description will be updated in the near future.
      DBUS_PMS_TBL_BOUNDARY1               : aliased DBUS_PMS_TBL_BOUNDARY1_Register;
      --  This description will be updated in the near future.
      DBUS_PMS_TBL_BOUNDARY2               : aliased DBUS_PMS_TBL_BOUNDARY2_Register;
      --  This description will be updated in the near future.
      DBUS_PMS_TBL_ATTR                    : aliased DBUS_PMS_TBL_ATTR_Register;
      --  This description will be updated in the near future.
      CLOCK_GATE                           : aliased CLOCK_GATE_Register;
      --  This description will be updated in the near future.
      REG_DATE                             : aliased REG_DATE_Register;
   end record
     with Volatile;

   for EXTMEM_Peripheral use record
      ICACHE_CTRL                          at 16#0# range 0 .. 31;
      ICACHE_CTRL1                         at 16#4# range 0 .. 31;
      ICACHE_TAG_POWER_CTRL                at 16#8# range 0 .. 31;
      ICACHE_PRELOCK_CTRL                  at 16#C# range 0 .. 31;
      ICACHE_PRELOCK_SCT0_ADDR             at 16#10# range 0 .. 31;
      ICACHE_PRELOCK_SCT1_ADDR             at 16#14# range 0 .. 31;
      ICACHE_PRELOCK_SCT_SIZE              at 16#18# range 0 .. 31;
      ICACHE_LOCK_CTRL                     at 16#1C# range 0 .. 31;
      ICACHE_LOCK_ADDR                     at 16#20# range 0 .. 31;
      ICACHE_LOCK_SIZE                     at 16#24# range 0 .. 31;
      ICACHE_SYNC_CTRL                     at 16#28# range 0 .. 31;
      ICACHE_SYNC_ADDR                     at 16#2C# range 0 .. 31;
      ICACHE_SYNC_SIZE                     at 16#30# range 0 .. 31;
      ICACHE_PRELOAD_CTRL                  at 16#34# range 0 .. 31;
      ICACHE_PRELOAD_ADDR                  at 16#38# range 0 .. 31;
      ICACHE_PRELOAD_SIZE                  at 16#3C# range 0 .. 31;
      ICACHE_AUTOLOAD_CTRL                 at 16#40# range 0 .. 31;
      ICACHE_AUTOLOAD_SCT0_ADDR            at 16#44# range 0 .. 31;
      ICACHE_AUTOLOAD_SCT0_SIZE            at 16#48# range 0 .. 31;
      ICACHE_AUTOLOAD_SCT1_ADDR            at 16#4C# range 0 .. 31;
      ICACHE_AUTOLOAD_SCT1_SIZE            at 16#50# range 0 .. 31;
      IBUS_TO_FLASH_START_VADDR            at 16#54# range 0 .. 31;
      IBUS_TO_FLASH_END_VADDR              at 16#58# range 0 .. 31;
      DBUS_TO_FLASH_START_VADDR            at 16#5C# range 0 .. 31;
      DBUS_TO_FLASH_END_VADDR              at 16#60# range 0 .. 31;
      CACHE_ACS_CNT_CLR                    at 16#64# range 0 .. 31;
      IBUS_ACS_MISS_CNT                    at 16#68# range 0 .. 31;
      IBUS_ACS_CNT                         at 16#6C# range 0 .. 31;
      DBUS_ACS_FLASH_MISS_CNT              at 16#70# range 0 .. 31;
      DBUS_ACS_CNT                         at 16#74# range 0 .. 31;
      CACHE_ILG_INT_ENA                    at 16#78# range 0 .. 31;
      CACHE_ILG_INT_CLR                    at 16#7C# range 0 .. 31;
      CACHE_ILG_INT_ST                     at 16#80# range 0 .. 31;
      CORE0_ACS_CACHE_INT_ENA              at 16#84# range 0 .. 31;
      CORE0_ACS_CACHE_INT_CLR              at 16#88# range 0 .. 31;
      CORE0_ACS_CACHE_INT_ST               at 16#8C# range 0 .. 31;
      CORE0_DBUS_REJECT_ST                 at 16#90# range 0 .. 31;
      CORE0_DBUS_REJECT_VADDR              at 16#94# range 0 .. 31;
      CORE0_IBUS_REJECT_ST                 at 16#98# range 0 .. 31;
      CORE0_IBUS_REJECT_VADDR              at 16#9C# range 0 .. 31;
      CACHE_MMU_FAULT_CONTENT              at 16#A0# range 0 .. 31;
      CACHE_MMU_FAULT_VADDR                at 16#A4# range 0 .. 31;
      CACHE_WRAP_AROUND_CTRL               at 16#A8# range 0 .. 31;
      CACHE_MMU_POWER_CTRL                 at 16#AC# range 0 .. 31;
      CACHE_STATE                          at 16#B0# range 0 .. 31;
      CACHE_ENCRYPT_DECRYPT_RECORD_DISABLE at 16#B4# range 0 .. 31;
      CACHE_ENCRYPT_DECRYPT_CLK_FORCE_ON   at 16#B8# range 0 .. 31;
      CACHE_PRELOAD_INT_CTRL               at 16#BC# range 0 .. 31;
      CACHE_SYNC_INT_CTRL                  at 16#C0# range 0 .. 31;
      CACHE_MMU_OWNER                      at 16#C4# range 0 .. 31;
      CACHE_CONF_MISC                      at 16#C8# range 0 .. 31;
      ICACHE_FREEZE                        at 16#CC# range 0 .. 31;
      ICACHE_ATOMIC_OPERATE_ENA            at 16#D0# range 0 .. 31;
      CACHE_REQUEST                        at 16#D4# range 0 .. 31;
      IBUS_PMS_TBL_LOCK                    at 16#D8# range 0 .. 31;
      IBUS_PMS_TBL_BOUNDARY0               at 16#DC# range 0 .. 31;
      IBUS_PMS_TBL_BOUNDARY1               at 16#E0# range 0 .. 31;
      IBUS_PMS_TBL_BOUNDARY2               at 16#E4# range 0 .. 31;
      IBUS_PMS_TBL_ATTR                    at 16#E8# range 0 .. 31;
      DBUS_PMS_TBL_LOCK                    at 16#EC# range 0 .. 31;
      DBUS_PMS_TBL_BOUNDARY0               at 16#F0# range 0 .. 31;
      DBUS_PMS_TBL_BOUNDARY1               at 16#F4# range 0 .. 31;
      DBUS_PMS_TBL_BOUNDARY2               at 16#F8# range 0 .. 31;
      DBUS_PMS_TBL_ATTR                    at 16#FC# range 0 .. 31;
      CLOCK_GATE                           at 16#100# range 0 .. 31;
      REG_DATE                             at 16#3FC# range 0 .. 31;
   end record;

   --  External Memory
   EXTMEM_Periph : aliased EXTMEM_Peripheral
     with Import, Address => EXTMEM_Base;

end ESP32_C3.EXTMEM;
