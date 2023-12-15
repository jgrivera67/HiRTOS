--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS.Memory_Protection;

package body HiRTOS.RTOS_Private is

   procedure Allocate_Thread_Object (Thread_Id : out Valid_Thread_Id_Type) is
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
   begin
      pragma Assert (Thread_Id_Type (Atomic_Load (RTOS_Cpu_Instance.Next_Free_Thread_Id)) /= Invalid_Thread_Id);
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access
        (RTOS_Cpu_Instance'Address, RTOS_Cpu_Instance'Size, Old_Data_Range);
      Thread_Id := Valid_Thread_Id_Type (Atomic_Fetch_Add (RTOS_Cpu_Instance.Next_Free_Thread_Id, 1));
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
   end Allocate_Thread_Object;

   procedure Allocate_Mutex_Object (Mutex_Id : out Valid_Mutex_Id_Type) is
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
   begin
      pragma Assert (Mutex_Id_Type (Atomic_Load (RTOS_Cpu_Instance.Next_Free_Mutex_Id)) /= Invalid_Mutex_Id);
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access
        (RTOS_Cpu_Instance'Address, RTOS_Cpu_Instance'Size, Old_Data_Range);
      Mutex_Id := Valid_Mutex_Id_Type (Atomic_Fetch_Add (RTOS_Cpu_Instance.Next_Free_Mutex_Id, 1));
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
   end Allocate_Mutex_Object;

   procedure Allocate_Condvar_Object (Condvar_Id : out Valid_Condvar_Id_Type) is
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
   begin
      pragma Assert (Condvar_Id_Type (Atomic_Load (RTOS_Cpu_Instance.Next_Free_Condvar_Id)) /= Invalid_Condvar_Id);
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access
        (RTOS_Cpu_Instance'Address, RTOS_Cpu_Instance'Size, Old_Data_Range);
      Condvar_Id := Valid_Condvar_Id_Type (Atomic_Fetch_Add (RTOS_Cpu_Instance.Next_Free_Condvar_Id, 1));
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
   end Allocate_Condvar_Object;

   procedure Allocate_Timer_Object (Timer_Id : out Valid_Timer_Id_Type) is
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
   begin
      pragma Assert (Timer_Id_Type (Atomic_Load (RTOS_Cpu_Instance.Next_Free_Timer_Id)) /= Invalid_Timer_Id);
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access
        (RTOS_Cpu_Instance'Address, RTOS_Cpu_Instance'Size, Old_Data_Range);
      Timer_Id := Valid_Timer_Id_Type (Atomic_Fetch_Add (RTOS_Cpu_Instance.Next_Free_Timer_Id, 1));
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
   end Allocate_Timer_Object;

end HiRTOS.RTOS_Private;
