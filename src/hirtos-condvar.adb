--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
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
