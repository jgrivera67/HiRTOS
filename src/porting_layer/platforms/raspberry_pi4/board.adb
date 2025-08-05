--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  Board-specific interface Raspberry PI 4
--

package body Board is

   procedure Start_Secondary_Cpu (Cpu_Id : Secondary_Cpu_Core_Id_Type;
                                  Entry_Point_Address : System.Address) is
      Spin_Address : System.Address renames Secondary_Cpu_To_Spin_Address_Map (Cpu_Id);
      Secondary_Cpu_Spin_Entry : System.Address with Import, Address => Spin_Address;
   begin
      Secondary_Cpu_Spin_Entry := Entry_Point_Address;
   end Start_Secondary_Cpu;

end Board;
