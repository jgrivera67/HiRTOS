--
--  Copyright (c) 2021, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
--

with Interfaces;

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
   use type Interfaces.Unsigned_32;

   type List_Anchor_Type is private;

   function List_Initialized
     (List_Anchor : List_Anchor_Type) return Boolean with
     Ghost => True;

   function List_Length
     (List_Anchor : List_Anchor_Type) return Interfaces.Unsigned_32 with
     Ghost => True;

   function Get_Containing_List (Element_Id : Element_Id_Type) return List_Id_Type
      with Ghost => True;

   procedure List_Init
     (List_Anchor : in out List_Anchor_Type; List_Id : List_Id_Type) with
     Global => null, Depends => (List_Anchor =>+ List_Id),
     Pre    =>
      List_Id /= Null_List_Id,
     Post =>
      List_Initialized (List_Anchor) and then List_Is_Empty (List_Anchor);

   function List_Is_Empty (List_Anchor : List_Anchor_Type) return Boolean with
     Global => null, Depends => (List_Is_Empty'Result => List_Anchor),
     Pre    => List_Initialized (List_Anchor);

   procedure List_Add_Tail
     (List_Anchor : in out List_Anchor_Type; Element_Id : Element_Id_Type) with
     Global => null, Depends => (List_Anchor =>+ Element_Id),
     Pre    =>
      List_Initialized (List_Anchor) and then Element_Id /= Null_Element_Id
      and then Get_Containing_List (Element_Id) = Null_List_Id,
     Post =>
      List_Length (List_Anchor) = List_Length (List_Anchor'Old) + 1
      and then Get_Containing_List (Element_Id) /= Null_List_Id;

   procedure List_Add_Head
     (List_Anchor : in out List_Anchor_Type; Element_Id : Element_Id_Type) with
     Global => null, Depends => (List_Anchor =>+ Element_Id),
     Pre    =>
      List_Initialized (List_Anchor) and then Element_Id /= Null_Element_Id
      and then Get_Containing_List (Element_Id) = Null_List_Id,
     Post =>
      List_Length (List_Anchor) = List_Length (List_Anchor'Old) + 1
      and then Get_Containing_List (Element_Id) /= Null_List_Id;

   procedure List_Remove_Head
     (List_Anchor : in out List_Anchor_Type;
      Element_Id  :    out Element_Id_Type) with
     Global  => null,
     Depends => (List_Anchor =>+ null, Element_Id => List_Anchor),
     Pre     =>
      List_Initialized (List_Anchor) and then List_Length (List_Anchor) /= 0,
     Post =>
      List_Length (List_Anchor) = List_Length (List_Anchor'Old) - 1
      and then Element_Id /= Null_Element_Id
      and then Get_Containing_List (Element_Id) = Null_List_Id;

   procedure List_Remove_This
     (List_Anchor : in out List_Anchor_Type; Element_Id : Element_Id_Type) with
     Global => null, Depends => (List_Anchor =>+ Element_Id),
     Pre    =>
      List_Initialized (List_Anchor) and then List_Length (List_Anchor) /= 0
      and then Element_Id /= Null_Element_Id
      and then Get_Containing_List (Element_Id) /= Null_List_Id,
     Post =>
      List_Length (List_Anchor) = List_Length (List_Anchor'Old) - 1
      and then Get_Containing_List (Element_Id) = Null_List_Id;

   generic
      with procedure Element_Visitor
        (List_Anchor : in out List_Anchor_Type; Element_Id : Element_Id_Type);
   procedure List_Traverse (List_Anchor : in out List_Anchor_Type) with
     Pre => List_Initialized (List_Anchor);

private

   type List_Anchor_Type is record
      List_Id : List_Id_Type := Null_List_Id;
      Head    : Element_Id_Type := Null_Element_Id;
      Tail    : Element_Id_Type := Null_Element_Id;
      Length  : Interfaces.Unsigned_32 := 0;
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
   --  the maximum number of nodes that we need is Valid_Element_Id_Type'Range
   --
   List_Nodes : array (Valid_Element_Id_Type) of List_Node_Type;

   function List_Initialized (List_Anchor : List_Anchor_Type) return Boolean is
     (List_Anchor.List_Id /= Null_List_Id);

   function List_Length
     (List_Anchor : List_Anchor_Type) return Interfaces.Unsigned_32 is
     (List_Anchor.Length);

   function Get_Containing_List (Element_Id : Element_Id_Type) return List_Id_Type is
      (List_Nodes (Element_Id).Containing_List_Id);

   function List_Is_Empty (List_Anchor : List_Anchor_Type) return Boolean is
     (List_Anchor.Length = 0);

end Generic_Linked_List;
