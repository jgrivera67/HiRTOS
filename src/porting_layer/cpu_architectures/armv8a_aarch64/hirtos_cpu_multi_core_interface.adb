--
--  Copyright (c) 2022-2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS multi-core CPU interface for ARMv8-A architecture
--

with System.Machine_Code;
with Memory_Utils;
with Bit_Sized_Integer_Types;
with Board;

package body HiRTOS_Cpu_Multi_Core_Interface is
   use Bit_Sized_Integer_Types;

   type MPIDR_EL1_Type (As_Value : Boolean := True)  is record
      case As_Value is
         when True =>
            Value : Interfaces.Unsigned_64 := 0;
         when False =>
            Aff0 : Interfaces.Unsigned_8 := 0;  --  CPU ID if MT is 0
            Aff1 : Interfaces.Unsigned_8 := 0;  --  CPU ID if MT is 1
            Aff2 : Interfaces.Unsigned_8 := 0;  --  Affinity level 2 Cluster Id
            MT   : Bit_Type := 0;               --  0: Aff0 is CPU ID, 1: Aff1 is CPU ID
            U    : Bit_Type := 0;               --  Uniprocessor
            Res1 : Bit_Type := 1;               --  Reserved field set to 1
            Aff3 : Interfaces.Unsigned_8 := 0;  --  Affinity level 3 Cluster Id
      end case;
   end record
   with Size => 64,
        Bit_Order => System.Low_Order_First,
        Unchecked_Union;

   for MPIDR_EL1_Type use record
      Value at 0 range 0 .. 63;
      Aff0  at 0 range 0 .. 7;
      Aff1  at 0 range 8 .. 15;
      Aff2  at 0 range 16 .. 23;
      MT    at 0 range 24 .. 24;
      U     at 0 range 30 .. 30;
      Res1  at 0 range 31 .. 31;
      Aff3  at 0 range 32 .. 39;
   end record;

   type Cpu_Model_Type is (
      Cortex_A72, --  Raspberry PI 4
      Cortex_A76  --  Raspberry PI 5
   );

   function Cpu_Id_To_MPIDR (Cpu_Id : Valid_Cpu_Core_Id_Type;
                             Cpu_Model : Cpu_Model_Type)
      return MPIDR_EL1_Type is
      (case Cpu_Model is
         when Cortex_A72 =>
            (As_Value => False,
             Aff0 => Interfaces.Unsigned_8 (Cpu_Id),
             others => <>),
         when Cortex_A76 =>
            (As_Value => False,
             Aff1 => Interfaces.Unsigned_8 (Cpu_Id),
             MT => 1,
             others => <>));

   type Atomic_Operator_Type is (Test_Set,
                                 Fetch_Add,
                                 Fetch_Sub,
                                 Fetch_Or,
                                 Fetch_And);

   function Get_Cpu_Id return Valid_Cpu_Core_Id_Type is
      MPIDR_EL1_Value : MPIDR_EL1_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, mpidr_el1",
         Outputs => Interfaces.Unsigned_64'Asm_Output ("=r", MPIDR_EL1_Value.Value), --  %0
         Volatile => True);

      return Valid_Cpu_Core_Id_Type (
         (if MPIDR_EL1_Value.MT = 1 then MPIDR_EL1_Value.Aff1
                                    else MPIDR_EL1_Value.Aff0));
   end Get_Cpu_Id;

   procedure Start_Secondary_Cpus is
      procedure Reset_Handler with
         Import,
         Convention => C,
         External_Name => "reset_handler",
         No_Return;

      Reset_Handler_Address : constant System.Address := Reset_Handler'Address;
   begin
      for Cpu_Id in Secondary_Cpu_Core_Id_Type loop
         Board.Start_Secondary_Cpu (Cpu_Id, Reset_Handler_Address);
      end loop;
   end Start_Secondary_Cpus;

   function Atomic_Operation (Atomic_Operator : Atomic_Operator_Type;
                              Atomic_Counter : in out Atomic_Counter_Type;
                              Value : Cpu_Register_Type)
    return Cpu_Register_Type
    with Inline_Always
   is
      Old_Value : Cpu_Register_Type;
      New_Value : Cpu_Register_Type;
   begin
      loop
         --  NOTE: Invalidate cache line to support multi-core processors without cache coherence
         --  Memory_Utils.Invalidate_Data_Cache_Range (Atomic_Counter'Address, Cache_Line_Size_Bytes);
         Old_Value := Ldaex_Agnostic_Word (Atomic_Counter.Counter'Address);
         case Atomic_Operator is
            when Test_Set =>
               if Old_Value = Value then
                  return Old_Value;
               end if;

               New_Value := Value;
            when Fetch_Add =>
               New_Value := Old_Value + Value;
            when Fetch_Sub =>
               New_Value := Old_Value - Value;
            when Fetch_Or =>
               New_Value := Old_Value or Value;
            when Fetch_And =>
               New_Value := Old_Value and Value;
         end case;

         exit when Stlex_Agnostic_Word (Atomic_Counter.Counter'Address, New_Value);
      end loop;

      --  NOTE: Flush cache line to support multi-core processors without cache coherence
      Memory_Utils.Flush_Data_Cache_Range (Atomic_Counter'Address, Cache_Line_Size_Bytes);
      return Old_Value;
   end Atomic_Operation;

   procedure Atomic_Counter_Initialize (Atomic_Counter_Obj : out Atomic_Counter_Type;
                                        Value : Cpu_Register_Type) is
   begin
      Atomic_Counter_Obj.Counter := Value;
   end Atomic_Counter_Initialize;

   function Atomic_Test_Set (Atomic_Counter : in out Atomic_Counter_Type; Value : Cpu_Register_Type)
    return Cpu_Register_Type is
      (Atomic_Operation (Test_Set, Atomic_Counter, Value));

   function Atomic_Fetch_Add (Atomic_Counter : in out Atomic_Counter_Type; Value : Cpu_Register_Type)
    return Cpu_Register_Type is
      (Atomic_Operation (Fetch_Add, Atomic_Counter, Value));

   function Atomic_Fetch_Sub (Atomic_Counter : in out Atomic_Counter_Type; Value : Cpu_Register_Type)
    return Cpu_Register_Type is
      (Atomic_Operation (Fetch_Sub, Atomic_Counter, Value));

   function Atomic_Fetch_Or (Atomic_Counter : in out Atomic_Counter_Type; Value : Cpu_Register_Type)
    return Cpu_Register_Type is
      (Atomic_Operation (Fetch_Or, Atomic_Counter, Value));

   function Atomic_Fetch_And (Atomic_Counter : in out Atomic_Counter_Type; Value : Cpu_Register_Type)
    return Cpu_Register_Type is
      (Atomic_Operation (Fetch_And, Atomic_Counter, Value));

   function Atomic_Load (Atomic_Counter : Atomic_Counter_Type)
    return Cpu_Register_Type
   is
   begin
      return Atomic_Counter.Counter;
   end Atomic_Load;

   procedure Atomic_Store (Atomic_Counter : out Atomic_Counter_Type; Value : Cpu_Register_Type)
   is
   begin
      Atomic_Counter.Counter := Value;
   end Atomic_Store;

   procedure Spinlock_Acquire (Spinlock : in out Spinlock_Type) is
      Cpu_Id : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      Old_Cpu_Interrupting : constant Cpu_Register_Type :=
         HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
   begin
      if Spinlock_Owner (Spinlock) = Cpu_Id then
         Spinlock.Recursive_Acquire_Count := @ + 1;

         --
         --  NOTE: We don't need to restore the CPU interrupting state, as
         --  the saved CPU interrupting state also has interrupts disabled,
         --  when recursively acquiring a spinlock.
         --
         return;
      end if;

      declare
         My_Ticket : constant Cpu_Register_Type := Atomic_Fetch_Add (Spinlock.Next_Ticket, 1);
      begin
         while Spinlock.Now_Serving /= My_Ticket loop
            Wait_For_Multicore_Event;
         end loop;

         pragma Assert (Spinlock.Owner = Invalid_Cpu_Core_Id);
         Spinlock.Owner := Cpu_Id;
         Spinlock.Old_Cpu_Interrupting := Old_Cpu_Interrupting;
         Memory_Barrier;
      end;
   end Spinlock_Acquire;

   procedure Spinlock_Release (Spinlock : in out Spinlock_Type) is
   begin
      if Spinlock.Recursive_Acquire_Count > 0 then
         Spinlock.Recursive_Acquire_Count := @ - 1;
         return;
      end if;

      Memory_Barrier;
      Spinlock.Owner := Invalid_Cpu_Core_Id;
      Spinlock.Now_Serving := @ + 1;
      Send_Multicore_Event;
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Spinlock.Old_Cpu_Interrupting);
   end Spinlock_Release;

end HiRTOS_Cpu_Multi_Core_Interface;
