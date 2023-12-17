--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - ARMv8-R hypervisor registers
--

package HiRTOS_Cpu_Arch_Interface.System_Registers.Hypervisor
   with SPARK_Mode => On,
        No_Elaboration_Code_All
is
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

   type HCR_TID_Array_Type is array (0 .. 3) of HCR_TID_Type
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
      TGE : HCR_TGE_Type := HCR_Trap_General_Exceptions_Disabled;
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

   function Get_HCR return HCR_Type;

   procedure Set_HCR (HCR_Value : HCR_Type);

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
   --  Values for the IFSC subfield of the ISS field of the HSR register.
   --  They are the Instruction Fault Status Codes for EL2 prefetch abort
   --  exceptions
   --
   type HSR_ISS_IFSC_Type is
      (IFSC_Translation_Fault,
       IFSC_Permission_Fault,
       IFSC_Synchronous_External_Abort,
       IFSC_Debug_Exception)
   with Size => 6;

   for HSR_ISS_IFSC_Type use
     (IFSC_Translation_Fault => 2#000100#,
      IFSC_Permission_Fault => 2#001100#,
      IFSC_Synchronous_External_Abort => 2#010000#,
      IFSC_Debug_Exception => 2#100010#);

   --
   --  Values for the DFSC subfield of the ISS field of the HSR register.
   --  They are the Data Fault Status Codes for EL2 data abort exceptions
   --
   type HSR_ISS_DFSC_Type is
      (DFSC_Translation_Fault,
       DFSC_Permission_Fault,
       DFSC_Synchronous_External_Abort,
       DFSC_Serror_Interrupt,
       DFSC_Synchronous_Parity_Or_Ecc_Error,
       DFSC_Serror_Interrupt_Parity_Or_Ecc_Error,
       DFSC_Alignment_Fault,
       DFSC_Debug_Exception,
       DFSC_Cache_Lockdown_Fault,
       DFSC_Unsupported_Exclusive_Access_Fault)
   with Size => 6;

   for HSR_ISS_DFSC_Type use
     (DFSC_Translation_Fault => 2#000100#,
      DFSC_Permission_Fault => 2#001100#,
      DFSC_Synchronous_External_Abort => 2#010000#,
      DFSC_Serror_Interrupt => 2#010001#,
      DFSC_Synchronous_Parity_Or_Ecc_Error => 2#011000#,
      DFSC_Serror_Interrupt_Parity_Or_Ecc_Error => 2#011001#,
      DFSC_Alignment_Fault => 2#100001#,
      DFSC_Debug_Exception => 2#100010#,
      DFSC_Cache_Lockdown_Fault => 2#110100#,
      DFSC_Unsupported_Exclusive_Access_Fault => 2#110101#);

   type HSR_ISS_WnR_Type is
      (WnR_Read_Access_Fault,
       WnR_Write_Access_Fault)
   with Size => 1;

   for HSR_ISS_WnR_Type use
     (WnR_Read_Access_Fault => 2#0#,
      WnR_Write_Access_Fault => 2#1#);

   type HSR_Raw_ISS_Type is mod 2**25 with Size => 25;

   type HSR_ISS_Type (EC : HSR_EC_Type := HSR_Exceptions_With_Unknown_Reason) is record
      case EC is
         when HSR_Exception_From_Prefetch_Abort_Routed_To_EL2 |
              HSR_Exception_From_Prefetch_Abort_At_EL2 =>
            IFSC : HSR_ISS_IFSC_Type;
         when HSR_Exception_From_Data_Abort_Routed_To_EL2 |
              HSR_Exception_From_Data_Abort_At_EL2 =>
            DFSC : HSR_ISS_DFSC_Type;
            WnR : HSR_ISS_WnR_Type;
         when others =>
            ISS : HSR_Raw_ISS_Type := 0;
      end case;
   end record with
        Size => 25, Unchecked_Union, Bit_Order => System.Low_Order_First;

   for HSR_ISS_Type use record
      IFSC at 0 range 0 .. 5;
      DFSC at 0 range 0 .. 5;
      WnR  at 0 range 6 .. 6;
      ISS at 0 range 0 .. 24;
   end record;

   --
   --  Hypervisor syndrome register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type HSR_Type is record
      ISS : HSR_ISS_Type;
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

   type SETEND_Disable_Type is (SETEND_Enabled,
                                SETEND_Disabled)
   with Size => 1;

   for SETEND_Disable_Type use
     (SETEND_Enabled => 2#0#,
      SETEND_Disabled => 2#1#);

   --
   --  Hypervisor System control register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type HSCTLR_Type is record
      M : Mpu_Enable_Type := Mpu_Disabled;
      A : Alignment_Check_Enable_Type := Alignment_Check_Disabled;
      C : Cacheability_Control_Type := Non_Cacheable;
      CP15BEN : CP15_Memory_Barrier_Instruction_Enable_Type := CP15_Memory_Barrier_Instruction_Disabled;
      ITD : IT_Disable_Type := IT_Enabled;
      SED : SETEND_Disable_Type := SETEND_Enabled;
      I : Instruction_Access_Cacheability_Control_Type := Instruction_Access_Non_Cacheable;
      BR : Background_Region_Enable_Type := Background_Region_Disabled;
      WXN : Write_Permission_Implies_XN_Enable_Type := Write_Permission_Implies_XN_Disabled;
      FI : Fast_Interrupts_Enable_Type; --  read only
   end record
   with Size => 32,
        Bit_Order => System.Low_Order_First;

   for HSCTLR_Type use record
      M at 0 range 0 .. 0;
      A at 0 range 1 .. 1;
      C at 0 range 2 .. 2;
      CP15BEN at 0 range 5 .. 5;
      ITD at 0 range 7 .. 7;
      SED at 0 range 8 .. 8;
      I at 0 range 12 .. 12;
      BR at 0 range 17 .. 17;
      WXN at 0 range 19 .. 19;
      FI at 0 range 21 .. 21;
   end record;

   function Get_HSCTLR return HSCTLR_Type;

   procedure Set_HSCTLR (HSCTLR_Value : HSCTLR_Type);

   type S2DMAD_Type is (S2DMAD_Disabled, S2DMAD_Enabled)
      with Size => 1;

   for S2DMAD_Type use
     (S2DMAD_Disabled => 2#0#,
      S2DMAD_Enabled => 2#1#);

   type S2NIE_Type is (S2NIE_Disabled, S2NIE_Enabled)
      with Size => 1;

   for S2NIE_Type use
     (S2NIE_Disabled => 2#0#,
      S2NIE_Enabled => 2#1#);

   type Virtual_Machine_ID_Type is new Interfaces.Unsigned_8;

   --
   --  Virtualization System control register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type VSCTLR_Type is record
      S2DMAD : S2DMAD_Type := S2DMAD_Disabled;
      S2NIE : S2NIE_Type := S2NIE_Disabled;
      VMID : Virtual_Machine_ID_Type := Virtual_Machine_ID_Type'First;
   end record
   with Size => 32,
        Bit_Order => System.Low_Order_First;

   for VSCTLR_Type use record
      S2DMAD at 0 range 1 .. 1;
      S2NIE at 0 range 2 .. 2;
      VMID at 0 range 16 .. 23;
   end record;

   function Get_VSCTLR return VSCTLR_Type;

   procedure Set_VSCTLR (VSCTLR_Value : VSCTLR_Type);

   function Get_HVBAR return System.Address;

   procedure Set_HVBAR (HVBAR_Value : System.Address);

end HiRTOS_Cpu_Arch_Interface.System_Registers.Hypervisor;
