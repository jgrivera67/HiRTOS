--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package HiRTOS.Condvar is

   function Initialized (Condvar_Id : Valid_Condvar_Id_Type) return Boolean
      with Ghost;

   procedure Create_Condvar (Condvar_Id : out Valid_Condvar_Id_Type)
      with Post => Initialized (Condvar_Id);

   procedure Wait (Condvar_Id : Valid_Condvar_Id_Type; Mutex_Id : Valid_Mutex_Id_Type;
                   Timeout_Ms : Time_Ms_Type := Time_Ms_Type'Last)
      with Pre => Initialized (Condvar_Id) and then
                  not Current_Execution_Context_Is_Interrupt;

   procedure Wait (Condvar_Id : Valid_Condvar_Id_Type;
                   Timeout_Ms : Time_Ms_Type := Time_Ms_Type'Last)
      with Pre => Initialized (Condvar_Id) and then
                  not Current_Execution_Context_Is_Interrupt;

   procedure Signal (Condvar_Id : Valid_Condvar_Id_Type)
      with Pre => Initialized (Condvar_Id);

   procedure Broadcast (Condvar_Id : Valid_Condvar_Id_Type)
      with Pre => Initialized (Condvar_Id);

end HiRTOS.Condvar;
