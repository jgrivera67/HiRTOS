--  Configuration for hirtos generated by Alire
pragma Restrictions (No_Elaboration_Code);
pragma Style_Checks (Off);

package Hirtos_Config is
   pragma Pure;

   Crate_Version : constant String := "1.0.0";
   Crate_Name : constant String := "hirtos";

   Alire_Host_OS : constant String := "linux";

   Alire_Host_Arch : constant String := "x86_64";

   Alire_Host_Distro : constant String := "ubuntu";

   type Build_Profile_Kind is (release, validation, development);
   Build_Profile : constant Build_Profile_Kind := development;

   type Platform_Kind is (arm_fvp, esp32_c3);
   Platform : constant Platform_Kind := esp32_c3;

end Hirtos_Config;
