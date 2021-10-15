# HiRTOS

This repository hosts HiRTOS, a high-integrity RTOS written in SPARK Ada.

## Motivation

An RTOS is a safety critical component of any bare-metal embedded software system.
Yet, most RTOSes are written in C which is an unsafe language. It would be safer
to use an RTOS written in a safer language, such as Ada or even better SPARK Ada.
However, integrating Ada code components in bare-metal embedded firmware written
in other languages, typically C, is not easy in a portable manner, as the available
baremetal GNAT cross-compiler from AdaCore requires the availability of an Ada Runtime
for the target CPU architecture and the FSF GNAT compiler is not available as a
baremetal cross-compiler, unless you port it yourself which can be very challenging
and time consuming.
	.

## Formal Specification

A Formal specification of HiRTOS can be found [here](doc/HiRTOS.pdf).

