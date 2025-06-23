/*
 * Copyright (c) 2025, German Rivera
 *
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include "hirtos_cpu_arch_interface_asm.h"

/*
 * Imported symbols
 */
        .extern interrupt_vector_table           /* defined in hirtos_cpu_arch_interface_interrupt_handling_asm.S */
        .extern isr_stacks                       /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
        .extern ada_reset_handler                /* defined in hirtos_cpu_startup_interface.adb */

/**
 * Get CPU id from MPIDR
 * @post CPU id is in \_dest_reg_
 * Clobbered registers: x1
 */
        .macro GET_CPU_ID _dest_reg_
        mrs \_dest_reg_, mpidr_el1
        and x1, \_dest_reg_, #MPIDR_EL1_MT_MASK
        cbnz x1, 0f
        ubfx \_dest_reg_, \_dest_reg_, #MPIDR_EL1_AFF0_LSB, #MPIDR_EL1_AFF0_WIDTH
        b 1f
0:
        ubfx \_dest_reg_, \_dest_reg_, #MPIDR_EL1_AFF1_LSB, #MPIDR_EL1_AFF1_WIDTH
1:
        .endm

/**
 * Initializes general-purpose CPUs registers to a known value
 *
 * NOTE: This is done to avoid an erroneous lockstep compare error. We need to ensure
 * that the CPU registers of both CPUs are initialized with the same values before the
 * registers are used.
 *
 * @pre  CPU is in HYP mode (EL2)
 */
        .macro INIT_CPU_REGS
        mov     x0,   xzr
        mov     x1,   xzr
        mov     x2,   xzr
        mov     x3,   xzr
        mov     x4,   xzr
        mov     x5,   xzr
        mov     x6,   xzr
        mov     x7,   xzr
        mov     x8,   xzr
        mov     x9,   xzr
        mov     x10,  xzr
        mov     x11,  xzr
        mov     x12,  xzr
        mov     x13,  xzr
        mov     x14,  xzr
        mov     x15,  xzr
        mov     x16,  xzr
        mov     x17,  xzr
        mov     x18,  xzr
        mov     x19,  xzr
        mov     x20,  xzr
        mov     x21,  xzr
        mov     x22,  xzr
        mov     x23,  xzr
        mov     x24,  xzr
        mov     x25,  xzr
        mov     x26,  xzr
        mov     x27,  xzr
        mov     x28,  xzr
        mov     x29,  xzr
        mov     x30,  xzr
        .endm

/**
 * Set VBAR_EL1 register
 * Modifies registers x0
 */
        .macro SET_VBAR_EL1 _vector_base_addr_
        adrp x0, \_vector_base_addr_
        add x0, x0, #:lo12:\_vector_base_addr_
        msr vbar_el1, x0
        .endm

/**
 * Set VBAR_EL2 register
 * Modifies registers x0
 */
        .macro SET_VBAR_EL2 _vector_base_addr_
        adrp x0, \_vector_base_addr_
        add x0, x0, #:lo12:\_vector_base_addr_
        msr vbar_el2, x0
        .endm

        .section .globals_initialized_at_load_time
   .align 6 // 64-byte aligned
        .global hirtos_secondary_cores_start_gate
hirtos_secondary_cores_start_gate:
   //.word
   .space CACHE_LINE_SIZE

   .global hirtos_global_vars_elaborated_flag
hirtos_global_vars_elaborated_flag:
   //.word
   .space CACHE_LINE_SIZE

   .global hirtos_booted_as_partition
hirtos_booted_as_partition:
   //.byte
   .space 1

/**
 * System Reset handler entry point
 */
        .section .text.privileged.reset_handler
        .align 2
        .global reset_handler
        .func reset_handler
reset_handler:
        /*
         * Disable all exceptions and interrupts:
         */
        msr DAIFset, #DAIF_SETCLR_ALL_MASK

        INIT_CPU_REGS

        /*
         * Check if we booted as a partition (guest)
         *
         * NOTE: The physical machine boots at EL2, but a partition (guest)
         * boots at EL1.
         */
        mrs    x0, CurrentEL
        and    x0, x0, #PSTATE_EL_MASK
        cmp    x0, #PSTATE_EL_EL2_MASK
        bne    1f
        mov    w1, #0
        b      2f
1:
        mov    w1, #1
2:
        adrp x2, hirtos_booted_as_partition
        add x2, x2, #:lo12:hirtos_booted_as_partition
        strb   w1, [x2]
        // x0 is still CurrentEL's EL field
        cmp    x0, #PSTATE_EL_EL2_MASK
        bne    reset_handler_el1

#if defined(HIRTOS_SEPARATION_KERNEL)
        SET_VBAR_EL2 interrupt_vector_table
        b reset_handler_common
#else
        /*
         * Clear SCTLR_EL1:
         */
        msr sctlr_el1, xzr

        /*
         * Set ACTLR_EL2 to allow EL1 access to system registers
         */
        mov x0, #(ACTLR_EL2_CPUACTLR_MASK | ACTLR_EL2_CPUECTLR_MASK)
        msr actlr_el2, x0

        /*
         * Set the execution state for EL1 to be AArch64:
         *
         * NOTE: VM bit is 0 meaning that stage 2 address translation is disabled
         */
        mov x0, #HCR_EL2_RW_MASK
        msr hcr_el2, x0

        /*
         * Transition from EL2 to EL1, by returning from an EL2 exception into EL1.
         * Return to EL1 with all exceptions/interrupts disabled and using SP_EL0 stack pointer.
         */
        mov x0, #(PSTATE_DAIF_MASK | PSTATE_EL_EL1_MASK)
        msr spsr_el2, x0
        adr x0, reset_handler_el1
        msr elr_el2, x0
        eret
#endif // defined(HIRTOS_SEPARATION_KERNEL)

reset_handler_el1:
        SET_VBAR_EL1 interrupt_vector_table

reset_handler_common:
        /*
         * Enables the processor to receive instruction cache and TLB maintenance operations broadcast from other
         * processors in the cluster.
         *
         * NOTE: This must be done before enabling the caches and MMU, or performing any cache and TLB
         * maintenance operations.
         */
#if 0 // This does not work on Raspberry PI
        mrs x0, s3_1_c15_c2_1 // read cpuectlr_el1
        orr x0, x0, #CPUECTLR_EL1_SMPEN_MASK
        msr s3_1_c15_c2_1, x0 // write cpuectlr_el1
#endif

        /*
         * Set ISR stack (SP_EL0 stack pointer) for calling CPU:
         */
        GET_CPU_ID x0           // x0 = CPU id
        //??? TODO: Remove this for multi-core
        cbnz x0, park_cpu
        //???
        adrp x1, isr_stacks
        add x1, x1, #:lo12:isr_stacks
        mov     x2, #ISR_GUARDED_STACK_SIZE
        mul     x3, x0, x2      // x3 = byte offset of per-cpu stack base
        add     x1, x1, x3      // x1 = per-cpu stack base address
        add     sp, x1, x2

        /*
         * Set frame pointer to be the same as stack pointer:
         */
        mov     fp, sp

        /*
         * Enable async SError exceptions:
         */
        msr DAIFclr, #DAIF_SETCLR_A_BIT_MASK
                                // x0 = CPU id
        bl ada_reset_handler

        /*
         * We should never come here:
         */
        b park_cpu
        .endfunc

        .section .text.park_cpu
        .global park_cpu
        .func reset_handler
park_cpu:
        /*
         * Disable all exceptions and interrupts:
         */
        msr DAIFset, #DAIF_SETCLR_ALL_MASK

        /*
         * If CPU core 0 and booted from UART, jump back to the UART boot loader:
         */
        GET_CPU_ID x0           // x0 = CPU id
        cbnz x0, 1f
        adr x0, reset_handler
        cmp x0, #UART_BOOT_LOAD_ADDR
        bne 1f

        /*
         * Clear SCTLR_EL1:
         *
         * NOTE: Among other things, this ensures that the MMU is disabled, so that we
         * can execute instructions where the UART boot loader is located.
         */
        msr sctlr_el1, xzr

        /*
         * Jump back to UART boot loader:
         */
        mov x0, #KERNEL8_IMG_BOOT_ADDR
        br x0

        /*
         * Park the CPU
         */
1:      wfi
        b 1b
        .endfunc

/**
 * Alternating bit pattern that secondary cores wait to see, before
 * they start waiting for hirtos_global_vars_elaborated_flag to be set
 * by the primary core.
 */
   .section .rodata.hirtos_secondary_cores_start_gate_value
   .balign 8
   .global hirtos_secondary_cores_start_gate_value
hirtos_secondary_cores_start_gate_value:
   .dword 0xa5a5a5a5a5a5a5a5
