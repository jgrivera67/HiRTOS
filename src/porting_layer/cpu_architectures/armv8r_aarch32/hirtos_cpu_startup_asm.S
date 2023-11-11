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
#define CPSR_A_BIT_MASK BIT(8u)
#define CPSR_MODE_MASK  MULTI_BIT_MASK(4u, 0)

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
 * Stack guard size (in bytes)
 */
#define STACK_GUARD_SIZE CACHE_LINE_SIZE

/**
 * Cache line size (in bytes)
 */
#define CACHE_LINE_SIZE 64u

#define MPIDR_CORE_ID_MASK      MULTI_BIT_MASK(7u, MPIDR_CORE_ID_SHIFT)
#define MPIDR_CORE_ID_SHIFT     0

#define SYSTEM_CLOCK_FREQUENCY_HZ 100000000

#define FAST_MODELS_COUNTER_CONTROL_REG 0xaa430000

/*
 * Imported symbols
 */
	.extern isr_stack			                            /* defined in startup.adb */
	.extern ada_reset_handler			                   /* defined in startup.adb */
	.extern el1_undefined_instruction_exception_handler /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern el1_supervisor_call_exception_handler       /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern el1_prefetch_abort_exception_handler        /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern el1_data_abort_exception_handler            /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern el1_irq_interrupt_handler                   /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern el1_fiq_interrupt_handler                   /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern el2_undefined_instruction_exception_handler /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern el2_prefetch_abort_exception_handler        /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern el2_data_abort_exception_handler            /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern el2_irq_interrupt_handler                   /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern el2_fiq_interrupt_handler                   /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern el2_hypervisor_exception_handler            /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */

/**
 * Cortex-R52 EL1 interrupt vector table
 */
        .section .text.privileged.interrupt_vector_table, "ax"
        .align 5 // 32-byte aligned
        .global el1_interrupt_vector_table
el1_interrupt_vector_table:
	b reset_handler                               /* Reset */
	b el1_undefined_instruction_exception_handler /* Undefined Instruction */
	b el1_supervisor_call_exception_handler       /* Supervisor Call */
	b el1_prefetch_abort_exception_handler        /* Abort (prefetch) */
	b el1_data_abort_exception_handler            /* Abort (data) */
	b el1_undefined_instruction_exception_handler /* Hypervisor Exception */
	b el1_irq_interrupt_handler                   /* IRQ */
   b el1_fiq_interrupt_handler                   /* FIQ */

/**
 * Cortex-R52 EL2 interrupt vector table
 *
 * NOTE: On taking an exception, the exception level either increases or remains
 * the same. The exception level cannot decrease on taking an exception.
 */
        .section .text.privileged.interrupt_vector_table, "ax"
        .align 5 // 32-byte aligned
        .global el2_interrupt_vector_table
el2_interrupt_vector_table:
	b reset_handler                               /* Reset */
	b el2_undefined_instruction_exception_handler /* Undefined Instruction */
	b el2_undefined_instruction_exception_handler /* Supervisor Call */
	b el2_prefetch_abort_exception_handler        /* Abort (prefetch) */
	b el2_data_abort_exception_handler            /* Abort (data) */
	b el2_hypervisor_exception_handler            /* Hypervisor exceptions */
	b el2_irq_interrupt_handler                   /* IRQ */
   b el2_fiq_interrupt_handler                   /* FIQ */

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
 * Initializes general-purpose CPUs registers to a known value
 *
 * NOTE: This is done to avoid an erroneous lockstep compare error. We need to ensure
 * that the CPU registers of both CPUs are initialized with the same values before the
 * registers are used.
 *
 * @pre  CPU is in HYP mode (EL2)
 */
	.macro INIT_CPU_REGS
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
	.endm

/**
 * Initializes all EL2/EL1 banked CPUs registers to a known value
 *
 * NOTE: This is done to avoid an erroneous lockstep compare error. We need to ensure
 * that the CPU registers of both CPUs are initialized with the same values before the
 * registers are used, including function calls where the register values are pushed
 * onto the stack.
 *
 * @pre  CPU is in HYP mode (EL2)
 * @post CPU is in HYP mode (EL2)
 * @post Stack pointers for all CPU modes are set to NULL
 * @post Interrupts are disabled at the CPU in all CPU modes
 */
	.macro INIT_CPU_BANKED_REGS_FROM_EL2
        // CPU started in HYP mode from reset
        mov     sp,   #0
        mov     lr,   #0
        mov     r0,   #0
        msr     spsr_cxsf, r0
        msr     elr_hyp,  r0

        msr     sp_svc,   r0
        msr     lr_svc,   r0
        msr     spsr_svc, r0

        msr     r8_fiq,   r0
        msr     r9_fiq,   r0
        msr     r10_fiq,  r0
        msr     r11_fiq,  r0
        msr     r12_fiq,  r0
        msr     sp_fiq,   r0
        msr     lr_fiq,   r0
        msr     spsr_fiq, r0

        msr     sp_irq,   r0
        msr     lr_irq,   r0
        msr     spsr_irq, r0

        msr     sp_abt,   r0
        msr     lr_abt,   r0
        msr     spsr_abt, r0

        msr     sp_und,   r0
        msr     lr_und,   r0
        msr     spsr_und, r0

        /*
         * NOTE: SYS mode and USR mode share the same sp and lr
         * and they don't have spsr.
         */
        msr     sp_usr,   r0
        msr     lr_usr,   r0
	.endm

/**
 * Initializes all EL1 banked CPUs registers to a known value
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
	.macro INIT_CPU_BANKED_REGS_FROM_EL1
        // CPU started in SVC mode from reset
        mov     sp,   #0
        mov     lr,   #0
        mov     r0,   #0
        msr     spsr_cxsf, r0

        msr     CPSR_c, #(CPSR_FAST_INTERRUPT_MODE | CPSR_NO_INT)
        mov     r8,   #0
        mov     r9,   #0
        mov     r10,  #0
        mov     r11,  #0
        mov     r12,  #0
        mov     sp,   #0
        mov     lr,   #0
        msr     spsr_cxsf, r0

        msr     CPSR_c, #(CPSR_INTERRUPT_MODE | CPSR_NO_INT)
        mov     sp,   #0
        mov     lr,   #0
        msr     spsr_cxsf, r0

        msr     CPSR_c, #(CPSR_ABORT_MODE | CPSR_NO_INT)
        mov     sp,   #0
        mov     lr,   #0
        msr     spsr_cxsf, r0

        msr     CPSR_c, #(CPSR_UNDEFINED_MODE | CPSR_NO_INT)
        mov     sp,   #0
        mov     lr,   #0
        msr     spsr_cxsf, r0

        /*
         * NOTE: SYS mode and USR mode share the same sp and lr
         * and they don't have spsr.
         */
        msr     CPSR_c, #(CPSR_SYSTEM_MODE | CPSR_NO_INT)
        mov     sp,   #0
        mov     lr,   #0
	.endm

/**
 * Set VBAR register
 * Modifies registers r0
 */
	.macro SET_VBAR _vector_base_addr_
        ldr r0, =\_vector_base_addr_
        mcr p15, 0, r0, c12, c0, 0      // write VBAR
	.endm

/**
 * Set HVBAR register
 * Modifies registers r0
 */
	.macro SET_HVBAR _vector_base_addr_
        ldr r0, =\_vector_base_addr_
        mcr p15, 4, r0, c12, c0, 0      // write HVBAR
	.endm

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
 * System Reset handler entry point
 */
	.section .text.privileged.reset_handler
	.align 2
	.global reset_handler
        .func reset_handler
reset_handler:
        INIT_CPU_REGS

#if defined(ARM_FVP_SIMULATOR)
        /*
         * Enable use of generic timer for ARM FVP platform:
         */
        ldr r0, =#FAST_MODELS_COUNTER_CONTROL_REG
        ldr r1, [r0]
        orr r1, r1, #0x3u
        str r1, [r0]
#endif

        /*
         * Check if we booted as a partition (guest)
         *
         * NOTE: The physical machine boots at EL2, but a partition (guest)
         * boots at EL1.
         */
        mrs     r0, cpsr
        and     r0, r0, #CPSR_MODE_MASK
        cmp     r0, #CPSR_HYPERVISOR_MODE
        ldrne  r0, =hirtos_booted_as_partition
        movne  r1, #1
        strbne r1, [r0]
        bne     reset_handler_el1

        /*
         * Set generic timer's CNTFRQ register to the system clock frequency, while in EL2,
         * as this cannot be done from EL1.
         */
        ldr r0, =#SYSTEM_CLOCK_FREQUENCY_HZ
        mcr p15, 0, r0, c14, c0, 0

        SET_HVBAR el2_interrupt_vector_table

                                // CPU in HYP mode (EL2)
        INIT_CPU_BANKED_REGS_FROM_EL2
                                // CPU in HYP mode (EL2)

#if !defined(HIRTOS_SEPARATION_KERNEL)
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
        msr spsr, r0
        ldr r0, =reset_handler_el1
        msr elr_hyp, r0
        eret
#else
        b reset_handler_common
#endif // defined(UNSUPERVISED_RTOS)

reset_handler_el1:
        SET_VBAR el1_interrupt_vector_table
                                // CPU in SVC mode (EL1)
        INIT_CPU_BANKED_REGS_FROM_EL1
                                // CPU in SYS mode (EL1)

reset_handler_common:
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

        /*
         * Enable async aborts:
         */
        cpsie a
                                // r0 = CPU id
	     bl ada_reset_handler

        /*
         * We should never come here:
         */
1:      wfi
	     b 1b
        .endfunc
