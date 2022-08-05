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

--
--  @summary HiRTOS compile-time configuration parameters
--
package HiRTOS_Config_Parameters with SPARK_Mode => On is
   --
   --  Maximum number of threads
   --
   Max_Num_Threads : constant := 32;

   --
   --  Maximum number of condition variables (not counting the condvar embedded
   --  in each thread)
   --
   Max_Num_Condvars : constant := 32;

   --
   --  Maximum number of mutexes
   --
   Max_Num_Mutexes : constant := 32;

   --
   --  Maximum number of timers
   --
   Max_Num_Timers : constant := 32;

   --
   --  Number of thread priorities
   --
   Num_Thread_Priorities : constant := 32;

   --
   --  Thread stack minimum size in bytes
   --
   Thread_Stack_Min_Size : constant := 1024;

   --
   --  RTOS tick timer period in microseconds
   --
   Tick_Period_Us : constant := 1000;

   --
   --  Thread time slice in RTOS ticks
   --
   Thread_Time_Slice_Ticks : constant := 1;

end HiRTOS_Config_Parameters;
