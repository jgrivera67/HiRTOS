--
--  Copyright (c) 2022-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS.Mutex_Private;
with HiRTOS.RTOS_Private;
with HiRTOS.Thread_Private;
with HiRTOS.Memory_Protection;
with HiRTOS_Cpu_Multi_Core_Interface;

package body HiRTOS.Mutex is
   use HiRTOS.Mutex_Private;
   use HiRTOS.RTOS_Private;
   use HiRTOS.Thread_Private;
   use HiRTOS_Cpu_Multi_Core_Interface;

   function Initialized (Mutex_Id : Valid_Mutex_Id_Type) return Boolean  with Ghost;

   procedure Initialize_Mutex (Mutex_Obj : out Mutex_Type; Mutex_Id : Mutex_Id_Type;
                               Ceiling_Priority : Thread_Priority_Type)
      with Pre => Mutex_Id /= Invalid_Mutex_Id;

   -----------------------------------------------------------------------------
   --  Public Subprograms
   -----------------------------------------------------------------------------

   procedure Create_Mutex (Mutex_Id : out Valid_Mutex_Id_Type;
                           Ceiling_Priority : Thread_Priority_Type := Invalid_Thread_Priority)
      with Refined_Post => Initialized (Mutex_Id)
   is
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;
      declare
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      begin
         RTOS_Private.Allocate_Mutex_Object (Mutex_Id);
         Initialize_Mutex (RTOS_Cpu_Instance.Mutex_Instances (Mutex_Id), Mutex_Id, Ceiling_Priority);
      end;
      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Create_Mutex;

   procedure Acquire (Mutex_Id : Valid_Mutex_Id_Type) is
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;

      declare
         Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
            HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
         Mutex_Obj : HiRTOS.Mutex_Private.Mutex_Type renames
            RTOS_Cpu_Instance.Mutex_Instances (Mutex_Id);
         Current_Thread_Id : constant Thread_Id_Type := RTOS_Cpu_Instance.Current_Thread_Id;
         Current_Thread_Obj : HiRTOS.Thread_Private.Thread_Type renames
            RTOS_Cpu_Instance.Thread_Instances (Current_Thread_Id);
         Current_Atomic_Level : constant Atomic_Level_Type := Get_Current_Atomic_Level;
      begin
         pragma Assert (not HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled
                        and then
                        Current_Atomic_Level = Atomic_Level_None);
         Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
         Acquire_Mutex_Internal (Mutex_Obj, Current_Thread_Obj, Time_Ms_Type'Last);
         HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
         pragma Assert (Get_Current_Atomic_Level = Current_Atomic_Level);
      end;

      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Acquire;

   function Try_Acquire (Mutex_Id : Valid_Mutex_Id_Type;
                         Timeout_Ms : Time_Ms_Type) return Boolean
   is
      Mutex_Acquired : Boolean;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;

      declare
         Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
            HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
         Mutex_Obj : HiRTOS.Mutex_Private.Mutex_Type renames
            RTOS_Cpu_Instance.Mutex_Instances (Mutex_Id);
         Current_Thread_Id : constant Thread_Id_Type := RTOS_Cpu_Instance.Current_Thread_Id;
         Current_Thread_Obj : HiRTOS.Thread_Private.Thread_Type renames
            RTOS_Cpu_Instance.Thread_Instances (Current_Thread_Id);
         Current_Atomic_Level : constant Atomic_Level_Type := Get_Current_Atomic_Level;
      begin
         pragma Assert (not HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled
                        and then
                        Current_Atomic_Level = Atomic_Level_None);
         Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
         Acquire_Mutex_Internal (Mutex_Obj, Current_Thread_Obj, Timeout_Ms);
         Mutex_Acquired := not Current_Thread_Obj.Last_Mutex_Acquire_Timed_Out;
         HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
         pragma Assert (Get_Current_Atomic_Level = Current_Atomic_Level);
      end;

      HiRTOS.Exit_Cpu_Privileged_Mode;
      return Mutex_Acquired;
   end Try_Acquire;

   procedure Release (Mutex_Id : Valid_Mutex_Id_Type) is
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;

      declare
         Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
            HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
         Mutex_Obj : HiRTOS.Mutex_Private.Mutex_Type renames
            RTOS_Cpu_Instance.Mutex_Instances (Mutex_Id);
         Current_Thread_Id : constant Thread_Id_Type := RTOS_Cpu_Instance.Current_Thread_Id;
         Current_Thread_Obj : HiRTOS.Thread_Private.Thread_Type renames
            RTOS_Cpu_Instance.Thread_Instances (Current_Thread_Id);
      begin
         Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
         Release_Mutex_Internal (Mutex_Obj, Current_Thread_Obj);
         HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
      end;

      HiRTOS.Exit_Cpu_Privileged_Mode;
   end Release;

   -----------------------------------------------------------------------------
   --  Private Subprograms
   -----------------------------------------------------------------------------

   function Initialized (Mutex_Id : Valid_Mutex_Id_Type) return Boolean is
      (HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id).Mutex_Instances (Mutex_Id).Initialized);

   procedure Initialize_Mutex (Mutex_Obj : out Mutex_Type; Mutex_Id : Mutex_Id_Type;
                               Ceiling_Priority : Thread_Priority_Type) is
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
   begin
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access (Mutex_Obj'Address, Mutex_Obj'Size,
                                                              Old_Data_Range);
      Mutex_Obj.Id := Mutex_Id;
      Mutex_Obj.Ceiling_Priority := Ceiling_Priority;
      Initialize_Thread_Priority_Queue (Mutex_Obj.Waiting_Threads_Queue);
      Mutex_Obj.Initialized := True;
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
   end Initialize_Mutex;

end HiRTOS.Mutex;
