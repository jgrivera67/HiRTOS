--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS multi-core CPU interface
--

with HiRTOS_Platform_Parameters;
private with HiRTOS_Cpu_Arch_Interface;
with Interfaces;

package HiRTOS_Cpu_Multi_Core_Interface
   with SPARK_Mode => On,
        No_Elaboration_Code_All
is
   --
   --  Ids of CPU cores
   --
   --  NOTE: +1 to allow for an invalid CPU Id
   --
   type Cpu_Core_Id_Type is mod HiRTOS_Platform_Parameters.Num_Cpu_Cores + 1
     with Size => Interfaces.Unsigned_8'Size;

   subtype Valid_Cpu_Core_Id_Type is
     Cpu_Core_Id_Type range Cpu_Core_Id_Type'First .. Cpu_Core_Id_Type'Last - 1;

   Invalid_Cpu_Core_Id : constant Cpu_Core_Id_Type := Cpu_Core_Id_Type'Last;

   function Get_Cpu_Id return Valid_Cpu_Core_Id_Type
      with Inline_Always,
           Suppress => All_Checks;

   type Spinlock_Type is limited private;

   procedure Spinlock_Acquire (Spinlock : in out Spinlock_Type);

   procedure Spinlock_Release (Spinlock : in out Spinlock_Type);

private

   type Spinlock_Type is limited record
    Atomic_Flag : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type := 0;
   end record
     with Volatile_Full_Access;

end HiRTOS_Cpu_Multi_Core_Interface;
