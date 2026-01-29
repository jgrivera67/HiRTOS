--
--  Copyright (c) 2024, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target CPU architecture interface - private declarations
--

with HiRTOS_Platform_Parameters;
with Bit_Sized_Integer_Types;
with System.Storage_Elements;
with Interfaces;

package HiRTOS_Cpu_Arch_Interface_Private with
   SPARK_Mode => On
is
   use Bit_Sized_Integer_Types;
   use System.Storage_Elements;
   use Interfaces;

   Bl_Instruction_Size : constant := 4;
   --  Size of of the "bl" instruction in bytes for ARM thumb-2

   Arm_Thumb_Code_Flag : constant := 16#1#;
   --  In ARM Cortex-M code, the lowest bit of the target address of a branch
   --  (including call and return  branches) is set to indicate that the
   --  target code must be executed in THUMB mode.

   --
   --  Values that LR can be set to, to return from an exception:
   --
   Cpu_Exc_Return_To_Handler_Mode : constant Unsigned_32 := 16#FFFFFFF1#;
   Cpu_Exc_Return_To_Thread_Mode_Using_Msp : constant Unsigned_32 :=
     16#FFFFFFF9#;
   Cpu_Exc_Return_To_Thread_Mode_Using_Psp : constant Unsigned_32 :=
     16#FFFFFFFD#;
   Cpu_Exc_Return_To_Thread_Mode_Using_Psp_Fpu : constant Unsigned_32 :=
     16#FFFFFFED#;

   type Cortex_M_Common_Vector_Entry_Type is
        (Initial_MSP,
         Reset_Exception,
         NMI_Exception,
         HardFault_Exception,
         MemoryManagement_Exception, -- Not in Cortex-M0+
         BusFault_Exception,          -- Not in Cortex-M0+
         UsageFault_Exception,        -- Not in Cortex-M0+
         Reserved1,
         Reserved2,
         Reserved3,
         Reserved4,
         SVCall_Exception,
         DebugMonitor_Exception,     -- Not in Cortex-M0+
         Reserved5,
         PendSV_Exception,
         SysTick_Exception,
         First_External_Interrupt_Vector_Index);

   pragma Compile_Time_Error
     (Cortex_M_Common_Vector_Entry_Type'First'Enum_Rep /= 0,
      "First Cortex_M_Common_Vector_Entry_Type value must be 0");
   pragma Compile_Time_Error
     (Cortex_M_Common_Vector_Entry_Type'Last'Enum_Rep /= 16,
      "Last Cortex_M_Common_Vector_Entry_Type value must be 16");

   --  ARM core CONTROL register
   type CONTROL_Type is record
      nPRIV : Bit_Type;
      SPSEL  : Bit_Type;
      FPCA  : Bit_Type;
   end record with
     Size      => Unsigned_32'Size,
     Bit_Order => System.Low_Order_First;

   for CONTROL_Type use record
      nPRIV at 0 range 0 .. 0;
      SPSEL at 0 range 1 .. 1;
      FPCA at 0 range 2 .. 2;
   end record;

   --  ARM core xPSR register
   type XPSR_Type (As_Value : Boolean := True) is record
      case As_Value is
         when True =>
            Value : Unsigned_32 := 0;
         when False =>
            ISR : Nine_Bits_Type := 0; --  Exception number
            T : Bit_Type := 0; --  Thumb state bit
            V : Bit_Type := 0; --  Overflow flag
            C : Bit_Type := 0; --  Carry flag
            Z : Bit_Type := 0; --  Zero flag
            N : Bit_Type := 0; --  Negative flag
      end case;
   end record with
     Size      => 32,
     Bit_Order => System.Low_Order_First,
     Unchecked_Union;

   for XPSR_Type use record
      Value at 0 range 0 .. 31;
      ISR at 0 range 0 .. 8;
      T   at 0 range 24 .. 24;
      V   at 0 range 28 .. 28;
      C   at 0 range 29 .. 29;
      Z   at 0 range 30 .. 30;
      N   at 0 range 31 .. 31;
   end record;

   -- ** --

   --
   --  ARM Thumb instruction format
   --
   type Thumb_Instruction_Type is record
      Operand : Unsigned_8;
      Op_Code : Unsigned_8;
   end record with
     Size      => Unsigned_16'Size,
     Bit_Order => System.Low_Order_First,
     Alignment => 2;

   for Thumb_Instruction_Type use record
      Operand at 0 range 0 .. 7;
      Op_Code at 0 range 8 .. 15;
   end record;

   --
   --  ARM Thumb instruction format
   --
   type Thumb_32bit_Instruction_Type is record
      Operand1 : Unsigned_8;
      Op_Code : Unsigned_8;
      Operand2 : Unsigned_16;
   end record with
     Size      => Unsigned_32'Size,
     Bit_Order => System.Low_Order_First,
     Alignment => 4;

   for Thumb_32bit_Instruction_Type use record
      Operand1 at 0 range 0 .. 7;
      Op_Code at 0 range 8 .. 15;
      Operand2 at 0 range 16 .. 31;
   end record;

   --
   --  Register list operand for ARM Cortex-M push instruction
   --
   type Register_List_Operand_Type is array (0 .. 7) of Bit_Type with
     Component_Size => 1, Size => Unsigned_8'Size;

   --
   --  Register list operand for ARM Cortex-M push instruction
   --
   type Register_Long_List_Operand_Type is array (0 .. 15) of Bit_Type with
     Component_Size => 1, Size => Unsigned_16'Size;

   --
   --  Entries in the execution stack for an ARM Cortex-M processor
   ---
   type Stack_Entry_Type is new Unsigned_32;

   --
   --  'sub sp, #imm7' instruction immediate operand mask
   --
   Sub_SP_Immeditate_Operand_Mask : constant Unsigned_8 := 16#7F#;

   Instruction_Size : constant Positive := Thumb_Instruction_Type'Size / Unsigned_8'Size;
   --  Size of an ARM THUMB 16-bit instruction in bytes

   Stack_Entry_Size : constant Positive := Stack_Entry_Type'Size / Unsigned_8'Size;
   --  Size in bytes of an entry in the execution stack

   Num_Internal_Interrupts : constant := 16;

   Num_Interrupt_Vector_Table_Entries : constant Positive :=
      Num_Internal_Interrupts + HiRTOS_Platform_Parameters.Num_External_Interrupts;

   type Interrupt_Vector_Table_Index_Type is mod  Num_Interrupt_Vector_Table_Entries;

   Interrupt_Vector_Table : constant array (Interrupt_Vector_Table_Index_Type) of System.Address
       with Import,
            Convention => C,
            External_Name => "Interrupt_Vector_Table";

   -- ** --

   procedure Data_Synchronization_Barrier with Inline_Always;
   --  Data memory barrier

   function Return_Address_To_Call_Address (Return_Address : System.Address)
                                            return System.Address with Inline_Always;
   --  Calculates the call address for given a return address for ARM Cortex-M

   function Get_LR_Register return System.Address with Inline_Always;
   --  Capture current value of the ARM core LR (r14) register

   function Get_Frame_Pointer_Register return System.Address with Inline_Always;
   --  Capture current value of the ARM core frame pointer (r7) register

   function Get_CONTROL_Register return CONTROL_Type with Inline_Always;
   --  Capture current value of the ARM core CONTROL register

   procedure Set_CONTROL_Register (Reg_Value : CONTROL_Type) with Inline_Always;
   --  Set current value of the ARM core CONTROL register

   function Get_IPSR_Register return Unsigned_32 with Inline_Always;
   --  Capture current value of the ARM core IPSR register

   function Get_PSP_Register return Unsigned_32 with Inline_Always;
   --  Capture current value of the ARM core PSP register

   procedure Set_PSP_Register (Reg_Value : Unsigned_32) with Inline_Always;
   --  Set current value of the ARM core PSP register

   function Is_Cpu_Using_MSP_Stack_Pointer return Boolean with Inline_Always;
   --  Tell if the CPU is current stack pointer is the MSP stack pointer

   function Is_Cpu_Exception_Return (Return_Address : System.Address)
                                     return Boolean is
     (To_Integer (Return_Address) >=
          Integer_Address (Cpu_Exc_Return_To_Thread_Mode_Using_Psp_Fpu));
   --  Tell if a return address is one of the exception return special values

   function Is_Add_R7_SP_Immeditate (Instruction : Thumb_Instruction_Type)
                                     return Boolean is
     (Instruction.Op_Code = 16#AF#);
   --  Tell if it is the 'add r7, sp, #imm8' instruction

   function Is_Sub_SP_Immeditate (Instruction : Thumb_Instruction_Type)
                                  return Boolean is
     (Instruction.Op_Code = 16#B0# and then
        (Instruction.Operand and 16#80#) /= 0);
   --  Tell if it is the 'sub sp, #imm7' instruction

   function Is_Push_R7 (Instruction : Thumb_Instruction_Type)
                        return Boolean is
     ((Instruction.Op_Code and 16#FE#) = 16#B4# and then
      (Instruction.Operand and 16#80#) /= 0);
   --  Tell if it is the 'push {...,r7, ...}' instruction

   function Is_32bit_Instruction (Instruction : Thumb_Instruction_Type)
                                  return Boolean with Inline_Always;
   --  Tell if a half-word is the lower half-word of a 32-bit instruction

   function Is_STMDB_SP_R7 (Long_Instruction : Thumb_32bit_Instruction_Type)
                        return Boolean is
     (Long_Instruction.Op_Code = 16#E9# and then
      Long_Instruction.Operand1 = 16#2D# and then
      (Long_Instruction.Operand2 and 16#0080#) /= 0);
   --  Tell if it is the 'stmdb sp!, {...,r7, ...}' instruction

   function Push_Operand_Includes_LR (Instruction : Thumb_Instruction_Type)
                                      return Boolean is
     ((Instruction.Op_Code and 16#01#) /= 0);
   --  Tell if  'push' instruction modifier "append lr to reg list" is present

   function Is_Push_R7_LR (Instruction : Thumb_Instruction_Type)
                           return Boolean is
     (Is_Push_R7 (Instruction) and then
      Push_Operand_Includes_LR (Instruction));
   --  Tell if it is the 'push {...,r7, lr}' instruction

   function Stmdb_Register_List_Includes_LR (
      Instruction : Thumb_32bit_Instruction_Type) return Boolean is
      ((Instruction.Operand2 and 16#4000#) /= 0);
   --
   --  Tell if  'stmdb' instruction modifier "append lr to reg list" is
   --  present
   --

   function Is_BL32_First_Half (Instruction : Thumb_Instruction_Type)
                                 return Boolean is
     ((Instruction.Op_Code and 16#F0#) = 16#F0#);
   --  "bl" instruction (32-bit instruction) opcode first-half mask

   function Is_BL32_Second_Half (Instruction : Thumb_Instruction_Type)
                                  return Boolean is
     ((Instruction.Op_Code and 16#D0#) = 16#D0#);
   --  "bl" instruction (32-bit instruction) opcode second-half mask

   function Is_BLX (Instruction : Thumb_Instruction_Type)
                    return Boolean is
     ((Instruction.Op_Code and 16#FF#) = 16#47# and then
          (Instruction.Operand and 16#80#) = 16#80#);
   --  "blx" instruction opcode mask (16-bit instruction)

   function Get_Pushed_R7_Stack_Offset (
      Push_Instruction : Thumb_Instruction_Type) return Integer_Address;

   function Get_Pushed_R7_Stack_Offset (
      Stmdb_Sp_Instruction : Thumb_32bit_Instruction_Type)
      return Integer_Address;

   function Get_Pushed_LR_Stack_Offset (
      Stmdb_Sp_Instruction : Thumb_32bit_Instruction_Type)
      return Integer_Address;

   function Is_Caller_An_Interrupt_Handler return Boolean is
      (Is_Cpu_Using_MSP_Stack_Pointer);
   --  Tell if the caller is an ISR or a CPU exception handler

   function Byte_Swap (Value : Unsigned_16) return Unsigned_16 with Inline_Always;
   --  Do a byte-swap of a 16-bit value

   function Byte_Swap (Value : Unsigned_32) return Unsigned_32 with Inline_Always;
   --  Do a byte-swap of a 32-bit value

   procedure Nop;
   --  Nop machine instruction

   procedure Trigger_PendSV_Exception with Inline_Always;
   --  Trigger a PendSV exception

   -----------------------------------------------------------------------------
   --  Interrupt vector table declarations
   -----------------------------------------------------------------------------

   --
   --  Reset exception handler
   --
   procedure Reset_Handler with Export,
                                External_Name => "reset_handler",
                                Convention => Asm,
                                No_Return;

   procedure Non_Maskable_Interrupt_Handler
      with Export,
           External_Name => "non_maskable_interrupt_handler",
           Convention => C;

   procedure Hard_Fault_Exception_Handler
      with Export,
           External_Name => "hard_fault_exception_handler",
           Convention => C;

   procedure MemoryManagement_Exception_Handler
      with Export,
           External_Name => "memory_management_exception_handler",
           Convention => C;

   procedure Bus_Fault_Exception_Handler
      with Export,
           External_Name => "bus_fault_exception_handler",
           Convention => C;

   procedure Usage_Fault_Exception_Handler
      with Export,
           External_Name => "usage_fault_exception_handler",
           Convention => C;

   procedure Unexpected_Exception_Handler
      with Export,
           External_Name => "unexpected_exception_handler",
           Convention => C;

   procedure SVCall_Exception_Handler
      with Export,
           External_Name => "svcall_exception_handler",
           Convention => C;

   procedure Debug_Monitor_Exception_Handler
      with Export,
           External_Name => "debug_monitor_exception_handler",
           Convention => C;

   procedure PendSV_Exception_Handler
      with Export,
           External_Name => "pendsv_exception_handler",
           Convention => C;
   pragma Machine_Attribute (PendSV_Exception_Handler, "naked");

   procedure SysTick_Interrupt_Handler
      with Export,
           External_Name => "systick_interrupt_handler",
           Convention => C;

   procedure External_Interrupt_Handler
      with Export,
           External_Name => "external_interrupt_handler",
           Convention => C;

   procedure Fault_Exception_Handler_Prolog
      with Inline_Always;

   procedure Common_Fault_Exception_Handler (Exception_Vector : Cortex_M_Common_Vector_Entry_Type)
      with No_Return;

end HiRTOS_Cpu_Arch_Interface_Private;
