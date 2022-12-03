--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS target platform parameters
--

package HiRTOS_Platform_Parameters
   with SPARK_Mode => On,
        No_Elaboration_Code_All
is
   --
   --  Number of CPU cores
   --
   Num_Cpu_Cores : constant := 4;

   System_Clock_Frequency_Hz : constant := 100_000_000;

end HiRTOS_Platform_Parameters;
