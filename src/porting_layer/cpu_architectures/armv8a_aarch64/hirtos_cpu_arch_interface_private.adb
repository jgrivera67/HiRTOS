--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target CPU architecture interface - private declarations
--

with System.Machine_Code;
with HiRTOS_Cpu_Arch_Interface.System_Registers;

package body HiRTOS_Cpu_Arch_Interface_Private is
   use ASCII;
   use System.Storage_Elements;
   use HiRTOS_Cpu_Arch_Interface.System_Registers;

   function Get_CurrentEL return Exception_Level_Type is
      PSTATE_Value : PSTATE_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, currentel",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", PSTATE_Value.Value),
         Volatile => True);

      return PSTATE_Value.CurrentEL;
   end Get_CurrentEL;

   function Get_DAIF return DAIF_Type is
      PSTATE_Value : PSTATE_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, daif",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", PSTATE_Value.Value),
         Volatile => True);

      return PSTATE_Value.DAIF;
   end Get_DAIF;

   function Get_PSTATE return PSTATE_Type is
      NZCV_Reg_Value : Cpu_Register_Type;
      DAIF_Reg_Value : Cpu_Register_Type;
      CurrentEL_Reg_Value : Cpu_Register_Type;
      SPSel_Reg_Value : Cpu_Register_Type;
      --  PAN_Reg_Value : Cpu_Register_Type;
      --  UAO_Reg_Value : Cpu_Register_Type;
      --  DIT_Reg_Value : Cpu_Register_Type;
      --  SSBS_Reg_Value : Cpu_Register_Type;
      --  TCO_Reg_Value : Cpu_Register_Type;
      PSTATE_Value : PSTATE_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, nzcv" & LF &
         "mrs %1, daif" & LF &
         "mrs %2, currentel" & LF &
         "mrs %3, spsel", -- & LF &
         --  "mrs %4, pan" & LF &
         --  "mrs %5, uao" & LF &
         --  "mrs %6, dit" & LF &
         --  "mrs %7, ssbs" & LF &
         --  "mrs %8, tco",
         Outputs => [
            Cpu_Register_Type'Asm_Output ("=r", NZCV_Reg_Value), --  %0
            Cpu_Register_Type'Asm_Output ("=r", DAIF_Reg_Value), --  %1
            Cpu_Register_Type'Asm_Output ("=r", CurrentEL_Reg_Value), --  %2
            Cpu_Register_Type'Asm_Output ("=r", SPSel_Reg_Value) --  , --  %3
            --  Cpu_Register_Type'Asm_Output ("=r", PAN_Reg_Value), --  %4
            --  Cpu_Register_Type'Asm_Output ("=r", UAO_Reg_Value), --  %5
            --  Cpu_Register_Type'Asm_Output ("=r", DIT_Reg_Value), --  %6
            --  Cpu_Register_Type'Asm_Output ("=r", SSBS_Reg_Value), --  %7
            --  Cpu_Register_Type'Asm_Output ("=r", TCO_Reg_Value) --  %8
         ],
         Volatile => True);

      PSTATE_Value.Value := (NZCV_Reg_Value or DAIF_Reg_Value or CurrentEL_Reg_Value or
                             SPSel_Reg_Value);  -- or PAN_Reg_Value or UAO_Reg_Value or
                           --    DIT_Reg_Value or SSBS_Reg_Value or TCO_Reg_Value);
      return PSTATE_Value;
   end Get_PSTATE;

   function Get_ELR_EL1 return Cpu_Register_Type is
      ELR_EL1_Value : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, elr_el1",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", ELR_EL1_Value), --  %0
         Volatile => True);

      return ELR_EL1_Value;
   end Get_ELR_EL1;

   procedure Set_ELR_EL1 (ELR_EL1_Value : Cpu_Register_Type) is
   begin
      System.Machine_Code.Asm (
         "msr elr_el1, %0",
         Inputs => Cpu_Register_Type'Asm_Input ("r", ELR_EL1_Value), --  %0
         Volatile => True);
   end Set_ELR_EL1;

   function Get_ELR_EL2 return Cpu_Register_Type is
      ELR_EL2_Value : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "mrs %0, elr_el2",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", ELR_EL2_Value), --  %0
         Volatile => True);

      return ELR_EL2_Value;
   end Get_ELR_EL2;

   procedure Enable_Debug_Exceptions is
   begin
      System.Machine_Code.Asm (
         "dsb sy" & LF &
         "isb" & LF &
         "msr DAIFclr, %0",
         Inputs => Interfaces.Unsigned_8'Asm_Input ("g", DAIF_SetClr_D_Bit_Mask),  --  %0
         Volatile => True);
   end Enable_Debug_Exceptions;

   procedure Invalidate_Data_Cache_Range (Start_Address : System.Address;
                                          End_Address : System.Address) is
      Cache_Line_Address : System.Address := Start_Address;
   begin
      loop
         Invalidate_Data_Cache_Line (Cache_Line_Address);
         Cache_Line_Address := To_Address (To_Integer (@) + HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes);
         exit when Cache_Line_Address = End_Address;
      end loop;
   end Invalidate_Data_Cache_Range;

   procedure Flush_Invalidate_Data_Cache_Range (Start_Address : System.Address;
                                                End_Address : System.Address) is
      Cache_Line_Address : System.Address := Start_Address;
   begin
      loop
         Flush_Invalidate_Data_Cache_Line (Cache_Line_Address);
         Cache_Line_Address := To_Address (To_Integer (@) + HiRTOS_Cpu_Arch_Parameters.Cache_Line_Size_Bytes);
         exit when Cache_Line_Address = End_Address;
      end loop;
   end Flush_Invalidate_Data_Cache_Range;

   function Caches_Are_Enabled return Boolean is
      SCTLR_EL1_Value : constant SCTLR_EL1_Type := Get_SCTLR_EL1;
   begin
      return SCTLR_EL1_Value.C = Cacheable and then
             SCTLR_EL1_Value.I = Instruction_Access_Cacheable;
   end Caches_Are_Enabled;

end HiRTOS_Cpu_Arch_Interface_Private;