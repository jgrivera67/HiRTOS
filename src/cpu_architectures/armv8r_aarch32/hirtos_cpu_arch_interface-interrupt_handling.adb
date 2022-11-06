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
--  @summary HiRTOS to target platform interface for ARMv8-R architecture - Interrupt handling
--

with Generic_Execution_Stack;
with HiRTOS.Interrupt_Handling;
with System.Machine_Code;
with Interfaces;

package body HiRTOS_Cpu_Arch_Interface.Interrupt_Handling is
   use ASCII;

   ISR_Stack_Size_In_Bytes : constant := 4 * 1024; -- 4KiB

   package ISR_Stacks_Package is new
      Generic_Execution_Stack (Stack_Size_In_Bytes => ISR_Stack_Size_In_Bytes);

   ISR_Stacks :
      array (Cpu_Core_Id_Type) of ISR_Stacks_Package.Execution_Stack_Type
         with Linker_Section => ".isr_stack",
              Convention => C,
              Export,
              External_Name => "isr_stacks";

   ------------------------
   -- Get_ISR_Stack_Info --
   ------------------------

   function Get_ISR_Stack_Info return ISR_Stack_Info_Type is
      use type System.Storage_Elements.Integer_Address;
      Cpu_Id : constant Cpu_Core_Id_Type := Get_Cpu_Id;
      ISR_Stack_Info : constant ISR_Stack_Info_Type :=
         (Base_Address => ISR_Stacks (Cpu_Id).Stack_Entries'Address,
          Size_In_Bytes => ISR_Stacks (Cpu_Id).Stack_Entries'Size / System.Storage_Unit);
   begin
      return ISR_Stack_Info;
   end Get_ISR_Stack_Info;

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
            [Interfaces.Unsigned_8'Asm_Input ("g", CPSR_System_Mode),  --  %0
             Interfaces.Unsigned_8'Asm_Input ("g",
                                              HiRTOS_Cpu_Arch_Parameters.Integer_Register_Size_In_Bytes)], -- %1
         Volatile => True);

      --
      --  NOTE: Enter_Interrupt_Context call is assumed to be inlined,
      --  since sp changes to point to the ISR stack, if interrupt nesting was 0.
      --
      HiRTOS.Interrupt_Handling.Enter_Interrupt_Context;

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
      HiRTOS.Interrupt_Handling.Exit_Interrupt_Context;

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
                                              HiRTOS_Cpu_Arch_Parameters.Integer_Register_Size_In_Bytes)), -- %0
         Volatile => True);
   end Interrupt_Handler_Epilog;

end HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
