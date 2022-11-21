--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary RTOS to target platform interface - Interrupt controller driver
--

with HiRTOS.Interrupt_Handling;
with System.Machine_Code;
with System.Address_To_Access_Conversions;
with System.Storage_Elements;

package body HiRTOS_Cpu_Arch_Interface.Interrupt_Controller with SPARK_Mode => Off
is
   package Address_To_GICD_Pointer is new
      System.Address_To_Access_Conversions (Object => GICD_Type);

   ----------------------------------------------------------------------------
   --  Public Subprograms
   ----------------------------------------------------------------------------

   procedure Initialize is
      procedure Initialize_GIC_Distributor is
         use System.Storage_Elements;
         use type Interfaces.Unsigned_16;
         IMP_CBAR_Value : constant IMP_CBAR_Type := Get_IMP_CBAR;
         Old_Mmio_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
         Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
         GICD_Pointer : access GICD_Type;
         GICD_CTLR_Value : GICD_CTLR_Type;
         GICD_TYPER_Value : GICD_TYPER_Type;
         Max_Number_Interrupt_Sources : Interfaces.Unsigned_16;
      begin
         pragma Assert (IMP_CBAR_Value.RES0 = 0);

         --  Get address of GICD
         GICD_Pointer := Address_To_GICD_Pointer.To_Pointer (
                           To_Address (Integer_Address (IMP_CBAR_Value.Value)));

         HiRTOS.Memory_Protection.Begin_Mmio_Range_Write_Access (
            Address_To_GICD_Pointer.To_Address (Address_To_GICD_Pointer.Object_Pointer (GICD_Pointer)),
            GICD_Pointer.all'Size,
            Old_Mmio_Range);

         --  Disable interrupts from group0 and group1 before configuring the GIC:
         GICD_CTLR_Value := GICD_Pointer.GICD_CTLR;
         GICD_CTLR_Value.EnableGrp0 := Group_Interrupts_Disabled;
         GICD_CTLR_Value.EnableGrp1 := Group_Interrupts_Disabled;
         GICD_Pointer.GICD_CTLR := GICD_CTLR_Value;

         GICD_TYPER_Value := GICD_Pointer.GICD_TYPER;
         pragma Assert (GICD_TYPER_Value.IDBits = ARM_Cortex_R52_GICD_TYPER_IDbits);

         Max_Number_Interrupt_Sources :=
            (32 * Interfaces.Unsigned_16 (GICD_TYPER_Value.ITLinesNumber)) + 1;
         pragma Assert (Max_Number_Interrupt_Sources <=
            Interfaces.Unsigned_16 (External_Interrupt_Id_Type'Last - External_Interrupt_Id_Type'First + 1));

         --
         --  Disable all external interrupts (SPIs):
         --
         for I in GICD_ICENABLER_Array_Type'Range loop
            GICD_Pointer.GICD_ICENABLER_Array (I) := [others => 2#1#];
         end loop;

         --  Enable reception of interrupts from group0/group1 in the GIC:
         GICD_CTLR_Value := GICD_Pointer.GICD_CTLR;
         GICD_CTLR_Value.EnableGrp0 := Group_Interrupts_Enabled; --  FIQ
         GICD_CTLR_Value.EnableGrp1 := Group_Interrupts_Enabled; --  IRQ
         GICD_Pointer.GICD_CTLR := GICD_CTLR_Value;
         HiRTOS.Memory_Protection.End_Mmio_Range_Access (Old_Mmio_Range);

         HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access (
            Interrupt_Controller_Obj'Address,
            Interrupt_Controller_Obj'Size,
            Old_Data_Range);

         Interrupt_Controller_Obj.GICD_Pointer := GICD_Pointer;
         Interrupt_Controller_Obj.Max_Number_Interrupt_Sources :=
            Max_Number_Interrupt_Sources;
         Interrupt_Controller_Obj.Initialized := True;
         HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
         HiRTOS_Cpu_Arch_Interface.Send_Event;
      end Initialize_GIC_Distributor;

      procedure Initialize_GIC_Redistributor (Cpu_Id : Cpu_Core_Id_Type) is
         GICR : GICR_Type renames Interrupt_Controller_Obj.GICD_Pointer.GICR_Array (Cpu_Id);
         Old_Mmio_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
         GICR_TYPER_Value : GICR_TYPER_Type;
      begin
         HiRTOS.Memory_Protection.Begin_Mmio_Range_Write_Access (
            GICR'Address, GICR'Size, Old_Mmio_Range);

         GICR_TYPER_Value := GICR.GICR_Control_Page.GICR_TYPER;
         pragma Assert (GICR_TYPER_Value.Processor_Number =
                        GICR_TYPER_Processor_Number_Type (Cpu_Id));

         --
         --  Disable all internal interrupts (SGIs ands PPIs):
         --
         GICR.GICR_SGI_And_PPI_Page.GICR_ICENABLER0 := [ others => 2#1# ];

         HiRTOS.Memory_Protection.End_Mmio_Range_Access (Old_Mmio_Range);
      end Initialize_GIC_Redistributor;

      procedure Initialize_GIC_Cpu_Interface is
         ICC_CTLR_Value : ICC_CTLR_Type;
         ICC_BPR_Value : ICC_BPR_Type;
         ICC_IGRPEN_Value : ICC_IGRPEN_Type;
         ICC_PMR_Value : ICC_PMR_Type;
      begin
         --  Enable CPU interface:
         ICC_CTLR_Value := Get_ICC_CTLR;
         ICC_CTLR_Value.CBPR := Use_ICC_BPR0_For_Interrupt_Preemption_Enabled;
         Set_ICC_CTLR (ICC_CTLR_Value);

         --
         --  Set binary point to 7 for groups 0 and 1, so that no priority
         --  grouping is used:
         --
         ICC_BPR_Value.Binary_Point := Binary_Point_Type'Last;
         Set_ICC_BPR (Cpu_Interrupt_Fiq, ICC_BPR_Value);
         Set_ICC_BPR (Cpu_Interrupt_Irq, ICC_BPR_Value);

         --
         --  Enable group0 & group1 interrupts:
         --
         --  NOTE: Interrupt group 1 will be used for regular interrupts
         --  as they are routed to the IRQ interrupt line of the CPU core.
         --  Interrupt group 0 will be used for high-priority non-maskable
         --  interrupts, as they are routed to the FIQ interrupt line of
         --  the CPU core.
         ICC_IGRPEN_Value.Enable := Interrupt_Group_Enabled;
         Set_ICC_IGRPEN (Cpu_Interrupt_Fiq, ICC_IGRPEN_Value); --  group0 -> FIQ
         Set_ICC_IGRPEN (Cpu_Interrupt_Irq, ICC_IGRPEN_Value); --  group1 -> IRQ

         --
         --  Set current interrupt priority mask to accept all interrupt priorities
         --  supported:

         --  NOTE: Interrupt_Priority_Type'Last is the lowest priority supported.
         --  Interrupt_Priority_Type'First is the highest priority.
         --  The GIC only signals pending interrupts with a higher priority (lower
         --  priority value) than the value set in ICC_PMR.
         --
         ICC_PMR_Value.Priority := GIC_Interrupt_Priority_Type'Last;
         Set_ICC_PMR (ICC_PMR_Value);
      end Initialize_GIC_Cpu_Interface;

      use type Valid_Cpu_Core_Id_Type;
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      Old_Cpu_Interrupting_State : Cpu_Register_Type;

   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;
      Old_Cpu_Interrupting_State := Disable_Cpu_Interrupting;

      if Cpu_Id = Valid_Cpu_Core_Id_Type'First then
         pragma Assert (not Interrupt_Controller_Obj.Initialized);
         Initialize_GIC_Distributor;
      else
         while not Interrupt_Controller_Obj.Initialized loop
            HiRTOS_Cpu_Arch_Interface.Wait_For_Event;
         end loop;
      end if;

      Initialize_GIC_Redistributor (Get_Cpu_Id);
      Initialize_GIC_Cpu_Interface;

      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Initialize;

   procedure Configure_Internal_Interrupt (
      Internal_Interrupt_Id : Internal_Interrupt_Id_Type;
      Priority : Interrupt_Priority_Type;
      Cpu_Interrupt_Line : Cpu_Interrupt_Line_Type;
      Trigger_Mode : Interrupt_Trigger_Mode_Type;
      Interrupt_Handler_Entry_Point : Interrupt_Handler_Entry_Point_Type;
      Interrupt_Handler_Arg : System.Address := System.Null_Address)
   is
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      Interrupt_Handler : Interrupt_Handler_Type renames
         Interrupt_Controller_Obj.Internal_Interrupt_Handlers (Cpu_Id,
                                                               Internal_Interrupt_Id);
      GICR : GICR_Type renames Interrupt_Controller_Obj.GICD_Pointer.GICR_Array (Cpu_Id);
      Old_Mmio_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
      ICFGR_Register_Index : constant Integer :=
         Integer (Internal_Interrupt_Id) / GIC_ICFGR_Field_Array_Type'Length;
      ICFGR_Field_Index : constant Integer :=
         Integer (Internal_Interrupt_Id) mod GIC_ICFGR_Field_Array_Type'Length;
      IPRIORITY_Register_Index : constant Integer :=
         Integer (Internal_Interrupt_Id) / GIC_IPRIORITYR_Slot_Array_Type'Length;
      IPRIORITY_Field_Index : constant Integer :=
         Integer (Internal_Interrupt_Id) mod GIC_IPRIORITYR_Slot_Array_Type'Length;
      GIC_ICFGR_Value : GIC_ICFGR_Type;
      GIC_IPRIORITYR_Value : GIC_IPRIORITYR_Type;
      GIC_IGROUPR_Value : GIC_IGROUPR_Type;
   begin
      pragma Assert (Interrupt_Handler.Interrupt_Handler_Entry_Point = null);
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access (
         Interrupt_Handler'Address,
         Interrupt_Handler'Size,
         Old_Data_Range);
      Interrupt_Handler.Cpu_Id := Cpu_Id;
      Interrupt_Handler.Interrupt_Handler_Entry_Point := Interrupt_Handler_Entry_Point;
      Interrupt_Handler.Interrupt_Handler_Arg := Interrupt_Handler_Arg;
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);

      HiRTOS.Memory_Protection.Begin_Mmio_Range_Write_Access (
         GICR'Address, GICR'Size, Old_Mmio_Range);

      --
      --  Configure interrupt trigger mode:
      --
      GIC_ICFGR_Value := GICR.GICR_SGI_And_PPI_Page.GICR_ICFGR_Array (ICFGR_Register_Index);
      GIC_ICFGR_Value.Interrupt_Config_Array (ICFGR_Field_Index).Interrupt_Trigger :=
         GIC_ICFGR_Interrupt_Trigger_Type (Trigger_Mode);
      GICR.GICR_SGI_And_PPI_Page.GICR_ICFGR_Array (ICFGR_Register_Index) := GIC_ICFGR_Value;

      --
      --  Configure interrupt priority:
      --
      GIC_IPRIORITYR_Value := GICR.GICR_SGI_And_PPI_Page.GICR_IPRIORITYR_Array (IPRIORITY_Register_Index);
      GIC_IPRIORITYR_Value.Slot_Array (IPRIORITY_Field_Index).Interrupt_Priority :=
         GIC_Interrupt_Priority_Type (Priority);
      GICR.GICR_SGI_And_PPI_Page.GICR_IPRIORITYR_Array (IPRIORITY_Register_Index) := GIC_IPRIORITYR_Value;

      --
      --  Assign interrupt to an interrupt group:
      --
      GIC_IGROUPR_Value := GICR.GICR_SGI_And_PPI_Page.GICR_IGROUPR0;
      GIC_IGROUPR_Value (Integer (Internal_Interrupt_Id)) := GIC_Interrupt_Group_Type (Cpu_Interrupt_Line);
      GICR.GICR_SGI_And_PPI_Page.GICR_IGROUPR0 := GIC_IGROUPR_Value;

      HiRTOS.Memory_Protection.End_Mmio_Range_Access (Old_Mmio_Range);
   end Configure_Internal_Interrupt;

   procedure Configure_External_Interrupt (
      External_Interrupt_Id : External_Interrupt_Id_Type;
      Priority : Interrupt_Priority_Type;
      Cpu_Interrupt_Line : Cpu_Interrupt_Line_Type;
      Trigger_Mode : Interrupt_Trigger_Mode_Type;
      Interrupt_Handler_Entry_Point : Interrupt_Handler_Entry_Point_Type;
      Interrupt_Handler_Arg : System.Address := System.Null_Address)
   is
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      Interrupt_Handler : Interrupt_Handler_Type renames
         Interrupt_Controller_Obj.External_Interrupt_Handlers (External_Interrupt_Id);
      Old_Mmio_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
      GICD : GICD_Type renames Interrupt_Controller_Obj.GICD_Pointer.all;
      ICFGR_Register_Index : constant Integer :=
         Integer (External_Interrupt_Id) / GIC_ICFGR_Field_Array_Type'Length;
      ICFGR_Field_Index : constant Integer :=
         Integer (External_Interrupt_Id) mod GIC_ICFGR_Field_Array_Type'Length;
      IPRIORITYR_Register_Index : constant Integer :=
         Integer (External_Interrupt_Id) / GIC_IPRIORITYR_Slot_Array_Type'Length;
      IPRIORITYR_Field_Index : constant Integer :=
         Integer (External_Interrupt_Id) mod GIC_IPRIORITYR_Slot_Array_Type'Length;
      IGROUPR_Register_Index : constant Integer :=
         Integer (External_Interrupt_Id) / GIC_IGROUPR_Type'Length;
      IGROUPR_Field_Index : constant Integer :=
         Integer (External_Interrupt_Id) mod GIC_IGROUPR_Type'Length;
      GIC_ICFGR_Value : GIC_ICFGR_Type;
      GIC_IPRIORITYR_Value : GIC_IPRIORITYR_Type;
      GIC_IGROUPR_Value : GIC_IGROUPR_Type;
      GICD_IROUTER_Value : GICD_IROUTER_Type;
   begin
      pragma Assert (Interrupt_Handler.Interrupt_Handler_Entry_Point = null);
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access (
         Interrupt_Controller_Obj'Address,
         Interrupt_Controller_Obj'Size,
         Old_Data_Range);
      Interrupt_Handler.Cpu_Id := Cpu_Id;
      Interrupt_Handler.Interrupt_Handler_Entry_Point := Interrupt_Handler_Entry_Point;
      Interrupt_Handler.Interrupt_Handler_Arg := Interrupt_Handler_Arg;

      --
      --  NOTE: We need to serialize access to the GICD from multiple
      --  CPU cores, as exxternal interrupts (shared peripherla interrupts)
      --
      HiRTOS_Cpu_Multi_Core_Interface.Spinlock_Acquire (Interrupt_Controller_Obj.Spinlock);
      HiRTOS.Memory_Protection.Begin_Mmio_Range_Write_Access (
         GICD'Address, GICD'Size, Old_Mmio_Range);

      --
      --  Configure interrupt trigger mode:
      --
      GIC_ICFGR_Value := GICD.GICD_ICFGR_Array (ICFGR_Register_Index);
      GIC_ICFGR_Value.Interrupt_Config_Array (ICFGR_Field_Index).Interrupt_Trigger :=
         GIC_ICFGR_Interrupt_Trigger_Type (Trigger_Mode);
      GICD.GICD_ICFGR_Array (ICFGR_Register_Index) := GIC_ICFGR_Value;

      --
      --  Configure interrupt priority:
      --
      GIC_IPRIORITYR_Value := GICD.GICD_IPRIORITYR_Array (IPRIORITYR_Register_Index);
      GIC_IPRIORITYR_Value.Slot_Array (IPRIORITYR_Field_Index).Interrupt_Priority :=
         GIC_Interrupt_Priority_Type (Priority);
      GICD.GICD_IPRIORITYR_Array (IPRIORITYR_Register_Index) := GIC_IPRIORITYR_Value;

      --
      --  Assign interrupt to an interrupt group:
      --
      GIC_IGROUPR_Value := GICD.GICD_IGROUPR_Array (IGROUPR_Register_Index);
      GIC_IGROUPR_Value (IGROUPR_Field_Index) := GIC_Interrupt_Group_Type (Cpu_Interrupt_Line);
      GICD.GICD_IGROUPR_Array (IGROUPR_Register_Index) := GIC_IGROUPR_Value;

      --
      --  Route interrupt to ther calling CPU:
      --
      GICD_IROUTER_Value := GICD.GICD_IROUTER_Array (Integer (External_Interrupt_Id));
      GICD_IROUTER_Value.Aff0 := GICD_IROUTER_Affinity_Type (Cpu_Id);
      GICD.GICD_IROUTER_Array (Integer (External_Interrupt_Id)) := GICD_IROUTER_Value;

      HiRTOS.Memory_Protection.End_Mmio_Range_Access (Old_Mmio_Range);
      HiRTOS_Cpu_Multi_Core_Interface.Spinlock_Release (Interrupt_Controller_Obj.Spinlock);
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
   end Configure_External_Interrupt;

   procedure Enable_Internal_Interrupt (Internal_Interrupt_Id : Internal_Interrupt_Id_Type) is
      GIC_ISENABLER_Value : GIC_ISENABLER_Type;
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      GICR : GICR_Type renames Interrupt_Controller_Obj.GICD_Pointer.GICR_Array (Cpu_Id);
      Old_Mmio_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
   begin
      HiRTOS.Memory_Protection.Begin_Mmio_Range_Write_Access (
         GICR'Address, GICR'Size, Old_Mmio_Range);

      GIC_ISENABLER_Value := [others => 0];
      GIC_ISENABLER_Value (Integer (Internal_Interrupt_Id)) := 1;
      GICR.GICR_SGI_And_PPI_Page.GICR_ISENABLER0 := GIC_ISENABLER_Value;

      HiRTOS.Memory_Protection.End_Mmio_Range_Access (Old_Mmio_Range);
   end Enable_Internal_Interrupt;

   procedure Enable_External_Interrupt (External_Interrupt_Id : External_Interrupt_Id_Type) is
      GIC_ISENABLER_Value : GIC_ISENABLER_Type;
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
      Old_Mmio_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
      ISENABLER_Register_Index : constant Integer :=
         Integer (External_Interrupt_Id) / GIC_ISENABLER_Type'Length;
      ISENABLER_Field_Index : constant Integer :=
         Integer (External_Interrupt_Id) mod GIC_ISENABLER_Type'Length;
      GICD : GICD_Type renames Interrupt_Controller_Obj.GICD_Pointer.all;
   begin
      --
      --  NOTE: We need to serialize access to the GICD from multiple
      --  CPU cores, as exxternal interrupts (shared peripherla interrupts)
      --
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access (
         Interrupt_Controller_Obj'Address,
         Interrupt_Controller_Obj'Size,
         Old_Data_Range);
      HiRTOS_Cpu_Multi_Core_Interface.Spinlock_Acquire (Interrupt_Controller_Obj.Spinlock);
      HiRTOS.Memory_Protection.Begin_Mmio_Range_Write_Access (
         GICD'Address, GICD'Size, Old_Mmio_Range);

      GIC_ISENABLER_Value := [others => 0];
      GIC_ISENABLER_Value (ISENABLER_Field_Index) := 1;
      GICD.GICD_ISENABLER_Array (ISENABLER_Register_Index) := GIC_ISENABLER_Value;

      HiRTOS.Memory_Protection.End_Mmio_Range_Access (Old_Mmio_Range);
      HiRTOS_Cpu_Multi_Core_Interface.Spinlock_Release (Interrupt_Controller_Obj.Spinlock);
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
   end Enable_External_Interrupt;

   procedure Disable_Internal_Interrupt (Internal_Interrupt_Id : Internal_Interrupt_Id_Type) is
      GIC_ICENABLER_Value : GIC_ICENABLER_Type;
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      GICR : GICR_Type renames Interrupt_Controller_Obj.GICD_Pointer.GICR_Array (Cpu_Id);
      Old_Mmio_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
   begin
      HiRTOS.Memory_Protection.Begin_Mmio_Range_Write_Access (
         GICR'Address, GICR'Size, Old_Mmio_Range);

      GIC_ICENABLER_Value := [others => 0];
      GIC_ICENABLER_Value (Integer (Internal_Interrupt_Id)) := 1;
      GICR.GICR_SGI_And_PPI_Page.GICR_ICENABLER0 := GIC_ICENABLER_Value;

      HiRTOS.Memory_Protection.End_Mmio_Range_Access (Old_Mmio_Range);
   end Disable_Internal_Interrupt;

   procedure Disable_External_Interrupt (External_Interrupt_Id : External_Interrupt_Id_Type) is
      GIC_ICENABLER_Value : GIC_ICENABLER_Type;
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
      Old_Mmio_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
      ICENABLER_Register_Index : constant Integer :=
         Integer (External_Interrupt_Id) / GIC_ICENABLER_Type'Length;
      ICENABLER_Field_Index : constant Integer :=
         Integer (External_Interrupt_Id) mod GIC_ICENABLER_Type'Length;
      GICD : GICD_Type renames Interrupt_Controller_Obj.GICD_Pointer.all;
   begin
      --
      --  NOTE: We need to serialize access to the GICD from multiple
      --  CPU cores, as exxternal interrupts (shared peripherla interrupts)
      --
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access (
         Interrupt_Controller_Obj'Address,
         Interrupt_Controller_Obj'Size,
         Old_Data_Range);
      HiRTOS_Cpu_Multi_Core_Interface.Spinlock_Acquire (Interrupt_Controller_Obj.Spinlock);
      HiRTOS.Memory_Protection.Begin_Mmio_Range_Write_Access (
         GICD'Address, GICD'Size, Old_Mmio_Range);

      GIC_ICENABLER_Value := [others => 0];
      GIC_ICENABLER_Value (ICENABLER_Field_Index) := 1;
      GICD.GICD_ICENABLER_Array (ICENABLER_Register_Index) := GIC_ICENABLER_Value;

      HiRTOS.Memory_Protection.End_Mmio_Range_Access (Old_Mmio_Range);
      HiRTOS_Cpu_Multi_Core_Interface.Spinlock_Release (Interrupt_Controller_Obj.Spinlock);
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
   end Disable_External_Interrupt;

   procedure GIC_Interrupt_Handler (Cpu_Interrupt_Line : Cpu_Interrupt_Line_Type) is
      use type HiRTOS.Interrupt_Nesting_Counter_Type;
      ICC_IAR_Value : constant ICC_IAR_Type :=
         Get_ICC_IAR (GIC_Interrupt_Group_Type (Cpu_Interrupt_Line));
      Interrupt_Id : constant Valid_Interrupt_Id_Type :=
         Valid_Interrupt_Id_Type (ICC_IAR_Value.INTID);
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      Interrupt_Handler : Interrupt_Handler_Type renames
         Interrupt_Controller_Obj.Internal_Interrupt_Handlers (Cpu_Id, Interrupt_Id);
      Old_Cpu_Interrupting_State : Cpu_Register_Type with Unreferenced;
      ICC_EOIR_Value : ICC_EOIR_Type;
   begin
      pragma Assert (Interrupt_Handler.Interrupt_Handler_Entry_Point /= null);

      --  Enable interrupts at the CPU ro support nested interrupts
      HiRTOS_Cpu_Arch_Interface.Enable_Cpu_Interrupting;

      --  Invoke the IRQ-specific interrupt handler:
      Interrupt_Handler.Interrupt_Handler_Entry_Point (Interrupt_Handler.Interrupt_Handler_Arg);

      --  Disable interrupts at the CPU before returning:
      Old_Cpu_Interrupting_State := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      --
      --  Notify the interrupt controller that processing for the last interrupt
      --  received by the calling CPU core has been completed, so that another
      --  interrupt of the same priority or lower can be received by this CPU core:
      --
      ICC_EOIR_Value.INTID := INTID_Type (Interrupt_Id);
      Set_ICC_EOIR (GIC_Interrupt_Group_Type (Cpu_Interrupt_Line), ICC_EOIR_Value);
   end GIC_Interrupt_Handler;

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

   --  Get base address of the GIC registers
   function Get_IMP_CBAR return IMP_CBAR_Type is
      IMP_CBAR_Value : IMP_CBAR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 1, %0, c15, c3, 0",
         Outputs => IMP_CBAR_Type'Asm_Output ("=r", IMP_CBAR_Value), --  %0
         Volatile => True);

      return IMP_CBAR_Value;
   end Get_IMP_CBAR;

   function Get_ICC_IAR (GIC_Interrupt_Group : GIC_Interrupt_Group_Type)
      return ICC_IAR_Type
   is
      ICC_IAR_Value : ICC_IAR_Type;
   begin
      if GIC_Interrupt_Group = GIC_Interrupt_Group0 then
         System.Machine_Code.Asm (
            "mrc p15, 0, %0, c12, c8, 0",
            Outputs => ICC_IAR_Type'Asm_Output ("=r", ICC_IAR_Value), --  %0
            Volatile => True);
      else
         System.Machine_Code.Asm (
            "mrc p15, 0, %0, c12, c12, 0",
            Outputs => ICC_IAR_Type'Asm_Output ("=r", ICC_IAR_Value), --  %0
            Volatile => True);
      end if;

      return ICC_IAR_Value;
   end Get_ICC_IAR;

   procedure Set_ICC_IAR (GIC_Interrupt_Group : GIC_Interrupt_Group_Type;
                          ICC_IAR_Value : ICC_IAR_Type) is
   begin
      if GIC_Interrupt_Group = GIC_Interrupt_Group0 then
         System.Machine_Code.Asm (
            "mcr p15, 0, %0, c12, c8, 0",
            Inputs => ICC_IAR_Type'Asm_Input ("r", ICC_IAR_Value), --  %0
            Volatile => True);
      else
         System.Machine_Code.Asm (
            "mcr p15, 0, %0, c12, c12, 0",
            Inputs => ICC_IAR_Type'Asm_Input ("r", ICC_IAR_Value), --  %0
            Volatile => True);
      end if;
   end Set_ICC_IAR;

   function Get_ICC_EOIR (GIC_Interrupt_Group : GIC_Interrupt_Group_Type)
      return ICC_EOIR_Type
   is
      ICC_EOIR_Value : ICC_EOIR_Type;
   begin
      if GIC_Interrupt_Group = GIC_Interrupt_Group0 then
         System.Machine_Code.Asm (
            "mrc p15, 0, %0, c12, c8, 1",
            Outputs => ICC_EOIR_Type'Asm_Output ("=r", ICC_EOIR_Value), --  %0
            Volatile => True);
      else
         System.Machine_Code.Asm (
            "mrc p15, 0, %0, c12, c12, 1",
            Outputs => ICC_EOIR_Type'Asm_Output ("=r", ICC_EOIR_Value), --  %0
            Volatile => True);
      end if;

      return ICC_EOIR_Value;
   end Get_ICC_EOIR;

   procedure Set_ICC_EOIR (GIC_Interrupt_Group : GIC_Interrupt_Group_Type;
                           ICC_EOIR_Value : ICC_EOIR_Type) is
   begin
      if GIC_Interrupt_Group = GIC_Interrupt_Group0 then
         System.Machine_Code.Asm (
            "mcr p15, 0, %0, c12, c8, 1",
            Inputs => ICC_EOIR_Type'Asm_Input ("r", ICC_EOIR_Value), --  %0
            Volatile => True);
      else
         System.Machine_Code.Asm (
            "mcr p15, 0, %0, c12, c12, 1",
            Inputs => ICC_EOIR_Type'Asm_Input ("r", ICC_EOIR_Value), --  %0
            Volatile => True);
      end if;
   end Set_ICC_EOIR;

   function Get_ICC_HPPIR (GIC_Interrupt_Group : GIC_Interrupt_Group_Type)
      return ICC_HPPIR_Type
   is
      ICC_HPPIR_Value : ICC_HPPIR_Type;
   begin
      if GIC_Interrupt_Group = GIC_Interrupt_Group0 then
         System.Machine_Code.Asm (
            "mrc p15, 0, %0, c12, c8, 2",
            Outputs => ICC_HPPIR_Type'Asm_Output ("=r", ICC_HPPIR_Value), --  %0
            Volatile => True);
      else
         System.Machine_Code.Asm (
            "mrc p15, 0, %0, c12, c12, 2",
            Outputs => ICC_HPPIR_Type'Asm_Output ("=r", ICC_HPPIR_Value), --  %0
            Volatile => True);
      end if;

      return ICC_HPPIR_Value;
   end Get_ICC_HPPIR;

   procedure Set_ICC_HPPIR (GIC_Interrupt_Group : GIC_Interrupt_Group_Type;
                            ICC_HPPIR_Value : ICC_HPPIR_Type) is
   begin
      if GIC_Interrupt_Group = GIC_Interrupt_Group0 then
         System.Machine_Code.Asm (
            "mcr p15, 0, %0, c12, c8, 2",
            Inputs => ICC_HPPIR_Type'Asm_Input ("r", ICC_HPPIR_Value), --  %0
            Volatile => True);
      else
         System.Machine_Code.Asm (
            "mcr p15, 0, %0, c12, c12, 2",
            Inputs => ICC_HPPIR_Type'Asm_Input ("r", ICC_HPPIR_Value), --  %0
            Volatile => True);
      end if;
   end Set_ICC_HPPIR;

   function Get_ICC_BPR (GIC_Interrupt_Group : GIC_Interrupt_Group_Type)
      return ICC_BPR_Type is
      ICC_BPR_Value : ICC_BPR_Type;
   begin
      if GIC_Interrupt_Group = GIC_Interrupt_Group0 then
         System.Machine_Code.Asm (
            "mrc p15, 0, %0, c12, c8, 3",
            Outputs => ICC_BPR_Type'Asm_Output ("=r", ICC_BPR_Value), --  %0
            Volatile => True);
      else
         System.Machine_Code.Asm (
            "mrc p15, 0, %0, c12, c12, 3",
            Outputs => ICC_BPR_Type'Asm_Output ("=r", ICC_BPR_Value), --  %0
            Volatile => True);
      end if;

      return ICC_BPR_Value;
   end Get_ICC_BPR;

   procedure Set_ICC_BPR (GIC_Interrupt_Group : GIC_Interrupt_Group_Type;
                          ICC_BPR_Value : ICC_BPR_Type) is
   begin
      if GIC_Interrupt_Group = GIC_Interrupt_Group0 then
         System.Machine_Code.Asm (
            "mcr p15, 0, %0, c12, c8, 3",
            Inputs => ICC_BPR_Type'Asm_Input ("r", ICC_BPR_Value), --  %0
            Volatile => True);
      else
         System.Machine_Code.Asm (
            "mcr p15, 0, %0, c12, c12, 3",
            Inputs => ICC_BPR_Type'Asm_Input ("r", ICC_BPR_Value), --  %0
            Volatile => True);
      end if;
   end Set_ICC_BPR;

   function Get_ICC_DIR return ICC_DIR_Type is
      ICC_DIR_Value : ICC_DIR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c12, c11, 1",
         Outputs => ICC_DIR_Type'Asm_Output ("=r", ICC_DIR_Value), --  %0
         Volatile => True);

      return ICC_DIR_Value;
   end Get_ICC_DIR;

   procedure Set_ICC_DIR (ICC_DIR_Value : ICC_DIR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c12, c11, 1",
         Inputs => ICC_DIR_Type'Asm_Input ("r", ICC_DIR_Value), --  %0
         Volatile => True);
   end Set_ICC_DIR;

   function Get_ICC_PMR return ICC_PMR_Type is
      ICC_PMR_Value : ICC_PMR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c4, c6, 0",
         Outputs => ICC_PMR_Type'Asm_Output ("=r", ICC_PMR_Value), --  %0
         Volatile => True);

      return ICC_PMR_Value;
   end Get_ICC_PMR;

   procedure Set_ICC_PMR (ICC_PMR_Value : ICC_PMR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c4, c6, 0",
         Inputs => Interfaces.Unsigned_32'Asm_Input ("r", ICC_PMR_Value.Value), --  %0
         Volatile => True);
   end Set_ICC_PMR;

   function Get_ICC_CTLR return ICC_CTLR_Type is
      ICC_CTLR_Value : ICC_CTLR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c12, c12, 4",
         Outputs => ICC_CTLR_Type'Asm_Output ("=r", ICC_CTLR_Value), --  %0
         Volatile => True);

      return ICC_CTLR_Value;
   end Get_ICC_CTLR;

   procedure Set_ICC_CTLR (ICC_CTLR_Value : ICC_CTLR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c12, c12, 4",
         Inputs => ICC_CTLR_Type'Asm_Input ("r", ICC_CTLR_Value), --  %0
         Volatile => True);
   end Set_ICC_CTLR;

   function Get_ICC_IGRPEN (GIC_Interrupt_Group : GIC_Interrupt_Group_Type)
      return ICC_IGRPEN_Type
   is
      ICC_IGRPEN_Value : ICC_IGRPEN_Type;
   begin
      if GIC_Interrupt_Group = GIC_Interrupt_Group0 then
         System.Machine_Code.Asm (
            "mrc p15, 0, %0, c12, c12, 6",
            Outputs => ICC_IGRPEN_Type'Asm_Output ("=r", ICC_IGRPEN_Value), --  %0
            Volatile => True);
      else
         System.Machine_Code.Asm (
            "mrc p15, 0, %0, c12, c12, 7",
            Outputs => ICC_IGRPEN_Type'Asm_Output ("=r", ICC_IGRPEN_Value), --  %0
            Volatile => True);
      end if;

      return ICC_IGRPEN_Value;
   end Get_ICC_IGRPEN;

   procedure Set_ICC_IGRPEN (GIC_Interrupt_Group : GIC_Interrupt_Group_Type;
                             ICC_IGRPEN_Value : ICC_IGRPEN_Type) is
   begin
      if GIC_Interrupt_Group = GIC_Interrupt_Group0 then
         System.Machine_Code.Asm (
            "mcr p15, 0, %0, c12, c12, 6",
            Inputs => ICC_IGRPEN_Type'Asm_Input ("r", ICC_IGRPEN_Value), --  %0
            Volatile => True);
      else
         System.Machine_Code.Asm (
            "mcr p15, 0, %0, c12, c12, 7",
            Inputs => ICC_IGRPEN_Type'Asm_Input ("r", ICC_IGRPEN_Value), --  %0
            Volatile => True);
      end if;
   end Set_ICC_IGRPEN;

   procedure Set_ICC_SGIR (GIC_Interrupt_Group : GIC_Interrupt_Group_Type;
                            ICC_SGIR_Value : ICC_SGIR_Type) is
   begin
      if GIC_Interrupt_Group = GIC_Interrupt_Group0 then
         System.Machine_Code.Asm (
            "mcrr p15, 2, %0, %1, c12",
            Inputs => [Interfaces.Unsigned_32'Asm_Input ("r", ICC_SGIR_Value.Lower_Word),  --  %0
                     Interfaces.Unsigned_32'Asm_Input ("r", ICC_SGIR_Value.Upper_Word)], --  %1
            Volatile => True);
      else
         System.Machine_Code.Asm (
            "mcrr p15, 0, %0, %1, c12",
            Inputs => [Interfaces.Unsigned_32'Asm_Input ("r", ICC_SGIR_Value.Lower_Word),  --  %0
                     Interfaces.Unsigned_32'Asm_Input ("r", ICC_SGIR_Value.Upper_Word)], --  %1
            Volatile => True);
      end if;
   end Set_ICC_SGIR;

end HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
