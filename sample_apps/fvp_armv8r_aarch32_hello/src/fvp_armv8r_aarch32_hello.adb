--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with Interfaces;
with HiRTOS_Low_Level_Debug_Interface;
--???with HiRTOS_Low_Level_Debug_Interface.UART_Input;
with GNAT.Source_Info;
with HiRTOS_Cpu_Startup_Interface;
with HiRTOS_Cpu_Multi_Core_Interface;
with HiRTOS;
with App_Threads;

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

begin -- Main
   --
   --  Initialize per-cpu debug peripherals:
   --
   HiRTOS_Low_Level_Debug_Interface.Initialize;
   Print_Console_Greeting;
   HiRTOS.Initialize_HiRTOS_Lib;
   --???HiRTOS_Low_Level_Debug_Interface.UART_Input.Initialize_Uart_Input;
   App_Threads.Initialize;
   HiRTOS.Start_Thread_Scheduler;

   pragma Assert (False);
end Fvp_Armv8r_Aarch32_Hello;
