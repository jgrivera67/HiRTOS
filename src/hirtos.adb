
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
with HiRTOS.Platform_Interface;

--
--  @summary HiRTOS implementation
--
package body HiRTOS with SPARK_Mode => On is
   procedure Initialize (Interrupt_Stack_Base_Addr : System.Address;
                         Interrupt_Stack_Size : System.Storage_Elements.Integer_Address)
   is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS.Platform_Interface.Get_Cpu_Id);
   begin
      HiRTOS_Instance.Interrupt_Stack_Base_Addr := Interrupt_Stack_Base_Addr;
      HiRTOS_Instance.Interrupt_Stack_Size := Interrupt_Stack_Size;
      HiRTOS_Instance.Initialized := True;
   end Initialize;

   procedure Start_Thread_Scheduler is
   begin
      HiRTOS.Platform_Interface.First_Thread_Context_Switch;
   end Start_Thread_Scheduler;

   function Thread_Scheduler_Started return Boolean is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS.Platform_Interface.Get_Cpu_Id);
   begin
      return HiRTOS_Instance.Current_Thread_Id /= Invalid_Thread_Id;
   end Thread_Scheduler_Started;

   function Current_Execution_Context_Is_Interrupt return Boolean is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS.Platform_Interface.Get_Cpu_Id);
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
            HiRTOS_Instances (HiRTOS.Platform_Interface.Get_Cpu_Id);
         Current_Thread_Id : constant Thread_Id_Type :=
                  HiRTOS_Instance.Current_Thread_Id;
         Current_Thread_Ptr : constant Thread_Pointer_Type :=
            Get_Thread_Pointer (Current_Thread_Id);
      begin
         if Thread_Private.Get_Privilege_Nesting (Current_Thread_Ptr.all) = 0 then
            HiRTOS.Platform_Interface.Switch_Cpu_To_Privileged_Mode;
         else
            pragma Assert (HiRTOS.Platform_Interface.Cpu_In_Privileged_Mode);
         end if;

         Thread_Private.Increment_Privilege_Nesting (Current_Thread_Ptr.all);
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
            HiRTOS_Instances (HiRTOS.Platform_Interface.Get_Cpu_Id);
         Current_Thread_Id : Thread_Id_Type renames
            HiRTOS_Instance.Current_Thread_Id;
         Current_Thread_Ptr : constant Thread_Pointer_Type :=
            Get_Thread_Pointer (Current_Thread_Id);
      begin
         Thread_Private.Decrement_Privilege_Nesting (Current_Thread_Ptr.all);
         if Thread_Private.Get_Privilege_Nesting (Current_Thread_Ptr.all) = 0 then
            HiRTOS.Platform_Interface.Switch_Cpu_To_Unprivileged_Mode;
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
         HiRTOS_Instances (HiRTOS.Platform_Interface.Get_Cpu_Id);
      Stack_Pointer : constant Cpu_Register_Type :=
         HiRTOS.Platform_Interface.Get_Stack_Pointer;
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
            Current_Thread_Ptr : constant Thread_Pointer_Type :=
               Get_Thread_Pointer (Current_Thread_Id);
         begin
            --
            --  Save current sp in current RTOS task context:
            --
            Thread_Private.Save_Thread_Stack_Pointer (Current_Thread_Ptr.all, Stack_Pointer);
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
            HiRTOS.Platform_Interface.Set_Stack_Pointer (
               Cpu_Register_Type (Interrupt_Stack_Bottom_End_Addr));
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
         HiRTOS_Instances (HiRTOS.Platform_Interface.Get_Cpu_Id);
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
            Current_Thread_Ptr : constant Thread_Pointer_Type :=
               Get_Thread_Pointer (Current_Thread_Id);
            Stack_Pointer : constant Cpu_Register_Type :=
               Thread_Private.Get_Thread_Stack_Pointer (Current_Thread_Ptr.all);

         begin
            --
            --  Restore saved stack pointer from the current RTOS task context:
            --
            HiRTOS.Platform_Interface.Set_Stack_Pointer (Stack_Pointer);
         end;
      end if;
   end Exit_Interrupt_Context;

   procedure Switch_Thread_Context is
   begin
      null; -- TODO
   end Switch_Thread_Context;

   function Get_Thread_Pointer (Thread_Id : Thread_Id_Type) return Thread_Pointer_Type is
      HiRTOS_Instance : HiRTOS_Instance_Type renames
         HiRTOS_Instances (HiRTOS.Platform_Interface.Get_Cpu_Id);
      Thread_Node_Ptr : constant Thread_Queue.Node_Pointer_Type :=
         HiRTOS_Instance.Thread_Node_Array (Thread_Id)'Access;
   begin
      return Thread_Queue.Get_Node_Payload_Pointer (Thread_Node_Ptr);
   end Get_Thread_Pointer;

   function Running_In_Privileged_Mode return Boolean renames
      HiRTOS.Platform_Interface.Cpu_In_Privileged_Mode;

end HiRTOS;
