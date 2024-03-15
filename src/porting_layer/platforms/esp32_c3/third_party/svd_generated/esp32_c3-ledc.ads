pragma Style_Checks (Off);

--  Copyright 2024 Espressif Systems (Shanghai) PTE LTD    Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at        http://www.apache.org/licenses/LICENSE-2.0    Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.

--  This spec has been automatically generated from esp32c3.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package ESP32_C3.LEDC is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype CH_CONF_TIMER_SEL_Field is ESP32_C3.UInt2;
   subtype CH_CONF_SIG_OUT_EN_Field is ESP32_C3.Bit;
   subtype CH_CONF_IDLE_LV_Field is ESP32_C3.Bit;
   subtype CH_CONF_PARA_UP_Field is ESP32_C3.Bit;
   subtype CH_CONF_OVF_NUM_Field is ESP32_C3.UInt10;
   subtype CH_CONF_OVF_CNT_EN_Field is ESP32_C3.Bit;
   subtype CH_CONF_OVF_CNT_RESET_Field is ESP32_C3.Bit;

   --  LEDC_LSCH%s_CONF%s.
   type CH_CONF_Register is record
      --  reg_timer_sel_lsch0.
      TIMER_SEL      : CH_CONF_TIMER_SEL_Field := 16#0#;
      --  reg_sig_out_en_lsch0.
      SIG_OUT_EN     : CH_CONF_SIG_OUT_EN_Field := 16#0#;
      --  reg_idle_lv_lsch0.
      IDLE_LV        : CH_CONF_IDLE_LV_Field := 16#0#;
      --  Write-only. reg_para_up_lsch0.
      PARA_UP        : CH_CONF_PARA_UP_Field := 16#0#;
      --  reg_ovf_num_lsch0.
      OVF_NUM        : CH_CONF_OVF_NUM_Field := 16#0#;
      --  reg_ovf_cnt_en_lsch0.
      OVF_CNT_EN     : CH_CONF_OVF_CNT_EN_Field := 16#0#;
      --  Write-only. reg_ovf_cnt_reset_lsch0.
      OVF_CNT_RESET  : CH_CONF_OVF_CNT_RESET_Field := 16#0#;
      --  unspecified
      Reserved_17_31 : ESP32_C3.UInt15 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CH_CONF_Register use record
      TIMER_SEL      at 0 range 0 .. 1;
      SIG_OUT_EN     at 0 range 2 .. 2;
      IDLE_LV        at 0 range 3 .. 3;
      PARA_UP        at 0 range 4 .. 4;
      OVF_NUM        at 0 range 5 .. 14;
      OVF_CNT_EN     at 0 range 15 .. 15;
      OVF_CNT_RESET  at 0 range 16 .. 16;
      Reserved_17_31 at 0 range 17 .. 31;
   end record;

   subtype CH_HPOINT_HPOINT_Field is ESP32_C3.UInt14;

   --  LEDC_LSCH%s_HPOINT.
   type CH_HPOINT_Register is record
      --  reg_hpoint_lsch0.
      HPOINT         : CH_HPOINT_HPOINT_Field := 16#0#;
      --  unspecified
      Reserved_14_31 : ESP32_C3.UInt18 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CH_HPOINT_Register use record
      HPOINT         at 0 range 0 .. 13;
      Reserved_14_31 at 0 range 14 .. 31;
   end record;

   subtype CH_DUTY_DUTY_Field is ESP32_C3.UInt19;

   --  LEDC_LSCH%s_DUTY.
   type CH_DUTY_Register is record
      --  reg_duty_lsch0.
      DUTY           : CH_DUTY_DUTY_Field := 16#0#;
      --  unspecified
      Reserved_19_31 : ESP32_C3.UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CH_DUTY_Register use record
      DUTY           at 0 range 0 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   subtype CH_CONF_DUTY_SCALE_Field is ESP32_C3.UInt10;
   subtype CH_CONF_DUTY_CYCLE_Field is ESP32_C3.UInt10;
   subtype CH_CONF_DUTY_NUM_Field is ESP32_C3.UInt10;
   subtype CH_CONF_DUTY_INC_Field is ESP32_C3.Bit;
   subtype CH_CONF_DUTY_START_Field is ESP32_C3.Bit;

   --  LEDC_LSCH%s_CONF1.
   type CH_CONF_Register_1 is record
      --  reg_duty_scale_lsch0.
      DUTY_SCALE : CH_CONF_DUTY_SCALE_Field := 16#0#;
      --  reg_duty_cycle_lsch0.
      DUTY_CYCLE : CH_CONF_DUTY_CYCLE_Field := 16#0#;
      --  reg_duty_num_lsch0.
      DUTY_NUM   : CH_CONF_DUTY_NUM_Field := 16#0#;
      --  reg_duty_inc_lsch0.
      DUTY_INC   : CH_CONF_DUTY_INC_Field := 16#1#;
      --  reg_duty_start_lsch0.
      DUTY_START : CH_CONF_DUTY_START_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CH_CONF_Register_1 use record
      DUTY_SCALE at 0 range 0 .. 9;
      DUTY_CYCLE at 0 range 10 .. 19;
      DUTY_NUM   at 0 range 20 .. 29;
      DUTY_INC   at 0 range 30 .. 30;
      DUTY_START at 0 range 31 .. 31;
   end record;

   subtype CH_DUTY_R_DUTY_R_Field is ESP32_C3.UInt19;

   --  LEDC_LSCH%s_DUTY_R.
   type CH_DUTY_R_Register is record
      --  Read-only. reg_duty_lsch0_r.
      DUTY_R         : CH_DUTY_R_DUTY_R_Field;
      --  unspecified
      Reserved_19_31 : ESP32_C3.UInt13;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CH_DUTY_R_Register use record
      DUTY_R         at 0 range 0 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   subtype TIMER_CONF_DUTY_RES_Field is ESP32_C3.UInt4;
   subtype TIMER_CONF_CLK_DIV_Field is ESP32_C3.UInt18;
   subtype TIMER_CONF_PAUSE_Field is ESP32_C3.Bit;
   subtype TIMER_CONF_RST_Field is ESP32_C3.Bit;
   subtype TIMER_CONF_TICK_SEL_Field is ESP32_C3.Bit;
   subtype TIMER_CONF_PARA_UP_Field is ESP32_C3.Bit;

   --  LEDC_LSTIMER%s_CONF.
   type TIMER_CONF_Register is record
      --  reg_lstimer0_duty_res.
      DUTY_RES       : TIMER_CONF_DUTY_RES_Field := 16#0#;
      --  reg_clk_div_lstimer0.
      CLK_DIV        : TIMER_CONF_CLK_DIV_Field := 16#0#;
      --  reg_lstimer0_pause.
      PAUSE          : TIMER_CONF_PAUSE_Field := 16#0#;
      --  reg_lstimer0_rst.
      RST            : TIMER_CONF_RST_Field := 16#1#;
      --  reg_tick_sel_lstimer0.
      TICK_SEL       : TIMER_CONF_TICK_SEL_Field := 16#0#;
      --  Write-only. reg_lstimer0_para_up.
      PARA_UP        : TIMER_CONF_PARA_UP_Field := 16#0#;
      --  unspecified
      Reserved_26_31 : ESP32_C3.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIMER_CONF_Register use record
      DUTY_RES       at 0 range 0 .. 3;
      CLK_DIV        at 0 range 4 .. 21;
      PAUSE          at 0 range 22 .. 22;
      RST            at 0 range 23 .. 23;
      TICK_SEL       at 0 range 24 .. 24;
      PARA_UP        at 0 range 25 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype TIMER_VALUE_CNT_Field is ESP32_C3.UInt14;

   --  LEDC_LSTIMER%s_VALUE.
   type TIMER_VALUE_Register is record
      --  Read-only. reg_lstimer0_cnt.
      CNT            : TIMER_VALUE_CNT_Field;
      --  unspecified
      Reserved_14_31 : ESP32_C3.UInt18;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TIMER_VALUE_Register use record
      CNT            at 0 range 0 .. 13;
      Reserved_14_31 at 0 range 14 .. 31;
   end record;

   subtype INT_RAW_LSTIMER0_OVF_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_LSTIMER1_OVF_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_LSTIMER2_OVF_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_LSTIMER3_OVF_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_DUTY_CHNG_END_LSCH0_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_DUTY_CHNG_END_LSCH1_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_DUTY_CHNG_END_LSCH2_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_DUTY_CHNG_END_LSCH3_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_DUTY_CHNG_END_LSCH4_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_DUTY_CHNG_END_LSCH5_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_OVF_CNT_LSCH0_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_OVF_CNT_LSCH1_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_OVF_CNT_LSCH2_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_OVF_CNT_LSCH3_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_OVF_CNT_LSCH4_INT_RAW_Field is ESP32_C3.Bit;
   subtype INT_RAW_OVF_CNT_LSCH5_INT_RAW_Field is ESP32_C3.Bit;

   --  LEDC_INT_RAW.
   type INT_RAW_Register is record
      --  reg_lstimer0_ovf_int_raw.
      LSTIMER0_OVF_INT_RAW        : INT_RAW_LSTIMER0_OVF_INT_RAW_Field :=
                                     16#0#;
      --  reg_lstimer1_ovf_int_raw.
      LSTIMER1_OVF_INT_RAW        : INT_RAW_LSTIMER1_OVF_INT_RAW_Field :=
                                     16#0#;
      --  reg_lstimer2_ovf_int_raw.
      LSTIMER2_OVF_INT_RAW        : INT_RAW_LSTIMER2_OVF_INT_RAW_Field :=
                                     16#0#;
      --  reg_lstimer3_ovf_int_raw.
      LSTIMER3_OVF_INT_RAW        : INT_RAW_LSTIMER3_OVF_INT_RAW_Field :=
                                     16#0#;
      --  reg_duty_chng_end_lsch0_int_raw.
      DUTY_CHNG_END_LSCH0_INT_RAW : INT_RAW_DUTY_CHNG_END_LSCH0_INT_RAW_Field :=
                                     16#0#;
      --  reg_duty_chng_end_lsch1_int_raw.
      DUTY_CHNG_END_LSCH1_INT_RAW : INT_RAW_DUTY_CHNG_END_LSCH1_INT_RAW_Field :=
                                     16#0#;
      --  reg_duty_chng_end_lsch2_int_raw.
      DUTY_CHNG_END_LSCH2_INT_RAW : INT_RAW_DUTY_CHNG_END_LSCH2_INT_RAW_Field :=
                                     16#0#;
      --  reg_duty_chng_end_lsch3_int_raw.
      DUTY_CHNG_END_LSCH3_INT_RAW : INT_RAW_DUTY_CHNG_END_LSCH3_INT_RAW_Field :=
                                     16#0#;
      --  reg_duty_chng_end_lsch4_int_raw.
      DUTY_CHNG_END_LSCH4_INT_RAW : INT_RAW_DUTY_CHNG_END_LSCH4_INT_RAW_Field :=
                                     16#0#;
      --  reg_duty_chng_end_lsch5_int_raw.
      DUTY_CHNG_END_LSCH5_INT_RAW : INT_RAW_DUTY_CHNG_END_LSCH5_INT_RAW_Field :=
                                     16#0#;
      --  reg_ovf_cnt_lsch0_int_raw.
      OVF_CNT_LSCH0_INT_RAW       : INT_RAW_OVF_CNT_LSCH0_INT_RAW_Field :=
                                     16#0#;
      --  reg_ovf_cnt_lsch1_int_raw.
      OVF_CNT_LSCH1_INT_RAW       : INT_RAW_OVF_CNT_LSCH1_INT_RAW_Field :=
                                     16#0#;
      --  reg_ovf_cnt_lsch2_int_raw.
      OVF_CNT_LSCH2_INT_RAW       : INT_RAW_OVF_CNT_LSCH2_INT_RAW_Field :=
                                     16#0#;
      --  reg_ovf_cnt_lsch3_int_raw.
      OVF_CNT_LSCH3_INT_RAW       : INT_RAW_OVF_CNT_LSCH3_INT_RAW_Field :=
                                     16#0#;
      --  reg_ovf_cnt_lsch4_int_raw.
      OVF_CNT_LSCH4_INT_RAW       : INT_RAW_OVF_CNT_LSCH4_INT_RAW_Field :=
                                     16#0#;
      --  reg_ovf_cnt_lsch5_int_raw.
      OVF_CNT_LSCH5_INT_RAW       : INT_RAW_OVF_CNT_LSCH5_INT_RAW_Field :=
                                     16#0#;
      --  unspecified
      Reserved_16_31              : ESP32_C3.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_RAW_Register use record
      LSTIMER0_OVF_INT_RAW        at 0 range 0 .. 0;
      LSTIMER1_OVF_INT_RAW        at 0 range 1 .. 1;
      LSTIMER2_OVF_INT_RAW        at 0 range 2 .. 2;
      LSTIMER3_OVF_INT_RAW        at 0 range 3 .. 3;
      DUTY_CHNG_END_LSCH0_INT_RAW at 0 range 4 .. 4;
      DUTY_CHNG_END_LSCH1_INT_RAW at 0 range 5 .. 5;
      DUTY_CHNG_END_LSCH2_INT_RAW at 0 range 6 .. 6;
      DUTY_CHNG_END_LSCH3_INT_RAW at 0 range 7 .. 7;
      DUTY_CHNG_END_LSCH4_INT_RAW at 0 range 8 .. 8;
      DUTY_CHNG_END_LSCH5_INT_RAW at 0 range 9 .. 9;
      OVF_CNT_LSCH0_INT_RAW       at 0 range 10 .. 10;
      OVF_CNT_LSCH1_INT_RAW       at 0 range 11 .. 11;
      OVF_CNT_LSCH2_INT_RAW       at 0 range 12 .. 12;
      OVF_CNT_LSCH3_INT_RAW       at 0 range 13 .. 13;
      OVF_CNT_LSCH4_INT_RAW       at 0 range 14 .. 14;
      OVF_CNT_LSCH5_INT_RAW       at 0 range 15 .. 15;
      Reserved_16_31              at 0 range 16 .. 31;
   end record;

   subtype INT_ST_LSTIMER0_OVF_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_LSTIMER1_OVF_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_LSTIMER2_OVF_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_LSTIMER3_OVF_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_DUTY_CHNG_END_LSCH0_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_DUTY_CHNG_END_LSCH1_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_DUTY_CHNG_END_LSCH2_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_DUTY_CHNG_END_LSCH3_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_DUTY_CHNG_END_LSCH4_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_DUTY_CHNG_END_LSCH5_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_OVF_CNT_LSCH0_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_OVF_CNT_LSCH1_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_OVF_CNT_LSCH2_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_OVF_CNT_LSCH3_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_OVF_CNT_LSCH4_INT_ST_Field is ESP32_C3.Bit;
   subtype INT_ST_OVF_CNT_LSCH5_INT_ST_Field is ESP32_C3.Bit;

   --  LEDC_INT_ST.
   type INT_ST_Register is record
      --  Read-only. reg_lstimer0_ovf_int_st.
      LSTIMER0_OVF_INT_ST        : INT_ST_LSTIMER0_OVF_INT_ST_Field;
      --  Read-only. reg_lstimer1_ovf_int_st.
      LSTIMER1_OVF_INT_ST        : INT_ST_LSTIMER1_OVF_INT_ST_Field;
      --  Read-only. reg_lstimer2_ovf_int_st.
      LSTIMER2_OVF_INT_ST        : INT_ST_LSTIMER2_OVF_INT_ST_Field;
      --  Read-only. reg_lstimer3_ovf_int_st.
      LSTIMER3_OVF_INT_ST        : INT_ST_LSTIMER3_OVF_INT_ST_Field;
      --  Read-only. reg_duty_chng_end_lsch0_int_st.
      DUTY_CHNG_END_LSCH0_INT_ST : INT_ST_DUTY_CHNG_END_LSCH0_INT_ST_Field;
      --  Read-only. reg_duty_chng_end_lsch1_int_st.
      DUTY_CHNG_END_LSCH1_INT_ST : INT_ST_DUTY_CHNG_END_LSCH1_INT_ST_Field;
      --  Read-only. reg_duty_chng_end_lsch2_int_st.
      DUTY_CHNG_END_LSCH2_INT_ST : INT_ST_DUTY_CHNG_END_LSCH2_INT_ST_Field;
      --  Read-only. reg_duty_chng_end_lsch3_int_st.
      DUTY_CHNG_END_LSCH3_INT_ST : INT_ST_DUTY_CHNG_END_LSCH3_INT_ST_Field;
      --  Read-only. reg_duty_chng_end_lsch4_int_st.
      DUTY_CHNG_END_LSCH4_INT_ST : INT_ST_DUTY_CHNG_END_LSCH4_INT_ST_Field;
      --  Read-only. reg_duty_chng_end_lsch5_int_st.
      DUTY_CHNG_END_LSCH5_INT_ST : INT_ST_DUTY_CHNG_END_LSCH5_INT_ST_Field;
      --  Read-only. reg_ovf_cnt_lsch0_int_st.
      OVF_CNT_LSCH0_INT_ST       : INT_ST_OVF_CNT_LSCH0_INT_ST_Field;
      --  Read-only. reg_ovf_cnt_lsch1_int_st.
      OVF_CNT_LSCH1_INT_ST       : INT_ST_OVF_CNT_LSCH1_INT_ST_Field;
      --  Read-only. reg_ovf_cnt_lsch2_int_st.
      OVF_CNT_LSCH2_INT_ST       : INT_ST_OVF_CNT_LSCH2_INT_ST_Field;
      --  Read-only. reg_ovf_cnt_lsch3_int_st.
      OVF_CNT_LSCH3_INT_ST       : INT_ST_OVF_CNT_LSCH3_INT_ST_Field;
      --  Read-only. reg_ovf_cnt_lsch4_int_st.
      OVF_CNT_LSCH4_INT_ST       : INT_ST_OVF_CNT_LSCH4_INT_ST_Field;
      --  Read-only. reg_ovf_cnt_lsch5_int_st.
      OVF_CNT_LSCH5_INT_ST       : INT_ST_OVF_CNT_LSCH5_INT_ST_Field;
      --  unspecified
      Reserved_16_31             : ESP32_C3.UInt16;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_ST_Register use record
      LSTIMER0_OVF_INT_ST        at 0 range 0 .. 0;
      LSTIMER1_OVF_INT_ST        at 0 range 1 .. 1;
      LSTIMER2_OVF_INT_ST        at 0 range 2 .. 2;
      LSTIMER3_OVF_INT_ST        at 0 range 3 .. 3;
      DUTY_CHNG_END_LSCH0_INT_ST at 0 range 4 .. 4;
      DUTY_CHNG_END_LSCH1_INT_ST at 0 range 5 .. 5;
      DUTY_CHNG_END_LSCH2_INT_ST at 0 range 6 .. 6;
      DUTY_CHNG_END_LSCH3_INT_ST at 0 range 7 .. 7;
      DUTY_CHNG_END_LSCH4_INT_ST at 0 range 8 .. 8;
      DUTY_CHNG_END_LSCH5_INT_ST at 0 range 9 .. 9;
      OVF_CNT_LSCH0_INT_ST       at 0 range 10 .. 10;
      OVF_CNT_LSCH1_INT_ST       at 0 range 11 .. 11;
      OVF_CNT_LSCH2_INT_ST       at 0 range 12 .. 12;
      OVF_CNT_LSCH3_INT_ST       at 0 range 13 .. 13;
      OVF_CNT_LSCH4_INT_ST       at 0 range 14 .. 14;
      OVF_CNT_LSCH5_INT_ST       at 0 range 15 .. 15;
      Reserved_16_31             at 0 range 16 .. 31;
   end record;

   subtype INT_ENA_LSTIMER0_OVF_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_LSTIMER1_OVF_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_LSTIMER2_OVF_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_LSTIMER3_OVF_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_DUTY_CHNG_END_LSCH0_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_DUTY_CHNG_END_LSCH1_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_DUTY_CHNG_END_LSCH2_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_DUTY_CHNG_END_LSCH3_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_DUTY_CHNG_END_LSCH4_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_DUTY_CHNG_END_LSCH5_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_OVF_CNT_LSCH0_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_OVF_CNT_LSCH1_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_OVF_CNT_LSCH2_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_OVF_CNT_LSCH3_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_OVF_CNT_LSCH4_INT_ENA_Field is ESP32_C3.Bit;
   subtype INT_ENA_OVF_CNT_LSCH5_INT_ENA_Field is ESP32_C3.Bit;

   --  LEDC_INT_ENA.
   type INT_ENA_Register is record
      --  reg_lstimer0_ovf_int_ena.
      LSTIMER0_OVF_INT_ENA        : INT_ENA_LSTIMER0_OVF_INT_ENA_Field :=
                                     16#0#;
      --  reg_lstimer1_ovf_int_ena.
      LSTIMER1_OVF_INT_ENA        : INT_ENA_LSTIMER1_OVF_INT_ENA_Field :=
                                     16#0#;
      --  reg_lstimer2_ovf_int_ena.
      LSTIMER2_OVF_INT_ENA        : INT_ENA_LSTIMER2_OVF_INT_ENA_Field :=
                                     16#0#;
      --  reg_lstimer3_ovf_int_ena.
      LSTIMER3_OVF_INT_ENA        : INT_ENA_LSTIMER3_OVF_INT_ENA_Field :=
                                     16#0#;
      --  reg_duty_chng_end_lsch0_int_ena.
      DUTY_CHNG_END_LSCH0_INT_ENA : INT_ENA_DUTY_CHNG_END_LSCH0_INT_ENA_Field :=
                                     16#0#;
      --  reg_duty_chng_end_lsch1_int_ena.
      DUTY_CHNG_END_LSCH1_INT_ENA : INT_ENA_DUTY_CHNG_END_LSCH1_INT_ENA_Field :=
                                     16#0#;
      --  reg_duty_chng_end_lsch2_int_ena.
      DUTY_CHNG_END_LSCH2_INT_ENA : INT_ENA_DUTY_CHNG_END_LSCH2_INT_ENA_Field :=
                                     16#0#;
      --  reg_duty_chng_end_lsch3_int_ena.
      DUTY_CHNG_END_LSCH3_INT_ENA : INT_ENA_DUTY_CHNG_END_LSCH3_INT_ENA_Field :=
                                     16#0#;
      --  reg_duty_chng_end_lsch4_int_ena.
      DUTY_CHNG_END_LSCH4_INT_ENA : INT_ENA_DUTY_CHNG_END_LSCH4_INT_ENA_Field :=
                                     16#0#;
      --  reg_duty_chng_end_lsch5_int_ena.
      DUTY_CHNG_END_LSCH5_INT_ENA : INT_ENA_DUTY_CHNG_END_LSCH5_INT_ENA_Field :=
                                     16#0#;
      --  reg_ovf_cnt_lsch0_int_ena.
      OVF_CNT_LSCH0_INT_ENA       : INT_ENA_OVF_CNT_LSCH0_INT_ENA_Field :=
                                     16#0#;
      --  reg_ovf_cnt_lsch1_int_ena.
      OVF_CNT_LSCH1_INT_ENA       : INT_ENA_OVF_CNT_LSCH1_INT_ENA_Field :=
                                     16#0#;
      --  reg_ovf_cnt_lsch2_int_ena.
      OVF_CNT_LSCH2_INT_ENA       : INT_ENA_OVF_CNT_LSCH2_INT_ENA_Field :=
                                     16#0#;
      --  reg_ovf_cnt_lsch3_int_ena.
      OVF_CNT_LSCH3_INT_ENA       : INT_ENA_OVF_CNT_LSCH3_INT_ENA_Field :=
                                     16#0#;
      --  reg_ovf_cnt_lsch4_int_ena.
      OVF_CNT_LSCH4_INT_ENA       : INT_ENA_OVF_CNT_LSCH4_INT_ENA_Field :=
                                     16#0#;
      --  reg_ovf_cnt_lsch5_int_ena.
      OVF_CNT_LSCH5_INT_ENA       : INT_ENA_OVF_CNT_LSCH5_INT_ENA_Field :=
                                     16#0#;
      --  unspecified
      Reserved_16_31              : ESP32_C3.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_ENA_Register use record
      LSTIMER0_OVF_INT_ENA        at 0 range 0 .. 0;
      LSTIMER1_OVF_INT_ENA        at 0 range 1 .. 1;
      LSTIMER2_OVF_INT_ENA        at 0 range 2 .. 2;
      LSTIMER3_OVF_INT_ENA        at 0 range 3 .. 3;
      DUTY_CHNG_END_LSCH0_INT_ENA at 0 range 4 .. 4;
      DUTY_CHNG_END_LSCH1_INT_ENA at 0 range 5 .. 5;
      DUTY_CHNG_END_LSCH2_INT_ENA at 0 range 6 .. 6;
      DUTY_CHNG_END_LSCH3_INT_ENA at 0 range 7 .. 7;
      DUTY_CHNG_END_LSCH4_INT_ENA at 0 range 8 .. 8;
      DUTY_CHNG_END_LSCH5_INT_ENA at 0 range 9 .. 9;
      OVF_CNT_LSCH0_INT_ENA       at 0 range 10 .. 10;
      OVF_CNT_LSCH1_INT_ENA       at 0 range 11 .. 11;
      OVF_CNT_LSCH2_INT_ENA       at 0 range 12 .. 12;
      OVF_CNT_LSCH3_INT_ENA       at 0 range 13 .. 13;
      OVF_CNT_LSCH4_INT_ENA       at 0 range 14 .. 14;
      OVF_CNT_LSCH5_INT_ENA       at 0 range 15 .. 15;
      Reserved_16_31              at 0 range 16 .. 31;
   end record;

   subtype INT_CLR_LSTIMER0_OVF_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_LSTIMER1_OVF_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_LSTIMER2_OVF_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_LSTIMER3_OVF_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_DUTY_CHNG_END_LSCH0_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_DUTY_CHNG_END_LSCH1_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_DUTY_CHNG_END_LSCH2_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_DUTY_CHNG_END_LSCH3_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_DUTY_CHNG_END_LSCH4_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_DUTY_CHNG_END_LSCH5_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_OVF_CNT_LSCH0_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_OVF_CNT_LSCH1_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_OVF_CNT_LSCH2_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_OVF_CNT_LSCH3_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_OVF_CNT_LSCH4_INT_CLR_Field is ESP32_C3.Bit;
   subtype INT_CLR_OVF_CNT_LSCH5_INT_CLR_Field is ESP32_C3.Bit;

   --  LEDC_INT_CLR.
   type INT_CLR_Register is record
      --  Write-only. reg_lstimer0_ovf_int_clr.
      LSTIMER0_OVF_INT_CLR        : INT_CLR_LSTIMER0_OVF_INT_CLR_Field :=
                                     16#0#;
      --  Write-only. reg_lstimer1_ovf_int_clr.
      LSTIMER1_OVF_INT_CLR        : INT_CLR_LSTIMER1_OVF_INT_CLR_Field :=
                                     16#0#;
      --  Write-only. reg_lstimer2_ovf_int_clr.
      LSTIMER2_OVF_INT_CLR        : INT_CLR_LSTIMER2_OVF_INT_CLR_Field :=
                                     16#0#;
      --  Write-only. reg_lstimer3_ovf_int_clr.
      LSTIMER3_OVF_INT_CLR        : INT_CLR_LSTIMER3_OVF_INT_CLR_Field :=
                                     16#0#;
      --  Write-only. reg_duty_chng_end_lsch0_int_clr.
      DUTY_CHNG_END_LSCH0_INT_CLR : INT_CLR_DUTY_CHNG_END_LSCH0_INT_CLR_Field :=
                                     16#0#;
      --  Write-only. reg_duty_chng_end_lsch1_int_clr.
      DUTY_CHNG_END_LSCH1_INT_CLR : INT_CLR_DUTY_CHNG_END_LSCH1_INT_CLR_Field :=
                                     16#0#;
      --  Write-only. reg_duty_chng_end_lsch2_int_clr.
      DUTY_CHNG_END_LSCH2_INT_CLR : INT_CLR_DUTY_CHNG_END_LSCH2_INT_CLR_Field :=
                                     16#0#;
      --  Write-only. reg_duty_chng_end_lsch3_int_clr.
      DUTY_CHNG_END_LSCH3_INT_CLR : INT_CLR_DUTY_CHNG_END_LSCH3_INT_CLR_Field :=
                                     16#0#;
      --  Write-only. reg_duty_chng_end_lsch4_int_clr.
      DUTY_CHNG_END_LSCH4_INT_CLR : INT_CLR_DUTY_CHNG_END_LSCH4_INT_CLR_Field :=
                                     16#0#;
      --  Write-only. reg_duty_chng_end_lsch5_int_clr.
      DUTY_CHNG_END_LSCH5_INT_CLR : INT_CLR_DUTY_CHNG_END_LSCH5_INT_CLR_Field :=
                                     16#0#;
      --  Write-only. reg_ovf_cnt_lsch0_int_clr.
      OVF_CNT_LSCH0_INT_CLR       : INT_CLR_OVF_CNT_LSCH0_INT_CLR_Field :=
                                     16#0#;
      --  Write-only. reg_ovf_cnt_lsch1_int_clr.
      OVF_CNT_LSCH1_INT_CLR       : INT_CLR_OVF_CNT_LSCH1_INT_CLR_Field :=
                                     16#0#;
      --  Write-only. reg_ovf_cnt_lsch2_int_clr.
      OVF_CNT_LSCH2_INT_CLR       : INT_CLR_OVF_CNT_LSCH2_INT_CLR_Field :=
                                     16#0#;
      --  Write-only. reg_ovf_cnt_lsch3_int_clr.
      OVF_CNT_LSCH3_INT_CLR       : INT_CLR_OVF_CNT_LSCH3_INT_CLR_Field :=
                                     16#0#;
      --  Write-only. reg_ovf_cnt_lsch4_int_clr.
      OVF_CNT_LSCH4_INT_CLR       : INT_CLR_OVF_CNT_LSCH4_INT_CLR_Field :=
                                     16#0#;
      --  Write-only. reg_ovf_cnt_lsch5_int_clr.
      OVF_CNT_LSCH5_INT_CLR       : INT_CLR_OVF_CNT_LSCH5_INT_CLR_Field :=
                                     16#0#;
      --  unspecified
      Reserved_16_31              : ESP32_C3.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_CLR_Register use record
      LSTIMER0_OVF_INT_CLR        at 0 range 0 .. 0;
      LSTIMER1_OVF_INT_CLR        at 0 range 1 .. 1;
      LSTIMER2_OVF_INT_CLR        at 0 range 2 .. 2;
      LSTIMER3_OVF_INT_CLR        at 0 range 3 .. 3;
      DUTY_CHNG_END_LSCH0_INT_CLR at 0 range 4 .. 4;
      DUTY_CHNG_END_LSCH1_INT_CLR at 0 range 5 .. 5;
      DUTY_CHNG_END_LSCH2_INT_CLR at 0 range 6 .. 6;
      DUTY_CHNG_END_LSCH3_INT_CLR at 0 range 7 .. 7;
      DUTY_CHNG_END_LSCH4_INT_CLR at 0 range 8 .. 8;
      DUTY_CHNG_END_LSCH5_INT_CLR at 0 range 9 .. 9;
      OVF_CNT_LSCH0_INT_CLR       at 0 range 10 .. 10;
      OVF_CNT_LSCH1_INT_CLR       at 0 range 11 .. 11;
      OVF_CNT_LSCH2_INT_CLR       at 0 range 12 .. 12;
      OVF_CNT_LSCH3_INT_CLR       at 0 range 13 .. 13;
      OVF_CNT_LSCH4_INT_CLR       at 0 range 14 .. 14;
      OVF_CNT_LSCH5_INT_CLR       at 0 range 15 .. 15;
      Reserved_16_31              at 0 range 16 .. 31;
   end record;

   subtype CONF_APB_CLK_SEL_Field is ESP32_C3.UInt2;
   subtype CONF_CLK_EN_Field is ESP32_C3.Bit;

   --  LEDC_CONF.
   type CONF_Register is record
      --  reg_apb_clk_sel.
      APB_CLK_SEL   : CONF_APB_CLK_SEL_Field := 16#0#;
      --  unspecified
      Reserved_2_30 : ESP32_C3.UInt29 := 16#0#;
      --  reg_clk_en.
      CLK_EN        : CONF_CLK_EN_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CONF_Register use record
      APB_CLK_SEL   at 0 range 0 .. 1;
      Reserved_2_30 at 0 range 2 .. 30;
      CLK_EN        at 0 range 31 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  LED Control PWM (Pulse Width Modulation)
   type LEDC_Peripheral is record
      --  LEDC_LSCH%s_CONF%s.
      CH_CONF00    : aliased CH_CONF_Register;
      --  LEDC_LSCH%s_HPOINT.
      CH_HPOINT0   : aliased CH_HPOINT_Register;
      --  LEDC_LSCH%s_DUTY.
      CH_DUTY0     : aliased CH_DUTY_Register;
      --  LEDC_LSCH%s_CONF1.
      CH_CONF10    : aliased CH_CONF_Register_1;
      --  LEDC_LSCH%s_DUTY_R.
      CH_DUTY_R0   : aliased CH_DUTY_R_Register;
      --  LEDC_LSCH%s_CONF%s.
      CH_CONF01    : aliased CH_CONF_Register;
      --  LEDC_LSCH%s_HPOINT.
      CH_HPOINT1   : aliased CH_HPOINT_Register;
      --  LEDC_LSCH%s_DUTY.
      CH_DUTY1     : aliased CH_DUTY_Register;
      --  LEDC_LSCH%s_CONF1.
      CH_CONF11    : aliased CH_CONF_Register_1;
      --  LEDC_LSCH%s_DUTY_R.
      CH_DUTY_R1   : aliased CH_DUTY_R_Register;
      --  LEDC_LSCH%s_CONF%s.
      CH_CONF02    : aliased CH_CONF_Register;
      --  LEDC_LSCH%s_HPOINT.
      CH_HPOINT2   : aliased CH_HPOINT_Register;
      --  LEDC_LSCH%s_DUTY.
      CH_DUTY2     : aliased CH_DUTY_Register;
      --  LEDC_LSCH%s_CONF1.
      CH_CONF12    : aliased CH_CONF_Register_1;
      --  LEDC_LSCH%s_DUTY_R.
      CH_DUTY_R2   : aliased CH_DUTY_R_Register;
      --  LEDC_LSCH%s_CONF%s.
      CH_CONF03    : aliased CH_CONF_Register;
      --  LEDC_LSCH%s_HPOINT.
      CH_HPOINT3   : aliased CH_HPOINT_Register;
      --  LEDC_LSCH%s_DUTY.
      CH_DUTY3     : aliased CH_DUTY_Register;
      --  LEDC_LSCH%s_CONF1.
      CH_CONF13    : aliased CH_CONF_Register_1;
      --  LEDC_LSCH%s_DUTY_R.
      CH_DUTY_R3   : aliased CH_DUTY_R_Register;
      --  LEDC_LSCH%s_CONF%s.
      CH_CONF04    : aliased CH_CONF_Register;
      --  LEDC_LSCH%s_HPOINT.
      CH_HPOINT4   : aliased CH_HPOINT_Register;
      --  LEDC_LSCH%s_DUTY.
      CH_DUTY4     : aliased CH_DUTY_Register;
      --  LEDC_LSCH%s_CONF1.
      CH_CONF14    : aliased CH_CONF_Register_1;
      --  LEDC_LSCH%s_DUTY_R.
      CH_DUTY_R4   : aliased CH_DUTY_R_Register;
      --  LEDC_LSCH%s_CONF%s.
      CH_CONF05    : aliased CH_CONF_Register;
      --  LEDC_LSCH%s_HPOINT.
      CH_HPOINT5   : aliased CH_HPOINT_Register;
      --  LEDC_LSCH%s_DUTY.
      CH_DUTY5     : aliased CH_DUTY_Register;
      --  LEDC_LSCH%s_CONF1.
      CH_CONF15    : aliased CH_CONF_Register_1;
      --  LEDC_LSCH%s_DUTY_R.
      CH_DUTY_R5   : aliased CH_DUTY_R_Register;
      --  LEDC_LSTIMER%s_CONF.
      TIMER_CONF0  : aliased TIMER_CONF_Register;
      --  LEDC_LSTIMER%s_VALUE.
      TIMER_VALUE0 : aliased TIMER_VALUE_Register;
      --  LEDC_LSTIMER%s_CONF.
      TIMER_CONF1  : aliased TIMER_CONF_Register;
      --  LEDC_LSTIMER%s_VALUE.
      TIMER_VALUE1 : aliased TIMER_VALUE_Register;
      --  LEDC_LSTIMER%s_CONF.
      TIMER_CONF2  : aliased TIMER_CONF_Register;
      --  LEDC_LSTIMER%s_VALUE.
      TIMER_VALUE2 : aliased TIMER_VALUE_Register;
      --  LEDC_LSTIMER%s_CONF.
      TIMER_CONF3  : aliased TIMER_CONF_Register;
      --  LEDC_LSTIMER%s_VALUE.
      TIMER_VALUE3 : aliased TIMER_VALUE_Register;
      --  LEDC_INT_RAW.
      INT_RAW      : aliased INT_RAW_Register;
      --  LEDC_INT_ST.
      INT_ST       : aliased INT_ST_Register;
      --  LEDC_INT_ENA.
      INT_ENA      : aliased INT_ENA_Register;
      --  LEDC_INT_CLR.
      INT_CLR      : aliased INT_CLR_Register;
      --  LEDC_CONF.
      CONF         : aliased CONF_Register;
      --  LEDC_DATE.
      DATE         : aliased ESP32_C3.UInt32;
   end record
     with Volatile;

   for LEDC_Peripheral use record
      CH_CONF00    at 16#0# range 0 .. 31;
      CH_HPOINT0   at 16#4# range 0 .. 31;
      CH_DUTY0     at 16#8# range 0 .. 31;
      CH_CONF10    at 16#C# range 0 .. 31;
      CH_DUTY_R0   at 16#10# range 0 .. 31;
      CH_CONF01    at 16#14# range 0 .. 31;
      CH_HPOINT1   at 16#18# range 0 .. 31;
      CH_DUTY1     at 16#1C# range 0 .. 31;
      CH_CONF11    at 16#20# range 0 .. 31;
      CH_DUTY_R1   at 16#24# range 0 .. 31;
      CH_CONF02    at 16#28# range 0 .. 31;
      CH_HPOINT2   at 16#2C# range 0 .. 31;
      CH_DUTY2     at 16#30# range 0 .. 31;
      CH_CONF12    at 16#34# range 0 .. 31;
      CH_DUTY_R2   at 16#38# range 0 .. 31;
      CH_CONF03    at 16#3C# range 0 .. 31;
      CH_HPOINT3   at 16#40# range 0 .. 31;
      CH_DUTY3     at 16#44# range 0 .. 31;
      CH_CONF13    at 16#48# range 0 .. 31;
      CH_DUTY_R3   at 16#4C# range 0 .. 31;
      CH_CONF04    at 16#50# range 0 .. 31;
      CH_HPOINT4   at 16#54# range 0 .. 31;
      CH_DUTY4     at 16#58# range 0 .. 31;
      CH_CONF14    at 16#5C# range 0 .. 31;
      CH_DUTY_R4   at 16#60# range 0 .. 31;
      CH_CONF05    at 16#64# range 0 .. 31;
      CH_HPOINT5   at 16#68# range 0 .. 31;
      CH_DUTY5     at 16#6C# range 0 .. 31;
      CH_CONF15    at 16#70# range 0 .. 31;
      CH_DUTY_R5   at 16#74# range 0 .. 31;
      TIMER_CONF0  at 16#A0# range 0 .. 31;
      TIMER_VALUE0 at 16#A4# range 0 .. 31;
      TIMER_CONF1  at 16#A8# range 0 .. 31;
      TIMER_VALUE1 at 16#AC# range 0 .. 31;
      TIMER_CONF2  at 16#B0# range 0 .. 31;
      TIMER_VALUE2 at 16#B4# range 0 .. 31;
      TIMER_CONF3  at 16#B8# range 0 .. 31;
      TIMER_VALUE3 at 16#BC# range 0 .. 31;
      INT_RAW      at 16#C0# range 0 .. 31;
      INT_ST       at 16#C4# range 0 .. 31;
      INT_ENA      at 16#C8# range 0 .. 31;
      INT_CLR      at 16#CC# range 0 .. 31;
      CONF         at 16#D0# range 0 .. 31;
      DATE         at 16#FC# range 0 .. 31;
   end record;

   --  LED Control PWM (Pulse Width Modulation)
   LEDC_Periph : aliased LEDC_Peripheral
     with Import, Address => LEDC_Base;

end ESP32_C3.LEDC;
