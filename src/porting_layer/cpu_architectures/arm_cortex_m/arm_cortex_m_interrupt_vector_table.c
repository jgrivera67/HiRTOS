/*
 * Copyright (c) 2026, German Rivera
 *
 * SPDX-License-Identifier: Apache-2.0
 */

/**
 * @summary ARM Cortex-M interrupt vector table
 */

#include <stdint.h>

/* Cortex-M Common Vector Entry indices */
enum cortex_m_common_vector_entry {
   INITIAL_MSP = 0,
   RESET_EXCEPTION,
   NMI_EXCEPTION,
   HARDFAULT_EXCEPTION,
   MEMORYMANAGEMENT_EXCEPTION,
   BUSFAULT_EXCEPTION,
   USAGEFAULT_EXCEPTION,
   RESERVED1,
   RESERVED2,
   RESERVED3,
   RESERVED4,
   SVCALL_EXCEPTION,
   DEBUGMONITOR_EXCEPTION,
   RESERVED5,
   PENDSV_EXCEPTION,
   SYSTICK_EXCEPTION,
   FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX
};

#define NUM_INTERNAL_INTERRUPTS 16u
#define NUM_EXTERNAL_INTERRUPTS 32u
#define NUM_INTERRUPT_VECTOR_TABLE_ENTRIES (NUM_INTERNAL_INTERRUPTS + NUM_EXTERNAL_INTERRUPTS)
#define CACHE_LINE_SIZE 32u

extern void* _stacks_end[];

/* Exception and interrupt handlers */
extern void reset_handler(void);
extern void non_maskable_interrupt_handler(void);
extern void hard_fault_exception_handler(void);
extern void memory_management_exception_handler(void);
extern void bus_fault_exception_handler(void);
extern void usage_fault_exception_handler(void);
extern void unexpected_exception_handler(void);
extern void svcall_exception_handler(void);
extern void debug_monitor_exception_handler(void);
extern void pendsv_exception_handler(void);
extern void systick_interrupt_handler(void);
extern void external_interrupt_handler(void);

/* Interrupt Vector Table */
__attribute__((section(".text.privileged.interrupt_vector_table")))
const void* const Interrupt_Vector_Table[] = {
   [INITIAL_MSP] = _stacks_end,
   [RESET_EXCEPTION] = reset_handler,
   [NMI_EXCEPTION] = non_maskable_interrupt_handler,
   [HARDFAULT_EXCEPTION] = hard_fault_exception_handler,
   [MEMORYMANAGEMENT_EXCEPTION] = memory_management_exception_handler,
   [BUSFAULT_EXCEPTION] = bus_fault_exception_handler,
   [USAGEFAULT_EXCEPTION] = usage_fault_exception_handler,
   [RESERVED1] = unexpected_exception_handler,
   [RESERVED4] = unexpected_exception_handler,
   [RESERVED4] = unexpected_exception_handler,
   [RESERVED4] = unexpected_exception_handler,
   [SVCALL_EXCEPTION] = svcall_exception_handler,
   [DEBUGMONITOR_EXCEPTION] = debug_monitor_exception_handler,
   [PENDSV_EXCEPTION] = pendsv_exception_handler,
   [SYSTICK_EXCEPTION] = systick_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 1] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 2] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 3] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 4] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 5] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 6] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 7] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 8] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 9] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 10] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 11] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 12] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 13] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 14] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 15] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 16] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 17] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 18] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 19] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 20] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 21] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 22] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 23] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 24] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 25] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 26] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 27] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 28] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 29] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 30] = external_interrupt_handler,
   [FIRST_EXTERNAL_INTERRUPT_VECTOR_INDEX + 31] = external_interrupt_handler
};

static_assert(sizeof(Interrupt_Vector_Table) / sizeof(void*) == NUM_INTERRUPT_VECTOR_TABLE_ENTRIES,
              "Interrupt Vector Table size mismatch");


__attribute__((section(".globals_initialized_at_load_time")))
alignas(CACHE_LINE_SIZE) uint32_t hirtos_secondary_cores_start_gate;

__attribute__((section(".globals_initialized_at_load_time")))
alignas(CACHE_LINE_SIZE) uint32_t hirtos_global_vars_elaborated_flag;

__attribute__((section(".globals_initialized_at_load_time")))
alignas(CACHE_LINE_SIZE) uint8_t hirtos_booted_as_partition;

/**
 * Alternating bit pattern that secondary cores wait to see, before
 * they start waiting for hirtos_global_vars_elaborated_flag to be set
 * by the primary core.
 */
__attribute__((section(".rodata.hirtos_secondary_cores_start_gate_value")))
const uint32_t hirtos_secondary_cores_start_gate_value = 0xa5a5a5a5;