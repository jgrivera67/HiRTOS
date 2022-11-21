--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package HiRTOS.Condvar is

   procedure Create_Condvar (Condvar_Id : out Condvar_Id_Type);

   procedure Wait (Condvar : Condvar_Id_Type; Mutex_Id : Mutex_Id_Type);

   procedure Wait (Condvar : Condvar_Id_Type; Atomic_Level : Atomic_Level_Type);

end HiRTOS.Condvar;
