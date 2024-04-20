--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target CPU architecture interface
--

with HiRTOS_Cpu_Arch_Parameters;
with System.Storage_Elements;
with Interfaces;

package HiRTOS_Cpu_Arch_Interface with
 SPARK_Mode => On
is
   use System.Storage_Elements;

   type Cpu_Register_Type is new Interfaces.Unsigned_32;

   pragma Compile_Time_Error
    (Cpu_Register_Type'Size /=
     HiRTOS_Cpu_Arch_Parameters.Machine_Word_Width_In_Bits,
     "Cpu_Register_Type has the wrong size");

   function Get_Call_Address return System.Address with
    Inline_Always, Suppress => All_Checks;

   function Get_Stack_Pointer return Cpu_Register_Type with
    Inline_Always, Suppress => All_Checks;

   procedure Set_Stack_Pointer (Stack_Pointer : Cpu_Register_Type) with
    Inline_Always, Suppress => All_Checks;

   function Get_Cpu_Status_Register return Cpu_Register_Type with
    Inline_Always, Suppress => All_Checks;

   function Cpu_Interrupting_Disabled return Boolean with
    Inline_Always, Suppress => All_Checks;

   --
   --  Disable interrupts at the CPU
   --
   --  NOTE: Only the IRQ interrupt is disabled, not the FIQ interrupt.
   --
   pragma Warnings (Off, "postcondition does not mention function result");
   function Disable_Cpu_Interrupting return Cpu_Register_Type with
    Pre => Cpu_In_Privileged_Mode,
    Post => Cpu_Interrupting_Disabled;
   pragma Warnings (On, "postcondition does not mention function result");

   --
   --  Restore interrupt enablement at the CPU
   --
   procedure Restore_Cpu_Interrupting (Old_Cpu_Interrupting : Cpu_Register_Type) with
    Pre => Cpu_In_Privileged_Mode and then
           Cpu_Interrupting_Disabled;

   procedure Enable_Cpu_Interrupting with
    Pre => Cpu_In_Privileged_Mode,
    Post => not Cpu_Interrupting_Disabled;

   function Cpu_In_Privileged_Mode return Boolean with
    Inline_Always, Suppress => All_Checks;

   function Cpu_In_Hypervisor_Mode return Boolean with
    Inline_Always, Suppress => All_Checks;

   procedure Break_Point with Inline_Always;

   function Ldrex_Word (Word_Address : System.Address) return Cpu_Register_Type with
    Inline_Always, Suppress => All_Checks;

   function Strex_Word (Word_Address : System.Address; Value : Cpu_Register_Type)
    return Boolean with
    Inline_Always, Suppress => All_Checks;

   function Ldrex_Byte (Byte_Address : System.Address) return Interfaces.Unsigned_8 with
    Inline_Always, Suppress => All_Checks;

   function Strex_Byte (Byte_Address : System.Address; Value : Interfaces.Unsigned_8)
    return Boolean with
    Inline_Always, Suppress => All_Checks;

   procedure Wait_For_Interrupt with
    Inline_Always;

   procedure Wait_For_Multicore_Event with
    Inline_Always;

   procedure Send_Multicore_Event with
    Inline_Always;

   procedure Memory_Barrier with
    Inline_Always;

   procedure Strong_Memory_Barrier  with
    Inline_Always;

   function Count_Leading_Zeros (Value : Cpu_Register_Type) return Cpu_Register_Type with
    Inline_Always, Suppress => All_Checks;

   function Count_Trailing_Zeros (Value : Cpu_Register_Type) return Cpu_Register_Type with
    Inline_Always, Suppress => All_Checks;

   type Bit_Index_Type is mod Integer_Address'Size;

   function Bit_Mask (Bit_Index : Bit_Index_Type) return Cpu_Register_Type is
    --(Cpu_Register_Type (Interfaces.Shift_Left (Interfaces.Unsigned_32 (1), Natural (Bit_Index))));
    (Cpu_Register_Type (2 ** Natural (Bit_Index)));

   subtype Log_Base_2_Type is Natural range 0 .. Integer_Address'Size - 1;

   function Is_Value_Power_Of_Two (Value : Integer_Address) return Boolean is
      (Value /= 0 and then
       (Value and (Value - 1)) = 0);

   function Get_Log_Base_2 (Value : Integer_Address) return Log_Base_2_Type
      with Pre => Is_Value_Power_Of_Two (Value);

   function Get_Log_Base_2 (Value : Integer_Address) return Log_Base_2_Type is
      (Log_Base_2_Type'Last - Log_Base_2_Type (Count_Leading_Zeros (Cpu_Register_Type (Value))));

   procedure Enable_Caches
      with Pre => Cpu_In_Privileged_Mode;

   procedure Disable_Caches
      with Pre => Cpu_In_Privileged_Mode;

   procedure Invalidate_Data_Cache;

   procedure Invalidate_Instruction_Cache;

   procedure Invalidate_Data_Cache_Line (Cache_Line_Address : System.Address);

   procedure Flush_Data_Cache_Line (Cache_Line_Address : System.Address);

   procedure Flush_Invalidate_Data_Cache_Line (Cache_Line_Address : System.Address);

   procedure Hypercall (Op_Code : Interfaces.Unsigned_8) with
     Pre => not Cpu_In_Hypervisor_Mode;

end HiRTOS_Cpu_Arch_Interface;
