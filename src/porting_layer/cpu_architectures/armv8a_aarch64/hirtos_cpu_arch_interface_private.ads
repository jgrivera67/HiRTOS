--
--  Copyright (c) 2022-2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target CPU architecture interface
--

with System.Storage_ELements;
with Interfaces;
with HiRTOS_Cpu_Arch_Interface;
with HiRTOS_Cpu_Arch_Parameters;

private package HiRTOS_Cpu_Arch_Interface_Private with
 SPARK_Mode => On
is
   use HiRTOS_Cpu_Arch_Interface;
   use type Interfaces.Unsigned_8;

   type SP_Selector_Type is (
      SP_EL0, --  Thread context stack pointer
      SP_ELx  --  Interrupt context stack pointer
   ) with Size => 1;

   for SP_Selector_Type use (
      SP_EL0 => 2#0#,
      SP_ELx => 2#1#
   );

   type Exception_Level_Type is (
      EL0,
      EL1,
      EL2,
      EL3
   ) with Size => 2;

   for Exception_Level_Type use (
      EL0 => 2#0#,
      EL1 => 2#1#,
      EL2 => 2#10#,
      EL3 => 2#11#
   );

   type Execution_State_Type is (
      Execution_State_AArch64,
      Execution_State_AArch32
   ) with Size => 1;

   for Execution_State_Type use (
      Execution_State_AArch64 => 2#0#,
      Execution_State_AArch32 => 2#1#
   );

   type Interrupt_Flag_Type is
      (Interrupt_Enabled,
       Interrupt_Disabled)
   with Size => 1;

   for Interrupt_Flag_Type use (
      Interrupt_Enabled => 2#0#,
      Interrupt_Disabled => 2#1#
   );

   type DAIF_Type is record
      F : Interrupt_Flag_Type := Interrupt_Disabled;
      I : Interrupt_Flag_Type := Interrupt_Disabled;
      A : Interrupt_Flag_Type := Interrupt_Disabled;
      D : Interrupt_Flag_Type := Interrupt_Disabled;
   end record with
     Size => 4,
     Bit_Order => System.Low_Order_First;

   for DAIF_Type use record
      F at 0 range 0 .. 0;
      I at 0 range 1 .. 1;
      A at 0 range 2 .. 2;
      D at 0 range 3 .. 3;
   end record;

   type Arithmetic_Flag_Type is new Boolean
       with Size => 1;

   type NZCV_Type is record
      V : Arithmetic_Flag_Type := False;
      C : Arithmetic_Flag_Type := False;
      Z : Arithmetic_Flag_Type := False;
      N : Arithmetic_Flag_Type := False;
   end record with Size => 4, Bit_Order => System.Low_Order_First;

   for NZCV_Type use record
      V at 0 range 0 .. 0;
      C at 0 range 1 .. 1;
      Z at 0 range 2 .. 2;
      N at 0 range 3 .. 3;
   end record;

   --
   --  PSTATE register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRS/MSR instructions.
   --
   type PSTATE_Type (As_Value : Boolean := True) is record
      case As_Value is
         when True =>
            Value : Cpu_Register_Type := 0;
         when False =>
            SPSel : SP_Selector_Type := SP_EL0;
            CurrentEL : Exception_Level_Type := EL0;
            M : Execution_State_Type := Execution_State_AArch64;
            DAIF : DAIF_Type;
            NZCV : NZCV_Type;
      end case;
   end record with
     Size => 64, Bit_Order => System.Low_Order_First, Unchecked_Union;

   for PSTATE_Type use record
      SPSel      at 0 range  0 .. 0;
      CurrentEL  at 0 range  2 .. 3;
      M          at 0 range  4 .. 4;
      DAIF       at 0 range  6 .. 9;
      NZCV       at 0 range 28 .. 31;
      Value      at 0 range  0 .. 63;
   end record;

   function Get_CurrentEL return Exception_Level_Type;

   function Get_DAIF return DAIF_Type;

   function Get_PSTATE return PSTATE_Type;

   --
   --  Bit masks to use with msr DAIFset/DAIFclr:
   --
   DAIF_SetClr_F_Bit_Mask : constant Interfaces.Unsigned_8 := 2#1#; --  bit 0
   DAIF_SetClr_I_Bit_Mask : constant Interfaces.Unsigned_8 := 2#10#; --  bit 1
   DAIF_SetClr_A_Bit_Mask : constant Interfaces.Unsigned_8 := 2#100#; --  bit 2
   DAIF_SetClr_D_Bit_Mask : constant Interfaces.Unsigned_8 := 2#1000#; --  bit 3
   DAIF_SetClr_IF_Mask : constant Interfaces.Unsigned_8 := (DAIF_SetClr_I_Bit_Mask or DAIF_SetClr_F_Bit_Mask);

   function Get_ELR_EL1 return Cpu_Register_Type;

   procedure Set_ELR_EL1 (ELR_EL1_Value : Cpu_Register_Type);

   function Get_ELR_EL2 return Cpu_Register_Type;

   procedure Enable_Debug_Exceptions;

   use type System.Address;
   use type System.Storage_Elements.Integer_Address;

   procedure Invalidate_Data_Cache_Range (Start_Address : System.Address;
                                          End_Address : System.Address)
      with Pre => System.Storage_Elements.To_Integer (Start_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes = 0 and then
                   System.Storage_Elements.To_Integer (End_Address) mod
                     HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes = 0 and then
                   Start_Address < End_Address;

end HiRTOS_Cpu_Arch_Interface_Private;
