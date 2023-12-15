--
--  Copyright (c) 2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS_Cpu_Multi_Core_Interface;
with HiRTOS_Low_Level_Debug_Interface;
with HiRTOS.Separation_Kernel.SK_Private;
with HiRTOS.Separation_Kernel.Partition_Private;
with HiRTOS_Cpu_Arch_Interface.Partition_Context;

package body HiRTOS.Separation_Kernel.Interrupt_Handling is
   use HiRTOS_Cpu_Multi_Core_Interface;
   use HiRTOS.Separation_Kernel.SK_Private;
   use HiRTOS.Separation_Kernel.Partition_Private;

   Debug_Tracing_On : constant Boolean := False;

   --
   --  NOTE: EL2 nested interrupts are not supported
   --

   function Exit_Interrupt_Context return System.Address is
      Separation_Kernel_Cpu_Instance : Separation_Kernel_Cpu_Instance_Type renames
         Separation_Kernel_Cpu_Instances (Get_Cpu_Id);
      New_Stack_Pointer : System.Address;
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      --
      --  Run the partition scheduler:
      --
      declare
         use type System.Address;
         Old_Current_Partition_Id : constant Partition_Id_Type :=
               Separation_Kernel_Cpu_Instance.Current_Partition_Id;
      begin
         HiRTOS.Separation_Kernel.Partition_Private.Run_Partition_Scheduler;
         declare
            New_Current_Partition_Id : constant Valid_Partition_Id_Type :=
                  Separation_Kernel_Cpu_Instance.Current_Partition_Id;
            New_Current_Partition_Obj : Partition_Type renames
               Separation_Kernel_Cpu_Instance.Partition_Instances (New_Current_Partition_Id);
         begin
            if New_Current_Partition_Id /= Old_Current_Partition_Id then
               if Old_Current_Partition_Id /= Invalid_Partition_Id then
                  declare
                     Old_Current_Partition_Obj : Partition_Type renames
                        Separation_Kernel_Cpu_Instance.Partition_Instances (Old_Current_Partition_Id);
                  begin
                     Save_Partition_Extended_Context (Old_Current_Partition_Obj);
                  end;
               end if;

               Restore_Partition_Extended_Context (New_Current_Partition_Obj);
            end if;

            if Debug_Tracing_On then
               HiRTOS_Low_Level_Debug_Interface.Print_String ("*** Switching to partition_id: ");
               HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (
                  Interfaces.Unsigned_32 (New_Current_Partition_Id), End_Line => True);
            end if;

            --
            --  Make hypervisor's stack pointer point to the current partition's Cpu_Context,
            --  so that HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Hypervisor.Interrupt_Handler_Epilog
            --  can pop it as if it were on the stack.
            --
            pragma Assert (
               HiRTOS_Cpu_Arch_Interface.Partition_Context.Get_Interrupt_Stack_End_Address (
                  New_Current_Partition_Obj.Cpu_Context) =
               Separation_Kernel_Cpu_Instance.Interrupt_Stack_End_Address);

            New_Stack_Pointer := New_Current_Partition_Obj.Cpu_Context'Address;
         end;
      end;

      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
      return New_Stack_Pointer;
   end Exit_Interrupt_Context;

   procedure Tick_Timer_Interrupt_Handler is
      Separation_Kernel_Cpu_Instance : Separation_Kernel_Cpu_Instance_Type renames
         Separation_Kernel_Cpu_Instances (Get_Cpu_Id);
      Current_Partition_Id : constant Valid_Partition_Id_Type :=
               Separation_Kernel_Cpu_Instance.Current_Partition_Id;
      Current_Partition_Obj : Partition_Type renames
         Separation_Kernel_Cpu_Instance.Partition_Instances (Current_Partition_Id);
   begin
      pragma Assert (Current_Partition_Obj.Time_Slice_Left_Us >=
                     HiRTOS_Separation_Kernel_Config_Parameters.Tick_Timer_Period_Us);
      Separation_Kernel_Cpu_Instance.Timer_Ticks_Since_Boot := @ + 1;
      Current_Partition_Obj.Time_Slice_Left_Us :=
         @ - HiRTOS_Separation_Kernel_Config_Parameters.Tick_Timer_Period_Us;
   end Tick_Timer_Interrupt_Handler;

   procedure Hypervisor_Trap_Handler (
      Hypervisor_Trap : HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Hypervisor.Hypervisor_Traps_Type) is
      Separation_Kernel_Cpu_Instance : Separation_Kernel_Cpu_Instance_Type renames
         Separation_Kernel_Cpu_Instances (Get_Cpu_Id);
      Partition_Obj : Partition_Type renames
         Separation_Kernel_Cpu_Instance.Partition_Instances (Separation_Kernel_Cpu_Instance.Current_Partition_Id);
   begin
      case Hypervisor_Trap is
         when HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Hypervisor.WFI_Instruction_Executed =>
            Partition_Obj.Executed_WFI := True;
         when others =>
            null; -- TODO
      end case;
   end Hypervisor_Trap_Handler;

end HiRTOS.Separation_Kernel.Interrupt_Handling;
