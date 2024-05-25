--
--  Copyright (c) 2021-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary Generic pointerless linked list
--
generic
   type List_Id_Type is private;
   Null_List_Id : List_Id_Type;
   type Element_Id_Type is range <>;
   Null_Element_Id : Element_Id_Type;
package Generic_Linked_List with
  SPARK_Mode => On
is
   type List_Node_Type is limited private;

   type List_Anchor_Type is private;

   type List_Nodes_Type is limited private;

   function List_Initialized
     (List_Anchor : List_Anchor_Type) return Boolean with
     Ghost => True;

   function List_Length
     (List_Anchor : List_Anchor_Type) return Natural with
     Ghost => True;

   function Get_Containing_List (Element_Id : Element_Id_Type;
                                 List_Nodes : List_Nodes_Type) return List_Id_Type
      with Ghost => True;

   procedure List_Init
     (List_Anchor : in out List_Anchor_Type; List_Id : List_Id_Type) with
     Global => null, Depends => (List_Anchor =>+ List_Id),
     Pre    =>
      List_Id /= Null_List_Id,
     Post =>
      List_Initialized (List_Anchor)
      and then List_Is_Empty (List_Anchor);

   function List_Is_Empty (List_Anchor : List_Anchor_Type) return Boolean with
     Global => null, Depends => (List_Is_Empty'Result => List_Anchor),
     Pre    => List_Initialized (List_Anchor);

   procedure List_Add_Tail
     (List_Anchor : in out List_Anchor_Type; Element_Id : Element_Id_Type;
      List_Nodes : in out List_Nodes_Type) with
     Global => null, Depends => (List_Anchor =>+ Element_Id, List_Nodes =>+ Element_Id),
     Pre    =>
      List_Initialized (List_Anchor)
      and then Element_Id /= Null_Element_Id
      and then Get_Containing_List (Element_Id, List_Nodes) = Null_List_Id,
     Post =>
      List_Length (List_Anchor) = List_Length (List_Anchor'Old) + 1
      and then Get_Containing_List (Element_Id, List_Nodes) /= Null_List_Id;

   procedure List_Add_Head
     (List_Anchor : in out List_Anchor_Type; Element_Id : Element_Id_Type;
      List_Nodes : in out List_Nodes_Type) with
     Global => null, Depends => (List_Anchor =>+ Element_Id, List_Nodes =>+ Element_Id),
     Pre    =>
      List_Initialized (List_Anchor)
      and then Element_Id /= Null_Element_Id
      and then Get_Containing_List (Element_Id, List_Nodes) = Null_List_Id,
     Post =>
      List_Length (List_Anchor) = List_Length (List_Anchor'Old) + 1
      and then Get_Containing_List (Element_Id, List_Nodes) /= Null_List_Id;

   procedure List_Remove_Head
     (List_Anchor : in out List_Anchor_Type;
      Element_Id  :    out Element_Id_Type;
      List_Nodes : in out List_Nodes_Type) with
     Global  => null,
     Depends => (List_Anchor =>+ null, List_Nodes =>+ null, Element_Id => List_Anchor),
     Pre     =>
      List_Initialized (List_Anchor)
      and then List_Length (List_Anchor) /= 0,
     Post =>
      List_Length (List_Anchor) = List_Length (List_Anchor'Old) - 1
      and then Element_Id /= Null_Element_Id
      and then Get_Containing_List (Element_Id, List_Nodes) = Null_List_Id;

   procedure List_Remove_This
     (List_Anchor : in out List_Anchor_Type; Element_Id : Element_Id_Type;
      List_Nodes : in out List_Nodes_Type) with
     Global => null, Depends => (List_Anchor =>+ Element_Id, List_Nodes =>+ Element_Id),
     Pre    =>
      List_Initialized (List_Anchor)
      and then List_Length (List_Anchor) /= 0
      and then Element_Id /= Null_Element_Id
      and then Get_Containing_List (Element_Id, List_Nodes) /= Null_List_Id,
     Post =>
      List_Length (List_Anchor) = List_Length (List_Anchor'Old) - 1
      and then Get_Containing_List (Element_Id, List_Nodes) = Null_List_Id;

   generic
      with procedure Element_Visitor
        (List_Anchor : in out List_Anchor_Type; Element_Id : Element_Id_Type;
         List_Nodes : in out List_Nodes_Type);
   procedure List_Traverse (List_Anchor : in out List_Anchor_Type;
                            List_Nodes : in out List_Nodes_Type) with
     Pre => List_Initialized (List_Anchor);

private

   type List_Anchor_Type is record
      List_Id : List_Id_Type := Null_List_Id;
      Head    : Element_Id_Type := Null_Element_Id;
      Tail    : Element_Id_Type := Null_Element_Id;
      Length  : Natural := 0;
   end record with
     Type_Invariant =>
      (if List_Anchor_Type.Length = 0 then
         (List_Anchor_Type.Head = Null_Element_Id
          and then List_Anchor_Type.Tail = Null_Element_Id)
       else
         (List_Anchor_Type.Head /= Null_Element_Id
          and then List_Anchor_Type.Tail /= Null_Element_Id
          and then
          (if List_Anchor_Type.Head = List_Anchor_Type.Tail then
             List_Anchor_Type.Length = 1
           else List_Anchor_Type.Length > 1)));

   type List_Node_Type is limited record
      Next_Element_Id    : Element_Id_Type := Null_Element_Id;
      Prev_Element_Id    : Element_Id_Type := Null_Element_Id;
      Containing_List_Id : List_Id_Type := Null_List_Id;
   end record;

   pragma Compile_Time_Error
     (Null_Element_Id /= Element_Id_Type'Last,
      "Null_element_Id has the wrong value");

   subtype Valid_Element_Id_Type is
     Element_Id_Type range Element_Id_Type'First .. Element_Id_Type'Last - 1;

   --
   --  NOTE: The same element cannot be in more than one list. So,
   --  the maximal set of nodes that we need is `Valid_Element_Id_Type`
   --
   type List_Nodes_Type is array (Valid_Element_Id_Type) of List_Node_Type;

   function List_Initialized (List_Anchor : List_Anchor_Type) return Boolean is
     (List_Anchor.List_Id /= Null_List_Id);

   function List_Length
     (List_Anchor : List_Anchor_Type) return Natural is
     (List_Anchor.Length);

   function Get_Containing_List (Element_Id : Element_Id_Type;
                                 List_Nodes : List_Nodes_Type) return List_Id_Type is
      (List_Nodes (Element_Id).Containing_List_Id);

   function List_Is_Empty (List_Anchor : List_Anchor_Type) return Boolean is
     (List_Anchor.Length = 0);

end Generic_Linked_List;
