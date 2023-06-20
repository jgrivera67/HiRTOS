--
--  Copyright (c) 2023, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS_Cpu_Multi_Core_Interface;
with HiRTOS_Low_Level_Debug_Interface;
with HiRTOS.Separation_Kernel.SK_Private;
with HiRTOS.Separation_Kernel.Partition_Private;
with System.Storage_Elements;

package body HiRTOS.Separation_Kernel.Interrupt_Handling is
   use HiRTOS_Cpu_Multi_Core_Interface;
   use HiRTOS.Separation_Kernel.SK_Private;
   use HiRTOS.Separation_Kernel.Partition_Private;

   Debug_Tracing_On : constant Boolean := False;

   --
   --  NOTE: EL2 nested interrupts are not supported
   --
   function Enter_Interrupt_Context (Stack_Pointer : System.Address) return System.Address is
      Separation_Kernel_Cpu_Instance : Separation_Kernel_Cpu_Instance_Type renames
         Separation_Kernel_Cpu_Instances (Get_Cpu_Id);
      Current_Partition_Id : constant Partition_Id_Type :=
         Separation_Kernel_Cpu_Instance.Current_Partition_Id;
   begin
      --
      --  Interrupted context must be a Partition
      --
      pragma Assert (Current_Partition_Id /= Invalid_Partition_Id);
      declare
         use type System.Address;
         Current_Partition_Obj : Partition_Type renames
            Separation_Kernel_Cpu_Instance.Partition_Instances (Current_Partition_Id);
      begin
         pragma Assert (Stack_Pointer = Current_Partition_Obj.Cpu_Context'Address);
      end;

      return Separation_Kernel_Cpu_Instance.Interrupt_Stack_End_Address;
   end Enter_Interrupt_Context;

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
         Old_Current_Partition_Id : constant Partition_Id_Type :=
               Separation_Kernel_Cpu_Instance.Current_Partition_Id;
      begin
         HiRTOS.Separation_Kernel.Partition_Private.Run_Partition_Scheduler;
         declare
            use System.Storage_Elements;
            use type Integer_Address;
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
               HiRTOS_Low_Level_Debug_Interface.Print_String ("*** exit partition_id: ");
               HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (
                  Interfaces.Unsigned_32 (New_Current_Partition_Id), End_Line => True);
            end if;

            --
            --  Make hypervisor's stack pointer point to the end of the new
            --  current'partition's Cpu_Context, so that it is ready to be
            --  used by Hypervisor_Interrupt_Handler_Prolog, on the next
            --  hypervisor interrupt:
            --
            New_Stack_Pointer := To_Address (
               To_Integer (New_Current_Partition_Obj.Cpu_Context'Address) +
               (New_Current_Partition_Obj.Cpu_Context'Size / System.Storage_Unit));
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
      pragma Assert (Current_Partition_Obj.Time_Slice_Left_Us >= HiRTOS_Config_Parameters.Tick_Timer_Period_Us);
      Separation_Kernel_Cpu_Instance.Timer_Ticks_Since_Boot := @ + 1;
      Current_Partition_Obj.Time_Slice_Left_Us := @ - HiRTOS_Config_Parameters.Tick_Timer_Period_Us;
   end Tick_Timer_Interrupt_Handler;

end HiRTOS.Separation_Kernel.Interrupt_Handling;
