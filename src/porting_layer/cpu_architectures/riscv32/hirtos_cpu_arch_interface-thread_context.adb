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
with HiRTOS_Low_Level_Debug_Interface; --???
with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface.Thread_Context with SPARK_Mode => On is
   use ASCII;
   use HiRTOS_Cpu_Arch_Interface_Private;

   function Get_Global_Pointer return Cpu_Register_Type with
      Inline_Always, Suppress => All_Checks;

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
         (RA => Cpu_Register_Type (To_Integer (Thread_Unintended_Exit_Catcher'Address)),
          SP => Stack_End_Address - (Cpu_Context_Type'Object_Size / System.Storage_Unit),
          GP => Get_Global_Pointer,
          TP => (others => <>),
          T0 => 16#05050505#,
          T1 => 16#06060606#,
          T2 => 16#07070707#,
          FP => Stack_End_Address,
          S1 => 16#09090909#,
          A0 => Thread_Arg,
          A1 => 16#11111111#,
          A2 => 16#12121212#,
          A3 => 16#13131313#,
          A4 => 16#14141414#,
          A5 => 16#15151515#,
          A6 => 16#16161616#,
          A7 => 16#17171717#,
          S2 => 16#18181818#,
          S3 => 16#19191919#,
          S4 => 16#20202020#,
          S5 => 16#21212121#,
          S6 => 16#22222222#,
          S7 => 16#23232323#,
          S8 => 16#24242424#,
          S9 => 16#25252525#,
          S10 => 16#26262626#,
          S11 => 16#27272727#,
          T3 => 16#28282828#,
          T4 => 16#29292929#,
          T5 => 16#30303030#,
          T6 => 16#31313131#,
          MEPC => Entry_Point_Address,
          --
          --  NOTE: When a thread is switched, it is lie if returned from an exception/interrupt.
          --  So, when the mstatus register is restored, it ust indicate that interrupts are currently
          --  disabled but they will be re-enabled when the mret is executed (MPIE cpied to MIE).
          --  Also, when the mret is executed, the CPU goes to U-mode, since a thread must start
          --  executiong in unprivileged mode:
          --
          MSTATUS => (MIE => 0, MPIE => 1, MPP => Mstatus_Mpp_User_Mode, others => <>),
          --  Set mscratch to indicate that thread's privilege level is unprivileged
          MSCRATCH => 0);

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

   procedure Synchronous_Thread_Context_Switch
   is
   begin
      --
      --  Initiate a synchronous thread context switch by executing an ecall
      --  instruction from M-mode, to trigger an Ecall exception from M-mode.
      --
      System.Machine_Code.Asm (
         "ecall",
         Volatile => True);

      --
      --  NOTE: When the switched-out thread is resumed in the future, it will
      --  start executing right here.
      --
      --HiRTOS_Low_Level_Debug_Interface.Print_String ("*** JGR: After Synchronous_context_Switch" & ASCII.LF); --???
   end Synchronous_Thread_Context_Switch;

--
   --  Transitions the CPU from user-mode to sys-mode with interrupts
   --  enabled.
   --
   procedure Switch_Cpu_To_Privileged_Mode is
   begin
      --
      --  Switch to privileged mode:
      --
      System.Machine_Code.Asm (
         "ecall",
         Volatile => True);

      --
      --  NOTE: We returned here in privileged mode.
      --
      --HiRTOS_Low_Level_Debug_Interface.Print_String ("*** After going to privileged mode" & ASCII.LF); --???
   end Switch_Cpu_To_Privileged_Mode;

   --
   --  Transitions the CPU from machine-mode to user-mode with interrupts enabled.
   --
   procedure Switch_Cpu_To_Unprivileged_Mode
   is
      use type Interfaces.Unsigned_32;
   begin
      --  Switch to unprivileged mode:
      System.Machine_Code.Asm (
         --  Disable CPU interrupting, so that we don't get interrupted before executing mret:
         "csrrci t0, mstatus, %0" & LF &
         "fence.i" & LF &
         --  Update mscratch and tp to remember that we are going to be in unprivileged mode:
         "csrci mscratch, 0x1" & LF &
         "andi tp, tp, %3" & LF &
         --  Set exception return address to be the caller's return address:
         "csrw mepc, ra" & LF &
         --  t0 = mstatus
         --  Set mstatus.MPP to U-mode (00) and mstatus.MPIE to 1:
         "li   t1, %1" & LF &
         "and  t0, t0, t1" & LF &
         "ori  t0, t0, %2" & LF &
         "csrw mstatus, t0" & LF &
         --  return from exception:
        "mret",
         Inputs =>
            [Interfaces.Unsigned_32'Asm_Input ("g",
                                               MSTATUS_MIE_Bit_Mask), --  %0
             Interfaces.Unsigned_32'Asm_Input ("g",
                                               not MSTATUS_MPP_Bit_Mask), --  %1
             Interfaces.Unsigned_32'Asm_Input ("g",
               Interfaces.Shift_Left (Interfaces.Unsigned_32 (Mstatus_Mpp_User_Mode'Enum_Rep),
                                      MSTATUS_MPP_Bit_Offset) or MSTATUS_MPIE_Bit_Mask), --  %2
             Interfaces.Unsigned_32'Asm_Input ("g",
                                               not TP_Cpu_Running_In_Privileged_Mode_Bit_Mask)], --  %3
         Clobber => "t0, t1",
         Volatile => True);
   end Switch_Cpu_To_Unprivileged_Mode;

   function Get_Global_Pointer return Cpu_Register_Type  is
      GP_Value : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "mv %0, gp",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", GP_Value),
         Volatile => True);

      return GP_Value;
   end Get_Global_Pointer;

   function Get_Thread_Pointer return Thread_Pointer_Type is
      Thread_Pointer : Thread_Pointer_Type;
   begin
      System.Machine_Code.Asm (
         "mv %0, tp",
         Outputs => Thread_Pointer_Type'Asm_Output ("=r", Thread_Pointer),
         Volatile => True);

      return Thread_Pointer;
   end Get_Thread_Pointer;

   procedure Set_Thread_Pointer (Thread_Pointer : Thread_Pointer_Type) is
   begin
      System.Machine_Code.Asm (
         "mv tp, %0",
         Inputs => Thread_Pointer_Type'Asm_Input ("r", Thread_Pointer),
         Volatile => True);
   end Set_Thread_Pointer;

   function Get_MSCRATCH return Cpu_Register_Type  is
      MSCRATCH_Value : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "csrr %0, mscratch",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", MSCRATCH_Value),
         Volatile => True);

      return MSCRATCH_Value;
   end Get_MSCRATCH;

   procedure Set_Saved_PC (Cpu_Context : in out Cpu_Context_Type; PC_Value : Cpu_Register_Type)
   is
   begin
      Cpu_Context.MEPC := PC_Value;
   end Set_Saved_PC;

end HiRTOS_Cpu_Arch_Interface.Thread_Context;
