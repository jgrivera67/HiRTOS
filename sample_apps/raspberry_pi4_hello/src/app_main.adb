--
--  Copyright (c) 2022-2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with App_Threads;
with HiRTOS_Cpu_Startup_Interface;
with HiRTOS;
with HiRTOS.Debug;
with HiRTOS_Low_Level_Debug_Interface; --???
with Interfaces;
with GNAT.Source_Info;

--  NOTE: This is needed to force the startup code to be linked-in
pragma Unreferenced (HiRTOS_Cpu_Startup_Interface);

procedure App_Main is
   procedure Print_Console_Greeting is
      Cpu_Id : constant HiRTOS.Cpu_Id_Type := HiRTOS.Get_Current_Cpu_Id;
   begin
      HiRTOS.Debug.Print_String (
        "Raspberry PI 4 Hello running on CPU ");
      HiRTOS.Debug.Print_Number_Decimal (Interfaces.Unsigned_32 (Cpu_Id));
      HiRTOS.Debug.Print_String (
        " (built on " &
        GNAT.Source_Info.Compilation_Date &
        " at " & GNAT.Source_Info.Compilation_Time & ")" & ASCII.LF);
   end Print_Console_Greeting;

begin -- Main
   HiRTOS_Low_Level_Debug_Interface.Print_String("**** Hello perro joe ***" & ASCII.LF); --???
   HiRTOS.Initialize;
   Print_Console_Greeting;

   App_Threads.Initialize;
   HiRTOS.Start_Thread_Scheduler;

   pragma Assert (False);
end App_Main;
