--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Interrupt controller driver
--  for ARM GIC-400 (GICv2)
--

with HiRTOS_Cpu_Multi_Core_Interface;
with HiRTOS_Platform_Parameters;
private with System;
private with Interfaces;

package HiRTOS_Cpu_Arch_Interface.Interrupt_Controller with
  SPARK_Mode => On
is
   Max_Num_Interrupts_Supported : constant := 992;

   type Interrupt_Id_Type is range 0 .. Max_Num_Interrupts_Supported;

   subtype Valid_Interrupt_Id_Type is
     Interrupt_Id_Type range Interrupt_Id_Type'First ..
         Interrupt_Id_Type'Last - 1;

   Invalid_Interrupt_Id : constant Interrupt_Id_Type := Interrupt_Id_Type'Last;

   subtype Internal_Interrupt_Id_Type is Interrupt_Id_Type range 0 .. 31;

   --  IDs of (per-CPU) software-generated interrupts (SGIs)
   subtype Soft_Gen_Interrupt_Id_Type is
     Internal_Interrupt_Id_Type range 0 .. 15;

   --  IDs of (per-CPU) private peripheral interrupts (PPIs) in the GIC
   subtype Private_Interrupt_Id_Type is
     Internal_Interrupt_Id_Type range 16 .. 31;

   --  IDs of (global) shared peripheral interrupts (SPIs) in the GIC
   subtype External_Interrupt_Id_Type is Interrupt_Id_Type range
      32 .. 32 + HiRTOS_Platform_Parameters.Num_External_Interrupts - 1;

   --  Priority 0 is the highest priority and priority 31 is the lowest
   type Interrupt_Priority_Type is mod 2**5;

   Highest_Interrupt_Priority : constant Interrupt_Priority_Type :=
     Interrupt_Priority_Type'First;

   --
   --  NOTE: The usable lowest interrupt priority is one less than the
   --  largest priority value, since setting the ICC_PMR register to the
   --  largest priority value (lowest priority) implies that that interrupts
   --  at that priority cannot fire.
   --
   Lowest_Interrupt_Priority : constant Interrupt_Priority_Type :=
     Interrupt_Priority_Type'Last - 1;

   subtype Valid_Interrupt_Priority_Type is Interrupt_Priority_Type range
      Highest_Interrupt_Priority .. Lowest_Interrupt_Priority;

   Invalid_Interrupt_Priority : constant Interrupt_Priority_Type := Interrupt_Priority_Type'Last;

   type Interrupt_Handler_Entry_Point_Type is
     access procedure (Arg : System.Address);

   type Cpu_Interrupt_Line_Type is (Cpu_Interrupt_Fiq, Cpu_Interrupt_Irq);

   for Cpu_Interrupt_Line_Type use
     (Cpu_Interrupt_Fiq => 2#0#, Cpu_Interrupt_Irq => 2#1#);

   type Interrupt_Trigger_Mode_Type is
     (Interrupt_Level_Sensitive, Interrupt_Edge_Triggered);

   for Interrupt_Trigger_Mode_Type use
     (Interrupt_Level_Sensitive => 2#00#, Interrupt_Edge_Triggered => 2#10#);

   ----------------------------------------------------------------------------
   --  Public Subprograms
   ----------------------------------------------------------------------------

   function Per_Cpu_Initialized return Boolean with
     Ghost;

   procedure Initialize with
     Pre  => not Per_Cpu_Initialized and then Cpu_In_Privileged_Mode,
     Post => Per_Cpu_Initialized;

   --
   --  NOTE: Internal interrupts always fire in the local CPU
   --
   procedure Configure_Internal_Interrupt
     (Internal_Interrupt_Id         : Internal_Interrupt_Id_Type;
      Priority                      : Valid_Interrupt_Priority_Type;
      Cpu_Interrupt_Line            : Cpu_Interrupt_Line_Type;
      Trigger_Mode                  : Interrupt_Trigger_Mode_Type;
      Interrupt_Handler_Entry_Point : Interrupt_Handler_Entry_Point_Type;
      Interrupt_Handler_Arg : System.Address := System.Null_Address) with
     Pre => Per_Cpu_Initialized;

   --
   --  NOTE: The external interrupt is configured to fire on the CPU on which
   --  this subprogram is called for that interrupt.
   --
   procedure Configure_External_Interrupt
     (External_Interrupt_Id         : External_Interrupt_Id_Type;
      Priority                      : Valid_Interrupt_Priority_Type;
      Cpu_Interrupt_Line            : Cpu_Interrupt_Line_Type;
      Trigger_Mode                  : Interrupt_Trigger_Mode_Type;
      Interrupt_Handler_Entry_Point : Interrupt_Handler_Entry_Point_Type;
      Interrupt_Handler_Arg : System.Address := System.Null_Address) with
     Pre => Per_Cpu_Initialized;

   procedure Enable_Internal_Interrupt
     (Internal_Interrupt_Id : Internal_Interrupt_Id_Type) with
     Pre => Per_Cpu_Initialized;

   procedure Enable_External_Interrupt
     (External_Interrupt_Id : External_Interrupt_Id_Type) with
     Pre => Per_Cpu_Initialized;

   procedure Disable_Internal_Interrupt
     (Internal_Interrupt_Id : Internal_Interrupt_Id_Type) with
     Pre => Per_Cpu_Initialized;

   procedure Disable_External_Interrupt
     (External_Interrupt_Id : External_Interrupt_Id_Type) with
     Pre => Per_Cpu_Initialized;

   procedure GIC_Interrupt_Handler
     (Cpu_Interrupt_Line : Cpu_Interrupt_Line_Type) with
     Pre =>
      Per_Cpu_Initialized and then
      Cpu_In_Privileged_Mode and then
      Cpu_Interrupting_Disabled;

   procedure Trigger_Software_Generated_Interrupt (Soft_Gen_Interrupt_Id : Soft_Gen_Interrupt_Id_Type;
                                                   Cpu_Id : HiRTOS_Cpu_Multi_Core_Interface.Cpu_Core_Id_Type);

   function Get_Highest_Interrupt_Priority_Disabled return Interrupt_Priority_Type
      with Pre => Cpu_In_Privileged_Mode;

   procedure Set_Highest_Interrupt_Priority_Disabled (Priority : Interrupt_Priority_Type)
      with Pre => Cpu_In_Privileged_Mode;

private
   pragma SPARK_Mode (Off);
   use HiRTOS_Cpu_Multi_Core_Interface;

   type CBAR_RES0_Type is mod 2**18 with
     Size => 18;

   type CBAR_PERIPHBASE_Type is mod 2**26 with
     Size => 26;

   --
   --  Configuration Base Address Register
   --  (This register holds the physical base address of the memory-mapped GIC
   --   Distributor registers.)
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  aIMP_CBARs it is not memory-mapped. It is accessed via MRS/MSR instructions.
   --
   type CBAR_EL1_Type (As_Value : Boolean := True) is record
      case As_Value is
         when True =>
            Value : Interfaces.Unsigned_64 := 0;
         when False =>
            RES0       : CBAR_RES0_Type;
            --  Upper 26 bits of base physical address of GIC registers
            PERIPHBASE : CBAR_PERIPHBASE_Type;
      end case;
   end record with
     Size => 64, Bit_Order => System.Low_Order_First, Unchecked_Union;

   for CBAR_EL1_Type use record
      RES0       at 0 range  0 .. 17;
      PERIPHBASE at 0 range 18 .. 43;
      Value      at 0 range  0 .. 63;
   end record;

   function Get_CBAR_EL1 return CBAR_EL1_Type;

   ----------------------------------------------------------------------------
   --  GIC distributor registers
   ----------------------------------------------------------------------------

   type Group_Interrupts_Enable_Type is
     (Group_Interrupts_Disabled, Group_Interrupts_Enabled) with
     Size => 1;

   for Group_Interrupts_Enable_Type use
     (Group_Interrupts_Disabled => 2#0#, Group_Interrupts_Enabled => 2#1#);

   type Affinity_Routing_Enable_Type is
     (Affinity_Routing_Disabled, Affinity_Routing_Enabled) with
     Size => 1;

   for Affinity_Routing_Enable_Type use
     (Affinity_Routing_Disabled => 2#0#, Affinity_Routing_Enabled => 2#1#);

   type Register_Write_Pending_Type is
     (Register_Write_Not_Pending, Register_Write_Pending) with
     Size => 1;

   for Register_Write_Pending_Type use
     (Register_Write_Not_Pending => 2#0#, Register_Write_Pending => 2#1#);

   type GICD_CTLR_Type is record
      EnableGrp0 : Group_Interrupts_Enable_Type := Group_Interrupts_Disabled;
      EnableGrp1 : Group_Interrupts_Enable_Type := Group_Interrupts_Disabled;
      ARE        : Affinity_Routing_Enable_Type := Affinity_Routing_Disabled;
      RWP        : Register_Write_Pending_Type  := Register_Write_Not_Pending;
   end record with
     Volatile_Full_Access, Size => 32, Bit_Order => System.Low_Order_First;

   for GICD_CTLR_Type use record
      EnableGrp0 at 16#0# range  0 ..  0;
      EnableGrp1 at 16#0# range  1 ..  1;
      ARE        at 16#0# range  4 ..  4;
      RWP        at 16#0# range 31 .. 31;
   end record;

   --
   --  Number of SPI INTIDs that the GIC Distributor supports. The valid values
   --  for this field range from 1 to 30, depending on the number of SPIs
   --  configured for Cortex-R52.
   --  Valid interrupt INTID range is 0 to 32*(ITLinesNumber + 1) - 1.
   --
   type ITLinesNumber_Type is range 1 .. 30 with
     Size => 5;

   --
   --  Number of INTID bits that the GIC Distributor supports, minus one.
   --  For the Cortex-R52 this value is 0b01001 (INTID is 10 bits).
   --
   type TYPER_IDBits_Type is mod 2**5 with
     Size => 5;

   ARM_Cortex_A72_GICD_TYPER_IDbits : constant TYPER_IDBits_Type :=
     2#0_0000#; --  1 = 1 - 1

   type GICD_TYPER_Type is record
      ITLinesNumber : ITLinesNumber_Type := ITLinesNumber_Type'First;
      IDBits        : TYPER_IDBits_Type  := TYPER_IDBits_Type'First;
   end record with
     Volatile_Full_Access, Size => 32, Bit_Order => System.Low_Order_First;

   for GICD_TYPER_Type use record
      ITLinesNumber at 16#0# range  0 ..  4;
      IDBits        at 16#0# range 19 .. 23;
   end record;

   type GICD_IIDR_Type is new Interfaces.Unsigned_32;

   GICD_IIDR_GIC_400_Value : constant GICD_IIDR_Type := 16#0200143B#;

   --
   --  Interrupt groups in the GIC
   --  - Group0 routed to FIQ line
   --  - Group1 routed to IRQ line
   --
   type GIC_Interrupt_Group_Type is new Cpu_Interrupt_Line_Type with
     Size => 1;

   GIC_Interrupt_Group0 : constant GIC_Interrupt_Group_Type :=
     Cpu_Interrupt_Fiq;
   GIC_Interrupt_Group1 : constant GIC_Interrupt_Group_Type :=
     Cpu_Interrupt_Irq;

   type GIC_IGROUPR_Type is array (0 .. 31) of GIC_Interrupt_Group_Type with
     Volatile_Full_Access, Size => 32, Component_Size => 1;

   --
   --  The GICD_IGROUPR1-30 registers control whether the corresponding SPI is
   --  in Group 0 or Group 1. Each register contains the group bits for 32 SPIs.
   --  GICD_IGROUPR (1)(0) corresponds to INTID32 and GICD_IGROUPR(30)(31)
   --  corresponds to INTID991.
   --  Group 0 interrupts are signaled with FIQ and Group 1 interrupts are
   --  signaled with IRQ.
   --
   type GICD_IGROUPR_Array_Type is array (1 .. 30) of GIC_IGROUPR_Type;

   type GIC_Interrupt_Bit_Type is mod 2**1 with
     Size => 1;

   type GIC_Interrupt_Bit_Mask_Type is
     array (0 .. 31) of GIC_Interrupt_Bit_Type with
     Size => 32, Component_Size => 1;

   --  Interrupt set-enable register for 32 interrupts
   type GIC_ISENABLER_Type is new GIC_Interrupt_Bit_Mask_Type with Volatile_Full_Access;

   --
   --  The GICD_ISENABLER1-30 registers enable forwarding of the corresponding
   --  SPI from the Distributor to the CPU interfaces. Each register contains
   --  the set-enable bits for 32 SPIs.
   --  GICD_ISENABLER (1)(0) corresponds to INTID32 and GICD_ISENABLER(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_ISENABLER_Array_Type is array (1 .. 30) of GIC_ISENABLER_Type;

   --  Interrupt clear-enable register for 32 interrupts
   type GIC_ICENABLER_Type is new GIC_Interrupt_Bit_Mask_Type with Volatile_Full_Access;

   --
   --  The GICD_ICENABLER1-30 registers disable forwarding of the corresponding
   --  SPI to the CPU interfaces. Each register contains the clear-enable bits
   --  for 32 SPIs.
   --  GICD_ICENABLER (1)(0) corresponds to INTID32 and GICD_ICENABLER(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_ICENABLER_Array_Type is array (1 .. 30) of GIC_ICENABLER_Type;

   --  Interrupt set-pending register for 32 interrupts
   type GIC_ISPENDR_Type is new GIC_Interrupt_Bit_Mask_Type with Volatile_Full_Access;

   --
   --  The GICD_ISPENDR1-30 registers set the pending bit for the corresponding
   --  SPI. Each register contains the set-pending bits for 32 SPIs.
   --  GICD_ISPENDR (1)(0) corresponds to INTID32 and GICD_ISPENDR(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_ISPENDR_Array_Type is array (1 .. 30) of GIC_ISPENDR_Type;

   --  Interrupt clear-pending register for 32 interrupts
   type GIC_ICPENDR_Type is new GIC_Interrupt_Bit_Mask_Type with Volatile_Full_Access;

   --
   --  The GICD_ICPENDR1-30 registers clear the pending bit for the corresponding
   --  SPI. Each register contains the clear-pending bits for 32 SPIs.
   --  GICD_ICPENDR (1)(0) corresponds to INTID32 and GICD_ICPENDR(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_ICPENDR_Array_Type is array (1 .. 30) of GIC_ICPENDR_Type;

   --  Interrupt set-active register for 32 interrupts
   type GIC_ISACTIVER_Type is new GIC_Interrupt_Bit_Mask_Type with Volatile_Full_Access;

   --
   --  The GICD_ISACTIVER1-30 registers set the active bit for the corresponding
   --  SPI. Each register contains the set-active bits for 32 SPIs.
   --  GICD_ISACTIVER (1)(0) corresponds to INTID32 and GICD_ISACTIVER(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_ISACTIVER_Array_Type is array (1 .. 30) of GIC_ISACTIVER_Type;

   --  Interrupt clear-active register for 32 interrupts
   type GIC_ICACTIVER_Type is new GIC_Interrupt_Bit_Mask_Type with Volatile_Full_Access;

   --
   --  The GICD_ICACTIVER1-30 registers clear the active bit for the corresponding
   --  SPI. Each register contains the clear-active bits for 32 SPIs.
   --  GICD_ICACTIVER (1)(0) corresponds to INTID32 and GICD_ICACTIVER(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_ICACTIVER_Array_Type is array (1 .. 30) of GIC_ICACTIVER_Type;

   type GIC_Interrupt_Priority_Type is new Interrupt_Priority_Type with
     Size => 5;

   type GIC_IPRIORITYR_Slot_Type is record
      Interrupt_Priority : GIC_Interrupt_Priority_Type :=
        GIC_Interrupt_Priority_Type'First;
   end record with
     Size => 8, Bit_Order => System.Low_Order_First;

   for GIC_IPRIORITYR_Slot_Type use record
      Interrupt_Priority at 16#0# range 3 .. 7;
   end record;

   type GIC_IPRIORITYR_Slot_Array_Type is
     array (0 .. 3) of GIC_IPRIORITYR_Slot_Type with
     Component_Size => 8, Size => 32;

   type GIC_IPRIORITYR_Type (As_Word : Boolean := True) is record
      case As_Word is
         when True =>
            Value : Interfaces.Unsigned_32 := 0;
         when False =>
            Slot_Array : GIC_IPRIORITYR_Slot_Array_Type;
      end case;
   end record with
     Size => 32, Unchecked_Union, Volatile_Full_Access;

   --
   --  The GICD_IPRIORITYR8-247 registers provide a 5-bit priority field for each
   --  SPI supported by the GIC.
   --  The corresponding GICD_IPRIORITYRn number, n, is given by n = m DIV 4,
   --  where m = 32 to 991.
   --  The address offset of the required GICD_IPRIORITYRn is (0x400 + (4×n)).
   --  The byte offset of the required Priority field in this register is m MOD 4.
   --  GICD_IPRIORITYR(8)[7:0] corresponds to INTID32 and GICD_IPRIORITYR(247)31:24]
   --  corresponds to INTID991.
   --
   type GICD_IPRIORITYR_Array_Type is array (8 .. 247) of GIC_IPRIORITYR_Type;

   type GIC_ITARGETSR_Slot_Type is array (0 .. 7) of Boolean with
     Component_Size => 1, Size => 8;

   type GIC_ITARGETSR_Slot_Array_Type is
     array (0 .. 3) of GIC_ITARGETSR_Slot_Type with
     Component_Size => 8, Size => 32;

   type GIC_ITARGETSR_Type (As_Word : Boolean := True) is record
      case As_Word is
         when True =>
            Value : Interfaces.Unsigned_32 := 0;
         when False =>
            Slot_Array : GIC_ITARGETSR_Slot_Array_Type;
      end case;
   end record with
     Size => 32, Unchecked_Union, Volatile_Full_Access;

   --
   --  The GICD_ITARGETSR8-247 registers provide a 8-bit mask indicating the
   --  CPU cores that are the targets of a given SPI interrupt m.
   --  The corresponding GICD_ITARGETSRn number, n, is given by n = m DIV 4,
   --  where m = 32 to 991.
   --  The address offset of the required GICD_ITARGETSRn is (0x400 + (4×n)).
   --  The byte offset of the required Priority field in this register is m MOD 4.
   --  GICD_ITARGETSR(8)[7:0] corresponds to INTID32 and GICD_ITARGETSR(247)31:24]
   --  corresponds to INTID991.
   --
   type GICD_ITARGETSR_Array_Type is array (8 .. 247) of GIC_ITARGETSR_Type;

   type GIC_ICFGR_Interrupt_Trigger_Mode_Type is
     new Interrupt_Trigger_Mode_Type with
     Size => 2;

   type GIC_ICFGR_Interrupt_Trigger_Mode_Array_Type is
     array (0 .. 15) of GIC_ICFGR_Interrupt_Trigger_Mode_Type with
     Component_Size => 2, Size => 32;

   type GIC_ICFGR_Type (As_Word : Boolean := True) is record
      case As_Word is
         when True =>
            Value : Interfaces.Unsigned_32 := 0;
         when False =>
            Interrupt_Trigger_Mode_Array : GIC_ICFGR_Interrupt_Trigger_Mode_Array_Type;
      end case;
   end record with
     Size => 32, Unchecked_Union, Volatile_Full_Access;

   --
   --  The GICD_ICFGR2-61 registers provide a 2-bit Int_config field for each
   --  interrupt supported by the GIC. This field determines whether the
   --  corresponding interrupt is rising edge-triggered or active-HIGH
   --  level-sensitive.
   --  GICD_ICFGR(2)[1:0] corresponds to INTID32 and GICD_ICFGR(61)[31:30] corresponds
   --  to INTID991.
   --
   type GICD_ICFGR_Array_Type is array (2 .. 61) of GIC_ICFGR_Type;

   --
   --  Set of cores for which SGI interrupts are generated. Each bit corresponds
   --  to the core within a cluster with an Affinity 0 value equal to the bit
   --  number.
   --
   type GICD_SGIR_Target_List_Type is mod 2**5 with
     Size => 5;

   --  Software generated interrupts:
   type SGI_INTID_Type is mod 2**4 with
     Size => 4;

   type Interrupt_Routing_Mode_Type is
     (Interrupts_Routed_To_Selected_Cores, --  cores specified by Aff3.Aff2.Aff1.<target list>
      Interrupts_Routed_To_All_Cores_But_Self) with
     Size => 1;

   for Interrupt_Routing_Mode_Type use
     (Interrupts_Routed_To_Selected_Cores     => 2#0#,
      Interrupts_Routed_To_All_Cores_But_Self => 2#1#);

   --
   --  Interrupt Controller Software Generated Interrupt Register.
   --
   type GICD_SGIR_Type (As_Value : Boolean := False) is record
      case As_Value is
         when True =>
            Value : Interfaces.Unsigned_32;
         when False =>
            INTID       : SGI_INTID_Type;
            Target_List : GICD_SGIR_Target_List_Type := GICD_SGIR_Target_List_Type'First;
      end case;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First, Unchecked_Union, Volatile_Full_Access;

   for GICD_SGIR_Type use record
      INTID       at 0 range 0 .. 3;
      Target_List at 0 range 16 .. 23;
   end record;

   --
   --  Generic Interrupt Controller Distributor (GICD)
   --
   type GICD_Type is limited record
      GICD_CTLR             : GICD_CTLR_Type;
      GICD_TYPER            : GICD_TYPER_Type;
      GICD_IIDR             : GICD_IIDR_Type;
      GICD_IGROUPR_Array    : GICD_IGROUPR_Array_Type;
      GICD_ISENABLER_Array  : GICD_ISENABLER_Array_Type;
      GICD_ICENABLER_Array  : GICD_ICENABLER_Array_Type;
      GICD_ISPENDR_Array    : GICD_ISPENDR_Array_Type;
      GICD_ICPENDR_Array    : GICD_ICPENDR_Array_Type;
      GICD_ISACTIVER_Array  : GICD_ISACTIVER_Array_Type;
      GICD_ICACTIVER_Array  : GICD_ICACTIVER_Array_Type;
      GICD_IPRIORITYR_Array : GICD_IPRIORITYR_Array_Type;
      GICD_ITARGETSR_Array : GICD_ITARGETSR_Array_Type;
      GICD_ICFGR_Array      : GICD_ICFGR_Array_Type;
      GICD_SGIR             : GICD_SGIR_Type;
   end record with Volatile;

   for GICD_Type use record
      GICD_CTLR             at       16#0# range 0 .. 31;
      GICD_TYPER            at       16#4# range 0 .. 31;
      GICD_IIDR             at       16#8# range 0 .. 31;
      GICD_IGROUPR_Array    at    16#0080# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ISENABLER_Array  at    16#0100# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ICENABLER_Array  at    16#0180# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ISPENDR_Array    at    16#0200# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ICPENDR_Array    at    16#0280# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ISACTIVER_Array  at    16#0300# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ICACTIVER_Array  at    16#0380# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_IPRIORITYR_Array at    16#0400# range 0 .. ((247 - 8 + 1) * 32) - 1;
      GICD_ITARGETSR_Array  at    16#0800# range 0 .. ((247 - 8 + 1) * 32) - 1;
      GICD_ICFGR_Array      at    16#0C00# range 0 .. ((61 - 2 + 1) * 32) - 1;
      GICD_SGIR             at    16#0F00# range 0 .. 31;
   end record;

   GICD : aliased GICD_Type with
     Import, Address => HiRTOS_Platform_Parameters.GICD_Base_Address;

   ----------------------------------------------------------------------------
   --  GIC CPU interface registers
   ----------------------------------------------------------------------------

   type INTID_Type is mod 2**24 with
     Size => 24;

   --
   --  Interrupt Controller Interrupt Acknowledge Register
   --
   --  The ICC_IARx register contains the INTID of the signaled interrupt.
   --  When the core reads this INTID, it acts as an acknowledge for the interrupt.
   --
   type ICC_IAR_Type is record
      INTID : INTID_Type := INTID_Type'First;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First, Volatile_Full_Access;

   for ICC_IAR_Type use record
      INTID at 0 range 0 .. 23;
   end record;

   --
   --  Interrupt Controller End Of Interrupt Register
   --
   --  A core can write to the ICC_EOIRx register to inform the CPU interface
   --  that it has completed the processing of the specified Group x interrupt.
   --  In normal operation, the highest priority set group x priority bit is
   --  cleared and additionally the interrupt is deactivated if ICC_CTLR.EOImode == 0.
   --
   type ICC_EOIR_Type is record
      INTID : INTID_Type := INTID_Type'First;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First, Volatile_Full_Access;

   for ICC_EOIR_Type use record
      INTID at 0 range 0 .. 23;
   end record;

   --
   --  Interrupt Controller Highest Priority Pending Interrupt Register
   --
   type ICC_HPPIR_Type is record
      INTID : INTID_Type := INTID_Type'First;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First, Volatile_Full_Access;

   for ICC_HPPIR_Type use record
      INTID at 0 range 0 .. 23;
   end record;

   --
   --  This value controls how the 5-bit interrupt priority field is split into
   --  a group priority field, that determines interrupt preemption, and a
   --  subpriority field. See Table 10-88 "ICC_BPR0 relationship between binary
   --  point value and group priority, subpriority fields" in the ARM Cortex-R52
   --  TRM.
   --
   type Binary_Point_Type is mod 2**3 with
     Size => 3;

   --
   --  Interrupt Controller Binary Point Register
   --
   --  The ICC_BPR register defines the point at which the priority value fields
   --  split into two parts, the group priority field and the subpriority field.
   --  The group priority field determines Group 0 interrupt preemption.
   --
   type ICC_BPR_Type (As_Value : Boolean := True) is record
      case As_Value is
         when True =>
            Value : Interfaces.Unsigned_32 := 0;
         when False =>
            Binary_Point : Binary_Point_Type;
      end case;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First, Unchecked_Union, Volatile_Full_Access;

   for ICC_BPR_Type use record
      Binary_Point at 0 range 0 .. 2;
   end record;

   --
   --  Interrupt Controller Deactivate Interrupt
   --
   type ICC_DIR_Type is record
      INTID : INTID_Type := INTID_Type'First;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First, Volatile_Full_Access;

   for ICC_DIR_Type use record
      INTID at 0 range 0 .. 23;
   end record;

   --
   --  Interrupt Controller Interrupt Priority Mask Register
   --
   --  The ICC_PMR register provides an interrupt priority filter.
   --  Only interrupts with higher priority than the value in this
   --  register are signaled to the core. Lower values have higher
   --  priority.
   --
   type ICC_PMR_Type is record
      Priority : GIC_Interrupt_Priority_Type;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First, Volatile_Full_Access;

   for ICC_PMR_Type use record
      Priority at 0 range 3 .. 7;
   end record;

   --
   --  Interrupt Controller Running Priority Register
   --
   --  It indicates the highest active priority across Groups 0 and 1, of the CPU interface.
   --
   type ICC_RPR_Type is record
      --
      --  Current running interrupt priority. Returns the value 0xFF when ICC_AP0R0
      --  and ICC_AP1R0 are both 0x0. Otherwise returns the index in bits [7:3]
      --  of the lowest set bit from ICC_AP0R0 and ICC_AP1R0.
      --
      Priority : Interfaces.Unsigned_8;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First, Volatile_Full_Access;

   for ICC_RPR_Type use record
      Priority at 0 range 0 .. 7;
   end record;

   type CBPR_Type is
     (Use_ICC_BPR0_For_Interrupt_Preemption_Disabled,
      Use_ICC_BPR0_For_Interrupt_Preemption_Enabled) with
     Size => 1;

   for CBPR_Type use
     (Use_ICC_BPR0_For_Interrupt_Preemption_Disabled => 2#0#,
      Use_ICC_BPR0_For_Interrupt_Preemption_Enabled  => 2#1#);

   type EOImode_Type is
     (ICC_EOIRx_Write_Deactives_Interrupt_Enabled,
      ICC_EOIRx_Write_Deactives_Interrupt_Disabled) with
     Size => 1;

   --
   --  EOImode = 0: A write to ICC_EOIR0_EL1 for Group 0 interrupts, or ICC_EOIR1_EL1 for Group 1
   --  interrupts, performs both the priority drop and deactivation.
   --  EOImode = 1: A write to ICC_EOIR_EL10 for Group 0 interrupts, or ICC_EOIR1_EL1 for Group 1
   --  interrupts results in a priority drop. A separate write to ICC_DIR_EL1 is required for
   --  deactivation.
   for EOImode_Type use
     (ICC_EOIRx_Write_Deactives_Interrupt_Enabled => 2#0#,
      ICC_EOIRx_Write_Deactives_Interrupt_Disabled => 2#1#);

   --  Number of priority bits implemented, minus one
   type PRIbits_Type is mod 2**3 with
     Size => 3;

   ARM_Cortex_A72_PRIbits : constant PRIbits_Type := 2#100#; --  5 - 1

   --  Number of physical interrupt identifier bits supported
   type CTLR_IDbits_Type is mod 2**3 with
     Size => 3;

   ARM_Cortex_A72_ICC_CTLR_IDbits : constant CTLR_IDbits_Type := 2#000#; --  16

   --
   --  Interrupt Controller Control Register (EL1)
   --
   type ICC_CTLR_Type is record
      CBPR    : CBPR_Type := Use_ICC_BPR0_For_Interrupt_Preemption_Disabled;
      EOImode : EOImode_Type := ICC_EOIRx_Write_Deactives_Interrupt_Disabled;
      PRIbits : PRIbits_Type     := PRIbits_Type'First;
      IDbits  : CTLR_IDbits_Type := CTLR_IDbits_Type'First;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First, Volatile_Full_Access;

   for ICC_CTLR_Type use record
      CBPR    at 0 range  0 ..  0;
      EOImode at 0 range  1 ..  1;
      PRIbits at 0 range  8 .. 10;
      IDbits  at 0 range 11 .. 13;
   end record;

   type ICC_IIDR_Type is new Interfaces.Unsigned_32;

   ICC_IIDR_GIC_400_Value : constant ICC_IIDR_Type := 16#0202143B#;

   --
   --  Memory-mapped banked interface to the GIC CPU interface for each CPU core
   --
   type GICC_Type is limited record
      ICC_CTLR  : ICC_CTLR_Type;
      ICC_PMR   : ICC_PMR_Type;
      ICC_BPR   : ICC_BPR_Type;
      ICC_IAR   : ICC_IAR_Type;
      ICC_EOIR  : ICC_EOIR_Type;
      ICC_RPR   : ICC_RPR_Type;
      ICC_HPPIR : ICC_HPPIR_Type;
      ICC_IIDR  : ICC_IIDR_Type;
      ICC_DIR   : ICC_DIR_Type;
   end record with Volatile;

   for GICC_Type use record
      ICC_CTLR  at 16#0000# range 0 .. 31;
      ICC_PMR   at 16#0004# range 0 .. 31;
      ICC_BPR   at 16#0008# range 0 .. 31;
      ICC_IAR   at 16#000c# range 0 .. 31;
      ICC_EOIR  at 16#0010# range 0 .. 31;
      ICC_RPR   at 16#0014# range 0 .. 31;
      ICC_HPPIR at 16#0018# range 0 .. 31;
      ICC_IIDR  at 16#00fc# range 0 .. 31;
      ICC_DIR   at 16#1000# range 0 .. 31;
   end record;

   GICC : aliased GICC_Type with
     Import, Address => HiRTOS_Platform_Parameters.GICC_Base_Address;

   ----------------------------------------------------------------------------
   --  Interrupt controller state variables
   ----------------------------------------------------------------------------

   type Per_Cpu_Flags_Array_Type is
     array (Valid_Cpu_Core_Id_Type) of Boolean with
     Component_Size => 1, Size => Cpu_Register_Type'Size, Warnings => Off;

   type Interrupt_Handler_Type is record
      Cpu_Id                        : Cpu_Core_Id_Type := Invalid_Cpu_Core_Id;
      Interrupt_Handler_Entry_Point : Interrupt_Handler_Entry_Point_Type :=
        null;
      Interrupt_Handler_Arg         : System.Address := System.Null_Address;
      Times_Interrupt_Fired         : Natural                            := 0;
   end record with
     Alignment => HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes;

   type Internal_Interrupt_Handler_Array_Type is
     array
       (Valid_Cpu_Core_Id_Type,
        Internal_Interrupt_Id_Type) of Interrupt_Handler_Type;

   type External_Interrupt_Handler_Array_Type is
     array (External_Interrupt_Id_Type) of Interrupt_Handler_Type;

   type Interrupt_Controller_Type is record
      Per_Cpu_Initialized_Flags    : HiRTOS_Cpu_Multi_Core_Interface.Atomic_Counter_Type;
      GIC_Distributor_Initialized  : Boolean := False with Volatile;
      Max_Number_Interrupt_Sources : Interfaces.Unsigned_16;
      Spinlock : HiRTOS_Cpu_Multi_Core_Interface.Spinlock_Type;
      Internal_Interrupt_Handlers  : Internal_Interrupt_Handler_Array_Type;
      External_Interrupt_Handlers  : External_Interrupt_Handler_Array_Type;
   end record;

   Interrupt_Controller_Obj : Interrupt_Controller_Type;

   function Per_Cpu_Initialized return Boolean is
     ((HiRTOS_Cpu_Multi_Core_Interface.Atomic_Load (Interrupt_Controller_Obj.Per_Cpu_Initialized_Flags) and
       Bit_Mask (Bit_Index_Type (Get_Cpu_Id))) /= 0);

end HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
