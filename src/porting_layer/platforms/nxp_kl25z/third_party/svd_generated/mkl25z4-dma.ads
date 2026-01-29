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

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;

with System;

--  DMA Controller
package MKL25Z4.DMA is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype DSR_BCR0_BCR_Field is MKL25Z4.UInt24;

   --  Transactions done
   type DSR_BCR0_DONE_Field is
     (
      --  DMA transfer is not yet complete. Writing a 0 has no effect.
      DSR_BCR0_DONE_Field_0,
      --  DMA transfer completed. Writing a 1 to this bit clears all DMA status
      --  bits and should be used in an interrupt service routine to clear the
      --  DMA interrupt and error bits.
      DSR_BCR0_DONE_Field_1)
     with Size => 1;
   for DSR_BCR0_DONE_Field use
     (DSR_BCR0_DONE_Field_0 => 0,
      DSR_BCR0_DONE_Field_1 => 1);

   --  Busy
   type DSR_BCR0_BSY_Field is
     (
      --  DMA channel is inactive. Cleared when the DMA has finished the last
      --  transaction.
      DSR_BCR0_BSY_Field_0,
      --  BSY is set the first time the channel is enabled after a transfer is
      --  initiated.
      DSR_BCR0_BSY_Field_1)
     with Size => 1;
   for DSR_BCR0_BSY_Field use
     (DSR_BCR0_BSY_Field_0 => 0,
      DSR_BCR0_BSY_Field_1 => 1);

   --  Request
   type DSR_BCR0_REQ_Field is
     (
      --  No request is pending or the channel is currently active. Cleared
      --  when the channel is selected.
      DSR_BCR0_REQ_Field_0,
      --  The DMA channel has a transfer remaining and the channel is not
      --  selected.
      DSR_BCR0_REQ_Field_1)
     with Size => 1;
   for DSR_BCR0_REQ_Field use
     (DSR_BCR0_REQ_Field_0 => 0,
      DSR_BCR0_REQ_Field_1 => 1);

   --  Bus error on destination
   type DSR_BCR0_BED_Field is
     (
      --  No bus error occurred.
      DSR_BCR0_BED_Field_0,
      --  The DMA channel terminated with a bus error during the write portion
      --  of a transfer.
      DSR_BCR0_BED_Field_1)
     with Size => 1;
   for DSR_BCR0_BED_Field use
     (DSR_BCR0_BED_Field_0 => 0,
      DSR_BCR0_BED_Field_1 => 1);

   --  Bus error on source
   type DSR_BCR0_BES_Field is
     (
      --  No bus error occurred.
      DSR_BCR0_BES_Field_0,
      --  The DMA channel terminated with a bus error during the read portion
      --  of a transfer.
      DSR_BCR0_BES_Field_1)
     with Size => 1;
   for DSR_BCR0_BES_Field use
     (DSR_BCR0_BES_Field_0 => 0,
      DSR_BCR0_BES_Field_1 => 1);

   --  Configuration error
   type DSR_BCR0_CE_Field is
     (
      --  No configuration error exists.
      DSR_BCR0_CE_Field_0,
      --  A configuration error has occurred.
      DSR_BCR0_CE_Field_1)
     with Size => 1;
   for DSR_BCR0_CE_Field use
     (DSR_BCR0_CE_Field_0 => 0,
      DSR_BCR0_CE_Field_1 => 1);

   --  DMA Status Register / Byte Count Register
   type DSR_BCR_Register is record
      --  This field contains the number of bytes yet to be transferred for a
      --  given block
      BCR            : DSR_BCR0_BCR_Field := 16#0#;
      --  Transactions done
      DONE           : DSR_BCR0_DONE_Field :=
                        MKL25Z4.DMA.DSR_BCR0_DONE_Field_0;
      --  Read-only. Busy
      BSY            : DSR_BCR0_BSY_Field := MKL25Z4.DMA.DSR_BCR0_BSY_Field_0;
      --  Read-only. Request
      REQ            : DSR_BCR0_REQ_Field := MKL25Z4.DMA.DSR_BCR0_REQ_Field_0;
      --  unspecified
      Reserved_27_27 : MKL25Z4.Bit := 16#0#;
      --  Read-only. Bus error on destination
      BED            : DSR_BCR0_BED_Field := MKL25Z4.DMA.DSR_BCR0_BED_Field_0;
      --  Read-only. Bus error on source
      BES            : DSR_BCR0_BES_Field := MKL25Z4.DMA.DSR_BCR0_BES_Field_0;
      --  Read-only. Configuration error
      CE             : DSR_BCR0_CE_Field := MKL25Z4.DMA.DSR_BCR0_CE_Field_0;
      --  unspecified
      Reserved_31_31 : MKL25Z4.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for DSR_BCR_Register use record
      BCR            at 0 range 0 .. 23;
      DONE           at 0 range 24 .. 24;
      BSY            at 0 range 25 .. 25;
      REQ            at 0 range 26 .. 26;
      Reserved_27_27 at 0 range 27 .. 27;
      BED            at 0 range 28 .. 28;
      BES            at 0 range 29 .. 29;
      CE             at 0 range 30 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   --  Link channel 2
   type DCR0_LCH2_Field is
     (
      --  DMA Channel 0
      DCR0_LCH2_Field_00,
      --  DMA Channel 1
      DCR0_LCH2_Field_01,
      --  DMA Channel 2
      DCR0_LCH2_Field_10,
      --  DMA Channel 3
      DCR0_LCH2_Field_11)
     with Size => 2;
   for DCR0_LCH2_Field use
     (DCR0_LCH2_Field_00 => 0,
      DCR0_LCH2_Field_01 => 1,
      DCR0_LCH2_Field_10 => 2,
      DCR0_LCH2_Field_11 => 3);

   --------------
   -- DCR0.LCH --
   --------------

   --  DCR0_LCH array
   type DCR0_LCH_Field_Array is array (1 .. 2) of DCR0_LCH2_Field
     with Component_Size => 2, Size => 4;

   --  Type definition for DCR0_LCH
   type DCR0_LCH_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  LCH as a value
            Val : MKL25Z4.UInt4;
         when True =>
            --  LCH as an array
            Arr : DCR0_LCH_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 4;

   for DCR0_LCH_Field use record
      Val at 0 range 0 .. 3;
      Arr at 0 range 0 .. 3;
   end record;

   --  Link channel control
   type DCR0_LINKCC_Field is
     (
      --  No channel-to-channel linking
      DCR0_LINKCC_Field_00,
      --  Perform a link to channel LCH1 after each cycle-steal transfer
      --  followed by a link to LCH2 after the BCR decrements to zero
      DCR0_LINKCC_Field_01,
      --  Perform a link to channel LCH1 after each cycle-steal transfer
      DCR0_LINKCC_Field_10,
      --  Perform a link to channel LCH1 after the BCR decrements to zero
      DCR0_LINKCC_Field_11)
     with Size => 2;
   for DCR0_LINKCC_Field use
     (DCR0_LINKCC_Field_00 => 0,
      DCR0_LINKCC_Field_01 => 1,
      DCR0_LINKCC_Field_10 => 2,
      DCR0_LINKCC_Field_11 => 3);

   --  Disable request
   type DCR0_D_REQ_Field is
     (
      --  ERQ bit is not affected.
      DCR0_D_REQ_Field_0,
      --  ERQ bit is cleared when the BCR is exhausted.
      DCR0_D_REQ_Field_1)
     with Size => 1;
   for DCR0_D_REQ_Field use
     (DCR0_D_REQ_Field_0 => 0,
      DCR0_D_REQ_Field_1 => 1);

   --  Destination address modulo
   type DCR0_DMOD_Field is
     (
      --  Buffer disabled
      DCR0_DMOD_Field_0000,
      --  Circular buffer size is 16 bytes
      DCR0_DMOD_Field_0001,
      --  Circular buffer size is 32 bytes
      DCR0_DMOD_Field_0010,
      --  Circular buffer size is 64 bytes
      DCR0_DMOD_Field_0011,
      --  Circular buffer size is 128 bytes
      DCR0_DMOD_Field_0100,
      --  Circular buffer size is 256 bytes
      DCR0_DMOD_Field_0101,
      --  Circular buffer size is 512 bytes
      DCR0_DMOD_Field_0110,
      --  Circular buffer size is 1 KB
      DCR0_DMOD_Field_0111,
      --  Circular buffer size is 2 KB
      DCR0_DMOD_Field_1000,
      --  Circular buffer size is 4 KB
      DCR0_DMOD_Field_1001,
      --  Circular buffer size is 8 KB
      DCR0_DMOD_Field_1010,
      --  Circular buffer size is 16 KB
      DCR0_DMOD_Field_1011,
      --  Circular buffer size is 32 KB
      DCR0_DMOD_Field_1100,
      --  Circular buffer size is 64 KB
      DCR0_DMOD_Field_1101,
      --  Circular buffer size is 128 KB
      DCR0_DMOD_Field_1110,
      --  Circular buffer size is 256 KB
      DCR0_DMOD_Field_1111)
     with Size => 4;
   for DCR0_DMOD_Field use
     (DCR0_DMOD_Field_0000 => 0,
      DCR0_DMOD_Field_0001 => 1,
      DCR0_DMOD_Field_0010 => 2,
      DCR0_DMOD_Field_0011 => 3,
      DCR0_DMOD_Field_0100 => 4,
      DCR0_DMOD_Field_0101 => 5,
      DCR0_DMOD_Field_0110 => 6,
      DCR0_DMOD_Field_0111 => 7,
      DCR0_DMOD_Field_1000 => 8,
      DCR0_DMOD_Field_1001 => 9,
      DCR0_DMOD_Field_1010 => 10,
      DCR0_DMOD_Field_1011 => 11,
      DCR0_DMOD_Field_1100 => 12,
      DCR0_DMOD_Field_1101 => 13,
      DCR0_DMOD_Field_1110 => 14,
      DCR0_DMOD_Field_1111 => 15);

   --  Source address modulo
   type DCR0_SMOD_Field is
     (
      --  Buffer disabled
      DCR0_SMOD_Field_0000,
      --  Circular buffer size is 16 bytes
      DCR0_SMOD_Field_0001,
      --  Circular buffer size is 32 bytes
      DCR0_SMOD_Field_0010,
      --  Circular buffer size is 64 bytes
      DCR0_SMOD_Field_0011,
      --  Circular buffer size is 128 bytes
      DCR0_SMOD_Field_0100,
      --  Circular buffer size is 256 bytes
      DCR0_SMOD_Field_0101,
      --  Circular buffer size is 512 bytes
      DCR0_SMOD_Field_0110,
      --  Circular buffer size is 1 KB
      DCR0_SMOD_Field_0111,
      --  Circular buffer size is 2 KB
      DCR0_SMOD_Field_1000,
      --  Circular buffer size is 4 KB
      DCR0_SMOD_Field_1001,
      --  Circular buffer size is 8 KB
      DCR0_SMOD_Field_1010,
      --  Circular buffer size is 16 KB
      DCR0_SMOD_Field_1011,
      --  Circular buffer size is 32 KB
      DCR0_SMOD_Field_1100,
      --  Circular buffer size is 64 KB
      DCR0_SMOD_Field_1101,
      --  Circular buffer size is 128 KB
      DCR0_SMOD_Field_1110,
      --  Circular buffer size is 256 KB
      DCR0_SMOD_Field_1111)
     with Size => 4;
   for DCR0_SMOD_Field use
     (DCR0_SMOD_Field_0000 => 0,
      DCR0_SMOD_Field_0001 => 1,
      DCR0_SMOD_Field_0010 => 2,
      DCR0_SMOD_Field_0011 => 3,
      DCR0_SMOD_Field_0100 => 4,
      DCR0_SMOD_Field_0101 => 5,
      DCR0_SMOD_Field_0110 => 6,
      DCR0_SMOD_Field_0111 => 7,
      DCR0_SMOD_Field_1000 => 8,
      DCR0_SMOD_Field_1001 => 9,
      DCR0_SMOD_Field_1010 => 10,
      DCR0_SMOD_Field_1011 => 11,
      DCR0_SMOD_Field_1100 => 12,
      DCR0_SMOD_Field_1101 => 13,
      DCR0_SMOD_Field_1110 => 14,
      DCR0_SMOD_Field_1111 => 15);

   --  Start transfer
   type DCR0_START_Field is
     (
      --  DMA inactive
      DCR0_START_Field_0,
      --  The DMA begins the transfer in accordance to the values in the TCDn.
      --  START is cleared automatically after one module clock and always
      --  reads as logic 0.
      DCR0_START_Field_1)
     with Size => 1;
   for DCR0_START_Field use
     (DCR0_START_Field_0 => 0,
      DCR0_START_Field_1 => 1);

   --  Destination size
   type DCR0_DSIZE_Field is
     (
      --  32-bit
      DCR0_DSIZE_Field_00,
      --  8-bit
      DCR0_DSIZE_Field_01,
      --  16-bit
      DCR0_DSIZE_Field_10,
      --  Reserved (generates a configuration error (DSRn[CE]) if incorrectly
      --  specified at time of channel activation)
      DCR0_DSIZE_Field_11)
     with Size => 2;
   for DCR0_DSIZE_Field use
     (DCR0_DSIZE_Field_00 => 0,
      DCR0_DSIZE_Field_01 => 1,
      DCR0_DSIZE_Field_10 => 2,
      DCR0_DSIZE_Field_11 => 3);

   --  Destination increment
   type DCR0_DINC_Field is
     (
      --  No change to the DAR after a successful transfer.
      DCR0_DINC_Field_0,
      --  The DAR increments by 1, 2, 4 depending upon the size of the
      --  transfer.
      DCR0_DINC_Field_1)
     with Size => 1;
   for DCR0_DINC_Field use
     (DCR0_DINC_Field_0 => 0,
      DCR0_DINC_Field_1 => 1);

   --  Source size
   type DCR0_SSIZE_Field is
     (
      --  32-bit
      DCR0_SSIZE_Field_00,
      --  8-bit
      DCR0_SSIZE_Field_01,
      --  16-bit
      DCR0_SSIZE_Field_10,
      --  Reserved (generates a configuration error (DSRn[CE]) if incorrectly
      --  specified at time of channel activation)
      DCR0_SSIZE_Field_11)
     with Size => 2;
   for DCR0_SSIZE_Field use
     (DCR0_SSIZE_Field_00 => 0,
      DCR0_SSIZE_Field_01 => 1,
      DCR0_SSIZE_Field_10 => 2,
      DCR0_SSIZE_Field_11 => 3);

   --  Source increment
   type DCR0_SINC_Field is
     (
      --  No change to SAR after a successful transfer.
      DCR0_SINC_Field_0,
      --  The SAR increments by 1, 2, 4 as determined by the transfer size.
      DCR0_SINC_Field_1)
     with Size => 1;
   for DCR0_SINC_Field use
     (DCR0_SINC_Field_0 => 0,
      DCR0_SINC_Field_1 => 1);

   --  Enable asynchronous DMA requests
   type DCR0_EADREQ_Field is
     (
      --  Disabled
      DCR0_EADREQ_Field_0,
      --  Enabled
      DCR0_EADREQ_Field_1)
     with Size => 1;
   for DCR0_EADREQ_Field use
     (DCR0_EADREQ_Field_0 => 0,
      DCR0_EADREQ_Field_1 => 1);

   --  Auto-align
   type DCR0_AA_Field is
     (
      --  Auto-align disabled
      DCR0_AA_Field_0,
      --  If SSIZE indicates a transfer no smaller than DSIZE, source accesses
      --  are auto-aligned; otherwise, destination accesses are auto-aligned.
      --  Source alignment takes precedence over destination alignment. If
      --  auto-alignment is enabled, the appropriate address register
      --  increments, regardless of DINC or SINC.
      DCR0_AA_Field_1)
     with Size => 1;
   for DCR0_AA_Field use
     (DCR0_AA_Field_0 => 0,
      DCR0_AA_Field_1 => 1);

   --  Cycle steal
   type DCR0_CS_Field is
     (
      --  DMA continuously makes read/write transfers until the BCR decrements
      --  to 0.
      DCR0_CS_Field_0,
      --  Forces a single read/write transfer per request.
      DCR0_CS_Field_1)
     with Size => 1;
   for DCR0_CS_Field use
     (DCR0_CS_Field_0 => 0,
      DCR0_CS_Field_1 => 1);

   --  Enable peripheral request
   type DCR0_ERQ_Field is
     (
      --  Peripheral request is ignored.
      DCR0_ERQ_Field_0,
      --  Enables peripheral request to initiate transfer. A software-initiated
      --  request (setting the START bit) is always enabled.
      DCR0_ERQ_Field_1)
     with Size => 1;
   for DCR0_ERQ_Field use
     (DCR0_ERQ_Field_0 => 0,
      DCR0_ERQ_Field_1 => 1);

   --  Enable interrupt on completion of transfer
   type DCR0_EINT_Field is
     (
      --  No interrupt is generated.
      DCR0_EINT_Field_0,
      --  Interrupt signal is enabled.
      DCR0_EINT_Field_1)
     with Size => 1;
   for DCR0_EINT_Field use
     (DCR0_EINT_Field_0 => 0,
      DCR0_EINT_Field_1 => 1);

   --  DMA Control Register
   type DCR_Register is record
      --  Link channel 2
      LCH            : DCR0_LCH_Field := (As_Array => False, Val => 16#0#);
      --  Link channel control
      LINKCC         : DCR0_LINKCC_Field := MKL25Z4.DMA.DCR0_LINKCC_Field_00;
      --  unspecified
      Reserved_6_6   : MKL25Z4.Bit := 16#0#;
      --  Disable request
      D_REQ          : DCR0_D_REQ_Field := MKL25Z4.DMA.DCR0_D_REQ_Field_0;
      --  Destination address modulo
      DMOD           : DCR0_DMOD_Field := MKL25Z4.DMA.DCR0_DMOD_Field_0000;
      --  Source address modulo
      SMOD           : DCR0_SMOD_Field := MKL25Z4.DMA.DCR0_SMOD_Field_0000;
      --  Write-only. Start transfer
      START          : DCR0_START_Field := MKL25Z4.DMA.DCR0_START_Field_0;
      --  Destination size
      DSIZE          : DCR0_DSIZE_Field := MKL25Z4.DMA.DCR0_DSIZE_Field_00;
      --  Destination increment
      DINC           : DCR0_DINC_Field := MKL25Z4.DMA.DCR0_DINC_Field_0;
      --  Source size
      SSIZE          : DCR0_SSIZE_Field := MKL25Z4.DMA.DCR0_SSIZE_Field_00;
      --  Source increment
      SINC           : DCR0_SINC_Field := MKL25Z4.DMA.DCR0_SINC_Field_0;
      --  Enable asynchronous DMA requests
      EADREQ         : DCR0_EADREQ_Field := MKL25Z4.DMA.DCR0_EADREQ_Field_0;
      --  unspecified
      Reserved_24_27 : MKL25Z4.UInt4 := 16#0#;
      --  Auto-align
      AA             : DCR0_AA_Field := MKL25Z4.DMA.DCR0_AA_Field_0;
      --  Cycle steal
      CS             : DCR0_CS_Field := MKL25Z4.DMA.DCR0_CS_Field_0;
      --  Enable peripheral request
      ERQ            : DCR0_ERQ_Field := MKL25Z4.DMA.DCR0_ERQ_Field_0;
      --  Enable interrupt on completion of transfer
      EINT           : DCR0_EINT_Field := MKL25Z4.DMA.DCR0_EINT_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for DCR_Register use record
      LCH            at 0 range 0 .. 3;
      LINKCC         at 0 range 4 .. 5;
      Reserved_6_6   at 0 range 6 .. 6;
      D_REQ          at 0 range 7 .. 7;
      DMOD           at 0 range 8 .. 11;
      SMOD           at 0 range 12 .. 15;
      START          at 0 range 16 .. 16;
      DSIZE          at 0 range 17 .. 18;
      DINC           at 0 range 19 .. 19;
      SSIZE          at 0 range 20 .. 21;
      SINC           at 0 range 22 .. 22;
      EADREQ         at 0 range 23 .. 23;
      Reserved_24_27 at 0 range 24 .. 27;
      AA             at 0 range 28 .. 28;
      CS             at 0 range 29 .. 29;
      ERQ            at 0 range 30 .. 30;
      EINT           at 0 range 31 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  DMA Controller
   type DMA_Peripheral is record
      --  Source Address Register
      SAR0     : MKL25Z4.Word;
      --  Destination Address Register
      DAR0     : MKL25Z4.Word;
      --  DMA Status Register / Byte Count Register
      DSR_BCR0 : DSR_BCR_Register;
      --  DMA_DSR0 register.
      DSR0     : MKL25Z4.Byte;
      --  DMA Control Register
      DCR0     : DCR_Register;
      --  Source Address Register
      SAR1     : MKL25Z4.Word;
      --  Destination Address Register
      DAR1     : MKL25Z4.Word;
      --  DMA Status Register / Byte Count Register
      DSR_BCR1 : DSR_BCR_Register;
      --  DMA_DSR1 register.
      DSR1     : MKL25Z4.Byte;
      --  DMA Control Register
      DCR1     : DCR_Register;
      --  Source Address Register
      SAR2     : MKL25Z4.Word;
      --  Destination Address Register
      DAR2     : MKL25Z4.Word;
      --  DMA Status Register / Byte Count Register
      DSR_BCR2 : DSR_BCR_Register;
      --  DMA_DSR2 register.
      DSR2     : MKL25Z4.Byte;
      --  DMA Control Register
      DCR2     : DCR_Register;
      --  Source Address Register
      SAR3     : MKL25Z4.Word;
      --  Destination Address Register
      DAR3     : MKL25Z4.Word;
      --  DMA Status Register / Byte Count Register
      DSR_BCR3 : DSR_BCR_Register;
      --  DMA_DSR3 register.
      DSR3     : MKL25Z4.Byte;
      --  DMA Control Register
      DCR3     : DCR_Register;
   end record
     with Volatile;

   for DMA_Peripheral use record
      SAR0     at 256 range 0 .. 31;
      DAR0     at 260 range 0 .. 31;
      DSR_BCR0 at 264 range 0 .. 31;
      DSR0     at 267 range 0 .. 7;
      DCR0     at 268 range 0 .. 31;
      SAR1     at 272 range 0 .. 31;
      DAR1     at 276 range 0 .. 31;
      DSR_BCR1 at 280 range 0 .. 31;
      DSR1     at 283 range 0 .. 7;
      DCR1     at 284 range 0 .. 31;
      SAR2     at 288 range 0 .. 31;
      DAR2     at 292 range 0 .. 31;
      DSR_BCR2 at 296 range 0 .. 31;
      DSR2     at 299 range 0 .. 7;
      DCR2     at 300 range 0 .. 31;
      SAR3     at 304 range 0 .. 31;
      DAR3     at 308 range 0 .. 31;
      DSR_BCR3 at 312 range 0 .. 31;
      DSR3     at 315 range 0 .. 7;
      DCR3     at 316 range 0 .. 31;
   end record;

   --  DMA Controller
   DMA_Periph : aliased DMA_Peripheral
     with Import, Address => DMA_Base;

end MKL25Z4.DMA;
