--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.Thread_Private;

private package HiRTOS.Mutex_Private is
   use HiRTOS.Thread_Private;

   --
   --  Mutex object
   --
   --  @field Initialized: flag indicating if the mutex object has been initialized.
   --  @field Id: mutex Id
   --  @field Owner_Thread_Id: Thread Id of the thread that currently owns the mutex
   --  @field Recursive_Count: Recursive mutex acquires count
   --  @field Priority: Thread priority associated to the mutex
   --  @field Waiters_Queue: Priority queue of threads waiting to acquire the mutex
   --  @field List_Node: this mutex's node in a list of mutexes, if this mutex is in a list.
   --
   type Mutex_Type is limited record
      Initialized : Boolean := False;
      Id : Mutex_Id_Type := Invalid_Mutex_Id;
      Owner_Thread_Id : Thread_Id_Type := Invalid_Thread_Id;
      Recursive_Count : Interfaces.Unsigned_8 := 0;
      Priority        : Thread_Priority_Type := Invalid_Thread_Priority;
      Waiters_Queue   : Priority_Thread_Queues_Type;
   end record;

   type Mutex_Array_Type is array (Valid_Mutex_Id_Type) of Mutex_Type;

end HiRTOS.Mutex_Private;
