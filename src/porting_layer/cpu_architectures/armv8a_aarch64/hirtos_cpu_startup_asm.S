/*
 * Copyright (c) 2025, German Rivera
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

/*
 * Bit masks PSTATE register bit fields
 */
#define PSTATE_SPSEL_MASK BIT(0) // Stack pointer selector: 1 = SP_ELx (x > 0), 0 = SP_EL0
#define PSTATE_EL_MASK  MULTI_BIT_MASK(3u, PSTATE_EL_SHIFT)
#define PSTATE_EL_SHIFT 2u
#define PSTATE_F_BIT_MASK BIT(6u) // Fiq
#define PSTATE_I_BIT_MASK BIT(7u) // Irq
#define PSTATE_A_BIT_MASK BIT(8u) // SError (Async Abort)
#define PSTATE_D_BIT_MASK BIT(9u) // Debug
#define PSTATE_DAIF_MASK (PSTATE_D_BIT_MASK | PSTATE_A_BIT_MASK | PSTATE_I_BIT_MASK | PSTATE_F_BIT_MASK)

/*
 * Bit masks for PSTATE EL field values:
 */
#define PSTATE_EL_EL0_MASK (0x0 << PSTATE_EL_SHIFT)
#define PSTATE_EL_EL1_MASK (0x1 << PSTATE_EL_SHIFT)
#define PSTATE_EL_EL2_MASK (0x2 << PSTATE_EL_SHIFT)
#define PSTATE_EL_EL3_MASK (0x3 << PSTATE_EL_SHIFT)

/*
 * Bit masks for ACTLR_EL2 register bit fields
 */
#define ACTLR_EL2_ACTLREN_MASK BIT(0u)
#define ACTLR_EL2_ECTLREN_MASK BIT(1u)

/*
 * Bit masks to use with msr DAIFset/DAIFclr:
 */
#define DAIF_SETCLR_F_BIT_MASK BIT(0u)
#define DAIF_SETCLR_I_BIT_MASK BIT(1u)
#define DAIF_SETCLR_A_BIT_MASK BIT(2u)
#define DAIF_SETCLR_D_BIT_MASK BIT(3u)
#define DAIF_SETCLR_ALL_MASK (DAIF_SETCLR_D_BIT_MASK | DAIF_SETCLR_A_BIT_MASK | DAIF_SETCLR_I_BIT_MASK | DAIF_SETCLR_F_BIT_MASK)
/*
 * Bit masks for the FPEXC register's bit fields:
 */
#define FPEXC_EN_BIT_MASK BIT(30u)


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

/*
 * Imported symbols
 */
	.extern isr_stack			                  /* defined in startup.adb */
	.extern ada_reset_handler			          /* defined in startup.adb */

	.extern same_el_with_sp_el0_synchronous_exception_handler /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern same_el_with_sp_el0_irq_interrupt_handler         /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern same_el_with_sp_el0_fiq_interrupt_handler         /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern same_el_with_sp_el0_serror_exception_handler      /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */

	.extern same_el_with_sp_elx_synchronous_exception_handler /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern same_el_with_sp_elx_irq_interrupt_handler         /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern same_el_with_sp_elx_fiq_interrupt_handler         /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern same_el_with_sp_elx_serror_exception_handler      /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */

	.extern lower_el_synchronous_exception_handler            /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern lower_el_irq_interrupt_handler                    /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern lower_el_fiq_interrupt_handler                    /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern lower_el_serror_exception_handler                 /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */

	.extern aarch32_lower_el_synchronous_exception_handler   /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern aarch32_lower_el_irq_interrupt_handler           /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern aarch32_lower_el_fiq_interrupt_handler           /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */
	.extern aarch32_lower_el_serror_exception_handler        /* defined in hirtos_cpu_arch_interface-interrupt_handling.adb */

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
        mrs \_dest_reg_, mpidr_el1
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
        ldr x0, =\_vector_base_addr_
        msr vbar_el1, x0
	.endm

/**
 * Set VBAR_EL2 register
 * Modifies registers x0
 */
	.macro SET_VBAR_EL2 _vector_base_addr_
        ldr x0, =\_vector_base_addr_
        msr vbar_el2, x0
	.endm

	.section .globals_initialized_at_load_time
   .align 6 // 64-byte aligned
	.global hirtos_secondary_cores_start_gate
hirtos_secondary_cores_start_gate:
   .word
   .space CACHE_LINE_SIZE

   .global hirtos_global_vars_elaborated_flag
hirtos_global_vars_elaborated_flag:
   .word
   .space CACHE_LINE_SIZE

   .global hirtos_booted_as_partition
hirtos_booted_as_partition:
   .byte
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
	msr	DAIFset, #(DAIF_SETCLR_D_BIT_MASK | DAIF_SETCLR_A_BIT_MASK | DAIF_SETCLR_I_BIT_MASK | DAIF_SETCLR_F_BIT_MASK)

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
        ldr    x0, =hirtos_booted_as_partition
        strb   w1, [x0]
        bne    reset_handler_el1

#if 0 //???
        /*
         * Set generic timer's CNTFRQ register to the system clock frequency, while in EL2,
         * as this cannot be done from EL1.
         */
        ldr x0, =#SYSTEM_CLOCK_FREQUENCY_HZ
        mcr p15, 0, x0, c14, c0, 0
#endif

#if defined(HIRTOS_SEPARATION_KERNEL)
        SET_VBAR_EL2 interrupt_vector_table
        b reset_handler_common
#else
        /*
         * Set ACTLR_EL2 to allow EL1 access to system registers
         */
        mov x0, #(ACTLR_EL2_ACTLREN_MASK | ACTLR_EL2_ECTLREN_MASK)
        msr actlr_el2, x0

        /*
         * Transition from EL2 to EL1, by returning from an EL2 exception into EL1.
         * Return to EL1 with all exceptions/interrupts disabled and using SP_EL0 stack pointer.
         */
        mov x0, #(PSTATE_DAIF_MASK | PSTATE_EL_EL1_MASK)
        msr spsr_el2, x0
        ldr x0, =reset_handler_el1
        msr elr_el2, x0
        eret
#endif // defined(HIRTOS_SEPARATION_KERNEL)

reset_handler_el1:
        SET_VBAR_EL1 interrupt_vector_table

reset_handler_common:
        /*
         * Set ISR stack (SP_EL0 stack pointer) for calling CPU:
         */
        GET_CPU_ID x0           // x0 = CPU id
        ldr     x1, =isr_stacks
        mov     x2, #ISR_STACK_SIZE
        mul     x3, x0, x2      // x3 = byte offset of per-cpu stack base
        add     x1, x1, x3      // x1 = per-cpu stack base address
        add     sp, x1, x2

        /*
         * Set frame pointer to be the same as stack pointer:
         * (needed by unwind_stack())
         */
        mov     fp, sp

        /*
         * Enable async SError exceptions:
         */
        msr	DAIFclr, #DAIF_SETCLR_A_BIT_MASK
                                // x0 = CPU id
	     bl ada_reset_handler

        /*
         * We should never come here:
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
   .align 2 // 4-byte aligned
   .global hirtos_secondary_cores_start_gate_value
hirtos_secondary_cores_start_gate_value:
   .word 0xa5a5a5a5
