--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Generic_Linked_List;
with AUnit.Assertions;

package body Linked_List_Test_Cases is

   Max_Num_Test_Elements : constant := 8;

   type Test_List_Id_Type is (Test_List_Id,
                              Invalid_List_Id);

   type Test_Element_Id_Type is range 0 .. Max_Num_Test_Elements;

   subtype Valid_Test_Element_Id_Type is Test_Element_Id_Type range
      Test_Element_Id_Type'First .. Test_Element_Id_Type'Last - 1;

   Invalid_Test_Element_Id : constant Test_Element_Id_Type := Test_Element_Id_Type'Last;

   package Test_List_Package is new
      Generic_Linked_List (List_Id_Type => Test_List_Id_Type,
                           Null_List_Id => Invalid_List_Id,
                           Element_Id_Type => Test_Element_Id_Type,
                           Null_Element_Id => Invalid_Test_Element_Id);

   type Test_Element_Type is limited record
      Value : Natural;
   end record;

   Test_Elements : constant array (Valid_Test_Element_Id_Type) of Test_Element_Type :=
      [0 => (Value => 10),
       1 => (Value => 11),
       2 => (Value => 12),
       3 => (Value => 13),
       4 => (Value => 14),
       5 => (Value => 15),
       6 => (Value => 16),
       7 => (Value => 17)];

   -----------------------------------------------------------------------------
   --  Test cases
   -----------------------------------------------------------------------------

   procedure Test_List_Init (T : in out Test_Case) is
      pragma Unreferenced (T);
      Test_List_Anchor : Test_List_Package.List_Anchor_Type;
   begin
      Test_List_Package.List_Init (Test_List_Anchor, Test_List_Id);
      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");
   end Test_List_Init;

   procedure Test_Fifo_List_Add_One_Remove_One (T : in out Test_Case) is
      pragma Unreferenced (T);
      Test_List_Anchor : Test_List_Package.List_Anchor_Type;
      Element_Id : Valid_Test_Element_Id_Type;
   begin
      Test_List_Package.List_Init (Test_List_Anchor, Test_List_Id);
      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");
      Test_List_Package.List_Add_Tail (Test_List_Anchor,  Valid_Test_Element_Id_Type'First);
      AUnit.Assertions.Assert (
         not Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List empty");

      Test_List_Package.List_Remove_Head (Test_List_Anchor,  Element_Id);
      AUnit.Assertions.Assert (
         Element_Id = Valid_Test_Element_Id_Type'First,
         "Element Id is wrong");
      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");
   end Test_Fifo_List_Add_One_Remove_One;

   procedure Test_Fifo_List_Add_Two_Remove_Two (T : in out Test_Case) is
      pragma Unreferenced (T);
      Test_List_Anchor : Test_List_Package.List_Anchor_Type;
      Element_Id : Valid_Test_Element_Id_Type;
   begin
      Test_List_Package.List_Init (Test_List_Anchor, Test_List_Id);
      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");
      Test_List_Package.List_Add_Tail (Test_List_Anchor,  Valid_Test_Element_Id_Type'First);
      AUnit.Assertions.Assert (
         not Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List empty");

      Test_List_Package.List_Add_Tail (Test_List_Anchor,  Valid_Test_Element_Id_Type'First + 1);

      Test_List_Package.List_Remove_Head (Test_List_Anchor,  Element_Id);
      AUnit.Assertions.Assert (
         Element_Id = Valid_Test_Element_Id_Type'First,
         "Element Id is wrong");

      Test_List_Package.List_Remove_Head (Test_List_Anchor,  Element_Id);
      AUnit.Assertions.Assert (
         Element_Id = Valid_Test_Element_Id_Type'First + 1,
         "Element Id is wrong");
      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");
   end Test_Fifo_List_Add_Two_Remove_Two;

   procedure Test_Fifo_List_Add_All_Remove_All (T : in out Test_Case) is
      pragma Unreferenced (T);
      Visitor_Cursor : Test_Element_Id_Type := Valid_Test_Element_Id_Type'First;
      Elements_Visited : Natural := 0;

      procedure Test_Element_Visitor (List_Anchor : in out Test_List_Package.List_Anchor_Type;
                                      Element_Id : Valid_Test_Element_Id_Type) is
         pragma Unreferenced (List_Anchor);
      begin
         AUnit.Assertions.Assert (
            Test_Elements (Element_Id).Value = 10 + Natural (Element_Id),
            "Element does not have expected value");
         AUnit.Assertions.Assert (
            Element_Id = Visitor_Cursor, "Unexpected element id");

         Visitor_Cursor := @ + 1;
         Elements_Visited := @ + 1;
      end Test_Element_Visitor;

      procedure Test_List_Traverse is new
         Test_List_Package.List_Traverse (Element_Visitor => Test_Element_Visitor);

      Test_List_Anchor : Test_List_Package.List_Anchor_Type;
      Element_Id : Valid_Test_Element_Id_Type;
   begin
      Test_List_Package.List_Init (Test_List_Anchor, Test_List_Id);
      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");

      --  Add all elements Ids to the list in increasting order:
      for Elem_Id in Valid_Test_Element_Id_Type loop
         Test_List_Package.List_Add_Tail (Test_List_Anchor, Elem_Id);
      end loop;

      Test_List_Traverse (Test_List_Anchor);

      AUnit.Assertions.Assert (
         Elements_Visited = Test_Elements'Length,
         "Wrong numbers of elements visited");

      --  Remove all elements Ids from the list in increasting order:
      for Elem_Id in Valid_Test_Element_Id_Type loop
         AUnit.Assertions.Assert (
            not Test_List_Package.List_Is_Empty (Test_List_Anchor),
            "List empty");
         Test_List_Package.List_Remove_Head (Test_List_Anchor,  Element_Id);
         AUnit.Assertions.Assert (
            Element_Id = Elem_Id,
            "Element Id is wrong");
      end loop;

      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");
   end Test_Fifo_List_Add_All_Remove_All;

   procedure Test_Lifo_List_Add_One_Remove_One (T : in out Test_Case) is
      pragma Unreferenced (T);
      Test_List_Anchor : Test_List_Package.List_Anchor_Type;
      Element_Id : Valid_Test_Element_Id_Type;
   begin
      Test_List_Package.List_Init (Test_List_Anchor, Test_List_Id);
      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");
      Test_List_Package.List_Add_Head (Test_List_Anchor,  Valid_Test_Element_Id_Type'First);
      AUnit.Assertions.Assert (
         not Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List empty");

      Test_List_Package.List_Remove_Head (Test_List_Anchor,  Element_Id);
      AUnit.Assertions.Assert (
         Element_Id = Valid_Test_Element_Id_Type'First,
         "Element Id is wrong");
      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");
   end Test_Lifo_List_Add_One_Remove_One;

   procedure Test_Lifo_List_Add_Two_Remove_Two (T : in out Test_Case) is
      pragma Unreferenced (T);
      Test_List_Anchor : Test_List_Package.List_Anchor_Type;
      Element_Id : Valid_Test_Element_Id_Type;
   begin
      Test_List_Package.List_Init (Test_List_Anchor, Test_List_Id);
      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");
      Test_List_Package.List_Add_Head (Test_List_Anchor,  Valid_Test_Element_Id_Type'First);
      AUnit.Assertions.Assert (
         not Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List empty");

      Test_List_Package.List_Add_Head (Test_List_Anchor,  Valid_Test_Element_Id_Type'First + 1);

      Test_List_Package.List_Remove_Head (Test_List_Anchor,  Element_Id);
      AUnit.Assertions.Assert (
         Element_Id = Valid_Test_Element_Id_Type'First + 1,
         "Element Id is wrong");

      Test_List_Package.List_Remove_Head (Test_List_Anchor,  Element_Id);
      AUnit.Assertions.Assert (
         Element_Id = Valid_Test_Element_Id_Type'First,
         "Element Id is wrong");
      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");
   end Test_Lifo_List_Add_Two_Remove_Two;

   procedure Test_Lifo_List_Add_All_Remove_All (T : in out Test_Case) is
      pragma Unreferenced (T);
      Visitor_Cursor : Test_Element_Id_Type := Valid_Test_Element_Id_Type'Last;
      Elements_Visited : Natural := 0;

      procedure Test_Element_Visitor (List_Anchor : in out Test_List_Package.List_Anchor_Type;
                                      Element_Id : Valid_Test_Element_Id_Type) is
         pragma Unreferenced (List_Anchor);
      begin
         AUnit.Assertions.Assert (
            Test_Elements (Element_Id).Value = 10 + Natural (Element_Id),
            "Element does not have expected value");
         AUnit.Assertions.Assert (
            Element_Id = Visitor_Cursor, "Unexpected element id");

         if Visitor_Cursor > Valid_Test_Element_Id_Type'First then
            Visitor_Cursor := @ - 1;
         else
            Visitor_Cursor := Valid_Test_Element_Id_Type'Last;
         end if;

         Elements_Visited := @ + 1;
      end Test_Element_Visitor;

      procedure Test_List_Traverse is new
         Test_List_Package.List_Traverse (Element_Visitor => Test_Element_Visitor);

      Test_List_Anchor : Test_List_Package.List_Anchor_Type;
      Element_Id : Valid_Test_Element_Id_Type;
   begin
      Test_List_Package.List_Init (Test_List_Anchor, Test_List_Id);
      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");

      --  Add all elements Ids to the list in increasting order:
      for Elem_Id in Valid_Test_Element_Id_Type loop
         Test_List_Package.List_Add_Head (Test_List_Anchor, Elem_Id);
      end loop;

      Test_List_Traverse (Test_List_Anchor);

      AUnit.Assertions.Assert (
         Elements_Visited = Test_Elements'Length,
         "Wrong numbers of elements visited");

      --  Remove all elements Ids from the list in decreasting order:
      for Elem_Id in reverse Valid_Test_Element_Id_Type loop
         AUnit.Assertions.Assert (
            not Test_List_Package.List_Is_Empty (Test_List_Anchor),
            "List empty");
         Test_List_Package.List_Remove_Head (Test_List_Anchor,  Element_Id);
         AUnit.Assertions.Assert (
            Element_Id = Elem_Id,
            "Element Id is wrong");
      end loop;

      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");
   end Test_Lifo_List_Add_All_Remove_All;

   procedure Test_Fifo_List_Add_All_Remove_This_All (T : in out Test_Case) is
      pragma Unreferenced (T);
      Test_List_Anchor : Test_List_Package.List_Anchor_Type;
   begin
      Test_List_Package.List_Init (Test_List_Anchor, Test_List_Id);
      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");

      --  Add all elements Ids to the list in increasting order:
      for Elem_Id in Valid_Test_Element_Id_Type loop
         Test_List_Package.List_Add_Tail (Test_List_Anchor, Elem_Id);
      end loop;

      --  Remove all elements Ids from the list in increasting order:
      for Elem_Id in Valid_Test_Element_Id_Type loop
         AUnit.Assertions.Assert (
            not Test_List_Package.List_Is_Empty (Test_List_Anchor),
            "List empty");
         Test_List_Package.List_Remove_This (Test_List_Anchor, Elem_Id);
      end loop;

      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");
   end Test_Fifo_List_Add_All_Remove_This_All;

   procedure Test_Fifo_List_Add_All_Remove_This_All_Reverse (T : in out Test_Case) is
      pragma Unreferenced (T);
      Test_List_Anchor : Test_List_Package.List_Anchor_Type;
   begin
      Test_List_Package.List_Init (Test_List_Anchor, Test_List_Id);
      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");

      --  Add all elements Ids to the list in increasting order:
      for Elem_Id in Valid_Test_Element_Id_Type loop
         Test_List_Package.List_Add_Tail (Test_List_Anchor, Elem_Id);
      end loop;

      --  Remove all elements Ids from the list in decreasting order:
      for Elem_Id in reverse Valid_Test_Element_Id_Type loop
         AUnit.Assertions.Assert (
            not Test_List_Package.List_Is_Empty (Test_List_Anchor),
            "List empty");
         Test_List_Package.List_Remove_This (Test_List_Anchor, Elem_Id);
      end loop;

      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");
   end Test_Fifo_List_Add_All_Remove_This_All_Reverse;

   procedure Test_Fifo_List_Add_All_Remove_This_All_Traverse (T : in out Test_Case) is
      pragma Unreferenced (T);
      Visitor_Cursor : Test_Element_Id_Type := Valid_Test_Element_Id_Type'First;
      Elements_Visited : Natural := 0;

      procedure Test_Element_Visitor (List_Anchor : in out Test_List_Package.List_Anchor_Type;
                                      Element_Id : Valid_Test_Element_Id_Type) is
      begin
         AUnit.Assertions.Assert (
            Test_Elements (Element_Id).Value = 10 + Natural (Element_Id),
            "Element does not have expected value");
         AUnit.Assertions.Assert (
            Element_Id = Visitor_Cursor, "Unexpected element id");

         Visitor_Cursor := @ + 1;
         Elements_Visited := @ + 1;
         Test_List_Package.List_Remove_This (List_Anchor, Element_Id);
      end Test_Element_Visitor;

      procedure Test_List_Traverse_Remove is new
         Test_List_Package.List_Traverse (Element_Visitor => Test_Element_Visitor);

      Test_List_Anchor : Test_List_Package.List_Anchor_Type;
   begin
      Test_List_Package.List_Init (Test_List_Anchor, Test_List_Id);
      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");

      --  Add all elements Ids to the list in increasting order:
      for Elem_Id in Valid_Test_Element_Id_Type loop
         Test_List_Package.List_Add_Tail (Test_List_Anchor, Elem_Id);
      end loop;

      Test_List_Traverse_Remove (Test_List_Anchor);

      AUnit.Assertions.Assert (
         Elements_Visited = Test_Elements'Length,
         "Wrong numbers of elements visited");

      AUnit.Assertions.Assert (
         Test_List_Package.List_Is_Empty (Test_List_Anchor),
         "List not empty");
   end Test_Fifo_List_Add_All_Remove_This_All_Traverse;

end Linked_List_Test_Cases;
