--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary HiRTOS to target platform interface for ARMv8-R architecture
--

with System.Machine_Code;
with System.Storage_Elements;

package body HiRTOS_Cpu_Arch_Interface is
   use ASCII;

   --
   --   Bit masks for CPSR bit fields
   --
   --  CPSR_F_Bit_Mask : constant := 2#0100_0000#; --  bit 6
   CPSR_I_Bit_Mask : constant Cpu_Register_Type := 2#1000_0000#; --  bit 7
   CPSR_Mode_Mask : constant Cpu_Register_Type :=  2#0001_1111#; --  bits [4:0]

   function Get_Cpu_Status_Register return Cpu_Register_Type is
      Reg_Value : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, cpsr",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", Reg_Value),
         Volatile => True);

      return Reg_Value;
   end Get_Cpu_Status_Register;

   function Get_Call_Address return System.Address is
      Reg_Value : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "mov %0, lr",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", Reg_Value),
         Volatile => True);

      return System.Storage_Elements.To_Address (
               System.Storage_Elements.Integer_Address (
                  Reg_Value - HiRTOS_Cpu_Arch_Parameters.Call_Instruction_Size));
   end Get_Call_Address;

   function Get_Stack_Pointer return Cpu_Register_Type is
      Stack_Pointer : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "mov %0, sp",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", Stack_Pointer),
         Volatile => True);

      return Stack_Pointer;
   end Get_Stack_Pointer;

   procedure Set_Stack_Pointer (Stack_Pointer : Cpu_Register_Type) is
   begin
      System.Machine_Code.Asm (
         "mov sp, %0",
         Inputs => Cpu_Register_Type'Asm_Input ("r", Stack_Pointer),
         Volatile => True);
   end Set_Stack_Pointer;

   function Cpu_Interrupting_Disabled return Boolean is
      CPSR_Value : constant Cpu_Register_Type := Get_Cpu_Status_Register;
   begin
      return (CPSR_Value and CPSR_I_Bit_Mask) /= 0;
   end Cpu_Interrupting_Disabled;

   function Disable_Cpu_Interrupting return Cpu_Register_Type
   is
      CPSR_Value : constant Cpu_Register_Type := Get_Cpu_Status_Register;
   begin
      if (CPSR_Value and CPSR_I_Bit_Mask) = 0 then
         System.Machine_Code.Asm (
            "cpsid i" & LF &
            "dsb" & LF &
            "isb",
            Clobber => "memory",
            Volatile => True);
      end if;

      pragma Assert (Cpu_Interrupting_Disabled);
      return CPSR_Value;
   end Disable_Cpu_Interrupting;

   procedure Restore_Cpu_Interrupting (Old_Cpu_Interrupting : Cpu_Register_Type) is
   begin
      if (Old_Cpu_Interrupting and CPSR_I_Bit_Mask) = 0 then
         System.Machine_Code.Asm (
            "dsb" & LF &
            "isb" & LF &
            "cpsie if",
            Clobber => "memory",
            Volatile => True);
      end if;
   end Restore_Cpu_Interrupting;

   procedure Enable_Cpu_Interrupting is
   begin
      System.Machine_Code.Asm (
         "dsb" & LF &
         "isb" & LF &
         "cpsie if",
         Clobber => "memory",
         Volatile => True);

      pragma Assert (not Cpu_Interrupting_Disabled);
   end Enable_Cpu_Interrupting;

   function Cpu_In_Privileged_Mode return Boolean is
      CPSR_Value : constant Cpu_Register_Type := Get_Cpu_Status_Register;
   begin
      return (CPSR_Value and CPSR_Mode_Mask) /= CPSR_User_Mode;
   end Cpu_In_Privileged_Mode;

   --
   --  Transitions the CPU from user-mode to sys-mode with interrupts
   --  enabled.
   --
   procedure Switch_Cpu_To_Privileged_Mode is
      CPSR_Value : constant Cpu_Register_Type := Get_Cpu_Status_Register;
   begin
         --
         --  We are not in privileged mode, so interrupts must be enabled:
         --
         --  NOTE: It is a bug to be in non-privileged mode with interrupts disabled.
         --
         pragma Assert ((CPSR_Value and CPSR_I_Bit_Mask) = 0);

         --
         --  Switch to privileged mode:
         --
         --  NOTE: The SVC exception handler sets `Cpu_Privileged_Nesting_Counter` to 1
         --
         System.Machine_Code.Asm (
            "mov r0, #1" & LF &
            "svc #0",
            Clobber => "r0",
            Volatile => True);

         --
         --  NOTE: We returned here in privileged mode.
         --
   end Switch_Cpu_To_Privileged_Mode;

   --
   --  Transitions the CPU from sys-mode to user-mode with interrupts enabled.
   --
   procedure Switch_Cpu_To_Unprivileged_Mode
   is
   begin
      --  Switch to unprivileged mode:
      System.Machine_Code.Asm (
         "cpsie i, %0" & LF &
         "isb",
         Inputs => Interfaces.Unsigned_8'Asm_Input ("g", CPSR_User_Mode), --  %0
         Volatile => True);
   end Switch_Cpu_To_Unprivileged_Mode;

   function Ldrex_Word (Word_Address : System.Address) return Cpu_Register_Type is
      Result : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
          "ldrex %0, [%1]",
           Outputs => Cpu_Register_Type'Asm_Output ("=r", Result), --  %0
           Inputs => System.Address'Asm_Input ("r", Word_Address), --  %1
           Volatile => True);

      return Result;
   end Ldrex_Word;

   function Strex_Word (Word_Address : System.Address;
                        Value : Cpu_Register_Type) return Boolean
   is
      Result : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm ("strex %0, %1, [%2]",
           Outputs =>
              --  NOTE: Use "=&r" to ensure a different register is used
              Cpu_Register_Type'Asm_Output ("=&r", Result),   -- %0
           Inputs =>
              [Cpu_Register_Type'Asm_Input ("r", Value),      -- %1
               System.Address'Asm_Input ("r", Word_Address)], -- %2
           Clobber => "memory",
           Volatile => True);

      return Result = 0;
   end Strex_Word;

   function Ldrex_Byte (Byte_Address : System.Address) return Interfaces.Unsigned_8 is
      Result : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
          "ldrexb %0, [%1]",
           Outputs => Cpu_Register_Type'Asm_Output ("=r", Result), --  %0
           Inputs => System.Address'Asm_Input ("r", Byte_Address), --  %1
           Volatile => True);

      return Interfaces.Unsigned_8 (Result);
   end Ldrex_Byte;

   function Strex_Byte (Byte_Address : System.Address;
                        Value : Interfaces.Unsigned_8) return Boolean
   is
      Result : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "strexb %0, %1, [%2]",
         Outputs =>
            --  NOTE: Use "=&r" to ensure a different register is used
            Cpu_Register_Type'Asm_Output ("=&r", Result),   -- %0
         Inputs =>
            [Interfaces.Unsigned_8'Asm_Input ("r", Value),  -- %1
             System.Address'Asm_Input ("r", Byte_Address)], -- %2
         Clobber => "memory",
         Volatile => True);

      return Result = 0;
   end Strex_Byte;

   procedure Wait_For_Interrupt is
   begin
      System.Machine_Code.Asm ("wfi", Volatile => True);
   end Wait_For_Interrupt;

   procedure Wait_For_Multicore_Event is
   begin
      System.Machine_Code.Asm ("wfe", Volatile => True);
   end Wait_For_Multicore_Event;

   procedure Send_Multicore_Event is
   begin
      System.Machine_Code.Asm ("sev", Volatile => True);
   end Send_Multicore_Event;

   procedure Memory_Barrier is
   begin
      System.Machine_Code.Asm ("dmb 0xF",
         Clobber => "memory",
         Volatile => True);
   end Memory_Barrier;

   function Atomic_Test_Set
     (Flag_Address : System.Address) return Boolean
   is
      Old_Value : Cpu_Register_Type;
   begin
      loop
         Old_Value := Ldrex_Word (Flag_Address);
         exit when Old_Value = 1;
         exit when Strex_Word (Flag_Address, 1);
      end loop;

      return Old_Value = 1;
   end Atomic_Test_Set;

   function Atomic_Fetch_Add
     (Atomic_Var : in out Interfaces.Unsigned_8;
      Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_8
   is
      use type Interfaces.Unsigned_8;
      Old_Value : Interfaces.Unsigned_8;
   begin
      loop
         Old_Value := Ldrex_Byte (Atomic_Var'Address);
         exit when Strex_Byte (Atomic_Var'Address, Old_Value + Value);
      end loop;

      return Old_Value;
   end Atomic_Fetch_Add;

   function Atomic_Fetch_Sub
     (Counter_Address : System.Address;
      Value : Cpu_Register_Type) return Cpu_Register_Type
   is
      Old_Value : Cpu_Register_Type;
   begin
      loop
         Old_Value := Ldrex_Word (Counter_Address);
         exit when Strex_Word (Counter_Address, Old_Value - Value);
      end loop;

      return Old_Value;
   end Atomic_Fetch_Sub;

   function Atomic_Fetch_Or
     (Counter_Address : System.Address;
      Value : Cpu_Register_Type) return Cpu_Register_Type
   is
      Old_Value : Cpu_Register_Type;
   begin
      loop
         Old_Value := Ldrex_Word (Counter_Address);
         exit when Strex_Word (Counter_Address, Old_Value or Value);
      end loop;

      return Old_Value;
   end Atomic_Fetch_Or;

   function Count_Leading_Zeros (Value : Cpu_Register_Type) return Cpu_Register_Type is
      Result : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
          "clz %0, %1",
           Outputs => Cpu_Register_Type'Asm_Output ("=r", Result), --  %0
           Inputs => Cpu_Register_Type'Asm_Input ("r", Value),     --  %1
           Volatile => True);

      return Result;
   end Count_Leading_Zeros;

   function Count_Trailing_Zeros (Value : Cpu_Register_Type) return Cpu_Register_Type is
      Result : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
          "ctz %0, %1",
           Outputs => Cpu_Register_Type'Asm_Output ("=r", Result), --  %0
           Inputs => Cpu_Register_Type'Asm_Input ("r", Value),     --  %1
           Volatile => True);

      return Result;
   end Count_Trailing_Zeros;

end HiRTOS_Cpu_Arch_Interface;
