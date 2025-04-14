--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - ARMv8-A system registers
--

with Bit_Sized_Integer_Types;
with Interfaces;
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

   type ESR_EL1_IFSC_Type is (ESR_EL1_IFSC_Address_Size_Fault_TTBRx,
                              ESR_EL1_IFSC_Translation_Fault_1st_Level,
                              ESR_EL1_IFSC_Translation_Fault_2nd_Level)
      with Size => 6;

   for ESR_EL1_IFSC_Type use (ESR_EL1_IFSC_Address_Size_Fault_TTBRx => 2#000000#,
                              ESR_EL1_IFSC_Translation_Fault_1st_Level => 2#000101#,
                              ESR_EL1_IFSC_Translation_Fault_2nd_Level => 2#000110#);

   type ESR_EL1_EA_Type is (ESR_EL1_EA_External_Abort_Marked_DECERR,
                            ESR_EL1_EA_External_Abort_Marked_SLVERR)
      with Size => 1;

   for ESR_EL1_EA_Type use (ESR_EL1_EA_External_Abort_Marked_DECERR => 2#0#,
                            ESR_EL1_EA_External_Abort_Marked_SLVERR => 2#1#);

   --
   --  NOTE: The actual size of this type should be 24 bits, but Ada does not allow to define
   --  a variant record of 24 bits
   --
   type ESR_EL1_ISS_Type (As_Value : Boolean := True) is record
      case As_Value is
         when True =>
            Value : Bit_Sized_Integer_Types.Twenty_Four_Bits_Type := 0;
         when False =>
            INST_ABORT_IFSC : ESR_EL1_IFSC_Type;
            INST_ABORT_EA : ESR_EL1_EA_Type;
      end case;
   end record with
      Size => 32, Bit_Order => System.Low_Order_First, Unchecked_Union;

   for ESR_EL1_ISS_Type use record
      Value at 0 range 0 .. 24;
      INST_ABORT_IFSC at 0 range 0 .. 5;
      INST_ABORT_EA at 0 range 9 .. 9;
   end record;

   type ESR_EL1_EC_Type is (ESR_EL1_EC_Unknown,
                            ESR_EL1_EC_Trapped_WFI_WFE,
                            ESR_EL1_EC_Trapped_Access_SME_SVE_Advanced_SIMD_FP,
                            ESR_EL1_EC_Illegal_State,
                            ESR_EL1_EC_Aarch64_SVC,
                            ESR_EL1_EC_Trapped_MSR_MRS_System_Inst_In_AArch64,
                            ESR_EL1_EC_Instruction_Abort_Lower_EL,
                            ESR_EL1_EC_Instruction_Abort_Current_EL,
                            ESR_EL1_EC_PC_ALignment_Fault,
                            ESR_EL1_EC_Data_Abort_Lower_EL,
                            ESR_EL1_EC_Data_Abort_Current_EL,
                            ESR_EL1_EC_SP_Alignment_Fault,
                            ESR_EL1_EC_Trapped_Floating_Point_Exception,
                            ESR_EL1_EC_SError_Exception,
                            ESR_EL1_EC_Breakpoint_Lower_EL,
                            ESR_EL1_EC_Breakpoint_Current_EL,
                            ESR_EL1_EC_Software_Step_Exception_Lower_EL,
                            ESR_EL1_EC_Software_Step_Exception_Current_EL,
                            ESR_EL1_EC_Watchpoint_Lower_EL,
                            ESR_EL1_EC_Watchpoint_Current_EL,
                            ESR_EL1_EC_BRK_Instruction_In_Aarch64)
      with Size => 6;

   for ESR_EL1_EC_Type use (ESR_EL1_EC_Unknown => 2#0#,
                            ESR_EL1_EC_Trapped_WFI_WFE => 2#1#,
                            ESR_EL1_EC_Trapped_Access_SME_SVE_Advanced_SIMD_FP => 2#00_0111#,
                            ESR_EL1_EC_Illegal_State => 2#0_1110#,
                            ESR_EL1_EC_Aarch64_SVC => 2#1_0101#,
                            ESR_EL1_EC_Trapped_MSR_MRS_System_Inst_In_AArch64 => 2#1_1000#,
                            ESR_EL1_EC_Instruction_Abort_Lower_EL => 2#10_0000#,
                            ESR_EL1_EC_Instruction_Abort_Current_EL => 2#10_0001#,
                            ESR_EL1_EC_PC_ALignment_Fault => 2#10_0010#,
                            ESR_EL1_EC_Data_Abort_Lower_EL => 2#10_0100#,
                            ESR_EL1_EC_Data_Abort_Current_EL => 2#10_0101#,
                            ESR_EL1_EC_SP_Alignment_Fault => 2#10_0110#,
                            ESR_EL1_EC_Trapped_Floating_Point_Exception => 2#10_1100#,
                            ESR_EL1_EC_SError_Exception => 2#10_1111#,
                            ESR_EL1_EC_Breakpoint_Lower_EL => 2#11_0000#,
                            ESR_EL1_EC_Breakpoint_Current_EL => 2#11_0001#,
                            ESR_EL1_EC_Software_Step_Exception_Lower_EL => 2#11_0010#,
                            ESR_EL1_EC_Software_Step_Exception_Current_EL => 2#11_0011#,
                            ESR_EL1_EC_Watchpoint_Lower_EL => 2#11_0100#,
                            ESR_EL1_EC_Watchpoint_Current_EL => 2#11_0101#,
                            ESR_EL1_EC_BRK_Instruction_In_Aarch64 => 2#11_1100#);

   type ESR_EL1_Type (As_Value : Boolean := True) is record
      case As_Value is
         when True =>
            Value : Interfaces.Unsigned_64 := 0;
         when False =>
            ISS : Bit_Sized_Integer_Types.Twenty_Four_Bits_Type;
            IL : Bit_Sized_Integer_Types.Bit_Type;
            EC : ESR_EL1_EC_Type;
            ISS2 : Bit_Sized_Integer_Types.Twenty_Three_Bits_Type;
      end case;
   end record with
      Size => 64, Bit_Order => System.Low_Order_First, Unchecked_Union;

   for ESR_EL1_Type use record
      Value at 0 range 0 .. 63;
      ISS at 0 range 0 .. 24;
      IL at 0 range 25 .. 25;
      EC at 0 range 26 .. 31;
      ISS2 at 0 range 32 .. 55;
   end record;

   function Get_ESR_EL1 return ESR_EL1_Type;

   procedure Set_ESR_EL1 (ESR_EL1_Value : ESR_EL1_Type);

   type FAR_EL1_Type is new Interfaces.Unsigned_64;

   function Get_FAR_EL1 return FAR_EL1_Type;

   procedure Set_FAR_EL1 (FAR_EL1_Value : FAR_EL1_Type);

end HiRTOS_Cpu_Arch_Interface.System_Registers;
