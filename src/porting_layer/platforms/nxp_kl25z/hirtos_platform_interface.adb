--
--  Copyright (c) 2024, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  Platform interface
--
with HiRTOS_Low_Level_Debug_Interface;
with Microcontroller_Clocks;
with Reset_Counter;

package body HiRTOS_Platform_Interface
   with SPARK_Mode => Off
is

   procedure Initialize_Platform is
   begin
      --???Low_Level_Debug.Initialize_Rgb_Led;
      --???Low_Level_Debug.Set_Rgb_Led(Red_On => True);

      Microcontroller_Clocks.Initialize;
      --???Low_Level_Debug.Set_Rgb_Led(Green_On => True);

      Reset_Counter.Update;
      HiRTOS_Low_Level_Debug_Interface.Initialize;
      --???Low_Level_Debug.Set_Rgb_Led; --  off
   end Initialize_Platform;

end HiRTOS_Platform_Interface;
