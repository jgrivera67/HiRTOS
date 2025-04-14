--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target platform interface for ARMv8-A aarch64 architecture
--

with HiRTOS_Cpu_Arch_Interface.System_Registers;
with System.Machine_Code;
with HiRTOS_Cpu_Arch_Interface_Private;
with HiRTOS_Low_Level_Debug_Interface; --???

package body HiRTOS_Cpu_Arch_Interface is
   use ASCII;
   use HiRTOS_Cpu_Arch_Interface.System_Registers;
   use HiRTOS_Cpu_Arch_Interface_Private;

   function Get_Cpu_Status_Register return Cpu_Register_Type is
      (Get_PSTATE.Value);

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
      DAIF_Value : constant DAIF_Type := Get_DAIF;
   begin
      if Cpu_In_Hypervisor_Mode then
         return DAIF_Value.F = Interrupt_Disabled and then DAIF_Value.I = Interrupt_Disabled;
      else
         return DAIF_Value.I = Interrupt_Disabled;
      end if;
   end Cpu_Interrupting_Disabled;

   function Disable_Cpu_Interrupting return Cpu_Register_Type
   is
      DAIF_Value : constant DAIF_Type := Get_DAIF;
      PSTATE_Value : PSTATE_Type;
   begin
      if Cpu_In_Hypervisor_Mode then
         if DAIF_Value.F = Interrupt_Enabled or else DAIF_Value.I = Interrupt_Enabled then
            System.Machine_Code.Asm (
               "msr DAIFset, %0",
               Inputs => Interfaces.Unsigned_8'Asm_Input ("g", DAIF_SetClr_IF_Mask),  --  %0
               Volatile => True);
         end if;
      else
         if DAIF_Value.I = Interrupt_Enabled then
            System.Machine_Code.Asm (
               "msr DAIFset, %0",
               Inputs => Interfaces.Unsigned_8'Asm_Input ("g", DAIF_SetClr_I_Bit_Mask),  --  %0
               Volatile => True);
         end if;
      end if;

      Strong_Memory_Barrier;
      pragma Assert (Cpu_Interrupting_Disabled);
      PSTATE_Value.DAIF := DAIF_Value;
      return PSTATE_Value.Value;
   end Disable_Cpu_Interrupting;

   procedure Restore_Cpu_Interrupting (Old_Cpu_Interrupting : Cpu_Register_Type) is
      PSTATE_Value : constant PSTATE_Type := (As_Value => True, Value => Old_Cpu_Interrupting);
   begin
      Strong_Memory_Barrier;
      if PSTATE_Value.DAIF.I = Interrupt_Enabled and then PSTATE_Value.DAIF.F = Interrupt_Enabled then
         System.Machine_Code.Asm (
            "msr DAIFclr, %0",
            Inputs => Interfaces.Unsigned_8'Asm_Input ("g", DAIF_SetClr_IF_Mask),  --  %0
            Volatile => True);
      elsif PSTATE_Value.DAIF.I = Interrupt_Enabled then
         System.Machine_Code.Asm (
            "msr DAIFclr, %0",
            Inputs => Interfaces.Unsigned_8'Asm_Input ("g", DAIF_SetClr_I_Bit_Mask),  --  %0
            Volatile => True);
      elsif PSTATE_Value.DAIF.F = Interrupt_Enabled then
         System.Machine_Code.Asm (
            "msr DAIFclr, %0",
            Inputs => Interfaces.Unsigned_8'Asm_Input ("g", DAIF_SetClr_F_Bit_Mask),  --  %0
            Volatile => True);
      end if;
   end Restore_Cpu_Interrupting;

   procedure Enable_Cpu_Interrupting is
   begin
      System.Machine_Code.Asm (
         "dsb sy" & LF &
         "isb" & LF &
         "msr DAIFclr, %0",
         Inputs => Interfaces.Unsigned_8'Asm_Input ("g", DAIF_SetClr_IF_Mask),  --  %0
         Volatile => True);

      pragma Assert (not Cpu_Interrupting_Disabled);
   end Enable_Cpu_Interrupting;

   function Cpu_In_Privileged_Mode return Boolean is
      CurrentEL_Value : constant Exception_Level_Type := Get_CurrentEL;
   begin
      return CurrentEL_Value /= EL0;
   end Cpu_In_Privileged_Mode;

   function Cpu_In_Hypervisor_Mode return Boolean is
      CurrentEL_Value : constant Exception_Level_Type := Get_CurrentEL;
   begin
      return CurrentEL_Value = EL2;
   end Cpu_In_Hypervisor_Mode;

   function Ldaex_Agnostic_Word (Agnostic_Word_Address : System.Address) return Cpu_Register_Type is
      Result : Cpu_Register_Type;
   begin
      HiRTOS_Low_Level_Debug_Interface.Print_String("TODO: do ldaxr" & ASCII.LF); --???
      System.Machine_Code.Asm (
          --"ldaxr %0, [%1]",
          "ldr %0, [%1]", -- TODO: Remove this when when can use ldaxr
           Outputs => Cpu_Register_Type'Asm_Output ("=r", Result), --  %0
           Inputs => System.Address'Asm_Input ("r", Agnostic_Word_Address), --  %1
           Volatile => True);

      return Result;
   end Ldaex_Agnostic_Word;

   function Stlex_Agnostic_Word (Agnostic_Word_Address : System.Address;
                                 Value : Cpu_Register_Type) return Boolean
   is
      use type Interfaces.Unsigned_32;
      Result : Interfaces.Unsigned_32;
   begin
      HiRTOS_Low_Level_Debug_Interface.Print_String("TODO: do stlxr" & ASCII.LF); --???
      System.Machine_Code.Asm (
           --"stlxr w0, %1, [%2]" & LF &
           --"mov %0, x0",
           "str %1, [%2]" & LF &   -- TODO: Remove this when when can use stlxr
           "mov %0, #0",           -- TODO: Remove this when when can use stlxr
           Outputs =>
              --  NOTE: Use "=&r" to ensure a different register is used
              Interfaces.Unsigned_32'Asm_Output ("=&r", Result),   -- %0
           Inputs =>
              [Cpu_Register_Type'Asm_Input ("r", Value),      -- %1
               System.Address'Asm_Input ("r", Agnostic_Word_Address)], -- %2
           Clobber => "x0, memory",
           Volatile => True);

      return Result = 0;
   end Stlex_Agnostic_Word;

   function Ldaex_Byte (Byte_Address : System.Address) return Interfaces.Unsigned_8 is
      Result : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
          "ldaxrb %0, [%1]",
           Outputs => Cpu_Register_Type'Asm_Output ("=r", Result), --  %0
           Inputs => System.Address'Asm_Input ("r", Byte_Address), --  %1
           Volatile => True);

      return Interfaces.Unsigned_8 (Result);
   end Ldaex_Byte;

   function Stlex_Byte (Byte_Address : System.Address;
                        Value : Interfaces.Unsigned_8) return Boolean
   is
      use type Interfaces.Unsigned_32;
      Result : Interfaces.Unsigned_32;
   begin
      System.Machine_Code.Asm (
         "stlxrb %0, %1, [%2]",
         Outputs =>
            --  NOTE: Use "=&r" to ensure a different register is used
            Interfaces.Unsigned_32'Asm_Output ("=&r", Result),   -- %0
         Inputs =>
            [Interfaces.Unsigned_8'Asm_Input ("r", Value),  -- %1
             System.Address'Asm_Input ("r", Byte_Address)], -- %2
         Clobber => "memory",
         Volatile => True);

      return Result = 0;
   end Stlex_Byte;

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
      System.Machine_Code.Asm ("dmb sy",
         Clobber => "memory",
         Volatile => True);
   end Memory_Barrier;

   procedure Strong_Memory_Barrier is
   begin
      System.Machine_Code.Asm (
         "dsb sy"  & LF &
         "isb",
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
      SCTLR_Value : SCTLR_EL1_Type;
   begin
      Memory_Barrier;
      Invalidate_Data_Cache;
      Invalidate_Instruction_Cache;
      SCTLR_Value := Get_SCTLR_EL1;
      SCTLR_Value.C := Cacheable;
      SCTLR_Value.I := Instruction_Access_Cacheable;
      Set_SCTLR_EL1 (SCTLR_Value);
      Strong_Memory_Barrier;
   end Enable_Caches;

   procedure Disable_Caches is
      SCTLR_Value : SCTLR_EL1_Type;
   begin
      Strong_Memory_Barrier;
      SCTLR_Value := Get_SCTLR_EL1;
      SCTLR_Value.C := Non_Cacheable;
      SCTLR_Value.I := Instruction_Access_Non_Cacheable;
      Set_SCTLR_EL1 (SCTLR_Value);
      Strong_Memory_Barrier;
   end Disable_Caches;

   procedure Invalidate_Data_Cache is
   begin
      Strong_Memory_Barrier;
      System.Machine_Code.Asm (
         "dc zva, xzr",
         Clobber => "memory",
         Volatile => True);
      Strong_Memory_Barrier;
   end Invalidate_Data_Cache;

   procedure Invalidate_Instruction_Cache is
   begin
      Strong_Memory_Barrier;
      System.Machine_Code.Asm (
         "ic iallu",
         Clobber => "memory",
         Volatile => True);
      Strong_Memory_Barrier;
   end Invalidate_Instruction_Cache;

   procedure Invalidate_Data_Cache_Line (Cache_Line_Address : System.Address) is
   begin
      Strong_Memory_Barrier;
      System.Machine_Code.Asm (
         "dc ivac, %0",
         Inputs => System.Address'Asm_Input ("r", Cache_Line_Address), --  %0
         Clobber => "memory",
         Volatile => True);
      Strong_Memory_Barrier;
   end Invalidate_Data_Cache_Line;

   procedure Flush_Data_Cache_Line (Cache_Line_Address : System.Address) is
   begin
      Strong_Memory_Barrier;
      System.Machine_Code.Asm (
         "dc cvac, %0",
         Inputs => System.Address'Asm_Input ("r", Cache_Line_Address), --  %0
         Volatile => True);
      Strong_Memory_Barrier;
   end Flush_Data_Cache_Line;

   procedure Flush_Invalidate_Data_Cache_Line (Cache_Line_Address : System.Address) is
   begin
      Strong_Memory_Barrier;
      System.Machine_Code.Asm (
         "dc civac, %0",
         Inputs => System.Address'Asm_Input ("r", Cache_Line_Address), --  %0
         Clobber => "memory",
         Volatile => True);
      Strong_Memory_Barrier;
   end Flush_Invalidate_Data_Cache_Line;

   procedure Hypercall (Op_Code : Interfaces.Unsigned_8) is
   begin
      System.Machine_Code.Asm (
            "mov x0, %0" & LF &
            "hvc #0",
            Inputs => Interfaces.Unsigned_8'Asm_Input ("r", Op_Code), --  %0
            Clobber => "x0",
            Volatile => True);
   end Hypercall;

   procedure Break_Point is
   begin
      System.Machine_Code.Asm ("brk #0", Volatile => True);
   end Break_Point;

end HiRTOS_Cpu_Arch_Interface;
