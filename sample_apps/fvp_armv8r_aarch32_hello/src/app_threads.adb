--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.Thread;
with HiRTOS.Mutex;
with HiRTOS.Timer;
with HiRTOS_Cpu_Arch_Interface.Tick_Timer;
with HiRTOS_Low_Level_Debug_Interface;
with System.Storage_Elements;
with Interfaces;

package body App_Threads is
   use System.Storage_Elements;

   procedure Heat_Beat_Timer_Callback (Timer_Id : HiRTOS.Valid_Timer_Id_Type;
                                       Callback_Arg : Integer_Address)
      with Convention => C;

   procedure Hello_Thread_Proc (Arg : System.Address) with
     Convention => C;

   Num_Threads : constant := 8;

   Heart_Beat_Timer_Period_Us : constant HiRTOS.Relative_Time_Us_Type := 100_000;

   Hello_Thread_Stacks :
      array (HiRTOS.Cpu_Id_Type, 1 .. Num_Threads) of HiRTOS.Small_Thread_Stack_Package.Execution_Stack_Type with
      Linker_Section => ".thread_stacks",
      Convention => C;

   type My_Cpu_Data_Type is limited record
      Turn_LED_On : Boolean := True;
      Heart_Beat_Timer_Id : HiRTOS.Timer_Id_Type := HiRTOS.Invalid_Timer_Id;
      Mutex_Id : HiRTOS.Mutex_Id_Type := HiRTOS.Invalid_Mutex_Id;
   end record;

   Per_Cpu_Data : array (HiRTOS.Cpu_Id_Type) of My_Cpu_Data_Type;

   procedure Initialize is
      use type HiRTOS.Thread_Priority_Type;
      use type HiRTOS.Relative_Time_Us_Type;
      Thread_Id : HiRTOS.Valid_Thread_Id_Type;
      Cpu_Id : constant HiRTOS.Cpu_Id_Type := HiRTOS.Get_Current_Cpu_Id;
      My_Cpu_Data : My_Cpu_Data_Type renames Per_Cpu_Data (Cpu_Id);
   begin
      HiRTOS.Timer.Create_Timer (My_Cpu_Data.Heart_Beat_Timer_Id);
      HiRTOS.Mutex.Create_Mutex (My_Cpu_Data.Mutex_Id); --  HiRTOS.Highest_Thread_Priority - 1,

      for I in 1 .. Num_Threads loop
         HiRTOS.Thread.Create_Thread (
            Hello_Thread_Proc'Access,
            To_Address (Integer_Address (I)),
            HiRTOS.Highest_Thread_Priority - HiRTOS.Valid_Thread_Priority_Type (I),
            Hello_Thread_Stacks (Cpu_Id, I)'Address,
            Hello_Thread_Stacks (Cpu_Id, I)'Size / System.Storage_Unit,
            Thread_Id);
      end loop;

      HiRTOS.Timer.Start_Timer (My_Cpu_Data.Heart_Beat_Timer_Id,
                                Heart_Beat_Timer_Period_Us * (HiRTOS.Relative_Time_Us_Type (Cpu_Id) + 1),
                                Heat_Beat_Timer_Callback'Access,
                                To_Integer (My_Cpu_Data'Address),
                                Periodic => True);
   end Initialize;

   procedure Hello_Thread_Proc (Arg : System.Address) is
      use type System.Address;
      use type Interfaces.Unsigned_32;
      use type HiRTOS.Relative_Time_Us_Type;
      use type HiRTOS.Absolute_Time_Us_Type;

      Cpu_Id : constant HiRTOS.Cpu_Id_Type := HiRTOS.Get_Current_Cpu_Id;
      Arg_Value : constant Positive range 1 .. Num_Threads := Positive (To_Integer (Arg));
      Period_Us : constant HiRTOS.Relative_Time_Us_Type :=
         500_000 * HiRTOS.Relative_Time_Us_Type (Arg_Value);
      Thread_Id : constant HiRTOS.Thread_Id_Type := HiRTOS.Thread.Get_Current_Thread_Id;
      Time_Since_Boot_Us : HiRTOS.Absolute_Time_Us_Type;
      Last_Wakeup_Time_Us : HiRTOS.Absolute_Time_Us_Type;
      Next_Wakeup_Time_Us : HiRTOS.Absolute_Time_Us_Type :=
         HiRTOS.Get_Current_Time_Us + HiRTOS.Absolute_Time_Us_Type (Period_Us);
      Counter : Interfaces.Unsigned_32 := 1;
      My_Cpu_Data : My_Cpu_Data_Type renames Per_Cpu_Data (Cpu_Id);
   begin
      pragma Assert (not HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode);
      pragma Assert (not HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled);
      pragma Assert (Arg_Value = Positive (Thread_Id) - 1);
      --  HiRTOS.Enter_Cpu_Privileged_Mode;
      --  HiRTOS_Cpu_Arch_Interface.Wait_For_Interrupt;
      --  pragma Assert (not HiRTOS.Current_Execution_Context_Is_Interrupt);
      --  HiRTOS.Exit_Cpu_Privileged_Mode;

      loop
         HiRTOS.Mutex.Acquire (My_Cpu_Data.Mutex_Id);

         HiRTOS.Enter_Cpu_Privileged_Mode;
         HiRTOS_Low_Level_Debug_Interface.Print_String (" Thread ");
         HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (Interfaces.Unsigned_32 (Arg_Value));
         HiRTOS_Low_Level_Debug_Interface.Print_String (" (id ");
         HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (
            Interfaces.Unsigned_32 (Thread_Id));
         HiRTOS_Low_Level_Debug_Interface.Print_String (", prio ");
         HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (
            Interfaces.Unsigned_32 (HiRTOS.Thread.Get_Current_Thread_Priority));
         HiRTOS_Low_Level_Debug_Interface.Print_String ("): Period ");
         HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (
            Interfaces.Unsigned_32 (Period_Us / 1000));
         HiRTOS_Low_Level_Debug_Interface.Print_String ("ms, Last run at ");
         Time_Since_Boot_Us := HiRTOS_Cpu_Arch_Interface.Tick_Timer.Get_Timer_Timestamp_Us;
         HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (
            Interfaces.Unsigned_32 (Time_Since_Boot_Us / 1000_000));
         HiRTOS_Low_Level_Debug_Interface.Print_String ("s ");
         HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (
            Interfaces.Unsigned_32 (Time_Since_Boot_Us mod 1000_000));
         HiRTOS_Low_Level_Debug_Interface.Print_String ("us, ");
         HiRTOS_Low_Level_Debug_Interface.Print_String ("Wakeups ");
         HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (Counter, End_Line => True);
         HiRTOS.Exit_Cpu_Privileged_Mode;

         HiRTOS.Mutex.Release (My_Cpu_Data.Mutex_Id);

         Counter := @ + 1;
         Last_Wakeup_Time_Us := HiRTOS.Thread.Thread_Delay_Until (Next_Wakeup_Time_Us);
         Next_Wakeup_Time_Us := @ + HiRTOS.Absolute_Time_Us_Type (Period_Us);
         if Last_Wakeup_Time_Us >= Next_Wakeup_Time_Us then
            declare
               Time_Behind_Us : constant HiRTOS.Relative_Time_Us_Type :=
                  HiRTOS.Relative_Time_Us_Type (Last_Wakeup_Time_Us - Next_Wakeup_Time_Us);
            begin
               HiRTOS.Mutex.Acquire (My_Cpu_Data.Mutex_Id);
               HiRTOS.Enter_Cpu_Privileged_Mode;
               HiRTOS_Low_Level_Debug_Interface.Print_String ("*** WARNING: Thread ");
               HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (Interfaces.Unsigned_32 (Arg_Value));
               HiRTOS_Low_Level_Debug_Interface.Print_String (" was late by ");
               HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (
                  Interfaces.Unsigned_32 (Time_Behind_Us));
               HiRTOS_Low_Level_Debug_Interface.Print_String (" us" & ASCII.LF);
               HiRTOS.Exit_Cpu_Privileged_Mode;
               HiRTOS.Mutex.Release (My_Cpu_Data.Mutex_Id);

               --  Catch up
               Next_Wakeup_Time_Us :=
                  HiRTOS.Get_Current_Time_Us + HiRTOS.Absolute_Time_Us_Type (Period_Us);
            end;
         end if;
      end loop;
   end Hello_Thread_Proc;

   procedure Heat_Beat_Timer_Callback (Timer_Id : HiRTOS.Valid_Timer_Id_Type;
                                       Callback_Arg : Integer_Address) is
      use type System.Address;
      use type HiRTOS.Timer_Id_Type;
      Cpu_Id : constant HiRTOS.Cpu_Id_Type := HiRTOS.Get_Current_Cpu_Id;
      My_Cpu_Data : My_Cpu_Data_Type renames Per_Cpu_Data (Cpu_Id);
   begin
      pragma Assert (My_Cpu_Data'Address = To_Address (Callback_Arg));
      pragma Assert (Timer_Id = My_Cpu_Data.Heart_Beat_Timer_Id);
      pragma Assert (HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode);

      if My_Cpu_Data.Turn_LED_On then
         My_Cpu_Data.Turn_LED_On := False;
         HiRTOS_Low_Level_Debug_Interface.Set_Led (True);
      else
         My_Cpu_Data.Turn_LED_On := True;
         HiRTOS_Low_Level_Debug_Interface.Set_Led (False);
      end if;
   end Heat_Beat_Timer_Callback;

end App_Threads;
