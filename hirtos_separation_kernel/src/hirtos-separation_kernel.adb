--
--  Copyright (c) 2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS_Cpu_Arch_Interface.Hypervisor;
with HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
with HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
with HiRTOS_Cpu_Arch_Interface.Tick_Timer.Hypervisor;
with HiRTOS_Cpu_Arch_Interface.Partition_Context;
with HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Hypervisor;
with HiRTOS_Cpu_Startup_Interface;
with HiRTOS_Platform_Parameters;
with HiRTOS.Memory_Protection_Private;
with HiRTOS.Separation_Kernel.SK_Private;
with HiRTOS.Separation_Kernel.Interrupt_Handling;
with HiRTOS.Separation_Kernel.Memory_Protection_Private;
with System.Storage_Elements;
with Memory_Utils;

package body HiRTOS.Separation_Kernel is
   use HiRTOS_Cpu_Multi_Core_Interface;
   use HiRTOS.Separation_Kernel.SK_Private;

   -----------------------------------------------------------------------------
   --  Public Subprograms
   -----------------------------------------------------------------------------

   procedure Initialize with SPARK_Mode => Off
   is
      use type HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;

      --  Compiler-generated Ada elaboration code:
      procedure HiRTOS_Separation_Kernel_Lib_Elaboration with
         Import,
         Convention => C,
         External_Name => "HiRTOS_Separation_Kernelinit";

   begin
      if Get_Cpu_Id = Valid_Cpu_Core_Id_Type'First then
         HiRTOS_Separation_Kernel_Lib_Elaboration;
         Atomic_Store (HiRTOS_Cpu_Startup_Interface.HiRTOS_Global_Vars_Elaborated_Flag, 1);
         Memory_Utils.Flush_Data_Cache_Range (
            HiRTOS_Platform_Parameters.Global_Data_Region_Start_Address,
            HiRTOS.Memory_Protection_Private.Global_Data_Region_Size_In_Bytes);
         HiRTOS_Cpu_Arch_Interface.Send_Multicore_Event;
      else
         loop
            HiRTOS_Cpu_Arch_Interface.Wait_For_Multicore_Event;
            exit when Atomic_Load (HiRTOS_Cpu_Startup_Interface.HiRTOS_Global_Vars_Elaborated_Flag) = 1;
         end loop;
         Memory_Utils.Invalidate_Data_Cache_Range (
            HiRTOS_Platform_Parameters.Global_Data_Region_Start_Address,
            HiRTOS.Memory_Protection_Private.Global_Data_Region_Size_In_Bytes);
      end if;

      Initialize_Separation_Kernel;
   end Initialize;

   -----------------------------------------------------------------------------
   --  Private Subprograms
   -----------------------------------------------------------------------------
   --
   procedure Initialize_Separation_Kernel is
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
      HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Hypervisor.Register_Hypervisor_Trap_Callback (
         HiRTOS.Separation_Kernel.Interrupt_Handling.Hypervisor_Trap_Handler'Access);

      Separation_Kernel_Cpu_Instance.Cpu_Id := Cpu_Id;
      Separation_Kernel_Cpu_Instance.Interrupt_Stack_Base_Address :=
         ISR_Stack_Info.Base_Address;
      Separation_Kernel_Cpu_Instance.Interrupt_Stack_End_Address :=
         System.Storage_Elements.To_Address (
            System.Storage_Elements.To_Integer (ISR_Stack_Info.Base_Address) +
            ISR_Stack_Info.Size_In_Bytes);

      Partition_Queue_Package.List_Init (Separation_Kernel_Cpu_Instance.Runnable_Partitions_Queue,
                                         Cpu_Id);
   end Initialize_Separation_Kernel;

   procedure Start_Partition_Scheduler is
      Separation_Kernel_Cpu_Instance : Separation_Kernel_Cpu_Instance_Type renames
         HiRTOS.Separation_Kernel.SK_Private.Separation_Kernel_Cpu_Instances (Get_Cpu_Id);
   begin
      pragma Assert (Separation_Kernel_Cpu_Instance.Partition_Scheduler_State = Partition_Scheduler_Stopped);
      pragma Assert (Separation_Kernel_Cpu_Instance.Current_Partition_Id = Invalid_Partition_Id);

      HiRTOS_Cpu_Arch_Interface.Tick_Timer.Hypervisor.Start_Timer (
         HiRTOS_Separation_Kernel_Config_Parameters.Tick_Timer_Period_Us);

      HiRTOS_Cpu_Arch_Interface.Partition_Context.First_Partition_Context_Switch;

      --
      --  We should not come here
      --
      pragma Assert (False);

   end Start_Partition_Scheduler;

end HiRTOS.Separation_Kernel;
