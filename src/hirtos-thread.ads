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
package HiRTOS.Thread is

   --
   --  NOTE: Lower value means higher priority
   --
   Lowest_Thread_Prioritiy :
      constant Thread_Priority_Type := Thread_Priority_Type'Last;

   Highest_Thread_Prioritiy :
      constant Thread_Priority_Type := Thread_Priority_Type'First;

   type Thread_Entry_Point_Type is access procedure (Arg : System.Address)
	 with Convention => C;

   --
   --  Create new thread
   --
   procedure Create_Thread (Entry_Point : Thread_Entry_Point_Type;
			    Priority : Thread_Priority_Type;
			    Stack_Addr : System.Address;
			    Stack_Size : Interfaces.Unsigned_32;
			    Thread_Id : out Thread_Id_Type;
			    Error : out Error_Type)
      with Export,
         Convention => C,
         External_Name => "hirtos_create_thread";

   --
   --  Return the Id of the current thread executing on the current CPU core,
   --  if that core is running in thread context, or the Id of the last thread
   --  prempted by an interrupt handler, if running in interrupt context.
   --
   function Get_Current_Thread_Id return Thread_Id_Type;

end HiRTOS.Thread;
