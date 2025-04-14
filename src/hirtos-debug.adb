--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS_Low_Level_Debug_Interface;
with HiRTOS.Interrupt_Handling;

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

   procedure Self_Hosted_Debugger_Callback (Arg : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type)
   is
      use System.Storage_Elements;
      Saved_PC : constant System.Address := HiRTOS.Interrupt_Handling.Get_Interrupted_PC;
      C : Character;
   begin
      HiRTOS_Low_Level_Debug_Interface.Print_String (ASCII.LF & "Running GDB server ..." & ASCII.LF);
      HiRTOS_Low_Level_Debug_Interface.Print_String ("GDB server not implemented yet" & ASCII.LF);
      loop
         C := HiRTOS_Low_Level_Debug_Interface.Get_Char;
         --???
         if C = ASCII.CR then
            HiRTOS_Low_Level_Debug_Interface.Put_Char (ASCII.LF);
         else
            HiRTOS_Low_Level_Debug_Interface.Put_Char (C);
            exit when C = 'q';
         end if;
         --???
      end loop;

      --  TODO: Fix this (not returning correctly from breakpoint)
      pragma Assert (Integer_Address (Arg) = To_Integer (Saved_PC));
      HiRTOS.Interrupt_Handling.Set_Interrupted_PC (
         To_Address (To_Integer (Saved_PC) + HiRTOS_Cpu_Arch_Parameters.Break_Instruction_Size_In_Bytes));
   end Self_Hosted_Debugger_Callback;

   procedure Initialize_Self_Hosted_Debugger is
   begin
      HiRTOS_Low_Level_Debug_Interface.Init_Self_Hosted_Debugger (Self_Hosted_Debugger_Callback'Access);
   end Initialize_Self_Hosted_Debugger;

end HiRTOS.Debug;
