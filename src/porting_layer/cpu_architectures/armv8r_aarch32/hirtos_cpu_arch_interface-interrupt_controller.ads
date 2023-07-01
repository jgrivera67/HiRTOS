--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary RTOS to target platform interface - Interrupt controller driver
--  for ARMv8-R MPU
--

with HiRTOS_Cpu_Multi_Core_Interface;
private with HiRTOS.Memory_Protection;
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
   subtype External_Interrupt_Id_Type is Interrupt_Id_Type range 32 .. 991;

   --  Priority 0 is the highest priority and prioirty 31 is the lowest
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
      Priority                      : Interrupt_Priority_Type;
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
      Priority                      : Interrupt_Priority_Type;
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
      not Cpu_Interrupting_Disabled;

   procedure Trigger_Software_Generated_Interrupt (Soft_Gen_Interrupt_Id : Soft_Gen_Interrupt_Id_Type;
                                                   Cpu_Id : HiRTOS_Cpu_Multi_Core_Interface.Cpu_Core_Id_Type);

   function Get_Highest_Interrupt_Priority_Disabled return Interrupt_Priority_Type
      with Pre => Cpu_In_Privileged_Mode;

   procedure Set_Highest_Interrupt_Priority_Disabled (Priority : Interrupt_Priority_Type)
      with Pre => Cpu_In_Privileged_Mode;

private
   pragma SPARK_Mode (Off);
   use HiRTOS_Cpu_Multi_Core_Interface;

   type CBAR_RES0_Type is mod 2**21 with
     Size => 21;

   type CBAR_PERIPHBASE_Type is mod 2**11 with
     Size => 11;

   --
   --  Configuration Base Address Register
   --  (This register holds the physical base address of the memory-mapped GIC
   --   Distributor registers.)
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  aIMP_CBARs it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type IMP_CBAR_Type (As_Word : Boolean := True) is record
      case As_Word is
         when True =>
            Value : Interfaces.Unsigned_32 := 0;
         when False =>
            RES0       : CBAR_RES0_Type;
            --  Upper 11 bits of base physical address of GIC registers
            PERIPHBASE : CBAR_PERIPHBASE_Type;
      end case;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First, Unchecked_Union;

   for IMP_CBAR_Type use record
      RES0       at 0 range  0 .. 20;
      PERIPHBASE at 0 range 21 .. 31;
      Value      at 0 range  0 .. 31;
   end record;

   function Get_IMP_CBAR return IMP_CBAR_Type;

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

   ARM_Cortex_R52_GICD_TYPER_IDbits : constant TYPER_IDBits_Type :=
     2#0_1001#; --  9 = 10 - 1

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

   type GIC_Interrupt_Bits_Register_Type is
     array (0 .. 31) of GIC_Interrupt_Bit_Type with
     Size => 32, Component_Size => 1, Volatile_Full_Access;

   --  Interrupt set-enable register for 32 interrupts
   type GIC_ISENABLER_Type is new GIC_Interrupt_Bits_Register_Type;

   --
   --  The GICD_ISENABLER1-30 registers enable forwarding of the corresponding
   --  SPI from the Distributor to the CPU interfaces. Each register contains
   --  the set-enable bits for 32 SPIs.
   --  GICD_ISENABLER (1)(0) corresponds to INTID32 and GICD_ISENABLER(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_ISENABLER_Array_Type is array (1 .. 30) of GIC_ISENABLER_Type;

   --  Interrupt clear-enable register for 32 interrupts
   type GIC_ICENABLER_Type is new GIC_Interrupt_Bits_Register_Type;

   --
   --  The GICD_ICENABLER1-30 registers disable forwarding of the corresponding
   --  SPI to the CPU interfaces. Each register contains the clear-enable bits
   --  for 32 SPIs.
   --  GICD_ICENABLER (1)(0) corresponds to INTID32 and GICD_ICENABLER(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_ICENABLER_Array_Type is array (1 .. 30) of GIC_ICENABLER_Type;

   --  Interrupt set-pending register for 32 interrupts
   type GIC_ISPENDR_Type is new GIC_Interrupt_Bits_Register_Type;

   --
   --  The GICD_ISPENDR1-30 registers set the pending bit for the corresponding
   --  SPI. Each register contains the set-pending bits for 32 SPIs.
   --  GICD_ISPENDR (1)(0) corresponds to INTID32 and GICD_ISPENDR(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_ISPENDR_Array_Type is array (1 .. 30) of GIC_ISPENDR_Type;

   --  Interrupt clear-pending register for 32 interrupts
   type GIC_ICPENDR_Type is new GIC_Interrupt_Bits_Register_Type;

   --
   --  The GICD_ICPENDR1-30 registers clear the pending bit for the corresponding
   --  SPI. Each register contains the clear-pending bits for 32 SPIs.
   --  GICD_ICPENDR (1)(0) corresponds to INTID32 and GICD_ICPENDR(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_ICPENDR_Array_Type is array (1 .. 30) of GIC_ICPENDR_Type;

   --  Interrupt set-active register for 32 interrupts
   type GIC_ISACTIVER_Type is new GIC_Interrupt_Bits_Register_Type;

   --
   --  The GICD_ISACTIVER1-30 registers set the active bit for the corresponding
   --  SPI. Each register contains the set-active bits for 32 SPIs.
   --  GICD_ISACTIVER (1)(0) corresponds to INTID32 and GICD_ISACTIVER(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_ISACTIVER_Array_Type is array (1 .. 30) of GIC_ISACTIVER_Type;

   --  Interrupt clear-active register for 32 interrupts
   type GIC_ICACTIVER_Type is new GIC_Interrupt_Bits_Register_Type;

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

   type GICD_IROUTER_Affinity_Type is mod 2**8 with
     Size => 8;

   type GICD_IROUTER_Type (As_Two_Words : Boolean := False) is record
      case As_Two_Words is
         when True =>
            Lower_Word : Interfaces.Unsigned_32 with
              Volatile_Full_Access;
            Upper_Word : Interfaces.Unsigned_32 with
              Volatile_Full_Access;
         when False =>
            Aff0 : GICD_IROUTER_Affinity_Type :=
              GICD_IROUTER_Affinity_Type'First;
            Aff1 : GICD_IROUTER_Affinity_Type :=
              GICD_IROUTER_Affinity_Type'First;
            Aff2 : GICD_IROUTER_Affinity_Type :=
              GICD_IROUTER_Affinity_Type'First;
            Aff3 : GICD_IROUTER_Affinity_Type :=
              GICD_IROUTER_Affinity_Type'First;
      end case;
   end record with
     Size => 64, Unchecked_Union, Bit_Order => System.Low_Order_First;

   for GICD_IROUTER_Type use record
      Aff0       at 16#0# range  0 ..  7;
      Aff1       at 16#0# range  8 .. 15;
      Aff2       at 16#0# range 16 .. 23;
      Aff3       at 16#0# range 32 .. 39;
      Lower_Word at 16#0# range  0 .. 31;
      Upper_Word at 16#4# range  0 .. 31;
   end record;

   --
   --  The GICD_IROUTER32-991 registers provide routing information for the SPI
   --  with GICD_IROUTERn corresponding to INTIDn.
   --  GICD_IROUTER(32) corresponds to INTID32 and GICD_IROUTER(991) corresponds
   --  to INTID991.
   --
   type GICD_IROUTER_Array_Type is array (32 .. 991) of GICD_IROUTER_Type;

   type GICD_PIDR_Type is new Interfaces.Unsigned_32 with
     Volatile_Full_Access;

   --
   --  The GICD_PIDR0-7 registers provide the peripheral identification information.
   --
   type GICD_PIDR_Array_Type is array (0 .. 7) of GICD_PIDR_Type;

   Arm_Cortex_R52_GICD_PIDR_Array : constant GICD_PIDR_Array_Type :=
     [16#0000_0092#, 16#0000_00B4#, 16#0000_003B#, 16#0000_0000#,
     16#0000_0044#, 16#0000_0000#, 16#0000_0000#, 16#0000_0000#];

   ARM_Cortex_R52_GICR_IIDR_Value : constant Interfaces.Unsigned_32 :=
     16#0101_243B#;

   type GICR_TYPER_Affinity_Type is mod 2**8 with
     Size => 8;

   type GICR_TYPER_Processor_Number_Type is mod 2**16 with
     Size => 16;

   type GICR_TYPER_Last_Type is
     (Not_Last_Redistributor, Last_Redistributor) with
     Size => 1;

   for GICR_TYPER_Last_Type use
     (Not_Last_Redistributor => 2#0#, Last_Redistributor => 2#1#);

   type GICR_TYPER_Type (As_Two_Words : Boolean := True) is record
      case As_Two_Words is
         when True =>
            Lower_Word : Interfaces.Unsigned_32 := 0 with
              Volatile_Full_Access;
            Upper_Word : Interfaces.Unsigned_32 := 0 with
              Volatile_Full_Access;
         when False =>
            Last             : GICR_TYPER_Last_Type;
            --  CPU core Id. It is the same as Aff0 with unused MSBs zero-padded
            Processor_Number : GICR_TYPER_Processor_Number_Type;
            Aff0             : GICR_TYPER_Affinity_Type;
            Aff1             : GICR_TYPER_Affinity_Type;
            Aff2             : GICR_TYPER_Affinity_Type;
            Aff3             : GICR_TYPER_Affinity_Type;
      end case;
   end record with
     Size => 64, Unchecked_Union, Bit_Order => System.Low_Order_First;

   for GICR_TYPER_Type use record
      Last             at 16#0# range  4 ..  4;
      Processor_Number at 16#0# range  8 .. 23;
      Aff0             at 16#0# range 32 .. 39;
      Aff1             at 16#0# range 40 .. 47;
      Aff2             at 16#0# range 48 .. 55;
      Aff3             at 16#0# range 56 .. 63;
      Lower_Word       at 16#0# range  0 .. 31;
      Upper_Word       at 16#4# range  0 .. 31;
   end record;

   type GICR_WAKER_Processor_Sleep_Type is
     (Target_Not_In_Processor_Sleep_State,
      Target_In_Processor_Sleep_State) with
     Size => 1;

   for GICR_WAKER_Processor_Sleep_Type use
     (Target_Not_In_Processor_Sleep_State => 2#0#,
      Target_In_Processor_Sleep_State     => 2#1#);

   type GICR_WAKER_Children_Asleep_Type is
     (All_Interfaces_Target_Not_Quiescent,
      All_Interfaces_Target_Quiescent) with
     Size => 1;

   for GICR_WAKER_Children_Asleep_Type use
     (All_Interfaces_Target_Not_Quiescent => 2#0#,
      All_Interfaces_Target_Quiescent     => 2#1#);

   --  Redistributor Wake Register
   type GICR_WAKER_Type (As_Word : Boolean := True) is record
      case As_Word is
         when True =>
            Value : Interfaces.Unsigned_32 := 0;
         when False =>
            Processor_Sleep : GICR_WAKER_Processor_Sleep_Type;
            Children_Asleep : GICR_WAKER_Children_Asleep_Type;
      end case;
   end record with
     Size => 32, Unchecked_Union, Bit_Order => System.Low_Order_First,
     Volatile_Full_Access;

   for GICR_WAKER_Type use record
      Processor_Sleep at 16#0# range 1 ..  1;
      Children_Asleep at 16#0# range 2 ..  2;
      Value           at 16#0# range 0 .. 31;
   end record;

   type GICR_PIDR_Type is new Interfaces.Unsigned_32 with
     Volatile_Full_Access;

   --
   --  The GICR_PIDR0-7 registers provide the Peripheral identification information.
   --
   type GICR_PIDR_Array_Type is array (0 .. 7) of GICR_PIDR_Type;

   Arm_Cortex_R52_GICR_PIDR_Array : constant GICR_PIDR_Array_Type :=
     [16#0000_0093#, 16#0000_00B4#, 16#0000_003B#, 16#0000_0000#,
     16#0000_0044#, 16#0000_0000#, 16#0000_0000#, 16#0000_0000#];

   type GICR_CIDR_Type is new Interfaces.Unsigned_32 with
     Volatile_Full_Access;

   --  The GICR_CIDR0-3 registers provide the component identification information.
   type GICR_CIDR_Array_Type is array (0 .. 3) of GICR_CIDR_Type;

   Arm_Cortex_R52_GICR_CIDR_Array : constant GICR_CIDR_Array_Type :=
     [16#0000_000D#, 16#0000_00F0#, 16#0000_0005#, 16#0000_00B1#];

   type GICR_Control_Page_Type is limited record
      GICR_CTLR       : Interfaces.Unsigned_32;
      GICR_IIDR       : Interfaces.Unsigned_32;
      GICR_TYPER      : GICR_TYPER_Type;
      GICR_WAKER      : GICR_WAKER_Type;
      GICR_PIDR_Array : GICR_PIDR_Array_Type;
   end record with
     Volatile, Size => 64 * 1_024 * System.Storage_Unit;

   for GICR_Control_Page_Type use record
      GICR_CTLR       at 16#0000# range 0 ..                     31;
      GICR_IIDR       at 16#0004# range 0 ..                     31;
      GICR_TYPER      at 16#0008# range 0 ..                     63;
      GICR_WAKER      at 16#0014# range 0 ..                     31;
      GICR_PIDR_Array at 16#FFE0# range 0 .. ((7 - 0 + 1) * 32) - 1;
   end record;

   type GICR_IPRIORITYR_Array_Type is array (0 .. 7) of GIC_IPRIORITYR_Type;

   --
   --  The GICR_ICFGR0 register provides a 2-bit Int_config field for each SGI.
   --  All SGIs behave as edge-triggered interrupts and therefore this register
   --  is read only.
   --  The GICR_ICFGR1 register provides a 2-bit Int_config field for each PPI.
   --  Fields 0-5, 12, 13, and 15 are programmable, 6-11 and 14 are read-only
   --  because  they are assigned to core peripherals that have a fixed
   --  level-sensitive configuration.
   --
   type GICR_ICFGR_Array_Type is array (0 .. 1) of GIC_ICFGR_Type;

   type GICR_SGI_And_PPI_Page_Type is limited record
      --
      --  The GICR_IGROUPR0 register controls whether the corresponding SGI or PPI
      --  is in Group 0 or Group 1
      --
      GICR_IGROUPR0 : GIC_IGROUPR_Type;

      --
      --  The GICR_ISENABLER0 register enables forwarding of the corresponding
      --  SGI or PPI from the Distributor to the CPU interfaces.
      --
      GICR_ISENABLER0 : GIC_ISENABLER_Type;

      --
      --  The GICR_ICENABLER0 register disables forwarding of the corresponding
      --  SGI or PPI from the Distributor to the CPU interfaces.
      --
      GICR_ICENABLER0 : GIC_ICENABLER_Type;

      --  The GICR_ISPENDR0 register sets the pending bit for SGIs and PPIs.
      GICR_ISPENDR0 : GIC_ISPENDR_Type;

      --  The GICR_ICPENDR0 register clears the pending bit for SGIs and PPIs.
      GICR_ICPENDR0 : GIC_ICPENDR_Type;

      --  The GICR_ISACTIVER0 register sets the active bit for SGIs and PPIs.
      GICR_ISACTIVER0 : GIC_ISACTIVER_Type;

      --  The GICR_ICACTIVER0 register clears the active bit for SGIs and PPIs.
      GICR_ICACTIVER0 : GIC_ICACTIVER_Type;

      --
      --  The GICR_IPRIORITYR0-7 registers provide a 5-bit priority field for
      --  each SGI and PPI.
      --
      GICR_IPRIORITYR_Array : GICR_IPRIORITYR_Array_Type;

      GICR_ICFGR_Array : GICR_ICFGR_Array_Type;
   end record with
     Volatile, Size => 64 * 1_024 * System.Storage_Unit, Warnings => Off;

   for GICR_SGI_And_PPI_Page_Type use record
      GICR_IGROUPR0         at 16#0080# range 0 ..                     31;
      GICR_ISENABLER0       at 16#0100# range 0 ..                     31;
      GICR_ICENABLER0       at 16#0180# range 0 ..                     31;
      GICR_ISPENDR0         at 16#0200# range 0 ..                     31;
      GICR_ICPENDR0         at 16#0280# range 0 ..                     31;
      GICR_ISACTIVER0       at 16#0300# range 0 ..                     31;
      GICR_ICACTIVER0       at 16#0380# range 0 ..                     31;
      GICR_IPRIORITYR_Array at 16#0400# range 0 .. ((7 - 0 + 1) * 32) - 1;
      GICR_ICFGR_Array      at 16#0C00# range 0 .. ((1 - 0 + 1) * 32) - 1;
   end record;

   --
   --  Generic Interrupt Controller Redistributor (GICR)
   --
   type GICR_Type is limited record
      GICR_Control_Page     : GICR_Control_Page_Type;
      GICR_SGI_And_PPI_Page : GICR_SGI_And_PPI_Page_Type;
   end record with
     Volatile, Size => 64 * 1_024 * 2 * System.Storage_Unit;

   for GICR_Type use record
      GICR_Control_Page     at      16#0# range 0 ..
          (64 * 1_024 * System.Storage_Unit) - 1;
      GICR_SGI_And_PPI_Page at 16#1_0000# range 0 ..
          (64 * 1_024 * System.Storage_Unit) - 1;
   end record;

   type GICR_Array_Type is array (Valid_Cpu_Core_Id_Type) of GICR_Type;

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
      GICD_ICFGR_Array      : GICD_ICFGR_Array_Type;
      GICD_IROUTER_Array    : GICD_IROUTER_Array_Type;
      GICD_PIDR_Array       : GICD_PIDR_Array_Type;
      GICR_Array            : GICR_Array_Type;
   end record with
     Volatile;

   for GICD_Type use record
      GICD_CTLR             at       16#0# range 0 .. 31;
      GICD_TYPER            at       16#4# range 0 .. 31;
      GICD_IIDR             at       16#8# range 0 .. 31;
      GICD_IGROUPR_Array    at    16#0084# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ISENABLER_Array  at    16#0104# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ICENABLER_Array  at    16#0184# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ISPENDR_Array    at    16#0204# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ICPENDR_Array    at    16#0284# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ISACTIVER_Array  at    16#0304# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ICACTIVER_Array  at    16#0384# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_IPRIORITYR_Array at    16#0420# range 0 .. ((247 - 8 + 1) * 32) - 1;
      GICD_ICFGR_Array      at    16#0C08# range 0 .. ((61 - 2 + 1) * 32) - 1;
      GICD_IROUTER_Array    at 16#6100# range 0 .. ((991 - 32 + 1) * 64) - 1;
      GICD_PIDR_Array       at    16#FFE0# range 0 .. ((7 - 0 + 1) * 32) - 1;
      GICR_Array            at 16#10_0000# range 0 ..
          ((16#18_0000# - 16#10_0000#) * System.Storage_Unit) - 1;
   end record;

   GICD_Base_Address : constant System.Address :=
     System'To_Address (16#8000_0000# + 16#2F00_0000#);

   GICD : aliased GICD_Type with
     Import, Address => GICD_Base_Address;

   ----------------------------------------------------------------------------
   --  GIC CPU intterface registers
   ----------------------------------------------------------------------------

   type INTID_Type is mod 2**10 with
     Size => 10;

   --
   --  Interrupt Controller Interrupt Acknowledge Register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type ICC_IAR_Type is record
      INTID : INTID_Type := INTID_Type'First;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First;

   for ICC_IAR_Type use record
      INTID at 0 range 0 .. 9;
   end record;

   --
   --  The ICC_IARx register contains the INTID of the signaled Group x interrupt.
   --  When the core reads this INTID, it acts as an acknowledge for the interrupt.
   --
   function Get_ICC_IAR
     (GIC_Interrupt_Group : GIC_Interrupt_Group_Type) return ICC_IAR_Type with
     Inline_Always;

   procedure Set_ICC_IAR
     (GIC_Interrupt_Group : GIC_Interrupt_Group_Type;
      ICC_IAR_Value       : ICC_IAR_Type) with
     Inline_Always;

   --
   --  Interrupt Controller End Of Interrupt Register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type ICC_EOIR_Type is record
      INTID : INTID_Type := INTID_Type'First;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First;

   for ICC_EOIR_Type use record
      INTID at 0 range 0 .. 9;
   end record;

   --
   --  A core can write to the ICC_EOIRx register to inform the CPU interface
   --  that it has completed the processing of the specified Group x interrupt.
   --  In normal operation, the highest priority set group x priority bit is
   --  cleared and additionally the interrupt is deactivated if ICC_CTLR.EOImode == 0.
   --
   function Get_ICC_EOIR
     (GIC_Interrupt_Group : GIC_Interrupt_Group_Type) return ICC_EOIR_Type with
     Inline_Always;

   procedure Set_ICC_EOIR
     (GIC_Interrupt_Group : GIC_Interrupt_Group_Type;
      ICC_EOIR_Value      : ICC_EOIR_Type) with
     Inline_Always;

   --
   --  Interrupt Controller Highest Priority Pending Interrupt Register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type ICC_HPPIR_Type is record
      INTID : INTID_Type := INTID_Type'First;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First;

   for ICC_HPPIR_Type use record
      INTID at 0 range 0 .. 9;
   end record;

   --
   --  The ICC_HPPIRx register indicates the highest priority pending Group x
   --  interrupt on the CPU interface without changing the state of the GIC.
   --
   function Get_ICC_HPPIR
     (GIC_Interrupt_Group : GIC_Interrupt_Group_Type)
      return ICC_HPPIR_Type with
     Inline_Always;

   procedure Set_ICC_HPPIR
     (GIC_Interrupt_Group : GIC_Interrupt_Group_Type;
      ICC_HPPIR_Value     : ICC_HPPIR_Type) with
     Inline_Always;

   --
   --  This value controls how the 5-bit interrupt priority field is split into
   --  a group priority field, that determines interrupt preemption, and a
   --  subpriority field. See Table 9-87 ICC_BPR0 relationship between binary
   --  point value and group priority, subpriority fields on page 9-318.
   --
   type Binary_Point_Type is mod 2**3 with
     Size => 3;

   --
   --  Interrupt Controller Binary Point Register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type ICC_BPR_Type (As_Word : Boolean := True) is record
      case As_Word is
         when True =>
            Value : Interfaces.Unsigned_32 := 0;
         when False =>
            Binary_Point : Binary_Point_Type;
      end case;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First, Unchecked_Union;

   for ICC_BPR_Type use record
      Binary_Point at 0 range 0 .. 2;
   end record;

   --
   --  The ICC_BPRx register defines the point at which the priority value fields
   --  split into two parts, the group priority field and the subpriority field.
   --  The group priority field determines Group 0 interrupt preemption.
   --
   function Get_ICC_BPR
     (GIC_Interrupt_Group : GIC_Interrupt_Group_Type) return ICC_BPR_Type with
     Inline_Always;

   procedure Set_ICC_BPR
     (GIC_Interrupt_Group : GIC_Interrupt_Group_Type;
      ICC_BPR_Value       : ICC_BPR_Type) with
     Inline_Always;

   --
   --  Interrupt Controller Deactivate Interrupt
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type ICC_DIR_Type is record
      INTID : INTID_Type := INTID_Type'First;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First;

   for ICC_DIR_Type use record
      INTID at 0 range 0 .. 9;
   end record;

   function Get_ICC_DIR return ICC_DIR_Type with
     Inline_Always;

   procedure Set_ICC_DIR (ICC_DIR_Value : ICC_DIR_Type) with
     Inline_Always;

   --
   --  Interrupt Controller Interrupt Priority Mask Register
   --
   --  The ICC_PMR register provides an interrupt priority filter.
   --  Only interrupts with higher priority than the value in this
   --  register are signaled to the core. Lower values have higher
   --  priority.
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type ICC_PMR_Type is record
      Priority : GIC_Interrupt_Priority_Type;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First;

   for ICC_PMR_Type use record
      Priority at 0 range 3 .. 7;
   end record;

   function Get_ICC_PMR return ICC_PMR_Type with
     Inline_Always;

   procedure Set_ICC_PMR (ICC_PMR_Value : ICC_PMR_Type) with
     Inline_Always;

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
      --  NOTE: We don't need to declare this register with Volatile_Full_Access,
      --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
      --
      Priority : Interfaces.Unsigned_8;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First;

   for ICC_RPR_Type use record
      Priority at 0 range 0 .. 7;
   end record;

   function Get_ICC_RPR return ICC_RPR_Type with
     Inline_Always;

   procedure Set_ICC_RPR (ICC_RPR_Value : ICC_RPR_Type) with
     Inline_Always;

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

   ARM_Cortex_R52_PRIbits : constant PRIbits_Type := 2#100#; --  5 - 1

   --  Number of physical interrupt identifier bits supported
   type CTLR_IDbits_Type is mod 2**3 with
     Size => 3;

   ARM_Cortex_R52_ICC_CTLR_IDbits : constant CTLR_IDbits_Type := 2#000#; --  16

   --
   --  Interrupt Controller Control Register (EL1)
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type ICC_CTLR_Type is record
      CBPR    : CBPR_Type := Use_ICC_BPR0_For_Interrupt_Preemption_Disabled;
      EOImode : EOImode_Type := ICC_EOIRx_Write_Deactives_Interrupt_Disabled;
      PRIbits : PRIbits_Type     := PRIbits_Type'First;
      IDbits  : CTLR_IDbits_Type := CTLR_IDbits_Type'First;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First;

   for ICC_CTLR_Type use record
      CBPR    at 0 range  0 ..  0;
      EOImode at 0 range  1 ..  1;
      PRIbits at 0 range  8 .. 10;
      IDbits  at 0 range 11 .. 13;
   end record;

   function Get_ICC_CTLR return ICC_CTLR_Type with
     Inline_Always;

   procedure Set_ICC_CTLR (ICC_CTLR_Value : ICC_CTLR_Type) with
     Inline_Always;

   type GIC_CPU_Interface_System_Registers_Enable_Type is
     (GIC_CPU_Interface_System_Registers_Disabled,
      GIC_CPU_Interface_System_Registers_Enabled);

   for GIC_CPU_Interface_System_Registers_Enable_Type use
     (GIC_CPU_Interface_System_Registers_Disabled => 2#0#,
      GIC_CPU_Interface_System_Registers_Enabled  => 2#1#);

   --
   --  Interrupt Controller System Register Enable Register (EL1)
   --
   --  This indicates that system registers are used to access the GIC CPU interface.
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type ICC_SRE_Type is record
      SRE : GIC_CPU_Interface_System_Registers_Enable_Type :=
        GIC_CPU_Interface_System_Registers_Disabled;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First;

   for ICC_SRE_Type use record
      SRE at 0 range 0 .. 0;
   end record;

   function Get_ICC_SRE return ICC_SRE_Type with
     Inline_Always;

   procedure Set_ICC_SRE (ICC_SRE_Value : ICC_SRE_Type) with
     Inline_Always;

   type Interrupt_Group_Enable_Type is
     (Interrupt_Group_Disabled, Interrupt_Group_Enabled) with
     Size => 1;

   for Interrupt_Group_Enable_Type use
     (Interrupt_Group_Disabled => 2#0#, Interrupt_Group_Enabled => 2#1#);

   --
   --  Interrupt Controller Interrupt Group Enable Register for software
   --  generated interrupts (SGIs: 0 .. 15) and private peripheral interrupts
   --  (PPIs: 16 .. 31).
   --  Group 0 interrupts are signaled with FIQ and Group 1 interrupts are
   --  signaled with IRQ.
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type ICC_IGRPEN_Type (As_Word : Boolean := True) is record
      case As_Word is
         when True =>
            Value : Interfaces.Unsigned_32 := 0;
         when False =>
            Enable : Interrupt_Group_Enable_Type := Interrupt_Group_Disabled;
      end case;
   end record with
     Size => 32, Bit_Order => System.Low_Order_First, Unchecked_Union;

   for ICC_IGRPEN_Type use record
      Enable at 0 range 0 .. 0;
   end record;

   function Get_ICC_IGRPEN
     (GIC_Interrupt_Group : GIC_Interrupt_Group_Type)
      return ICC_IGRPEN_Type with
     Inline_Always;

   procedure Set_ICC_IGRPEN
     (GIC_Interrupt_Group : GIC_Interrupt_Group_Type;
      ICC_IGRPEN_Value    : ICC_IGRPEN_Type) with
     Inline_Always;

   --
   --  Set of cores for which SGI interrupts are generated. Each bit corresponds
   --  to the core within a cluster with an Affinity 0 value equal to the bit
   --  number.
   --
   type ICC_SGIR_Target_List_Type is mod 2**5 with
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
   --  Interrupt Controller Software Generated Interrupt Group Register.
   --  The ICC_SGIxR register is used to request Group x SGIs according to
   --  the GICR_IGROUPR configuration.
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type ICC_SGIR_Type (As_Two_Words : Boolean := False) is record
      case As_Two_Words is
         when True =>
            Lower_Word : Interfaces.Unsigned_32;
            Upper_Word : Interfaces.Unsigned_32;
         when False =>
            Target_List : ICC_SGIR_Target_List_Type   :=
              ICC_SGIR_Target_List_Type'First;
            Aff1        : GICD_IROUTER_Affinity_Type  :=
              GICD_IROUTER_Affinity_Type'First;
            INTID       : SGI_INTID_Type;
            Aff2        : GICD_IROUTER_Affinity_Type  :=
              GICD_IROUTER_Affinity_Type'First;
            IRM         : Interrupt_Routing_Mode_Type :=
              Interrupts_Routed_To_Selected_Cores;
            Aff3        : GICD_IROUTER_Affinity_Type  :=
              GICD_IROUTER_Affinity_Type'First;
      end case;
   end record with
     Size => 64, Bit_Order => System.Low_Order_First, Unchecked_Union;

   for ICC_SGIR_Type use record
      Target_List at 0 range  0 ..  4;
      Aff1        at 0 range 16 .. 23;
      INTID       at 0 range 24 .. 27;
      Aff2        at 0 range 32 .. 39;
      IRM         at 0 range 40 .. 40;
      Aff3        at 0 range 48 .. 55;
      Lower_Word  at 0 range  0 .. 31;
      Upper_Word  at 4 range  0 .. 31;
   end record;

   procedure Set_ICC_SGIR
     (GIC_Interrupt_Group : GIC_Interrupt_Group_Type;
      ICC_SGIR_Value      : ICC_SGIR_Type) with
     Inline_Always;

   --
   --  Memory-mapped banked interface to the GIC CPU interface for each CPU core
   --
   type GICC_Type is limited record
      GICC_CTLR  : ICC_CTLR_Type with
        Volatile_Full_Access;
      GICC_PMR   : ICC_PMR_Type with
        Volatile_Full_Access;
      GICC_BPR   : ICC_BPR_Type with
        Volatile_Full_Access;
      GICC_IAR   : ICC_IAR_Type with
        Volatile_Full_Access;
      GICC_EOIR  : ICC_EOIR_Type with
        Volatile_Full_Access;
      GICC_RPR   : ICC_RPR_Type with
        Volatile_Full_Access;
      GICC_HPPIR : ICC_HPPIR_Type with
        Volatile_Full_Access;
      GICC_DIR   : ICC_DIR_Type with
        Volatile_Full_Access;
   end record with
     Volatile;

   for GICC_Type use record
      GICC_CTLR  at 16#0000# range 0 .. 31;
      GICC_PMR   at 16#0004# range 0 .. 31;
      GICC_BPR   at 16#0008# range 0 .. 31;
      GICC_IAR   at 16#000c# range 0 .. 31;
      GICC_EOIR  at 16#0010# range 0 .. 31;
      GICC_RPR   at 16#0014# range 0 .. 31;
      GICC_HPPIR at 16#0018# range 0 .. 31;
      GICC_DIR   at 16#1000# range 0 .. 31;
   end record;

   --
   --  NOTE: All CPU cores use the same (banked) base address for the GICC
   --
   GICC_Base_Address : constant System.Address :=
     System'To_Address (16#8000_0000# + 16#2C00_0000#);

   GICC : aliased GICC_Type with
     Import, Address => GICC_Base_Address;

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
     Alignment => HiRTOS.Memory_Protection.Memory_Range_Alignment;

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
   end record with
     Alignment => HiRTOS.Memory_Protection.Memory_Range_Alignment,
     Warnings  => Off;

   Interrupt_Controller_Obj : Interrupt_Controller_Type;

   function Per_Cpu_Initialized return Boolean is
     ((HiRTOS_Cpu_Multi_Core_Interface.Atomic_Load (Interrupt_Controller_Obj.Per_Cpu_Initialized_Flags) and
       Bit_Mask (Bit_Index_Type (Get_Cpu_Id))) /= 0);

end HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
