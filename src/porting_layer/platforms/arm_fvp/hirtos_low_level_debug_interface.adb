--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS_Cpu_Multi_Core_Interface;
with Uart_Driver;
with Bit_Sized_Integer_Types;
with Number_Conversion_Utils;
with System;

package body HiRTOS_Low_Level_Debug_Interface with SPARK_Mode => Off is
   use HiRTOS_Cpu_Multi_Core_Interface;

   procedure Initialize_Led;

   --
   --  Red/yellow/green LEDs on the VE hardware, which are mapped to bits [7:0] of the
   --  SYS_LED register
   --
   SYS_LED_Base : constant System.Address := System'To_Address (16#8000_0000# + 16#1C01_0008#);

   --
   --  User DIP switches mapped to bits [7:0] of the SYS_SW register
   --
   SYS_SW_Base : constant System.Address := System'To_Address (16#8000_0000# + 16#1C01_0004#);

   type Word_Bit_Index_Type is range 0 .. Interfaces.Unsigned_32'Size - 1;

   type Word_Bit_Array_Type is array (Word_Bit_Index_Type) of Bit_Sized_Integer_Types.Bit_Type
     with Component_Size => 1, Size => Interfaces.Unsigned_32'Size;

   --
   --  Array LED instance
   --
   SYS_LED_Periph : aliased Word_Bit_Array_Type
     with Import, Volatile_Full_Access, Address => SYS_LED_Base;

   --
   --  Array of dip switches
   --
   SYS_SW_Periph : aliased Word_Bit_Array_Type
     with Import, Volatile_Full_Access, Address => SYS_SW_Base;

   Baud_Rate : constant := 115_200;

   UART_Clock_Frequency_Hz : constant := 24_000_000; --- 24 MHz

   ----------------------------------------------------------------------------
   --  Public Subprograms
   ----------------------------------------------------------------------------

   procedure Initialize is
   begin
      Initialize_Led;
      Uart_Driver.Initialize_Uart (Baud_Rate, UART_Clock_Frequency_Hz);
   end Initialize;

   ------------------
   -- Print_String --
   ------------------

   procedure Print_String (S : String; End_Line : Boolean := False) is
   begin
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

   procedure Set_Led (On : Boolean) is
      SYS_LED_Value : Word_Bit_Array_Type;
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
   begin
      SYS_LED_Value := SYS_LED_Periph;
      SYS_LED_Value (Word_Bit_Index_Type (Cpu_Id)) := Boolean'Pos (On);
      SYS_LED_Periph := SYS_LED_Value;
   end Set_Led;

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

   procedure Initialize_Led is
      SYS_LED_Value : Word_Bit_Array_Type;
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
   begin
      SYS_LED_Value := SYS_LED_Periph;
      SYS_LED_Value (Word_Bit_Index_Type (Cpu_Id)) := 0;
      SYS_LED_Periph := SYS_LED_Value;
   end Initialize_Led;

end HiRTOS_Low_Level_Debug_Interface;
