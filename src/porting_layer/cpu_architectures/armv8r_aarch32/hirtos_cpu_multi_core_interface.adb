--
--  Copyright (c) 2022, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
--

--
--  @summary HiRTOS multi-core CPU interface for ARMv8-R architecture
--

with System.Machine_Code;

package body HiRTOS_Cpu_Multi_Core_Interface is

   MPIDR_Core_Id_Mask : constant := 2#1111_1111#;

   function Get_Cpu_Id return Valid_Cpu_Core_Id_Type is
      use type Interfaces.Unsigned_32;
      Reg_Value : Interfaces.Unsigned_32;
   begin
      System.Machine_Code.Asm (
         "mrc p15, 0, %0, c0, c0, 5",   -- read MPIDR
         Outputs => Interfaces.Unsigned_32'Asm_Output ("=r", Reg_Value), --  %0
         Volatile => True);

      Reg_Value := @ and MPIDR_Core_Id_Mask;
      return Valid_Cpu_Core_Id_Type (Reg_Value);
   end Get_Cpu_Id;

end HiRTOS_Cpu_Multi_Core_Interface;
