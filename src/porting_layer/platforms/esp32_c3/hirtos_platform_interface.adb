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
with ESP32_C3.INTERRUPT_CORE0;
with ESP32_C3.SYSTIMER;
with ESP32_C3.ESP_SYSTEM;
with ESP32_C3.GPIO;
with HiRTOS_Cpu_Arch_Interface.Interrupts;
with HiRTOS_Cpu_Arch_Parameters;
with HiRTOS_Cpu_Arch_Interface_Private;
with HiRTOS_Low_Level_Debug_Interface;
with Interfaces;
with System.Storage_Elements;

package body HiRTOS_Platform_Interface
   with SPARK_Mode => Off
is
   use type ESP32_C3.UInt32;
   use type ESP32_C3.Bit;
   use System.Storage_Elements;
   use HiRTOS_Cpu_Arch_Interface_Private;

   procedure PMS_IBUS_VIO_Interrupt_Handler (Arg : System.Address)
      with Pre => Cpu_In_Privileged_Mode;

   procedure PMS_DBUS_VIO_Interrupt_Handler (Arg : System.Address)
      with Pre => Cpu_In_Privileged_Mode;

   procedure PMS_PERI_VIO_Interrupt_Handler (Arg : System.Address)
      with Pre => Cpu_In_Privileged_Mode;

   procedure Initialize_Platform is
      use ESP32_C3.ESP_SYSTEM;
      use ESP32_C3.GPIO;

      procedure Initialize_PMS is
         use ESP32_C3.SENSITIVE;
         PRIVILEGE_MODE_SEL_Value : PRIVILEGE_MODE_SEL_Register;
         IRAM_PMS_CONSTRAIN_Value : CORE_X_IRAM0_PMS_CONSTRAIN_1_Register;
         DRAM_PMS_CONSTRAIN_Value : CORE_X_DRAM0_PMS_CONSTRAIN_1_Register;
      begin
         --
         --  Enable privilege mode switch using the CPU's MSTATUS instead of the ESP32-C3 World controller:
         --
         PRIVILEGE_MODE_SEL_Value := SENSITIVE_Periph.PRIVILEGE_MODE_SEL;
         PRIVILEGE_MODE_SEL_Value.PRIVILEGE_MODE_SEL := 1;
         SENSITIVE_Periph.PRIVILEGE_MODE_SEL := PRIVILEGE_MODE_SEL_Value;

         --
         --   Enable unprivileged access to SRAM in the PMS:
         --
         IRAM_PMS_CONSTRAIN_Value := SENSITIVE_Periph.CORE_X_IRAM0_PMS_CONSTRAIN_1;
         IRAM_PMS_CONSTRAIN_Value.CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 := 2#111#;
         IRAM_PMS_CONSTRAIN_Value.CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 := 2#111#;
         IRAM_PMS_CONSTRAIN_Value.CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 := 2#111#;
         IRAM_PMS_CONSTRAIN_Value.CORE_X_IRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 := 2#111#;
         SENSITIVE_Periph.CORE_X_IRAM0_PMS_CONSTRAIN_1 := IRAM_PMS_CONSTRAIN_Value;

         DRAM_PMS_CONSTRAIN_Value := SENSITIVE_Periph.CORE_X_DRAM0_PMS_CONSTRAIN_1;
         DRAM_PMS_CONSTRAIN_Value.CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_0 := 2#11#;
         DRAM_PMS_CONSTRAIN_Value.CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_1 := 2#11#;
         DRAM_PMS_CONSTRAIN_Value.CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_2 := 2#11#;
         DRAM_PMS_CONSTRAIN_Value.CORE_X_DRAM0_PMS_CONSTRAIN_SRAM_WORLD_1_PMS_3 := 2#11#;
         SENSITIVE_Periph.CORE_X_DRAM0_PMS_CONSTRAIN_1 := DRAM_PMS_CONSTRAIN_Value;
      end Initialize_PMS;

      SYSCLK_CONF_Value : SYSCLK_CONF_Register;
      CPU_PER_CONF_Value : CPU_PER_CONF_Register;
   begin
      --
      --  Configure CPU clock to the highest (CPU_CLK = 320MHz / 2 = 160 MHz):
      --
      SYSCLK_CONF_Value := SYSTEM_Periph.SYSCLK_CONF;
      SYSCLK_CONF_Value.SOC_CLK_SEL := 1; --  PLL_CLK
      SYSTEM_Periph.SYSCLK_CONF := SYSCLK_CONF_Value;
      CPU_PER_CONF_Value := SYSTEM_Periph.CPU_PER_CONF;
      CPU_PER_CONF_Value.PLL_FREQ_SEL := 0; --  320 MHz PLL (1 is 480 MHz PLL)
      CPU_PER_CONF_Value.CPUPERIOD_SEL := 1;
      SYSTEM_Periph.CPU_PER_CONF := CPU_PER_CONF_Value;

      Initialize_PMS;

      --  Enable GPIO clock:
      GPIO_Periph.CLOCK_GATE := (CLK_EN => 1, others => <>);
   end Initialize_Platform;

   procedure Initialize_Interrupt_Controller is
      use ESP32_C3.INTERRUPT_CORE0;
      WCL_Core_0_MTVEC_BASE_REG_ADDR : constant System.Address := To_Address (16#600d_0000#);
      WCL_Core_0_MTVEC_BASE_REG : Integer_Address with Address => WCL_Core_0_MTVEC_BASE_REG_ADDR;
   begin
      --  Ensure that WCL_Core_0_MTVEC_BASE_REG matches the MTVEC value
      WCL_Core_0_MTVEC_BASE_REG :=
         Integer_Address (HiRTOS_Cpu_Arch_Interface_Private.Get_MTVEC.Encoded_Base_Address) *
         HiRTOS_Cpu_Arch_Parameters.Call_Instruction_Size_In_Bytes;

      --  Enable interrupt controller:
      INTERRUPT_CORE0_Periph.CLOCK_GATE := (REG_CLK_EN => 1, others => <>);

      --  Disable all interrupts:
      INTERRUPT_CORE0_Periph.CPU_INT_ENABLE := 0;

      --  Allow all interrupt priorities to fire:
      INTERRUPT_CORE0_Periph.CPU_INT_THRESH :=
         (CPU_INT_THRESH => ESP32_C3.UInt4 (Lowest_Interrupt_Priority), others => <>);
   end Initialize_Interrupt_Controller;

   procedure Configure_Interrupt
     (Interrupt_Id                  : Valid_Interrupt_Id_Type;
      Priority                      : Interrupt_Priority_Type;
      Trigger_Mode                  : Interrupt_Trigger_Mode_Type) is
      use ESP32_C3.INTERRUPT_CORE0;
      use HiRTOS_Cpu_Arch_Interface.Interrupts;
      CPU_INT_TYPE_Value : ESP32_C3.UInt32;
   begin
      --
      --  Map peripheral external interrupt source to interrupt controller interrupt:
      --
      case Interrupt_Id is
         when UART0_Interrupt_Id =>
            INTERRUPT_CORE0_Periph.UART_INTR_MAP :=
              (UART_INTR_MAP => ESP32_C3.UInt5 (Interrupt_Id), others => <>);
         when UART1_Interrupt_Id =>
            INTERRUPT_CORE0_Periph.UART1_INTR_MAP :=
              (UART1_INTR_MAP => ESP32_C3.UInt5 (Interrupt_Id), others => <>);
         when System_Timer_Target0_Interrupt_Id =>
            INTERRUPT_CORE0_Periph.SYSTIMER_TARGET0_INT_MAP :=
              (SYSTIMER_TARGET0_INT_MAP => ESP32_C3.UInt5 (Interrupt_Id), others => <>);
         when System_Timer_Target1_Interrupt_Id =>
            INTERRUPT_CORE0_Periph.SYSTIMER_TARGET1_INT_MAP :=
              (SYSTIMER_TARGET1_INT_MAP => ESP32_C3.UInt5 (Interrupt_Id), others => <>);
         when System_Timer_Target2_Interrupt_Id =>
            INTERRUPT_CORE0_Periph.SYSTIMER_TARGET2_INT_MAP :=
              (SYSTIMER_TARGET2_INT_MAP => ESP32_C3.UInt5 (Interrupt_Id), others => <>);
         when Assist_Debug_Interrupt_Id =>
            INTERRUPT_CORE0_Periph.ASSIST_DEBUG_INTR_MAP :=
              (ASSIST_DEBUG_INTR_MAP => ESP32_C3.UInt5 (Interrupt_Id), others => <>);
         when PMS_DMA_VIO_Interrupt_Id =>
            INTERRUPT_CORE0_Periph.DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_MAP :=
              (DMA_APBPERI_PMS_MONITOR_VIOLATE_INTR_MAP => ESP32_C3.UInt5 (Interrupt_Id), others => <>);
         when PMS_IBUS_VIO_Interrupt_Id =>
            INTERRUPT_CORE0_Periph.CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_MAP :=
              (CORE_0_IRAM0_PMS_MONITOR_VIOLATE_INTR_MAP => ESP32_C3.UInt5 (Interrupt_Id), others => <>);
         when PMS_DBUS_VIO_Interrupt_Id =>
            INTERRUPT_CORE0_Periph.CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_MAP :=
              (CORE_0_DRAM0_PMS_MONITOR_VIOLATE_INTR_MAP => ESP32_C3.UInt5 (Interrupt_Id), others => <>);
         when PMS_PERI_VIO_Interrupt_Id =>
            INTERRUPT_CORE0_Periph.CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_MAP :=
              (CORE_0_PIF_PMS_MONITOR_VIOLATE_INTR_MAP => ESP32_C3.UInt5 (Interrupt_Id), others => <>);
         when PMS_PERI_VIO_Size_Interrupt_Id =>
            INTERRUPT_CORE0_Periph.CORE_0_PIF_PMS_MONITOR_VIOLATE_SIZE_INTR_MAP :=
              (CORE_0_PIF_PMS_MONITOR_VIOLATE_SIZE_INTR_MAP => ESP32_C3.UInt5 (Interrupt_Id), others => <>);
         when others =>
            pragma Assert (False);
      end case;

      --
      --  Configure interrupt trigger mode:
      --
      CPU_INT_TYPE_Value := INTERRUPT_CORE0_Periph.CPU_INT_TYPE;
      if Trigger_Mode = Interrupt_Edge_Triggered then
         CPU_INT_TYPE_Value := @ or ESP32_C3.UInt32 (Bit_Mask (Bit_Index_Type (Interrupt_Id)));
      else
         CPU_INT_TYPE_Value := @ and not ESP32_C3.UInt32 (Bit_Mask (Bit_Index_Type (Interrupt_Id)));
      end if;

      INTERRUPT_CORE0_Periph.CPU_INT_TYPE := CPU_INT_TYPE_Value;

      --
      --  Configure interrupt priority:
      --
      INTERRUPT_CORE0_Periph.CPU_INT_PRI_Array (Cpu_Interrupt_Id_Type (Interrupt_Id)) :=
         (CPU_PRI_MAP => ESP32_C3.UInt4 (Priority), others => <>);

      --
      --  NOTE: The interrupt starts to fire on the CPU only after Enable_Interrupt()
      --  is called.
   end Configure_Interrupt;

   procedure Enable_Interrupt (Interrupt_Id : Valid_Interrupt_Id_Type) is
      use ESP32_C3.INTERRUPT_CORE0;
      CPU_INT_ENABLE_Value : ESP32_C3.UInt32;
   begin
      --  Enable interrupt in the interrupt controller:
      CPU_INT_ENABLE_Value := INTERRUPT_CORE0_Periph.CPU_INT_ENABLE;
      CPU_INT_ENABLE_Value := @ or ESP32_C3.UInt32 (Bit_Mask (Bit_Index_Type (Interrupt_Id)));
      INTERRUPT_CORE0_Periph.CPU_INT_ENABLE := CPU_INT_ENABLE_Value;
   end Enable_Interrupt;

   procedure Disable_Interrupt (Interrupt_Id : Valid_Interrupt_Id_Type) is
      use ESP32_C3.INTERRUPT_CORE0;
      CPU_INT_ENABLE_Value : ESP32_C3.UInt32;
   begin
      CPU_INT_ENABLE_Value := INTERRUPT_CORE0_Periph.CPU_INT_ENABLE;
      CPU_INT_ENABLE_Value := @ and not ESP32_C3.UInt32 (Bit_Mask (Bit_Index_Type (Interrupt_Id)));
      INTERRUPT_CORE0_Periph.CPU_INT_ENABLE := CPU_INT_ENABLE_Value;
   end Disable_Interrupt;

   function Begin_Interrupt_Processing (Interrupt_Id : Valid_Interrupt_Id_Type with Unreferenced;
                                        Interrupt_Priority : Interrupt_Priority_Type)
      return Interrupt_Priority_Type is
      Old_Highest_Interrupt_Priority_Disabled : Interrupt_Priority_Type;
   begin
      Old_Highest_Interrupt_Priority_Disabled := Get_Highest_Interrupt_Priority_Disabled;

      --  Raise priority threshold to be above the given interrupt's current priority:
      if Interrupt_Priority < Interrupt_Priority_Type'Last then
         Set_Highest_Interrupt_Priority_Disabled (Interrupt_Priority + 1);
      else
         Set_Highest_Interrupt_Priority_Disabled (Interrupt_Priority);
      end if;

      Memory_Barrier;
      return Old_Highest_Interrupt_Priority_Disabled;
   end Begin_Interrupt_Processing;

   procedure End_Interrupt_Processing (Interrupt_Id : Valid_Interrupt_Id_Type;
                                       Old_Highest_Interrupt_Priority_Disabled : Interrupt_Priority_Type) is
      use ESP32_C3.INTERRUPT_CORE0;
   begin
      --  Clear interrupt in the interrupt controller:
      INTERRUPT_CORE0_Periph.CPU_INT_CLEAR := ESP32_C3.UInt32 (Bit_Mask (Bit_Index_Type (Interrupt_Id)));
      Memory_Barrier;

      Set_Highest_Interrupt_Priority_Disabled (Old_Highest_Interrupt_Priority_Disabled);
      Memory_Barrier;
   end End_Interrupt_Processing;

   function Get_Highest_Interrupt_Priority_Disabled return Interrupt_Priority_Type is
      use ESP32_C3.INTERRUPT_CORE0;
   begin
      return Interrupt_Priority_Type (INTERRUPT_CORE0_Periph.CPU_INT_THRESH.CPU_INT_THRESH);
   end Get_Highest_Interrupt_Priority_Disabled;

   procedure Set_Highest_Interrupt_Priority_Disabled (Priority : Interrupt_Priority_Type)
   is
      use ESP32_C3.INTERRUPT_CORE0;
      CPU_INT_THRESH_Value : CPU_INT_THRESH_Register;
   begin
      CPU_INT_THRESH_Value := INTERRUPT_CORE0_Periph.CPU_INT_THRESH;
      CPU_INT_THRESH_Value.CPU_INT_THRESH := ESP32_C3.UInt4 (Priority);
      INTERRUPT_CORE0_Periph.CPU_INT_THRESH := CPU_INT_THRESH_Value;
   end Set_Highest_Interrupt_Priority_Disabled;

   function Is_Interrupt_Pending (Interrupt_Id : Valid_Interrupt_Id_Type) return Boolean
   is
      use ESP32_C3.INTERRUPT_CORE0;
   begin
      return (INTERRUPT_CORE0_Periph.CPU_INT_EIP_STATUS and
              ESP32_C3.UInt32 (Bit_Mask (Bit_Index_Type (Interrupt_Id)))) /= 0;
   end Is_Interrupt_Pending;

   function Get_Interrupt_Priority (Interrupt_Id : Valid_Interrupt_Id_Type)
      return Interrupt_Priority_Type
   is
      use ESP32_C3.INTERRUPT_CORE0;
      CPU_INT_PRI_Value : constant CPU_INT_PRI_n_Register :=
         INTERRUPT_CORE0_Periph.CPU_INT_PRI_Array (Cpu_Interrupt_Id_Type (Interrupt_Id));
   begin
      return Interrupt_Priority_Type (CPU_INT_PRI_Value.CPU_PRI_MAP);
   end Get_Interrupt_Priority;

   procedure Initialize_System_Timer (System_Timer_Counter : System_Timer_Counter_Type) is
      use ESP32_C3.SYSTIMER;
      use ESP32_C3.ESP_SYSTEM;
      CONF_Value : CONF_Register;
      PERIP_CLK_EN0_Value : PERIP_CLK_EN0_Register;
      PERIP_RST_EN0_Value : PERIP_RST_EN0_Register;
   begin
      --  Enable input clock for Systimer block:
      PERIP_CLK_EN0_Value := SYSTEM_Periph.PERIP_CLK_EN0;
      PERIP_CLK_EN0_Value.SYSTIMER_CLK_EN := 1;
      SYSTEM_Periph.PERIP_CLK_EN0 := PERIP_CLK_EN0_Value;
      Memory_Barrier;

      --  Reset Systimer block:
      PERIP_RST_EN0_Value := SYSTEM_Periph.PERIP_RST_EN0;
      PERIP_RST_EN0_Value.SYSTIMER_RST := 1;
      SYSTEM_Periph.PERIP_RST_EN0 := PERIP_RST_EN0_Value;
      Memory_Barrier;
      PERIP_RST_EN0_Value.SYSTIMER_RST := 0;
      SYSTEM_Periph.PERIP_RST_EN0 := PERIP_RST_EN0_Value;
      Memory_Barrier;

      CONF_Value := SYSTIMER_Periph.CONF;
      case System_Timer_Counter is
         when System_Timer_Counter0 =>
            --  Enable Unit0 work, so that Unit0's counter starts counting:
            CONF_Value.TIMER_UNIT0_WORK_EN := 1;
            CONF_Value.TIMER_UNIT0_CORE0_STALL_EN := 0;

         when System_Timer_Counter1 =>
            --  Enable Unit1 work, so that Unit1's counter starts counting:
            CONF_Value.TIMER_UNIT1_WORK_EN := 1;
            CONF_Value.TIMER_UNIT1_CORE0_STALL_EN := 0;
      end case;

      CONF_Value.CLK_EN := 1;
      SYSTIMER_Periph.CONF := CONF_Value;
   end Initialize_System_Timer;

   function Get_System_Timer_Timestamp_Cycles (System_Timer_Counter : System_Timer_Counter_Type)
      return Timer_Timestamp_Cycles_Type
   is
      use ESP32_C3.SYSTIMER;
      use type Interfaces.Unsigned_64;
      UNIT0_OP_Value : UNIT0_OP_Register;
      UNIT0_VALUE_HI_Value : UNIT0_VALUE_HI_Register;
      UNITx_VALUE_LO_Value : ESP32_C3.UInt32;
      UNIT1_OP_Value : UNIT1_OP_Register;
      UNIT1_VALUE_HI_Value : UNIT1_VALUE_HI_Register;
   begin
      case System_Timer_Counter is
         when System_Timer_Counter0 =>
            SYSTIMER_Periph.UNIT0_OP :=
               (TIMER_UNIT0_UPDATE => 1, TIMER_UNIT0_VALUE_VALID => 0, others => <>);
            loop
               UNIT0_OP_Value := SYSTIMER_Periph.UNIT0_OP;
               exit when UNIT0_OP_Value.TIMER_UNIT0_VALUE_VALID = 1;
            end loop;

            Memory_Barrier;
            loop
               UNITx_VALUE_LO_Value := SYSTIMER_Periph.UNIT0_VALUE_LO;
               UNIT0_VALUE_HI_Value := SYSTIMER_Periph.UNIT0_VALUE_HI;
               exit when SYSTIMER_Periph.UNIT0_VALUE_LO = UNITx_VALUE_LO_Value;
            end loop;

            return Timer_Timestamp_Cycles_Type (
                     Interfaces.Shift_Left (Interfaces.Unsigned_64 (UNIT0_VALUE_HI_Value.TIMER_UNIT0_VALUE_HI), 32) or
                     Interfaces.Unsigned_64 (UNITx_VALUE_LO_Value));

         when System_Timer_Counter1 =>
            SYSTIMER_Periph.UNIT1_OP :=
               (TIMER_UNIT1_UPDATE => 1, TIMER_UNIT1_VALUE_VALID => 0, others => <>);
            loop
               UNIT1_OP_Value := SYSTIMER_Periph.UNIT1_OP;
               exit when UNIT1_OP_Value.TIMER_UNIT1_VALUE_VALID = 1;
            end loop;

            Memory_Barrier;
            loop
               UNITx_VALUE_LO_Value := SYSTIMER_Periph.UNIT1_VALUE_LO;
               UNIT1_VALUE_HI_Value := SYSTIMER_Periph.UNIT1_VALUE_HI;
               exit when SYSTIMER_Periph.UNIT1_VALUE_LO = UNITx_VALUE_LO_Value;
            end loop;

         return Timer_Timestamp_Cycles_Type (
                  Interfaces.Shift_Left (Interfaces.Unsigned_64 (UNIT1_VALUE_HI_Value.TIMER_UNIT1_VALUE_HI), 32) or
                  Interfaces.Unsigned_64 (UNITx_VALUE_LO_Value));
      end case;
   end Get_System_Timer_Timestamp_Cycles;

   procedure Start_System_Timer_Single_Shot_Interrupt (System_Timer_Counter : System_Timer_Counter_Type;
                                                       Expiration_Time_Us : HiRTOS.Relative_Time_Us_Type) is
      use ESP32_C3.SYSTIMER;
      use type Interfaces.Unsigned_64;
      CONF_Value : CONF_Register;
      TARGET0_CONF_Value : TARGET0_CONF_Register;
      TARGET1_CONF_Value : TARGET1_CONF_Register;
      INT_ENA_Value : INT_ENA_Register;
      Expiration_Timestamp_Cycles : Timer_Timestamp_Cycles_Type;
   begin
      case System_Timer_Counter is
         when System_Timer_Counter0 =>
            --  Disable comparator COMP0:
            CONF_Value := SYSTIMER_Periph.CONF;
            CONF_Value.TARGET0_WORK_EN := 0;
            SYSTIMER_Periph.CONF := CONF_Value;

            --  Select UNIT0 for COMP0
            TARGET0_CONF_Value := SYSTIMER_Periph.TARGET0_CONF;
            TARGET0_CONF_Value.TARGET0_TIMER_UNIT_SEL := 0;
            SYSTIMER_Periph.TARGET0_CONF := TARGET0_CONF_Value;

            Expiration_Timestamp_Cycles :=
               Get_System_Timer_Timestamp_Cycles (System_Timer_Counter) +
               Timer_Timestamp_Cycles_Type (Expiration_Time_Us *
                                          HiRTOS_Cpu_Arch_Interface.Tick_Timer.Timer_Counter_Cycles_Per_Us);

            --  Select single-shot mode
            TARGET0_CONF_Value := SYSTIMER_Periph.TARGET0_CONF;
            TARGET0_CONF_Value.TARGET0_PERIOD_MODE := 0;
            SYSTIMER_Periph.TARGET0_CONF := TARGET0_CONF_Value;

            --  Set target expiration time:
            SYSTIMER_Periph.TARGET0_LO := ESP32_C3.UInt32 (
               Interfaces.Unsigned_64 (Expiration_Timestamp_Cycles) and
               Interfaces.Unsigned_64 (Interfaces.Unsigned_32'Last));
            SYSTIMER_Periph.TARGET0_HI :=
               (TIMER_TARGET0_HI => TARGET0_HI_TIMER_TARGET0_HI_Field (
                  Interfaces.Shift_Right (Interfaces.Unsigned_64 (Expiration_Timestamp_Cycles), 32)),
               others => <>);

            --  Re-load target expiration time into COMP0 comparator:
            Memory_Barrier;
            SYSTIMER_Periph.COMP0_LOAD := (TIMER_COMP0_LOAD => 1, others => <>);

            --  Enable comparator COMP0:
            CONF_Value := SYSTIMER_Periph.CONF;
            CONF_Value.TARGET0_WORK_EN := 1;
            SYSTIMER_Periph.CONF := CONF_Value;

            --  Enable generation of COMP0 timer interrupts:
            INT_ENA_Value := SYSTIMER_Periph.INT_ENA;
            INT_ENA_Value.TARGET0_INT_ENA := 1;
            SYSTIMER_Periph.INT_ENA := INT_ENA_Value;

         when System_Timer_Counter1 =>
            --  Disable comparator COMP1:
            CONF_Value := SYSTIMER_Periph.CONF;
            CONF_Value.TARGET1_WORK_EN := 0;
            SYSTIMER_Periph.CONF := CONF_Value;

            --  Select UNIT1 for COMP1
            TARGET1_CONF_Value := SYSTIMER_Periph.TARGET1_CONF;
            TARGET1_CONF_Value.TARGET1_TIMER_UNIT_SEL := 1;
            SYSTIMER_Periph.TARGET1_CONF := TARGET1_CONF_Value;

            Expiration_Timestamp_Cycles :=
               Get_System_Timer_Timestamp_Cycles (System_Timer_Counter) +
               Timer_Timestamp_Cycles_Type (Expiration_Time_Us *
                                          HiRTOS_Cpu_Arch_Interface.Tick_Timer.Timer_Counter_Cycles_Per_Us);

            --  Select single-shot mode
            TARGET1_CONF_Value := SYSTIMER_Periph.TARGET1_CONF;
            TARGET1_CONF_Value.TARGET1_PERIOD_MODE := 0;
            SYSTIMER_Periph.TARGET1_CONF := TARGET1_CONF_Value;

            --  Set target expiration time:
            SYSTIMER_Periph.TARGET1_LO := ESP32_C3.UInt32 (
               Interfaces.Unsigned_64 (Expiration_Timestamp_Cycles) and
               Interfaces.Unsigned_64 (Interfaces.Unsigned_32'Last));
            SYSTIMER_Periph.TARGET1_HI :=
               (TIMER_TARGET1_HI => TARGET1_HI_TIMER_TARGET1_HI_Field (
                  Interfaces.Shift_Right (Interfaces.Unsigned_64 (Expiration_Timestamp_Cycles), 32)),
               others => <>);

            --  Re-load target expiration time into COMP0 comparator:
            Memory_Barrier;
            SYSTIMER_Periph.COMP1_LOAD := (TIMER_COMP1_LOAD => 1, others => <>);

            --  Enable comparator COMP1:
            CONF_Value := SYSTIMER_Periph.CONF;
            CONF_Value.TARGET1_WORK_EN := 1;
            SYSTIMER_Periph.CONF := CONF_Value;

            --  Enable generation of COMP1 timer interrupts:
            INT_ENA_Value := SYSTIMER_Periph.INT_ENA;
            INT_ENA_Value.TARGET1_INT_ENA := 1;
            SYSTIMER_Periph.INT_ENA := INT_ENA_Value;
      end case;
   end Start_System_Timer_Single_Shot_Interrupt;

   procedure Start_System_Timer_Periodic_Interrupt (System_Timer_Counter : System_Timer_Counter_Type;
                                                    Expiration_Time_Us : HiRTOS.Relative_Time_Us_Type) is
      use ESP32_C3.SYSTIMER;
      CONF_Value : CONF_Register;
      TARGET0_CONF_Value : TARGET0_CONF_Register;
      TARGET1_CONF_Value : TARGET1_CONF_Register;
      INT_ENA_Value : INT_ENA_Register;
   begin
      case System_Timer_Counter is
         when System_Timer_Counter0 =>
            TARGET0_CONF_Value := SYSTIMER_Periph.TARGET0_CONF;
            TARGET0_CONF_Value.TARGET0_TIMER_UNIT_SEL := 0; --  Select UNIT0 for COMP0
            TARGET0_CONF_Value.TARGET0_PERIOD :=
               TARGET0_CONF_TARGET0_PERIOD_Field (
                  Expiration_Time_Us * HiRTOS_Cpu_Arch_Interface.Tick_Timer.Timer_Counter_Cycles_Per_Us);
            SYSTIMER_Periph.TARGET0_CONF := TARGET0_CONF_Value;

            --  Re-load period into COMP0 comparator:
            Memory_Barrier;
            SYSTIMER_Periph.COMP0_LOAD := (TIMER_COMP0_LOAD => 1, others => <>);

            --  Clear and then set PERIOD_MODE bit to enable periodic firing
            TARGET0_CONF_Value.TARGET0_PERIOD_MODE := 0;
            SYSTIMER_Periph.TARGET0_CONF := TARGET0_CONF_Value;
            Memory_Barrier;
            TARGET0_CONF_Value.TARGET0_PERIOD_MODE := 1;
            SYSTIMER_Periph.TARGET0_CONF := TARGET0_CONF_Value;

            --  Enable comparator COMP0:
            CONF_Value := SYSTIMER_Periph.CONF;
            CONF_Value.TARGET0_WORK_EN := 1;
            SYSTIMER_Periph.CONF := CONF_Value;

            --  Enable generation of COMP0 timer interrupts:
            INT_ENA_Value := SYSTIMER_Periph.INT_ENA;
            INT_ENA_Value.TARGET0_INT_ENA := 1;
            SYSTIMER_Periph.INT_ENA := INT_ENA_Value;

         when System_Timer_Counter1 =>
            TARGET1_CONF_Value := SYSTIMER_Periph.TARGET1_CONF;
            TARGET1_CONF_Value.TARGET1_TIMER_UNIT_SEL := 1; --  Select UNIT1 for COMP1
            TARGET1_CONF_Value.TARGET1_PERIOD :=
               TARGET0_CONF_TARGET0_PERIOD_Field (
                  Expiration_Time_Us * HiRTOS_Cpu_Arch_Interface.Tick_Timer.Timer_Counter_Cycles_Per_Us);
            SYSTIMER_Periph.TARGET1_CONF := TARGET1_CONF_Value;

            --  Re-load period into COMP1 comparator:
            Memory_Barrier;
            SYSTIMER_Periph.COMP1_LOAD := (TIMER_COMP1_LOAD => 1, others => <>);

            --  Clear and then set PERIOD_MODE bit to enable periodic firing
            TARGET1_CONF_Value.TARGET1_PERIOD_MODE := 0;
            SYSTIMER_Periph.TARGET1_CONF := TARGET1_CONF_Value;
            Memory_Barrier;
            TARGET1_CONF_Value.TARGET1_PERIOD_MODE := 1;
            SYSTIMER_Periph.TARGET1_CONF := TARGET1_CONF_Value;

            --  Enable comparator COMP1:
            CONF_Value := SYSTIMER_Periph.CONF;
            CONF_Value.TARGET1_WORK_EN := 1;
            SYSTIMER_Periph.CONF := CONF_Value;

            --  Enable generation of COMP1 timer interrupts:
            INT_ENA_Value := SYSTIMER_Periph.INT_ENA;
            INT_ENA_Value.TARGET1_INT_ENA := 1;
            SYSTIMER_Periph.INT_ENA := INT_ENA_Value;
      end case;
   end Start_System_Timer_Periodic_Interrupt;

   procedure Stop_System_Timer_Interrupt (System_Timer_Counter : System_Timer_Counter_Type) is
      use ESP32_C3.SYSTIMER;
      INT_ENA_Value : INT_ENA_Register;
   begin
      INT_ENA_Value := SYSTIMER_Periph.INT_ENA;
      case System_Timer_Counter is
         when System_Timer_Counter0 =>
            --  Disable generation of COMP0 timer interrupts:
            INT_ENA_Value.TARGET0_INT_ENA := 0;
         when System_Timer_Counter1 =>
            --  Disable generation of COMP0 timer interrupts:
            INT_ENA_Value.TARGET1_INT_ENA := 0;
      end case;

      SYSTIMER_Periph.INT_ENA := INT_ENA_Value;
   end Stop_System_Timer_Interrupt;

   procedure Clear_System_Timer_Interrupt (System_Timer_Counter : System_Timer_Counter_Type) is
      use ESP32_C3.SYSTIMER;
   begin
      Memory_Barrier;
      case System_Timer_Counter is
         when System_Timer_Counter0 =>
            --  Clear (W1C) COMP0 interrupt
            SYSTIMER_Periph.INT_CLR := (TARGET0_INT_CLR => 1, others => <>);
            Memory_Barrier;
            loop
               exit when SYSTIMER_Periph.INT_CLR.TARGET0_INT_CLR = 0;
            end loop;
         when System_Timer_Counter1 =>
            --  Clear (W1C) COMP1 interrupt
            SYSTIMER_Periph.INT_CLR := (TARGET1_INT_CLR => 1, others => <>);
            Memory_Barrier;
            loop
               exit when SYSTIMER_Periph.INT_CLR.TARGET1_INT_CLR = 0;
            end loop;
      end case;
      Memory_Barrier;
   end Clear_System_Timer_Interrupt;

   procedure Configure_Access_Violation_Interrupts is
      use ESP32_C3.SENSITIVE;
      use HiRTOS_Cpu_Arch_Interface.Interrupts;

      procedure Enable_PMS_IBUS_VIO_Interrupt is
      begin
         --  Configure interrupt in the interrupt controller:
         Interrupt_Controller.Configure_Interrupt (
            Interrupt_Id => PMS_IBUS_VIO_Interrupt_Id,
            Priority => Interrupt_Priorities (PMS_IBUS_VIO_Interrupt_Id),
            Trigger_Mode => Interrupt_Controller.Interrupt_Level_Sensitive,
            Interrupt_Handler_Entry_Point => PMS_IBUS_VIO_Interrupt_Handler'Access,
            Interrupt_Handler_Arg => System.Null_Address);

         --  Enable generation of interrupt:
         SENSITIVE_Periph.CORE_0_IRAM0_PMS_MONITOR_1 := (CORE_0_IRAM0_PMS_MONITOR_VIOLATE_CLR => 1,
                                                         CORE_0_IRAM0_PMS_MONITOR_VIOLATE_EN => 1,
                                                         others => <>);

         --  Enable interrupt in the interrupt controller:
         Interrupt_Controller.Enable_Interrupt (PMS_IBUS_VIO_Interrupt_Id);
      end Enable_PMS_IBUS_VIO_Interrupt;

      procedure Enable_PMS_DBUS_VIO_Interrupt is
      begin
         --  Configure interrupt in the interrupt controller:
         Interrupt_Controller.Configure_Interrupt (
            Interrupt_Id => PMS_DBUS_VIO_Interrupt_Id,
            Priority => Interrupt_Priorities (PMS_DBUS_VIO_Interrupt_Id),
            Trigger_Mode => Interrupt_Controller.Interrupt_Level_Sensitive,
            Interrupt_Handler_Entry_Point => PMS_DBUS_VIO_Interrupt_Handler'Access,
            Interrupt_Handler_Arg => System.Null_Address);

         --  Enable generation of interrupt:
         SENSITIVE_Periph.CORE_0_DRAM0_PMS_MONITOR_1 := (CORE_0_DRAM0_PMS_MONITOR_VIOLATE_CLR => 1,
                                                         CORE_0_DRAM0_PMS_MONITOR_VIOLATE_EN => 1,
                                                         others => <>);

         --  Enable interrupt in the interrupt controller:
         Interrupt_Controller.Enable_Interrupt (PMS_DBUS_VIO_Interrupt_Id);
      end Enable_PMS_DBUS_VIO_Interrupt;

      procedure Enable_PMS_PERI_VIO_Interrupt is
      begin
         --  Configure interrupt in the interrupt controller:
         Interrupt_Controller.Configure_Interrupt (
            Interrupt_Id => PMS_PERI_VIO_Interrupt_Id,
            Priority => Interrupt_Priorities (PMS_PERI_VIO_Interrupt_Id),
            Trigger_Mode => Interrupt_Controller.Interrupt_Level_Sensitive,
            Interrupt_Handler_Entry_Point => PMS_PERI_VIO_Interrupt_Handler'Access,
            Interrupt_Handler_Arg => System.Null_Address);

         --  Enable generation of interrupt:
         SENSITIVE_Periph.CORE_0_PIF_PMS_MONITOR_1 := (CORE_0_PIF_PMS_MONITOR_VIOLATE_CLR => 1,
                                                         CORE_0_PIF_PMS_MONITOR_VIOLATE_EN => 1,
                                                         others => <>);

         --  Enable interrupt in the interrupt controller:
         Interrupt_Controller.Enable_Interrupt (PMS_PERI_VIO_Interrupt_Id);
      end Enable_PMS_PERI_VIO_Interrupt;
   begin
      Enable_PMS_IBUS_VIO_Interrupt;
      Enable_PMS_DBUS_VIO_Interrupt;
      Enable_PMS_PERI_VIO_Interrupt;
   end Configure_Access_Violation_Interrupts;

   ---------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

   procedure PMS_IBUS_VIO_Interrupt_Handler (Arg : System.Address with Unreferenced) is
      use ESP32_C3.SENSITIVE;
      Mepc_Value : constant Integer_Address := Get_Mepc_Register;
   begin
      HiRTOS_Low_Level_Debug_Interface.Print_String (
         "*** Instruction access violation at PC ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (Mepc_Value));
      HiRTOS_Low_Level_Debug_Interface.Print_String (" accessing ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (
         Interfaces.Unsigned_32 (
            SENSITIVE_Periph.CORE_0_IRAM0_PMS_MONITOR_2.CORE_0_IRAM0_PMS_MONITOR_VIOLATE_STATUS_ADDR),
         End_Line => True);

      raise Program_Error;
   end PMS_IBUS_VIO_Interrupt_Handler;

   procedure PMS_DBUS_VIO_Interrupt_Handler (Arg : System.Address with Unreferenced) is
      use ESP32_C3.SENSITIVE;
      Mepc_Value : constant Integer_Address := Get_Mepc_Register;
   begin
      HiRTOS_Low_Level_Debug_Interface.Print_String (
         "*** " &
         (if SENSITIVE_Periph.CORE_0_DRAM0_PMS_MONITOR_3.CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_WR = 1 then
             "Store"
          else
             "Load") &
         " access violation at PC ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (Mepc_Value));
      HiRTOS_Low_Level_Debug_Interface.Print_String (" accessing ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (
         Interfaces.Unsigned_32 (
            SENSITIVE_Periph.CORE_0_DRAM0_PMS_MONITOR_2.CORE_0_DRAM0_PMS_MONITOR_VIOLATE_STATUS_ADDR),
         End_Line => True);

      raise Program_Error;
   end PMS_DBUS_VIO_Interrupt_Handler;

   procedure PMS_PERI_VIO_Interrupt_Handler (Arg : System.Address with Unreferenced) is
      use ESP32_C3.SENSITIVE;
      Mepc_Value : constant Integer_Address := Get_Mepc_Register;
   begin
      HiRTOS_Low_Level_Debug_Interface.Print_String (
         "*** MMIO " &
         (if SENSITIVE_Periph.CORE_0_PIF_PMS_MONITOR_2.CORE_0_PIF_PMS_MONITOR_VIOLATE_STATUS_HWRITE = 1 then
             "Store"
          else
             "Load") &
         " access violation at PC ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (Mepc_Value));
      HiRTOS_Low_Level_Debug_Interface.Print_String (" accessing ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (
         Interfaces.Unsigned_32 (SENSITIVE_Periph.CORE_0_PIF_PMS_MONITOR_3),
         End_Line => True);

      raise Program_Error;
   end PMS_PERI_VIO_Interrupt_Handler;

end HiRTOS_Platform_Interface;
