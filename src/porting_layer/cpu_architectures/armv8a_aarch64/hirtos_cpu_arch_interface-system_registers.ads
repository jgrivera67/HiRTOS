--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - ARMv8-A system registers
--

package HiRTOS_Cpu_Arch_Interface.System_Registers
   with SPARK_Mode => On
is
   type MMU_Enable_Type is
      (MMU_Disabled,
       MMU_Enabled)
   with Size => 1;

   for MMU_Enable_Type use
     (MMU_Disabled => 2#0#,
      MMU_Enabled => 2#1#);

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

   type SP_EL1_Alignment_Check_Enable_Type is (SP_EL1_Alignment_Check_Disabled,
                                               SP_EL1_Alignment_Check_Enabled)
   with Size => 1;

   for SP_EL1_Alignment_Check_Enable_Type use
     (SP_EL1_Alignment_Check_Disabled => 2#0#,
      SP_EL1_Alignment_Check_Enabled => 2#1#);

   type SP_EL0_Alignment_Check_Enable_Type is (SP_EL0_Alignment_Check_Disabled,
                                               SP_EL0_Alignment_Check_Enabled)
   with Size => 1;

   for SP_EL0_Alignment_Check_Enable_Type use
     (SP_EL0_Alignment_Check_Disabled => 2#0#,
      SP_EL0_Alignment_Check_Enabled => 2#1#);

   type User_Mask_Access_Enable_Type is (User_Mask_Access_Disabled,
                                         User_Mask_Access_Enabled)
   with Size => 1;

   for User_Mask_Access_Enable_Type use
     (User_Mask_Access_Disabled => 2#0#,
      User_Mask_Access_Enabled => 2#1#);

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

   type EL1_Endianness_Type is
      (EL1_Is_Little_Endian,
       EL1_Is_Big_Endian)
   with Size => 1;

   for EL1_Endianness_Type use
     (EL1_Is_Little_Endian => 2#0#,
      EL1_Is_Big_Endian => 2#1#);

   type EL0_Endianness_Type is
      (EL0_Is_Little_Endian,
       EL0_Is_Big_Endian)
   with Size => 1;

   for EL0_Endianness_Type use
     (EL0_Is_Little_Endian => 2#0#,
      EL0_Is_Big_Endian => 2#1#);

   type APDBKey_EL1_Pointer_Authentication_Enable_Type is
      (APDBKey_EL1_Pointer_Authentication_Disabled,
       APDBKey_EL1_Pointer_Authentication_Enabled)
   with Size => 1;

   for APDBKey_EL1_Pointer_Authentication_Enable_Type use
     (APDBKey_EL1_Pointer_Authentication_Disabled => 2#0#,
      APDBKey_EL1_Pointer_Authentication_Enabled => 2#1#);

   type APDAKey_EL1_Pointer_Authentication_Enable_Type is
      (APDAKey_EL1_Pointer_Authentication_Disabled,
       APDAKey_EL1_Pointer_Authentication_Enabled)
   with Size => 1;

   for APDAKey_EL1_Pointer_Authentication_Enable_Type use
     (APDAKey_EL1_Pointer_Authentication_Disabled => 2#0#,
      APDAKey_EL1_Pointer_Authentication_Enabled => 2#1#);

   type APIBKey_EL1_Pointer_Authentication_Enable_Type is
      (APIBKey_EL1_Pointer_Authentication_Disabled,
       APIBKey_EL1_Pointer_Authentication_Enabled)
   with Size => 1;

   for APIBKey_EL1_Pointer_Authentication_Enable_Type use
     (APIBKey_EL1_Pointer_Authentication_Disabled => 2#0#,
      APIBKey_EL1_Pointer_Authentication_Enabled => 2#1#);

   type APIAKey_EL1_Pointer_Authentication_Enable_Type is
      (APIAKey_EL1_Pointer_Authentication_Disabled,
       APIAKey_EL1_Pointer_Authentication_Enabled)
   with Size => 1;

   for APIAKey_EL1_Pointer_Authentication_Enable_Type use
     (APIAKey_EL1_Pointer_Authentication_Disabled => 2#0#,
      APIAKey_EL1_Pointer_Authentication_Enabled => 2#1#);

   --
   --  System control register for EL1
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRS/MSR instructions.
   --
   type SCTLR_EL1_Type is record
      M : MMU_Enable_Type := MMU_Disabled;
      A : Alignment_Check_Enable_Type := Alignment_Check_Disabled;
      C : Cacheability_Control_Type := Non_Cacheable;
      SA : SP_EL1_Alignment_Check_Enable_Type := SP_EL1_Alignment_Check_Disabled;
      SA0 : SP_EL0_Alignment_Check_Enable_Type := SP_EL0_Alignment_Check_Disabled;
      UMA : User_Mask_Access_Enable_Type := User_Mask_Access_Disabled;
      I : Instruction_Access_Cacheability_Control_Type := Instruction_Access_Non_Cacheable;
      EnDB : APDBKey_EL1_Pointer_Authentication_Enable_Type := APDBKey_EL1_Pointer_Authentication_Disabled;
      nTWI : EL0_WFI_Trap_Disable_Type := EL0_WFI_Trap_Enabled;
      nTWE : EL0_WFE_Trap_Disable_Type := EL0_WFE_Trap_Enabled;
      WXN : Write_Permission_Implies_XN_Enable_Type := Write_Permission_Implies_XN_Disabled;
      E0E : EL0_Endianness_Type := EL0_Is_Little_Endian;
      EE : EL1_Endianness_Type := EL1_Is_Little_Endian;
      EnDA : APDAKey_EL1_Pointer_Authentication_Enable_Type := APDAKey_EL1_Pointer_Authentication_Disabled;
      EnIB : APIBKey_EL1_Pointer_Authentication_Enable_Type := APIBKey_EL1_Pointer_Authentication_Disabled;
      EnIA : APIAKey_EL1_Pointer_Authentication_Enable_Type := APIAKey_EL1_Pointer_Authentication_Disabled;
   end record
   with Size => 64,
        Bit_Order => System.Low_Order_First;

   for SCTLR_EL1_Type use record
      M at 0 range 0 .. 0;
      A at 0 range 1 .. 1;
      C at 0 range 2 .. 2;
      SA at 0 range 3 .. 3;
      SA0 at 0 range 4 .. 4;
      UMA at 0 range 9 .. 9;
      I at 0 range 12 .. 12;
      EnDB at 0 range 13 .. 13;
      nTWI at 0 range 16 .. 16;
      nTWE at 0 range 18 .. 18;
      WXN at 0 range 19 .. 19;
      E0E at 0 range 24 .. 24;
      EE at 0 range 25 .. 25;
      EnDA at 0 range 27 .. 27;
      EnIB at 0 range 30 .. 30;
      EnIA at 0 range 31 .. 31;
   end record;

   function Get_SCTLR_EL1 return SCTLR_EL1_Type;

   procedure Set_SCTLR_EL1 (SCTLR_EL1_Value : SCTLR_EL1_Type);

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
   --  Architectural Feature Access Control Register for EL1
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRS/MSR instructions.
   --
   type CPACR_EL1_Type is record
      FPEN : Advanced_SIMD_And_Floating_Point_Enable_Type := Advanced_SIMD_And_Floating_Point_Disabled_For_EL0_EL1;
   end record
   with Size => 64,
        Bit_Order => System.Low_Order_First;

   for CPACR_EL1_Type use record
      FPEN at 0 range 20 .. 21;
   end record;

   function Get_CPACR_EL1 return CPACR_EL1_Type;

   procedure Set_CPACR_EL1 (CPACR_EL1_Value : CPACR_EL1_Type);

   function Get_VBAR_EL1 return System.Address;

   procedure Set_VBAR_EL1 (VBAR_Value : System.Address);

   type CONTEXTIDR_EL1_Type is new Interfaces.Unsigned_64;

   function Get_CONTEXTIDR_EL1 return CONTEXTIDR_EL1_Type;

   procedure Set_CONTEXTIDR_EL1 (CONTEXTIDR_Value : CONTEXTIDR_EL1_Type);

   type ESR_EL1_Type is new Interfaces.Unsigned_64; --  TODO: Define the right fields

   function Get_ESR_EL1 return ESR_EL1_Type;

   procedure Set_ESR_EL1 (ESR_EL1_Value : ESR_EL1_Type);

   type FAR_EL1_Type is new Interfaces.Unsigned_64; --  TODO: Define the right fields

   function Get_FAR_EL1 return FAR_EL1_Type;

   procedure Set_FAR_EL1 (FAR_EL1_Value : FAR_EL1_Type);

end HiRTOS_Cpu_Arch_Interface.System_Registers;
