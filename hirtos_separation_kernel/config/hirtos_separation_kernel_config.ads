--  Configuration for hirtos_separation_kernel generated by Alire
pragma Restrictions (No_Elaboration_Code);
pragma Style_Checks (Off);

package Hirtos_Separation_Kernel_Config is
   pragma Pure;

   Crate_Version : constant String := "2.0.0";
   Crate_Name : constant String := "hirtos_separation_kernel";

   Alire_Host_OS : constant String := "linux";

   Alire_Host_Arch : constant String := "x86_64";

   Alire_Host_Distro : constant String := "ubuntu";

   type Platform_Kind is (arm_fvp);
   Platform : constant Platform_Kind := arm_fvp;

   type Build_Profile_Kind is (release, validation, development);
   Build_Profile : constant Build_Profile_Kind := development;

   Separation_Kernel_Debug_Tracing_On : constant Boolean := False;

end Hirtos_Separation_Kernel_Config;
