/*
 * Copyright (c) 2025, German Rivera
 *
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef HIRTOS_CPU_ARCH_INTERFACE_ASM_H
#define HIRTOS_CPU_ARCH_INTERFACE_ASM_H

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
#define ACTLR_EL2_CPUACTLR_MASK BIT(0u)
#define ACTLR_EL2_CPUECTLR_MASK BIT(1u)

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

/*
 * Bit masks for HCR_EL2 register bit fields
 */
#define HCR_EL2_RW_MASK BIT(31u)

/*
 * Bit masks for ESR_EL1 register bit fields
 */
#define ESR_EL1_SVC_ISS_MASK MULTI_BIT_MASK(24u, ESR_EL1_SVC_ISS_SHIFT)
#define ESR_EL1_SVC_ISS_SHIFT 0u
#define ESR_EL1_EC_MASK MULTI_BIT_MASK(31u, ESR_EL1_EC_SHIFT)
#define ESR_EL1_EC_SHIFT 26u

#define ESR_EL1_EC_AARCH64_SVC_EXCEPTION 0x15u

/**
 * ISR stack + guard size (in bytes)
 */
#define ISR_GUARDED_STACK_SIZE (ISR_STACK_SIZE + STACK_GUARD_SIZE)

#define ISR_STACK_SIZE (2u * PAGE_SIZE)

/**
 * Stack guard size (in bytes)
 */
#define STACK_GUARD_SIZE PAGE_SIZE

/**
 * Cache line size (in bytes)
 */
#define CACHE_LINE_SIZE 64u

/**
 * Page line size (in bytes)
 */
#define PAGE_SIZE (4u * 1024u)

#define MPIDR_CORE_ID_MASK      MULTI_BIT_MASK(7u, MPIDR_CORE_ID_SHIFT)
#define MPIDR_CORE_ID_SHIFT     0

#define KERNEL8_IMG_BOOT_ADDR 0x80000u

#define UART_BOOT_LOAD_ADDR 0x100000u

#endif // HIRTOS_CPU_ARCH_INTERFACE_ASM_H