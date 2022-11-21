--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.Condvar_Private;

package body HiRTOS.Condvar is
   use HiRTOS.Condvar_Private;

   procedure Initialize_Condvar (Condvar_Obj : out Condvar_Type; Condvar_Id : Condvar_Id_Type)
      with Pre => Condvar_Id /= Invalid_Condvar_Id;

   -----------------------------------------------------------------------------
   --  Public Subprograms
   -----------------------------------------------------------------------------

   procedure Create_Condvar (Condvar_Id : out Condvar_Id_Type) is
   begin
      pragma Assert (False); --???
   end Create_Condvar;

   procedure Wait (Condvar : Condvar_Id_Type; Mutex_Id : Mutex_Id_Type) is
   begin
      pragma Assert (False); --???
   end Wait;

   procedure Wait (Condvar : Condvar_Id_Type; Atomic_Level : Atomic_Level_Type) is
   begin
      pragma Assert (False); --???
   end Wait;

   -----------------------------------------------------------------------------
   --  Private Subprograms
   -----------------------------------------------------------------------------

   procedure Initialize_Condvar (Condvar_Obj : out Condvar_Type; Condvar_Id : Condvar_Id_Type) is
   begin
      Condvar_Obj.Id := Condvar_Id;
   end Initialize_Condvar;

end HiRTOS.Condvar;
