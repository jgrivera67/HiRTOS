--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.Memory_Protection;
with HiRTOS_Low_Level_Debug_Interface;

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

   procedure Last_Chance_Handler (Msg : System.Address; Line : Integer) is
      procedure Privileged_Last_Chance_Handler (Msg : System.Address; Line : Integer)
         with No_Return
      is
         Msg_Text : String (1 .. 128) with Address => Msg;
         Msg_Length : Natural := 0;
         Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
           HiRTOS_Obj.RTOS_Cpu_Instances (Cpu_Id);
      begin
         HiRTOS_Low_Level_Debug_Interface.Set_Led (True);
         --
         --  Calculate length of the null-terminated 'Msg' string:
         --
         for Msg_Char of Msg_Text loop
            Msg_Length := Msg_Length + 1;
            exit when Msg_Char = ASCII.NUL;
         end loop;

         if RTOS_Cpu_Instance.Last_Chance_Handler_Running then
            HiRTOS_Low_Level_Debug_Interface.Print_String (
               "*** Recursive call to Last_Chance_Handler: " &
               Msg_Text (1 .. Msg_Length) & "' at line ");
            HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (Interfaces.Unsigned_32 (Line),
                                                                  End_Line => True);
            loop
               HiRTOS_Cpu_Arch_Interface.Wait_For_Interrupt;
            end loop;
         end if;

         RTOS_Cpu_Instance.Last_Chance_Handler_Running := True;

         --
         --  Print exception message to UART:
         --
         if Line /= 0 then
            HiRTOS_Low_Level_Debug_Interface.Print_String (
               ASCII.LF & "*** Exception: '" & Msg_Text (1 .. Msg_Length) &
               "' at line ");
            HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (Interfaces.Unsigned_32 (Line),
                                                                  End_Line => True);
         else
            HiRTOS_Low_Level_Debug_Interface.Print_String (
               ASCII.LF &
               "*** Exception: '" & Msg_Text (1 .. Msg_Length) & "'" & ASCII.LF);
         end if;

         loop
            HiRTOS_Cpu_Arch_Interface.Wait_For_Interrupt;
         end loop;
      end Privileged_Last_Chance_Handler;

   begin
      Enter_Cpu_Privileged_Mode;
      Privileged_Last_Chance_Handler (Msg, Line);
   end Last_Chance_Handler;

end HiRTOS.RTOS_Private;
