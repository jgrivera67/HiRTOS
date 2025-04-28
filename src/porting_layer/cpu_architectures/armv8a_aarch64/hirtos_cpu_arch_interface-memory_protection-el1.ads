--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary ARMv8-A EL1-controlled MPU
--

private package HiRTOS_Cpu_Arch_Interface.Memory_Protection.EL1
   with SPARK_Mode => On
is
   function Get_MAIR return MAIR_Type
      with Inline_Always;

   procedure Set_MAIR (MAIR_Value : MAIR_Type)
      with Inline_Always;

   function Get_TCR return TCR_Type
      with Inline_Always;

   procedure Set_TCR (TCR_Value : TCR_Type)
      with Inline_Always;

   function Get_TTBR0 return TTBRn_Type
      with Inline_Always;

   procedure Set_TTBR0 (TTBR0_Value : TTBRn_Type)
      with Inline_Always;

   function Get_TTBR1 return TTBRn_Type
      with Inline_Always;

   procedure Set_TTBR1 (TTBR1_Value : TTBRn_Type)
      with Inline_Always;

   procedure Invalidate_TLB with
      Pre => CPU_In_Privileged_Mode;

   procedure Enable_MMU with
      Pre => CPU_In_Privileged_Mode and then
             CPU_Interrupting_Disabled;

   procedure Disable_MMU with
      Pre => CPU_In_Privileged_Mode and then
             CPU_Interrupting_Disabled;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection.EL1;
