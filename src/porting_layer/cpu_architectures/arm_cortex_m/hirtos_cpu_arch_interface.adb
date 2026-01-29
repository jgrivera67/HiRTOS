--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target platform interface for ARMv7-M architecture
--

with System.Machine_Code;
with HiRTOS_Cpu_Arch_Interface_Private;
with HiRTOS_Platform_Parameters;
with Bit_Sized_Integer_Types;

package body HiRTOS_Cpu_Arch_Interface is
   use ASCII;
   use Interfaces;
   use HiRTOS_Cpu_Arch_Interface_Private;
   use type Bit_Sized_Integer_Types.Bit_Type;

   function Get_Cpu_Status_Register return Cpu_Register_Type is
      Reg_Value : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, xpsr",
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
                  Reg_Value - HiRTOS_Cpu_Arch_Parameters.Call_Instruction_Size_In_Bytes));
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
      Reg_Value : Unsigned_32;
   begin
      System.Machine_Code.Asm (
         "mrs %0, primask" & ASCII.LF,
         Outputs => Unsigned_32'Asm_Output ("=r", Reg_Value),
         Volatile => True);

      return (Reg_Value and 16#1#) /= 0;
   end Cpu_Interrupting_Disabled;

   function Disable_Cpu_Interrupting return Cpu_Register_Type is
      Reg_Value : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, primask" & ASCII.LF &
         "cpsid i" & ASCII.LF &
         "isb" & ASCII.LF,
         Outputs => Cpu_Register_Type'Asm_Output ("=r", Reg_Value),
         Volatile => True);

      return Reg_Value;
   end Disable_Cpu_Interrupting;

   procedure Restore_Cpu_Interrupting (Old_Cpu_Interrupting : Cpu_Register_Type) is
   begin
      if (Old_Cpu_Interrupting and 16#1#) = 0 then
         Enable_Cpu_Interrupting;
      end if;
   end Restore_Cpu_Interrupting;

   procedure Enable_Cpu_Interrupting is
   begin
      System.Machine_Code.Asm (
         "isb" & ASCII.LF &
         "cpsie i" & ASCII.LF,
         Volatile => True);
   end Enable_Cpu_Interrupting;

   function Cpu_In_Privileged_Mode return Boolean is
   begin
      return Get_IPSR_Register > 0 or else Get_CONTROL_Register.nPRIV = 0;
   end Cpu_In_Privileged_Mode;

   function Cpu_In_Hypervisor_Mode return Boolean is
      (False);

   procedure Break_Point is
   begin
      System.Machine_Code.Asm ("bkpt #0", Volatile => True);
   end Break_Point;

   function Ldrex_Word (Word_Address : System.Address) return Cpu_Register_Type is
   begin
      --  if Cortex M0+
      declare
         Word : Cpu_Register_Type with Address => Word_Address;
      begin
         return Word;
      end;
      --  else
      --  System.Machine_Code.Asm (
      --      "ldrex %0, [%1]",
      --       Outputs => Cpu_Register_Type'Asm_Output ("=r", Result), --  %0
      --       Inputs => System.Address'Asm_Input ("r", Word_Address), --  %1
      --       Volatile => True);
      --
      --  return Result;
   end Ldrex_Word;

   function Strex_Word (Word_Address : System.Address;
                        Value : Cpu_Register_Type) return Boolean
   is
   begin
      --  if Cortex M0+
      declare
         Word : Cpu_Register_Type with Address => Word_Address;
      begin
         Word := Value;
      end;

      return True;
      --  else
      --  System.Machine_Code.Asm ("strex %0, %1, [%2]",
      --       Outputs =>
      --          --  NOTE: Use "=&r" to ensure a different register is used
      --          Cpu_Register_Type'Asm_Output ("=&r", Result),   -- %0
      --       Inputs =>
      --          [Cpu_Register_Type'Asm_Input ("r", Value),      -- %1
      --           System.Address'Asm_Input ("r", Word_Address)], -- %2
      --       Clobber => "memory",
      --       Volatile => True);
      --
      --  return Result = 0;
   end Strex_Word;

   function Ldrex_Byte (Byte_Address : System.Address) return Interfaces.Unsigned_8 is
   begin
      --  if Cortex M0+
      declare
         Byte : Interfaces.Unsigned_8 with Address => Byte_Address;
      begin
         return Byte;
      end;
      --  else
      --  System.Machine_Code.Asm (
      --      "ldrexb %0, [%1]",
      --       Outputs => Cpu_Register_Type'Asm_Output ("=r", Result), --  %0
      --       Inputs => System.Address'Asm_Input ("r", Byte_Address), --  %1
      --       Volatile => True);
      --
      --  return Interfaces.Unsigned_8 (Result);
   end Ldrex_Byte;

   function Strex_Byte (Byte_Address : System.Address;
                        Value : Interfaces.Unsigned_8) return Boolean
   is
   begin
      --  if Cortex M0+
      declare
         Byte : Interfaces.Unsigned_8 with Address => Byte_Address;
      begin
         Byte := Value;
      end;

      return True;
      --  else
      --  System.Machine_Code.Asm (
      --     "strexb %0, %1, [%2]",
      --     Outputs =>
      --        --  NOTE: Use "=&r" to ensure a different register is used
      --        Cpu_Register_Type'Asm_Output ("=&r", Result),   -- %0
      --     Inputs =>
      --        [Interfaces.Unsigned_8'Asm_Input ("r", Value),  -- %1
      --         System.Address'Asm_Input ("r", Byte_Address)], -- %2
      --     Clobber => "memory",
      --     Volatile => True);
      --
      --  return Result = 0;
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

   procedure Strong_Memory_Barrier is
   begin
      System.Machine_Code.Asm (
         "dsb 0xF"  & LF &
         "isb 0xF",
         Clobber => "memory",
         Volatile => True);
   end Strong_Memory_Barrier;

   function Count_Leading_Zeros (Value : Cpu_Register_Type) return Cpu_Register_Type is
      Remaining_Value : Interfaces.Unsigned_32 := Interfaces.Unsigned_32 (Value);
      Result : Cpu_Register_Type := 0;
   begin
      if HiRTOS_Platform_Parameters.CLZ_Instruction_Supported then
         System.Machine_Code.Asm (
             "clz %0, %1",
              Outputs => Cpu_Register_Type'Asm_Output ("=r", Result), --  %0
              Inputs => Cpu_Register_Type'Asm_Input ("r", Value),     --  %1
              Volatile => True);
      else
         --  Emulate the behavior of CLZ. The algorithm used here was taken from
         --  section 7.2.2 of the ARM System Developer's Guide book.

         if Remaining_Value < 2**16 then
            Remaining_Value := Interfaces.Shift_Left (Remaining_Value, 16);
            Result := @ + 16;
         end if;

         if Remaining_Value < 2**24 then
            Remaining_Value := Interfaces.Shift_Left (Remaining_Value, 8);
            Result := @ + 8;
         end if;

         if Remaining_Value < 2**28 then
            Remaining_Value := Interfaces.Shift_Left (Remaining_Value, 4);
            Result := @ + 4;
         end if;

         if Remaining_Value < 2**30 then
            Remaining_Value := Interfaces.Shift_Left (Remaining_Value, 2);
            Result := @ + 2;
         end if;

         if Remaining_Value < 2**31 then
            Remaining_Value := Interfaces.Shift_Left (Remaining_Value, 1);
            Result := @ + 1;
            if Remaining_Value = 0 then
               Result := 32;
            end if;
         end if;
      end if;

      return Result;
   end Count_Leading_Zeros;

   function Count_Trailing_Zeros (Value : Cpu_Register_Type) return Cpu_Register_Type is
      Result : Cpu_Register_Type := 0;
   begin
      --  if cortex-m0+
      for Bit_Index in 0 .. HiRTOS_Cpu_Arch_Parameters.Machine_Word_Width_In_Bits - 1 loop
         declare
            Bit_Mask : constant Cpu_Register_Type := Cpu_Register_Type (
               Interfaces.Shift_Left (Interfaces.Unsigned_32 (1), Bit_Index));
         begin
            exit when (Value and Bit_Mask) /= 0;
            Result := @ + 1;
         end;
      end loop;
      --  else
      --  System.Machine_Code.Asm (
      --      "ctz %0, %1",
      --       Outputs => Cpu_Register_Type'Asm_Output ("=r", Result), --  %0
      --       Inputs => Cpu_Register_Type'Asm_Input ("r", Value),     --  %1
      --       Volatile => True);
      return Result;
   end Count_Trailing_Zeros;

   procedure Enable_Caches is
   begin
      Memory_Barrier;
      Invalidate_Data_Cache;
      Invalidate_Instruction_Cache;
      --  TODO: Enable i-cache and d-cache
      Strong_Memory_Barrier;
   end Enable_Caches;

   procedure Disable_Caches is
   begin
      Strong_Memory_Barrier;
      --  TODO: Disable i-cache and d-cache
      Strong_Memory_Barrier;
   end Disable_Caches;

   procedure Invalidate_Data_Cache is
   begin
      Strong_Memory_Barrier;
      --  TODO: invalidate d-cache
      Strong_Memory_Barrier;
   end Invalidate_Data_Cache;

   procedure Invalidate_Instruction_Cache is
   begin
      Strong_Memory_Barrier;
      --  TODO: invalidate i-cache
      Strong_Memory_Barrier;
   end Invalidate_Instruction_Cache;

   procedure Invalidate_Data_Cache_Line (Cache_Line_Address : System.Address) is
   begin
      null; --  TODO
   end Invalidate_Data_Cache_Line;

   procedure Flush_Data_Cache_Line (Cache_Line_Address : System.Address) is
   begin
      null; --  TODO
   end Flush_Data_Cache_Line;

   procedure Flush_Invalidate_Data_Cache_Line (Cache_Line_Address : System.Address) is
   begin
      null; --???
   end Flush_Invalidate_Data_Cache_Line;

   procedure Hypercall (Op_Code : Interfaces.Unsigned_8) is
   begin
      null; --???
   end Hypercall;

end HiRTOS_Cpu_Arch_Interface;
