--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary Watchdog driver for ESP32-C3
--

with ESP32_C3.TIMG;
with ESP32_C3.RTC_CNTL;

package body Watchdog_Driver is
   use ESP32_C3;

   WDT_Protection_Key_Value : constant := 16#50D8_3AA1#;
   SWD_Protection_Key_Value : constant := 16#8F1D_312A#;
   WDT_Feed_Value : constant := 16#8000_0000#;

   procedure Disable_Watchdogs is
      TIMG_WDTCONFIG0_Value : TIMG.WDTCONFIG0_Register;
      RTC_CNTL_WDTCONFIG0_Value : RTC_CNTL.WDTCONFIG0_Register;
      RTC_CNTL_SWD_CONF_Value : RTC_CNTL.SWD_CONF_Register;
   begin
      --  Turn Timer group 0 WDT protection off:
      TIMG.TIMG0_Periph.WDTWPROTECT := WDT_Protection_Key_Value;

      TIMG.TIMG0_Periph.WDTFEED := WDT_Feed_Value;
      TIMG_WDTCONFIG0_Value := TIMG.TIMG0_Periph.WDTCONFIG0;
      TIMG_WDTCONFIG0_Value.WDT_FLASHBOOT_MOD_EN := 0;
      TIMG_WDTCONFIG0_Value.WDT_STG0 := 0;
      TIMG_WDTCONFIG0_Value.WDT_STG1 := 0;
      TIMG_WDTCONFIG0_Value.WDT_STG2 := 0;
      TIMG_WDTCONFIG0_Value.WDT_STG3 := 0;
      TIMG_WDTCONFIG0_Value.WDT_EN := 0;
      TIMG.TIMG0_Periph.WDTCONFIG0 := TIMG_WDTCONFIG0_Value;

      --  Turn Timer group 0 WDT protection back on:
      TIMG.TIMG0_Periph.WDTWPROTECT := 0;

      --  Turn RTC WDT protection off:
      RTC_CNTL.RTC_CNTL_Periph.WDTWPROTECT := WDT_Protection_Key_Value;

      RTC_CNTL.RTC_CNTL_Periph.WDTFEED := (WDT_FEED => 1, others => 0);
      RTC_CNTL_WDTCONFIG0_Value := RTC_CNTL.RTC_CNTL_Periph.WDTCONFIG0;
      RTC_CNTL_WDTCONFIG0_Value.WDT_FLASHBOOT_MOD_EN := 0;
      RTC_CNTL_WDTCONFIG0_Value.WDT_STG0 := 0;
      RTC_CNTL_WDTCONFIG0_Value.WDT_STG1 := 0;
      RTC_CNTL_WDTCONFIG0_Value.WDT_STG2 := 0;
      RTC_CNTL_WDTCONFIG0_Value.WDT_STG3 := 0;
      RTC_CNTL_WDTCONFIG0_Value.WDT_EN := 0;
      RTC_CNTL.RTC_CNTL_Periph.WDTCONFIG0 := RTC_CNTL_WDTCONFIG0_Value;

      --  Turn RTC WDT protection back on:
      RTC_CNTL.RTC_CNTL_Periph.WDTWPROTECT := 0;

      --  Turn RTC SWD protection off:
      RTC_CNTL.RTC_CNTL_Periph.SWD_WPROTECT := SWD_Protection_Key_Value;

      RTC_CNTL_SWD_CONF_Value := RTC_CNTL.RTC_CNTL_Periph.SWD_CONF;
      RTC_CNTL_SWD_CONF_Value.SWD_FEED := 1;
      RTC_CNTL.RTC_CNTL_Periph.SWD_CONF := RTC_CNTL_SWD_CONF_Value;
      RTC_CNTL_SWD_CONF_Value.SWD_DISABLE := 1;
      RTC_CNTL.RTC_CNTL_Periph.SWD_CONF := RTC_CNTL_SWD_CONF_Value;

      --  Turn RTC SWD protection back on:
      RTC_CNTL.RTC_CNTL_Periph.SWD_WPROTECT := 0;

   end Disable_Watchdogs;

end Watchdog_Driver;