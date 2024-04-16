/*
 * SPDX-FileCopyrightText: 2021-2022 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: Apache-2.0
 */

/*
 * Simplified memory map for the ESP32-C3 2nd stage bootloader.
 *
 *  The 2nd stage bootloader can take space up to the end of ROM shared
 *  buffers area (0x3fcdc710).
 */

USABLE_SRAM_SIZE = 400K - 16K;

/* The offset between Dbus and Ibus. Used to convert between 0x403xxxxx and 0x3fcxxxxx addresses. */
iram_dram_offset = 0x700000;

/* We consider 0x3fcdc710 to be the last usable address for 2nd stage bootloader stack overhead, dram_seg,
 * and work out iram_seg and iram_loader_seg addresses from there, backwards.
 */

/* These lengths can be adjusted, if necessary: */
bootloader_usable_dram_end = 0x3fcdc710;
bootloader_stack_overhead = 0x2000; /* For safety margin between bootloader data section and startup stacks */
bootloader_dram_seg_len = USABLE_SRAM_SIZE; /*0x5000;*/
bootloader_iram_loader_seg_len = 0x7000;
bootloader_iram_seg_len = USABLE_SRAM_SIZE; /*0x2000;*/

/* Start of the lower region is determined by region size and the end of the higher region */
bootloader_dram_seg_end = bootloader_usable_dram_end - bootloader_stack_overhead;
bootloader_dram_seg_start = 0x3FC80000; /*bootloader_dram_seg_end - bootloader_dram_seg_len;*/
bootloader_iram_loader_seg_start = 0x403ce710; /*bootloader_dram_seg_start - bootloader_iram_loader_seg_len + iram_dram_offset;*/
bootloader_iram_seg_start = 0x40380000; /*bootloader_iram_loader_seg_start - bootloader_iram_seg_len; */

STACK_POINTER_ALIGNMENT = 4;
CACHE_LINE_ALIGNMENT = 32;    /* Must match the cache-line size for cache flushing */
MPU_TEXT_REGION_SIZE = 256K;  /* Must be a power of two */
MPU_RODATA_REGION_SIZE = 32K; /* Must be a power of two */

MEMORY
{
  iram_seg (RWX) :                  org = bootloader_iram_seg_start, len = bootloader_iram_seg_len
  iram_loader_seg (RWX) :           org = bootloader_iram_loader_seg_start, len = bootloader_iram_loader_seg_len
  dram_seg (RW) :                   org = bootloader_dram_seg_start, len = bootloader_dram_seg_len
}

/* The app may use RAM for static allocations up to the start of iram_loader_seg.
 * If you have changed something above and this assert fails:
 * 1. Check what the new value of bootloader_iram_loader_seg start is.
 * 2. Update the value in this assert.
 * 3. Update (SRAM_DRAM_END + I_D_SRAM_OFFSET) in components/esp_system/ld/esp32c3/memory.ld.in to the same value.
 */
ASSERT(bootloader_iram_loader_seg_start == 0x403ce710, "bootloader_iram_loader_seg_start inconsistent with SRAM_DRAM_END");

/* Default entry point: */
ENTRY(reset_handler);

SECTIONS
{

  .iram_loader.text :
  {
    . = ALIGN (16);
    _loader_text_start = ABSOLUTE(.);
    KEEP (*(.text.privileged.reset_handler))
    _loader_text_end = ABSOLUTE(.);
  } > iram_loader_seg

  .iram.text :
  {
     . = ALIGN(MPU_TEXT_REGION_SIZE);
    __global_text_region_start = .;  /* NAPOT PMP region start boundary */

    *(.text.privileged.*)

    __privileged_text_region_end = .;
    PROVIDE (__unprivileged_text_start = .);

   /* Functions that are the only ones allowed to enter privileged mode */
    __syscall_functions_start = .;
    *(.text.syscall.*)
    __syscall_functions_end = .;

    *(.text.unlikely .text.unlikely.*)
    *(.text.startup .text.startup.*)
    *(.text .text.*)
    *(.gnu.linkonce.t.*)

    . = ALIGN(MPU_TEXT_REGION_SIZE);
    PROVIDE (__visible_text_end = .);
    __global_text_region_end = .; /* NAPOT PMP region end boundary */
  } > iram_seg

  /**
   * This section is required to skip text sections because Instruction_Bus_Sram_Alias and
   * Data_Bus_Sram_Alias reflect the same address space on different buses.
   */
  .data_bus_sram_alias_skip_fast_text (NOLOAD):
  {
    . += __global_text_region_end - __global_text_region_start;
  } > dram_seg

  .rodata :
  {
    . = ALIGN(MPU_RODATA_REGION_SIZE);
    PROVIDE_HIDDEN (__rodata_start = .);  /* NAPOT PMP region start boundary */
    *(.rdata)
    *(.rodata .rodata.*)
    *(.gnu.linkonce.r.*)
    *(.srodata.cst16)
    *(.srodata.cst8)
    *(.srodata.cst4)
    *(.srodata.cst2)
    *(.srodata .srodata.*)
    . = ALIGN(MPU_RODATA_REGION_SIZE);
    PROVIDE_HIDDEN (__rodata_end = .);   /* NAPOT PMP region end boundary */
    PROVIDE( __data_load = . );
  } > dram_seg

  .data :  AT (__data_load)
  {
    . = ALIGN(CACHE_LINE_ALIGNMENT); /* Start boundary for data cache flushing */
    __global_data_region_start = .;
    PROVIDE( __data_start = . );

    *(.gnu.linkonce.d.*)
    *(.data1)
    __global_pointer = . + 0x800;
    *(.sdata)
    *(.sdata.*)
    *(.gnu.linkonce.s.*)
    *(.gnu.linkonce.s2.*)
    *(.jcr)

    *(.data .data.*)

    *(.sdata .sdata.*)
    *(.sdata2 .sdata2.*)
    *(.gnu.linkonce.s.*)

    PROVIDE( __data_end = . );
  } > dram_seg

  .globals_initialized_at_load_time :
  {
    . = ALIGN(CACHE_LINE_ALIGNMENT); /* Needs to be in its own cache line to be flushed */
    *(.globals_initialized_at_load_time)
  } > dram_seg

  .bss (NOLOAD)  :
  {
   PROVIDE( __bss_start = . );
    *(.sbss*)
    *(.gnu.linkonce.sb.*)
    *(EXCLUDE_FILE(*hirtos*.o).bss.*)
    *(.gnu.linkonce.b.*)
    *(COMMON)
    . = ALIGN(CACHE_LINE_ALIGNMENT); /* End boundary for data cache flushing */
    PROVIDE( __bss_end = . );
    __global_data_region_end = .;
  } > dram_seg

  .privileged_bss (NOLOAD)  :
  {
   /*
    * Privileged uninitialized global variables (only accessible in privileged mode)
    */
    . = ALIGN(CACHE_LINE_ALIGNMENT); /* Start boundary for data cache flushing */
    __privileged_bss_start = .;
    *hirtos*.o (.bss.*)
    . = ALIGN(CACHE_LINE_ALIGNMENT); /* End boundary for data cache flushing */
    __privileged_bss_end = .;
  } > dram_seg

  .stack (NOLOAD)  :
  {
    . = ALIGN(STACK_POINTER_ALIGNMENT);
    _stacks_start = .;
    *(.isr_stack)
    . = ALIGN(STACK_POINTER_ALIGNMENT);
    *(.thread_stacks)
    . = ALIGN(STACK_POINTER_ALIGNMENT);
    _stacks_end = .;
  } > dram_seg

  .thread_local (NOLOAD)  :
  {
    _thread_local_start = .;
    *(.thread_local)
    _thread_local_end = .;
  } > dram_seg
}

ASSERT(__global_text_region_end - __global_text_region_start == MPU_TEXT_REGION_SIZE,
       "Global text region size must be MPU_TEXT_REGION_SIZE");
ASSERT(__rodata_end - __rodata_start == MPU_RODATA_REGION_SIZE,
       "Rodata region size must be MPU_RODATA_REGION_SIZE");