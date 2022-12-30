--
--  Copyright (c) 2021, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS compile-time configuration parameters
--
package HiRTOS_Config_Parameters
   with SPARK_Mode => On,
        No_Elaboration_Code_All
is
   --
   --  Maximum number of threads (total for all CPU cores)
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
   Thread_Stack_Min_Size_In_Bytes : constant := 1024;

   --
   --  RTOS tick timer period in microseconds
   --
   Tick_Period_Us : constant := 1000;

   --
   --  Thread time slice in RTOS ticks
   --
   Thread_Time_Slice_Ticks : constant := 1;

   --
   --  Global variables default access
   --
   type Global_Data_Default_Access_Type is
      (Global_Data_Privileged_Unprivileged_Read_Only_Access,
       Global_Data_Privileged_Read_Write_Unprivileged_No_Access,
       Global_Data_Privileged_Read_Only_Unprivileged_No_Access,
       Global_Data_Privileged_Unprivileged_Read_Write_Access);

   Global_Data_Default_Access : constant Global_Data_Default_Access_Type :=
      Global_Data_Privileged_Unprivileged_Read_Write_Access;

   type Global_Mmio_Default_Access_Type is
      (Global_Mmio_Privileged_Only_Access,
       Global_Mmio_Privileged_Unprivileged_Access);

   Global_Mmio_Default_Access : constant Global_Mmio_Default_Access_Type :=
      Global_Mmio_Privileged_Only_Access;

end HiRTOS_Config_Parameters;
