--
--  Copyright (c) 2022-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS_Cpu_Arch_Interface.Partition_Context;
with HiRTOS.Memory_Protection;
with HiRTOS.Separation_Kernel.SK_Private;
with HiRTOS.Separation_Kernel.Partition_Private;
with HiRTOS.Separation_Kernel.Memory_Protection_Private;

package body HiRTOS.Separation_Kernel.Partition is
   use HiRTOS_Cpu_Arch_Interface;
   use HiRTOS.Separation_Kernel.SK_Private;
   use HiRTOS_Cpu_Arch_Interface.Partition_Context;
   use HiRTOS.Separation_Kernel.Partition_Private;

   -----------------------------------------------------------------------------
   --  Private subprogram specifications
   -----------------------------------------------------------------------------

   procedure Initialize_Partition (Partition_Obj : out Partition_Type;
                                   Partition_Id : Valid_Partition_Id_Type;
                                   Interrupt_Vector_Table_Address : System.Address;
                                   TCM_Base_Address : System.Address;
                                   TCM_Size_In_Bytes :  System.Storage_Elements.Integer_Address;
                                   SRAM_Base_Address : System.Address;
                                   SRAM_Size_In_Bytes :  System.Storage_Elements.Integer_Address;
                                   MMIO_Base_Address : System.Address;
                                   MMIO_Size_In_Bytes :  System.Storage_Elements.Integer_Address;
                                   Suspended : Boolean);

   -----------------------------------------------------------------------------
   --  Public Subprograms
   -----------------------------------------------------------------------------

   procedure Create_Partition (Reset_Handler_Address : System.Address;
                               Interrupt_Vector_Table_Address : System.Address;
                               TCM_Base_Address : System.Address;
                               TCM_Size_In_Bytes :  System.Storage_Elements.Integer_Address;
                               SRAM_Base_Address : System.Address;
                               SRAM_Size_In_Bytes :  System.Storage_Elements.Integer_Address;
                               MMIO_Base_Address : System.Address;
                               MMIO_Size_In_Bytes :  System.Storage_Elements.Integer_Address;
                               Partition_Id : out Valid_Partition_Id_Type;
                               Suspended : Boolean := False)
   is
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      Separation_Kernel_Cpu_Instance : Separation_Kernel_Cpu_Instance_Type renames
         Separation_Kernel_Cpu_Instances (Cpu_Id);
      Old_Cpu_Interrupting : Cpu_Register_Type;
   begin
      Allocate_Partition_Object (Partition_Id);

      declare
         Partition_Obj : Partition_Type renames
            Separation_Kernel_Cpu_Instance.Partition_Instances (Partition_Id);
      begin
         Initialize_Partition (Partition_Obj,
                              Partition_Id,
                              Interrupt_Vector_Table_Address,
                              TCM_Base_Address, TCM_Size_In_Bytes,
                              SRAM_Base_Address, SRAM_Size_In_Bytes,
                              MMIO_Base_Address, MMIO_Size_In_Bytes,
                              Suspended);

         Initialize_Partition_Cpu_Context (Partition_Obj.Cpu_Context,
                                           Cpu_Register_Type (To_Integer (Reset_Handler_Address)),
                                           Separation_Kernel_Cpu_Instance.Interrupt_Stack_End_Address);
      end;

      if not Suspended then
         --  Begin critical section
         Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
         Enqueue_Runnable_Partition (Partition_Id);
         --  End critical section
         HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
      end if;
   end Create_Partition;

   function Is_Partition_Suspended (Partition_Id : Valid_Partition_Id_Type) return Boolean
   is
      Separation_Kernel_Cpu_Instance : Separation_Kernel_Cpu_Instance_Type renames
         Separation_Kernel_Cpu_Instances (Get_Cpu_Id);
      Partition_Obj : Partition_Type renames
         Separation_Kernel_Cpu_Instance.Partition_Instances (Partition_Id);
   begin
      return Partition_Obj.State = Partition_Suspended;
   end Is_Partition_Suspended;

   procedure Set_Partition_Failover (Partition_Id : Valid_Partition_Id_Type;
                                     Failover_Partition_Id : Valid_Partition_Id_Type)
   is
      Separation_Kernel_Cpu_Instance : Separation_Kernel_Cpu_Instance_Type renames
         Separation_Kernel_Cpu_Instances (Get_Cpu_Id);
      Partition_Obj : Partition_Type renames
         Separation_Kernel_Cpu_Instance.Partition_Instances (Partition_Id);
   begin
      Partition_Obj.Failover_Partition_Id := Failover_Partition_Id;
   end Set_Partition_Failover;

   function Get_Current_Partition_Id return Partition_Id_Type is
      Separation_Kernel_Cpu_Instance : Separation_Kernel_Cpu_Instance_Type renames
         Separation_Kernel_Cpu_Instances (Get_Cpu_Id);
   begin
      return Separation_Kernel_Cpu_Instance.Current_Partition_Id;
   end Get_Current_Partition_Id;

   -----------------------------------------------------------------------------
   --  Private Subprograms
   -----------------------------------------------------------------------------

   procedure Initialize_Partition (Partition_Obj : out Partition_Type;
                                   Partition_Id : Valid_Partition_Id_Type;
                                   Interrupt_Vector_Table_Address : System.Address;
                                   TCM_Base_Address : System.Address;
                                   TCM_Size_In_Bytes :  System.Storage_Elements.Integer_Address;
                                   SRAM_Base_Address : System.Address;
                                   SRAM_Size_In_Bytes :  System.Storage_Elements.Integer_Address;
                                   MMIO_Base_Address : System.Address;
                                   MMIO_Size_In_Bytes :  System.Storage_Elements.Integer_Address;
                                   Suspended : Boolean) is
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
   begin
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access
        (Partition_Obj'Address, Partition_Obj'Size, Old_Data_Range);
      Partition_Obj.Id := Partition_Id;
      Partition_Obj.State := (if Suspended then Partition_Suspended else Partition_Runnable);

      HiRTOS.Separation_Kernel.Memory_Protection_Private.Initialize_Partition_Memory_Regions (
         Partition_Id,
         TCM_Base_Address,
         TCM_Size_In_Bytes,
         SRAM_Base_Address,
         SRAM_Size_In_Bytes,
         MMIO_Base_Address,
         MMIO_Size_In_Bytes,
         Partition_Obj.Internal_Memory_Regions);

      HiRTOS_Cpu_Arch_Interface.Partition_Context.Initialize_Interrupt_Handling_Context (
         Interrupt_Vector_Table_Address,
         Partition_Obj.Interrupt_Handling_Context);
      Partition_Obj.Time_Slice_Left_Us := Partition_Time_Slice_Us;
      Partition_Obj.Stats := (others => <>);
      Partition_Obj.Initialized := True;
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
   end Initialize_Partition;

end HiRTOS.Separation_Kernel.Partition;
