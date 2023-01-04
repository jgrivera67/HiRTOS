--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HiRTOS_Config_Parameters;
with HiRTOS.Memory_Protection;
with System.Storage_Elements;

package HiRTOS.Timer is

   type Timer_Expiration_Callback_Type is access
      procedure (Timer_Id : Valid_Timer_Id_Type;
                 Callback_Arg : System.Storage_Elements.Integer_Address)
          with Convention => C;

   function Initialized (Timer_Id : Valid_Timer_Id_Type) return Boolean
      with Ghost;

   function Timer_Running (Timer_Id : Valid_Timer_Id_Type) return Boolean
      with Ghost;

   procedure Create_Timer (Timer_Id : out Valid_Timer_Id_Type)
      with Post => Initialized (Timer_Id);

   procedure Start_Timer (Timer_Id : Valid_Timer_Id_Type;
                          Expiration_Time_Us : Time_Us_Type;
                          Expiration_Callback : Timer_Expiration_Callback_Type;
                          Expiration_Callback_Arg : System.Storage_Elements.Integer_Address;
                          Periodic : Boolean := False)
      with Pre => Initialized (Timer_Id) and then
                  not Timer_Running (Timer_Id) and then
                  Expiration_Time_Us mod HiRTOS_Config_Parameters.Tick_Timer_Period_Us = 0 and then
                  HiRTOS.Memory_Protection.Valid_Code_Address (Expiration_Callback.all'Address);

   procedure Stop_Timer (Timer_Id : Valid_Timer_Id_Type)
      with Pre => Initialized (Timer_Id),
           Post => not Timer_Running (Timer_Id);

end HiRTOS.Timer;
