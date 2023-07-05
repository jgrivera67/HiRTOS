# HiRTOS

This repository hosts HiRTOS, a high-integrity RTOS written in SPARK Ada.

## Motivation

An RTOS is a safety critical component of any bare-metal embedded software system.
Yet, most RTOSes are written in C which is an unsafe language. It would be safer
to use an RTOS written in a safer language, such as Ada or even better SPARK Ada.
However, integrating Ada code components in bare-metal embedded firmware written
in other languages, typically C, is not easy in a portable manner, as the available
baremetal GNAT cross-compiler from AdaCore requires the availability of an Ada Runtime
for the target micrcontroller or embedded platform, and such baremetal Ada runtimes
are available only for a very limited number of platforms. HiRTOS solves
this problem by being implemented on onto pf a minimal platform-independent Ada runtime.
Also, HiRTOS code itself has been written on top of a porting layer that provides
a platform-agnostic interface to HiRTOS. So, to port HiRTOS to a new target platform,
all what it is needed is to implement the porting layer for the new target platform.

## Formal Specification

A Formal specification of HiRTOS can be found [here](doc/HiRTOS.pdf).

## Building and Running the Multi-Core Multi-threaded Sample Ada Application

### Prerequisites

* Install the [`alr`](https://alire.ada.dev/docs/) Ada package manager and meta-build tool
* Install the latest `gnat_arm_elf` cross-compiler by running `alr toolchain --select`
* Install the [ARM Fixed Virtual Platform (FVP) Simulator](https://developer.arm.com/downloads/-/arm-ecosystem-models)
  for ARMv8-R (scroll down to Armv8-R AEM FVP)

### Build the "Hello World" Sample Application for ARMv8-R

```
cd sample_apps/fvp_armv8r_aarch32_hello
alr build
```
### Run the  "Hello World" Sample Application on the ARM FVP Simulator

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
displayed. An ARM FVP run would look like this: ![](doc/HiRTOS_Sample_App_Running.png)