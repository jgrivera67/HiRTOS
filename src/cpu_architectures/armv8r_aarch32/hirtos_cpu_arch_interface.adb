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

--
--  @summary HiRTOS to target platform interface for ARMv8-R architecture
--

with HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
with Interfaces;
with System.Machine_Code;
with System.Storage_Elements;

package body HiRTOS_Cpu_Arch_Interface is
   use ASCII;

   --
   --   Bit masks for CPSR bit fields
   --
   --  CPSR_F_Bit_Mask : constant := 2#0100_0000#; --  bit 6
   CPSR_I_Bit_Mask : constant Cpu_Register_Type := 2#1000_0000#; --  bit 7
   CPSR_Mode_Mask : constant Cpu_Register_Type :=  2#0001_1111#; --  bits [4:0]

   MPIDR_Core_Id_Mask : constant := 2#1111_1111#;

   procedure Prefetch_Abort_Exception_App_Handler
      with Import,
           Convention => C,
           External_Name => "prefetch_abort_exception_app_handler";

   procedure Data_Abort_Exception_App_Handler
      with Import,
           Convention => C,
           External_Name => "data_abort_exception_app_handler";

   procedure External_Interrupt_App_Handler
      with Import,
           Convention => C,
           External_Name => "external_interrupt_app_handler";

   function Get_Cpu_Id return Cpu_Core_Id_Type is
      Reg_Value : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c0, c0, 5",   -- read MPIDR
         Outputs => Cpu_Register_Type'Asm_Output ("=r", Reg_Value),           --  %0
         Volatile => True);

      Reg_Value := @ and MPIDR_Core_Id_Mask;
      return Cpu_Core_Id_Type (Reg_Value);
   end Get_Cpu_Id;

   function Get_Cpu_Status_Register return Cpu_Register_Type is
      Reg_Value : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, cpsr",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", Reg_Value),
         Volatile => True);

      return Reg_Value;
   end Get_Cpu_Status_Register;

   function Get_Call_Address return System.Address is
      Reg_Value : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "mov %0, lr",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", Reg_Value),
         Volatile => True);

      return System.Storage_Elements.To_Address (
               System.Storage_Elements.Integer_Address (
                  Reg_Value - HiRTOS_Cpu_Arch_Parameters.Call_Instruction_Size));
   end Get_Call_Address;

   function Get_Stack_Pointer return Cpu_Register_Type is
      Stack_Pointer : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "mov %0, sp",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", Stack_Pointer),
         Volatile => True);

      return Stack_Pointer;
   end Get_Stack_Pointer;

   procedure Set_Stack_Pointer (Stack_Pointer : Cpu_Register_Type) is
   begin
      System.Machine_Code.Asm (
         "mov sp, %0",
         Inputs => Cpu_Register_Type'Asm_Input ("r", Stack_Pointer),
         Volatile => True);
   end Set_Stack_Pointer;

   function Cpu_Interrupting_Disabled return Boolean is
      CPSR_Value : constant Cpu_Register_Type := Get_Cpu_Status_Register;
   begin
      return (CPSR_Value and CPSR_I_Bit_Mask) /= 0;
   end Cpu_Interrupting_Disabled;

   function Disable_Cpu_Interrupting return Cpu_Register_Type
   is
      CPSR_Value : constant Cpu_Register_Type := Get_Cpu_Status_Register;
   begin
      if (CPSR_Value and CPSR_I_Bit_Mask) = 0 then
         System.Machine_Code.Asm (
            "cpsid i" & LF &
            "dsb" & LF &
            "isb",
            Clobber => "memory",
            Volatile => True);
      end if;

      pragma Assert (Cpu_Interrupting_Disabled);
      return CPSR_Value;
   end Disable_Cpu_Interrupting;

   procedure Restore_Cpu_Interrupting (Old_Cpu_Interrupting : Cpu_Register_Type) is
   begin
      if (Old_Cpu_Interrupting and CPSR_I_Bit_Mask) = 0 then
         System.Machine_Code.Asm (
            "dsb" & LF &
            "isb" & LF &
            "cpsie i",
            Clobber => "memory",
            Volatile => True);
      end if;
   end Restore_Cpu_Interrupting;

   function Cpu_In_Privileged_Mode return Boolean is
      CPSR_Value : constant Cpu_Register_Type := Get_Cpu_Status_Register;
   begin
      return (CPSR_Value and CPSR_Mode_Mask) /= CPSR_User_Mode;
   end Cpu_In_Privileged_Mode;

   --
   --  Transitions the CPU from user-mode to sys-mode with interrupts
   --  enabled.
   --
   procedure Switch_Cpu_To_Privileged_Mode is
      CPSR_Value : constant Cpu_Register_Type := Get_Cpu_Status_Register;
   begin
         --
         --  We are not in privileged mode, so interrupts must be enabled:
         --
         --  NOTE: It is a bug to be in non-privileged mode with interrupts disabled.
         --
         pragma Assert ((CPSR_Value and CPSR_I_Bit_Mask) = 0);

         --
         --  Switch to privileged mode:
         --
         --  NOTE: The SVC exception handler sets `Cpu_Privileged_Nesting_Counter` to 1
         --
         System.Machine_Code.Asm (
            "mov r0, #1" & LF &
            "svc #0",
            Clobber => "r0",
            Volatile => True);

         --
         --  NOTE: We returned here in privileged mode.
         --
   end Switch_Cpu_To_Privileged_Mode;

   --
   --  Transitions the CPU from sys-mode to user-mode with interrupts enabled.
   --
   procedure Switch_Cpu_To_Unprivileged_Mode
   is
   begin
      --  Switch to unprivileged mode:
      System.Machine_Code.Asm (
         "cpsie i, %0" & LF &
         "isb",
         Inputs => Interfaces.Unsigned_8'Asm_Input ("g", CPSR_User_Mode), --  %0
         Volatile => True);
   end Switch_Cpu_To_Unprivileged_Mode;

   function Ldrex_Word (Word_Address : System.Address) return Cpu_Register_Type is
      Result : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
          "ldrex %0, [%1]",
           Outputs => Cpu_Register_Type'Asm_Output ("=r", Result), --  %0
           Inputs => System.Address'Asm_Input ("r", Word_Address), --  %1
           Volatile => True);

      return Result;
   end Ldrex_Word;

   function Strex_Word (Word_Address : System.Address;
                        Value : Cpu_Register_Type) return Boolean
   is
      Result : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm ("strex %0, %1, [%2]",
           Outputs =>
              Cpu_Register_Type'Asm_Output ("=r", Result),    -- %0
           Inputs =>
              [Cpu_Register_Type'Asm_Input ("r", Value),      -- %1
               System.Address'Asm_Input ("r", Word_Address)], -- %2
           Clobber => "memory",
           Volatile => True);

      return Result = 0;
   end Strex_Word;

   function Atomic_Fetch_Add
     (Counter_Address : System.Address;
      Value : Cpu_Register_Type) return Cpu_Register_Type
   is
      Old_Value : Cpu_Register_Type;
   begin
      loop
         Old_Value := Ldrex_Word (Counter_Address);
         exit when Strex_Word (Counter_Address, Old_Value + Value);
      end loop;

      return Old_Value;
   end Atomic_Fetch_Add;

   function Atomic_Fetch_Sub
     (Counter_Address : System.Address;
      Value : Cpu_Register_Type) return Cpu_Register_Type
   is
      Old_Value : Cpu_Register_Type;
   begin
      loop
         Old_Value := Ldrex_Word (Counter_Address);
         exit when Strex_Word (Counter_Address, Old_Value - Value);
      end loop;

      return Old_Value;
   end Atomic_Fetch_Sub;

   procedure Do_Synchronous_Context_Switch
      with Export,
           External_Name => "do_synchronous_context_switch";
   pragma Machine_Attribute (Do_Synchronous_Context_Switch, "naked");

   procedure Handle_Invalid_SVC_Exception
      with Export,
           External_Name => "handle_invalid_svc_exception";
   pragma Machine_Attribute (Handle_Invalid_SVC_Exception, "naked");

   procedure First_Thread_Context_Switch is
   begin
      --
      --  NOTE: To start executing the first thread, we pretend that we are returning from an
      --  interrupt, since before RTOS tasking is started, we have executing in the reset exception
      --  handler.
      --
      HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Interrupt_Handler_Epilog;
   end First_Thread_Context_Switch;

   procedure Synchronous_Thread_Context_Switch is
   begin
      --
      --  Initiate a synchronous thread context switch by doing
      --  a Supervisor call, passing 0 in r0
      --
      System.Machine_Code.Asm (
         "mov r0, #0" & LF &
         "svc #0",
         Clobber => "r0",
         Volatile => True);
   end Synchronous_Thread_Context_Switch;

   --
   --  SVC instruction exception handler
   --
   --  Register r0 indicates the action to perform:
   --  - 0 perform RTOS task synchronous context switch
   --  - 1 switch to privileged mode and return to the caller
   --
   --  CAUTION: This subprogram cannot use any stack space as we
   --  do not define a stack for SVC mode.
   --
   procedure Supervisor_Call_Exception_Handler is
   begin
      System.Machine_Code.Asm (
         --  TODO: Change to get the SVC instruction immediate operand
         --  "ldr r0, [lr, #-4]" & LF &
         --  "ubfx r0, r0, #0, #24" & LF &
         "teq r0, #0" & LF & --  RTOS synchronous task context switch?
         "beq do_synchronous_context_switch" & LF &
         "teq r0, #1" & LF & --  Enter_Cpu_Privileged_Mode call?
         "beq stay_in_cpu_privileged_mode" & LF &
         "b handle_invalid_svc_exception",
         Clobber => "r0",
         Volatile => True);
   end Supervisor_Call_Exception_Handler;

   --
   --  CAUTION: This subprogram cannot use any stack space, before
   --  it calls Interrupt_Hanlder_Prolog, as we do not define a stack
   --  for SVC mode.
   --
   procedure Do_Synchronous_Context_Switch is
   begin
      --  Save the current thread's CPU state on its own stack
      HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Interrupt_Handler_Prolog;

      --  Run the thread scheduler to select next thread to run and
      --  resume execution of the newly selected thread
      HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Interrupt_Handler_Epilog;
   end Do_Synchronous_Context_Switch;

   procedure Prefetch_Abort_Exception_Handler is
   begin
      --
      --  NOTE: We cannot call Interrupt_Handler_Prolog to save the
      --  current thread's CPU state on its own stack, because if the
      --  data abort is caused by a stack overflow, that will cause another
      --  data abort (recursively)
      --
      --  TODO: Set up abort mode stack in the reset handler
      --
      Prefetch_Abort_Exception_App_Handler;
      raise Program_Error;
   end Prefetch_Abort_Exception_Handler;

   procedure Data_Abort_Exception_Handler is
   begin
      --
      --  NOTE: We cannot call Interrupt_Handler_Prolog to save the
      --  current thread's CPU state on its own stack, because if the
      --  data abort is caused by a stack overflow, that will cause another
      --  data abort (recursively).
      --
      --  TODO: Set up abort mode stack in the reset handler
      --
      Data_Abort_Exception_App_Handler;
      raise Program_Error;
   end Data_Abort_Exception_Handler;

   procedure External_Interrupt_Handler is
   begin
      --
      --  Adjust lr to point to the instruction we need to return to after
      --  handling the interrupt (see table B1-7, section B1.8.3 in ARMv7-AR ARM)
      --
      System.Machine_Code.Asm (
         "sub lr, lr, %0",
         Inputs =>
            (Interfaces.Unsigned_8'Asm_Input ("g",
                                              HiRTOS_Cpu_Arch_Parameters.Integer_Register_Size_In_Bytes)), -- %0
         Volatile => True);

      --  Save the current thread's CPU state on its own stack
      HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Interrupt_Handler_Prolog;

      External_Interrupt_App_Handler;

      --  Run the thread scheduler to select next thread to run and
      --  resume execution of the newly selected thread
      HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Interrupt_Handler_Epilog;
   end External_Interrupt_Handler;

   procedure Handle_Invalid_SVC_Exception is
   begin
      null; -- ???
   end Handle_Invalid_SVC_Exception;

end HiRTOS_Cpu_Arch_Interface;
