--
--  Copyright (c) 2024, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target platform interface for ARMv8-R architecture
--

with System.Machine_Code;
with HiRTOS_Cpu_Arch_Interface_Private;
with HiRTOS_Cpu_Arch_Interface.Thread_Context;
with Bit_Sized_Integer_Types;

package body HiRTOS_Cpu_Arch_Interface is
   use ASCII;
   use HiRTOS_Cpu_Arch_Interface_Private;
   use HiRTOS_Cpu_Arch_Interface.Thread_Context;
   use type Bit_Sized_Integer_Types.Bit_Type;

   function Get_Cpu_Status_Register return Cpu_Register_Type is
      (Cpu_Register_Type (Get_MSTATUS.Value));

   function Get_Call_Address return System.Address is
      Reg_Value : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "mv %0, ra",
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
         "mv %0, sp",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", Stack_Pointer),
         Volatile => True);

      return Stack_Pointer;
   end Get_Stack_Pointer;

   procedure Set_Stack_Pointer (Stack_Pointer : Cpu_Register_Type) is
   begin
      System.Machine_Code.Asm (
         "mv sp, %0",
         Inputs => Cpu_Register_Type'Asm_Input ("r", Stack_Pointer),
         Volatile => True);
   end Set_Stack_Pointer;

   function Cpu_Interrupting_Disabled return Boolean is
      MSTATUS_Value : MSTATUS_Type;
   begin
      --
      --  NOTE: MSTATUS cannot be accessed from U-mode:
      --
      if not Cpu_In_Privileged_Mode then
         return False;
      end if;

      MSTATUS_Value := Get_MSTATUS;
      return MSTATUS_Value.MIE = 0;
   end Cpu_Interrupting_Disabled;

   function Disable_Cpu_Interrupting return Cpu_Register_Type
   is
      Old_MSTATUS_Value : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "csrrci %0, mstatus, %1",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", Old_MSTATUS_Value), --  %0
         Inputs => Cpu_Register_Type'Asm_Input ("g",
                                                MSTATUS_UIE_Bit_Mask or MSTATUS_MIE_Bit_Mask), --  %1
         Volatile => True);
      Memory_Barrier;
      return Old_MSTATUS_Value and (MSTATUS_UIE_Bit_Mask or MSTATUS_MIE_Bit_Mask);
   end Disable_Cpu_Interrupting;

   procedure Restore_Cpu_Interrupting (Old_Cpu_Interrupting : Cpu_Register_Type) is
   begin
      Memory_Barrier;
      System.Machine_Code.Asm (
         "csrs mstatus, %0",
         Inputs => Cpu_Register_Type'Asm_Input ("r", Old_Cpu_Interrupting), --  %0
         Volatile => True);
   end Restore_Cpu_Interrupting;

   procedure Enable_Cpu_Interrupting is
   begin
      Memory_Barrier;
      System.Machine_Code.Asm (
         "csrsi mstatus, %0",
         Inputs => Cpu_Register_Type'Asm_Input ("g", MSTATUS_MIE_Bit_Mask), --  %0
         Volatile => True);
   end Enable_Cpu_Interrupting;

   function Cpu_In_Privileged_Mode return Boolean is
      (Get_Thread_Pointer.Cpu_Running_In_Privileged_Mode);

   function Cpu_In_Hypervisor_Mode return Boolean is
      (False);

   procedure Break_Point is
   begin
      System.Machine_Code.Asm (
         "ebreak",
         Volatile => True);
   end Break_Point;

   function Ldrex_Word (Word_Address : System.Address) return Cpu_Register_Type is
      MISA_Value : constant MISA_Type := Get_MISA;
   begin
      if MISA_Value.A = 1 then
         --
         --   NOTE: To enable the code below, need to compile with -march=rv32gc_zbb
         --
         --  declare
         --     Result : Cpu_Register_Type;
         --  begin
         --     System.Machine_Code.Asm (
         --        "lr.w %0, (%1)",
         --        Outputs => Cpu_Register_Type'Asm_Output ("=r", Result), --  %0
         --        Inputs => System.Address'Asm_Input ("r", Word_Address), --  %1
         --        Volatile => True);
         --     return Result;
         --  end;
         pragma Assert (False);
      else
         declare
            Word : Cpu_Register_Type with Address => Word_Address;
         begin
            return Word;
         end;
      end if;
   end Ldrex_Word;

   function Strex_Word (Word_Address : System.Address;
                        Value : Cpu_Register_Type) return Boolean
   is
      MISA_Value : constant MISA_Type := Get_MISA;
   begin
      if MISA_Value.A = 1 then
         --
         --   NOTE: To enable the code below, need to compile with -march=rv32gc_zbb
         --
         --  declare
         --     Result : Cpu_Register_Type;
         --  begin
         --     System.Machine_Code.Asm ("sc.w %0, %1, (%2)",
         --        Outputs =>
         --           --  NOTE: Use "=&r" to ensure a different register is used
         --           Cpu_Register_Type'Asm_Output ("=&r", Result),   -- %0
         --        Inputs =>
         --           [Cpu_Register_Type'Asm_Input ("r", Value),      -- %1
         --            System.Address'Asm_Input ("r", Word_Address)], -- %2
         --        Clobber => "memory",
         --        Volatile => True);
         --     return Result = 0;
         --  end;
         pragma Assert (False);
      else
         declare
            Word : Cpu_Register_Type with Address => Word_Address;
         begin
            Word := Value;
         end;

         return True;
      end if;
   end Strex_Word;

   function Ldrex_Byte (Byte_Address : System.Address) return Interfaces.Unsigned_8 is
      Result : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
          "lr.b %0, (%1)",
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
         "sc.b %0, %1, (%2)",
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
      System.Machine_Code.Asm (
         "fence" & LF &
         "wfi" & LF &
         "fence.i",
         Clobber => "memory",
         Volatile => True);
   end Wait_For_Interrupt;

   procedure Wait_For_Multicore_Event is
   begin
      null; --??? TODO: add replacement for wfe
   end Wait_For_Multicore_Event;

   procedure Send_Multicore_Event is
   begin
      null; --??? TODO: add replacement for sev
   end Send_Multicore_Event;

   procedure Memory_Barrier is
   begin
      System.Machine_Code.Asm ("fence",
         Clobber => "memory",
         Volatile => True);
   end Memory_Barrier;

   procedure Strong_Memory_Barrier is
   begin
      System.Machine_Code.Asm (
         "fence.i"  & LF &
         "fence",
         Clobber => "memory",
         Volatile => True);
   end Strong_Memory_Barrier;

   function Count_Leading_Zeros (Value : Cpu_Register_Type) return Cpu_Register_Type is
      Result : Cpu_Register_Type;
      MISA_Value : constant MISA_Type := Get_MISA;
   begin
      if MISA_Value.G = 1 then
         --
         --   NOTE: To enable the code below, need to compile with -march=rv32gc_zbb
         --
         --  System.Machine_Code.Asm (
         --     "clz %0, %1",
         --     Outputs => Cpu_Register_Type'Asm_Output ("=r", Result), --  %0
         --     Inputs => Cpu_Register_Type'Asm_Input ("r", Value),     --  %1
         --     Volatile => True);
         pragma Assert (False);
      else
         Result := 0;
         for Bit_Index in reverse 0 .. HiRTOS_Cpu_Arch_Parameters.Machine_Word_Width_In_Bits - 1 loop
            declare
               Bit_Mask : constant Cpu_Register_Type := Cpu_Register_Type (
                  Interfaces.Shift_Left (Interfaces.Unsigned_32 (1), Bit_Index));
            begin
               exit when (Value and Bit_Mask) /= 0;
               Result := @ + 1;
            end;
         end loop;
      end if;
      return Result;
   end Count_Leading_Zeros;

   function Count_Trailing_Zeros (Value : Cpu_Register_Type) return Cpu_Register_Type is
      Result : Cpu_Register_Type;
      MISA_Value : constant MISA_Type := Get_MISA;
   begin
      if MISA_Value.G = 1 then
         --
         --   NOTE: To enable the code below, need to compile with -march=rv32gc_zbb
         --
         --  System.Machine_Code.Asm (
         --     "ctz %0, %1",
         --     Outputs => Cpu_Register_Type'Asm_Output ("=r", Result), --  %0
         --     Inputs => Cpu_Register_Type'Asm_Input ("r", Value),     --  %1
         --     Volatile => True);
         pragma Assert (False);
      else
         Result := 0;
         for Bit_Index in 0 .. HiRTOS_Cpu_Arch_Parameters.Machine_Word_Width_In_Bits - 1 loop
            declare
               Bit_Mask : constant Cpu_Register_Type := Cpu_Register_Type (
                  Interfaces.Shift_Left (Interfaces.Unsigned_32 (1), Bit_Index));
            begin
               exit when (Value and Bit_Mask) /= 0;
               Result := @ + 1;
            end;
         end loop;
      end if;

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
