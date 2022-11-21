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

end HiRTOS_Platform_Parameters;
