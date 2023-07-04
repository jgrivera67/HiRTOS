--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS_Cpu_Arch_Interface.Thread_Context;
with HiRTOS_Cpu_Multi_Core_Interface;
with HiRTOS.Timer;
with HiRTOS.Condvar;
with HiRTOS.RTOS_Private;
with HiRTOS.Thread_Private;
with HiRTOS.Memory_Protection_Private;
--  ???with HiRTOS_Low_Level_Debug_Interface;--???
--  ???with GNAT.Source_Info; --???

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
                                Stack_End_Address : System.Address;
                                Initial_Stack_Pointer : System.Address) with
      Pre =>  To_Integer (Stack_Base_Address) mod
                  HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0
              and then
              To_Integer (Stack_End_Address) mod
                  HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0
              and then
              To_Integer (Stack_Base_Address) < To_Integer (Stack_End_Address)
              and then
              To_Integer (Initial_Stack_Pointer) mod
                  HiRTOS_Cpu_Arch_Parameters.Integer_Register_Size_In_Bytes = 0
              and then
              To_Integer (Initial_Stack_Pointer) in
                 To_Integer (Stack_Base_Address) .. To_Integer (Stack_End_Address)
              and then
              To_Integer (Initial_Stack_Pointer) +
                 (HiRTOS_Cpu_Arch_Interface.Thread_Context.Cpu_Context_Type'Object_Size /
                  System.Storage_Unit) = To_Integer (Stack_End_Address);

   procedure Thread_Delay_Timer_Callback (Timer_Id : Valid_Timer_Id_Type;
                                          Callback_Arg : Integer_Address)
      with Convention => C;

   -----------------------------------------------------------------------------
   --  Public Subprograms
   -----------------------------------------------------------------------------

   procedure Create_Thread (Entry_Point : Thread_Entry_Point_Type;
                            Thread_Arg : System.Address;
                            Priority : Valid_Thread_Priority_Type;
                            Stack_Base_Address : System.Address;
                            Stack_Size_In_Bytes : System.Storage_Elements.Integer_Address;
                            Thread_Id : out Valid_Thread_Id_Type)
   is
   begin
      Enter_Cpu_Privileged_Mode;

      declare
         Stack_End_Address : constant System.Address :=
            To_Address (To_Integer (Stack_Base_Address) + Stack_Size_In_Bytes);
         Initial_Stack_Pointer : constant System.Address :=
            To_Address (To_Integer (Stack_End_Address) -
                        (Cpu_Context_Type'Object_Size / System.Storage_Unit));
         Thread_Cpu_Context : Cpu_Context_Type with
            Import, Address => Initial_Stack_Pointer;
         Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Cpu_Id);
         Old_Cpu_Interrupting : Cpu_Register_Type;
      begin
         HiRTOS.RTOS_Private.Allocate_Thread_Object (Thread_Id);

         Initialize_Thread (RTOS_Cpu_Instance.Thread_Instances (Thread_Id), Thread_Id, Priority,
                           Stack_Base_Address, Stack_End_Address, Initial_Stack_Pointer);
         Initialize_Thread_Cpu_Context (Thread_Cpu_Context,
                                       Cpu_Register_Type (To_Integer (Entry_Point.all'Address)),
                                       Cpu_Register_Type (To_Integer (Thread_Arg)),
                                       Cpu_Register_Type (To_Integer (Stack_End_Address)));

         --  Begin critical section
         Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
         declare
            Thread_Obj : HiRTOS.Thread_Private.Thread_Type renames
               RTOS_Cpu_Instance.Thread_Instances (Thread_Id);
         begin
            Enqueue_Runnable_Thread (Thread_Obj, Priority);
         end;

         --  End critical section
         HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
      end;

      Exit_Cpu_Privileged_Mode;
   end Create_Thread;

   function Get_Current_Thread_Id return Thread_Id_Type is
      Thread_Id : Thread_Id_Type;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;

      declare
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
            HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      begin
         Thread_Id := RTOS_Cpu_Instance.Current_Thread_Id;
      end;

      Exit_Cpu_Privileged_Mode;
      return Thread_Id;
   end Get_Current_Thread_Id;

   function Thread_Delay_Until (Wakeup_Time_Us : Absolute_Time_Us_Type) return Absolute_Time_Us_Type
   is
      Current_Time_Us : Absolute_Time_Us_Type;
   begin
      HiRTOS.Enter_Cpu_Privileged_Mode;

      declare
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
            HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
         Current_Thread_Id : constant Thread_Id_Type := RTOS_Cpu_Instance.Current_Thread_Id;
         Current_Thread_Obj : Thread_Type renames
            RTOS_Cpu_Instance.Thread_Instances (Current_Thread_Id);
         --  ???Old_Atomic_Level : Atomic_Level_Type;
         Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
         Expiration_Time_Us : Relative_Time_Us_Type;
      begin
         --   ???Old_Atomic_Level := HiRTOS.Enter_Atomic_Level (
         --   ???      HiRTOS.Atomic_Level_Type (HiRTOS.Interrupt_Handling.Tick_Timer_Interrupt_Priority));
         Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

         Current_Time_Us := HiRTOS.Get_Current_Time_Us;

         --
         --  NOTE: The time delta calculation below works even if
         --  Wakeup_Time_Us < Get_Current_Time_Us
         --  since we are using unsigned modulo-32 arithmetic.
         --
         Expiration_Time_Us := Relative_Time_Us_Type (Wakeup_Time_Us - Current_Time_Us);
         if Expiration_Time_Us = 0 then
            goto Common_Exit;
         end if;

         if Wakeup_Time_Us < Current_Time_Us then
            --
            --  Disambiguate if the RTOS tiock count has wrapped around or Thread_Delay_Until()
            --  has been called with a time point that is already in the past (which would be
            --  a sing that a thread is missing its dealines or starving)
            --
            if Expiration_Time_Us > HiRTOS_Config_Parameters.Max_Thread_Delay_Us then
               Current_Thread_Obj.Stats.Delay_Until_In_the_Past_Count := @ + 1;
               goto Common_Exit;
            end if;

            Expiration_Time_Us := HiRTOS_Config_Parameters.Max_Thread_Delay_Us;
         end if;

         --
         --  Start timer for the current thread:
         --
         HiRTOS.Timer.Start_Timer (Current_Thread_Obj.Builtin_Timer_Id,
                                   Expiration_Time_Us,
                                   Thread_Delay_Timer_Callback'Access,
                                   Integer_Address (Current_Thread_Id));

         --
         --  Wait for the calling thread's delay timer to expire:
         --
         HiRTOS.Condvar.Wait (Current_Thread_Obj.Builtin_Condvar_Id);

         --  ???HiRTOS.Exit_Atomic_Level (Old_Atomic_Level);
         HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
         Current_Time_Us := Get_Current_Time_Us;
      end;

<<Common_Exit>>
      HiRTOS.Exit_Cpu_Privileged_Mode;

      return Current_Time_Us;
   end Thread_Delay_Until;

   -----------------------------------------------------------------------------
   --  Private Subprograms
   -----------------------------------------------------------------------------

   procedure Initialize_Thread (Thread_Obj : out Thread_Type;
                                Thread_Id : Valid_Thread_Id_Type;
                                Priority : Valid_Thread_Priority_Type;
                                Stack_Base_Address : System.Address;
                                Stack_End_Address : System.Address;
                                Initial_Stack_Pointer : System.Address) is
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
   begin
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access
        (Thread_Obj'Address, Thread_Obj'Size, Old_Data_Range);
      Thread_Obj.Id := Thread_Id;
      Thread_Obj.State := Thread_Suspended;
      Thread_Obj.Base_Priority := Priority;
      Thread_Obj.Current_Priority := Thread_Obj.Base_Priority;
      Thread_Obj.Atomic_Level := Atomic_Level_None;
      HiRTOS.Timer.Create_Timer (Thread_Obj.Builtin_Timer_Id);

      Thread_Obj.Stack_Base_Addr := Stack_Base_Address;
      Thread_Obj.Stack_End_Addr := Stack_End_Address;
      Thread_Obj.Saved_Stack_Pointer := Initial_Stack_Pointer;

      HiRTOS.Condvar.Create_Condvar (Thread_Obj.Builtin_Condvar_Id);
      Thread_Obj.Waiting_On_Condvar_Id := Invalid_Condvar_Id;
      Thread_Obj.Waiting_On_Mutex_Id := Invalid_Mutex_Id;
      Mutex_List_Package.List_Init (Thread_Obj.Owned_Mutexes_List, Thread_Id);
      HiRTOS.Memory_Protection_Private.Initialize_Thread_Memory_Regions (
         Stack_Base_Address, Stack_End_Address, Thread_Obj.Saved_Thread_Memory_Regions);

      Thread_Obj.Privilege_Nesting_Counter := 0;
      Thread_Obj.Time_Slice_Left_Us := Thread_Time_Slice_Us;
      Thread_Obj.Stats := (others => <>);
      Thread_Obj.Initialized := True;
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
   end Initialize_Thread;

   procedure Thread_Delay_Timer_Callback (Timer_Id : Valid_Timer_Id_Type;
                                          Callback_Arg : Integer_Address) is
      Thread_Id : constant Valid_Thread_Id_Type := Valid_Thread_Id_Type (Callback_Arg);
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Thread_Obj : Thread_Type renames RTOS_Cpu_Instance.Thread_Instances (Thread_Id);
   begin
      pragma Assert (Timer_Id = Thread_Obj.Builtin_Timer_Id);

      --
      --  Wake up delayed thread
      --
      HiRTOS.Condvar.Signal (Thread_Obj.Builtin_Condvar_Id);
   end Thread_Delay_Timer_Callback;

end HiRTOS.Thread;
