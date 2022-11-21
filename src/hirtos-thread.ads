--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with System.Storage_Elements;

package HiRTOS.Thread
   with SPARK_Mode => On
is
   --
   --  NOTE: Lower value means higher priority
   --
   Lowest_Thread_Prioritiy :
      constant Thread_Priority_Type := Thread_Priority_Type'Last;

   Highest_Thread_Prioritiy :
      constant Thread_Priority_Type := Thread_Priority_Type'First;

   type Thread_Entry_Point_Type is access procedure (Arg : System.Address)
          with Convention => C;

   --
   --  Create new thread
   --
   procedure Create_Thread (Entry_Point : Thread_Entry_Point_Type;
                            Priority : Thread_Priority_Type;
                            Stack_Addr : System.Address;
                            Stack_Size :  System.Storage_Elements.Integer_Address;
                            Thread_Id : out Thread_Id_Type;
                            Error : out Error_Type)
      with Export,
         Convention => C,
         External_Name => "hirtos_create_thread";

   --
   --  Return the Id of the current thread executing on the current CPU core,
   --  if that core is running in thread context, or the Id of the last thread
   --  prempted by an interrupt handler, if running in interrupt context.
   --
   function Get_Current_Thread_Id return Thread_Id_Type;

end HiRTOS.Thread;
