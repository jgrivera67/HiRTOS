--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.Timer_Private;

package body HiRTOS.Timer is
   use HiRTOS.Timer_Private;

   procedure Initialize_Timer (Timer_Obj : out Timer_Type; Timer_Id : Timer_Id_Type)
      with Pre => Timer_Id /= Invalid_Timer_Id;

   -----------------------------------------------------------------------------
   --  Public Subprograms
   -----------------------------------------------------------------------------

   procedure Create_Timer (Timer_Id : out Timer_Id_Type) is
   begin
      pragma Assert (False); --???
   end Create_Timer;

   -----------------------------------------------------------------------------
   --  Private Subprograms
   -----------------------------------------------------------------------------

   procedure Initialize_Timer (Timer_Obj : out Timer_Type; Timer_Id : Timer_Id_Type) is
   begin
      Timer_Obj.Id := Timer_Id;
   end Initialize_Timer;
end HiRTOS.Timer;
