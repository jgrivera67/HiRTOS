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
with HiRTOS_Cpu_Arch_Interface_Private;
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
      Thread_Cpu_Context.Integer_Registers :=
         (R0 => Thread_Arg,
          R1 => 16#01010101#,
          R2 => 16#02020202#,
          R3 => 16#03030303#,
          R4 => 16#04040404#,
          R5 => 16#05050505#,
          R6 => 16#06060606#,
          R7 => 16#07070707#,
          R8 => 16#08080808#,
          R9 => 16#09090909#,
          R10 => 16#10101010#,
          R11 => Stack_End_Address, --  FP
          R12 => 16#12121212#,
          LR => Cpu_Register_Type (To_Integer (Thread_Unintended_Exit_Catcher'Address)),
          PC => Entry_Point_Address,
          CPSR => CPSR_User_Mode);

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
         "mov r0, #0" & LF &
         "svc #0",
         Clobber => "r0",
         Volatile => True);
   end Synchronous_Thread_Context_Switch;

   --
   --  Transitions the CPU from user-mode to sys-mode with interrupts
   --  enabled.
   --
   procedure Switch_Cpu_To_Privileged_Mode is
      CPSR_Value : constant Cpu_Register_Type := Get_Cpu_Status_Register;
   begin
         --
         --  We are not in privileged mode, so interrupts must be enabled:
         --
         --  NOTE: It is a bug to be in non-privileged mode with interrupts disabled.
         --
         pragma Assert ((CPSR_Value and CPSR_I_Bit_Mask) = 0);

         --
         --  Switch to privileged mode:
         --
         --  NOTE: The SVC exception handler sets `Cpu_Privileged_Nesting_Counter` to 1
         --
         System.Machine_Code.Asm (
            "mov r0, #1" & LF &
            "svc #0",
            Clobber => "r0",
            Volatile => True);

         --
         --  NOTE: We returned here in privileged mode.
         --
   end Switch_Cpu_To_Privileged_Mode;

   --
   --  Transitions the CPU from sys-mode to user-mode with interrupts enabled.
   --
   procedure Switch_Cpu_To_Unprivileged_Mode
   is
   begin
      --  Switch to unprivileged mode:
      System.Machine_Code.Asm (
         "cpsie i, %0" & LF &
         "isb",
         Inputs => Interfaces.Unsigned_8'Asm_Input ("g", CPSR_User_Mode), --  %0
         Volatile => True);
   end Switch_Cpu_To_Unprivileged_Mode;

   procedure Set_Saved_PC (Cpu_Context : in out Cpu_Context_Type; PC_Value : System.Address)
   is
   begin
      Cpu_Context.Integer_Registers.PC := Cpu_Register_Type (To_Integer (PC_Value));
   end Set_Saved_PC;
end HiRTOS_Cpu_Arch_Interface.Thread_Context;
