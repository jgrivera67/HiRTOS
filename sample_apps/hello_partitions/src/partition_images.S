/*
 * Copyright (c) 2022, German Rivera
 * All rights reserved.
 *
 *  SPDX-License-Identifier: BSD-3-Clause
 */

/*
 * Partition 1
 */
        .section .bindata, "ax"
        .align 5
        .global hello_partition1_image_start
hello_partition1_image_start:
        .incbin "../../partitions/bin/hello_partition1.bin"
        .global hello_partition1_image_end
hello_partition1_image_end:

        .section .rodata
        .align 2
        .global hello_partition1_image_addr
hello_partition1_image_addr:
        .word hello_partition1_image_start

        .global hello_partition1_load_addr
hello_partition1_load_addr:
        .word 0x08080000

        .global hello_partition1_size
hello_partition1_size:
        .word hello_partition1_image_end - hello_partition1_image_start

/*
 * Partition 2
 */
        .section .bindata, "ax"
        .align 5
        .global hello_partition2_image_start
 hello_partition2_image_start:
        .incbin "../../partitions/bin/hello_partition2.bin"
        .global hello_partition2_image_end
 hello_partition2_image_end:

        .section .rodata
        .align 2
        .global hello_partition2_image_addr
hello_partition2_image_addr:
        .word hello_partition2_image_start

        .global hello_partition2_load_addr
hello_partition2_load_addr:
        .word 0x08100000

        .global hello_partition2_size
hello_partition2_size:
        .word hello_partition2_image_end - hello_partition2_image_start

