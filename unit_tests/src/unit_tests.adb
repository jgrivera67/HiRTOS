--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with AUnit.Reporter.Text;
with AUnit.Run;
with Test_Suites;

procedure Unit_Tests is
   procedure Run_Linked_List_Tests is new
      AUnit.Run.Test_Runner (Test_Suites.Create_Linked_List_Test_Suite);

   Linked_List_Tests_Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Run_Linked_List_Tests (Linked_List_Tests_Reporter);
end Unit_Tests;
