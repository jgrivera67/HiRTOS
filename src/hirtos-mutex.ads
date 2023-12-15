--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--
package HiRTOS.Mutex is

   procedure Create_Mutex (Mutex_Id : out Valid_Mutex_Id_Type;
                           Ceiling_Priority : Thread_Priority_Type := Invalid_Thread_Priority);

   procedure Acquire (Mutex_Id : Valid_Mutex_Id_Type);

   function Try_Acquire (Mutex_Id : Valid_Mutex_Id_Type;
                         Timeout_Ms : Time_Ms_Type) return Boolean;

   procedure Release (Mutex_Id : Valid_Mutex_Id_Type);

end HiRTOS.Mutex;
