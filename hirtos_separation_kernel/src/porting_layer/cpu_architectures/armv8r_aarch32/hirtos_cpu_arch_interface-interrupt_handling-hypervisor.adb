--
--  Copyright (c) 2022-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target platform interface for ARMv8-R architecture - Interrupt handling
--

with HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
with HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor;
with HiRTOS_Cpu_Arch_Interface.System_Registers.Hypervisor;
with HiRTOS_Cpu_Arch_Interface_Private;
with System.Machine_Code;
with Interfaces;

package body HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Hypervisor is
   use ASCII;
   use HiRTOS_Cpu_Arch_Interface_Private;
   use HiRTOS_Cpu_Arch_Interface.System_Registers.Hypervisor;

   Per_Cpu_Hypervisor_Trap_Callback_Array :
      array (Valid_Cpu_Core_Id_Type) of Hypervisor_Trap_Callback_Type := [others => null];

   procedure Register_Hypervisor_Trap_Callback (Hypervisor_Trap_Callback : Hypervisor_Trap_Callback_Type)
   is
   begin
      Per_Cpu_Hypervisor_Trap_Callback_Array (Get_Cpu_Id) := Hypervisor_Trap_Callback;
   end Register_Hypervisor_Trap_Callback;

   --
   --  Entry point of the EL2 undefined instruction exception handler
   --
   procedure EL2_Undefined_Instruction_Exception_Handler
      with Export,
           External_Name => "el2_undefined_instruction_exception_handler";
   pragma Machine_Attribute (EL2_Undefined_Instruction_Exception_Handler, "naked");

   --
   --  Entry point of the EL2 hypervisor call exception handler
   --
   procedure EL2_Hypervisor_Exception_Handler
      with Export,
           External_Name => "el2_hypervisor_exception_handler";
   pragma Machine_Attribute (EL2_Hypervisor_Exception_Handler, "naked");

   --
   --  Entry point of the EL2 prefetch abort exception handler
   --
   procedure EL2_Prefetch_Abort_Exception_Handler
      with Export,
           External_Name => "el2_prefetch_abort_exception_handler";
   pragma Machine_Attribute (EL2_Prefetch_Abort_Exception_Handler, "naked");

   --
   --  Entry point of the EL2 data abort exception handler
   --
   procedure EL2_Data_Abort_Exception_Handler
      with Export,
           External_Name => "el2_data_abort_exception_handler";
   pragma Machine_Attribute (EL2_Data_Abort_Exception_Handler, "naked");

   --
   --  Entry point of the EL2 IRQ interrupt handler
   --
   procedure EL2_Irq_Interrupt_Handler
      with Export,
           External_Name => "el2_irq_interrupt_handler";
   pragma Machine_Attribute (EL2_Irq_Interrupt_Handler, "naked");

   --
   --  Entry point of the EL2 FIQ interrupt handler
   --
   procedure EL2_Fiq_Interrupt_Handler
      with Export,
           External_Name => "el2_fiq_interrupt_handler";
   pragma Machine_Attribute (EL2_Fiq_Interrupt_Handler, "naked");

   procedure Interrupt_Handler_Prolog
      with Inline_Always;

   --
   --  Inline subprogram to be invoked at the beginning of top-level EL2 interrupt
   --  handlers from which the partition scheduler can be called upon exit.
   --
   --  @pre  interrupts are disabled at the CPU
   --  @pre  sp_hyp points to bottom of current partition's hypervisor stack
   --  @pre  CPU is in HYP mode
   --  @post CPU is in HYP mode
   --
   --  NOTE: We cannot check preconditions, as that would insert code
   --  at the beginning of this subprogram, which would clobber the CPU registers
   --  before we save them.
   --
   procedure Interrupt_Handler_Prolog is
   begin
      System.Machine_Code.Asm (
         --
         --  Save general-purpose registers on the stack:
         --
         --  NOTE: The interrupted context's register r13 (sp) does not need to
         --  be saved here, as it is saved in the partition's extended CPU context.
         --  sp points to the end of the current partition's CPU_Context.
         --
         "push    {r0-r12, r14}" & LF &

         --
         --  Save elr_hyp and spsr_hyp:
         --
         "mrs     r0, elr_hyp" & LF &
         "mrs     r1, spsr" & LF &
         "push    {r0-r1}" & LF &

         --
         --  Save floating-point registers on the stack:
         --
         --  NOTE: We need to save the floating point registers even if ISRs do not
         --  explicitly use floating point registers, as the compiler may still
         --  generate code to use floating point registers to temporarily save integer
         --  registers for any function.
         --
         "sub  sp, sp, %1" & LF & --  skip alignment hole
         "vmrs r1, fpscr" & LF &
         "push {r1}" & LF &
         "vpush {d0-d15}" & LF &
         "sub sp, sp, #4" & LF &

         --
         --  sp points to the current partition's CPU_Context.
         --
         "ldr sp, [sp]" & LF &

         --
         --  Set frame pointer to be the same as stack pointer:
         --  (needed for stack unwinding across interrupted contexts)
         --
         "mov     fp, sp",
         Inputs =>
            [Interfaces.Unsigned_8'Asm_Input ("g", CPSR_System_Mode),  --  %0
             Interfaces.Unsigned_8'Asm_Input ("g",
                                              HiRTOS_Cpu_Arch_Parameters.Integer_Register_Size_In_Bytes)], -- %1
         Volatile => True);
   end Interrupt_Handler_Prolog;

   --
   --  Inline subprogram to be invoked at the end of top-level EL2 interrupt
   --  handlers from which the partition scheduler can be called upon exit.
   --
   --  It restores the CPU state that was saved by a previous invocation to
   --  Hypervisor_Interrupt_Handler_Prolog, and then executes an 'eret' instruction.
   --
   --  @pre  interrupts are disabled at the CPU
   --  @pre  CPU is in HYP mode
   --  @post PC = return address from interrupt (next instruction to execute in
   --        interrupted code)
   --  @post current CPU privilege = privilege level of interrupted code
   --
   procedure Interrupt_Handler_Epilog is
   begin
      System.Machine_Code.Asm (
         --
         --  Set sp to value returned by HiRTOS.Separation_Kernel.Interrupt_Handling.Exit_Interrupt_Context,
         --  which is the address of the new current partitions' CPU_Context.
         --
         "bl hirtos_separation_kernel_exit_interrupt_context" & LF &
         "add sp, r0, #4" & LF & -- skip Interrupt_Stack_End_Address field

         --
         --  Restore floating-point registers from the stack:
         --
         "vpop    {d0-d15}" & LF &
         "pop     {r1}" & LF &
         "vmsr    fpscr, r1" & LF &
         "add     sp, sp, %0" & LF & --  skip alignment hole

         --
         --  Restore elr_hyp and spsr_hyp:
         --
         "pop     {r0-r1}" & LF &
         "msr     elr_hyp, r0" & LF &
         "msr     spsr, r1" & LF &

         --
         --  Restore general-purpose registers saved on the stack:
         --
         --  NOTE: register r13 (sp) does not need to be restored here,
         --  as we already restored it from the thread context
         --
         "pop     {r0-r12, r14}" & LF &

         --
         --  Return from EL2 exception:
         --  - elr_hyp = PC to return to from the EL2 exception
         --  - spsr_hyp = target context cpsr
         --  - sp_hyp = address of end of current partition's CPU context
         --
         "eret",
         Inputs =>
            (Interfaces.Unsigned_8'Asm_Input ("g",
                                              HiRTOS_Cpu_Arch_Parameters.Integer_Register_Size_In_Bytes)), -- %0
         Volatile => True);

      pragma Assert (False);
      loop
         Wait_For_Interrupt;
      end loop;
   end Interrupt_Handler_Epilog;

   ----------------------------------------------------------------------------
   --  Interrupt and Exception Handlers
   ----------------------------------------------------------------------------

   procedure EL2_Undefined_Instruction_Exception_Handler is
   begin
      Interrupt_Handler_Prolog;
      Handle_Undefined_Instruction_Exception;
      Interrupt_Handler_Epilog;
   end EL2_Undefined_Instruction_Exception_Handler;

   --
   --  Hypervisor (EL2) exception handler
   --
   procedure EL2_Hypervisor_Exception_Handler is
   begin
      --  Save the current partition's CPU state on its own stack
      Interrupt_Handler_Prolog;

      declare
         HSR_Value : constant HSR_Type := Get_HSR;
         Hypervisor_Trap_Callback : constant Hypervisor_Trap_Callback_Type :=
            Per_Cpu_Hypervisor_Trap_Callback_Array (Get_Cpu_Id);
      begin
         case HSR_Value.EC is
            when HSR_Exception_From_WFI_WFE =>
               if Hypervisor_Trap_Callback /= null then
                  Hypervisor_Trap_Callback.all (WFI_Instruction_Executed);
               end if;
            when HSR_Exception_From_HVC_Executed =>
               if Hypervisor_Trap_Callback /= null then
                  Hypervisor_Trap_Callback.all (HVC_Instruction_Executed);
               end if;
            when HSR_Exception_From_Prefetch_Abort_Routed_To_EL2 |
                 HSR_Exception_From_Prefetch_Abort_At_EL2 =>
               Memory_Protection.Hypervisor.Handle_Prefetch_Abort_Exception;
            when HSR_Exception_From_Data_Abort_Routed_To_EL2 |
                 HSR_Exception_From_Data_Abort_At_EL2 =>
               Memory_Protection.Hypervisor.Handle_Data_Abort_Exception;
            when others =>
               null;
         end case;
      end;

      --  Run the partition scheduler to select next partition to run and
      --  resume execution of the newly selected partition
      Interrupt_Handler_Epilog;
   end EL2_Hypervisor_Exception_Handler;

   procedure EL2_Prefetch_Abort_Exception_Handler is
   begin
      Interrupt_Handler_Prolog;
      Memory_Protection.Hypervisor.Handle_Prefetch_Abort_Exception;
      Interrupt_Handler_Epilog;
   end EL2_Prefetch_Abort_Exception_Handler;

   procedure EL2_Data_Abort_Exception_Handler is
   begin
      Interrupt_Handler_Prolog;
      Memory_Protection.Hypervisor.Handle_Data_Abort_Exception;
      Interrupt_Handler_Epilog;
   end EL2_Data_Abort_Exception_Handler;

   procedure EL2_Irq_Interrupt_Handler is
   begin
      Interrupt_Handler_Prolog;

      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.GIC_Interrupt_Handler (
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Cpu_Interrupt_Irq);

      Interrupt_Handler_Epilog;
   end EL2_Irq_Interrupt_Handler;

   procedure EL2_Fiq_Interrupt_Handler is
   begin
      Interrupt_Handler_Prolog;

      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.GIC_Interrupt_Handler (
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Cpu_Interrupt_Fiq);

      Interrupt_Handler_Epilog;
   end EL2_Fiq_Interrupt_Handler;

end HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Hypervisor;
