# HiRTOS

This repository hosts HiRTOS, a high-integrity RTOS written in SPARK Ada.

## Motivation

An RTOS is a safety critical component of any bare-metal embedded software system.
Yet, most RTOSes are written in C which is an unsafe language. It would be safer
to use an RTOS written in a safer language, such as Ada or even better SPARK Ada.
However, integrating Ada code components in bare-metal embedded firmware written
in other languages, typically C, is not easy in a portable manner, as the available
baremetal GNAT cross-compilers require the availability of an Ada Runtime for the
target micrcontroller or embedded platform, and such baremetal Ada runtimes are
available only for a very limited number of platforms. HiRTOS solves this problem
by being implemented on on top of a minimal platform-independent Ada runtime.
Also, HiRTOS code itself has been written on top of a porting layer that provides
a platform-agnostic interface to HiRTOS. Currently, only one porting layer for the
ARM Cortex-R52 multi-core processor is provided. To port HiRTOS to a new target
platform, all what it is needed is to implement the porting layer for the new target
platform.

## HiRTOS Z Formal Specification

HiRTOS is formally specified using the Z notation. The Z specification of HiRTOS can
be found [here](doc/HiRTOS.pdf).

## Building and Running the HiRTOS Multi-core Sample Applications for ARMv8-R

### Prerequisites

* Install the [`alr`](https://alire.ada.dev/docs/) Ada package manager and meta-build tool
* Install the latest `gnat_arm_elf` cross-compiler by running `alr toolchain --select`
* Install the [ARM Fixed Virtual Platform (FVP) Simulator](https://developer.arm.com/downloads/-/arm-ecosystem-models)
  for ARMv8-R (scroll down to Armv8-R AEM FVP)

### Build the "Hello World" HiRTOS Sample Application 

```
cd sample_apps/fvp_armv8r_aarch32_hello
alr build
```
### Run the "Hello World" HiRTOS Sample Application on the ARM FVP Simulator

```
#
# NOTE:
# - `cluster0.gicv3.SRE-EL2-enable-RAO=1` and `cluster0.gicv3.cpuintf-mmap-access-level=2`
#   are needed to enable access to the GIC CPU interface's system registers
# - `bp.refcounter.non_arch_start_at_default=1` enables the system counter that drives
#   the generic timer counter.
#
<ARM FVP install dir>/models/Linux64_GCC-9.3/FVP_BaseR_AEMv8R \
   -C bp.pl011_uart0.uart_enable=1 \
   -C bp.pl011_uart0.baud_rate=460800 \
   -C cluster0.gicv3.SRE-EL2-enable-RAO=1 \
   -C cluster0.gicv3.cpuintf-mmap-access-level=2 \
   -C bp.refcounter.non_arch_start_at_default=1 \
	--application  bin/fvp_armv8r_aarch32_hello
```

Once the ARM FVP simulator starts, an xterm for the UART output from each CPU core would be
displayed.
An ARM FVP run for the "Hello World" HiRTOS sample application looks like this: ![](doc/HiRTOS_Sample_App_Running.png).

### Build the "Hello World" HiRTOS Separation Kernel Sample Application

```
cd sample_apps/hello_partitions
alr build
```
### Run the  "Hello World" HiRTOS Separation Kernel Sample Application on the ARM FVP Simulator

```
<ARM FVP install dir>/models/Linux64_GCC-9.3/FVP_BaseR_AEMv8R \
   -C bp.pl011_uart0.uart_enable=1 \
   -C bp.pl011_uart0.baud_rate=460800 \
   -C cluster0.gicv3.SRE-EL2-enable-RAO=1 \
   -C cluster0.gicv3.cpuintf-mmap-access-level=2 \
   -C bp.refcounter.non_arch_start_at_default=1 \
	--application  bin/hello_partitions
```

An ARM FVP run for "Hello World" HiRTOS separation kernel sample application looks like this: ![](doc/HiRTOS_Separation_Kernel_Sample_App_Running.png).
