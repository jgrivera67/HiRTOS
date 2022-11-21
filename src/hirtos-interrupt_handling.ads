--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

package HiRTOS.Interrupt_Handling
   with SPARK_Mode => On
is

   procedure Enter_Interrupt_Context
      with Inline_Always,
           Suppress => All_Checks;

   procedure Exit_Interrupt_Context
      with Inline_Always,
           Suppress => All_Checks;

end HiRTOS.Interrupt_Handling;
