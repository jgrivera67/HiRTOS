--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary UART driver for NXP KL25Z
--
private with Bit_Sized_Integer_Types;
private with System;
with Interfaces;

package Uart_Driver is

   procedure Initialize_Uart (Baud_Rate : Positive);

   procedure Put_Char (C : Character);

   function Get_Char return Character;
   procedure Tx_Flush;

private
   use Bit_Sized_Integer_Types;
   use Interfaces;

   type Encoded_Baud_Rate_Type is record
      Low_Part  : Byte_Type;
      High_Part : Five_Bits_Type;
   end record with
      Size      => Unsigned_16'Size,
      Bit_Order => System.Low_Order_First;

   for Encoded_Baud_Rate_Type use record
      Low_Part  at 0 range 0 ..  7;
      High_Part at 0 range 8 .. 12;
   end record;

end Uart_Driver;
