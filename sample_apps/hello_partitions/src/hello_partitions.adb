--
--  Copyright (c) 2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with App_Partitions;
with HiRTOS_Cpu_Startup_Interface;
with HiRTOS.Debug;
with HiRTOS.Separation_Kernel;
with Interfaces;
with GNAT.Source_Info;

--  NOTE: This is needed to force the startup code to be linked-in
pragma Unreferenced (HiRTOS_Cpu_Startup_Interface);

procedure Hello_Partitions is

   procedure Print_Console_Greeting is
      Cpu_Id : constant HiRTOS.Cpu_Id_Type := HiRTOS.Get_Current_Cpu_Id;
   begin
      HiRTOS.Debug.Print_String (
        "FVP ARMv8-R Hello Partitions (Written in Ada 2012, built on " &
        GNAT.Source_Info.Compilation_Date &
        " at " & GNAT.Source_Info.Compilation_Time & ")" & ASCII.LF);

      HiRTOS.Debug.Print_String ("CPU ");
      HiRTOS.Debug.Print_Number_Decimal (Interfaces.Unsigned_32 (Cpu_Id), End_Line => True);
   end Print_Console_Greeting;

begin -- Main
   HiRTOS.Separation_Kernel.Initialize;
   Print_Console_Greeting;

   App_Partitions.Initialize;
   HiRTOS.Separation_Kernel.Start_Partition_Scheduler;

   pragma Assert (False);
end Hello_Partitions;
