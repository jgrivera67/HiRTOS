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
with Memory_Utils;

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
      PMPCFG_Entry_Index : constant PMPCFG_Entry_Index_Type :=
         PMPCFG_Entry_Index_Type (Region_Id mod Num_PMPCFG_Entries);
   begin
      if Region_Id < Max_Num_Single_Entry_Memory_Regions then
         return PMPCFG_Value.Entries (PMPCFG_Entry_Index).Addr_Matching_Mode /= PMP_Region_Off;
      else
         pragma Assert (Region_Id mod 2 = 0);
         return PMPCFG_Value.Entries (PMPCFG_Entry_Index + 1).Addr_Matching_Mode /= PMP_Region_Off;
      end if;
   end Is_Memory_Region_Enabled;

   --
   --  If the size of the region is 2**(i + 3), the encoded size is
   --  a value whose lowest bit that is 0 is bit i
   --
   function Encode_NAPOT_Region_Size (Size_In_Bytes : Integer_Address) return Integer_Address with
      Pre => Is_Value_Power_Of_Two (Size_In_Bytes) and then
               Size_In_Bytes >= Min_NAPOT_Aligned_Size
   is
      Size_Log_Base_2 : constant Log_Base_2_Type := Get_Log_Base_2 (Size_In_Bytes);
   begin
      return Integer_Address ((2 ** (Size_Log_Base_2 - Log_Base_2_Min_NAPOT_Aligned_Size)) - 1);
   end Encode_NAPOT_Region_Size;

   function Decode_NAPOT_Region_Size (Encoded_Size_In_Bytes : Integer_Address) return Integer_Address with
      Pre => Is_Value_Power_Of_Two (Encoded_Size_In_Bytes + 1)
   is
      Size_Log_Base_2 : constant Log_Base_2_Type :=
         Get_Log_Base_2 (Encoded_Size_In_Bytes + 1) + Log_Base_2_Min_NAPOT_Aligned_Size;
   begin
      return Integer_Address (2 ** Size_Log_Base_2);
   end Decode_NAPOT_Region_Size;

   function Encode_Region_Start_Address (Start_Address : System.Address) return Integer_Address
      with Pre => To_Integer (Start_Address) mod Min_Region_Size_In_Bytes = 0
   is
   begin
      return To_Integer (Start_Address) / Min_Region_Size_In_Bytes;
   end Encode_Region_Start_Address;

   function Encode_Region_End_Address (End_Address : System.Address) return Integer_Address
      renames Encode_Region_Start_Address;

   function Decode_Region_Start_Address (Encoded_Start_Address : Integer_Address)
      return System.Address
   is (To_Address (Encoded_Start_Address * Min_Region_Size_In_Bytes));

   function Decode_Region_End_Address (Encoded_End_Address : Integer_Address)
      return System.Address
      renames Decode_Region_Start_Address;

   procedure Decode_NAPOT_PMPADDR (PMPADDR_Value : PMPADDR_Type;
                             Region_Start_Address : out System.Address;
                             Region_Size_In_Bytes : out Integer_Address) is
      Lowest_Zero_Bit_Index : constant Log_Base_2_Type :=
         Log_Base_2_Type (Count_Trailing_Zeros (not Cpu_Register_Type (PMPADDR_Value)));
      Encoded_Region_Size : constant Integer_Address := Integer_Address (2 ** Lowest_Zero_Bit_Index) - 1;
   begin
      Region_Size_In_Bytes := Decode_NAPOT_Region_Size (Encoded_Region_Size);
      Region_Start_Address := Decode_Region_Start_Address (Integer_Address (PMPADDR_Value) and not Encoded_Region_Size);
   end Decode_NAPOT_PMPADDR;

   procedure Initialize is
      procedure Disable_PMP_Entry (Region_Id : Memory_Region_Id_Type)
      is
         PMPCFG_Value : PMPCFG_Type;
      begin
         HiRTOS_Cpu_Arch_Interface.Memory_Barrier;
         PMPCFG_Value := Get_PMPCFG (Region_Id);
         PMPCFG_Value.Entries (PMPCFG_Entry_Index_Type (Region_Id mod Num_PMPCFG_Entries)).
            Addr_Matching_Mode := PMP_Region_Off;
         Set_PMPCFG (Region_Id, PMPCFG_Value);
      end Disable_PMP_Entry;

   begin
      --
      --  Disable all region descriptors:
      --
      for Region_Id in Memory_Region_Id_Type loop
         Disable_PMP_Entry (Region_Id);
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
      if Region_Id < Max_Num_Single_Entry_Memory_Regions then
         --
         --  Use a single-PMP-entry region descriptor:
         --
         pragma Assert (Is_Range_NAPOT_Aligned (Start_Address, Size_In_Bytes));
         Initialize_Memory_Region_Descriptor (Region_Descriptor,
                                              Start_Address,
                                              Size_In_Bytes,
                                              Unprivileged_Permissions,
                                              Privileged_Permissions,
                                              Region_Attributes,
                                              Is_Single_PMP_Entry => True);
      else
         --
         --  Use a two-PMP-entry region descriptor:
         --
         pragma Assert (Region_Id mod 2 = 0);
         Initialize_Memory_Region_Descriptor (Region_Descriptor,
                                              Start_Address,
                                              Size_In_Bytes,
                                              Unprivileged_Permissions,
                                              Privileged_Permissions,
                                              Region_Attributes,
                                              Is_Single_PMP_Entry => False);
      end if;

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
      Size_In_Bytes : constant System.Storage_Elements.Integer_Address :=
         To_Integer (End_Address) - To_Integer (Start_Address);
   begin
      Configure_Memory_Region (Region_Id,
                               Start_Address,
                               Size_In_Bytes,
                               Unprivileged_Permissions,
                               Privileged_Permissions,
                               Region_Attributes);
   end Configure_Memory_Region;

   procedure Initialize_Memory_Region_Descriptor (
      Region_Descriptor : out Memory_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bytes : System.Storage_Elements.Integer_Address;
      Unprivileged_Permissions : Region_Permissions_Type;
      Privileged_Permissions : Region_Permissions_Type with Unreferenced;
      Region_Attributes : Region_Attributes_Type with Unreferenced;
      Is_Single_PMP_Entry : Boolean)
   is
      End_Address : constant System.Address := To_Address (To_Integer (Start_Address) + Size_In_Bytes);
      PMPCFG_Entry : PMPCFG_Entry_Type;
   begin
      Region_Descriptor.Is_Single_PMP_Entry := Is_Single_PMP_Entry;
      if Is_Single_PMP_Entry then
         --
         --  Single-PMP-entry memory protection descriptor object using NAPOT mode:
         --
         --  NOTE: For NAPOT mode, the size of the region must be a power of two,
         --  encoded as the index of the lowest bit that is 0, as follows:
         --  If the lowest bit that is 0 in the PMPADDR register is bit i,
         --  (i: 0 .. 31), the size of the region is 2**(i + 3) and the
         --  base address must be a multiple of 2**(i + 1), so that all
         --  bits lower than bit i are also 0s in the base address.
         --
         Region_Descriptor.First_PMPADDR := PMPADDR_Type (
            Encode_Region_Start_Address (Start_Address) or
            Encode_NAPOT_Region_Size (Size_In_Bytes));

         PMPCFG_Entry.Addr_Matching_Mode := PMP_Region_NAPOT;

         declare
            Decoded_Region_Start_Address : System.Address;
            Decoded_Region_Size_In_Bytes : Integer_Address;
         begin
            Decode_NAPOT_PMPADDR (Region_Descriptor.First_PMPADDR, Decoded_Region_Start_Address,
                                  Decoded_Region_Size_In_Bytes);
            pragma Assert (Decoded_Region_Start_Address = Start_Address);
            pragma Assert (Decoded_Region_Size_In_Bytes = Size_In_Bytes);
         end;
      else
         --
         --  Two-PMP-entry descriptor, using TOR mode for the second PMP entry:
         --
         Region_Descriptor.First_PMPADDR := PMPADDR_Type (Encode_Region_Start_Address (Start_Address));
         Region_Descriptor.First_PMPCFG_Entry := (Addr_Matching_Mode => PMP_Region_Off, others => <>);
         Region_Descriptor.Second_PMPADDR := PMPADDR_Type (Encode_Region_End_Address (End_Address));
         PMPCFG_Entry.Addr_Matching_Mode := PMP_Region_TOR;
      end if;

      case Unprivileged_Permissions is
         when None =>
            PMPCFG_Entry.Locked_Entry := 1;
         when Read_Only =>
            PMPCFG_Entry.Read_Perm := 1;
            PMPCFG_Entry.Locked_Entry := 1;
         when Read_Write =>
            PMPCFG_Entry.Read_Perm := 1;
            PMPCFG_Entry.Write_Perm := 1;
         when Read_Execute =>
            PMPCFG_Entry.Read_Perm := 1;
            PMPCFG_Entry.Execute_Perm := 1;
            PMPCFG_Entry.Locked_Entry := 1;
         when Read_Write_Execute =>
            PMPCFG_Entry.Read_Perm := 1;
            PMPCFG_Entry.Write_Perm := 1;
            PMPCFG_Entry.Execute_Perm := 1;
      end case;

      if Is_Single_PMP_Entry then
         Region_Descriptor.First_PMPCFG_Entry := PMPCFG_Entry;
      else
         Region_Descriptor.Second_PMPCFG_Entry := PMPCFG_Entry;
      end if;
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
                                           Region_Attributes,
                                           Is_Single_PMP_Entry => False);
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

      if Region_Descriptor.Is_Single_PMP_Entry then
         Set_PMPADDR (Region_Id, Region_Descriptor.First_PMPADDR);
         PMPCFG_Value := Get_PMPCFG (Region_Id);
         PMPCFG_Value.Entries (PMPCFG_Entry_Index) := Region_Descriptor.First_PMPCFG_Entry;
         Set_PMPCFG (Region_Id, PMPCFG_Value);
      else
         --  Two PMP entry descriptor:
         pragma Assert (Region_Id mod 2 = 0);
         Set_PMPADDR (Region_Id, Region_Descriptor.First_PMPADDR);
         Set_PMPADDR (Region_Id + 1, Region_Descriptor.Second_PMPADDR);
         PMPCFG_Value := Get_PMPCFG (Region_Id);
         PMPCFG_Value.Entries (PMPCFG_Entry_Index) := Region_Descriptor.First_PMPCFG_Entry;
         PMPCFG_Value.Entries (PMPCFG_Entry_Index + 1) := Region_Descriptor.Second_PMPCFG_Entry;
         Set_PMPCFG (Region_Id, PMPCFG_Value);
      end if;

      HiRTOS_Cpu_Arch_Interface.Memory_Barrier;

      --  End critical section
      HiRTOS_Cpu_Arch_Interface.Restore_Cpu_Interrupting (Old_Cpu_Interrupting);
   end Restore_Memory_Region_Descriptor;

   procedure Initialize_Memory_Region_Descriptor_Disabled (
      Region_Descriptor : out Memory_Region_Descriptor_Type) is
   begin
      Region_Descriptor.Is_Single_PMP_Entry := False;
      Region_Descriptor.First_PMPCFG_Entry := (Addr_Matching_Mode => PMP_Region_Off, others => <>);
      Region_Descriptor.Second_PMPCFG_Entry := (Addr_Matching_Mode => PMP_Region_Off, others => <>);
   end Initialize_Memory_Region_Descriptor_Disabled;

   procedure Save_Memory_Region_Descriptor (
      Region_Id : Memory_Region_Id_Type;
      Region_Descriptor : out Memory_Region_Descriptor_Type) is
      PMPCFG_Value : PMPCFG_Type;
      PMPCFG_Entry_Index : constant PMPCFG_Entry_Index_Type :=
         PMPCFG_Entry_Index_Type (Region_Id mod Num_PMPCFG_Entries);
   begin
      Region_Descriptor.Is_Single_PMP_Entry := False;
      Region_Descriptor.First_PMPADDR := Get_PMPADDR (Region_Id);
      Region_Descriptor.Second_PMPADDR := Get_PMPADDR (Region_Id + 1);
      PMPCFG_Value := Get_PMPCFG (Region_Id);
      Region_Descriptor.First_PMPCFG_Entry := PMPCFG_Value.Entries (PMPCFG_Entry_Index);
      Region_Descriptor.Second_PMPCFG_Entry := PMPCFG_Value.Entries (PMPCFG_Entry_Index + 1);
   end Save_Memory_Region_Descriptor;

   procedure Enable_Memory_Protection (Enable_Background_Region : Boolean with Unreferenced) is
   begin
      --  The PMP is enabled by default
      null;
   end Enable_Memory_Protection;

   procedure Disable_Memory_Protection is
   begin
      --  The PMP cannot be disabled
      null;
   end Disable_Memory_Protection;

   procedure Get_NAPOT_Aligned_Range (Start_Address : System.Address;
                                      Size_In_Bytes : Integer_Address;
                                      Aligned_Start_Address : out System.Address;
                                      Aligned_Size_In_Bytes : out Integer_Address)
      with Pre => Size_In_Bytes in 1 .. 2 ** (Integer_Address'Size - 1),
            Post => Memory_Utils.Is_Subrange_Of_Address_Range (Start_Address, Size_In_Bytes,
                                                               Aligned_Start_Address, Aligned_Size_In_Bytes)
   is
      Nearest_Log_Of_2_Ceiling : constant Log_Base_2_Type := Get_Log_Base_2 (Size_In_Bytes) + 1;
      Nearest_Power_Of_2_Ceiling : constant Integer_Address := 2 ** Nearest_Log_Of_2_Ceiling;
   begin
      if Nearest_Power_Of_2_Ceiling < Min_NAPOT_Aligned_Size then
         Aligned_Size_In_Bytes := Min_NAPOT_Aligned_Size;
      else
         Aligned_Size_In_Bytes := Nearest_Power_Of_2_Ceiling;
      end if;

      loop
         Aligned_Start_Address := To_Address (Memory_Utils.Round_Down (To_Integer (Start_Address),
                                                                        Aligned_Size_In_Bytes));
         exit when Memory_Utils.Is_Subrange_Of_Address_Range (Start_Address, Size_In_Bytes,
                                                               Aligned_Start_Address, Aligned_Size_In_Bytes);

         Aligned_Size_In_Bytes := @ * 2; --  next power of 2
      end loop;
   end Get_NAPOT_Aligned_Range;

end HiRTOS_Cpu_Arch_Interface.Memory_Protection;
