--
--  Copyright (c) 2024, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary HiRTOS to target platform interface - Thread CPU context declarations
--

with System.Storage_Elements;
with Bit_Sized_Integer_Types;

package HiRTOS_Cpu_Arch_Interface.Thread_Context with SPARK_Mode => On is

   type Cpu_Context_Type is private;

   --
   --  RISCV privilege modes (values for mstatus.MPP)
   --
   type Mstatus_Mpp_Values_Type is (Mstatus_Mpp_User_Mode,
                                    Mstatus_Mpp_Supervisor_Mode,
                                    Mstatus_Mpp_Machine_Mode)
      with Size => 2;

   for Mstatus_Mpp_Values_Type use (Mstatus_Mpp_User_Mode => 0,
                                    Mstatus_Mpp_Supervisor_Mode => 1,
                                    Mstatus_Mpp_Machine_Mode => 3);

   type MSTATUS_Type (As_Register : Boolean := False) is record
      case As_Register is
         when True =>
            Value : Cpu_Register_Type := 0;
         when False =>
            UIE :  Bit_Sized_Integer_Types.Bit_Type := 0;
            SIE :  Bit_Sized_Integer_Types.Bit_Type := 0;
            HIE :  Bit_Sized_Integer_Types.Bit_Type := 0;
            MIE :  Bit_Sized_Integer_Types.Bit_Type := 0;
            UPIE : Bit_Sized_Integer_Types.Bit_Type := 0;
            SPIE : Bit_Sized_Integer_Types.Bit_Type := 0;
            HPIE : Bit_Sized_Integer_Types.Bit_Type := 0;
            MPIE : Bit_Sized_Integer_Types.Bit_Type := 0;
            SPP  : Bit_Sized_Integer_Types.Bit_Type := 0;
            HPP  : Bit_Sized_Integer_Types.Two_Bits_Type := 0;
            MPP  : Mstatus_Mpp_Values_Type := Mstatus_Mpp_User_Mode;
            FS   : Bit_Sized_Integer_Types.Two_Bits_Type := 0;
            XS   : Bit_Sized_Integer_Types.Two_Bits_Type := 0;
            MPRV : Bit_Sized_Integer_Types.Bit_Type := 0;
            SUM  : Bit_Sized_Integer_Types.Bit_Type := 0;
            MXR  : Bit_Sized_Integer_Types.Bit_Type := 0;
            TVM  : Bit_Sized_Integer_Types.Bit_Type := 0;
            TW   : Bit_Sized_Integer_Types.Bit_Type := 0;
            TSR  : Bit_Sized_Integer_Types.Bit_Type := 0;
            SD   : Bit_Sized_Integer_Types.Bit_Type := 0;
      end case;
   end record with Size => Cpu_Register_Type'Size,
                   Bit_Order => System.Low_Order_First,
                   Unchecked_Union;

   for MSTATUS_Type use record
      Value at 0 range 0 .. 31;
      UIE  at 0 range 0 .. 0;
      SIE  at 0 range 1 .. 1;
      HIE  at 0 range 2 .. 2;
      MIE  at 0 range 3 .. 3;
      UPIE  at 0 range 4 .. 4;
      SPIE  at 0 range 5 .. 5;
      HPIE  at 0 range 6 .. 6;
      MPIE  at 0 range 7 .. 7;
      SPP   at 0 range 8 .. 8;
      HPP   at 0 range 9 .. 10;
      MPP   at 0 range 11 .. 12;
      FS    at 0 range 13 .. 14;
      XS    at 0 range 15 .. 16;
      MPRV  at 0 range 17 .. 17;
      SUM   at 0 range 18 .. 18;
      MXR   at 0 range 19 .. 19;
      TVM   at 0 range 20 .. 20;
      TW    at 0 range 21 .. 21;
      TSR   at 0 range 22 .. 22;
      SD    at 0 range 31 .. 31;
   end record;

   --  Initialize a thread's CPU context
   --
   procedure Initialize_Thread_Cpu_Context (Thread_Cpu_Context : out Cpu_Context_Type;
                                            Entry_Point_Address : Cpu_Register_Type;
                                            Thread_Arg : Cpu_Register_Type;
                                            Stack_End_Address : Cpu_Register_Type);

   --
   --  Perform the first thread thread context switch
   --
   procedure First_Thread_Context_Switch with No_Return;

   --
   --  Perform a synchronous thread context switch
   --
   procedure Synchronous_Thread_Context_Switch;

   function  Get_Saved_PC (Cpu_Context : Cpu_Context_Type) return System.Address;

   function Get_Saved_CPSR (Cpu_Context : Cpu_Context_Type) return Cpu_Register_Type;

private

   --
   --  CPU context saved on the current's stack on entry to ISRs and on synchronous
   --  task context switches. Fields are in the exact order as the will be stored on the
   --  stack.
   --
   type Cpu_Context_Type is record
      RA : Cpu_Register_Type;  --  also known as register X1
      SP : Cpu_Register_Type;  --  also known as register X2
      GP : Cpu_Register_Type;  --  also known as register X3
      TP : Cpu_Register_Type;  --  also known as register X4
      T0 : Cpu_Register_Type;  --  also known as register X5
      T1 : Cpu_Register_Type;  --  also known as register X6
      T2 : Cpu_Register_Type;  --  also known as register X7
      FP : Cpu_Register_Type;  --  also known as register s0 or X8
      S1 : Cpu_Register_Type;  --  also known as register X9
      A0 : Cpu_Register_Type;  --  also known as register X10
      A1 : Cpu_Register_Type;  --  also known as register X11
      A2 : Cpu_Register_Type;  --  also known as register X12
      A3 : Cpu_Register_Type;  --  also known as register X13
      A4 : Cpu_Register_Type;  --  also known as register X14
      A5 : Cpu_Register_Type;  --  also known as register X15
      A6 : Cpu_Register_Type;  --  also known as register X16
      A7 : Cpu_Register_Type;  --  also known as register X17
      S2 : Cpu_Register_Type;  --  also known as register X18
      S3 : Cpu_Register_Type;  --  also known as register X19
      S4 : Cpu_Register_Type;  --  also known as register X20
      S5 : Cpu_Register_Type;  --  also known as register X21
      S6 : Cpu_Register_Type;  --  also known as register X22
      S7 : Cpu_Register_Type;  --  also known as register X23
      S8 : Cpu_Register_Type;  --  also known as register X24
      S9 : Cpu_Register_Type;  --  also known as register X25
      S10 : Cpu_Register_Type;  --  also known as register X26
      S11 : Cpu_Register_Type;  --  also known as register X27
      T3 : Cpu_Register_Type;  --  also known as register X28
      T4 : Cpu_Register_Type;  --  also known as register X29
      T5 : Cpu_Register_Type;  --  also known as register X30
      T6 : Cpu_Register_Type;  --  also known as register X31
      MEPC : Cpu_Register_Type;
      MSTATUS : MSTATUS_Type;
      MSCRATCH : Cpu_Register_Type;
   end record
      with Convention => C;

   for Cpu_Context_Type use record
      RA  at 16#04# range 0 .. 31;
      SP  at 16#08# range 0 .. 31;
      GP  at 16#0c# range 0 .. 31;
      TP  at 16#10# range 0 .. 31;
      T0  at 16#14# range 0 .. 31;
      T1  at 16#18# range 0 .. 31;
      T2  at 16#1c# range 0 .. 31;
      FP  at 16#20# range 0 .. 31;
      S1  at 16#24# range 0 .. 31;
      A0  at 16#28# range 0 .. 31;
      A1  at 16#2c# range 0 .. 31;
      A2  at 16#30# range 0 .. 31;
      A3  at 16#34# range 0 .. 31;
      A4  at 16#38# range 0 .. 31;
      A5  at 16#3c# range 0 .. 31;
      A6  at 16#40# range 0 .. 31;
      A7  at 16#44# range 0 .. 31;
      S2  at 16#48# range 0 .. 31;
      S3  at 16#4c# range 0 .. 31;
      S4  at 16#50# range 0 .. 31;
      S5  at 16#54# range 0 .. 31;
      S6  at 16#58# range 0 .. 31;
      S7  at 16#5c# range 0 .. 31;
      S8  at 16#60# range 0 .. 31;
      S9  at 16#64# range 0 .. 31;
      S10 at 16#68# range 0 .. 31;
      S11 at 16#6c# range 0 .. 31;
      T3  at 16#70# range 0 .. 31;
      T4  at 16#74# range 0 .. 31;
      T5  at 16#78# range 0 .. 31;
      T6  at 16#7c# range 0 .. 31;
      MEPC at 16#80# range 0 .. 31;
      MSTATUS at 16#84# range 0 .. 31;
      MSCRATCH at 16#88# range 0 .. 31;
   end record;

   function Get_Saved_PC (Cpu_Context : Cpu_Context_Type) return System.Address is
      (System.Storage_Elements.To_Address (
         System.Storage_Elements.Integer_Address (Cpu_Context.MEPC)));

   function Get_Saved_CPSR (Cpu_Context : Cpu_Context_Type) return Cpu_Register_Type is
      (Cpu_Context.MSTATUS.Value);

end HiRTOS_Cpu_Arch_Interface.Thread_Context;
