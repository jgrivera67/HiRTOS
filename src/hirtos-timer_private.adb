--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS.RTOS_Private;
with HiRTOS.Thread_Private;
with HiRTOS.Condvar;
with HiRTOS_Cpu_Arch_Interface;
with HiRTOS_Cpu_Multi_Core_Interface;
with HiRTOS_Config_Parameters;
with HiRTOS_Low_Level_Debug_Interface; --???

package body HiRTOS.Timer_Private is
   use HiRTOS.RTOS_Private;
   use HiRTOS_Cpu_Multi_Core_Interface;

   function Initialized (Timer_Id : Valid_Timer_Id_Type) return Boolean is
      (HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id).Timer_Instances (Timer_Id).Initialized);

   procedure Initialize_Timer_Wheel (Timer_Wheel : out Timer_Wheel_Type) is
   begin
      for I in Timer_Wheel.Wheel_Spokes_Hash_Table'Range loop
         Timer_List_Package.List_Init (Timer_Wheel.Wheel_Spokes_Hash_Table (I), I);
      end loop;

      Timer_Wheel.Current_Wheel_Spoke_Index :=
         Valid_Timer_Wheel_Spoke_Index_Type'First;
   end Initialize_Timer_Wheel;

   procedure Process_Timer_Wheel_Hash_Chain (Timer_Wheel_Hash_Chain : in out Timer_List_Package.List_Anchor_Type)
   is
      procedure Process_Timer (Timer_Wheel_Hash_Chain : in out Timer_List_Package.List_Anchor_Type;
                               Timer_Id : Timer_Id_Type;
                               Timer_Lists_Nodes : in out Timer_List_Package.List_Nodes_Type)
         with Pre => Initialized (Timer_Id) and then
                     HiRTOS.Timer.Timer_Running (Timer_Id) and then
                     HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled;

      procedure Process_Timer (Timer_Wheel_Hash_Chain : in out Timer_List_Package.List_Anchor_Type;
                               Timer_Id : Timer_Id_Type;
                               Timer_Lists_Nodes : in out Timer_List_Package.List_Nodes_Type) is
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
         Timer_Obj : Timer_Type renames RTOS_Cpu_Instance.Timer_Instances (Timer_Id);
      begin
         if Timer_Obj.Timer_Wheel_Revolutions_Left = 0 then
            if Timer_Obj.Periodic then
               Timer_Obj.Timer_Wheel_Revolutions_Left := Timer_Obj.Timer_Wheel_Revolutions;
            else
               Timer_List_Package.List_Remove_This (Timer_Wheel_Hash_Chain, Timer_Id,
                                                    Timer_Lists_Nodes);
               Timer_Obj.Running := False;
            end if;

            --
            --  Call timer expiration callback:
            --
            Timer_Obj.Expiration_Callback.all (Timer_Id, Timer_Obj.Expiration_Callback_Arg);
         else
            Timer_Obj.Timer_Wheel_Revolutions_Left := @ - 1;
         end if;
      end Process_Timer;

      procedure Traverse_Timer_Wheel_Hash_Chain is new
         Timer_List_Package.List_Traverse (Element_Visitor => Process_Timer);

      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
   begin
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
      Traverse_Timer_Wheel_Hash_Chain (Timer_Wheel_Hash_Chain,
                                       RTOS_Cpu_Instance.Timer_Lists_Nodes);
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
   end Process_Timer_Wheel_Hash_Chain;

   procedure Do_Software_Timers_Bookkeeping is
      use type HiRTOS_Config_Parameters.Software_Timers_Bookkeeping_Method_Type;
      RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
         HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
      Timer_Wheel : Timer_Wheel_Type renames RTOS_Cpu_Instance.Timer_Wheel;
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      --  Begin critical section
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      if Timer_Wheel.Current_Wheel_Spoke_Index < Valid_Timer_Wheel_Spoke_Index_Type'Last then
         Timer_Wheel.Current_Wheel_Spoke_Index := @ + 1;
      else
         Timer_Wheel.Current_Wheel_Spoke_Index := Valid_Timer_Wheel_Spoke_Index_Type'First;
      end if;

      if HiRTOS_Config_Parameters.Software_Timers_Bookkeeping_Method =
         HiRTOS_Config_Parameters.Software_Timers_Bookkeeping_In_Timer_ISR
      then
         --
         --  Do timer wheel processing:
         --
         declare
            Timer_Wheel_Hash_Chain : Timer_List_Package.List_Anchor_Type renames
               Timer_Wheel.Wheel_Spokes_Hash_Table (Timer_Wheel.Current_Wheel_Spoke_Index);
         begin
            Process_Timer_Wheel_Hash_Chain (Timer_Wheel_Hash_Chain);
         end;
      else
         declare
            Tick_timer_Thread_Obj : HiRTOS.Thread_Private.Thread_Type renames
               RTOS_Cpu_Instance.Thread_Instances (RTOS_Cpu_Instance.Tick_Timer_Thread_Id);
         begin
            --
            --  Wake up timer thread
            --
            HiRTOS.Condvar.Signal (Tick_timer_Thread_Obj.Builtin_Condvar_Id);
         end;
      end if;

      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
   end Do_Software_Timers_Bookkeeping;

   procedure Timer_Thread_Proc (Arg : System.Address) is
      use type HiRTOS_Config_Parameters.Software_Timers_Bookkeeping_Method_Type;
      use type System.Address;
   begin
      pragma Assert (Arg = System.Null_Address);
      HiRTOS.Enter_Cpu_Privileged_Mode;
      HiRTOS_Low_Level_Debug_Interface.Print_String("JGR: Timer_Thread_Proc" & ASCII.LF); --???

      declare
         RTOS_Cpu_Instance : HiRTOS_Cpu_Instance_Type renames
            HiRTOS_Obj.RTOS_Cpu_Instances (Get_Cpu_Id);
         Tick_Timer_Thread_Obj : HiRTOS.Thread_Private.Thread_Type renames
            RTOS_Cpu_Instance.Thread_Instances (RTOS_Cpu_Instance.Tick_Timer_Thread_Id);
         Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
      begin
         loop
            --  Begin critical section
            Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
            while not RTOS_Cpu_Instance.Tick_Timer_Thread_Work_Requested loop
               HiRTOS.Condvar.Wait (Tick_Timer_Thread_Obj.Builtin_Condvar_Id);
            end loop;

            RTOS_Cpu_Instance.Tick_Timer_Thread_Work_Requested := False;
            --  End critical section
            HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);

            if HiRTOS_Config_Parameters.Software_Timers_Bookkeeping_Method =
               HiRTOS_Config_Parameters.Software_Timers_Bookkeeping_In_Timer_Thread
            then
               --
               --  Do timer wheel processing:
               --
               declare
                  Timer_Wheel : Timer_Wheel_Type renames RTOS_Cpu_Instance.Timer_Wheel;
                  Timer_Wheel_Hash_Chain : Timer_List_Package.List_Anchor_Type renames
                     Timer_Wheel.Wheel_Spokes_Hash_Table (Timer_Wheel.Current_Wheel_Spoke_Index);
               begin
                  Process_Timer_Wheel_Hash_Chain (Timer_Wheel_Hash_Chain);
               end;
            end if;
         end loop;
      end;

   end Timer_Thread_Proc;

end HiRTOS.Timer_Private;
