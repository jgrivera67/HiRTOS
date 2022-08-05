
--
--  Copyright (c) 2021, German Rivera
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

with HiRTOS.Thread_Private;
with HiRTOS.Interrupt_Nesting;

--
--  @summary HiRTOS implementation
--
package body HiRTOS with SPARK_Mode => On is
   procedure Initialize (Interrupt_Stack_Base_Addr : System.Address;
                         Interrupt_Stack_Size : System.Storage_Elements.Integer_Address)
   is
      Cpu_Id : constant Cpu_Core_Id_Type := HiRTOS_Platform_Interface.Get_Cpu_Id;
      HiRTOS_Instance : HiRTOS_Instance_Type renames HiRTOS_Instances (Cpu_Id);
   begin
      pragma Assert (not HiRTOS_Instance.Initialized);
      HiRTOS_Platform_Interface.Memory_Protection.Initialize;
      HiRTOS_Instance.Interrupt_Stack_Base_Addr := Interrupt_Stack_Base_Addr;
      HiRTOS_Instance.Interrupt_Stack_Size := Interrupt_Stack_Size;
      HiRTOS_Instance.Cpu_Id := Cpu_Id;
      HiRTOS_Instance.Initialized := True;
   end Initialize;

   procedure Start_Thread_Scheduler is
   begin
      HiRTOS_Platform_Interface.First_Thread_Context_Switch;
   end Start_Thread_Scheduler;

   function Thread_Scheduler_Started return Boolean is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
   begin
      return HiRTOS_Instance.Current_Thread_Id /= Invalid_Thread_Id;
   end Thread_Scheduler_Started;

   function Current_Execution_Context_Is_Interrupt return Boolean is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
   begin
      return Interrupt_Nesting.Get_Current_Interrupt_Nesting (
               HiRTOS_Instance.Interrupt_Nesting_Level_Stack) /= 0;
   end Current_Execution_Context_Is_Interrupt;

   procedure Enter_Cpu_Privileged_Mode is
   begin
      --
      --  If we are in interrupt context, we don't need to do anything,
      --  as ISRs and the reset handler always run in provileged mode.
      --
      if Current_Execution_Context_Is_Interrupt then
         return;
      end if;

      declare
         HiRTOS_Instance : HiRTOS_Instance_Type renames
            HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
         Current_Thread_Id : constant Thread_Id_Type :=
                  HiRTOS_Instance.Current_Thread_Id;
         Current_Thread_Obj : Thread_Type renames
            HiRTOS_Instance.Thread_Instances (Current_Thread_Id);
      begin
         if Thread_Private.Get_Privilege_Nesting (Current_Thread_Obj) = 0 then
            HiRTOS_Platform_Interface.Switch_Cpu_To_Privileged_Mode;
         else
            pragma Assert (HiRTOS_Platform_Interface.Cpu_In_Privileged_Mode);
         end if;

         Thread_Private.Increment_Privilege_Nesting (Current_Thread_Obj);
      end;
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
         HiRTOS_Instance : HiRTOS_Instance_Type renames
            HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
         Current_Thread_Id : Thread_Id_Type renames
            HiRTOS_Instance.Current_Thread_Id;
         Current_Thread_Obj : Thread_Type renames
            HiRTOS_Instance.Thread_Instances (Current_Thread_Id);
      begin
         Thread_Private.Decrement_Privilege_Nesting (Current_Thread_Obj);
         if Thread_Private.Get_Privilege_Nesting (Current_Thread_Obj) = 0 then
            HiRTOS_Platform_Interface.Switch_Cpu_To_Unprivileged_Mode;
         end if;
      end;
   end Exit_Cpu_Privileged_Mode;

   --
   --  Inline subprogram to be invoked from Interrupt_Handler_Prolog.
   --
   --  NOTE: All subprograms invoked from this subprogram must be
   --  inline subprograms.
   --
   procedure Enter_Interrupt_Context is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Stack_Pointer : constant HiRTOS_Platform_Interface.Cpu_Register_Type :=
         HiRTOS_Platform_Interface.Get_Stack_Pointer;
      Current_Thread_Id : constant Thread_Id_Type :=
               HiRTOS_Instance.Current_Thread_Id;
   begin
      Interrupt_Nesting.Increment_Interrupt_Nesting (
         HiRTOS_Instance.Interrupt_Nesting_Level_Stack, Stack_Pointer);

      if Interrupt_Nesting.Get_Current_Interrupt_Nesting
          (HiRTOS_Instance.Interrupt_Nesting_Level_Stack) = 1
      then
         --
         --  Interupted context must be a thread
         --
         pragma Assert (Current_Thread_Id /= Invalid_Thread_Id);

         declare
            Current_Thread_Obj : Thread_Type renames
               HiRTOS_Instance.Thread_Instances (Current_Thread_Id);
         begin
            --
            --  Save current sp in current RTOS task context:
            --
            Thread_Private.Save_Thread_Stack_Pointer (Current_Thread_Obj, Stack_Pointer);
         end;

         --
         --  Set current CPU core's sp to the bottom of the ISR stack:
         --
         declare
            use type System.Storage_Elements.Integer_Address;
            Interrupt_Stack_Bottom_End_Addr : constant System.Storage_Elements.Integer_Address :=
               System.Storage_Elements.To_Integer (HiRTOS_Instance.Interrupt_Stack_Base_Addr) +
               HiRTOS_Instance.Interrupt_Stack_Size;
         begin
            HiRTOS_Platform_Interface.Set_Stack_Pointer (
               HiRTOS_Platform_Interface.Cpu_Register_Type (Interrupt_Stack_Bottom_End_Addr));
         end;
      end if;
   end Enter_Interrupt_Context;

   --
   --  Inline subprogram to be invoked from Interrupt_Handler_Epilog.
   --
   --  NOTE: All subprograms invoked from this subprogram must be
   --  inline subprograms.
   --
   procedure Exit_Interrupt_Context is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
   begin
      Interrupt_Nesting.Decrement_Interrupt_Nesting (
         HiRTOS_Instance.Interrupt_Nesting_Level_Stack);

      --
      --  If interrupt nesting level dropped to 0, run the thread scheduler
      --  in case the highest priority runnable thread has changed:
      --
      if Interrupt_Nesting.Get_Current_Interrupt_Nesting
          (HiRTOS_Instance.Interrupt_Nesting_Level_Stack) = 0
      then
         HiRTOS.Thread_Private.Run_Thread_Scheduler;

         declare
            Current_Thread_Id : constant Thread_Id_Type :=
                  HiRTOS_Instance.Current_Thread_Id;
            Current_Thread_Obj : Thread_Type renames
               HiRTOS_Instance.Thread_Instances (Current_Thread_Id);
            Stack_Pointer : constant HiRTOS_Platform_Interface.Cpu_Register_Type :=
               Thread_Private.Get_Thread_Stack_Pointer (Current_Thread_Obj);

         begin
            --
            --  Restore saved stack pointer from the current RTOS task context:
            --
            HiRTOS_Platform_Interface.Set_Stack_Pointer (Stack_Pointer);
         end;
      end if;
   end Exit_Interrupt_Context;

   function Running_In_Privileged_Mode return Boolean renames
      HiRTOS_Platform_Interface.Cpu_In_Privileged_Mode;

   --
   --  Timer list node accessors
   --

   function Get_Next_Timer (Timer_Id : Timer_Id_Type) return Timer_Id_Type is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Timer_Obj : Timer_Type renames HiRTOS_Instance.Timer_Instances (Timer_Id);
   begin
      return Timer_Obj.List_Node.Next_Element_Id;
   end Get_Next_Timer;

   procedure Set_Next_Timer (Timer_Id : Timer_Id_Type;
                             Next_Timer_Id : Timer_Id_Type) is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Timer_Obj : Timer_Type renames HiRTOS_Instance.Timer_Instances (Timer_Id);
   begin
      Timer_Obj.List_Node.Next_Element_Id := Next_Timer_Id;
   end Set_Next_Timer;

   function Get_Prev_Timer (Timer_Id : Timer_Id_Type) return Timer_Id_Type is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Timer_Obj : Timer_Type renames HiRTOS_Instance.Timer_Instances (Timer_Id);
   begin
      return Timer_Obj.List_Node.Prev_Element_Id;
   end Get_Prev_Timer;

   procedure Set_Prev_Timer (Timer_Id : Timer_Id_Type;
                             Prev_Timer_Id : Timer_Id_Type) is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Timer_Obj : Timer_Type renames HiRTOS_Instance.Timer_Instances (Timer_Id);
   begin
      Timer_Obj.List_Node.Prev_Element_Id := Prev_Timer_Id;
   end Set_Prev_Timer;

   function Get_Containing_Timer_List (Timer_Id : Timer_Id_Type) return Timer_Wheel_Spoke_Index_Type
   is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Timer_Obj : Timer_Type renames HiRTOS_Instance.Timer_Instances (Timer_Id);
   begin
      return Timer_Obj.List_Node.Containing_List_Id;
   end Get_Containing_Timer_List;

   procedure Set_Containing_Timer_List (Timer_Id : Timer_Id_Type;
                                        List_Id : Timer_Wheel_Spoke_Index_Type) is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Timer_Obj : Timer_Type renames HiRTOS_Instance.Timer_Instances (Timer_Id);
   begin
      Timer_Obj.List_Node.Containing_List_Id := List_Id;
   end Set_Containing_Timer_List;

   --
   --  Thread queue node accessors
   --

   function Get_Next_Thread (Thread_Id : Thread_Id_Type) return Thread_Id_Type is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Thread_Obj : Thread_Type renames HiRTOS_Instance.Thread_Instances (Thread_Id);
   begin
      return Thread_Obj.List_Node.Next_Element_Id;
   end Get_Next_Thread;

   procedure Set_Next_Thread (Thread_Id : Thread_Id_Type;
                             Next_Thread_Id : Thread_Id_Type) is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Thread_Obj : Thread_Type renames HiRTOS_Instance.Thread_Instances (Thread_Id);
   begin
      Thread_Obj.List_Node.Next_Element_Id := Next_Thread_Id;
   end Set_Next_Thread;

   function Get_Prev_Thread (Thread_Id : Thread_Id_Type) return Thread_Id_Type is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Thread_Obj : Thread_Type renames HiRTOS_Instance.Thread_Instances (Thread_Id);
   begin
      return Thread_Obj.List_Node.Prev_Element_Id;
   end Get_Prev_Thread;

   procedure Set_Prev_Thread (Thread_Id : Thread_Id_Type;
                             Prev_Thread_Id : Thread_Id_Type) is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Thread_Obj : Thread_Type renames HiRTOS_Instance.Thread_Instances (Thread_Id);
   begin
      Thread_Obj.List_Node.Prev_Element_Id := Prev_Thread_Id;
   end Set_Prev_Thread;

   function Get_Containing_Thread_Queue (Thread_Id : Thread_Id_Type) return Thread_Queue_Id_Type is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Thread_Obj : Thread_Type renames HiRTOS_Instance.Thread_Instances (Thread_Id);
   begin
      return Thread_Obj.List_Node.Containing_List_Id;
   end Get_Containing_Thread_Queue;

   procedure Set_Containing_Thread_Queue (Thread_Id : Thread_Id_Type;
                                         List_Id : Thread_Queue_Id_Type) is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Thread_Obj : Thread_Type renames HiRTOS_Instance.Thread_Instances (Thread_Id);
   begin
      Thread_Obj.List_Node.Containing_List_Id := List_Id;
   end Set_Containing_Thread_Queue;

   --
   --  Mutex list node accessors
   --

   function Get_Next_Mutex (Mutex_Id : Mutex_Id_Type) return Mutex_Id_Type is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Mutex_Obj : Mutex_Type renames HiRTOS_Instance.Mutex_Instances (Mutex_Id);
   begin
      return Mutex_Obj.List_Node.Next_Element_Id;
   end Get_Next_Mutex;

   procedure Set_Next_Mutex (Mutex_Id : Mutex_Id_Type;
                             Next_Mutex_Id : Mutex_Id_Type) is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Mutex_Obj : Mutex_Type renames HiRTOS_Instance.Mutex_Instances (Mutex_Id);
   begin
      Mutex_Obj.List_Node.Next_Element_Id := Next_Mutex_Id;
   end Set_Next_Mutex;

   function Get_Prev_Mutex (Mutex_Id : Mutex_Id_Type) return Mutex_Id_Type is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Mutex_Obj : Mutex_Type renames HiRTOS_Instance.Mutex_Instances (Mutex_Id);
   begin
      return Mutex_Obj.List_Node.Prev_Element_Id;
   end Get_Prev_Mutex;

   procedure Set_Prev_Mutex (Mutex_Id : Mutex_Id_Type;
                             Prev_Mutex_Id : Mutex_Id_Type) is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Mutex_Obj : Mutex_Type renames HiRTOS_Instance.Mutex_Instances (Mutex_Id);
   begin
      Mutex_Obj.List_Node.Prev_Element_Id := Prev_Mutex_Id;
   end Set_Prev_Mutex;

   function Get_Containing_Mutex_List (Mutex_Id : Mutex_Id_Type) return Thread_Id_Type is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Mutex_Obj : Mutex_Type renames HiRTOS_Instance.Mutex_Instances (Mutex_Id);
   begin
      return Mutex_Obj.List_Node.Containing_List_Id;
   end Get_Containing_Mutex_List;

   procedure Set_Containing_Mutex_List (Mutex_Id : Mutex_Id_Type;
                                        List_Id : Thread_Id_Type) is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS_Platform_Interface.Get_Cpu_Id);
      Mutex_Obj : Mutex_Type renames HiRTOS_Instance.Mutex_Instances (Mutex_Id);
   begin
      Mutex_Obj.List_Node.Containing_List_Id := List_Id;
   end Set_Containing_Mutex_List;

end HiRTOS;
