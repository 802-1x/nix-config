{
  self,
  ...
}:

{
  imports = with self.nixosModules; [
    # This was not source controlled - make sure to move any required
    # values across to flake if adopted
    # ./hardware-configuration.nix

    defaults
    hardening
    gnome-hyper-v
  ];

  # Use the GRUB 2 boot loader
  boot.loader.grub.enable = true;
  # Define on which hard drive you want to install Grub
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "work";
  networking.wireless.enable = true;

  # Never delete or modify this value unless you have thoroughly understood man configuration.nix
  system.stateVersion = "24.11";
}
