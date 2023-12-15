--
--  Copyright (c) 2021-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
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
   Tick_Timer_Period_Us : constant := 10_000; --??? 1000

   --
   --  Partition time slice in timer ticks
   --
   Partition_Time_Slice_Ticks : constant := 1;

   Partitions_Share_Tick_Timer : constant Boolean := True;

   Separation_Kernel_Debug_Tracing_On : constant Boolean := False;

end HiRTOS_Separation_Kernel_Config_Parameters;
