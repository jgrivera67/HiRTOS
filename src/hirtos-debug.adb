--
--  Copyright (c) 2022-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS_Low_Level_Debug_Interface;

--
--  Minimal debugging services
--
package body HiRTOS.Debug
   with SPARK_Mode => On
is

   procedure Print_String (S : String; End_Line : Boolean := False)
   is
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;
      HiRTOS_Low_Level_Debug_Interface.Print_String (S, End_Line);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Print_String;

   procedure Print_Number_Decimal (Value : Unsigned_32;
                                   End_Line : Boolean := False)
   is
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (Value, End_Line);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Print_Number_Decimal;

   procedure Print_Number_Hexadecimal (Value : Unsigned_32;
                                       End_Line : Boolean := False)
   is
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Value, End_Line);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Print_Number_Hexadecimal;

   procedure Set_Led (On : Boolean)
   is
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;
      HiRTOS_Low_Level_Debug_Interface.Set_Led (On);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Set_Led;

end HiRTOS.Debug;
