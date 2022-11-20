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
--  @summary HiRTOS multi-core CPU interface
--

with HiRTOS_Platform_Parameters;
with Interfaces;

package HiRTOS_Cpu_Multi_Core_Interface
   with SPARK_Mode => On,
        No_Elaboration_Code_All
is
   --
   --  Ids of CPU cores
   --
   --  NOTE: +1 to allow for an invalid CPU Id
   --
   type Cpu_Core_Id_Type is mod HiRTOS_Platform_Parameters.Num_Cpu_Cores + 1
     with Size => Interfaces.Unsigned_8'Size;

   subtype Valid_Cpu_Core_Id_Type is
     Cpu_Core_Id_Type range Cpu_Core_Id_Type'First .. Cpu_Core_Id_Type'Last - 1;

   Invalid_Cpu_Core_Id : constant Cpu_Core_Id_Type := Cpu_Core_Id_Type'Last;

   function Get_Cpu_Id return Valid_Cpu_Core_Id_Type
      with Inline_Always,
           Suppress => All_Checks;

end HiRTOS_Cpu_Multi_Core_Interface;
