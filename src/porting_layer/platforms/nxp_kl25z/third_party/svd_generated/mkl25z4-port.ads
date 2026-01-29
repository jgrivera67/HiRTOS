--  Redistribution and use in source and binary forms, with or without modification,
--  are permitted provided that the following conditions are met:
--   o Redistributions of source code must retain the above copyright notice, this list
--   of conditions and the following disclaimer.
--   o Redistributions in binary form must reproduce the above copyright notice, this
--   list of conditions and the following disclaimer in the documentation and/or
--   other materials provided with the distribution.
--   o Neither the name of Freescale Semiconductor, Inc. nor the names of its
--   contributors may be used to endorse or promote products derived from this
--   software without specific prior written permission.
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
--   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
--   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--   DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
--   ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
--   (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
--   ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--  This spec has been automatically generated from MKL25Z4.svd

with System;

package MKL25Z4.PORT is

   ---------------
   -- Registers --
   ---------------

   --  Pull Select
   type PCR_PS_Field is
     (
      --  Internal pulldown resistor is enabled on the corresponding pin, if
      --  the corresponding Port Pull Enable field is set.
      PCR_PS_Field_0,
      --  Internal pullup resistor is enabled on the corresponding pin, if the
      --  corresponding Port Pull Enable field is set.
      PCR_PS_Field_1)
     with Size => 1;
   for PCR_PS_Field use
     (PCR_PS_Field_0 => 0,
      PCR_PS_Field_1 => 1);

   --  Pull Enable
   type PCR_PE_Field is
     (
      --  Internal pullup or pulldown resistor is not enabled on the
      --  corresponding pin.
      PCR_PE_Field_0,
      --  Internal pullup or pulldown resistor is enabled on the corresponding
      --  pin, if the pin is configured as a digital input.
      PCR_PE_Field_1)
     with Size => 1;
   for PCR_PE_Field use
     (PCR_PE_Field_0 => 0,
      PCR_PE_Field_1 => 1);

   --  Slew Rate Enable
   type PCR_SRE_Field is
     (
      --  Fast slew rate is configured on the corresponding pin, if the pin is
      --  configured as a digital output.
      PCR_SRE_Field_0,
      --  Slow slew rate is configured on the corresponding pin, if the pin is
      --  configured as a digital output.
      PCR_SRE_Field_1)
     with Size => 1;
   for PCR_SRE_Field use
     (PCR_SRE_Field_0 => 0,
      PCR_SRE_Field_1 => 1);

   --  Passive Filter Enable
   type PCR_PFE_Field is
     (
      --  Passive input filter is disabled on the corresponding pin.
      PCR_PFE_Field_0,
      --  Passive input filter is enabled on the corresponding pin, if the pin
      --  is configured as a digital input. Refer to the device data sheet for
      --  filter characteristics.
      PCR_PFE_Field_1)
     with Size => 1;
   for PCR_PFE_Field use
     (PCR_PFE_Field_0 => 0,
      PCR_PFE_Field_1 => 1);

   --  Drive Strength Enable
   type PCR_DSE_Field is
     (
      --  Low drive strength is configured on the corresponding pin, if pin is
      --  configured as a digital output.
      PCR_DSE_Field_0,
      --  High drive strength is configured on the corresponding pin, if pin is
      --  configured as a digital output.
      PCR_DSE_Field_1)
     with Size => 1;
   for PCR_DSE_Field use
     (PCR_DSE_Field_0 => 0,
      PCR_DSE_Field_1 => 1);

   --  Pin Mux Control
   type PCR_MUX_Field is
     (
      --  Pin disabled (analog).
      PCR_MUX_Field_000,
      --  Alternative 1 (GPIO).
      PCR_MUX_Field_001,
      --  Alternative 2 (chip-specific).
      PCR_MUX_Field_010,
      --  Alternative 3 (chip-specific).
      PCR_MUX_Field_011,
      --  Alternative 4 (chip-specific).
      PCR_MUX_Field_100,
      --  Alternative 5 (chip-specific).
      PCR_MUX_Field_101,
      --  Alternative 6 (chip-specific).
      PCR_MUX_Field_110,
      --  Alternative 7 (chip-specific).
      PCR_MUX_Field_111)
     with Size => 3;
   for PCR_MUX_Field use
     (PCR_MUX_Field_000 => 0,
      PCR_MUX_Field_001 => 1,
      PCR_MUX_Field_010 => 2,
      PCR_MUX_Field_011 => 3,
      PCR_MUX_Field_100 => 4,
      PCR_MUX_Field_101 => 5,
      PCR_MUX_Field_110 => 6,
      PCR_MUX_Field_111 => 7);

   --  Interrupt Configuration
   type PCR_IRQC_Field is
     (
      --  Interrupt/DMA request disabled.
      PCR_IRQC_Field_0000,
      --  DMA request on rising edge.
      PCR_IRQC_Field_0001,
      --  DMA request on falling edge.
      PCR_IRQC_Field_0010,
      --  DMA request on either edge.
      PCR_IRQC_Field_0011,
      --  Interrupt when logic zero.
      PCR_IRQC_Field_1000,
      --  Interrupt on rising edge.
      PCR_IRQC_Field_1001,
      --  Interrupt on falling edge.
      PCR_IRQC_Field_1010,
      --  Interrupt on either edge.
      PCR_IRQC_Field_1011,
      --  Interrupt when logic one.
      PCR_IRQC_Field_1100)
     with Size => 4;
   for PCR_IRQC_Field use
     (PCR_IRQC_Field_0000 => 0,
      PCR_IRQC_Field_0001 => 1,
      PCR_IRQC_Field_0010 => 2,
      PCR_IRQC_Field_0011 => 3,
      PCR_IRQC_Field_1000 => 8,
      PCR_IRQC_Field_1001 => 9,
      PCR_IRQC_Field_1010 => 10,
      PCR_IRQC_Field_1011 => 11,
      PCR_IRQC_Field_1100 => 12);

   --  Interrupt Status Flag
   type PCR_ISF_Field is
     (
      --  Configured interrupt is not detected.
      PCR_ISF_Field_0,
      --  Configured interrupt is detected. If the pin is configured to
      --  generate a DMA request, then the corresponding flag will be cleared
      --  automatically at the completion of the requested DMA transfer.
      --  Otherwise, the flag remains set until a logic one is written to the
      --  flag. If the pin is configured for a level sensitive interrupt and
      --  the pin remains asserted, then the flag is set again immediately
      --  after it is cleared.
      PCR_ISF_Field_1)
     with Size => 1;
   for PCR_ISF_Field use
     (PCR_ISF_Field_0 => 0,
      PCR_ISF_Field_1 => 1);

   --  Pin Control Register n
   type PORTA_PCR_Register is record
      --  Pull Select
      PS             : PCR_PS_Field := MKL25Z4.PORT.PCR_PS_Field_0;
      --  Pull Enable
      PE             : PCR_PE_Field := MKL25Z4.PORT.PCR_PE_Field_1;
      --  Slew Rate Enable
      SRE            : PCR_SRE_Field := MKL25Z4.PORT.PCR_SRE_Field_1;
      --  unspecified
      Reserved_3_3   : MKL25Z4.Bit := 16#0#;
      --  Passive Filter Enable
      PFE            : PCR_PFE_Field := MKL25Z4.PORT.PCR_PFE_Field_0;
      --  unspecified
      Reserved_5_5   : MKL25Z4.Bit := 16#0#;
      --  Drive Strength Enable
      DSE            : PCR_DSE_Field := MKL25Z4.PORT.PCR_DSE_Field_0;
      --  unspecified
      Reserved_7_7   : MKL25Z4.Bit := 16#0#;
      --  Pin Mux Control
      MUX            : PCR_MUX_Field := MKL25Z4.PORT.PCR_MUX_Field_111;
      --  unspecified
      Reserved_11_15 : MKL25Z4.UInt5 := 16#0#;
      --  Interrupt Configuration
      IRQC           : PCR_IRQC_Field := MKL25Z4.PORT.PCR_IRQC_Field_0000;
      --  unspecified
      Reserved_20_23 : MKL25Z4.UInt4 := 16#0#;
      --  Interrupt Status Flag
      ISF            : PCR_ISF_Field := MKL25Z4.PORT.PCR_ISF_Field_0;
      --  unspecified
      Reserved_25_31 : MKL25Z4.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PORTA_PCR_Register use record
      PS             at 0 range 0 .. 0;
      PE             at 0 range 1 .. 1;
      SRE            at 0 range 2 .. 2;
      Reserved_3_3   at 0 range 3 .. 3;
      PFE            at 0 range 4 .. 4;
      Reserved_5_5   at 0 range 5 .. 5;
      DSE            at 0 range 6 .. 6;
      Reserved_7_7   at 0 range 7 .. 7;
      MUX            at 0 range 8 .. 10;
      Reserved_11_15 at 0 range 11 .. 15;
      IRQC           at 0 range 16 .. 19;
      Reserved_20_23 at 0 range 20 .. 23;
      ISF            at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   --  Pin Control Register n
   type PORTA_PCR_Registers is array (0 .. 31) of PORTA_PCR_Register;

   subtype GPCLR_GPWD_Field is MKL25Z4.Short;

   --  Global Pin Write Enable
   type GPCLR_GPWE_Field is
     (
      --  Corresponding Pin Control Register is not updated with the value in
      --  GPWD.
      GPCLR_GPWE_Field_0,
      --  Corresponding Pin Control Register is updated with the value in GPWD.
      GPCLR_GPWE_Field_1)
     with Size => 16;
   for GPCLR_GPWE_Field use
     (GPCLR_GPWE_Field_0 => 0,
      GPCLR_GPWE_Field_1 => 1);

   --  Global Pin Control Low Register
   type PORTA_GPCLR_Register is record
      --  Write-only. Global Pin Write Data
      GPWD : GPCLR_GPWD_Field := 16#0#;
      --  Write-only. Global Pin Write Enable
      GPWE : GPCLR_GPWE_Field := MKL25Z4.PORT.GPCLR_GPWE_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PORTA_GPCLR_Register use record
      GPWD at 0 range 0 .. 15;
      GPWE at 0 range 16 .. 31;
   end record;

   subtype GPCHR_GPWD_Field is MKL25Z4.Short;

   --  Global Pin Write Enable
   type GPCHR_GPWE_Field is
     (
      --  Corresponding Pin Control Register is not updated with the value in
      --  GPWD.
      GPCHR_GPWE_Field_0,
      --  Corresponding Pin Control Register is updated with the value in GPWD.
      GPCHR_GPWE_Field_1)
     with Size => 16;
   for GPCHR_GPWE_Field use
     (GPCHR_GPWE_Field_0 => 0,
      GPCHR_GPWE_Field_1 => 1);

   --  Global Pin Control High Register
   type PORTA_GPCHR_Register is record
      --  Write-only. Global Pin Write Data
      GPWD : GPCHR_GPWD_Field := 16#0#;
      --  Write-only. Global Pin Write Enable
      GPWE : GPCHR_GPWE_Field := MKL25Z4.PORT.GPCHR_GPWE_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PORTA_GPCHR_Register use record
      GPWD at 0 range 0 .. 15;
      GPWE at 0 range 16 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Pin Control and Interrupts
   type PORT_Peripheral is record
      --  Pin Control Register n
      PCR   : PORTA_PCR_Registers;
      --  Global Pin Control Low Register
      GPCLR : PORTA_GPCLR_Register;
      --  Global Pin Control High Register
      GPCHR : PORTA_GPCHR_Register;
      --  Interrupt Status Flag Register
      ISFR  : MKL25Z4.Word;
   end record
     with Volatile;

   for PORT_Peripheral use record
      PCR   at 0 range 0 .. 1023;
      GPCLR at 128 range 0 .. 31;
      GPCHR at 132 range 0 .. 31;
      ISFR  at 160 range 0 .. 31;
   end record;

   --  Pin Control and Interrupts
   PORTA_Periph : aliased PORT_Peripheral
     with Import, Address => PORTA_Base;

   --  Pin Control and Interrupts
   PORTB_Periph : aliased PORT_Peripheral
     with Import, Address => PORTB_Base;

   --  Pin Control and Interrupts
   PORTC_Periph : aliased PORT_Peripheral
     with Import, Address => PORTC_Base;

   --  Pin Control and Interrupts
   PORTD_Periph : aliased PORT_Peripheral
     with Import, Address => PORTD_Base;

   --  Pin Control and Interrupts
   PORTE_Periph : aliased PORT_Peripheral
     with Import, Address => PORTE_Base;

end MKL25Z4.PORT;
