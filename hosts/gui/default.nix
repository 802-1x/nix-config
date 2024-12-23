{ config, lib, pkgs, ... }:

{
  imports = 
    [
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "test";
  networking.wireless.enable = true;

  system.stateVersion = "24.11";

  networking.networkmanager.enable = false;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  boot.kernelParams = [ "nouveau.modeset=0" ];

  nixpkgs.config.allowUnfree = true;
  hardware.nvidia.open = true;

}
