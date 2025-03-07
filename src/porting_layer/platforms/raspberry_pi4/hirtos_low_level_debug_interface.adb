--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with Uart_Driver;
with Number_Conversion_Utils;
with HiRTOS_Cpu_Multi_Core_Interface;

package body HiRTOS_Low_Level_Debug_Interface with SPARK_Mode => Off is
   procedure Initialize_Led;

   --??? Baud_Rate : constant := 115_200;

   --??? UART_Clock_Frequency_Hz : constant := 48_000_000; --- 48 MHz

   Debug_Uart_Spinlock : HiRTOS_Cpu_Multi_Core_Interface.Spinlock_Type;

   ----------------------------------------------------------------------------
   --  Public Subprograms
   ----------------------------------------------------------------------------

   procedure Initialize is
   begin
      Initialize_Led;
      --??? Uart_Driver.Initialize_Uart (Baud_Rate, UART_Clock_Frequency_Hz);
      null;
   end Initialize;

   ------------------
   -- Print_String --
   ------------------

   procedure Print_String (S : String; End_Line : Boolean := False) is
   begin
      --???HiRTOS_Cpu_Multi_Core_Interface.Spinlock_Acquire (Debug_Uart_Spinlock);
      for C of S loop
         Uart_Driver.Put_Char (C);
         if C = ASCII.LF then
            Uart_Driver.Put_Char (ASCII.CR);
         end if;
      end loop;

      if End_Line then
         Uart_Driver.Put_Char (ASCII.LF);
         Uart_Driver.Put_Char (ASCII.CR);
      end if;
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

   procedure Print_Number_Hexadecimal (Value : Unsigned_32;
                                       End_Line : Boolean := False)
   is
      Str : String (1 .. 8);
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

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

   procedure Initialize_Led is
   begin
      null;
   end Initialize_Led;

end HiRTOS_Low_Level_Debug_Interface;
