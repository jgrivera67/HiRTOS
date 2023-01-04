--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.Mutex_Private;
with HiRTOS.RTOS_Private;
with HiRTOS.Memory_Protection;

package body HiRTOS.Mutex is
   use HiRTOS.Mutex_Private;
   use HiRTOS.RTOS_Private;

   procedure Initialize_Mutex (Mutex_Obj : out Mutex_Type; Mutex_Id : Mutex_Id_Type)
      with Pre => Mutex_Id /= Invalid_Mutex_Id;

   -----------------------------------------------------------------------------
   --  Public Subprograms
   -----------------------------------------------------------------------------

   function Initialized (Mutex_Id : Valid_Mutex_Id_Type) return Boolean is
      (HiRTOS_Obj.Mutex_Instances (Mutex_Id).Initialized);

   procedure Create_Mutex (Mutex_Id : out Mutex_Id_Type) is
   begin
      RTOS_Private.Allocate_Mutex_Object (Mutex_Id);
      Initialize_Mutex (HiRTOS_Obj.Mutex_Instances (Mutex_Id), Mutex_Id);
   end Create_Mutex;

   -----------------------------------------------------------------------------
   --  Private Subprograms
   -----------------------------------------------------------------------------

   procedure Initialize_Mutex (Mutex_Obj : out Mutex_Type; Mutex_Id : Mutex_Id_Type) is
      Old_Data_Range : HiRTOS.Memory_Protection.Memory_Range_Type;
   begin
      HiRTOS.Memory_Protection.Begin_Data_Range_Write_Access (Mutex_Obj'Address, Mutex_Obj'Size,
                                                              Old_Data_Range);
      Mutex_Obj.Id := Mutex_Id;
      Initialize_Thread_Priority_Queue (Mutex_Obj.Waiters_Queue);
      Mutex_Obj.Initialized := True;
      HiRTOS.Memory_Protection.End_Data_Range_Access (Old_Data_Range);
   end Initialize_Mutex;

end HiRTOS.Mutex;
