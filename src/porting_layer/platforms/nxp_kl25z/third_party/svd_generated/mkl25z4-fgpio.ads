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

package MKL25Z4.FGPIO is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   -----------------
   -- Peripherals --
   -----------------

   --  General Purpose Input/Output
   type FGPIO_Peripheral is record
      --  Port Data Output Register
      PDOR : MKL25Z4.Word;
      --  Port Set Output Register
      PSOR : MKL25Z4.Word;
      --  Port Clear Output Register
      PCOR : MKL25Z4.Word;
      --  Port Toggle Output Register
      PTOR : MKL25Z4.Word;
      --  Port Data Input Register
      PDIR : MKL25Z4.Word;
      --  Port Data Direction Register
      PDDR : MKL25Z4.Word;
   end record
     with Volatile;

   for FGPIO_Peripheral use record
      PDOR at 0 range 0 .. 31;
      PSOR at 4 range 0 .. 31;
      PCOR at 8 range 0 .. 31;
      PTOR at 12 range 0 .. 31;
      PDIR at 16 range 0 .. 31;
      PDDR at 20 range 0 .. 31;
   end record;

   --  General Purpose Input/Output
   FGPIOA_Periph : aliased FGPIO_Peripheral
     with Import, Address => FGPIOA_Base;

   --  General Purpose Input/Output
   FGPIOB_Periph : aliased FGPIO_Peripheral
     with Import, Address => FGPIOB_Base;

   --  General Purpose Input/Output
   FGPIOC_Periph : aliased FGPIO_Peripheral
     with Import, Address => FGPIOC_Base;

   --  General Purpose Input/Output
   FGPIOD_Periph : aliased FGPIO_Peripheral
     with Import, Address => FGPIOD_Base;

   --  General Purpose Input/Output
   FGPIOE_Periph : aliased FGPIO_Peripheral
     with Import, Address => FGPIOE_Base;

end MKL25Z4.FGPIO;
