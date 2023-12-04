--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.Memory_Protection;

package body HiRTOS.Separation_Kernel.SK_Private is

   procedure Allocate_Partition_Object (Partition_Id : out Valid_Partition_Id_Type) is
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
      Separation_Kernel_Cpu_Instance : Separation_Kernel_Cpu_Instance_Type renames
         Separation_Kernel_Cpu_Instances (Get_Cpu_Id);
   begin
      pragma Assert (Partition_Id_Type (Atomic_Load (Separation_Kernel_Cpu_Instance.Next_Free_Partition_Id)) /=
                     Invalid_Partition_Id);
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access
        (Separation_Kernel_Cpu_Instance'Address, Separation_Kernel_Cpu_Instance'Size, Old_Data_Range);
      Partition_Id := Valid_Partition_Id_Type (Atomic_Fetch_Add (
         Separation_Kernel_Cpu_Instance.Next_Free_Partition_Id, 1));
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
   end Allocate_Partition_Object;

end HiRTOS.Separation_Kernel.SK_Private;
