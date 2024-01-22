--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Hypervisor Tick timer driver
--

package HiRTOS_Cpu_Arch_Interface.Tick_Timer.Hypervisor
   with SPARK_Mode => On
is

   procedure Initialize
      with Pre => Cpu_In_Hypervisor_Mode;

   procedure Start_Timer (Expiration_Time_Us : HiRTOS.Relative_Time_Us_Type)
      with Pre => Expiration_Time_Us /= 0 and then
                  Cpu_In_Hypervisor_Mode;

   procedure Stop_Timer
      with Pre => Cpu_In_Hypervisor_Mode;

   type Timer_Context_Type is limited private;

   procedure Initialize_Timer_Context (Timer_Context : out Timer_Context_Type)
      with Pre => Cpu_In_Hypervisor_Mode;

   procedure Save_Timer_Context (Timer_Context : out Timer_Context_Type)
      with Pre => Cpu_In_Hypervisor_Mode;

   procedure Restore_Timer_Context (Timer_Context : Timer_Context_Type)
      with Pre => Cpu_In_Hypervisor_Mode;

private

   function Get_CNTHP_CTL return CNTP_CTL_Type
      with Inline_Always;

   procedure Set_CNTHP_CTL (CNTP_CTL_Value : CNTP_CTL_Type)
      with Inline_Always;

   function Get_CNTHP_TVAL return CNTP_TVAL_Type
      with Inline_Always;

   procedure Set_CNTHP_TVAL (CNTP_TVAL_Value : CNTP_TVAL_Type)
      with Inline_Always;

   subtype CNTVOFF_Type is CNTPCT_Type;

   function Get_CNTVOFF return CNTVOFF_Type
      with Inline_Always;

   procedure Set_CNTVOFF (CNTVOFF_Value : CNTVOFF_Type)
      with Inline_Always;

   type Timer_Context_Type is record
      CNTV_CTL_Value : CNTV_CTL_Type;
      CNTV_TVAL_Value : CNTV_TVAL_Type;
      CNTVCT_Value : CNTVCT_Type;
   end record;

end HiRTOS_Cpu_Arch_Interface.Tick_Timer.Hypervisor;
