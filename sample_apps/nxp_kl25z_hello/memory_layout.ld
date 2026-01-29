/**
 * Linker script for NXP KL25Z Microcontroller
 */
ENTRY(reset_handler);

WORD_SIZE = 4;

MPU_REGION_ALIGNMENT = 32;

MEMORY
{
  /*
   * NOR Flash
   */
  flash_vectors (RX)  : ORIGIN = 0x00000000, LENGTH = 0x00000100
  flash_config  (RX)  : ORIGIN = 0x00000400, LENGTH = 0x00000010
  flash_text    (RX)  : ORIGIN = 0x00000410, LENGTH = 0x0001FBF0

  /*
   * SRAM
   */
  /*sram          (RW)  : ORIGIN = 0x1FFFF000, LENGTH = 16K*/
  sram          (RWX)  : ORIGIN = 0x1FFFF000, LENGTH = 16K
}

SECTIONS
{
  .interrupt_vector_table :
  {
    . = ALIGN(MPU_REGION_ALIGNMENT);
    __global_text_region_start = .;

    KEEP (*(.text.privileged.interrupt_vector_table))
    . = ALIGN(WORD_SIZE);
  } > flash_vectors

  .fcf_config :
  {
    . = ALIGN(WORD_SIZE);
    KEEP(*(.FlashConfig))    /* Flash Configuration Field (FCF) */
    . = ALIGN(WORD_SIZE);
  } > flash_config

 .text :
  {
    *(.text.privileged.*)

    . = ALIGN(MPU_REGION_ALIGNMENT);
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
  } > flash_text

  /*
   * ARM exception unwind table
   */
  .ARM.extab :
  {
    *(.ARM.extab* .gnu.linkonce.armextab.*)
  } > flash_text

  /*
   * ARM exception unwind table index
   */
  .ARM.exidx :
  {
    PROVIDE_HIDDEN (__exidx_start = .);
    *(.ARM.exidx* .gnu.linkonce.armexidx.*)
    PROVIDE_HIDDEN (__exidx_end = .);
  } > flash_text

  .preinit_array :
  {
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array))
    PROVIDE_HIDDEN (__preinit_array_end = .);
  } >flash_text

  .init_array :
  {
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT_BY_INIT_PRIORITY(.init_array.*) SORT_BY_INIT_PRIORITY(.ctors.*)))
    KEEP (*(.init_array EXCLUDE_FILE (*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o ) .ctors))
    PROVIDE_HIDDEN (__init_array_end = .);
  } > flash_text

  .fini_array :
  {
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(SORT_BY_INIT_PRIORITY(.fini_array.*) SORT_BY_INIT_PRIORITY(.dtors.*)))
    KEEP (*(.fini_array EXCLUDE_FILE (*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o ) .dtors))
    PROVIDE_HIDDEN (__fini_array_end = .);
  } > flash_text

  .ctors :
  {
    /* gcc uses crtbegin.o to find the start of
       the constructors, so we make sure it is
       first.  Because this is a wildcard, it
       doesn't matter if the user does not
       actually link against crtbegin.o; the
       linker won't look for a file to match a
       wildcard.  The wildcard also means that it
       doesn't matter which directory crtbegin.o
       is in.  */
    KEEP (*crtbegin.o(.ctors))
    KEEP (*crtbegin?.o(.ctors))
    /* We don't want to include the .ctor section from
       the crtend.o file until after the sorted ctors.
       The .ctor section from the crtend file contains the
       end of ctors marker and it must be last */
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*(.ctors))
  } > flash_text

  .dtors :
  {
    KEEP (*crtbegin.o(.dtors))
    KEEP (*crtbegin?.o(.dtors))
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*(.dtors))

    . = ALIGN(MPU_REGION_ALIGNMENT);
    PROVIDE (__visible_text_end = .);
    __global_text_region_end = .;
  } > flash_text

  .rodata :
  {
    . = ALIGN(MPU_REGION_ALIGNMENT);
    PROVIDE_HIDDEN (__rodata_start = .);
    *(.rdata)
    *(.rodata .rodata.*)
    *(.srodata.cst16)
    *(.srodata.cst8)
    *(.srodata.cst4)
    *(.srodata.cst2)
    *(.srodata .srodata.*)
    *(.gnu.linkonce.r.*)
    . = ALIGN(MPU_REGION_ALIGNMENT);
    PROVIDE_HIDDEN (__rodata_end = .);
    PROVIDE( __data_load = . );
  } > flash_text

  .data :  AT (__data_load)
  {
    . = ALIGN(MPU_REGION_ALIGNMENT);
    __global_data_region_start = .;
    PROVIDE( __data_start = . );
    *(.data .data.*)
    *(.gnu.linkonce.d.*)
    *(.sdata .sdata.*)
    *(.sdata2 .sdata2.*)
    *(.gnu.linkonce.s.*)
    PROVIDE( __data_end = . );
  } > sram

  .bss (NOLOAD)  :
  {
   PROVIDE( __bss_start = . );
    *(.sbss*)
    *(.gnu.linkonce.sb.*)
    *(EXCLUDE_FILE(*hirtos*.o).bss.*)
    *(.gnu.linkonce.b.*)
    *(COMMON)
    PROVIDE( __bss_end = . );
    . = ALIGN(MPU_REGION_ALIGNMENT);
    __global_data_region_end = .;
  } > sram

  .privileged_bss (NOLOAD)  :
  {
   /*
    * Privileged uninitialized global variables (only accessible in privileged mode)
    * are located the beginning of the bss section
    */
    . = ALIGN(MPU_REGION_ALIGNMENT);
    __privileged_bss_start = .;
    *hirtos*.o (.bss.*)
    . = ALIGN(MPU_REGION_ALIGNMENT);
    __privileged_bss_end = .;
  } > sram

  .globals_initialized_at_load_time (NOLOAD) :
  {
    . = ALIGN(MPU_REGION_ALIGNMENT); /* Needs to be in its own cache line to be flushed */
    __globals_initialized_at_load_time_start = .;
    *(.globals_initialized_at_load_time)
    . = ALIGN(MPU_REGION_ALIGNMENT); /* End boundary for data cache flushing */
    __globals_initialized_at_load_time_end = .;
  } > sram

  /*
   * Special data section for global variables that keep their values across
   * resets:
   */
  .reset_persistent_data :
  {
    . = ALIGN(WORD_SIZE);
    __reset_persistent_data_start = .;
    KEEP(*(.cpu_reset_counter))
    KEEP(*(.watchdog))
    KEEP(*(.runtime_logs))
    . = ALIGN(WORD_SIZE);
    __reset_persistent_data_end = .;
  } > sram

  .stack (NOLOAD)  :
  {
    . = ALIGN(MPU_REGION_ALIGNMENT);
    _stacks_start = .;
    *(.isr_stack)
    . = ALIGN(MPU_REGION_ALIGNMENT);
    *(.thread_stacks)
    . = ALIGN(MPU_REGION_ALIGNMENT);
    _stacks_end = .;
  } > sram

  /DISCARD/ : { *(.ARM.extab .ARM.exidx) }
}
