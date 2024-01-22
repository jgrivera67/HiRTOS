--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Memory protection services
--  for ARMv8-R EL1 MPU
--

with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface.Memory_Protection.EL1_MPU with SPARK_Mode => On is

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
               "mrc p15, 1, %0, c6, c8, 0",
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
         when others =>
            --
            --  NOTE: For Region_Id >= 24, direct access to the corresponding PRBARx
            --  is no supported. So, we have to use PRSELR and PRBAR.
            --  We disable interrupts, so that we don't have to save/restore PRSELR
            --  on context switches.
            --
            declare
               Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
               PRSELR_Value : constant PRSELR_Type :=
                  (REGION => Region_Id_Selector_Type (Region_Id), others => <>);
            begin
               --  Begin critical section
               Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
               Set_PRSELR (PRSELR_Value);
               PRBAR_Value := Get_PRBAR;
               --  End critical section
               HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
            end;
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
               "mcr p15, 1, %0, c6, c8, 0",
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

         when others =>
            --
            --  NOTE: For Region_Id >= 24, direct access to the corresponding PRBARx
            --  is no supported. So, we have to use PRSELR and PRBAR.
            --  We disable interrupts, so that we don't have to save/restore PRSELR
            --  on context switches.
            --
            declare
               Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
               PRSELR_Value : constant PRSELR_Type :=
                  (REGION => Region_Id_Selector_Type (Region_Id), others => <>);
            begin
               --  Begin critical section
               Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
               Set_PRSELR (PRSELR_Value);
               Set_PRBAR (PRBAR_Value);
               --  End critical section
               HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
            end;
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
               "mrc p15, 1, %0, c6, c8, 1",
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

         when others =>
            --
            --  NOTE: For Region_Id >= 24, direct access to the corresponding PRLARx
            --  is no supported. So, we have to use PRSELR and PRLAR.
            --  We disable interrupts, so that we don't have to save/restore PRSELR
            --  on context switches.
            --
            declare
               Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
               PRSELR_Value : constant PRSELR_Type :=
                  (REGION => Region_Id_Selector_Type (Region_Id), others => <>);
            begin
               --  Begin critical section
               Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
               Set_PRSELR (PRSELR_Value);
               PRLAR_Value := Get_PRLAR;
               --  End critical section
               HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
            end;
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
               "mcr p15, 1, %0, c6, c8, 1",
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

         when others =>
            --
            --  NOTE: For Region_Id >= 24, direct access to the corresponding PRLARx
            --  is no supported. So, we have to use PRSELR and PRLAR.
            --  We disable interrupts, so that we don't have to save/restore PRSELR
            --  on context switches.
            --
            declare
               Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
               PRSELR_Value : constant PRSELR_Type :=
                  (REGION => Region_Id_Selector_Type (Region_Id), others => <>);
            begin
               --  Begin critical section
               Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;
               Set_PRSELR (PRSELR_Value);
               Set_PRLAR (PRLAR_Value);
               --  End critical section
               HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
            end;
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

   function Get_MAIR_Pair return MAIR_Pair_Type is
      MAIR_Pair : MAIR_Pair_Type;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c10, c2, 0",
         Outputs => Interfaces.Unsigned_32'Asm_Output ("=r", MAIR_Pair.MAIR0), --  %0
         Volatile => True);

      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c10, c2, 1",
         Outputs => Interfaces.Unsigned_32'Asm_Output ("=r", MAIR_Pair.MAIR1), --  %0
         Volatile => True);

      return MAIR_Pair;
   end Get_MAIR_Pair;

   procedure Set_MAIR_Pair (MAIR_Pair : MAIR_Pair_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c10, c2, 0",
         Inputs => Interfaces.Unsigned_32'Asm_Input ("r", MAIR_Pair.MAIR0), --  %0
         Volatile => True);

      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c10, c2, 1",
         Inputs => Interfaces.Unsigned_32'Asm_Input ("r", MAIR_Pair.MAIR1), --  %0
         Volatile => True);
   end Set_MAIR_Pair;

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

   procedure Set_DFSR (DFSR_Value : DFSR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c5, c0, 0",
         Inputs => DFSR_Type'Asm_Input ("r", DFSR_Value), --  %0
         Volatile => True);
   end Set_DFSR;

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

   procedure Set_IFSR (IFSR_Value : IFSR_Type) is
   begin
      System.Machine_Code.Asm (
         "mcr p15, 0, %0, c5, c0, 1",
         Inputs => IFSR_Type'Asm_Input ("r", IFSR_Value), --  %0
         Volatile => True);
   end Set_IFSR;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection.EL1_MPU;
