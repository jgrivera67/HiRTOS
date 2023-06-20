--
--  Copyright (c) 2023, German Rivera
--  All rights reserved.
--
--  SPDX-License-Identifier: BSD-3-Clause
--

--
--  @summary RTOS to target platform interface - Interrupt controller driver
--  for ARMv8-R hypervisor
--

package body HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Hypervisor with
  SPARK_Mode => Off
is
   procedure Initialize_Interrupts_Enabled_Bitmap (
      Interrupts_Enabled_Bitmap : out Interrupts_Enabled_Bitmap_Type) is
   begin
      Interrupts_Enabled_Bitmap := [others => (As_Word => True, Value => 0)];
   end Initialize_Interrupts_Enabled_Bitmap;

   procedure Save_Interrupts_Enabled_Bitmap (
      Interrupts_Enabled_Bitmap : out Interrupts_Enabled_Bitmap_Type) is
      GIC_ISENABLER_Value : GIC_ISENABLER_Type;
      Cpu_Id              : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      GICR                : GICR_Type renames GICD.GICR_Array (Cpu_Id);
   begin
      --
      --  Save PPIs enabled/disabled:
      --
      GIC_ISENABLER_Value := GICR.GICR_SGI_And_PPI_Page.GICR_ISENABLER0;
      Interrupts_Enabled_Bitmap (0).Bits_Array := GIC_Interrupt_Bit_Mask_Type (GIC_ISENABLER_Value);

      --
      --  Save SPIs enabled/disabled:
      --
      for I in GICD.GICD_ISENABLER_Array'Range loop
         GIC_ISENABLER_Value := GICD.GICD_ISENABLER_Array (I);
         Interrupts_Enabled_Bitmap (I + 1).Bits_Array := GIC_Interrupt_Bit_Mask_Type (GIC_ISENABLER_Value);
      end loop;

   end Save_Interrupts_Enabled_Bitmap;

   procedure Restore_Interrupts_Enabled_Bitmap (
      Interrupts_Enabled_Bitmap : Interrupts_Enabled_Bitmap_Type) is
      use type Interfaces.Unsigned_32;
      GIC_ISENABLER_Value : GIC_ISENABLER_Type;
      GIC_ICENABLER_Value : GIC_ICENABLER_Type;
      Cpu_Id              : constant Valid_Cpu_Core_Id_Type := Get_Cpu_Id;
      GICR                : GICR_Type renames GICD.GICR_Array (Cpu_Id);
      Negated_Bit_Mask    : Interrupt_Bitmap_Chunk_Type;
   begin
      --
      --  Restore PPIs enabled/disabled:
      --
      GIC_ISENABLER_Value := GIC_ISENABLER_Type (Interrupts_Enabled_Bitmap (0).Bits_Array);
      GICR.GICR_SGI_And_PPI_Page.GICR_ISENABLER0 := GIC_ISENABLER_Value;
      Negated_Bit_Mask.Value := not Interrupts_Enabled_Bitmap (0).Value;
      GIC_ICENABLER_Value := GIC_ICENABLER_Type (Negated_Bit_Mask.Bits_Array);
      GICR.GICR_SGI_And_PPI_Page.GICR_ICENABLER0 := GIC_ICENABLER_Value;

      --
      --  Restore SPIs enabled/disabled:
      --
      for I in GICD.GICD_ISENABLER_Array'Range loop
         GIC_ISENABLER_Value := GIC_ISENABLER_Type (Interrupts_Enabled_Bitmap (I + 1).Bits_Array);
         GICD.GICD_ISENABLER_Array (I) := GIC_ISENABLER_Value;
         Negated_Bit_Mask.Value := not Interrupts_Enabled_Bitmap (I + 1).Value;
         GIC_ICENABLER_Value := GIC_ICENABLER_Type (Negated_Bit_Mask.Bits_Array);
         GICD.GICD_ICENABLER_Array (I) := GIC_ICENABLER_Value;
      end loop;
   end Restore_Interrupts_Enabled_Bitmap;

end HiRTOS_Cpu_Arch_Interface.Interrupt_Controller.Hypervisor;
