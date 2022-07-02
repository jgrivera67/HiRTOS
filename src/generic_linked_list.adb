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
package body Generic_Linked_List with SPARK_Mode => On is

   procedure List_Init (List_Anchor : in out List_Anchor_Type;
                        List_Id : List_Id_Type) is
   begin
      List_Anchor.List_Id := List_Id;
      List_Anchor.Initialized := True;
   end List_Init;

   procedure List_Add_Tail (List_Anchor : in out List_Anchor_Type;
                            Node_Pointer : Node_Pointer_Type)
      with Refined_Post =>
         List_Anchor.Tail = Node_Pointer
         and then
         (if List_Anchor.Length = 1 then
             List_Anchor.Head = List_Anchor.Tail
          else
             (List_Anchor.Length > 1 and then
              List_Anchor.Head /= List_Anchor.Tail))
   is
   begin
      Node_Pointer.Next := null;
      Node_Pointer.Prev := List_Anchor.Tail;
      Node_Pointer.List_Id := List_Anchor.List_Id;
      Node_Pointer.In_List := True;

      if List_Anchor.Tail = null then
         List_Anchor.Head := Node_Pointer;
      end if;

      List_Anchor.Tail := Node_Pointer;
      List_Anchor.Length :=  @ + 1;
   end List_Add_Tail;

   procedure List_Add_Head (List_Anchor : in out List_Anchor_Type;
                            Node_Pointer : Node_Pointer_Type)
      with Refined_Post =>
         List_Anchor.Head = Node_Pointer
         and then
         (if List_Anchor.Length = 1 then
             List_Anchor.Head = List_Anchor.Tail
          else
             (List_Anchor.Length > 1 and then
              List_Anchor.Head /= List_Anchor.Tail))
   is
   begin
      Node_Pointer.Next := List_Anchor.Head;
      Node_Pointer.Prev := null;
      Node_Pointer.List_Id := List_Anchor.List_Id;
      Node_Pointer.In_List := True;

      if List_Anchor.Head = null then
         List_Anchor.Tail := Node_Pointer;
      end if;

      List_Anchor.Head := Node_Pointer;
      List_Anchor.Length :=  @ + 1;
   end List_Add_Head;

   procedure List_Remove_Head (List_Anchor : in out List_Anchor_Type;
                               Node_Pointer : out Node_Pointer_Type)
      with Refined_Post =>
         Node_Pointer = List_Anchor'Old.Head
   is
      Next_Head : constant Node_Pointer_Type := List_Anchor.Head.Next;
   begin
      Node_Pointer := List_Anchor.Head;
      List_Anchor.Head := Next_Head;
      Next_Head.Prev := null;
      List_Anchor.Length := @ - 1;
      if List_Anchor.Head = null then
         List_Anchor.Tail := null;
      end if;

      Node_Pointer.Next := null;
      Node_Pointer.Prev := null;
      Node_Pointer.In_List := False;
   end List_Remove_Head;

   procedure List_Remove_This (List_Anchor : in out List_Anchor_Type;
                               Node_Pointer : Node_Pointer_Type) is
      Prev_Node : constant Node_Pointer_Type :=  Node_Pointer.Prev;
      Next_Node : constant Node_Pointer_Type :=  Node_Pointer.Next;
   begin
      if Node_Pointer = List_Anchor.Head then
         List_Anchor.Head := Next_Node;
      end if;

      if Node_Pointer = List_Anchor.Tail then
         List_Anchor.Tail := Prev_Node;
      end if;

      List_Anchor.Length := @ - 1;
      Node_Pointer.Next := null;
      Node_Pointer.Prev := null;
      Node_Pointer.In_List := False;
   end List_Remove_This;

   procedure List_Traverse (List_Anchor : in out List_Anchor_Type) is
      Node_Pointer : Node_Pointer_Type := List_Anchor.Head;
      Next_Node_Pointer : Node_Pointer_Type;
      List_Length : constant Interfaces.Unsigned_32 := List_Anchor.Length;
   begin

      for I in 0 .. List_Length loop
         pragma Loop_Invariant (
            Node_Pointer.List_Id = List_Anchor.List_Id
            and then
            (Node_Pointer.Prev = null or else Node_Pointer.Prev.Next = Node_Pointer)
            and then
            (Node_Pointer.Next = null or else Node_Pointer.Next.Prev = Node_Pointer)
         );

         --
         --  NOTE: Save next pointer in case this node is removed from the list
         --  by Node_Visitor.
         --
         Next_Node_Pointer := Node_Pointer.Next;
         Node_Visitor (Node_Pointer);
         Node_Pointer := Next_Node_Pointer;
      end loop;
   end List_Traverse;

end Generic_Linked_List;