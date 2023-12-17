--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with Interfaces;

--
--  Minimal debugging services
--
package HiRTOS.Debug
   with SPARK_Mode => On
is
   use Interfaces;

   procedure Print_String (S : String; End_Line : Boolean := False);

   procedure Print_Number_Decimal (Value : Unsigned_32;
                                   End_Line : Boolean := False);

   procedure Print_Number_Hexadecimal (Value : Unsigned_32;
                                       End_Line : Boolean := False);

   procedure Set_Led (On : Boolean);

end HiRTOS.Debug;
