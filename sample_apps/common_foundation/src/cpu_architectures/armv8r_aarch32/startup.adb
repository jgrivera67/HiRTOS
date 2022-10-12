--
--  Copyright (c) 2018, German Rivera
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

with Low_Level_Debug;
with System.Machine_Code;
with Interfaces;

package body Startup is

   ----------------
   -- Enable_FPU --
   ----------------

   procedure Enable_FPU is
   begin
      null;
      --li t0, MSTATUS_FS
      --csrs mstatus, t0
      --csrr t1, mstatus
      --and t1, t1, t0
      --beqz t1, 1f
      --fssr zero
      --1:

   end Enable_FPU;

   -------------------
   -- Reset_Handler --
   -------------------

   procedure Reset_Handler (Cpu_Id : Interfaces.Unsigned_32) is
      use type Interfaces.Unsigned_32;

      procedure Gnat_Generated_Main with Import,
                                      Convention => C,
                                      External_Name => "main";
   begin
      --
      --  In case C code is invoked from Ada, C global variables
      --  need to be initialized in RAM:
      --
      --???Memory_Utils.Copy_Data_Section;
      --???Memory_Utils.Clear_BSS_Section;

      Low_Level_Debug.Initialize_Rgb_Led;

      if Cpu_Id = 0 then
         Low_Level_Debug.Initialize_Uart;
      else
         loop --???
            --  System.Machine_Code.Asm ("wfe", Volatile => True);
            System.Machine_Code.Asm ("wfi", Volatile => True);
         end loop; --???
      end if;

      Enable_FPU;

      --
      --  Call main() generated by gnat binder, which will do the elaboration
      --  of Ada library-level packages and then invoke the main Ada subprogram
      --
      --  NOTE: Before calling 'Gnat_Generated_Main' only
      --  "No_Elaboration_Code_All" packages can be invoked.
      --
      Gnat_Generated_Main;

      --
      --  We should not return here
      --
      loop
         null;
      end loop;
   end Reset_Handler;

   ----------------------------------
   -- Unexpected_Interrupt_Handler --
   ----------------------------------

   procedure Unexpected_Interrupt_Handler is
   begin
      loop
         null;
      end loop;
   end Unexpected_Interrupt_Handler;

   -------------------------
   -- Last_Chance_Handler --
   -------------------------

   Last_Chance_Handler_Running : Boolean := False;

   procedure Last_Chance_Handler (Msg : System.Address; Line : Integer) is
      Msg_Text : String (1 .. 128) with Address => Msg;
      Msg_Length : Natural := 0;
   begin
      Low_Level_Debug.Set_Rgb_Led (Red_On => True);
      --
      --  Calculate length of the null-terminated 'Msg' string:
      --
      for Msg_Char of Msg_Text loop
         Msg_Length := Msg_Length + 1;
         exit when Msg_Char = ASCII.NUL;
      end loop;

      if Last_Chance_Handler_Running then
         Low_Level_Debug.Print_String (
            "*** Recursive call to Last_Chance_Handler: " &
            Msg_Text (1 .. Msg_Length) & "' at line ");
         Low_Level_Debug.Print_Number_Decimal (Interfaces.Unsigned_32 (Line),
                                               End_Line => True);
         loop
            System.Machine_Code.Asm ("wfi", Volatile => True);
         end loop;
      end if;

      Last_Chance_Handler_Running := True;

      --
      --  Print exception message to UART0:
      --
      if Line /= 0 then
         Low_Level_Debug.Print_String (
            ASCII.LF & "*** Exception: '" & Msg_Text (1 .. Msg_Length) &
            "' at line ");
         Low_Level_Debug.Print_Number_Decimal (Interfaces.Unsigned_32 (Line),
                                               End_Line => True);
      else
         Low_Level_Debug.Print_String (
            ASCII.LF &
            "*** Exception: '" & Msg_Text (1 .. Msg_Length) & "'" & ASCII.LF);
      end if;

      loop
         System.Machine_Code.Asm ("wfi", Volatile => True);
      end loop;

   end Last_Chance_Handler;

end Startup;
