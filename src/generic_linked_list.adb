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
                            Node_Id : Node_Id_Type) is
   begin
      null;
   end List_Add_Tail;

   procedure List_Remove_Head (List_Anchor : in out List_Anchor_Type;
                               Node_Id : out Node_Id_Type) is
   begin
      null;
   end List_Remove_Head;

   procedure List_Remove_This (List_Anchor : in out List_Anchor_Type;
                               Node_Id : Node_Id_Type) is
   begin
      null;
   end List_Remove_This;

   procedure List_Traverse (List_Anchor : in out List_Anchor_Type) is
   begin
      null;
   end List_Traverse;

end Generic_Linked_List;