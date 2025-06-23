--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  Memory map for Raspberry PI 5
--
with System;
package Peripherals_Mmio_Map is
   --
   --  Main peripherals and ARM local peripherals in "High peripheral" mode.
   --
   Global_Mmio_Region_Start_Address : constant System.Address := System'To_Address (16#10_7000_0000#);
   Global_Mmio_Region_End_Address : constant System.Address := System'To_Address (16#10_f000_0000#);

   UART0_Base : constant System.Address := System'To_Address (16#10_7d00_1000#);
   UART2_Base : constant System.Address := System'To_Address (16#10_7d00_1400#);
   UART3_Base : constant System.Address := System'To_Address (16#10_7d00_1600#);
   UART4_Base : constant System.Address := System'To_Address (16#10_7d00_1800#);
   UART5_Base : constant System.Address := System'To_Address (16#10_7d00_1a00#);

   GICD_Base_Address : constant System.Address := System'To_Address (16#10_7fff_9000#);
   GICC_Base_Address : constant System.Address := System'To_Address (16#10_7fff_a000#);
end Peripherals_Mmio_Map;