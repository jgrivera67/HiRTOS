/*
 * Copyright (c) 2025, German Rivera
 *
 * SPDX-License-Identifier: Apache-2.0
 */

/**
 * HiRTOS to target platform interface for ARMv8-A aarch64 architecture - Interrupt handling
 */

#include "hirtos_cpu_arch_interface_asm.h"

/*
 * Imported symbols
 */
      .extern hirtos_enter_interrupt_context       /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
      .extern hirtos_exit_interrupt_context        /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
      .extern ada_handle_el1_synchronous_exception /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
      .extern ada_handle_el1_irq_interrupt         /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
      .extern ada_handle_el1_fiq_interrupt         /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
      .extern ada_handle_el1_serror_exception      /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
      .extern ada_handle_el1_unexpected_exception  /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */

/**
 * ARMv8-A EL1 interrupt vector table
 * (see "Table D1-5 Vector offsets from vector table base address" in
 *  ARMv8 Architecture Reference Manual)
 */
      .section .text.privileged.interrupt_vector_table, "ax"
      .align 11 // 2^11-aligned (2K byte-aligned)
      .global interrupt_vector_table
interrupt_vector_table:
      // Vectors when taking exception/interrupt from same privileged ELx (x > 0) that was using SP EL0
      b same_el_with_sp_el0_synchronous_exception_handler // offset 0x0
      .align 7 // 2^7-aligned (128 byte-aligned)
      b same_el_with_sp_el0_irq_interrupt_handler         // offset 0x80
      .align 7 // 2^7-aligned (128 byte-aligned)
      b same_el_with_sp_el0_fiq_interrupt_handler         // offset 0x100
      .align 7 // 2^7-aligned (128 byte-aligned)
      b same_el_with_sp_el0_serror_exception_handler      // offset 0x180

      // Vectors when taking exception/interrupt from same privileged ELx (x > 0) that was using SP ELx
      .align 7 // 2^7-aligned (128 byte-aligned)
      b same_el_with_sp_elx_synchronous_exception_handler // offset 0x200
      .align 7 // 2^7-aligned (128 byte-aligned)
      b same_el_with_sp_elx_irq_interrupt_handler         // offset 0x280
      .align 7 // 2^7-aligned (128 byte-aligned)
      b same_el_with_sp_elx_fiq_interrupt_handler         // offset 0x300
      .align 7 // 2^7-aligned (128 byte-aligned)
      b same_el_with_sp_elx_serror_exception_handler      // offset 0x380

      // Vectors when taking exception/interrupt from lower ELx (x >= 0) that was running in aarch64 mode
      .align 7 // 2^7-aligned (128 byte-aligned)
      b lower_el_synchronous_exception_handler // offset 0x400
      .align 7 // 2^7-aligned (128 byte-aligned)
      b lower_el_irq_interrupt_handler         // offset 0x480
      .align 7 // 2^7-aligned (128 byte-aligned)
      b lower_el_fiq_interrupt_handler         // offset 0x500
      .align 7 // 2^7-aligned (128 byte-aligned)
      b lower_el_serror_exception_handler      // offset 0x580

      // Vectors when taking exception/interrupt from lower ELx (x >= 0) that was running in aarch32 mode
      .align 7 // 2^7-aligned (128 byte-aligned)
      b aarch32_lower_el_synchronous_exception_handler // offset 0x600
      .align 7 // 2^7-aligned (128 byte-aligned)
      b aarch32_lower_el_irq_interrupt_handler         // offset 0x680
      .align 7 // 2^7-aligned (128 byte-aligned)
      b aarch32_lower_el_fiq_interrupt_handler         // offset 0x700
      .align 7 // 2^7-aligned (128 byte-aligned)
      b aarch32_lower_el_serror_exception_handler      // offset 0x780

/**
 * Macro to be invoked at the beginning of top-level EL1 interrupt handlers from
 * which the RTOS scheduler can be called upon exit.
 *
 * It first switches the SPSel to SP_EL0, instead of corresponding exception
 * SP_ELx. Then it saves all general purpose registers on the stack. All registers
 * need to be saved (both caller-saved and callee-saved) because the task
 * resumed upon returning from the interrupt may be a different task. However,
 * we need to save all the registers only if the interrupt nesting level was 0
 * before this interrupt.
 *
 * @pre  interrupts are disabled at the CPU
 * @pre  CPU is in EL1, using SP_EL1 stack pointer
 * @post CPU is in EL1, using SP_EL0 stack pointer
 *
 * NOTE: We cannot check preconditions, as that would insert code
 * at the beginning of this subprogram, which would clobber the CPU registers
 * before we save them.
 */
      .macro INTERRUPT_HANDLER_PROLOG
      /*
       * Switch to use SP_EL0 to save ELR_EL1, SPSR_EL1 and general purpose registers
       * onto the interrupted context stack.
       *
       * NOTE: ELR_EL1 holds the exception return address and SPSR_EL1 is the
       * interrupted mode PSTATE.
       */
      msr SPSel, #0

      /*
       * Save general-purpose registers on the stack:
       *
       * NOTE: SP does not need to be saved here,
       * as it is saved in the interrupted task's TCB.
       */
      stp x0, x1, [sp, #-16]!
      stp x2, x3, [sp, #-16]!
      stp x4, x5, [sp, #-16]!
      stp x6, x7, [sp, #-16]!
      stp x8, x9, [sp, #-16]!
      stp x10, x11, [sp, #-16]!
      stp x12, x13, [sp, #-16]!
      stp x14, x15, [sp, #-16]!
      stp x16, x17, [sp, #-16]!
      stp x18, x19, [sp, #-16]!
      stp x20, x21, [sp, #-16]!
      stp x22, x23, [sp, #-16]!
      stp x24, x25, [sp, #-16]!
      stp x26, x27, [sp, #-16]!
      stp x28, x29, [sp, #-16]!
      stp x30, xzr, [sp, #-16]! // Keep stack 16-byte-aligned

      /*
       * Save ELR_EL1 and SPSR_EL1 on the stack:
       */
      mrs x0, elr_el1
      mrs x1, spsr_el1
      stp x0, x1, [sp, #-16]!

      /*
       * Save floating-point registers on the stack:
       *
       * NOTE: We need to save the floating point registers even if ISRs do not
       * explicitly use floating point registers, as the compiler may still
       * generate code to use floating point registers to temporarily save integer
       * registers for any function.
       */
#if 0 //???
      stp q0, q1, [sp, #-32]!
      stp q2, q3, [sp, #-32]!
      stp q4, q5, [sp, #-32]!
      stp q6, q7, [sp, #-32]!
      stp q8, q9, [sp, #-32]!
      stp q10, q11, [sp, #-32]!
      stp q12, q13, [sp, #-32]!
      stp q14, q15, [sp, #-32]!
      stp q16, q17, [sp, #-32]!
      stp q18, q19, [sp, #-32]!
      stp q20, q21, [sp, #-32]!
      stp q22, q23, [sp, #-32]!
      stp q24, q25, [sp, #-32]!
      stp q26, q27, [sp, #-32]!
      stp q28, q29, [sp, #-32]!
      stp q30, q31, [sp, #-32]!
      mrs x0, fpsr
      mrs x1, fpcr
      stp x0, x1, [sp, #-16]!
#endif

      /*
       * Call sp = HiRTOS.Enter_Interrupt_Context (sp)
       */
      mov x0, sp
      bl hirtos_enter_interrupt_context
      mov sp, x0
      /*
       * NOTE: At this point sp always points to somewhere in the ISR stack
       *
       * Set frame pointer to be the same as stack pointer:
       * (needed for stack unwinding across interrupted contexts)
       */
      mov fp, sp
      .endm

/**
 * Macro to be invoked at the end of top-level EL1 interrupt
 * handlers from which the RTOS scheduler can be called upon exit.
 *
 * It restores the CPU state that was saved by a previous invocation to
 * Interrupt_Handler_Prolog.
 *
 * @pre  interrupts are disabled at the CPU
 * @pre  CPU is in EL1 mode and SP is SP_EL0
 * @post PC = return address from interrupt (next instruction to execute in
 *        interrupted code)
 * @post current CPU privilege = privilege level of interrupted code
 */
      .macro INTERRUPT_HANDLER_EPILOG
      /*
       * Call sp = HiRTOS.Interrupt_Handling.Exit_Interrupt_Context (sp)
       */
      mov x0, sp
      bl hirtos_exit_interrupt_context
      mov sp, x0
      /*
       * At this point sp points to a task stack, if interrupt nesting level
       * dropped to 0. Otherwise, it points to somewhere in the ISR stack.
       */

      /*
       * Restore floating-point registers from the stack:
       */
#if 0 //???
      ldp x0, x1, [sp], #16
      msr fpsr, x0
      msr fpcr, x1
      ldp q30, q31, [sp], #32
      ldp q28, q29, [sp], #32
      ldp q26, q27, [sp], #32
      ldp q24, q25, [sp], #32
      ldp q22, q23, [sp], #32
      ldp q20, q21, [sp], #32
      ldp q18, q19, [sp], #32
      ldp q16, q17, [sp], #32
      ldp q14, q15, [sp], #32
      ldp q12, q13, [sp], #32
      ldp q10, q11, [sp], #32
      ldp q8, q9, [sp], #32
      ldp q6, q7, [sp], #32
      ldp q4, q5, [sp], #32
      ldp q2, q3, [sp], #32
      ldp q0, q1, [sp], #32
#endif

      /*
       * Restore ELR_EL1 and SPSR_EL1 on the stack:
       */
      ldp x0, x1, [sp], #16
      msr elr_el1, x0
      msr spsr_el1, x1

      /*
       * Restore general-purpose registers saved on the stack:
       */
      ldp x30, xzr, [sp], #16
      ldp x28, x29, [sp], #16
      ldp x26, x27, [sp], #16
      ldp x24, x25, [sp], #16
      ldp x22, x23, [sp], #16
      ldp x20, x21, [sp], #16
      ldp x18, x19, [sp], #16
      ldp x16, x17, [sp], #16
      ldp x14, x15, [sp], #16
      ldp x12, x13, [sp], #16
      ldp x10, x11, [sp], #16
      ldp x8, x9, [sp], #16
      ldp x6, x7, [sp], #16
      ldp x4, x5, [sp], #16
      ldp x2, x3, [sp], #16
      ldp x0, x1, [sp], #16

      /*
       * Return from EL1 exception:
       */
      eret
      .endm

      /*
       * CAUTION: This macro cannot use any stack space, before
       * it invokes the INTERRUPT_HANDLER_PROLOG macro, as it is invoked
       * right after entering EL1 exceptions and we do not define a stack
       * for SP_EL1.
       */
      .macro COMMON_SYNCHRONOUS_EXCEPTION_HANDLER
      /*
       * NOTE: Since we don't use SP_EL1 as a stack pointer, we borrow it
       * as a scratch register to save x0.
       */
      mov sp, x0        // Save x0 in SP_EL1
      mrs x0, esr_el1
      and x0, x0, #ESR_EL1_EC_MASK
      lsr x0, x0, #ESR_EL1_EC_SHIFT
      cmp x0, #ESR_EL1_EC_AARCH64_SVC_EXCEPTION
      mov x0, sp        // Restore x0
      bne 1f
      // Handle SVC exception:
      mov sp, x0        // Save x0 in SP_EL1
      mrs x0, esr_el1
      and x0, x0, #ESR_EL1_SVC_ISS_MASK
#if 0  // Shift not needed as ESR_EL1_SVC_ISS_SHIFT is 0
      lsr x0, x0, #ESR_EL1_SVC_ISS_SHIFT
#endif
      cmp x0, #0        // RTOS synchronous task context switch?
      beq 2f
      cmp x0, #1        // Enter_Cpu_Privileged_Mode call?
      mov x0, sp        // Restore x0
      beq 3f
0:
      // Handle unexpected SVC exception:
      INTERRUPT_HANDLER_PROLOG
      bl ada_handle_el1_unexpected_exception
      b 4f
1:
      // Handle other synchronous exceptions:
      INTERRUPT_HANDLER_PROLOG
      bl ada_handle_el1_synchronous_exception
      INTERRUPT_HANDLER_EPILOG
2:
      /*
       * Synchronous context switch:
       */
      mov x0, sp        // Restore x0
      // Save the current thread's CPU state on its own stack
      INTERRUPT_HANDLER_PROLOG
      // Run the thread scheduler to select next thread to run and
      // resume execution of the newly selected thread
      INTERRUPT_HANDLER_EPILOG
3:
      /*
       * Stay in cpu privileged mode:
       */
      // Disable CPU interrupting, so that we don't get interrupted before executing eret:
      msr DAIFset, #(DAIF_SETCLR_I_BIT_MASK | DAIF_SETCLR_F_BIT_MASK)
      isb
      // Set exception return address to be the caller's return address:
      msr elr_el1, lr
      // Set SPSR_EL1 to EL1, using SP_EL0, interrupts enabled:
      mrs x0, spsr_el1
      and x1, x0, #PSTATE_EL_MASK
      cbnz x1, 0b                // SVC exception is not expected when already at ELx > EL0
      orr x0, x0, #PSTATE_EL_EL1_MASK
      msr spsr_el1, x0
      // return from exception:
      eret

4:    // Park CPU:
      wfi
      b 4b
      .endm

/*
 * Entry point of the synchronous exception that fires at the current privileged ELx (x > 0)
 * that was using the SP EL0 stack pointer (thread context).
 *
 * NOTE: Right after entering an EL1 exception, sp is SP_EL1,
 * which we don't use, as we handle exceptions using SP_EL0.
 *
 * CAUTION: This routine cannot use any stack space, before it invokes
 * INTERRUPT_HANDLER_PROLOG, as we do not define a stack for SP_EL1.
 */
      .section .text.privileged.same_el_with_sp_el0_synchronous_exception_handler
      .align 2
      .global same_el_with_sp_el0_synchronous_exception_handler
      .func same_el_with_sp_el0_synchronous_exception_handler
same_el_with_sp_el0_synchronous_exception_handler:
      COMMON_SYNCHRONOUS_EXCEPTION_HANDLER
      .endfunc

/*
 * Entry point of the IRQ interrupt that fires at the current privileged ELx (x > 0)
 * that was using the SP EL0 stack pointer (thread context).
 */
      .section .text.privileged.same_el_with_sp_el0_irq_interrupt_handler
      .align 2
      .global same_el_with_sp_el0_irq_interrupt_handler
      .func same_el_with_sp_el0_irq_interrupt_handler
   same_el_with_sp_el0_irq_interrupt_handler:
      // Save the current thread's CPU state on its own stack:
      INTERRUPT_HANDLER_PROLOG

      bl ada_handle_el1_irq_interrupt

      // Run the thread scheduler to select next thread to run and
      // resume execution of the newly selected thread
      INTERRUPT_HANDLER_EPILOG
      .endfunc

/*
 * Entry point of the FIQ interrupt that fires at the current privileged ELx (x > 0)
 * that was using the SP EL0 stack pointer (thread context).
 */
      .section .text.privileged.same_el_with_sp_el0_fiq_interrupt_handler
      .align 2
      .global same_el_with_sp_el0_fiq_interrupt_handler
      .func same_el_with_sp_el0_fiq_interrupt_handler
   same_el_with_sp_el0_fiq_interrupt_handler:
      // Save the current thread's CPU state on its own stack:
      INTERRUPT_HANDLER_PROLOG

      bl ada_handle_el1_fiq_interrupt

      // Run the thread scheduler to select next thread to run and
      // resume execution of the newly selected thread
      INTERRUPT_HANDLER_EPILOG
      .endfunc

/*
 * Entry point of the SError exception that fires at the current privileged ELx (x > 0)
 * that was using the SP EL0 stack pointer (thread context).
 */
      .section .text.privileged.same_el_with_sp_el0_serror_exception_handler
      .align 2
      .global same_el_with_sp_el0_serror_exception_handler
      .func same_el_with_sp_el0_serror_exception_handler
   same_el_with_sp_el0_serror_exception_handler:
      INTERRUPT_HANDLER_PROLOG
      bl ada_handle_el1_serror_exception
      INTERRUPT_HANDLER_EPILOG
      .endfunc

      .section .text.privileged.same_el_with_sp_elx_synchronous_exception_handler
      .align 2
      .global same_el_with_sp_elx_synchronous_exception_handler
      .func same_el_with_sp_elx_synchronous_exception_handler
   same_el_with_sp_elx_synchronous_exception_handler:
      INTERRUPT_HANDLER_PROLOG
      bl ada_handle_el1_unexpected_exception
      INTERRUPT_HANDLER_EPILOG
      .endfunc

/*
 * Entry point of the IRQ interrupt that fires at the current privileged ELx (x > 0)
 * that was using the SP ELx stack pointer (interrupt context).
 */
      .section .text.privileged.same_el_with_sp_elx_irq_interrupt_handler
      .align 2
      .global same_el_with_sp_elx_irq_interrupt_handler
      .func same_el_with_sp_elx_irq_interrupt_handler
   same_el_with_sp_elx_irq_interrupt_handler:
      INTERRUPT_HANDLER_PROLOG
      bl ada_handle_el1_unexpected_exception
      INTERRUPT_HANDLER_EPILOG
      .endfunc

/*
 * Entry point of the FIQ interrupt that fires at the current privileged ELx (x > 0)
 * that was using the SP ELx stack pointer (interrupt context).
 */
      .section .text.privileged.same_el_with_sp_elx_fiq_interrupt_handler
      .align 2
      .global same_el_with_sp_elx_fiq_interrupt_handler
      .func same_el_with_sp_elx_fiq_interrupt_handler
   same_el_with_sp_elx_fiq_interrupt_handler:
      INTERRUPT_HANDLER_PROLOG
      bl ada_handle_el1_unexpected_exception
      INTERRUPT_HANDLER_EPILOG
      .endfunc

/*
 * Entry point of the SError exception that fires at the current privileged ELx (x > 0)
 * that was using the SP ELx stack pointer (interrupt context).
 */
      .section .text.privileged.same_el_with_sp_elx_serror_exception_handler
      .align 2
      .global same_el_with_sp_elx_serror_exception_handler
      .func same_el_with_sp_elx_serror_exception_handler
   same_el_with_sp_elx_serror_exception_handler:
      INTERRUPT_HANDLER_PROLOG
      bl ada_handle_el1_unexpected_exception
      INTERRUPT_HANDLER_EPILOG
      .endfunc

/*
 * Entry point of the synchronous exception that fires at a lower EL (lower privilege level)
 *
 * For SVC exceptions, register x0 indicates the action to perform:
 * - 0 perform RTOS task synchronous context switch
 * - 1 switch to privileged mode and return to the caller
 *
 * NOTE: Right after entering an EL1 exception, sp is SP_EL1,
 * which we don't use, as we handle exceptions using SP_EL0.
 *
 * CAUTION: This routine cannot use any stack space, before it invokes
 * INTERRUPT_HANDLER_PROLOG, as we do not define a stack for SP_EL1.
 */
      .section .text.privileged.lower_el_synchronous_exception_handler
      .align 2
      .global lower_el_synchronous_exception_handler
      .func lower_el_synchronous_exception_handler
   lower_el_synchronous_exception_handler:
      COMMON_SYNCHRONOUS_EXCEPTION_HANDLER
      .endfunc

/*
 * Entry point of the IRQ interrupt that fires at a lower EL (lower privilege level)
 */
      .section .text.privileged.lower_el_irq_interrupt_handler
      .align 2
      .global lower_el_irq_interrupt_handler
      .func lower_el_irq_interrupt_handler
   lower_el_irq_interrupt_handler:
      // Save the current thread's CPU state on its own stack:
      INTERRUPT_HANDLER_PROLOG

      bl ada_handle_el1_irq_interrupt

      // Run the thread scheduler to select next thread to run and
      // resume execution of the newly selected thread
      INTERRUPT_HANDLER_EPILOG
      .endfunc

/*
 * Entry point of the FIQ interrupt that fires at a lower EL (lower privilege level)
 */
      .section .text.privileged.lower_el_fiq_interrupt_handler
      .align 2
      .global lower_el_fiq_interrupt_handler
      .func lower_el_fiq_interrupt_handler
   lower_el_fiq_interrupt_handler:
      // Save the current thread's CPU state on its own stack:
      INTERRUPT_HANDLER_PROLOG

      bl ada_handle_el1_fiq_interrupt

      // Run the thread scheduler to select next thread to run and
      // resume execution of the newly selected thread
      INTERRUPT_HANDLER_EPILOG
      .endfunc

/*
 * Entry point of the SError exception that fires at a lower EL (lower privilege level)
 */
      .section .text.privileged.lower_el_serror_exception_handler
      .align 2
      .global lower_el_serror_exception_handler
      .func lower_el_serror_exception_handler
   lower_el_serror_exception_handler:
      INTERRUPT_HANDLER_PROLOG
      bl ada_handle_el1_serror_exception
      INTERRUPT_HANDLER_EPILOG
      .endfunc

/*
 * Entry point of the synchronous exception that fires at a lower EL (lower privilege level),
 * when the CPU was in aarch32 execution state
 */
      .section .text.privileged.aarch32_lower_el_synchronous_exception_handler
      .align 2
      .global aarch32_lower_el_synchronous_exception_handler
      .func aarch32_lower_el_synchronous_exception_handler
   aarch32_lower_el_synchronous_exception_handler:
      INTERRUPT_HANDLER_PROLOG
      bl ada_handle_el1_unexpected_exception
      INTERRUPT_HANDLER_EPILOG
      .endfunc

/*
 * Entry point of the IRQ interrupt that fires at a lower EL (lower privilege level)
 * when the CPU was in aarch32 execution state
 */
      .section .text.privileged.aarch32_lower_el_irq_interrupt_handler
      .align 2
      .global aarch32_lower_el_irq_interrupt_handler
      .func aarch32_lower_el_irq_interrupt_handler
   aarch32_lower_el_irq_interrupt_handler:
      INTERRUPT_HANDLER_PROLOG
      bl ada_handle_el1_unexpected_exception
      INTERRUPT_HANDLER_EPILOG
      .endfunc

/*
 * Entry point of the FIQ interrupt that fires at a lower EL (lower privilege level)
 * when the CPU was in aarch32 execution state
 */
      .section .text.privileged.aarch32_lower_el_fiq_interrupt_handler
      .align 2
      .global aarch32_lower_el_fiq_interrupt_handler
      .func aarch32_lower_el_fiq_interrupt_handler
   aarch32_lower_el_fiq_interrupt_handler:
      INTERRUPT_HANDLER_PROLOG
      bl ada_handle_el1_unexpected_exception
      INTERRUPT_HANDLER_EPILOG
      .endfunc

/*
 * Entry point of the SError exception that fires at a lower EL (lower privilege level)
 * when the CPU was in aarch32 execution state
 */
      .section .text.privileged.aarch32_lower_el_serror_exception_handler
      .align 2
      .global aarch32_lower_el_serror_exception_handler
      .func aarch32_lower_el_serror_exception_handler
   aarch32_lower_el_serror_exception_handler:
      INTERRUPT_HANDLER_PROLOG
      bl ada_handle_el1_unexpected_exception
      INTERRUPT_HANDLER_EPILOG
      .endfunc

/*
 * Perform first HirTOS thread context switch
 */
   .section .text.privileged.first_thread_context_switch
      .align 2
      .global first_thread_context_switch
      .func first_thread_context_switch
   first_thread_context_switch:
      /*
       * NOTE: To start executing the first thread, we pretend that we are returning from an
       * interrupt, since before RTOS tasking is started, we have been executing in the reset
       * exception handler.
       */
      msr DAIFset, #DAIF_SETCLR_I_BIT_MASK
      isb
      INTERRUPT_HANDLER_EPILOG
      .endfunc

/*
 * Transitions the CPU from EL1 (privileged mode) to EL0 (unprivileged mode) with interrupts enabled.
 */
      .section .text.privileged.switch_cpu_to_unprivileged_mode
      .align 2
      .global switch_cpu_to_unprivileged_mode
      .func switch_cpu_to_unprivileged_mode
   switch_cpu_to_unprivileged_mode:
      /*
       * Transition from EL1 to EL0, by returning from an EL1 exception into EL0.
       * Return to EL0 with all exceptions/interrupts enabled and using SP_EL0 stack pointer.
       */
      // Disable CPU interrupting, so that we don't get interrupted before executing eret:
      msr DAIFset, #(DAIF_SETCLR_I_BIT_MASK | DAIF_SETCLR_F_BIT_MASK)
      isb
      // Set exception return address to be the caller's return address:
      msr elr_el1, lr
      // Set SPSR_EL1 to EL0, SP_EL0, interrupts enabled:
      mov x0, #PSTATE_EL_EL0_MASK
      mrs x1, daif
      and x1, x1, #(~(DAIF_SETCLR_I_BIT_MASK | DAIF_SETCLR_F_BIT_MASK))
      orr x0, x0, x1
      msr spsr_el1, x0
      // return from exception:
      eret
      .endfunc
