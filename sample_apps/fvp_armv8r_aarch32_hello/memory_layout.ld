/****************************************************************************
 *                                                                          *
 *                         GNAT COMPILER COMPONENTS                         *
 *                                                                          *
 *                                  A R M                                   *
 *                                                                          *
 *                            Linker Script File                            *
 *                                                                          *
 *      Copyright (C) 1999-2002 Universidad Politecnica de Madrid           *
 *             Copyright (C) 2003-2006 The European Space Agency            *
 *                   Copyright (C) 2003-2018 AdaCore                        *
 *                                                                          *
 * GNAT is free software;  you can  redistribute it  and/or modify it under *
 * terms of the  GNU General Public License as published  by the Free Soft- *
 * ware  Foundation;  either version 2,  or (at your option) any later ver- *
 * sion.  GNAT is distributed in the hope that it will be useful, but WITH- *
 * OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY *
 * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License *
 * for  more details.  You should have  received  a copy of the GNU General *
 * Public License  distributed with GNAT;  see file COPYING.  If not, write *
 * to  the  Free Software Foundation,  51  Franklin  Street,  Fifth  Floor, *
 * Boston, MA 02110-1301, USA.                                              *
 *                                                                          *
 * As a  special  exception,  if you  link  this file  with other  files to *
 * produce an executable,  this file does not by itself cause the resulting *
 * executable to be covered by the GNU General Public License. This except- *
 * ion does not  however invalidate  any other reasons  why the  executable *
 * file might be covered by the  GNU Public License.                        *
 *                                                                          *
 * GNARL was developed by the GNARL team at Florida State University.       *
 * Extensive contributions were provided by Ada Core Technologies, Inc.     *
 * The  executive  was developed  by the  Real-Time  Systems  Group  at the *
 * Technical University of Madrid.                                          *
 *                                                                          *
 ****************************************************************************/

ENTRY(reset_handler);

WORD_SIZE = 4;

MPU_REGION_ALIGNMENT = 64;

MEMORY
{
  TCM(rwx) : ORIGIN = 0x08000000, LENGTH = 1024K
}

SECTIONS
{
 .text :
  {
    . = ALIGN(MPU_REGION_ALIGNMENT);
    __global_text_region_start = .;

    KEEP (*(.text.privileged.interrupt_vector_table))

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
  } >TCM

  /*
   * ARM exception unwind table
   */
  .ARM.extab :
  {
    *(.ARM.extab* .gnu.linkonce.armextab.*)
  } >TCM

  /*
   * ARM exception unwind table index
   */
  .ARM.exidx :
  {
    PROVIDE_HIDDEN (__exidx_start = .);
    *(.ARM.exidx* .gnu.linkonce.armexidx.*)
    PROVIDE_HIDDEN (__exidx_end = .);
  } >TCM

  .preinit_array :
  {
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array))
    PROVIDE_HIDDEN (__preinit_array_end = .);
  } >TCM

  .init_array :
  {
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT_BY_INIT_PRIORITY(.init_array.*) SORT_BY_INIT_PRIORITY(.ctors.*)))
    KEEP (*(.init_array EXCLUDE_FILE (*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o ) .ctors))
    PROVIDE_HIDDEN (__init_array_end = .);
  } >TCM

  .fini_array :
  {
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(SORT_BY_INIT_PRIORITY(.fini_array.*) SORT_BY_INIT_PRIORITY(.dtors.*)))
    KEEP (*(.fini_array EXCLUDE_FILE (*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o ) .dtors))
    PROVIDE_HIDDEN (__fini_array_end = .);
  } >TCM

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
  } >TCM

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
  } >TCM

  .rodata :
  {
    . = ALIGN(MPU_REGION_ALIGNMENT);
    PROVIDE_HIDDEN (__rodata_start = .);
    *(.rdata)
    *(.rodata .rodata.*)
    *(.gnu.linkonce.r.*)
    . = ALIGN(MPU_REGION_ALIGNMENT);
    PROVIDE_HIDDEN (__rodata_end = .);
    PROVIDE( __data_load = . );
  } >TCM

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
    *(.srodata.cst16)
    *(.srodata.cst8)
    *(.srodata.cst4)
    *(.srodata.cst2)
    *(.srodata .srodata.*)
    PROVIDE( __data_end = . );
  } >TCM

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
  } >TCM

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
  } >TCM

  .globals_initialized_at_load_time :
  {
    . = ALIGN(MPU_REGION_ALIGNMENT); /* Needs to be in its own cache line to be flushed */
    *(.globals_initialized_at_load_time)
  } >TCM

  .stack (NOLOAD)  :
  {
    . = ALIGN(MPU_REGION_ALIGNMENT);
    _stacks_start = .;
    *(.isr_stack)
    . = ALIGN(MPU_REGION_ALIGNMENT);
    *(.thread_stacks)
    . = ALIGN(MPU_REGION_ALIGNMENT);
    _stacks_end = .;
  } >TCM
}
