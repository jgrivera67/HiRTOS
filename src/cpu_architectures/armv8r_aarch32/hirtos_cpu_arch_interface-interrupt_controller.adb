--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
--

--
--  @summary RTOS to target platform interface - Interrupt controller driver
--

with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface.Interrupt_Controller with SPARK_Mode => On is

   procedure Initialize is
      IMP_CBAR_Value : constant IMP_CBAR_Type := Get_IMP_CBAR;
   begin
      pragma Assert (IMP_CBAR_Value.RES0 = 0);
      pragma Assert (False); --???
   end Initialize;

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

   --  Get base address of the GIC registers
   function Get_IMP_CBAR return IMP_CBAR_Type is
      IMP_CBAR_Value : IMP_CBAR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 1, %0, c15, c3, 0",
         Outputs => IMP_CBAR_Type'Asm_Output ("=r", IMP_CBAR_Value), --  %0
         Volatile => True);

      return IMP_CBAR_Value;
   end Get_IMP_CBAR;

   function Get_ICC_IAR0 return ICC_IAR_Type is
      ICC_IAR_Value : ICC_IAR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c12, c8, 0",
         Outputs => ICC_IAR_Type'Asm_Output ("=r", ICC_IAR_Value), --  %0
         Volatile => True);

      return ICC_IAR_Value;
   end Get_ICC_IAR0;

   procedure Set_ICC_IAR0 (ICC_IAR_Value : ICC_IAR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c12, c8, 0",
         Inputs => ICC_IAR_Type'Asm_Input ("r", ICC_IAR_Value), --  %0
         Volatile => True);
   end Set_ICC_IAR0;

   function Get_ICC_IAR1 return ICC_IAR_Type is
      ICC_IAR_Value : ICC_IAR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c12, c12, 0",
         Outputs => ICC_IAR_Type'Asm_Output ("=r", ICC_IAR_Value), --  %0
         Volatile => True);

      return ICC_IAR_Value;
   end Get_ICC_IAR1;

   procedure Set_ICC_IAR1 (ICC_IAR_Value : ICC_IAR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c12, c12, 0",
         Inputs => ICC_IAR_Type'Asm_Input ("r", ICC_IAR_Value), --  %0
         Volatile => True);
   end Set_ICC_IAR1;

   function Get_ICC_EOIR0 return ICC_EOIR_Type is
      ICC_EOIR_Value : ICC_EOIR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c12, c8, 1",
         Outputs => ICC_EOIR_Type'Asm_Output ("=r", ICC_EOIR_Value), --  %0
         Volatile => True);

      return ICC_EOIR_Value;
   end Get_ICC_EOIR0;

   procedure Set_ICC_EOIR0 (ICC_EOIR_Value : ICC_EOIR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c12, c8, 1",
         Inputs => ICC_EOIR_Type'Asm_Input ("r", ICC_EOIR_Value), --  %0
         Volatile => True);
   end Set_ICC_EOIR0;

   function Get_ICC_EOIR1 return ICC_EOIR_Type is
      ICC_EOIR_Value : ICC_EOIR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c12, c12, 1",
         Outputs => ICC_EOIR_Type'Asm_Output ("=r", ICC_EOIR_Value), --  %0
         Volatile => True);

      return ICC_EOIR_Value;
   end Get_ICC_EOIR1;

   procedure Set_ICC_EOIR1 (ICC_EOIR_Value : ICC_EOIR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c12, c12, 1",
         Inputs => ICC_EOIR_Type'Asm_Input ("r", ICC_EOIR_Value), --  %0
         Volatile => True);
   end Set_ICC_EOIR1;

   function Get_ICC_HPPIR0 return ICC_HPPIR_Type is
      ICC_HPPIR_Value : ICC_HPPIR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c12, c8, 2",
         Outputs => ICC_HPPIR_Type'Asm_Output ("=r", ICC_HPPIR_Value), --  %0
         Volatile => True);

      return ICC_HPPIR_Value;
   end Get_ICC_HPPIR0;

   procedure Set_ICC_HPPIR0 (ICC_HPPIR_Value : ICC_HPPIR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c12, c8, 2",
         Inputs => ICC_HPPIR_Type'Asm_Input ("r", ICC_HPPIR_Value), --  %0
         Volatile => True);
   end Set_ICC_HPPIR0;

   function Get_ICC_HPPIR1 return ICC_HPPIR_Type is
      ICC_HPPIR_Value : ICC_HPPIR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c12, c12, 2",
         Outputs => ICC_HPPIR_Type'Asm_Output ("=r", ICC_HPPIR_Value), --  %0
         Volatile => True);

      return ICC_HPPIR_Value;
   end Get_ICC_HPPIR1;

   procedure Set_ICC_HPPIR1 (ICC_HPPIR_Value : ICC_HPPIR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c12, c12, 2",
         Inputs => ICC_HPPIR_Type'Asm_Input ("r", ICC_HPPIR_Value), --  %0
         Volatile => True);
   end Set_ICC_HPPIR1;

   function Get_ICC_BPR0 return ICC_BPR_Type is
      ICC_BPR_Value : ICC_BPR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c12, c8, 3",
         Outputs => ICC_BPR_Type'Asm_Output ("=r", ICC_BPR_Value), --  %0
         Volatile => True);

      return ICC_BPR_Value;
   end Get_ICC_BPR0;

   procedure Set_ICC_BPR0 (ICC_BPR_Value : ICC_BPR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c12, c8, 3",
         Inputs => ICC_BPR_Type'Asm_Input ("r", ICC_BPR_Value), --  %0
         Volatile => True);
   end Set_ICC_BPR0;

   function Get_ICC_BPR1 return ICC_BPR_Type is
      ICC_BPR_Value : ICC_BPR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c12, c12, 3",
         Outputs => ICC_BPR_Type'Asm_Output ("=r", ICC_BPR_Value), --  %0
         Volatile => True);

      return ICC_BPR_Value;
   end Get_ICC_BPR1;

   procedure Set_ICC_BPR1 (ICC_BPR_Value : ICC_BPR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c12, c12, 3",
         Inputs => ICC_BPR_Type'Asm_Input ("r", ICC_BPR_Value), --  %0
         Volatile => True);
   end Set_ICC_BPR1;

   function Get_ICC_DIR return ICC_DIR_Type is
      ICC_DIR_Value : ICC_DIR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c12, c11, 1",
         Outputs => ICC_DIR_Type'Asm_Output ("=r", ICC_DIR_Value), --  %0
         Volatile => True);

      return ICC_DIR_Value;
   end Get_ICC_DIR;

   procedure Set_ICC_DIR (ICC_DIR_Value : ICC_DIR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c12, c11, 1",
         Inputs => ICC_DIR_Type'Asm_Input ("r", ICC_DIR_Value), --  %0
         Volatile => True);
   end Set_ICC_DIR;

   function Get_ICC_PMR return ICC_PMR_Type is
      ICC_PMR_Value : ICC_PMR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c4, c6, 0",
         Outputs => ICC_PMR_Type'Asm_Output ("=r", ICC_PMR_Value), --  %0
         Volatile => True);

      return ICC_PMR_Value;
   end Get_ICC_PMR;

   procedure Set_ICC_PMR (ICC_PMR_Value : ICC_PMR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c4, c6, 0",
         Inputs => ICC_PMR_Type'Asm_Input ("r", ICC_PMR_Value), --  %0
         Volatile => True);
   end Set_ICC_PMR;

   function Get_ICC_CTLR return ICC_CTLR_Type is
      ICC_CTLR_Value : ICC_CTLR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c12, c12, 4",
         Outputs => ICC_CTLR_Type'Asm_Output ("=r", ICC_CTLR_Value), --  %0
         Volatile => True);

      return ICC_CTLR_Value;
   end Get_ICC_CTLR;

   procedure Set_ICC_CTLR (ICC_CTLR_Value : ICC_CTLR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c12, c12, 4",
         Inputs => ICC_CTLR_Type'Asm_Input ("r", ICC_CTLR_Value), --  %0
         Volatile => True);
   end Set_ICC_CTLR;

   function Get_ICC_IGRPEN0 return ICC_IGRPEN_Type is
      ICC_IGRPEN_Value : ICC_IGRPEN_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c12, c12, 6",
         Outputs => ICC_IGRPEN_Type'Asm_Output ("=r", ICC_IGRPEN_Value), --  %0
         Volatile => True);

      return ICC_IGRPEN_Value;
   end Get_ICC_IGRPEN0;

   procedure Set_ICC_IGRPEN0 (ICC_IGRPEN_Value : ICC_IGRPEN_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c12, c12, 6",
         Inputs => ICC_IGRPEN_Type'Asm_Input ("r", ICC_IGRPEN_Value), --  %0
         Volatile => True);
   end Set_ICC_IGRPEN0;

   function Get_ICC_IGRPEN1 return ICC_IGRPEN_Type is
      ICC_IGRPEN_Value : ICC_IGRPEN_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c12, c12, 7",
         Outputs => ICC_IGRPEN_Type'Asm_Output ("=r", ICC_IGRPEN_Value), --  %0
         Volatile => True);

      return ICC_IGRPEN_Value;
   end Get_ICC_IGRPEN1;

   procedure Set_ICC_IGRPEN1 (ICC_IGRPEN_Value : ICC_IGRPEN_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c12, c12, 7",
         Inputs => ICC_IGRPEN_Type'Asm_Input ("r", ICC_IGRPEN_Value), --  %0
         Volatile => True);
   end Set_ICC_IGRPEN1;

   procedure Set_ICC_SGIR0 (ICC_SGIR_Value : ICC_SGIR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcrr p15, 2, %0, %1, c12",
         Inputs => [Interfaces.Unsigned_32'Asm_Input ("r", ICC_SGIR_Value.Lower_Word),  --  %0
                    Interfaces.Unsigned_32'Asm_Input ("r", ICC_SGIR_Value.Upper_Word)], --  %1
         Volatile => True);
   end Set_ICC_SGIR0;

   procedure Set_ICC_SGIR1 (ICC_SGIR_Value : ICC_SGIR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcrr p15, 0, %0, %1, c12",
         Inputs => [Interfaces.Unsigned_32'Asm_Input ("r", ICC_SGIR_Value.Lower_Word),  --  %0
                    Interfaces.Unsigned_32'Asm_Input ("r", ICC_SGIR_Value.Upper_Word)], --  %1
         Volatile => True);
   end Set_ICC_SGIR1;

end HiRTOS_Cpu_Arch_Interface.Interrupt_Controller;
