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
   end List_Init;

   procedure List_Add_Tail (List_Anchor : in out List_Anchor_Type;
                            Element_Id : Element_Id_Type)
      with Refined_Post =>
         List_Anchor.Tail = Element_Id
         and then
         (if List_Anchor.Length = 1 then
             List_Anchor.Head = List_Anchor.Tail
          else
             (List_Anchor.Length > 1 and then
              List_Anchor.Head /= List_Anchor.Tail))
   is
   begin
      Set_Next_Element (Element_Id, Null_Element_Id);
      Set_Prev_Element (Element_Id, List_Anchor.Tail);
      Set_Containing_List (Element_Id, List_Anchor.List_Id);

      if List_Anchor.Tail = Null_Element_Id then
         List_Anchor.Head := Element_Id;
      end if;

      List_Anchor.Tail := Element_Id;
      List_Anchor.Length :=  @ + 1;
   end List_Add_Tail;

   procedure List_Add_Head (List_Anchor : in out List_Anchor_Type;
                            Element_Id : Element_Id_Type)
      with Refined_Post =>
         List_Anchor.Head = Element_Id
         and then
         (if List_Anchor.Length = 1 then
             List_Anchor.Head = List_Anchor.Tail
          else
             (List_Anchor.Length > 1 and then
              List_Anchor.Head /= List_Anchor.Tail))
   is
   begin
      Set_Next_Element (Element_Id, List_Anchor.Head);
      Set_Prev_Element (Element_Id, Null_Element_Id);
      Set_Containing_List (Element_Id, List_Anchor.List_Id);

      if List_Anchor.Head = Null_Element_Id then
         List_Anchor.Tail := Element_Id;
      end if;

      List_Anchor.Head := Element_Id;
      List_Anchor.Length :=  @ + 1;
   end List_Add_Head;

   procedure List_Remove_Head (List_Anchor : in out List_Anchor_Type;
                               Element_Id : out Element_Id_Type)
      with Refined_Post =>
         Element_Id = List_Anchor'Old.Head
   is
      Next_Head : constant Element_Id_Type := Get_Next_Element (List_Anchor.Head);
   begin
      Element_Id := List_Anchor.Head;
      List_Anchor.Head := Next_Head;
      Set_Prev_Element (Next_Head, Null_Element_Id);
      List_Anchor.Length := @ - 1;
      if List_Anchor.Head = Null_Element_Id then
         List_Anchor.Tail := Null_Element_Id;
      end if;

      Set_Next_Element (Element_Id, Null_Element_Id);
      Set_Prev_Element (Element_Id, Null_Element_Id);
      Set_Containing_List (Element_Id, Null_List_Id);
   end List_Remove_Head;

   procedure List_Remove_This (List_Anchor : in out List_Anchor_Type;
                               Element_Id : Element_Id_Type) is
      Prev_Element_Id : constant Element_Id_Type := Get_Prev_Element (Element_Id);
      Next_Element_Id : constant Element_Id_Type := Get_Next_Element (Element_Id);
   begin
      if Element_Id = List_Anchor.Head then
         List_Anchor.Head := Next_Element_Id;
      end if;

      if Element_Id = List_Anchor.Tail then
         List_Anchor.Tail := Prev_Element_Id;
      end if;

      List_Anchor.Length := @ - 1;
      Set_Next_Element (Element_Id, Null_Element_Id);
      Set_Prev_Element (Element_Id, Null_Element_Id);
      Set_Containing_List (Element_Id, Null_List_Id);
   end List_Remove_This;

   procedure List_Traverse (List_Anchor : in out List_Anchor_Type) is
      Element_Id : Element_Id_Type := List_Anchor.Head;
      Next_Element_Id : Element_Id_Type;
      List_Length : constant Interfaces.Unsigned_32 := List_Anchor.Length;
   begin
      for I in 0 .. List_Length - 1 loop
         pragma Loop_Invariant (
            Get_Containing_List (Element_Id) = List_Anchor.List_Id
            and then
            (Get_Prev_Element (Element_Id) = Null_Element_Id or else
             Get_Next_Element (Get_Prev_Element (Element_Id)) = Element_Id)
            and then
            (Get_Next_Element (Element_Id) = Null_Element_Id or else
             Get_Prev_Element (Get_Next_Element (Element_Id)) = Element_Id)
         );

         --
         --  NOTE: Save next pointer in case this node is removed from the list
         --  by Node_Visitor.
         --
         Next_Element_Id := Get_Next_Element (Element_Id);
         Element_Visitor (Element_Id);
         Element_Id := Next_Element_Id;
      end loop;

      pragma Assert (Element_Id = Null_Element_Id);
   end List_Traverse;

end Generic_Linked_List;