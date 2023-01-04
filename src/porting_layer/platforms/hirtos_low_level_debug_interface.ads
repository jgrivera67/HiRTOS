--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with Interfaces;

--
--  Minimal low-level debugging services
--
package HiRTOS_Low_Level_Debug_Interface
   with SPARK_Mode => On
is
   use Interfaces;

   procedure Initialize;

   procedure Print_Number_Decimal (Value : Unsigned_32;
                                   End_Line : Boolean := False);

   procedure Print_Number_Hexadecimal (Value : Unsigned_32;
                                       End_Line : Boolean := False);

   procedure Print_String (S : String; End_Line : Boolean := False);

   procedure Set_Led (On : Boolean);

end HiRTOS_Low_Level_Debug_Interface;
