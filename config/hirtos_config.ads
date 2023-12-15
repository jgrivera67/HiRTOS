--  Configuration for hirtos generated by Alire
pragma Restrictions (No_Elaboration_Code);
pragma Style_Checks (Off);

package Hirtos_Config is
   pragma Pure;

   Crate_Version : constant String := "0.1.0";
   Crate_Name : constant String := "hirtos";

   Alire_Host_OS : constant String := "linux";

   Alire_Host_Arch : constant String := "x86_64";

   Alire_Host_Distro : constant String := "ubuntu";

   Separation_Kernel_Debug_Tracing_On : constant Boolean := False;

   type Build_Profile_Kind is (release, validation, development);
   Build_Profile : constant Build_Profile_Kind := development;

end Hirtos_Config;
