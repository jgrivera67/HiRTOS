/*
 * Copyright (c) 2022, German Rivera
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

        .syntax unified
        .cpu cortex-r52
        .arm

#define BIT(_bit_index) (1u << (_bit_index))

#define MULTI_BIT_MASK(_most_significant_bit_index,                     \
                       _least_significant_bit_index)                    \
        (BIT(_most_significant_bit_index) |                             \
         ((BIT(_most_significant_bit_index) - 1u) &                     \
          ~(BIT(_least_significant_bit_index) - 1u)))

/*
 * Bit masks for the CPSR register's bit fields:
 */
#define CPSR_F_BIT_MASK BIT(6u)
#define CPSR_I_BIT_MASK BIT(7u)
#define CPSR_MODE_MASK MULTI_BIT_MASK(4u, 0u)

/*
 * Bit masks for the FPEXC register's bit fields:
 */
#define FPEXC_EN_BIT_MASK BIT(30u)

/**
 * ARM-CR52 privilege modes
 */
#define CPSR_USER_MODE 0x10u
#define CPSR_FAST_INTERRUPT_MODE 0x11u
#define CPSR_INTERRUPT_MODE 0x12u
#define CPSR_SUPERVISOR_MODE 0x13u      // EL1
#define CPSR_MONITOR_MODE 0x16u         // EL3
#define CPSR_ABORT_MODE 0x17u
#define CPSR_HYPERVISOR_MODE 0x1Au      // EL2
#define CPSR_UNDEFINED_MODE 0x1Bu
#define CPSR_SYSTEM_MODE 0x1Fu

#define CPSR_NO_INT ((CPSR_F_BIT_MASK) | (CPSR_I_BIT_MASK))

/**
 * ISR stack size (in bytes)
 */
#define ISR_STACK_SIZE (4u*1024u + STACK_GUARD_SIZE)

/**
 * stack guard size (in bytes)
 */
#define STACK_GUARD_SIZE 64u

#define MPIDR_CORE_ID_MASK      MULTI_BIT_MASK(7u, MPIDR_CORE_ID_SHIFT)
#define MPIDR_CORE_ID_SHIFT     0

#define SYSTEM_CLOCK_FREQUENCY_HZ 100000000

/*
 * Imported symbols
 */
	.extern isr_stack			            /* defined in startup.adb */
	.extern ada_reset_handler			    /* defined in startup.adb */
	.extern undefined_instruction_exception_handler     /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern supervisor_call_exception_handler           /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern prefetch_abort_exception_handler            /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern data_abort_exception_handler                /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern irq_interrupt_handler                       /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern fiq_interrupt_handler                       /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */

/**
 * Cortex-R52 interrupt vector table
 */
        .section .text.privileged.interrupt_vector_table, "ax"
        .global interrupt_vector_table
interrupt_vector_table:
	b reset_handler                           /* Reset */
	b undefined_instruction_exception_handler /* Undefined Instruction */
	b supervisor_call_exception_handler       /* Supervisor Call */
	b prefetch_abort_exception_handler        /* Abort (prefetch) */
	b data_abort_exception_handler            /* Abort (data) */
	nop                                       /* Reserved */
	b irq_interrupt_handler                   /* IRQ */
        b fiq_interrupt_handler                   /* FIQ */

/**
 * Get sctlr
 * @post \_dest_reg_ = value of sctlr_el1
 */
	.macro GET_SCTLR _dest_reg_
        mrc p15, 0, \_dest_reg_, c0, c0, 0
	.endm


/**
 * Set sctlr
 * @post sctlr = \_dest_reg_
 */
	.macro SET_SCTLR _dest_reg_
        mcr p15, 0, \_dest_reg_, c1, c0, 0
	.endm

/**
 * Get CPU id from MPIDR
 * @post CPU id is in \_dest_reg_
 */
	.macro GET_CPU_ID _dest_reg_
        mrc p15, 0, \_dest_reg_, c0, c0, 5      // read MPIDR
        and \_dest_reg_, \_dest_reg_, #MPIDR_CORE_ID_MASK
        // NOTE: lsr below is not necessary as shift is 0
        //lsr \_dest_reg_, \_dest_reg_, #MPIDR_CORE_ID_SHIFT
	.endm

/**
 * Initializes minimum set of CPU registers for EL2 (HYP mode) to a known value.
 *
 * NOTE: This is done to avoid an erroneous lockstep compare error. We need to ensure
 * that the CPU registers of both CPUs are initialized with the same values before the
 * registers are used.
 *
 * @pre  CPU is in HYP mode (EL2)
 */
	.macro INIT_CPU_REGS_EL2
    // Starting in HYP mode from reset
    mov     r0,   #0
    mov     sp,   #0
    mov     lr,   #0
    msr     spsr_hyp, #0
    msr     elr_hyp,  #0
	.endm

/**
 * Initializes all CPUs registers to a known value, including banked registers
 * for all EL1 CPU modes.
 *
 * NOTE: This is done to avoid an erroneous lockstep compare error. We need to ensure
 * that the CPU registers of both CPUs are initialized with the same values before the
 * registers are used, including function calls where the register values are pushed
 * onto the stack.
 *
 * @pre  CPU is in SVC mode (EL1)
 * @post CPU is in SYS mode (EL1)
 * @post Stack pointers for all CPU modes are set to NULL
 * @post Interrupts are disabled at the CPU in all CPU modes
 */
	.macro INIT_CPU_REGS_EL1
        // Starting in SVC mode
        mov     r0,   #0
        mov     r1,   #0
        mov     r2,   #0
        mov     r3,   #0
        mov     r4,   #0
        mov     r5,   #0
        mov     r6,   #0
        mov     r7,   #0
        mov     r8,   #0
        mov     r9,   #0
        mov     r10,  #0
        mov     r11,  #0
        mov     r12,  #0
        mov     sp,   #0
        mov     lr,   #0
        msr     spsr, #0

        msr     CPSR_c, #(CPSR_FAST_INTERRUPT_MODE | CPSR_NO_INT)
        mov     r8,   #0
        mov     r9,   #0
        mov     r10,  #0
        mov     r11,  #0
        mov     r12,  #0
        mov     sp,   #0
        mov     lr,   #0
        msr     spsr, #0

        msr     CPSR_c, #(CPSR_INTERRUPT_MODE | CPSR_NO_INT)
        mov     sp,   #0
        mov     lr,   #0
        msr     spsr, #0

        msr     CPSR_c, #(CPSR_ABORT_MODE | CPSR_NO_INT)
        mov     sp,   #0
        mov     lr,   #0
        msr     spsr, #0

        msr     CPSR_c, #(CPSR_UNDEFINED_MODE | CPSR_NO_INT)
        mov     sp,   #0
        mov     lr,   #0
        msr     spsr, #0

        /*
         * NOTE: SYS mode and USR mode share the same sp and lr
         * and they don't have spsr.
         */
        msr     CPSR_c, #(CPSR_SYSTEM_MODE | CPSR_NO_INT)
        mov     sp,   #0
        mov     lr,   #0
	.endm

/**
 * System Reset handler entry point
 */
	.section .text.privileged.reset_handler
	.align 2
	.global reset_handler
        .func reset_handler
reset_handler:
        INIT_CPU_REGS_EL2

        /*
         * Set generic timer's CNTFRQ register to the system clock freuency, while in EL2,
         * as this cannot be done from EL1.
         */
        ldr r0, =#SYSTEM_CLOCK_FREQUENCY_HZ
        mcr p15, 0, r0, c14, c0, 0

        /*
         * Disable HVC instruciton, by setting HCD bit in HCR register:
         */
        mrc p15, 4, r0, c1, c1, 0
        orr r0, #BIT(29u)
        mcr p15, 4, r0, c1, c1, 0

        /*
         * Set HACTLR to allow EL1 access to system registers
         */
        mov r0, #MULTI_BIT_MASK(15, 0)
        mcr p15, 4, r0, c1, c0, 1

        /*
         * As out of reset, the Cortex-R52 is in EL2 (HYP mode), to go to EL1
         * (SVC mode), we need to return from an EL2 exception into EL1.
         */
        mov r0, #CPSR_SUPERVISOR_MODE
        msr spsr_hyp, r0
        ldr r0, =reset_handler_el1
        msr elr_hyp, r0
        eret

reset_handler_el1:
                                // CPU in SVC mode (EL1)
        INIT_CPU_REGS_EL1
                                // CPU in SYS mode (EL1)

        /*
         * Set ISR stack for calling CPU:
         */
        GET_CPU_ID r0           // r0 = CPU id
        ldr     r1, =isr_stacks
        mov     r2, #ISR_STACK_SIZE
        mul     r2, r0, r2      // r2 = byte offset of per-cpu stack base
        add     r1, r1, r2      // r1 = per-cpu stack base address
        add     sp, r1, #ISR_STACK_SIZE

        /*
         * Set frame pointer to be the same as stack pointer:
         * (needed by unwind_stack())
         */
        mov     fp, sp
                                // r0 = CPU id
	bl ada_reset_handler

        /*
         * We should never come here:
         */
1:	wfi
	b 1b
        .endfunc
