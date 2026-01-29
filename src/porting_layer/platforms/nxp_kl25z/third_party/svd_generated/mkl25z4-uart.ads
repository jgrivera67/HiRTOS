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

package MKL25Z4.UART with No_Elaboration_Code_All is

   ---------------
   -- Registers --
   ---------------

   subtype BDH_SBR_Field is MKL25Z4.UInt5;

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

   --  RxD Input Active Edge Interrupt Enable (for RXEDGIF)
   type BDH_RXEDGIE_Field is
     (
      --  Hardware interrupts from UART_S2[RXEDGIF] disabled (use polling).
      BDH_RXEDGIE_Field_0,
      --  Hardware interrupt requested when UART_S2[RXEDGIF] flag is 1.
      BDH_RXEDGIE_Field_1)
     with Size => 1;
   for BDH_RXEDGIE_Field use
     (BDH_RXEDGIE_Field_0 => 0,
      BDH_RXEDGIE_Field_1 => 1);

   --  LIN Break Detect Interrupt Enable (for LBKDIF)
   type BDH_LBKDIE_Field is
     (
      --  Hardware interrupts from UART_S2[LBKDIF] disabled (use polling).
      BDH_LBKDIE_Field_0,
      --  Hardware interrupt requested when UART_S2[LBKDIF] flag is 1.
      BDH_LBKDIE_Field_1)
     with Size => 1;
   for BDH_LBKDIE_Field use
     (BDH_LBKDIE_Field_0 => 0,
      BDH_LBKDIE_Field_1 => 1);

   --  UART Baud Rate Register: High
   type UART1_BDH_Register is record
      --  Baud Rate Modulo Divisor.
      SBR     : BDH_SBR_Field := 16#0#;
      --  Stop Bit Number Select
      SBNS    : BDH_SBNS_Field := MKL25Z4.UART.BDH_SBNS_Field_0;
      --  RxD Input Active Edge Interrupt Enable (for RXEDGIF)
      RXEDGIE : BDH_RXEDGIE_Field := MKL25Z4.UART.BDH_RXEDGIE_Field_0;
      --  LIN Break Detect Interrupt Enable (for LBKDIF)
      LBKDIE  : BDH_LBKDIE_Field := MKL25Z4.UART.BDH_LBKDIE_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for UART1_BDH_Register use record
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
      --  Normal - start + 8 data bits (lsb first) + stop.
      C1_M_Field_0,
      --  Receiver and transmitter use 9-bit data characters start + 8 data
      --  bits (lsb first) + 9th data bit + stop.
      C1_M_Field_1)
     with Size => 1;
   for C1_M_Field use
     (C1_M_Field_0 => 0,
      C1_M_Field_1 => 1);

   --  Receiver Source Select
   type C1_RSRC_Field is
     (
      --  Provided LOOPS is set, RSRC is cleared, selects internal loop back
      --  mode and the UART does not use the RxD pins.
      C1_RSRC_Field_0,
      --  Single-wire UART mode where the TxD pin is connected to the
      --  transmitter output and receiver input.
      C1_RSRC_Field_1)
     with Size => 1;
   for C1_RSRC_Field use
     (C1_RSRC_Field_0 => 0,
      C1_RSRC_Field_1 => 1);

   --  UART Stops in Wait Mode
   type C1_UARTSWAI_Field is
     (
      --  UART clocks continue to run in wait mode so the UART can be the
      --  source of an interrupt that wakes up the CPU.
      C1_UARTSWAI_Field_0,
      --  UART clocks freeze while CPU is in wait mode.
      C1_UARTSWAI_Field_1)
     with Size => 1;
   for C1_UARTSWAI_Field use
     (C1_UARTSWAI_Field_0 => 0,
      C1_UARTSWAI_Field_1 => 1);

   --  Loop Mode Select
   type C1_LOOPS_Field is
     (
      --  Normal operation - RxD and TxD use separate pins.
      C1_LOOPS_Field_0,
      --  Loop mode or single-wire mode where transmitter outputs are
      --  internally connected to receiver input. (See RSRC bit.) RxD pin is
      --  not used by UART.
      C1_LOOPS_Field_1)
     with Size => 1;
   for C1_LOOPS_Field use
     (C1_LOOPS_Field_0 => 0,
      C1_LOOPS_Field_1 => 1);

   --  UART Control Register 1
   type UART1_C1_Register is record
      --  Parity Type
      PT       : C1_PT_Field := MKL25Z4.UART.C1_PT_Field_0;
      --  Parity Enable
      PE       : C1_PE_Field := MKL25Z4.UART.C1_PE_Field_0;
      --  Idle Line Type Select
      ILT      : C1_ILT_Field := MKL25Z4.UART.C1_ILT_Field_0;
      --  Receiver Wakeup Method Select
      WAKE     : C1_WAKE_Field := MKL25Z4.UART.C1_WAKE_Field_0;
      --  9-Bit or 8-Bit Mode Select
      M        : C1_M_Field := MKL25Z4.UART.C1_M_Field_0;
      --  Receiver Source Select
      RSRC     : C1_RSRC_Field := MKL25Z4.UART.C1_RSRC_Field_0;
      --  UART Stops in Wait Mode
      UARTSWAI : C1_UARTSWAI_Field := MKL25Z4.UART.C1_UARTSWAI_Field_0;
      --  Loop Mode Select
      LOOPS    : C1_LOOPS_Field := MKL25Z4.UART.C1_LOOPS_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for UART1_C1_Register use record
      PT       at 0 range 0 .. 0;
      PE       at 0 range 1 .. 1;
      ILT      at 0 range 2 .. 2;
      WAKE     at 0 range 3 .. 3;
      M        at 0 range 4 .. 4;
      RSRC     at 0 range 5 .. 5;
      UARTSWAI at 0 range 6 .. 6;
      LOOPS    at 0 range 7 .. 7;
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
      --  Receiver off.
      C2_RE_Field_0,
      --  Receiver on.
      C2_RE_Field_1)
     with Size => 1;
   for C2_RE_Field use
     (C2_RE_Field_0 => 0,
      C2_RE_Field_1 => 1);

   --  Transmitter Enable
   type C2_TE_Field is
     (
      --  Transmitter off.
      C2_TE_Field_0,
      --  Transmitter on.
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
   type UART1_C2_Register is record
      --  Send Break
      SBK  : C2_SBK_Field := MKL25Z4.UART.C2_SBK_Field_0;
      --  Receiver Wakeup Control
      RWU  : C2_RWU_Field := MKL25Z4.UART.C2_RWU_Field_0;
      --  Receiver Enable
      RE   : C2_RE_Field := MKL25Z4.UART.C2_RE_Field_0;
      --  Transmitter Enable
      TE   : C2_TE_Field := MKL25Z4.UART.C2_TE_Field_0;
      --  Idle Line Interrupt Enable for IDLE
      ILIE : C2_ILIE_Field := MKL25Z4.UART.C2_ILIE_Field_0;
      --  Receiver Interrupt Enable for RDRF
      RIE  : C2_RIE_Field := MKL25Z4.UART.C2_RIE_Field_0;
      --  Transmission Complete Interrupt Enable for TC
      TCIE : C2_TCIE_Field := MKL25Z4.UART.C2_TCIE_Field_0;
      --  Transmit Interrupt Enable for TDRE
      TIE  : C2_TIE_Field := MKL25Z4.UART.C2_TIE_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for UART1_C2_Register use record
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
      --  Noise detected in the received character in UART_D.
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
      --  Receive data register empty.
      S1_RDRF_Field_0,
      --  Receive data register full.
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
      --  Transmit data register (buffer) full.
      S1_TDRE_Field_0,
      --  Transmit data register (buffer) empty.
      S1_TDRE_Field_1)
     with Size => 1;
   for S1_TDRE_Field use
     (S1_TDRE_Field_0 => 0,
      S1_TDRE_Field_1 => 1);

   --  UART Status Register 1
   type UART1_S1_Register is record
      --  Read-only. Parity Error Flag
      PF   : S1_PF_Field;
      --  Read-only. Framing Error Flag
      FE   : S1_FE_Field;
      --  Read-only. Noise Flag
      NF   : S1_NF_Field;
      --  Read-only. Receiver Overrun Flag
      OR_k : S1_OR_Field;
      --  Read-only. Idle Line Flag
      IDLE : S1_IDLE_Field;
      --  Read-only. Receive Data Register Full Flag
      RDRF : S1_RDRF_Field;
      --  Read-only. Transmission Complete Flag
      TC   : S1_TC_Field;
      --  Read-only. Transmit Data Register Empty Flag
      TDRE : S1_TDRE_Field;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for UART1_S1_Register use record
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
      --  UART receiver active (RxD input not idle).
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
      --  SBNS = 1).
      S2_LBKDE_Field_0,
      --  Break character is detected at length of 11 bit times (if M = 0, SBNS
      --  = 0) or 12 (if M = 1, SBNS = 0 or M = 0, SBNS = 1) or 13 (if M = 1,
      --  SBNS = 1).
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
      --  1, SBNS = 1).
      S2_BRK13_Field_0,
      --  Break character is transmitted with length of 13 bit times (if M = 0,
      --  SBNS = 0) or 14 (if M = 1, SBNS = 0 or M = 0, SBNS = 1) or 15 (if M =
      --  1, SBNS = 1).
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

   --  RxD Pin Active Edge Interrupt Flag
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
   type UART1_S2_Register is record
      --  Read-only. Receiver Active Flag
      RAF          : S2_RAF_Field := MKL25Z4.UART.S2_RAF_Field_0;
      --  LIN Break Detection Enable
      LBKDE        : S2_LBKDE_Field := MKL25Z4.UART.S2_LBKDE_Field_0;
      --  Break Character Generation Length
      BRK13        : S2_BRK13_Field := MKL25Z4.UART.S2_BRK13_Field_0;
      --  Receive Wake Up Idle Detect
      RWUID        : S2_RWUID_Field := MKL25Z4.UART.S2_RWUID_Field_0;
      --  Receive Data Inversion
      RXINV        : S2_RXINV_Field := MKL25Z4.UART.S2_RXINV_Field_0;
      --  unspecified
      Reserved_5_5 : MKL25Z4.Bit := 16#0#;
      --  RxD Pin Active Edge Interrupt Flag
      RXEDGIF      : S2_RXEDGIF_Field := MKL25Z4.UART.S2_RXEDGIF_Field_0;
      --  LIN Break Detect Interrupt Flag
      LBKDIF       : S2_LBKDIF_Field := MKL25Z4.UART.S2_LBKDIF_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for UART1_S2_Register use record
      RAF          at 0 range 0 .. 0;
      LBKDE        at 0 range 1 .. 1;
      BRK13        at 0 range 2 .. 2;
      RWUID        at 0 range 3 .. 3;
      RXINV        at 0 range 4 .. 4;
      Reserved_5_5 at 0 range 5 .. 5;
      RXEDGIF      at 0 range 6 .. 6;
      LBKDIF       at 0 range 7 .. 7;
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
      --  FE interrupts disabled; use polling).
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
      --  NF interrupts disabled; use polling).
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

   --  TxD Pin Direction in Single-Wire Mode
   type C3_TXDIR_Field is
     (
      --  TxD pin is an input in single-wire mode.
      C3_TXDIR_Field_0,
      --  TxD pin is an output in single-wire mode.
      C3_TXDIR_Field_1)
     with Size => 1;
   for C3_TXDIR_Field use
     (C3_TXDIR_Field_0 => 0,
      C3_TXDIR_Field_1 => 1);

   subtype C3_T8_Field is MKL25Z4.Bit;
   subtype C3_R8_Field is MKL25Z4.Bit;

   --  UART Control Register 3
   type UART1_C3_Register is record
      --  Parity Error Interrupt Enable
      PEIE  : C3_PEIE_Field := MKL25Z4.UART.C3_PEIE_Field_0;
      --  Framing Error Interrupt Enable
      FEIE  : C3_FEIE_Field := MKL25Z4.UART.C3_FEIE_Field_0;
      --  Noise Error Interrupt Enable
      NEIE  : C3_NEIE_Field := MKL25Z4.UART.C3_NEIE_Field_0;
      --  Overrun Interrupt Enable
      ORIE  : C3_ORIE_Field := MKL25Z4.UART.C3_ORIE_Field_0;
      --  Transmit Data Inversion
      TXINV : C3_TXINV_Field := MKL25Z4.UART.C3_TXINV_Field_0;
      --  TxD Pin Direction in Single-Wire Mode
      TXDIR : C3_TXDIR_Field := MKL25Z4.UART.C3_TXDIR_Field_0;
      --  Ninth Data Bit for Transmitter
      T8    : C3_T8_Field := 16#0#;
      --  Read-only. Ninth Data Bit for Receiver
      R8    : C3_R8_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for UART1_C3_Register use record
      PEIE  at 0 range 0 .. 0;
      FEIE  at 0 range 1 .. 1;
      NEIE  at 0 range 2 .. 2;
      ORIE  at 0 range 3 .. 3;
      TXINV at 0 range 4 .. 4;
      TXDIR at 0 range 5 .. 5;
      T8    at 0 range 6 .. 6;
      R8    at 0 range 7 .. 7;
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
   type UART1_D_Register is record
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

   for UART1_D_Register use record
      R0T0 at 0 range 0 .. 0;
      R1T1 at 0 range 1 .. 1;
      R2T2 at 0 range 2 .. 2;
      R3T3 at 0 range 3 .. 3;
      R4T4 at 0 range 4 .. 4;
      R5T5 at 0 range 5 .. 5;
      R6T6 at 0 range 6 .. 6;
      R7T7 at 0 range 7 .. 7;
   end record;

   --  Receiver Full DMA Select
   type C4_RDMAS_Field is
     (
      --  If RIE is set and the RDRF flag is set, the RDRF interrupt request
      --  signal is asserted to request interrupt service.
      C4_RDMAS_Field_0,
      --  If RIE is set and the RDRF flag is set, the RDRF DMA request signal
      --  is asserted to request a DMA transfer.
      C4_RDMAS_Field_1)
     with Size => 1;
   for C4_RDMAS_Field use
     (C4_RDMAS_Field_0 => 0,
      C4_RDMAS_Field_1 => 1);

   --  Transmitter DMA Select
   type C4_TDMAS_Field is
     (
      --  If TIE is set and the TDRE flag is set, the TDRE interrupt request
      --  signal is asserted to request interrupt service.
      C4_TDMAS_Field_0,
      --  If TIE is set and the TDRE flag is set, the TDRE DMA request signal
      --  is asserted to request a DMA transfer.
      C4_TDMAS_Field_1)
     with Size => 1;
   for C4_TDMAS_Field use
     (C4_TDMAS_Field_0 => 0,
      C4_TDMAS_Field_1 => 1);

   --  UART Control Register 4
   type UART1_C4_Register is record
      --  unspecified
      Reserved_0_4 : MKL25Z4.UInt5 := 16#0#;
      --  Receiver Full DMA Select
      RDMAS        : C4_RDMAS_Field := MKL25Z4.UART.C4_RDMAS_Field_0;
      --  unspecified
      Reserved_6_6 : MKL25Z4.Bit := 16#0#;
      --  Transmitter DMA Select
      TDMAS        : C4_TDMAS_Field := MKL25Z4.UART.C4_TDMAS_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for UART1_C4_Register use record
      Reserved_0_4 at 0 range 0 .. 4;
      RDMAS        at 0 range 5 .. 5;
      Reserved_6_6 at 0 range 6 .. 6;
      TDMAS        at 0 range 7 .. 7;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Universal Asynchronous Receiver/Transmitter (UART)
   type UART_Peripheral is record
      --  UART Baud Rate Register: High
      BDH : UART1_BDH_Register;
      --  UART Baud Rate Register: Low
      BDL : MKL25Z4.Byte;
      --  UART Control Register 1
      C1  : UART1_C1_Register;
      --  UART Control Register 2
      C2  : UART1_C2_Register;
      --  UART Status Register 1
      S1  : UART1_S1_Register;
      --  UART Status Register 2
      S2  : UART1_S2_Register;
      --  UART Control Register 3
      C3  : UART1_C3_Register;
      --  UART Data Register
      D   : UART1_D_Register;
      --  UART Control Register 4
      C4  : UART1_C4_Register;
   end record
     with Volatile;

   for UART_Peripheral use record
      BDH at 0 range 0 .. 7;
      BDL at 1 range 0 .. 7;
      C1  at 2 range 0 .. 7;
      C2  at 3 range 0 .. 7;
      S1  at 4 range 0 .. 7;
      S2  at 5 range 0 .. 7;
      C3  at 6 range 0 .. 7;
      D   at 7 range 0 .. 7;
      C4  at 8 range 0 .. 7;
   end record;

   --  Universal Asynchronous Receiver/Transmitter (UART)
   UART1_Periph : aliased UART_Peripheral
     with Import, Address => UART1_Base;

   --  Universal Asynchronous Receiver/Transmitter (UART)
   UART2_Periph : aliased UART_Peripheral
     with Import, Address => UART2_Base;

end MKL25Z4.UART;
