--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

package body HiRTOS.Timer_Private is

   procedure Initialize_Timer_Wheel (Timer_Wheel : out Timer_Wheel_Type) is
   begin
      Timer_Wheel.Current_Wheel_Spoke_Index :=
         Valid_Timer_Wheel_Spoke_Index_Type'First;
   end Initialize_Timer_Wheel;

end HiRTOS.Timer_Private;
