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

private package HiRTOS.Thread_Private is

   procedure Increment_Privilege_Nesting (Thread_Obj : in out Thread_Type)
      with Pre => Get_Privilege_Nesting (Thread_Obj) < Privilege_Nesting_Counter_Type'Last;

   procedure Decrement_Privilege_Nesting (Thread_Obj : in out Thread_Type)
      with Pre => Get_Privilege_Nesting (Thread_Obj) > 0;

   procedure Save_Thread_Stack_Pointer (Thread_Obj : in out Thread_Type;
                                        Stack_Pointer : Cpu_Register_Type)
      with Inline_Always;

   function Get_Thread_Stack_Pointer (Thread_Obj : Thread_Type)
      return Cpu_Register_Type
      with Inline_Always;

   function Get_Privilege_Nesting (Thread_Obj : Thread_Type)
      return Privilege_Nesting_Counter_Type is
      (Thread_Obj.Privilege_Nesting_Counter);

   function Get_Thread_Stack_Pointer (Thread_Obj : Thread_Type)
      return Cpu_Register_Type is
      (Thread_Obj.Saved_Stack_Pointer);

   procedure Run_Thread_Scheduler;

end HiRTOS.Thread_Private;
