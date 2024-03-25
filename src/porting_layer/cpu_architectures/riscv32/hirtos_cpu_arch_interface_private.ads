--
--  Copyright (c) 2024, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target CPU architecture interface - private declarations
--

with Interfaces;
with System;
with Bit_Sized_Integer_Types;

private package HiRTOS_Cpu_Arch_Interface_Private with
 SPARK_Mode => On
is
   MCAUSE_Exception_Code_Bit_Mask : constant Interfaces.Unsigned_32 :=
      2#01111111_11111111_11111111_11111111#;
   MCAUSE_Interrupt_Bit_Mask : constant Interfaces.Unsigned_32 :=
      2#10000000_00000000_00000000_00000000#;
   MSTATUS_MPP_Bit_Mask : constant Interfaces.Unsigned_32 :=
      2#00000000_00000000_00011000_00000000#;
   MSTATUS_MPP_Bit_Offset : constant := 11;
   MSTATUS_UIE_Bit_Mask : constant := 2#1#;
   MSTATUS_SIE_Bit_Mask : constant := 2#10#;
   MSTATUS_HIE_Bit_Mask : constant := 2#100#;
   MSTATUS_MIE_Bit_Mask : constant := 2#1000#;
   MSTATUS_MPIE_Bit_Mask : constant Interfaces.Unsigned_32 := 2#10000000#;

   --
   --  RISCV synchronous exception codes (from mcause)
   --
   type Cpu_Sync_Exception_Code_Type is (Instruction_Address_Misaligned,
                                         Instruction_Access_Fault,
                                         Illegal_Instruction,
                                         Breakpoint,
                                         Load_Address_Misaligned,
                                         Load_Access_Fault,
                                         Store_Address_Misaligned,
                                         Store_Access_Fault,
                                         Environment_Call_From_U_Mode,
                                         Environment_Call_From_S_Mode,
                                         Environment_Call_From_M_Mode,
                                         Instruction_Page_Fault,
                                         Load_Page_Fault,
                                         Store_Page_Fault);

   for Cpu_Sync_Exception_Code_Type use (Instruction_Address_Misaligned => 0,
                                         Instruction_Access_Fault => 1,
                                         Illegal_Instruction => 2,
                                         Breakpoint => 3,
                                         Load_Address_Misaligned => 4,
                                         Load_Access_Fault => 5,
                                         Store_Address_Misaligned => 6,
                                         Store_Access_Fault => 7,
                                         Environment_Call_From_U_Mode => 8,
                                         Environment_Call_From_S_Mode => 9,
                                         Environment_Call_From_M_Mode => 11,
                                         Instruction_Page_Fault => 12,
                                         Load_Page_Fault => 13,
                                         Store_Page_Fault => 15
                                        );

   Uncompressed_Instruction_Size : constant := 4;

   type MISA_Type is record
      MXL : Bit_Sized_Integer_Types.Two_Bits_Type; --  Machine XLEN (1 is 32-bits)
      Z  : Bit_Sized_Integer_Types.Bit_Type;       --  Reserved
      Y  : Bit_Sized_Integer_Types.Bit_Type;       --  Reserved
      X  : Bit_Sized_Integer_Types.Bit_Type;       --  Non-standard extensions present
      W  : Bit_Sized_Integer_Types.Bit_Type;       --  Reserved
      V  : Bit_Sized_Integer_Types.Bit_Type;       --  Reserved
      U  : Bit_Sized_Integer_Types.Bit_Type;       --  U User mode implemented
      T  : Bit_Sized_Integer_Types.Bit_Type;       --  Reserved
      S  : Bit_Sized_Integer_Types.Bit_Type;       --  Supervisor mode implemented
      R  : Bit_Sized_Integer_Types.Bit_Type;       --  Reserved
      Q  : Bit_Sized_Integer_Types.Bit_Type;       --  Quad-precision floating-point extension
      P  : Bit_Sized_Integer_Types.Bit_Type;       --  Reserved
      O  : Bit_Sized_Integer_Types.Bit_Type;       --  Reserved
      N  : Bit_Sized_Integer_Types.Bit_Type;       --  User-level interrupts supported
      M  : Bit_Sized_Integer_Types.Bit_Type;       --  Integer Multiply/Divide extension
      L  : Bit_Sized_Integer_Types.Bit_Type;       --  Reserved
      K  : Bit_Sized_Integer_Types.Bit_Type;       --  Reserved
      J  : Bit_Sized_Integer_Types.Bit_Type;       --  Reserved
      I  : Bit_Sized_Integer_Types.Bit_Type;       --  RV32I base ISA
      H  : Bit_Sized_Integer_Types.Bit_Type;       --  Hypervisor extension
      G  : Bit_Sized_Integer_Types.Bit_Type;       --  Additional standard extensions present
      F  : Bit_Sized_Integer_Types.Bit_Type;       --  Single-precision floating-point extension
      E  : Bit_Sized_Integer_Types.Bit_Type;       --  RV32E base ISA
      D  : Bit_Sized_Integer_Types.Bit_Type;       --  Double-precision floating-point extension
      C  : Bit_Sized_Integer_Types.Bit_Type;       --  Compressed Extension
      B  : Bit_Sized_Integer_Types.Bit_Type;       --  Reserved
      A  : Bit_Sized_Integer_Types.Bit_Type;       --  Atomic Extension
   end record
     with Size => 32,
          Bit_Order => System.Low_Order_First;

   for MISA_Type use record
      MXL at 0 range 30 .. 31;
      Z   at 0 range 25 .. 25;
      Y   at 0 range 24 .. 24;
      X   at 0 range 23 .. 23;
      W   at 0 range 22 .. 22;
      V   at 0 range 21 .. 21;
      U   at 0 range 20 .. 20;
      T   at 0 range 19 .. 19;
      S   at 0 range 18 .. 18;
      R   at 0 range 17 .. 17;
      Q   at 0 range 16 .. 16;
      P   at 0 range 15 .. 15;
      O   at 0 range 14 .. 14;
      N   at 0 range 13 .. 13;
      M   at 0 range 12 .. 12;
      L   at 0 range 11 .. 11;
      K   at 0 range 10 .. 10;
      J   at 0 range 9 .. 9;
      I   at 0 range 8 .. 8;
      H   at 0 range 7 .. 7;
      G   at 0 range 6 .. 6;
      F   at 0 range 5 .. 5;
      E   at 0 range 4 .. 4;
      D   at 0 range 3 .. 3;
      C   at 0 range 2 .. 2;
      B   at 0 range 1 .. 1;
      A   at 0 range 0 .. 0;
   end record;

   function Get_MISA return MISA_Type;

   Interrupt_Vector_Jump_Table : constant Interfaces.Unsigned_32 with
         Import,
         Convention => Asm,
         External_Name => "interrupt_vector_jump_table";

end HiRTOS_Cpu_Arch_Interface_Private;
