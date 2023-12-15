--
--  Copyright (c) 2022-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS_Cpu_Arch_Interface;

package HiRTOS.Condvar is

   procedure Create_Condvar (Condvar_Id : out Valid_Condvar_Id_Type);

   procedure Wait (Condvar_Id : Valid_Condvar_Id_Type; Mutex_Id : Valid_Mutex_Id_Type;
                   Timeout_Ms : Time_Ms_Type := Time_Ms_Type'Last)
      with Pre => not Current_Execution_Context_Is_Interrupt;

   procedure Wait (Condvar_Id : Valid_Condvar_Id_Type;
                   Timeout_Ms : Time_Ms_Type := Time_Ms_Type'Last)
      with Pre => not Current_Execution_Context_Is_Interrupt and then
                  (HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled or else
                   Get_Current_Atomic_Level /= Atomic_Level_None);

   procedure Signal (Condvar_Id : Valid_Condvar_Id_Type);

   procedure Broadcast (Condvar_Id : Valid_Condvar_Id_Type);

   --
   --  Tells if the calling thread timed out on its last wait on a condvar
   --
   function Last_Wait_Timed_Out return Boolean
      with Pre => not Current_Execution_Context_Is_Interrupt;
end HiRTOS.Condvar;
