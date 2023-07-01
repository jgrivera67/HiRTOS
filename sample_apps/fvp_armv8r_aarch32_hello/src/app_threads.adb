--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.Thread;
with HiRTOS.Mutex;
with HiRTOS_Cpu_Arch_Interface;
with HiRTOS_Low_Level_Debug_Interface;
with System.Storage_Elements;
with Interfaces;

package body App_Threads is
   use System.Storage_Elements;

   procedure Hello_Thread_Proc (Arg : System.Address) with
     Convention => C;

   Num_Threads : constant := 8;

   Hello_Thread_Stacks :
      array (HiRTOS.Cpu_Id_Type, 1 .. Num_Threads) of HiRTOS.Small_Thread_Stack_Package.Execution_Stack_Type with
      Linker_Section => ".thread_stacks",
      Convention => C;

   Per_Cpu_Mutex_Id : array (HiRTOS.Cpu_Id_Type) of HiRTOS.Mutex_Id_Type;

   procedure Initialize is
      use type HiRTOS.Thread_Priority_Type;
      Thread_Id : HiRTOS.Valid_Thread_Id_Type;
      Cpu_Id : constant HiRTOS.Cpu_Id_Type := HiRTOS.Get_Current_Cpu_Id;
   begin
      HiRTOS.Mutex.Create_Mutex (Per_Cpu_Mutex_Id (Cpu_Id)); --  HiRTOS.Highest_Thread_Priority - 1,

      for I in 1 .. Num_Threads loop
         HiRTOS.Thread.Create_Thread
         (Hello_Thread_Proc'Access,
            To_Address (Integer_Address (I)),
            HiRTOS.Highest_Thread_Priority - HiRTOS.Valid_Thread_Priority_Type (I),
            Hello_Thread_Stacks (Cpu_Id, I)'Address,
            Hello_Thread_Stacks (Cpu_Id, I)'Size / System.Storage_Unit,
            Thread_Id);
      end loop;
   end Initialize;

   procedure Hello_Thread_Proc (Arg : System.Address) is
      use type System.Address;
      use type Interfaces.Unsigned_32;
      use type HiRTOS.Time_Us_Type;

      Turn_LED_On : Boolean := True;
      Cpu_Id : constant HiRTOS.Cpu_Id_Type := HiRTOS.Get_Current_Cpu_Id;
      Arg_Value : constant Positive range 1 .. Num_Threads := Positive (To_Integer (Arg));
      Period_Us : constant HiRTOS.Time_Us_Type := 500_000 * HiRTOS.Time_Us_Type (Arg_Value);
      Next_Wakeup_Time_Us : HiRTOS.Time_Us_Type := HiRTOS.Get_Current_Time_Us + Period_Us;
      Counter : Interfaces.Unsigned_32 := 0;
      Thread_Id : constant HiRTOS.Thread_Id_Type := HiRTOS.Thread.Get_Current_Thread_Id;
   begin
      pragma Assert (not HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode);
      pragma Assert (not HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled);
      --  HiRTOS.Enter_Cpu_Privileged_Mode;
      --  HiRTOS_Cpu_Arch_Interface.Wait_For_Interrupt;
      --  pragma Assert (not HiRTOS.Current_Execution_Context_Is_Interrupt);
      --  HiRTOS.Exit_Cpu_Privileged_Mode;

      loop
         HiRTOS.Mutex.Acquire (Per_Cpu_Mutex_Id (Cpu_Id));

         HiRTOS.Enter_Cpu_Privileged_Mode;
         HiRTOS_Low_Level_Debug_Interface.Print_String (" Thread ");
         HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (Interfaces.Unsigned_32 (Arg_Value));
         HiRTOS_Low_Level_Debug_Interface.Print_String (" (thread id ");
         HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (
            Interfaces.Unsigned_32 (Thread_Id));
         HiRTOS_Low_Level_Debug_Interface.Print_String ("): ");
         HiRTOS_Low_Level_Debug_Interface.Print_String ("Wakeups count: ");
         HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (Counter, End_Line => True);
         HiRTOS.Exit_Cpu_Privileged_Mode;

         HiRTOS.Mutex.Release (Per_Cpu_Mutex_Id (Cpu_Id));

         if Arg_Value = 1 then
            if Turn_LED_On then
               Turn_LED_On := False;
               HiRTOS.Enter_Cpu_Privileged_Mode;
               HiRTOS_Low_Level_Debug_Interface.Set_Led (True);
               HiRTOS.Exit_Cpu_Privileged_Mode;
            else
               Turn_LED_On := True;
               HiRTOS.Enter_Cpu_Privileged_Mode;
               HiRTOS_Low_Level_Debug_Interface.Set_Led (False);
               HiRTOS.Exit_Cpu_Privileged_Mode;
            end if;
         end if;

         Counter := @ + 1;
         HiRTOS.Thread.Thread_Delay_Until (Next_Wakeup_Time_Us);
         Next_Wakeup_Time_Us := @ + Period_Us;
      end loop;
   end Hello_Thread_Proc;

end App_Threads;
