--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Interrupt controller driver for ARM Cortex-M NVIC
--

with HiRTOS_Cpu_Arch_Interface_Private;
with HiRTOS.Interrupt_Handling;
with Bit_Sized_Integer_Types;
with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface.Interrupt_Controller with
  SPARK_Mode => Off
is
   use HiRTOS_Cpu_Arch_Interface_Private;
   use HiRTOS_Cpu_Arch_Interface.System_Registers;
   use Bit_Sized_Integer_Types;
   use Interfaces;

   function Get_BASEPRI return Unsigned_32;

   procedure Set_BASEPRI (Reg_Value : Unsigned_32);

   function Cortex_M_Start_Executing_Thread_Callback return Boolean;

   ----------------------------------------------------------------------------
   --  Public Subprograms
   ----------------------------------------------------------------------------

   procedure Initialize
   is
      use type System.Address;
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      Old_Cpu_Interrupting_State : Cpu_Register_Type;
      SHPR3_Value : SHPR3_Type;
      Old_Flags : Cpu_Register_Type with Unreferenced;
   begin
      Old_Cpu_Interrupting_State := Disable_Cpu_Interrupting;

      HiRTOS.Interrupt_Handling.Register_Executing_Thread_Callbacks (
         Stop_Executing_Thread_Callback => null,
         Start_Executing_Thread_Callback => Cortex_M_Start_Executing_Thread_Callback'Access);

      SHPR3_Value := SCS.SCB.SHPR3;
      SHPR3_Value.PendSV_Priority := Encoded_Interrupt_Priorities (Lowest_Interrupt_Priority);
      SHPR3_Value.SysTick_Priority := Encoded_Interrupt_Priorities (Highest_Interrupt_Priority);
      SCS.SCB.SHPR3 := SHPR3_Value;

      --  Set interrupt vector table pointer register:
      SCS.SCB.VTOR := Word_Type (To_Integer (Interrupt_Vector_Table'Address));

      --  Disable and clear all interrupts:
      SCS.NVIC.ICER := [others => [others => 1]];
      SCS.NVIC.ICPR := [others => [others => 1]];

      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);

      Old_Flags := Atomic_Fetch_Or (Interrupt_Controller_Obj.Per_Cpu_Initialized_Flags,
                                    Bit_Mask (Bit_Index_Type (Cpu_Id)));
   end Initialize;

   procedure Configure_Interrupt
     (Interrupt_Id                  : Valid_Interrupt_Id_Type;
      Priority                      : Interrupt_Priority_Type;
      Trigger_Mode                  : Interrupt_Trigger_Mode_Type with Unreferenced;
      Interrupt_Handler_Entry_Point : Interrupt_Handler_Entry_Point_Type;
      Interrupt_Handler_Arg         : System.Address := System.Null_Address)
   is
      Cpu_Id                   : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      ISER_Reg_Index : constant NVIC_Bit_Array_Array_Index_Type :=
         NVIC_Bit_Array_Array_Index_Type (Interrupt_Id / NVIC_Bit_Array_Type'Length);
      ISER_Bit_Index : constant NVIC_Bit_Array_Index_Type :=
         NVIC_Bit_Array_Index_Type (Interrupt_Id mod NVIC_Bit_Array_Type'Length);
      ISER_Reg_Value : NVIC_Bit_Array_Type := [others => 0];
      Priority_Reg_Index : constant NVIC_Priority_Slot_Array_Array_Index_Type :=
         NVIC_Priority_Slot_Array_Array_Index_Type (
            Interrupt_Id / NVIC_Priority_Slot_Array_Type'Length);
      Priority_Slot_Index : constant NVIC_Priority_Slot_Array_Index_Type :=
         NVIC_Priority_Slot_Array_Index_Type (
            Interrupt_Id mod NVIC_Priority_Slot_Array_Type'Length);
      Priority_Reg_Value : NVIC_Priority_Slot_Array_Type;
      Interrupt_Handler : Interrupt_Handler_Type renames
        Interrupt_Controller_Obj.Interrupt_Handlers (Cpu_Id, Interrupt_Id);
      Old_Cpu_Interrupting_State : Cpu_Register_Type;
   begin
      pragma Assert (Interrupt_Handler.Interrupt_Handler_Entry_Point = null);
      --  Begin critical section
      Old_Cpu_Interrupting_State := Disable_Cpu_Interrupting;

      Interrupt_Handler.Cpu_Id                        := Cpu_Id;
      Interrupt_Handler.Interrupt_Handler_Entry_Point :=
        Interrupt_Handler_Entry_Point;
      Interrupt_Handler.Interrupt_Handler_Arg         := Interrupt_Handler_Arg;

      --  Set interrupt priority in the NVIC:
      Priority_Reg_Value := SCS.NVIC.IP (Priority_Reg_Index);
      Priority_Reg_Value (Priority_Slot_Index) :=
         Encoded_Interrupt_Priority_Type (Priority);
      SCS.NVIC.IP (Priority_Reg_Index) := Priority_Reg_Value;

      --  Enable interrupt in the NVIC:
      ISER_Reg_Value (ISER_Bit_Index) := 1;
      SCS.NVIC.ISER (ISER_Reg_Index) := ISER_Reg_Value;

      --  End critical section
      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);
   end Configure_Interrupt;

   procedure Enable_Interrupt (Interrupt_Id : Valid_Interrupt_Id_Type) is
      ISER_Reg_Index : constant NVIC_Bit_Array_Array_Index_Type :=
         NVIC_Bit_Array_Array_Index_Type (Interrupt_Id / NVIC_Bit_Array_Type'Length);
      ISER_Bit_Index : constant NVIC_Bit_Array_Index_Type :=
         NVIC_Bit_Array_Index_Type (Interrupt_Id mod NVIC_Bit_Array_Type'Length);
      ISER_Reg_Value : NVIC_Bit_Array_Type := [others => 0];
      Old_Cpu_Interrupting_State : Cpu_Register_Type;
   begin
      --  Begin critical section
      Old_Cpu_Interrupting_State := Disable_Cpu_Interrupting;

      ISER_Reg_Value (ISER_Bit_Index) := 1;
      SCS.NVIC.ISER (ISER_Reg_Index) := ISER_Reg_Value;

      --  End critical section
      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);
   end Enable_Interrupt;

   procedure Disable_Interrupt (Interrupt_Id : Valid_Interrupt_Id_Type) is
      ICER_Reg_Index : constant NVIC_Bit_Array_Array_Index_Type :=
         NVIC_Bit_Array_Array_Index_Type (Interrupt_Id / NVIC_Bit_Array_Type'Length);
      ICER_Bit_Index : constant NVIC_Bit_Array_Index_Type :=
         NVIC_Bit_Array_Index_Type (Interrupt_Id mod NVIC_Bit_Array_Type'Length);
      ICER_Reg_Value : NVIC_Bit_Array_Type := [others => 0];
      Old_Cpu_Interrupting_State : Cpu_Register_Type;
   begin
      --  Begin critical section
      Old_Cpu_Interrupting_State := Disable_Cpu_Interrupting;

      ICER_Reg_Value (ICER_Bit_Index) := 1;
      SCS.NVIC.ICER (ICER_Reg_Index) := ICER_Reg_Value;

      --  End critical section
      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);
   end Disable_Interrupt;

   procedure Interrupt_Handler (Interrupt_Id : Valid_Interrupt_Id_Type)
   is
      Cpu_Id : constant Valid_Cpu_Core_Id_Type  := Get_Cpu_Id;
      Interrupt_Handler : Interrupt_Handler_Type renames
         Interrupt_Controller_Obj.Interrupt_Handlers (Cpu_Id, Interrupt_Id);
   begin
      --  Invoke the IRQ-specific interrupt handler:
      pragma Assert (Interrupt_Handler.Interrupt_Handler_Entry_Point /= null);
      Interrupt_Handler.Interrupt_Handler_Entry_Point (Interrupt_Handler.Interrupt_Handler_Arg);
   end Interrupt_Handler;

   function Get_Highest_Interrupt_Priority_Disabled return Interrupt_Priority_Type is
      (if HiRTOS_Platform_Parameters.BASEPRI_Register_Supported then
         Interrupt_Priority_Type (Get_BASEPRI)
       elsif Cpu_Interrupting_Disabled then
         Highest_Interrupt_Priority
       else
         Lowest_Interrupt_Priority);

   procedure Set_Highest_Interrupt_Priority_Disabled (Priority : Interrupt_Priority_Type) is
      Old_Cpu_Interrupting : Cpu_Register_Type with Unreferenced;
   begin
      if HiRTOS_Platform_Parameters.BASEPRI_Register_Supported then
         Set_BASEPRI (Unsigned_32 (Priority));
      elsif Priority < Interrupt_Priority_Type'Last then
         Old_Cpu_Interrupting := Disable_Cpu_Interrupting;
      else
         Enable_Cpu_Interrupting;
      end if;
   end Set_Highest_Interrupt_Priority_Disabled;

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

   function Cortex_M_Start_Executing_Thread_Callback return Boolean is
      IPSR_Value : constant Interfaces.Unsigned_32 := Get_IPSR_Register;
   begin
      if IPSR_Value = PendSV_Exception'Enum_Rep then
         return True;
      else
         Trigger_PendSV_Exception;
         return False;
      end if;
   end Cortex_M_Start_Executing_Thread_Callback;

   function Get_BASEPRI return Unsigned_32 is
      Reg_Value : Unsigned_32;
   begin
      if HiRTOS_Platform_Parameters.BASEPRI_Register_Supported then
         System.Machine_Code.Asm (
            "mrs %0, basepri",
            Outputs => Unsigned_32'Asm_Output ("=r", Reg_Value),
            Volatile => True);
      else
         Reg_Value := 0;
      end if;

      return Reg_Value;
   end Get_BASEPRI;

   procedure Set_BASEPRI (Reg_Value : Unsigned_32) is
   begin
      if HiRTOS_Platform_Parameters.BASEPRI_Register_Supported then
         System.Machine_Code.Asm (
            "msr basepri, %0",
            Inputs => Unsigned_32'Asm_Input ("r", Reg_Value),
            Volatile => True);
      else
         pragma Assert (Reg_Value = 0);
      end if;
   end Set_BASEPRI;

end HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
