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
