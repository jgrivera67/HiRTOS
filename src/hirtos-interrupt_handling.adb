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

with HiRTOS.RTOS_Private;
with HiRTOS.Interrupt_Handling_Private;
with HiRTOS.Thread_Private;
with HiRTOS_Cpu_Arch_Interface;
with HiRTOS_Cpu_Multi_Core_Interface;
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
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Stack_Pointer : constant HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type :=
         HiRTOS_Cpu_Arch_Interface.Get_Stack_Pointer;
      Current_Thread_Id : constant Thread_Id_Type :=
               RTOS_Cpu_Instance.Current_Thread_Id;
   begin
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
            --
            --  Save current sp in current RTOS task context:
            --
            HiRTOS.Thread_Private.Save_Thread_Stack_Pointer (Current_Thread_Obj, Stack_Pointer);
         end;

         --
         --  Set current CPU core's sp to the bottom of the ISR stack:
         --
         declare
            use type System.Storage_Elements.Integer_Address;
            Interrupt_Stack_Bottom_End_Addr : constant System.Storage_Elements.Integer_Address :=
               System.Storage_Elements.To_Integer (RTOS_Cpu_Instance.Interrupt_Stack_Base_Addr) +
               RTOS_Cpu_Instance.Interrupt_Stack_Size;
         begin
            HiRTOS_Cpu_Arch_Interface.Set_Stack_Pointer (
               HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type (Interrupt_Stack_Bottom_End_Addr));
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
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
   begin
      HiRTOS.Interrupt_Handling_Private.Decrement_Interrupt_Nesting (
         RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack);

      --
      --  If interrupt nesting level dropped to 0, run the thread scheduler
      --  in case the highest priority runnable thread has changed:
      --
      if HiRTOS.Interrupt_Handling_Private.Get_Current_Interrupt_Nesting
          (RTOS_Cpu_Instance.Interrupt_Nesting_Level_Stack) = 0
      then
         HiRTOS.Thread_Private.Run_Thread_Scheduler;

         declare
            Current_Thread_Id : constant Thread_Id_Type :=
                  RTOS_Cpu_Instance.Current_Thread_Id;
            Current_Thread_Obj : Thread_Type renames
               HiRTOS_Obj.Thread_Instances (Current_Thread_Id);
            Stack_Pointer : constant HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type :=
               Thread_Private.Get_Thread_Stack_Pointer (Current_Thread_Obj);

         begin
            --
            --  Restore saved stack pointer from the current RTOS task context:
            --
            HiRTOS_Cpu_Arch_Interface.Set_Stack_Pointer (Stack_Pointer);
         end;
      end if;
   end Exit_Interrupt_Context;

end HiRTOS.Interrupt_Handling;
