--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Interrupt controller driver
--  for ESP32-C3
--

with HiRTOS_Cpu_Multi_Core_Interface;
private with HiRTOS.Memory_Protection;
private with System;
private with Interfaces;

package HiRTOS_Cpu_Arch_Interface.Interrupt_Controller with
  SPARK_Mode => On
is
   Max_Num_Interrupts_Supported : constant := 31;

   type Interrupt_Id_Type is range 0 .. Max_Num_Interrupts_Supported;

   subtype Valid_Interrupt_Id_Type is
     Interrupt_Id_Type range Interrupt_Id_Type'First + 1 ..
         Interrupt_Id_Type'Last;

   Invalid_Interrupt_Id : constant Interrupt_Id_Type := Interrupt_Id_Type'First;

   --  Higher priority value means higher priority
   type Interrupt_Priority_Type is range 1 .. 15;

   Highest_Interrupt_Priority : constant Interrupt_Priority_Type :=
     Interrupt_Priority_Type'Last;

   Lowest_Interrupt_Priority : constant Interrupt_Priority_Type :=
     Interrupt_Priority_Type'First;

   type Interrupt_Handler_Entry_Point_Type is
     access procedure (Arg : System.Address);

   type Interrupt_Trigger_Mode_Type is
     (Interrupt_Level_Sensitive, Interrupt_Edge_Triggered);

   ----------------------------------------------------------------------------
   --  Public Subprograms
   ----------------------------------------------------------------------------

   function Per_Cpu_Initialized return Boolean with
     Ghost;

   procedure Initialize with
     Pre  => not Per_Cpu_Initialized and then Cpu_In_Privileged_Mode,
     Post => Per_Cpu_Initialized;

   procedure Configure_Interrupt
     (Interrupt_Id                  : Valid_Interrupt_Id_Type;
      Priority                      : Interrupt_Priority_Type;
      Trigger_Mode                  : Interrupt_Trigger_Mode_Type;
      Interrupt_Handler_Entry_Point : Interrupt_Handler_Entry_Point_Type;
      Interrupt_Handler_Arg : System.Address := System.Null_Address) with
     Pre => Per_Cpu_Initialized and then Cpu_In_Privileged_Mode;

   procedure Enable_Interrupt
     (Interrupt_Id : Valid_Interrupt_Id_Type) with
     Pre => Per_Cpu_Initialized and then Cpu_In_Privileged_Mode;

   procedure Disable_Interrupt
     (Interrupt_Id : Valid_Interrupt_Id_Type) with
     Pre => Per_Cpu_Initialized and then Cpu_In_Privileged_Mode;

   procedure Interrupt_Handler (Interrupt_Id : Valid_Interrupt_Id_Type) with
     Pre => Per_Cpu_Initialized and then
            Cpu_In_Privileged_Mode and then
            Cpu_Interrupting_Disabled,
     Post => Cpu_Interrupting_Disabled;

   function Get_Highest_Interrupt_Priority_Disabled return Interrupt_Priority_Type
      with Pre => Cpu_In_Privileged_Mode;

   procedure Set_Highest_Interrupt_Priority_Disabled (Priority : Interrupt_Priority_Type)
      with Pre => Cpu_In_Privileged_Mode;

private
   pragma SPARK_Mode (Off);
   use HiRTOS_Cpu_Multi_Core_Interface;

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

   type Interrupt_Handler_Array_Type is
     array (Valid_Cpu_Core_Id_Type, Valid_Interrupt_Id_Type) of Interrupt_Handler_Type;

   type Interrupt_Controller_Type is record
      Per_Cpu_Initialized_Flags    : HiRTOS_Cpu_Multi_Core_Interface.Atomic_Counter_Type;
      Max_Number_Interrupt_Sources : Interfaces.Unsigned_16;
      Spinlock : HiRTOS_Cpu_Multi_Core_Interface.Spinlock_Type;
      Interrupt_Handlers  : Interrupt_Handler_Array_Type;
   end record with
     Warnings => Off;

   Interrupt_Controller_Obj : Interrupt_Controller_Type;

   function Per_Cpu_Initialized return Boolean is
     ((HiRTOS_Cpu_Multi_Core_Interface.Atomic_Load (Interrupt_Controller_Obj.Per_Cpu_Initialized_Flags) and
       Bit_Mask (Bit_Index_Type (Get_Cpu_Id))) /= 0);

end HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
