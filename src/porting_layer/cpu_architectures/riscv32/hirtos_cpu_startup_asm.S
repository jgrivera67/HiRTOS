/*
 * Copyright (c) 2024, German Rivera
 *
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#define BIT(_bit_index) (1u << (_bit_index))

#define MULTI_BIT_MASK(_most_significant_bit_index,                     \
                       _least_significant_bit_index)                    \
        (BIT(_most_significant_bit_index) |                             \
         ((BIT(_most_significant_bit_index) - 1u) &                     \
          ~(BIT(_least_significant_bit_index) - 1u)))

/**
 * ISR stack size (in bytes)
 */
#define ISR_STACK_SIZE (4*1024 + STACK_GUARD_SIZE)

/**
 * Stack guard size (in bytes)
 */
#define STACK_GUARD_SIZE CACHE_LINE_SIZE

/**
 * Cache line size (in bytes)
 */
#define CACHE_LINE_SIZE 32

/*
 * Imported symbols
 */
	.extern isr_stacks			                         /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern ada_reset_handler			                   /* defined in hirtos_cpu_startup_interface.adb */
	.extern synchronous_exception_handler               /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern unexpected_interrupt_handler                /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern machine_timer_interrupt_handler             /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern machine_external_interrupt_handler          /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
   .extern __global_pointer                            /* defined in memory-layout.ld */

/**
 * Interrupt vector table if vectored interrupt mode is used.
 *
 * NOTE: The address of this table must be 256-byte aligned and
 * entries on the table must be 4 bytes long even if the compressed ISA
 * is used. The address of this table is used to set mtvec.BASE when
 * mtvec.MODE is set to 1 (mtvec.MODE = 1).
 */
        .section .text.privileged.interrupt_vector_jump_table /* section not accessible in U-mode */
        .align 8 // 256-byte aligned
        .global interrupt_vector_jump_table
interrupt_vector_jump_table:
        jal x0, synchronous_exception_handler                /* vector 0 */
        jal x0, unexpected_interrupt_handler                 /* vector 1 (supervisor software interrupt handler) */
        jal x0, unexpected_interrupt_handler                 /* vector 2 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 3 (machine software interrupt handler) */
        jal x0, unexpected_interrupt_handler                 /* vector 4 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 5 (supervisor timer interrupt handler) */
        jal x0, unexpected_interrupt_handler                 /* vector 6 (unused) */
        jal x0, machine_timer_interrupt_handler              /* vector 7 */
        jal x0, unexpected_interrupt_handler                 /* vector 8 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 9 (supervisor_external_interrupt_handler) */
        jal x0, unexpected_interrupt_handler                 /* vector 10 */
        jal x0, machine_external_interrupt_handler           /* vector 11 */
        jal x0, unexpected_interrupt_handler                 /* vector 12 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 13 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 14 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 15 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 16 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 17 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 18 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 20 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 21 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 22 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 23 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 24 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 25 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 26 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 27 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 28 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 29 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 30 (unused) */
        jal x0, unexpected_interrupt_handler                 /* vector 31 (unused) */
        /* end of interrupt_vector_jump_table */

	.section .globals_initialized_at_load_time
   .align 6 // 64-byte aligned
	.global hirtos_global_vars_elaborated_flag
hirtos_global_vars_elaborated_flag:
   .word 0
   .space CACHE_LINE_SIZE - 4

   .global hirtos_booted_as_partition
hirtos_booted_as_partition:
   .byte 0

/**
 * Get CPU id
 * @post CPU id is in \_dest_reg_
 */
	.macro GET_CPU_ID _dest_reg_
        csrr \_dest_reg_, mhartid
	.endm

/**
 * Cpu reset handler entry point
 */
        .section .text.privileged.reset_handler /* section not accessible in U-mode (see linker script) */
        .align 2
        .global reset_handler
        .cfi_startproc
        .cfi_undefined ra
reset_handler:
        la gp, __global_pointer

        /*
         * Set ISR stack for calling CPU:
         */
        GET_CPU_ID a0           // a0 = CPU id
        la      t1, isr_stacks
        li      t2, ISR_STACK_SIZE
        mul     t2, a0, t2      // t2 = byte offset of per-cpu stack base
        add     t1, t1, t2      // t1 = per-cpu stack base address
        li      t2, ISR_STACK_SIZE
        add     sp, t1, t2

        /* Initialize frame pointer (s0) (needed by unwind_stack()) */
        mv fp, sp

        /* Initialize mscratch to remember that we are in privileged mode */
        csrsi mscratch, 0x1

        call ada_reset_handler

        /*
         * We should never come here:
         */
1:      wfi
        j 1b
        .cfi_endproc
