--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.RTOS_Private;
with HiRTOS.Interrupt_Handling_Private;
with HiRTOS.Thread_Private;
with HiRTOS_Cpu_Arch_Interface.Thread_Context;
with HiRTOS_Cpu_Multi_Core_Interface;
with HiRTOS_Cpu_Arch_Interface;
with System.Storage_Elements;

package body HiRTOS.Interrupt_Handling is
   use HiRTOS.RTOS_Private;
   use HiRTOS.Thread_Private;
   use HiRTOS_Cpu_Multi_Core_Interface;

   --
   --  Inline subprogram to be invoked from Interrupt_Handler_Prolog.
   --
   --  NOTE: All subprograms invoked from this subprogram must be
   --  inline subprograms.
   --
   procedure Enter_Interrupt_Context is
      Stack_Pointer : constant System.Address :=
         System.Storage_Elements.To_Address (
            System.Storage_Elements.Integer_Address (HiRTOS_Cpu_Arch_Interface.Get_Stack_Pointer));
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Current_Thread_Id : constant Thread_Id_Type :=
               RTOS_Cpu_Instance.Current_Thread_Id;
   begin
      pragma Assert (HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled);

      HiRTOS.Interrupt_Handling_Private.Increment_Interrupt_Nesting (
         RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack, Stack_Pointer);

      if HiRTOS.Interrupt_Handling_Private.Get_Current_Interrupt_Nesting
          (RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack) = 1
      then
         --
         --  Interupted context must be a thread
         --
         pragma Assert (Current_Thread_Id /= Invalid_Thread_Id);

         declare
            Current_Thread_Obj : Thread_Type renames
               HiRTOS_Obj.Thread_Instances (Current_Thread_Id);
         begin
            Current_Thread_Obj.Stats.Times_Preempted_By_Isr := @ + 1;
            Save_Thread_Extended_Context (Current_Thread_Obj);

            --
            --  Save current thread's stack pointer in current RTOS task context:
            --
            --  The current thread's stack pointer points to the thread's CPU
            --  context saved on the thread's stack.
            --
            HiRTOS.Thread_Private.Save_Thread_Stack_Pointer (Current_Thread_Obj, Stack_Pointer);
         end;

         --
         --  Set current CPU core's sp to the bottom of the ISR stack:
         --
         HiRTOS_Cpu_Arch_Interface.Set_Stack_Pointer (HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type (
            System.Storage_Elements.To_Integer (RTOS_Cpu_Instance.Interrupt_Stack_End_Address)));
      end if;
   end Enter_Interrupt_Context;

   --
   --  Inline subprogram to be invoked from Interrupt_Handler_Epilog.
   --
   --  NOTE: All subprograms invoked from this subprogram must be
   --  inline subprograms.
   --
   procedure Exit_Interrupt_Context is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Current_Interrupt_Nesting_Counter : constant Interrupt_Nesting_Counter_Type :=
         HiRTOS.Interrupt_Handling_Private.Get_Current_Interrupt_Nesting
          (RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack);
   begin
      pragma Assert (HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled);

      --
      --  If interrupt nesting level is 1, run the thread scheduler
      --  in case the highest priority runnable thread has changed:
      --
      if Current_Interrupt_Nesting_Counter = 1 then
         HiRTOS.Thread_Private.Run_Thread_Scheduler;

         declare
            Current_Thread_Id : constant Valid_Thread_Id_Type :=
                  RTOS_Cpu_Instance.Current_Thread_Id;
            Current_Thread_Obj : Thread_Type renames
               HiRTOS_Obj.Thread_Instances (Current_Thread_Id);
            Stack_Pointer : constant System.Address :=
               Thread_Private.Get_Thread_Stack_Pointer (Current_Thread_Obj);
         begin
            Restore_Thread_Extended_Context (Current_Thread_Obj);
            HiRTOS.Interrupt_Handling_Private.Decrement_Interrupt_Nesting (
               RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack);

            --
            --  Restore saved stack pointer from the current RTOS task context:
            --
            HiRTOS_Cpu_Arch_Interface.Set_Stack_Pointer (
               HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type (
                  System.Storage_Elements.To_Integer (Stack_Pointer)));
         end;
      else
         pragma Assert (Current_Interrupt_Nesting_Counter > 1);
         HiRTOS.Interrupt_Handling_Private.Decrement_Interrupt_Nesting (
            RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack);
      end if;
   end Exit_Interrupt_Context;

   procedure RTOS_Tick_Timer_Interrupt_Handler is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Current_Thread_Id : constant Valid_Thread_Id_Type :=
               RTOS_Cpu_Instance.Current_Thread_Id;
      Current_Thread_Obj : Thread_Type renames
         HiRTOS_Obj.Thread_Instances (Current_Thread_Id);
   begin
      pragma Assert (Current_Thread_Obj.Time_Slice_Left_Us >= HiRTOS_Config_Parameters.Tick_Period_Us);
      Current_Thread_Obj.Time_Slice_Left_Us := @ - HiRTOS_Config_Parameters.Tick_Period_Us;
   end RTOS_Tick_Timer_Interrupt_Handler;

   function Get_Interrupted_PC return System.Address
   is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Current_Interrupt_Nesting_Counter : constant Interrupt_Nesting_Counter_Type :=
         RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack.Current_Interrupt_Nesting_Counter;
      Saved_Stack_Pointer : constant System.Address := RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack.
         Interrupt_Nesting_Level_Array (Current_Interrupt_Nesting_Counter).Saved_Stack_Pointer;
      Cpu_Context : constant HiRTOS_Cpu_Arch_Interface.Thread_Context.Cpu_Context_Type with
         Import, Address => Saved_Stack_Pointer;
   begin
      return HiRTOS_Cpu_Arch_Interface.Thread_Context.Get_Saved_PC (Cpu_Context);
   end Get_Interrupted_PC;

end HiRTOS.Interrupt_Handling;
