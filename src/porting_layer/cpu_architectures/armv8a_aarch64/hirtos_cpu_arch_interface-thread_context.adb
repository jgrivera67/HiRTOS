--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target platform interface - Thread CPU context
--  for ARMv8-R architecture
--

with HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface.Thread_Context with SPARK_Mode => Off is
   use ASCII;
   use HiRTOS_Cpu_Arch_Interface_Private;

   procedure Thread_Unintended_Exit_Catcher is
   begin
      raise Program_Error;
   end Thread_Unintended_Exit_Catcher;

   procedure Initialize_Thread_Cpu_Context (Thread_Cpu_Context : out Cpu_Context_Type;
                                            Entry_Point_Address : Cpu_Register_Type;
                                            Thread_Arg : Cpu_Register_Type;
                                            Stack_End_Address : Cpu_Register_Type) is
   begin
      Thread_Cpu_Context.Floating_Point_Registers := (others => <>);
      Thread_Cpu_Context.Integer_Registers := (
          PC => Entry_Point_Address,
          SPSR => (As_Value => False, SPSel => SP_EL0, CurrentEL => EL0, M => Execution_State_AArch64,
                   DAIF => (D => Interrupt_Enabled, A => Interrupt_Enabled,
                            I => Interrupt_Enabled, F => Interrupt_Enabled),
                   others => <>),
          X0 => Thread_Arg,
          X1 => 16#0101_0101_0101_0101#,
          X2 => 16#0202_0202_0202_0202#,
          X3 => 16#0303_0303_0303_0303#,
          X4 => 16#0404_0404_0404_0404#,
          X5 => 16#0505_0505_0505_0505#,
          X6 => 16#0606_0606_0606_0606#,
          X7 => 16#0707_0707_0707_0707#,
          X8 => 16#0808_0808_0808_0808#,
          X9 => 16#0909_0909_0909_0909#,
          X10 => 16#1010_1010_1010_1010#,
          X11 => 16#1111_1111_1111_1111#,
          X12 => 16#1212_1212_1212_1212#,
          X13 => 16#1313_1313_1313_1313#,
          X14 => 16#1414_1414_1414_1414#,
          X15 => 16#1515_1515_1515_1515#,
          X16 => 16#1616_1616_1616_1616#,
          X17 => 16#1717_1717_1717_1717#,
          X18 => 16#1818_1818_1818_1818#,
          X19 => 16#1919_1919_1919_1919#,
          X20 => 16#2020_2020_2020_2020#,
          X21 => 16#2121_2121_2121_2121#,
          X22 => 16#2222_2222_2222_2222#,
          X23 => 16#2323_2323_2323_2323#,
          X24 => 16#2424_2424_2424_2424#,
          X25 => 16#2525_2525_2525_2525#,
          X26 => 16#2626_2626_2626_2626#,
          X27 => 16#2727_2727_2727_2727#,
          X28 => 16#2828_2828_2828_2828#,
          X29 => Stack_End_Address, --  FP
          X30 => Cpu_Register_Type (To_Integer (Thread_Unintended_Exit_Catcher'Address)), --  LR
          others => <>
      );
   end Initialize_Thread_Cpu_Context;

   procedure First_Thread_Context_Switch is
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type with Unreferenced;
   begin
      --
      --  NOTE: To start executing the first thread, we pretend that we are returning from an
      --  interrupt, since before RTOS tasking is started, we have been executing in the reset
      --  exception handler.
      --
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
      HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Interrupt_Handler_Epilog;
   end First_Thread_Context_Switch;

   procedure Synchronous_Thread_Context_Switch is
   begin
      --
      --  Initiate a synchronous thread context switch by doing
      --  a Supervisor call, passing 0 in r0
      --
      System.Machine_Code.Asm (
         "mov x0, #0" & LF &
         "svc #0",
         Clobber => "x0",
         Volatile => True);
   end Synchronous_Thread_Context_Switch;

   --
   --  Transitions the CPU from user-mode to sys-mode with interrupts
   --  enabled.
   --
   procedure Switch_Cpu_To_Privileged_Mode is
      DAIF_Value : constant DAIF_Type := Get_DAIF;
   begin
         --
         --  We are not in privileged mode, so interrupts must be enabled:
         --
         --  NOTE: It is a bug to be in non-privileged mode with interrupts disabled.
         --
         pragma Assert (DAIF_Value.I = Interrupt_Enabled);

         --
         --  Switch to privileged mode:
         --
         --  NOTE: The SVC exception handler sets `Cpu_Privileged_Nesting_Counter` to 1
         --
         System.Machine_Code.Asm (
            "mov x0, #1" & LF &
            "svc #0",
            Clobber => "x0",
            Volatile => True);

         --
         --  NOTE: We returned here in privileged mode.
         --
   end Switch_Cpu_To_Privileged_Mode;

   --
   --  Transitions the CPU from EL1 (privileged mode) to EL0 (unprivileged mode) with interrupts enabled.
   --
   procedure Switch_Cpu_To_Unprivileged_Mode is
      SPSR_Value : constant PSTATE_Type :=
         (As_Value => True, SPSel => SP_EL0, CurrentEL => EL0, M => Execution_State_AArch64,
          DAIF => (D => Interrupt_Enabled, A => Interrupt_Enabled,
                   I => Interrupt_Enabled, F => Interrupt_Enabled),
          others => <>);
   begin
      --
      --  Transition from EL1 to EL0, by returning from an EL1 exception into EL0.
      --  Return to EL0 with all exceptions/interrupts enabled and using SP_EL0 stack pointer.
      --
      System.Machine_Code.Asm (
         --  Disable CPU interrupting, so that we don't get interrupted before executing eret:
         "msr DAIFset, %0" & LF &
         "isb" & LF &
         --  Set exception return address to be the caller's return address:
         "msr elr_el1, lr" & LF &
         --  SPSR_EL1 to El0, SP_EL0, interrupts enabled:
         "msr spsr_el1, %1" & LF &
         --  return from exception:
        "eret",
         Inputs =>
            [Interfaces.Unsigned_8'Asm_Input ("g", DAIF_SetClr_IF_Mask),  --  %0
             Interfaces.Unsigned_64'Asm_Input ("r", SPSR_Value)], --  %1
         Volatile => True);
   end Switch_Cpu_To_Unprivileged_Mode;

   procedure Set_Saved_PC (Cpu_Context : in out Cpu_Context_Type; PC_Value : System.Address)
   is
   begin
      Cpu_Context.Integer_Registers.PC := Cpu_Register_Type (To_Integer (PC_Value));
   end Set_Saved_PC;
end HiRTOS_Cpu_Arch_Interface.Thread_Context;
