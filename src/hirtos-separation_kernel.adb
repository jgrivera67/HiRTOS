--
--  Copyright (c) 2023, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS_Cpu_Arch_Interface.Hypervisor;
with HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
with HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
with HiRTOS_Cpu_Arch_Interface.Tick_Timer.Hypervisor;
with HiRTOS_Cpu_Arch_Interface.Partition_Context;
with HiRTOS.Separation_Kernel.SK_Private;
with HiRTOS.Separation_Kernel.Memory_Protection_Private;
with System.Storage_Elements;

package body HiRTOS.Separation_Kernel is
   use HiRTOS_Cpu_Multi_Core_Interface;
   use HiRTOS.Separation_Kernel.SK_Private;

   -----------------------------------------------------------------------------
   --  Public Subprograms
   -----------------------------------------------------------------------------

   procedure Initialize is
      use type System.Storage_Elements.Integer_Address;
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      Separation_Kernel_Cpu_Instance : Separation_Kernel_Cpu_Instance_Type renames
         HiRTOS.Separation_Kernel.SK_Private.Separation_Kernel_Cpu_Instances (Cpu_Id);
      ISR_Stack_Info : constant HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.ISR_Stack_Info_Type :=
         HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Get_ISR_Stack_Info (Cpu_Id);
   begin
      HiRTOS_Cpu_Arch_Interface.Hypervisor.Initialize;
      HiRTOS.Separation_Kernel.Memory_Protection_Private.Initialize;
      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Initialize;
      HiRTOS_Cpu_Arch_Interface.Enable_Cpu_Interrupting;
      HiRTOS_Cpu_Arch_Interface.Tick_Timer.Hypervisor.Initialize;

      Separation_Kernel_Cpu_Instance.Cpu_Id := Cpu_Id;
      Separation_Kernel_Cpu_Instance.Interrupt_Stack_Base_Address :=
         ISR_Stack_Info.Base_Address;
      Separation_Kernel_Cpu_Instance.Interrupt_Stack_End_Address :=
         System.Storage_Elements.To_Address (
            System.Storage_Elements.To_Integer (ISR_Stack_Info.Base_Address) +
            ISR_Stack_Info.Size_In_Bytes);
   end Initialize;

   procedure Start_Partition_Scheduler is
      Separation_Kernel_Cpu_Instance : Separation_Kernel_Cpu_Instance_Type renames
         HiRTOS.Separation_Kernel.SK_Private.Separation_Kernel_Cpu_Instances (Get_Cpu_Id);
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type with Unreferenced;
   begin
      pragma Assert (Separation_Kernel_Cpu_Instance.Partition_Scheduler_State = Partition_Scheduler_Stopped);
      pragma Assert (Separation_Kernel_Cpu_Instance.Current_Partition_Id = Invalid_Partition_Id);

      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
      HiRTOS_Cpu_Arch_Interface.Tick_Timer.Hypervisor.Start_Timer (
         HiRTOS_Separation_Kernel_Config_Parameters.Tick_Timer_Period_Us);

      HiRTOS_Cpu_Arch_Interface.Partition_Context.First_Partition_Context_Switch;

      --
      --  We should not come here
      --
      pragma Assert (False);

   end Start_Partition_Scheduler;

end HiRTOS.Separation_Kernel;
