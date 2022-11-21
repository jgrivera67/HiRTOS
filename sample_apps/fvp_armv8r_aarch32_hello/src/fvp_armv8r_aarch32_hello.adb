--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with Interfaces;
with HiRTOS_Low_Level_Debug_Interface;
with GNAT.Source_Info;
with HiRTOS_Cpu_Startup_Interface;
with HiRTOS_Cpu_Multi_Core_Interface;
with HiRTOS;

pragma Unreferenced (HiRTOS_Cpu_Startup_Interface);

procedure Fvp_Armv8r_Aarch32_Hello is
   use HiRTOS_Cpu_Multi_Core_Interface;

   procedure Print_Console_Greeting is
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
   begin
      HiRTOS_Low_Level_Debug_Interface.Print_String (
        "FVP ARMv8-R Hello (Written in Ada 2012, built on " &
        GNAT.Source_Info.Compilation_Date &
        " at " & GNAT.Source_Info.Compilation_Time & ")" & ASCII.LF);

      HiRTOS_Low_Level_Debug_Interface.Print_String (
         "CPU ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (
         Interfaces.Unsigned_32 (Cpu_Id),
         End_Line => True);
   end Print_Console_Greeting;

   -- ** --

   procedure Naive_Delay (N : Interfaces.Unsigned_32) is
      use Interfaces;
      Count : Unsigned_32 := N;
   begin
      loop
         exit when Count = 0;
         Count := Count - 1;
      end loop;
   end Naive_Delay;

   -- ** --

   Turn_LED_On : Boolean := True;
begin -- Main
   Print_Console_Greeting;

   HiRTOS.Initialize;

   loop
      HiRTOS_Low_Level_Debug_Interface.Print_String ("JGR "); --???
      if Turn_LED_On then
         Turn_LED_On := False;
         HiRTOS_Low_Level_Debug_Interface.Set_Led (True);
      else
         Turn_LED_On := True;
         HiRTOS_Low_Level_Debug_Interface.Set_Led (False);
      end if;

      Naive_Delay (10_000_000);
   end loop;
end Fvp_Armv8r_Aarch32_Hello;
