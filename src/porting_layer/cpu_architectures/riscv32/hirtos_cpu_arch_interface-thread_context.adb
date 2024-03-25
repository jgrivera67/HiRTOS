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

package body HiRTOS_Cpu_Arch_Interface.Thread_Context with SPARK_Mode => On is
   use ASCII;
   use System.Storage_Elements;
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
          --  Enable interrupts at the CPU when switching thread in, and start in unprivileged mode:
          MSTATUS => (MPIE => 1, MPP => Mstatus_Mpp_User_Mode, others => <>),
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

   procedure Synchronous_Thread_Context_Switch -- with Inline_Never
   is
      use type Interfaces.Unsigned_32;
   begin
      --
      --  Set mstatus.MPIE to interrupts disabled and mstatus.MPP to M-mode (as
      --  the calling context has interrupts disabled and is in M-mode):
      --
      System.Machine_Code.Asm (
         "li t0, %0" & LF &
         "csrc mstatus, t0" & LF &
         "li t1, %1" & LF &
         "csrs mstatus, t1" & LF &
         --
         --  Set exception return address to be the caller's return address:
         --
         --  NOTE: The calling context will be resumed in the future as if it
         --  were returning from a call to this routine:
         --
         "csrw mepc, ra",
         Inputs =>
            [Interfaces.Unsigned_32'Asm_Input ("g",
               MSTATUS_MPIE_Bit_Mask or MSTATUS_MPP_Bit_Mask),  --  %0
             Interfaces.Unsigned_32'Asm_Input ("g",
               Interfaces.Shift_Left (
                  Interfaces.Unsigned_32 (HiRTOS_Cpu_Arch_Interface.Thread_Context.Mstatus_Mpp_Machine_Mode'Enum_Rep),
                  MSTATUS_MPP_Bit_Offset))], -- %1
         Clobber => "t0, t1",
         Volatile => True);

      --
      --  NOTE: At this point we are like if we would have come here as a result
      --  of a synchronoous exception
      --

      --  Save the current thread's CPU state on its own stack
      HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Interrupt_Handler_Prolog;

      --  Run the thread scheduler to select next thread to run and
      --  resume execution of the newly selected thread
      HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Interrupt_Handler_Epilog;
   end Synchronous_Thread_Context_Switch;

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

end HiRTOS_Cpu_Arch_Interface.Thread_Context;
