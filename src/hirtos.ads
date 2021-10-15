--
--  Copyright (c) 2021, German Rivera
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

with System;
with Interfaces;
with HiRTOS_Parameters;

--
--  @summary HiRTOS interface
--
package HiRTOS with SPARK_Mode => On is
   use type Interfaces.Unsigned_16;

   type Thread_Id_Type is range 0 .. HiRTOS_Parameters.Max_Num_Threads
      with Size => Interfaces.Unsigned_8'Size;

   subtype Valid_Thread_Id_Type is
      Thread_Id_Type range 1 .. HiRTOS_Parameters.Max_Num_Threads;

   Invalid_Thread_Id : constant Thread_Id_Type := 0;

   type Condvar_Id_Type is range 0 .. HiRTOS_Parameters.Max_Num_Condvars
      with Size => Interfaces.Unsigned_8'Size;

   subtype Valid_Condvar_Id_Type is
      Condvar_Id_Type range 1 .. HiRTOS_Parameters.Max_Num_Condvars;

   Invalid_Condvar_Id : constant Condvar_Id_Type := 0;

   type Mutex_Id_Type is range 0 .. HiRTOS_Parameters.Max_Num_Mutexes
      with Size => Interfaces.Unsigned_8'Size;

   subtype Valid_Mutex_Id_Type is
      Mutex_Id_Type range 1 .. HiRTOS_Parameters.Max_Num_Mutexes;

   Invalid_Mutex_Id : constant Mutex_Id_Type := 0;

   type Timer_Id_Type is range 0 .. HiRTOS_Parameters.Max_Num_Timers
      with Size => Interfaces.Unsigned_8'Size;

   subtype Valid_Timer_Id_Type is
      Timer_Id_Type range 1 .. HiRTOS_Parameters.Max_Num_Timers;

   Invalid_Timer_Id : constant Timer_Id_Type := 0;

   type Thread_Priority_Type is
      range 0 .. HiRTOS_Parameters.Num_Thread_Priorities - 1
      with Size => Interfaces.Unsigned_8'Size;

   subtype Thread_Stack_Size_Type is Interfaces.Unsigned_16 with
      Dynamic_Predicate =>
         Thread_Stack_Size_Type >= HiRTOS_Parameters.Thread_Stack_Min_Size
         or else
         Thread_Stack_Size_Type = 0;

   --
   --  NOTE: Lower value means higher priority
   --
   Lowest_Thread_Prioritiy :
      constant Thread_Priority_Type := Thread_Priority_Type'Last;
   Highest_Thread_Prioritiy :
      constant Thread_Priority_Type := Thread_Priority_Type'First;

   type Time_Us_Type is new Interfaces.Unsigned_32;

   type Time_Ms_Type is new Interfaces.Unsigned_32;

   type Error_Type is new System.Address;

   --
   --  Start RTOS tick timer and RTOS thread scheduler for the calling CPU
   --
   procedure Rtos_Start_Thread_Scheduler
      with Export,
         Convention => C,
         External_Name => "hirtos_start_thread_scheduler";

   type Thread_entry_Point_Type is access procedure (Arg : System.Address)
         with Convention => C;

   --
   --  Create new thread
   --
   procedure Create_Thread (Entry_Point : Thread_entry_Point_Type;
                            Priority : Thread_Priority_Type;
                            Stack_Addr : System.Address;
                            Stack_Size : Interfaces.Unsigned_32;
                            Thread_Id : out Thread_Id_Type;
                            Error : out Error_Type)
   with Export,
        Convention => C,
        External_Name => "hirtos_create_thread";

end HiRTOS;
