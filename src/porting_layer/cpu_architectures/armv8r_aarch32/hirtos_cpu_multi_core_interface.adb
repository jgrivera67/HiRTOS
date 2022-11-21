--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS multi-core CPU interface for ARMv8-R architecture
--

with System.Machine_Code;

package body HiRTOS_Cpu_Multi_Core_Interface is

   MPIDR_Core_Id_Mask : constant := 2#1111_1111#;

   function Get_Cpu_Id return Valid_Cpu_Core_Id_Type is
      use type Interfaces.Unsigned_32;
      Reg_Value : Interfaces.Unsigned_32;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c0, c0, 5",   -- read MPIDR
         Outputs => Interfaces.Unsigned_32'Asm_Output ("=r", Reg_Value), --  %0
         Volatile => True);

      Reg_Value := @ and MPIDR_Core_Id_Mask;
      return Valid_Cpu_Core_Id_Type (Reg_Value);
   end Get_Cpu_Id;

   procedure Spinlock_Acquire (Spinlock : in out Spinlock_Type) is
   begin
      while HiRTOS_Cpu_Arch_Interface.Atomic_Test_Set (Spinlock.Atomic_Flag'Address) loop
         HiRTOS_Cpu_Arch_Interface.Wait_For_Event;
      end loop;

      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
   end Spinlock_Acquire;

   procedure Spinlock_Release (Spinlock : in out Spinlock_Type) is
   begin
      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
      Spinlock.Atomic_Flag := 0;
      HiRTOS_Cpu_Arch_Interface.Send_Event;
   end Spinlock_Release;

end HiRTOS_Cpu_Multi_Core_Interface;
