--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS_Cpu_Arch_Interface;
with Uart_Driver;
with Number_Conversion_Utils;
with ESP32_C3.GPIO;

package body HiRTOS_Low_Level_Debug_Interface with SPARK_Mode => Off is
   use HiRTOS_Cpu_Arch_Interface;

   procedure Initialize_Led;

   Baud_Rate : constant := 115_200;

   UART_Clock_Frequency_Hz : constant := 24_000_000; --- 24 MHz

   Led_Gpio_Pin_Num : constant := 8;

   ----------------------------------------------------------------------------
   --  Public Subprograms
   ----------------------------------------------------------------------------

   procedure Initialize is
   begin
      Initialize_Led;
      Uart_Driver.Initialize_Uart (Baud_Rate, UART_Clock_Frequency_Hz);
   end Initialize;

   procedure Put_Char (C : Character) is
      Old_Cpu_Interrupting_State : Cpu_Register_Type; --???
   begin
      --  Begin critical section
      Old_Cpu_Interrupting_State := Disable_Cpu_Interrupting;

      Uart_Driver.Put_Char (C);
      if C = ASCII.LF then
         Uart_Driver.Put_Char (ASCII.CR);
      end if;

      --  End critical section
      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);
   end Put_Char;

   ------------------
   -- Print_String --
   ------------------

   procedure Print_String (S : String; End_Line : Boolean := False) is
   begin
      for C of S loop
         Put_Char (C);
      end loop;

      if End_Line then
         Put_Char (ASCII.LF);
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
      use ESP32_C3.GPIO;
   begin
      if On then
         GPIO_Periph.OUT_W1TS :=
            (OUT_W1TS => ESP32_C3.UInt26 (HiRTOS_Cpu_Arch_Interface.Bit_Mask (Led_Gpio_Pin_Num)),
             others => <>);
      else
         GPIO_Periph.OUT_W1TC :=
            (OUT_W1TC => ESP32_C3.UInt26 (HiRTOS_Cpu_Arch_Interface.Bit_Mask (Led_Gpio_Pin_Num)),
             others => <>);
      end if;
   end Set_Led;

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

   procedure Initialize_Led is
      use ESP32_C3.GPIO;
   begin
      GPIO_Periph.FUNC_OUT_SEL_CFG (Led_Gpio_Pin_Num) :=
         (OUT_SEL => 16#80#, OEN_SEL => 1, others => <>);
      GPIO_Periph.ENABLE_W1TS :=
         (ENABLE_W1TS => ESP32_C3.UInt26 (HiRTOS_Cpu_Arch_Interface.Bit_Mask (Led_Gpio_Pin_Num)),
          others => <>);
   end Initialize_Led;

end HiRTOS_Low_Level_Debug_Interface;
