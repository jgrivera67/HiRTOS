--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.RTOS_Private;
with HiRTOS.Thread;
with HiRTOS.Thread_Private;
with HiRTOS.Timer_Private;
with HiRTOS.Memory_Protection_Private;
with HiRTOS.Interrupt_Handling_Private;
with HiRTOS.Memory_Protection;
with HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
with HiRTOS_Cpu_Arch_Interface.Thread_Context;
with HiRTOS_Cpu_Arch_Interface.Tick_Timer;
with HiRTOS_Cpu_Multi_Core_Interface;
with System.Storage_Elements;
with HiRTOS_Low_Level_Debug_Interface; --???

--
--  @summary HiRTOS implementation
--
package body HiRTOS with
  SPARK_Mode => On
is
   use HiRTOS.RTOS_Private;
   use HiRTOS.Thread_Private;
   use HiRTOS_Cpu_Multi_Core_Interface;
   use HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;

   Idle_Thread_Stack : Small_Thread_Stack_Package.Execution_Stack_Type;

   Timer_Thread_Stack : Medium_Thread_Stack_Package.Execution_Stack_Type;

   procedure Idle_Thread_Proc (Arg : System.Address) with
     Convention => C;

   procedure Timer_Thread_Proc (Arg : System.Address) with
     Convention => C;

   procedure Initialize with
     SPARK_Mode => Off
   is
      use type System.Storage_Elements.Integer_Address;
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      ISR_Stack_Info : constant ISR_Stack_Info_Type :=
         Get_ISR_Stack_Info (Cpu_Id);
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
        HiRTOS_Obj.RTOS_Cpu_Instances (Cpu_Id);
      Error          : Error_Type;
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
   begin
      HiRTOS_Low_Level_Debug_Interface.Print_String ("Here HIRTOS.0" & ASCII.LF);--???
      HiRTOS.Memory_Protection_Private.Initialize;
      HiRTOS.Interrupt_Handling_Private.Initialize;
      HiRTOS_Cpu_Arch_Interface.Tick_Timer.Initialize;

      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access
        (RTOS_Cpu_Instance'Address, RTOS_Cpu_Instance'Size, Old_Data_Range);
      RTOS_Cpu_Instance.Interrupt_Stack_Base_Addr :=
        ISR_Stack_Info.Base_Address;
      RTOS_Cpu_Instance.Interrupt_Stack_Size := ISR_Stack_Info.Size_In_Bytes;
      RTOS_Cpu_Instance.Cpu_Id               := Cpu_Id;

      HiRTOS.Interrupt_Handling_Private.Initialize_Interrupt_Nesting_Level_Stack
        (RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack);
      HiRTOS.Thread_Private.Initialize_Priority_Thread_Queues
        (RTOS_Cpu_Instance.Runnable_Thread_Queues);
      HiRTOS.Timer_Private.Initialize_Timer_Wheel
        (RTOS_Cpu_Instance.Timer_Wheel);

      HiRTOS.Thread.Create_Thread
        (Idle_Thread_Proc'Access, Lowest_Thread_Priority,
         Idle_Thread_Stack'Address,
         Idle_Thread_Stack'Size / System.Storage_Unit,
         RTOS_Cpu_Instance.Idle_Thread_Id, Error);
      pragma Assert (Error = No_Error);

      HiRTOS.Thread.Create_Thread
        (Timer_Thread_Proc'Access, Lowest_Thread_Priority,
         Timer_Thread_Stack'Address,
         Timer_Thread_Stack'Size / System.Storage_Unit,
         RTOS_Cpu_Instance.Tick_Timer_Thread_Id, Error);
      pragma Assert (Error = No_Error);

      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
   end Initialize;

   procedure Start_Thread_Scheduler is
   begin
      -- TODO: Set state varialbes ????
      -- TODO: Start tick timer interrupt generation
      HiRTOS_Cpu_Arch_Interface.Thread_Context.First_Thread_Context_Switch;
   end Start_Thread_Scheduler;

   function Thread_Scheduler_Started return Boolean is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
   begin
      return RTOS_Cpu_Instance.Current_Thread_Id /= Invalid_Thread_Id;
   end Thread_Scheduler_Started;

   function Current_Execution_Context_Is_Interrupt return Boolean is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
   begin
      return
        Interrupt_Handling_Private.Get_Current_Interrupt_Nesting
          (RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack) /=
        0;
   end Current_Execution_Context_Is_Interrupt;

   procedure Enter_Cpu_Privileged_Mode is
   begin
      HiRTOS_Low_Level_Debug_Interface.Print_String ("HiRTOS.117" & ASCII.LF);--???
      --
      --  If we are in interrupt context, we don't need to do anything,
      --  as ISRs and the reset handler always run in provileged mode.
      --
      if Current_Execution_Context_Is_Interrupt then
      HiRTOS_Low_Level_Debug_Interface.Print_String ("HiRTOS.123" & ASCII.LF);--???
         return;
      end if;

      HiRTOS_Low_Level_Debug_Interface.Print_String ("HiRTOS.127" & ASCII.LF);--???
      declare
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
           HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
         Current_Thread_Id : constant Thread_Id_Type :=
           RTOS_Cpu_Instance.Current_Thread_Id;
         Current_Thread_Obj :
           Thread_Type renames HiRTOS_Obj.Thread_Instances (Current_Thread_Id);
      begin
      HiRTOS_Low_Level_Debug_Interface.Print_String ("HiRTOS.136" & ASCII.LF);--???
         if Thread_Private.Get_Privilege_Nesting (Current_Thread_Obj) = 0 then
      HiRTOS_Low_Level_Debug_Interface.Print_String ("HiRTOS.138" & ASCII.LF);--???
            HiRTOS_Cpu_Arch_Interface.Switch_Cpu_To_Privileged_Mode;
         else
            pragma Assert (HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode);
         end if;

      HiRTOS_Low_Level_Debug_Interface.Print_String ("HiRTOS.144" & ASCII.LF);--???
         Thread_Private.Increment_Privilege_Nesting (Current_Thread_Obj);
      end;
      HiRTOS_Low_Level_Debug_Interface.Print_String ("HiRTOS.147" & ASCII.LF);--???
   end Enter_Cpu_Privileged_Mode;

   procedure Exit_Cpu_Privileged_Mode is
   begin
      --
      --  If we are in interrupt context, we don't need to do anything,
      --  as ISRs and the reset handler always run in provileged mode.
      --
      if Current_Execution_Context_Is_Interrupt then
         return;
      end if;

      declare
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
           HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
         Current_Thread_Id :
           Thread_Id_Type renames RTOS_Cpu_Instance.Current_Thread_Id;
         Current_Thread_Obj :
           Thread_Type renames HiRTOS_Obj.Thread_Instances (Current_Thread_Id);
      begin
         Thread_Private.Decrement_Privilege_Nesting (Current_Thread_Obj);
         if Thread_Private.Get_Privilege_Nesting (Current_Thread_Obj) = 0 then
            HiRTOS_Cpu_Arch_Interface.Switch_Cpu_To_Unprivileged_Mode;
         end if;
      end;
   end Exit_Cpu_Privileged_Mode;

   function Running_In_Privileged_Mode return Boolean renames
     HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode;

   procedure Idle_Thread_Proc (Arg : System.Address) is
      pragma Unreferenced (Arg);
   begin
      pragma Assert (False); --???
   end Idle_Thread_Proc;

   procedure Timer_Thread_Proc (Arg : System.Address) is
      pragma Unreferenced (Arg);
   begin
      pragma Assert (False); --???
   end Timer_Thread_Proc;

   function Enter_Atomic_Level
     (New_Atomic_Level : Atomic_Level_Type) return Atomic_Level_Type
   is
      pragma Unreferenced (New_Atomic_Level);
   begin
      pragma Assert (False); --???
      return Atomic_Level_None; --???
   end Enter_Atomic_Level;

   procedure Exit_Atomic_Level (Old_Atomic_Level : Atomic_Level_Type) is
   begin
      pragma Assert (Old_Atomic_Level /= Atomic_Level_None); --???
   end Exit_Atomic_Level;

end HiRTOS;
