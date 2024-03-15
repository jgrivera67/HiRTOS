--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Memory protection services
--  for the RISCV PMP
--

with System.Machine_Code;

package body HiRTOS_Cpu_Arch_Interface.Memory_Protection with SPARK_Mode => On is

   function Get_PMPADDR (Region_Id : Memory_Region_Id_Type) return PMPADDR_Type is
      PMPADDR_Value : PMPADDR_Type;
   begin
      case Region_Id is
         when 0 =>
            System.Machine_Code.Asm (
               "csrr  %0,  pmpaddr0",
               Outputs => PMPADDR_Type'Asm_Output ("=r", PMPADDR_Value),   -- %0
               Volatile => True);
         when 1 =>
            System.Machine_Code.Asm (
               "csrr  %0,  pmpaddr1",
               Outputs => PMPADDR_Type'Asm_Output ("=r", PMPADDR_Value),   -- %0
               Volatile => True);
         when 2 =>
            System.Machine_Code.Asm (
               "csrr  %0,  pmpaddr2",
               Outputs => PMPADDR_Type'Asm_Output ("=r", PMPADDR_Value),   -- %0
               Volatile => True);
         when 3 =>
            System.Machine_Code.Asm (
               "csrr  %0,  pmpaddr3",
               Outputs => PMPADDR_Type'Asm_Output ("=r", PMPADDR_Value),   -- %0
               Volatile => True);
         when 4 =>
            System.Machine_Code.Asm (
               "csrr  %0,  pmpaddr4",
               Outputs => PMPADDR_Type'Asm_Output ("=r", PMPADDR_Value),   -- %0
               Volatile => True);
         when 5 =>
            System.Machine_Code.Asm (
               "csrr  %0,  pmpaddr5",
               Outputs => PMPADDR_Type'Asm_Output ("=r", PMPADDR_Value),   -- %0
               Volatile => True);
         when 6 =>
            System.Machine_Code.Asm (
               "csrr  %0,  pmpaddr6",
               Outputs => PMPADDR_Type'Asm_Output ("=r", PMPADDR_Value),   -- %0
               Volatile => True);
         when 7 =>
            System.Machine_Code.Asm (
               "csrr  %0,  pmpaddr7",
               Outputs => PMPADDR_Type'Asm_Output ("=r", PMPADDR_Value),   -- %0
               Volatile => True);
         when 8 =>
            System.Machine_Code.Asm (
               "csrr  %0,  pmpaddr8",
               Outputs => PMPADDR_Type'Asm_Output ("=r", PMPADDR_Value),   -- %0
               Volatile => True);
         when 9 =>
            System.Machine_Code.Asm (
               "csrr  %0,  pmpaddr9",
               Outputs => PMPADDR_Type'Asm_Output ("=r", PMPADDR_Value),   -- %0
               Volatile => True);
         when 10 =>
            System.Machine_Code.Asm (
               "csrr  %0,  pmpaddr10",
               Outputs => PMPADDR_Type'Asm_Output ("=r", PMPADDR_Value),   -- %0
               Volatile => True);
         when 11 =>
            System.Machine_Code.Asm (
               "csrr  %0,  pmpaddr11",
               Outputs => PMPADDR_Type'Asm_Output ("=r", PMPADDR_Value),   -- %0
               Volatile => True);
         when 12 =>
            System.Machine_Code.Asm (
               "csrr  %0,  pmpaddr12",
               Outputs => PMPADDR_Type'Asm_Output ("=r", PMPADDR_Value),   -- %0
               Volatile => True);
         when 13 =>
            System.Machine_Code.Asm (
               "csrr  %0,  pmpaddr13",
               Outputs => PMPADDR_Type'Asm_Output ("=r", PMPADDR_Value),   -- %0
               Volatile => True);
         when 14 =>
            System.Machine_Code.Asm (
               "csrr  %0,  pmpaddr14",
               Outputs => PMPADDR_Type'Asm_Output ("=r", PMPADDR_Value),   -- %0
               Volatile => True);
         when 15 =>
            System.Machine_Code.Asm (
               "csrr  %0,  pmpaddr15",
               Outputs => PMPADDR_Type'Asm_Output ("=r", PMPADDR_Value),   -- %0
               Volatile => True);
      end case;

      return PMPADDR_Value;
   end Get_PMPADDR;

   procedure Set_PMPADDR (Region_Id : Memory_Region_Id_Type; PMPADDR_Value : PMPADDR_Type) is
   begin
      case Region_Id is
         when 0 =>
            System.Machine_Code.Asm (
               "csrw pmpaddr0, %0",
               Inputs => PMPADDR_Type'Asm_Input ("r", PMPADDR_Value), --  %0
               Volatile => True);
         when 1 =>
            System.Machine_Code.Asm (
               "csrw pmpaddr1, %0",
               Inputs => PMPADDR_Type'Asm_Input ("r", PMPADDR_Value), --  %0
               Volatile => True);
         when 2 =>
            System.Machine_Code.Asm (
               "csrw pmpaddr2, %0",
               Inputs => PMPADDR_Type'Asm_Input ("r", PMPADDR_Value), --  %0
               Volatile => True);
         when 3 =>
            System.Machine_Code.Asm (
               "csrw pmpaddr3, %0",
               Inputs => PMPADDR_Type'Asm_Input ("r", PMPADDR_Value), --  %0
               Volatile => True);
         when 4 =>
            System.Machine_Code.Asm (
               "csrw pmpaddr4, %0",
               Inputs => PMPADDR_Type'Asm_Input ("r", PMPADDR_Value), --  %0
               Volatile => True);
         when 5 =>
            System.Machine_Code.Asm (
               "csrw pmpaddr5, %0",
               Inputs => PMPADDR_Type'Asm_Input ("r", PMPADDR_Value), --  %0
               Volatile => True);
         when 6 =>
            System.Machine_Code.Asm (
               "csrw pmpaddr6, %0",
               Inputs => PMPADDR_Type'Asm_Input ("r", PMPADDR_Value), --  %0
               Volatile => True);
         when 7 =>
            System.Machine_Code.Asm (
               "csrw pmpaddr7, %0",
               Inputs => PMPADDR_Type'Asm_Input ("r", PMPADDR_Value), --  %0
               Volatile => True);
         when 8 =>
            System.Machine_Code.Asm (
               "csrw pmpaddr8, %0",
               Inputs => PMPADDR_Type'Asm_Input ("r", PMPADDR_Value), --  %0
               Volatile => True);
         when 9 =>
            System.Machine_Code.Asm (
               "csrw pmpaddr9, %0",
               Inputs => PMPADDR_Type'Asm_Input ("r", PMPADDR_Value), --  %0
               Volatile => True);
         when 10 =>
            System.Machine_Code.Asm (
               "csrw pmpaddr10, %0",
               Inputs => PMPADDR_Type'Asm_Input ("r", PMPADDR_Value), --  %0
               Volatile => True);
         when 11 =>
            System.Machine_Code.Asm (
               "csrw pmpaddr11, %0",
               Inputs => PMPADDR_Type'Asm_Input ("r", PMPADDR_Value), --  %0
               Volatile => True);
         when 12 =>
            System.Machine_Code.Asm (
               "csrw pmpaddr12, %0",
               Inputs => PMPADDR_Type'Asm_Input ("r", PMPADDR_Value), --  %0
               Volatile => True);
         when 13 =>
            System.Machine_Code.Asm (
               "csrw pmpaddr13, %0",
               Inputs => PMPADDR_Type'Asm_Input ("r", PMPADDR_Value), --  %0
               Volatile => True);
         when 14 =>
            System.Machine_Code.Asm (
               "csrw pmpaddr14, %0",
               Inputs => PMPADDR_Type'Asm_Input ("r", PMPADDR_Value), --  %0
               Volatile => True);
         when 15 =>
            System.Machine_Code.Asm (
               "csrw pmpaddr15, %0",
               Inputs => PMPADDR_Type'Asm_Input ("r", PMPADDR_Value), --  %0
               Volatile => True);
      end case;
   end Set_PMPADDR;

   function Get_PMPCFG (Region_Id : Memory_Region_Id_Type) return PMPCFG_Type is
      PMPCFG_Value : PMPCFG_Type;
   begin
      if Region_Id < 4 then
         System.Machine_Code.Asm (
            "csrr  %0,  pmpcfg0",
            Outputs => PMPCFG_Type'Asm_Output ("=r", PMPCFG_Value),   -- %0
            Volatile => True);
      elsif Region_Id < 8 then
         System.Machine_Code.Asm (
            "csrr  %0,  pmpcfg1",
            Outputs => PMPCFG_Type'Asm_Output ("=r", PMPCFG_Value),   -- %0
            Volatile => True);
      elsif Region_Id < 12 then
         System.Machine_Code.Asm (
            "csrr  %0,  pmpcfg2",
            Outputs => PMPCFG_Type'Asm_Output ("=r", PMPCFG_Value),   -- %0
            Volatile => True);
      else
         System.Machine_Code.Asm (
            "csrr  %0,  pmpcfg3",
            Outputs => PMPCFG_Type'Asm_Output ("=r", PMPCFG_Value),   -- %0
            Volatile => True);
      end if;

      return PMPCFG_Value;
   end Get_PMPCFG;

   procedure Set_PMPCFG (Region_Id : Memory_Region_Id_Type; PMPCFG_Value : PMPCFG_Type) is
   begin
      if Region_Id < 4 then
         System.Machine_Code.Asm (
            "csrw  pmpcfg0, %0",
            Inputs => PMPCFG_Type'Asm_Input ("r", PMPCFG_Value), --  %0
            Volatile => True);
      elsif Region_Id < 8 then
         System.Machine_Code.Asm (
            "csrw  pmpcfg1, %0",
            Inputs => PMPCFG_Type'Asm_Input ("r", PMPCFG_Value), --  %0
            Volatile => True);
      elsif Region_Id < 12 then
         System.Machine_Code.Asm (
            "csrw  pmpcfg2, %0",
            Inputs => PMPCFG_Type'Asm_Input ("r", PMPCFG_Value), --  %0
            Volatile => True);
      else
         System.Machine_Code.Asm (
            "csrw  pmpcfg3, %0",
            Inputs => PMPCFG_Type'Asm_Input ("r", PMPCFG_Value), --  %0
            Volatile => True);
      end if;
   end Set_PMPCFG;

   function Is_Memory_Region_Enabled (Region_Id : Memory_Region_Id_Type) return Boolean
   is
      PMPCFG_Value : constant PMPCFG_Type := Get_PMPCFG (Region_Id);
   begin
      return PMPCFG_Value.Entries (PMPCFG_Entry_Index_Type (Region_Id mod Num_PMPCFG_Entries)).
               Addr_Matching_Mode /= PMP_Region_Off;
   end Is_Memory_Region_Enabled;

   procedure Initialize is
   begin
      --
      --  Disable all region descriptors:
      --
      for Region_Id in Memory_Region_Id_Type loop
         Disable_Memory_Region (Region_Id);
      end loop;
   end Initialize;

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
   is
      Region_Descriptor : Memory_Region_Descriptor_Type;
   begin
      Initialize_Memory_Region_Descriptor (Region_Descriptor,
                                           Start_Address,
                                           Size_In_Bytes,
                                           Unprivileged_Permissions,
                                           Privileged_Permissions,
                                           Region_Attributes);
      Restore_Memory_Region_Descriptor (Region_Id, Region_Descriptor);
   end Configure_Memory_Region;

   procedure Configure_Memory_Region (
      Region_Id : Memory_Region_Id_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
   is
      Region_Descriptor : Memory_Region_Descriptor_Type;
   begin
      Initialize_Memory_Region_Descriptor (Region_Descriptor,
                                           Start_Address,
                                           End_Address,
                                           Unprivileged_Permissions,
                                           Privileged_Permissions,
                                           Region_Attributes);
      Restore_Memory_Region_Descriptor (Region_Id, Region_Descriptor);
   end Configure_Memory_Region;

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type with Unreferenced;
      Region_Attributes : Region_Attributes_Type with Unreferenced)
   is
      --
      --  If the size of the region is 2**(i + 3), the encoded size is
      --  a value whose lowest bit that is 0 is bit i
      --
      function Encode_NAPOT_Region_Size (Size_In_Bytes : System.Storage_Elements.Integer_Address)
         return Interfaces.Unsigned_32 with
         Pre => Is_Value_Power_Of_Two (Size_In_Bytes) and then
                Size_In_Bytes >= 2**3
      is
         Log_Base_2 : constant Natural range 3 .. 31 :=
            Natural (31 - Count_Leading_Zeros (Cpu_Register_Type (Size_In_Bytes)));
      begin
         return Interfaces.Shift_Left (Interfaces.Unsigned_32 (1), Log_Base_2 - 3) - 1;
      end Encode_NAPOT_Region_Size;

   begin
      Region_Descriptor.PMPADDR := PMPADDR_Type (
         Interfaces.Unsigned_32 (To_Integer (Start_Address)) or
         Encode_NAPOT_Region_Size (Size_In_Bytes));
      Region_Descriptor.PMPCFG_Entry := (Addr_Matching_Mode => PMP_Region_NAPOT, others => <>);
      case Unprivileged_Permissions is
         when Read_Write =>
            Region_Descriptor.PMPCFG_Entry.Read_Perm := 1;
            Region_Descriptor.PMPCFG_Entry.Write_Perm := 1;
         when Read_Only =>
            Region_Descriptor.PMPCFG_Entry.Read_Perm := 1;
         when Read_Execute =>
            Region_Descriptor.PMPCFG_Entry.Read_Perm := 1;
            Region_Descriptor.PMPCFG_Entry.Execute_Perm := 1;
         when others =>
            pragma Assert (False);
      end case;
   end Initialize_Memory_Region_Descriptor;

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      End_Address : System.Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type;
      Region_Attributes : Region_Attributes_Type)
   is
      Size_In_Bytes : constant System.Storage_Elements.Integer_Address :=
         To_Integer (End_Address) - To_Integer (Start_Address);
   begin
      Initialize_Memory_Region_Descriptor (Region_Descriptor,
                                           Start_Address,
                                           Size_In_Bytes,
                                           Unprivileged_Permissions,
                                           Privileged_Permissions,
                                           Region_Attributes);
   end Initialize_Memory_Region_Descriptor;

   procedure Restore_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : Memory_Region_Descriptor_Type) is
      PMPCFG_Value : PMPCFG_Type;
      Old_Cpu_Interrupting : HiRTOS_Cpu_Arch_Interface.Cpu_Register_Type;
      PMPCFG_Entry_Index : constant PMPCFG_Entry_Index_Type :=
         PMPCFG_Entry_Index_Type (Region_Id mod Num_PMPCFG_Entries);
   begin
      --  Begin critical section
      Old_Cpu_Interrupting := HiRTOS_Cpu_Arch_Interface.Disable_Cpu_Interrupting;

      --
      --  NOTE: Before changing the address range associate with the region in the
      --  PMP, it is safer to disable the region.
      --
      PMPCFG_Value := Get_PMPCFG (Region_Id);
      PMPCFG_Value.Entries (PMPCFG_Entry_Index) :=
         (Addr_Matching_Mode => PMP_Region_Off, others => <>);
      Set_PMPCFG (Region_Id, PMPCFG_Value);

      Set_PMPADDR (Region_Id, Region_Descriptor.PMPADDR);
      PMPCFG_Value.Entries (PMPCFG_Entry_Index) := Region_Descriptor.PMPCFG_Entry;
      Set_PMPCFG (Region_Id, PMPCFG_Value);
      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;

      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
   end Restore_Memory_Region_Descriptor;

   procedure Initialize_Memory_Region_Descriptor_Disabled (
      Region_Descriptor : out Memory_Region_Descriptor_Type) is
   begin
      Region_Descriptor.PMPCFG_Entry := (Addr_Matching_Mode => PMP_Region_Off, others => <>);
   end Initialize_Memory_Region_Descriptor_Disabled;

   procedure Save_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : out Memory_Region_Descriptor_Type) is
      PMPCFG_Value : PMPCFG_Type;
      PMPCFG_Entry_Index : constant PMPCFG_Entry_Index_Type :=
         PMPCFG_Entry_Index_Type (Region_Id mod Num_PMPCFG_Entries);
   begin
      Region_Descriptor.PMPADDR := Get_PMPADDR (Region_Id);
      PMPCFG_Value := Get_PMPCFG (Region_Id);
      Region_Descriptor.PMPCFG_Entry := PMPCFG_Value.Entries (PMPCFG_Entry_Index);
   end Save_Memory_Region_Descriptor;

   procedure Disable_Memory_Region (Region_Id : Memory_Region_Id_Type)
   is
      PMPCFG_Value : PMPCFG_Type;
   begin
      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
      PMPCFG_Value := Get_PMPCFG (Region_Id);
      PMPCFG_Value.Entries (PMPCFG_Entry_Index_Type (Region_Id mod Num_PMPCFG_Entries)).
         Addr_Matching_Mode := PMP_Region_Off;
      Set_PMPCFG (Region_Id, PMPCFG_Value);
   end Disable_Memory_Region;

   procedure Enable_Memory_Region (Region_Id : Memory_Region_Id_Type)
   is
      PMPCFG_Value : PMPCFG_Type;
   begin
      PMPCFG_Value := Get_PMPCFG (Region_Id);
      PMPCFG_Value.Entries (PMPCFG_Entry_Index_Type (Region_Id mod Num_PMPCFG_Entries)).
         Addr_Matching_Mode := PMP_Region_NAPOT;
      Set_PMPCFG (Region_Id, PMPCFG_Value);
      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
   end Enable_Memory_Region;

   procedure Enable_Memory_Protection (Enable_Background_Region : Boolean with Unreferenced) is
   begin
      null;
   end Enable_Memory_Protection;

   procedure Disable_Memory_Protection is
   begin
      null;
   end Disable_Memory_Protection;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection;
