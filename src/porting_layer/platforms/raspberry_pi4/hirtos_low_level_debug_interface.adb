--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with Uart_Driver;
with Number_Conversion_Utils;
with HiRTOS_Cpu_Arch_Interface_Private;
with HiRTOS_Cpu_Multi_Core_Interface;

package body HiRTOS_Low_Level_Debug_Interface with SPARK_Mode => Off is
   procedure Initialize_Led;

   Baud_Rate : constant := 115_200;

   UART_Clock_Frequency_Hz : constant := 48_000_000; --- 48 MHz

   --??? Debug_Uart_Spinlock : HiRTOS_Cpu_Multi_Core_Interface.Spinlock_Type;

   ----------------------------------------------------------------------------
   --  Public Subprograms
   ----------------------------------------------------------------------------

   procedure Initialize is
   begin
      Initialize_Led;
      Uart_Driver.Initialize_Uart (Baud_Rate, UART_Clock_Frequency_Hz);
      null;
   end Initialize;

   --------------
   -- Put_Char --
   --------------

   procedure Put_Char (C : Character) is
   begin
      Uart_Driver.Put_Char (C);
      if C = ASCII.LF then
         Uart_Driver.Put_Char (ASCII.CR);
      end if;
   end Put_Char;

   --------------
   -- Get_Char --
   --------------

   function Get_Char return Character is
      (Uart_Driver.Get_Char);

   ------------------
   -- Print_String --
   ------------------

   procedure Print_String (S : String; End_Line : Boolean := False) is
   begin
      --???HiRTOS_Cpu_Multi_Core_Interface.Spinlock_Acquire (Debug_Uart_Spinlock);
      for C of S loop
         Put_Char (C);
      end loop;

      if End_Line then
         Put_Char (ASCII.LF);
      end if;

      Uart_Driver.Flush_Output;
      --???HiRTOS_Cpu_Multi_Core_Interface.Spinlock_Release (Debug_Uart_Spinlock);
   end Print_String;

   --------------------------
   -- Print_Number_Decimal --
   --------------------------

   procedure Print_Number_Decimal (Value : Unsigned_32;
                                   End_Line : Boolean := False)
   is
      Str : String (1 .. 10);
      Str_Len : Positive;
   begin
      Number_Conversion_Utils.Unsigned_To_Decimal_String (Value, Str, Str_Len);
      Print_String (Str (1 .. Str_Len), End_Line);
   end Print_Number_Decimal;

   ------------------------------
   -- Print_Number_Hexadecimal --
   ------------------------------

   procedure Print_Number_Hexadecimal (Value : Unsigned_64;
                                       End_Line : Boolean := False)
   is
      Str : Number_Conversion_Utils.Unsigned_64_Hexadecimal_String_Type;
   begin
      Number_Conversion_Utils.Unsigned_To_Hexadecimal_String (Value, Str);
      Print_String (Str, End_Line);
   end Print_Number_Hexadecimal;

   procedure Print_Number_Hexadecimal (Value : Unsigned_32;
                                       End_Line : Boolean := False)
   is
      Str : Number_Conversion_Utils.Unsigned_32_Hexadecimal_String_Type;
   begin
      Number_Conversion_Utils.Unsigned_To_Hexadecimal_String (Value, Str);
      Print_String (Str, End_Line);
   end Print_Number_Hexadecimal;

   procedure Print_Number_Hexadecimal (Value : Unsigned_16;
                                       End_Line : Boolean := False)
   is
      Str : Number_Conversion_Utils.Unsigned_16_Hexadecimal_String_Type;
   begin
      Number_Conversion_Utils.Unsigned_To_Hexadecimal_String (Value, Str);
      Print_String (Str, End_Line);
   end Print_Number_Hexadecimal;

   procedure Print_Number_Hexadecimal (Value : Unsigned_8;
                                       End_Line : Boolean := False)
   is
      Str : Number_Conversion_Utils.Unsigned_8_Hexadecimal_String_Type;
   begin
      Number_Conversion_Utils.Unsigned_To_Hexadecimal_String (Value, Str);
      Print_String (Str, End_Line);
   end Print_Number_Hexadecimal;

   -------------
   -- Set_Led --
   -------------

   procedure Set_Led (On : Boolean with Unreferenced) is
   begin
      null;
   end Set_Led;

   -------------------------------
   -- Init_Self_Hosted_Debugger --
   -------------------------------

   Self_Hosted_Debugger_Callback : Self_Hosted_Debugger_Callback_Type := null;

   procedure Init_Self_Hosted_Debugger (Debugger_Callback : Self_Hosted_Debugger_Callback_Type) is
   begin
      HiRTOS_Cpu_Arch_Interface_Private.Enable_Debug_Exceptions;
      Self_Hosted_Debugger_Callback := Debugger_Callback;
   end Init_Self_Hosted_Debugger;

   ------------------------------
   -- Run_Self_Hosted_Debugger --
   ------------------------------

   procedure Run_Self_Hosted_Debugger (Arg : Cpu_Register_Type) is
   begin
      if Self_Hosted_Debugger_Callback /= null then
         Self_Hosted_Debugger_Callback (Arg);
      end if;
   end Run_Self_Hosted_Debugger;

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

   procedure Initialize_Led is
   begin
      null;
   end Initialize_Led;

end HiRTOS_Low_Level_Debug_Interface;
