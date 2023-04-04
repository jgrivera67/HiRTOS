--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS_Cpu_Arch_Interface;

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
                  not Current_Execution_Context_Is_Interrupt and then
                  (HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled or else
                   Get_Current_Atomic_Level /= Atomic_Level_None);

   procedure Signal (Condvar_Id : Valid_Condvar_Id_Type)
      with Pre => Initialized (Condvar_Id);

   procedure Broadcast (Condvar_Id : Valid_Condvar_Id_Type)
      with Pre => Initialized (Condvar_Id);

   --
   --  Tells if the calling thread timed out on its last wait on a condvar
   --
   function Last_Wait_Timed_Out (Condvar_Id : Valid_Condvar_Id_Type) return Boolean
      with Pre => Initialized (Condvar_Id) and then
                  not Current_Execution_Context_Is_Interrupt;
end HiRTOS.Condvar;
