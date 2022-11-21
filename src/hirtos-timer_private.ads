--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--
private package HiRTOS.Timer_Private with
  SPARK_Mode => On
is
   --
   --  Number of spokes of a timer wheel. It must be a power of 2.
   --
   Timer_Wheel_Num_Spokes : constant := 128;

   type Timer_Wheel_Spoke_Index_Type is range 0 .. Timer_Wheel_Num_Spokes;

   subtype Valid_Timer_Wheel_Spoke_Index_Type is
     Timer_Wheel_Spoke_Index_Type range Timer_Wheel_Spoke_Index_Type'First ..
         Timer_Wheel_Spoke_Index_Type'Last - 1;

   Invalid_Timer_Wheel_Spoke_Index : constant Timer_Wheel_Spoke_Index_Type :=
     Timer_Wheel_Spoke_Index_Type'Last;

   package Timer_List_Package is new Generic_Linked_List
     (List_Id_Type        => Timer_Wheel_Spoke_Index_Type,
      Null_List_Id        => Invalid_Timer_Wheel_Spoke_Index,
      Element_Id_Type     => Timer_Id_Type,
      Null_Element_Id     => Invalid_Timer_Id);

   --
   --  Software timer object
   --
   --  @field Initialized: flag indicating if the timer object has been initialized.
   --  @field Id: timer Id
   --  @List_Node: node in a linked list of timers
   --
   type Timer_Type is limited record
      Initialized : Boolean := False;
      Id : Timer_Id_Type := Invalid_Timer_Id;
   end record;

   type Timer_Array_Type is array (Valid_Timer_Id_Type) of Timer_Type;

   --  type Timer_Wheel_Spokes_Hash_Table_Type is
   --    array
   --      (Valid_Timer_Wheel_Spoke_Index_Type) of Timer_List_Package
   --      .List_Anchor_Type;

   --
   --  Timer wheel object
   --
   --  @field Wheel_Spokes_Hash_Table: array of hash chains, one hash chain per wheel spoke
   --  @field Current_Wheel_Spoke_Index: index of the current entry in `Wheel_Spokes_Hash_Table`
   --
   type Timer_Wheel_Type is limited record
      --Wheel_Spokes_Hash_Table   : Timer_Wheel_Spokes_Hash_Table_Type;
      Current_Wheel_Spoke_Index : Valid_Timer_Wheel_Spoke_Index_Type :=
         Valid_Timer_Wheel_Spoke_Index_Type'First;
   end record;

   procedure Initialize_Timer_Wheel (Timer_Wheel : out Timer_Wheel_Type);

end HiRTOS.Timer_Private;
