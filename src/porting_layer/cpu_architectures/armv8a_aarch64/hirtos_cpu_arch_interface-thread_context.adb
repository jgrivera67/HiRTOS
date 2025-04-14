--
--  Copyright (c) 2022-2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target platform interface - Thread CPU context
--  for ARMv8-R architecture
--

with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface.Thread_Context with SPARK_Mode => Off is

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

   procedure Synchronous_Thread_Context_Switch is
   begin
      --
      --  Initiate a synchronous thread context switch by doing
      --  a Supervisor call with immediate 0
      --
      System.Machine_Code.Asm (
         "svc #0",
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
         --  Switch to privileged mode by making a supervisor call with immediate 1:
         --
         --  NOTE: The SVC exception handler sets `Cpu_Privileged_Nesting_Counter` to 1
         --
         System.Machine_Code.Asm (
            "svc #1",
            Volatile => True);

         --
         --  NOTE: We returned here in privileged mode.
         --
   end Switch_Cpu_To_Privileged_Mode;

   procedure Set_Saved_PC (Cpu_Context : in out Cpu_Context_Type; PC_Value : System.Address)
   is
   begin
      Cpu_Context.Integer_Registers.PC := Cpu_Register_Type (To_Integer (PC_Value));
   end Set_Saved_PC;
end HiRTOS_Cpu_Arch_Interface.Thread_Context;
