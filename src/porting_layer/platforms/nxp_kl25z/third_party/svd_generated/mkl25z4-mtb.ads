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

--  Micro Trace Buffer
package MKL25Z4.MTB is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype POSITION_WRAP_Field is MKL25Z4.Bit;
   subtype POSITION_POINTER_Field is MKL25Z4.UInt29;

   --  MTB Position Register
   type MTB_POSITION_Register is record
      --  unspecified
      Reserved_0_1 : MKL25Z4.UInt2 := 16#0#;
      --  This bit is set to 1 automatically when the POINTER value wraps as
      --  determined by the MTB_MASTER[MASK] bit in the MASTER Trace Control
      --  Register
      WRAP         : POSITION_WRAP_Field := 16#0#;
      --  Trace Packet Address Pointer
      POINTER      : POSITION_POINTER_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MTB_POSITION_Register use record
      Reserved_0_1 at 0 range 0 .. 1;
      WRAP         at 0 range 2 .. 2;
      POINTER      at 0 range 3 .. 31;
   end record;

   subtype MASTER_MASK_Field is MKL25Z4.UInt5;
   subtype MASTER_TSTARTEN_Field is MKL25Z4.Bit;
   subtype MASTER_TSTOPEN_Field is MKL25Z4.Bit;
   subtype MASTER_SFRWPRIV_Field is MKL25Z4.Bit;
   subtype MASTER_RAMPRIV_Field is MKL25Z4.Bit;
   subtype MASTER_HALTREQ_Field is MKL25Z4.Bit;
   subtype MASTER_EN_Field is MKL25Z4.Bit;

   --  MTB Master Register
   type MTB_MASTER_Register is record
      --  Mask
      MASK           : MASTER_MASK_Field := 16#0#;
      --  Trace start input enable
      TSTARTEN       : MASTER_TSTARTEN_Field := 16#0#;
      --  Trace stop input enable
      TSTOPEN        : MASTER_TSTOPEN_Field := 16#0#;
      --  Special Function Register Write Privilege bit
      SFRWPRIV       : MASTER_SFRWPRIV_Field := 16#1#;
      --  RAM privilege bit
      RAMPRIV        : MASTER_RAMPRIV_Field := 16#0#;
      --  Halt request bit
      HALTREQ        : MASTER_HALTREQ_Field := 16#0#;
      --  unspecified
      Reserved_10_30 : MKL25Z4.UInt21 := 16#0#;
      --  Main trace enable bit
      EN             : MASTER_EN_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MTB_MASTER_Register use record
      MASK           at 0 range 0 .. 4;
      TSTARTEN       at 0 range 5 .. 5;
      TSTOPEN        at 0 range 6 .. 6;
      SFRWPRIV       at 0 range 7 .. 7;
      RAMPRIV        at 0 range 8 .. 8;
      HALTREQ        at 0 range 9 .. 9;
      Reserved_10_30 at 0 range 10 .. 30;
      EN             at 0 range 31 .. 31;
   end record;

   subtype FLOW_AUTOSTOP_Field is MKL25Z4.Bit;
   subtype FLOW_AUTOHALT_Field is MKL25Z4.Bit;
   subtype FLOW_WATERMARK_Field is MKL25Z4.UInt29;

   --  MTB Flow Register
   type MTB_FLOW_Register is record
      --  If this bit is 1 and WATERMARK is equal to MTB_POSITION[POINTER],
      --  then the MTB_MASTER[EN] bit is automatically set to 0
      AUTOSTOP     : FLOW_AUTOSTOP_Field := 16#0#;
      --  If this bit is 1 and WATERMARK is equal to MTB_POSITION[POINTER],
      --  then the MTB_MASTER[HALTREQ] bit is automatically set to 1
      AUTOHALT     : FLOW_AUTOHALT_Field := 16#0#;
      --  unspecified
      Reserved_2_2 : MKL25Z4.Bit := 16#0#;
      --  WATERMARK value
      WATERMARK    : FLOW_WATERMARK_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MTB_FLOW_Register use record
      AUTOSTOP     at 0 range 0 .. 0;
      AUTOHALT     at 0 range 1 .. 1;
      Reserved_2_2 at 0 range 2 .. 2;
      WATERMARK    at 0 range 3 .. 31;
   end record;

   ------------------
   -- AUTHSTAT.BIT --
   ------------------

   --  AUTHSTAT_BIT array element
   subtype AUTHSTAT_BIT_Element is MKL25Z4.Bit;

   --  AUTHSTAT_BIT array
   type AUTHSTAT_BIT_Field_Array is array (0 .. 3) of AUTHSTAT_BIT_Element
     with Component_Size => 1, Size => 4;

   --  Type definition for AUTHSTAT_BIT
   type AUTHSTAT_BIT_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  BIT as a value
            Val : MKL25Z4.UInt4;
         when True =>
            --  BIT as an array
            Arr : AUTHSTAT_BIT_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 4;

   for AUTHSTAT_BIT_Field use record
      Val at 0 range 0 .. 3;
      Arr at 0 range 0 .. 3;
   end record;

   --  Authentication Status Register
   type MTB_AUTHSTAT_Register is record
      --  Read-only. Connected to DBGEN.
      BIT           : AUTHSTAT_BIT_Field;
      --  unspecified
      Reserved_4_31 : MKL25Z4.UInt28;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MTB_AUTHSTAT_Register use record
      BIT           at 0 range 0 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   --  Peripheral ID Register

   --  Peripheral ID Register
   type MTB_PERIPHID_Registers is array (0 .. 7) of MKL25Z4.Word;

   --  Component ID Register

   --  Component ID Register
   type MTB_COMPID_Registers is array (0 .. 3) of MKL25Z4.Word;

   -----------------
   -- Peripherals --
   -----------------

   --  Micro Trace Buffer
   type MTB_Peripheral is record
      --  MTB Position Register
      POSITION    : MTB_POSITION_Register;
      --  MTB Master Register
      MASTER      : MTB_MASTER_Register;
      --  MTB Flow Register
      FLOW        : MTB_FLOW_Register;
      --  MTB Base Register
      BASE        : MKL25Z4.Word;
      --  Integration Mode Control Register
      MODECTRL    : MKL25Z4.Word;
      --  Claim TAG Set Register
      TAGSET      : MKL25Z4.Word;
      --  Claim TAG Clear Register
      TAGCLEAR    : MKL25Z4.Word;
      --  Lock Access Register
      LOCKACCESS  : MKL25Z4.Word;
      --  Lock Status Register
      LOCKSTAT    : MKL25Z4.Word;
      --  Authentication Status Register
      AUTHSTAT    : MTB_AUTHSTAT_Register;
      --  Device Architecture Register
      DEVICEARCH  : MKL25Z4.Word;
      --  Device Configuration Register
      DEVICECFG   : MKL25Z4.Word;
      --  Device Type Identifier Register
      DEVICETYPID : MKL25Z4.Word;
      --  Peripheral ID Register
      PERIPHID    : MTB_PERIPHID_Registers;
      --  Component ID Register
      COMPID      : MTB_COMPID_Registers;
   end record
     with Volatile;

   for MTB_Peripheral use record
      POSITION    at 0 range 0 .. 31;
      MASTER      at 4 range 0 .. 31;
      FLOW        at 8 range 0 .. 31;
      BASE        at 12 range 0 .. 31;
      MODECTRL    at 3840 range 0 .. 31;
      TAGSET      at 4000 range 0 .. 31;
      TAGCLEAR    at 4004 range 0 .. 31;
      LOCKACCESS  at 4016 range 0 .. 31;
      LOCKSTAT    at 4020 range 0 .. 31;
      AUTHSTAT    at 4024 range 0 .. 31;
      DEVICEARCH  at 4028 range 0 .. 31;
      DEVICECFG   at 4040 range 0 .. 31;
      DEVICETYPID at 4044 range 0 .. 31;
      PERIPHID    at 4048 range 0 .. 255;
      COMPID      at 4080 range 0 .. 127;
   end record;

   --  Micro Trace Buffer
   MTB_Periph : aliased MTB_Peripheral
     with Import, Address => MTB_Base;

end MKL25Z4.MTB;
