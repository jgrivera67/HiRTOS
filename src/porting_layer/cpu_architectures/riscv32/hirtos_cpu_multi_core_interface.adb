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
         Old_Value := Ldrex_Word (Atomic_Counter.Counter'Address);
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

         exit when Strex_Word (Atomic_Counter.Counter'Address, New_Value);
      end loop;

      --  NOTE: Flush cache line to support multi-core processors without cache coherence
      Memory_Utils.Flush_Data_Cache_Range (Atomic_Counter'Address, Cache_Line_Size_Bytes);
      return Old_Value;
   end Atomic_Operation;

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
   begin
      while Atomic_Test_Set (Atomic_Counter_Type (Spinlock), 1) = 1 loop
         HiRTOS_Cpu_Arch_Interface.Wait_For_Multicore_Event;
      end loop;

      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
   end Spinlock_Acquire;

   procedure Spinlock_Release (Spinlock : in out Spinlock_Type) is
   begin
      Atomic_Store (Atomic_Counter_Type (Spinlock), 0);
      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
      HiRTOS_Cpu_Arch_Interface.Send_Multicore_Event;
   end Spinlock_Release;

end HiRTOS_Cpu_Multi_Core_Interface;
