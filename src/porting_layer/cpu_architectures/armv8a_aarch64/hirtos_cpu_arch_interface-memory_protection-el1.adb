--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Memory protection services
--  for ARMv8-A EL1 MPU
--

with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface.Memory_Protection.EL1 with SPARK_Mode => Off is

   function Get_MAIR return MAIR_Type is
      MAIR_Value : MAIR_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, mair_el1",
         Outputs => Interfaces.Unsigned_64'Asm_Output ("=r", MAIR_Value.Value), --  %0
         Volatile => True);

      return MAIR_Value;
   end Get_MAIR;

   procedure Set_MAIR (MAIR_Value : MAIR_Type) is
   begin
      System.Machine_Code.Asm (
         "msr mair_el1, %0",
         Inputs => Interfaces.Unsigned_64'Asm_Input ("r", MAIR_Value.Value), --  %0
         Volatile => True);
   end Set_MAIR;

   function Get_TCR return TCR_Type is
      TCR_Value : TCR_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, tcr_el1",
         Outputs => TCR_Type'Asm_Output ("=r", TCR_Value), --  %0
         Volatile => True);

      return TCR_Value;
   end Get_TCR;

   procedure Set_TCR (TCR_Value : TCR_Type) is
   begin
      System.Machine_Code.Asm (
         "msr tcr_el1, %0",
         Inputs => TCR_Type'Asm_Input ("r", TCR_Value), --  %0
         Volatile => True);
   end Set_TCR;

   function Get_TTBR0 return TTBRn_Type is
      TTBR0_Value : TTBRn_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, ttbr0_el1",
         Outputs => TTBRn_Type'Asm_Output ("=r", TTBR0_Value), --  %0
         Volatile => True);

      return TTBR0_Value;
   end Get_TTBR0;

   procedure Set_TTBR0 (TTBR0_Value : TTBRn_Type) is
   begin
      System.Machine_Code.Asm (
         "msr ttbr0_el1, %0",
         Inputs => TTBRn_Type'Asm_Input ("r", TTBR0_Value), --  %0
         Volatile => True);
   end Set_TTBR0;

   function Get_TTBR1 return TTBRn_Type is
      TTBR1_Value : TTBRn_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, ttbr1_el1",
         Outputs => TTBRn_Type'Asm_Output ("=r", TTBR1_Value), --  %0
         Volatile => True);

      return TTBR1_Value;
   end Get_TTBR1;

   procedure Set_TTBR1 (TTBR1_Value : TTBRn_Type) is
   begin
      System.Machine_Code.Asm (
         "msr ttbr1_el1, %0",
         Inputs => TTBRn_Type'Asm_Input ("r", TTBR1_Value), --  %0
         Volatile => True);
   end Set_TTBR1;

   procedure Invalidate_TLB is
   begin
      System.Machine_Code.Asm (
         "tlbi vmalle1",
         Clobber => "memory",
         Volatile => True);
   end Invalidate_TLB;

   procedure Enable_MMU is
      use System_Registers;
      SCTLR_Value : SCTLR_EL1_Type;
      Old_Cpu_Interrupting_State : constant Cpu_Register_Type :=
         HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
   begin
      Strong_Memory_Barrier;
      Invalidate_TLB;
      Strong_Memory_Barrier;
      SCTLR_Value := Get_SCTLR_EL1;
      SCTLR_Value.M := MMU_Enabled;
      SCTLR_Value.A :=  Alignment_Check_Enabled;
      SCTLR_Value.SA0 := SP_EL0_Alignment_Check_Enabled;
      --  NOTE: We don't set SA, because we never initialize SP_EL1
      --  SCTLR_Value.SA := SP_EL1_Alignment_Check_Enabled;

      --
      --  NOTE: SPAN needs to be disabled, otherwise exceptions will not work on Cortex-A76.
      --  Cortex-A72 (ARMv8.0-A) does not support PAN (Privileged Access Never), but
      --  cortex-A76 (ARMv8.2-A) does and SCTLR_EL1.SPAN is enabled by default.
      --  When SPAN is enabled, PSTATE.PAN is set when entering an EL1 exception.
      --  When PSTATE.PAN is enabled, accessing any memory at that is accessible from EL0,
      --  while running at EL1, will cause memory access fault.
      --  Since the ISR stack is accessible from EL0 (to support going to EL0 in the reset
      --  handler), having SPAN enabled will cause the ISR stack not being accessible
      --  when taking EL1 exceptions.
      --
      SCTLR_Value.SPAN := Set_Privileged_Access_Never_Disabled;

      Set_SCTLR_EL1 (SCTLR_Value);
      Strong_Memory_Barrier;
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);
   end Enable_MMU;

   procedure Disable_MMU is
      use System_Registers;
      SCTLR_Value : SCTLR_EL1_Type;
      Old_Cpu_Interrupting_State : constant Cpu_Register_Type :=
         HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
   begin
      Strong_Memory_Barrier;
      SCTLR_Value := Get_SCTLR_EL1;
      SCTLR_Value.M := MMU_Disabled;
      Set_SCTLR_EL1 (SCTLR_Value);
      Strong_Memory_Barrier;
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);
   end Disable_MMU;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection.EL1;
