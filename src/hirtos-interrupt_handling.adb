--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.RTOS_Private;
with HiRTOS.Timer_Private;
with HiRTOS.Interrupt_Handling_Private;
with HiRTOS.Thread_Private;
with HiRTOS_Cpu_Arch_Interface.Thread_Context;
with HiRTOS_Cpu_Multi_Core_Interface;
with HiRTOS_Cpu_Arch_Interface;
with System.Storage_Elements;
with HiRTOS_Low_Level_Debug_Interface;--???
with GNAT.Source_Info; --???

package body HiRTOS.Interrupt_Handling is
   use HiRTOS.RTOS_Private;
   use HiRTOS.Thread_Private;
   use HiRTOS.Interrupt_Handling_Private;
   use HiRTOS_Cpu_Multi_Core_Interface;

   function Enter_Interrupt_Context (Stack_Pointer : System.Address) return System.Address is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Current_Thread_Id : constant Thread_Id_Type := RTOS_Cpu_Instance.Current_Thread_Id;
      New_Stack_Pointer : System.Address;
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      HiRTOS.Interrupt_Handling_Private.Increment_Interrupt_Nesting (
         RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack, Stack_Pointer);

      --  HiRTOS_Low_Level_Debug_Interface.Print_String ("*** JGR enter < " & GNAT.Source_Info.Source_Location & ASCII.LF); --???
      --  HiRTOS_Low_Level_Debug_Interface.Print_String ("*** JGR enter interrupt nesting level: "); --???
      --  HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (
      --    HiRTOS.Interrupt_Handling_Private.Get_Current_Interrupt_Nesting (RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack))); --???
      --  HiRTOS_Low_Level_Debug_Interface.Print_String (", old stack pointer: "); --???
      --  HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (System.Storage_Elements.To_Integer (Stack_Pointer)), End_line => True); --???

      if Get_Current_Interrupt_Nesting_Counter (RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack) = 1
      then
      --???
              --  HiRTOS_Low_Level_Debug_Interface.Print_String ("*** JGR enter thread_id: "); --???
              --  HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (Current_Thread_Id), End_line => True); --???
      --???
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
            --???
            --  if not Valid_Thread_Stack_Pointer (Current_Thread_Obj, Stack_Pointer) then
            --    HiRTOS_Low_Level_Debug_Interface.Print_String ("*** JGR: Invalid stack pointer: "); --???
            --    HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (System.Storage_Elements.To_Integer (Stack_Pointer)), End_line => True); --???
            --  end if;
            --???

            --???
            if Get_Cpu_Id = 3 then
              HiRTOS_Low_Level_Debug_Interface.Print_String ("*** JGR: Stack pointer: "); --???
              HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (System.Storage_Elements.To_Integer (Stack_Pointer)));
              HiRTOS_Low_Level_Debug_Interface.Print_String (", Nesting: "); --???
              HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (
                Get_Current_Interrupt_Nesting_Counter (RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack)), End_line => True); --???
            end if;
            --???
            HiRTOS.Thread_Private.Save_Thread_Stack_Pointer (Current_Thread_Obj, Stack_Pointer);
         end;

         --
         --  Set new sp to the bottom of the ISR stack:
         --
         New_Stack_Pointer := RTOS_Cpu_Instance.Interrupt_Stack_End_Address;
      else
         New_Stack_Pointer := Stack_Pointer;
      end if;

      --???
              --  HiRTOS_Low_Level_Debug_Interface.Print_String ("*** JGR enter > " & GNAT.Source_Info.Source_Location & ASCII.LF); --???
              --  HiRTOS_Low_Level_Debug_Interface.Print_String ("*** JGR enter new stack pointer: "); --???
              --  HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (System.Storage_Elements.To_Integer (New_Stack_Pointer)), End_line => True); --???
      --???
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
      return New_Stack_Pointer;
   end Enter_Interrupt_Context;

   function Exit_Interrupt_Context (Stack_Pointer : System.Address) return System.Address is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Current_Interrupt_Nesting_Counter : constant Interrupt_Nesting_Counter_Type :=
         Get_Current_Interrupt_Nesting_Counter (RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack);
      New_Stack_Pointer : System.Address;
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      --???
      --          HiRTOS_Low_Level_Debug_Interface.Print_String ("*** JGR exit < " & GNAT.Source_Info.Source_Location & ASCII.LF); --???
      --  HiRTOS_Low_Level_Debug_Interface.Print_String ("*** JGR exit interrupt nesting level: "); --???
      --  HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (Current_Interrupt_Nesting_Counter)); --???
      --          HiRTOS_Low_Level_Debug_Interface.Print_String (", old stack pointer: "); --???
      --          HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (System.Storage_Elements.To_Integer (New_Stack_Pointer)), End_line => True); --???
      --???
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
         begin
            Restore_Thread_Extended_Context (Current_Thread_Obj);
            HiRTOS.Interrupt_Handling_Private.Decrement_Interrupt_Nesting (
               RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack);

            --
            --  Restore saved stack pointer from the current RTOS task context:
            --
            New_Stack_Pointer := Thread_Private.Get_Thread_Stack_Pointer (Current_Thread_Obj);
              --  HiRTOS_Low_Level_Debug_Interface.Print_String ("*** JGR exit thread_id: "); --???
              --  HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (Current_Thread_Id), End_line => True); --???
         end;
      else
         pragma Assert (Current_Interrupt_Nesting_Counter > 1);
         HiRTOS.Interrupt_Handling_Private.Decrement_Interrupt_Nesting (
            RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack);
         New_Stack_Pointer := Stack_Pointer;
      end if;

      --???
              --  HiRTOS_Low_Level_Debug_Interface.Print_String ("*** JGR exit > " & GNAT.Source_Info.Source_Location & ASCII.LF); --???
              --  HiRTOS_Low_Level_Debug_Interface.Print_String ("*** JGR exit new stack pointer: "); --???
              --  HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (System.Storage_Elements.To_Integer (New_Stack_Pointer)), End_line => True); --???
      --???
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
      return New_Stack_Pointer;
   end Exit_Interrupt_Context;

   procedure RTOS_Tick_Timer_Interrupt_Handler is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Current_Thread_Id : constant Valid_Thread_Id_Type :=
               RTOS_Cpu_Instance.Current_Thread_Id;
      Current_Thread_Obj : Thread_Type renames
         HiRTOS_Obj.Thread_Instances (Current_Thread_Id);
   begin
      pragma Assert (Current_Thread_Obj.Time_Slice_Left_Us >= HiRTOS_Config_Parameters.Tick_Timer_Period_Us);
      RTOS_Cpu_Instance.Timer_Ticks_Since_Boot := @ + 1;
      Current_Thread_Obj.Time_Slice_Left_Us := @ - HiRTOS_Config_Parameters.Tick_Timer_Period_Us;
      HiRTOS.Timer_Private.Do_Software_Timers_Bookkeeping;
   end RTOS_Tick_Timer_Interrupt_Handler;

   function Get_Interrupted_PC return System.Address
   is
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Current_Interrupt_Nesting_Counter : constant Interrupt_Nesting_Counter_Type :=
         Get_Current_Interrupt_Nesting_Counter (RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack);
      Saved_Stack_Pointer : constant System.Address :=
         Get_Current_Interrupt_Nesting_Saved_Stack_Pointer (RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack);
      Cpu_Context : constant HiRTOS_Cpu_Arch_Interface.Thread_Context.Cpu_Context_Type with
         Import, Address => Saved_Stack_Pointer;
   begin
      return HiRTOS_Cpu_Arch_Interface.Thread_Context.Get_Saved_PC (Cpu_Context);
   end Get_Interrupted_PC;

end HiRTOS.Interrupt_Handling;