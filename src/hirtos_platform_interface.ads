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
--  @summary RTOS to target platform interface
--

with System.Storage_Elements;
with HiRTOS_Platform_Parameters;

package HiRTOS_Platform_Interface with SPARK_Mode => On is
   --
   --  Ids of CPU cores
   --
   type Cpu_Core_Id_Type is mod HiRTOS_Platform_Parameters.Num_Cpu_Cores;

   type Cpu_Register_Type is new System.Storage_Elements.Integer_Address;

   function Get_Cpu_Id return Cpu_Core_Id_Type
      with Inline_Always,
           Suppress => All_Checks;

   function Get_Call_Address return System.Address
      with Inline_Always,
           Suppress => All_Checks;

   function Get_Stack_Pointer return Cpu_Register_Type
      with Inline_Always,
           Suppress => All_Checks;

   procedure Set_Stack_Pointer (Stack_Pointer : Cpu_Register_Type)
      with Inline_Always,
           Suppress => All_Checks;

   function Get_Cpu_Status_Register return Cpu_Register_Type
      with Inline_Always,
           Suppress => All_Checks;

   function Cpu_Interrupting_Disabled return Boolean;

   --
   --  Disable interrupts at the CPU
   --
   --  NOTE: Only the IRQ interrupt is disabled, not the FIQ interrupt.
   --
   function Disable_Cpu_Interrupting return Cpu_Register_Type
      with Pre => Cpu_In_Privileged_Mode;

   --
   --  Restore interrupt enablement at the CPU
   --
   procedure Restore_Cpu_Interrupting (Old_Cpu_Interrupting : Cpu_Register_Type)
      with Pre => Cpu_In_Privileged_Mode and then
                  Cpu_Interrupting_Disabled;

   function Cpu_In_Privileged_Mode return Boolean;

   --
   --  Switch to CPU privileged mode
   --
   procedure Switch_Cpu_To_Privileged_Mode
      with Pre => not Cpu_In_Privileged_Mode and then
                  not Cpu_Interrupting_Disabled,
           Post => Cpu_In_Privileged_Mode;

   --
   --  Switch back to CPU unprivileged mode
   --
   procedure Switch_Cpu_To_Unprivileged_Mode
      with Pre => Cpu_In_Privileged_Mode and then
                  not Cpu_Interrupting_Disabled,
           Post => not Cpu_In_Privileged_Mode;

   function Ldrex_Word (Word_Address : System.Address) return Cpu_Register_Type
      with Inline_Always,
           Suppress => All_Checks;

   function Strex_Word (Word_Address : System.Address;
                        Value : Cpu_Register_Type) return Boolean
      with Inline_Always,
           Suppress => All_Checks;

   function Atomic_Fetch_Add
     (Counter_Address : System.Address;
      Value : Cpu_Register_Type) return Cpu_Register_Type
      with Inline_Always,
           Suppress => All_Checks;

   function Atomic_Fetch_Sub
     (Counter_Address : System.Address;
      Value : Cpu_Register_Type) return Cpu_Register_Type
      with Inline_Always,
           Suppress => All_Checks;

   --
   --  Perform the first thread thread context switch
   --
   procedure First_Thread_Context_Switch;

   --
   --  Perform a synchronous thread context switch
   --
   procedure Synchronous_Thread_Context_Switch;

   --
   --  Entry point of the supervisor call exception handler
   --
   procedure Supervisor_Call_Exception_Handler
      with Export,
           External_Name => "supervisor_call_exception_handler";
   pragma Machine_Attribute (Supervisor_Call_Exception_Handler, "naked");

   --
   --  Entry point of the prefetch abort exception handler
   --
   procedure Prefetch_Abort_Exception_Handler
      with Export,
           External_Name => "prefetch_abort_exception_handler";
   pragma Machine_Attribute (Prefetch_Abort_Exception_Handler, "naked");

   --
   --  Entry point of the data abort exception handler
   --
   procedure Data_Abort_Exception_Handler
      with Export,
           External_Name => "data_abort_exception_handler";
   pragma Machine_Attribute (Data_Abort_Exception_Handler, "naked");

   --
   --  Entry point of the external interrupt handler
   --
   procedure External_Interrupt_Handler
      with Export,
           External_Name => "external_interrupt_handler";
   pragma Machine_Attribute (External_Interrupt_Handler, "naked");

end HiRTOS_Platform_Interface;
