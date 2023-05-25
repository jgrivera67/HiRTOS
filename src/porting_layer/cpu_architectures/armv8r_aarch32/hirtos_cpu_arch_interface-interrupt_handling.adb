--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS to target platform interface for ARMv8-R architecture - Interrupt handling
--

with Generic_Execution_Stack;
with HiRTOS.Interrupt_Handling;
with HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
with HiRTOS_Cpu_Arch_Interface.Memory_Protection;
with HiRTOS_Cpu_Arch_Interface_Private;
with HiRTOS_Low_Level_Debug_Interface;
with System.Machine_Code;
with Interfaces;

package body HiRTOS_Cpu_Arch_Interface.Interrupt_Handling is
   use ASCII;
   use System.Storage_Elements;
   use HiRTOS_Cpu_Arch_Interface_Private;

   procedure Handle_Undefined_Instruction_Exception;

   procedure Do_Synchronous_Context_Switch
      with Export,
           External_Name => "do_synchronous_context_switch";
   pragma Machine_Attribute (Do_Synchronous_Context_Switch, "naked");

   procedure Stay_In_Cpu_Privileged_Mode
      with Export,
           External_Name => "stay_in_cpu_privileged_mode";
   pragma Machine_Attribute (Stay_In_Cpu_Privileged_Mode, "naked");

   procedure Handle_Invalid_SVC_Exception
      with Export,
           External_Name => "handle_invalid_svc_exception";
   pragma Machine_Attribute (Handle_Invalid_SVC_Exception, "naked");

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

   function Get_ISR_Stack_Info (Cpu_Id : Cpu_Core_Id_Type)
      return ISR_Stack_Info_Type
   is
      use type System.Storage_Elements.Integer_Address;
      ISR_Stack_Info : constant ISR_Stack_Info_Type :=
         (Base_Address => ISR_Stacks (Cpu_Id).Stack_Entries'Address,
          Size_In_Bytes => ISR_Stacks (Cpu_Id).Stack_Entries'Size / System.Storage_Unit);
   begin
      return ISR_Stack_Info;
   end Get_ISR_Stack_Info;

   function Valid_ISR_Stack_Pointer (Cpu_Id : Cpu_Core_Id_Type; Stack_Pointer : System.Address)
      return Boolean is
      Min_Valid_Address : constant Integer_Address :=
         To_Integer (ISR_Stacks (Cpu_Id).Stack_Entries'Address);
      Max_Valid_Address : constant Integer_Address :=
         Min_Valid_Address + (ISR_Stacks (Cpu_Id).Stack_Entries'Size / System.Storage_Unit) - 1;
   begin
      return To_Integer (Stack_Pointer) in Min_Valid_Address .. Max_Valid_Address;
   end Valid_ISR_Stack_Pointer;

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
         "vpush {d0-d15}" & LF &

         --
         --  Call sp = HiRTOS.Enter_Interrupt_Context (sp)
         --
         "mov r0, sp" & LF &
         "bl hirtos_enter_interrupt_context" & LF &
         "mov sp, r0" & LF &
         --
         --  NOTE: At this point sp always points to somewhere in the ISR stack
         --
         --  Set frame pointer to be the same as stack pointer:
         --  (needed for stack unwinding across interrupted contexts)
         --
         "mov     fp, sp",
         Inputs =>
            [Interfaces.Unsigned_8'Asm_Input ("g", CPSR_System_Mode),  --  %0
             Interfaces.Unsigned_8'Asm_Input ("g",
                                              HiRTOS_Cpu_Arch_Parameters.Integer_Register_Size_In_Bytes)], -- %1
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
      System.Machine_Code.Asm (
         --
         --  Call sp = HiRTOS.Interrupt_Handling.Exit_Interrupt_Context (sp)
         --
         "mov r0, sp" & LF &
         "bl hirtos_exit_interrupt_context" & LF &
         "mov sp, r0" & LF &
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

      pragma Assert (False);
      loop
         Wait_For_Interrupt;
      end loop;
   end Interrupt_Handler_Epilog;

   ----------------------------------------------------------------------------
   --  Interrupt and Exception Handlers
   ----------------------------------------------------------------------------

   procedure Undefined_Instruction_Exception_Handler is
   begin
      Interrupt_Handler_Prolog;
      Handle_Undefined_Instruction_Exception;
      Interrupt_Handler_Epilog;
   end Undefined_Instruction_Exception_Handler;

   procedure Handle_Undefined_Instruction_Exception is
      use type System.Storage_Elements.Integer_Address;
      Faulting_PC : constant System.Storage_Elements.Integer_Address :=
         System.Storage_Elements.To_Integer (HiRTOS.Interrupt_Handling.Get_Interrupted_PC) - 4;
   begin
      HiRTOS_Low_Level_Debug_Interface.Print_String (
         "*** Undefined instruction exception (faulting PC: ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (Faulting_PC));
      HiRTOS_Low_Level_Debug_Interface.Print_String (")" & ASCII.LF);

      raise Program_Error;
   end Handle_Undefined_Instruction_Exception;

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

   procedure Stay_In_Cpu_Privileged_Mode is
   begin
      System.Machine_Code.Asm (
         --
         --  Set CPU mode to system mode in spsr
         --
         "mrs r0, spsr" & LF &
         "orr r0, r0, %0" & LF &
         "msr spsr, r0" & LF &

         --
         --  Return from the exception:
         --  (see Cortex-R5 Technical Reference Manual, section 3.8.1)
         --
         --  NOTE: For the SVC exception, lr points the instruction right
         --  after the svc instruction that brought us here.
         --
         "movs pc, lr",
         Inputs => Interfaces.Unsigned_8'Asm_Input ("g", CPSR_System_Mode), --  %0
         Clobber => "r0",
         Volatile => True);
   end Stay_In_Cpu_Privileged_Mode;

   procedure Handle_Invalid_SVC_Exception is
   begin
      raise Program_Error;
   end Handle_Invalid_SVC_Exception;

   procedure Prefetch_Abort_Exception_Handler is
   begin
      Interrupt_Handler_Prolog;
      Memory_Protection.Handle_Prefetch_Abort_Exception;
      Interrupt_Handler_Epilog;
   end Prefetch_Abort_Exception_Handler;

   procedure Data_Abort_Exception_Handler is
   begin
      Interrupt_Handler_Prolog;
      Memory_Protection.Handle_Data_Abort_Exception;
      Interrupt_Handler_Epilog;
   end Data_Abort_Exception_Handler;

   procedure Irq_Interrupt_Handler is
   begin
      --
      --  Adjust lr to point to the instruction we need to return to after
      --  handling the interrupt
      --
      System.Machine_Code.Asm (
         "sub lr, lr, %0",
         Inputs =>
            (Interfaces.Unsigned_8'Asm_Input ("g",
                                              HiRTOS_Cpu_Arch_Parameters.Integer_Register_Size_In_Bytes)), -- %0
         Volatile => True);

      --  Save the current thread's CPU state on its own stack
      Interrupt_Handler_Prolog;

      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.GIC_Interrupt_Handler (
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Cpu_Interrupt_Irq);

      --  Run the thread scheduler to select next thread to run and
      --  resume execution of the newly selected thread
      Interrupt_Handler_Epilog;
   end Irq_Interrupt_Handler;

   procedure Fiq_Interrupt_Handler is
   begin
      --
      --  Adjust lr to point to the instruction we need to return to after
      --  handling the interrupt (see table B1-7, section B1.8.3 in ARMv7-AR ARM)
      --
      System.Machine_Code.Asm (
         "sub lr, lr, %0",
         Inputs =>
            (Interfaces.Unsigned_8'Asm_Input ("g",
                                              HiRTOS_Cpu_Arch_Parameters.Integer_Register_Size_In_Bytes)), -- %0
         Volatile => True);

      --  Save the current thread's CPU state on its own stack
      Interrupt_Handler_Prolog;

      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.GIC_Interrupt_Handler (
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Cpu_Interrupt_Fiq);

      --  Run the thread scheduler to select next thread to run and
      --  resume execution of the newly selected thread
      Interrupt_Handler_Epilog;
   end Fiq_Interrupt_Handler;

end HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
