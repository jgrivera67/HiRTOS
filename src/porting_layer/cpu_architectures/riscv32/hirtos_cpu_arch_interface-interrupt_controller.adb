--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Interrupt controller driver for ESP32-C3
--

with HiRTOS_Platform_Interface;
with HiRTOS_Cpu_Arch_Interface_Private;

package body HiRTOS_Cpu_Arch_Interface.Interrupt_Controller with
  SPARK_Mode => Off
is

   ----------------------------------------------------------------------------
   --  Public Subprograms
   ----------------------------------------------------------------------------

   procedure Initialize
   is
      use HiRTOS_Cpu_Arch_Interface_Private;
      use type System.Address;
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      Old_Cpu_Interrupting_State : Cpu_Register_Type;
      Old_Flags                  : Cpu_Register_Type with Unreferenced;
      MTVEC_Value                : constant MTVEC_Type := Get_MTVEC;
      Interrupt_Vector_Table_Address : constant System.Address := To_Address (
         Integer_Address (MTVEC_Value.Encoded_Base_Address) *
         HiRTOS_Cpu_Arch_Parameters.Call_Instruction_Size_In_Bytes);
   begin
      pragma Assert (Interrupt_Vector_Table_Address = Interrupt_Vector_Jump_Table'Address);
      pragma Assert (MTVEC_Value.Mode = Vectored_Mode);

      Old_Cpu_Interrupting_State := Disable_Cpu_Interrupting;

      HiRTOS_Platform_Interface.Initialize_Interrupt_Controller;

      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);

      Old_Flags := Atomic_Fetch_Or (Interrupt_Controller_Obj.Per_Cpu_Initialized_Flags,
                                    Bit_Mask (Bit_Index_Type (Cpu_Id)));

      HiRTOS_Platform_Interface.Configure_Access_Violation_Interrupts;
   end Initialize;

   procedure Configure_Interrupt
     (Interrupt_Id                  : Valid_Interrupt_Id_Type;
      Priority                      : Interrupt_Priority_Type;
      Trigger_Mode                  : Interrupt_Trigger_Mode_Type;
      Interrupt_Handler_Entry_Point : Interrupt_Handler_Entry_Point_Type;
      Interrupt_Handler_Arg         : System.Address := System.Null_Address)
   is
      Cpu_Id                   : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      Interrupt_Handler        :
        Interrupt_Handler_Type renames
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

      HiRTOS_Platform_Interface.Configure_Interrupt (Interrupt_Id,
                                                     Priority,
                                                     Trigger_Mode);

      --  End critical section
      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);
   end Configure_Interrupt;

   procedure Enable_Interrupt (Interrupt_Id : Valid_Interrupt_Id_Type)
   is
      Old_Cpu_Interrupting_State : Cpu_Register_Type;
   begin
      --  Begin critical section
      Old_Cpu_Interrupting_State := Disable_Cpu_Interrupting;

      HiRTOS_Platform_Interface.Enable_Interrupt (Interrupt_Id);

      --  End critical section
      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);
   end Enable_Interrupt;

   procedure Disable_Interrupt (Interrupt_Id : Valid_Interrupt_Id_Type)
   is
      Old_Cpu_Interrupting_State : Cpu_Register_Type;
   begin
      --  Begin critical section
      Old_Cpu_Interrupting_State := Disable_Cpu_Interrupting;

      HiRTOS_Platform_Interface.Disable_Interrupt (Interrupt_Id);

      --  End critical section
      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);
   end Disable_Interrupt;

   procedure Interrupt_Handler (Interrupt_Id : Valid_Interrupt_Id_Type)
   is
      Cpu_Id : constant Valid_Cpu_Core_Id_Type  := Get_Cpu_Id;
      Interrupt_Priority : constant Interrupt_Priority_Type :=
         HiRTOS_Platform_Interface.Get_Interrupt_Priority (Interrupt_Id);

      procedure Handle_One_Interrupt (Interrupt_Id : Valid_Interrupt_Id_Type)
      is
         Old_Cpu_Interrupting_State : Cpu_Register_Type with Unreferenced;
         Old_Highest_Interrupt_Priority_Disabled : Interrupt_Priority_Type;
      begin
         pragma Assert (HiRTOS_Platform_Interface.Is_Interrupt_Pending (Interrupt_Id));

         Old_Highest_Interrupt_Priority_Disabled :=
            HiRTOS_Platform_Interface.Begin_Interrupt_Processing (Interrupt_Id, Interrupt_Priority);

         --  Enable interrupts at the CPU to support nested interrupts:
         if Interrupt_Priority < Interrupt_Priority_Type'Last then
            HiRTOS_Cpu_Arch_Interface.Enable_Cpu_Interrupting;
         end if;

         --  Invoke the IRQ-specific interrupt handler:
         declare
            Interrupt_Handler : Interrupt_Handler_Type renames
               Interrupt_Controller_Obj.Interrupt_Handlers (Cpu_Id, Interrupt_Id);
         begin
            pragma Assert (Interrupt_Handler.Interrupt_Handler_Entry_Point /= null);
            Interrupt_Handler.Interrupt_Handler_Entry_Point (Interrupt_Handler.Interrupt_Handler_Arg);
         end;

         --  Re-disable interrupts at the CPU before returning, if enabled above:
         if Interrupt_Priority < Interrupt_Priority_Type'Last then
            Old_Cpu_Interrupting_State := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
         end if;

         --
         --  Notify the interrupt controller that processing for the last interrupt
         --  received by the calling CPU core has been completed, so that another
         --  interrupt of the same priority or lower can be received by this CPU core:
         --
         HiRTOS_Cpu_Arch_Interface.Strong_Memory_Barrier;
         HiRTOS_Platform_Interface.End_Interrupt_Processing (Interrupt_Id,
                                                            Old_Highest_Interrupt_Priority_Disabled);
      end Handle_One_Interrupt;
   begin
      loop
         Handle_One_Interrupt (Interrupt_Id);
         exit when not HiRTOS_Platform_Interface.Is_Interrupt_Pending (Interrupt_Id);
      end loop;
   end Interrupt_Handler;

   function Get_Highest_Interrupt_Priority_Disabled return Interrupt_Priority_Type is
      (HiRTOS_Platform_Interface.Get_Highest_Interrupt_Priority_Disabled);

   procedure Set_Highest_Interrupt_Priority_Disabled (Priority : Interrupt_Priority_Type) is
   begin
      HiRTOS_Platform_Interface.Set_Highest_Interrupt_Priority_Disabled (Priority);
   end Set_Highest_Interrupt_Priority_Disabled;

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

end HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
