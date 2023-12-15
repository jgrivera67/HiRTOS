--
--  Copyright (c) 2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--
with HiRTOS.Separation_Kernel.SK_Private;
with HiRTOS_Cpu_Multi_Core_Interface;

package body HiRTOS.Separation_Kernel.Partition_Private is
   use HiRTOS.Separation_Kernel.SK_Private;
   use HiRTOS_Cpu_Multi_Core_Interface;

   -----------------------------------------------------------------------------
   --  Private Subprograms Specifications                                     --
   -----------------------------------------------------------------------------

   --
   --  If the partition has consumed its time slice, enqueue it at the end of the
   --  given run queue.
   --
   procedure Reschedule_Partition (Partition_Id : Valid_Partition_Id_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled;

   -----------------------------------------------------------------------------
   --  Public Subprograms                                                     --
   -----------------------------------------------------------------------------

   procedure Dequeue_Runnable_Partition (Partition_Id : out Valid_Partition_Id_Type) is
      Separation_Kernel_Cpu_Instance : Separation_Kernel_Cpu_Instance_Type renames
         Separation_Kernel_Cpu_Instances (Get_Cpu_Id);
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      pragma Assert (Separation_Kernel_Cpu_Instance.Current_Partition_Id = Invalid_Partition_Id);

      --  Begin critical section
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      Partition_Queue_Package.List_Remove_Head (Separation_Kernel_Cpu_Instance.Runnable_Partitions_Queue,
                                                Partition_Id,
                                                Separation_Kernel_Cpu_Instance.Partition_Queue_Nodes);

      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
   end Dequeue_Runnable_Partition;

   procedure Enqueue_Runnable_Partition (Partition_Id : Valid_Partition_Id_Type;
                                         First_In_Queue : Boolean := False)
   is
      Separation_Kernel_Cpu_Instance : Separation_Kernel_Cpu_Instance_Type renames
         Separation_Kernel_Cpu_Instances (Get_Cpu_Id);
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      --  Begin critical section
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      if First_In_Queue then
         Partition_Queue_Package.List_Add_Head (Separation_Kernel_Cpu_Instance.Runnable_Partitions_Queue,
                                                Partition_Id,
                                                Separation_Kernel_Cpu_Instance.Partition_Queue_Nodes);
      else
         Partition_Queue_Package.List_Add_Tail (Separation_Kernel_Cpu_Instance.Runnable_Partitions_Queue,
                                                Partition_Id,
                                                Separation_Kernel_Cpu_Instance.Partition_Queue_Nodes);
      end if;

      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
   end Enqueue_Runnable_Partition;

   procedure Run_Partition_Scheduler is
      Separation_Kernel_Cpu_Instance : Separation_Kernel_Cpu_Instance_Type renames
         Separation_Kernel_Cpu_Instances (Get_Cpu_Id);
      Old_Partition_Id : Partition_Id_Type;
      Old_Cpu_Interrupt_Mask : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      --  begin critical section
      Old_Cpu_Interrupt_Mask := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
      Old_Partition_Id := Separation_Kernel_Cpu_Instance.Current_Partition_Id;
      if Old_Partition_Id /= Invalid_Partition_Id then
         Reschedule_Partition (Old_Partition_Id);
         Separation_Kernel_Cpu_Instance.Current_Partition_Id := Invalid_Partition_Id;
      end if;

      Dequeue_Runnable_Partition (Separation_Kernel_Cpu_Instance.Current_Partition_Id);

      if Separation_Kernel_Cpu_Instance.Current_Partition_Id /= Old_Partition_Id then
         declare
            Current_Partition_Obj : Partition_Type renames
               Separation_Kernel_Cpu_Instance.Partition_Instances (Separation_Kernel_Cpu_Instance.Current_Partition_Id);
         begin
            Current_Partition_Obj.Stats.Times_Switched_In := @ + 1;
         end;
      end if;

      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupt_Mask);
   end Run_Partition_Scheduler;

   -----------------------------------------------------------------------------
   --  Private Subprograms                                                    --
   -----------------------------------------------------------------------------

   procedure Reschedule_Partition (Partition_Id : Valid_Partition_Id_Type) is
      Separation_Kernel_Cpu_Instance : Separation_Kernel_Cpu_Instance_Type renames
         Separation_Kernel_Cpu_Instances (Get_Cpu_Id);
      Partition_Obj : Partition_Type renames Separation_Kernel_Cpu_Instance.Partition_Instances (Partition_Id);
   begin
      if Partition_Obj.Time_Slice_Left_Us = 0 or else Partition_Obj.Executed_WFI then
         Partition_Obj.Stats.Times_Time_Slice_Consumed := @ + 1;
         Partition_Obj.Time_Slice_Left_Us := Partition_Time_Slice_Us;
         Partition_Obj.Executed_WFI := False;
         Enqueue_Runnable_Partition (Partition_Obj.Id);
      else
         pragma Assert (Partition_Obj.Time_Slice_Left_Us <= Partition_Time_Slice_Us);
         Enqueue_Runnable_Partition (Partition_Obj.Id, First_In_Queue => True);
      end if;
   end Reschedule_Partition;

   procedure Save_Partition_Extended_Context (Partition_Obj : in out Partition_Type) is
   begin
      HiRTOS_Cpu_Arch_Interface.Partition_Context.Save_Extended_Cpu_Context (
         Partition_Obj.Extended_Cpu_Context);
      HiRTOS_Cpu_Arch_Interface.Partition_Context.Save_Interrupt_Handling_Context (
         Partition_Obj.Interrupt_Handling_Context);
      if HiRTOS_Separation_Kernel_Config_Parameters.Partitions_Share_Tick_Timer then
         HiRTOS_Cpu_Arch_Interface.Tick_Timer.Save_Timer_Context (Partition_Obj.Timer_Context);
      end if;

      HiRTOS.Separation_Kernel.Memory_Protection_Private.Save_Partition_Memory_Regions (
         Partition_Obj.Id, Partition_Obj.Internal_Memory_Regions);
   end Save_Partition_Extended_Context;

   procedure Restore_Partition_Extended_Context (Partition_Obj : Partition_Type) is
   begin
      HiRTOS_Cpu_Arch_Interface.Partition_Context.Restore_Extended_Cpu_Context (
         Partition_Obj.Extended_Cpu_Context);
      HiRTOS_Cpu_Arch_Interface.Partition_Context.Restore_Interrupt_Handling_Context (
         Partition_Obj.Interrupt_Handling_Context);
      if HiRTOS_Separation_Kernel_Config_Parameters.Partitions_Share_Tick_Timer then
         HiRTOS_Cpu_Arch_Interface.Tick_Timer.Restore_Timer_Context (Partition_Obj.Timer_Context);
      end if;

      HiRTOS.Separation_Kernel.Memory_Protection_Private.Restore_Partition_Memory_Regions (
         Partition_Obj.Id, Partition_Obj.Internal_Memory_Regions);
   end Restore_Partition_Extended_Context;

end HiRTOS.Separation_Kernel.Partition_Private;
