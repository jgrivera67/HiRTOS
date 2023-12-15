--
--  Copyright (c) 2022-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--
with Linked_List_Test_Cases;
with AUnit.Test_Caller;

package body Test_Suites is

   package Caller is new AUnit.Test_Caller (Linked_List_Test_Cases.Test_Case);

   function Create_Linked_List_Test_Suite return AUnit.Test_Suites.Access_Test_Suite is
      Test_Suite_Ptr : constant AUnit.Test_Suites.Access_Test_Suite :=
         new AUnit.Test_Suites.Test_Suite;
   begin
      Test_Suite_Ptr.Add_Test (
         Caller.Create (
           "Test_List_Init",
           Linked_List_Test_Cases.Test_List_Init'Access));

      Test_Suite_Ptr.Add_Test (
         Caller.Create (
           "Test_Fifo_List_Add_One_Remove_One",
           Linked_List_Test_Cases.Test_Fifo_List_Add_One_Remove_One'Access));

      Test_Suite_Ptr.Add_Test (
         Caller.Create (
           "Test_Fifo_List_Add_Two_Remove_Two",
           Linked_List_Test_Cases.Test_Fifo_List_Add_Two_Remove_Two'Access));

      Test_Suite_Ptr.Add_Test (
         Caller.Create (
           "Test_Fifo_List_Add_All_Remove_All",
           Linked_List_Test_Cases.Test_Fifo_List_Add_All_Remove_All'Access));

      Test_Suite_Ptr.Add_Test (
         Caller.Create (
           "Test_Lifo_List_Add_One_Remove_One",
           Linked_List_Test_Cases.Test_Lifo_List_Add_One_Remove_One'Access));

      Test_Suite_Ptr.Add_Test (
         Caller.Create (
           "Test_Lifo_List_Add_Two_Remove_Two",
           Linked_List_Test_Cases.Test_Lifo_List_Add_Two_Remove_Two'Access));

      Test_Suite_Ptr.Add_Test (
         Caller.Create (
           "Test_Lifo_List_Add_All_Remove_All",
           Linked_List_Test_Cases.Test_Lifo_List_Add_All_Remove_All'Access));

      Test_Suite_Ptr.Add_Test (
         Caller.Create (
           "Test_Fifo_List_Add_All_Remove_This_All",
           Linked_List_Test_Cases.Test_Fifo_List_Add_All_Remove_This_All'Access));

      Test_Suite_Ptr.Add_Test (
         Caller.Create (
           "Test_Fifo_List_Add_All_Remove_This_All_Reverse",
           Linked_List_Test_Cases.Test_Fifo_List_Add_All_Remove_This_All_Reverse'Access));

      Test_Suite_Ptr.Add_Test (
         Caller.Create (
           "Test_Fifo_List_Add_All_Remove_This_All_Traverse",
           Linked_List_Test_Cases.Test_Fifo_List_Add_All_Remove_This_All_Traverse'Access));

      return Test_Suite_Ptr;
   end Create_Linked_List_Test_Suite;

end Test_Suites;
