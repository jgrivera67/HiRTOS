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

with HiRTOS_Platform_Parameters;
with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface.Thread_Context with SPARK_Mode => On is

   procedure Thread_Unintended_Exit_Catcher is
   begin
      raise Program_Error;
   end Thread_Unintended_Exit_Catcher;

   procedure Initialize_Thread_Cpu_Context (Thread_Cpu_Context : out Cpu_Context_Type;
                                            Entry_Point_Address : Cpu_Register_Type;
                                            Thread_Arg : Cpu_Register_Type;
                                            Stack_End_Address : Cpu_Register_Type) is
   begin
      Thread_Cpu_Context :=
         (SP => Cpu_Register_Type (To_Integer (Thread_Cpu_Context'Address)),
          R0 => Thread_Arg,
          R1 => 16#01010101#,
          R2 => 16#02020202#,
          R3 => 16#03030303#,
          R4 => 16#04040404#,
          R5 => 16#05050505#,
          R6 => 16#06060606#,
          R7 => Stack_End_Address, --  FP
          R8 => 16#08080808#,
          R9 => 16#09090909#,
          R10 => 16#10101010#,
          R11 => 16#11111111#,
          R12 => 16#12121212#,
          LR => Cpu_Register_Type (To_Integer (Thread_Unintended_Exit_Catcher'Address)),
          PC => Entry_Point_Address,
          XPSR => (As_Value => False, T => 1, others => <>),
          CONTROL => (nPRIV => 1, SPSEL => 1, others => 0));

   end Initialize_Thread_Cpu_Context;

   procedure First_Thread_Context_Switch is
      Old_Cpu_Interrupting : Cpu_Register_Type with Unreferenced;
      CONTROL_Value : CONTROL_Type;
      SP_Value : Cpu_Register_Type;
   begin
      --
      --  Pretend that we were executing in a thread (using PSP as the SP), and do
      --  a synchronous context switch to the first actual thread by triggering a
      --  PendSV exception. Also reset MSP to point to the bottom of ISR stack:
      --
      Old_Cpu_Interrupting := Disable_Cpu_Interrupting;
      SP_Value := Get_Stack_Pointer;
      Set_PSP_Register (Interfaces.Unsigned_32 (SP_Value));
      CONTROL_Value := Get_CONTROL_Register;
      CONTROL_Value.SPSEL := 1; --  Use PSP
      Set_Stack_Pointer (Cpu_Register_Type (To_Integer (
         HiRTOS_Platform_Parameters.Stacks_Section_End_Address))); -- MSP changed
      Set_CONTROL_Register (CONTROL_Value); -- PSP is now SP
      Trigger_PendSV_Exception;
      loop
         Wait_For_Interrupt;
      end loop;
   end First_Thread_Context_Switch;

   procedure Synchronous_Thread_Context_Switch
   is
   begin
      Trigger_PendSV_Exception;

      --
      --  NOTE: When the switched-out thread is resumed in the future, it will
      --  start executing right here.
      --
   end Synchronous_Thread_Context_Switch;

   --
   --  Transitions the CPU from unprivileged mode to privileged mode with interrupts
   --  enabled.
   --
   procedure Switch_Cpu_To_Privileged_Mode is
   begin
      --
      --  We are not in privileged mode, so interrupts must be enabled:
      --
      --  NOTE: It is a bug to be in non-privileged mode with interrupts disabled.
      --
      pragma Assert (not Cpu_Interrupting_Disabled);

      --
      --  Switch to privileged mode:
      --
      --  NOTE: The SVC exception handler sets `Cpu_Privileged_Nesting_Counter` to 1
      --
      System.Machine_Code.Asm (
         "svc #0",
         Volatile => True);

      --
      --  NOTE: We returned here in privileged mode.
      --
   end Switch_Cpu_To_Privileged_Mode;

   --
   --  Transitions the CPU from privileged mode to unprivileged mode with interrupts enabled.
   --
   procedure Switch_Cpu_To_Unprivileged_Mode is
      CONTROL_Value : CONTROL_Type := Get_CONTROL_Register;
   begin
      pragma Assert (not Cpu_Interrupting_Disabled);
      CONTROL_Value.nPRIV := 1; --  Unprivileged mode
      Set_CONTROL_Register (CONTROL_Value);
   end Switch_Cpu_To_Unprivileged_Mode;

   procedure Set_Saved_PC (Cpu_Context : in out Cpu_Context_Type; PC_Value : System.Address)
   is
   begin
      Cpu_Context.PC := Cpu_Register_Type (To_Integer (PC_Value));
   end Set_Saved_PC;

end HiRTOS_Cpu_Arch_Interface.Thread_Context;
