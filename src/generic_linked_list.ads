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
   type Node_Id_Type is private;
   Invalid_Node_Id : Node_Id_Type;
   with procedure Set_Next (Node_Id : Node_Id_Type; Next_Node_Id : Node_Id_Type);
   with function Get_Next (Node_Id : Node_Id_Type) return Node_Id_Type;
   with procedure Set_Prev (Node_Id : Node_Id_Type; Prev_Node_Id : Node_Id_Type);
   with function Get_Prev (Node_Id : Node_Id_Type) return Node_Id_Type;
package Generic_Linked_List with SPARK_Mode => On is
   type List_Anchor_Type is limited private;

   subtype Link_Type is Node_Id_Type;

   Null_Link : constant Link_Type := Invalid_Node_Id;

   type List_Node_Type is limited record
      Next : Link_Type := Null_Link;
      Prev : Link_Type := Null_Link;
      In_List : Boolean := False;
      List_Id : List_Id_Type;
   end record;

   procedure List_Init (List_Anchor : in out List_Anchor_Type;
                        List_Id : List_Id_Type);

   procedure List_Add_Tail (List_Anchor : in out List_Anchor_Type;
                           Node_Id : Node_Id_Type);

   procedure List_Remove_Head (List_Anchor : in out List_Anchor_Type;
                              Node_Id : out Node_Id_Type);

   procedure List_Remove_This (List_Anchor : in out List_Anchor_Type;
                              Node_Id : Node_Id_Type);

   generic
      with procedure Node_Visitor (Node_Id : Node_Id_Type);
   procedure List_Traverse (List_Anchor : in out List_Anchor_Type);

private
   use type Interfaces.Unsigned_32;

   type List_Anchor_Type is limited record
      Initialized : Boolean := False;
      List_Id : List_Id_Type;
      Head : Link_Type := Null_Link;
      Tail : Link_Type := Null_Link;
      Length : Interfaces.Unsigned_32 := 0;
   end record with
      Type_Invariant => List_Anchor_Invariant (List_Anchor_Type);

   function List_Anchor_Invariant (List_Anchor : List_Anchor_Type) return Boolean is
      (if List_Anchor.Length = 0 then
         (List_Anchor.Head = Null_Link and then
         List_Anchor.Tail = Null_Link)
      else
         (List_Anchor.Head /= Null_Link and then
         List_Anchor.Tail /= Null_Link and then
         (if List_Anchor.Head = List_Anchor.Tail then
            List_Anchor.Length = 1)));
end Generic_Linked_List;
