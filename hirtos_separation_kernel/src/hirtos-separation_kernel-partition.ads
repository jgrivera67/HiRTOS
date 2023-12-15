--
--  Copyright (c) 2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with System.Storage_Elements;

package HiRTOS.Separation_Kernel.Partition
   with SPARK_Mode => On
is
   use HiRTOS_Cpu_Multi_Core_Interface;
   use System.Storage_Elements;
   use type System.Address;

   --
   --  Create new partition
   --
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
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode
                  and then
                  (if TCM_Base_Address /= System.Null_Address then
                     TCM_Size_In_Bytes /= 0
                   else
                     TCM_Size_In_Bytes = 0)
                  and then
                  (if SRAM_Base_Address /= System.Null_Address then
                     SRAM_Size_In_Bytes /= 0
                   else
                     SRAM_Size_In_Bytes = 0)
                  and then
                   (if MMIO_Base_Address /= System.Null_Address then
                     MMIO_Size_In_Bytes /= 0
                   else
                     MMIO_Size_In_Bytes = 0)
                  and then
                  ((To_Integer (Reset_Handler_Address) in
                     To_Integer (TCM_Base_Address) ..
                     To_Integer (TCM_Base_Address) + TCM_Size_In_Bytes - 1
                   and then
                   To_Integer (Interrupt_Vector_Table_Address) in
                     To_Integer (TCM_Base_Address) ..
                     To_Integer (TCM_Base_Address) + TCM_Size_In_Bytes - 1)
                   or else
                   (To_Integer (Reset_Handler_Address) in
                      To_Integer (SRAM_Base_Address) ..
                      To_Integer (SRAM_Base_Address) + SRAM_Size_In_Bytes - 1
                    and then
                    To_Integer (Interrupt_Vector_Table_Address) in
                      To_Integer (SRAM_Base_Address) ..
                      To_Integer (SRAM_Base_Address) + SRAM_Size_In_Bytes - 1));

   --
   --  Tell if a parittion is currently suspended
   --
   function Is_Partition_Suspended (Partition_Id : Valid_Partition_Id_Type) return Boolean
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode;

   --
   --  Set the "fail-over to" parittion for a given partition
   --
   procedure Set_Partition_Failover (Partition_Id : Valid_Partition_Id_Type;
                                     Failover_Partition_Id : Valid_Partition_Id_Type)
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode
                  and then
                  Is_Partition_Suspended (Failover_Partition_Id);

   --
   --  Return the Id of the current partition executing on the current CPU core,
   --  if that core is running in partition context, or the Id of the last partition
   --  prempted by an interrupt handler, if running in interrupt context.
   --
   function Get_Current_Partition_Id return Partition_Id_Type
      with Pre => HiRTOS_Cpu_Arch_Interface.Cpu_In_Hypervisor_Mode;

end HiRTOS.Separation_Kernel.Partition;
