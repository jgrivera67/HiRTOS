--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary RTOS to target platform interface - ARMv8-R system registers
--

with System.Storage_Elements;

package HiRTOS_Cpu_Arch_Interface.System_Registers
   with SPARK_Mode => On,
        No_Elaboration_Code_All
is
   use type System.Storage_Elements.Integer_Address;

   type HCR_VM_Type is
      (HCR_Virtualization_Disabled,
       HCR_Virtualization_Enabled)
   with Size => 1;

   for HCR_VM_Type use
     (HCR_Virtualization_Disabled => 2#0#,
      HCR_Virtualization_Enabled => 2#1#);

   type HCR_SWIO_Type is
      (HCR_Cache_Invalidate_Override_Disabled,
       HCR_Cache_Invalidate_Override_Enabled)
   with Size => 1;

   for HCR_SWIO_Type use
     (HCR_Cache_Invalidate_Override_Disabled => 2#0#,
      HCR_Cache_Invalidate_Override_Enabled => 2#1#);

   type HCR_FMO_Type is
      (HCR_FIQ_Mask_Override_Disabled,
       HCR_FIQ_Mask_Override_Enabled)
   with Size => 1;

   for HCR_FMO_Type use
     (HCR_FIQ_Mask_Override_Disabled => 2#0#,
      HCR_FIQ_Mask_Override_Enabled => 2#1#);

   type HCR_IMO_Type is
      (HCR_IRQ_Mask_Override_Disabled,
       HCR_IRQ_Mask_Override_Enabled)
   with Size => 1;

   for HCR_IMO_Type use
     (HCR_IRQ_Mask_Override_Disabled => 2#0#,
      HCR_IRQ_Mask_Override_Enabled => 2#1#);

   type HCR_AMO_Type is
      (HCR_Async_Abort_Mask_Override_Disabled,
       HCR_Async_Abort_Mask_Override_Enabled)
   with Size => 1;

   for HCR_AMO_Type use
     (HCR_Async_Abort_Mask_Override_Disabled => 2#0#,
      HCR_Async_Abort_Mask_Override_Enabled => 2#1#);

   type HCR_VF_Type is
      (HCR_Virtual_FIQ_Not_Pending,
       HCR_Virtual_FIQ_Pending)
   with Size => 1;

   for HCR_VF_Type use
     (HCR_Virtual_FIQ_Not_Pending => 2#0#,
      HCR_Virtual_FIQ_Pending => 2#1#);

   type HCR_VI_Type is
      (HCR_Virtual_IRQ_Not_Pending,
       HCR_Virtual_IRQ_Pending)
   with Size => 1;

   for HCR_VI_Type use
     (HCR_Virtual_IRQ_Not_Pending => 2#0#,
      HCR_Virtual_IRQ_Pending => 2#1#);

type HCR_VA_Type is
      (HCR_Virtual_Async_Abort_Not_Pending,
       HCR_Virtual_Async_Abort_Pending)
   with Size => 1;

   for HCR_VA_Type use
     (HCR_Virtual_Async_Abort_Not_Pending => 2#0#,
      HCR_Virtual_Async_Abort_Pending => 2#1#);

   type HCR_FB_Type is
      (HCR_Force_Broadcast_Disabled,
       HCR_Force_Broadcast_Enabled)
   with Size => 1;

   for HCR_FB_Type use
     (HCR_Force_Broadcast_Disabled => 2#0#,
      HCR_Force_Broadcast_Enabled => 2#1#);

   type HCR_BSU_Type is
      (HCR_Barrier_No_Effect,
       HCR_Barrier_Inner_Shareable,
       HCR_Barrier_Outer_Shareable,
       HCR_Barrier_Full_System)
   with Size => 2;

   for HCR_BSU_Type use
     (HCR_Barrier_No_Effect => 2#00#,
      HCR_Barrier_Inner_Shareable => 2#01#,
      HCR_Barrier_Outer_Shareable => 2#10#,
      HCR_Barrier_Full_System => 2#11#);

   type HCR_DC_Type is
      (HCR_Default_Cacheability_Disabled,
       HCR_Default_Cacheability_Enabled)
   with Size => 1;

   for HCR_DC_Type use
     (HCR_Default_Cacheability_Disabled => 2#0#,
      HCR_Default_Cacheability_Enabled => 2#1#);

   type HCR_TWI_Type is
      (HCR_Trap_WFI_Disabled,
       HCR_Trap_WFI_Enabled)
   with Size => 1;

   for HCR_TWI_Type use
     (HCR_Trap_WFI_Disabled => 2#0#,
      HCR_Trap_WFI_Enabled => 2#1#);

   type HCR_TWE_Type is
      (HCR_Trap_WFE_Disabled,
       HCR_Trap_WFE_Enabled)
   with Size => 1;

   for HCR_TWE_Type use
     (HCR_Trap_WFE_Disabled => 2#0#,
      HCR_Trap_WFE_Enabled => 2#1#);

   type HCR_TID_Type is
      (HCR_Trap_Register_Group_Disabled,
       HCR_Trap_Register_Group_Enabled);

   for HCR_TID_Type use
     (HCR_Trap_Register_Group_Disabled => 2#0#,
      HCR_Trap_Register_Group_Enabled => 2#1#);

   type HCR_TID_Array_Type is Array (0 .. 3) of HCR_TID_Type
      with Component_Size => 1, Size => 4;

   type HCR_TIDCP_Type is
      (HCR_Trap_CP15_Access_Disabled,
       HCR_Trap_CP15_Access_Enabled)
   with Size => 1;

   for HCR_TIDCP_Type use
     (HCR_Trap_CP15_Access_Disabled => 2#0#,
      HCR_Trap_CP15_Access_Enabled => 2#1#);

   type HCR_TAC_Type is
      (HCR_Trap_ACTLR_Access_Disabled,
       HCR_Trap_ACTLR_Access_Enabled)
   with Size => 1;

   for HCR_TAC_Type use
     (HCR_Trap_ACTLR_Access_Disabled => 2#0#,
      HCR_Trap_ACTLR_Access_Enabled => 2#1#);

   type HCR_TSW_Type is
      (HCR_Trap_Cache_Set_Way_Disabled,
       HCR_Trap_Cache_Set_Way_Enabled)
   with Size => 1;

   for HCR_TSW_Type use
     (HCR_Trap_Cache_Set_Way_Disabled => 2#0#,
      HCR_Trap_Cache_Set_Way_Enabled => 2#1#);

   type HCR_TPC_Type is
      (HCR_Trap_Cache_Point_Coherence_Disabled,
       HCR_Trap_Cache_Point_Coherence_Enabled)
   with Size => 1;

   for HCR_TPC_Type use
     (HCR_Trap_Cache_Point_Coherence_Disabled => 2#0#,
      HCR_Trap_Cache_Point_Coherence_Enabled => 2#1#);

   type HCR_TPU_Type is
      (HCR_Trap_Cache_Point_Unification_Disabled,
       HCR_Trap_Cache_Point_Unification_Enabled)
   with Size => 1;

   for HCR_TPU_Type use
     (HCR_Trap_Cache_Point_Unification_Disabled => 2#0#,
      HCR_Trap_Cache_Point_Unification_Enabled => 2#1#);

   type HCR_TVM_Type is
      (HCR_Trap_Virtual_Memory_Controls_Disabled,
       HCR_Trap_Virtual_Memory_Controls_Enabled)
   with Size => 1;

   for HCR_TVM_Type use
     (HCR_Trap_Virtual_Memory_Controls_Disabled => 2#0#,
      HCR_Trap_Virtual_Memory_Controls_Enabled => 2#1#);

   type HCR_TRVM_Type is
      (HCR_Trap_Read_Virtual_Memory_Controls_Disabled,
       HCR_Trap_Read_Virtual_Memory_Controls_Enabled)
   with Size => 1;

   for HCR_TRVM_Type use
     (HCR_Trap_Read_Virtual_Memory_Controls_Disabled => 2#0#,
      HCR_Trap_Read_Virtual_Memory_Controls_Enabled => 2#1#);

   type HCR_TGE_Type is
      (HCR_Trap_General_Exceptions_Disabled,
       HCR_Trap_General_Exceptions_Enabled)
   with Size => 1;

   for HCR_TGE_Type use
     (HCR_Trap_General_Exceptions_Disabled => 2#0#,
      HCR_Trap_General_Exceptions_Enabled => 2#1#);

   type HCR_HCD_Type is
      (HCR_HVC_Instruction_Disable_Off,
       HCR_HVC_Instruction_Disable_On)
   with Size => 1;

   for HCR_HCD_Type use
     (HCR_HVC_Instruction_Disable_Off => 2#0#,
      HCR_HVC_Instruction_Disable_On => 2#1#);

   --
   --  Hypervisor configuration register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type HCR_Type is record
      VM : HCR_VM_Type := HCR_Virtualization_Disabled;
      SWIO : HCR_SWIO_Type := HCR_Cache_Invalidate_Override_Disabled;
      FMO : HCR_FMO_Type := HCR_FIQ_Mask_Override_Disabled;
      IMO : HCR_IMO_Type := HCR_IRQ_Mask_Override_Disabled;
      AMO : HCR_AMO_Type := HCR_Async_Abort_Mask_Override_Disabled;
      VF : HCR_VF_Type := HCR_Virtual_FIQ_Not_Pending;
      VI : HCR_VI_Type := HCR_Virtual_IRQ_Not_Pending;
      VA : HCR_VA_Type := HCR_Virtual_Async_Abort_Not_Pending;
      FB : HCR_FB_Type := HCR_Force_Broadcast_Disabled;
      BSU : HCR_BSU_Type := HCR_Barrier_No_Effect;
      DC : HCR_DC_Type := HCR_Default_Cacheability_Disabled;
      TWI : HCR_TWI_Type := HCR_Trap_WFI_Disabled;
      TWE : HCR_TWE_Type := HCR_Trap_WFE_Disabled;
      TID : HCR_TID_Array_Type := [others => HCR_Trap_Register_Group_Disabled];
      TIDCP : HCR_TIDCP_Type := HCR_Trap_CP15_Access_Disabled;
      TAC : HCR_TAC_Type := HCR_Trap_ACTLR_Access_Disabled;
      TSW : HCR_TSW_Type := HCR_Trap_Cache_Set_Way_Disabled;
      TPC : HCR_TPC_Type := HCR_Trap_Cache_Point_Coherence_Disabled;
      TPU : HCR_TPU_Type := HCR_Trap_Cache_Point_Unification_Disabled;
      TVM : HCR_TVM_Type := HCR_Trap_Virtual_Memory_Controls_Disabled;
      TGE : HCR_TGE_Type := HCR_Trap_Genersal_Exceptions_Disabled;
      HCD : HCR_HCD_Type := HCR_HVC_Instruction_Disable_Off;
      TRVM : HCR_TRVM_Type := HCR_Trap_Read_Virtual_Memory_Controls_Disabled;
   end record
   with Size => 32,
        Bit_Order => System.Low_Order_First;

   for HCR_Type use record
      VM at 0 range 0 .. 0;
      SWIO at 0 range 1 .. 1;
      FMO at 0 range 3 .. 3;
      IMO at 0 range 4 .. 4;
      AMO at 0 range 5 .. 5;
      VF at 0 range 6 .. 6;
      VI at 0 range 7 .. 7;
      VA at 0 range 8 .. 8;
      FB at 0 range 9 .. 9;
      BSU at 0 range 10 .. 11;
      DC at 0 range 12 .. 12;
      TWI at 0 range 13 .. 13;
      TWE at 0 range 14 .. 14;
      TID at 0 range 15 .. 18;
      TIDCP at 0 range 19 .. 19;
      TAC at 0 range 21 .. 21;
      TSW at 0 range 22 .. 22;
      TPC at 0 range 23 .. 23;
      TPU at 0 range 24 .. 24;
      TVM at 0 range 26 .. 26;
      TGE at 0 range 27 .. 27;
      HCD at 0 range 29 .. 29;
      TRVM at 0 range 30 .. 30;
   end record;

   function Get_HCR return HCR_Type is HCR_Value : HCR_Type;

   procedure Set_HCR (HCR_Value : HCR_Type);

   type HSR_ISS_Type is mod 2**25 with Size => 25;

   type HSR_IL_Type is
      (HSR_16_Bit_Instruction_Trapped,
       HSR_32_Bit_Instruction_Trapped)
   with Size => 1;

   for HSR_IL_Type use
     (HSR_16_Bit_Instruction_Trapped => 2#0#,
      HSR_32_Bit_Instruction_Trapped => 2#1#);

   type HSR_EC_Type is
      (HSR_Exceptions_With_Unknown_Reason,
       HSR_Exception_From_WFI_WFE,
       HSR_Exception_From_MCR_or_MRC_CP15,
       HSR_Exception_From_MCRR_or_MRRC_CP15,
       HSR_Exception_From_MCR_or_MRC_CP14,
       HSR_Exception_From_LDC_or_STC_CP14,
       HSR_Exception_From_SIMD_or_Floating_Point_From_HCPTR,
       HSR_Exception_From_MCR_or_MRC_VMRS,
       HSR_Exception_From_MCRR_or_MRRC_CP14,
       HSR_Exception_From_Illegal_State_Taken_To_AArch32,
       HSR_Exception_From_SVC_Taken_To_EL2,
       HSR_Exception_From_HVC_Executed,
       HSR_Exception_From_Prefetch_Abort_Routed_To_EL2,
       HSR_Exception_From_Prefetch_Abort_At_EL2,
       HSR_Exception_From_PC_Alignment_fault,
       HSR_Exception_From_Data_Abort_Routed_To_EL2,
       HSR_Exception_From_Data_Abort_At_EL2)
   with Size => 6;

   for HSR_EC_Type use
     (HSR_Exceptions_With_Unknown_Reason => 2#000000#,
      HSR_Exception_From_WFI_WFE => 2#000001#,
      HSR_Exception_From_MCR_or_MRC_CP15 => 2#000011#,
      HSR_Exception_From_MCRR_or_MRRC_CP15 => 2#000100#,
      HSR_Exception_From_MCR_or_MRC_CP14 => 2#000101#,
      HSR_Exception_From_LDC_or_STC_CP14 => 2#000110#,
      HSR_Exception_From_SIMD_or_Floating_Point_From_HCPTR => 2#000111#,
      HSR_Exception_From_MCR_or_MRC_VMRS => 2#001000#,
      HSR_Exception_From_MCRR_or_MRRC_CP14 => 2#001100#,
      HSR_Exception_From_Illegal_State_Taken_To_AArch32 => 2#001110#,
      HSR_Exception_From_SVC_Taken_To_EL2 => 2#010001#,
      HSR_Exception_From_HVC_Executed => 2#010010#,
      HSR_Exception_From_Prefetch_Abort_Routed_To_EL2 => 2#100000#,
      HSR_Exception_From_Prefetch_Abort_At_EL2 => 2#100001#,
      HSR_Exception_From_PC_Alignment_fault => 2#100010#,
      HSR_Exception_From_Data_Abort_Routed_To_EL2 => 2#100100#,
      HSR_Exception_From_Data_Abort_At_EL2 => 2#100101#);

   --
   --  Hypervisor syndrome register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type HSR_Type is record
      ISS : HSR_ISS_Type := 0;
      IL : HSR_IL_Type := HSR_16_Bit_Instruction_Trapped;
      EC : HSR_EC_Type := HSR_Exceptions_With_Unknown_Reason;
   end record
   with Size => 32,
        Bit_Order => System.Low_Order_First;

   for HSR_Type use record
      ISS at 0 range 0 .. 24;
      IL at 0 range 25 .. 25;
      EC at 0 range 26 .. 31;
   end record;

   function Get_HSR return HSR_Type;

   procedure Set_HSR (HSR_Value : HSR_Type);

   type EL1_Mpu_Enable_Type is (EL1_Mpu_Disabled, EL1_Mpu_Enabled)
      with Size => 1;

   for EL1_Mpu_Enable_Type use
     (EL1_Mpu_Disabled => 2#0#,
      EL1_Mpu_Enabled => 2#1#);

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
      M : EL1_Mpu_Enable_Type := EL1_Mpu_Disabled;
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
   procedure Set_DCCMVAC(DCCMVAC_Value : System.Address)
      with Pre => System.Storage_Elements.To_Integer (DCCMVAC_Value) mod
                     HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes = 0;

   --
   --  Invalidate data cache line
   --
   procedure Set_DCIMVAC(DCIMVAC_Value : System.Address)
      with Pre => System.Storage_Elements.To_Integer (DCIMVAC_Value) mod
                     HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes = 0;

  --
   --  Clean and invalidate data cache line
   --
   procedure Set_DCCIMVAC(DCCIMVAC_Value : System.Address)
      with Pre => System.Storage_Elements.To_Integer (DCCIMVAC_Value) mod
                     HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes = 0;

   procedure Set_DCIM_ALL;

   procedure Set_ICIALLU;

end HiRTOS_Cpu_Arch_Interface.System_Registers;
