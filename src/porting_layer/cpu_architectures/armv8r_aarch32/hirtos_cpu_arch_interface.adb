--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target platform interface for ARMv8-R architecture
--

with HiRTOS_Cpu_Arch_Interface.System_Registers;
with System.Machine_Code;
with HiRTOS_Cpu_Arch_Interface_Private;

package body HiRTOS_Cpu_Arch_Interface is
   use ASCII;
   use HiRTOS_Cpu_Arch_Interface.System_Registers;
   use HiRTOS_Cpu_Arch_Interface_Private;

   --
   --   Bit masks for CPSR bit fields
   --
   CPSR_F_Bit_Mask : constant := 2#0100_0000#; --  bit 6
   CPSR_I_Bit_Mask : constant Cpu_Register_Type := 2#1000_0000#; --  bit 7
   CPSR_IF_Bit_Mask : constant Cpu_Register_Type := (CPSR_I_Bit_Mask or CPSR_F_Bit_Mask);
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
      CPSR_Value : constant Cpu_Register_Type := Get_Cpu_Status_Register;
   begin
      if Cpu_In_Hypervisor_Mode then
         return (CPSR_Value and CPSR_IF_Bit_Mask) = CPSR_IF_Bit_Mask;
      else
         return (CPSR_Value and CPSR_I_Bit_Mask) = CPSR_I_Bit_Mask;
      end if;
   end Cpu_Interrupting_Disabled;

   function Disable_Cpu_Interrupting return Cpu_Register_Type
   is
      CPSR_Value : constant Cpu_Register_Type := Get_Cpu_Status_Register;
   begin
      if Cpu_In_Hypervisor_Mode then
         if (CPSR_Value and CPSR_IF_Bit_Mask) /= CPSR_IF_Bit_Mask then
            System.Machine_Code.Asm (
               "cpsid if" & LF &
               "dsb" & LF &
               "isb",
               Clobber => "memory",
               Volatile => True);
         end if;
      else
         if (CPSR_Value and CPSR_I_Bit_Mask) /= CPSR_I_Bit_Mask then
            System.Machine_Code.Asm (
               "cpsid i" & LF &
               "dsb" & LF &
               "isb",
               Clobber => "memory",
               Volatile => True);
         end if;
      end if;

      pragma Assert (Cpu_Interrupting_Disabled);
      return CPSR_Value;
   end Disable_Cpu_Interrupting;

   procedure Restore_Cpu_Interrupting (Old_Cpu_Interrupting : Cpu_Register_Type) is
   begin
      if (Old_Cpu_Interrupting and CPSR_IF_Bit_Mask) = 0 then
         System.Machine_Code.Asm (
            "dsb" & LF &
            "isb" & LF &
            "cpsie if",
            Clobber => "memory",
            Volatile => True);
      elsif (Old_Cpu_Interrupting and CPSR_I_Bit_Mask) = 0 then
         System.Machine_Code.Asm (
            "dsb" & LF &
            "isb" & LF &
            "cpsie i",
            Clobber => "memory",
            Volatile => True);
      elsif (Old_Cpu_Interrupting and CPSR_F_Bit_Mask) = 0 then
         System.Machine_Code.Asm (
            "dsb" & LF &
            "isb" & LF &
            "cpsie f",
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

   function Cpu_In_Hypervisor_Mode return Boolean is
      CPSR_Value : constant Cpu_Register_Type := Get_Cpu_Status_Register;
   begin
      return (CPSR_Value and CPSR_Mode_Mask) = CPSR_Hypervisor_Mode;
   end Cpu_In_Hypervisor_Mode;

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

   procedure Strong_Memory_Barrier is
   begin
      System.Machine_Code.Asm (
         "dsb 0xF"  & LF &
         "isb 0xF",
         Clobber => "memory",
         Volatile => True);
   end Strong_Memory_Barrier;

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

   procedure Enable_Caches is
      SCTLR_Value : SCTLR_Type;
   begin
      Memory_Barrier;
      Invalidate_Data_Cache;
      Invalidate_Instruction_Cache;
      SCTLR_Value := Get_SCTLR;
      SCTLR_Value.C := Cacheable;
      SCTLR_Value.I := Instruction_Access_Cacheable; --  TODO: This too slow in ARM FVP simulator
      Set_SCTLR (SCTLR_Value);
      Strong_Memory_Barrier;
   end Enable_Caches;

   procedure Disable_Caches is
      SCTLR_Value : SCTLR_Type;
   begin
      Strong_Memory_Barrier;
      SCTLR_Value := Get_SCTLR;
      SCTLR_Value.C := Non_Cacheable;
      SCTLR_Value.I := Instruction_Access_Non_Cacheable;
      Set_SCTLR (SCTLR_Value);
      Strong_Memory_Barrier;
   end Disable_Caches;

   procedure Invalidate_Data_Cache is
   begin
      Strong_Memory_Barrier;
      HiRTOS_Cpu_Arch_Interface.System_Registers.Set_DCIM_ALL;
      Strong_Memory_Barrier;
   end Invalidate_Data_Cache;

   procedure Invalidate_Instruction_Cache is
   begin
      Strong_Memory_Barrier;
      HiRTOS_Cpu_Arch_Interface.System_Registers.Set_ICIALLU;
      Strong_Memory_Barrier;
   end Invalidate_Instruction_Cache;

   procedure Invalidate_Data_Cache_Line (Cache_Line_Address : System.Address) is
   begin
      HiRTOS_Cpu_Arch_Interface.System_Registers.Set_DCIMVAC (Cache_Line_Address);
   end Invalidate_Data_Cache_Line;

   procedure Flush_Data_Cache_Line (Cache_Line_Address : System.Address) is
   begin
      HiRTOS_Cpu_Arch_Interface.System_Registers.Set_DCCMVAC (Cache_Line_Address);
   end Flush_Data_Cache_Line;

   procedure Flush_Invalidate_Data_Cache_Line (Cache_Line_Address : System.Address) is
   begin
      HiRTOS_Cpu_Arch_Interface.System_Registers.Set_DCCIMVAC (Cache_Line_Address);
   end Flush_Invalidate_Data_Cache_Line;

   procedure Hypercall (Op_Code : Interfaces.Unsigned_8) is
   begin
      System.Machine_Code.Asm (
            "mov r0, %0" & LF &
            "hvc #0",
            Inputs => Interfaces.Unsigned_8'Asm_Input ("r", Op_Code), --  %0
            Clobber => "r0",
            Volatile => True);
   end Hypercall;

   procedure Break_Point is
   begin
      System.Machine_Code.Asm ("bkpt #0", Volatile => True);
   end Break_Point;

end HiRTOS_Cpu_Arch_Interface;
