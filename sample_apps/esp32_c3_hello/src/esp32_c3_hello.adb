--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with App_Threads;
with HiRTOS_Cpu_Startup_Interface;
with HiRTOS;
with HiRTOS.Debug;
with Interfaces;
with GNAT.Source_Info;

--  NOTE: This is needed to force the startup code to be linked-in
pragma Unreferenced (HiRTOS_Cpu_Startup_Interface);

procedure Esp32_C3_Hello is

   procedure Print_Console_Greeting is
      Cpu_Id : constant HiRTOS.Cpu_Id_Type := HiRTOS.Get_Current_Cpu_Id;
   begin
      HiRTOS.Debug.Print_String (
        "ESP32-C3 Hello (built on " &
        GNAT.Source_Info.Compilation_Date &
        " at " & GNAT.Source_Info.Compilation_Time & ")" & ASCII.LF);

      HiRTOS.Debug.Print_String ("CPU ");
      HiRTOS.Debug.Print_Number_Decimal (Interfaces.Unsigned_32 (Cpu_Id), End_Line => True);
   end Print_Console_Greeting;

begin -- Main
   HiRTOS.Initialize;
   Print_Console_Greeting;
   App_Threads.Initialize;
   HiRTOS.Start_Thread_Scheduler;

   pragma Assert (False);
end Esp32_C3_Hello;
