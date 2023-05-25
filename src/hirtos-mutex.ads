--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package HiRTOS.Mutex is

   function Initialized (Mutex_Id : Valid_Mutex_Id_Type) return Boolean  with Ghost;

   procedure Create_Mutex (Ceiling_Priority : Thread_Priority_Type; Mutex_Id : out Valid_Mutex_Id_Type)
      with Post => Initialized (Mutex_Id);

   procedure Acquire (Mutex_Id : Valid_Mutex_Id_Type)
      with Pre => Initialized (Mutex_Id);

   function Try_Acquire (Mutex_Id : Valid_Mutex_Id_Type;
                         Timeout_Ms : Time_Ms_Type) return Boolean
      with Pre => Initialized (Mutex_Id);

   procedure Release (Mutex_Id : Valid_Mutex_Id_Type)
      with Pre => Initialized (Mutex_Id);

end HiRTOS.Mutex;
