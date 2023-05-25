--
--  Copyright (c) 2021, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS compile-time configuration parameters
--

with HiRTOS_Platform_Parameters;

package HiRTOS_Config_Parameters
   with SPARK_Mode => On,
        No_Elaboration_Code_All
is
   --
   --  Maximum number of threads (total for all CPU cores)
   --
   Max_Num_Threads : constant := 32;

   pragma Compile_Time_Error
     (Max_Num_Threads < 2 * HiRTOS_Platform_Parameters.Num_Cpu_Cores,
      "Max_Num_Threads too small");

   --
   --  Maximum number of condition variables (not counting the condvar embedded
   --  in each thread)
   --
   Max_Num_Condvars : constant := 32;

   pragma Compile_Time_Error
     (Max_Num_Condvars < Max_Num_Threads,
      "Max_Num_Condvars too small");

   --
   --  Maximum number of mutexes
   --
   Max_Num_Mutexes : constant := 32;

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
   Tick_Timer_Period_Us : constant := 500;

   --
   --  Thread time slice in RTOS ticks
   --
   Thread_Time_Slice_Ticks : constant := 2;

   type Software_Timers_Bookkeeping_Method_Type is (Software_Timers_Bookkeeping_In_Timer_ISR,
                                                    Software_Timers_Bookkeeping_In_Timer_Thread);

   Software_Timers_Bookkeeping_Method : constant Software_Timers_Bookkeeping_Method_Type :=
      Software_Timers_Bookkeeping_In_Timer_ISR;

   --
   --  Global variables default access
   --
   type Global_Data_Default_Access_Type is
      (Global_Data_Privileged_Unprivileged_No_Access,
       Global_Data_Privileged_Access_Unprivileged_No_Access,
       Global_Data_Privileged_Unprivileged_Access);

   Global_Data_Default_Access : constant Global_Data_Default_Access_Type :=
      Global_Data_Privileged_Unprivileged_Access;

   type Global_Mmio_Default_Access_Type is
      (Global_Mmio_Privileged_Unprivileged_No_Access,
       Global_Mmio_Privileged_Access_Unprivileged_No_Access,
       Global_Mmio_Privileged_Unprivileged_Access);

   Global_Mmio_Default_Access : constant Global_Mmio_Default_Access_Type :=
      Global_Mmio_Privileged_Access_Unprivileged_No_Access;

end HiRTOS_Config_Parameters;
