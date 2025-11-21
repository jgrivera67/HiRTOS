--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  Board-specific interface Raspberry PI 5
--

with PSCI_Interface;

package body Board is

   procedure Start_Secondary_Cpu (Cpu_Id : Secondary_Cpu_Core_Id_Type;
                                  Entry_Point_Address : System.Address) is
   begin
      PSCI_Interface.Cpu_On (Cpu_Id, Entry_Point_Address);
   end Start_Secondary_Cpu;

end Board;
