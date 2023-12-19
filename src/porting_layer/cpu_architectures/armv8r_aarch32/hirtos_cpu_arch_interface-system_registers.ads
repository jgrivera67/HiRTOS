--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - ARMv8-R system registers
--

with System.Storage_Elements;

package HiRTOS_Cpu_Arch_Interface.System_Registers
   with SPARK_Mode => On
is
   use type System.Storage_Elements.Integer_Address;

   type Mpu_Enable_Type is (Mpu_Disabled, Mpu_Enabled)
      with Size => 1;

   for Mpu_Enable_Type use
     (Mpu_Disabled => 2#0#,
      Mpu_Enabled => 2#1#);

   type Alignment_Check_Enable_Type is (Alignment_Check_Disabled,
                                        Alignment_Check_Enabled)
   with Size => 1;

   for Alignment_Check_Enable_Type use
     (Alignment_Check_Disabled => 2#0#,
      Alignment_Check_Enabled => 2#1#);

   type Cacheability_Control_Type is (Non_Cacheable,
                                      Cacheable)
   with Size => 1;

   for Cacheability_Control_Type use
     (Non_Cacheable => 2#0#,
      Cacheable => 2#1#);

   type CP15_Memory_Barrier_Instruction_Enable_Type is
      (CP15_Memory_Barrier_Instruction_Disabled,
       CP15_Memory_Barrier_Instruction_Enabled)
   with Size => 1;

   for CP15_Memory_Barrier_Instruction_Enable_Type use
     (CP15_Memory_Barrier_Instruction_Disabled => 2#0#,
      CP15_Memory_Barrier_Instruction_Enabled => 2#1#);

   type IT_Disable_Type is (IT_Enabled,
                            IT_Disabled)
   with Size => 1;

   for IT_Disable_Type use
     (IT_Enabled => 2#0#,
      IT_Disabled => 2#1#);

   type Instruction_Access_Cacheability_Control_Type is (
      Instruction_Access_Non_Cacheable,
      Instruction_Access_Cacheable)
   with Size => 1;

   for Instruction_Access_Cacheability_Control_Type use
     (Instruction_Access_Non_Cacheable => 2#0#,
      Instruction_Access_Cacheable => 2#1#);

   type EL0_WFI_Trap_Disable_Type is (EL0_WFI_Trap_Enabled,
                                      EL0_WFI_Trap_Disabled)
   with Size => 1;

   for EL0_WFI_Trap_Disable_Type use
     (EL0_WFI_Trap_Enabled => 2#0#,
      EL0_WFI_Trap_Disabled => 2#1#);

   type Background_Region_Enable_Type is
      (Background_Region_Disabled,
       Background_Region_Enabled)
   with Size => 1;

   for Background_Region_Enable_Type use
     (Background_Region_Disabled => 2#0#,
      Background_Region_Enabled => 2#1#);

   type EL0_WFE_Trap_Disable_Type is (EL0_WFE_Trap_Enabled,
                                      EL0_WFE_Trap_Disabled)
   with Size => 1;

   for EL0_WFE_Trap_Disable_Type use
     (EL0_WFE_Trap_Enabled => 2#0#,
      EL0_WFE_Trap_Disabled => 2#1#);

   type Write_Permission_Implies_XN_Enable_Type is
      (Write_Permission_Implies_XN_Disabled,
       Write_Permission_Implies_XN_Enabled)
   with Size => 1;

   for Write_Permission_Implies_XN_Enable_Type use
     (Write_Permission_Implies_XN_Disabled => 2#0#,
      Write_Permission_Implies_XN_Enabled => 2#1#);

   type EL0_Write_Permission_Implies_EL1_XN_Enable_Type is
      (EL0_Write_Permission_Implies_EL1_XN_Disabled,
       EL0_Write_Permission_Implies_EL1_XN_Enabled)
   with Size => 1;

   for EL0_Write_Permission_Implies_EL1_XN_Enable_Type use
     (EL0_Write_Permission_Implies_EL1_XN_Disabled => 2#0#,
      EL0_Write_Permission_Implies_EL1_XN_Enabled => 2#1#);

   type Fast_Interrupts_Enable_Type is
      (Fast_Interrupts_Disabled,
       Fast_Interrupts_Enabled)
   with Size => 1;

   for Fast_Interrupts_Enable_Type use
     (Fast_Interrupts_Disabled => 2#0#,
      Fast_Interrupts_Enabled => 2#1#);

   type Exception_Endianness_Type is
      (Exceptions_Taken_On_Little_Endian,
       Exceptions_Taken_On_Big_Endian)
   with Size => 1;

   for Exception_Endianness_Type use
     (Exceptions_Taken_On_Little_Endian => 2#0#,
      Exceptions_Taken_On_Big_Endian => 2#1#);

   type T32_On_Exceptions_Enable_Type is
      (T32_On_Exceptions_Disabled,
       T32_On_Exceptions_Enabled)
   with Size => 1;

   for T32_On_Exceptions_Enable_Type use
     (T32_On_Exceptions_Disabled => 2#0#,
      T32_On_Exceptions_Enabled => 2#1#);

   --
   --  System control register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type SCTLR_Type is record
      M : Mpu_Enable_Type := Mpu_Disabled;
      A : Alignment_Check_Enable_Type := Alignment_Check_Disabled;
      C : Cacheability_Control_Type := Non_Cacheable;
      CP15BEN : CP15_Memory_Barrier_Instruction_Enable_Type := CP15_Memory_Barrier_Instruction_Disabled;
      ITD : IT_Disable_Type := IT_Enabled;
      I : Instruction_Access_Cacheability_Control_Type := Instruction_Access_Non_Cacheable;
      nTWI : EL0_WFI_Trap_Disable_Type := EL0_WFI_Trap_Enabled;
      BR : Background_Region_Enable_Type := Background_Region_Disabled;
      nTWE : EL0_WFE_Trap_Disable_Type := EL0_WFE_Trap_Enabled;
      WXN : Write_Permission_Implies_XN_Enable_Type := Write_Permission_Implies_XN_Disabled;
      UWXN : EL0_Write_Permission_Implies_EL1_XN_Enable_Type := EL0_Write_Permission_Implies_EL1_XN_Disabled;
      FI : Fast_Interrupts_Enable_Type; --  read only
      EE : Exception_Endianness_Type := Exceptions_Taken_On_Little_Endian;
      TE : T32_On_Exceptions_Enable_Type := T32_On_Exceptions_Disabled;
   end record
   with Size => 32,
        Bit_Order => System.Low_Order_First;

   for SCTLR_Type use record
      M at 0 range 0 .. 0;
      A at 0 range 1 .. 1;
      C at 0 range 2 .. 2;
      CP15BEN at 0 range 5 .. 5;
      ITD at 0 range 7 .. 7;
      I at 0 range 12 .. 12;
      nTWI at 0 range 16 .. 16;
      BR at 0 range 17 .. 17;
      nTWE at 0 range 18 .. 18;
      WXN at 0 range 19 .. 19;
      UWXN at 0 range 20 .. 20;
      FI at 0 range 21 .. 21;
      EE at 0 range 25 .. 25;
      TE at 0 range 30 .. 30;
   end record;

   function Get_SCTLR return SCTLR_Type;

   procedure Set_SCTLR (SCTLR_Value : SCTLR_Type);

   type Advanced_SIMD_Disable_Type is
      (Advanced_SIMD_Not_Disabled,
       Advanced_SIMD_Disabled)
   with Size => 1;

   for Advanced_SIMD_Disable_Type use
     (Advanced_SIMD_Not_Disabled => 2#0#,
      Advanced_SIMD_Disabled => 2#1#);

   type Advanced_SIMD_And_Floating_Point_Enable_Type is
     (Advanced_SIMD_And_Floating_Point_Disabled_For_EL0_EL1,
      Advanced_SIMD_And_Floating_Point_Enabled_For_EL1_Only,
      Advanced_SIMD_And_Floating_Point_Enabled_For_EL0_EL1)
      with Size => 2;

   for Advanced_SIMD_And_Floating_Point_Enable_Type use
     (Advanced_SIMD_And_Floating_Point_Disabled_For_EL0_EL1 => 2#00#,
      Advanced_SIMD_And_Floating_Point_Enabled_For_EL1_Only => 2#01#,
      Advanced_SIMD_And_Floating_Point_Enabled_For_EL0_EL1 => 2#11#);

   --
   --  Architectural Feature Access Control Register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type CPACR_Type is record
      cp10 : Advanced_SIMD_And_Floating_Point_Enable_Type := Advanced_SIMD_And_Floating_Point_Disabled_For_EL0_EL1;
      cp11 : Advanced_SIMD_And_Floating_Point_Enable_Type := Advanced_SIMD_And_Floating_Point_Disabled_For_EL0_EL1;
      ASEDIS : Advanced_SIMD_Disable_Type := Advanced_SIMD_Not_Disabled;
   end record
   with Size => 32,
        Bit_Order => System.Low_Order_First;

   for CPACR_Type use record
      cp10 at 0 range 20 .. 21;
      cp11 at 0 range 22 .. 23;
      ASEDIS at 0 range 31 .. 31;
   end record;

   function Get_CPACR return CPACR_Type;

   procedure Set_CPACR (CPACR_Value : CPACR_Type);

   --
   --  Flush data cache line
   --
   procedure Set_DCCMVAC (DCCMVAC_Value : System.Address)
      with Pre => System.Storage_Elements.To_Integer (DCCMVAC_Value) mod
                     HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes = 0;

   --
   --  Invalidate data cache line
   --
   procedure Set_DCIMVAC (DCIMVAC_Value : System.Address)
      with Pre => System.Storage_Elements.To_Integer (DCIMVAC_Value) mod
                     HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes = 0;

   --
   --  Clean and invalidate data cache line
   --
   procedure Set_DCCIMVAC (DCCIMVAC_Value : System.Address)
      with Pre => System.Storage_Elements.To_Integer (DCCIMVAC_Value) mod
                     HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes = 0;

   procedure Set_DCIM_ALL;

   procedure Set_ICIALLU;

   function Get_VBAR return System.Address;

   procedure Set_VBAR (VBAR_Value : System.Address);

   type CONTEXTIDR_Type is new Interfaces.Unsigned_32;

   function Get_CONTEXTIDR return CONTEXTIDR_Type;

   procedure Set_CONTEXTIDR (CONTEXTIDR_Value : CONTEXTIDR_Type);

end HiRTOS_Cpu_Arch_Interface.System_Registers;
