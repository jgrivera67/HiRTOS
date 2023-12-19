--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS multi-core CPU interface
--

with HiRTOS_Platform_Parameters;
with HiRTOS_Cpu_Arch_Interface;
private with HiRTOS_Cpu_Arch_Parameters;
private with System;
with Interfaces;

package HiRTOS_Cpu_Multi_Core_Interface
   with SPARK_Mode => On
is

   use HiRTOS_Cpu_Arch_Interface;

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

   type Atomic_Counter_Type is limited private;

   function Atomic_Counter_Initializer (Value : Cpu_Register_Type) return Atomic_Counter_Type;

   function Atomic_Test_Set (Atomic_Counter : in out Atomic_Counter_Type; Value : Cpu_Register_Type)
    return Cpu_Register_Type
    with SPARK_Mode => Off;

   function Atomic_Fetch_Add (Atomic_Counter : in out Atomic_Counter_Type; Value : Cpu_Register_Type)
    return Cpu_Register_Type
    with SPARK_Mode => Off;

   function Atomic_Fetch_Sub (Atomic_Counter : in out Atomic_Counter_Type; Value : Cpu_Register_Type)
    return Cpu_Register_Type
    with SPARK_Mode => Off;

   function Atomic_Fetch_Or (Atomic_Counter : in out Atomic_Counter_Type; Value : Cpu_Register_Type)
    return Cpu_Register_Type
    with SPARK_Mode => Off;

   function Atomic_Fetch_And (Atomic_Counter : in out Atomic_Counter_Type; Value : Cpu_Register_Type)
    return Cpu_Register_Type
    with SPARK_Mode => Off;

   function Atomic_Load (Atomic_Counter : Atomic_Counter_Type)
    return Cpu_Register_Type;

   procedure Atomic_Store (Atomic_Counter : out Atomic_Counter_Type; Value : Cpu_Register_Type);

   type Spinlock_Type is limited private;

   procedure Spinlock_Acquire (Spinlock : in out Spinlock_Type);

   procedure Spinlock_Release (Spinlock : in out Spinlock_Type);

private
   use HiRTOS_Cpu_Arch_Parameters;

   type Atomic_Counter_Type is limited record
      Counter : Cpu_Register_Type := 0 with Volatile_Full_Access;
   end record
     with Size => Cache_Line_Size_Bytes * System.Storage_Unit,
          Alignment => Cache_Line_Size_Bytes;

   function Atomic_Counter_Initializer (Value : Cpu_Register_Type) return Atomic_Counter_Type is
      ((Counter => Value));

   type Spinlock_Type is new Atomic_Counter_Type;

end HiRTOS_Cpu_Multi_Core_Interface;
