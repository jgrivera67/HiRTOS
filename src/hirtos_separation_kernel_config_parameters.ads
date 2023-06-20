--
--  Copyright (c) 2021, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS separation kernel compile-time configuration parameters
--

package HiRTOS_Separation_Kernel_Config_Parameters
   with SPARK_Mode => On,
        No_Elaboration_Code_All
is
   --
   --  Maximum number of partitions per CPU core
   --
   Max_Num_Partitions : constant := 4;

   --
   --  Separation kernel's tick timer period in microseconds
   --
   Tick_Timer_Period_Us : constant := 500;

   --
   --  Partition time slice in timer ticks
   --
   Partition_Time_Slice_Ticks : constant := 1;

end HiRTOS_Separation_Kernel_Config_Parameters;
