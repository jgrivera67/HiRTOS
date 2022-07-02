--
--  Copyright (c) 2022, German Rivera
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
package body HiRTOS.Thread is

   procedure Create_Thread (Entry_Point : Thread_Entry_Point_Type;
                            Priority : Thread_Priority_Type;
                            Stack_Addr : System.Address;
                            Stack_Size : Interfaces.Unsigned_32;
                            Thread_Id : out Thread_Id_Type;
                            Error : out Error_Type) is
      Thread_Obj : Thread_Type;
      Thread_Cpu_Context_Address : constant System.Address :=
         To_Address (Integer_Address (Stack_Addr) + Stack_Size -
                     (Cpu_Context_Type'Object_Size / System.Storage_Unit));
      Thread_Cpu_Context : Cpu_Context_Type with Address => Thread_Cpu_Context_Address;
   begin
      --  Allocate a Thread object:
      null; --  TODO

      Initialize_Thread_Cpu_Context(Thread_Cpu_Context,
                                    Thread_Cpu_Context_Address);

   end Create_Thread;

   function Get_Current_Thread_Id return Thread_Id_Type is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
   begin
      return HiRTOS_Instance.Current_Thread_Id;
   end Get_Current_Thread_Id;

end HiRTOS.Thread;
