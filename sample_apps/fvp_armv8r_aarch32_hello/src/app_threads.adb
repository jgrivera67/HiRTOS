--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.Thread;
with HiRTOS_Cpu_Arch_Interface;
with HiRTOS_Low_Level_Debug_Interface;
with System.Storage_Elements;
with Interfaces;

package body App_Threads is

   procedure Hello_Thread_Proc (Arg : System.Address) with
     Convention => C;

   Hello_Thread_Stack : HiRTOS.Small_Thread_Stack_Package.Execution_Stack_Type with
      Linker_Section => ".thread_stacks",
      Convention => C;

   procedure Initialize is
      use type HiRTOS.Thread_Priority_Type;
      use type System.Storage_Elements.Integer_Address;
      Thread_Id : HiRTOS.Valid_Thread_Id_Type;
   begin
      HiRTOS.Thread.Create_Thread
        (Hello_Thread_Proc'Access,
         System.Null_Address,
         HiRTOS.Highest_Thread_Priority - 1,
         Hello_Thread_Stack'Address,
         Hello_Thread_Stack'Size / System.Storage_Unit,
         Thread_Id);
   end Initialize;

   procedure Hello_Thread_Proc (Arg : System.Address) is
      use type System.Address;

      procedure Naive_Delay (N : Interfaces.Unsigned_32) is
         use Interfaces;
         Count : Unsigned_32 := N;
      begin
         loop
            exit when Count = 0;
            Count := Count - 1;
         end loop;
      end Naive_Delay;

      Turn_LED_On : Boolean := True;

   begin
      pragma Assert (not HiRTOS_Cpu_Arch_Interface.Cpu_In_Privileged_Mode);
      pragma Assert (not HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled);
      pragma Assert (Arg = System.Null_Address);
      HiRTOS.Enter_Cpu_Privileged_Mode;
      HiRTOS_Cpu_Arch_Interface.Wait_For_Interrupt; --???
      pragma Assert (not HiRTOS.Current_Execution_Context_Is_Interrupt);
      HiRTOS.Exit_Cpu_Privileged_Mode;

      loop
         HiRTOS.Enter_Cpu_Privileged_Mode;
         HiRTOS_Low_Level_Debug_Interface.Print_String ("Hello ");
         HiRTOS.Exit_Cpu_Privileged_Mode;
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

         Naive_Delay (10_000_000);
      end loop;
   end Hello_Thread_Proc;

end App_Threads;
