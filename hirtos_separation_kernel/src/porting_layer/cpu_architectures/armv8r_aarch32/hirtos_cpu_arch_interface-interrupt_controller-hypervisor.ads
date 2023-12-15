--
--  Copyright (c) 2023, German Rivera
--  
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - Interrupt controller driver
--  for ARMv8-R hypervisor
--

package HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Hypervisor with
  SPARK_Mode => On
is

   type Interrupts_Enabled_Bitmap_Type is private;

   ----------------------------------------------------------------------------
   --  Public Subprograms
   ----------------------------------------------------------------------------

   procedure Initialize_Interrupts_Enabled_Bitmap (
      Interrupts_Enabled_Bitmap : out Interrupts_Enabled_Bitmap_Type)
      with Pre => Cpu_In_Hypervisor_Mode;

   procedure Save_Interrupts_Enabled_Bitmap (
      Interrupts_Enabled_Bitmap : out Interrupts_Enabled_Bitmap_Type)
      with Pre => Cpu_In_Hypervisor_Mode;

   procedure Restore_Interrupts_Enabled_Bitmap (
      Interrupts_Enabled_Bitmap : Interrupts_Enabled_Bitmap_Type)
      with Pre => Cpu_In_Hypervisor_Mode;

private
   type Interrupt_Bitmap_Chunk_Type (As_Word : Boolean := True) is record
       case As_Word is
          when True =>
             Value : Interfaces.Unsigned_32 := 0;
          when False =>
             Bits_Array : GIC_Interrupt_Bit_Mask_Type;
       end case;
   end record with
        Size => 32, Unchecked_Union;

   --
   --  Saved PPI/SPI interrupts enabled:
   --  - Entry 0 is for the 32 PPI interrupts
   --  - Entries 1 .. 30 are for SPI interrupts, in group of 32 interrupts.
   --
   type Interrupts_Enabled_Bitmap_Type is array (0 .. 30) of Interrupt_Bitmap_Chunk_Type;

end HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Hypervisor;
