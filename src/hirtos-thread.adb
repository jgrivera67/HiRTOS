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

with HiRTOS_Cpu_Arch_Interface.Thread_Context;
with HiRTOS_Cpu_Multi_Core_Interface;
with HiRTOS.RTOS_Private;
with HiRTOS.Thread_Private;

package body HiRTOS.Thread is
   use System.Storage_Elements;
   use HiRTOS_Cpu_Arch_Interface;
   use HiRTOS_Cpu_Arch_Interface.Thread_Context;
   use HiRTOS_Cpu_Multi_Core_Interface;
   use HiRTOS.RTOS_Private;
   use HiRTOS.Thread_Private;

   procedure Initialize_Thread (Thread_Obj : out Thread_Type; Thread_Id : Thread_Id_Type)
      with Pre => Thread_Id /= Invalid_Thread_Id;

   -----------------------------------------------------------------------------
   --  Public Subprograms
   -----------------------------------------------------------------------------

   procedure Create_Thread (Entry_Point : Thread_Entry_Point_Type;
                            Priority : Thread_Priority_Type;
                            Stack_Addr : System.Address;
                            Stack_Size : System.Storage_Elements.Integer_Address;
                            Thread_Id : out Thread_Id_Type;
                            Error : out Error_Type) is
      Thread_Obj : Thread_Type;
      Thread_Cpu_Context_Address : constant System.Address :=
         To_Address (To_Integer (Stack_Addr) + Stack_Size -
                     (Cpu_Context_Type'Object_Size / System.Storage_Unit));
      Thread_Cpu_Context : Cpu_Context_Type with Address => Thread_Cpu_Context_Address;
      Initial_Stack_Pointer : constant Cpu_Register_Type :=
         Cpu_Register_Type (To_Integer (Thread_Cpu_Context_Address));
   begin
      --   Allocate a Thread object:
      --  TODO
      --Initialize_Thread (Thread_Obj, Thread_Id);
      Initialize_Thread_Cpu_Context(Thread_Cpu_Context, Initial_Stack_Pointer);

   end Create_Thread;

   function Get_Current_Thread_Id return Thread_Id_Type is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
   begin
      return RTOS_Cpu_Instance.Current_Thread_Id;
   end Get_Current_Thread_Id;

   -----------------------------------------------------------------------------
   --  Private Subprograms
   -----------------------------------------------------------------------------

   procedure Initialize_Thread (Thread_Obj : out Thread_Type; Thread_Id : Thread_Id_Type) is
   begin
      Thread_Obj.Id := Thread_Id;
      Thread_Obj.State := Thread_Not_Created;
      Thread_Obj.Atomic_Level := Atomic_Level_None;
      Thread_Obj.Timer_Id := Invalid_Timer_Id;
      Thread_Obj.Stack_Base_Addr := System.Null_Address;
      Thread_Obj.Stack_Size_In_Bytes := 0;
      Thread_Obj.Builtin_Condvar_Id := Invalid_Condvar_Id;
      Thread_Obj.Waiting_On_Condvar_Id := Invalid_Condvar_Id;
      Thread_Obj.Waiting_On_Mutex_Id := Invalid_Mutex_Id;
      --Mutex_List_Package.List_Init (Thread_Obj.Owned_Mutexes_List);
      Thread_Obj.Saved_Stack_Pointer := 0;
      Thread_Obj.Privilege_Nesting_Counter := 0;
      Thread_Obj.Time_Slice_Left_Us := Thread_Time_Slice_Us;
      --Run_Thread_Queue_Package.List_Node_Init (Thread_Obj.Run_Queue_Node);
      --Mutex_Thread_Queue_Package.List_Node_Init (Thread_Obj.Mutex_Queue_Node);
      --Condvar_Thread_Queue_Package.List_Node_Init (Thread_Obj.Condvar_Queue_Node);
      Thread_Obj.Stats := (others => <>);
   end Initialize_Thread;

end HiRTOS.Thread;
