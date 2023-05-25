--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

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
      with Pre => Initialized (Timer_Id);

   procedure Create_Timer (Timer_Id : out Valid_Timer_Id_Type)
      with Post => Initialized (Timer_Id);

   --
   --  NOTE: Due to a race condition with the tick timer ISR, the timer may have already expired
   --  when this subprogram returns to the caller. So we cannot assert in the post-condition that
   --  the timer is still running upon return.
   --
   procedure Start_Timer (Timer_Id : Valid_Timer_Id_Type;
                          Expiration_Time_Us : Time_Us_Type;
                          Expiration_Callback : Timer_Expiration_Callback_Type;
                          Expiration_Callback_Arg : System.Storage_Elements.Integer_Address;
                          Periodic : Boolean := False)
      with Pre => Initialized (Timer_Id) and then
                  not Timer_Running (Timer_Id) and then
                  HiRTOS.Memory_Protection.Valid_Code_Address (Expiration_Callback.all'Address);

   --
   --  NOTE: Due to a race condition with the tick timer ISR, the timer may have already expired
   --  may have already expired when this subprogram is invoked. So we cannot assert in the
   --  pre-condition that the timer is still running upon entry.
   --
   procedure Stop_Timer (Timer_Id : Valid_Timer_Id_Type)
      with Pre => Initialized (Timer_Id),
           Post => not Timer_Running (Timer_Id);

end HiRTOS.Timer;
