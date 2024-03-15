--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Tick timer driver
--

with HiRTOS;
with Interfaces;
with HiRTOS_Platform_Parameters;

package HiRTOS_Cpu_Arch_Interface.Tick_Timer
   with SPARK_Mode => On
is
   use type HiRTOS.Relative_Time_Us_Type;

   Timer_Counter_Cycles_Per_Us : constant :=
      HiRTOS_Platform_Parameters.System_Clock_Frequency_Hz / 1_000_000; --TODO

   pragma Compile_Time_Error
     (Timer_Counter_Cycles_Per_Us = 0, "Invalid Timer_Counter_Cycles_Per_Us");

   procedure Initialize
      with Pre => Cpu_In_Privileged_Mode;

   type Timer_Timestamp_Cycles_Type is new Interfaces.Unsigned_64;

   function Get_Timer_Timestamp_Cycles return Timer_Timestamp_Cycles_Type;

   function Get_Timer_Timestamp_Us return HiRTOS.Absolute_Time_Us_Type;

   procedure Start_Timer (Expiration_Time_Us : HiRTOS.Relative_Time_Us_Type)
      with Pre => Expiration_Time_Us /= 0 and then
                  Cpu_In_Privileged_Mode;

   procedure Stop_Timer
      with Pre => Cpu_In_Privileged_Mode;

private

   function Get_Timer_Timestamp_Us return HiRTOS.Absolute_Time_Us_Type is
      (HiRTOS.Absolute_Time_Us_Type (Get_Timer_Timestamp_Cycles  / Timer_Counter_Cycles_Per_Us));

end HiRTOS_Cpu_Arch_Interface.Tick_Timer;
