--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.Timer;
with System.Storage_Elements;

private package HiRTOS.Timer_Private with
  SPARK_Mode => On
is
   procedure Do_Software_Timers_Bookkeeping
      with Pre => HiRTOS.Current_Execution_Context_Is_Interrupt;

   procedure Timer_Thread_Proc (Arg : System.Address) with
     Convention => C;

   function Initialized (Timer_Id : Valid_Timer_Id_Type) return Boolean
      with Ghost;

   --
   --  Number of spokes of a timer wheel
   --
   type Timer_Wheel_Spoke_Index_Type is range 0 .. HiRTOS_Config_Parameters.Timer_Wheel_Num_Spokes;

   subtype Valid_Timer_Wheel_Spoke_Index_Type is
     Timer_Wheel_Spoke_Index_Type range Timer_Wheel_Spoke_Index_Type'First ..
         Timer_Wheel_Spoke_Index_Type'Last - 1;

   Invalid_Timer_Wheel_Spoke_Index : constant Timer_Wheel_Spoke_Index_Type :=
     Timer_Wheel_Spoke_Index_Type'Last;

   type Timer_Wheel_Revolutions_Count_Type is new Interfaces.Unsigned_32;

   package Timer_List_Package is new Generic_Linked_List
     (List_Id_Type        => Timer_Wheel_Spoke_Index_Type,
      Null_List_Id        => Invalid_Timer_Wheel_Spoke_Index,
      Element_Id_Type     => Timer_Id_Type,
      Null_Element_Id     => Invalid_Timer_Id);

   --
   --  Software timer object
   --
   --  @field Initialized: flag indicating if the timer object has been initialized.
   --  @field Periodic: flag indicating if the timer is periodic or one-shot
   --  @field Running: flag indicating if the timer is currenty running
   --  @field Id: timer Id
   --  @Timer Timer_Wheel_Revolutions: Total number of timer wheel revolutions before
   --  the timer expires.
   --  @Timer Timer_Wheel_Revolutions_Left: Number of timer wheel revolutions left
   --  before timer expiration.
   --  @Expiration_Callback: Poinrer to timer expiration callback
   --  @Expiration_Callback_Arg: Callback-specific argument
   --  @Wheel_Spoke_Index: Timer wheel hash table index of the hash chain where this
   --  timer was inserted.
   --
   type Timer_Type is limited record
      Initialized : Boolean := False;
      Periodic : Boolean := False;
      Running : Boolean := False;
      Id : Timer_Id_Type := Invalid_Timer_Id;
      Timer_Wheel_Revolutions : Timer_Wheel_Revolutions_Count_Type := 0;
      Timer_Wheel_Revolutions_Left : Timer_Wheel_Revolutions_Count_Type := 0;
      Expiration_Callback : HiRTOS.Timer.Timer_Expiration_Callback_Type := null;
      Expiration_Callback_Arg : System.Storage_Elements.Integer_Address;
      Wheel_Spoke_Index : Timer_Wheel_Spoke_Index_Type := Invalid_Timer_Wheel_Spoke_Index;
   end record with
     Alignment => HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment;
    --  Type_Invariant => Timer_Wheel_Revolutions_Left <= Timer_Wheel_Revolutions;

   type Timer_Array_Type is array (Valid_Timer_Id_Type) of Timer_Type;

   type Timer_Wheel_Spokes_Hash_Table_Type is
     array
       (Valid_Timer_Wheel_Spoke_Index_Type) of Timer_List_Package.List_Anchor_Type;

   --
   --  Timer wheel object
   --
   --  @field Wheel_Spokes_Hash_Table: array of hash chains, one hash chain per wheel spoke
   --  @field Current_Wheel_Spoke_Index: index of the current entry in `Wheel_Spokes_Hash_Table`
   --
   type Timer_Wheel_Type is limited record
      Wheel_Spokes_Hash_Table   : Timer_Wheel_Spokes_Hash_Table_Type;
      Current_Wheel_Spoke_Index : Valid_Timer_Wheel_Spoke_Index_Type :=
         Valid_Timer_Wheel_Spoke_Index_Type'First;
   end record;

   procedure Initialize_Timer_Wheel (Timer_Wheel : out Timer_Wheel_Type);

   procedure Process_Timer_Wheel_Hash_Chain (Timer_Wheel_Hash_Chain : in out Timer_List_Package.List_Anchor_Type);

end HiRTOS.Timer_Private;
