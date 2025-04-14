--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with Interfaces;
with HiRTOS_Cpu_Arch_Interface;

--
--  Minimal low-level debugging services
--
package HiRTOS_Low_Level_Debug_Interface
   with SPARK_Mode => On
is
   use Interfaces;
   use HiRTOS_Cpu_Arch_Interface;

   procedure Initialize;

   procedure Put_Char (C : Character);

   function Get_Char return Character;

   procedure Print_Number_Decimal (Value : Unsigned_32;
                                   End_Line : Boolean := False);

   procedure Print_Number_Hexadecimal (Value : Unsigned_64;
                                       End_Line : Boolean := False);

   procedure Print_Number_Hexadecimal (Value : Unsigned_32;
                                       End_Line : Boolean := False);

   procedure Print_Number_Hexadecimal (Value : Unsigned_16;
                                       End_Line : Boolean := False);

   procedure Print_Number_Hexadecimal (Value : Unsigned_8;
                                       End_Line : Boolean := False);

   procedure Print_String (S : String; End_Line : Boolean := False);

   procedure Set_Led (On : Boolean);

   type Self_Hosted_Debugger_Callback_Type is access procedure (Arg : Cpu_Register_Type);

   procedure Init_Self_Hosted_Debugger (Debugger_Callback : Self_Hosted_Debugger_Callback_Type)
      with Pre => Debugger_Callback /= null;

   procedure Run_Self_Hosted_Debugger (Arg : Cpu_Register_Type)
      with Pre => Cpu_In_Privileged_Mode;

end HiRTOS_Low_Level_Debug_Interface;
