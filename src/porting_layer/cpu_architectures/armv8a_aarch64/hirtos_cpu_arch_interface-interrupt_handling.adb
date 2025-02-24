--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target platform interface for ARMv8-A aarch64 architecture - Interrupt handling
--

with Generic_Execution_Stack;
with HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
with HiRTOS_Cpu_Arch_Interface.Memory_Protection;
with HiRTOS_Cpu_Arch_Interface_Private;
with System.Machine_Code;
with Interfaces;

package body HiRTOS_Cpu_Arch_Interface.Interrupt_Handling is
   use ASCII;
   use HiRTOS_Cpu_Arch_Interface_Private;

   procedure Same_El_With_Sp_El0_Synchronous_Exception_Handler
      with Export,
           External_Name => "same_el_with_sp_el0_synchronous_exception_handler";
   pragma Machine_Attribute (Same_El_With_Sp_El0_Synchronous_Exception_Handler, "naked");

   procedure Same_El_With_Sp_El0_Irq_Interrupt_Handler
      with Export,
           External_Name => "same_el_with_sp_el0_irq_interrupt_handler";
   pragma Machine_Attribute (Same_El_With_Sp_El0_Irq_Interrupt_Handler, "naked");

   procedure Same_El_With_Sp_El0_Fiq_Interrupt_Handler
      with Export,
           External_Name => "same_el_with_sp_el0_fiq_interrupt_handler";
   pragma Machine_Attribute (Same_El_With_Sp_El0_Fiq_Interrupt_Handler, "naked");

   procedure Same_El_With_Sp_El0_Serror_Exception_Handler
      with Export,
           External_Name => "same_el_with_sp_el0_serror_exception_handler";
   pragma Machine_Attribute (Same_El_With_Sp_El0_Serror_Exception_Handler, "naked");

   procedure Same_El_With_Sp_Elx_Synchronous_Exception_Handler
      with Export,
           External_Name => "same_el_with_sp_elx_synchronous_exception_handler";
   pragma Machine_Attribute (Same_El_With_Sp_Elx_Synchronous_Exception_Handler, "naked");

   procedure Same_El_With_Sp_Elx_Irq_Interrupt_Handler
      with Export,
           External_Name => "same_el_with_sp_elx_irq_interrupt_handler";
   pragma Machine_Attribute (Same_El_With_Sp_Elx_Irq_Interrupt_Handler, "naked");

   procedure Same_El_With_Sp_Elx_Fiq_Interrupt_Handler
      with Export,
           External_Name => "same_el_with_sp_elx_fiq_interrupt_handler";
   pragma Machine_Attribute (Same_El_With_Sp_Elx_Fiq_Interrupt_Handler, "naked");

   procedure Same_El_With_Sp_Elx_Serror_Exception_Handler
      with Export,
           External_Name => "same_el_with_sp_elx_serror_exception_handler";
   pragma Machine_Attribute (Same_El_With_Sp_Elx_Serror_Exception_Handler, "naked");

   procedure Lower_El_Synchronous_Exception_Handler
      with Export,
           External_Name => "lower_el_synchronous_exception_handler";
   pragma Machine_Attribute (Lower_El_Synchronous_Exception_Handler, "naked");

   procedure Lower_El_Irq_Interrupt_Handler
      with Export,
           External_Name => "lower_el_irq_interrupt_handler";
   pragma Machine_Attribute (Lower_El_Irq_Interrupt_Handler, "naked");

   procedure Lower_El_Fiq_Interrupt_Handler
      with Export,
           External_Name => "lower_el_fiq_interrupt_handler";
   pragma Machine_Attribute (Lower_El_Fiq_Interrupt_Handler, "naked");

   procedure Lower_El_Serror_Exception_Handler
      with Export,
           External_Name => "lower_el_serror_exception_handler";
   pragma Machine_Attribute (Lower_El_Serror_Exception_Handler, "naked");

   procedure Aarch32_Lower_El_Synchronous_Exception_Handler
      with Export,
           External_Name => "aarch32_lower_el_synchronous_exception_handler";
   pragma Machine_Attribute (Aarch32_Lower_El_Synchronous_Exception_Handler, "naked");

   procedure Aarch32_Lower_El_Irq_Interrupt_Handler
      with Export,
           External_Name => "aarch32_lower_el_irq_interrupt_handler";
   pragma Machine_Attribute (Aarch32_Lower_El_Irq_Interrupt_Handler, "naked");

   procedure Aarch32_Lower_El_Fiq_Interrupt_Handler
      with Export,
           External_Name => "aarch32_lower_el_fiq_interrupt_handler";
   pragma Machine_Attribute (Aarch32_Lower_El_Fiq_Interrupt_Handler, "naked");

   procedure Aarch32_Lower_El_Serror_Exception_Handler
      with Export,
           External_Name => "aarch32_lower_el_serror_exception_handler";
   pragma Machine_Attribute (Aarch32_Lower_El_Serror_Exception_Handler, "naked");

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
      array (Valid_Cpu_Core_Id_Type) of ISR_Stacks_Package.Execution_Stack_Type
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
   --  Inline subprogram to be invoked at the beginning of top-level EL1 interrupt handlers from
   --  which the RTOS scheduler can be called upon exit.
   --
   --  This subprogram first switches the SPSel to SP_EL0, instead of corresponding exception
   --  SP_ELx. Then it saves all general purpose registers on the stack. All registers
   --  need to be saved (both caller-saved and callee-saved) because the task
   --  resumed upon returning from the interrupt may be a different task. However,
   --  we need to save all the registers only if the interrupt nesting level was 0
   --  before this interrupt.
   --
   --  @pre  interrupts are disabled at the CPU
   --  @pre  CPU is in EL1, using SP_EL1 stack pointer
   --  @post CPU is in EL1, using SP_EL0 stack pointer
   --
   --  NOTE: We cannot check preconditions, as that would insert code
   --  at the beginning of this subprogram, which would clobber the CPU registers
   --  before we save them.
   --
   procedure Interrupt_Handler_Prolog is
   begin
      System.Machine_Code.Asm (
         --
         --  Switch to use SP_EL0 to save ELR_EL1, SPSR_EL1 and general purpose registers
         -- onto the interrupted context stack.
         --
         --  NOTE: ELR_EL1 holds the exception return address and SPSR_EL1 is the
         --  interrupted mode PSTATE.
         --
         "msr SPSel, #0" & LF &

         --
         --  Save general-purpose registers on the stack:
         --
         --  NOTE: SP does not need to be saved here,
         --  as it is saved in the interrupted task's TCB.
         --
         "stp x0, x1, [sp, #-16]!" & LF &
         "stp x2, x3, [sp, #-16]!" & LF &
         "stp x4, x5, [sp, #-16]!" & LF &
         "stp x6, x7, [sp, #-16]!" & LF &
         "stp x8, x9, [sp, #-16]!" & LF &
         "stp x10, x11, [sp, #-16]!" & LF &
         "stp x12, x13, [sp, #-16]!" & LF &
         "stp x14, x15, [sp, #-16]!" & LF &
         "stp x16, x17, [sp, #-16]!" & LF &
         "stp x18, x19, [sp, #-16]!" & LF &
         "stp x20, x21, [sp, #-16]!" & LF &
         "stp x22, x23, [sp, #-16]!" & LF &
         "stp x24, x25, [sp, #-16]!" & LF &
         "stp x26, x27, [sp, #-16]!" & LF &
         "stp x28, x29, [sp, #-16]!" & LF &
         "stp x30, xzr, [sp, #-16]!" & LF & --  Keep stack 16-byte-aligned

         --
         --  Save ELR_EL1 and SPSR_EL1 on the stack:
         -- 
         "mrs x0, elr_el1" & LF &
         "mrs x1, spsr_el1" & LF &
         "stp x0, x1, [sp, #-16]!" & LF &

         --
         --  Save floating-point registers on the stack:
         --
         --  NOTE: We need to save the floating point registers even if ISRs do not
         --  explicitly use floating point registers, as the compiler may still
         --  generate code to use floating point registers to temporarily save integer
         --  registers for any function.
         --
         "stp q0, q1, [sp, #-32]!" & LF &
         "stp q2, q3, [sp, #-32]!" & LF &
         "stp q4, q5, [sp, #-32]!" & LF &
         "stp q6, q7, [sp, #-32]!" & LF &
         "stp q8, q9, [sp, #-32]!" & LF &
         "stp q10, q11, [sp, #-32]!" & LF &
         "stp q12, q13, [sp, #-32]!" & LF &
         "stp q14, q15, [sp, #-32]!" & LF &
         "stp q16, q17, [sp, #-32]!" & LF &
         "stp q18, q19, [sp, #-32]!" & LF &
         "stp q20, q21, [sp, #-32]!" & LF &
         "stp q22, q23, [sp, #-32]!" & LF &
         "stp q24, q25, [sp, #-32]!" & LF &
         "stp q26, q27, [sp, #-32]!" & LF &
         "stp q28, q29, [sp, #-32]!" & LF &
         "stp q30, q31, [sp, #-32]!" & LF &
         "mrs x0, fpsr" & LF &
         "mrs x1, fpcr" & LF &
         "stp x0, x1, [sp, #-16]!" & LF &

         --
         --  Call sp = HiRTOS.Enter_Interrupt_Context (sp)
         --
         "mov x0, sp" & LF &
         "bl hirtos_enter_interrupt_context" & LF &
         "mov sp, x0" & LF &
         --
         --  NOTE: At this point sp always points to somewhere in the ISR stack
         --
         --  Set frame pointer to be the same as stack pointer:
         --  (needed for stack unwinding across interrupted contexts)
         --
         "mov     fp, sp",
         Volatile => True);
   end Interrupt_Handler_Prolog;

   --
   --  Inline subprogram to be invoked at the end of top-level EL1 interrupt
   --  handlers from which the RTOS scheduler can be called upon exit.
   --
   --  It restores the CPU state that was saved by a previous invocation to
   --  Interrupt_Handler_Prolog.
   --
   --  @pre  interrupts are disabled at the CPU
   --  @pre  CPU is in EL1 mode and SP is SP_EL0
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
         "mov x0, sp" & LF &
         "bl hirtos_exit_interrupt_context" & LF &
         "mov sp, x0" & LF &
         --
         --  At this point sp points to a task stack, if interrupt nesting level
         --  dropped to 0. Otherwise, it points to somewhere in the ISR stack.
         --

         --
         --  Restore floating-point registers from the stack:
         --
         "ldp x0, x1, [sp], #16" & LF &
         "msr fpsr, x0" & LF &   
         "msr fpcr, x1" & LF &   
         "ldp q30, q31, [sp], #32" & LF &
         "ldp q28, q29, [sp], #32" & LF &
         "ldp q26, q27, [sp], #32" & LF &
         "ldp q24, q25, [sp], #32" & LF &
         "ldp q22, q23, [sp], #32" & LF &
         "ldp q20, q21, [sp], #32" & LF &
         "ldp q18, q19, [sp], #32" & LF &
         "ldp q16, q17, [sp], #32" & LF &
         "ldp q14, q15, [sp], #32" & LF &
         "ldp q12, q13, [sp], #32" & LF &
         "ldp q10, q11, [sp], #32" & LF &
         "ldp q8, q9, [sp], #32" & LF &
         "ldp q6, q7, [sp], #32" & LF &
         "ldp q4, q5, [sp], #32" & LF &
         "ldp q2, q3, [sp], #32" & LF &
         "ldp q0, q1, [sp], #32" & LF &

         --
         --  Restore ELR_EL1 and SPSR_EL1 on the stack:
         -- 
         "ldp x0, x1, [sp], #16" & LF &
         "msr elr_el1, x0" & LF &
         "msr spsr_el1, x1" & LF &

         --
         --  Restore general-purpose registers saved on the stack:
         --
         "ldp x30, xzr, [sp], #16" & LF & 
         "ldp x28, x29, [sp], #16" & LF &
         "ldp x26, x27, [sp], #16" & LF &
         "ldp x24, x25, [sp], #16" & LF &
         "ldp x22, x23, [sp], #16" & LF &
         "ldp x20, x21, [sp], #16" & LF &
         "ldp x18, x19, [sp], #16" & LF &
         "ldp x16, x17, [sp], #16" & LF &
         "ldp x14, x15, [sp], #16" & LF &
         "ldp x12, x13, [sp], #16" & LF &
         "ldp x10, x11, [sp], #16" & LF &
         "ldp x8, x9, [sp], #16" & LF &
         "ldp x6, x7, [sp], #16" & LF &
         "ldp x4, x5, [sp], #16" & LF &
         "ldp x2, x3, [sp], #16" & LF &
         "ldp x0, x1, [sp], #16" & LF &

         --
         --  Return from EL1 exception:
         --
         "eret",
         Volatile => True);

      pragma Assert (False);
      loop
         Wait_For_Interrupt;
      end loop;
   end Interrupt_Handler_Epilog;

   ----------------------------------------------------------------------------
   --  Interrupt and Exception Handlers
   ----------------------------------------------------------------------------

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
   procedure EL1_Supervisor_Call_Exception_Handler is -- ???
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
   end EL1_Supervisor_Call_Exception_Handler;

   --
   --  CAUTION: This subprogram cannot use any stack space, before
   --  it calls Interrupt_Handler_Prolog, as we do not define a stack
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
      SPSR_Value : constant PSTATE_Type :=
         (SPSel => SP_EL0, CurrentEL => EL1, M => Execution_State_AArch64, 
          DAIF => (D => Interrupt_Enabled, A => Interrupt_Enabled, 
                   I => Interrupt_Enabled, F => Interrupt_Enabled),
          others => <>);
   begin
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
   end Stay_In_Cpu_Privileged_Mode;

   --
   --  Entry point of the synchronous exception that fires at the current privileged ELx (x > 0)
   --  that was using the SP EL0 stack pointer (thread context).
   --
   procedure Same_El_With_Sp_El0_Synchronous_Exception_Handler is
   begin
      Interrupt_Handler_Prolog;
      --  TODO: Handle synchronous exception:
      --??? Memory_Protection.Handle_Prefetch_Abort_Exception;
      --??? Memory_Protection.Handle_Data_Abort_Exception;
      --??? Memory_Protection.Handle_Svc_Exception; (EL1_Supervisor_Call_Exception_Handler)
      Interrupt_Handler_Epilog;
   end Same_El_With_Sp_El0_Synchronous_Exception_Handler;

   --
   --  Entry point of the IRQ interrupt that fires at the current privileged ELx (x > 0)
   --  that was using the SP EL0 stack pointer (thread context).
   --
   procedure Same_El_With_Sp_El0_Irq_Interrupt_Handler is
   begin
   --  Save the current thread's CPU state on its own stack
      Interrupt_Handler_Prolog;

      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.GIC_Interrupt_Handler (
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Cpu_Interrupt_Irq);

      --  Run the thread scheduler to select next thread to run and
      --  resume execution of the newly selected thread
      Interrupt_Handler_Epilog;
   end Same_El_With_Sp_El0_Irq_Interrupt_Handler;

   --
   --  Entry point of the FIQ interrupt that fires at the current privileged ELx (x > 0)
   --  that was using the SP EL0 stack pointer (thread context).
   --
   procedure Same_El_With_Sp_El0_Fiq_Interrupt_Handler is
   begin
      --  Save the current thread's CPU state on its own stack
      Interrupt_Handler_Prolog;

      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.GIC_Interrupt_Handler (
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Cpu_Interrupt_Fiq);

      --  Run the thread scheduler to select next thread to run and
      --  resume execution of the newly selected thread
      Interrupt_Handler_Epilog;
   end Same_El_With_Sp_El0_Fiq_Interrupt_Handler;

   --
   --  Entry point of the SError exception that fires at the current privileged ELx (x > 0)
   --  that was using the SP EL0 stack pointer (thread context).
   --
   procedure Same_El_With_Sp_El0_Serror_Exception_Handler is
   begin
      Interrupt_Handler_Prolog;
      --  TODO: Handle SError exception:
      Interrupt_Handler_Epilog;
   end Same_El_With_Sp_El0_Serror_Exception_Handler;

   --
   --  Entry point of the synchronous exception that fires at the current privileged ELx (x > 0)
   --  that was using the SP ELx stack pointer (interrupt context).
   --
   procedure Same_El_With_Sp_Elx_Synchronous_Exception_Handler is
   begin
      raise Program_Error;
   end Same_El_With_Sp_Elx_Synchronous_Exception_Handler;

   --
   --  Entry point of the IRQ interrupt that fires at the current privileged ELx (x > 0)
   --  that was using the SP ELx stack pointer (interrupt context).
   --
   procedure Same_El_With_Sp_Elx_Irq_Interrupt_Handler is
   begin
      raise Program_Error;
   end Same_El_With_Sp_Elx_Irq_Interrupt_Handler;

   --
   --  Entry point of the FIQ interrupt that fires at the current privileged ELx (x > 0)
   --  that was using the SP ELx stack pointer (interrupt context).
   --
   procedure Same_El_With_Sp_Elx_Fiq_Interrupt_Handler is
   begin
      raise Program_Error;
   end Same_El_With_Sp_Elx_Fiq_Interrupt_Handler;

   --
   --  Entry point of the SError exception that fires at the current privileged ELx, (x > 0)
   --  that was using the SP ELx stack pointer (interrupt context).
   --
   procedure Same_El_With_Sp_Elx_Serror_Exception_Handler is
   begin
      raise Program_Error;
   end Same_El_With_Sp_Elx_Serror_Exception_Handler;

   --
   --  Entry point of the synchronous exception that fires at a lower EL (lower privilege level)
   --
   procedure Lower_El_Synchronous_Exception_Handler is
   begin
      Interrupt_Handler_Prolog;
      --  TODO: Handle synchronous exception:
      --??? Memory_Protection.Handle_Prefetch_Abort_Exception;
      --??? Memory_Protection.Handle_Data_Abort_Exception;
      --??? Memory_Protection.Handle_Svc_Exception;
      Interrupt_Handler_Epilog;
   end Lower_El_Synchronous_Exception_Handler;

   --
   --  Entry point of the IRQ interrupt that fires at a lower EL (lower privilege level)
   --
   procedure Lower_El_Irq_Interrupt_Handler is
   begin
   --  Save the current thread's CPU state on its own stack
      Interrupt_Handler_Prolog;

      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.GIC_Interrupt_Handler (
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Cpu_Interrupt_Irq);

      --  Run the thread scheduler to select next thread to run and
      --  resume execution of the newly selected thread
      Interrupt_Handler_Epilog;
   end Lower_El_Irq_Interrupt_Handler;

   --
   --  Entry point of the FIQ interrupt that fires at a lower EL (lower privilege level)
   --
   procedure Lower_El_Fiq_Interrupt_Handler is
   begin
      --  Save the current thread's CPU state on its own stack
      Interrupt_Handler_Prolog;

      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.GIC_Interrupt_Handler (
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Cpu_Interrupt_Fiq);

      --  Run the thread scheduler to select next thread to run and
      --  resume execution of the newly selected thread
      Interrupt_Handler_Epilog;
   end Lower_El_Fiq_Interrupt_Handler;

   --
   --  Entry point of the SError exception that fires at a lower EL (lower privilege level)
   --
   procedure Lower_El_Serror_Exception_Handler is
   begin
      Interrupt_Handler_Prolog;
      --  TODO: Handle SError exception:
      Interrupt_Handler_Epilog;
   end Lower_El_Serror_Exception_Handler;

   --
   --  Entry point of the synchronous exception that fires at a lower EL (lower privilege level),
   --  when the CPU was in aarch32 execution state
   --
   procedure Aarch32_Lower_El_Synchronous_Exception_Handler is
   begin
      raise Program_Error;
   end Aarch32_Lower_El_Synchronous_Exception_Handler;

   --
   --  Entry point of the IRQ interrupt that fires at a lower EL (lower privilege level)
   --  when the CPU was in aarch32 execution state
   --
   procedure Aarch32_Lower_El_Irq_Interrupt_Handler is
   begin
      raise Program_Error;
   end Aarch32_Lower_El_Irq_Interrupt_Handler;

   --
   --  Entry point of the FIQ interrupt that fires at a lower EL (lower privilege level)
   --  when the CPU was in aarch32 execution state
   --
   procedure Aarch32_Lower_El_Fiq_Interrupt_Handler is
   begin
      raise Program_Error;
   end Aarch32_Lower_El_Fiq_Interrupt_Handler;

   --
   --  Entry point of the SError exception that fires at a lower EL (lower privilege level)
   --  when the CPU was in aarch32 execution state
   --
   procedure Aarch32_Lower_El_Serror_Exception_Handler is
   begin
      raise Program_Error;
   end Aarch32_Lower_El_Serror_Exception_Handler;

   procedure Handle_Invalid_SVC_Exception is
   begin
      raise Program_Error;
   end Handle_Invalid_SVC_Exception;

end HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
