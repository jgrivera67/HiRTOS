--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Hypervisor Tick timer driver
--

with HiRTOS.Separation_Kernel.Interrupt_Handling;
with HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
with HiRTOS_Cpu_Arch_Interface.Interrupts;
with System.Machine_Code;
with System.Storage_Elements;

package body HiRTOS_Cpu_Arch_Interface.Tick_Timer.Hypervisor with SPARK_Mode => On is

   procedure Tick_Timer_Interrupt_Handler (Arg : System.Address)
      with Pre => Cpu_In_Hypervisor_Mode;

   procedure Initialize is
      CNTP_CTL_Value : CNTP_CTL_Type;
      CNTFRQ_Value : CNTFRQ_Type;
   begin
      CNTFRQ_Value := Get_CNTFRQ;
      pragma Assert (CNTFRQ_Value = CNTFRQ_Type (HiRTOS_Platform_Parameters.System_Clock_Frequency_Hz));

      --
      --  Make sure that the timer is disabled:
      --
      --  NOTE: Even if the ENABLE bit is 0, CNTPCT continues to count.
      --
      CNTP_CTL_Value := Get_CNTHP_CTL;
      CNTP_CTL_Value.ENABLE := Timer_Disabled;
      CNTP_CTL_Value.IMASK := Timer_Interrupt_Masked;
      Set_CNTHP_CTL (CNTP_CTL_Value);

      --
      --  NOTE: the generic timer interrupt is enabled in the GIC and in the
      --  peripheral when Start_Timer is called and disabled when Stop_Timer
      --  is called.
      --
   end Initialize;

   procedure Start_Timer (Expiration_Time_Us : HiRTOS.Relative_Time_Us_Type) is
      use System.Storage_Elements;
      CNTP_CTL_Value : CNTP_CTL_Type;
      CNTP_TVAL_Value : constant CNTP_TVAL_Type :=
         CNTP_TVAL_Type (Expiration_Time_Us * Timer_Counter_Cycles_Per_Us);
      Timer_Interrupt_Id : constant
         HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Interrupt_Id_Type :=
         HiRTOS_Cpu_Arch_Interface.Interrupts.Generic_Hypervisor_Timer_Interrupt_Id;
   begin
      pragma Assert (CNTP_TVAL_Value >= CNTP_TVAL_Type (Expiration_Time_Us));

      Set_CNTHP_TVAL (CNTP_TVAL_Value);

      --
      --  Enable tick timer interrupt in the generic timer peipheral:
      --
      --  NOTE: Section G8.7.16 of ARMv8 Architecture Reference Manual says:
      --  "When the value of the ENABLE bit is 1, ISTATUS indicates whether
      --   the timer condition is met. ISTATUS takes no account of the value
      --   of the IMASK bit. If the value of ISTATUS is 1 and the value of
      --   IMASK is 0 then the timer interrupt is asserted.
      --   Setting the ENABLE bit to 0 disables the timer output signal,
      --   but the timer value accessible from CNTP_TVAL continues to
      --   count down. Disabling the output signal might be a
      --   power-saving option."
      --
      CNTP_CTL_Value := Get_CNTHP_CTL;
      CNTP_CTL_Value.ENABLE := Timer_Enabled;
      CNTP_CTL_Value.IMASK := Timer_Interrupt_Not_Masked;
      Set_CNTHP_CTL (CNTP_CTL_Value);

      --  Configure generic hypervisor timer interrupt in the GIC:
      Interrupt_Controller.Configure_Internal_Interrupt (
         Internal_Interrupt_Id => Timer_Interrupt_Id,
         Priority => HiRTOS_Cpu_Arch_Interface.Interrupts.Interrupt_Priorities (Timer_Interrupt_Id),
         Cpu_Interrupt_Line => Interrupt_Controller.Cpu_Interrupt_Fiq,
         Trigger_Mode => Interrupt_Controller.Interrupt_Level_Sensitive,
         Interrupt_Handler_Entry_Point => Tick_Timer_Interrupt_Handler'Access,
         Interrupt_Handler_Arg => To_Address (Integer_Address (CNTP_TVAL_Value)));

      --  Enable generic timer interrupt in the GIC:
      Interrupt_Controller.Enable_Internal_Interrupt (Timer_Interrupt_Id);
   end Start_Timer;

   procedure Stop_Timer is
      CNTP_CTL_Value : CNTP_CTL_Type;
   begin
      --  Disable generic timer interrupt in the GIC:
      Interrupt_Controller.Disable_Internal_Interrupt (
         HiRTOS_Cpu_Arch_Interface.Interrupts.Generic_Hypervisor_Timer_Interrupt_Id);

      --  Disable tick timer interrupt in the generic timer peipheral:
      CNTP_CTL_Value := Get_CNTHP_CTL;
      CNTP_CTL_Value.ENABLE := Timer_Disabled;
      CNTP_CTL_Value.IMASK := Timer_Interrupt_Masked;
      Set_CNTHP_CTL (CNTP_CTL_Value);
   end Stop_Timer;

   procedure Initialize_Timer_Context (Timer_Context : out Timer_Context_Type) is
   begin
      --  Initialize CNTVCT to match the current CNTPCT
      Timer_Context := (CNTVCT_Value => Get_CNTPCT, others => <>);
   end Initialize_Timer_Context;

   procedure Save_Timer_Context (Timer_Context : out Timer_Context_Type) is
   begin
      Timer_Context.CNTV_CTL_Value := Get_CNTV_CTL;
      Timer_Context.CNTV_TVAL_Value := Get_CNTV_TVAL;
      Timer_Context.CNTVCT_Value := Get_CNTVCT;
   end Save_Timer_Context;

   procedure Restore_Timer_Context (Timer_Context : Timer_Context_Type) is
      use type Interfaces.Unsigned_64;
      CNTPCT_Value : constant CNTPCT_Type := Get_CNTPCT;
      CNTVOFF_Value : constant CNTVOFF_Type :=
         (As_Two_Words => False, Value => CNTPCT_Value.Value - Timer_Context.CNTVCT_Value.Value);
      CNTV_CTL_Value : CNTV_CTL_Type;
   begin
      --
      --  Disable virtual timer before updating its registers
      --
      CNTV_CTL_Value := Get_CNTV_CTL;
      CNTV_CTL_Value.ENABLE := Timer_Disabled;
      CNTV_CTL_Value.IMASK := Timer_Interrupt_Masked;
      Set_CNTV_CTL (CNTV_CTL_Value);

      --
      --  NOTE: CNTVCT cannot be restored directly as it is not writable. It is restored indirectly
      --  by setting the CNTVOFF register. CNTV_TVAL must be set only after setting CNTVOFF, since
      --  modifying CNTVOFF has the side effect of updating CNTVCT (CNTVCT = CNTPCT - CNTVOFF)
      --
      Set_CNTVOFF (CNTVOFF_Value);
      Set_CNTV_TVAL (Timer_Context.CNTV_TVAL_Value);
      Set_CNTV_CTL (Timer_Context.CNTV_CTL_Value);
   end Restore_Timer_Context;

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

   procedure Tick_Timer_Interrupt_Handler (Arg : System.Address)
   is
      use System.Storage_Elements;
      CNTP_TVAL_Value : constant CNTP_TVAL_Type := CNTP_TVAL_Type (To_Integer (Arg));
   begin
      --
      --  NOTE: Setting CNTP_TVAL here serves two purposes:
      --  - Clear the timer interrupt at the timer peripheral
      --  - Set the timer to fire for the next tick
      --
      Set_CNTHP_TVAL (CNTP_TVAL_Value);
      HiRTOS.Separation_Kernel.Interrupt_Handling.Tick_Timer_Interrupt_Handler;
   end Tick_Timer_Interrupt_Handler;

   function Get_CNTHP_CTL return CNTP_CTL_Type is
      CNTP_CTL_Value : CNTP_CTL_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 4, %0, c14, c2, 1",
         Outputs => CNTP_CTL_Type'Asm_Output ("=r", CNTP_CTL_Value), --  %0
         Volatile => True);

      return CNTP_CTL_Value;
   end Get_CNTHP_CTL;

   procedure Set_CNTHP_CTL (CNTP_CTL_Value : CNTP_CTL_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 4, %0, c14, c2, 1",
         Inputs => CNTP_CTL_Type'Asm_Input ("r", CNTP_CTL_Value), --  %0
         Volatile => True);
   end Set_CNTHP_CTL;

   function Get_CNTHP_TVAL return CNTP_TVAL_Type is
      CNTP_TVAL_Value : CNTP_TVAL_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 4, %0, c14, c2, 0",
         Outputs => CNTP_TVAL_Type'Asm_Output ("=r", CNTP_TVAL_Value), --  %0
         Volatile => True);

      return CNTP_TVAL_Value;
   end Get_CNTHP_TVAL;

   procedure Set_CNTHP_TVAL (CNTP_TVAL_Value : CNTP_TVAL_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 4, %0, c14, c2, 0",
         Inputs => CNTP_TVAL_Type'Asm_Input ("r", CNTP_TVAL_Value), --  %0
         Volatile => True);
   end Set_CNTHP_TVAL;

   function Get_CNTVOFF return CNTVOFF_Type is
      CNTVOFF_Value : CNTVOFF_Type;
   begin
      --  NOTE: Use "=&r" to ensure a different register is used
      System.Machine_Code.Asm (
         "mrrc p15, 4, %0, %1, c14",
         Outputs => [Interfaces.Unsigned_32'Asm_Output ("=r", CNTVOFF_Value.Low_Word),    --  %0
                     Interfaces.Unsigned_32'Asm_Output ("=&r", CNTVOFF_Value.High_Word)], --  %1
         Volatile => True);

      return CNTVOFF_Value;
   end Get_CNTVOFF;

   procedure Set_CNTVOFF (CNTVOFF_Value : CNTVOFF_Type) is
   begin
      System.Machine_Code.Asm (
         "mcrr p15, 4, %0, %1, c14",
         Inputs => [Interfaces.Unsigned_32'Asm_Input ("r", CNTVOFF_Value.Low_Word),    --  %0
                     Interfaces.Unsigned_32'Asm_Input ("r", CNTVOFF_Value.High_Word)], --  %1
         Volatile => True);
   end Set_CNTVOFF;

end HiRTOS_Cpu_Arch_Interface.Tick_Timer.Hypervisor;
