--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.Thread_Private;

private package HiRTOS.Condvar_Private is
   use HiRTOS.Thread_Private;

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
   --  @field Waiting_Threads_Queue: Priority queue of threads waiting on the condvar.
   --
   type Condvar_Type is limited record
      Initialized : Boolean := False;
      Id : Condvar_Id_Type := Invalid_Condvar_Id;
      Wakeup_Atomic_Level : Atomic_Level_Type := Atomic_Level_None;
      Wakeup_Mutex_id : Mutex_Id_Type := Invalid_Mutex_Id;
      Waiting_Threads_Queue : Thread_Priority_Queue_Type;
   end record;
   --  with Type_Invariant =>
   --    (if Condvar_Type.Wakeup_Atomic_Level /= Atomic_Level_None then
   --        Condvar_Type.Wakeup_Mutex_id = Invalid_Mutex_Id);

   type Condvar_Array_Type is array (Valid_Condvar_Id_Type) of Condvar_Type;

end HiRTOS.Condvar_Private;
