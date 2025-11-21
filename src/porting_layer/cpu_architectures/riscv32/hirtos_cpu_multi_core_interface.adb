--
--  Copyright (c) 2024, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS multi-core CPU interface for RISCV architecture
--

with System.Machine_Code;
with Memory_Utils;

package body HiRTOS_Cpu_Multi_Core_Interface is

   type Atomic_Operator_Type is (Test_Set,
                                 Fetch_Add,
                                 Fetch_Sub,
                                 Fetch_Or,
                                 Fetch_And);

   function Get_Cpu_Id return Valid_Cpu_Core_Id_Type is
      Reg_Value : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "csrr  %0, mhartid",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", Reg_Value),
         Volatile => True);
      return Valid_Cpu_Core_Id_Type (Reg_Value);
   end Get_Cpu_Id;

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
         Memory_Utils.Invalidate_Data_Cache_Range (Atomic_Counter'Address, Cache_Line_Size_Bytes);
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
      --  NOTE: Invalidate cache line to support multi-core processors without cache coherence
      Memory_Utils.Invalidate_Data_Cache_Range (Atomic_Counter'Address, Cache_Line_Size_Bytes);
      return Atomic_Counter.Counter;
   end Atomic_Load;

   procedure Atomic_Store (Atomic_Counter : out Atomic_Counter_Type; Value : Cpu_Register_Type)
   is
   begin
      Atomic_Counter.Counter := Value;

      --  NOTE: Flush cache line to support multi-core processors without cache coherence
      Memory_Utils.Flush_Data_Cache_Range (Atomic_Counter'Address, Cache_Line_Size_Bytes);
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

   procedure Start_Secondary_Cpus is
   begin
      --  for Cpu_Id in Secondary_Cpu_Core_Id_Type loop
      --     Board.Start_Secondary_Cpu (Cpu_Id, Reset_Handler_Address);
      --  end loop;
      null;
   end Start_Secondary_Cpus;
end HiRTOS_Cpu_Multi_Core_Interface;
