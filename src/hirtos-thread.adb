--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
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

   procedure Initialize_Thread (Thread_Obj : out Thread_Type;
                                Thread_Id : Valid_Thread_Id_Type;
                                Priority : Valid_Thread_Priority_Type;
                                Stack_Base_Address : System.Address;
                                Stack_Size : System.Storage_Elements.Integer_Address);

   -----------------------------------------------------------------------------
   --  Public Subprograms
   -----------------------------------------------------------------------------

   procedure Create_Thread (Entry_Point : Thread_Entry_Point_Type;
                            Thread_Arg : System.Address;
                            Priority : Valid_Thread_Priority_Type;
                            Stack_Base_Address : System.Address;
                            Stack_Size : System.Storage_Elements.Integer_Address;
                            Thread_Id : out Valid_Thread_Id_Type)
   is
      Stack_End_Address : constant System.Address := To_Address (To_Integer (Stack_Base_Address) + Stack_Size);
      Thread_Cpu_Context_Address : constant System.Address :=
         To_Address (To_Integer (Stack_End_Address) - (Cpu_Context_Type'Object_Size / System.Storage_Unit));
      Thread_Cpu_Context : Cpu_Context_Type with Import, Address => Thread_Cpu_Context_Address;
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
        HiRTOS_Obj.RTOS_Cpu_Instances (Cpu_Id);
      Old_Cpu_Interrupting : Cpu_Register_Type;
   begin
      Enter_Cpu_Privileged_Mode;
      HiRTOS.RTOS_Private.Allocate_Thread_Object (Thread_Id);

      Initialize_Thread (HiRTOS_Obj.Thread_Instances (Thread_Id), Thread_Id, Priority, Stack_Base_Address, Stack_Size);
      Initialize_Thread_Cpu_Context (Thread_Cpu_Context,
                                     Cpu_Register_Type (To_Integer (Entry_Point.all'Address)),
                                     Cpu_Register_Type (To_Integer (Thread_Arg)),
                                     Cpu_Register_Type (To_Integer (Stack_End_Address)));

      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
      Per_Cpu_Thread_List_Package.List_Add_Tail (RTOS_Cpu_Instance.All_Threads, Thread_Id);
      Thread_Queue_Package.List_Add_Tail (RTOS_Cpu_Instance.Runnable_Thread_Queues (Priority),
                                          Thread_Id);
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
      Exit_Cpu_Privileged_Mode;
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

   procedure Initialize_Thread (Thread_Obj : out Thread_Type;
                                Thread_Id : Valid_Thread_Id_Type;
                                Priority : Valid_Thread_Priority_Type;
                                Stack_Base_Address : System.Address;
                                Stack_Size : System.Storage_Elements.Integer_Address) is
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
   begin
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access
        (Thread_Obj'Address, Thread_Obj'Size, Old_Data_Range);
      Thread_Obj.Id := Thread_Id;
      Thread_Obj.State := Thread_Runnable;
      Thread_Obj.Priority := Priority;
      Thread_Obj.Atomic_Level := Atomic_Level_None;
      RTOS_Private.Allocate_Timer_Object (Thread_Obj.Timer_Id);
      Thread_Obj.Stack_Base_Addr := Stack_Base_Address;
      Thread_Obj.Stack_Size_In_Bytes := Thread_Stack_Size_In_Bytes_Type (Stack_Size);
      RTOS_Private.Allocate_Condvar_Object (Thread_Obj.Builtin_Condvar_Id);
      Thread_Obj.Waiting_On_Condvar_Id := Invalid_Condvar_Id;
      Thread_Obj.Waiting_On_Mutex_Id := Invalid_Mutex_Id;
      --Mutex_List_Package.List_Init (Thread_Obj.Owned_Mutexes_List);
      Thread_Obj.Saved_Stack_Pointer := System.Null_Address;
      Thread_Obj.Privilege_Nesting_Counter := 0;
      Thread_Obj.Time_Slice_Left_Us := Thread_Time_Slice_Us;
      --Run_Thread_Queue_Package.List_Node_Init (Thread_Obj.Run_Queue_Node);
      --Mutex_Thread_Queue_Package.List_Node_Init (Thread_Obj.Mutex_Queue_Node);
      --Condvar_Thread_Queue_Package.List_Node_Init (Thread_Obj.Condvar_Queue_Node);
      Thread_Obj.Stats := (others => <>);
      Thread_Obj.Initialized := True;
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
   end Initialize_Thread;

end HiRTOS.Thread;
