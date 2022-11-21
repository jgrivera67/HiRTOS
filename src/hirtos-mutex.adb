--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.Mutex_Private;

package body HiRTOS.Mutex is
   use HiRTOS.Mutex_Private;

   procedure Initialize_Mutex (Mutex_Obj : out Mutex_Type; Mutex_Id : Mutex_Id_Type)
      with Pre => Mutex_Id /= Invalid_Mutex_Id;

   -----------------------------------------------------------------------------
   --  Public Subprograms
   -----------------------------------------------------------------------------

   procedure Create_Mutex (Mutex_Id : out Mutex_Id_Type) is
   begin
      pragma Assert (False); --???
   end Create_Mutex;

   -----------------------------------------------------------------------------
   --  Private Subprograms
   -----------------------------------------------------------------------------

   procedure Initialize_Mutex (Mutex_Obj : out Mutex_Type; Mutex_Id : Mutex_Id_Type) is
   begin
      Mutex_Obj.Id := Mutex_Id;
   end Initialize_Mutex;

end HiRTOS.Mutex;
