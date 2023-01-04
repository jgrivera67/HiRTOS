--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS.RTOS_Private;
with HiRTOS_Cpu_Arch_Interface;
with HiRTOS_Cpu_Multi_Core_Interface;
with HiRTOS_Config_Parameters;
with HiRTOS_Low_Level_Debug_Interface; --???
with GNAT.Source_Info; --???
package body HiRTOS.Timer_Private is
   use HiRTOS.RTOS_Private;
   use HiRTOS_Cpu_Multi_Core_Interface;

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
                               Timer_Id : Timer_Id_Type)
         with Pre => HiRTOS.Timer.Initialized (Timer_Id) and then
                     HiRTOS.Timer.Timer_Running (Timer_Id) and then
                     HiRTOS_Cpu_Arch_Interface.Cpu_Interrupting_Disabled;

      procedure Process_Timer (Timer_Wheel_Hash_Chain : in out Timer_List_Package.List_Anchor_Type;
                               Timer_Id : Timer_Id_Type) is
         Timer_Obj : Timer_Type renames HiRTOS_Obj.Timer_Instances (Timer_Id);
      begin
         if Timer_Obj.Timer_Wheel_Revolutions_Left = 0 then
            --
            --  Call timer expiration callback:
            --
            Timer_Obj.Expiration_Callback.all (Timer_Id, Timer_Obj.Expiration_Callback_Arg);

            if Timer_Obj.Periodic then
               Timer_Obj.Timer_Wheel_Revolutions_Left := Timer_Obj.Timer_Wheel_Revolutions;
            else
               Timer_List_Package.List_Remove_This (Timer_Wheel_Hash_Chain, Timer_Id);
               Timer_Obj.Running := False;
            end if;
         else
            Timer_Obj.Timer_Wheel_Revolutions_Left := @ - 1;
         end if;
      end Process_Timer;

      procedure Traverse_Timer_Wheel_Hash_Chain is new
         Timer_List_Package.List_Traverse (Element_Visitor => Process_Timer);

      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
   begin
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
      Traverse_Timer_Wheel_Hash_Chain (Timer_Wheel_Hash_Chain);
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
         --
         --  Wake up timer thread
         --
         pragma Assert (False); -- TODO: implement this
      end if;

      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
   end Do_Software_Timers_Bookkeeping;

end HiRTOS.Timer_Private;
