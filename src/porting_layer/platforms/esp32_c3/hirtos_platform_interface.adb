--
--  Copyright (c) 2024, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  Platform interface
--
with ESP32_C3.SENSITIVE;

package body HiRTOS_Platform_Interface
   with SPARK_Mode => Off
is

   procedure Initialize_Platform is
      IRAM_PMS_CONSTRAIN_Value : ESP32_C3.SENSITIVE.CORE_X_IRAM0_PMS_CONSTRAIN_1_Register;
      DRAM_PMS_CONSTRAIN_Value : ESP32_C3.SENSITIVE.CORE_X_DRAM0_PMS_CONSTRAIN_1_Register;
      PRIVILEGE_MODE_SEL_Value : ESP32_C3.SENSITIVE.PRIVILEGE_MODE_SEL_Register;
   begin
      --
      --  Enable privilege mode switch using the CPU's MSTATUS instead of the ESP32-C3 World controller :
      --
      PRIVILEGE_MODE_SEL_Value := ESP32_C3.SENSITIVE.SENSITIVE_Periph.PRIVILEGE_MODE_SEL;
      PRIVILEGE_MODE_SEL_Value.PRIVILEGE_MODE_SEL := 1;
      ESP32_C3.SENSITIVE.SENSITIVE_Periph.PRIVILEGE_MODE_SEL := PRIVILEGE_MODE_SEL_Value;

      --
      --   Enable unprivileged access to SRAM in the PMS:
      --
      IRAM_PMS_CONSTRAIN_Value := ESP32_C3.SENSITIVE.SENSITIVE_Periph.CORE_X_IRAM0_PMS_CONSTRAIN_1;
      IRAM_PMS_CONSTRAIN_Value.CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 := 2#111#;
      IRAM_PMS_CONSTRAIN_Value.CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 := 2#111#;
      IRAM_PMS_CONSTRAIN_Value.CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 := 2#111#;
      IRAM_PMS_CONSTRAIN_Value.CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 := 2#111#;
      ESP32_C3.SENSITIVE.SENSITIVE_Periph.CORE_X_IRAM0_PMS_CONSTRAIN_1 := IRAM_PMS_CONSTRAIN_Value;

      DRAM_PMS_CONSTRAIN_Value := ESP32_C3.SENSITIVE.SENSITIVE_Periph.CORE_X_DRAM0_PMS_CONSTRAIN_1;
      DRAM_PMS_CONSTRAIN_Value.CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 := 2#11#;
      DRAM_PMS_CONSTRAIN_Value.CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 := 2#11#;
      DRAM_PMS_CONSTRAIN_Value.CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 := 2#11#;
      DRAM_PMS_CONSTRAIN_Value.CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 := 2#11#;
      ESP32_C3.SENSITIVE.SENSITIVE_Periph.CORE_X_DRAM0_PMS_CONSTRAIN_1 := DRAM_PMS_CONSTRAIN_Value;
   end Initialize_Platform;

   procedure Initialize_Interrupt_Controller is
   begin
      null; --????TODO
   end Initialize_Interrupt_Controller;

   procedure Initialize_System_Timer is
   begin
      null; --????TODO
   end Initialize_System_Timer;


end HiRTOS_Platform_Interface;
