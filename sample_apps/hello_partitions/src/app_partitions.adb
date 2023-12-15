--
--  Copyright (c) 2022-2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

with HiRTOS.Separation_Kernel.Partition;
with HiRTOS_Platform_Parameters;
with HiRTOS_Cpu_Arch_Parameters;
with System.Storage_Elements;
with Interfaces;
with HiRTOS.Debug; --???

package body App_Partitions is
   use System.Storage_Elements;
   use type System.Address;

   Hello_Partition1_Image_Address : constant System.Address
      with Import,
           Convention => Asm,
           External_Name => "hello_partition1_image_addr";

   Hello_Partition1_Image_Size_Bytes : constant System.Storage_Elements.Integer_Address
      with Import,
           Convention => Asm,
           External_Name => "hello_partition1_size";

   Hello_Partition1_Load_Address : constant System.Address
      with Import,
           Convention => Asm,
           External_Name => "hello_partition1_load_addr";

   Hello_Partition2_Image_Address : constant System.Address
      with Import,
           Convention => Asm,
           External_Name => "hello_partition2_image_addr";

   Hello_Partition2_Image_Size_Bytes : constant System.Storage_Elements.Integer_Address
      with Import,
           Convention => Asm,
           External_Name => "hello_partition2_size";

   Hello_Partition2_Load_Address : constant System.Address
      with Import,
           Convention => Asm,
           External_Name => "hello_partition2_load_addr";

   Per_Partittion_TCM_Size_Bytes : constant := 512 * 1024;

   -----------------------------------------------------------------------------
   --  Private Subprograms Specifications                                     --
   -----------------------------------------------------------------------------

   procedure Load_Partition (Image_Address : System.Address;
                             Image_Size_Bytes : System.Storage_Elements.Integer_Address;
                             Load_Address : System.Address)
      with Pre => Image_Size_Bytes /= 0 and then
                  Image_Size_Bytes mod HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  Load_Address /= Image_Address and then
                  To_Integer (Image_Address) mod HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  To_Integer (Load_Address) mod HiRTOS_Cpu_Arch_Parameters.Memory_Region_Alignment = 0 and then
                  Load_Address >= HiRTOS_Platform_Parameters.Stacks_Section_End_Address;

   -----------------------------------------------------------------------------
   --  Public Subprograms                                                     --
   -----------------------------------------------------------------------------

   procedure Initialize is
      use type HiRTOS.Separation_Kernel.Partition_Id_Type;
      Partition1_Id : HiRTOS.Separation_Kernel.Valid_Partition_Id_Type;
      Partition2_Id : HiRTOS.Separation_Kernel.Valid_Partition_Id_Type;
      Global_Mmio_Region_Size_In_Bytes : constant Integer_Address :=
         To_Integer (HiRTOS_Platform_Parameters.Global_Mmio_Region_End_Address) -
         To_Integer (HiRTOS_Platform_Parameters.Global_Mmio_Region_Start_Address);

   begin
      Load_Partition (Hello_Partition1_Image_Address,
                      Hello_Partition1_Image_Size_Bytes,
                      Hello_Partition1_Load_Address);

      pragma Assert (To_Integer (Hello_Partition2_Load_Address) >=
                     To_Integer (Hello_Partition1_Load_Address) + Hello_Partition1_Image_Size_Bytes);

      Load_Partition (Hello_Partition2_Image_Address,
                      Hello_Partition2_Image_Size_Bytes,
                      Hello_Partition2_Load_Address);

      HiRTOS.Separation_Kernel.Partition.Create_Partition (
         Reset_Handler_Address => Hello_Partition1_Load_Address,
         Interrupt_Vector_Table_Address => Hello_Partition1_Load_Address,
         TCM_Base_Address => Hello_Partition1_Load_Address,
         TCM_Size_In_Bytes => Per_Partittion_TCM_Size_Bytes,
         SRAM_Base_Address => System.Null_Address,
         SRAM_Size_In_Bytes => 0,
         --  TODO: Use only a subrange of MMIO space
         MMIO_Base_Address => HiRTOS_Platform_Parameters.Global_Mmio_Region_Start_Address,
         MMIO_Size_In_Bytes => Global_Mmio_Region_Size_In_Bytes,
         Partition_Id => Partition1_Id);

      pragma Assert (Partition1_Id /= HiRTOS.Separation_Kernel.Invalid_Partition_Id);

      HiRTOS.Separation_Kernel.Partition.Create_Partition (
         Reset_Handler_Address => Hello_Partition2_Load_Address,
         Interrupt_Vector_Table_Address => Hello_Partition2_Load_Address,
         TCM_Base_Address => Hello_Partition2_Load_Address,
         TCM_Size_In_Bytes => Per_Partittion_TCM_Size_Bytes,
         SRAM_Base_Address => System.Null_Address,
         SRAM_Size_In_Bytes => 0,
         --  TODO: Use only a subrange of MMIO space
         MMIO_Base_Address => HiRTOS_Platform_Parameters.Global_Mmio_Region_Start_Address,
         MMIO_Size_In_Bytes => Global_Mmio_Region_Size_In_Bytes,
         Partition_Id => Partition2_Id);

         pragma Assert (Partition2_Id /= HiRTOS.Separation_Kernel.Invalid_Partition_Id);
   end Initialize;

   -----------------------------------------------------------------------------
   --  Private Subprograms                                                    --
   -----------------------------------------------------------------------------

   procedure Load_Partition (Image_Address : System.Address;
                             Image_Size_Bytes : System.Storage_Elements.Integer_Address;
                             Load_Address : System.Address) is
      Num_Words : constant Integer_Address :=
         Image_Size_Bytes / (Interfaces.Unsigned_32'Size / System.Storage_Unit);
      type Image_Type is array (1 .. Num_Words) of Interfaces.Unsigned_32;

      Source_Image : Image_Type with Import, Address => Image_Address;
      Dest_Image : Image_Type with Import, Address => Load_Address;
   begin
      HiRTOS.Debug.Print_String ("Image_Address " ); --???
      HiRTOS.Debug.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (To_Integer (Image_Address)), End_Line => True);  --???
      HiRTOS.Debug.Print_String ("Image_Size " ); --???
      HiRTOS.Debug.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (Image_Size_Bytes), End_Line => True);  --???
      HiRTOS.Debug.Print_String ("Load_Address " ); --???
      HiRTOS.Debug.Print_Number_Hexadecimal (Interfaces.Unsigned_32 (To_Integer (Load_Address)), End_Line => True);  --???

      Dest_Image := Source_Image;
   end Load_Partition;

end App_Partitions;
