--
--  Copyright (c) 2023, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary ARMv8-R EL2-controlled MPU
--

with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor.EL2_MPU with SPARK_Mode => On is

   function Get_HMPUIR return HMPUIR_Type is
      HMPUIR_Value : HMPUIR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 4, %0, c0, c0, 4",
         Outputs => HMPUIR_Type'Asm_Output ("=r", HMPUIR_Value), --  %0
         Volatile => True);

      return HMPUIR_Value;
   end Get_HMPUIR;

   function Get_HPRBAR return PRBAR_Type is
      HPRBAR_Value : PRBAR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 4, %0, c6, c3, 0",
         Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value), --  %0
         Volatile => True);

      return HPRBAR_Value;
   end Get_HPRBAR;

   function Get_HPRBAR (Region_Id : Memory_Region_Id_Type) return PRBAR_Type is
      HPRBAR_Value : PRBAR_Type;
   begin
      --  To access HPRBAR0 to HPRBAR15:
      --  MRC p15, 4, <Rt>, c6, c8+n[3:1], 4*n[0]
      --  To access HPRBAR16 to HPRBAR24:
      --  MRC p15, 5, <Rt>, c6, c8+n[3:1], 4*n[0]
      case Region_Id is
         when 0 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c8, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 1 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c8, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 2 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c9, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 3 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c9, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 4 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c10, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 5 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c10, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 6 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c11, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 7 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c11, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 8 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c12, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 9 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c12, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 10 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c13, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 11 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c13, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 12 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c14, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 13 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c14, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 14 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c15, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 15 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c15, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 16 =>
            System.Machine_Code.Asm (
               "mrc p15, 5, %0, c6, c8, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 17 =>
            System.Machine_Code.Asm (
               "mrc p15, 5, %0, c6, c8, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 18 =>
            System.Machine_Code.Asm (
               "mrc p15, 5, %0, c6, c9, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 19 =>
            System.Machine_Code.Asm (
               "mrc p15, 5, %0, c6, c9, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 20 =>
            System.Machine_Code.Asm (
               "mrc p15, 5, %0, c6, c10, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 21 =>
            System.Machine_Code.Asm (
               "mrc p15, 5, %0, c6, c10, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 22 =>
            System.Machine_Code.Asm (
               "mrc p15, 5, %0, c6, c11, 0",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);
         when 23 =>
            System.Machine_Code.Asm (
               "mrc p15, 5, %0, c6, c11, 4",
               Outputs => PRBAR_Type'Asm_Output ("=r", HPRBAR_Value),   -- %0
               Volatile => True);

         when others =>
            --
            --  NOTE: For Region_Id >= 24, direct access to the corresponding HPRBARx
            --  is no supported. So, we have to use HPRSELR and HPRBAR.
            --  We disable interrupts, so that we don't have to save/restore HPRSELR
            --  on context switches.
            --
            declare
               Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
               HPRSELR_Value : constant PRSELR_Type :=
                  (REGION => Region_Id_Selector_Type (Region_Id), others => <>);
            begin
               --  Begin critical section
               Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
               Set_HPRSELR (HPRSELR_Value);
               HPRBAR_Value := Get_HPRBAR;
               --  End critical section
               HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
            end;
      end case;

      return HPRBAR_Value;
   end Get_HPRBAR;

   procedure Set_HPRBAR (HPRBAR_Value : PRBAR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 4, %0, c6, c3, 0",
         Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
         Volatile => True);
   end Set_HPRBAR;

   procedure Set_HPRBAR (Region_Id : Memory_Region_Id_Type; HPRBAR_Value : PRBAR_Type) is
   begin
      --  To access HPRBAR0 to HPRBAR15:
      --  MCR p15, 4, <Rt>, c6, c8+n[3:1], 4*n[0]
      --  To access HPRBAR16 to HPRBAR24:
      --  MCR p15, 5, <Rt>, c6, c8+n[3:1], 4*n[0]
      case Region_Id is
         when 0 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c8, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 1 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c8, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 2 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c9, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 3 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c9, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 4 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c10, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 5 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c10, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 6 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c11, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 7 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c11, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 8 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c12, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 9 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c12, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 10 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c13, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 11 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c13, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 12 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c14, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 13 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c14, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 14 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c15, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 15 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c15, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 16 =>
            System.Machine_Code.Asm (
               "mcr p15, 5, %0, c6, c8, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 17 =>
            System.Machine_Code.Asm (
               "mcr p15, 5, %0, c6, c8, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 18 =>
            System.Machine_Code.Asm (
               "mcr p15, 5, %0, c6, c9, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 19 =>
            System.Machine_Code.Asm (
               "mcr p15, 5, %0, c6, c9, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 20 =>
            System.Machine_Code.Asm (
               "mcr p15, 5, %0, c6, c10, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 21 =>
            System.Machine_Code.Asm (
               "mcr p15, 5, %0, c6, c10, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 22 =>
            System.Machine_Code.Asm (
               "mcr p15, 5, %0, c6, c11, 0",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);
         when 23 =>
            System.Machine_Code.Asm (
               "mcr p15, 5, %0, c6, c11, 4",
               Inputs => PRBAR_Type'Asm_Input ("r", HPRBAR_Value), --  %0
               Volatile => True);

         when others =>
            --
            --  NOTE: For Region_Id >= 24, direct access to the corresponding HPRBARx
            --  is no supported. So, we have to use HPRSELR and HPRBAR.
            --  We disable interrupts, so that we don't have to save/restore HPRSELR
            --  on context switches.
            --
            declare
               Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
               HPRSELR_Value : constant PRSELR_Type :=
                  (REGION => Region_Id_Selector_Type (Region_Id), others => <>);
            begin
               --  Begin critical section
               Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
               Set_HPRSELR (HPRSELR_Value);
               Set_HPRBAR (HPRBAR_Value);
               --  End critical section
               HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
            end;
      end case;
   end Set_HPRBAR;

   function Get_HPRLAR return PRLAR_Type is
      HPRLAR_Value : PRLAR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 4, %0, c6, c3, 1",
         Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value), --  %0
         Volatile => True);

      return HPRLAR_Value;
   end Get_HPRLAR;

   function Get_HPRLAR (Region_Id : Memory_Region_Id_Type) return PRLAR_Type is
      HPRLAR_Value : PRLAR_Type;
   begin
      --  To access HPRLAR0 to HPRLAR15:
      --  MRC p15, 4, <Rt>, c6, c8+n[3:1], 4*n[0]+1
      --  To access HPRLAR16 to HPRLAR24:
      --  MRC p15, 5, <Rt>, c6, c8+n[3:1], 4*n[0]+1
      case Region_Id is
         when 0 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c8, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 1 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c8, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 2 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c9, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 3 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c9, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 4 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c10, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 5 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c10, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 6 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c11, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 7 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c11, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 8 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c12, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 9 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c12, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 10 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c13, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 11 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c13, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 12 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c14, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 13 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c14, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 14 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c15, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 15 =>
            System.Machine_Code.Asm (
               "mrc p15, 4, %0, c6, c15, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 16 =>
            System.Machine_Code.Asm (
               "mrc p15, 5, %0, c6, c8, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 17 =>
            System.Machine_Code.Asm (
               "mrc p15, 5, %0, c6, c8, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 18 =>
            System.Machine_Code.Asm (
               "mrc p15, 5, %0, c6, c9, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 19 =>
            System.Machine_Code.Asm (
               "mrc p15, 5, %0, c6, c9, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 20 =>
            System.Machine_Code.Asm (
               "mrc p15, 5, %0, c6, c10, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 21 =>
            System.Machine_Code.Asm (
               "mrc p15, 5, %0, c6, c10, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 22 =>
            System.Machine_Code.Asm (
               "mrc p15, 5, %0, c6, c11, 1",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);
         when 23 =>
            System.Machine_Code.Asm (
               "mrc p15, 5, %0, c6, c11, 5",
               Outputs => PRLAR_Type'Asm_Output ("=r", HPRLAR_Value),   -- %0
               Volatile => True);

         when others =>
            --
            --  NOTE: For Region_Id >= 24, direct access to the corresponding HPRLARx
            --  is no supported. So, we have to use HPRSELR and HPRLAR.
            --  We disable interrupts, so that we don't have to save/restore HPRSELR
            --  on context switches.
            --
            declare
               Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
               HPRSELR_Value : constant PRSELR_Type :=
                  (REGION => Region_Id_Selector_Type (Region_Id), others => <>);
            begin
               --  Begin critical section
               Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
               Set_HPRSELR (HPRSELR_Value);
               HPRLAR_Value := Get_HPRLAR;
               --  End critical section
               HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
            end;
      end case;

      return HPRLAR_Value;
   end Get_HPRLAR;

   procedure Set_HPRLAR (HPRLAR_Value : PRLAR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 4, %0, c6, c3, 1",
         Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
         Volatile => True);
   end Set_HPRLAR;

   procedure Set_HPRLAR (Region_Id : Memory_Region_Id_Type; HPRLAR_Value : PRLAR_Type) is
   begin
      --  To access HPRLAR0 to HPRLAR15:
      --  MCR p15, 4, <Rt>, c6, c8+n[3:1], 4*n[0]+1
      --  To access HPRLAR16 to HPRLAR24:
      --  MCR p15, 5, <Rt>, c6, c8+n[3:1], 4*n[0]+1
      case Region_Id is
         when 0 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c8, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 1 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c8, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 2 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c9, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 3 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c9, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 4 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c10, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 5 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c10, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 6 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c11, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 7 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c11, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 8 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c12, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 9 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c12, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 10 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c13, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 11 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c13, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 12 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c14, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 13 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c14, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 14 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c15, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 15 =>
            System.Machine_Code.Asm (
               "mcr p15, 4, %0, c6, c15, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 16 =>
            System.Machine_Code.Asm (
               "mcr p15, 5, %0, c6, c8, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 17 =>
            System.Machine_Code.Asm (
               "mcr p15, 5, %0, c6, c8, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 18 =>
            System.Machine_Code.Asm (
               "mcr p15, 5, %0, c6, c9, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 19 =>
            System.Machine_Code.Asm (
               "mcr p15, 5, %0, c6, c9, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 20 =>
            System.Machine_Code.Asm (
               "mcr p15, 5, %0, c6, c10, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 21 =>
            System.Machine_Code.Asm (
               "mcr p15, 5, %0, c6, c10, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 22 =>
            System.Machine_Code.Asm (
               "mcr p15, 5, %0, c6, c11, 1",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);
         when 23 =>
            System.Machine_Code.Asm (
               "mcr p15, 5, %0, c6, c11, 5",
               Inputs => PRLAR_Type'Asm_Input ("r", HPRLAR_Value), --  %0
               Volatile => True);

         when others =>
            --
            --  NOTE: For Region_Id >= 24, direct access to the corresponding HPRLARx
            --  is no supported. So, we have to use HPRSELR and HPRLAR.
            --  We disable interrupts, so that we don't have to save/restore HPRSELR
            --  on context switches.
            --
            declare
               Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
               HPRSELR_Value : constant PRSELR_Type :=
                  (REGION => Region_Id_Selector_Type (Region_Id), others => <>);
            begin
               --  Begin critical section
               Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
               Set_HPRSELR (HPRSELR_Value);
               Set_HPRLAR (HPRLAR_Value);
               --  End critical section
               HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
            end;
      end case;
   end Set_HPRLAR;

   function Get_HPRSELR return PRSELR_Type is
      HPRSELR_Value : PRSELR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 4, %0, c6, c2, 1",
         Outputs => PRSELR_Type'Asm_Output ("=r", HPRSELR_Value), --  %0
         Volatile => True);

      return HPRSELR_Value;
   end Get_HPRSELR;

   procedure Set_HPRSELR (HPRSELR_Value : PRSELR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 4, %0, c6, c2, 1",
         Inputs => PRSELR_Type'Asm_Input ("r", HPRSELR_Value), --  %0
         Volatile => True);
   end Set_HPRSELR;

   function Get_HMAIR_Pair return MAIR_Pair_Type is
      MAIR_Pair : MAIR_Pair_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 4, %0, c10, c2, 0",
         Outputs => Interfaces.Unsigned_32'Asm_Output ("=r", MAIR_Pair.MAIR0), --  %0
         Volatile => True);

      System.Machine_Code.Asm (
         "mrc p15, 4, %0, c10, c2, 1",
         Outputs => Interfaces.Unsigned_32'Asm_Output ("=r", MAIR_Pair.MAIR1), --  %0
         Volatile => True);

      return MAIR_Pair;
   end Get_HMAIR_Pair;

   procedure Set_HMAIR_Pair (MAIR_Pair : MAIR_Pair_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 4, %0, c10, c2, 0",
         Inputs => Interfaces.Unsigned_32'Asm_Input ("r", MAIR_Pair.MAIR0), --  %0
         Volatile => True);

      System.Machine_Code.Asm (
         "mcr p15, 4, %0, c10, c2, 1",
         Inputs => Interfaces.Unsigned_32'Asm_Input ("r", MAIR_Pair.MAIR1), --  %0
         Volatile => True);
   end Set_HMAIR_Pair;

   function Get_HPRENR return HPRENR_Type is
      HPRENR_Value : HPRENR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 4, %0, c6, c1, 1",
         Outputs => HPRENR_Type'Asm_Output ("=r", HPRENR_Value), --  %0
         Volatile => True);

      return HPRENR_Value;
   end Get_HPRENR;

   procedure Set_HPRENR (HPRENR_Value : HPRENR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 4, %0, c6, c2, 1",
         Inputs => HPRENR_Type'Asm_Input ("r", HPRENR_Value), --  %0
         Volatile => True);
   end Set_HPRENR;

   function Get_HDFAR return DFAR_Type is
      DFAR_Value : DFAR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 4, %0, c6, c0, 0",
         Outputs => DFAR_Type'Asm_Output ("=r", DFAR_Value), --  %0
         Volatile => True);

      return DFAR_Value;
   end Get_HDFAR;

   function Get_HIFAR return IFAR_Type is
      IFAR_Value : IFAR_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 4, %0, c6, c0, 2",
         Outputs => IFAR_Type'Asm_Output ("=r", IFAR_Value), --  %0
         Volatile => True);

      return IFAR_Value;
   end Get_HIFAR;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection.Hypervisor.EL2_MPU;
