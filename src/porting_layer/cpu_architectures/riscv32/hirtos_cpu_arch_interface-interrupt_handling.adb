--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target platform interface for RISCV architecture - Interrupt handling
--

with Generic_Execution_Stack;
with HiRTOS_Platform_Parameters;
with HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
with HiRTOS_Cpu_Arch_Interface.Thread_Context;
with HiRTOS_Cpu_Arch_Interface_Private;
with HiRTOS_Low_Level_Debug_Interface;
with HiRTOS.Interrupt_Handling;
with Bit_Sized_Integer_Types;
with System.Machine_Code;
with Interfaces;

package body HiRTOS_Cpu_Arch_Interface.Interrupt_Handling is
   use ASCII;
   use HiRTOS_Cpu_Arch_Interface_Private;
   use HiRTOS_Cpu_Arch_Interface.Thread_Context;
   use type Interfaces.Unsigned_16;
   use type Bit_Sized_Integer_Types.Bit_Type;

   type MCause_Exception_Code_Type is mod 2 ** (Integer_Address'Size - 2)
     with Size => Integer_Address'Size - 2;

   type MCause_Type is record
      Interrupt_Flag : Bit_Sized_Integer_Types.Bit_Type;
      Exception_Code : MCause_Exception_Code_Type;
   end record
     with Size => Integer_Address'Size,
          Bit_Order => System.Low_Order_First;

   for MCause_Type use record
      Exception_Code at 0 range 0 .. Integer_Address'Size - 2;
      Interrupt_Flag at 0 range Integer_Address'Size - 1 .. Integer_Address'Size - 1;
   end record;

   Instruction_Address_Misaligned_Str : aliased constant String := "Instruction Address Misaligned";
   Instruction_Access_Fault_Str : aliased constant String := "Instruction Access Fault";
   Illegal_Instruction_Str : aliased constant String := "Illegal Instruction";
   Breakpoint_Str : aliased constant String := "Breakpoint";
   Load_Address_Misaligned_Str : aliased constant String := "Load Address Misaligned";
   Load_Access_Fault_Str : aliased constant String := "Load Access Fault";
   Store_Address_Misaligned_Str : aliased constant String := "Store Address Misaligned";
   Store_Access_Fault_Str : aliased constant String := "Store Access Fault";
   Environment_Call_From_U_Mode_Str : aliased constant String := "Environment Call From U Mode";
   Environment_Call_From_S_Mode_Str : aliased constant String := "Environment Call From S Mode";
   Environment_Call_From_M_Mode_Str : aliased constant String := "Environment Call From M Mode";
   Instruction_Page_Fault_Str : aliased constant String := "Instruction Page Fault";
   Load_Page_Fault_Str : aliased constant String := "Load Page Fault";
   Store_Page_Fault_Str : aliased constant String := "Store Page Fault";

   Cpu_Sync_Exception_Str_Pointer_Array :
      constant array (Cpu_Sync_Exception_Code_Type) of not null access constant String :=
      [Instruction_Address_Misaligned => Instruction_Address_Misaligned_Str'Access,
       Instruction_Access_Fault => Instruction_Access_Fault_Str'Access,
       Illegal_Instruction => Illegal_Instruction_Str'Access,
       Breakpoint => Breakpoint_Str'Access,
       Load_Address_Misaligned => Load_Address_Misaligned_Str'Access,
       Load_Access_Fault => Load_Access_Fault_Str'Access,
       Store_Address_Misaligned => Store_Address_Misaligned_Str'Access,
       Store_Access_Fault => Store_Access_Fault_Str'Access,
       Environment_Call_From_U_Mode => Environment_Call_From_U_Mode_Str'Access,
       Environment_Call_From_S_Mode => Environment_Call_From_S_Mode_Str'Access,
       Environment_Call_From_M_Mode => Environment_Call_From_M_Mode_Str'Access,
       Instruction_Page_Fault => Instruction_Page_Fault_Str'Access,
       Load_Page_Fault => Load_Page_Fault_Str'Access,
       Store_Page_Fault => Store_Page_Fault_Str'Access];

   Cpu_Context_Size_In_Bytes : constant Interfaces.Unsigned_16 :=
      HiRTOS_Cpu_Arch_Interface.Thread_Context.Cpu_Context_Type'Size / System.Storage_Unit;

   --
   --  Entry point of the synchronous exception handler
   --
   procedure Synchronous_Exception_Handler
      with Export,
           External_Name => "synchronous_exception_handler",
           No_Return;
   pragma Machine_Attribute (Synchronous_Exception_Handler, "naked");

   procedure Ecall_From_U_Mode_Exception_Handler
      with Export,
           External_Name => "ecall_from_u_mode_exception_handler";
   pragma Machine_Attribute (Ecall_From_U_Mode_Exception_Handler, "naked");

   procedure Ecall_From_M_Mode_Exception_Handler
      with Export,
           External_Name => "ecall_from_m_mode_exception_handler";
   pragma Machine_Attribute (Ecall_From_M_Mode_Exception_Handler, "naked");

   --
   --  Entry point of the external interrupt handler
   --
   procedure External_Interrupt_Handler
      with Export,
           External_Name => "external_interrupt_handler",
           No_Return;
   pragma Machine_Attribute (External_Interrupt_Handler, "naked");

   procedure Handle_Synchronous_Exception
      with Pre => Cpu_Interrupting_Disabled;

   function Get_MCause_Register return MCause_Type
      with Inline_Always;

   function Get_Mtval_Register return Cpu_Register_Type
      with Inline_Always;

   ISR_Stack_Size_In_Bytes : constant := 4 * 1024; -- 4KiB

   package ISR_Stacks_Package is new
      Generic_Execution_Stack (Stack_Size_In_Bytes => ISR_Stack_Size_In_Bytes);

   pragma Compile_Time_Error (
      ISR_Stacks_Package.Stack_Entries_Type'Size /= ISR_Stack_Size_In_Bytes * System.Storage_Unit,
      "Unexpected ISR stack size");

   ISR_Stacks :
      array (Valid_Cpu_Core_Id_Type) of ISR_Stacks_Package.Execution_Stack_Type
         with Linker_Section => ".isr_stack",
              Convention => C,
              Export,
              External_Name => "isr_stacks";

   pragma Compile_Time_Error (
      ISR_Stacks'Size = HiRTOS_Platform_Parameters.Num_Cpu_Cores * ISR_Stack_Size_In_Bytes * System.Storage_Unit,
      "Unexpected size of ISR_Stacks");

   ------------------------
   -- Get_ISR_Stack_Info --
   ------------------------

   function Get_ISR_Stack_Info (Cpu_Id : Cpu_Core_Id_Type)
      return ISR_Stack_Info_Type
   is
      ISR_Stack_Info : constant ISR_Stack_Info_Type :=
         (Base_Address => ISR_Stacks (Cpu_Id).Stack_Entries'Address,
          Size_In_Bytes => ISR_Stacks (Cpu_Id).Stack_Entries'Size / System.Storage_Unit);
   begin
      pragma Assert (Is_Value_Power_Of_Two (ISR_Stack_Info.Size_In_Bytes));
      return ISR_Stack_Info;
   end Get_ISR_Stack_Info;

   function Valid_ISR_Stack_Pointer (Cpu_Id : Cpu_Core_Id_Type; Stack_Pointer : System.Address)
      return Boolean is
      Min_Valid_Address : constant Integer_Address :=
         To_Integer (ISR_Stacks (Cpu_Id).Stack_Entries'Address);
      Max_Valid_Address : constant Integer_Address :=
         Min_Valid_Address + (ISR_Stacks (Cpu_Id).Stack_Entries'Size / System.Storage_Unit) - 1;
   begin
      return To_Integer (Stack_Pointer) in Min_Valid_Address .. Max_Valid_Address;
   end Valid_ISR_Stack_Pointer;

   --
   --  Inline subprogram to be invoked at the beginning of top-level interrupt handlers from
   --  which the RTOS scheduler can be called upon exit.
   --
   --  This subprogram saves all general purpose registers on the stack. All registers
   --  need to be saved (both caller-saved and callee-saved) because the task
   --  resumed upon returning from the interrupt may be a different task. However,
   --  we need to save all the registers only if the interrupt nesting level was 0
   --  before this interrupt.
   --
   --  CPU registers and other CPU state is saved on the current stack
   --  according to the layout of Cpu_Context_Type'. If the interrupted
   --  context was a task (interrupt nesting level was 0), this macro needs to
   --  switch stacks to the ISR stack.
   --
   --  @pre  interrupts are disabled at the CPU
   --  @pre  CPU is in M-mode
   --  @post sp = sp - (Cpu_Context_Type'Size / System.Storage_Unit)
   --
   --  NOTE: We cannot check preconditions, as that would insert code
   --  at the beginning of this subprogram, which would clobber the CPU registers
   --  before we save them.
   --
   procedure Interrupt_Handler_Prolog is
   begin
      System.Machine_Code.Asm (
         --
         --  Allocate space on the stack:
         --
         "addi sp, sp, -%0" & LF &
         --
         --  Save general-purpose registers on the stack:
         --
         --  NOTE: x2 (sp) does not need to be saved on the stack.
         --
         "sw ra, (0 * %1)(sp)" & LF &
         "sw sp, (1 * %1)(sp)" & LF & --  SP saved (redundant copy)
         "sw gp, (2 * %1)(sp)" & LF &
         "sw tp, (3 * %1)(sp)" & LF & --  TP saved
         "sw x5, (4 * %1)(sp)" & LF &
         "sw x6, (5 * %1)(sp)" & LF &
         "sw x7, (6 * %1)(sp)" & LF &
         "sw fp, (7 * %1)(sp)" & LF &
         "sw x9, (8 * %1)(sp)" & LF &
         "sw x10, (9 * %1)(sp)" & LF &
         "sw x11, (10 * %1)(sp)" & LF &
         "sw x12, (11 * %1)(sp)" & LF &
         "sw x13, (12 * %1)(sp)" & LF &
         "sw x14, (13 * %1)(sp)" & LF &
         "sw x15, (14 * %1)(sp)" & LF &
         "sw x16, (15 * %1)(sp)" & LF &
         "sw x17, (16 * %1)(sp)" & LF &
         "sw x18, (17 * %1)(sp)" & LF &
         "sw x19, (18 * %1)(sp)" & LF &
         "sw x20, (19 * %1)(sp)" & LF &
         "sw x21, (20 * %1)(sp)" & LF &
         "sw x22, (21 * %1)(sp)" & LF &
         "sw x23, (22 * %1)(sp)" & LF &
         "sw x24, (23 * %1)(sp)" & LF &
         "sw x25, (24 * %1)(sp)" & LF &
         "sw x26, (25 * %1)(sp)" & LF &
         "sw x27, (26 * %1)(sp)" & LF &
         "sw x28, (27 * %1)(sp)" & LF &
         "sw x29, (28 * %1)(sp)" & LF &
         "sw x30, (29 * %1)(sp)" & LF &
         "sw x31, (30 * %1)(sp)" & LF &
         --
         --  Save MEPC, MSTATUS and MSCRATCH:
         --
         "csrr t0, mepc" & LF &
         "sw   t0, (31 * %1)(sp)" & LF &
         "csrr t1, mstatus" & LF &
         "sw   t1, (32 * %1)(sp)" & LF &
         "csrr t2, mscratch" & LF &
         "sw   t2, (33 * %1)(sp)" & LF &
         --  Update mscratch and tp to remember that we are in privileged mode */
         "csrsi mscratch, 0x1" & LF &
         "and  tp, tp, %2" & LF &
         --
         --  Call sp = HiRTOS.Enter_Interrupt_Context (sp)
         --
         "mv a0, sp" & LF &
         "call hirtos_enter_interrupt_context" & LF &
         "mv sp, a0" & LF &
         --
         --  NOTE: At this point sp always points to somewhere in the ISR stack
         --
         --  Set frame pointer to be the same as stack pointer:
         --  (needed for stack unwinding across interrupted contexts)
         --
         "mv fp, sp",
         Inputs =>
            [Interfaces.Unsigned_16'Asm_Input ("g",
                                               Cpu_Context_Size_In_Bytes), --  %0
             Interfaces.Unsigned_8'Asm_Input ("g",
                                              HiRTOS_Cpu_Arch_Parameters.Integer_Register_Size_In_Bytes), --  %1
             Interfaces.Unsigned_32'Asm_Input ("g",
                                               TP_Cpu_Running_In_Privileged_Mode_Bit_Mask)], --  %2
         Volatile => True);

   end Interrupt_Handler_Prolog;

   --
   --  Inline subprogram to be invoked at the end of top-level interrupt handlers from
   --  which the RTOS scheduler can be called upon exit.
   --
   --  It restores the CPU state that was saved by a previous invocation to
   --  Interrupt_Handler_Prolog, and then executes an 'mret' instruction.
   --
   --  @pre  interrupts are disabled at the CPU
   --  @pre  CPU is in M-mode
   --  @pre  g_interrupt_nesting_level > 0
   --  @post sp = sp + SAVED_CPU_STATE_SIZE
   --  @post PC = MEPC
   --  @post current CPU privilege = MSTATUS.MPP
   --
   procedure Interrupt_Handler_Epilog is
   begin
      System.Machine_Code.Asm (
         --
         --  Call sp = HiRTOS.Interrupt_Handling.Exit_Interrupt_Context (sp)
         --
         "mv a0, sp" & LF &
         "call hirtos_exit_interrupt_context" & LF &
         "mv sp, a0" & LF &
         --
         --  At this point sp points to a thread stack, if interrupt nesting level
         --  dropped to 0. Otherwise, it points to somewhere in the ISR stack.
         --

         --
         --  Restore MEPC, MSTATUS and MSCRATCH:
         --
         "lw t0, (31 * %1)(sp)" & LF &
         "csrw mepc, t0" & LF &
         "lw t1, (32 * %1)(sp)" & LF &
         "csrw mstatus, t1" & LF &
         "lw t2, (33 * %1)(sp)" & LF &
         "csrw mscratch, t2" & LF &

         --
         --  Restore general-purpose registers saved on the stack:
         --
         --  NOTE: register sp (x2) does not need to be restored here,
         --  as we already restored it from the thread context
         --
         "lw ra, (0 * %1)(sp)" & LF &
         "lw gp, (2 * %1)(sp)" & LF &
         "lw tp, (3 * %1)(sp)" & LF & --  TP restored
         "lw x5, (4 * %1)(sp)" & LF &
         "lw x6, (5 * %1)(sp)" & LF &
         "lw x7, (6 * %1)(sp)" & LF &
         "lw fp, (7 * %1)(sp)" & LF &
         "lw x9, (8 * %1)(sp)" & LF &
         "lw x10, (9 * %1)(sp)" & LF &
         "lw x11, (10 * %1)(sp)" & LF &
         "lw x12, (11 * %1)(sp)" & LF &
         "lw x13, (12 * %1)(sp)" & LF &
         "lw x14, (13 * %1)(sp)" & LF &
         "lw x15, (14 * %1)(sp)" & LF &
         "lw x16, (15 * %1)(sp)" & LF &
         "lw x17, (16 * %1)(sp)" & LF &
         "lw x18, (17 * %1)(sp)" & LF &
         "lw x19, (18 * %1)(sp)" & LF &
         "lw x20, (19 * %1)(sp)" & LF &
         "lw x21, (20 * %1)(sp)" & LF &
         "lw x22, (21 * %1)(sp)" & LF &
         "lw x23, (22 * %1)(sp)" & LF &
         "lw x24, (23 * %1)(sp)" & LF &
         "lw x25, (24 * %1)(sp)" & LF &
         "lw x26, (25 * %1)(sp)" & LF &
         "lw x27, (26 * %1)(sp)" & LF &
         "lw x28, (27 * %1)(sp)" & LF &
         "lw x29, (28 * %1)(sp)" & LF &
         "lw x30, (29 * %1)(sp)" & LF &
         "lw x31, (30 * %1)(sp)" & LF &

         --
         --  Free space allocated on the stack:
         --
         "addi sp, sp, %0" & LF &

         --
         --  Return from m-mode exception:
         --
         "mret",
         Inputs =>
            [Interfaces.Unsigned_16'Asm_Input ("g",
                                               Cpu_Context_Size_In_Bytes),  --  %0
             Interfaces.Unsigned_8'Asm_Input ("g",
                                              HiRTOS_Cpu_Arch_Parameters.Integer_Register_Size_In_Bytes)], -- %1
         Volatile => True);
   end Interrupt_Handler_Epilog;

   ----------------------------------------------------------------------------
   --  Interrupt and Exception Handlers
   ----------------------------------------------------------------------------

   procedure Synchronous_Exception_Handler is
      use type Interfaces.Unsigned_32;
   begin
      System.Machine_Code.Asm (
        --  Push t0, t1 on the stack
        "addi sp, sp, -(2 * %1)" & LF &
        "sw t0, (0 * %1)(sp)" & LF &
        "sw t1, (1 * %1)(sp)" & LF &
        "csrr t0, mcause" & LF &
        "li t1, %0" & LF &
        "and t0, t0, t1" & LF &
        "li t1, %2" & LF &
        "beq t0, t1, ecall_from_u_mode_exception_handler" & LF &
        "li t1, %3" & LF &
        "beq t0, t1, ecall_from_m_mode_exception_handler" & LF &

        --
        --  Synchronous exceptions other than the ecall exceptions:
        --

        --  Pop t0, t1 from the stack
        "lw t0, (0 * %1)(sp)" & LF &
        "lw t1, (1 * %1)(sp)" & LF &
        "addi sp, sp, (2 * %1)",
         Inputs =>
            [Interfaces.Unsigned_32'Asm_Input ("g",
                                               not MCAUSE_Interrupt_Bit_Mask),  --  %0
             Interfaces.Unsigned_8'Asm_Input ("g",
                                              HiRTOS_Cpu_Arch_Parameters.Integer_Register_Size_In_Bytes), -- %1
             Interfaces.Unsigned_8'Asm_Input ("g",
                                              Environment_Call_From_U_Mode'Enum_Rep), -- %2
             Interfaces.Unsigned_8'Asm_Input ("g",
                                              Environment_Call_From_M_Mode'Enum_Rep)], -- %3
         Clobber => "t0, t1",
         Volatile => True);

      Interrupt_Handler_Prolog;
      Handle_Synchronous_Exception;
      Interrupt_Handler_Epilog;
   end Synchronous_Exception_Handler;

   --
   --  Raise CPU privilege to M-mode. That is, handle ENVIRONMENT_CALL_FROM_U_MODE
   --  exception by returning to caller in M-mode.
   --
   --  @pre interrupts are disabled at the CPU
   --  @pre t0, t1 were saved on the stack by the caller
   --
   --  NOTE: This subprogram is to be invoked only from Synchronous_Exception_Handler
   --
   procedure Ecall_From_U_Mode_Exception_Handler is
      use type Interfaces.Unsigned_32;
   begin
      System.Machine_Code.Asm (
         --
         --  Set exception return address to be the address of the instruction
         --  that is right after the 'ecall' instruction that brought us here:
         --
         --  NOTE: The size of the ecall instruction is always 4 bytes, even if
         --  building for the compressed ISA.
         --
         "csrr t0, mepc" & LF &
         "addi t0, t0, %0" & LF &
         "csrw mepc, t0" & LF &
         --  Set mstatus.MPP to M-mode:
         "csrr t0, mstatus" & LF &
         "li   t1, %2" & LF &
         "and  t0, t0, t1" & LF &
         "li   t1, %3" & LF &
         "or   t0, t0, t1" & LF &
         "csrw mstatus, t0" & LF &
         --  Update mscratch and tp to remember that we are in privileged mode:
         "csrsi mscratch, 0x1" & LF &
         "ori  tp, tp, %4" & LF &

         --  Pop t0, t1 from stack and return from exception
         "lw t0, (0 * %1)(sp)" & LF &
         "lw t1, (1 * %1)(sp)" & LF &
         "addi sp, sp, (2 * %1)" & LF &
         "mret",
        Inputs =>
            [Interfaces.Unsigned_8'Asm_Input ("g",
                                              Uncompressed_Instruction_Size),  --  %0
             Interfaces.Unsigned_8'Asm_Input ("g",
                                              HiRTOS_Cpu_Arch_Parameters.Integer_Register_Size_In_Bytes), -- %1
             Interfaces.Unsigned_32'Asm_Input ("g",
                                              not MSTATUS_MPP_Bit_Mask), -- %2
             Interfaces.Unsigned_32'Asm_Input ("g",
               Interfaces.Shift_Left (
                  Interfaces.Unsigned_32 (Mstatus_Mpp_Machine_Mode'Enum_Rep), MSTATUS_MPP_Bit_Offset)), -- %3
             Interfaces.Unsigned_32'Asm_Input ("g",
                                               TP_Cpu_Running_In_Privileged_Mode_Bit_Mask)], --  %4
         Clobber => "t0, t1",
         Volatile => True);
   end Ecall_From_U_Mode_Exception_Handler;

   --
   --  Perform a synchronous thread context switch
   --
   --  NOTE: This subprogram is to be invoked only from Synchronous_Exception_Handler
   --
   procedure Ecall_From_M_Mode_Exception_Handler is
   begin
      System.Machine_Code.Asm (
        --
        --  Set exception return address to be the address of the instruction
        --  that is right after the 'ecall' instruction that brought us here:
        --
        "csrr t0, mepc" & LF &
        "addi t0, t0, %0" & LF &
        "csrw mepc, t0" & LF &
        --  Pop t0, t1 from the stack
        "lw t0, (0 * %1)(sp)" & LF &
        "lw t1, (1 * %1)(sp)" & LF &
        "addi sp, sp, (2 * %1)",
        Inputs =>
            [Interfaces.Unsigned_8'Asm_Input ("g",
                                              Uncompressed_Instruction_Size),  --  %0
             Interfaces.Unsigned_8'Asm_Input ("g",
                                              HiRTOS_Cpu_Arch_Parameters.Integer_Register_Size_In_Bytes)], -- %1
         Clobber => "t0, t1",
         Volatile => True);

      --  Save the current thread's CPU state on its own stack
      HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Interrupt_Handler_Prolog;

      --
      --  Run the thread scheduler to select next thread to run and
      --  resume execution of the newly selected thread
      --
      HiRTOS_Cpu_Arch_Interface.Interrupt_Handling.Interrupt_Handler_Epilog;
   end Ecall_From_M_Mode_Exception_Handler;

   procedure Handle_Synchronous_Exception is
      MCause_Value : constant MCause_Type := Get_MCause_Register;

      procedure Handle_Fault_Exception (Exception_Code : Cpu_Sync_Exception_Code_Type) is
         Mepc_Value : constant Integer_Address := Get_Mepc_Register;
         Mtval_Value : constant Cpu_Register_Type := Get_Mtval_Register;
      begin
         HiRTOS_Low_Level_Debug_Interface.Print_String (
            "*** " & Cpu_Sync_Exception_Str_Pointer_Array (Exception_Code).all & " at PC ");
         HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (Mepc_Value));
         HiRTOS_Low_Level_Debug_Interface.Print_String (" accessing ");
         HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (Mtval_Value),
                                                                    End_Line => True);
         raise Program_Error;
      end Handle_Fault_Exception;

      procedure Handle_Breakpoint_Exception is
         Saved_PC : constant System.Address := HiRTOS.Interrupt_Handling.Get_Interrupted_PC;
      begin
         HiRTOS_Low_Level_Debug_Interface.Print_String (
            "*** Breakpoint exception ignored (not suported yet)" & ASCII.LF);

         pragma Assert (Get_Mepc_Register = To_Integer (Saved_PC));
         HiRTOS.Interrupt_Handling.Set_Interrupted_PC (
            To_Address (To_Integer (Saved_PC) + Uncompressed_Instruction_Size));
      end Handle_Breakpoint_Exception;

      procedure Handle_Unexpected_Exception (Exception_Code : Cpu_Sync_Exception_Code_Type) is
      begin
         HiRTOS_Low_Level_Debug_Interface.Print_String (
            "*** ERROR: Unexpected exception: " &
            Cpu_Sync_Exception_Str_Pointer_Array (Exception_Code).all & ASCII.LF);
         raise Program_Error;
      end Handle_Unexpected_Exception;

   begin
      pragma Assert (MCause_Value.Interrupt_Flag = 0);
      if MCause_Value.Exception_Code <= Cpu_Sync_Exception_Code_Type'Last'Enum_Rep then
         declare
            Exception_Code : constant Cpu_Sync_Exception_Code_Type :=
               Cpu_Sync_Exception_Code_Type'Enum_Val (MCause_Value.Exception_Code);
         begin
            case Exception_Code is
               when Instruction_Address_Misaligned |
                    Instruction_Access_Fault |
                    Illegal_Instruction |
                    Load_Address_Misaligned |
                    Load_Access_Fault |
                    Store_Address_Misaligned |
                    Store_Access_Fault =>
                  Handle_Fault_Exception (Exception_Code);

               when Breakpoint =>
                  Handle_Breakpoint_Exception;

               when others =>
                  Handle_Unexpected_Exception (Exception_Code);
            end case;
         end;
      else
         HiRTOS_Low_Level_Debug_Interface.Print_String (
            "*** ERROR: synchronous exception with invalid mcause ");
         HiRTOS_Low_Level_Debug_Interface.Print_Number_Hexadecimal (
            Interfaces.Unsigned_32 (MCause_Value.Exception_Code), End_Line => True);
         raise Program_Error;
      end if;
   end Handle_Synchronous_Exception;

   procedure External_Interrupt_Handler is
   begin
      --  Save the current thread's CPU state on its own stack
      Interrupt_Handler_Prolog;

      declare
         Mcause_Value : constant MCause_Type := Get_MCause_Register;
      begin
         pragma Assert (Mcause_Value.Interrupt_Flag = 1);
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Interrupt_Handler (
            HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Valid_Interrupt_Id_Type (Mcause_Value.Exception_Code));
      end;

      --  Run the thread scheduler to select next thread to run and
      --  resume execution of the newly selected thread
      Interrupt_Handler_Epilog;
   end External_Interrupt_Handler;

   function Get_MCause_Register return MCause_Type is
      MCause_Value : MCause_Type;
   begin
      System.Machine_Code.Asm (
         "csrr  %0, mcause",
         Outputs => MCause_Type'Asm_Output ("=r", MCause_Value),
         Volatile => True);

      return MCause_Value;
   end Get_MCause_Register;

   function Get_Mtval_Register return Cpu_Register_Type is
      Reg_Value : Cpu_Register_Type;
   begin
      System.Machine_Code.Asm (
         "csrr  %0, mtval",
         Outputs => Cpu_Register_Type'Asm_Output ("=r", Reg_Value),
         Volatile => True);

      return Reg_Value;
   end Get_Mtval_Register;

end HiRTOS_Cpu_Arch_Interface.Interrupt_Handling;
