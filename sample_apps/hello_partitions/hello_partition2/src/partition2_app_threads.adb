--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.Thread;
with HiRTOS.Mutex;
with HiRTOS.Timer;
with HiRTOS.Debug;
with System.Storage_Elements;
with Interfaces;

package body Partition2_App_Threads is
   use System.Storage_Elements;

   procedure Heart_Beat_Timer_Callback (Timer_Id : HiRTOS.Valid_Timer_Id_Type;
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
                                Heart_Beat_Timer_Callback'Access,
                                To_Integer (My_Cpu_Data'Address),
                                Periodic => True);
   end Initialize;

   procedure Hello_Thread_Proc (Arg : System.Address) is
      use type System.Address;
      use type Interfaces.Unsigned_32;
      use type HiRTOS.Relative_Time_Us_Type;
      use type HiRTOS.Absolute_Time_Us_Type;

      One_Hour_Us : constant := 3_600 * 1_000_000;
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
      pragma Assert (not HiRTOS.Cpu_In_Privileged_Mode);
      pragma Assert (not HiRTOS.Cpu_Interrupting_Disabled);
      pragma Assert (Arg_Value = Positive (Thread_Id) - 1);
      --  HiRTOS.Enter_Cpu_Privileged_Mode;
      --  HiRTOS_Cpu_Arch_Interface.Wait_For_Interrupt;
      --  pragma Assert (not HiRTOS.Current_Execution_Context_Is_Interrupt);
      --  HiRTOS.Exit_Cpu_Privileged_Mode;

      loop
         HiRTOS.Mutex.Acquire (My_Cpu_Data.Mutex_Id);

         HiRTOS.Debug.Print_String ("Partition 2: Thread ");
         HiRTOS.Debug.Print_Number_Decimal (Interfaces.Unsigned_32 (Arg_Value));
         HiRTOS.Debug.Print_String (" (id ");
         HiRTOS.Debug.Print_Number_Decimal (
            Interfaces.Unsigned_32 (Thread_Id));
         HiRTOS.Debug.Print_String (", prio ");
         HiRTOS.Debug.Print_Number_Decimal (
            Interfaces.Unsigned_32 (HiRTOS.Thread.Get_Current_Thread_Priority));
         HiRTOS.Debug.Print_String ("): Period ");
         HiRTOS.Debug.Print_Number_Decimal (
            Interfaces.Unsigned_32 (Period_Us / 1_000));
         HiRTOS.Debug.Print_String ("ms, Last run at ");
         Time_Since_Boot_Us := HiRTOS.Timer.Get_Timestamp_Us;
         if Time_Since_Boot_Us >= One_Hour_Us then
            HiRTOS.Debug.Print_Number_Decimal (
               Interfaces.Unsigned_32 (Time_Since_Boot_Us / One_Hour_Us));
            HiRTOS.Debug.Print_String ("h ");
            Time_Since_Boot_Us := Time_Since_Boot_Us mod One_Hour_Us;
         end if;
         HiRTOS.Debug.Print_Number_Decimal (
            Interfaces.Unsigned_32 (Time_Since_Boot_Us / 1_000_000));
         HiRTOS.Debug.Print_String ("s ");
         HiRTOS.Debug.Print_Number_Decimal (
            Interfaces.Unsigned_32 (Time_Since_Boot_Us mod 1_000_000));
         HiRTOS.Debug.Print_String ("us, ");
         HiRTOS.Debug.Print_String ("Wakeups ");
         HiRTOS.Debug.Print_Number_Decimal (Counter, End_Line => True);

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
               HiRTOS.Debug.Print_String ("*** WARNING: Thread ");
               HiRTOS.Debug.Print_Number_Decimal (Interfaces.Unsigned_32 (Arg_Value));
               HiRTOS.Debug.Print_String (" was late by ");
               HiRTOS.Debug.Print_Number_Decimal (
                  Interfaces.Unsigned_32 (Time_Behind_Us));
               HiRTOS.Debug.Print_String (" us" & ASCII.LF);
               HiRTOS.Mutex.Release (My_Cpu_Data.Mutex_Id);

               --  Catch up
               Next_Wakeup_Time_Us :=
                  HiRTOS.Get_Current_Time_Us + HiRTOS.Absolute_Time_Us_Type (Period_Us);
            end;
         end if;
      end loop;
   end Hello_Thread_Proc;

   procedure Heart_Beat_Timer_Callback (Timer_Id : HiRTOS.Valid_Timer_Id_Type;
                                       Callback_Arg : Integer_Address) is
      use type System.Address;
      use type HiRTOS.Timer_Id_Type;
      Cpu_Id : constant HiRTOS.Cpu_Id_Type := HiRTOS.Get_Current_Cpu_Id;
      My_Cpu_Data : My_Cpu_Data_Type renames Per_Cpu_Data (Cpu_Id);
   begin
      pragma Assert (My_Cpu_Data'Address = To_Address (Callback_Arg));
      pragma Assert (Timer_Id = My_Cpu_Data.Heart_Beat_Timer_Id);
      pragma Assert (HiRTOS.Cpu_In_Privileged_Mode);

      if My_Cpu_Data.Turn_LED_On then
         My_Cpu_Data.Turn_LED_On := False;
         HiRTOS.Debug.Set_Led (True);
      else
         My_Cpu_Data.Turn_LED_On := True;
         HiRTOS.Debug.Set_Led (False);
      end if;
   end Heart_Beat_Timer_Callback;

end Partition2_App_Threads;
