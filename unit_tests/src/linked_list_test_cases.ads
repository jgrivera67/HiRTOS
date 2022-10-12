with AUnit;
with AUnit.Test_Fixtures;

package Linked_List_Test_Cases is

   type Test_Case is new AUnit.Test_Fixtures.Test_Fixture with null record;

   procedure Test_List_Init (T : in out Test_Case);

   procedure Test_Fifo_List_Add_One_Remove_One (T : in out Test_Case);

   procedure Test_Fifo_List_Add_Two_Remove_Two (T : in out Test_Case);

   procedure Test_Fifo_List_Add_All_Remove_All (T : in out Test_Case);

   procedure Test_Lifo_List_Add_One_Remove_One (T : in out Test_Case);

   procedure Test_Lifo_List_Add_Two_Remove_Two (T : in out Test_Case);

   procedure Test_Lifo_List_Add_All_Remove_All (T : in out Test_Case);

   procedure Test_Fifo_List_Add_All_Remove_This_All (T : in out Test_Case);

   procedure Test_Fifo_List_Add_All_Remove_This_All_Reverse (T : in out Test_Case);

   procedure Test_Fifo_List_Add_All_Remove_This_All_Traverse (T : in out Test_Case);

end Linked_List_Test_Cases;