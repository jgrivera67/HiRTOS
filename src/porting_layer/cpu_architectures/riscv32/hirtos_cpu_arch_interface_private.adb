--
--  Copyright (c) 2024, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target CPU architecture interface - private declarations
--

with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface_Private is

   function Get_MISA return MISA_Type is
      MISA_Value : MISA_Type;
   begin
      System.Machine_Code.Asm (
         "csrr  %0, misa",
         Outputs => MISA_Type'Asm_Output ("=r", MISA_Value),
         Volatile => True);

      return MISA_Value;
   end Get_MISA;

end HiRTOS_Cpu_Arch_Interface_Private;