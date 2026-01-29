--
--  Copyright (c) 2025, German Rivera
--
--
--  SPDX-License-Identifier: Apache-2.0
--

--
--  @summary RTOS to target platform interface - ARM Cortex-M system registers
--

with Bit_Sized_Integer_Types;
with HiRTOS_Platform_Parameters;
with Interfaces;

package HiRTOS_Cpu_Arch_Interface.System_Registers
   with SPARK_Mode => On
is
   use Bit_Sized_Integer_Types;

   type Mpu_Enable_Type is (Mpu_Disabled, Mpu_Enabled)
      with Size => 1;

   for Mpu_Enable_Type use
     (Mpu_Disabled => 2#0#,
      Mpu_Enabled => 2#1#);

   type Alignment_Check_Enable_Type is (Alignment_Check_Disabled,
                                        Alignment_Check_Enabled)
   with Size => 1;

   for Alignment_Check_Enable_Type use
     (Alignment_Check_Disabled => 2#0#,
      Alignment_Check_Enabled => 2#1#);

   type Background_Region_Enable_Type is
      (Background_Region_Disabled,
       Background_Region_Enabled)
   with Size => 1;

   for Background_Region_Enable_Type use
     (Background_Region_Disabled => 2#0#,
      Background_Region_Enabled => 2#1#);

   -----------------------------------------------------------------------------
   --  SysTick registers block
   -----------------------------------------------------------------------------

   type SysTick_CTLR_Type is record
      ENABLE : Bit_Type;
      TICKINT : Bit_Type;
      CLKSOURCE : Bit_Type;
      COUNTFLAG : Bit_Type;
   end record
     with Volatile_Full_Access,
          Size => 32,
          Bit_Order => System.Low_Order_First;

   for SysTick_CTLR_Type use record
      ENABLE         at 0 range 0 .. 0;
      TICKINT        at 0 range 1 .. 1;
      CLKSOURCE      at 0 range 2 .. 2;
      COUNTFLAG      at 0 range 16 .. 16;
   end record;

   type SysTick_LOAD_Type is record
      RELOAD : Twenty_Four_Bits_Type;
      Reserved : Interfaces.Unsigned_8;
   end record
     with Volatile_Full_Access,
          Size => 32,
          Bit_Order => System.Low_Order_First;

   for SysTick_LOAD_Type use record
      RELOAD at 0 range 0 .. 23;
      Reserved at 0 range 24 .. 31;
   end record;

   type SysTick_VAL_Type is record
      CURRENT : Twenty_Four_Bits_Type;
      Reserved : Interfaces.Unsigned_8;
   end record
     with Volatile_Full_Access,
          Size => 32,
          Bit_Order => System.Low_Order_First;

   for SysTick_VAL_Type use record
      CURRENT at 0 range 0 .. 23;
      Reserved at 0 range 24 .. 31;
   end record;

   type SysTick_CALIB_Type is record
      TENMS : Twenty_Four_Bits_Type := 0;
      SKEW : Bit_Type := 0;
      NOREF : Bit_Type := 0;
   end record
     with Volatile_Full_Access,
          Size => 32,
          Bit_Order => System.Low_Order_First;

   for SysTick_CALIB_Type use record
      TENMS          at 0 range 0 .. 23;
      SKEW           at 0 range 30 .. 30;
      NOREF          at 0 range 31 .. 31;
   end record;

   type SysTick_Type is limited record
      CTLR : SysTick_CTLR_Type; --  SysTick Control and Status Register
      LOAD : SysTick_LOAD_Type; --  SysTick Reload Value Register
      VAL : SysTick_VAL_Type;   --  SysTick Current Value Register
      CALIB : SysTick_CALIB_Type; --  SysTick Calibration Register
   end record;

   for SysTick_Type use record
      CTLR at 16#0# range 0 .. 31;
      LOAD at 16#4# range 0 .. 31;
      VAL  at 16#8# range 0 .. 31;
      CALIB at 16#C# range 0 .. 31;
   end record;

   -----------------------------------------------------------------------------
   --  NVIC registers block
   -----------------------------------------------------------------------------

   Num_Supported_Interrupts : constant := HiRTOS_Platform_Parameters.Num_External_Interrupts;

   pragma Compile_Time_Error (Num_Supported_Interrupts mod Interfaces.Unsigned_32'Size /= 0,
     "Number of supported interrupts must be a multiple of 32");

   type NVIC_Bit_Array_Index_Type is mod Interfaces.Unsigned_32'Size;

   type NVIC_Bit_Array_Type is array (NVIC_Bit_Array_Index_Type) of Bit_Type
      with Component_Size => 1, Size => 32, Volatile_Full_Access;

   Num_NVIC_Bit_Array_Registers : constant Positive :=
      Num_Supported_Interrupts / Interfaces.Unsigned_32'Size;

   type NVIC_Bit_Array_Array_Index_Type is mod Num_NVIC_Bit_Array_Registers;

   type NVIC_Bit_Array_Array_Type is
      array (NVIC_Bit_Array_Array_Index_Type) of NVIC_Bit_Array_Type;

   type Encoded_Interrupt_Priority_Type is new Interfaces.Unsigned_8
      with Size => 8;

   Num_NVIC_Priority_Register_Slots : constant Positive :=
      Interfaces.Unsigned_32'Size / Encoded_Interrupt_Priority_Type'Size;

   type NVIC_Priority_Slot_Array_Index_Type is mod Num_NVIC_Priority_Register_Slots;

   type NVIC_Priority_Slot_Array_Type is array (NVIC_Priority_Slot_Array_Index_Type) of Encoded_Interrupt_Priority_Type
      with Component_Size => 8, size => 32, Volatile_Full_Access;

   Num_NVIC_Priority_Registers : constant Positive :=
      Num_Supported_Interrupts / NVIC_Priority_Slot_Array_Type'Length;

   type NVIC_Priority_Slot_Array_Array_Index_Type is mod Num_NVIC_Priority_Registers;

   type NVIC_Priority_Slot_Array_Array_Type is
      array (NVIC_Priority_Slot_Array_Array_Index_Type) of NVIC_Priority_Slot_Array_Type;

   NVIC_Type_Size_In_Bits : constant Integer_Address :=
      16#300# * System.Storage_Unit + 32 * Integer_Address (Num_NVIC_Priority_Registers);

   type NVIC_Type is limited record
      ISER : NVIC_Bit_Array_Array_Type; --  Interrupt Set-Enable Register
      ICER : NVIC_Bit_Array_Array_Type; --  Interrupt Clear-Enable Register
      ISPR : NVIC_Bit_Array_Array_Type; --  Interrupt Set-Pending Register
      ICPR : NVIC_Bit_Array_Array_Type; --  Interrupt Clear-Pending Register
      IABR : NVIC_Bit_Array_Array_Type; --  Interrupt Active Bit Register
      IP : NVIC_Priority_Slot_Array_Array_Type;  --  Interrupt Priority Registers
   end record with Size => NVIC_Type_Size_In_Bits;

   for NVIC_Type use record
      ISER      at 16#000# range 0 .. 32 * Num_NVIC_Bit_Array_Registers - 1;
      ICER      at 16#080# range 0 .. 32 * Num_NVIC_Bit_Array_Registers - 1;
      ISPR      at 16#100# range 0 .. 32 * Num_NVIC_Bit_Array_Registers - 1;
      ICPR      at 16#180# range 0 .. 32 * Num_NVIC_Bit_Array_Registers - 1;
      IABR      at 16#200# range 0 .. 32 * Num_NVIC_Bit_Array_Registers - 1;
      IP        at 16#300# range 0 .. 32 * Num_NVIC_Priority_Registers - 1;
   end record;

   -----------------------------------------------------------------------------
   --  SCB registers block
   -----------------------------------------------------------------------------

   --  CPUID base register
   type CPUID_Type is record
      Revision : Four_Bits_Type;
      Part_Number : Twelve_Bits_Type;
      Architecture : Four_Bits_Type;
      Variant : Four_Bits_Type;
      Implementer : Byte_Type;
   end record with Size => 32,
                   Bit_Order => System.Low_Order_First,
                   Volatile_Full_Access;

   for CPUID_Type use
      record
         Revision at 0 range 0 .. 3;
         Part_Number at 0 range 4 .. 15;
         Architecture at 0 range 16 .. 19;
         Variant at 0 range 20 .. 23;
         Implementer at 0 range 24 .. 31;
      end record;

   --  ICSR - Interrupt Control and State Register
   type ICSR_Type is record
      VECTACTIVE : Nine_Bits_Type := 0;
      VECTPENDING : Nine_Bits_Type := 0;
      ISRPENDING : Bit_Type := 0;
      ISRPREEMPT : Bit_Type := 0;
      PENDSTCLR : Bit_Type := 0;
      PENDSTSET : Bit_Type := 0;
      PENDSVCLR : Bit_Type := 0;
      PENDSVSET : Bit_Type := 0;
      NMIPENDSET : Bit_Type := 0;
   end record with Size => 32,
                   Bit_Order => System.Low_Order_First,
                   Volatile_Full_Access;

   for ICSR_Type use record
      VECTACTIVE at 0 range 0 .. 8;
      VECTPENDING at 0 range 12 .. 21;
      ISRPENDING at 0 range 22 .. 22;
      ISRPREEMPT at 0 range 23 .. 23;
      PENDSTCLR at 0 range 25 .. 25;
      PENDSTSET at 0 range 26 .. 26;
      PENDSVCLR at 0 range 27 .. 27;
      PENDSVSET at 0 range 28 .. 28;
      NMIPENDSET at 0 range 31 .. 31;
   end record;

   --  AIRCR - Application Interrupt and Reset Control Register
   type AIRCR_Type is record
      VECTCLRACTIVE : Bit_Type;
      SYSRESETREQ : Bit_Type;
      ENDIANESS : Bit_Type;
      VECTKEY : Half_Word_Type;
   end record with Size => 32,
                   Bit_Order => System.Low_Order_First,
                   Volatile_Full_Access;

   for AIRCR_Type use record
         VECTCLRACTIVE at 0 range 1 .. 1;
         SYSRESETREQ at 0 range 2 .. 2;
         ENDIANESS at 0 range 15 .. 15;
         VECTKEY at 0 range 16 .. 31;
   end record;

   type SHPR3_Type is record
      PendSV_Priority : Encoded_Interrupt_Priority_Type;
      SysTick_Priority : Encoded_Interrupt_Priority_Type;
   end record with Size => 32,
                   Bit_Order => System.Low_Order_First,
                   Volatile_Full_Access;

   for SHPR3_Type use record
      PendSV_Priority at 0 range 16 .. 23;
      SysTick_Priority at 0 range 24 .. 31;
   end record;

   SCB_Type_Size_In_Bits : constant Integer_Address := 16#40# * System.Storage_Unit;

   --
   --  SCB registers
   --
   type SCB_Type is limited record
      CPUID : CPUID_Type;
      ICSR : ICSR_Type;
      VTOR : Word_Type;
      AIRCR : AIRCR_Type;
      SCR : Word_Type;
      CCR : Word_Type;
      SHPR3 : SHPR3_Type;
      SHCSR : Word_Type; --  System Handler Control and State Register
      CFSR : Word_Type; --  Configurable Fault Status Register
      HFSR : Word_Type; --  HardFault Fault Status Register
      DFSR : Word_Type; --  Debug Fault Status Register
      MMFAR : Word_Type; --  MemManage Fault Address Register
      BFAR : Word_Type; --  Bus Fault Address Register
      AFSR : Word_Type; --  Auxiliary Fault Status Register
   end record with Size => SCB_Type_Size_In_Bits;

   for SCB_Type use record
      CPUID at 16#000# range 0 .. 31;
      ICSR at 16#004# range 0 .. 31;
      VTOR at 16#008# range 0 .. 31;
      AIRCR at 16#00C# range 0 .. 31;
      SCR at 16#010# range 0 .. 31;
      CCR at 16#014# range 0 .. 31;
      SHPR3 at 16#020# range 0 .. 31;
      SHCSR at 16#024# range 0 .. 31;
      CFSR  at 16#028# range 0 .. 31;
      HFSR  at 16#02C# range 0 .. 31;
      DFSR  at 16#030# range 0 .. 31;
      MMFAR at 16#034# range 0 .. 31;
      BFAR at 16#038# range 0 .. 31;
      AFSR at 16#03C# range 0 .. 31;
   end record;

   -----------------------------------------------------------------------------
   --  MPU registers block
   -----------------------------------------------------------------------------

   --  MPU type register
   type MPU_TYPE_Register_Type is record
      --  Separate regions for data and instructions (not supported in ARMv7-M)
      SEPARATE_Flag : Bit_Type := 0; --  RAZ

      --  Number of regions supported by the MPU. If RAZ, the MPU is not
      --  supported.
      DREGION_Num : Byte_Type;

      --  Number separate regions for instructions (not supported by ARMv7-M)
      IREGION_Num : Byte_Type := 0; --  RAZ
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MPU_TYPE_Register_Type use record
      SEPARATE_Flag at 0 range 0 .. 0;
      DREGION_Num   at 0 range 8 .. 15;
      IREGION_Num   at 0 range 16 .. 23;
   end record;

   --  MPU control register
   type MPU_CTRL_Register_Type is record
      --  When set, the MPU is enabled.
      ENABLE : Bit_Type := 0;

      --  When set along with the ENABLE bit, the MPU is enabled for
      --  HardFault, NMI, and exception handlers with FAULTMASK
      HFNMIENA : Bit_Type := 0;

      --  When the bit is set along with the ENABLE bit, the Default
      --  memory map is enabled as a background region for privileged
      --  access. The background region acts as though it were region
      --  number -1. MPU configured regions will override (take
      --  priority over) the default memory map. When the bit is clear, the
      --  default map is disabled. Instruction or data accesses not covered by
      --  a region will fault.
      PRIVDEFENA :  Bit_Type := 0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MPU_CTRL_Register_Type use record
      ENABLE  at 0 range 0 .. 0;
      HFNMIENA at 0 range 1 .. 1;
      PRIVDEFENA at 0 range 2 .. 2;
   end record;

   --  MPU Region Number Register
   type MPU_RNR_Register_Type is record
      --  Region selector index
      REGION : Byte_Type := 0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MPU_RNR_Register_Type use record
      REGION   at 0 range 0 .. 7;
   end record;

   --  MPU Region Base Address Register
   type MPU_RBAR_Register_Type is record
      --  Region selector index.
      REGION : Four_Bits_Type := 0;

      --  is zero extended and copied into the MPU_RNR.
      VALID : Bit_Type := 0;

      --  Most significant 27 bits of the region's base address. The least
      --  significant bits of the address are always 0, as the minimum
      --  alignment is 32 bytes.
      ADDR : Twenty_Seven_Bits_Type;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MPU_RBAR_Register_Type use record
      REGION  at 0 range 0 .. 3;
      VALID   at 0 range 4 .. 4;
      ADDR    at 0 range 5 .. 31;
   end record;

   --  Privileged and unprivileged read/write permissions
   type Read_Write_Permissions_Type is
     (No_Access,
      Privileged_Read_Write_Unprivileged_No_Access,
      Privileged_Read_Write_Unprivileged_Read_Only,
      Privileged_Read_Write_Unprivileged_Read_Write,
      Reserved,
      Privileged_Read_Only_Unprivileged_No_Access,
      Privileged_Read_Only_Unprivileged_Read_Only) with Size => 3;

   for Read_Write_Permissions_Type use
     (No_Access => 2#000#,
      Privileged_Read_Write_Unprivileged_No_Access => 2#001#,
      Privileged_Read_Write_Unprivileged_Read_Only => 2#010#,
      Privileged_Read_Write_Unprivileged_Read_Write => 2#011#,
      Reserved => 2#100#,
      Privileged_Read_Only_Unprivileged_No_Access => 2#101#,
      Privileged_Read_Only_Unprivileged_Read_Only => 2#110#);

   type Region_Attributes_Type is record
      B : Bit_Type := 0;
      C : Bit_Type := 0;
      S : Bit_Type := 0;
      TEX : Three_Bits_Type := 0;
      AP : Read_Write_Permissions_Type := No_Access;
      XN : Bit_Type := 0; --  eXecute Never (no instruction fetches allowed)
   end record
     with Size => 16,
          Bit_Order => System.Low_Order_First;

   for Region_Attributes_Type use record
      B  at 0 range 0 .. 0;
      C  at 0 range 1 .. 1;
      S  at 0 range 2 .. 2;
      TEX at 0 range 3 .. 5;
      AP  at 0 range 8 .. 10;
      XN  at 0 range 12 .. 12;
   end record;

   type  Encoded_Region_Size_Type is range 4 .. 31 with Size => 5;

   type Subregion_Index_Type is range 0 .. 7;

   type Subregions_Disabled_Mask_Type is array (Subregion_Index_Type) of Bit_Type
      with Component_Size => 1, Size => System.Storage_Unit;

   --  MPU Region Attribute and Size Register
   type MPU_RASR_Register_Type is record
      --  When set, the associated region is enabled within the MPU. The
      --  global MPU enable bit must also be set for it to take effect.
      ENABLE : Bit_Type := 0;

      --  Region size encoded as a power of 2 (log base 2 of size) - 1
      SIZE : Encoded_Region_Size_Type := Encoded_Region_Size_Type'First;

      --  Subregion disabled bits
      SRD : Subregions_Disabled_Mask_Type := [others => 0];

      ATTRS : Region_Attributes_Type;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MPU_RASR_Register_Type use record
      ENABLE  at 0 range 0 .. 0;
      SIZE    at 0 range 1 .. 5;
      SRD     at 0 range 8 .. 15;
      ATTRS   at 0 range 16 .. 31;
   end record;

   MPU_Type_Size_In_Bits : constant Integer_Address := 16#14# * System.Storage_Unit;

   --
   --  Standard ARMv7-M MPU registers
   --
   type MPU_Type is limited record
      MPU_TYPE : MPU_TYPE_Register_Type;
      MPU_CTRL : MPU_CTRL_Register_Type;
      MPU_RNR : MPU_RNR_Register_Type;
      MPU_RBAR : MPU_RBAR_Register_Type;
      MPU_RASR : MPU_RASR_Register_Type;
   end record with Size => MPU_Type_Size_In_Bits;

   for MPU_Type use record
      MPU_TYPE at 16#000# range 0 .. 31;
      MPU_CTRL at 16#004# range 0 .. 31;
      MPU_RNR at 16#008# range 0 .. 31;
      MPU_RBAR at 16#00C# range 0 .. 31;
      MPU_RASR at 16#010# range 0 .. 31;
   end record;

   -----------------------------------------------------------------------------
   --  System control registers block
   -----------------------------------------------------------------------------

   type SCS_Type is limited record
      SysTick : SysTick_Type;
      NVIC : NVIC_Type;
      SCB : SCB_Type;
      MPU : MPU_Type;
   end record;

   for SCS_Type use record
      SysTick at 16#0010# range 0 .. 4 * 32 - 1;
      NVIC    at 16#0100# range 0 .. NVIC_Type_Size_In_Bits - 1;
      SCB     at 16#0D00# range 0 .. SCB_Type_Size_In_Bits - 1;
      MPU     at 16#0D90# range 0 .. MPU_Type_Size_In_Bits - 1;
   end record;

   SCS : SCS_Type with
     Import, Address => System'To_Address (16#E000E000#);

end HiRTOS_Cpu_Arch_Interface.System_Registers;
