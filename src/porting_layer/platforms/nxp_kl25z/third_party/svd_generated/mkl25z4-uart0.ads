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

--  Universal Asynchronous Receiver/Transmitter
package MKL25Z4.UART0 is

   ---------------
   -- Registers --
   ---------------

   subtype BDH_SBR_Field is Five_Bits_Type;

   --  Stop Bit Number Select
   type BDH_SBNS_Field is
     (
      --  One stop bit.
      BDH_SBNS_Field_0,
      --  Two stop bit.
      BDH_SBNS_Field_1)
     with Size => 1;
   for BDH_SBNS_Field use
     (BDH_SBNS_Field_0 => 0,
      BDH_SBNS_Field_1 => 1);

   --  RX Input Active Edge Interrupt Enable (for RXEDGIF)
   type BDH_RXEDGIE_Field is
     (
      --  Hardware interrupts from UART _S2[RXEDGIF] disabled (use polling).
      BDH_RXEDGIE_Field_0,
      --  Hardware interrupt requested when UART _S2[RXEDGIF] flag is 1.
      BDH_RXEDGIE_Field_1)
     with Size => 1;
   for BDH_RXEDGIE_Field use
     (BDH_RXEDGIE_Field_0 => 0,
      BDH_RXEDGIE_Field_1 => 1);

   --  LIN Break Detect Interrupt Enable (for LBKDIF)
   type BDH_LBKDIE_Field is
     (
      --  Hardware interrupts from UART _S2[LBKDIF] disabled (use polling).
      BDH_LBKDIE_Field_0,
      --  Hardware interrupt requested when UART _S2[LBKDIF] flag is 1.
      BDH_LBKDIE_Field_1)
     with Size => 1;
   for BDH_LBKDIE_Field use
     (BDH_LBKDIE_Field_0 => 0,
      BDH_LBKDIE_Field_1 => 1);

   --  UART Baud Rate Register High
   type UART0_BDH_Register is record
      --  Baud Rate Modulo Divisor.
      SBR     : BDH_SBR_Field := 16#0#;
      --  Stop Bit Number Select
      SBNS    : BDH_SBNS_Field := MKL25Z4.UART0.BDH_SBNS_Field_0;
      --  RX Input Active Edge Interrupt Enable (for RXEDGIF)
      RXEDGIE : BDH_RXEDGIE_Field := MKL25Z4.UART0.BDH_RXEDGIE_Field_0;
      --  LIN Break Detect Interrupt Enable (for LBKDIF)
      LBKDIE  : BDH_LBKDIE_Field := MKL25Z4.UART0.BDH_LBKDIE_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for UART0_BDH_Register use record
      SBR     at 0 range 0 .. 4;
      SBNS    at 0 range 5 .. 5;
      RXEDGIE at 0 range 6 .. 6;
      LBKDIE  at 0 range 7 .. 7;
   end record;

   --  Parity Type
   type C1_PT_Field is
     (
      --  Even parity.
      C1_PT_Field_0,
      --  Odd parity.
      C1_PT_Field_1)
     with Size => 1;
   for C1_PT_Field use
     (C1_PT_Field_0 => 0,
      C1_PT_Field_1 => 1);

   --  Parity Enable
   type C1_PE_Field is
     (
      --  No hardware parity generation or checking.
      C1_PE_Field_0,
      --  Parity enabled.
      C1_PE_Field_1)
     with Size => 1;
   for C1_PE_Field use
     (C1_PE_Field_0 => 0,
      C1_PE_Field_1 => 1);

   --  Idle Line Type Select
   type C1_ILT_Field is
     (
      --  Idle character bit count starts after start bit.
      C1_ILT_Field_0,
      --  Idle character bit count starts after stop bit.
      C1_ILT_Field_1)
     with Size => 1;
   for C1_ILT_Field use
     (C1_ILT_Field_0 => 0,
      C1_ILT_Field_1 => 1);

   --  Receiver Wakeup Method Select
   type C1_WAKE_Field is
     (
      --  Idle-line wakeup.
      C1_WAKE_Field_0,
      --  Address-mark wakeup.
      C1_WAKE_Field_1)
     with Size => 1;
   for C1_WAKE_Field use
     (C1_WAKE_Field_0 => 0,
      C1_WAKE_Field_1 => 1);

   --  9-Bit or 8-Bit Mode Select
   type C1_M_Field is
     (
      --  Receiver and transmitter use 8-bit data characters.
      C1_M_Field_0,
      --  Receiver and transmitter use 9-bit data characters.
      C1_M_Field_1)
     with Size => 1;
   for C1_M_Field use
     (C1_M_Field_0 => 0,
      C1_M_Field_1 => 1);

   --  Receiver Source Select
   type C1_RSRC_Field is
     (
      --  Provided LOOPS is set, RSRC is cleared, selects internal loop back
      --  mode and the UART does not use the UART _RX pins.
      C1_RSRC_Field_0,
      --  Single-wire UART mode where the UART _TX pin is connected to the
      --  transmitter output and receiver input.
      C1_RSRC_Field_1)
     with Size => 1;
   for C1_RSRC_Field use
     (C1_RSRC_Field_0 => 0,
      C1_RSRC_Field_1 => 1);

   --  Doze Enable
   type C1_DOZEEN_Field is
     (
      --  UART is enabled in Wait mode.
      C1_DOZEEN_Field_0,
      --  UART is disabled in Wait mode.
      C1_DOZEEN_Field_1)
     with Size => 1;
   for C1_DOZEEN_Field use
     (C1_DOZEEN_Field_0 => 0,
      C1_DOZEEN_Field_1 => 1);

   --  Loop Mode Select
   type C1_LOOPS_Field is
     (
      --  Normal operation - UART _RX and UART _TX use separate pins.
      C1_LOOPS_Field_0,
      --  Loop mode or single-wire mode where transmitter outputs are
      --  internally connected to receiver input. (See RSRC bit.) UART _RX pin
      --  is not used by UART .
      C1_LOOPS_Field_1)
     with Size => 1;
   for C1_LOOPS_Field use
     (C1_LOOPS_Field_0 => 0,
      C1_LOOPS_Field_1 => 1);

   --  UART Control Register 1
   type UART0_C1_Register is record
      --  Parity Type
      PT     : C1_PT_Field := MKL25Z4.UART0.C1_PT_Field_0;
      --  Parity Enable
      PE     : C1_PE_Field := MKL25Z4.UART0.C1_PE_Field_0;
      --  Idle Line Type Select
      ILT    : C1_ILT_Field := MKL25Z4.UART0.C1_ILT_Field_0;
      --  Receiver Wakeup Method Select
      WAKE   : C1_WAKE_Field := MKL25Z4.UART0.C1_WAKE_Field_0;
      --  9-Bit or 8-Bit Mode Select
      M      : C1_M_Field := MKL25Z4.UART0.C1_M_Field_0;
      --  Receiver Source Select
      RSRC   : C1_RSRC_Field := MKL25Z4.UART0.C1_RSRC_Field_0;
      --  Doze Enable
      DOZEEN : C1_DOZEEN_Field := MKL25Z4.UART0.C1_DOZEEN_Field_0;
      --  Loop Mode Select
      LOOPS  : C1_LOOPS_Field := MKL25Z4.UART0.C1_LOOPS_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for UART0_C1_Register use record
      PT     at 0 range 0 .. 0;
      PE     at 0 range 1 .. 1;
      ILT    at 0 range 2 .. 2;
      WAKE   at 0 range 3 .. 3;
      M      at 0 range 4 .. 4;
      RSRC   at 0 range 5 .. 5;
      DOZEEN at 0 range 6 .. 6;
      LOOPS  at 0 range 7 .. 7;
   end record;

   --  Send Break
   type C2_SBK_Field is
     (
      --  Normal transmitter operation.
      C2_SBK_Field_0,
      --  Queue break character(s) to be sent.
      C2_SBK_Field_1)
     with Size => 1;
   for C2_SBK_Field use
     (C2_SBK_Field_0 => 0,
      C2_SBK_Field_1 => 1);

   --  Receiver Wakeup Control
   type C2_RWU_Field is
     (
      --  Normal UART receiver operation.
      C2_RWU_Field_0,
      --  UART receiver in standby waiting for wakeup condition.
      C2_RWU_Field_1)
     with Size => 1;
   for C2_RWU_Field use
     (C2_RWU_Field_0 => 0,
      C2_RWU_Field_1 => 1);

   --  Receiver Enable
   type C2_RE_Field is
     (
      --  Receiver disabled.
      C2_RE_Field_0,
      --  Receiver enabled.
      C2_RE_Field_1)
     with Size => 1;
   for C2_RE_Field use
     (C2_RE_Field_0 => 0,
      C2_RE_Field_1 => 1);

   --  Transmitter Enable
   type C2_TE_Field is
     (
      --  Transmitter disabled.
      C2_TE_Field_0,
      --  Transmitter enabled.
      C2_TE_Field_1)
     with Size => 1;
   for C2_TE_Field use
     (C2_TE_Field_0 => 0,
      C2_TE_Field_1 => 1);

   --  Idle Line Interrupt Enable for IDLE
   type C2_ILIE_Field is
     (
      --  Hardware interrupts from IDLE disabled; use polling.
      C2_ILIE_Field_0,
      --  Hardware interrupt requested when IDLE flag is 1.
      C2_ILIE_Field_1)
     with Size => 1;
   for C2_ILIE_Field use
     (C2_ILIE_Field_0 => 0,
      C2_ILIE_Field_1 => 1);

   --  Receiver Interrupt Enable for RDRF
   type C2_RIE_Field is
     (
      --  Hardware interrupts from RDRF disabled; use polling.
      C2_RIE_Field_0,
      --  Hardware interrupt requested when RDRF flag is 1.
      C2_RIE_Field_1)
     with Size => 1;
   for C2_RIE_Field use
     (C2_RIE_Field_0 => 0,
      C2_RIE_Field_1 => 1);

   --  Transmission Complete Interrupt Enable for TC
   type C2_TCIE_Field is
     (
      --  Hardware interrupts from TC disabled; use polling.
      C2_TCIE_Field_0,
      --  Hardware interrupt requested when TC flag is 1.
      C2_TCIE_Field_1)
     with Size => 1;
   for C2_TCIE_Field use
     (C2_TCIE_Field_0 => 0,
      C2_TCIE_Field_1 => 1);

   --  Transmit Interrupt Enable for TDRE
   type C2_TIE_Field is
     (
      --  Hardware interrupts from TDRE disabled; use polling.
      C2_TIE_Field_0,
      --  Hardware interrupt requested when TDRE flag is 1.
      C2_TIE_Field_1)
     with Size => 1;
   for C2_TIE_Field use
     (C2_TIE_Field_0 => 0,
      C2_TIE_Field_1 => 1);

   --  UART Control Register 2
   type UART0_C2_Register is record
      --  Send Break
      SBK  : C2_SBK_Field := MKL25Z4.UART0.C2_SBK_Field_0;
      --  Receiver Wakeup Control
      RWU  : C2_RWU_Field := MKL25Z4.UART0.C2_RWU_Field_0;
      --  Receiver Enable
      RE   : C2_RE_Field := MKL25Z4.UART0.C2_RE_Field_0;
      --  Transmitter Enable
      TE   : C2_TE_Field := MKL25Z4.UART0.C2_TE_Field_0;
      --  Idle Line Interrupt Enable for IDLE
      ILIE : C2_ILIE_Field := MKL25Z4.UART0.C2_ILIE_Field_0;
      --  Receiver Interrupt Enable for RDRF
      RIE  : C2_RIE_Field := MKL25Z4.UART0.C2_RIE_Field_0;
      --  Transmission Complete Interrupt Enable for TC
      TCIE : C2_TCIE_Field := MKL25Z4.UART0.C2_TCIE_Field_0;
      --  Transmit Interrupt Enable for TDRE
      TIE  : C2_TIE_Field := MKL25Z4.UART0.C2_TIE_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for UART0_C2_Register use record
      SBK  at 0 range 0 .. 0;
      RWU  at 0 range 1 .. 1;
      RE   at 0 range 2 .. 2;
      TE   at 0 range 3 .. 3;
      ILIE at 0 range 4 .. 4;
      RIE  at 0 range 5 .. 5;
      TCIE at 0 range 6 .. 6;
      TIE  at 0 range 7 .. 7;
   end record;

   --  Parity Error Flag
   type S1_PF_Field is
     (
      --  No parity error.
      S1_PF_Field_0,
      --  Parity error.
      S1_PF_Field_1)
     with Size => 1;
   for S1_PF_Field use
     (S1_PF_Field_0 => 0,
      S1_PF_Field_1 => 1);

   --  Framing Error Flag
   type S1_FE_Field is
     (
      --  No framing error detected. This does not guarantee the framing is
      --  correct.
      S1_FE_Field_0,
      --  Framing error.
      S1_FE_Field_1)
     with Size => 1;
   for S1_FE_Field use
     (S1_FE_Field_0 => 0,
      S1_FE_Field_1 => 1);

   --  Noise Flag
   type S1_NF_Field is
     (
      --  No noise detected.
      S1_NF_Field_0,
      --  Noise detected in the received character in UART _D.
      S1_NF_Field_1)
     with Size => 1;
   for S1_NF_Field use
     (S1_NF_Field_0 => 0,
      S1_NF_Field_1 => 1);

   --  Receiver Overrun Flag
   type S1_OR_Field is
     (
      --  No overrun.
      S1_OR_Field_0,
      --  Receive overrun (new UART data lost).
      S1_OR_Field_1)
     with Size => 1;
   for S1_OR_Field use
     (S1_OR_Field_0 => 0,
      S1_OR_Field_1 => 1);

   --  Idle Line Flag
   type S1_IDLE_Field is
     (
      --  No idle line detected.
      S1_IDLE_Field_0,
      --  Idle line was detected.
      S1_IDLE_Field_1)
     with Size => 1;
   for S1_IDLE_Field use
     (S1_IDLE_Field_0 => 0,
      S1_IDLE_Field_1 => 1);

   --  Receive Data Register Full Flag
   type S1_RDRF_Field is
     (
      --  Receive data buffer empty.
      S1_RDRF_Field_0,
      --  Receive data buffer full.
      S1_RDRF_Field_1)
     with Size => 1;
   for S1_RDRF_Field use
     (S1_RDRF_Field_0 => 0,
      S1_RDRF_Field_1 => 1);

   --  Transmission Complete Flag
   type S1_TC_Field is
     (
      --  Transmitter active (sending data, a preamble, or a break).
      S1_TC_Field_0,
      --  Transmitter idle (transmission activity complete).
      S1_TC_Field_1)
     with Size => 1;
   for S1_TC_Field use
     (S1_TC_Field_0 => 0,
      S1_TC_Field_1 => 1);

   --  Transmit Data Register Empty Flag
   type S1_TDRE_Field is
     (
      --  Transmit data buffer full.
      S1_TDRE_Field_0,
      --  Transmit data buffer empty.
      S1_TDRE_Field_1)
     with Size => 1;
   for S1_TDRE_Field use
     (S1_TDRE_Field_0 => 0,
      S1_TDRE_Field_1 => 1);

   --  UART Status Register 1
   type UART0_S1_Register is record
      --  Parity Error Flag
      PF   : S1_PF_Field := MKL25Z4.UART0.S1_PF_Field_0;
      --  Framing Error Flag
      FE   : S1_FE_Field := MKL25Z4.UART0.S1_FE_Field_0;
      --  Noise Flag
      NF   : S1_NF_Field := MKL25Z4.UART0.S1_NF_Field_0;
      --  Receiver Overrun Flag
      OR_k : S1_OR_Field := MKL25Z4.UART0.S1_OR_Field_0;
      --  Idle Line Flag
      IDLE : S1_IDLE_Field := MKL25Z4.UART0.S1_IDLE_Field_0;
      --  Read-only. Receive Data Register Full Flag
      RDRF : S1_RDRF_Field := MKL25Z4.UART0.S1_RDRF_Field_0;
      --  Read-only. Transmission Complete Flag
      TC   : S1_TC_Field := MKL25Z4.UART0.S1_TC_Field_1;
      --  Read-only. Transmit Data Register Empty Flag
      TDRE : S1_TDRE_Field := MKL25Z4.UART0.S1_TDRE_Field_1;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for UART0_S1_Register use record
      PF   at 0 range 0 .. 0;
      FE   at 0 range 1 .. 1;
      NF   at 0 range 2 .. 2;
      OR_k at 0 range 3 .. 3;
      IDLE at 0 range 4 .. 4;
      RDRF at 0 range 5 .. 5;
      TC   at 0 range 6 .. 6;
      TDRE at 0 range 7 .. 7;
   end record;

   --  Receiver Active Flag
   type S2_RAF_Field is
     (
      --  UART receiver idle waiting for a start bit.
      S2_RAF_Field_0,
      --  UART receiver active ( UART _RXD input not idle).
      S2_RAF_Field_1)
     with Size => 1;
   for S2_RAF_Field use
     (S2_RAF_Field_0 => 0,
      S2_RAF_Field_1 => 1);

   --  LIN Break Detection Enable
   type S2_LBKDE_Field is
     (
      --  Break character is detected at length 10 bit times (if M = 0, SBNS =
      --  0) or 11 (if M = 1, SBNS = 0 or M = 0, SBNS = 1) or 12 (if M = 1,
      --  SBNS = 1 or M10 = 1, SNBS = 0) or 13 (if M10 = 1, SNBS = 1).
      S2_LBKDE_Field_0,
      --  Break character is detected at length of 11 bit times (if M = 0, SBNS
      --  = 0) or 12 (if M = 1, SBNS = 0 or M = 0, SBNS = 1) or 14 (if M = 1,
      --  SBNS = 1 or M10 = 1, SNBS = 0) or 15 (if M10 = 1, SNBS = 1).
      S2_LBKDE_Field_1)
     with Size => 1;
   for S2_LBKDE_Field use
     (S2_LBKDE_Field_0 => 0,
      S2_LBKDE_Field_1 => 1);

   --  Break Character Generation Length
   type S2_BRK13_Field is
     (
      --  Break character is transmitted with length of 10 bit times (if M = 0,
      --  SBNS = 0) or 11 (if M = 1, SBNS = 0 or M = 0, SBNS = 1) or 12 (if M =
      --  1, SBNS = 1 or M10 = 1, SNBS = 0) or 13 (if M10 = 1, SNBS = 1).
      S2_BRK13_Field_0,
      --  Break character is transmitted with length of 13 bit times (if M = 0,
      --  SBNS = 0) or 14 (if M = 1, SBNS = 0 or M = 0, SBNS = 1) or 15 (if M =
      --  1, SBNS = 1 or M10 = 1, SNBS = 0) or 16 (if M10 = 1, SNBS = 1).
      S2_BRK13_Field_1)
     with Size => 1;
   for S2_BRK13_Field use
     (S2_BRK13_Field_0 => 0,
      S2_BRK13_Field_1 => 1);

   --  Receive Wake Up Idle Detect
   type S2_RWUID_Field is
     (
      --  During receive standby state (RWU = 1), the IDLE bit does not get set
      --  upon detection of an idle character.
      S2_RWUID_Field_0,
      --  During receive standby state (RWU = 1), the IDLE bit gets set upon
      --  detection of an idle character.
      S2_RWUID_Field_1)
     with Size => 1;
   for S2_RWUID_Field use
     (S2_RWUID_Field_0 => 0,
      S2_RWUID_Field_1 => 1);

   --  Receive Data Inversion
   type S2_RXINV_Field is
     (
      --  Receive data not inverted.
      S2_RXINV_Field_0,
      --  Receive data inverted.
      S2_RXINV_Field_1)
     with Size => 1;
   for S2_RXINV_Field use
     (S2_RXINV_Field_0 => 0,
      S2_RXINV_Field_1 => 1);

   --  MSB First
   type S2_MSBF_Field is
     (
      --  LSB (bit0) is the first bit that is transmitted following the start
      --  bit. Further, the first bit received after the start bit is
      --  identified as bit0.
      S2_MSBF_Field_0,
      --  MSB (bit9, bit8, bit7 or bit6) is the first bit that is transmitted
      --  following the start bit depending on the setting of C1[M], C1[PE] and
      --  C4[M10]. Further, the first bit received after the start bit is
      --  identified as bit9, bit8, bit7 or bit6 depending on the setting of
      --  C1[M] and C1[PE].
      S2_MSBF_Field_1)
     with Size => 1;
   for S2_MSBF_Field use
     (S2_MSBF_Field_0 => 0,
      S2_MSBF_Field_1 => 1);

   --  UART _RX Pin Active Edge Interrupt Flag
   type S2_RXEDGIF_Field is
     (
      --  No active edge on the receive pin has occurred.
      S2_RXEDGIF_Field_0,
      --  An active edge on the receive pin has occurred.
      S2_RXEDGIF_Field_1)
     with Size => 1;
   for S2_RXEDGIF_Field use
     (S2_RXEDGIF_Field_0 => 0,
      S2_RXEDGIF_Field_1 => 1);

   --  LIN Break Detect Interrupt Flag
   type S2_LBKDIF_Field is
     (
      --  No LIN break character has been detected.
      S2_LBKDIF_Field_0,
      --  LIN break character has been detected.
      S2_LBKDIF_Field_1)
     with Size => 1;
   for S2_LBKDIF_Field use
     (S2_LBKDIF_Field_0 => 0,
      S2_LBKDIF_Field_1 => 1);

   --  UART Status Register 2
   type UART0_S2_Register is record
      --  Read-only. Receiver Active Flag
      RAF     : S2_RAF_Field := MKL25Z4.UART0.S2_RAF_Field_0;
      --  LIN Break Detection Enable
      LBKDE   : S2_LBKDE_Field := MKL25Z4.UART0.S2_LBKDE_Field_0;
      --  Break Character Generation Length
      BRK13   : S2_BRK13_Field := MKL25Z4.UART0.S2_BRK13_Field_0;
      --  Receive Wake Up Idle Detect
      RWUID   : S2_RWUID_Field := MKL25Z4.UART0.S2_RWUID_Field_0;
      --  Receive Data Inversion
      RXINV   : S2_RXINV_Field := MKL25Z4.UART0.S2_RXINV_Field_0;
      --  MSB First
      MSBF    : S2_MSBF_Field := MKL25Z4.UART0.S2_MSBF_Field_0;
      --  UART _RX Pin Active Edge Interrupt Flag
      RXEDGIF : S2_RXEDGIF_Field := MKL25Z4.UART0.S2_RXEDGIF_Field_0;
      --  LIN Break Detect Interrupt Flag
      LBKDIF  : S2_LBKDIF_Field := MKL25Z4.UART0.S2_LBKDIF_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for UART0_S2_Register use record
      RAF     at 0 range 0 .. 0;
      LBKDE   at 0 range 1 .. 1;
      BRK13   at 0 range 2 .. 2;
      RWUID   at 0 range 3 .. 3;
      RXINV   at 0 range 4 .. 4;
      MSBF    at 0 range 5 .. 5;
      RXEDGIF at 0 range 6 .. 6;
      LBKDIF  at 0 range 7 .. 7;
   end record;

   --  Parity Error Interrupt Enable
   type C3_PEIE_Field is
     (
      --  PF interrupts disabled; use polling).
      C3_PEIE_Field_0,
      --  Hardware interrupt requested when PF is set.
      C3_PEIE_Field_1)
     with Size => 1;
   for C3_PEIE_Field use
     (C3_PEIE_Field_0 => 0,
      C3_PEIE_Field_1 => 1);

   --  Framing Error Interrupt Enable
   type C3_FEIE_Field is
     (
      --  FE interrupts disabled; use polling.
      C3_FEIE_Field_0,
      --  Hardware interrupt requested when FE is set.
      C3_FEIE_Field_1)
     with Size => 1;
   for C3_FEIE_Field use
     (C3_FEIE_Field_0 => 0,
      C3_FEIE_Field_1 => 1);

   --  Noise Error Interrupt Enable
   type C3_NEIE_Field is
     (
      --  NF interrupts disabled; use polling.
      C3_NEIE_Field_0,
      --  Hardware interrupt requested when NF is set.
      C3_NEIE_Field_1)
     with Size => 1;
   for C3_NEIE_Field use
     (C3_NEIE_Field_0 => 0,
      C3_NEIE_Field_1 => 1);

   --  Overrun Interrupt Enable
   type C3_ORIE_Field is
     (
      --  OR interrupts disabled; use polling.
      C3_ORIE_Field_0,
      --  Hardware interrupt requested when OR is set.
      C3_ORIE_Field_1)
     with Size => 1;
   for C3_ORIE_Field use
     (C3_ORIE_Field_0 => 0,
      C3_ORIE_Field_1 => 1);

   --  Transmit Data Inversion
   type C3_TXINV_Field is
     (
      --  Transmit data not inverted.
      C3_TXINV_Field_0,
      --  Transmit data inverted.
      C3_TXINV_Field_1)
     with Size => 1;
   for C3_TXINV_Field use
     (C3_TXINV_Field_0 => 0,
      C3_TXINV_Field_1 => 1);

   --  UART _TX Pin Direction in Single-Wire Mode
   type C3_TXDIR_Field is
     (
      --  UART _TXD pin is an input in single-wire mode.
      C3_TXDIR_Field_0,
      --  UART _TXD pin is an output in single-wire mode.
      C3_TXDIR_Field_1)
     with Size => 1;
   for C3_TXDIR_Field use
     (C3_TXDIR_Field_0 => 0,
      C3_TXDIR_Field_1 => 1);

   subtype C3_R9T8_Field is MKL25Z4.Bit;
   subtype C3_R8T9_Field is MKL25Z4.Bit;

   --  UART Control Register 3
   type UART0_C3_Register is record
      --  Parity Error Interrupt Enable
      PEIE  : C3_PEIE_Field := MKL25Z4.UART0.C3_PEIE_Field_0;
      --  Framing Error Interrupt Enable
      FEIE  : C3_FEIE_Field := MKL25Z4.UART0.C3_FEIE_Field_0;
      --  Noise Error Interrupt Enable
      NEIE  : C3_NEIE_Field := MKL25Z4.UART0.C3_NEIE_Field_0;
      --  Overrun Interrupt Enable
      ORIE  : C3_ORIE_Field := MKL25Z4.UART0.C3_ORIE_Field_0;
      --  Transmit Data Inversion
      TXINV : C3_TXINV_Field := MKL25Z4.UART0.C3_TXINV_Field_0;
      --  UART _TX Pin Direction in Single-Wire Mode
      TXDIR : C3_TXDIR_Field := MKL25Z4.UART0.C3_TXDIR_Field_0;
      --  Receive Bit 9 / Transmit Bit 8
      R9T8  : C3_R9T8_Field := 16#0#;
      --  Receive Bit 8 / Transmit Bit 9
      R8T9  : C3_R8T9_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for UART0_C3_Register use record
      PEIE  at 0 range 0 .. 0;
      FEIE  at 0 range 1 .. 1;
      NEIE  at 0 range 2 .. 2;
      ORIE  at 0 range 3 .. 3;
      TXINV at 0 range 4 .. 4;
      TXDIR at 0 range 5 .. 5;
      R9T8  at 0 range 6 .. 6;
      R8T9  at 0 range 7 .. 7;
   end record;

   subtype D_R0T0_Field is MKL25Z4.Bit;
   subtype D_R1T1_Field is MKL25Z4.Bit;
   subtype D_R2T2_Field is MKL25Z4.Bit;
   subtype D_R3T3_Field is MKL25Z4.Bit;
   subtype D_R4T4_Field is MKL25Z4.Bit;
   subtype D_R5T5_Field is MKL25Z4.Bit;
   subtype D_R6T6_Field is MKL25Z4.Bit;
   subtype D_R7T7_Field is MKL25Z4.Bit;

   --  UART Data Register
   type UART0_D_Register is record
      --  Read receive data buffer 0 or write transmit data buffer 0.
      R0T0 : D_R0T0_Field := 16#0#;
      --  Read receive data buffer 1 or write transmit data buffer 1.
      R1T1 : D_R1T1_Field := 16#0#;
      --  Read receive data buffer 2 or write transmit data buffer 2.
      R2T2 : D_R2T2_Field := 16#0#;
      --  Read receive data buffer 3 or write transmit data buffer 3.
      R3T3 : D_R3T3_Field := 16#0#;
      --  Read receive data buffer 4 or write transmit data buffer 4.
      R4T4 : D_R4T4_Field := 16#0#;
      --  Read receive data buffer 5 or write transmit data buffer 5.
      R5T5 : D_R5T5_Field := 16#0#;
      --  Read receive data buffer 6 or write transmit data buffer 6.
      R6T6 : D_R6T6_Field := 16#0#;
      --  Read receive data buffer 7 or write transmit data buffer 7.
      R7T7 : D_R7T7_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for UART0_D_Register use record
      R0T0 at 0 range 0 .. 0;
      R1T1 at 0 range 1 .. 1;
      R2T2 at 0 range 2 .. 2;
      R3T3 at 0 range 3 .. 3;
      R4T4 at 0 range 4 .. 4;
      R5T5 at 0 range 5 .. 5;
      R6T6 at 0 range 6 .. 6;
      R7T7 at 0 range 7 .. 7;
   end record;

   subtype C4_OSR_Field is Five_Bits_Type;

   --  10-bit Mode select
   type C4_M10_Field is
     (
      --  Receiver and transmitter use 8-bit or 9-bit data characters.
      C4_M10_Field_0,
      --  Receiver and transmitter use 10-bit data characters.
      C4_M10_Field_1)
     with Size => 1;
   for C4_M10_Field use
     (C4_M10_Field_0 => 0,
      C4_M10_Field_1 => 1);

   --  Match Address Mode Enable 2
   type C4_MAEN2_Field is
     (
      --  All data received is transferred to the data buffer if MAEN1 is
      --  cleared.
      C4_MAEN2_Field_0,
      --  All data received with the most significant bit cleared, is
      --  discarded. All data received with the most significant bit set, is
      --  compared with contents of MA2 register. If no match occurs, the data
      --  is discarded. If match occurs, data is transferred to the data
      --  buffer.
      C4_MAEN2_Field_1)
     with Size => 1;
   for C4_MAEN2_Field use
     (C4_MAEN2_Field_0 => 0,
      C4_MAEN2_Field_1 => 1);

   --  Match Address Mode Enable 1
   type C4_MAEN1_Field is
     (
      --  All data received is transferred to the data buffer if MAEN2 is
      --  cleared.
      C4_MAEN1_Field_0,
      --  All data received with the most significant bit cleared, is
      --  discarded. All data received with the most significant bit set, is
      --  compared with contents of MA1 register. If no match occurs, the data
      --  is discarded. If match occurs, data is transferred to the data
      --  buffer.
      C4_MAEN1_Field_1)
     with Size => 1;
   for C4_MAEN1_Field use
     (C4_MAEN1_Field_0 => 0,
      C4_MAEN1_Field_1 => 1);

   --  UART Control Register 4
   type UART0_C4_Register is record
      --  Over Sampling Ratio
      OSR   : C4_OSR_Field := 16#F#;
      --  10-bit Mode select
      M10   : C4_M10_Field := MKL25Z4.UART0.C4_M10_Field_0;
      --  Match Address Mode Enable 2
      MAEN2 : C4_MAEN2_Field := MKL25Z4.UART0.C4_MAEN2_Field_0;
      --  Match Address Mode Enable 1
      MAEN1 : C4_MAEN1_Field := MKL25Z4.UART0.C4_MAEN1_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for UART0_C4_Register use record
      OSR   at 0 range 0 .. 4;
      M10   at 0 range 5 .. 5;
      MAEN2 at 0 range 6 .. 6;
      MAEN1 at 0 range 7 .. 7;
   end record;

   --  Resynchronization Disable
   type C5_RESYNCDIS_Field is
     (
      --  Resynchronization during received data word is supported
      C5_RESYNCDIS_Field_0,
      --  Resynchronization during received data word is disabled
      C5_RESYNCDIS_Field_1)
     with Size => 1;
   for C5_RESYNCDIS_Field use
     (C5_RESYNCDIS_Field_0 => 0,
      C5_RESYNCDIS_Field_1 => 1);

   --  Both Edge Sampling
   type C5_BOTHEDGE_Field is
     (
      --  Receiver samples input data using the rising edge of the baud rate
      --  clock.
      C5_BOTHEDGE_Field_0,
      --  Receiver samples input data using the rising and falling edge of the
      --  baud rate clock.
      C5_BOTHEDGE_Field_1)
     with Size => 1;
   for C5_BOTHEDGE_Field use
     (C5_BOTHEDGE_Field_0 => 0,
      C5_BOTHEDGE_Field_1 => 1);

   --  Receiver Full DMA Enable
   type C5_RDMAE_Field is
     (
      --  DMA request disabled.
      C5_RDMAE_Field_0,
      --  DMA request enabled.
      C5_RDMAE_Field_1)
     with Size => 1;
   for C5_RDMAE_Field use
     (C5_RDMAE_Field_0 => 0,
      C5_RDMAE_Field_1 => 1);

   --  Transmitter DMA Enable
   type C5_TDMAE_Field is
     (
      --  DMA request disabled.
      C5_TDMAE_Field_0,
      --  DMA request enabled.
      C5_TDMAE_Field_1)
     with Size => 1;
   for C5_TDMAE_Field use
     (C5_TDMAE_Field_0 => 0,
      C5_TDMAE_Field_1 => 1);

   --  UART Control Register 5
   type UART0_C5_Register is record
      --  Resynchronization Disable
      RESYNCDIS    : C5_RESYNCDIS_Field := MKL25Z4.UART0.C5_RESYNCDIS_Field_0;
      --  Both Edge Sampling
      BOTHEDGE     : C5_BOTHEDGE_Field := MKL25Z4.UART0.C5_BOTHEDGE_Field_0;
      --  unspecified
      Reserved_2_4 : MKL25Z4.UInt3 := 16#0#;
      --  Receiver Full DMA Enable
      RDMAE        : C5_RDMAE_Field := MKL25Z4.UART0.C5_RDMAE_Field_0;
      --  unspecified
      Reserved_6_6 : MKL25Z4.Bit := 16#0#;
      --  Transmitter DMA Enable
      TDMAE        : C5_TDMAE_Field := MKL25Z4.UART0.C5_TDMAE_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for UART0_C5_Register use record
      RESYNCDIS    at 0 range 0 .. 0;
      BOTHEDGE     at 0 range 1 .. 1;
      Reserved_2_4 at 0 range 2 .. 4;
      RDMAE        at 0 range 5 .. 5;
      Reserved_6_6 at 0 range 6 .. 6;
      TDMAE        at 0 range 7 .. 7;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Universal Asynchronous Receiver/Transmitter
   type UART0_Peripheral is record
      --  UART Baud Rate Register High
      BDH : UART0_BDH_Register;
      --  UART Baud Rate Register Low
      BDL : MKL25Z4.Byte;
      --  UART Control Register 1
      C1  : UART0_C1_Register;
      --  UART Control Register 2
      C2  : UART0_C2_Register;
      --  UART Status Register 1
      S1  : UART0_S1_Register;
      --  UART Status Register 2
      S2  : UART0_S2_Register;
      --  UART Control Register 3
      C3  : UART0_C3_Register;
      --  UART Data Register
      D   : MKL25Z4.Byte; --  JGR change: replaced UART0_D_Register;
      --  UART Match Address Registers 1
      MA1 : MKL25Z4.Byte;
      --  UART Match Address Registers 2
      MA2 : MKL25Z4.Byte;
      --  UART Control Register 4
      C4  : UART0_C4_Register;
      --  UART Control Register 5
      C5  : UART0_C5_Register;
   end record
     with Volatile;

   for UART0_Peripheral use record
      BDH at 0 range 0 .. 7;
      BDL at 1 range 0 .. 7;
      C1  at 2 range 0 .. 7;
      C2  at 3 range 0 .. 7;
      S1  at 4 range 0 .. 7;
      S2  at 5 range 0 .. 7;
      C3  at 6 range 0 .. 7;
      D   at 7 range 0 .. 7;
      MA1 at 8 range 0 .. 7;
      MA2 at 9 range 0 .. 7;
      C4  at 10 range 0 .. 7;
      C5  at 11 range 0 .. 7;
   end record;

   --  Universal Asynchronous Receiver/Transmitter
   UART0_Periph : aliased UART0_Peripheral
     with Import, Address => UART0_Base;

end MKL25Z4.UART0;
