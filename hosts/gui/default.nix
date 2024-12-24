{ config, lib, pkgs, ... }:

{
  imports = 
    [
      ./hardware-configuration.nix
      ./common/locale.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "test";
  networking.wireless.enable = true;
  networking.networkmanager.enable = false;

  system.stateVersion = "24.11";

  networking.networkmanager.enable = false;

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    modules = [ pkgs.xorg.xf86videofbdev ];
    #videoDrivers = [ "hyperv_fb" "modesetting" "nvida" ];
  };

  boot.kernelParams = [ "nouveau.modeset=0" ];

  nixpkgs.config.allowUnfree = true;
  hardware.nvidia.open = true;

  users.groups.gdm = {};
  users.users.gdm = {
    isSystemUser = true;
    group = "gdm";
    extraGroups = [ "video" ];
  };

  users.users.gui = {
    isNormalUser = true;
    home = "/home/gui";
    description = "test";
    extraGroups = [ "wheel" "networkmanager" "tty" "input" "audio" "video" ];
  };
}
