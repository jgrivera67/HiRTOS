--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
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

private

   function Get_CNTHP_CTL return CNTP_CTL_Type
      with Inline_Always;

   procedure Set_CNTHP_CTL (CNTP_CTL_Value : CNTP_CTL_Type)
      with Inline_Always;

   function Get_CNTHP_TVAL return CNTP_TVAL_Type
      with Inline_Always;

   procedure Set_CNTHP_TVAL (CNTP_TVAL_Value : CNTP_TVAL_Type)
      with Inline_Always;

end HiRTOS_Cpu_Arch_Interface.Tick_Timer.Hypervisor;
