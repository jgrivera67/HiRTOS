--
--  Copyright (c) 2021-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS compile-time configuration parameters
--

with HiRTOS_Platform_Parameters;

package HiRTOS_Config_Parameters
   with SPARK_Mode => On
is
   --
   --  Maximum number of threads per CPU core
   --
   Max_Num_Threads : constant := 32;

   pragma Compile_Time_Error
     (Max_Num_Threads <= 2,
      "Max_Num_Threads too small");

   --
   --  Maximum number of condition variables (not counting the condvar embedded
   --  in each thread)
   --
   Max_Num_Condvars : constant := 48;

   pragma Compile_Time_Error
     (Max_Num_Condvars < Max_Num_Threads,
      "Max_Num_Condvars too small");

   --
   --  Maximum number of mutexes
   --
   Max_Num_Mutexes : constant := 16;

   --
   --  Maximum number of timers
   --
   Max_Num_Timers : constant := 64;

   pragma Compile_Time_Error
     (Max_Num_Timers < Max_Num_Threads,
      "Max_Num_Timers too small");

   --
   --  Number of spokes of the Timer Wheel
   --
   Timer_Wheel_Num_Spokes : constant := 32;

   --
   --  Number of thread priorities
   --
   Num_Thread_Priorities : constant := 32;

   --
   --  Thread stack minimum size in bytes
   --
   Thread_Stack_Min_Size_In_Bytes : constant := 1024;

   --
   --  RTOS tick timer period in microseconds
   --
   Tick_Timer_Period_Us : constant :=
      (if HiRTOS_Platform_Parameters.Cpu_Clock_Frequency_Hz >= 500_000_000
       then 500
       else 1000);

   --
   --  Longest time that a thread can request to be delayed (by calling Thread_Delay_Until)
   --
   --  NOTE: Having this limit is necessary to be able to disambiguate if the RTOS tiock count
   --  has wrapped around or Thread_Delay_Until() has been called with a time point that is
   --  already in the past (which would be a sing that a thread is missing its dealines or starving)
   --
   Max_Thread_Delay_Us : constant := 3600_000_000;

   --
   --  Thread time slice in RTOS ticks
   --
   Thread_Time_Slice_Ticks : constant := 2;

   type Software_Timers_Bookkeeping_Method_Type is (Software_Timers_Bookkeeping_In_Timer_ISR,
                                                    Software_Timers_Bookkeeping_In_Timer_Thread);

   Software_Timers_Bookkeeping_Method : constant Software_Timers_Bookkeeping_Method_Type :=
      Software_Timers_Bookkeeping_In_Timer_ISR;

end HiRTOS_Config_Parameters;
