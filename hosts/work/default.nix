{ config, lib, pkgs, ... }:

{
  imports = 
    [
      ./hardware-configuration.nix
      ./common/locale.nix
      ./common/current-system-packages.nix
      ./modules/gnome-hyper-v/default.nix
      ./hardening/baseline.nix
    ];

  # Use the GRUB 2 boot loader
  boot.loader.grub.enable = true;
  # Define on which hard drive you want to install Grub
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "work";
  networking.wireless.enable = true;

  system.stateVersion = "24.11";
}
