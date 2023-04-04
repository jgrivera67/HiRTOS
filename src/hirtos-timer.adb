--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.Interrupt_Handling;
with HiRTOS.RTOS_Private;
with HiRTOS.Timer_Private;
with HiRTOS_Cpu_Multi_Core_Interface;
with HiRTOS_Cpu_Arch_Interface.Interrupts;

package body HiRTOS.Timer is
   use HiRTOS.Interrupt_Handling;
   use HiRTOS.RTOS_Private;
   use HiRTOS.Timer_Private;
   use HiRTOS_Cpu_Multi_Core_Interface;
   use HiRTOS_Cpu_Arch_Interface;

   procedure Initialize_Timer (Timer_Obj : out Timer_Type; Timer_Id : Valid_Timer_Id_Type);

   -----------------------------------------------------------------------------
   --  Public Subprograms
   -----------------------------------------------------------------------------

   function Initialized (Timer_Id : Valid_Timer_Id_Type) return Boolean is
      (HiRTOS_Obj.Timer_Instances (Timer_Id).Initialized);

   function Timer_Running (Timer_Id : Valid_Timer_Id_Type) return Boolean is
      (HiRTOS_Obj.Timer_Instances (Timer_Id).Running);

   procedure Create_Timer (Timer_Id : out Valid_Timer_Id_Type) is
   begin
      RTOS_Private.Allocate_Timer_Object (Timer_Id);
      Initialize_Timer (HiRTOS_Obj.Timer_Instances (Timer_Id), Timer_Id);
   end Create_Timer;

   procedure Start_Timer (Timer_Id : Valid_Timer_Id_Type;
                          Expiration_Time_Us : Time_Us_Type;
                          Expiration_Callback : Timer_Expiration_Callback_Type;
                          Expiration_Callback_Arg : System.Storage_Elements.Integer_Address;
                          Periodic : Boolean := False) is
      Timer_Obj : Timer_Type renames HiRTOS_Obj.Timer_Instances (Timer_Id);
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;

      --
      --  NOTE: We need to serialize with all interrupts, in case an ISR,
      --  with higher priority than the tick timer ISR, starts a timer
      --
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      declare
         use type Interfaces.Unsigned_32;
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
            HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
         Expiration_Time_Ticks : constant Timer_Ticks_Count_Type :=
            Timer_Ticks_Count_Type (
               Expiration_Time_Us / HiRTOS_Config_Parameters.Tick_Timer_Period_Us);
         --
         --  NOTE: The ticks delta calculation below works even if
         --  Expiration_Time_Ticks < RTOS_Cpu_Instance.Timer_Ticks_Since_Boot,
         --  since we are using unsigned modulo-32 arithmetic.
         --
         Delta_Timer_Ticks_Before_Expiration : constant Timer_Ticks_Count_Type :=
            Expiration_Time_Ticks - RTOS_Cpu_Instance.Timer_Ticks_Since_Boot;
         Wheel_Spoke_Index : constant Valid_Timer_Wheel_Spoke_Index_Type :=
            Valid_Timer_Wheel_Spoke_Index_Type (
               (Interfaces.Unsigned_32 (RTOS_Cpu_Instance.Timer_Wheel.Current_Wheel_Spoke_Index) +
                Interfaces.Unsigned_32 (Delta_Timer_Ticks_Before_Expiration)) mod
               HiRTOS_Config_Parameters.Timer_Wheel_Num_Spokes);
         Timer_Wheel_Hash_Chain : Timer_List_Package.List_Anchor_Type renames
            RTOS_Cpu_Instance.Timer_Wheel.Wheel_Spokes_Hash_Table (Wheel_Spoke_Index);
      begin
         Timer_Obj.Expiration_Callback := Expiration_Callback;
         Timer_Obj.Expiration_Callback_Arg := Expiration_Callback_Arg;
         Timer_Obj.Periodic := Periodic;
         Timer_Obj.Timer_Wheel_Revolutions :=
            Timer_Wheel_Revolutions_Count_Type (Delta_Timer_Ticks_Before_Expiration /
                                                HiRTOS_Config_Parameters.Timer_Wheel_Num_Spokes);
         Timer_Obj.Timer_Wheel_Revolutions_Left := Timer_Obj.Timer_Wheel_Revolutions;

         Timer_List_Package.List_Add_Tail (Timer_Wheel_Hash_Chain, Timer_Id);
         Timer_Obj.Wheel_Spoke_Index := Wheel_Spoke_Index;
         Timer_Obj.Running := True;
      end;

      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Start_Timer;

   procedure Stop_Timer (Timer_Id : Valid_Timer_Id_Type) is
      Timer_Obj : Timer_Type renames HiRTOS_Obj.Timer_Instances (Timer_Id);
      Old_Atomic_Level : Atomic_Level_Type;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;
      Old_Atomic_Level := HiRTOS.Enter_Atomic_Level (
         HiRTOS.Atomic_Level_Type (Interrupts.Interrupt_Priorities (Interrupts.Generic_Timer_Interrupt_Id)));

      declare
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
            HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
         Wheel_Spoke_Index : constant Valid_Timer_Wheel_Spoke_Index_Type :=
             Timer_Obj.Wheel_Spoke_Index;
         Timer_Wheel_Hash_Chain : Timer_List_Package.List_Anchor_Type renames
            RTOS_Cpu_Instance.Timer_Wheel.Wheel_Spokes_Hash_Table (Wheel_Spoke_Index);
      begin
         if Timer_Obj.Running then
            Timer_List_Package.List_Remove_This (Timer_Wheel_Hash_Chain, Timer_Id);
            Timer_Obj.Wheel_Spoke_Index := Invalid_Timer_Wheel_Spoke_Index;
            Timer_Obj.Running := False;
         end if;
      end;

      HiRTOS.Exit_Atomic_Level (Old_Atomic_Level);
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Stop_Timer;

   -----------------------------------------------------------------------------
   --  Private Subprograms
   -----------------------------------------------------------------------------

   procedure Initialize_Timer (Timer_Obj : out Timer_Type; Timer_Id : Valid_Timer_Id_Type) is
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
   begin
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access (Timer_Obj'Address, Timer_Obj'Size,
                                                              Old_Data_Range);
      Timer_Obj.Id := Timer_Id;
      Timer_Obj.Initialized := True;
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
   end Initialize_Timer;
end HiRTOS.Timer;
