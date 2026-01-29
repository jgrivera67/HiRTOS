--
--  Copyright (c) 2024, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target CPU architecture interface - private declarations
--

with HiRTOS_Cpu_Arch_Interface;
with HiRTOS_Cpu_Startup_Interface;
with HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
with HiRTOS_Cpu_Arch_Interface.System_Registers;
with HiRTOS_Cpu_Arch_Interface.Thread_Context;
with HiRTOS_Low_Level_Debug_Interface;
with HiRTOS.Interrupt_Handling;
with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface_Private is
   use System.Machine_Code;
   use HiRTOS_Cpu_Arch_Interface;
   use ASCII;

   ---------------
   -- Byte_Swap --
   ---------------

   function Byte_Swap (Value : Unsigned_16) return Unsigned_16 is
      Swapped_Value : Unsigned_16;
   begin
      Asm ("rev16 %0, %1" & ASCII.LF,
           Outputs => Unsigned_16'Asm_Output ("=r", Swapped_Value),
           Inputs => Unsigned_16'Asm_Input ("r", Value),
           Volatile => True);

      return Swapped_Value;
   end Byte_Swap;

   ---------------
   -- Byte_Swap --
   ---------------

   function Byte_Swap (Value : Unsigned_32) return Unsigned_32 is
      Swapped_Value : Unsigned_32;
   begin
      Asm ("rev %0, %1" & ASCII.LF,
           Outputs => Unsigned_32'Asm_Output ("=r", Swapped_Value),
           Inputs => Unsigned_32'Asm_Input ("r", Value),
           Volatile => True);

      return Swapped_Value;
   end Byte_Swap;

   ----------------------------------
   -- Data_Synchronization_Barrier --
   ----------------------------------

   procedure Data_Synchronization_Barrier is
   begin
      Asm ("dsb 0xf", Volatile => True, Clobber => "memory");
   end Data_Synchronization_Barrier;

   --------------------------
   -- Get_CONTROL_Register --
   --------------------------

   function Get_CONTROL_Register return CONTROL_Type is
      Reg_Value : CONTROL_Type;
   begin
      Asm ("mrs %0, control",
           Outputs => CONTROL_Type'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return Reg_Value;
   end Get_CONTROL_Register;

   --------------------------
   -- Set_CONTROL_Register --
   --------------------------

   procedure Set_CONTROL_Register (Reg_Value : CONTROL_Type) is
   begin
      Asm ("msr control, %0",
         Inputs => CONTROL_Type'Asm_Input ("r", Reg_Value), --  %0
         Volatile => True);
   end Set_CONTROL_Register;

   --------------------------------
   -- Get_Frame_Pointer_Register --
   --------------------------------

   function Get_Frame_Pointer_Register return System.Address is
      Reg_Value : Unsigned_32;
   begin
      Asm ("mov %0, r7", Outputs => Unsigned_32'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return To_Address (Integer_Address (Reg_Value));
   end Get_Frame_Pointer_Register;

   -----------------------
   -- Get_IPSR_Register --
   -----------------------

   function Get_IPSR_Register return Unsigned_32 is
      Reg_Value : Unsigned_32;
   begin
      Asm ("mrs %0, ipsr", Outputs => Unsigned_32'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return Reg_Value;
   end Get_IPSR_Register;

   ---------------------
   -- Get_LR_Register --
   ---------------------

   function Get_LR_Register return System.Address is
      Reg_Value : Unsigned_32;
   begin
      Asm ("mov %0, lr", Outputs => Unsigned_32'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return To_Address (Integer_Address (Reg_Value));
   end Get_LR_Register;

   ----------------------
   -- Get_PSP_Register --
   ----------------------

   function Get_PSP_Register return Unsigned_32 is
      Reg_Value : Unsigned_32;
   begin
      Asm ("mrs %0, psp", Outputs => Unsigned_32'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return Reg_Value;
   end Get_PSP_Register;

   ----------------------
   -- Set_PSP_Register --
   ----------------------

   procedure Set_PSP_Register (Reg_Value : Unsigned_32) is
   begin
      Asm ("msr psp, %0",
           Inputs => Unsigned_32'Asm_Input ("r", Reg_Value),
           Volatile => True);
   end Set_PSP_Register;

   --------------------------------------------------------
   -- Get_Pushed_LR_Stack_Offset - for stmdb instruction --
   --------------------------------------------------------

   function Get_Pushed_LR_Stack_Offset (
      Stmdb_Sp_Instruction : Thumb_32bit_Instruction_Type)
      return Integer_Address
   is
      Reg_List_Operand : Register_Long_List_Operand_Type with
        Import, Address => Stmdb_Sp_Instruction.Operand2'Address;
      Bits_Set_Count : Integer_Address := 0;
   begin
      --
      --  Check if registers r0 .. r12 are saved on the stack by the push
      --  instruction
      --
      for I in 0 .. 12 loop
         if Reg_List_Operand (I) = 1 then
            Bits_Set_Count := Bits_Set_Count + 1;
         end if;
      end loop;

      return Bits_Set_Count * Integer_Address (Stack_Entry_Size);
   end Get_Pushed_LR_Stack_Offset;

   -------------------------------------------------------
   -- Get_Pushed_R7_Stack_Offset - for push instruction --
   -------------------------------------------------------

   function Get_Pushed_R7_Stack_Offset (
      Push_Instruction : Thumb_Instruction_Type)
      return Integer_Address
   is
      Reg_List_Operand : Register_List_Operand_Type with
        Import, Address => Push_Instruction.Operand'Address;
      Bits_Set_Count : Integer_Address := 0;
   begin
      --
      --  Check if registers r0 .. r6 are saved on the stack by the push
      --  instruction
      --
      for I in 0 .. 6 loop
         if Reg_List_Operand (I) = 1 then
            Bits_Set_Count := Bits_Set_Count + 1;
         end if;
      end loop;

      return Bits_Set_Count * Integer_Address (Stack_Entry_Size);
   end Get_Pushed_R7_Stack_Offset;

   --------------------------------------------------------
   -- Get_Pushed_R7_Stack_Offset - for stmdb instruction --
   --------------------------------------------------------

   function Get_Pushed_R7_Stack_Offset (
      Stmdb_Sp_Instruction : Thumb_32bit_Instruction_Type)
      return Integer_Address
   is
      Reg_List_Operand : Register_Long_List_Operand_Type with
        Import, Address => Stmdb_Sp_Instruction.Operand2'Address;
      Bits_Set_Count : Integer_Address := 0;
   begin
      --
      --  Check if registers r0 .. r6 are saved on the stack by the push
      --  instruction
      --
      for I in 0 .. 6 loop
         if Reg_List_Operand (I) = 1 then
            Bits_Set_Count := Bits_Set_Count + 1;
         end if;
      end loop;

      return Bits_Set_Count * Integer_Address (Stack_Entry_Size);
   end Get_Pushed_R7_Stack_Offset;

   --------------------------
   -- Is_32bit_Instruction --
   --------------------------

   function Is_32bit_Instruction (Instruction : Thumb_Instruction_Type)
                                  return Boolean is
      Masked_Opcode : constant Unsigned_8 := (Instruction.Op_Code and
                                              2#11111000#);
   begin
      return Masked_Opcode = 2#11101000# or else
        Masked_Opcode = 2#11110000# or else
        Masked_Opcode = 2#11111000#;
   end Is_32bit_Instruction;

   ------------------------------------
   -- Is_Cpu_Using_MSP_Stack_Pointer --
   ------------------------------------

   function Is_Cpu_Using_MSP_Stack_Pointer return Boolean is
      (Get_CONTROL_Register.SPSEL = 0);

   ---------
   -- Nop --
   ---------

   procedure Nop is
   begin
      Asm ("nop", Volatile => True);
   end Nop;

   ------------------------------
   -- Trigger_PendSV_Exception --
   ------------------------------

   procedure Trigger_PendSV_Exception is
      use HiRTOS_Cpu_Arch_Interface.System_Registers;
      --  NOTE: Writing 0s to other fields has no effect
      ICSR_Value : constant ICSR_Type := (PENDSVSET => 1, others => <>);
   begin
      SCS.SCB.ICSR := ICSR_Value;
   end Trigger_PendSV_Exception;

   ------------------------------------
   -- Return_Address_To_Call_Address --
   ------------------------------------

   function Return_Address_To_Call_Address
     (Return_Address : System.Address)
      return System.Address
   is
      Value : Integer_Address;
   begin
      Value := To_Integer (Return_Address) and not Arm_Thumb_Code_Flag;
      return To_Address (Value - Bl_Instruction_Size);
   end Return_Address_To_Call_Address;

   -----------------------------------------------------------------------------
   --  Top level exception/interrupt handlers
   -----------------------------------------------------------------------------

   procedure Reset_Handler is
      Old_Cpu_Interrupting : Cpu_Register_Type with Unreferenced;
   begin
      --
      --  NOTE: Only "No_Elaboration_Code_All" packages can be invoked
      --  by this subprogram.
      --

      Old_Cpu_Interrupting := Disable_Cpu_Interrupting;

      HiRTOS_Cpu_Startup_Interface.Ada_Reset_Handler;

      --
      --  We should not return here
      --
      pragma Assert (False);
   end Reset_Handler;

   procedure Non_Maskable_Interrupt_Handler is
   begin
      HiRTOS_Low_Level_Debug_Interface.Print_String ("*** Unsupported non Maskable Interrupt" & ASCII.LF);
   end Non_Maskable_Interrupt_Handler;

   procedure Fault_Exception_Handler_Prolog is
   begin
      System.Machine_Code.Asm (
         --
         --  Save general-purpose registers not saved by hardware:
         --
         "mrs r0, psp" & LF &
         "ldr r3, =%0" & LF &
         "sub r1, r0, r3" & LF &  --  r1 = PSP to be saved
         "mrs r2, control" & LF & --  r2 = CONTROL to be saved
         "mov r3, #(10*4)" & LF &
         "sub r0, r0, r3" & LF & --  make room for 10 registers
         "stmia r0!, {r1, r2, r4-r7}" & LF &
         "mov r4, r8" & LF &
         "mov r5, r9" & LF &
         "mov r6, r10" & LF &
         "mov r7, r11" & LF &
         "stmia r0!, {r4-r7}",
         Inputs =>
            [Integer_Address'Asm_Input (
               "g",
               HiRTOS_Cpu_Arch_Interface.Thread_Context.Cpu_Context_Size_In_Bytes)], --  %0
         Volatile => True);
   end Fault_Exception_Handler_Prolog;

   procedure Common_Fault_Exception_Handler (Exception_Vector : Cortex_M_Common_Vector_Entry_Type) is
   begin
      raise Program_Error with Exception_Vector'Image;
   end Common_Fault_Exception_Handler;

   procedure Hard_Fault_Exception_Handler is
   begin
      Fault_Exception_Handler_Prolog;
      Common_Fault_Exception_Handler (HardFault_Exception);
   end Hard_Fault_Exception_Handler;

   procedure MemoryManagement_Exception_Handler is
   begin
      Fault_Exception_Handler_Prolog;
      Common_Fault_Exception_Handler (MemoryManagement_Exception);
   end MemoryManagement_Exception_Handler;

   procedure Bus_Fault_Exception_Handler is
   begin
      Fault_Exception_Handler_Prolog;
      Common_Fault_Exception_Handler (BusFault_Exception);
   end Bus_Fault_Exception_Handler;

   procedure Usage_Fault_Exception_Handler is
   begin
      Fault_Exception_Handler_Prolog;
      Common_Fault_Exception_Handler (UsageFault_Exception);
   end Usage_Fault_Exception_Handler;

   procedure SVCall_Exception_Handler is
      CONTROL_Value : CONTROL_Type := Get_CONTROL_Register;
   begin
      --
      --  Return from the exception in privileged mode:
      --
      CONTROL_Value.nPRIV := 0; --  privileged mode
      Set_CONTROL_Register (CONTROL_Value);
   end SVCall_Exception_Handler;

   procedure Debug_Monitor_Exception_Handler is
   begin
      Fault_Exception_Handler_Prolog;
      Common_Fault_Exception_Handler (DebugMonitor_Exception);
   end Debug_Monitor_Exception_Handler;

   function Do_HiRTOS_Thread_Context_Switch (PSP_Value : System.Address) return System.Address
      with Export,
         Convention => C,
         External_Name => "do_hirtos_thread_context_switch";

   function Do_HiRTOS_Thread_Context_Switch (PSP_Value : System.Address) return System.Address
   is
      New_PSP_Value : System.Address;
      MSP_Value : System.Address;
      Old_Cpu_Interrupting : constant Cpu_Register_Type := Disable_Cpu_Interrupting;
   begin
      pragma Assert (Unsigned_32 (To_Integer (PSP_Value)) = Get_PSP_Register);
      MSP_Value := HiRTOS.Interrupt_Handling.Enter_Interrupt_Context (PSP_Value);
      pragma Assert (Cpu_Register_Type (To_Integer (MSP_Value)) = Get_Stack_Pointer);
      New_PSP_Value := HiRTOS.Interrupt_Handling.Exit_Interrupt_Context (MSP_Value);
      Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
      return New_PSP_Value;
   end Do_HiRTOS_Thread_Context_Switch;

   procedure PendSV_Exception_Handler is
   begin
      System.Machine_Code.Asm (
         --
         --  Save general-purpose registers not saved by hardware:
         --
         "mrs r0, psp" & LF &
         "ldr r3, =%0" & LF &
         "sub r1, r0, r3" & LF &  --  r1 = PSP to be saved
         "mrs r2, control" & LF & --  r2 = CONTROL to be saved
         "mov r3, #(10*4)" & LF &
         "sub r0, r0, r3" & LF & --  make room for 10 registers
         "stmia r0!, {r1, r2, r4-r7}" & LF &
         "mov r4, r8" & LF &
         "mov r5, r9" & LF &
         "mov r6, r10" & LF &
         "mov r7, r11" & LF &
         "stmia r0!, {r4-r7}" & LF &
         "mov r3, #(10*4)" & LF &
         "sub r0, r0, r3" & LF & --  current stack top

         --  r0 = old PSP after saving software-saved CPU context
         --  call Do_Hirtos_Thread_Context_Switch (old PSP)
         --  r0 = new PSP
         "bl do_hirtos_thread_context_switch" & LF &

         --
         --  Restore general-purpose registers saved by software
         --
         "ldmia r0!, {r4-r7}" & LF &
         "mov r8, r4" & LF &
         "mov r9, r5" & LF &
         "mov r10, r6" & LF &
         "mov r11, r7" & LF &
         "ldmia r0!, {r1, r2, r4-r7}" & LF &

          --  r1 = r0 = new PSP after popping software-saved CPU context
          --  r2 = restored CONTROL
         "msr control, r2" & LF &
         "msr psp, r0" & LF &
         "ldr r0, =%1" & LF &
         "bx r0",
         Inputs =>
            [Integer_Address'Asm_Input (
               "g",
               HiRTOS_Cpu_Arch_Interface.Thread_Context.Cpu_Context_Size_In_Bytes), --  %0
             Interfaces.Unsigned_32'Asm_Input (
               "g",
               Cpu_Exc_Return_To_Thread_Mode_Using_Psp)], --  %1
         Volatile => True);
   end PendSV_Exception_Handler;

   procedure SysTick_Interrupt_Handler is
      PSP_Value : aliased System.Address; --  aliased to discard last value
      MSP_Value : System.Address;
      IPSR_Value : constant Unsigned_32 := Get_IPSR_Register;
   begin
      PSP_Value := To_Address (Integer_Address (Get_PSP_Register));
      MSP_Value := HiRTOS.Interrupt_Handling.Enter_Interrupt_Context (PSP_Value);

      pragma Assert (IPSR_Value = SysTick_Exception'Enum_Rep);
      HiRTOS.Interrupt_Handling.RTOS_Tick_Timer_Interrupt_Handler;

      pragma Assert (Cpu_Register_Type (To_Integer (MSP_Value)) = Get_Stack_Pointer);
      PSP_Value := HiRTOS.Interrupt_Handling.Exit_Interrupt_Context (MSP_Value);
   end SysTick_Interrupt_Handler;

   procedure External_Interrupt_Handler is
      use HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
      Interrupt_Id : Valid_Interrupt_Id_Type;
      PSP_Value : aliased System.Address; --  aliased to discard last value
      MSP_Value : System.Address;
      IPSR_Value : constant Unsigned_32 := Get_IPSR_Register;
   begin
      PSP_Value := To_Address (Integer_Address (Get_PSP_Register));
      MSP_Value := HiRTOS.Interrupt_Handling.Enter_Interrupt_Context (PSP_Value);

      pragma Assert (IPSR_Value >= First_External_Interrupt_Vector_Index'Enum_Rep);
      Interrupt_Id := Valid_Interrupt_Id_Type (
         IPSR_Value - First_External_Interrupt_Vector_Index'Enum_Rep);
      HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Interrupt_Handler (Interrupt_Id);

      pragma Assert (Cpu_Register_Type (To_Integer (MSP_Value)) = Get_Stack_Pointer);
      PSP_Value := HiRTOS.Interrupt_Handling.Exit_Interrupt_Context (MSP_Value);
   end External_Interrupt_Handler;

   procedure Unexpected_Exception_Handler is
   begin
      HiRTOS_Low_Level_Debug_Interface.Print_String ("*** Unexpected Exception ");
      HiRTOS_Low_Level_Debug_Interface.Print_Number_Decimal (
         Get_IPSR_Register, End_Line => True);

      pragma Assert (False);
      loop
         Wait_For_Interrupt;
      end loop;
   end Unexpected_Exception_Handler;

end HiRTOS_Cpu_Arch_Interface_Private;
