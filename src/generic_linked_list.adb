--
--  Copyright (c) 2021-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

package body Generic_Linked_List with SPARK_Mode => On is

   procedure List_Init (List_Anchor : in out List_Anchor_Type;
                        List_Id : List_Id_Type) is
   begin
      List_Anchor.List_Id := List_Id;
      List_Anchor.Head := Null_Element_Id;
      List_Anchor.Tail := Null_Element_Id;
      List_Anchor.Length := 0;
   end List_Init;

   procedure List_Add_Tail (List_Anchor : in out List_Anchor_Type;
                            Element_Id : Element_Id_Type;
                            List_Nodes : in out List_Nodes_Type)
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
      List_Nodes (Element_Id).Next_Element_Id := Null_Element_Id;
      List_Nodes (Element_Id).Prev_Element_Id := List_Anchor.Tail;
      List_Nodes (Element_Id).Containing_List_Id := List_Anchor.List_Id;

      if List_Anchor.Tail = Null_Element_Id then
         List_Anchor.Head := Element_Id;
      else
         List_Nodes (List_Anchor.Tail).Next_Element_Id := Element_Id;
      end if;

      List_Anchor.Tail := Element_Id;
      List_Anchor.Length :=  @ + 1;
   end List_Add_Tail;

   procedure List_Add_Head (List_Anchor : in out List_Anchor_Type;
                            Element_Id : Element_Id_Type;
                            List_Nodes : in out List_Nodes_Type)
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
      List_Nodes (Element_Id).Next_Element_Id := List_Anchor.Head;
      List_Nodes (Element_Id).Prev_Element_Id := Null_Element_Id;
      List_Nodes (Element_Id).Containing_List_Id := List_Anchor.List_Id;

      if List_Anchor.Head = Null_Element_Id then
         List_Anchor.Tail := Element_Id;
      else
         List_Nodes (List_Anchor.Head).Prev_Element_Id := Element_Id;
      end if;

      List_Anchor.Head := Element_Id;
      List_Anchor.Length := @ + 1;
   end List_Add_Head;

   procedure List_Remove_Head (List_Anchor : in out List_Anchor_Type;
                               Element_Id : out Element_Id_Type;
                               List_Nodes : in out List_Nodes_Type)
      with Refined_Post =>
         Element_Id = List_Anchor'Old.Head
   is
      Next_Head : constant Element_Id_Type := List_Nodes (List_Anchor.Head).Next_Element_Id;
   begin
      Element_Id := List_Anchor.Head;
      if Next_Head = Null_Element_Id then
         List_Anchor.Tail := Null_Element_Id;
      else
         List_Nodes (Next_Head).Prev_Element_Id := Null_Element_Id;
      end if;

      List_Anchor.Head := Next_Head;
      List_Anchor.Length := @ - 1;
      List_Nodes (Element_Id).Next_Element_Id := Null_Element_Id;
      List_Nodes (Element_Id).Prev_Element_Id := Null_Element_Id;
      List_Nodes (Element_Id).Containing_List_Id := Null_List_Id;
   end List_Remove_Head;

   procedure List_Remove_This (List_Anchor : in out List_Anchor_Type;
                               Element_Id : Element_Id_Type;
                               List_Nodes : in out List_Nodes_Type) is
      Prev_Element_Id : constant Element_Id_Type := List_Nodes (Element_Id).Prev_Element_Id;
      Next_Element_Id : constant Element_Id_Type := List_Nodes (Element_Id).Next_Element_Id;
   begin
      if Element_Id = List_Anchor.Head then
         List_Anchor.Head := Next_Element_Id;
      else
         pragma Assert (Prev_Element_Id /= Null_Element_Id);
         List_Nodes (Prev_Element_Id).Next_Element_Id := Next_Element_Id;
      end if;

      if Element_Id = List_Anchor.Tail then
         List_Anchor.Tail := Prev_Element_Id;
      else
         pragma Assert (Next_Element_Id /= Null_Element_Id);
         List_Nodes (Next_Element_Id).Prev_Element_Id := Prev_Element_Id;
      end if;

      List_Anchor.Length := @ - 1;
      List_Nodes (Element_Id).Next_Element_Id := Null_Element_Id;
      List_Nodes (Element_Id).Prev_Element_Id := Null_Element_Id;
      List_Nodes (Element_Id).Containing_List_Id := Null_List_Id;
   end List_Remove_This;

   procedure List_Traverse (List_Anchor : in out List_Anchor_Type;
                            List_Nodes : in out List_Nodes_Type) is
      Element_Id : Element_Id_Type := List_Anchor.Head;
      Next_Element_Id : Element_Id_Type;
      List_Length : constant Interfaces.Unsigned_32 := List_Anchor.Length;
   begin
      if List_Length /= 0 then
         for I in 0 .. List_Length - 1 loop
            pragma Loop_Invariant (
               List_Nodes (Element_Id).Containing_List_Id = List_Anchor.List_Id
               and then
               (List_Nodes (Element_Id).Prev_Element_Id = Null_Element_Id or else
               List_Nodes (List_Nodes (Element_Id).Prev_Element_Id).Next_Element_Id = Element_Id)
               and then
               (List_Nodes (Element_Id).Next_Element_Id = Null_Element_Id or else
               List_Nodes (List_Nodes (Element_Id).Next_Element_Id).Prev_Element_Id = Element_Id)
            );

            --
            --  NOTE: Save next link in case this node is removed from the list
            --  by Node_Visitor.
            --
            Next_Element_Id := List_Nodes (Element_Id).Next_Element_Id;
            Element_Visitor (List_Anchor, Element_Id, List_Nodes);
            Element_Id := Next_Element_Id;
         end loop;
      end if;

      pragma Assert (Element_Id = Null_Element_Id);
   end List_Traverse;

end Generic_Linked_List;
