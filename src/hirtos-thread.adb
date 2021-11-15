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
separate (HiRTOS)
package body Thread is
   -------------------
   -- Create_Thread --
   -------------------
   procedure Create_Thread (Entry_Point : Thread_Entry_Point_Type;
                            Priority : Thread_Priority_Type;
                            Stack_Addr : System.Address;
                            Stack_Size : Interfaces.Unsigned_32;
                            Thread_Id : out Thread_Id_Type;
                            Error : out Error_Type) is
   begin
      null;
   end Create_Thread;

   --
   --  Subpograms needed by the Thread_Queues package
   --
   function Get_Next_Thread (Thread_Id : Thread_Id_Type) return Thread_Id_Type is
      (HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id).
         Thread_Pool.Object_Array (Thread_Id).Node.Next);

   function Get_Prev_Thread (Thread_Id : Thread_Id_Type) return Thread_Id_Type is
      (HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id).
         Thread_Pool.Object_Array (Thread_Id).Node.Prev);

   procedure Set_Next_Thread (Thread_Id : Thread_Id_Type;
                              Next_Thread_Id : Thread_Id_Type) is
   begin
      HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id).
         Thread_Pool.Object_Array (Thread_Id).Node.Next := Next_Thread_Id;
   end Set_Next_Thread;

   procedure Set_Prev_Thread (Thread_Id : Thread_Id_Type;
                              Prev_Thread_Id : Thread_Id_Type) is
   begin
      HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id).
         Thread_Pool.Object_Array (Thread_Id).Node.Prev := Prev_Thread_Id;
   end Set_Prev_Thread;
end Thread;