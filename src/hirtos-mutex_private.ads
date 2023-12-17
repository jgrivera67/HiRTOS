--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS.Thread_Private;
with HiRTOS_Cpu_Arch_Interface;

private package HiRTOS.Mutex_Private is
   use HiRTOS.Thread_Private;
   use type Interfaces.Unsigned_8;

   --
   --  Mutex object
   --
   --  @field Initialized: flag indicating if the mutex object has been initialized.
   --  @field Id: mutex Id
   --  @field Owner_Thread_Id: Thread Id of the thread that currently owns the mutex
   --  @field Recursive_Count: Recursive mutex acquires count
   --  @field Ceiling_Priority: Thread priority associated to the mutex
   --  @field Waiting_Threads_Queue: Priority queue of threads waiting to acquire the mutex
   --  @field List_Node: this mutex's node in a list of mutexes, if this mutex is in a list.
   --
   type Mutex_Type is limited record
      Initialized : Boolean := False;
      Id : Mutex_Id_Type := Invalid_Mutex_Id;
      Owner_Thread_Id : Thread_Id_Type := Invalid_Thread_Id;
      Recursive_Count : Interfaces.Unsigned_8 := 0;
      Ceiling_Priority : Thread_Priority_Type := Invalid_Thread_Priority;
      Waiting_Threads_Queue : Thread_Priority_Queue_Type;
   end record with
     Alignment => HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment;

   type Mutex_Array_Type is array (Valid_Mutex_Id_Type) of Mutex_Type;

   procedure Acquire_Mutex_Internal (Mutex_Obj : in out Mutex_Type;
                                     Current_Thread_Obj : in out Thread_Type;
                                     Timeout_Ms : Time_Ms_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode
                  and then
                  HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled
                  and then
                  not Current_Execution_Context_Is_Interrupt
                  and then
                  Mutex_Obj.Initialized
                  and then
                  Mutex_Obj.Recursive_Count < Interfaces.Unsigned_8'Last
                  and then
                  Current_Thread_Obj.Id /= Invalid_Thread_Id
                  and then
                  (Current_Thread_Obj.State = Thread_Running or else
                   Current_Thread_Obj.State = Thread_Runnable)
                  and then
                  Current_Thread_Obj.Waiting_On_Mutex_Id = Invalid_Mutex_Id,
           Post =>
                  Current_Thread_Obj.Waiting_On_Mutex_Id = Invalid_Mutex_Id
                  and then
                  not Mutex_List_Package.List_Is_Empty (Current_Thread_Obj.Owned_Mutexes_List)
                  and then
                  Mutex_Obj.Owner_Thread_Id = Current_Thread_Obj.Id;

   procedure Release_Mutex_Internal (Mutex_Obj : in out Mutex_Type;
                                     Current_Thread_Obj : in out Thread_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode
                  and then
                  HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled
                  and then
                  not Current_Execution_Context_Is_Interrupt
                  and then
                  Mutex_Obj.Initialized
                  and then
                  Mutex_Obj.Recursive_Count > 0
                  and then
                  Mutex_Obj.Owner_Thread_Id = Current_Thread_Obj.Id
                  and then
                  Current_Thread_Obj.Id /= Invalid_Thread_Id
                  and then
                  --???Current_Thread_Obj.State = Thread_Running
                  --???and then
                  not Mutex_List_Package.List_Is_Empty (Current_Thread_Obj.Owned_Mutexes_List)
                  and then
                  Current_Thread_Obj.Waiting_On_Mutex_Id = Invalid_Mutex_Id,
           Post =>
                  Current_Thread_Obj.Waiting_On_Mutex_Id = Invalid_Mutex_Id
                  and then
                  (if Mutex_Obj.Recursive_Count = 0 then
                      Mutex_Obj.Owner_Thread_Id /= Current_Thread_Obj.Id);

end HiRTOS.Mutex_Private;
