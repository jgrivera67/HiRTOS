--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
--

--
--  @summary RTOS to target platform interface for ARMv7-R architecture
--

with System.Machine_Code;
with Interfaces;
with HiRTOS;

package body HiRTOS_Platform_Interface with SPARK_Mode => On is
   use ASCII;

   --
   --   Bit masks for CPSR bit fields
   --
   --  CPSR_F_Bit_Mask : constant := 2#0100_0000#; --  bit 6
   CPSR_I_Bit_Mask : constant := 2#1000_0000#; --  bit 7
   CPSR_Mode_Mask : constant :=  2#0001_1111#; --  bits [4:0]

   --
   --  Values for CPSR mode field
   --
   CPSR_User_Mode : constant :=           2#1_0000#;
   --  CPSR_Fast_Interrupt_Mode : constant := 2#1_0010#;
   --  CPSR_Supervisor_Mode : constant :=     2#1_0011#;
   --  CPSR_Abort_Mode : constant :=          2#1_0111#;
   --  CPSR_Undefined_Mode : constant :=      2#1_1011#;
   CPSR_System_Mode : constant :=         2#1_1111#;

   procedure Prefetch_Abort_Exception_App_Handler
      with Import,
           Convention => C,
           External_Name => "prefetch_abort_exception_app_handler";

   procedure Data_Abort_Exception_App_Handler
      with Import,
           Convention => C,
           External_Name => "data_abort_exception_app_handler";

   procedure External_Interrupt_App_Handler
      with Import,
           Convention => C,
           External_Name => "external_interrupt_app_handler";

   function Get_Cpu_Id return Cpu_Core_Id_Type is
      --  For now support only single CPU systems
      (Cpu_Core_Id_Type'First);

   function Get_Cpu_Status_Register return Cpu_Register_Type is
      Reg_Value : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, cpsr",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", Reg_Value),
         Volatile => True);

      return Reg_Value;
   end Get_Cpu_Status_Register;

   function Get_Call_Address return System.Address is
      Reg_Value : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "mov %0, lr",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", Reg_Value),
         Volatile => True);

      return System.Storage_Elements.To_Address (
               System.Storage_Elements.Integer_Address (
                  Reg_Value - HiRTOS_Platform_Parameters.Call_Instruction_Size));
   end Get_Call_Address;

   function Get_Stack_Pointer return Cpu_Register_Type is
      Stack_Pointer : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "mov %0, sp",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", Stack_Pointer),
         Volatile => True);

      return Stack_Pointer;
   end Get_Stack_Pointer;

   procedure Set_Stack_Pointer (Stack_Pointer : Cpu_Register_Type) is
   begin
      System.Machine_Code.Asm (
         "mov sp, %0",
         Inputs => Cpu_Register_Type'Asm_Input ("r", Stack_Pointer),
         Volatile => True);
   end Set_Stack_Pointer;

   function Cpu_Interrupting_Disabled return Boolean is
      CPSR_Value : constant Cpu_Register_Type := Get_Cpu_Status_Register;
   begin
      return (CPSR_Value and CPSR_I_Bit_Mask) /= 0;
   end Cpu_Interrupting_Disabled;

   function Disable_Cpu_Interrupting return Cpu_Register_Type
   is
      CPSR_Value : constant Cpu_Register_Type := Get_Cpu_Status_Register;
   begin
      if (CPSR_Value and CPSR_I_Bit_Mask) = 0 then
         System.Machine_Code.Asm (
            "cpsid i" & LF &
            "dsb" & LF &
            "isb",
            Clobber => "memory",
            Volatile => True);
      end if;

      pragma Assert (Cpu_Interrupting_Disabled);
      return CPSR_Value;
   end Disable_Cpu_Interrupting;

   procedure Restore_Cpu_Interrupting (Old_Cpu_Interrupting : Cpu_Register_Type) is
   begin
      if (Old_Cpu_Interrupting and CPSR_I_Bit_Mask) = 0 then
         System.Machine_Code.Asm (
            "dsb" & LF &
            "isb" & LF &
            "cpsie i",
            Clobber => "memory",
            Volatile => True);
      end if;
   end Restore_Cpu_Interrupting;

   function Cpu_In_Privileged_Mode return Boolean is
      CPSR_Value : constant Cpu_Register_Type := Get_Cpu_Status_Register;
   begin
      return (CPSR_Value and CPSR_Mode_Mask) /= CPSR_User_Mode;
   end Cpu_In_Privileged_Mode;

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

   function Ldrex_Word (Word_Address : System.Address) return Cpu_Register_Type is
      Result : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
          "ldrex %0, [%1]",
           Outputs => Cpu_Register_Type'Asm_Output ("=r", Result), --  %0
           Inputs => System.Address'Asm_Input ("r", Word_Address), --  %1
           Volatile => True);

      return Result;
   end Ldrex_Word;

   function Strex_Word (Word_Address : System.Address;
                        Value : Cpu_Register_Type) return Boolean
   is
      Result : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm ("strex %0, %1, [%2]",
           Outputs =>
              Cpu_Register_Type'Asm_Output ("=r", Result),    -- %0
           Inputs =>
              (Cpu_Register_Type'Asm_Input ("r", Value),      -- %1
               System.Address'Asm_Input ("r", Word_Address)), -- %2
           Clobber => "memory",
           Volatile => True);

      return Result = 0;
   end Strex_Word;

   function Atomic_Fetch_Add
     (Counter_Address : System.Address;
      Value : Cpu_Register_Type) return Cpu_Register_Type
   is
      Old_Value : Cpu_Register_Type;
   begin
      loop
         Old_Value := Ldrex_Word (Counter_Address);
         exit when Strex_Word (Counter_Address, Old_Value + Value);
      end loop;

      return Old_Value;
   end Atomic_Fetch_Add;

   function Atomic_Fetch_Sub
     (Counter_Address : System.Address;
      Value : Cpu_Register_Type) return Cpu_Register_Type
   is
      Old_Value : Cpu_Register_Type;
   begin
      loop
         Old_Value := Ldrex_Word (Counter_Address);
         exit when Strex_Word (Counter_Address, Old_Value - Value);
      end loop;

      return Old_Value;
   end Atomic_Fetch_Sub;

   procedure Do_Synchronous_Context_Switch
      with Export,
           External_Name => "do_synchronous_context_switch";
   pragma Machine_Attribute (Do_Synchronous_Context_Switch, "naked");

   procedure Handle_Invalid_SVC_Exception
      with Export,
           External_Name => "handle_invalid_svc_exception";
   pragma Machine_Attribute (Handle_Invalid_SVC_Exception, "naked");

   procedure Interrupt_Handler_Prolog
      with Inline_Always;

   procedure Interrupt_Handler_Epilog
      with Inline_Always;

   procedure First_Thread_Context_Switch is
   begin
      --
      --  NOTE: To start executing the first thread, we pretend that we are returning from an
      --  interrupt, since before RTOS tasking is started, we have executing in the reset exception
      --  handler.
      --
      Interrupt_Handler_Epilog;
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
   --  SVC instruction exception handler
   --
   --  Register r0 indicates the action to perform:
   --  - 0 perform RTOS task synchronous context switch
   --  - 1 switch to privileged mode and return to the caller
   --
   --  CAUTION: This subprogram cannot use any stack space as we
   --  do not define a stack for SVC mode.
   --
   procedure Supervisor_Call_Exception_Handler is
   begin
      System.Machine_Code.Asm (
         --  TODO: Change to get the SVC instruction immediate operand
         --  "ldr r0, [lr, #-4]" & LF &
         --  "ubfx r0, r0, #0, #24" & LF &
         "teq r0, #0" & LF & --  RTOS synchronous task context switch?
         "beq do_synchronous_context_switch" & LF &
         "teq r0, #1" & LF & --  Enter_Cpu_Privileged_Mode call?
         "beq stay_in_cpu_privileged_mode" & LF &
         "b handle_invalid_svc_exception",
         Clobber => "r0",
         Volatile => True);
   end Supervisor_Call_Exception_Handler;

   --
   --  CAUTION: This subprogram cannot use any stack space, before
   --  it calls Interrupt_Hanlder_Prolog, as we do not define a stack
   --  for SVC mode.
   --
   procedure Do_Synchronous_Context_Switch is
   begin
      --  Save the current thread's CPU state on its own stack
      Interrupt_Handler_Prolog;

      --  Run the thread scheduler to select next thread to run and
      --  resume execution of the newly selected thread
      Interrupt_Handler_Epilog;
   end Do_Synchronous_Context_Switch;

   procedure Prefetch_Abort_Exception_Handler is
   begin
      --
      --  NOTE: We cannot call Interrupt_Handler_Prolog to save the
      --  current thread's CPU state on its own stack, because if the
      --  data abort is caused by a stack overflow, that will cause another
      --  data abort (recursively)
      --
      --  TODO: Set up abort mode stack in the reset handler
      --
      Prefetch_Abort_Exception_App_Handler;
      raise Program_Error;
   end Prefetch_Abort_Exception_Handler;

   procedure Data_Abort_Exception_Handler is
   begin
      --
      --  NOTE: We cannot call Interrupt_Handler_Prolog to save the
      --  current thread's CPU state on its own stack, because if the
      --  data abort is caused by a stack overflow, that will cause another
      --  data abort (recursively).
      --
      --  TODO: Set up abort mode stack in the reset handler
      --
      Data_Abort_Exception_App_Handler;
      raise Program_Error;
   end Data_Abort_Exception_Handler;

   procedure External_Interrupt_Handler is
   begin
      --
      --  Adjust lr to point to the instruction we need to return to after
      --  handling the interrupt (see table B1-7, section B1.8.3 in ARMv7-AR ARM)
      --
      System.Machine_Code.Asm (
         "sub lr, lr, %0",
         Inputs =>
            (Interfaces.Unsigned_8'Asm_Input ("g",
                                              HiRTOS_Platform_Parameters.Int_Register_Size)), -- %0
         Volatile => True);

      --  Save the current thread's CPU state on its own stack
      Interrupt_Handler_Prolog;

      External_Interrupt_App_Handler;

      --  Run the thread scheduler to select next thread to run and
      --  resume execution of the newly selected thread
      Interrupt_Handler_Epilog;
   end External_Interrupt_Handler;

   procedure Handle_Invalid_SVC_Exception is
   begin
      null; -- ???
   end Handle_Invalid_SVC_Exception;

   --
   --  Inline subprogram to be invoked at the beginning of top-level interrupt handlers from
   --  which the RTOS scheduler can be called upon exit.
   --
   --  This subprogram first switches the CPU mode to system mode, so that the SYS/USR
   --  stack pointer is used, instead of corresponding exception CPU mode stack
   --  pointer. Then it saves all general purpose registers on the stack. All registers
   --  need to be saved (both caller-saved and callee-saved) because the task
   --  resumed upon returning from the interrupt may be a different task. However,
   --  we need to save all the registers only if the interrupt nesting level was 0
   --  before this interrupt.
   --
   --  @pre  interrupts are disabled at the CPU
   --  @pre  CPU is in one of the exception modes (SVC, IRQ, FIQ, ABT or UND)
   --  @post CPU is in SYS mode
   --
   --  NOTE: We cannot check preconditions, as that would insert code
   --  at the beginning of this subprogram, which would clobber the CPU registers
   --  before we save them.
   --
   procedure Interrupt_Handler_Prolog is
   begin
      System.Machine_Code.Asm (
         --
         --  Save the IRQ mode LR (or other exception mode LR), and SPSR onto the
         --  interrupted context stack and switch to system mode to save the
         --  remaining registers on the interrupted context stack:
         --
         --  NOTE: The IRQ mode LR holds the exception return address and SPSR
         --  is the interrupted mode CPSR.
         --
         "srsdb sp!, %0" & LF &
         "cps   %0" & LF &

         --
         --  Save general-purpose registers on the stack:
         --
         --  NOTE: register r13 (sp) does not need to (and should not) be saved here,
         --  as it is saved in the interrupted task's TCB.
         --
         "push    {r0-r12, r14}" & LF &

         --
         --  Save floating-point registers on the stack:
         --
         --  NOTE: We need to save the floating point registers even if ISRs do not
         --  explicitly use floating point registers, as the compiler may still
         --  generate code to use floating point registers to temporarily save integer
         --  registers for any function.
         --
         "sub  sp, sp, %1" & LF & --  skip alignment hole
         "vmrs r1, fpscr" & LF &
         "push {r1}" & LF &
         "vpush {d0-d15}",
         Inputs =>
            (Interfaces.Unsigned_8'Asm_Input ("g", CPSR_System_Mode),  --  %0
             Interfaces.Unsigned_8'Asm_Input ("g",
                                              HiRTOS_Platform_Parameters.Int_Register_Size)), -- %1
         Volatile => True);

      --
      --  NOTE: Enter_Interrupt_Context call is assumed to be inlined,
      --  since sp changes to point to the ISR stack, if interrupt nesting was 0.
      --
      HiRTOS.Enter_Interrupt_Context;

      --
      --  NOTE: At this point sp always points to somewhere in the ISR stack
      --

      --
      --  Set frame pointer to be the same as stack pointer:
      --  (needed for stack unwinding across interrupted contexts)
      --
      System.Machine_Code.Asm (
         "mov     fp, sp",
         Volatile => True);
   end Interrupt_Handler_Prolog;

   --
   --  Inline subprogram to be invoked at the end of top-level interrupt handlers from
   --  which the RTOS scheduler can be called upon exit.
   --
   --  It restores the CPU state that was saved by a previous invocation to
   --  Interrupt_Handler_Prolog, and then executes an 'rfeia' instruction.
   --
   --  @pre  interrupts are disabled at the CPU
   --  @pre  CPU is in SYS mode
   --  @pre  g_interrupt_nesting_level > 0
   --  @post PC = return address from interrupt (next instruction to execute in
   --        interrupted code)
   --  @post current CPU privilege = privilege level of interrupted code
   --
   procedure Interrupt_Handler_Epilog is
   begin
      --
      --  NOTE: Exit_Interrupt_Context call is assumed to be inlined,
      --  since sp changes to point to the interrupted task's stack if
      --  if interrupt nesting dropped 0.
      --
      HiRTOS.Exit_Interrupt_Context;

      System.Machine_Code.Asm (
         --
         --  At this point sp points to a task stack, if interrupt nesting level
         --  dropped to 0. Otherwise, it points to somewhere in the ISR stack.
         --

         --
         --  Restore floating-point registers from the stack:
         --
         "vpop    {d0-d15}" & LF &
         "pop     {r1}" & LF &
         "vmsr    fpscr, r1" & LF &
         "add     sp, sp, %0" & LF & --  skip alignment hole

         --
         --  Restore general-purpose registers saved on the stack:
         --
         --  NOTE: register r13 (sp) does not need to be restored here,
         --  as we already restored it from the thread context
         --
         "pop     {r0-r12, r14}" & LF &

         --
         --  Return from exception popping PC and CPSR that were saved on the stack:
         --
         "rfeia   sp!",
         Inputs =>
            (Interfaces.Unsigned_8'Asm_Input ("g",
                                              HiRTOS_Platform_Parameters.Int_Register_Size)), -- %0
         Volatile => True);
   end Interrupt_Handler_Epilog;

end HiRTOS_Platform_Interface;
