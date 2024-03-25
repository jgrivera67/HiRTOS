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

package body HiRTOS_Cpu_Arch_Interface.Interrupt_Controller with
  SPARK_Mode => Off
is
   ----------------------------------------------------------------------------
   --  Public Subprograms
   ----------------------------------------------------------------------------

   procedure Initialize
   is
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      Old_Cpu_Interrupting_State : Cpu_Register_Type;
      Old_Data_Range             : HiRTOS.Memory_Protection.Memory_Range_Type;
      Old_Flags                  : Cpu_Register_Type with Unreferenced;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access
        (Interrupt_Controller_Obj'Address, Interrupt_Controller_Obj'Size,
         Old_Data_Range);

      Old_Cpu_Interrupting_State := Disable_Cpu_Interrupting;

      HiRTOS_Platform_Interface.Initialize_Interrupt_Controller;

      Restore_Cpu_Interrupting (Old_Cpu_Interrupting_State);

      Old_Flags := Atomic_Fetch_Or (Interrupt_Controller_Obj.Per_Cpu_Initialized_Flags,
                                    Bit_Mask (Bit_Index_Type (Cpu_Id)));

      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Initialize;

   procedure Configure_Interrupt
     (Interrupt_Id                  : Interrupt_Id_Type;
      Priority                      : Interrupt_Priority_Type;
      Trigger_Mode                  : Interrupt_Trigger_Mode_Type;
      Interrupt_Handler_Entry_Point : Interrupt_Handler_Entry_Point_Type;
      Interrupt_Handler_Arg         : System.Address := System.Null_Address)
   is
      Cpu_Id                   : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      Interrupt_Handler        :
        Interrupt_Handler_Type renames
        Interrupt_Controller_Obj.Interrupt_Handlers (Cpu_Id, Interrupt_Id);
      Old_Mmio_Range           : HiRTOS.Memory_Protection.Memory_Range_Type;
      Old_Data_Range           : HiRTOS.Memory_Protection.Memory_Range_Type;
   begin
      pragma Assert (Interrupt_Handler.Interrupt_Handler_Entry_Point = null);
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access
        (Interrupt_Handler'Address, Interrupt_Handler'Size, Old_Data_Range);
      Interrupt_Handler.Cpu_Id                        := Cpu_Id;
      Interrupt_Handler.Interrupt_Handler_Entry_Point :=
        Interrupt_Handler_Entry_Point;
      Interrupt_Handler.Interrupt_Handler_Arg         := Interrupt_Handler_Arg;
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);

      --HiRTOS.Memory_Protection.Begin_Mmio_Range_Write_Access
      --  (GICR'Address, GICR'Size, Old_Mmio_Range);

      --
      --  Configure interrupt trigger mode:
      --

      --
      --  Configure interrupt priority:
      --

      --
      --  NOTE: The interrupt starts to fire on the CPU only after Enable_Interrupt()
      --  is called.
      --
      --HiRTOS.Memory_Protection.End_Mmio_Range_Access (Old_Mmio_Range);
   end Configure_Interrupt;

   procedure Enable_Interrupt
     (Interrupt_Id : Interrupt_Id_Type)
   is
      Cpu_Id              : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      Old_Mmio_Range      : HiRTOS.Memory_Protection.Memory_Range_Type;
   begin
      --HiRTOS.Memory_Protection.Begin_Mmio_Range_Write_Access
      --  (GICR'Address, GICR'Size, Old_Mmio_Range);

      -- TODO
      null;

      --HiRTOS.Memory_Protection.End_Mmio_Range_Access (Old_Mmio_Range);
   end Enable_Interrupt;

   procedure Disable_Interrupt
     (Interrupt_Id : Interrupt_Id_Type)
   is
      Cpu_Id              : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      Old_Mmio_Range      : HiRTOS.Memory_Protection.Memory_Range_Type;
   begin
      --HiRTOS.Memory_Protection.Begin_Mmio_Range_Write_Access
      --  (GICR'Address, GICR'Size, Old_Mmio_Range);

      -- TODO
      null;

      --HiRTOS.Memory_Protection.End_Mmio_Range_Access (Old_Mmio_Range);
   end Disable_Interrupt;

   procedure Interrupt_Handler
   is
      use type Interfaces.Unsigned_16;
      --???Interrupt_Id               : constant Interfaces.Unsigned_16 := Interfaces.Unsigned_16 (ICC_IAR_Value.INTID);
      Cpu_Id : constant Valid_Cpu_Core_Id_Type  := Get_Cpu_Id;
      Old_Cpu_Interrupting_State : Cpu_Register_Type with Unreferenced;
   begin
      --  Enable interrupts at the CPU to support nested interrupts
      HiRTOS_Cpu_Arch_Interface.Enable_Cpu_Interrupting;

      --  Invoke the IRQ-specific interrupt handler:
      --  declare
      --     Interrupt_Handler : Interrupt_Handler_Type renames
      --        Interrupt_Controller_Obj.Interrupt_Handlers (Cpu_Id, Interrupt_Id);
      --  begin
      --     pragma Assert (Interrupt_Handler.Interrupt_Handler_Entry_Point /= null);
      --     Interrupt_Handler.Interrupt_Handler_Entry_Point (Interrupt_Handler.Interrupt_Handler_Arg);
      --  end;

      --  Disable interrupts at the CPU before returning:
      Old_Cpu_Interrupting_State :=
        HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      --
      --  Notify the interrupt controller that processing for the last interrupt
      --  received by the calling CPU core has been completed, so that another
      --  interrupt of the same priority or lower can be received by this CPU core:
      --
      HiRTOS_Cpu_Arch_Interface.Strong_Memory_Barrier;
      -- TODO
   end Interrupt_Handler;

   function Get_Highest_Interrupt_Priority_Disabled return Interrupt_Priority_Type is
   begin
      return Interrupt_Priority_Type'Last; --???
   end Get_Highest_Interrupt_Priority_Disabled;

   procedure Set_Highest_Interrupt_Priority_Disabled (Priority : Interrupt_Priority_Type) is
   begin
      null; --???
   end Set_Highest_Interrupt_Priority_Disabled;

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

end HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
