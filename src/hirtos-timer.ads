--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS.Memory_Protection;
with System.Storage_Elements;

package HiRTOS.Timer is

   type Timer_Expiration_Callback_Type is access
      procedure (Timer_Id : Valid_Timer_Id_Type;
                 Callback_Arg : System.Storage_Elements.Integer_Address)
          with Convention => C;

   function Timer_Running (Timer_Id : Valid_Timer_Id_Type) return Boolean;

   procedure Create_Timer (Timer_Id : out Valid_Timer_Id_Type);

   --
   --  NOTE: Due to a race condition with the tick timer ISR, the timer may have already expired
   --  when this subprogram returns to the caller. So we cannot assert in the post-condition that
   --  the timer is still running upon return.
   --
   procedure Start_Timer (Timer_Id : Valid_Timer_Id_Type;
                          Expiration_Time_Us : Relative_Time_Us_Type;
                          Expiration_Callback : Timer_Expiration_Callback_Type;
                          Expiration_Callback_Arg : System.Storage_Elements.Integer_Address;
                          Periodic : Boolean := False)
      with Pre => not Timer_Running (Timer_Id)
                  and then
                  Expiration_Time_Us /= 0
                  and then
                  Expiration_Time_Us mod HiRTOS_Config_Parameters.Tick_Timer_Period_Us = 0
                  and then
                  HiRTOS.Memory_Protection.Valid_Code_Address (Expiration_Callback.all'Address);

   --
   --  NOTE: Due to a race condition with the tick timer ISR, the timer may have already expired
   --  may have already expired when this subprogram is invoked. So we cannot assert in the
   --  pre-condition that the timer is still running upon entry.
   --
   procedure Stop_Timer (Timer_Id : Valid_Timer_Id_Type)
      with Post => not Timer_Running (Timer_Id);

   function Get_Timestamp_Us return Absolute_Time_Us_Type;

end HiRTOS.Timer;
