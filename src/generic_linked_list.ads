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
--  @summary Generic linked list
--
generic
   type List_Id_Type is private;
   type Node_Payload_Type is limited private;
package Generic_Linked_List with SPARK_Mode => On is
   use type Interfaces.Unsigned_32;

   type List_Anchor_Type is private;

   type List_Node_Type is limited private;

   type List_Node_Pointer_Type is access all List_Node_Type;

   type Node_Payload_Pointer_Type is access all Node_Payload_Type;

   function List_Initialized (List_Anchor : List_Anchor_Type) return Boolean
      with Ghost => True;

   function List_Length (List_Anchor : List_Anchor_Type) return Interfaces.Unsigned_32
      with Ghost => True;

   function Node_In_List (List_Node : List_Node_Type) return Boolean
      with Ghost => True;

   procedure List_Init (List_Anchor : in out List_Anchor_Type;
                        List_Id : List_Id_Type)
      with
         Global => null,
         Depends => (List_Anchor =>+ List_Id),
         Pre => not List_Initialized (List_Anchor),
         Post => List_Initialized (List_Anchor) and then
                 List_Length (List_Anchor) = 0;

   function List_Is_Empty (List_Anchor : List_Anchor_Type) return Boolean
      with
         Global => null,
         Depends => (List_Is_Empty'Result => List_Anchor),
         Pre => List_Initialized (List_Anchor);

   procedure List_Add_Tail (List_Anchor : in out List_Anchor_Type;
                            List_Node_Pointer : List_Node_Pointer_Type)
      with
         Global => null,
         Depends => (List_Anchor =>+ List_Node_Pointer,
                     List_Node_Pointer => List_Anchor),
         Pre => List_Initialized (List_Anchor) and then
                List_Node_Pointer /= null and then
                not Node_In_List (List_Node_Pointer.all),
         Post => List_Length (List_Anchor) = List_Length (List_Anchor'Old) + 1
                 and then
                 Node_In_List (List_Node_Pointer.all);

   procedure List_Remove_Head (List_Anchor : in out List_Anchor_Type;
                               List_Node_Pointer : out List_Node_Pointer_Type)
      with
         Global => null,
         Depends => (List_Anchor =>+ null,
                     List_Node_Pointer => List_Anchor),
         Pre => List_Initialized (List_Anchor) and then
                List_Length (List_Anchor) /= 0,
         Post => List_Length (List_Anchor) = List_Length (List_Anchor'Old) - 1
                 and then
                 List_Node_Pointer /= null
                 and then
                 not Node_In_List (List_Node_Pointer.all);

   procedure List_Remove_This (List_Anchor : in out List_Anchor_Type;
                               List_Node_Pointer : List_Node_Pointer_Type)
      with
         Global => null,
         Depends => (List_Anchor =>+ List_Node_Pointer,
                     List_Node_Pointer => List_Anchor),
         Pre => List_Initialized (List_Anchor) and then
                List_Length (List_Anchor) /= 0 and then
                List_Node_Pointer /= null and then
                Node_In_List (List_Node_Pointer.all),
         Post => List_Length (List_Anchor) = List_Length (List_Anchor'Old) - 1
                 and then
                 not Node_In_List (List_Node_Pointer.all);

   generic
      with procedure Node_Visitor (Node_Pointer : List_Node_Pointer_Type);
   procedure List_Traverse (List_Anchor : in out List_Anchor_Type)
      with
         Pre => List_Initialized (List_Anchor);

   function Get_Node_Payload_Pointer (List_Node_Pointer : List_Node_Pointer_Type)
      return Node_Payload_Pointer_Type
      with Pre => List_Node_Pointer /= null;

private

   type List_Anchor_Type is record
      Initialized : Boolean := False;
      List_Id : List_Id_Type;
      Head : List_Node_Pointer_Type := null;
      Tail : List_Node_Pointer_Type := null;
      Length : Interfaces.Unsigned_32 := 0;
   end record with
      Type_Invariant => List_Anchor_Invariant (List_Anchor_Type);

   type List_Node_Type is limited record
      Next : List_Node_Pointer_Type := null;
      Prev : List_Node_Pointer_Type := null;
      In_List : Boolean := False;
      List_Id : List_Id_Type;
      Payload : aliased Node_Payload_Type;
   end record with Type_Invariant =>
      (if not List_Node_Type.In_List then
         (List_Node_Type.Next = null and then List_Node_Type.Prev = null));

   function List_Anchor_Invariant (List_Anchor : List_Anchor_Type) return Boolean is
      (if List_Anchor.Length = 0 then
         (List_Anchor.Head = null and then
          List_Anchor.Tail = null)
      else
         (List_Anchor.Head /= null and then
          List_Anchor.Tail /= null and then
          (if List_Anchor.Head = List_Anchor.Tail then
             List_Anchor.Length = 1)));

   function List_Initialized (List_Anchor : List_Anchor_Type) return Boolean
      is (List_Anchor.Initialized);

   function List_Length (List_Anchor : List_Anchor_Type) return Interfaces.Unsigned_32
      is (List_Anchor.Length);

   function Node_In_List (List_Node : List_Node_Type) return Boolean is
      (List_Node.In_List);

   function List_Is_Empty (List_Anchor : List_Anchor_Type) return Boolean is
      (List_Anchor.Length = 0);

   function Get_Node_Payload_Pointer (List_Node_Pointer : List_Node_Pointer_Type)
      return Node_Payload_Pointer_Type is
      (List_Node_Pointer.Payload'Access);

end Generic_Linked_List;
