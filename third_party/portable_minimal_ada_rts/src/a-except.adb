------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                       A D A . E X C E P T I O N S                        --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--          Copyright (C) 1992-2023, Free Software Foundation, Inc.         --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

package body Ada.Exceptions is

   procedure Last_Chance_Handler (Msg : System.Address; Line : Integer);
   pragma Import (C, Last_Chance_Handler, "__gnat_last_chance_handler");
   pragma No_Return (Last_Chance_Handler);

   Empty_C_String : aliased constant String := [ASCII.NUL];

   procedure Call_Last_Chance_Handler_With_Message (Message : String);
   pragma No_Return (Call_Last_Chance_Handler_With_Message);
   --  Convert an exception message string to a NUL terminated C string and
   --  call the last chance handler.

   procedure Call_Last_Chance_Handler_With_Message (Message : String) is
      C_Message : String (1 .. 80);
      --  A fixed length string is used to aid gnatstack analysis of the
      --  procedure.

   begin
      if Message'Length >= C_Message'Length then
         --  Truncate the message

         C_Message (1 .. 79) :=
           Message (Message'First .. Message'First + 78);
         C_Message (80) := ASCII.NUL;
      else
         C_Message (1 .. Message'Length) := Message;
         C_Message (Message'Length + 1) := ASCII.NUL;
      end if;

      Last_Chance_Handler (C_Message'Address, 0);
   end Call_Last_Chance_Handler_With_Message;

   ---------------------
   -- Raise_Exception --
   ---------------------

   procedure Raise_Exception (E : Exception_Id; Message : String := "") is
      pragma Unreferenced (E);
      --  Exception ID E is unused as raised exception go directly to the
      --  last chance handler on the ZFP runtime. Note it is essential
      --  for E to be unreferenced here to ensure the compiler removes
      --  references to Standard defined exceptions when it inlines this
      --  procedure, as these exceptions are located in the Standard library
      --  which is not part of ZFP runtime library.

   begin
      --  The last chance handler requires a NUL terminated C string as the Msg
      --  parameter.

      if Message'Length = 0 then
         --  Pass a NUL character to the last chance handler in the case of no
         --  message.

         Last_Chance_Handler (Empty_C_String'Address, 0);
      else
         --  While the compiler is efficient and passes NUL terminated literals
         --  to this procedure, users who directly call are not likely to be
         --  as thoughtful due to the String interface. Consequently we may
         --  need to append NUL to the Message. Since this procedure is inlined
         --  and NUL appending requires the stack, a seperate procedure is used
         --  to ensure the caller's stack is not unduly bloated.

         Call_Last_Chance_Handler_With_Message (Message);
      end if;
   end Raise_Exception;

end Ada.Exceptions;
