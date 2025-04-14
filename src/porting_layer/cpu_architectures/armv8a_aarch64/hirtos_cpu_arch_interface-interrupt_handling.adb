--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target platform interface for ARMv8-A aarch64 architecture - Interrupt handling
--

with Generic_Execution_Stack;
with HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
with HiRTOS_Cpu_Arch_Interface.System_Registers;
with HiRTOS_Cpu_Arch_Interface_Private;
with HiRTOS_Cpu_Arch_Parameters;
with HiRTOS_Low_Level_Debug_Interface;
with Interfaces;

package body HiRTOS_Cpu_Arch_Interface.Interrupt_Handling is
   use ASCII;

   procedure Ada_Handle_EL1_Synchronous_Exception
      with Export,
           Convention => C,
           External_Name => "ada_handle_el1_synchronous_exception";

   procedure Ada_Handle_EL1_Irq_Interrupt
      with Export,
           Convention => C,
           External_Name => "ada_handle_el1_irq_interrupt";

   procedure Ada_Handle_EL1_Fiq_Interrupt
      with Export,
           Convention => C,
           External_Name => "ada_handle_el1_fiq_interrupt";

   procedure Ada_Handle_EL1_SError_Exception
      with Export,
           Convention => C,
           External_Name => "ada_handle_el1_serror_exception",
           No_Return;

   procedure Ada_Handle_EL1_Unexpected_Exception
      with Export,
           Convention => C,
           External_Name => "ada_handle_el1_unexpected_exception",
           No_Return;

   --
   --  NOTE: The Value of this constant must match the value of ISR_STACK_SIZE in
   --  hirtos_cpu_arch_interface_asm.h
   --
   ISR_Stack_Size_In_Bytes : constant := 2 * HiRTOS_Cpu_Arch_Parameters.Page_Size_In_Bytes;

   package ISR_Stacks_Package is new
      Generic_Execution_Stack (Stack_Size_In_Bytes => ISR_Stack_Size_In_Bytes);

   ISR_Stacks :
      array (Valid_Cpu_Core_Id_Type) of ISR_Stacks_Package.Execution_Stack_Type
         with Linker_Section => ".isr_stacks",
              Convention => C,
              Export,
              External_Name => "isr_stacks";

   ------------------------
   -- Get_ISR_Stack_Info --
   ------------------------

   function Get_ISR_Stack_Info (Cpu_Id : Cpu_Core_Id_Type)
      return ISR_Stack_Info_Type
   is
      ISR_Stack_Info : constant ISR_Stack_Info_Type :=
         (Base_Address => ISR_Stacks (Cpu_Id).Stack_Entries'Address,
          Size_In_Bytes => ISR_Stacks (Cpu_Id).Stack_Entries'Size / System.Storage_Unit);
   begin
      return ISR_Stack_Info;
   end Get_ISR_Stack_Info;

   function Valid_ISR_Stack_Pointer (Cpu_Id : Cpu_Core_Id_Type; Stack_Pointer : System.Address)
      return Boolean is
      Min_Valid_Address : constant Integer_Address :=
         To_Integer (ISR_Stacks (Cpu_Id).Stack_Entries'Address);
      Max_Valid_Address : constant Integer_Address :=
         Min_Valid_Address + (ISR_Stacks (Cpu_Id).Stack_Entries'Size / System.Storage_Unit) - 1;
   begin
      return To_Integer (Stack_Pointer) in Min_Valid_Address .. Max_Valid_Address;
   end Valid_ISR_Stack_Pointer;

   ----------------------------------------------------------------------------
   --  Interrupt and Exception Handlers
   ----------------------------------------------------------------------------

   procedure Print_Exception_Info (Exception_Description : String) is
      use HiRTOS_Cpu_Arch_Interface.System_Registers;
      ESR_EL1_Value : constant ESR_EL1_Type := Get_ESR_EL1;
      FAR_EL1_Value : constant FAR_EL1_Type := Get_FAR_EL1;
      ELR_EL1_Value : constant Cpu_Register_Type := HiRTOS_Cpu_Arch_Interface_Private.Get_ELR_EL1;
   begin
      HiRTOS_Low_Level_Debug_Interface.Print_String (ASCII.LF & "*** EL1 ");
      HiRTOS_Low_Level_Debug_Interface.Print_String (Exception_Description);
      HiRTOS_Low_Level_Debug_Interface.Print_String (" (Exception class: ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_8 (ESR_EL1_Value.EC'Enum_Rep));
      HiRTOS_Low_Level_Debug_Interface.Print_String (", ESR_EL1: ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (ESR_EL1_Value.Value);
      HiRTOS_Low_Level_Debug_Interface.Print_String (", FAR_EL1: ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_64 (FAR_EL1_Value));
      HiRTOS_Low_Level_Debug_Interface.Print_String (", faulting PC: ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_64 (ELR_EL1_Value));
      HiRTOS_Low_Level_Debug_Interface.Print_String (")" & ASCII.LF);
   end Print_Exception_Info;

   procedure Handle_EL1_Error_Exception (Exception_Description : String) with No_Return is
   begin
      Print_Exception_Info (Exception_Description);
      raise Program_Error with Exception_Description;
   end Handle_EL1_Error_Exception;

   procedure Handle_EL1_Debug_Exception (Exception_Description : String) is
   begin
      Print_Exception_Info (Exception_Description);
      HiRTOS_Low_Level_Debug_Interface.Run_Self_Hosted_Debugger (HiRTOS_Cpu_Arch_Interface_Private.Get_ELR_EL1);
   end Handle_EL1_Debug_Exception;

   procedure Ada_Handle_EL1_Synchronous_Exception is
      use HiRTOS_Cpu_Arch_Interface.System_Registers;
      ESR_EL1_Value : constant ESR_EL1_Type := Get_ESR_EL1;
   begin
      case ESR_EL1_Value.EC is
         when ESR_EL1_EC_Unknown =>
            Handle_EL1_Error_Exception ("Unknown Exception");
         when ESR_EL1_EC_Trapped_WFI_WFE =>
            Handle_EL1_Error_Exception ("Trapped WFI/WFE Exception");
         when ESR_EL1_EC_Trapped_Access_SME_SVE_Advanced_SIMD_FP =>
            Handle_EL1_Error_Exception ("Trapped Access SME/SVE/Advanced SIMD/FP Exception");
         when ESR_EL1_EC_Illegal_State =>
            Handle_EL1_Error_Exception ("Illegal State Exception");
         when ESR_EL1_EC_Trapped_MSR_MRS_System_Inst_In_AArch64 =>
            Handle_EL1_Error_Exception ("Trapped MSR/MRS/System Instruction in AArch64 Exception");
         when ESR_EL1_EC_Instruction_Abort_Lower_EL =>
            Handle_EL1_Error_Exception ("Instruction Abort at Lower Exception Level");
         when ESR_EL1_EC_Instruction_Abort_Current_EL =>
            Handle_EL1_Error_Exception ("Instruction Abort at Current Exception Level");
         when ESR_EL1_EC_PC_ALignment_Fault =>
            Handle_EL1_Error_Exception ("PC Alignment Fault Exception");
         when ESR_EL1_EC_Data_Abort_Lower_EL =>
            Handle_EL1_Error_Exception ("Data Abort at Lower Exception Level");
         when ESR_EL1_EC_Data_Abort_Current_EL =>
            Handle_EL1_Error_Exception ("Data Abort at Current Exception Level");
         when ESR_EL1_EC_SP_Alignment_Fault =>
            Handle_EL1_Error_Exception ("SP Alignment Fault Exception");
         when ESR_EL1_EC_Trapped_Floating_Point_Exception =>
            Handle_EL1_Error_Exception ("Trapped Floating Point Exception");
         when ESR_EL1_EC_Breakpoint_Lower_EL =>
            Handle_EL1_Debug_Exception ("Hardware Breakpoint at Lower Exception Level");
         when ESR_EL1_EC_Breakpoint_Current_EL =>
            Handle_EL1_Debug_Exception ("Breakpoint at Current Exception Level");
         when ESR_EL1_EC_Software_Step_Exception_Lower_EL =>
            Handle_EL1_Debug_Exception ("Software Step Exception at Lower Exception Level");
         when ESR_EL1_EC_Software_Step_Exception_Current_EL =>
            Handle_EL1_Debug_Exception ("Software Step Exception at Current Exception Level");
         when ESR_EL1_EC_Watchpoint_Lower_EL =>
            Handle_EL1_Debug_Exception ("Watchpoint at Lower Exception Level");
         when ESR_EL1_EC_Watchpoint_Current_EL =>
            Handle_EL1_Debug_Exception ("Watchpoint at Current Exception Level");
         when ESR_EL1_EC_BRK_Instruction_In_Aarch64 =>
            Handle_EL1_Debug_Exception ("BRK Instruction in AArch64 Exception");
         when others =>
            Handle_EL1_Error_Exception ("Other Synchronous Error Exception");
      end case;
   end Ada_Handle_EL1_Synchronous_Exception;

   procedure Ada_Handle_EL1_Irq_Interrupt is
   begin
      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.GIC_Interrupt_Handler (
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Cpu_Interrupt_Irq);
   end Ada_Handle_EL1_Irq_Interrupt;

   procedure Ada_Handle_EL1_Fiq_Interrupt is
   begin
      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.GIC_Interrupt_Handler (
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Cpu_Interrupt_Fiq);
   end Ada_Handle_EL1_Fiq_Interrupt;

   procedure Ada_Handle_EL1_SError_Exception is
   begin
      Handle_EL1_Error_Exception ("SError Exception");
   end Ada_Handle_EL1_SError_Exception;

   procedure Ada_Handle_EL1_Unexpected_Exception is
   begin
      Handle_EL1_Error_Exception ("Unexpected Exception");
   end Ada_Handle_EL1_Unexpected_Exception;

end HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
