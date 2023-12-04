--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with App_Threads;
with HiRTOS_Cpu_Startup_Interface;
with HiRTOS;
with HiRTOS.Debug;
with Interfaces;
with GNAT.Source_Info;

--  NOTE: This is needed to force the startup code to be linked-in
pragma Unreferenced (HiRTOS_Cpu_Startup_Interface);

procedure Fvp_Armv8r_Aarch32_Hello is

   procedure Print_Console_Greeting is
      Cpu_Id : constant HiRTOS.Cpu_Id_Type := HiRTOS.Get_Current_Cpu_Id;
   begin
      HiRTOS.Debug.Print_String (
        "FVP ARMv8-R Hello (Written in Ada 2012, built on " &
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
end Fvp_Armv8r_Aarch32_Hello;
