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

private package HiRTOS.Condvar_Private is
   --
   --  Condition variable object
   --
   --  @field Initialized: Flag indicating if the condvar object has been initialized.
   --  @field Id: Condvar Id
   --  @field Wakeup_Atomic_Level: Atomic level in effect before calling Wait
   --         on the condvar and to be re-entered when wakeup up from Wait.
   --  @field Wakeup_Mutex_Id: Mutex Id of the mutex that was held before
   --         calling Wait on the condvar and to be re-acquired  when
   --         waking up from Wait. It is meaningful only if `Wake_Atomic_Level`
   --         is `Atomic_Level_None`.
   --  @field Waiters_Queue: Queue of threads waiting on the condvar.
   --
   type Condvar_Type is limited record
      Initialized : Boolean := False;
      Id : Condvar_Id_Type := Invalid_Condvar_Id;
      Wakeup_Atomic_Level : Atomic_Level_Type := Atomic_Level_None;
      Wakeup_Mutex_id : Mutex_Id_Type := Invalid_Mutex_Id;
      Waiters_Queue       : Thread_Queue_Package.List_Anchor_Type;
   end record;
   --  with Type_Invariant =>
   --    (if Condvar_Type.Wakeup_Atomic_Level /= Atomic_Level_None then
   --        Condvar_Type.Wakeup_Mutex_id = Invalid_Mutex_Id);

   type Condvar_Array_Type is array (Valid_Condvar_Id_Type) of Condvar_Type;

end HiRTOS.Condvar_Private;
