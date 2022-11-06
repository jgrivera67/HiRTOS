--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
--

--
--  @summary RTOS to target platform interface - Interrupt controller driver
--  for ARMv8-R MPU
--

package HiRTOS_Cpu_Arch_Interface.Interrupt_Controller
   with SPARK_Mode => On
is

   procedure Initialize;

private

   type CBAR_RES0_Type is mod 2 ** 21
      with Size => 21;

   type CBAR_PERIPHBASE_Type is mod 2 ** 11
      with Size => 11;

   --
   --  Configuration Base Address Register
   --  (This register holds the physical base address of the memory-mapped GIC
   --   Distributor registers.)
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  aIMP_CBARs it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type IMP_CBAR_Type (As_Word : Boolean := False) is record
      case As_Word is
         when True =>
            Value : Interfaces.Unsigned_32 := 0;
         when False =>
            RES0 : CBAR_RES0_Type;
            --  Upper 11 bits of base physical address of GIC registers
            PERIPHBASE : CBAR_PERIPHBASE_Type;
      end case;
   end record
     with Size => 32,
          Bit_Order => System.Low_Order_First,
          Unchecked_Union;

   for IMP_CBAR_Type use record
      RES0 at 0 range 0 .. 20;
      PERIPHBASE at 0 range 21 .. 31;
      Value at 0 range 0 .. 31;
   end record;

   function Get_IMP_CBAR return IMP_CBAR_Type;

   ----------------------------------------------------------------------------
   --  GIC distributor registers
   ----------------------------------------------------------------------------

   type Group_Interrupts_Enable_Type is (Group_Interrupts_Disabled,
                                         Group_Interrupts_Enabled)
      with Size => 1;

   for Group_Interrupts_Enable_Type use
      (Group_Interrupts_Disabled => 2#0#,
       Group_Interrupts_Enabled => 2#1#);

   type Affinity_Routing_Enable_Type is (Affinity_Routing_Disabled,
                                         Affinity_Routing_Enabled)
      with Size => 1;

   for Affinity_Routing_Enable_Type use
      (Affinity_Routing_Disabled => 2#0#,
       Affinity_Routing_Enabled => 2#1#);

   type Register_Write_Pending_Type is (Register_Write_Not_Pending,
                                        Register_Write_Pending)
      with Size => 1;

   for Register_Write_Pending_Type use
      (Register_Write_Not_Pending => 2#0#,
       Register_Write_Pending => 2#1#);

   type GICD_CTLR_Type is record
      EnableGrp0 : Group_Interrupts_Enable_Type := Group_Interrupts_Disabled;
      EnableGrp1 : Group_Interrupts_Enable_Type := Group_Interrupts_Disabled;
      ARE : Affinity_Routing_Enable_Type := Affinity_Routing_Disabled;
      RWP : Register_Write_Pending_Type := Register_Write_Not_Pending;
   end record
   with Volatile_Full_Access,
        Size => 32,
        Bit_Order => System.Low_Order_First;

   for GICD_CTLR_Type use record
      EnableGrp0 at 16#0# range 0 .. 0;
      EnableGrp1 at 16#0# range 1 .. 1;
      ARE        at 16#0# range 4 .. 4;
      RWP        at 16#0# range 31 .. 31;
   end record;

   --
   --  Number of SPI INTIDs that the GIC Distributor supports. The valid values
   --  for this field range from 1 to 30, depending on the number of SPIs
   --  configured for Cortex-R52.
   --  Valid interrupt INTID range is 0 to 32*(ITLinesNumber + 1) - 1.
   --
   type ITLinesNumber_Type is mod 2 ** 5
      with Size => 5;

   --
   --  Number of INTID bits that the GIC Distributor supports, minus one.
   --  For the Cortex-R52 this value is 0b01001 (INTID is 10 bits).
   --
   type TYPER_IDBits_Type is mod 2 ** 5
      with Size => 5;

   type GICD_TYPER_Type is record
      ITLinesNumber : ITLinesNumber_Type := ITLinesNumber_Type'First;
      IDBits : TYPER_IDBits_Type := TYPER_IDBits_Type'First;
   end record
   with Volatile_Full_Access,
        Size => 32,
        Bit_Order => System.Low_Order_First;

   for GICD_TYPER_Type use record
      ITLinesNumber at 16#0# range 0 .. 4;
      IDBits        at 16#0# range 19 .. 23;
   end record;

   type GICD_IIDR_Type is new Interfaces.Unsigned_32;

   --  Shared Peripheral Interrupt (SPI) groups
   type SPI_Group_Type is (SPI_Group0, SPI_Group1)
      with Size => 1;

   for SPI_Group_Type use
      (SPI_Group0 => 2#0#,
       SPI_Group1 => 2#1#);

   type GICD_IGROUPR_Type is array (0 .. 31) of SPI_Group_Type
      with Volatile_Full_Access,
           Size => 32,
           Component_Size => 1;

   --
   --  The GICD_IGROUPR1-30 registers control whether the corresponding SPI is
   --  in Group 0 or Group 1. Each register contains the group bits for 32 SPIs.
   --  GICD_IGROUPR (1)(0) corresponds to INTID32 and GICD_IGROUPR(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_IGROUPR_Array_Type is array (1 .. 30) of GICD_IGROUPR_Type;

   type SPI_Bit_Type is mod 2 ** 1
      with Size => 1;

   --  Interrupt set-enable register for 32 interrupts (SPIs)
   type GICD_ISENABLER_Type is array (0 .. 31) of SPI_Bit_Type
      with Volatile_Full_Access,
           Size => 32,
           Component_Size => 1;

   --
   --  The GICD_ISENABLER1-30 registers enable forwarding of the corresponding
   --  SPI from the Distributor to the CPU interfaces. Each register contains
   --  the set-enable bits for 32 SPIs.
   --  GICD_ISENABLER (1)(0) corresponds to INTID32 and GICD_ISENABLER(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_ISENABLER_Array_Type is array (1 .. 30) of GICD_ISENABLER_Type;

   --  Interrupt clear-enable register for 32 interrupts (SPIs)
   type GICD_ICENABLER_Type is array (0 .. 31) of SPI_Bit_Type
      with Volatile_Full_Access,
           Size => 32,
           Component_Size => 1;

   --
   --  The GICD_ICENABLER1-30 registers disable forwarding of the corresponding
   --  SPI to the CPU interfaces. Each register contains the clear-enable bits
   --  for 32 SPIs.
   --  GICD_ICENABLER (1)(0) corresponds to INTID32 and GICD_ICENABLER(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_ICENABLER_Array_Type is array (1 .. 30) of GICD_ICENABLER_Type;

   --  Interrupt set-pending register for 32 interrupts (SPIs)
   type GICD_ISPENDR_Type is array (0 .. 31) of SPI_Bit_Type
      with Volatile_Full_Access,
           Size => 32,
           Component_Size => 1;

   --
   --  The GICD_ISPENDR1-30 registers set the pending bit for the corresponding
   --  SPI. Each register contains the set-pending bits for 32 SPIs.
   --  GICD_ISPENDR (1)(0) corresponds to INTID32 and GICD_ISPENDR(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_ISPENDR_Array_Type is array (1 .. 30) of GICD_ISPENDR_Type;

   --  Interrupt clear-pending register for 32 interrupts (SPIs)
   type GICD_ICPENDR_Type is array (0 .. 31) of SPI_Bit_Type
      with Volatile_Full_Access,
           Size => 32,
           Component_Size => 1;

   --
   --  The GICD_ICPENDR1-30 registers clear the pending bit for the corresponding
   --  SPI. Each register contains the clear-pending bits for 32 SPIs.
   --  GICD_ICPENDR (1)(0) corresponds to INTID32 and GICD_ICPENDR(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_ICPENDR_Array_Type is array (1 .. 30) of GICD_ICPENDR_Type;

--  Interrupt set-active register for 32 interrupts (SPIs)
   type GICD_ISACTIVER_Type is array (0 .. 31) of SPI_Bit_Type
      with Volatile_Full_Access,
           Size => 32,
           Component_Size => 1;

   --
   --  The GICD_ISACTIVER1-30 registers set the active bit for the corresponding
   --  SPI. Each register contains the set-active bits for 32 SPIs.
   --  GICD_ISACTIVER (1)(0) corresponds to INTID32 and GICD_ISACTIVER(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_ISACTIVER_Array_Type is array (1 .. 30) of GICD_ISACTIVER_Type;

   --  Interrupt clear-active register for 32 interrupts (SPIs)
   type GICD_ICACTIVER_Type is array (0 .. 31) of SPI_Bit_Type
      with Volatile_Full_Access,
           Size => 32,
           Component_Size => 1;

   --
   --  The GICD_ICACTIVER1-30 registers clear the active bit for the corresponding
   --  SPI. Each register contains the clear-active bits for 32 SPIs.
   --  GICD_ICACTIVER (1)(0) corresponds to INTID32 and GICD_ICACTIVER(30)(31)
   --  corresponds to INTID991.
   --
   type GICD_ICACTIVER_Array_Type is array (1 .. 30) of GICD_ICACTIVER_Type;

   type Interrupt_Priority_Type is mod 2 ** 5
      with Size => 5;

   type GICD_IPRIORITYR_Slot_Type is record
      Interrupt_Priority : Interrupt_Priority_Type := Interrupt_Priority_Type'First;
   end record
      with Size => 8,
           Bit_Order => System.Low_Order_First;

   for GICD_IPRIORITYR_Slot_Type use record
      Interrupt_Priority at 16#0# range 3 .. 7;
   end record;

   type GICD_IPRIORITYR_Slot_Array_Type is array (0 .. 3) of GICD_IPRIORITYR_Slot_Type
      with Component_Size => 8,
           Size => 32;

   type GICD_IPRIORITYR_Type (As_Word : Boolean := False) is record
      case As_Word is
         when True =>
            Word : Interfaces.Unsigned_32 with Volatile_Full_Access;
         when False =>
            Slot_Array : GICD_IPRIORITYR_Slot_Array_Type;
      end case;
   end record
      with Size => 32,
           Unchecked_Union;

   --
   --  The GICD_IPRIORITYR8-247 registers provide a 5-bit priority field for each
   --  SPI supported by the GIC.
   --  The corresponding GICD_IPRIORITYRn number, n, is given by n = m DIV 4,
   --  where m=32 to 991.
   --  The address offset of the required GICD_IPRIORITYRn is (0x400 + (4×n)).
   --  The byte offset of the required Priority field in this register is m MOD 4.
   --  GICD_IPRIORITYR(8)[7:0] corresponds to INTID32 and GICD_IPRIORITYR(247)31:24]
   --  corresponds to INTID991.
   --
   type GICD_IPRIORITYR_Array_Type is array (8 .. 247) of GICD_IPRIORITYR_Type;

   type GICD_ICFGR_Interrupt_Trigger_Type is (Active_High_Level_Sensitive,
                                              Rising_Edge_Triggered)
      with Size => 1;

   for GICD_ICFGR_Interrupt_Trigger_Type use
      (Active_High_Level_Sensitive => 2#0#,
       Rising_Edge_Triggered => 2#1#);

   type GICD_ICFGR_Field_Type is record
      Interrupt_Trigger : GICD_ICFGR_Interrupt_Trigger_Type;
   end record
      with Size => 2,
           Bit_Order => System.Low_Order_First;

   for GICD_ICFGR_Field_Type use record
      Interrupt_Trigger at 0 range 1 .. 1;
   end record;

   type GICD_ICFGR_Type is array (0 .. 15) of GICD_ICFGR_Field_Type
      with Component_Size => 2,
           Size => 32,
           Volatile_Full_Access;

   --
   --  The GICD_ICFGR2-61 registers provide a 2-bit Int_config field for each
   --  interrupt supported by the GIC. This field determines whether the
   --  corresponding interrupt is rising edge-triggered or active-HIGH
   --  level-sensitive.
   --  GICD_ICFGR(2)[1:0] corresponds to INTID32 and GICD_ICFGR(61)[31:30] corresponds
   --  to INTID991.
   --
   type GICD_ICFGR_Array_Type is array (2 .. 61) of GICD_ICFGR_Type;

   type GICD_IROUTER_Affinity_Type is mod 2 ** 8
      with Size => 8;

   type GICD_IROUTER_Type (As_Two_Words : Boolean := False) is record
      case As_Two_Words is
         when True =>
            Lower_Word : Interfaces.Unsigned_32 with Volatile_Full_Access;
            Upper_Word : Interfaces.Unsigned_32 with Volatile_Full_Access;
         when False =>
            Aff0 : GICD_IROUTER_Affinity_Type := GICD_IROUTER_Affinity_Type'First;
            Aff1 : GICD_IROUTER_Affinity_Type := GICD_IROUTER_Affinity_Type'First;
            Aff2 : GICD_IROUTER_Affinity_Type := GICD_IROUTER_Affinity_Type'First;
            Aff3 : GICD_IROUTER_Affinity_Type := GICD_IROUTER_Affinity_Type'First;
      end case;
   end record
      with Size => 64,
           Unchecked_Union,
           Bit_Order => System.Low_Order_First;

   for GICD_IROUTER_Type use record
      Aff0 at 16#0# range 0 .. 7;
      Aff1 at 16#0# range 8 .. 15;
      Aff2 at 16#0# range 16 .. 23;
      Aff3 at 16#0# range 32 .. 39;
      Lower_Word at 16#0# range 0 .. 31;
      Upper_Word at 16#4# range 0 .. 31;
   end record;

   --
   --  The GICD_IROUTER32-991 registers provide routing information for the SPI
   --  with GICD_IROUTERn corresponding to INTIDn.
   --  GICD_IROUTER(32) corresponds to INTID32 and GICD_IROUTER(991) corresponds
   --  to INTID991.
   --
   type GICD_IROUTER_Array_Type is array (32 .. 991) of GICD_IROUTER_Type;

   type GICD_PIDR_Type is new Interfaces.Unsigned_32
      with Volatile_Full_Access;

   --
   --  The GICD_PIDR0-7 registers provide the peripheral identification information.
   --
   type GICD_PIDR_Array_Type is array (0 .. 7) of GICD_PIDR_Type;

   Arm_Cortex_R52_GICD_PIDR_Array : constant GICD_PIDR_Array_Type :=
      [16#00000092#,
       16#000000B4#,
       16#0000003B#,
       16#00000000#,
       16#00000044#,
       16#00000000#,
       16#00000000#,
       16#00000000#];

   --
   --  Generic Interrupt Controller Distributor (GICD)
   --
   type GICD_Type is limited record
      GICD_CTLR : GICD_CTLR_Type;
      GICD_TYPER : GICD_TYPER_Type;
      GICD_IIDR : GICD_IIDR_Type;
      GICD_IGROUPR_Array : GICD_IGROUPR_Array_Type;
      GICD_ISENABLER_Array : GICD_ISENABLER_Array_Type;
      GICD_ICENABLER_Array : GICD_ICENABLER_Array_Type;
      GICD_ISPENDR_Array : GICD_ISPENDR_Array_Type;
      GICD_ICPENDR_Array : GICD_ICPENDR_Array_Type;
      GICD_ISACTIVER_Array : GICD_ISACTIVER_Array_Type;
      GICD_ICACTIVER_Array : GICD_ICACTIVER_Array_Type;
      GICD_IPRIORITYR_Array : GICD_IPRIORITYR_Array_Type;
      GICD_ICFGR_Array : GICD_ICFGR_Array_Type;
      GICD_IROUTER_Array : GICD_IROUTER_Array_Type;
      GICD_PIDR_Array : GICD_PIDR_Array_Type;
   end record with Volatile;

   for GICD_Type use record
      GICD_CTLR at 16#0# range 0 .. 31;
      GICD_TYPER at 16#4# range 0 .. 31;
      GICD_IIDR at 16#8# range 0 .. 31;
      GICD_IGROUPR_Array at 16#0084# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ISENABLER_Array at 16#0104# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ICENABLER_Array at 16#0184# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ISPENDR_Array at 16#0204# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ICPENDR_Array at 16#0284# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ISACTIVER_Array at 16#0304# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_ICACTIVER_Array at 16#0384# range 0 .. ((30 - 1 + 1) * 32) - 1;
      GICD_IPRIORITYR_Array at 16#0420# range 0 .. ((247 - 8 + 1) * 32) - 1;
      GICD_ICFGR_Array at 16#0C08# range 0 .. ((61 - 2 + 1) * 32) - 1;
      GICD_IROUTER_Array at 16#6100# range 0 .. ((991 - 32 + 1) * 64) - 1;
      GICD_PIDR_Array at 16#FFE0# range 0 .. ((7 - 0 + 1) * 32) - 1;
   end record;

   ----------------------------------------------------------------------------
   --  GIC CPU intterface registers
   ----------------------------------------------------------------------------

   type INTID_Type is mod 2 ** 10
      with Size => 10;

   --
   --  Interrupt Controller Interrupt Acknowledge Register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type ICC_IAR_Type is record
      INTID : INTID_Type := INTID_Type'First;
   end record
      with Size => 32,
           Bit_Order => System.Low_Order_First;

   for ICC_IAR_Type use record
      INTID at 0 range 0 .. 9;
   end record;

   --
   --  The ICC_IAR0 register contains the INTID of the signaled Group 0 interrupt.
   --  When the core reads this INTID, it acts as an acknowledge for the interrupt.
   --
   function Get_ICC_IAR0 return ICC_IAR_Type
      with Inline_Always;

   procedure Set_ICC_IAR0 (ICC_IAR_Value : ICC_IAR_Type)
      with Inline_Always;

   --
   --  The ICC_IAR1 register contains the INTID of the signaled Group 1 interrupt.
   --  When the core reads this INTID, it acts as an acknowledge for the interrupt.
   --
   function Get_ICC_IAR1 return ICC_IAR_Type
      with Inline_Always;

   procedure Set_ICC_IAR1 (ICC_IAR_Value : ICC_IAR_Type)
      with Inline_Always;

   --
   --  Interrupt Controller End Of Interrupt Register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type ICC_EOIR_Type is record
      INTID : INTID_Type := INTID_Type'First;
   end record
      with Size => 32,
           Bit_Order => System.Low_Order_First;

   for ICC_EOIR_Type use record
      INTID at 0 range 0 .. 9;
   end record;

   --
   --  A core can write to the ICC_EOIR0 register to inform the CPU interface
   --  that it has completed the processing of the specified Group 0 interrupt.
   --  In normal operation, the highest priority set group 0 priority bit is
   --  cleared and additionally the interrupt is deactivated if ICC_CTLR.EOImode == 0.
   --
   function Get_ICC_EOIR0 return ICC_EOIR_Type
      with Inline_Always;

   procedure Set_ICC_EOIR0 (ICC_EOIR_Value : ICC_EOIR_Type)
      with Inline_Always;

   --
   --  A core can write to the ICC_EOIR1 register to inform the CPU interface
   --  that it has completed the processing of the specified Group 1 interrupt.
   --  In normal operation, the highest priority set group 1 priority bit is
   --  cleared and additionally the interrupt is deactivated if ICC_CTLR.EOImode == 0.
   --
   function Get_ICC_EOIR1 return ICC_EOIR_Type
      with Inline_Always;

   procedure Set_ICC_EOIR1 (ICC_EOIR_Value : ICC_EOIR_Type)
      with Inline_Always;

   --
   --  Interrupt Controller Highest Priority Pending Interrupt Register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type ICC_HPPIR_Type is record
      INTID : INTID_Type := INTID_Type'First;
   end record
      with Size => 32,
           Bit_Order => System.Low_Order_First;

   for ICC_HPPIR_Type use record
      INTID at 0 range 0 .. 9;
   end record;

   --
   --  The ICC_HPPIR0 register indicates the highest priority pending Group 0
   --  interrupt on the CPU interface without changing the state of the GIC.
   --
   function Get_ICC_HPPIR0 return ICC_HPPIR_Type
      with Inline_Always;

   procedure Set_ICC_HPPIR0 (ICC_HPPIR_Value : ICC_HPPIR_Type)
      with Inline_Always;

   --
   --  The ICC_HPPIR1 register indicates the highest priority pending Group 1
   --  interrupt on the CPU interface without changing the state of the GIC.
   --
   function Get_ICC_HPPIR1 return ICC_HPPIR_Type
      with Inline_Always;

   procedure Set_ICC_HPPIR1 (ICC_HPPIR_Value : ICC_HPPIR_Type)
      with Inline_Always;

   --
   --  This value controls how the 5-bit interrupt priority field is split into
   --  a group priority field, that determines interrupt preemption, and a
   --  subpriority field. See Table 9-87 ICC_BPR0 relationship between binary
   --  point value and group priority, subpriority fields on page 9-318.
   --
   type Binary_Point_Type is mod 2 ** 3
      with Size => 3;

   --
   --  Interrupt Controller Binary Point Register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type ICC_BPR_Type is record
      Binary_Point : Binary_Point_Type;
   end record
      with Size => 32,
           Bit_Order => System.Low_Order_First;

   for ICC_BPR_Type use record
      Binary_Point at 0 range 0 .. 2;
   end record;

   --
   --  The ICC_BPR0 register defines the point at which the priority value fields
   --  split into two parts, the group priority field and the subpriority field.
   --  The group priority field determines Group 0 interrupt preemption.
   --
   function Get_ICC_BPR0 return ICC_BPR_Type
      with Inline_Always;

   procedure Set_ICC_BPR0 (ICC_BPR_Value : ICC_BPR_Type)
      with Inline_Always;

   --
   --  The ICC_BPR1 register defines the point at which the priority value fields
   --  split into two parts, the group priority field and the subpriority field.
   --  The group priority field determines Group 1 interrupt preemption.
   --
   function Get_ICC_BPR1 return ICC_BPR_Type
      with Inline_Always;

   procedure Set_ICC_BPR1 (ICC_BPR_Value : ICC_BPR_Type)
      with Inline_Always;

   --
   --  Interrupt Controller Deactivate Interrupt
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type ICC_DIR_Type is record
      INTID : INTID_Type := INTID_Type'First;
   end record
      with Size => 32,
           Bit_Order => System.Low_Order_First;

   for ICC_DIR_Type use record
      INTID at 0 range 0 .. 9;
   end record;

   function Get_ICC_DIR return ICC_DIR_Type
      with Inline_Always;

   procedure Set_ICC_DIR (ICC_DIR_Value : ICC_DIR_Type)
      with Inline_Always;

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
      Priority : Interrupt_Priority_Type := Interrupt_Priority_Type'First;
   end record
      with Size => 32,
           Bit_Order => System.Low_Order_First;

   for ICC_PMR_Type use record
      Priority at 0 range 3 .. 7;
   end record;

   function Get_ICC_PMR return ICC_PMR_Type
      with Inline_Always;

   procedure Set_ICC_PMR (ICC_PMR_Value : ICC_PMR_Type)
      with Inline_Always;

   type CBPR_Type is (Use_ICC_BPR0_For_Interrupt_Preemption_Disabled,
                      Use_ICC_BPR0_For_Interrupt_Preemption_Enabled)
      with Size => 1;

   for CBPR_Type use
      (Use_ICC_BPR0_For_Interrupt_Preemption_Disabled => 2#0#,
       Use_ICC_BPR0_For_Interrupt_Preemption_Enabled => 2#1#);

   type EOImode_Type is (ICC_EOIRx_Write_Deactives_Interrupt_Disabled,
                         ICC_EOIRx_Write_Deactives_Interrupt_Enabled)
      with Size => 1;

   for EOImode_Type use
      (ICC_EOIRx_Write_Deactives_Interrupt_Disabled => 2#0#,
       ICC_EOIRx_Write_Deactives_Interrupt_Enabled => 2#1#);

   --  Number of priority bits implemented, minus one
   type PRIbits_Type is mod 2 ** 3
      with Size => 3;

   ARM_Cortex_R52_PRIbits : constant PRIbits_Type := 2#100#; --  5 - 1

   --  Number of physical interrupt identifier bits supported
   type CTLR_IDbits_Type is mod 2 ** 3
      with Size => 3;

   ARM_Cortex_R52_IDbits : constant CTLR_IDbits_Type := 2#000#; --  16

   --
   --  Interrupt Controller Control Register (EL1)
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type ICC_CTLR_Type is record
      CBPR : CBPR_Type := Use_ICC_BPR0_For_Interrupt_Preemption_Disabled;
      EOImode : EOImode_Type := ICC_EOIRx_Write_Deactives_Interrupt_Disabled;
      PRIbits : PRIbits_Type := PRIbits_Type'First;
      IDbits : CTLR_IDbits_Type := CTLR_IDbits_Type'First;
   end record
      with Size => 32,
           Bit_Order => System.Low_Order_First;

   for ICC_CTLR_Type use record
      CBPR at 0 range 0 .. 0;
      EOImode at 0 range 1 .. 1;
      PRIbits at 0 range 8 .. 10;
      IDbits at 0 range 11 .. 13;
   end record;

   function Get_ICC_CTLR return ICC_CTLR_Type
      with Inline_Always;

   procedure Set_ICC_CTLR (ICC_CTLR_Value : ICC_CTLR_Type)
      with Inline_Always;

   type Interrupt_Group_Enable_Type is (Interrupt_Group_Disabled,
                                        Interrupt_Group_Enabled)
      with Size => 1;

   for Interrupt_Group_Enable_Type use
      (Interrupt_Group_Disabled => 2#0#,
       Interrupt_Group_Enabled => 2#1#);

   --
   --  Interrupt Controller Interrupt Group Enable Register
   --
   --  NOTE: We don't need to declare this register with Volatile_Full_Access,
   --  as it is not memory-mapped. It is accessed via MRC/MCR instructions.
   --
   type ICC_IGRPEN_Type is record
      Enable : Interrupt_Group_Enable_Type := Interrupt_Group_Disabled;
   end record
      with Size => 32,
           Bit_Order => System.Low_Order_First;

   for ICC_IGRPEN_Type use record
      Enable at 0 range 0 .. 0;
   end record;

   function Get_ICC_IGRPEN0 return ICC_IGRPEN_Type
      with Inline_Always;

   procedure Set_ICC_IGRPEN0 (ICC_IGRPEN_Value : ICC_IGRPEN_Type)
      with Inline_Always;

   function Get_ICC_IGRPEN1 return ICC_IGRPEN_Type
      with Inline_Always;

   procedure Set_ICC_IGRPEN1 (ICC_IGRPEN_Value : ICC_IGRPEN_Type)
      with Inline_Always;

   --
   --  Set of cores for which SGI interrupts are generated. Each bit corresponds
   --  to the core within a cluster with an Affinity 0 value equal to the bit
   --  number.
   --
   type ICC_SGIR_Target_List_Type is mod 2 ** 5
      with Size => 5;

   type SGI_INTID_Type is mod 2 ** 4
      with Size => 4;

   type Interrupt_Routing_Mode_Type is
      (Interrupts_Routed_To_Selected_Cores, --  cores specified by Aff3.Aff2.Aff1.<target list>
       Interrupts_Routed_To_All_Cores_But_Self)
      with Size => 1;

   for Interrupt_Routing_Mode_Type use
      (Interrupts_Routed_To_Selected_Cores => 2#0#,
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
            Target_List : ICC_SGIR_Target_List_Type := ICC_SGIR_Target_List_Type'First;
            Aff1 : GICD_IROUTER_Affinity_Type := GICD_IROUTER_Affinity_Type'First;
            INTID : SGI_INTID_Type;
            Aff2 : GICD_IROUTER_Affinity_Type := GICD_IROUTER_Affinity_Type'First;
            IRM : Interrupt_Routing_Mode_Type := Interrupts_Routed_To_Selected_Cores;
            Aff3 : GICD_IROUTER_Affinity_Type := GICD_IROUTER_Affinity_Type'First;
      end case;
   end record
      with Size => 64,
           Bit_Order => System.Low_Order_First,
           Unchecked_Union;

   for ICC_SGIR_Type use record
      Target_List at 0 range 0 .. 4;
      Aff1 at 0 range 16 .. 23;
      INTID at 0 range 24 .. 27;
      Aff2 at 0 range 32 .. 39;
      IRM at 0 range 40 .. 40;
      Aff3 at 0 range 48 .. 55;
      Lower_Word at 0 range 0 .. 31;
      Upper_Word at 4 range 0 .. 31;
   end record;

   procedure Set_ICC_SGIR0 (ICC_SGIR_Value : ICC_SGIR_Type)
      with Inline_Always;

   procedure Set_ICC_SGIR1 (ICC_SGIR_Value : ICC_SGIR_Type)
      with Inline_Always;

end HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
