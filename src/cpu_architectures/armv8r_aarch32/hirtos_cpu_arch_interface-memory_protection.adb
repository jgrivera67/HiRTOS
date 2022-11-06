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
--  @summary RTOS to target platform interface - Memory protection services
--  for ARMv8-R MPU
--

with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface.Memory_Protection with SPARK_Mode => On is

   procedure Enable_Memory_Protection is
   begin
      pragma Assert (False); -- ????
   end Enable_Memory_Protection;

   procedure Disable_Memory_Protection is
   begin
      pragma Assert (False); -- ????
   end Disable_Memory_Protection;

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Permissions : Region_Permissions_Type) is
   begin
      pragma Assert (False); --  ???
   end Initialize_Memory_Region_Descriptor;

   procedure Restore_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : Memory_Region_Descriptor_Type) is
   begin
      pragma Assert (False); --  ???
   end Restore_Memory_Region_Descriptor;

   procedure Save_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : out Memory_Region_Descriptor_Type) is
   begin
      pragma Assert (False); --  ???
   end Save_Memory_Region_Descriptor;

   ----------------------------------------------------------------------------
   --  Private Subprograms
   ----------------------------------------------------------------------------

   function Get_MPUIR return MPUIR_Type is
      MPUIR_Value : MPUIR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c0, c0, 4",
         Outputs => MPUIR_Type'Asm_Output ("=r", MPUIR_Value), --  %0
         Volatile => True);

      return MPUIR_Value;
   end Get_MPUIR;

   function Get_PRBAR return PRBAR_Type is
      PRBAR_Value : PRBAR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c6, c3, 0",
         Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value), --  %0
         Volatile => True);

      return PRBAR_Value;
   end Get_PRBAR;

   function Get_PRBAR (Region_Id : Memory_Region_Id_Type) return PRBAR_Type is
      PRBAR_Value : PRBAR_Type;
   begin
      --  To access PRBAR0 to PRBAR15:
      --  MRC p15, 0, <Rt>, c6, c8+n[3:1], 4*n[0]
      --  To access PRBAR16 to PRBAR24:
      --  MRC p15, 1, <Rt>, c6, c8+n[3:1], 4*n[0]
      case Region_Id is
         when 0 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c8, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 1 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c8, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 2 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c9, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 3 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c9, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 4 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c10, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 5 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c10, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 6 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c11, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 7 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c11, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 8 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c12, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 9 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c12, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 10 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c13, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 11 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c13, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 12 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c14, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 13 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c14, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 14 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c15, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 15 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c15, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 16 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c8, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 17 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c8, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 18 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c9, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 19 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c9, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 20 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c10, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 21 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c10, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 22 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c11, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
         when 23 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c11, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", PRBAR_Value),   -- %0
               Volatile => True);
      end case;

      return PRBAR_Value;
   end Get_PRBAR;

   procedure Set_PRBAR (PRBAR_Value : PRBAR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c6, c3, 0",
         Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
         Volatile => True);
   end Set_PRBAR;

   procedure Set_PRBAR (Region_Id : Memory_Region_Id_Type; PRBAR_Value : PRBAR_Type) is
   begin
      --  To access PRBAR0 to PRBAR15:
      --  MCR p15, 0, <Rt>, c6, c8+n[3:1], 4*n[0]
      --  To access PRBAR16 to PRBAR24:
      --  MCR p15, 1, <Rt>, c6, c8+n[3:1], 4*n[0]
      case Region_Id is
         when 0 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c8, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 1 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c8, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 2 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c9, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 3 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c9, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 4 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c10, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 5 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c10, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 6 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c11, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 7 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c11, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 8 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c12, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 9 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c12, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 10 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c13, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 11 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c13, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 12 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c14, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 13 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c14, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 14 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c15, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 15 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c15, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 16 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c8, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 17 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c8, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 18 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c9, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 19 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c9, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 20 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c10, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 21 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c10, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 22 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c11, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
         when 23 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c11, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", PRBAR_Value), --  %0
               Volatile => True);
      end case;
   end Set_PRBAR;

   function Get_PRLAR return PRLAR_Type is
      PRLAR_Value : PRLAR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c6, c3, 1",
         Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value), --  %0
         Volatile => True);

      return PRLAR_Value;
   end Get_PRLAR;

   function Get_PRLAR (Region_Id : Memory_Region_Id_Type) return PRLAR_Type is
      PRLAR_Value : PRLAR_Type;
   begin
      --  To access PRLAR0 to PRLAR15:
      --  MRC p15, 0, <Rt>, c6, c8+n[3:1], 4*n[0]+1
      --  To access PRLAR16 to PRLAR24:
      --  MRC p15, 1, <Rt>, c6, c8+n[3:1], 4*n[0]+1
      case Region_Id is
         when 0 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c8, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 1 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c8, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 2 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c9, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 3 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c9, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 4 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c10, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 5 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c10, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 6 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c11, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 7 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c11, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 8 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c12, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 9 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c12, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 10 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c13, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 11 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c13, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 12 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c14, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 13 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c14, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 14 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c15, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 15 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c15, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 16 =>
            System.Machine_Code.Asm (
               "mrc p15, 0, %0, c6, c8, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 17 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c8, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 18 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c9, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 19 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c9, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 20 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c10, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 21 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c10, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 22 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c11, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
         when 23 =>
            System.Machine_Code.Asm (
               "mrc p15, 1, %0, c6, c11, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", PRLAR_Value),   -- %0
               Volatile => True);
      end case;

      return PRLAR_Value;
   end Get_PRLAR;

   procedure Set_PRLAR (PRLAR_Value : PRLAR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c6, c3, 1",
         Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
         Volatile => True);
   end Set_PRLAR;

   procedure Set_PRLAR (Region_Id : Memory_Region_Id_Type; PRLAR_Value : PRLAR_Type) is
   begin
      --  To access PRLAR0 to PRLAR15:
      --  MCR p15, 0, <Rt>, c6, c8+n[3:1], 4*n[0]+1
      --  To access PRLAR16 to PRLAR24:
      --  MCR p15, 1, <Rt>, c6, c8+n[3:1], 4*n[0]+1
      case Region_Id is
         when 0 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c8, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 1 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c8, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 2 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c9, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 3 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c9, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 4 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c10, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 5 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c10, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 6 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c11, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 7 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c11, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 8 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c12, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 9 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c12, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 10 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c13, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 11 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c13, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 12 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c14, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 13 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c14, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 14 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c15, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 15 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c15, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 16 =>
            System.Machine_Code.Asm (
               "mcr p15, 0, %0, c6, c8, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 17 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c8, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 18 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c9, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 19 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c9, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 20 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c10, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 21 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c10, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 22 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c11, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
         when 23 =>
            System.Machine_Code.Asm (
               "mcr p15, 1, %0, c6, c11, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", PRLAR_Value), --  %0
               Volatile => True);
      end case;
   end Set_PRLAR;

   function Get_PRSELR return PRSELR_Type is
      PRSELR_Value : PRSELR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c6, c2, 1",
         Outputs => PRSELR_Type'Asm_Output ("=r", PRSELR_Value), --  %0
         Volatile => True);

      return PRSELR_Value;
   end Get_PRSELR;

   procedure Set_PRSELR (PRSELR_Value : PRSELR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c6, c2, 1",
         Inputs => PRSELR_Type'Asm_Input ("r", PRSELR_Value), --  %0
         Volatile => True);
   end Set_PRSELR;

   function Get_DFAR return DFAR_Type is
      DFAR_Value : DFAR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c6, c0, 0",
         Outputs => DFAR_Type'Asm_Output ("=r", DFAR_Value), --  %0
         Volatile => True);

      return DFAR_Value;
   end Get_DFAR;

   function Get_DFSR return DFSR_Type is
      DFSR_Value : DFSR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c5, c0, 0",
         Outputs => DFSR_Type'Asm_Output ("=r", DFSR_Value), --  %0
         Volatile => True);

      return DFSR_Value;
   end Get_DFSR;

   function Get_IFAR return IFAR_Type is
      IFAR_Value : IFAR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c6, c0, 2",
         Outputs => IFAR_Type'Asm_Output ("=r", IFAR_Value), --  %0
         Volatile => True);

      return IFAR_Value;
   end Get_IFAR;

   function Get_IFSR return IFSR_Type is
      IFSR_Value : IFSR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c5, c0, 1",
         Outputs => IFSR_Type'Asm_Output ("=r", IFSR_Value), --  %0
         Volatile => True);

      return IFSR_Value;
   end Get_IFSR;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection;
