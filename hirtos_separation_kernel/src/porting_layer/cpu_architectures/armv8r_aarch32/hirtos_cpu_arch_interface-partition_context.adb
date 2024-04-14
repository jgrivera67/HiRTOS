--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target platform interface - Partition CPU context
--  for ARMv8-R architecture
--

with HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Hypervisor;
with HiRTOS_Cpu_Arch_Interface.System_Registers;
with HiRTOS_Cpu_Arch_Interface_Private;
with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface.Partition_Context with SPARK_Mode => On is
   use ASCII;
   use HiRTOS_Cpu_Arch_Interface_Private;

   procedure Partition_Unintended_Exit_Catcher is
   begin
      raise Program_Error;
   end Partition_Unintended_Exit_Catcher;

   procedure Initialize_Partition_Cpu_Context (Partition_Cpu_Context : out Cpu_Context_Type;
                                               Entry_Point_Address : Cpu_Register_Type;
                                               Interrupt_Stack_End_Address : System.Address) is
   begin
      Partition_Cpu_Context.Interrupt_Stack_End_Address := Interrupt_Stack_End_Address;
      Partition_Cpu_Context.Floating_Point_Registers := (others => <>);
      Partition_Cpu_Context.Integer_Registers :=
         (ELR_HYP => Entry_Point_Address,
          SPSR_HYP => CPSR_Supervisor_Mode or CPSR_I_Bit_Mask,
          R0 => 16#00000000#,
          R1 => 16#01010101#,
          R2 => 16#02020202#,
          R3 => 16#03030303#,
          R4 => 16#04040404#,
          R5 => 16#05050505#,
          R6 => 16#06060606#,
          R7 => 16#07070707#,
          R8 => 16#08080808#,
          R9 => 16#09090909#,
          R10 => 16#10101010#,
          R11 => 16#11111111#,
          R12 => 16#12121212#,
          LR => Cpu_Register_Type (To_Integer (Partition_Unintended_Exit_Catcher'Address)));

   end Initialize_Partition_Cpu_Context;

   procedure First_Partition_Context_Switch is
   begin
      --
      --  NOTE: To start executing the first partition, we pretend that we are returning from an
      --  EL2 interrupt, since we have been executing at EL2 in the reset exception handler.
      --
      HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Hypervisor.Interrupt_Handler_Epilog;
   end First_Partition_Context_Switch;

   procedure Synchronous_Partition_Context_Switch is
   begin
      --
      --  Initiate a synchronous partition context switch by doing
      --  a Hypervisor call, passing 0 in r0
      --
      System.Machine_Code.Asm (
         "mov r0, #0" & LF &
         "hvc #0",
         Clobber => "r0",
         Volatile => True);
   end Synchronous_Partition_Context_Switch;

   procedure Save_Extended_Cpu_Context (Extended_Cpu_Context : out Extended_Cpu_Context_Type)
   is
   begin
      System.Machine_Code.Asm (
         "mrs %0, sp_svc"  & LF &
         "mrs %1, lr_svc" & LF &
         "mrs %2, spsr_svc",
         Outputs => [
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.Sp_Svc),   --  %0
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.Lr_Svc),   --  %1
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.Spsr_Svc)  --  %2
         ],
         Volatile => True);

      System.Machine_Code.Asm (
         "mrs %0, r8_fiq" & LF &
         "mrs %1, r9_fiq" & LF &
         "mrs %2, r10_fiq" & LF &
         "mrs %3, r11_fiq",
         Outputs => [
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.R8_Fiq),   --  %0
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.R9_Fiq),   --  %1
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.R10_Fiq),  --  %2
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.R11_Fiq)   --  %3
         ],
         Volatile => True);

      System.Machine_Code.Asm (
         "mrs %0, r12_fiq" & LF &
         "mrs %1, sp_fiq" & LF &
         "mrs %2, lr_fiq" & LF &
         "mrs %3, spsr_fiq",
         Outputs => [
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.R12_Fiq),  --  %0
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.Sp_Fiq),   --  %1
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.Lr_Fiq),   --  %2
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.Spsr_Fiq)  --  %3
         ],
         Volatile => True);

      System.Machine_Code.Asm (
         "mrs %0, sp_irq" & LF &
         "mrs %1, lr_irq" & LF &
         "mrs %2, spsr_irq",
         Outputs => [
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.Sp_Irq),   --  %0
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.Lr_Irq),   --  %1
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.Spsr_Irq)  --  %2
         ],
         Volatile => True);

      System.Machine_Code.Asm (
         "mrs %0, sp_abt" & LF &
         "mrs %1, lr_abt" & LF &
         "mrs %2, spsr_abt",
         Outputs => [
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.Sp_Abt),   --  %0
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.Lr_Abt),   --  %1
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.Spsr_Abt)  --  %2
         ],
         Volatile => True);

      System.Machine_Code.Asm (
         "mrs %0, sp_und" & LF &
         "mrs %1, lr_und" & LF &
         "mrs %2, spsr_und",
         Outputs => [
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.Sp_Und),   --  %0
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.Lr_Und),   --  %1
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.Spsr_Und)  --  %2
         ],
         Volatile => True);

         --
         --  NOTE: SYS mode and USR mode share the same sp and lr
         --  and they don't have spsr. Also, we don't need to save
         --  lr_usr here, as lr it is saved by Interrupt_Handler_Prolog
         --
         System.Machine_Code.Asm (
         "mrs %0, sp_usr",
         Outputs => [
            Cpu_Register_Type'Asm_Output ("=r", Extended_Cpu_Context.Sp_Usr)    --  %0
         ],
         Volatile => True);
   end Save_Extended_Cpu_Context;

   procedure Restore_Extended_Cpu_Context (Extended_Cpu_Context : Extended_Cpu_Context_Type)
   is
   begin
      System.Machine_Code.Asm (
         "msr sp_svc, %0" & LF &
         "msr lr_svc, %1" & LF &
         "msr spsr_svc, %2",
         Inputs   => [
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.Sp_Svc),   --  %0
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.Lr_Svc),   --  %1
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.Spsr_Svc)  --  %2
         ],
         Volatile => True);

      System.Machine_Code.Asm (
         "msr r8_fiq, %0" & LF &
         "msr r9_fiq, %1" & LF &
         "msr r10_fiq, %2" & LF &
         "msr r11_fiq, %3",
         Inputs   => [
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.R8_Fiq),   --  %0
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.R9_Fiq),   --  %1
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.R10_Fiq),  --  %2
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.R11_Fiq)   --  %3
         ],
         Volatile => True);

      System.Machine_Code.Asm (
         "msr r12_fiq, %0" & LF &
         "msr sp_fiq, %1" & LF &
         "msr lr_fiq, %2" & LF &
         "msr spsr_fiq, %3",
         Inputs   => [
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.R12_Fiq),  --  %0
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.Sp_Fiq),   --  %1
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.Lr_Fiq),   --  %2
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.Spsr_Fiq)  --  %3
         ],
         Volatile => True);

      System.Machine_Code.Asm (
         "msr sp_irq, %0" & LF &
         "msr lr_irq, %1" & LF &
         "msr spsr_irq, %2",
         Inputs   => [
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.Sp_Irq),   --  %0
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.Lr_Irq),   --  %1
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.Spsr_Irq)  --  %2
         ],
         Volatile => True);

      System.Machine_Code.Asm (
         "msr sp_abt, %0" & LF &
         "msr lr_abt, %1" & LF &
         "msr spsr_abt, %2",
         Inputs   => [
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.Sp_Abt),   --  %0
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.Lr_Abt),   --  %1
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.Spsr_Abt)  --  %2
         ],
         Volatile => True);

      System.Machine_Code.Asm (
         "msr sp_und, %0" & LF &
         "msr lr_und, %1" & LF &
         "msr spsr_und, %2",
         Inputs   => [
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.Sp_Und),   --  %0
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.Lr_Und),   --  %1
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.Spsr_Und)  --  %2
         ],
         Volatile => True);

      --
      --  NOTE: SYS mode and USR mode share the same sp and lr
      --  and they don't have spsr. Also, we don't need to restore
         --  lr_usr here, as lr it is saved by Interrupt_Handler_Epilog
      --
      System.Machine_Code.Asm (
         "msr sp_usr, %0",
         Inputs   => [
            Cpu_Register_Type'Asm_Input ("r", Extended_Cpu_Context.Sp_Usr)    --  %0
         ],
         Volatile => True);
   end Restore_Extended_Cpu_Context;

   procedure Initialize_Interrupt_Handling_Context (Interrupt_Vector_Table_Address : System.Address;
                                                    Interrupt_Handling_Context : out Interrupt_Handling_Context_Type)
   is
   begin
      Interrupt_Handling_Context.VBAR_Value := Interrupt_Vector_Table_Address;
      Interrupt_Handling_Context.Highest_Interrupt_Priority_Disabled :=
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Interrupt_Priority_Type'Last;
      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Hypervisor.Initialize_Interrupts_Enabled_Bitmap
         (Interrupt_Handling_Context.Interrupts_Enabled_Bitmap);
   end Initialize_Interrupt_Handling_Context;

   procedure Save_Interrupt_Handling_Context (Interrupt_Handling_Context : out Interrupt_Handling_Context_Type)
   is
   begin
      Interrupt_Handling_Context.VBAR_Value := System_Registers.Get_VBAR;
      Interrupt_Handling_Context.Highest_Interrupt_Priority_Disabled :=
         Interrupt_Controller.Get_Highest_Interrupt_Priority_Disabled;
      Interrupt_Controller.Hypervisor.Save_Interrupts_Enabled_Bitmap (
         Interrupt_Handling_Context.Interrupts_Enabled_Bitmap);
   end Save_Interrupt_Handling_Context;

   procedure Restore_Interrupt_Handling_Context (Interrupt_Handling_Context : Interrupt_Handling_Context_Type)
   is
   begin
      System_Registers.Set_VBAR (Interrupt_Handling_Context.VBAR_Value);
      Interrupt_Controller.Set_Highest_Interrupt_Priority_Disabled (
         Interrupt_Handling_Context.Highest_Interrupt_Priority_Disabled);
      Interrupt_Controller.Hypervisor.Restore_Interrupts_Enabled_Bitmap (
         Interrupt_Handling_Context.Interrupts_Enabled_Bitmap);
   end Restore_Interrupt_Handling_Context;

end HiRTOS_Cpu_Arch_Interface.Partition_Context;
