--
--  Copyright (c) 2022-2023, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary UART driver for NXP KL25Z
--

with MKL25Z4.UART0;
with MKL25Z4.SIM;
with MKL25Z4.PORT;
with Microcontroller_Clocks;

package body Uart_Driver is
   use MKL25Z4.UART0;
   use Microcontroller_Clocks;

   ---------
   -- Get --
   ---------

   function Get_Char return Character is
     (Character'Val (UART0_Periph.D));

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize_Uart (Baud_Rate : Positive) is
      use MKL25Z4.PORT;

      procedure Set_Baud_Rate;

      procedure Set_Baud_Rate is
         SBR_Field_Value : Positive range 1 .. 16#1FFF#;
         SBR_Field_Encoded : Encoded_Baud_Rate_Type with
           Address => SBR_Field_Value'Address;
         Uart_Clock : Positive;
         Calculated_Baud_Rate : Positive;
         Baud_Diff : Natural;
         Baud_Diff2 : Natural;
         OSR_Value : Natural;
         C4_Value : UART0_C4_Register;
         C5_Value : UART0_C5_Register;
         BDH_Value : UART0_BDH_Register;
      begin
         --
         --  Calculate the first baud rate using the lowest OSR value possible.
         --
         Uart_Clock := Get_Pll_Frequency_Hz / 2;
         SBR_Field_Value := Uart_Clock / (Baud_Rate * 4);
         Calculated_Baud_Rate := Uart_Clock / (4 * SBR_Field_Value);
         if Calculated_Baud_Rate > Baud_Rate then
            Baud_Diff := Calculated_Baud_Rate - Baud_Rate;
         else
            Baud_Diff := Baud_Rate - Calculated_Baud_Rate;
         end if;

         OSR_Value := 4;

         --  Select the best OSR value:
         for I in 5 .. 32 loop
            SBR_Field_Value := Uart_Clock / (Baud_Rate * I);
            Calculated_Baud_Rate := Uart_Clock / (I * SBR_Field_Value);

            if Calculated_Baud_Rate > Baud_Rate then
               Baud_Diff2 := Calculated_Baud_Rate - Baud_Rate;
            else
               Baud_Diff2 := Baud_Rate - Calculated_Baud_Rate;
            end if;

            if Baud_Diff2 <= Baud_Diff then
               Baud_Diff := Baud_Diff2;
               OSR_Value := I;
            end if;
         end loop;

         pragma Assert (Baud_Diff < (Baud_Rate / 100) * 3);

         --
         --  If the OSR is between 4x and 8x then both
         --  edge sampling MUST be turned on.
         --
         if OSR_Value in  4 .. 8 then
            C5_Value := UART0_Periph.C5;
            C5_Value.BOTHEDGE := C5_BOTHEDGE_Field_1;
            UART0_Periph.C5 := C5_Value;
         end if;

         --  Setup OSR value:
         C4_Value := UART0_Periph.C4;
         C4_Value.OSR := Five_Bits_Type (OSR_Value - 1);
         UART0_Periph.C4 := C4_Value;
         SBR_Field_Value := Uart_Clock / (Baud_Rate * OSR_Value);

         --  Set baud rate in the device:
         BDH_Value := UART0_Periph.BDH;
         BDH_Value.SBR := SBR_Field_Encoded.High_Part;
         UART0_Periph.BDH := BDH_Value;
         UART0_Periph.BDL := SBR_Field_Encoded.Low_Part;
      end Set_Baud_Rate;

      C1_Value : UART0_C1_Register;
      C2_Value : UART0_C2_Register;
      SOPT2_Value : MKL25Z4.SIM.SIM_SOPT2_Register;
      SCGC4_Value : MKL25Z4.SIM.SIM_SCGC4_Register;
      PCR_Value : MKL25Z4.PORT.PORTA_PCR_Register;
   begin
      --
      --  Select the clock source to be used for this UART peripheral:
      --  01 =  MCGFLLCLK clock or MCGPLLCLK/2 clock
      --
      SOPT2_Value := MKL25Z4.SIM.SIM_Periph.SOPT2;
      SOPT2_Value.UART0SRC := MKL25Z4.SIM.SOPT2_UART0SRC_Field_01;
      MKL25Z4.SIM.SIM_Periph.SOPT2 := SOPT2_Value;

      --  Enable UART clock
      SCGC4_Value := MKL25Z4.SIM.SIM_Periph.SCGC4;
      SCGC4_Value.UART.Arr (0) := MKL25Z4.SIM.SCGC4_UART0_Field_1;
      MKL25Z4.SIM.SIM_Periph.SCGC4 := SCGC4_Value;

      --  Disable UART's transmitter and receiver, while UART is being
      --  configured:
      C2_Value := UART0_Periph.C2;
      C2_Value.TE := C2_TE_Field_0;
      C2_Value.RE := C2_RE_Field_0;
      UART0_Periph.C2 := C2_Value;

      --  Configure the uart transmission mode: 8-N-1
      --  (8 data bits, no parity bit, 1 stop bit):
      C1_Value := (others => <>);
      UART0_Periph.C1 := C1_Value;

      --  Configure Tx pin:
      PCR_Value := (MUX => PCR_MUX_Field_010,
                    DSE => PCR_DSE_Field_1,
                    IRQC => PCR_IRQC_Field_0000,
                    others => <>);
      MKL25Z4.PORT.PORTA_Periph.PCR (1) := PCR_Value;

      --  Configure Rx pin:
      PCR_Value := (MUX => PCR_MUX_Field_010,
                    DSE => PCR_DSE_Field_1,
                    IRQC => PCR_IRQC_Field_0000,
                    others => <>);
      MKL25Z4.PORT.PORTA_Periph.PCR (2) := PCR_Value;

      Set_Baud_Rate;

      --  Disable generation of Tx/Rx interrupts:
      C2_Value.RIE := C2_RIE_Field_0;
      C2_Value.TIE := C2_TIE_Field_0;
      UART0_Periph.C2 := C2_Value;

      --  Enable UART's transmitter and receiver:
      C2_Value.TE := C2_TE_Field_1;
      C2_Value.RE := C2_RE_Field_1;
      UART0_Periph.C2 := C2_Value;
   end Initialize_Uart;

   procedure Put_Char (C : Character) is
   begin
      loop
         exit when UART0_Periph.S1.TDRE = S1_TDRE_Field_1;
      end loop;

      UART0_Periph.D := Byte_Type (Character'Pos (C));
   end Put_Char;

   procedure Tx_Flush is
   begin
      loop
         exit when UART0_Periph.S1.TDRE = S1_TDRE_Field_1;
      end loop;
   end Tx_Flush;

end Uart_Driver;